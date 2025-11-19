# MSDS文件管理系统 - 项目打包部署说明

## 📋 项目概述

MSDS文件管理系统是一个基于Spring Boot + React的全栈项目，专为实验室科研机构设计的化学品安全技术说明书电子化管理系统。

### 技术栈

- **后端**: Spring Boot 3.3.0 + Java 17 + MyBatis + MySQL 8.0
- **前端**: React 18 + Ant Design Pro 6.0 + UmiJS 4.0
- **容器化**: Docker + Docker Compose
- **反向代理**: Nginx
- **缓存**: Redis
- **构建工具**: Maven 3.x + npm/yarn

---

## 🏗️ 运行环境要求

### 开发环境

- **Java**: JDK 17+
- **Node.js**: 18.0.0+
- **npm**: 8.0.0+
- **Maven**: 3.6+
- **Docker**: 20.10+
- **Docker Compose**: 2.0+

### 生产环境

- **操作系统**: Linux/Windows Server
- **内存**: 最低4GB，推荐8GB+
- **存储**: 最低20GB可用空间
- **网络**: 支持HTTP/HTTPS访问

---

## ⚙️ 配置文件修改

### 1. 后端配置修改

#### 数据库配置

位置: `msdsPC/ruoyi-MsdsPc-react/ruoyi-admin/src/main/resources/application-dev.yml`

```yaml
# 数据源配置
spring:
  datasource:
    type: com.alibaba.druid.pool.DruidDataSource
    driverClassName: com.mysql.cj.jdbc.Driver
    druid:
      # 主库数据源
      master:
        url: jdbc:mysql://localhost:3306/msds_dev?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8
        username: msds_user
        password: msds_dev_password
```

#### Redis配置

```yaml
# Redis配置
redis:
  host: localhost
  port: 6379
  password: 
  database: 0
  timeout: 10s
  lettuce:
    pool:
      min-idle: 0
      max-idle: 8
      max-active: 8
      max-wait: -1ms
```

#### 文件上传配置

```yaml
# 文件上传
ruoyi:
  # 名称
  name: MSDS管理系统
  # 版本
  version: 3.8.8
  # 版权年份
  copyrightYear: 2024
  # 文件路径 示例（ Windows配置D:/ruoyi/uploadPath，Linux配置 /home/ruoyi/uploadPath）
  profile: D:/ruoyi/uploadPath
  # 获取ip地址开关
  addressEnabled: false
  # 验证码类型 math 数字计算 char 字符验证
  captchaType: math
```

### 2. 前端配置修改

#### API接口配置

位置: `msdsPC/ruoyi-MsdsPc-react/react-ui/config/config.ts`

```typescript
export default defineConfig({
  // 开发环境配置
  define: {
    REACT_APP_ENV: process.env.REACT_APP_ENV || false,
  },
  // API代理配置
  proxy: {
    '/api': {
      target: 'http://localhost:8080',
      changeOrigin: true,
      pathRewrite: { '^/api': '' },
    },
  },
});
```

#### 环境变量配置

位置: `msdsPC/ruoyi-MsdsPc-react/react-ui/.env.development`

```bash
# 开发环境配置
REACT_APP_ENV=dev
REACT_APP_API_URL=http://localhost:8080
REACT_APP_BASE_API=/api
```

### 3. Docker配置修改

#### 生产环境配置

位置: `msdsdocker/docker-compose.yml`

关键配置项：

- 数据库连接信息
- Redis连接信息
- 文件存储路径
- 端口映射
- 环境变量

---

## 📦 前后端打包详细说明

### 1. 后端打包步骤

#### 1.1 环境准备

```bash
# 检查Java版本
java -version

# 检查Maven版本
mvn -version

# 进入后端项目目录
cd d:\XUYIFEI\XUPROJECTS\msdsfullstack\msdsPC\ruoyi-MsdsPc-react
```

#### 1.2 清理和编译

```bash
# 清理之前的构建
mvn clean

# 编译项目（跳过测试）
mvn compile -DskipTests

# 运行测试（可选）
mvn test

# 打包项目
mvn package -DskipTests
```

#### 1.3 生成可执行JAR

```bash
# 完整打包命令
mvn clean package -DskipTests -Pprod

# 打包后的文件位置
# ruoyi-admin/target/ruoyi-admin.jar
```

#### 1.4 验证打包结果

```bash
# 检查JAR文件
ls -la ruoyi-admin/target/ruoyi-admin.jar

# 测试运行（可选）
java -jar ruoyi-admin/target/ruoyi-admin.jar --spring.profiles.active=dev
```

### 2. 前端打包步骤

#### 2.1 环境准备

```bash
# 检查Node.js版本
node -v

# 检查npm版本
npm -v

# 进入前端项目目录
cd d:\XUYIFEI\XUPROJECTS\msdsfullstack\msdsPC\ruoyi-MsdsPc-react\react-ui
```

#### 2.2 安装依赖

```bash
# 清理node_modules（如果存在）
rm -rf node_modules package-lock.json

# 安装依赖
npm install

# 或使用yarn
yarn install
```

#### 2.3 构建生产版本

```bash
# 生产环境构建
npm run build

# 或使用yarn
yarn build

# 构建后的文件位置
# dist/ 目录包含所有静态资源
```

#### 2.4 验证构建结果

```bash
# 检查构建文件
ls -la dist/

# 本地预览（可选）
npm run preview
```

### 3. 静态资源优化

#### 3.1 前端资源压缩

```bash
# 启用Gzip压缩构建
npm run build -- --analyze

# 检查包大小分析
npm run analyze
```

#### 3.2 图片和字体优化

- 压缩图片资源
- 使用WebP格式
- 字体文件子集化

---

## 🐳 Docker容器化部署

### 1. 构建Docker镜像

#### 1.1 后端镜像构建

```bash
# 进入Docker配置目录
cd d:\XUYIFEI\XUPROJECTS\msdsfullstack\msdsdocker

# 构建后端镜像
docker build -t msdsbackend:latest -f Dockerfile.backend ../msdsPC/ruoyi-MsdsPc-react
```

#### 1.2 前端镜像构建

```bash
# 构建前端镜像
docker build -t msdsfrontend:latest -f Dockerfile.frontend ../msdsPC/ruoyi-MsdsPc-react/react-ui
```

#### 1.3 数据库镜像准备

```bash
# 构建MySQL镜像（包含初始化脚本）
docker build -t msdsmysql:latest -f Dockerfile.mysql .

# 构建Redis镜像
docker build -t msdsredis:latest -f Dockerfile.redis .
```

### 2. 容器编排部署

#### 2.1 启动完整服务栈

```bash
# 启动所有服务
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f
```

#### 2.2 服务健康检查

```bash
# 检查后端服务
curl http://localhost:8080/actuator/health

# 检查前端服务
curl http://localhost:3000

# 检查数据库连接
docker-compose exec msdsmysql mysql -u msds_user -p msds_dev
```

### 3. 生产环境部署

#### 3.1 环境变量配置

```bash
# 创建生产环境配置文件
cp .env.example .env.production

# 编辑生产环境变量
vim .env.production
```

#### 3.2 SSL证书配置

```bash
# 配置SSL证书
mkdir -p nginx/ssl
cp your-cert.pem nginx/ssl/
cp your-key.pem nginx/ssl/

# 更新Nginx配置
vim nginx/nginx.conf
```

#### 3.3 数据备份策略

```bash
# 数据库备份脚本
./dockerbackupok/export_msds_containers.ps1

# 定期备份计划
crontab -e
# 添加: 0 2 * * * /path/to/backup-script.sh
```

---

## 🚀 部署验证

### 1. 功能测试

- [ ] 用户登录功能
- [ ] MSDS文件上传
- [ ] 文件搜索和下载
- [ ] 权限管理
- [ ] 系统监控

### 2. 性能测试

- [ ] 并发用户测试
- [ ] 文件上传性能
- [ ] 数据库查询性能
- [ ] 内存和CPU使用率

### 3. 安全检查

- [ ] SQL注入防护
- [ ] XSS防护
- [ ] 文件上传安全
- [ ] 访问权限控制

---

## 🔧 常见问题解决

### 1. 构建问题

#### Maven构建失败

```bash
# 清理Maven缓存
mvn dependency:purge-local-repository

# 重新下载依赖
mvn clean install -U
```

#### npm构建失败

```bash
# 清理npm缓存
npm cache clean --force

# 删除node_modules重新安装
rm -rf node_modules package-lock.json
npm install
```

### 2. 运行时问题

#### 数据库连接失败

- 检查数据库服务状态
- 验证连接参数
- 检查防火墙设置

#### 文件上传失败

- 检查文件存储路径权限
- 验证文件大小限制
- 检查磁盘空间

### 3. Docker问题

#### 容器启动失败

```bash
# 查看详细日志
docker-compose logs [service-name]

# 检查容器状态
docker ps -a

# 重启服务
docker-compose restart [service-name]
```

---

## 📊 监控和维护

### 1. 日志管理

- 应用日志: `/app/logs/`
- Nginx日志: `/var/log/nginx/`
- 数据库日志: `/var/log/mysql/`

### 2. 性能监控

- JVM监控: JVisualVM/JProfiler
- 数据库监控: MySQL Workbench
- 系统监控: htop/iostat

### 3. 定期维护

- 数据库优化和清理
- 日志文件轮转
- 安全补丁更新
- 依赖版本升级

---

## 📞 技术支持

如遇到部署问题，请按以下步骤排查：

1. 检查系统环境和依赖版本
2. 查看详细错误日志
3. 验证配置文件正确性
4. 检查网络和防火墙设置
5. 联系技术支持团队

---

**最后更新**: 2025年1月27日
**文档版本**: v1.0.0
**维护人员**: MSDS开发团队

---

🚌打包前部署配置文件调整修改：

@@@打包补充：

让我查看前后端配置文件，以便修改域名相关配置。

toolName: view_files

status: success

filePath: d:\XUYIFEI\XUPROJECTS\msdsfullstack\msdsPC\ruoyi-MsdsPc-react\ruoyi-admin\src\main\resources\application-prod.yml
d:\XUYIFEI\XUPROJECTS\msdsfullstack\msdsPC\ruoyi-MsdsPc-react\react-ui\config\config.ts

让我查看application.yml和application-dev.yml文件，以便了解配置结构。

toolName: view_files

status: success

filePath: d:\XUYIFEI\XUPROJECTS\msdsfullstack\msdsPC\ruoyi-MsdsPc-react\ruoyi-admin\src\main\resources\application.yml
d:\XUYIFEI\XUPROJECTS\msdsfullstack\msdsPC\ruoyi-MsdsPc-react\ruoyi-admin\src\main\resources\application-dev.yml

让我查看application-druid.yml文件，因为在application.yml中指定了active profile为druid。

toolName: view_files

status: success

filePath: d:\XUYIFEI\XUPROJECTS\msdsfullstack\msdsPC\ruoyi-MsdsPc-react\ruoyi-admin\src\main\resources\application-druid.yml

让我创建生产环境配置文件，并修改相关配置以支持域名访问。

toolName: write_to_file

status: success

filePath: d:\XUYIFEI\XUPROJECTS\msdsfullstack\msdsPC\ruoyi-MsdsPc-react\ruoyi-admin\src\main\resources\application-prod.yml

content: # 项目相关配置
ruoyi:

# 名称

  name: MSDS管理系统

# 版本

  version: 3.8.8

# 版权年份

  copyrightYear: 2024

# 文件路径

  profile: /app/uploadPath

# 获取ip地址开关

  addressEnabled: true

# 验证码类型 math 数字计算 char 字符验证

  captchaType: math

# 开发环境配置

server:

# 服务器的HTTP端口，默认为8080

  port: 8080
  servlet:
    # 应用的访问路径
    context-path: /
  tomcat:
    # tomcat的URI编码
    uri-encoding: UTF-8
    # 连接数满后的排队数，默认为100
    accept-count: 1000
    threads:
      # tomcat最大线程数，默认为200
      max: 800
      # Tomcat启动初始化的线程数，默认值10
      min-spare: 100
    # 配置域名访问
    remote-ip-header: X-Real-IP
    protocol-header: X-Forwarded-Proto
    protocol-header-https-value: https

# 日志配置

logging:
  level:
    com.ruoyi: info
    org.springframework: warn
  file:
    path: /app/logs

# Spring配置

spring:

# 资源信息

  messages:
    # 国际化资源文件路径
    basename: i18n/messages
  profiles:
    active: druid

# 文件上传

  servlet:
    multipart:
      # 单个文件大小
      max-file-size: 10MB
      # 设置总上传的文件大小
      max-request-size: 20MB

# 服务模块

  devtools:
    restart:
      # 热部署开关
      enabled: false
  data:
    # redis 配置
    redis:
      # 地址
      host: msdsredis
      # 端口，默认为6379
      port: 6379
      # 数据库索引
      database: 0
      # 密码
      password:
      # 连接超时时间
      timeout: 10s
      lettuce:
        pool:
          # 连接池中的最小空闲连接
          min-idle: 0
          # 连接池中的最大空闲连接
          max-idle: 8
          # 连接池的最大数据库连接数
          max-active: 8
          # #连接池最大阻塞等待时间（使用负值表示没有限制）
          max-wait: -1ms

现在让我修改前端配置以支持生产环境域名访问。

toolName: write_to_file

status: success

filePath: d:\XUYIFEI\XUPROJECTS\msdsfullstack\msdsPC\ruoyi-MsdsPc-react\react-ui\.env.production

content: # 生产环境配置
REACT_APP_ENV=prod

# API接口地址

REACT_APP_API_URL=https://flymsds.cn

# API请求前缀

REACT_APP_BASE_API=/api

# 路由基础路径

PUBLIC_PATH=/

让我修改Nginx配置以支持域名访问和反向代理。

toolName: write_to_file

status: success

filePath: d:\XUYIFEI\XUPROJECTS\msdsfullstack\msdsdocker\nginx\conf.d\msds.conf

content: upstream backend {
    server msdsbackend:8080;
}

server {
    listen 80;
    server_name flymsds.cn;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl;
    server_name flymsds.cn;

    # SSL配置
    ssl_certificate /etc/nginx/ssl/flymsds.cn.pem;
    ssl_certificate_key /etc/nginx/ssl/flymsds.cn.key;
    ssl_session_timeout 5m;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE;
    ssl_prefer_server_ciphers on;

    # 前端静态资源
    location / {
        root /usr/share/nginx/html;
        try_files$uri $uri/ /index.html;
        index index.html index.htm;
    }

    # 后端API代理
    location /api/ {
        proxy_pass http://backend/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

    # 上传文件大小限制
        client_max_body_size 20m;

    # 超时设置
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }

    # 文件上传路径
    location /profile/ {
        alias /app/uploadPath/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        expires 7d;
    }

    # gzip压缩配置
    gzip on;
    gzip_min_length 1k;
    gzip_comp_level 6;
    gzip_types text/plain text/css text/javascript application/json application/javascript application/x-javascript application/xml;
    gzip_vary on;
    gzip_disable "MSIE [1-6]\.";

    # 错误页面
    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }
}

让我修改生产环境的数据库配置。

toolName: write_to_file

status: success

filePath: d:\XUYIFEI\XUPROJECTS\msdsfullstack\msdsPC\ruoyi-MsdsPc-react\ruoyi-admin\src\main\resources\application-druid-prod.yml

content: # 数据源配置
spring:
    datasource:
        type: com.alibaba.druid.pool.DruidDataSource
        driverClassName: com.mysql.cj.jdbc.Driver
        druid:
            # 主库数据源
            master:
                url: jdbc:mysql://msdsmysql:3306/msds_prod?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
                username: msds_prod_user
                password: msds_prod_password
            # 从库数据源
            slave:
                # 从数据源开关/默认关闭
                enabled: false
                url:
                username:
                password:
            # 初始连接数
            initialSize: 5
            # 最小连接池数量
            minIdle: 10
            # 最大连接池数量
            maxActive: 20
            # 配置获取连接等待超时的时间
            maxWait: 60000
            # 配置连接超时时间
            connectTimeout: 30000
            # 配置网络超时时间
            socketTimeout: 60000
            # 配置间隔多久才进行一次检测，检测需要关闭的空闲连接，单位是毫秒
            timeBetweenEvictionRunsMillis: 60000
            # 配置一个连接在池中最小生存的时间，单位是毫秒
            minEvictableIdleTimeMillis: 300000
            # 配置一个连接在池中最大生存的时间，单位是毫秒
            maxEvictableIdleTimeMillis: 900000
            # 配置检测连接是否有效
            validationQuery: SELECT 1 FROM DUAL
            testWhileIdle: true
            testOnBorrow: false
            testOnReturn: false
            webStatFilter:
                enabled: true
            statViewServlet:
                enabled: true
                # 设置白名单，不填则允许所有访问
                allow:
                url-pattern: /druid/*
                # 控制台管理用户名和密码
                login-username: msds_admin
                login-password: msds_prod_druid_pwd
            filter:
                stat:
                    enabled: true
                    # 慢SQL记录
                    log-slow-sql: true
                    slow-sql-millis: 1000
                    merge-sql: true
                wall:
                    config:
                        multi-statement-allow: true

我已完成了所有必要的配置修改，以支持域名 `flymsds.cn` 的访问。以下是修改的内容和打包说明：

1. 后端配置修改：

   - 创建了生产环境配置文件 `application-prod.yml`，配置了生产环境特定的参数
   - 创建了生产环境数据库配置文件 `application-druid-prod.yml`，设置了生产环境的数据库连接信息
   - 启用了 IP 地址获取功能，配置了域名访问所需的请求头支持
   - 关闭了热部署，调整了日志级别和输出路径
2. 前端配置修改：

   - 创建了生产环境配置文件 `.env.production`
   - 配置了生产环境 API 地址为 `https://flymsds.cn`
   - 设置了 API 请求前缀为 `/api`
3. Nginx配置修改：

   - 创建了域名配置文件 `msds.conf`
   - 配置了 HTTP 到 HTTPS 的自动跳转
   - 设置了 SSL 证书配置（需要您提供 SSL 证书文件）
   - 配置了前端静态资源访问
   - 设置了后端 API 反向代理
   - 优化了文件上传、gzip压缩等配置

打包部署步骤：

1. 前端打包：

```bash
cd react-ui
npm install
npm run build:prod
```

现package.json中没有build:prod脚本，需要修改构建命令。   #####构建生产环境！
"build:prod": "cross-env REACT_APP_ENV=prod max build"

这个脚本会： 使用 cross-env 设置生产环境变量 REACT_APP_ENV=prod  使用 max build 命令进行生产环境构建     现在你可以在容器中使用 npm run build:prod 命令来构建生产环境的前端代码了。这个命令会使用生产环境的配置（包括之前配置的域名 flymsds.cn）来构建项目。

---

2. 后端打包：

```bash
cd ruoyi-MsdsPc-react
mvn clean package -Pprod -DskipTests
```

mvn clean install  //////?这个不编译打包吗！！！

3. 部署准备：

   - 将 SSL 证书文件（`flymsds.cn.pem` 和 `flymsds.cn.key`）放置在 `msdsdocker/nginx/ssl/` 目录下
   - 确保生产环境数据库用户名和密码与 `application-druid-prod.yml` 中的配置一致
   - 检查 Docker 配置中的数据卷路径是否正确
4. 启动服务：

```bash
cd msdsdocker
docker-compose up -d
```

注意事项：

1. 在正式部署前，请确保已经获取并正确配置了域名 `flymsds.cn` 的 SSL 证书
2. 生产环境的数据库密码、Redis密码等敏感信息建议使用环境变量注入
3. 首次部署时需要执行数据库初始化脚本
4. 建议在正式部署前进行完整的测试，确保所有功能正常运行

如果您需要修改任何配置或有其他需求，请告诉我。
