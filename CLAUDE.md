# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MSDS (Material Safety Data Sheet) Management System - A full-stack chemical safety data management platform built on the **RuoYi framework**.

**Important**: This is a secondary development project based on the open-source RuoYi framework. All development must follow RuoYi's architecture specifications and coding standards.

### Technology Stack

- **Backend**: Java 17 + Spring Boot 3.3.0 + RuoYi Framework 3.8.8
- **Frontend**: React 18 + TypeScript + Ant Design Pro + Umi Framework
- **Mobile**: UniApp + Vue + uView UI (WeChat Mini Program)
- **Database**: MySQL 8.0
- **Cache**: Redis
- **Deployment**: Docker Compose (Windows 11 + WSL2 + Docker Desktop)

### Project Structure

```
msdsfullstack/
├── msdsPC/ruoyi-MsdsPc-react/    # Backend + Web Frontend
│   ├── ruoyi-admin/              # Web service entry
│   ├── ruoyi-framework/          # Framework core (security, config, utils)
│   ├── ruoyi-system/             # System management (users, roles, menus, dicts)
│   ├── ruoyi-common/             # Common utilities and constants
│   ├── ruoyi-generator/          # Code generator
│   └── react-ui/                 # React frontend
├── wechatapps/RuoYi-Msds-App/    # UniApp mobile app
├── msdsdocker/                   # Docker deployment configs
└── aboutproject/                 # Documentation
```

## Development Environment

### Critical: WSL2 + Docker Desktop

**All backend and frontend code MUST be compiled and run inside Docker containers** on Windows 11 WSL2.

- **DO NOT** run Maven or npm commands directly on Windows host
- **DO** use `docker-compose exec` to enter containers for command execution
- **Mobile app** is developed on Windows host using HBuilderX (not in Docker)

### Common Commands

```bash
# Start all services
cd msdsdocker
docker-compose up -d

# View logs
docker-compose logs -f msdsbackend
docker-compose logs -f msdsnginx

# Enter backend container (for Maven commands)
docker-compose exec msdsbackend bash
mvn clean package -DskipTests

# Enter frontend container (for npm commands)
docker-compose exec msdsfrontend bash
npm install
npm run dev

# Stop services
docker-compose down
```

### Port Mappings

- Frontend (Nginx): `localhost:80`, `localhost:443`
- Backend: `localhost:18080` → container:8080
- MySQL: `localhost:3306`
- Redis: `localhost:6379`

## RuoYi Framework Conventions

### Backend Development

RuoYi follows a strict layered architecture:

1. **Controller Layer** (`ruoyi-admin`)
   - Extends `BaseController` for pagination and standard responses
   - Uses `@PreAuthorize("@ss.hasPermi('module:entity:action')")` for permissions
   - Returns `AjaxResult` or `TableDataInfo` (RuoYi standard formats)
   - Methods: `list()`, `getInfo()`, `add()`, `edit()`, `remove()`

2. **Service Layer** (`ruoyi-system` or custom module)
   - Interface naming: `I{Entity}Service`
   - Implementation: `{Entity}ServiceImpl`
   - Methods: `select{Entity}List()`, `select{Entity}ById()`, `insert{Entity}()`, `update{Entity}()`, `delete{Entity}ByIds()`

3. **Mapper Layer** (`ruoyi-system/mapper`)
   - Extends `BaseMapper<T>` from MyBatis Plus
   - XML files for complex queries

4. **Entity Layer** (`ruoyi-system/domain`)
   - Extends `BaseEntity` for audit fields (createTime, updateTime, createBy, updateBy)
   - Uses `@Excel` annotation for export functionality

### Code Generation

Use RuoYi's built-in code generator at: `系统工具 → 代码生成`

1. Import database table
2. Configure: module name, business name, function name
3. Generate code (downloads zip)
4. Extract to project

### Permission System

Permission format: `{module}:{entity}:{action}`

Examples:
- `system:msds:list` - View MSDS list
- `system:msds:add` - Add MSDS
- `system:msds:edit` - Edit MSDS
- `system:msds:remove` - Delete MSDS

Configure permissions in: `系统管理 → 菜单管理`

### RuoYi Utilities

```java
// String utilities
StringUtils.isEmpty(str)
StringUtils.isNotEmpty(str)

// Date utilities
DateUtils.getNowDate()
DateUtils.parseDate(dateStr)

// Security utilities
SecurityUtils.getUsername()
SecurityUtils.getUserId()
SecurityUtils.getLoginUser()

// Dictionary utilities
DictUtils.getDictLabel(type, value)
```

### Database Conventions

- System tables: `sys_` prefix (DO NOT modify)
- Business tables: `msds_` prefix
- All tables inherit `BaseEntity` audit fields
- Primary keys: Auto-increment BIGINT named `{table_singular}_id`

## Frontend Development (React)

The React frontend uses Ant Design Pro + Umi framework:

### API Calling

```typescript
// api/system/msds.ts
import request from '@/utils/request';

export function listMsds(query: MsdsQuery) {
  return request({
    url: '/system/msds/list',
    method: 'get',
    params: query
  });
}

// RuoYi standard response: {code: 200, msg: 'success', rows: [], total: 100}
```

### Component Development

Use `ProTable` from `@ant-design/pro-table` for list pages.

### Build Commands

```bash
cd msdsPC/ruoyi-MsdsPc-react/react-ui
npm install              # Install dependencies
npm run dev             # Development server
npm run build:prod      # Production build
npm run lint            # Code linting
```

## Mobile Development (UniApp)

**IMPORTANT**: Mobile app is NOT developed in Docker containers.

### Development Flow

1. Use **HBuilderX** to open `wechatapps/RuoYi-Msds-App`
2. Write code in HBuilderX
3. Run to: `运行 → 运行到小程序模拟器 → 微信开发者工具`
4. Debug in **微信开发者工具** (WeChat DevTools)

### API Integration

The mobile app uses RuoYi-App's request module for backend communication:

```javascript
import request from '@/utils/request'

export function listMsds(params) {
  return request({
    url: '/system/msds/list',
    method: 'GET',
    params
  })
}
```

### Development Environment Config

```javascript
// config.js - Point to Docker backend
baseURL: 'http://192.168.x.x:8080'  // WSL2 LAN IP
```

## CI/CD Pipeline

The project uses GitHub Actions for automated deployment (`.github/workflows/deploy.yml`):

### Trigger Branches
- `main` → Production deployment (https://flymsds.cn)
- `develop` → Staging deployment

### Pipeline Steps

1. **Build Frontend**: `npm ci`, `npm run build:prod`
2. **Build Backend**: `mvn clean package`
3. **Build Docker Images**: Multi-stage builds
4. **Export Images**: `.tar` files for server deployment
5. **Deploy to Server**: SSH upload and restart services

### Required GitHub Secrets

- `SSH_HOST` - Server IP address
- `SSH_USER` - SSH username
- `SSH_PRIVATE_KEY` - SSH private key

## MSDS Business Specifics

### Key Features

1. **File Upload/Processing**
   - Supports: PDF, Word (DOC/DOCX), Excel, TXT
   - Uses Apache POI for Office documents
   - Uses Apache PDFBox for PDF parsing
   - Extracts chemical names, CAS numbers, aliases

2. **Core Tables**
   - `msds_main` - Main MSDS records
   - `msds_component` - Chemical components
   - `msds_hazard` - Hazard information
   - `msds_first_aid` - First aid measures
   - `msds_fire_fighting` - Firefighting measures
   - Additional specialized tables for handling, storage, disposal, etc.

3. **Data Import**
   - Batch import from files
   - Progress tracking via `msds_import_progress`
   - Audit logging via `msds_audit_log`

## Development Best Practices

1. **Reuse RuoYi Components**
   - Don't reinvent user management, permissions, logging
   - Use BaseController, BaseEntity, standard utilities

2. **Follow Naming Conventions**
   - Database: `snake_case` with prefixes
   - Java: `PascalCase` for classes, `camelCase` for methods
   - API: RESTful paths (`/system/msds/list`)

3. **Container Development**
   - All Java/Node.js execution in Docker
   - Use volume mounts for code (Windows → WSL2)
   - Use named volumes for dependencies (node_modules, .m2)

4. **Error Handling**
   - Use `ServiceException` for business errors
   - Use `@Transactional` for data consistency
   - Log errors with SLF4J

## RuoYi Official Resources

- Documentation: https://doc.ruoyi.vip/
- Repository: https://gitee.com/y_project/RuoYi-Vue
- Demo: http://vue.ruoyi.vip/

**When in doubt, consult RuoYi documentation first!**
