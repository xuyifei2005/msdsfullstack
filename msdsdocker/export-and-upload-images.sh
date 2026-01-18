#!/bin/bash

# MSDS Docker镜像导出和上传脚本
# 用于将本地Docker镜像导出并上传到服务器

set -e

# 配置信息
SERVER_HOST="39.107.211.72"
SERVER_USER="root"
SERVER_DIR="/opt/msds/msdsdocker/images"
LOCAL_DIR="./docker-images"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== MSDS Docker镜像导出和上传脚本 ===${NC}"
echo ""

# 创建本地临时目录
echo -e "${YELLOW}1. 创建本地临时目录...${NC}"
mkdir -p "$LOCAL_DIR"
echo "✅ 临时目录创建完成: $LOCAL_DIR"
echo ""

# 导出Docker镜像
echo -e "${YELLOW}2. 导出Docker镜像...${NC}"
echo "这可能需要几分钟，请耐心等待..."
echo ""

# 导出MySQL镜像
echo -e "${YELLOW}导出 msdsmysql:latest...${NC}"
docker save msdsmysql:latest -o "$LOCAL_DIR/msdsmysql.tar"
echo "✅ msdsmysql.tar 导出完成"

# 导出Redis镜像
echo -e "${YELLOW}导出 msdsredis:latest...${NC}"
docker save msdsredis:latest -o "$LOCAL_DIR/msdsredis.tar"
echo "✅ msdsredis.tar 导出完成"

# 导出Backend镜像
echo -e "${YELLOW}导出 msdsbackend:latest...${NC}"
docker save msdsbackend:latest -o "$LOCAL_DIR/msdsbackend.tar"
echo "✅ msdsbackend.tar 导出完成"

# 导出Nginx镜像
echo -e "${YELLOW}导出 msdsnginx:latest...${NC}"
docker save msdsnginx:latest -o "$LOCAL_DIR/msdsnginx.tar"
echo "✅ msdsnginx.tar 导出完成"

echo ""
echo -e "${GREEN}=== 镜像导出完成 ===${NC}"
ls -lh "$LOCAL_DIR"
echo ""

# 创建服务器目录
echo -e "${YELLOW}3. 创建服务器目录...${NC}"
ssh "$SERVER_USER@$SERVER_HOST" "mkdir -p $SERVER_DIR"
echo "✅ 服务器目录创建完成: $SERVER_DIR"
echo ""

# 上传镜像文件
echo -e "${YELLOW}4. 上传镜像文件到服务器...${NC}"
echo "这可能需要较长时间，取决于网络速度..."
echo ""

# 上传MySQL镜像
echo -e "${YELLOW}上传 msdsmysql.tar...${NC}"
scp "$LOCAL_DIR/msdsmysql.tar" "$SERVER_USER@$SERVER_HOST:$SERVER_DIR/"
echo "✅ msdsmysql.tar 上传完成"

# 上传Redis镜像
echo -e "${YELLOW}上传 msdsredis.tar...${NC}"
scp "$LOCAL_DIR/msdsredis.tar" "$SERVER_USER@$SERVER_HOST:$SERVER_DIR/"
echo "✅ msdsredis.tar 上传完成"

# 上传Backend镜像
echo -e "${YELLOW}上传 msdsbackend.tar...${NC}"
scp "$LOCAL_DIR/msdsbackend.tar" "$SERVER_USER@$SERVER_HOST:$SERVER_DIR/"
echo "✅ msdsbackend.tar 上传完成"

# 上传Nginx镜像
echo -e "${YELLOW}上传 msdsnginx.tar...${NC}"
scp "$LOCAL_DIR/msdsnginx.tar" "$SERVER_USER@$SERVER_HOST:$SERVER_DIR/"
echo "✅ msdsnginx.tar 上传完成"

echo ""
echo -e "${GREEN}=== 镜像上传完成 ===${NC}"

# 在服务器上加载镜像
echo -e "${YELLOW}5. 在服务器上加载Docker镜像...${NC}"
echo ""

ssh "$SERVER_USER@$SERVER_HOST" << 'ENDSSH'
cd /opt/msds/msdsdocker/images

echo "加载 msdsmysql.tar..."
docker load -i msdsmysql.tar
echo "✅ msdsmysql.tar 加载完成"

echo "加载 msdsredis.tar..."
docker load -i msdsredis.tar
echo "✅ msdsredis.tar 加载完成"

echo "加载 msdsbackend.tar..."
docker load -i msdsbackend.tar
echo "✅ msdsbackend.tar 加载完成"

echo "加载 msdsnginx.tar..."
docker load -i msdsnginx.tar
echo "✅ msdsnginx.tar 加载完成"

echo ""
echo "=== 验证镜像 ==="
docker images | grep -E "msdsnginx|msdsbackend|msdsmysql|msdsredis"
ENDSSH

echo ""
echo -e "${GREEN}=== 所有步骤完成！ ===${NC}"
echo ""
echo "现在可以运行以下命令启动服务："
echo "  cd /opt/msds/msdsdocker"
echo "  docker-compose -f docker-compose.prod.yml up -d"
echo ""

# 询问是否删除本地临时文件
read -p "是否删除本地临时文件? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}删除本地临时文件...${NC}"
    rm -rf "$LOCAL_DIR"
    echo "✅ 临时文件删除完成"
fi
