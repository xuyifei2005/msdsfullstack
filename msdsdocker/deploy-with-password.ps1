param(
    [Parameter(Mandatory=$true)]
    [string]$ServerIP,
    
    [Parameter(Mandatory=$true)]
    [string]$ServerUser,
    
    [Parameter(Mandatory=$true)]
    [SecureString]$ServerPassword,
    
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

function Invoke-SSHWithPassword {
    param(
        [string]$Server,
        [string]$User,
        [SecureString]$Password,
        [string]$Command
    )
    
    # 将SecureString转换为明文（仅在内存中）
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
    $PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
    
    try {
        # 使用plink进行SSH连接
        $process = Start-Process -FilePath "plink" -ArgumentList @(
            "-ssh", 
            "-batch", 
            "-pw", $PlainPassword,
            "$User@$Server", 
            $Command
        ) -Wait -PassThru -NoNewWindow -RedirectStandardOutput "ssh_output.txt" -RedirectStandardError "ssh_error.txt"
        
        return $process.ExitCode
    }
    finally {
        # 清理内存中的密码
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
        $PlainPassword = $null
    }
}

function Invoke-SCPWithPassword {
    param(
        [string]$Source,
        [string]$Destination,
        [string]$User,
        [SecureString]$Password
    )
    
    # 将SecureString转换为明文（仅在内存中）
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
    $PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
    
    try {
        # 使用pscp进行文件传输
        $process = Start-Process -FilePath "pscp" -ArgumentList @(
            "-batch", 
            "-pw", $PlainPassword,
            "-r",
            $Source, 
            "$User@$Destination"
        ) -Wait -PassThru -NoNewWindow
        
        return $process.ExitCode
    }
    finally {
        # 清理内存中的密码
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
        $PlainPassword = $null
    }
}

# 主部署逻辑
Write-Info "MSDS Lab Management System - Production Deployment Script (With Password Auth)"
Write-Info "Target Server: $ServerUser@$ServerIP"
if ($Domain) {
    Write-Info "Domain: $Domain"
}

# 步骤1: 检查本地环境
Write-Info "[1/7] Checking local environment..."

# 检查必要的工具
$tools = @("plink", "pscp", "docker")
foreach ($tool in $tools) {
    try {
        $null = Get-Command $tool -ErrorAction Stop
        Write-Success "Found $tool"
    }
    catch {
        Write-Error "$tool not found. Please install PuTTY tools and Docker."
        exit 1
    }
}

# 检查必要的文件
$files = @("docker-compose.prod.yml", ".env.prod")
foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Success "Found $file"
    }
    else {
        Write-Error "$file not found"
        exit 1
    }
}

# 步骤2: 前端构建（可选）
if (-not $SkipBuild) {
    Write-Info "[2/7] Building frontend..."
    $frontendPath = "..\msdsPC\ruoyi-MsdsPc-react\react-ui"
    if (Test-Path $frontendPath) {
        Push-Location $frontendPath
        try {
            Write-Info "Installing dependencies..."
            npm install
            Write-Info "Building production version..."
            npm run build:prod
            Write-Success "Frontend build completed"
        }
        catch {
            Write-Error "Frontend build failed: $_"
            exit 1
        }
        finally {
            Pop-Location
        }
    }
    else {
        Write-Warning "Frontend path not found, skipping build"
    }
}
else {
    Write-Info "[2/7] Skipping frontend build"
}

# 步骤3: 测试服务器连接
Write-Info "[3/7] Testing server connection..."
$testResult = Invoke-SSHWithPassword -Server $ServerIP -User $ServerUser -Password $ServerPassword -Command "echo 'Connection test successful'"
if ($testResult -ne 0) {
    Write-Error "Cannot connect to server $ServerUser@$ServerIP"
    exit 1
}
Write-Success "Server connection successful"

# 步骤4: 准备服务器目录
Write-Info "[4/7] Preparing server directories..."
$commands = @(
    "mkdir -p /opt/msds",
    "mkdir -p /opt/msds/nginx/ssl",
    "mkdir -p /opt/msds/mysql/data",
    "mkdir -p /opt/msds/logs"
)

foreach ($cmd in $commands) {
    $result = Invoke-SSHWithPassword -Server $ServerIP -User $ServerUser -Password $ServerPassword -Command $cmd
    if ($result -ne 0) {
        Write-Warning "Command failed: $cmd"
    }
}
Write-Success "Server directories prepared"

# 步骤5: 上传文件
if (-not $SkipUpload) {
    Write-Info "[5/7] Uploading files to server..."
    
    # 上传Docker配置文件
    $uploadFiles = @(
        @{Source = "docker-compose.prod.yml"; Dest = "$ServerIP:/opt/msds/"},
        @{Source = ".env.prod"; Dest = "$ServerIP:/opt/msds/.env"},
        @{Source = "nginx"; Dest = "$ServerIP:/opt/msds/"},
        @{Source = "mysql"; Dest = "$ServerIP:/opt/msds/"}
    )
    
    foreach ($upload in $uploadFiles) {
        Write-Info "Uploading $($upload.Source)..."
        $result = Invoke-SCPWithPassword -Source $upload.Source -Destination $upload.Dest -User $ServerUser -Password $ServerPassword
        if ($result -ne 0) {
            Write-Error "Failed to upload $($upload.Source)"
            exit 1
        }
    }
    
    # 上传前端文件（如果存在）
    $frontendDist = "..\msdsPC\ruoyi-MsdsPc-react\react-ui\dist"
    if (Test-Path $frontendDist) {
        Write-Info "Uploading frontend files..."
        $result = Invoke-SCPWithPassword -Source $frontendDist -Destination "$ServerIP:/opt/msds/nginx/html/" -User $ServerUser -Password $ServerPassword
        if ($result -ne 0) {
            Write-Warning "Failed to upload frontend files"
        }
    }
    
    Write-Success "Files uploaded successfully"
}
else {
    Write-Info "[5/7] Skipping file upload"
}

# 步骤6: 检查SSL证书
Write-Info "[6/7] Checking SSL certificates..."
$sslCheck = Invoke-SSHWithPassword -Server $ServerIP -User $ServerUser -Password $ServerPassword -Command "test -f /opt/msds/nginx/ssl/flymsds.cn.pem && test -f /opt/msds/nginx/ssl/flymsds.cn.key"
if ($sslCheck -ne 0) {
    Write-Warning "SSL certificates not found on server"
    Write-Info "Please ensure SSL certificates are uploaded to /opt/msds/nginx/ssl/"
    if (-not $Force) {
        $continue = Read-Host "Continue without SSL? (y/N)"
        if ($continue -ne "y" -and $continue -ne "Y") {
            Write-Info "Deployment cancelled"
            exit 1
        }
    }
}
else {
    Write-Success "SSL certificates found"
}

# 步骤7: 部署应用
Write-Info "[7/7] Deploying application..."
$deployCommands = @(
    "cd /opt/msds",
    "docker-compose -f docker-compose.prod.yml down",
    "docker-compose -f docker-compose.prod.yml pull",
    "docker-compose -f docker-compose.prod.yml up -d",
    "sleep 10",
    "docker-compose -f docker-compose.prod.yml ps"
)

foreach ($cmd in $deployCommands) {
    Write-Info "Executing: $cmd"
    $result = Invoke-SSHWithPassword -Server $ServerIP -User $ServerUser -Password $ServerPassword -Command $cmd
    if ($result -ne 0 -and $cmd -notlike "*ps*") {
        Write-Warning "Command may have failed: $cmd"
    }
}

Write-Success "Deployment completed!"
Write-Info ""
Write-Info "Post-deployment instructions:"
Write-Info "1. Check application status: docker-compose -f docker-compose.prod.yml ps"
Write-Info "2. View logs: docker-compose -f docker-compose.prod.yml logs -f"
Write-Info "3. Restart services: docker-compose -f docker-compose.prod.yml restart"
Write-Info "4. Stop services: docker-compose -f docker-compose.prod.yml down"
if ($Domain) {
    Write-Info "5. Access your application at: https://$Domain"
}
Write-Info "6. Health check: curl -k https://$ServerIP/health"

# 清理临时文件
Remove-Item -Path "ssh_output.txt", "ssh_error.txt" -ErrorAction SilentlyContinue