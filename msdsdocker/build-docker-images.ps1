# 本地Docker镜像预构建脚本（Windows PowerShell）
# 用于在本地构建和准备所有需要的Docker镜像

Write-Host "=== MSDS Docker镜像预构建脚本 ===" -ForegroundColor Green
Write-Host ""

# 检查Docker是否运行
$dockerRunning = docker info 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "错误：Docker未运行，请先启动Docker Desktop" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Docker正在运行" -ForegroundColor Green
Write-Host ""

# 步骤1: 拉取MySQL镜像
Write-Host "步骤 1/5: 拉取MySQL镜像" -ForegroundColor Cyan
$mysqlExists = docker images msdsmysql -q
if ($mysqlExists) {
    Write-Host "✅ MySQL镜像已存在: msdsmysql" -ForegroundColor Green
} else {
    Write-Host "拉取MySQL 8.0.42镜像..." -ForegroundColor Yellow
    docker pull mysql:8.0.42
    docker tag mysql:8.0.42 msdsmysql
    Write-Host "✅ MySQL镜像准备完成" -ForegroundColor Green
}
Write-Host ""

# 步骤2: 拉取Redis镜像
Write-Host "步骤 2/5: 拉取Redis镜像" -ForegroundColor Cyan
$redisExists = docker images msdsredis -q
if ($redisExists) {
    Write-Host "✅ Redis镜像已存在: msdsredis" -ForegroundColor Green
} else {
    Write-Host "拉取Redis latest镜像..." -ForegroundColor Yellow
    docker pull redis:latest
    docker tag redis:latest msdsredis
    Write-Host "✅ Redis镜像准备完成" -ForegroundColor Green
}
Write-Host ""

# 步骤3: 构建后端Docker镜像
Write-Host "步骤 3/5: 构建后端Docker镜像" -ForegroundColor Cyan
$backendExists = docker images msdsbackend -q
if ($backendExists) {
    Write-Host "✅ 后端镜像已存在: msdsbackend" -ForegroundColor Green
} else {
    Write-Host "构建后端Docker镜像..." -ForegroundColor Yellow
    Push-Location msdsPC\ruoyi-MsdsPc-react
    docker build -f Dockerfile.prod -t msdsbackend:latest .
    docker tag msdsbackend:latest msdsbackend
    Pop-Location
    Write-Host "✅ 后端镜像构建完成" -ForegroundColor Green
}
Write-Host ""

# 步骤4: 构建Nginx前端镜像
Write-Host "步骤 4/5: 构建Nginx前端镜像" -ForegroundColor Cyan
$nginxExists = docker images msdsnginx -q
if ($nginxExists) {
    Write-Host "✅ Nginx镜像已存在: msdsnginx" -ForegroundColor Green
} else {
    Write-Host "构建Nginx前端镜像..." -ForegroundColor Yellow
    Push-Location msdsPC\ruoyi-MsdsPc-react\react-ui
    docker build -f Dockerfile.nginx -t msdsnginx:latest .
    docker tag msdsnginx:latest msdsnginx
    Pop-Location
    Write-Host "✅ Nginx镜像构建完成" -ForegroundColor Green
}
Write-Host ""

# 步骤5: 验证所有镜像
Write-Host "步骤 5/5: 验证所有镜像" -ForegroundColor Cyan
Write-Host ""
Write-Host "已准备的Docker镜像：" -ForegroundColor Cyan
docker images | Select-String "msdsnginx|msdsbackend|msdsmysql|msdsredis"
Write-Host ""

Write-Host "=== 镜像预构建完成！ ===" -ForegroundColor Green
Write-Host ""
Write-Host "下一步操作：" -ForegroundColor Yellow
Write-Host "1. 将镜像导出为tar文件（可选）"
Write-Host "   .\export-docker-images.ps1"
Write-Host ""
Write-Host "2. 上传到服务器（可选）"
Write-Host "   .\upload-docker-images.ps1"
Write-Host ""
Write-Host "3. CI/CD构建时会自动使用这些镜像"
Write-Host ""
