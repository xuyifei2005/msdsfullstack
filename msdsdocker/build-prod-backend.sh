#!/bin/bash

# MSDS后端生产环境镜像构建脚本
# 使用多阶段构建，大幅减小镜像大小

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== MSDS后端生产环境镜像构建 ===${NC}"
echo ""

# 配置信息
PROJECT_DIR="../msdsPC/ruoyi-MsdsPc-react"
DOCKERFILE="$PROJECT_DIR/Dockerfile.prod"
IMAGE_NAME="msdsbackend:prod"
IMAGE_NAME_LATEST="msdsbackend:latest"

# 检查Dockerfile是否存在
if [ ! -f "$DOCKERFILE" ]; then
    echo -e "${RED}❌ Dockerfile.prod 不存在: $DOCKERFILE${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Dockerfile.prod 找到${NC}"
echo ""

# 进入项目目录
echo -e "${YELLOW}📁 进入项目目录: $PROJECT_DIR${NC}"
cd "$PROJECT_DIR"

# 构建生产环境镜像
echo -e "${YELLOW}🔨 开始构建生产环境镜像...${NC}"
echo "这可能需要几分钟，请耐心等待..."
echo ""

docker build -f Dockerfile.prod -t $IMAGE_NAME -t $IMAGE_NAME_LATEST .

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ 生产环境镜像构建成功！${NC}"
    echo ""
    
    # 显示镜像大小
    echo -e "${YELLOW}📊 镜像信息：${NC}"
    docker images | grep msdsbackend
    
    echo ""
    echo -e "${GREEN}🎯 预期大小：300-500MB（而不是9.08GB）${NC}"
    echo ""
    
    # 询问是否删除旧镜像
    OLD_IMAGE=$(docker images --format "{{.ID}}" msds_exported_backend 2>/dev/null)
    if [ -n "$OLD_IMAGE" ]; then
        echo -e "${YELLOW}⚠️  检测到旧的msds_exported_backend镜像${NC}"
        read -p "是否删除旧镜像? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            docker rmi msds_exported_backend
            echo -e "${GREEN}✅ 旧镜像已删除${NC}"
        fi
    fi
    
    echo ""
    echo -e "${GREEN}🚀 现在可以使用新镜像部署了！${NC}"
    echo ""
    echo "更新docker-compose.prod.yml中的镜像名称："
    echo "  image: msdsbackend:latest"
else
    echo ""
    echo -e "${RED}❌ 镜像构建失败！${NC}"
    exit 1
fi
