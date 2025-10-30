# MSDS系统网络诊断脚本
Write-Host "=== MSDS系统网络诊断 ===" -ForegroundColor Green

# 1. 检查Docker服务
Write-Host "1. Docker服务状态..." -ForegroundColor Cyan
docker version --format "Docker版本: {{.Server.Version}}"

# 2. 检查容器状态
Write-Host "2. 容器状态..." -ForegroundColor Cyan
docker ps --filter "name=msds" --format "table {{.Names}}\t{{.Status}}"

# 3. 检查端口映射
Write-Host "3. 端口映射..." -ForegroundColor Cyan
Write-Host "前端容器端口:"
docker port msdsfrontend
Write-Host "后端容器端口:"
docker port msdsbackend
Write-Host "Nginx容器端口:"
docker port msdsnginx

# 4. 检查容器IP
Write-Host "4. 容器IP地址..." -ForegroundColor Cyan
$frontendIP = docker inspect msdsfrontend --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
$backendIP = docker inspect msdsbackend --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
$nginxIP = docker inspect msdsnginx --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'

Write-Host "前端IP: $frontendIP"
Write-Host "后端IP: $backendIP"
Write-Host "Nginx IP: $nginxIP"

# 5. 测试容器内部服务
Write-Host "5. 测试容器内部服务..." -ForegroundColor Cyan
Write-Host "测试前端容器内部端口8000..."
docker exec msdsfrontend curl -s -I http://localhost:8000 | Select-String "HTTP"

Write-Host "测试后端容器内部端口8080..."
docker exec msdsbackend curl -s -I http://localhost:8080 | Select-String "HTTP"

# 6. 检查本地端口
Write-Host "6. 检查本地端口监听..." -ForegroundColor Cyan
$ports = @(180, 8000, 18080)
foreach ($port in $ports) {
    $conn = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
    if ($conn) {
        Write-Host "端口 $port : 监听中" -ForegroundColor Green
    } else {
        Write-Host "端口 $port : 未监听" -ForegroundColor Red
    }
}

# 7. 尝试使用127.0.0.1访问
Write-Host "7. 测试127.0.0.1访问..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://127.0.0.1:180/health" -UseBasicParsing -TimeoutSec 5
    Write-Host "Nginx健康检查(127.0.0.1): $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "Nginx健康检查(127.0.0.1): 失败" -ForegroundColor Red
}

Write-Host "=== 诊断完成 ===" -ForegroundColor Green