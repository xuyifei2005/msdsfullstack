# MSDS系统生产环境自动化部署脚本 (PowerShell版本)
# 适用于Windows服务器
# 版本: 1.0.1 - 修复版本

param(
    [switch]$SkipBackup,
    [switch]$SkipBuild,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# 配置
$ProjectName = "MSDS管理系统"
$ComposeFile = "docker-compose.prod.yml"
$EnvFile = ".env.prod"

# 颜色输出函数
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Type = "INFO"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    switch ($Type) {
        "INFO"    { Write-Host "[$Type] $timestamp - $Message" -ForegroundColor Green }
        "WARN"    { Write-Host "[$Type] $timestamp - $Message" -ForegroundColor Yellow }
        "ERROR"   { Write-Host "[$Type] $timestamp - $Message" -ForegroundColor Red }
        "STEP"    { Write-Host "[$Type] $timestamp - $Message" -ForegroundColor Blue }
        default   { Write-Host "[$Type] $timestamp - $Message" }
    }
}

# 显示Banner
function Show-Banner {
    Clear-Host
    Write-Host ""
    Write-Host "========================================================" -ForegroundColor Green
    Write-Host "                                                        " -ForegroundColor Green
    Write-Host "          MSDS系统生产环境部署脚本 v1.0.1               " -ForegroundColor Green
    Write-Host "                                                        " -ForegroundColor Green
    Write-Host "          服务器: 39.107.211.72                         " -ForegroundColor Green
    Write-Host "          域名: flymsds.cn                              " -ForegroundColor Green
    Write-Host "                                                        " -ForegroundColor Green
    Write-Host "========================================================" -ForegroundColor Green
    Write-Host ""
}

# 检查系统要求
function Test-Requirements {
    Write-ColorOutput "检查系统要求..." "STEP"
    
    # 检查Docker
    try {
        $dockerVersion = docker --version
        Write-ColorOutput "✓ Docker已安装: $dockerVersion" "INFO"
    } catch {
        Write-ColorOutput "Docker未安装，请先安装Docker Desktop" "ERROR"
        exit 1
    }
    
    # 检查Docker Compose
    try {
        $composeVersion = docker-compose --version
        Write-ColorOutput "✓ Docker Compose已安装: $composeVersion" "INFO"
    } catch {
        Write-ColorOutput "Docker Compose未安装" "ERROR"
        exit 1
    }
    
    Write-ColorOutput "系统要求检查完成" "INFO"
}

# 检查环境变量配置
function Test-EnvConfig {
    Write-ColorOutput "检查环境变量配置..." "STEP"
    
    if (-not (Test-Path $EnvFile)) {
        Write-ColorOutput "未找到环境变量配置文件: $EnvFile" "ERROR"
        Write-ColorOutput "请从 env.prod.example 复制并修改配置" "INFO"
        exit 1
    }
    
    # 检查是否还在使用默认密码
    $envContent = Get-Content $EnvFile -Raw
    if ($envContent -match "CHANGE_ME") {
        Write-ColorOutput "请修改 $EnvFile 中的默认密码！" "ERROR"
        exit 1
    }
    
    Write-ColorOutput "环境变量配置检查通过" "INFO"
}

# 检查SSL证书
function Test-SSLCertificates {
    Write-ColorOutput "检查SSL证书..." "STEP"
    
    $certFile = "./nginx/ssl/flymsds.cn.pem"
    $keyFile = "./nginx/ssl/flymsds.cn.key"
    
    if (-not (Test-Path $certFile) -or -not (Test-Path $keyFile)) {
        Write-ColorOutput "未找到SSL证书文件" "WARN"
        Write-ColorOutput "请将证书文件放置到: ./nginx/ssl/" "WARN"
        Write-ColorOutput "  - flymsds.cn.pem" "WARN"
        Write-ColorOutput "  - flymsds.cn.key" "WARN"
        
        if (-not $Force) {
            $continue = Read-Host "是否继续部署（将使用HTTP）? [y/N]"
            if ($continue -ne "y" -and $continue -ne "Y") {
                exit 1
            }
        }
    } else {
        Write-ColorOutput "✓ SSL证书文件已就绪" "INFO"
    }
}

# 备份数据库
function Backup-Database {
    Write-ColorOutput "备份生产数据库..." "STEP"
    
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupDir = "../msds-backup"
    $backupFile = "$backupDir/mysql_backup_$timestamp.sql"
    
    # 创建备份目录
    if (-not (Test-Path $backupDir)) {
        New-Item -ItemType Directory -Path $backupDir | Out-Null
    }
    
    # 检查是否有运行中的MySQL容器
    $runningContainers = docker ps --filter "name=msdsmysql-prod" --format "{{.Names}}"
    
    if ($runningContainers -match "msdsmysql-prod") {
        Write-ColorOutput "开始备份数据库..." "INFO"
        
        # 读取环境变量
        $envVars = @{}
        Get-Content $EnvFile | ForEach-Object {
            $line = $_.Trim()
            if ($line -and -not $line.StartsWith("#")) {
                if ($line -match "^(.+?)=(.+)$") {
                    $key = $matches[1].Trim()
                    $value = $matches[2].Trim()
                    $envVars[$key] = $value
                }
            }
        }
        
        $mysqlPassword = $envVars["MYSQL_ROOT_PASSWORD"]
        
        # 执行备份
        docker exec msdsmysql-prod mysqldump `
            -u root `
            -p"$mysqlPassword" `
            --all-databases `
            --single-transaction `
            --quick `
            --lock-tables=false | Out-File -FilePath $backupFile -Encoding utf8
        
        if ($LASTEXITCODE -eq 0) {
            # 压缩备份文件
            Compress-Archive -Path $backupFile -DestinationPath "$backupFile.zip" -Force
            Remove-Item $backupFile
            Write-ColorOutput "数据库备份完成: $backupFile.zip" "INFO"
            
            # 删除30天前的备份
            Get-ChildItem -Path $backupDir -Filter "mysql_backup_*.zip" | 
                Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } | 
                Remove-Item
            Write-ColorOutput "已清理30天前的旧备份" "INFO"
        } else {
            Write-ColorOutput "数据库备份失败" "ERROR"
            exit 1
        }
    } else {
        Write-ColorOutput "未找到运行中的MySQL容器，跳过备份" "WARN"
    }
}

# 构建前端
function Build-Frontend {
    Write-ColorOutput "构建前端应用..." "STEP"
    
    $frontendPath = "../msdsPC/ruoyi-MsdsPc-react/react-ui"
    
    if (Test-Path $frontendPath) {
        Push-Location $frontendPath
        
        try {
            Write-ColorOutput "安装前端依赖..." "INFO"
            npm install --production
            
            Write-ColorOutput "执行生产环境构建..." "INFO"
            npm run build:prod
            
            Write-ColorOutput "复制构建产物..." "INFO"
            $targetPath = "../../../msdsdocker/nginx/html/"
            if (Test-Path $targetPath) {
                Remove-Item -Path "$targetPath*" -Recurse -Force -ErrorAction SilentlyContinue
            }
            Copy-Item -Path "dist/*" -Destination $targetPath -Recurse -Force
            
            Write-ColorOutput "前端构建完成" "INFO"
        } catch {
            Write-ColorOutput "前端构建失败: $_" "ERROR"
            Pop-Location
            exit 1
        } finally {
            Pop-Location
        }
    } else {
        Write-ColorOutput "未找到前端项目目录: $frontendPath" "ERROR"
        exit 1
    }
}

# 构建后端
function Build-Backend {
    Write-ColorOutput "构建后端应用..." "STEP"
    
    $backendPath = "../msdsPC/ruoyi-MsdsPc-react"
    
    if (Test-Path $backendPath) {
        Push-Location $backendPath
        
        try {
            Write-ColorOutput "执行Maven打包..." "INFO"
            mvn clean package -Pprod -DskipTests
            
            if ($LASTEXITCODE -eq 0) {
                Write-ColorOutput "后端构建完成" "INFO"
            } else {
                Write-ColorOutput "后端构建失败" "ERROR"
                Pop-Location
                exit 1
            }
        } finally {
            Pop-Location
        }
    } else {
        Write-ColorOutput "未找到后端项目目录: $backendPath" "ERROR"
        exit 1
    }
}

# 停止旧容器
function Stop-OldContainers {
    Write-ColorOutput "停止旧容器..." "STEP"
    
    $runningContainers = docker-compose -f $ComposeFile ps -q
    
    if ($runningContainers) {
        docker-compose -f $ComposeFile down
        Write-ColorOutput "旧容器已停止" "INFO"
    } else {
        Write-ColorOutput "没有运行中的容器" "INFO"
    }
}

# 启动新容器
function Start-NewContainers {
    Write-ColorOutput "启动新容器..." "STEP"
    
    docker-compose -f $ComposeFile --env-file $EnvFile up -d --build
    
    Write-ColorOutput "容器启动完成" "INFO"
}

# 健康检查
function Test-Health {
    Write-ColorOutput "执行健康检查..." "STEP"
    
    $maxRetries = 30
    $retry = 0
    
    while ($retry -lt $maxRetries) {
        try {
            $response = docker exec msdsbackend-prod curl -f http://localhost:8080/actuator/health 2>$null
            if ($LASTEXITCODE -eq 0) {
                Write-ColorOutput "✓ 后端服务健康检查通过" "INFO"
                break
            }
        } catch {
            # 继续重试
        }
        
        $retry++
        Write-ColorOutput "等待服务启动... ($retry/$maxRetries)" "WARN"
        Start-Sleep -Seconds 10
    }
    
    if ($retry -eq $maxRetries) {
        Write-ColorOutput "后端服务健康检查失败" "ERROR"
        Write-ColorOutput "查看日志: docker logs msdsbackend-prod" "ERROR"
        exit 1
    }
    
    # 检查其他服务
    try {
        docker exec msdsnginx-prod wget --quiet --tries=1 --spider http://localhost/ 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput "✓ Nginx服务健康检查通过" "INFO"
        }
    } catch {
        Write-ColorOutput "Nginx服务健康检查失败" "WARN"
    }
}

# 显示部署信息
function Show-DeploymentInfo {
    Write-Host ""
    Write-Host "========================================================" -ForegroundColor Green
    Write-Host "                                                        " -ForegroundColor Green
    Write-Host "              🎉 部署成功！系统已启动                    " -ForegroundColor Green
    Write-Host "                                                        " -ForegroundColor Green
    Write-Host "========================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "访问地址:" -ForegroundColor Blue
    Write-Host "  • HTTPS: " -NoNewline -ForegroundColor Blue
    Write-Host "https://flymsds.cn" -ForegroundColor Green
    Write-Host "  • HTTP:  " -NoNewline -ForegroundColor Blue
    Write-Host "http://39.107.211.72" -ForegroundColor Green
    Write-Host ""
    Write-Host "服务状态:" -ForegroundColor Blue
    docker-compose -f $ComposeFile ps
    Write-Host ""
}

# 主函数
function Main {
    Show-Banner
    
    Write-ColorOutput "开始部署 $ProjectName..." "INFO"
    
    Test-Requirements
    Test-EnvConfig
    Test-SSLCertificates
    
    # 备份数据库
    if (-not $SkipBackup) {
        $doBackup = Read-Host "是否备份现有数据库? [Y/n]"
        if ($doBackup -ne "n" -and $doBackup -ne "N") {
            Backup-Database
        }
    }
    
    # 重新构建
    if (-not $SkipBuild) {
        $doBuild = Read-Host "是否重新构建前后端? [Y/n]"
        if ($doBuild -ne "n" -and $doBuild -ne "N") {
            Build-Frontend
            Build-Backend
        }
    }
    
    Stop-OldContainers
    Start-NewContainers
    Test-Health
    
    Show-DeploymentInfo
    
    Write-ColorOutput "部署流程完成！" "INFO"
}

# 执行主函数
try {
    Main
} catch {
    Write-ColorOutput "部署过程中发生错误: $_" "ERROR"
    Write-Host $_.ScriptStackTrace -ForegroundColor Red
    exit 1
}

