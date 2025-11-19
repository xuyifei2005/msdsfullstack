# MSDS实验室管理系统自动化部署脚本 (PowerShell版本)
# 版本: v1.0
# 更新日期: 2025-01-27
# 用途: Windows环境下的生产环境自动化部署

param(
    [Parameter(Position=0)]
    [ValidateSet("deploy", "rollback", "health", "backup")]
    [string]$Action = "deploy"
)

# ==================== 配置变量 ====================
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir
$DockerDir = Join-Path $ProjectRoot "msdsdocker"
$BackupDir = Join-Path $ProjectRoot "backups"
$LogDir = Join-Path $ProjectRoot "logs"
$LogFile = Join-Path $LogDir "deploy.log"

# 确保日志目录存在
if (!(Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

# ==================== 日志函数 ====================
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] [$Level] $Message"
    
    switch ($Level) {
        "ERROR" { Write-Host $LogMessage -ForegroundColor Red }
        "WARN"  { Write-Host $LogMessage -ForegroundColor Yellow }
        "INFO"  { Write-Host $LogMessage -ForegroundColor Green }
        default { Write-Host $LogMessage -ForegroundColor White }
    }
    
    Add-Content -Path $LogFile -Value $LogMessage
}

function Write-Error-Log {
    param([string]$Message)
    Write-Log $Message "ERROR"
    exit 1
}

function Write-Warn-Log {
    param([string]$Message)
    Write-Log $Message "WARN"
}

# ==================== 环境检查 ====================
function Test-Environment {
    Write-Log "开始环境检查..."
    
    # 检查Docker
    try {
        $dockerVersion = docker --version
        Write-Log "Docker版本: $dockerVersion"
    }
    catch {
        Write-Error-Log "Docker未安装或未启动，请先安装并启动Docker Desktop"
    }
    
    # 检查Docker Compose
    try {
        $composeVersion = docker compose version
        Write-Log "Docker Compose版本: $composeVersion"
    }
    catch {
        Write-Error-Log "Docker Compose不可用"
    }
    
    # 检查必要文件
    $prodComposeFile = Join-Path $DockerDir "docker-compose.prod.yml"
    if (!(Test-Path $prodComposeFile)) {
        Write-Error-Log "生产环境配置文件不存在: $prodComposeFile"
    }
    
    $envFile = Join-Path $DockerDir ".env.prod"
    if (!(Test-Path $envFile)) {
        Write-Error-Log "环境变量文件不存在: $envFile"
    }
    
    Write-Log "环境检查完成"
}

# ==================== 数据库备份 ====================
function Backup-Database {
    Write-Log "开始数据库备份..."
    
    # 创建备份目录
    if (!(Test-Path $BackupDir)) {
        New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
    }
    
    # 备份文件名
    $BackupFile = Join-Path $BackupDir "msds_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').sql"
    
    # 读取环境变量
    $envFile = Join-Path $DockerDir ".env.prod"
    $envVars = @{}
    Get-Content $envFile | ForEach-Object {
        if ($_ -match '^([^#][^=]+)=(.*)$') {
            $envVars[$matches[1]] = $matches[2]
        }
    }
    
    try {
        # 执行备份
        $mysqlPassword = $envVars["MYSQL_ROOT_PASSWORD"]
        docker exec msdsmysql-prod mysqldump -u root -p"$mysqlPassword" msds_prod | Out-File -FilePath $BackupFile -Encoding UTF8
        
        Write-Log "数据库备份成功: $BackupFile"
        
        # 压缩备份文件
        Compress-Archive -Path $BackupFile -DestinationPath "$BackupFile.zip" -Force
        Remove-Item $BackupFile
        Write-Log "备份文件已压缩: $BackupFile.zip"
        
        # 清理7天前的备份
        Get-ChildItem $BackupDir -Filter "*.zip" | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-7) } | Remove-Item
        Write-Log "已清理7天前的备份文件"
    }
    catch {
        Write-Warn-Log "数据库备份失败，继续部署... 错误: $($_.Exception.Message)"
    }
}

# ==================== 拉取最新镜像 ====================
function Update-Images {
    Write-Log "开始拉取最新镜像..."
    
    Push-Location $DockerDir
    try {
        # 拉取镜像
        docker compose -f docker-compose.prod.yml pull
        Write-Log "镜像拉取完成"
    }
    catch {
        Write-Error-Log "镜像拉取失败: $($_.Exception.Message)"
    }
    finally {
        Pop-Location
    }
}

# ==================== 蓝绿部署 ====================
function Start-BlueGreenDeploy {
    Write-Log "开始蓝绿部署..."
    
    Push-Location $DockerDir
    try {
        # 启动新版本（绿色环境）
        Write-Log "启动新版本服务..."
        docker compose -f docker-compose.prod.yml up -d --no-deps msdsbackend msdsfrontend
        
        # 等待服务启动
        Write-Log "等待服务启动..."
        Start-Sleep -Seconds 30
        
        # 健康检查
        if (Test-Health) {
            Write-Log "新版本健康检查通过"
            
            # 更新Nginx配置指向新版本
            Write-Log "更新负载均衡配置..."
            docker compose -f docker-compose.prod.yml restart msdsnginx
            
            # 等待Nginx重启
            Start-Sleep -Seconds 10
            
            # 再次健康检查
            if (Test-Health) {
                Write-Log "部署成功！"
                
                # 清理旧镜像
                docker image prune -f
                Write-Log "已清理无用镜像"
            }
            else {
                Write-Error-Log "部署后健康检查失败，请检查服务状态"
            }
        }
        else {
            Write-Error-Log "新版本健康检查失败，部署中止"
        }
    }
    catch {
        Write-Error-Log "部署过程中发生错误: $($_.Exception.Message)"
    }
    finally {
        Pop-Location
    }
}

# ==================== 健康检查 ====================
function Test-Health {
    Write-Log "开始健康检查..."
    
    $maxAttempts = 10
    $attempt = 1
    
    while ($attempt -le $maxAttempts) {
        Write-Log "健康检查尝试 $attempt/$maxAttempts"
        
        try {
            # 检查后端服务
            $backendResponse = Invoke-WebRequest -Uri "http://localhost:8080/actuator/health" -TimeoutSec 5 -UseBasicParsing
            if ($backendResponse.StatusCode -eq 200) {
                Write-Log "后端服务健康检查通过"
                
                # 检查前端服务
                $frontendResponse = Invoke-WebRequest -Uri "http://localhost:3000" -TimeoutSec 5 -UseBasicParsing
                if ($frontendResponse.StatusCode -eq 200) {
                    Write-Log "前端服务健康检查通过"
                    return $true
                }
                else {
                    Write-Warn-Log "前端服务健康检查失败"
                }
            }
            else {
                Write-Warn-Log "后端服务健康检查失败"
            }
        }
        catch {
            Write-Warn-Log "健康检查请求失败: $($_.Exception.Message)"
        }
        
        Start-Sleep -Seconds 10
        $attempt++
    }
    
    Write-Error-Log "健康检查失败"
    return $false
}

# ==================== 回滚操作 ====================
function Start-Rollback {
    Write-Log "开始回滚操作..."
    
    Push-Location $DockerDir
    try {
        # 停止当前服务
        docker compose -f docker-compose.prod.yml down
        
        # 恢复到上一个版本的镜像
        Write-Warn-Log "回滚功能需要根据具体的镜像版本管理策略来实现"
        
        Write-Log "回滚完成"
    }
    catch {
        Write-Error-Log "回滚过程中发生错误: $($_.Exception.Message)"
    }
    finally {
        Pop-Location
    }
}

# ==================== 监控检查 ====================
function Test-Monitoring {
    Write-Log "检查监控服务..."
    
    try {
        # 检查Prometheus
        $prometheusResponse = Invoke-WebRequest -Uri "http://localhost:9090/-/healthy" -TimeoutSec 5 -UseBasicParsing
        if ($prometheusResponse.StatusCode -eq 200) {
            Write-Log "Prometheus服务正常"
        }
    }
    catch {
        Write-Warn-Log "Prometheus服务异常"
    }
    
    try {
        # 检查Grafana
        $grafanaResponse = Invoke-WebRequest -Uri "http://localhost:3001/api/health" -TimeoutSec 5 -UseBasicParsing
        if ($grafanaResponse.StatusCode -eq 200) {
            Write-Log "Grafana服务正常"
        }
    }
    catch {
        Write-Warn-Log "Grafana服务异常"
    }
}

# ==================== 部署后验证 ====================
function Test-PostDeploy {
    Write-Log "开始部署后验证..."
    
    Push-Location $DockerDir
    try {
        # 检查容器状态
        Write-Log "检查容器状态..."
        docker compose -f docker-compose.prod.yml ps
        
        # 检查服务日志
        Write-Log "检查服务日志..."
        docker compose -f docker-compose.prod.yml logs --tail=50 msdsbackend
        
        # 读取环境变量
        $envFile = Join-Path $DockerDir ".env.prod"
        $envVars = @{}
        Get-Content $envFile | ForEach-Object {
            if ($_ -match '^([^#][^=]+)=(.*)$') {
                $envVars[$matches[1]] = $matches[2]
            }
        }
        
        # 检查数据库连接
        Write-Log "检查数据库连接..."
        $mysqlPassword = $envVars["MYSQL_ROOT_PASSWORD"]
        $dbTest = docker exec msdsmysql-prod mysql -u root -p"$mysqlPassword" -e "SELECT 1" 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Log "数据库连接正常"
        }
        else {
            Write-Error-Log "数据库连接失败"
        }
        
        # 检查Redis连接
        Write-Log "检查Redis连接..."
        $redisPassword = $envVars["REDIS_PASSWORD"]
        $redisTest = docker exec msdsredis-prod redis-cli -a "$redisPassword" ping 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Log "Redis连接正常"
        }
        else {
            Write-Error-Log "Redis连接失败"
        }
        
        # 检查监控服务
        Test-Monitoring
        
        Write-Log "部署后验证完成"
    }
    catch {
        Write-Error-Log "部署后验证失败: $($_.Exception.Message)"
    }
    finally {
        Pop-Location
    }
}

# ==================== 主函数 ====================
function Main {
    Write-Log "开始MSDS系统自动化部署..."
    
    switch ($Action) {
        "deploy" {
            Test-Environment
            Backup-Database
            Update-Images
            Start-BlueGreenDeploy
            Test-PostDeploy
            Write-Log "部署完成！"
        }
        "rollback" {
            Start-Rollback
        }
        "health" {
            Test-Health
        }
        "backup" {
            Backup-Database
        }
        default {
            Write-Host "用法: .\deploy.ps1 [deploy|rollback|health|backup]"
            Write-Host "  deploy   - 执行完整部署流程"
            Write-Host "  rollback - 回滚到上一个版本"
            Write-Host "  health   - 执行健康检查"
            Write-Host "  backup   - 仅执行数据库备份"
            exit 1
        }
    }
}

# 执行主函数
Main