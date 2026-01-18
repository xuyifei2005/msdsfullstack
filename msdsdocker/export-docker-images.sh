#!/bin/bash

###############################################################################
# 导出Docker镜像为tar文件
###############################################################################

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== 导出Docker镜像 ===${NC}"
echo ""

# 创建导出目录
mkdir -p docker-images
cd docker-images

echo -e "${BLUE}导出镜像...${NC}"
echo ""

# 导出MySQL镜像
if docker image inspect msdsmysql > /dev/null 2>&1; then
    echo "导出 msdsmysql..."
    docker save msdsmysql -o msdsmysql.tar
    echo -e "${GREEN}✅ msdsmysql.tar${NC}"
else
    echo -e "${YELLOW}⚠️  msdsmysql镜像不存在，跳过${NC}"
fi

# 导出Redis镜像
if docker image inspect msdsredis > /dev/null 2>&1; then
    echo "导出 msdsredis..."
    docker save msdsredis -o msdsredis.tar
    echo -e "${GREEN}✅ msdsredis.tar${NC}"
else
    echo -e "${YELLOW}⚠️  msdsredis镜像不存在，跳过${NC}"
fi

# 导出后端镜像
if docker image inspect msdsbackend > /dev/null 2>&1; then
    echo "导出 msdsbackend..."
    docker save msdsbackend -o msdsbackend.tar
    echo -e "${GREEN}✅ msdsbackend.tar${NC}"
else
    echo -e "${YELLOW}⚠️  msdsbackend镜像不存在，跳过${NC}"
fi

# 导出Nginx镜像
if docker image inspect msdsnginx > /dev/null 2>&1; then
    echo "导出 msdsnginx..."
    docker save msdsnginx -o msdsnginx.tar
    echo -e "${GREEN}✅ msdsnginx.tar${NC}"
else
    echo -e "${YELLOW}⚠️  msdsnginx镜像不存在，跳过${NC}"
fi

echo ""
echo -e "${GREEN}=== 导出完成 ===${NC}"
echo ""

# 显示文件大小
echo -e "${BLUE}导出的文件：${NC}"
ls -lh *.tar 2>/dev/null || echo "没有找到任何tar文件"
echo ""

# 计算总大小
total_size=$(du -sh . 2>/dev/null | cut -f1)
echo -e "${BLUE}总大小: ${total_size}${NC}"
echo ""
