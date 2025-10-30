param(
    [Parameter(Mandatory=$true)]
    [string]$ServerIP,
    
    [Parameter(Mandatory=$true)]
    [string]$ServerUser,
    
    [string]$Domain = "",
    
    [switch]$SkipBuild,
    
    [switch]$SkipUpload,
    
    [switch]$Force
)

function Write-Info {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Red
}

function Invoke-SSH {
    param(
        [string]$Server,
        [string]$Command
    )
    
    $process = Start-Process -FilePath "ssh" -ArgumentList @($Server, $Command) -Wait -PassThru -NoNewWindow
    return $process.ExitCode
}

function Invoke-SCP {
    param(
        [string]$Source,
        [string]$Destination
    )
    
    $process = Start-Process -FilePath "scp" -ArgumentList @("-r", $Source, $Destination) -Wait -PassThru -NoNewWindow
    return $process.ExitCode
}

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$DockerDir = $PSScriptRoot
$FrontendDir = Join-Path $ProjectRoot "msdsPC\ruoyi-MsdsPc-react\react-ui"
$BuildDir = Join-Path $FrontendDir "dist"

Write-Info "MSDS Lab Management System - Production Deployment Script"
Write-Info "Target Server: $ServerUser@$ServerIP"
if ($Domain) {
    Write-Info "Domain: $Domain"
}

if (-not (Test-Path $ProjectRoot)) {
    Write-Error "Project root directory not found: $ProjectRoot"
    exit 1
}

Write-Info "[1/7] Checking local environment..."

$tools = @("ssh", "scp", "docker")
foreach ($tool in $tools) {
    try {
        $null = Get-Command $tool -ErrorAction Stop
        Write-Success "Found $tool"
    }
    catch {
        Write-Error "$tool not found in PATH"
        exit 1
    }
}

$requiredFiles = @(
    "docker-compose.prod.yml",
    ".env.prod"
)

foreach ($file in $requiredFiles) {
    $filePath = Join-Path $DockerDir $file
    if (-not (Test-Path $filePath)) {
        Write-Error "Required file not found: $file"
        exit 1
    }
    Write-Success "Found $file"
}

if (-not $SkipBuild) {
    Write-Info "[2/7] Building frontend..."
    
    if (-not (Test-Path $FrontendDir)) {
        Write-Error "Frontend directory not found: $FrontendDir"
        exit 1
    }
    
    Set-Location $FrontendDir
    
    if (-not (Test-Path "package.json")) {
        Write-Error "package.json not found"
        exit 1
    }
    
    Write-Info "Installing dependencies..."
    $npmInstall = Start-Process -FilePath "npm" -ArgumentList "install" -Wait -PassThru -NoNewWindow
    if ($npmInstall.ExitCode -ne 0) {
        Write-Error "npm install failed"
        exit 1
    }
    
    Write-Info "Building production version..."
    $npmBuild = Start-Process -FilePath "npm" -ArgumentList "run", "build:prod" -Wait -PassThru -NoNewWindow
    if ($npmBuild.ExitCode -ne 0) {
        Write-Error "npm run build:prod failed"
        exit 1
    }
    
    if (-not (Test-Path $BuildDir)) {
        Write-Error "Build directory not found: $BuildDir"
        exit 1
    }
    
    Set-Location $DockerDir
    Write-Success "Frontend build completed"
} else {
    Write-Info "[2/7] Skipping frontend build"
}

Write-Info "[3/7] Testing server connection..."

$sshTest = Invoke-SSH -Server "$ServerUser@$ServerIP" -Command "echo 'SSH connection successful'"
if ($sshTest -ne 0) {
    Write-Error "Cannot connect to server $ServerUser@$ServerIP"
    exit 1
}
Write-Success "Server connection OK"

Write-Info "[4/7] Preparing server directories..."

$commands = @(
    "mkdir -p /opt/msds",
    "mkdir -p /opt/msds-backup"
)

foreach ($cmd in $commands) {
    $result = Invoke-SSH -Server "$ServerUser@$ServerIP" -Command $cmd
    if ($result -ne 0) {
        Write-Error "Command failed: $cmd"
        exit 1
    }
}

Write-Success "Server directories prepared"

if (-not $SkipUpload) {
    Write-Info "[5/7] Uploading files..."
    
    Write-Info "Uploading Docker configuration..."
    $scpResult1 = Invoke-SCP -Source "$DockerDir\docker-compose.prod.yml" -Destination "$ServerUser@$ServerIP`:/opt/msds/"
    if ($scpResult1 -ne 0) {
        Write-Error "Docker config upload failed"
        exit 1
    }
    
    $scpResult1_env = Invoke-SCP -Source "$DockerDir\.env.prod" -Destination "$ServerUser@$ServerIP`:/opt/msds/"
    if ($scpResult1_env -ne 0) {
        Write-Error "Environment config upload failed"
        exit 1
    }
    
    if (Test-Path $BuildDir) {
        Write-Info "Uploading frontend build files..."
        $mkdirResult = Invoke-SSH -Server "$ServerUser@$ServerIP" -Command "mkdir -p /opt/msds/frontend-dist"
        $scpResult2 = Invoke-SCP -Source "$BuildDir\*" -Destination "$ServerUser@$ServerIP`:/opt/msds/frontend-dist/"
        if ($scpResult2 -ne 0) {
            Write-Error "Frontend files upload failed"
            exit 1
        }
    }
    
    Write-Success "File upload completed"
} else {
    Write-Info "[5/7] Skipping file upload"
}

Write-Info "[6/7] Checking SSL certificates..."

$sslCheck = Invoke-SSH -Server "$ServerUser@$ServerIP" -Command "test -f /opt/msds/nginx/ssl/cert.pem"
if ($sslCheck -ne 0) {
    Write-Warning "SSL certificates not found, will use HTTP mode"
    if (-not $Force) {
        $continue = Read-Host "Continue deployment? (y/N)"
        if ($continue -ne "y" -and $continue -ne "Y") {
            Write-Info "Deployment cancelled"
            exit 0
        }
    }
}

Write-Info "[7/7] Executing server-side deployment..."

$deployCommands = @(
    "cd /opt/msds",
    "chmod +x deploy.sh",
    "cat docker-compose.prod.yml",
    "./deploy.sh",
    "docker ps"
)

foreach ($cmd in $deployCommands) {
    Write-Info "Executing: $cmd"
    $result = Invoke-SSH -Server "$ServerUser@$ServerIP" -Command $cmd
    if ($result -ne 0 -and $cmd -ne "chmod +x deploy.sh" -and $cmd -ne "cat docker-compose.prod.yml") {
        Write-Error "Command failed: $cmd"
        exit 1
    }
}

Write-Success "Deployment completed!"

Write-Info ""
Write-Info "=== Deployment Successful ==="
if ($Domain) {
    Write-Info "Application URL: https://$Domain"
} else {
    Write-Info "Application URL: http://$ServerIP"
}

Write-Info ""
Write-Info "=== Management Commands ==="
Write-Info "View logs: ssh $ServerUser@$ServerIP 'docker logs -f msdsfrontend'"
Write-Info "Restart services: ssh $ServerUser@$ServerIP 'cd /opt/msds && docker-compose -f docker-compose.prod.yml restart'"
Write-Info "Stop services: ssh $ServerUser@$ServerIP 'cd /opt/msds && docker-compose -f docker-compose.prod.yml down'"

Write-Info ""
Write-Info "=== Health Check ==="
Write-Info "Check container status: ssh $ServerUser@$ServerIP 'docker ps'"
Write-Info "Check service status: curl -I http://$ServerIP"