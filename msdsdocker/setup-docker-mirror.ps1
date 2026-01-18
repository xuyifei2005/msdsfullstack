# Docker镜像加速器配置脚本（Windows PowerShell）
# 适用于Windows Docker Desktop

Write-Host "=== 配置Docker国内镜像加速器 ===" -ForegroundColor Green
Write-Host ""

# 检查Docker Desktop是否运行
$dockerRunning = docker info 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "错误：Docker未运行，请先启动Docker Desktop" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Docker正在运行" -ForegroundColor Green
Write-Host ""

# Docker Desktop配置文件路径
$configPath = "$env:USERPROFILE\.docker\daemon.json"

# 备份原配置
if (Test-Path $configPath) {
    Write-Host "备份原Docker配置..." -ForegroundColor Yellow
    $backupPath = "$configPath.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Copy-Item $configPath $backupPath
    Write-Host "✅ 备份完成: $backupPath" -ForegroundColor Green
    Write-Host ""
}

# 创建配置目录
$configDir = Split-Path $configPath -Parent
if (-not (Test-Path $configDir)) {
    New-Item -ItemType Directory -Path $configDir -Force | Out-Null
}

# 创建新的Docker配置
Write-Host "配置Docker镜像加速器..." -ForegroundColor Yellow

$config = @{
    "registry-mirrors" = @(
        "https://hub-mirror.c.163.com",
        "https://mirror.ccs.tencentyun.com",
        "https://docker.mirrors.ustc.edu.cn",
        "https://reg-mirror.qiniu.com"
    )
    "max-concurrent-downloads" = 10
    "log-driver" = "json-file"
    "log-level" = "warn"
    "storage-driver" = "overlay2"
}

$configJson = $config | ConvertTo-Json -Depth 10
$configJson | Out-File -FilePath $configPath -Encoding UTF8

Write-Host "✅ 配置文件已创建: $configPath" -ForegroundColor Green
Write-Host ""

# 提示用户重启Docker
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "配置完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "请执行以下操作使配置生效：" -ForegroundColor Cyan
Write-Host "1. 右键点击系统托盘中的Docker图标" -ForegroundColor White
Write-Host "2. 选择 'Restart' 重启Docker Desktop" -ForegroundColor White
Write-Host ""
Write-Host "已配置的镜像加速器：" -ForegroundColor Cyan
Write-Host "  1. 网易镜像: https://hub-mirror.c.163.com" -ForegroundColor White
Write-Host "  2. 腾讯云: https://mirror.ccs.tencentyun.com" -ForegroundColor White
Write-Host "  3. 中科大: https://docker.mirrors.ustc.edu.cn" -ForegroundColor White
Write-Host "  4. 七牛云: https://reg-mirror.qiniu.com" -ForegroundColor White
Write-Host ""
Write-Host "重启后验证配置：" -ForegroundColor Cyan
Write-Host "  docker info | Select-String 'Registry Mirrors'" -ForegroundColor White
Write-Host ""
Write-Host "测试镜像拉取速度：" -ForegroundColor Cyan
Write-Host "  docker pull nginx:alpine" -ForegroundColor White
Write-Host ""
