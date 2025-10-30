# MSDS系统简单性能检查脚本
Write-Host "MSDS Laboratory Management System Performance Check" -ForegroundColor Green
Write-Host "=" * 60

# 检查Docker是否运行
try {
    docker version | Out-Null
    Write-Host "[OK] Docker is running" -ForegroundColor Green
}
catch {
    Write-Host "[ERROR] Docker is not running" -ForegroundColor Red
    exit 1
}

# 检查容器状态
Write-Host "`n=== Container Status ===" -ForegroundColor Yellow
$containers = @("msdsbackend", "msdsfrontend", "msdsmysql", "msdsredis", "msdsnginx")

foreach ($container in $containers) {
    try {
        $status = docker inspect --format='{{.State.Status}}' $container 2>$null
        if ($status -eq "running") {
            Write-Host "[$container] Running" -ForegroundColor Green
        } else {
            Write-Host "[$container] $status" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "[$container] Not found" -ForegroundColor Red
    }
}

# 检查资源使用
Write-Host "`n=== Resource Usage ===" -ForegroundColor Yellow
foreach ($container in $containers) {
    try {
        Write-Host "Checking $container..." -ForegroundColor Cyan
        $stats = docker stats --no-stream --format "table {{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}" $container 2>$null
        if ($stats) {
            Write-Host $stats -ForegroundColor White
        }
    }
    catch {
        Write-Host "Cannot get stats for $container" -ForegroundColor Yellow
    }
}

# 测试服务连接
Write-Host "`n=== Service Connectivity ===" -ForegroundColor Yellow

# 测试前端
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8000" -TimeoutSec 5 -UseBasicParsing 2>$null
    if ($response.StatusCode -eq 200) {
        Write-Host "[OK] Frontend accessible (port 8000)" -ForegroundColor Green
    }
}
catch {
    Write-Host "[WARNING] Frontend not accessible" -ForegroundColor Yellow
}

# 测试后端API
try {
    $response = Invoke-WebRequest -Uri "http://localhost:18080/captchaImage" -TimeoutSec 5 -UseBasicParsing 2>$null
    if ($response.StatusCode -eq 200) {
        Write-Host "[OK] Backend API accessible (port 18080)" -ForegroundColor Green
    }
}
catch {
    Write-Host "[WARNING] Backend API not accessible" -ForegroundColor Yellow
}

# 测试Nginx代理
try {
    $response = Invoke-WebRequest -Uri "http://localhost:180/health" -TimeoutSec 5 -UseBasicParsing 2>$null
    if ($response.StatusCode -eq 200) {
        Write-Host "[OK] Nginx proxy accessible (port 180)" -ForegroundColor Green
    }
}
catch {
    Write-Host "[WARNING] Nginx proxy not accessible" -ForegroundColor Yellow
}

# 测试数据库连接
Write-Host "`n=== Database Connectivity ===" -ForegroundColor Yellow
try {
    $result = docker exec msdsmysql mysql -u msds_user -pmsds_dev_password -e "SELECT 1;" 2>$null
    if ($result) {
        Write-Host "[OK] MySQL database accessible" -ForegroundColor Green
    }
}
catch {
    Write-Host "[WARNING] MySQL database not accessible" -ForegroundColor Yellow
}

# 测试Redis连接
try {
    $result = docker exec msdsredis redis-cli ping 2>$null
    if ($result -eq "PONG") {
        Write-Host "[OK] Redis cache accessible" -ForegroundColor Green
    }
}
catch {
    Write-Host "[WARNING] Redis cache not accessible" -ForegroundColor Yellow
}

# 生成简单报告
$timestamp = Get-Date
$reportPath = "performance-check-$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"

$report = "MSDS System Performance Check Report`n"
$report += "Generated: $timestamp`n"
$report += "=" * 50 + "`n`n"

# 获取容器状态
$report += "Container Status:`n"
foreach ($container in $containers) {
    try {
        $status = docker inspect --format='{{.State.Status}}' $container 2>$null
        $report += "$container : $status`n"
    }
    catch {
        $report += "$container : error`n"
    }
}

$report += "`nSystem Recommendations:`n"
$report += "1. Monitor container resource usage regularly`n"
$report += "2. Check service connectivity periodically`n"
$report += "3. Ensure database connections are stable`n"
$report += "4. Monitor cache performance`n"
$report += "5. Regular system health checks`n"

$report | Out-File -FilePath $reportPath -Encoding UTF8
Write-Host "`n[OK] Performance report saved to: $reportPath" -ForegroundColor Green

Write-Host "`nPerformance check completed." -ForegroundColor Green