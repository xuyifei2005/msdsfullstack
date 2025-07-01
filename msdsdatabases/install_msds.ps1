# =============================================
# MSDS数据库安装 PowerShell脚本
# 解决PowerShell兼容性问题
# =============================================

Write-Host "=============================================" -ForegroundColor Green
Write-Host "MSDS数据库安装程序" -ForegroundColor Green
Write-Host "PowerShell兼容版本" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""

# 获取MySQL密码
$password = Read-Host "请输入MySQL root密码" -AsSecureString
$plainPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))

Write-Host ""
Write-Host "正在安装MSDS数据库结构..." -ForegroundColor Yellow
Write-Host ""

try {
    # 使用Get-Content和管道，避免重定向操作符
    Get-Content "install_msds_database.sql" | mysql -u root -p"$plainPassword"
    
    Write-Host ""
    Write-Host "=============================================" -ForegroundColor Green
    Write-Host "数据库安装成功！" -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "已创建数据库: msds_management" -ForegroundColor Cyan
    Write-Host "已创建基础表结构" -ForegroundColor Cyan
    Write-Host "已插入初始数据" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "您现在可以使用以下命令连接数据库:" -ForegroundColor Yellow
    Write-Host "mysql -u root -p" -ForegroundColor White
    Write-Host "use msds_management;" -ForegroundColor White
    Write-Host ""
    
} catch {
    Write-Host ""
    Write-Host "=============================================" -ForegroundColor Red
    Write-Host "数据库安装失败！" -ForegroundColor Red
    Write-Host "=============================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "错误信息: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "请检查:" -ForegroundColor Yellow
    Write-Host "1. MySQL服务是否正在运行" -ForegroundColor White
    Write-Host "2. root密码是否正确" -ForegroundColor White
    Write-Host "3. MySQL命令行工具是否在PATH中" -ForegroundColor White
    Write-Host "4. 文件编码是否正确" -ForegroundColor White
    Write-Host ""
}

Read-Host "按任意键继续..." 