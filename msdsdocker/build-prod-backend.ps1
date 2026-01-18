# MSDS后端生产环境镜像构建脚本
# 使用多阶段构建，大幅减小镜像大小

Write-Host "=== MSDS后端生产环境镜像构建 ===" -ForegroundColor Green
Write-Host ""

# 配置信息
$PROJECT_DIR = "..\msdsPC\ruoyi-MsdsPc-react"
$DOCKERFILE = "$PROJECT_DIR\Dockerfile.prod"
$IMAGE_NAME = "msdsbackend:prod"
$IMAGE_NAME_LATEST = "msdsbackend:latest"

# 检查Dockerfile是否存在
if (-not (Test-Path $DOCKERFILE)) {
    Write-Host "❌ Dockerfile.prod 不存在: $DOCKERFILE" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Dockerfile.prod 找到" -ForegroundColor Green
Write-Host ""

# 进入项目目录
Write-Host "📁 进入项目目录: $PROJECT_DIR" -ForegroundColor Yellow
Set-Location $PROJECT_DIR

# 构建生产环境镜像
Write-Host "🔨 开始构建生产环境镜像..." -ForegroundColor Yellow
Write-Host "这可能需要几分钟，请耐心等待..."
Write-Host ""

docker build -f Dockerfile.prod -t $IMAGE_NAME -t $IMAGE_NAME_LATEST .

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ 生产环境镜像构建成功！" -ForegroundColor Green
    Write-Host ""
    
    # 显示镜像大小
    Write-Host "📊 镜像信息：" -ForegroundColor Yellow
    docker images | findstr msdsbackend
    
    Write-Host ""
    Write-Host "🎯 预期大小：300-500MB（而不是9.08GB）" -ForegroundColor Green
    Write-Host ""
    
    # 询问是否删除旧镜像
    $oldImage = docker images --format "{{.ID}}" msds_exported_backend
    if ($oldImage) {
        Write-Host "⚠️  检测到旧的msds_exported_backend镜像" -ForegroundColor Yellow
        $delete = Read-Host "是否删除旧镜像? (y/n)"
        if ($delete -eq "y" -or $delete -eq "Y") {
            docker rmi msds_exported_backend
            Write-Host "✅ 旧镜像已删除" -ForegroundColor Green
        }
    }
    
    Write-Host ""
    Write-Host "🚀 现在可以使用新镜像部署了！" -ForegroundColor Green
    Write-Host ""
    Write-Host "更新docker-compose.prod.yml中的镜像名称：" -ForegroundColor Yellow
    Write-Host "  image: msdsbackend:latest" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "❌ 镜像构建失败！" -ForegroundColor Red
    exit 1
}
