# MSDS系统SSL证书配置指南

## 概述

本指南将帮助您为MSDS实验室管理系统配置SSL证书，实现HTTPS安全访问。

## 配置方式

### 方式一：使用Let's Encrypt免费证书（推荐）

#### 1. 安装Certbot

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install certbot python3-certbot-nginx

# CentOS/RHEL
sudo yum install certbot python3-certbot-nginx

# Windows (使用Chocolatey)
choco install certbot
```

#### 2. 获取证书

```bash
# 为您的域名获取证书
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com

# 或者手动模式
sudo certbot certonly --manual -d yourdomain.com
```

#### 3. 配置自动续期

```bash
# 添加到crontab
sudo crontab -e

# 添加以下行（每天检查一次）
0 12 * * * /usr/bin/certbot renew --quiet
```

### 方式二：使用自签名证书（开发环境）

#### 1. 生成自签名证书

```bash
# 创建证书目录
mkdir -p ./nginx/ssl

# 生成私钥
openssl genrsa -out ./nginx/ssl/server.key 2048

# 生成证书签名请求
openssl req -new -key ./nginx/ssl/server.key -out ./nginx/ssl/server.csr

# 生成自签名证书
openssl x509 -req -days 365 -in ./nginx/ssl/server.csr -signkey ./nginx/ssl/server.key -out ./nginx/ssl/server.crt
```

#### 2. 配置信息示例

```
Country Name: CN
State: Beijing
City: Beijing
Organization: MSDS Lab
Organizational Unit: IT Department
Common Name: localhost (或您的域名)
Email: admin@yourdomain.com
```

### 方式三：使用商业证书

#### 1. 购买SSL证书

从以下证书颁发机构购买：
- DigiCert
- Comodo
- GeoTrust
- RapidSSL

#### 2. 证书文件准备

确保您有以下文件：
- `server.crt` - 服务器证书
- `server.key` - 私钥文件
- `ca-bundle.crt` - 中间证书（可选）

## Nginx配置

### 1. 更新Nginx配置文件

编辑 `./nginx/conf.d/default.conf`：

```nginx
# HTTP重定向到HTTPS
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;
    return 301 https://$server_name$request_uri;
}

# HTTPS配置
server {
    listen 443 ssl http2;
    server_name yourdomain.com www.yourdomain.com;

    # SSL证书配置
    ssl_certificate /etc/nginx/ssl/server.crt;
    ssl_certificate_key /etc/nginx/ssl/server.key;
    
    # SSL安全配置
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA384;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    
    # 安全头
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Frame-Options DENY always;
    add_header X-Content-Type-Options nosniff always;
    add_header X-XSS-Protection "1; mode=block" always;

    # 前端代理
    location / {
        proxy_pass http://msdsfrontend:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # API代理
    location /api/ {
        proxy_pass http://msdsbackend:8080/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # 验证码接口
    location /captchaImage {
        proxy_pass http://msdsbackend:8080/captchaImage;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # 文件上传
    location /profile/ {
        proxy_pass http://msdsbackend:8080/profile/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### 2. 更新Docker Compose配置

编辑 `docker-compose.yml`：

```yaml
services:
  msdsnginx:
    image: nginx:latest
    container_name: msdsnginx
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/conf.d:/etc/nginx/conf.d
      - ./nginx/ssl:/etc/nginx/ssl  # 添加SSL证书挂载
    depends_on:
      - msdsfrontend
      - msdsbackend
    networks:
      - msds-network
    restart: unless-stopped
```

## 域名配置

### 1. DNS配置

在您的域名服务商处配置DNS记录：

```
A记录：yourdomain.com -> 您的服务器IP
A记录：www.yourdomain.com -> 您的服务器IP
```

### 2. 本地测试（开发环境）

编辑hosts文件：

**Windows**: `C:\Windows\System32\drivers\etc\hosts`
**Linux/Mac**: `/etc/hosts`

添加：
```
127.0.0.1 yourdomain.com
127.0.0.1 www.yourdomain.com
```

## 部署步骤

### 1. 准备证书文件

```bash
# 创建SSL目录
mkdir -p ./nginx/ssl

# 复制证书文件到SSL目录
cp /path/to/your/server.crt ./nginx/ssl/
cp /path/to/your/server.key ./nginx/ssl/
```

### 2. 更新配置文件

```bash
# 备份原配置
cp ./nginx/conf.d/default.conf ./nginx/conf.d/default.conf.bak

# 使用新的HTTPS配置
# 编辑 ./nginx/conf.d/default.conf
```

### 3. 重启服务

```bash
# 重启Nginx容器
docker-compose restart msdsnginx

# 或重新部署整个系统
docker-compose down
docker-compose up -d
```

### 4. 验证配置

```bash
# 检查Nginx配置
docker exec msdsnginx nginx -t

# 检查SSL证书
openssl s_client -connect yourdomain.com:443 -servername yourdomain.com

# 测试HTTPS访问
curl -I https://yourdomain.com
```

## 安全最佳实践

### 1. 证书安全

- 私钥文件权限设置为600
- 定期更新证书
- 使用强密码保护私钥

### 2. Nginx安全配置

```nginx
# 隐藏Nginx版本
server_tokens off;

# 限制请求大小
client_max_body_size 100M;

# 超时设置
client_body_timeout 12;
client_header_timeout 12;
keepalive_timeout 15;
send_timeout 10;

# 限制连接数
limit_conn_zone $binary_remote_addr zone=conn_limit_per_ip:10m;
limit_conn conn_limit_per_ip 20;

# 限制请求频率
limit_req_zone $binary_remote_addr zone=req_limit_per_ip:10m rate=5r/s;
limit_req zone=req_limit_per_ip burst=10 nodelay;
```

### 3. 防火墙配置

```bash
# 开放HTTP和HTTPS端口
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# 关闭不必要的端口
sudo ufw deny 8080/tcp  # 直接访问后端
sudo ufw deny 8000/tcp  # 直接访问前端
```

## 故障排除

### 1. 常见问题

**证书错误**：
```bash
# 检查证书有效期
openssl x509 -in ./nginx/ssl/server.crt -text -noout | grep "Not After"

# 检查证书链
openssl verify -CAfile ca-bundle.crt server.crt
```

**配置错误**：
```bash
# 检查Nginx配置语法
docker exec msdsnginx nginx -t

# 查看Nginx错误日志
docker logs msdsnginx
```

**端口冲突**：
```bash
# 检查端口占用
netstat -tulpn | grep :443
```

### 2. 日志分析

```bash
# Nginx访问日志
docker exec msdsnginx tail -f /var/log/nginx/access.log

# Nginx错误日志
docker exec msdsnginx tail -f /var/log/nginx/error.log

# SSL握手日志
docker exec msdsnginx grep "SSL" /var/log/nginx/error.log
```

## 监控和维护

### 1. 证书监控

创建证书过期检查脚本：

```bash
#!/bin/bash
# check-ssl.sh

DOMAIN="yourdomain.com"
DAYS_WARN=30

EXPIRY_DATE=$(openssl s_client -connect $DOMAIN:443 -servername $DOMAIN 2>/dev/null | openssl x509 -noout -dates | grep "notAfter" | cut -d= -f2)
EXPIRY_EPOCH=$(date -d "$EXPIRY_DATE" +%s)
CURRENT_EPOCH=$(date +%s)
DAYS_LEFT=$(( ($EXPIRY_EPOCH - $CURRENT_EPOCH) / 86400 ))

if [ $DAYS_LEFT -lt $DAYS_WARN ]; then
    echo "WARNING: SSL certificate for $DOMAIN expires in $DAYS_LEFT days!"
    # 发送告警邮件或通知
fi
```

### 2. 性能监控

```bash
# SSL握手时间
curl -w "@curl-format.txt" -o /dev/null -s https://yourdomain.com

# 创建curl-format.txt
echo "time_namelookup:  %{time_namelookup}\n" > curl-format.txt
echo "time_connect:     %{time_connect}\n" >> curl-format.txt
echo "time_appconnect:  %{time_appconnect}\n" >> curl-format.txt
echo "time_pretransfer: %{time_pretransfer}\n" >> curl-format.txt
echo "time_total:       %{time_total}\n" >> curl-format.txt
```

## 总结

通过以上配置，您的MSDS系统将支持HTTPS安全访问。建议：

1. 生产环境使用Let's Encrypt或商业证书
2. 开发环境可使用自签名证书
3. 定期检查证书有效期
4. 保持Nginx和SSL配置的安全性
5. 监控SSL性能和安全性

如需帮助，请参考相关文档或联系技术支持。