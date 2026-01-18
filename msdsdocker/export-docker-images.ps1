# 导出Docker镜像为tar文件（Windows PowerShell）

Write-Host "=== 导出Docker镜像 ===" -ForegroundColor Green
Write-Host ""

# 创建导出目录
$exportDir = "docker-images"
if (-not (Test-Path $exportDir)) {
    New-Item -ItemType Directory -Path $exportDir -Force | Out-Null
}
Set-Location $exportDir

Write-Host "导出镜像..." -ForegroundColor Cyan
Write-Host ""

# 导出MySQL镜像
$mysqlExists = docker images msdsmysql -q
if ($mysqlExists) {
    Write-Host "导出 msdsmysql..." -ForegroundColor Yellow
    docker save msdsmysql -o msdsmysql.tar
    Write-Host "✅ msdsmysql.tar" -ForegroundColor Green
} else {
    Write-Host "⚠️  msdsmysql镜像不存在，跳过" -ForegroundColor Yellow
}

# 导出Redis镜像
$redisExists = docker images msdsredis -q
if ($redisExists) {
    Write-Host "导出 msdsredis..." -ForegroundColor Yellow
    docker save msdsredis -o msdsredis.tar
    Write-Host "✅ msdsredis.tar" -ForegroundColor Green
} else {
    Write-Host "⚠️  msdsredis镜像不存在，跳过" -ForegroundColor Yellow
}

# 导出后端镜像
$backendExists = docker images msdsbackend -q
if ($backendExists) {
    Write-Host "导出 msdsbackend..." -ForegroundColor Yellow
    docker save msdsbackend -o msdsbackend.tar
    Write-Host "✅ msdsbackend.tar" -ForegroundColor Green
} else {
    Write-Host "⚠️  msdsbackend镜像不存在，跳过" -ForegroundColor Yellow
}

# 导出Nginx镜像
$nginxExists = docker images msdsnginx -q
if ($nginxExists) {
    Write-Host "导出 msdsnginx..." -ForegroundColor Yellow
    docker save msdsnginx -o msdsnginx.tar
    Write-Host "✅ msdsnginx.tar" -ForegroundColor Green
} else {
    Write-Host "⚠️  msdsnginx镜像不存在，跳过" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== 导出完成 ===" -ForegroundColor Green
Write-Host ""

# 显示文件大小
Write-Host "导出的文件：" -ForegroundColor Cyan
Get-ChildItem -Filter "*.tar" | ForEach-Object {
    $size = [math]::Round($_.Length / 1MB, 2)
    Write-Host "  $($_.Name) - $size MB" -ForegroundColor White
}

Write-Host ""

# 计算总大小
$totalSize = (Get-ChildItem -Filter "*.tar" | Measure-Object -Property Length -Sum).Sum
if ($totalSize) {
    $totalSizeMB = [math]::Round($totalSize / 1MB, 2)
    Write-Host "总大小: $totalSizeMB MB" -ForegroundColor Cyan
}
Write-Host ""
