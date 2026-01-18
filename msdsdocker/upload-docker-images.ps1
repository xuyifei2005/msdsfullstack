# 上传Docker镜像到服务器（Windows PowerShell）

# 配置
$ServerHost = "39.107.211.72"
$ServerUser = "root"
$ServerDir = "/opt/msds/msdsdocker/images"
$LocalDir = ".\docker-images"

Write-Host "=== 上传Docker镜像到服务器 ===" -ForegroundColor Green
Write-Host ""

# 检查本地镜像目录
if (-not (Test-Path $LocalDir)) {
    Write-Host "错误：本地镜像目录不存在: $LocalDir" -ForegroundColor Red
    Write-Host "请先运行 .\export-docker-images.ps1 导出镜像" -ForegroundColor Yellow
    exit 1
}

# 获取所有tar文件
$tarFiles = Get-ChildItem -Path $LocalDir -Filter "*.tar"

if ($tarFiles.Count -eq 0) {
    Write-Host "错误：没有找到任何tar文件" -ForegroundColor Red
    exit 1
}

Write-Host "找到 $($tarFiles.Count) 个镜像文件：" -ForegroundColor Cyan
$tarFiles | ForEach-Object {
    $size = [math]::Round($_.Length / 1MB, 2)
    Write-Host "  $($_.Name) - $size MB" -ForegroundColor White
}
Write-Host ""

# 询问确认
$confirm = Read-Host "是否继续上传？(y/n)"
if ($confirm -ne "y" -and $confirm -ne "Y") {
    Write-Host "上传已取消" -ForegroundColor Yellow
    exit 0
}

Write-Host ""

# 创建服务器目录
Write-Host "创建服务器目录..." -ForegroundColor Cyan
$createDirCmd = "mkdir -p $ServerDir"
ssh $ServerUser@$ServerHost $createDirCmd
Write-Host "✅ 服务器目录创建完成" -ForegroundColor Green
Write-Host ""

# 上传镜像文件
Write-Host "上传镜像文件到服务器..." -ForegroundColor Cyan
Write-Host "这可能需要较长时间，请耐心等待..." -ForegroundColor Yellow
Write-Host ""

foreach ($file in $tarFiles) {
    $size = [math]::Round($file.Length / 1MB, 2)
    Write-Host "上传 $($file.Name) ($size MB)..." -ForegroundColor Yellow
    
    scp $file.FullName "$ServerUser@$ServerHost`:$ServerDir/"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ $($file.Name) 上传完成" -ForegroundColor Green
    } else {
        Write-Host "❌ $($file.Name) 上传失败" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "=== 上传完成 ===" -ForegroundColor Green
Write-Host ""

# 在服务器上加载镜像
Write-Host "在服务器上加载Docker镜像..." -ForegroundColor Cyan
$loadCmd = @"
cd $ServerDir
for image in *.tar; do
    if [ -f "`$image" ]; then
        echo "加载镜像: `$image"
        docker load -i "`$image"
    fi
done

echo ""
echo "=== 验证镜像 ==="
docker images | grep -E "msdsnginx|msdsbackend|msdsmysql|msdsredis"
"@

ssh $ServerUser@$ServerHost $loadCmd

Write-Host ""
Write-Host "=== 所有步骤完成！ ===" -ForegroundColor Green
Write-Host ""
Write-Host "现在可以运行以下命令启动服务：" -ForegroundColor Cyan
Write-Host "  ssh $ServerUser@$ServerHost"
Write-Host "  cd /opt/msds/msdsdocker"
Write-Host "  docker-compose -f docker-compose.prod.yml up -d"
Write-Host ""
