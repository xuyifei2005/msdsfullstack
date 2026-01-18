#!/bin/bash

###############################################################################
# 配置Docker国内镜像加速器
# 适用于生产服务器
###############################################################################

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== 配置Docker国内镜像加速器 ===${NC}"
echo ""

# 检查是否为root用户
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}错误：此脚本需要root权限运行${NC}"
   echo "请使用: sudo $0"
   exit 1
fi

# 备份原配置
if [ -f /etc/docker/daemon.json ]; then
    echo -e "${YELLOW}备份原Docker配置...${NC}"
    cp /etc/docker/daemon.json /etc/docker/daemon.json.backup.$(date +%Y%m%d_%H%M%S)
    echo -e "${GREEN}✅ 备份完成${NC}"
fi

# 创建Docker配置目录
mkdir -p /etc/docker

# 写入新的Docker配置
echo -e "${YELLOW}配置Docker镜像加速器...${NC}"
cat > /etc/docker/daemon.json << 'EOF'
{
  "registry-mirrors": [
    "https://hub-mirror.c.163.com",
    "https://mirror.ccs.tencentyun.com",
    "https://docker.mirrors.ustc.edu.cn",
    "https://reg-mirror.qiniu.com"
  ],
  "max-concurrent-downloads": 10,
  "log-driver": "json-file",
  "log-level": "warn",
  "storage-driver": "overlay2",
  "live-restore": true
}
EOF

echo -e "${GREEN}✅ 配置文件已创建${NC}"

# 重启Docker服务
echo -e "${YELLOW}重启Docker服务...${NC}"
systemctl daemon-reload
systemctl restart docker

echo -e "${GREEN}✅ Docker服务已重启${NC}"

# 验证配置
echo ""
echo -e "${BLUE}=== 验证配置 ===${NC}"
docker info | grep -A 10 "Registry Mirrors"

echo ""
echo -e "${GREEN}=== 配置完成！ ===${NC}"
echo ""
echo -e "${BLUE}已配置的镜像加速器：${NC}"
echo "  1. 网易镜像: https://hub-mirror.c.163.com"
echo "  2. 腾讯云: https://mirror.ccs.tencentyun.com"
echo "  3. 中科大: https://docker.mirrors.ustc.edu.cn"
echo "  4. 七牛云: https://reg-mirror.qiniu.com"
echo ""
echo -e "${BLUE}测试镜像拉取速度：${NC}"
echo "  docker pull nginx:alpine"
echo ""
echo -e "${BLUE}查看Docker配置：${NC}"
echo "  cat /etc/docker/daemon.json"
echo ""
