# MSDS实验室管理系统 Docker部署

[![Docker](https://img.shields.io/badge/Docker-20.10+-blue.svg)](https://www.docker.com/)
[![Docker Compose](https://img.shields.io/badge/Docker%20Compose-2.0+-blue.svg)](https://docs.docker.com/compose/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-orange.svg)](https://www.mysql.com/)
[![Redis](https://img.shields.io/badge/Redis-latest-red.svg)](https://redis.io/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-2.x-green.svg)](https://spring.io/projects/spring-boot)
[![React](https://img.shields.io/badge/React-18.x-blue.svg)](https://reactjs.org/)

## 📋 目录

- [系统概述](#系统概述)
- [快速开始](#快速开始)
- [系统架构](#系统架构)
- [部署指南](#部署指南)
- [运维管理](#运维管理)
- [监控系统](#监控系统)
- [故障排除](#故障排除)
- [API文档](#api文档)

## 🎯 系统概述

MSDS实验室管理系统是一个基于微服务架构的全栈应用，用于管理化学品安全数据表(MSDS)。系统采用Docker容器化部署，支持高可用、可扩展的生产环境。

### 核心功能
- 🧪 MSDS文档管理
- 📊 化学品信息查询
- 🔍 安全数据检索
- 📈 实时监控告警
- 🔐 用户权限管理
- 📱 移动端支持

### 技术栈
- **前端**: React 18 + Ant Design + TypeScript
- **后端**: Spring Boot 2.x + MyBatis + Java 8
- **数据库**: MySQL 8.0
- **缓存**: Redis
- **代理**: Nginx
- **监控**: Prometheus + Grafana + cAdvisor
- **容器**: Docker + Docker Compose

## 🚀 快速开始

### 前置要求
- Docker 20.10+
- Docker Compose 2.0+
- 8GB+ 内存
- 20GB+ 磁盘空间

### 一键部署

```bash
# 1. 克隆项目
git clone <repository-url>
cd msdsfullstack/msdsdocker

# 2. 启动系统
docker-compose up -d

# 3. 启动监控
docker-compose -f docker-compose.monitoring-simple.yml up -d

# 4. 验证部署
.\system-check.ps1
```

### 访问地址

| 服务 | 地址 | 说明 |
|------|------|------|
| 🌐 MSDS前端 | http://localhost:8000 | 主应用界面 |
| 🔧 MSDS后端 | http://localhost:18080 | API服务 |
| 🌍 Nginx代理 | http://localhost:180 | 反向代理 |
| 📊 Grafana | http://localhost:13000 | 监控面板 (admin/admin) |
| 📈 Prometheus | http://localhost:9090 | 指标收集 |
| 🔍 cAdvisor | http://localhost:18081 | 容器监控 |

## 🏗️ 系统架构

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   用户浏览器     │    │   移动端应用     │    │   管理员界面     │
└─────────┬───────┘    └─────────┬───────┘    └─────────┬───────┘
          │                      │                      │
          └──────────────────────┼──────────────────────┘
                                 │
                    ┌─────────────┴─────────────┐
                    │      Nginx 反向代理        │
                    └─────────────┬─────────────┘
                                 │
                    ┌─────────────┴─────────────┐
                    │     React 前端服务        │
                    └─────────────┬─────────────┘
                                 │
                    ┌─────────────┴─────────────┐
                    │   Spring Boot 后端服务    │
                    └─────────────┬─────────────┘
                                 │
          ┌──────────────────────┼──────────────────────┐
          │                      │                      │
┌─────────┴─────────┐  ┌─────────┴─────────┐  ┌─────────┴─────────┐
│   MySQL 数据库    │  │   Redis 缓存      │  │   文件存储系统     │
└───────────────────┘  └───────────────────┘  └───────────────────┘

监控系统:
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Prometheus    │    │    Grafana      │    │    cAdvisor     │
│   指标收集       │    │   可视化面板     │    │   容器监控       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 📖 部署指南

### 开发环境部署

```bash
# 启动开发环境
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f
```

### 生产环境部署

```bash
# 使用生产配置
docker-compose -f docker-compose.local-prod.yml up -d

# 配置SSL证书
# 编辑 nginx/nginx.conf 添加SSL配置

# 重启Nginx
docker-compose restart msdsnginx
```

### 环境配置

#### 数据库配置
```yaml
# docker-compose.yml
environment:
  MYSQL_ROOT_PASSWORD: msds_root_password
  MYSQL_DATABASE: msds_dev
  MYSQL_USER: msds_user
  MYSQL_PASSWORD: msds_dev_password
```

#### 应用配置
```yaml
# 后端环境变量
environment:
  SPRING_PROFILES_ACTIVE: docker
  SPRING_DATASOURCE_URL: jdbc:mysql://msdsmysql:3306/msds_dev
  SPRING_REDIS_HOST: msdsredis
```

## 🛠️ 运维管理

### 系统检查

```bash
# 完整系统检查
.\system-check.ps1

# 性能检查
.\system-check.ps1 -Performance

# 健康检查
.\system-check.ps1 -Health

# 详细检查
.\system-check.ps1 -Detailed
```

### 备份恢复

```bash
# 创建备份
.\backup-restore.ps1 -Action backup

# 查看备份列表
.\backup-restore.ps1 -Action list

# 恢复数据库
.\backup-restore.ps1 -Action restore -BackupFile ".\backups\mysql_backup_20250127_120000.sql"

# 恢复Redis
.\backup-restore.ps1 -Action restore -BackupFile ".\backups\redis_backup_20250127_120000.rdb"
```

### 日志管理

```bash
# 查看所有服务日志
docker-compose logs -f

# 查看特定服务日志
docker-compose logs -f msdsbackend

# 查看最近100行日志
docker logs msdsbackend --tail 100

# 实时跟踪日志
docker logs -f msdsbackend
```

### 容器管理

```bash
# 重启服务
docker-compose restart msdsbackend

# 重新构建镜像
docker-compose build --no-cache msdsbackend

# 进入容器
docker exec -it msdsbackend /bin/bash

# 查看容器资源使用
docker stats $(docker ps --filter "name=msds" --format "{{.Names}}")
```

## 📊 监控系统

### Grafana仪表板

访问 http://localhost:13000 (admin/admin)

预配置仪表板：
- 系统概览
- 容器监控
- 应用性能
- 数据库监控
- 网络流量

### Prometheus指标

访问 http://localhost:9090

关键指标：
- `container_cpu_usage_seconds_total`
- `container_memory_usage_bytes`
- `mysql_global_status_connections`
- `redis_connected_clients`

### 告警配置

```yaml
# prometheus/alert.rules
groups:
- name: msds-alerts
  rules:
  - alert: HighCPUUsage
    expr: rate(container_cpu_usage_seconds_total[5m]) > 0.8
    for: 2m
    labels:
      severity: warning
    annotations:
      summary: "容器CPU使用率过高"
```

## 🔧 故障排除

### 常见问题

#### 1. 容器启动失败
```bash
# 检查端口占用
netstat -an | findstr :8080

# 查看详细错误
docker-compose logs msdsbackend

# 重新构建镜像
docker-compose build --no-cache
```

#### 2. 数据库连接失败
```bash
# 检查MySQL容器
docker ps | grep msdsmysql

# 测试数据库连接
docker exec -it msdsmysql mysql -u msds_user -p

# 检查网络连接
docker network ls
docker network inspect msdsdocker_msds_network
```

#### 3. 前端页面无法访问
```bash
# 检查Nginx配置
docker exec -it msdsnginx nginx -t

# 重启Nginx
docker-compose restart msdsnginx

# 检查前端构建
docker-compose logs msdsfrontend
```

### 性能优化

#### 1. 数据库优化
```sql
-- 查看慢查询
SHOW VARIABLES LIKE 'slow_query_log';
SHOW VARIABLES LIKE 'long_query_time';

-- 分析查询性能
EXPLAIN SELECT * FROM msds_documents WHERE product_name LIKE '%化学品%';

-- 添加索引
CREATE INDEX idx_product_name ON msds_documents(product_name);
```

#### 2. 缓存优化
```bash
# 查看Redis内存使用
docker exec msdsredis redis-cli info memory

# 查看缓存命中率
docker exec msdsredis redis-cli info stats | grep keyspace
```

#### 3. 应用优化
```bash
# 调整JVM参数
environment:
  JAVA_OPTS: "-Xms512m -Xmx2g -XX:+UseG1GC"

# 启用应用监控
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
```

## 📚 API文档

### 认证接口
```
POST /login          # 用户登录
POST /logout         # 用户登出
GET  /captchaImage   # 获取验证码
```

### MSDS管理接口
```
GET    /msds/list           # 获取MSDS列表
POST   /msds/add            # 添加MSDS文档
PUT    /msds/edit/{id}      # 编辑MSDS文档
DELETE /msds/remove/{id}    # 删除MSDS文档
GET    /msds/detail/{id}    # 获取MSDS详情
```

### 文件管理接口
```
POST /upload/msds     # 上传MSDS文件
GET  /download/{id}   # 下载文件
```

详细API文档请访问：http://localhost:18080/swagger-ui.html

## 🤝 贡献指南

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 📞 支持

- 📧 邮箱: msds-support@company.com
- 📱 电话: +86-xxx-xxxx-xxxx
- 💬 QQ群: xxxxxxxxx
- 📖 文档: [完整运维手册](./MSDS系统运维手册.md)

## 🔄 更新日志

### v1.0.0 (2025-01-27)
- ✨ 初始版本发布
- 🐳 Docker容器化部署
- 📊 集成监控系统
- 🔧 完善运维工具
- 📚 完整文档体系

---

**注意**: 生产环境部署前请仔细阅读 [运维手册](./MSDS系统运维手册.md) 和 [快速部署指南](./快速部署指南.md)。