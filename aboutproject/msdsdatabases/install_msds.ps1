# MSDS实验室管理系统 - 数据库安装脚本 (PowerShell版本)
# 编码: UTF-8

Write-Host "========================================" -ForegroundColor Green
Write-Host "MSDS实验室管理系统 - 数据库安装脚本" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "正在使用完整数据库文件: msds_complete_database.sql" -ForegroundColor Yellow
Write-Host ""

# 检查MySQL是否可用
try {
    $mysqlVersion = mysql --version 2>$null
    if ($mysqlVersion) {
        Write-Host "MySQL已检测到: $mysqlVersion" -ForegroundColor Green
    }
} catch {
    Write-Host "警告: 未检测到MySQL命令行工具" -ForegroundColor Red
    Write-Host "请确保MySQL已安装并添加到PATH环境变量中" -ForegroundColor Red
}

Write-Host ""
$password = Read-Host "请输入MySQL root密码" -AsSecureString
$plainPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))

Write-Host ""
Write-Host "开始执行数据库初始化..." -ForegroundColor Yellow

try {
    # 执行SQL文件
    $process = Start-Process -FilePath "mysql" -ArgumentList "-u", "root", "-p$plainPassword" -RedirectStandardInput "msds_complete_database.sql" -Wait -PassThru -NoNewWindow
    
    if ($process.ExitCode -eq 0) {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "数据库安装成功！" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "数据库名称: msds_dev" -ForegroundColor Cyan
        Write-Host "默认管理员: admin / admin123" -ForegroundColor Cyan
        Write-Host "默认用户: msds_user / 123456" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "详细说明请查看: README_完整数据库说明.md" -ForegroundColor Yellow
        Write-Host "========================================" -ForegroundColor Green
    } else {
        throw "MySQL执行失败，退出代码: $($process.ExitCode)"
    }
} catch {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "数据库安装失败！" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "错误信息: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "请检查:" -ForegroundColor Yellow
    Write-Host "1. MySQL服务是否正在运行" -ForegroundColor Yellow
    Write-Host "2. root密码是否正确" -ForegroundColor Yellow
    Write-Host "3. MySQL命令行工具是否在PATH中" -ForegroundColor Yellow
}

Write-Host ""
Read-Host "按任意键退出"