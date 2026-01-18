-- 配置MySQL远程访问权限
-- 允许特定IP或所有IP连接到MySQL数据库

-- 注意：在生产环境中，应该只允许特定的IP地址访问
-- 这里配置为允许所有IP（0.0.0.0/0），请根据实际需求修改

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
