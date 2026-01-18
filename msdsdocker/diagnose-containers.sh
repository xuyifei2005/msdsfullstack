#!/bin/bash

###############################################################################
# Docker容器诊断脚本
# 用于诊断容器启动失败问题
###############################################################################

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Docker容器诊断脚本 ===${NC}"
echo ""

# 检查Docker是否运行
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}错误：Docker未运行${NC}"
    exit 1
fi

echo -e "${BLUE}=== 1. 容器状态概览 ===${NC}"
docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

echo -e "${BLUE}=== 2. 后端容器日志（最近50行） ===${NC}"
if docker ps -a --format "{{.Names}}" | grep -q "msdsbackend"; then
    docker logs msdsbackend --tail 50 2>&1 || echo -e "${YELLOW}无法获取后端日志${NC}"
else
    echo -e "${YELLOW}msdsbackend容器不存在${NC}"
fi
echo ""

echo -e "${BLUE}=== 3. Nginx容器日志（最近50行） ===${NC}"
if docker ps -a --format "{{.Names}}" | grep -q "msdsnginx"; then
    docker logs msdsnginx --tail 50 2>&1 || echo -e "${YELLOW}无法获取Nginx日志${NC}"
else
    echo -e "${YELLOW}msdsnginx容器不存在${NC}"
fi
echo ""

echo -e "${BLUE}=== 4. 检查网络连接 ===${NC}"
echo "测试后端容器到MySQL的连接..."
if docker exec msdsbackend ping -c 2 msdsmysql > /dev/null 2>&1; then
    echo -e "${GREEN}✅ 后端可以连接到MySQL${NC}"
else
    echo -e "${RED}❌ 后端无法连接到MySQL${NC}"
fi

echo "测试后端容器到Redis的连接..."
if docker exec msdsbackend ping -c 2 msdsredis > /dev/null 2>&1; then
    echo -e "${GREEN}✅ 后端可以连接到Redis${NC}"
else
    echo -e "${RED}❌ 后端无法连接到Redis${NC}"
fi
echo ""

echo -e "${BLUE}=== 5. 检查JAR文件 ===${NC}"
if docker exec msdsbackend ls -lh /app/ruoyi-admin.jar > /dev/null 2>&1; then
    echo -e "${GREEN}✅ JAR文件存在${NC}"
    docker exec msdsbackend ls -lh /app/ruoyi-admin.jar
else
    echo -e "${RED}❌ JAR文件不存在${NC}"
fi
echo ""

echo -e "${BLUE}=== 6. 检查Java环境 ===${NC}"
if docker exec msdsbackend java -version > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Java环境正常${NC}"
    docker exec msdsbackend java -version 2>&1 | head -n 1
else
    echo -e "${RED}❌ Java环境异常${NC}"
fi
echo ""

echo -e "${BLUE}=== 7. 检查MySQL连接 ===${NC}"
if docker exec msdsbackend mysqladmin ping -h msdsmysql -u msds_user -pmsds_dev_password > /dev/null 2>&1; then
    echo -e "${GREEN}✅ 后端可以连接到MySQL${NC}"
else
    echo -e "${RED}❌ 后端无法连接到MySQL${NC}"
    echo "尝试直接从MySQL容器测试..."
    if docker exec msdsmysql mysqladmin ping -h localhost -u msds_user -pmsds_dev_password > /dev/null 2>&1; then
        echo -e "${GREEN}✅ MySQL内部连接正常${NC}"
    else
        echo -e "${RED}❌ MySQL内部连接失败${NC}"
    fi
fi
echo ""

echo -e "${BLUE}=== 8. 检查Redis连接 ===${NC}"
if docker exec msdsbackend redis-cli -h msdsredis ping > /dev/null 2>&1; then
    echo -e "${GREEN}✅ 后端可以连接到Redis${NC}"
else
    echo -e "${RED}❌ 后端无法连接到Redis${NC}"
fi
echo ""

echo -e "${BLUE}=== 9. 检查端口占用 ===${NC}"
echo "检查宿主机端口占用..."
netstat -tuln | grep -E ":(80|443|18080|3306|16379)" || echo "没有发现端口冲突"
echo ""

echo -e "${BLUE}=== 10. 检查Docker网络 ===${NC}"
docker network ls | grep msds || echo "未找到msds网络"
if docker network ls | grep -q msds; then
    docker network inspect msds_network | grep -A 5 "Containers"
fi
echo ""

echo -e "${GREEN}=== 诊断完成 ===${NC}"
echo ""
echo -e "${YELLOW}建议操作：${NC}"
echo "1. 查看完整日志: docker logs -f msdsbackend"
echo "2. 重启失败容器: docker restart msdsbackend msdsnginx"
echo "3. 进入容器调试: docker exec -it msdsbackend sh"
echo "4. 查看容器详情: docker inspect msdsbackend"
echo ""
