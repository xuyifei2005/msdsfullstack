#!/bin/bash

###############################################################################
# 本地Docker镜像预构建脚本
# 用于在本地构建和准备所有需要的Docker镜像
###############################################################################

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== MSDS Docker镜像预构建脚本 ===${NC}"
echo ""

# 检查Docker是否运行
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}错误：Docker未运行，请先启动Docker${NC}"
    exit 1
fi

echo -e "${BLUE}步骤 1/5: 拉取MySQL镜像${NC}"
if docker image inspect msdsmysql > /dev/null 2>&1; then
    echo -e "${GREEN}✅ MySQL镜像已存在: msdsmysql${NC}"
else
    echo "拉取MySQL 8.0.42镜像..."
    docker pull mysql:8.0.42
    docker tag mysql:8.0.42 msdsmysql
    echo -e "${GREEN}✅ MySQL镜像准备完成${NC}"
fi
echo ""

echo -e "${BLUE}步骤 2/5: 拉取Redis镜像${NC}"
if docker image inspect msdsredis > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Redis镜像已存在: msdsredis${NC}"
else
    echo "拉取Redis latest镜像..."
    docker pull redis:latest
    docker tag redis:latest msdsredis
    echo -e "${GREEN}✅ Redis镜像准备完成${NC}"
fi
echo ""

echo -e "${BLUE}步骤 3/5: 构建后端Docker镜像${NC}"
cd msdsPC/ruoyi-MsdsPc-react
if docker image inspect msdsbackend > /dev/null 2>&1; then
    echo -e "${GREEN}✅ 后端镜像已存在: msdsbackend${NC}"
else
    echo "构建后端Docker镜像..."
    docker build -f Dockerfile.prod -t msdsbackend:latest .
    docker tag msdsbackend:latest msdsbackend
    echo -e "${GREEN}✅ 后端镜像构建完成${NC}"
fi
cd ../..
echo ""

echo -e "${BLUE}步骤 4/5: 构建Nginx前端镜像${NC}"
cd msdsPC/ruoyi-MsdsPc-react/react-ui
if docker image inspect msdsnginx > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Nginx镜像已存在: msdsnginx${NC}"
else
    echo "构建Nginx前端镜像..."
    docker build -f Dockerfile.nginx -t msdsnginx:latest .
    docker tag msdsnginx:latest msdsnginx
    echo -e "${GREEN}✅ Nginx镜像构建完成${NC}"
fi
cd ../..
echo ""

echo -e "${BLUE}步骤 5/5: 验证所有镜像${NC}"
echo ""
echo "已准备的Docker镜像："
docker images | grep -E "msdsnginx|msdsbackend|msdsmysql|msdsredis" || echo "未找到任何镜像"
echo ""

echo -e "${GREEN}=== 镜像预构建完成！ ===${NC}"
echo ""
echo -e "${YELLOW}下一步操作：${NC}"
echo "1. 将镜像导出为tar文件（可选）"
echo "   ./export-docker-images.sh"
echo ""
echo "2. 上传到服务器（可选）"
echo "   ./upload-docker-images.sh"
echo ""
echo "3. CI/CD构建时会自动使用这些镜像"
echo ""
