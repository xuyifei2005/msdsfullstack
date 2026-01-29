# MSDS System Status Check Script
# Version: v1.0

param(
    [switch]$All
)

function Write-Status {
    param(
        [string]$Message,
        [string]$Status
    )
    
    $statusColor = switch ($Status) {
        "OK" { "Green" }
        "FAIL" { "Red" }
        "WARN" { "Yellow" }
        "INFO" { "Cyan" }
        default { "White" }
    }
    
    Write-Host "[$Status]" -ForegroundColor $statusColor -NoNewline
    Write-Host " $Message" -ForegroundColor White
}

function Test-ContainerStatus {
    Write-Host "`n=== Container Status Check ===" -ForegroundColor Cyan
    
    $containers = @(
        "msdsmysql",
        "msdsredis", 
        "msdsbackend",
        "msdsfrontend",
        "msdsnginx",
        "msds-prometheus",
        "msds-grafana",
        "msds-cadvisor"
    )
    
    $allRunning = $true
    
    foreach ($container in $containers) {
        $status = docker ps --filter "name=$container" --format "{{.Status}}" 2>$null
        if ($status -and $status -like "*Up*") {
            Write-Status "Container $container is running" "OK"
        } else {
            Write-Status "Container $container is not running" "FAIL"
            $allRunning = $false
        }
    }
    
    return $allRunning
}

function Test-ServiceConnectivity {
    Write-Host "`n=== Service Connectivity Check ===" -ForegroundColor Cyan
    
    $services = @(
        @{ Name = "Frontend"; Url = "http://localhost:8000" },
        @{ Name = "Backend API"; Url = "http://localhost:18080/captchaImage" },
        @{ Name = "Nginx Proxy"; Url = "http://localhost:180" },
        @{ Name = "Prometheus"; Url = "http://localhost:9090" },
        @{ Name = "Grafana"; Url = "http://localhost:13000" }
    )
    
    $allConnected = $true
    
    foreach ($service in $services) {
        try {
            $response = Invoke-WebRequest -Uri $service.Url -UseBasicParsing -TimeoutSec 30 -ErrorAction Stop
            if ($response.StatusCode -eq 200) {
                Write-Status "$($service.Name) is accessible" "OK"
            } else {
                Write-Status "$($service.Name) returned status: $($response.StatusCode)" "WARN"
                $allConnected = $false
            }
        }
        catch {
            Write-Status "$($service.Name) is not accessible" "FAIL"
            $allConnected = $false
        }
    }
    
    return $allConnected
}

function Test-DatabaseConnectivity {
    Write-Host "`n=== Database Connectivity Check ===" -ForegroundColor Cyan
    
    # Test MySQL
    try {
        $mysqlResult = docker exec msdsmysql mysql -u msds_user -pmsds_dev_password -e "SELECT 'OK' as status;" 2>$null
        if ($mysqlResult -like "*OK*") {
            Write-Status "MySQL database connection is OK" "OK"
            $mysqlOk = $true
        } else {
            Write-Status "MySQL database connection failed" "FAIL"
            $mysqlOk = $false
        }
    }
    catch {
        Write-Status "MySQL database connection test error" "FAIL"
        $mysqlOk = $false
    }
    
    # Test Redis
    try {
        $redisPassword = $env:MSDS_REDIS_PASSWORD
        if ($redisPassword) {
            $redisResult = docker exec msdsredis redis-cli -a $redisPassword ping 2>$null
        } else {
            $redisResult = docker exec msdsredis redis-cli ping 2>$null
        }
        if ($redisResult -eq "PONG") {
            Write-Status "Redis cache connection is OK" "OK"
            $redisOk = $true
        } else {
            Write-Status "Redis cache connection failed" "FAIL"
            $redisOk = $false
        }
    }
    catch {
        Write-Status "Redis cache connection test error" "FAIL"
        $redisOk = $false
    }
    
    return ($mysqlOk -and $redisOk)
}

function Get-ResourceUsage {
    Write-Host "`n=== Resource Usage ===" -ForegroundColor Cyan
    
    try {
        $stats = docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}" $(docker ps --filter "name=msds" --format "{{.Names}}")
        Write-Host $stats -ForegroundColor White
    }
    catch {
        Write-Status "Failed to get resource usage" "FAIL"
    }
}

function Show-Summary {
    param(
        [bool]$ContainerStatus,
        [bool]$ServiceConnectivity,
        [bool]$DatabaseConnectivity
    )
    
    Write-Host "`n=== Summary ===" -ForegroundColor Cyan
    
    $overallStatus = $ContainerStatus -and $ServiceConnectivity -and $DatabaseConnectivity
    
    if ($overallStatus) {
        Write-Status "MSDS System overall status is OK" "OK"
        Write-Host "All core services are running normally" -ForegroundColor Green
    } else {
        Write-Status "MSDS System has issues" "WARN"
        if (!$ContainerStatus) {
            Write-Host "Some containers are not running" -ForegroundColor Red
        }
        if (!$ServiceConnectivity) {
            Write-Host "Some services are not accessible" -ForegroundColor Red
        }
        if (!$DatabaseConnectivity) {
            Write-Host "Database connections have issues" -ForegroundColor Red
        }
    }
    
    Write-Host "`nQuick Access URLs:" -ForegroundColor Cyan
    Write-Host "   Frontend: http://localhost:8000" -ForegroundColor White
    Write-Host "   Backend:  http://localhost:18080" -ForegroundColor White
    Write-Host "   Monitor:  http://localhost:13000 (admin/admin)" -ForegroundColor White
}

# Main Logic
Write-Host "MSDS Laboratory Management System Status Check" -ForegroundColor Magenta
Write-Host "Check Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
Write-Host "=" * 50 -ForegroundColor Gray

$containerStatus = Test-ContainerStatus
$serviceConnectivity = Test-ServiceConnectivity
$databaseConnectivity = Test-DatabaseConnectivity

if ($All) {
    Get-ResourceUsage
}

Show-Summary -ContainerStatus $containerStatus -ServiceConnectivity $serviceConnectivity -DatabaseConnectivity $databaseConnectivity

Write-Host "`nCheck completed" -ForegroundColor Gray
