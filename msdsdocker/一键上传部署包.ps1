<#
.SYNOPSIS
    MSDS System Deployment Package Upload Script
    
.DESCRIPTION
    Upload compiled frontend dist directory and backend JAR package to production server
    
.PARAMETER ServerIP
    Server IP address (default: 39.107.211.72)
    
.PARAMETER ServerUser
    Server username (default: root)
    
.PARAMETER ServerPassword
    Server password (optional, not needed if using SSH key authentication)
    
.PARAMETER SkipFrontend
    Skip frontend file upload
    
.PARAMETER SkipBackend
    Skip backend JAR package upload
    
.EXAMPLE
    .\一键上传部署包.ps1
    
.EXAMPLE
    .\一键上传部署包.ps1 -ServerIP "192.168.1.100" -ServerUser "admin"
#>

param(
    [string]$ServerIP = "39.107.211.72",
    [string]$ServerUser = "root",
    [SecureString]$ServerPassword = $null,
    [switch]$SkipFrontend,
    [switch]$SkipBackend
)

# Set console output encoding to UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Color output function
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Type = "INFO"
    )
    
    $color = switch ($Type) {
        "SUCCESS" { "Green" }
        "ERROR"   { "Red" }
        "WARNING" { "Yellow" }
        "STEP"    { "Cyan" }
        default   { "White" }
    }
    
    $prefix = switch ($Type) {
        "SUCCESS" { "[OK]" }
        "ERROR"   { "[ERROR]" }
        "WARNING" { "[WARN]" }
        "STEP"    { "[STEP]" }
        default   { "[INFO]" }
    }
    
    Write-Host "$prefix $Message" -ForegroundColor $color
}

# Check if command exists
function Test-Command {
    param([string]$Command)
    
    try {
        $null = Get-Command $Command -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

# Execute SSH command
function Invoke-RemoteCommand {
    param(
        [string]$Server,
        [string]$User,
        [string]$Command,
        [SecureString]$Password = $null
    )
    
    if ($Password) {
        # Use password authentication (requires plink)
        if (-not (Test-Command "plink")) {
            Write-ColorOutput "plink not found, please install PuTTY tools or use SSH key authentication" "ERROR"
            return $false
        }
        
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
        $PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
        
        try {
            $process = Start-Process -FilePath "plink" -ArgumentList @(
                "-ssh", "-batch", "-pw", $PlainPassword,
                "$User@$Server", $Command
            ) -Wait -PassThru -NoNewWindow
            
            return $process.ExitCode -eq 0
        }
        finally {
            [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
        }
    }
    else {
        # Use SSH key authentication
        if (-not (Test-Command "ssh")) {
            Write-ColorOutput "ssh command not found, please ensure OpenSSH client is installed" "ERROR"
            return $false
        }
        
        $process = Start-Process -FilePath "ssh" -ArgumentList @(
            "-o", "StrictHostKeyChecking=no",
            "-o", "BatchMode=yes",
            "$User@$Server", $Command
        ) -Wait -PassThru -NoNewWindow
        
        return $process.ExitCode -eq 0
    }
}

# Upload file
function Copy-RemoteFile {
    param(
        [string]$Source,
        [string]$Destination,
        [string]$Server,
        [string]$User,
        [SecureString]$Password = $null
    )
    
    if ($Password) {
        # Use password authentication (requires pscp)
        if (-not (Test-Command "pscp")) {
            Write-ColorOutput "pscp not found, please install PuTTY tools or use SSH key authentication" "ERROR"
            return $false
        }
        
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
        $PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
        
        try {
            $isDirectory = (Get-Item $Source) -is [System.IO.DirectoryInfo]
            $scpArgs = @("-batch", "-pw", $PlainPassword)
            
            if ($isDirectory) {
                $scpArgs += "-r"
            }
            
            $scpArgs += $Source, "$User@$Server`:$Destination"
            
            $process = Start-Process -FilePath "pscp" -ArgumentList $scpArgs -Wait -PassThru -NoNewWindow
            
            return $process.ExitCode -eq 0
        }
        finally {
            [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
        }
    }
    else {
        # Use SSH key authentication
        if (-not (Test-Command "scp")) {
            Write-ColorOutput "scp command not found, please ensure OpenSSH client is installed" "ERROR"
            return $false
        }
        
        $isDirectory = (Get-Item $Source) -is [System.IO.DirectoryInfo]
        $scpArgs = @("-o", "StrictHostKeyChecking=no", "-o", "BatchMode=yes")
        
        if ($isDirectory) {
            $scpArgs += "-r"
        }
        
        $scpArgs += $Source, "$User@$Server`:$Destination"
        
        $process = Start-Process -FilePath "scp" -ArgumentList $scpArgs -Wait -PassThru -NoNewWindow
        
        return $process.ExitCode -eq 0
    }
}

# Main program start
Write-Host ""
Write-ColorOutput "========================================" "STEP"
Write-ColorOutput "MSDS System Deployment Package Upload Script" "STEP"
Write-ColorOutput "========================================" "STEP"
Write-Host ""

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir

# Define paths
$FrontendDistPath = Join-Path $ProjectRoot "msdsPC\ruoyi-MsdsPc-react\react-ui\dist"
$BackendJarPath = Join-Path $ProjectRoot "msdsPC\ruoyi-MsdsPc-react\ruoyi-admin\target\ruoyi-admin.jar"

# Server target paths
$ServerFrontendPath = "/opt/msds/msdsfullstack/msdsdocker/nginx/html"
$ServerBackendPath = "/opt/msds/msdsfullstack/msdsdocker/ruoyi-admin.jar"

Write-ColorOutput "Server Information:" "INFO"
Write-ColorOutput "  IP Address: $ServerIP" "INFO"
Write-ColorOutput "  Username: $ServerUser" "INFO"
Write-Host ""

# Step 1: Check local files
Write-ColorOutput "[1/4] Checking local build artifacts..." "STEP"

$filesToCheck = @()

if (-not $SkipFrontend) {
    if (Test-Path $FrontendDistPath) {
        $distSize = (Get-ChildItem $FrontendDistPath -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB
        Write-ColorOutput "  Frontend dist directory: Found ($([math]::Round($distSize, 2)) MB)" "SUCCESS"
        $filesToCheck += @{Type="Frontend"; Path=$FrontendDistPath; ServerPath=$ServerFrontendPath}
    }
    else {
        Write-ColorOutput "  Frontend dist directory: Not found ($FrontendDistPath)" "ERROR"
        Write-ColorOutput "  Please build frontend first: npm run build:prod" "WARNING"
    }
}

if (-not $SkipBackend) {
    if (Test-Path $BackendJarPath) {
        $jarSize = (Get-Item $BackendJarPath).Length / 1MB
        Write-ColorOutput "  Backend JAR package: Found ($([math]::Round($jarSize, 2)) MB)" "SUCCESS"
        $filesToCheck += @{Type="Backend"; Path=$BackendJarPath; ServerPath=$ServerBackendPath}
    }
    else {
        Write-ColorOutput "  Backend JAR package: Not found ($BackendJarPath)" "ERROR"
        Write-ColorOutput "  Please build backend first: mvn clean package -DskipTests" "WARNING"
    }
}

if ($filesToCheck.Count -eq 0) {
    Write-ColorOutput "No files to upload, exiting" "ERROR"
    exit 1
}

Write-Host ""

# Step 2: Test server connection
Write-ColorOutput "[2/4] Testing server connection..." "STEP"

if (-not $ServerPassword) {
    Write-ColorOutput "  Using SSH key authentication" "INFO"
}
else {
    Write-ColorOutput "  Using password authentication" "INFO"
}

$testCmd = "echo Connection test successful"
$testResult = Invoke-RemoteCommand -Server $ServerIP -User $ServerUser -Command $testCmd -Password $ServerPassword

if (-not $testResult) {
    Write-ColorOutput "  Cannot connect to server $ServerUser@$ServerIP" "ERROR"
    Write-ColorOutput "  Please check:" "WARNING"
    Write-ColorOutput "    1. Server IP address is correct" "WARNING"
    Write-ColorOutput "    2. Network connection is normal" "WARNING"
    Write-ColorOutput "    3. SSH service is running" "WARNING"
    Write-ColorOutput "    4. SSH key is correctly configured (if using key authentication)" "WARNING"
    exit 1
}

Write-ColorOutput "  Server connection successful" "SUCCESS"
Write-Host ""

# Step 3: Prepare server directories
Write-ColorOutput "[3/4] Preparing server directories..." "STEP"

$commands = @(
    "mkdir -p /opt/msds/msdsfullstack/msdsdocker/nginx/html",
    "mkdir -p /opt/msds/msdsfullstack/msdsdocker"
)

foreach ($cmd in $commands) {
    $result = Invoke-RemoteCommand -Server $ServerIP -User $ServerUser -Command $cmd -Password $ServerPassword
    if (-not $result) {
        Write-ColorOutput "  Failed to create directory: $cmd" "WARNING"
    }
}

Write-ColorOutput "  Server directories prepared" "SUCCESS"
Write-Host ""

# Step 4: Upload files
Write-ColorOutput "[4/4] Uploading files to server..." "STEP"

foreach ($file in $filesToCheck) {
    Write-ColorOutput "  Uploading $($file.Type)..." "INFO"
    
    if ($file.Type -eq "Frontend") {
        # Frontend: Clear target directory first, then upload
        Write-ColorOutput "    Clearing server frontend directory..." "INFO"
        $clearCmd = "rm -rf $($file.ServerPath)/*"
        Invoke-RemoteCommand -Server $ServerIP -User $ServerUser -Command $clearCmd -Password $ServerPassword | Out-Null
        
        Write-ColorOutput "    Uploading frontend files..." "INFO"
        $uploadResult = Copy-RemoteFile -Source $file.Path -Destination $file.ServerPath -Server $ServerIP -User $ServerUser -Password $ServerPassword
        
        if ($uploadResult) {
            Write-ColorOutput "    Frontend files uploaded successfully" "SUCCESS"
        }
        else {
            Write-ColorOutput "    Frontend files upload failed" "ERROR"
            exit 1
        }
    }
    else {
        # Backend: Upload JAR file directly
        Write-ColorOutput "    Uploading backend JAR package..." "INFO"
        
        # Backup old file first (if exists)
        $serverPath = $file.ServerPath
        $backupSuffix = ".backup.`$(date +%Y%m%d_%H%M%S)"
        $backupTarget = "$serverPath$backupSuffix"
        $quote = [char]34
        $backupCmd = "if [ -f " + $quote + $serverPath + $quote + " ]; then mv " + $quote + $serverPath + $quote + " " + $quote + $backupTarget + $quote + "; fi"
        Invoke-RemoteCommand -Server $ServerIP -User $ServerUser -Command $backupCmd -Password $ServerPassword | Out-Null
        
        $uploadResult = Copy-RemoteFile -Source $file.Path -Destination $file.ServerPath -Server $ServerIP -User $ServerUser -Password $ServerPassword
        
        if ($uploadResult) {
            Write-ColorOutput "    Backend JAR package uploaded successfully" "SUCCESS"
        }
        else {
            Write-ColorOutput "    Backend JAR package upload failed" "ERROR"
            exit 1
        }
    }
}

Write-Host ""
Write-ColorOutput "========================================" "SUCCESS"
Write-ColorOutput "File upload completed!" "SUCCESS"
Write-ColorOutput "========================================" "SUCCESS"
Write-Host ""

# Display follow-up instructions
Write-ColorOutput "Next steps:" "INFO"
Write-ColorOutput "  1. Login to server to check files:" "INFO"
Write-ColorOutput "     ssh $ServerUser@$ServerIP" "INFO"
Write-ColorOutput "     ls -lh $ServerBackendPath" "INFO"
Write-ColorOutput "     ls -lh $ServerFrontendPath" "INFO"
Write-Host ""
Write-ColorOutput "  2. Restart services (if needed):" "INFO"
Write-ColorOutput "     cd /opt/msds/msdsfullstack/msdsdocker" "INFO"
Write-ColorOutput "     docker-compose -f docker-compose.prod.yml restart msdsbackend" "INFO"
Write-ColorOutput "     docker-compose -f docker-compose.prod.yml restart msdsnginx" "INFO"
Write-Host ""
Write-ColorOutput "  3. Check service status:" "INFO"
Write-ColorOutput "     docker-compose -f docker-compose.prod.yml ps" "INFO"
Write-Host ""
