#!/bin/bash
set -e

echo "=== 配置MySQL远程访问权限 ==="

# 等待MySQL完全启动
echo "等待MySQL服务启动..."
until mysql -u root -proot_password -e "SELECT 1" > /dev/null 2>&1; do
    echo "MySQL尚未就绪，等待中..."
    sleep 2
done

echo "MySQL服务已启动，开始配置远程访问权限..."

# 配置远程访问权限
mysql -u root -proot_password << 'EOF'
-- 允许msds_user从任何主机连接
GRANT ALL PRIVILEGES ON msds_dev.* TO 'msds_user'@'%' IDENTIFIED BY 'msds_dev_password';

-- 允许root用户从任何主机连接（仅用于管理）
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root_password';

-- 刷新权限
FLUSH PRIVILEGES;
EOF

if [ $? -eq 0 ]; then
    echo "✅ MySQL远程访问权限配置成功！"
else
    echo "❌ MySQL远程访问权限配置失败！"
    exit 1
fi

# 验证配置
echo "验证远程访问权限..."
mysql -u root -proot_password -e "SELECT user, host FROM mysql.user WHERE user IN ('msds_user', 'root');"

echo "=== 远程访问权限配置完成 ==="
