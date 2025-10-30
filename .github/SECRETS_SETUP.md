# GitHub Secrets 配置指南

## 概述

本文档指导您如何配置MSDS实验室管理系统CI/CD流水线所需的GitHub Secrets。

## 必需的Secrets

### 1. 阿里云容器镜像服务

```
ALIYUN_REGISTRY_USERNAME
ALIYUN_REGISTRY_PASSWORD
```

**配置步骤：**
1. 登录阿里云控制台
2. 进入容器镜像服务
3. 创建命名空间：`msds`
4. 获取访问凭证
5. 在GitHub仓库设置中添加Secrets

### 2. 生产环境服务器

```
PRODUCTION_HOST=your-production-server.com
PRODUCTION_USER=deploy
PRODUCTION_SSH_KEY=-----BEGIN OPENSSH PRIVATE KEY-----
...
-----END OPENSSH PRIVATE KEY-----
```

**配置步骤：**
1. 在生产服务器创建部署用户
2. 生成SSH密钥对
3. 将公钥添加到服务器的authorized_keys
4. 将私钥添加到GitHub Secrets

### 3. 测试环境服务器（可选）

```
STAGING_HOST=your-staging-server.com
STAGING_USER=deploy
STAGING_SSH_KEY=-----BEGIN OPENSSH PRIVATE KEY-----
...
-----END OPENSSH PRIVATE KEY-----
```

## 配置方法

### 在GitHub仓库中添加Secrets

1. 进入GitHub仓库页面
2. 点击 `Settings` 选项卡
3. 在左侧菜单中选择 `Secrets and variables` > `Actions`
4. 点击 `New repository secret`
5. 输入Secret名称和值
6. 点击 `Add secret`

### 生产服务器准备

#### 1. 创建部署用户

```bash
# 在生产服务器上执行
sudo useradd -m -s /bin/bash deploy
sudo usermod -aG docker deploy
sudo mkdir -p /home/deploy/.ssh
sudo chown deploy:deploy /home/deploy/.ssh
sudo chmod 700 /home/deploy/.ssh
```

#### 2. 生成SSH密钥

```bash
# 在本地执行
ssh-keygen -t rsa -b 4096 -C "deploy@msds" -f ~/.ssh/msds_deploy
```

#### 3. 配置SSH访问

```bash
# 将公钥复制到服务器
ssh-copy-id -i ~/.ssh/msds_deploy.pub deploy@your-server.com

# 或手动添加
cat ~/.ssh/msds_deploy.pub | ssh deploy@your-server.com "cat >> ~/.ssh/authorized_keys"
```

#### 4. 准备部署目录

```bash
# 在生产服务器上执行
sudo mkdir -p /opt/msds/msdsdocker
sudo chown -R deploy:deploy /opt/msds
cd /opt/msds

# 克隆项目（如果还没有）
git clone https://github.com/your-username/msdsfullstack.git
cd msdsfullstack/msdsdocker

# 复制配置文件
cp .env.example .env.prod
# 编辑配置文件
nano .env.prod
```

### 阿里云容器镜像服务配置

#### 1. 创建命名空间

1. 登录阿里云控制台
2. 进入容器镜像服务
3. 选择个人实例或企业版实例
4. 创建命名空间：`msds`

#### 2. 获取访问凭证

1. 在容器镜像服务控制台
2. 点击右上角头像 > AccessKey管理
3. 创建AccessKey（用作用户名和密码）

#### 3. 配置镜像仓库

```bash
# 镜像仓库地址格式
registry.cn-hangzhou.aliyuncs.com/msds/msds-backend
registry.cn-hangzhou.aliyuncs.com/msds/msds-frontend
```

## 环境变量配置

### 生产环境 (.env.prod)

```bash
# 数据库配置
MYSQL_ROOT_PASSWORD=your_secure_root_password
MYSQL_DATABASE=msds_prod
MYSQL_USER=msds_user
MYSQL_PASSWORD=your_secure_password

# Redis配置
REDIS_PASSWORD=your_redis_password

# 应用配置
SPRING_PROFILES_ACTIVE=prod
SERVER_PORT=8080

# 镜像配置
BACKEND_IMAGE=registry.cn-hangzhou.aliyuncs.com/msds/msds-backend:latest
FRONTEND_IMAGE=registry.cn-hangzhou.aliyuncs.com/msds/msds-frontend:latest

# 域名配置
DOMAIN=flymsds.cn
```

## 安全最佳实践

### 1. SSH密钥安全

- 使用强密码保护私钥
- 定期轮换SSH密钥
- 限制SSH访问IP范围
- 禁用密码登录

### 2. 数据库安全

- 使用强密码
- 限制数据库访问IP
- 定期备份数据
- 启用SSL连接

### 3. 容器安全

- 使用非root用户运行容器
- 定期更新基础镜像
- 扫描镜像漏洞
- 限制容器权限

## 验证配置

### 1. 测试SSH连接

```bash
ssh -i ~/.ssh/msds_deploy deploy@your-server.com
```

### 2. 测试Docker访问

```bash
ssh deploy@your-server.com "docker ps"
```

### 3. 测试镜像推送

```bash
docker login registry.cn-hangzhou.aliyuncs.com
docker tag hello-world registry.cn-hangzhou.aliyuncs.com/msds/test:latest
docker push registry.cn-hangzhou.aliyuncs.com/msds/test:latest
```

## 故障排查

### 常见问题

1. **SSH连接失败**
   - 检查SSH密钥格式
   - 验证服务器防火墙设置
   - 确认用户权限

2. **Docker权限问题**
   - 确认用户在docker组中
   - 重新登录或重启Docker服务

3. **镜像推送失败**
   - 检查阿里云访问凭证
   - 验证镜像仓库地址
   - 确认网络连接

### 日志查看

```bash
# GitHub Actions日志
# 在GitHub仓库的Actions选项卡中查看

# 服务器部署日志
ssh deploy@your-server.com "docker-compose -f /opt/msds/msdsdocker/docker-compose.prod.yml logs"
```

## 联系支持

如果遇到配置问题，请：

1. 检查本文档的故障排查部分
2. 查看GitHub Actions运行日志
3. 联系系统管理员

---

**注意：** 请妥善保管所有密钥和密码，不要在代码中硬编码敏感信息。