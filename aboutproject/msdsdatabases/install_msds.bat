@echo off
chcp 65001 >nul
echo ========================================
echo MSDS实验室管理系统 - 数据库安装脚本
echo ========================================
echo.
echo 正在使用完整数据库文件: msds_complete_database.sql
echo.
echo 请确保MySQL服务已启动...
echo.
pause

echo 开始执行数据库初始化...
mysql -u root -p < msds_complete_database.sql

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo 数据库安装成功！
    echo ========================================
    echo.
    echo 数据库名称: msds_dev
    echo 默认管理员: admin / admin123
    echo 默认用户: msds_user / 123456
    echo.
    echo 详细说明请查看: README_完整数据库说明.md
    echo ========================================
) else (
    echo.
    echo ========================================
    echo 数据库安装失败！
    echo ========================================
    echo 请检查MySQL连接和权限设置
)

echo.
pause