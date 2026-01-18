# 配置MySQL远程访问权限脚本（Windows PowerShell）
# 用于在服务器上配置MySQL允许远程连接

# 服务器配置
$ServerHost = "39.107.211.72"
$ServerUser = "root"
$MySQLRootPassword = "root_password"
$MsdsUser = "msds_user"
$MsdsPassword = "msds_dev_password"
$Database = "msds_dev"

Write-Host "=== 配置MySQL远程访问权限 ===" -ForegroundColor Green
Write-Host ""

# 连接到服务器并配置MySQL
Write-Host "连接到服务器..." -ForegroundColor Cyan
Write-Host "服务器: $ServerHost" -ForegroundColor White
Write-Host ""

# 构建SQL命令
$sqlCommands = @"
-- 允许msds_user从任何主机连接
GRANT ALL PRIVILEGES ON $Database.* TO '$MsdsUser'@'%' IDENTIFIED BY '$MsdsPassword';

-- 允许root用户从任何主机连接（仅用于管理）
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MySQLRootPassword';

-- 刷新权限
FLUSH PRIVILEGES;

-- 验证权限
SELECT user, host FROM mysql.user WHERE user IN ('$MsdsUser', 'root');

-- 显示当前连接权限
SHOW GRANTS FOR '$MsdsUser'@'%';
SHOW GRANTS FOR 'root'@'%';
"@

# 执行SQL命令
Write-Host "配置MySQL远程访问权限..." -ForegroundColor Cyan
$sshCommand = "docker exec msdsmysql mysql -u root -p$MySQLRootPassword -e `"$sqlCommands`""

$sshResult = ssh $ServerUser@$ServerHost $sshCommand

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ MySQL远程访问权限配置成功！" -ForegroundColor Green
    Write-Host ""
    Write-Host "已配置的权限：" -ForegroundColor Cyan
    Write-Host "  - msds_user: 可以从任何主机连接到msds_dev数据库" -ForegroundColor White
    Write-Host "  - root: 可以从任何主机连接到所有数据库" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "❌ MySQL权限配置失败！" -ForegroundColor Red
    Write-Host "错误信息：" -ForegroundColor Yellow
    Write-Host $sshResult
    Write-Host ""
    exit 1
}

# 验证配置
Write-Host "验证配置..." -ForegroundColor Cyan
$verifyCommand = "docker exec msdsmysql mysql -u root -p$MySQLRootPassword -e `"SELECT user, host FROM mysql.user WHERE user IN ('$MsdsUser', 'root');`""

$verifyResult = ssh $ServerUser@$ServerHost $verifyCommand
Write-Host $verifyResult
Write-Host ""

Write-Host "=== 配置完成！ ===" -ForegroundColor Green
Write-Host ""
Write-Host "现在可以使用以下信息远程连接MySQL：" -ForegroundColor Cyan
Write-Host "  主机: $ServerHost" -ForegroundColor White
Write-Host "  端口: 3306" -ForegroundColor White
Write-Host "  用户: $MsdsUser" -ForegroundColor White
Write-Host "  密码: $MsdsPassword" -ForegroundColor White
Write-Host "  数据库: $Database" -ForegroundColor White
Write-Host ""
Write-Host "测试连接命令：" -ForegroundColor Cyan
Write-Host "  mysql -h $ServerHost -u $MsdsUser -p$MsdsPassword $Database" -ForegroundColor White
Write-Host ""
Write-Host "或使用Navicat/DBeaver等工具：" -ForegroundColor Cyan
Write-Host "  主机: $ServerHost" -ForegroundColor White
Write-Host "  端口: 3306" -ForegroundColor White
Write-Host "  用户名: $MsdsUser" -ForegroundColor White
Write-Host "  密码: $MsdsPassword" -ForegroundColor White
Write-Host "  数据库: $Database" -ForegroundColor White
Write-Host ""
