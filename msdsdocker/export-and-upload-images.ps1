# MSDS Docker镜像导出和上传脚本
# 用于将本地Docker镜像导出并上传到服务器

# 配置信息
$SERVER_HOST = "39.107.211.72"
$SERVER_USER = "root"
$SERVER_DIR = "/opt/msds/msdsdocker/images"
$LOCAL_DIR = ".\docker-images"

Write-Host "=== MSDS Docker镜像导出和上传脚本 ===" -ForegroundColor Green
Write-Host ""

# 创建本地临时目录
Write-Host "1. 创建本地临时目录..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path $LOCAL_DIR | Out-Null
Write-Host "✅ 临时目录创建完成: $LOCAL_DIR"
Write-Host ""

# 导出Docker镜像
Write-Host "2. 导出Docker镜像..." -ForegroundColor Yellow
Write-Host "这可能需要几分钟，请耐心等待..."
Write-Host ""

# 导出MySQL镜像
Write-Host "导出 msdsmysql:latest..." -ForegroundColor Yellow
docker save msdsmysql:latest -o "$LOCAL_DIR\msdsmysql.tar"
Write-Host "✅ msdsmysql.tar 导出完成"

# 导出Redis镜像
Write-Host "导出 msdsredis:latest..." -ForegroundColor Yellow
docker save msdsredis:latest -o "$LOCAL_DIR\msdsredis.tar"
Write-Host "✅ msdsredis.tar 导出完成"

# 导出Backend镜像
Write-Host "导出 msdsbackend:latest..." -ForegroundColor Yellow
docker save msdsbackend:latest -o "$LOCAL_DIR\msdsbackend.tar"
Write-Host "✅ msdsbackend.tar 导出完成"

# 导出Nginx镜像
Write-Host "导出 msdsnginx:latest..." -ForegroundColor Yellow
docker save msdsnginx:latest -o "$LOCAL_DIR\msdsnginx.tar"
Write-Host "✅ msdsnginx.tar 导出完成"

Write-Host ""
Write-Host "=== 镜像导出完成 ===" -ForegroundColor Green
Get-ChildItem -Path $LOCAL_DIR | Format-Table Name, Length
Write-Host ""

# 创建服务器目录
Write-Host "3. 创建服务器目录..." -ForegroundColor Yellow
ssh "$SERVER_USER@$SERVER_HOST" "mkdir -p $SERVER_DIR"
Write-Host "✅ 服务器目录创建完成: $SERVER_DIR"
Write-Host ""

# 上传镜像文件
Write-Host "4. 上传镜像文件到服务器..." -ForegroundColor Yellow
Write-Host "这可能需要较长时间，取决于网络速度..."
Write-Host ""

# 上传MySQL镜像
Write-Host "上传 msdsmysql.tar..." -ForegroundColor Yellow
scp "$LOCAL_DIR\msdsmysql.tar" "$SERVER_USER@$SERVER_HOST:$SERVER_DIR/"
Write-Host "✅ msdsmysql.tar 上传完成"

# 上传Redis镜像
Write-Host "上传 msdsredis.tar..." -ForegroundColor Yellow
scp "$LOCAL_DIR\msdsredis.tar" "$SERVER_USER@$SERVER_HOST:$SERVER_DIR/"
Write-Host "✅ msdsredis.tar 上传完成"

# 上传Backend镜像
Write-Host "上传 msdsbackend.tar..." -ForegroundColor Yellow
scp "$LOCAL_DIR\msdsbackend.tar" "$SERVER_USER@$SERVER_HOST:$SERVER_DIR/"
Write-Host "✅ msdsbackend.tar 上传完成"

# 上传Nginx镜像
Write-Host "上传 msdsnginx.tar..." -ForegroundColor Yellow
scp "$LOCAL_DIR\msdsnginx.tar" "$SERVER_USER@$SERVER_HOST:$SERVER_DIR/"
Write-Host "✅ msdsnginx.tar 上传完成"

Write-Host ""
Write-Host "=== 镜像上传完成 ===" -ForegroundColor Green

# 在服务器上加载镜像
Write-Host "5. 在服务器上加载Docker镜像..." -ForegroundColor Yellow
Write-Host ""

$loadImagesCommand = @"
cd /opt/msds/msdsdocker/images

echo "加载 msdsmysql.tar..."
docker load -i msdsmysql.tar
echo "✅ msdsmysql.tar 加载完成"

echo "加载 msdsredis.tar..."
docker load -i msdsredis.tar
echo "✅ msdsredis.tar 加载完成"

echo "加载 msdsbackend.tar..."
docker load -i msdsbackend.tar
echo "✅ msdsbackend.tar 加载完成"

echo "加载 msdsnginx.tar..."
docker load -i msdsnginx.tar
echo "✅ msdsnginx.tar 加载完成"

echo ""
echo "=== 验证镜像 ==="
docker images | grep -E "msdsnginx|msdsbackend|msdsmysql|msdsredis"
"@

ssh "$SERVER_USER@$SERVER_HOST" $loadImagesCommand

Write-Host ""
Write-Host "=== 所有步骤完成！ ===" -ForegroundColor Green
Write-Host ""
Write-Host "现在可以运行以下命令启动服务："
Write-Host "  cd /opt/msds/msdsdocker"
Write-Host "  docker-compose -f docker-compose.prod.yml up -d"
Write-Host ""

# 询问是否删除本地临时文件
$delete = Read-Host "是否删除本地临时文件? (y/n)"
if ($delete -eq "y" -or $delete -eq "Y") {
    Write-Host "删除本地临时文件..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $LOCAL_DIR
    Write-Host "✅ 临时文件删除完成"
}
