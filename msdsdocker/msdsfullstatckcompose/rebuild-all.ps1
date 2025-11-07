# ============================================================
# 重新编译前后端完整脚本
# 用途：修改代码后，完整重新编译和部署
# ============================================================

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "   MSDS系统完整重新编译脚本" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# 1. 编译后端
Write-Host "[1/6] 开始编译后端（约3-5分钟）..." -ForegroundColor Yellow
docker exec -it msdsbackend bash -c "cd /app && mvn clean package -DskipTests"

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ 后端编译失败！" -ForegroundColor Red
    Write-Host "请检查Java代码是否有错误" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ 后端编译成功" -ForegroundColor Green
Write-Host ""

# 2. 重启后端服务
Write-Host "[2/6] 重启后端服务..." -ForegroundColor Yellow
docker-compose restart msdsbackend

Write-Host "✅ 后端服务已重启" -ForegroundColor Green
Write-Host ""

# 3. 等待后端启动
Write-Host "[3/6] 等待后端服务启动（约1-2分钟）..." -ForegroundColor Yellow
Start-Sleep -Seconds 60

Write-Host "检查后端健康状态..." -ForegroundColor Yellow
$backendHealth = docker logs msdsbackend 2>&1 | Select-String "Started RuoYiApplication"
if ($backendHealth) {
    Write-Host "✅ 后端服务已启动" -ForegroundColor Green
} else {
    Write-Host "⚠️  后端可能还在启动中，请稍后..." -ForegroundColor Yellow
}
Write-Host ""

# 4. 编译前端
Write-Host "[4/6] 开始编译前端（约2-3分钟）..." -ForegroundColor Yellow
docker exec -it msdsfrontend bash -c "cd /app && rm -rf dist && npm run build"

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ 前端编译失败！" -ForegroundColor Red
    Write-Host "请检查React/TypeScript代码是否有错误" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ 前端编译成功" -ForegroundColor Green
Write-Host ""

# 5. 重启前端服务
Write-Host "[5/6] 重启前端服务..." -ForegroundColor Yellow
docker-compose restart msdsfrontend

Write-Host "✅ 前端服务已重启" -ForegroundColor Green
Write-Host ""

# 6. 等待前端启动
Write-Host "[6/6] 等待前端服务启动（约30秒）..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# 检查所有服务状态
Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "   服务状态检查" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
docker-compose ps

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "   编译部署完成！" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "🌐 访问地址：" -ForegroundColor Cyan
Write-Host "   前端页面: http://localhost:8000" -ForegroundColor White
Write-Host "   后端API:  http://localhost:18080" -ForegroundColor White
Write-Host ""
Write-Host "📝 测试智能搜索：" -ForegroundColor Cyan
Write-Host "   1. 访问: http://localhost:8000/intelligent-search" -ForegroundColor White
Write-Host "   2. 清除浏览器缓存（Ctrl + F5）或使用无痕模式" -ForegroundColor White
Write-Host "   3. 确认'普通搜索'标签是蓝色" -ForegroundColor White
Write-Host "   4. 输入搜索关键词：吡啶" -ForegroundColor White
Write-Host "   5. 按F12查看Console确认 searchType: general" -ForegroundColor White
Write-Host ""
Write-Host "🔧 查看日志：" -ForegroundColor Cyan
Write-Host "   后端日志: docker logs -f --tail=100 msdsbackend" -ForegroundColor White
Write-Host "   前端日志: docker logs -f --tail=100 msdsfrontend" -ForegroundColor White
Write-Host ""
Write-Host "⚠️  重要提示：" -ForegroundColor Yellow
Write-Host "   - 化学品名称 → 用'普通搜索'" -ForegroundColor White
Write-Host "   - CAS号(如 54-11-5) → 用'CAS号搜索'" -ForegroundColor White
Write-Host "   - 搜索类型和关键词要匹配！" -ForegroundColor White
Write-Host ""

