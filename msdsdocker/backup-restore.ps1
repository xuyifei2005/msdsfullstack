# MSDS系统备份恢复脚本
# 版本: v1.0
# 作者: MSDS运维团队

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("backup", "restore", "list")]
    [string]$Action,
    
    [string]$BackupFile = "",
    [string]$BackupDir = ".\backups"
)

# 创建备份目录
if (!(Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir -Force
    Write-Host "创建备份目录: $BackupDir" -ForegroundColor Green
}

# 获取当前时间戳
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

function Backup-Database {
    Write-Host "开始备份MySQL数据库..." -ForegroundColor Yellow
    
    $backupFile = "$BackupDir\mysql_backup_$timestamp.sql"
    
    try {
        # 检查MySQL容器是否运行
        $mysqlStatus = docker ps --filter "name=msdsmysql" --format "{{.Status}}"
        if (!$mysqlStatus) {
            Write-Host "错误: MySQL容器未运行" -ForegroundColor Red
            return $false
        }
        
        # 执行数据库备份
        docker exec msdsmysql mysqldump -u msds_user -pmsds_dev_password msds_dev > $backupFile
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "MySQL备份成功: $backupFile" -ForegroundColor Green
            return $true
        } else {
            Write-Host "MySQL备份失败" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "备份过程中发生错误: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

function Backup-Redis {
    Write-Host "开始备份Redis数据..." -ForegroundColor Yellow
    
    $backupFile = "$BackupDir\redis_backup_$timestamp.rdb"
    
    try {
        # 检查Redis容器是否运行
        $redisStatus = docker ps --filter "name=msdsredis" --format "{{.Status}}"
        if (!$redisStatus) {
            Write-Host "错误: Redis容器未运行" -ForegroundColor Red
            return $false
        }
        
        # 触发Redis保存
        docker exec msdsredis redis-cli BGSAVE
        Start-Sleep -Seconds 2
        
        # 复制备份文件
        docker cp msdsredis:/data/dump.rdb $backupFile
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Redis备份成功: $backupFile" -ForegroundColor Green
            return $true
        } else {
            Write-Host "Redis备份失败" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "备份过程中发生错误: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

function Restore-Database {
    param([string]$RestoreFile)
    
    if (!(Test-Path $RestoreFile)) {
        Write-Host "错误: 备份文件不存在: $RestoreFile" -ForegroundColor Red
        return $false
    }
    
    Write-Host "开始恢复MySQL数据库..." -ForegroundColor Yellow
    Write-Host "备份文件: $RestoreFile" -ForegroundColor Cyan
    
    # 确认操作
    $confirm = Read-Host "这将覆盖现有数据库，是否继续? (y/N)"
    if ($confirm -ne "y" -and $confirm -ne "Y") {
        Write-Host "操作已取消" -ForegroundColor Yellow
        return $false
    }
    
    try {
        # 检查MySQL容器是否运行
        $mysqlStatus = docker ps --filter "name=msdsmysql" --format "{{.Status}}"
        if (!$mysqlStatus) {
            Write-Host "错误: MySQL容器未运行" -ForegroundColor Red
            return $false
        }
        
        # 执行数据库恢复
        Get-Content $RestoreFile | docker exec -i msdsmysql mysql -u msds_user -pmsds_dev_password msds_dev
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "MySQL恢复成功" -ForegroundColor Green
            return $true
        } else {
            Write-Host "MySQL恢复失败" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "恢复过程中发生错误: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

function Restore-Redis {
    param([string]$RestoreFile)
    
    if (!(Test-Path $RestoreFile)) {
        Write-Host "错误: 备份文件不存在: $RestoreFile" -ForegroundColor Red
        return $false
    }
    
    Write-Host "开始恢复Redis数据..." -ForegroundColor Yellow
    Write-Host "备份文件: $RestoreFile" -ForegroundColor Cyan
    
    # 确认操作
    $confirm = Read-Host "这将覆盖现有Redis数据，是否继续? (y/N)"
    if ($confirm -ne "y" -and $confirm -ne "Y") {
        Write-Host "操作已取消" -ForegroundColor Yellow
        return $false
    }
    
    try {
        # 检查Redis容器是否运行
        $redisStatus = docker ps --filter "name=msdsredis" --format "{{.Status}}"
        if (!$redisStatus) {
            Write-Host "错误: Redis容器未运行" -ForegroundColor Red
            return $false
        }
        
        # 停止Redis服务
        Write-Host "停止Redis服务..." -ForegroundColor Yellow
        docker exec msdsredis redis-cli SHUTDOWN NOSAVE
        Start-Sleep -Seconds 2
        
        # 复制备份文件
        docker cp $RestoreFile msdsredis:/data/dump.rdb
        
        # 重启Redis容器
        Write-Host "重启Redis容器..." -ForegroundColor Yellow
        docker restart msdsredis
        Start-Sleep -Seconds 5
        
        # 验证Redis状态
        $pingResult = docker exec msdsredis redis-cli ping
        if ($pingResult -eq "PONG") {
            Write-Host "Redis恢复成功" -ForegroundColor Green
            return $true
        } else {
            Write-Host "Redis恢复失败" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "恢复过程中发生错误: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

function List-Backups {
    Write-Host "备份文件列表:" -ForegroundColor Cyan
    Write-Host "备份目录: $BackupDir" -ForegroundColor Gray
    Write-Host ""
    
    if (!(Test-Path $BackupDir)) {
        Write-Host "备份目录不存在" -ForegroundColor Yellow
        return
    }
    
    $backupFiles = Get-ChildItem -Path $BackupDir -Filter "*.sql", "*.rdb" | Sort-Object LastWriteTime -Descending
    
    if ($backupFiles.Count -eq 0) {
        Write-Host "没有找到备份文件" -ForegroundColor Yellow
        return
    }
    
    Write-Host "MySQL备份文件:" -ForegroundColor Green
    $backupFiles | Where-Object { $_.Extension -eq ".sql" } | ForEach-Object {
        $size = [math]::Round($_.Length / 1MB, 2)
        Write-Host "  $($_.Name) ($size MB) - $($_.LastWriteTime)" -ForegroundColor White
    }
    
    Write-Host ""
    Write-Host "Redis备份文件:" -ForegroundColor Green
    $backupFiles | Where-Object { $_.Extension -eq ".rdb" } | ForEach-Object {
        $size = [math]::Round($_.Length / 1MB, 2)
        Write-Host "  $($_.Name) ($size MB) - $($_.LastWriteTime)" -ForegroundColor White
    }
}

# 主逻辑
switch ($Action) {
    "backup" {
        Write-Host "=== MSDS系统备份开始 ===" -ForegroundColor Cyan
        Write-Host "时间戳: $timestamp" -ForegroundColor Gray
        Write-Host ""
        
        $mysqlSuccess = Backup-Database
        $redisSuccess = Backup-Redis
        
        Write-Host ""
        Write-Host "=== 备份完成 ===" -ForegroundColor Cyan
        if ($mysqlSuccess -and $redisSuccess) {
            Write-Host "所有备份操作成功完成" -ForegroundColor Green
        } else {
            Write-Host "部分备份操作失败，请检查日志" -ForegroundColor Yellow
        }
    }
    
    "restore" {
        if (!$BackupFile) {
            Write-Host "错误: 请指定备份文件路径" -ForegroundColor Red
            Write-Host "用法: .\backup-restore.ps1 -Action restore -BackupFile 'path\to\backup.sql'" -ForegroundColor Yellow
            return
        }
        
        Write-Host "=== MSDS系统恢复开始 ===" -ForegroundColor Cyan
        Write-Host ""
        
        $fileExtension = [System.IO.Path]::GetExtension($BackupFile)
        
        switch ($fileExtension) {
            ".sql" {
                $success = Restore-Database -RestoreFile $BackupFile
            }
            ".rdb" {
                $success = Restore-Redis -RestoreFile $BackupFile
            }
            default {
                Write-Host "错误: 不支持的文件类型: $fileExtension" -ForegroundColor Red
                Write-Host "支持的文件类型: .sql (MySQL), .rdb (Redis)" -ForegroundColor Yellow
                return
            }
        }
        
        Write-Host ""
        Write-Host "=== 恢复完成 ===" -ForegroundColor Cyan
        if ($success) {
            Write-Host "恢复操作成功完成" -ForegroundColor Green
        } else {
            Write-Host "恢复操作失败" -ForegroundColor Red
        }
    }
    
    "list" {
        List-Backups
    }
}

Write-Host ""
Write-Host "脚本执行完成" -ForegroundColor Gray