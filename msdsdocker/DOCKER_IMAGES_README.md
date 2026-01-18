# Docker镜像管理脚本使用指南

## 📋 概述

本目录包含Docker镜像管理脚本，用于本地构建、导出和上传Docker镜像到生产服务器。

## 🚀 快速开始

### 方案1：本地预构建镜像（推荐）

**优势**：
- ✅ 避免CI/CD DNS解析问题
- ✅ 加快CI/CD构建速度
- ✅ 减少网络依赖
- ✅ 提高部署可靠性

#### Windows环境

```powershell
# 1. 构建所有Docker镜像
cd msdsdocker
.\build-docker-images.ps1

# 2. 导出镜像为tar文件（可选）
.\export-docker-images.ps1

# 3. 上传到服务器（可选）
.\upload-docker-images.ps1
```

#### Linux环境

```bash
# 1. 构建所有Docker镜像
cd msdsdocker
chmod +x build-docker-images.sh
./build-docker-images.sh

# 2. 导出镜像为tar文件（可选）
chmod +x export-docker-images.sh
./export-docker-images.sh

# 3. 上传到服务器（可选）
# 使用export-and-upload-images.sh
```

### 方案2：CI/CD自动拉取（备用）

CI/CD工作流已配置为：
- 优先使用本地镜像
- 如果本地不存在，从Docker Hub拉取
- 自动标记镜像为项目需要的名称

**注意**：GitHub Actions可能无法访问国内镜像源，会使用Docker Hub官方源（速度较慢但可靠）。

## 📦 脚本说明

### build-docker-images.ps1 / build-docker-images.sh

**功能**：在本地构建所有需要的Docker镜像

**构建的镜像**：
1. `msdsmysql` - MySQL 8.0.42
2. `msdsredis` - Redis latest
3. `msdsbackend` - Spring Boot后端
4. `msdsnginx` - Nginx前端

**特点**：
- 自动检查镜像是否已存在
- 避免重复构建
- 显示构建进度

### export-docker-images.ps1 / export-docker-images.sh

**功能**：将本地Docker镜像导出为tar文件

**导出的文件**：
- `msdsmysql.tar` - MySQL镜像
- `msdsredis.tar` - Redis镜像
- `msdsbackend.tar` - 后端镜像
- `msdsnginx.tar` - Nginx镜像

**特点**：
- 自动创建导出目录
- 显示文件大小
- 计算总大小

### upload-docker-images.ps1

**功能**：上传Docker镜像tar文件到服务器

**上传到**：
- 服务器：39.107.211.72
- 用户：root
- 目录：/opt/msds/msdsdocker/images

**特点**：
- 自动创建服务器目录
- 显示上传进度
- 自动加载镜像到服务器
- 验证镜像加载结果

### setup-docker-mirror.ps1 / setup-docker-mirror.sh

**功能**：配置Docker国内镜像加速器

**配置的镜像源**：
1. 网易：https://hub-mirror.c.163.com
2. 腾讯云：https://mirror.ccs.tencentyun.com
3. 中科大：https://docker.mirrors.ustc.edu.cn
4. 七牛云：https://reg-mirror.qiniu.com

**适用场景**：
- 本地开发环境
- 生产服务器环境

## 🔧 使用场景

### 场景1：首次部署

```powershell
# Windows环境
cd msdsdocker
.\build-docker-images.ps1
.\export-docker-images.ps1
.\upload-docker-images.ps1

# Linux环境
cd msdsdocker
./build-docker-images.sh
./export-docker-images.sh
# 使用export-and-upload-images.sh上传
```

### 场景2：更新镜像

```powershell
# 只需要重新构建和上传
cd msdsdocker
.\build-docker-images.ps1
.\upload-docker-images.ps1
```

### 场景3：配置镜像加速

```powershell
# Windows本地
.\setup-docker-mirror.ps1

# Linux服务器
ssh root@39.107.211.72
cd /opt/msds/msdsdocker
chmod +x setup-docker-mirror.sh
sudo ./setup-docker-mirror.sh
```

### 场景4：CI/CD部署

```bash
# 提交代码并推送
git add .
git commit -m "feat: 更新代码"
git push

# CI/CD会自动：
# 1. 检查本地镜像是否存在
# 2. 如果不存在，从Docker Hub拉取
# 3. 构建后端和Nginx镜像
# 4. 导出并上传到服务器
# 5. 在服务器上加载镜像并启动服务
```

## 📊 镜像大小参考

| 镜像 | 大小 | 说明 |
|------|------|------|
| msdsmysql | ~500MB | MySQL 8.0.42 |
| msdsredis | ~100MB | Redis latest |
| msdsbackend | ~400MB | Spring Boot应用 |
| msdsnginx | ~50MB | Nginx + React前端 |
| **总计** | **~1.05GB** | 所有镜像 |

## 🔍 故障排除

### 问题1：Docker未运行

**错误**：
```
错误：Docker未运行，请先启动Docker Desktop
```

**解决方案**：
```powershell
# Windows
# 启动Docker Desktop

# Linux
sudo systemctl start docker
```

### 问题2：SSH连接失败

**错误**：
```
ssh: connect to host 39.107.211.72 port 22: Connection refused
```

**解决方案**：
```bash
# 检查服务器是否在线
ping 39.107.211.72

# 检查SSH服务是否运行
ssh root@39.107.211.72

# 检查防火墙设置
```

### 问题3：镜像构建失败

**错误**：
```
Error response from daemon: No such image
```

**解决方案**：
```powershell
# 清理Docker缓存
docker system prune -a

# 重新构建
.\build-docker-images.ps1
```

### 问题4：上传速度慢

**解决方案**：
```powershell
# 使用压缩上传
# 在upload-docker-images.ps1中添加压缩选项

# 或使用rsync（Linux）
rsync -avz --progress docker-images/ root@39.107.211.72:/opt/msds/msdsdocker/images/
```

## 📝 最佳实践

1. **定期更新镜像**：保持镜像为最新版本
2. **清理旧镜像**：定期清理不需要的镜像
3. **使用镜像加速**：配置国内镜像源加速拉取
4. **备份重要镜像**：导出重要镜像为tar文件
5. **监控镜像大小**：控制镜像大小，优化构建

## 🎯 工作流程

### 完整部署流程

```
1. 本地构建镜像
   ↓
2. 导出镜像为tar文件
   ↓
3. 上传到服务器
   ↓
4. 在服务器上加载镜像
   ↓
5. 使用docker-compose启动服务
```

### CI/CD部署流程

```
1. 代码提交到GitHub
   ↓
2. 触发GitHub Actions
   ↓
3. 检查本地镜像
   ↓
4. 拉取或构建镜像
   ↓
5. 导出并上传到服务器
   ↓
6. 在服务器上加载镜像
   ↓
7. 重启服务
```

## 📞 技术支持

如遇到问题，请检查：

1. Docker是否正常运行
2. 网络连接是否正常
3. SSH密钥是否配置正确
4. 服务器磁盘空间是否充足
5. 防火墙是否阻止连接

## 🔗 相关文档

- [Docker镜像加速器配置指南](./DOCKER_MIRROR_GUIDE.md)
- [部署说明](../aboutproject/部署实施/)
- [Docker Compose配置](./docker-compose.prod.yml)
