# MSDS项目自动Git提交和推送脚本
# 作者: AI Assistant
# 版本: 1.0

param(
    [string]$CommitMessage = "",
    [switch]$Force,
    [switch]$DryRun,
    [switch]$Help
)

# 日志函数
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "Info"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    
    switch ($Level) {
        "Error" { Write-Host $logMessage -ForegroundColor Red }
        "Warning" { Write-Host $logMessage -ForegroundColor Yellow }
        "Success" { Write-Host $logMessage -ForegroundColor Green }
        default { Write-Host $logMessage -ForegroundColor White }
    }
    
    # 同时写入日志文件
    $logMessage | Out-File -FilePath ".\auto-git-log.txt" -Append -Encoding UTF8
}

# 显示帮助信息
function Show-Help {
    Write-Host "MSDS项目自动Git提交和推送脚本" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "用法:" -ForegroundColor Yellow
    Write-Host "  .\auto-git-commit.ps1 [-CommitMessage ""消息""] [-Force] [-DryRun] [-Help]" -ForegroundColor White
    Write-Host ""
    Write-Host "参数说明:" -ForegroundColor Yellow
    Write-Host "  -CommitMessage ""消息"" : 指定提交消息，默认自动生成" -ForegroundColor White
    Write-Host "  -Force                : 强制推送，即使有冲突也继续" -ForegroundColor White
    Write-Host "  -DryRun               : 模拟运行，不实际执行操作" -ForegroundColor White
    Write-Host "  -Help                 : 显示此帮助信息" -ForegroundColor White
    Write-Host ""
    Write-Host "示例:" -ForegroundColor Yellow
    Write-Host "  .\auto-git-commit.ps1" -ForegroundColor White
    Write-Host "  .\auto-git-commit.ps1 -CommitMessage ""更新README文件""" -ForegroundColor White
    Write-Host "  .\auto-git-commit.ps1 -Force" -ForegroundColor White
    Write-Host "  .\auto-git-commit.ps1 -DryRun -CommitMessage ""测试提交""" -ForegroundColor White
    Write-Host ""
    Write-Host "功能说明:" -ForegroundColor Yellow
    Write-Host "  1. 检查Git状态和未提交的更改" -ForegroundColor White
    Write-Host "  2. 自动添加所有更改到暂存区" -ForegroundColor White
    Write-Host "  3. 生成提交消息（可自定义）" -ForegroundColor White
    Write-Host "  4. 提交更改到本地仓库" -ForegroundColor White
    Write-Host "  5. 推送更改到远程仓库" -ForegroundColor White
    Write-Host ""
    Write-Host "注意事项:" -ForegroundColor Yellow
    Write-Host "  - 确保已在Git仓库目录中运行此脚本" -ForegroundColor White
    Write-Host "  - 确保已配置Git远程仓库" -ForegroundColor White
    Write-Host "  - 确保有足够的权限推送更改" -ForegroundColor White
}

# 检查Git是否安装
function Test-GitInstalled {
    try {
        $gitVersion = git --version 2>$null
        return $gitVersion -ne $null
    } catch {
        return $false
    }
}

# 检查是否为Git仓库
function Test-GitRepository {
    try {
        $gitDir = git rev-parse --git-dir 2>$null
        return $gitDir -ne $null
    } catch {
        return $false
    }
}

# 获取当前分支
function Get-CurrentBranch {
    try {
        return git rev-parse --abbrev-ref HEAD 2>$null
    } catch {
        return $null
    }
}

# 检查是否有未提交的更改
function Test-UncommittedChanges {
    try {
        $status = git status --porcelain 2>$null
        return $status -ne $null -and $status.Trim() -ne ""
    } catch {
        return $false
    }
}

# 获取未提交更改的文件列表
function Get-UncommittedFiles {
    try {
        return git status --porcelain 2>$null | ForEach-Object { $_.Trim() }
    } catch {
        return @()
    }
}

# 生成默认提交消息
function Generate-DefaultCommitMessage {
    $date = Get-Date -Format "yyyy-MM-dd HH:mm"
    $files = Get-UncommittedFiles
    $fileCount = $files.Count
    
    if ($fileCount -eq 0) {
        return "自动提交: 无文件更改 ($date)"
    }
    
    # 分析更改类型
    $added = ($files | Where-Object { $_.StartsWith("A") }).Count
    $modified = ($files | Where-Object { $_.StartsWith("M") }).Count
    $deleted = ($files | Where-Object { $_.StartsWith("D") }).Count
    
    $message = "自动提交: "
    if ($added -gt 0) { $message += "新增$added个文件 " }
    if ($modified -gt 0) { $message += "修改$modified个文件 " }
    if ($deleted -gt 0) { $message += "删除$deleted个文件 " }
    
    $message += "($date)"
    return $message
}

# 主函数
function Main {
    Write-Log "开始执行MSDS项目自动Git提交和推送" "Info"
    Write-Log "=====================================" "Info"
    
    # 检查帮助参数
    if ($Help) {
        Show-Help
        return
    }
    
    # 检查Git是否安装
    if (-not (Test-GitInstalled)) {
        Write-Log "请先安装Git并配置到环境变量" "Error"
        exit 1
    }
    
    # 检查是否为Git仓库
    if (-not (Test-GitRepository)) {
        Write-Log "请在Git仓库目录中运行此脚本" "Error"
        exit 1
    }
    
    # 获取当前分支
    $currentBranch = Get-CurrentBranch
    if (-not $currentBranch) {
        Write-Log "无法获取当前分支信息" "Error"
        exit 1
    }
    
    Write-Log "当前分支: $currentBranch" "Info"
    
    # 检查是否有未提交的更改
    if (-not (Test-UncommittedChanges)) {
        Write-Log "没有未提交的更改" "Warning"
        return
    }
    
    # 获取未提交文件列表
    $uncommittedFiles = Get-UncommittedFiles
    Write-Log "发现 $($uncommittedFiles.Count) 个未提交的文件:" "Info"
    foreach ($file in $uncommittedFiles) {
        Write-Log "  $file" "Info"
    }
    
    # 确定提交消息
    if ($CommitMessage -eq "") {
        $CommitMessage = Generate-DefaultCommitMessage
        Write-Log "使用自动生成的提交消息: $CommitMessage" "Info"
    } else {
        Write-Log "使用指定的提交消息: $CommitMessage" "Info"
    }
    
    # 如果是模拟运行，到这里就结束
    if ($DryRun) {
        Write-Log "模拟运行模式，不会执行实际操作" "Warning"
        Write-Log "已完成模拟运行" "Success"
        return
    }
    
    try {
        # 添加所有更改到暂存区
        Write-Log "正在添加所有更改到暂存区..." "Info"
        if (-not $DryRun) {
            git add .
            if ($LASTEXITCODE -ne 0) {
                throw "添加文件到暂存区失败"
            }
        }
        Write-Log "成功添加所有更改到暂存区" "Success"
        
        # 提交更改
        Write-Log "正在提交更改..." "Info"
        if (-not $DryRun) {
            git commit -m "$CommitMessage"
            if ($LASTEXITCODE -ne 0) {
                throw "提交更改失败"
            }
        }
        Write-Log "成功提交更改" "Success"
        
        # 拉取远程更改
        Write-Log "正在拉取远程更改..." "Info"
        if (-not $DryRun) {
            git pull origin $currentBranch
            if ($LASTEXITCODE -ne 0 -and -not $Force) {
                throw "拉取远程更改失败，可能存在冲突。使用-Force参数强制推送"
            }
        }
        Write-Log "完成拉取远程更改" "Success"
        
        # 推送更改到远程仓库
        Write-Log "正在推送更改到远程仓库..." "Info"
        if (-not $DryRun) {
            $pushArgs = @("push", "origin", $currentBranch)
            if ($Force) {
                $pushArgs += "--force"
                Write-Log "使用强制推送模式" "Warning"
            }
            
            & git $pushArgs
            if ($LASTEXITCODE -ne 0) {
                throw "推送更改到远程仓库失败"
            }
        }
        Write-Log "成功推送更改到远程仓库" "Success"
        
        Write-Log "自动Git提交和推送完成" "Success"
        Write-Log "=====================================" "Info"
        
    } catch {
        Write-Log "执行过程中发生错误: $($_.Exception.Message)" "Error"
        Write-Log "自动Git提交和推送失败" "Error"
        exit 1
    }
}

# 执行主函数
Main