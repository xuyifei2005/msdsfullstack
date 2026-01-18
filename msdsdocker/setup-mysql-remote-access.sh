#!/bin/bash

###############################################################################
# 配置MySQL远程访问权限脚本（Linux服务器端）
# 用于在服务器上配置MySQL允许远程连接
###############################################################################

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== 配置MySQL远程访问权限 ===${NC}"
echo ""

# 检查是否为root用户
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}错误：此脚本需要root权限运行${NC}"
   echo "请使用: sudo $0"
   exit 1
fi

# 检查MySQL容器是否运行
if ! docker ps | grep -q "msdsmysql.*Up"; then
    echo -e "${RED}错误：MySQL容器未运行${NC}"
    echo "请先启动MySQL容器："
    echo "  docker-compose -f docker-compose.prod.yml up -d msdsmysql"
    exit 1
fi

echo -e "${BLUE}配置信息：${NC}"
echo "  数据库: msds_dev"
echo "  用户: msds_user"
echo "  密码: msds_dev_password"
echo "  允许的主机: % (所有主机)"
echo ""

# 询问确认
read -p "是否继续配置？(y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}配置已取消${NC}"
    exit 0
fi

echo -e "${BLUE}配置MySQL远程访问权限...${NC}"
echo ""

# 执行SQL配置
docker exec msdsmysql mysql -u root -proot_password << 'EOF'
-- 允许msds_user从任何主机连接
GRANT ALL PRIVILEGES ON msds_dev.* TO 'msds_user'@'%' IDENTIFIED BY 'msds_dev_password';

-- 允许root用户从任何主机连接（仅用于管理）
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root_password';

-- 刷新权限
FLUSH PRIVILEGES;

-- 验证权限
SELECT user, host FROM mysql.user WHERE user IN ('msds_user', 'root');

-- 显示当前连接权限
SHOW GRANTS FOR 'msds_user'@'%';
SHOW GRANTS FOR 'root'@'%';
EOF

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ MySQL远程访问权限配置成功！${NC}"
else
    echo -e "${RED}❌ MySQL权限配置失败！${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}=== 配置完成 ===${NC}"
echo ""
echo -e "${YELLOW}现在可以使用以下信息远程连接MySQL：${NC}"
echo "  主机: 39.107.211.72"
echo "  端口: 3306"
echo "  用户: msds_user"
echo "  密码: msds_dev_password"
echo "  数据库: msds_dev"
echo ""
echo -e "${YELLOW}测试连接命令：${NC}"
echo "  mysql -h 39.107.211.72 -u msds_user -pmsds_dev_password msds_dev"
echo ""
echo -e "${YELLOW}或使用Navicat/DBeaver等工具：${NC}"
echo "  主机: 39.107.211.72"
echo "  端口: 3306"
echo "  用户名: msds_user"
echo "  密码: msds_dev_password"
echo "  数据库: msds_dev"
echo ""
echo -e "${YELLOW}验证配置：${NC}"
echo "  docker exec msdsmysql mysql -u root -proot_password -e \"SELECT user, host FROM mysql.user WHERE user IN ('msds_user', 'root');\""
echo ""
