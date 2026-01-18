#!/bin/bash

###############################################################################
# 快速修复和重启脚本
# 用于修复容器启动失败问题
###############################################################################

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== MSDS容器快速修复脚本 ===${NC}"
echo ""

# 检查是否为root用户
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}错误：此脚本需要root权限运行${NC}"
   echo "请使用: sudo $0"
   exit 1
fi

# 进入项目目录
cd /opt/msds/msdsdocker

echo -e "${BLUE}步骤 1/5: 停止所有容器${NC}"
docker-compose -f docker-compose.prod.yml down
echo -e "${GREEN}✅ 所有容器已停止${NC}"
echo ""

echo -e "${BLUE}步骤 2/5: 配置MySQL远程访问权限${NC}"
docker exec msdsmysql mysql -u root -proot_password -e "
GRANT ALL PRIVILEGES ON msds_dev.* TO 'msds_user'@'%' IDENTIFIED BY 'msds_dev_password';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root_password';
FLUSH PRIVILEGES;
" 2>/dev/null || echo -e "${YELLOW}⚠️  MySQL容器未运行，跳过权限配置${NC}"
echo -e "${GREEN}✅ MySQL权限配置完成${NC}"
echo ""

echo -e "${BLUE}步骤 3/5: 检查前端文件${NC}"
if [ -d "./nginx/html" ]; then
    echo -e "${GREEN}✅ 前端文件目录存在${NC}"
    echo "文件数量: $(find ./nginx/html -type f | wc -l)"
else
    echo -e "${YELLOW}⚠️  前端文件目录不存在${NC}"
    echo "创建目录..."
    mkdir -p ./nginx/html
    echo -e "${GREEN}✅ 前端文件目录已创建${NC}"
fi
echo ""

echo -e "${BLUE}步骤 4/5: 检查SSL证书${NC}"
if [ -f "./nginx/ssl/flymsds.cn.pem" ] && [ -f "./nginx/ssl/flymsds.cn.key" ]; then
    echo -e "${GREEN}✅ SSL证书文件存在${NC}"
else
    echo -e "${YELLOW}⚠️  SSL证书文件不存在${NC}"
    echo "请将证书文件放置到: ./nginx/ssl/"
    echo "  - flymsds.cn.pem"
    echo "  - flymsds.cn.key"
fi
echo ""

echo -e "${BLUE}步骤 5/5: 启动所有服务${NC}"
docker-compose -f docker-compose.prod.yml up -d
echo -e "${GREEN}✅ 服务启动命令已执行${NC}"
echo ""

# 等待服务启动
echo -e "${YELLOW}等待服务启动（30秒）...${NC}"
sleep 30

echo ""
echo -e "${BLUE}=== 服务状态检查 ===${NC}"
echo ""

# 检查MySQL
if docker ps | grep -q "msdsmysql.*Up"; then
    echo -e "${GREEN}✅ MySQL: 运行中${NC}"
else
    echo -e "${RED}❌ MySQL: 未运行${NC}"
fi

# 检查Redis
if docker ps | grep -q "msdsredis.*Up"; then
    echo -e "${GREEN}✅ Redis: 运行中${NC}"
else
    echo -e "${RED}❌ Redis: 未运行${NC}"
fi

# 检查后端
if docker ps | grep -q "msdsbackend.*Up"; then
    echo -e "${GREEN}✅ Backend: 运行中${NC}"
else
    echo -e "${RED}❌ Backend: 未运行${NC}"
    echo -e "${YELLOW}查看后端日志: docker logs msdsbackend${NC}"
fi

# 检查Nginx
if docker ps | grep -q "msdsnginx.*Up"; then
    echo -e "${GREEN}✅ Nginx: 运行中${NC}"
else
    echo -e "${RED}❌ Nginx: 未运行${NC}"
    echo -e "${YELLOW}查看Nginx日志: docker logs msdsnginx${NC}"
fi

echo ""
echo -e "${BLUE}=== 端口监听状态 ===${NC}"
docker ps --format "table {{.Names}}\t{{.Ports}}"
echo ""

echo -e "${GREEN}=== 修复完成！ ===${NC}"
echo ""
echo -e "${YELLOW}下一步操作：${NC}"
echo "1. 查看服务状态: docker-compose -f docker-compose.prod.yml ps"
echo "2. 查看日志: docker-compose -f docker-compose.prod.yml logs -f [服务名]"
echo "3. 重启服务: docker-compose -f docker-compose.prod.yml restart [服务名]"
echo "4. 访问应用: http://39.107.211.72 或 https://flymsds.cn"
echo ""
echo -e "${YELLOW}如果后端仍然失败，请运行诊断脚本：${NC}"
echo "  ./diagnose-containers.sh"
echo ""
