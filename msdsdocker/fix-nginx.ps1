# Nginx Configuration Fix Script
# Version: v1.0

param(
    [switch]$Backup,
    [switch]$Restore,
    [switch]$Check
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

function Backup-NginxConfig {
    Write-Host "`n=== Backup Nginx Configuration ===" -ForegroundColor Cyan
    
    $backupDir = "./nginx/backup"
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    
    try {
        # Create backup directory
        if (!(Test-Path $backupDir)) {
            New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
        }
        
        # Backup configuration files
        if (Test-Path "./nginx/conf.d") {
            Copy-Item -Path "./nginx/conf.d" -Destination "$backupDir/conf.d_$timestamp" -Recurse -Force
            Write-Status "Configuration files backed up to $backupDir/conf.d_$timestamp" "OK"
        }
        
        return $true
    }
    catch {
        Write-Status "Failed to backup configuration: $($_.Exception.Message)" "FAIL"
        return $false
    }
}

function Test-NginxConfig {
    Write-Host "`n=== Test Nginx Configuration ===" -ForegroundColor Cyan
    
    try {
        $result = docker exec msdsnginx nginx -t 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Status "Nginx configuration syntax is valid" "OK"
            return $true
        } else {
            Write-Status "Nginx configuration has errors:" "FAIL"
            Write-Host $result -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Status "Failed to test Nginx configuration: $($_.Exception.Message)" "FAIL"
        return $false
    }
}

function Fix-NginxConfig {
    Write-Host "`n=== Fix Nginx Configuration ===" -ForegroundColor Cyan
    
    $configContent = @"
# MSDS System Nginx Configuration
# Fixed version to resolve conflicts

upstream frontend {
    server msdsfrontend:8000;
}

upstream backend {
    server msdsbackend:8080;
}

# Default server block
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;
    
    # Health check endpoint
    location /health {
        access_log off;
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }
    
    # Frontend proxy
    location / {
        proxy_pass http://frontend;
        proxy_set_header Host `$host;
        proxy_set_header X-Real-IP `$remote_addr;
        proxy_set_header X-Forwarded-For `$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto `$scheme;
        
        # WebSocket support
        proxy_http_version 1.1;
        proxy_set_header Upgrade `$http_upgrade;
        proxy_set_header Connection "upgrade";
        
        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
    
    # API proxy
    location /api/ {
        proxy_pass http://backend/;
        proxy_set_header Host `$host;
        proxy_set_header X-Real-IP `$remote_addr;
        proxy_set_header X-Forwarded-For `$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto `$scheme;
        
        # Timeouts
        proxy_connect_timeout 30s;
        proxy_send_timeout 30s;
        proxy_read_timeout 30s;
    }
    
    # Captcha image
    location /captchaImage {
        proxy_pass http://backend/captchaImage;
        proxy_set_header Host `$host;
        proxy_set_header X-Real-IP `$remote_addr;
        proxy_set_header X-Forwarded-For `$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto `$scheme;
    }
    
    # File upload and profile
    location /profile/ {
        proxy_pass http://backend/profile/;
        proxy_set_header Host `$host;
        proxy_set_header X-Real-IP `$remote_addr;
        proxy_set_header X-Forwarded-For `$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto `$scheme;
        
        # File upload settings
        client_max_body_size 100M;
        proxy_request_buffering off;
    }
    
    # Static files
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        proxy_pass http://frontend;
        proxy_set_header Host `$host;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}

# HTTPS server block (commented out, uncomment when SSL is configured)
# server {
#     listen 443 ssl http2;
#     listen [::]:443 ssl http2;
#     server_name yourdomain.com www.yourdomain.com;
#     
#     ssl_certificate /etc/nginx/ssl/server.crt;
#     ssl_certificate_key /etc/nginx/ssl/server.key;
#     
#     # Include the same location blocks as above
#     # ... (copy from the HTTP server block)
# }
"@

    try {
        # Ensure directory exists
        if (!(Test-Path "./nginx/conf.d")) {
            New-Item -ItemType Directory -Path "./nginx/conf.d" -Force | Out-Null
        }
        
        # Write new configuration
        $configContent | Out-File -FilePath "./nginx/conf.d/default.conf" -Encoding UTF8 -Force
        Write-Status "New Nginx configuration written to ./nginx/conf.d/default.conf" "OK"
        
        return $true
    }
    catch {
        Write-Status "Failed to write Nginx configuration: $($_.Exception.Message)" "FAIL"
        return $false
    }
}

function Restart-NginxService {
    Write-Host "`n=== Restart Nginx Service ===" -ForegroundColor Cyan
    
    try {
        # Test configuration first
        $testResult = docker exec msdsnginx nginx -t 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Status "Configuration test failed, not restarting" "FAIL"
            Write-Host $testResult -ForegroundColor Red
            return $false
        }
        
        # Reload Nginx
        docker exec msdsnginx nginx -s reload
        if ($LASTEXITCODE -eq 0) {
            Write-Status "Nginx configuration reloaded successfully" "OK"
        } else {
            # If reload fails, try restart
            Write-Status "Reload failed, restarting container..." "WARN"
            docker-compose restart msdsnginx
            Start-Sleep -Seconds 5
            Write-Status "Nginx container restarted" "OK"
        }
        
        return $true
    }
    catch {
        Write-Status "Failed to restart Nginx: $($_.Exception.Message)" "FAIL"
        return $false
    }
}

function Test-NginxConnectivity {
    Write-Host "`n=== Test Nginx Connectivity ===" -ForegroundColor Cyan
    
    $testUrls = @(
        @{ Name = "Health Check"; Url = "http://localhost:180/health" },
        @{ Name = "Frontend"; Url = "http://localhost:180/" },
        @{ Name = "Backend API"; Url = "http://localhost:180/api/captchaImage" }
    )
    
    $allPassed = $true
    
    foreach ($test in $testUrls) {
        try {
            $response = Invoke-WebRequest -Uri $test.Url -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop
            if ($response.StatusCode -eq 200) {
                Write-Status "$($test.Name) is accessible" "OK"
            } else {
                Write-Status "$($test.Name) returned status: $($response.StatusCode)" "WARN"
                $allPassed = $false
            }
        }
        catch {
            Write-Status "$($test.Name) is not accessible: $($_.Exception.Message)" "FAIL"
            $allPassed = $false
        }
    }
    
    return $allPassed
}

function Show-NginxStatus {
    Write-Host "`n=== Nginx Status ===" -ForegroundColor Cyan
    
    # Container status
    $containerStatus = docker ps --filter "name=msdsnginx" --format "{{.Status}}"
    if ($containerStatus -and $containerStatus -like "*Up*") {
        Write-Status "Nginx container is running" "OK"
    } else {
        Write-Status "Nginx container is not running" "FAIL"
        return
    }
    
    # Configuration test
    Test-NginxConfig | Out-Null
    
    # Connectivity test
    Test-NginxConnectivity | Out-Null
    
    # Show access URLs
    Write-Host "`nAccess URLs:" -ForegroundColor Cyan
    Write-Host "   Nginx Proxy: http://localhost:180" -ForegroundColor White
    Write-Host "   Direct Frontend: http://localhost:8000" -ForegroundColor White
    Write-Host "   Direct Backend: http://localhost:18080" -ForegroundColor White
}

# Main Logic
Write-Host "MSDS Nginx Configuration Fix Tool" -ForegroundColor Magenta
Write-Host "Fix Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
Write-Host "=" * 50 -ForegroundColor Gray

if ($Backup) {
    Backup-NginxConfig
    exit
}

if ($Restore) {
    Write-Host "Please manually restore from backup directory: ./nginx/backup/" -ForegroundColor Yellow
    exit
}

if ($Check) {
    Show-NginxStatus
    exit
}

# Default: Full fix process
Write-Host "Starting Nginx configuration fix process..." -ForegroundColor Cyan

# Step 1: Backup current configuration
Write-Status "Step 1: Backing up current configuration" "INFO"
$backupSuccess = Backup-NginxConfig

# Step 2: Fix configuration
Write-Status "Step 2: Applying configuration fix" "INFO"
$fixSuccess = Fix-NginxConfig

# Step 3: Test configuration
Write-Status "Step 3: Testing new configuration" "INFO"
$testSuccess = Test-NginxConfig

# Step 4: Restart service
if ($testSuccess) {
    Write-Status "Step 4: Restarting Nginx service" "INFO"
    $restartSuccess = Restart-NginxService
    
    # Step 5: Final connectivity test
    if ($restartSuccess) {
        Write-Status "Step 5: Testing connectivity" "INFO"
        Start-Sleep -Seconds 3
        $connectivitySuccess = Test-NginxConnectivity
        
        if ($connectivitySuccess) {
            Write-Host "`n✅ Nginx configuration fix completed successfully!" -ForegroundColor Green
            Write-Host "You can now access the system through: http://localhost:180" -ForegroundColor Green
        } else {
            Write-Host "`n⚠️  Configuration applied but connectivity issues remain" -ForegroundColor Yellow
            Write-Host "Please check the logs: docker logs msdsnginx" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "`n❌ Configuration test failed. Please check the syntax errors above." -ForegroundColor Red
    Write-Host "You can restore from backup if needed." -ForegroundColor Red
}

Write-Host "`nFix process completed" -ForegroundColor Gray