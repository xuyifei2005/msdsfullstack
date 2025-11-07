# ============================================================
# 重新编译前端脚本
# 用途：修改前端代码后，快速重新编译和部署
# ============================================================

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "   MSDS前端重新编译脚本" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# 1. 进入前端容器并编译
Write-Host "[1/4] 开始编译前端..." -ForegroundColor Yellow
docker exec -it msdsfrontend bash -c "cd /app && rm -rf dist && npm run build"

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ 前端编译失败！" -ForegroundColor Red
    exit 1
}

Write-Host "✅ 前端编译成功" -ForegroundColor Green
Write-Host ""

# 2. 重启前端服务
Write-Host "[2/4] 重启前端服务..." -ForegroundColor Yellow
docker-compose restart msdsfrontend

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ 前端重启失败！" -ForegroundColor Red
    exit 1
}

Write-Host "✅ 前端服务已重启" -ForegroundColor Green
Write-Host ""

# 3. 等待服务启动
Write-Host "[3/4] 等待前端服务启动（约30秒）..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# 4. 检查服务状态
Write-Host "[4/4] 检查服务状态..." -ForegroundColor Yellow
docker-compose ps msdsfrontend

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "   完成！" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📝 接下来的操作：" -ForegroundColor Cyan
Write-Host "   1. 访问: http://localhost:8000/intelligent-search" -ForegroundColor White
Write-Host "   2. 清除浏览器缓存（Ctrl + F5）" -ForegroundColor White
Write-Host "   3. 选择'普通搜索'，输入：吡啶" -ForegroundColor White
Write-Host "   4. 按F12查看Console输出" -ForegroundColor White
Write-Host ""
Write-Host "🔍 如果搜索类型不对（显示cas而不是general）：" -ForegroundColor Yellow
Write-Host "   - 使用无痕模式：Ctrl + Shift + N" -ForegroundColor White
Write-Host "   - 或清空浏览器所有缓存" -ForegroundColor White
Write-Host ""

