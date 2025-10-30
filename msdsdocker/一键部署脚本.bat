@echo off
chcp 65001 >nul
echo ========================================
echo    MSDS系统生产环境一键部署脚本
echo    目标服务器: 39.107.211.72
echo    域名: flymsds.cn
echo ========================================
echo.

:: 设置变量
set SERVER_IP=39.107.211.72
set SERVER_USER=root
set PROJECT_ROOT=D:\XUYIFEI\XUPROJECTS\msdsfullstack
set FRONTEND_DIST=%PROJECT_ROOT%\msdsPC\ruoyi-MsdsPc-react\react-ui\dist
set DOCKER_DIR=%PROJECT_ROOT%\msdsdocker

:: 检查必要文件
echo [1/6] 检查本地文件...
if not exist "%FRONTEND_DIST%" (
    echo ❌ 前端构建产物不存在，请先执行前端构建
    echo 执行命令: cd %PROJECT_ROOT%\msdsPC\ruoyi-MsdsPc-react\react-ui && npm run build:prod
    pause
    exit /b 1
)

if not exist "%DOCKER_DIR%\docker-compose.prod.yml" (
    echo ❌ Docker配置文件不存在
    pause
    exit /b 1
)

if not exist "%DOCKER_DIR%\.env.prod" (
    echo ❌ 环境变量文件不存在，请先配置.env.prod
    pause
    exit /b 1
)

echo ✅ 本地文件检查完成

:: 询问是否继续
echo.
set /p CONTINUE="是否继续部署到生产服务器? (y/N): "
if /i not "%CONTINUE%"=="y" (
    echo 部署已取消
    pause
    exit /b 0
)

:: 上传Docker配置文件
echo.
echo [2/6] 上传Docker配置文件...
scp -r "%DOCKER_DIR%" %SERVER_USER%@%SERVER_IP%:/opt/msds/
if errorlevel 1 (
    echo ❌ Docker配置文件上传失败
    pause
    exit /b 1
)
echo ✅ Docker配置文件上传完成

:: 上传前端构建产物
echo.
echo [3/6] 上传前端构建产物...
scp -r "%FRONTEND_DIST%\*" %SERVER_USER%@%SERVER_IP%:/opt/msds/msdsdocker/nginx/html/
if errorlevel 1 (
    echo ❌ 前端文件上传失败
    pause
    exit /b 1
)
echo ✅ 前端文件上传完成

:: 检查SSL证书
echo.
echo [4/6] 检查SSL证书...
ssh %SERVER_USER%@%SERVER_IP% "ls -la /opt/msds/msdsdocker/nginx/ssl/"
if errorlevel 1 (
    echo ⚠️  SSL证书文件可能不存在，请手动上传证书文件
    echo 证书文件应位于: /opt/msds/msdsdocker/nginx/ssl/
    echo 需要文件: flymsds.cn.pem, flymsds.cn.key
    set /p CONTINUE_SSL="是否继续部署? (y/N): "
    if /i not "%CONTINUE_SSL%"=="y" (
        echo 部署已取消，请先上传SSL证书
        pause
        exit /b 1
    )
) else (
    echo ✅ SSL证书检查完成
)

:: 设置文件权限并部署
echo.
echo [5/6] 执行服务器部署...
ssh %SERVER_USER%@%SERVER_IP% "cd /opt/msds/msdsdocker && chmod +x deploy.sh backup-restore.sh && chmod 600 nginx/ssl/flymsds.cn.key 2>/dev/null; chmod 644 nginx/ssl/flymsds.cn.pem 2>/dev/null; ./deploy.sh"
if errorlevel 1 (
    echo ❌ 服务器部署失败
    pause
    exit /b 1
)

:: 验证部署结果
echo.
echo [6/6] 验证部署结果...
ssh %SERVER_USER%@%SERVER_IP% "docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}' | grep msds"
if errorlevel 1 (
    echo ⚠️  容器状态检查失败，请手动检查
) else (
    echo ✅ 容器状态检查完成
)

echo.
echo ========================================
echo 🎉 部署完成！
echo.
echo 访问地址:
echo   HTTP:  http://flymsds.cn
echo   HTTPS: https://flymsds.cn
echo.
echo 管理命令:
echo   查看容器状态: ssh %SERVER_USER%@%SERVER_IP% "docker ps"
echo   查看日志: ssh %SERVER_USER%@%SERVER_IP% "cd /opt/msds/msdsdocker && docker-compose -f docker-compose.prod.yml logs -f"
echo   重启服务: ssh %SERVER_USER%@%SERVER_IP% "cd /opt/msds/msdsdocker && docker-compose -f docker-compose.prod.yml restart"
echo ========================================
echo.
pause