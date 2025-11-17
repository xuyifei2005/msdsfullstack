@echo off
chcp 65001 >nul
echo ================================================================================
echo MSDS PDF特定格式批量转换工具
echo 专门处理: (1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 类型PDF
echo ================================================================================
echo.

echo 请选择操作:
echo 1. 测试单个PDF文件转换
echo 2. 批量转换所有PDF文件
echo 3. 退出
echo.

set /p choice=请输入选择 (1-3): 

if "%choice%"=="1" (
    echo.
    echo 开始测试单个PDF文件转换...
    python test_specific_format.py
    echo.
    echo 测试完成！按任意键继续...
    pause >nul
    goto :menu
)

if "%choice%"=="2" (
    echo.
    echo 开始批量转换...
    python start_convert_specific.py
    echo.
    echo 转换完成！按任意键继续...
    pause >nul
    goto :menu
)

if "%choice%"=="3" (
    echo 退出程序
    exit /b 0
)

echo 无效选择，请重新输入
goto :menu

:menu
cls
goto :eof
