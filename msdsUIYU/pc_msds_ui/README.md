# MSDS 管理文件系统

> 专为实验室科研机构设计的化学品安全技术说明书电子化管理PC端应用

## 📋 项目概述

MSDS管理文件系统是一个专业的化学品安全数据表(Material Safety Data Sheet)管理平台，旨在帮助实验室和科研机构高效管理、检索和使用化学品安全信息。

### 🎯 主要功能

- **📄 MSDS文档管理**: 上传、存储、版本控制
- **🔍 智能搜索**: 支持化学品名称、CAS号、供应商等多维度搜索
- **👥 用户权限管理**: 多角色权限控制，支持科研人员和管理员
- **📊 数据统计**: 使用情况统计和分析
- **💾 本地缓存**: 离线查阅支持
- **🔄 实时同步**: 文档更新实时通知

### 🏗️ 技术架构

- **前端**: Electron + React + TypeScript + Ant Design
- **后端**: Node.js + Fastify + TypeScript
- **数据库**: PostgreSQL + Elasticsearch + Redis
- **文件存储**: MinIO/本地存储
- **容器化**: Docker + Docker Compose

## 🚀 快速开始

### 环境要求

- **Node.js**: >= 18.0.0
- **npm**: >= 8.0.0
- **Docker**: >= 20.0.0
- **Docker Compose**: >= 2.0.0

### 安装步骤

1. **克隆项目**
```bash
git clone <repository-url>
cd msds-management-system
```

2. **安装依赖**
```bash
npm run setup
```

3. **启动开发环境**
```bash
# 启动数据库和服务
npm run docker:dev

# 启动开发服务器
npm run dev
```

4. **访问应用**
- **客户端应用**: 自动启动桌面应用
- **API服务**: http://localhost:3000
- **Elasticsearch**: http://localhost:9200
- **Kibana**: http://localhost:5601
- **MinIO控制台**: http://localhost:9001

## 📁 项目结构

```
msds-management-system/
├── src/
│   ├── client/              # Electron客户端
│   │   ├── main/           # 主进程
│   │   ├── renderer/       # 渲染进程(React)
│   │   └── shared/         # 共享代码
│   └── server/             # Node.js服务端
│       ├── api/            # API路由
│       ├── services/       # 业务服务
│       ├── models/         # 数据模型
│       └── utils/          # 工具函数
├── design/                 # 设计文档和原型
│   ├── prototypes/         # UI原型文件
│   └── specs/              # 设计规范
├── docs/                   # 项目文档
├── config/                 # 配置文件
├── scripts/                # 构建和部署脚本
├── docker-compose.dev.yml  # 开发环境配置
├── docker-compose.prod.yml # 生产环境配置
└── package.json           # 项目配置
```

## 🛠️ 开发指南

### 本地开发

```bash
# 启动数据库服务
npm run docker:dev

# 启动客户端开发服务器
npm run dev:client

# 启动服务端开发服务器
npm run dev:server

# 同时启动前后端
npm run dev
```

### 构建应用

```bash
# 构建所有
npm run build

# 构建客户端
npm run build:client

# 构建服务端
npm run build:server
```

### 测试

```bash
# 运行所有测试
npm run test

# 运行客户端测试
npm run test:client

# 运行服务端测试
npm run test:server
```

### 代码质量

```bash
# 代码检查
npm run lint

# 代码格式化
npm run format
```

## 🔧 配置说明

### 环境变量

创建 `.env` 文件：

```env
# 数据库配置
DATABASE_URL="postgresql://msds_user:msds_dev_password@localhost:5432/msds_dev"

# Redis配置
REDIS_URL="redis://:msds_redis_password@localhost:6379"

# Elasticsearch配置
ELASTICSEARCH_URL="http://localhost:9200"

# MinIO配置
MINIO_ENDPOINT="localhost"
MINIO_PORT=9000
MINIO_ACCESS_KEY="msds_minio_user"
MINIO_SECRET_KEY="msds_minio_password"

# JWT配置
JWT_SECRET="your-jwt-secret-key"
JWT_EXPIRES_IN="7d"

# 应用配置
NODE_ENV="development"
API_PORT=3000
API_HOST="localhost"
```

### 数据库初始化

```bash
# 运行数据库迁移
cd src/server
npm run migrate

# 填充种子数据
npm run seed
```

## 🐳 Docker 部署

### 开发环境

```bash
# 启动所有服务
npm run docker:dev

# 查看服务状态
docker-compose -f docker-compose.dev.yml ps

# 查看日志
docker-compose -f docker-compose.dev.yml logs -f [service-name]

# 停止服务
npm run docker:down
```

### 生产环境

```bash
# 构建生产镜像
docker-compose -f docker-compose.prod.yml build

# 启动生产服务
npm run docker:prod
```

## 📊 监控和日志

### 健康检查

- **数据库**: http://localhost:5432 (pg_isready)
- **API服务**: http://localhost:3000/health
- **Elasticsearch**: http://localhost:9200/_cluster/health

### 日志查看

```bash
# 查看所有服务日志
docker-compose logs -f

# 查看特定服务日志
docker-compose logs -f postgres
docker-compose logs -f elasticsearch
```

## 🔒 安全说明

### 生产环境安全配置

1. **更改默认密码**: 修改所有默认密码
2. **SSL/TLS**: 配置HTTPS证书
3. **防火墙**: 限制端口访问
4. **备份**: 定期数据备份
5. **监控**: 配置安全监控和告警

### 数据备份

```bash
# 数据库备份
docker exec msds-postgres-dev pg_dump -U msds_user msds_dev > backup.sql

# 恢复数据库
docker exec -i msds-postgres-dev psql -U msds_user msds_dev < backup.sql
```

## 🤝 贡献指南

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

### 开发规范

- 使用 TypeScript 进行类型检查
- 遵循 ESLint 和 Prettier 代码规范
- 编写单元测试覆盖核心功能
- 提交前运行 `npm run lint` 和 `npm run test`

## 📝 更新日志

### v1.0.0 (2024-01-15)

- ✨ 初始版本发布
- 🎨 完成UI设计和原型
- 🏗️ 完成技术架构设计
- 🗃️ 完成数据库设计
- 🚀 开始MVP开发

## 📄 许可证

本项目基于 [MIT License](LICENSE) 开源协议。

## 👥 团队

- **产品经理**: 产品需求和路线图规划
- **UI/UX设计师**: 界面设计和用户体验
- **系统架构师**: 技术架构和数据库设计
- **前端开发**: Electron + React 客户端开发
- **后端开发**: Node.js + Fastify 服务端开发
- **DevOps工程师**: 部署和运维

## 📞 支持

如有问题或建议，请：

1. 查看 [FAQ文档](docs/FAQ.md)
2. 提交 [Issue](../../issues)
3. 发送邮件至：support@msds-system.com

---

**�� 让化学品管理更安全、更高效！** 