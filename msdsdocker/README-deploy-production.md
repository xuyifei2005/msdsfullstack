# MSDS实验室管理系统 - 生产环境部署脚本使用说明

## 概述

`deploy-production.ps1` 是用于将MSDS实验室管理系统部署到生产环境的PowerShell脚本。该脚本自动化了整个部署流程，包括前端构建、文件上传、服务器配置和应用启动。

## 系统要求

### 本地环境
- Windows PowerShell 5.0 或更高版本
- SSH客户端 (OpenSSH)
- SCP客户端
- Docker 和 Docker Compose

### 服务器环境
- Linux 服务器 (Ubuntu/CentOS)
- SSH访问权限
- Docker 和 Docker Compose 已安装
- 必要的端口已开放 (80, 443, 3306, 6379等)

## 脚本参数

### 必需参数
- `ServerIP`: 目标服务器IP地址
- `ServerUser`: SSH登录用户名

### 可选参数
- `Domain`: 域名 (默认: localhost)
- `SkipBuild`: 跳过前端构建步骤
- `SkipUpload`: 跳过文件上传步骤
- `Force`: 强制执行，跳过确认提示

## 使用方法

### 基本用法
```powershell
.\deploy-production.ps1 -ServerIP "your.server.ip" -ServerUser "username"
```

### 指定域名
```powershell
.\deploy-production.ps1 -ServerIP "your.server.ip" -ServerUser "username" -Domain "yourdomain.com"
```

### 跳过前端构建
```powershell
.\deploy-production.ps1 -ServerIP "your.server.ip" -ServerUser "username" -SkipBuild
```

### 跳过文件上传（仅执行服务器端部署）
```powershell
.\deploy-production.ps1 -ServerIP "your.server.ip" -ServerUser "username" -SkipUpload
```

### 强制执行（跳过确认）
```powershell
.\deploy-production.ps1 -ServerIP "your.server.ip" -ServerUser "username" -Force
```

## 部署流程

脚本执行以下7个步骤：

1. **本地环境检查**: 验证必需的工具和配置文件
2. **前端构建**: 构建React前端应用（可跳过）
3. **服务器连接测试**: 测试SSH连接
4. **服务器目录准备**: 创建必要的目录结构
5. **文件上传**: 上传Docker配置和前端文件
6. **SSL证书检查**: 检查SSL证书是否存在
7. **远程部署执行**: 在服务器上执行部署脚本

## 配置文件要求

确保以下文件存在于当前目录：
- `docker-compose.prod.yml`: 生产环境Docker配置
- `.env.prod`: 生产环境变量配置
- `deploy.sh`: 服务器端部署脚本

## 前端构建

如果不跳过前端构建，脚本会：
1. 进入React项目目录
2. 安装依赖 (`npm install`)
3. 执行生产构建 (`npm run build`)
4. 打包构建结果

## 服务器端操作

脚本会在服务器上执行以下操作：
1. 创建项目目录 `/opt/msds`
2. 上传Docker配置文件
3. 上传前端构建文件（如果有）
4. 设置执行权限
5. 运行部署脚本
6. 检查容器状态

## 故障排除

### 常见问题

1. **SSH连接失败**
   - 检查服务器IP和用户名
   - 确认SSH密钥已配置
   - 检查防火墙设置

2. **前端构建失败**
   - 检查Node.js和npm版本
   - 清理node_modules重新安装
   - 使用 `-SkipBuild` 跳过构建

3. **文件上传失败**
   - 检查SCP权限
   - 确认服务器磁盘空间
   - 检查网络连接

4. **容器启动失败**
   - 检查Docker服务状态
   - 查看容器日志
   - 验证配置文件格式

### 日志查看

部署完成后，可以使用以下命令查看日志：
```bash
# 查看所有容器状态
docker ps

# 查看特定容器日志
docker logs msdsbackend
docker logs msdsfrontend
docker logs msdsmysql
docker logs msdsredis
docker logs msdsnginx

# 查看实时日志
docker logs -f msdsbackend
```

### 服务管理

```bash
# 重启服务
docker-compose -f docker-compose.prod.yml restart

# 停止服务
docker-compose -f docker-compose.prod.yml down

# 启动服务
docker-compose -f docker-compose.prod.yml up -d

# 查看服务状态
docker-compose -f docker-compose.prod.yml ps
```

## 安全注意事项

1. 确保SSH密钥安全存储
2. 定期更新服务器系统和Docker
3. 使用强密码和密钥认证
4. 限制SSH访问IP范围
5. 定期备份重要数据

## 支持

如遇问题，请检查：
1. 脚本输出的错误信息
2. 服务器端日志文件
3. Docker容器状态和日志
4. 网络连接和防火墙设置

---

**注意**: 首次部署前，请确保已正确配置所有必需的文件和环境变量。