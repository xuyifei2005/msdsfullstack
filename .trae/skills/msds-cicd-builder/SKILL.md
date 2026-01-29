---
name: "msds-cicd-builder"
description: "Manages MSDS project CI/CD pipeline including frontend/backend builds, Docker image creation, and deployment to production/staging environments. Invoke when deploying code, building Docker images, or setting up CI/CD workflows."
---

# MSDS项目CI/CD构建技能

## 技能概述

本技能专门用于管理MSDS实验室管理系统的CI/CD构建流程，包括前端React应用构建、后端Spring Boot应用构建、Docker镜像创建以及部署到生产/测试环境。

## 核心功能

### 1. 前端构建流程

#### 1.1 环境准备
- **Node.js版本**: 18.x
- **包管理器**: npm
- **镜像源**: 使用国内镜像源加速依赖下载
```bash
npm config set registry https://registry.npmmirror.com
```

#### 1.2 构建步骤
1. **安装依赖**
   ```bash
   cd msdsPC/ruoyi-MsdsPc-react/react-ui
   npm ci
   ```

2. **代码检查**
   ```bash
   npm run lint
   npm run test -- --passWithNoTests
   ```

3. **生产构建**
   ```bash
   npm run build:prod
   ```

4. **构建产物**
   - 输出目录: `dist/`
   - 包含文件: 静态HTML、CSS、JS资源
   - 验证: 检查`dist/index.html`是否存在

#### 1.3 Docker镜像构建
- **Dockerfile**: `Dockerfile.nginx`
- **基础镜像**: `node:18-alpine` (构建阶段) + `nginx:alpine` (运行阶段)
- **多阶段构建**: 优化镜像大小
- **健康检查**: 内置健康检查端点

### 2. 后端构建流程

#### 2.1 环境准备
- **Java版本**: 17 (Temurin)
- **构建工具**: Maven 3.9
- **镜像源**: 使用阿里云Maven镜像

#### 2.2 Maven配置
创建`~/.m2/settings.xml`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0">
  <mirrors>
    <mirror>
      <id>aliyun</id>
      <mirrorOf>central</mirrorOf>
      <name>Aliyun Maven Mirror</name>
      <url>https://maven.aliyun.com/repository/public</url>
    </mirror>
  </mirrors>
</settings>
```

#### 2.3 构建步骤
1. **Maven构建**
   ```bash
   cd msdsPC/ruoyi-MsdsPc-react
   mvn clean package -Pprod -DskipTests -B
   ```

2. **构建产物**
   - 输出文件: `ruoyi-admin/target/ruoyi-admin.jar`
   - Profile: `prod`
   - 跳过测试: `-DskipTests`

#### 2.4 Docker镜像构建
- **Dockerfile**: `Dockerfile.prod`
- **基础镜像**: `maven:3.9-eclipse-temurin-17` (构建) + `eclipse-temurin:17-jre` (运行)
- **多阶段构建**: 分离构建和运行环境
- **安全配置**: 使用非root用户运行

### 3. Docker镜像管理

#### 3.1 镜像列表
- `msdsbackend:latest` - 后端Spring Boot应用
- `msdsnginx:latest` - 前端Nginx静态文件服务
- `msdsmysql:latest` - MySQL 8.0.42数据库
- `msdsredis:latest` - Redis缓存服务

#### 3.2 镜像构建命令
```bash
# 后端镜像
cd msdsPC/ruoyi-MsdsPc-react
docker build -f Dockerfile.prod -t msdsbackend:latest .

# 前端镜像
cd msdsPC/ruoyi-MsdsPc-react/react-ui
docker build -f Dockerfile.nginx -t msdsnginx:latest .

# MySQL镜像 (重新标记)
docker pull mysql:8.0.42
docker tag mysql:8.0.42 msdsmysql

# Redis镜像 (重新标记)
docker pull redis:latest
docker tag redis:latest msdsredis
```

#### 3.3 镜像导出/导入
```bash
# 导出镜像
docker save msdsmysql -o docker-images/msdsmysql.tar
docker save msdsredis -o docker-images/msdsredis.tar
docker save msdsbackend:latest -o docker-images/msdsbackend.tar
docker save msdsnginx:latest -o docker-images/msdsnginx.tar

# 导入镜像
docker load -i docker-images/msdsmysql.tar
docker load -i docker-images/msdsredis.tar
docker load -i docker-images/msdsbackend.tar
docker load -i docker-images/msdsnginx.tar
```

### 4. Docker Compose配置

#### 4.1 开发环境 (docker-compose.yml)
- **网络**: msds_network (bridge驱动)
- **服务**:
  - `msdsnginx`: 端口80:80, 443:443
  - `msdsbackend`: 端口18080:8080, 5005:5005 (调试), 2222:22 (SSH)
  - `msdsfrontend`: 端口3000:8000, 8000:8000, 2223:22 (SSH)
  - `msdsmysql`: 端口3306:3306
  - `msdsredis`: 端口16379:6379

#### 4.2 生产环境 (docker-compose.prod.yml)
- **网络**: msds_network (bridge驱动)
- **服务**:
  - `msdsnginx`: 端口80:80, 443:443 (HTTPS)
  - `msdsbackend`: 端口18080:8080
  - `msdsmysql`: 端口3306:3306
  - `msdsredis`: 端口16379:6379
  - `msdsdbinit`: 数据库初始化服务 (一次性)

#### 4.3 启动命令
```bash
# 开发环境
cd msdsdocker
docker-compose up -d

# 生产环境
cd msdsdocker
docker-compose -f docker-compose.prod.yml up -d

# 查看状态
docker-compose ps

# 查看日志
docker-compose logs -f [service_name]

# 停止服务
docker-compose stop
```

### 5. CI/CD工作流

#### 5.1 触发条件
- **生产环境**: push到`main`分支
- **测试环境**: push到`develop`分支
- **代码审查**: PR到`main`分支

#### 5.2 工作流阶段

##### 阶段1: 构建前端 (build-frontend)
1. 检出代码
2. 删除pdf2xml目录 (避免长文件名问题)
3. 设置Node.js环境
4. 配置npm镜像源
5. 安装依赖 (npm ci)
6. 运行Lint检查
7. 运行测试
8. 构建生产版本
9. 上传构建产物

##### 阶段2: 构建后端 (build-backend)
1. 检出代码
2. 删除pdf2xml目录
3. 设置Java环境
4. 配置Maven镜像源
5. Maven构建
6. 上传JAR文件

##### 阶段3: 构建Docker镜像 (build-docker-images)
1. 检出代码
2. 设置QEMU (多架构支持)
3. 设置Docker Buildx
4. 构建后端Docker镜像
5. 拉取并标记MySQL镜像
6. 拉取并标记Redis镜像
7. 构建Nginx前端镜像
8. 导出Docker镜像为tar文件
9. 上传Docker镜像

##### 阶段4: 上传配置 (upload-docker-config)
1. 检出代码
2. 创建服务器目录结构
3. 检查docker-compose.prod.yml文件
4. 上传docker-compose.prod.yml到服务器
5. 上传Nginx配置到服务器
6. 上传SSL证书到服务器
7. 校验Nginx配置存在
8. 上传数据库SQL到服务器
9. 验证文件上传

##### 阶段5: 部署到生产环境 (deploy-production)
1. 检出代码
2. 下载前端构建产物
3. 下载后端JAR文件
4. 下载Docker镜像
5. 上传Docker镜像到服务器
6. 部署到服务器
   - 诊断Docker环境
   - 加载Docker镜像
   - 备份当前版本
   - 停止服务
7. 上传前端文件到服务器
8. 解压并校验前端静态目录
9. 校验前端静态资源与权限
10. 上传后端JAR文件到服务器
11. 重启服务
    - 启动基础服务 (MySQL/Redis)
    - 等待MySQL就绪
    - 校验并初始化数据库
    - 启动后端服务
    - 等待后端健康
    - 启动Nginx
12. 校验Nginx本地健康与静态文件
13. 校验服务器本机端口访问
14. 健康检查
15. 发送部署通知

##### 阶段6: 部署到测试环境 (deploy-staging)
流程与生产环境类似，但使用不同的环境变量和配置

### 6. 部署验证

#### 6.1 健康检查端点
- **前端**: `http://flymsds.cn/health`
- **后端**: `http://flymsds.cn/prod-api/`
- **Nginx**: `http://127.0.0.1/health`

#### 6.2 服务状态检查
```bash
# 查看容器状态
docker ps -a | grep -E "msdsbackend|msdsnginx|msdsmysql|msdsredis"

# 查看容器日志
docker logs --tail=300 msdsbackend
docker logs --tail=200 msdsnginx

# 检查容器健康状态
docker inspect -f '{{.Name}} {{.State.Status}} {{if .State.Health}}{{.State.Health.Status}}{{end}}' msdsbackend
```

#### 6.3 数据库验证
```bash
# 检查数据库连接
docker exec msdsmysql mysqladmin ping -h 127.0.0.1 -uroot -proot_password --silent

# 检查数据库表
docker exec msdsmysql mysql -u root -proot_password -e "USE msds_dev; SHOW TABLES;"

# 检查系统表
docker exec msdsmysql mysql -u root -proot_password -e "SELECT COUNT(*) FROM msds_dev.sys_menu;"
```

### 7. 常见问题处理

#### 7.1 构建失败
- **前端**: 检查Node.js版本、依赖安装、构建脚本
- **后端**: 检查Java版本、Maven配置、依赖下载
- **Docker**: 检查Dockerfile语法、镜像可用性

#### 7.2 部署失败
- **镜像加载**: 检查tar文件完整性、Docker版本
- **服务启动**: 检查端口占用、配置文件、依赖关系
- **健康检查**: 检查服务日志、网络连接、数据库连接

#### 7.3 回滚方案
1. 停止当前服务
2. 恢复备份的JAR文件和前端文件
3. 重新加载Docker镜像
4. 重启服务
5. 验证服务健康状态

### 8. 最佳实践

#### 8.1 构建优化
- 使用多阶段构建减小镜像大小
- 利用Docker缓存层加速构建
- 使用国内镜像源加速依赖下载
- 并行构建前后端

#### 8.2 部署优化
- 使用健康检查确保服务就绪
- 实现零停机部署 (蓝绿部署)
- 自动化回滚机制
- 完善的日志记录和监控

#### 8.3 安全实践
- 使用非root用户运行容器
- 限制容器资源使用
- 使用SSL证书加密通信
- 定期更新基础镜像

### 9. 环境变量配置

#### 9.1 后端环境变量
```bash
SPRING_PROFILES_ACTIVE=prod
SPRING_DATASOURCE_URL=jdbc:mysql://msdsmysql:3306/msds_dev?useUnicode=true&characterEncoding=UTF-8&connectionCollation=utf8mb4_unicode_ci&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
SPRING_DATASOURCE_USERNAME=msds_user
SPRING_DATASOURCE_PASSWORD=msds_dev_password
SPRING_REDIS_HOST=msdsredis
SPRING_REDIS_PORT=6379
SPRING_REDIS_DATABASE=0
TZ=Asia/Shanghai
JAVA_OPTS=-Xms512m -Xmx2048m -XX:+UseG1GC -XX:+PrintGCDetails
```

#### 9.2 数据库环境变量
```bash
MYSQL_DATABASE=msds_dev
MYSQL_USER=msds_user
MYSQL_PASSWORD=msds_dev_password
MYSQL_ROOT_PASSWORD=root_password
TZ=Asia/Shanghai
```

### 10. 文件结构

```
msdsfullstack/
├── .github/workflows/
│   └── deploy.yml                    # CI/CD工作流配置
├── msdsdocker/
│   ├── docker-compose.yml             # 开发环境配置
│   ├── docker-compose.prod.yml        # 生产环境配置
│   ├── nginx/
│   │   ├── conf.d/
│   │   │   └── default.conf         # Nginx配置
│   │   ├── ssl/                     # SSL证书
│   │   ├── html/                    # 静态文件
│   │   └── logs/                    # 日志目录
│   └── mysql/
│       └── conf.d/                  # MySQL配置
├── msdsPC/ruoyi-MsdsPc-react/
│   ├── Dockerfile.prod               # 后端Dockerfile
│   └── react-ui/
│       ├── Dockerfile.nginx          # 前端Dockerfile
│       ├── nginx.prod.conf          # Nginx配置
│       └── package.json             # 前端依赖
└── aboutproject/msdsdatabases/
    └── msds_complete_database.sql   # 数据库初始化脚本
```

## 使用示例

### 示例1: 本地构建前端
```bash
cd msdsPC/ruoyi-MsdsPc-react/react-ui
npm ci
npm run build:prod
```

### 示例2: 本地构建后端
```bash
cd msdsPC/ruoyi-MsdsPc-react
mvn clean package -Pprod -DskipTests -B
```

### 示例3: 构建Docker镜像
```bash
cd msdsPC/ruoyi-MsdsPc-react
docker build -f Dockerfile.prod -t msdsbackend:latest .
cd react-ui
docker build -f Dockerfile.nginx -t msdsnginx:latest .
```

### 示例4: 启动开发环境
```bash
cd msdsdocker
docker-compose up -d
```

### 示例5: 部署到生产环境
```bash
# 通过GitHub Actions自动触发
git push origin main
```

## 注意事项

1. **镜像拉取策略**: 生产环境使用`pull_policy: never`，只使用本地镜像
2. **数据库初始化**: 首次启动时自动执行SQL脚本
3. **健康检查**: 所有服务都配置了健康检查，确保服务可用性
4. **日志管理**: 使用Docker卷持久化日志
5. **数据备份**: 部署前自动备份数据库和构建产物
6. **权限管理**: Nginx静态文件需要正确的读写权限
7. **SSL证书**: 生产环境需要有效的SSL证书
8. **端口映射**: 确保端口不冲突，生产环境使用标准端口

## 技能触发条件

当以下情况发生时，应调用此技能：

1. **代码部署**: 需要将代码部署到生产或测试环境
2. **Docker镜像构建**: 需要构建或更新Docker镜像
3. **CI/CD配置**: 需要配置或修改CI/CD工作流
4. **构建失败排查**: 前端或后端构建失败需要排查
5. **部署问题**: 部署过程中遇到问题需要解决
6. **环境搭建**: 需要搭建新的开发或生产环境
7. **服务健康检查**: 需要检查服务健康状态
8. **回滚操作**: 需要回滚到之前的版本
