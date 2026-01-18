# Docker容器修复指南

## 🔍 问题诊断

### 当前容器状态

| 容器 | 状态 | 问题 |
|------|------|------|
| msdsnginx | `Created` | ❌ 容器已创建但未启动 |
| msdsbackend | `Restarting (1)` | ❌ 容器不断重启（退出码1） |
| msdsredis | `Up (healthy)` | ✅ 正常运行 |
| msdsmysql | `Up (healthy)` | ✅ 正常运行 |

### 问题分析

#### 问题1：后端容器启动失败

**原因**：
- Dockerfile构建的JAR文件名是`app.jar`
- docker-compose挂载的本地文件是`ruoyi-admin.jar`
- 启动命令检查的是`/app/ruoyi-admin.jar`而不是`app.jar`
- 导致JAR文件找不到，容器退出

**修复**：
- 移除JAR文件挂载
- 使用Dockerfile中构建的`app.jar`
- 修改启动命令使用正确的JAR文件名

#### 问题2：Nginx容器未启动

**原因**：
- 前端文件目录路径不正确
- 使用相对路径`../msdsPC/...`可能无法解析

**修复**：
- 修改为绝对路径`./nginx/html`
- 确保前端文件已复制到正确位置

#### 问题3：MySQL远程连接失败

**错误**：
```
Host '113.132.145.107' is not allowed to connect to this MySQL server
```

**原因**：
- MySQL默认只允许localhost连接
- 需要配置远程访问权限

**修复**：
- 执行SQL脚本配置远程访问权限
- 允许`msds_user`从任何主机连接

## 🚀 快速修复方案

### 方案1：使用自动修复脚本（推荐）

#### Linux服务器

```bash
# SSH登录到服务器
ssh root@39.107.211.72

# 进入项目目录
cd /opt/msds/msdsdocker

# 运行修复脚本
chmod +x fix-and-restart.sh
sudo ./fix-and-restart.sh
```

#### Windows本地

```powershell
# 先在本地构建镜像
cd msdsdocker
.\build-docker-images.ps1

# 提交代码并触发CI/CD
git add msdsdocker/docker-compose.prod.yml
git commit -m "fix: 修复容器启动失败问题"
git push
```

### 方案2：手动修复步骤

#### 步骤1：停止所有容器

```bash
cd /opt/msds/msdsdocker
docker-compose -f docker-compose.prod.yml down
```

#### 步骤2：配置MySQL远程访问权限

```bash
# 方法1：使用SQL脚本
docker exec msdsmysql mysql -u root -proot_password < msdsfullstatckcompose/msdsdatabaseinitdb/99-remote-access-setup.sql

# 方法2：直接执行SQL
docker exec msdsmysql mysql -u root -proot_password -e "
GRANT ALL PRIVILEGES ON msds_dev.* TO 'msds_user'@'%' IDENTIFIED BY 'msds_dev_password';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root_password';
FLUSH PRIVILEGES;
"
```

#### 步骤3：检查前端文件

```bash
# 确保前端文件存在
ls -la nginx/html/

# 如果不存在，从CI/CD上传
# 或手动复制
cp -r ../msdsPC/ruoyi-MsdsPc-react/react-ui/dist/* nginx/html/
```

#### 步骤4：启动所有服务

```bash
docker-compose -f docker-compose.prod.yml up -d
```

#### 步骤5：等待并检查状态

```bash
# 等待30秒让服务启动
sleep 30

# 检查容器状态
docker-compose -f docker-compose.prod.yml ps

# 查看日志
docker-compose -f docker-compose.prod.yml logs -f
```

## 🔧 详细修复说明

### 修复1：后端容器JAR文件问题

**修改前**（docker-compose.prod.yml）：
```yaml
volumes:
  - ../msdsPC/ruoyi-MsdsPc-react/ruoyi-admin/target/ruoyi-admin.jar:/app/ruoyi-admin.jar:ro
command: ["/bin/sh", "-c", "if [ -f '/app/ruoyi-admin.jar' ]; then ..."]
```

**修改后**（docker-compose.prod.yml）：
```yaml
volumes:
  # 移除JAR文件挂载，使用Dockerfile中构建的app.jar
  - backend_logs:/app/logs
  - backend_upload:/app/uploadPath
  - msdsmaven_repository:/root/.m2/repository
command: ["sh", "-c", "java ${JAVA_OPTS} -jar app.jar --spring.profiles.active=prod"]
```

**原因**：
- Dockerfile构建的JAR文件名是`app.jar`
- 不需要挂载本地JAR文件
- 直接使用镜像中构建的JAR文件

### 修复2：Nginx前端文件路径问题

**修改前**（docker-compose.prod.yml）：
```yaml
volumes:
  - ../msdsPC/ruoyi-MsdsPc-react/react-ui/dist:/usr/share/nginx/html:ro
```

**修改后**（docker-compose.prod.yml）：
```yaml
volumes:
  - ./nginx/html:/usr/share/nginx/html:ro
```

**原因**：
- 使用相对路径可能导致解析失败
- CI/CD会自动上传前端文件到`./nginx/html`
- 使用绝对路径更可靠

### 修复3：MySQL远程访问权限

**添加SQL脚本**（99-remote-access-setup.sql）：
```sql
-- 允许msds_user从任何主机连接
GRANT ALL PRIVILEGES ON msds_dev.* TO 'msds_user'@'%' IDENTIFIED BY 'msds_dev_password';

-- 允许root用户从任何主机连接
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root_password';

-- 刷新权限
FLUSH PRIVILEGES;
```

**执行方法**：
```bash
docker exec msdsmysql mysql -u root -proot_password < msdsfullstatckcompose/msdsdatabaseinitdb/99-remote-access-setup.sql
```

## 📊 验证修复结果

### 检查容器状态

```bash
docker-compose -f docker-compose.prod.yml ps
```

**期望输出**：
```
NAME         STATUS              PORTS
msdsnginx    Up                  0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp
msdsbackend  Up (healthy)        0.0.0.0:18080->8080/tcp
msdsredis    Up (healthy)        0.0.0.0:16379->6379/tcp
msdsmysql    Up (healthy)        0.0.0.0:3306->3306/tcp
```

### 检查后端日志

```bash
docker logs msdsbackend --tail 50
```

**期望输出**：
```
Starting MSDS Backend Service...
Started RuoYiApplication in X seconds
```

### 检查Nginx日志

```bash
docker logs msdsnginx --tail 50
```

**期望输出**：
```
nginx: configuration file /etc/nginx/nginx.conf test is successful
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

### 测试MySQL远程连接

```bash
# 从本地测试连接
mysql -h 39.107.211.72 -u msds_user -pmsds_dev_password msds_dev

# 或使用Navicat/DBeaver等工具
# 主机: 39.107.211.72
# 端口: 3306
# 用户: msds_user
# 密码: msds_dev_password
# 数据库: msds_dev
```

### 测试应用访问

```bash
# 测试HTTP
curl http://39.107.211.72

# 测试HTTPS
curl https://flymsds.cn

# 测试后端API
curl http://39.107.211.72:18080/actuator/health
```

## 🔍 故障排除

### 问题1：后端仍然重启

**诊断**：
```bash
# 查看详细日志
docker logs msdsbackend --tail 100

# 进入容器调试
docker exec -it msdsbackend sh

# 检查JAR文件
ls -la /app/

# 检查Java版本
java -version
```

**可能原因**：
- 数据库连接失败
- Redis连接失败
- 端口冲突
- 内存不足

### 问题2：Nginx仍然未启动

**诊断**：
```bash
# 查看详细日志
docker logs msdsnginx --tail 100

# 检查配置文件
docker exec msdsnginx nginx -t

# 检查前端文件
ls -la nginx/html/
```

**可能原因**：
- 配置文件错误
- SSL证书不存在
- 前端文件目录为空
- 端口被占用

### 问题3：MySQL仍然无法远程连接

**诊断**：
```bash
# 检查权限
docker exec msdsmysql mysql -u root -proot_password -e "SHOW GRANTS FOR 'msds_user'@'%'"

# 检查防火墙
firewall-cmd --list-all

# 检查端口监听
netstat -tuln | grep 3306
```

**可能原因**：
- 权限未正确配置
- 防火墙阻止连接
- 端口未正确映射

## 📝 最佳实践

1. **使用自动修复脚本**：快速解决常见问题
2. **定期检查日志**：及时发现和解决问题
3. **监控容器状态**：确保所有服务正常运行
4. **备份重要数据**：定期备份数据库和配置
5. **使用诊断脚本**：快速定位问题根源

## 🎯 下一步操作

1. **立即运行修复脚本**：
   ```bash
   cd /opt/msds/msdsdocker
   chmod +x fix-and-restart.sh
   sudo ./fix-and-restart.sh
   ```

2. **验证所有容器正常运行**：
   ```bash
   docker-compose -f docker-compose.prod.yml ps
   ```

3. **测试应用访问**：
   - HTTP: http://39.107.211.72
   - HTTPS: https://flymsds.cn
   - 后端API: http://39.107.211.72:18080/actuator/health

4. **提交修复到Git**：
   ```bash
   git add msdsdocker/docker-compose.prod.yml
   git add msdsdocker/msdsfullstatckcompose/msdsdatabaseinitdb/99-remote-access-setup.sql
   git commit -m "fix: 修复容器启动失败和MySQL远程访问问题"
   git push
   ```

## 📞 技术支持

如遇到问题，请运行诊断脚本：

```bash
cd /opt/msds/msdsdocker
chmod +x diagnose-containers.sh
./diagnose-containers.sh
```

诊断脚本会检查：
- 容器状态
- 服务日志
- 网络连接
- JAR文件
- Java环境
- 数据库连接
- Redis连接
- 端口占用
- Docker网络
