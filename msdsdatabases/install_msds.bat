@echo off
chcp 65001 >nul
echo =============================================
echo MSDS数据库安装程序
echo 解决编码和PowerShell兼容性问题
echo =============================================
echo.

set /p mysql_password=请输入MySQL root密码: 

echo.
echo 正在安装MSDS数据库结构...
echo.

mysql -u root -p%mysql_password% < install_msds_database.sql

if %errorlevel% equ 0 (
    echo.
    echo =============================================
    echo 数据库安装成功！
    echo =============================================
    echo.
    echo 已创建数据库: msds_management
    echo 已创建基础表结构
    echo 已插入初始数据
    echo.
    echo 您现在可以使用以下命令连接数据库:
    echo mysql -u root -p
    echo use msds_management;
    echo.
) else (
    echo.
    echo =============================================
    echo 数据库安装失败！
    echo =============================================
    echo.
    echo 请检查:
    echo 1. MySQL服务是否正在运行
    echo 2. root密码是否正确
    echo 3. MySQL命令行工具是否在PATH中
    echo.
)

pause 