@echo off
chcp 65001 >nul
echo ===============================================
echo MSDS PDF批量转XML工具 (Windows)
echo ===============================================
echo.

REM 检查Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未找到Python，请先安装Python 3.8+
    pause
    exit /b 1
)

REM 设置默认参数
set INPUT_DIR=..\aboutproject\doc
set OUTPUT_DIR=.\output
set WORKERS=4

REM 解析命令行参数
:parse_args
if "%~1"=="" goto start_convert
if "%~1"=="-i" (
    set INPUT_DIR=%~2
    shift
    shift
    goto parse_args
)
if "%~1"=="-o" (
    set OUTPUT_DIR=%~2
    shift
    shift
    goto parse_args
)
if "%~1"=="-w" (
    set WORKERS=%~2
    shift
    shift
    goto parse_args
)
if "%~1"=="-h" goto show_help
if "%~1"=="--help" goto show_help
shift
goto parse_args

:show_help
echo 用法: batch_convert.bat [选项]
echo.
echo 选项:
echo   -i DIR    输入PDF目录 (默认: ..\aboutproject\doc)
echo   -o DIR    输出XML目录 (默认: .\output)
echo   -w NUM    并行线程数 (默认: 4)
echo   -h        显示帮助信息
echo.
echo 示例:
echo   batch_convert.bat
echo   batch_convert.bat -i C:\pdfs -o C:\xmls -w 8
pause
exit /b 0

:start_convert
echo 配置信息:
echo   输入目录: %INPUT_DIR%
echo   输出目录: %OUTPUT_DIR%
echo   线程数: %WORKERS%
echo.

REM 检查输入目录
if not exist "%INPUT_DIR%" (
    echo [错误] 输入目录不存在: %INPUT_DIR%
    pause
    exit /b 1
)

REM 创建输出目录
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"
if not exist "logs" mkdir logs

echo 开始批量转换...
echo.

python batch_convert.py -i "%INPUT_DIR%" -o "%OUTPUT_DIR%" -w %WORKERS%

echo.
echo ===============================================
echo 批量转换完成
echo ===============================================
echo.
echo 输出目录: %OUTPUT_DIR%
echo 转换报告: %OUTPUT_DIR%\conversion_report.json
echo 日志文件: .\logs\pdf_to_xml.log
echo.

pause


