# MSDS系统性能优化脚本
# 版本: 1.0
# 作者: AI PM
# 日期: 2025-10-30

param(
    [switch]$CheckOnly,
    [switch]$OptimizeAll
)

Write-Host "MSDS Laboratory Management System Performance Optimization" -ForegroundColor Green
Write-Host "=" * 60

# 检查Docker是否运行
function Test-DockerRunning {
    try {
        docker version | Out-Null
        return $true
    }
    catch {
        Write-Host "[ERROR] Docker is not running" -ForegroundColor Red
        return $false
    }
}

# 检查容器资源使用
function Get-ContainerStats {
    Write-Host "`n=== Container Resource Usage ===" -ForegroundColor Yellow
    
    $containers = @("msdsbackend", "msdsfrontend", "msdsmysql", "msdsredis", "msdsnginx")
    
    foreach ($container in $containers) {
        try {
            Write-Host "Checking $container..." -ForegroundColor Cyan
            $stats = docker stats --no-stream --format "{{.CPUPerc}},{{.MemUsage}},{{.MemPerc}}" $container
            if ($stats) {
                $parts = $stats -split ","
                $cpu = $parts[0]
                $memory = $parts[1]
                $memPercent = $parts[2]
                
                Write-Host "  CPU: $cpu" -ForegroundColor White
                Write-Host "  Memory: $memory ($memPercent)" -ForegroundColor White
                
                # 检查资源使用警告
                $cpuValue = [float]($cpu -replace '%', '')
                $memValue = [float]($memPercent -replace '%', '')
                
                if ($cpuValue -gt 80) {
                    Write-Host "  [WARNING] High CPU usage!" -ForegroundColor Red
                }
                if ($memValue -gt 80) {
                    Write-Host "  [WARNING] High memory usage!" -ForegroundColor Red
                }
                if ($cpuValue -lt 50 -and $memValue -lt 50) {
                    Write-Host "  [OK] Resource usage normal" -ForegroundColor Green
                }
            }
        }
        catch {
            Write-Host "  [ERROR] Cannot get stats for $container" -ForegroundColor Red
        }
    }
}

# 数据库性能检查
function Test-DatabasePerformance {
    Write-Host "`n=== Database Performance Check ===" -ForegroundColor Yellow
    
    try {
        Write-Host "Testing MySQL connection..." -ForegroundColor Cyan
        $result = docker exec msdsmysql mysql -u msds_user -pmsds_dev_password -e "SELECT 1;" 2>$null
        if ($result) {
            Write-Host "[OK] MySQL connection successful" -ForegroundColor Green
        }
        
        Write-Host "Checking MySQL process list..." -ForegroundColor Cyan
        $processes = docker exec msdsmysql mysql -u msds_user -pmsds_dev_password -e "SHOW PROCESSLIST;" 2>$null
        if ($processes) {
            Write-Host "[OK] MySQL processes checked" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "[WARNING] Database performance check failed" -ForegroundColor Yellow
    }
}

# Redis性能检查
function Test-RedisPerformance {
    Write-Host "`n=== Redis Performance Check ===" -ForegroundColor Yellow
    
    try {
        Write-Host "Testing Redis connection..." -ForegroundColor Cyan
        $redisPassword = $env:MSDS_REDIS_PASSWORD
        if ($redisPassword) {
            $result = docker exec msdsredis redis-cli -a $redisPassword ping 2>$null
        } else {
            $result = docker exec msdsredis redis-cli ping 2>$null
        }
        if ($result -eq "PONG") {
            Write-Host "[OK] Redis connection successful" -ForegroundColor Green
        }
        
        Write-Host "Checking Redis memory usage..." -ForegroundColor Cyan
        if ($redisPassword) {
            $memInfo = docker exec msdsredis redis-cli -a $redisPassword info memory 2>$null
        } else {
            $memInfo = docker exec msdsredis redis-cli info memory 2>$null
        }
        if ($memInfo) {
            Write-Host "[OK] Redis memory info retrieved" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "[WARNING] Redis performance check failed" -ForegroundColor Yellow
    }
}

# 网络性能测试
function Test-NetworkPerformance {
    Write-Host "`n=== Network Performance Test ===" -ForegroundColor Yellow
    
    try {
        Write-Host "Testing service connectivity..." -ForegroundColor Cyan
        
        # 测试前端服务
        $frontendTest = Invoke-WebRequest -Uri "http://localhost:8000" -TimeoutSec 10 -UseBasicParsing 2>$null
        if ($frontendTest.StatusCode -eq 200) {
            Write-Host "[OK] Frontend service accessible" -ForegroundColor Green
        }
        
        # 测试后端API
        $backendTest = Invoke-WebRequest -Uri "http://localhost:18080/captchaImage" -TimeoutSec 10 -UseBasicParsing 2>$null
        if ($backendTest.StatusCode -eq 200) {
            Write-Host "[OK] Backend API accessible" -ForegroundColor Green
        }
        
        # 测试Nginx代理
        $nginxTest = Invoke-WebRequest -Uri "http://localhost:180/health" -TimeoutSec 10 -UseBasicParsing 2>$null
        if ($nginxTest.StatusCode -eq 200) {
            Write-Host "[OK] Nginx proxy accessible" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "[WARNING] Some network tests failed" -ForegroundColor Yellow
    }
}

# 应用基本优化
function Apply-BasicOptimizations {
    Write-Host "`n=== Applying Basic Optimizations ===" -ForegroundColor Yellow
    
    try {
        Write-Host "Optimizing Redis configuration..." -ForegroundColor Cyan
        $redisPassword = $env:MSDS_REDIS_PASSWORD
        if ($redisPassword) {
            docker exec msdsredis redis-cli -a $redisPassword config set maxmemory 256mb 2>$null
            docker exec msdsredis redis-cli -a $redisPassword config set maxmemory-policy allkeys-lru 2>$null
        } else {
            docker exec msdsredis redis-cli config set maxmemory 256mb 2>$null
            docker exec msdsredis redis-cli config set maxmemory-policy allkeys-lru 2>$null
        }
        Write-Host "[OK] Redis optimization applied" -ForegroundColor Green
        
        Write-Host "Cleaning up Docker resources..." -ForegroundColor Cyan
        docker system prune -f | Out-Null
        Write-Host "[OK] Docker cleanup completed" -ForegroundColor Green
        
    }
    catch {
        Write-Host "[WARNING] Some optimizations failed" -ForegroundColor Yellow
    }
}

# 生成性能报告
function Generate-PerformanceReport {
    Write-Host "`n=== Generating Performance Report ===" -ForegroundColor Yellow
    
    $reportPath = "performance-report-$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
    $timestamp = Get-Date
    
    $reportContent = "MSDS System Performance Report`n"
    $reportContent += "Generated: $timestamp`n"
    $reportContent += "=" * 50 + "`n`n"
    
    # 获取容器状态
    $reportContent += "Container Status:`n"
    $containers = @("msdsbackend", "msdsfrontend", "msdsmysql", "msdsredis", "msdsnginx")
    foreach ($container in $containers) {
        try {
            $status = docker inspect --format='{{.State.Status}}' $container 2>$null
            $reportContent += "$container : $status`n"
        }
        catch {
            $reportContent += "$container : error`n"
        }
    }
    
    $reportContent += "`nRecommendations:`n"
    $reportContent += "1. Monitor memory usage regularly`n"
    $reportContent += "2. Implement database query optimization`n"
    $reportContent += "3. Configure proper caching strategies`n"
    $reportContent += "4. Set up resource limits for production`n"
    $reportContent += "5. Regular cleanup of unused Docker resources`n"
    
    $reportContent | Out-File -FilePath $reportPath -Encoding UTF8
    Write-Host "[OK] Performance report saved to: $reportPath" -ForegroundColor Green
}

# 主执行逻辑
if (!(Test-DockerRunning)) {
    exit 1
}

if ($CheckOnly) {
    Get-ContainerStats
    Test-DatabasePerformance
    Test-RedisPerformance
    Test-NetworkPerformance
    Generate-PerformanceReport
}
elseif ($OptimizeAll) {
    Get-ContainerStats
    Test-DatabasePerformance
    Test-RedisPerformance
    Test-NetworkPerformance
    Apply-BasicOptimizations
    Generate-PerformanceReport
    Write-Host "`n[COMPLETE] Performance optimization completed!" -ForegroundColor Green
}
else {
    Write-Host "Usage: .\performance-optimization.ps1 [options]" -ForegroundColor Cyan
    Write-Host "Options:" -ForegroundColor White
    Write-Host "  -CheckOnly    : Only check current performance" -ForegroundColor White
    Write-Host "  -OptimizeAll  : Run performance check and apply optimizations" -ForegroundColor White
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Cyan
    Write-Host "  .\performance-optimization.ps1 -CheckOnly" -ForegroundColor White
    Write-Host "  .\performance-optimization.ps1 -OptimizeAll" -ForegroundColor White
}

Write-Host "`nPerformance script completed." -ForegroundColor Green
