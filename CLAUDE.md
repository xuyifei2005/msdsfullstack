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

### Troubleshooting: 开发环境常见故障

**登录页报 504 / 验证码获取失败**

前端 dev server（`localhost:8000`）把 `/api/**` 代理到后端 `msdsbackend:8080`，后端容器没起来时代理超时即返回 504。排查顺序：

```bash
docker ps --filter name=msds          # msdsbackend 是否 Up (healthy)
docker logs --tail 50 msdsbackend     # 是否还在 Maven 编译 / 有无启动异常
```

> `/app` 挂载的是 Windows 目录，Docker Desktop 跨系统 IO 很慢，`mvn -DskipTests package` 完整编译一次需要 40 分钟以上。
> 后端启动脚本 `msdsdocker/backend-start.sh` 会在「jar 已存在且没有更新的源码」时跳过编译，直接复用 `ruoyi-admin/target/ruoyi-admin.jar`（秒级启动）。
> 强制重新编译：`docker compose exec msdsbackend rm -f /app/ruoyi-admin/target/ruoyi-admin.jar`，或启动前设置 `FORCE_BUILD=1`。

**后端报 `UnknownHostException: msdsmysql`**

Docker Desktop 重启后，容器可能丢失自定义网络的端点（`docker inspect msdsmysql` 的 `NetworkSettings.Networks` 为空）。修复：

```bash
docker network connect msdsdocker_msds_network msdsmysql
```

容器名即网络别名，接回后端即可通过 `msdsmysql:3306` 访问。

**检索页提示「智能检索异常」或搜危化品返回 0 条**

先确认是「代码问题」还是「数据问题」—— 绝大多数情况是后者：

```bash
# 1) 查文档总数（不要信 information_schema.table_rows，那是过期估算值）
docker exec msdsmysql mysql -uroot -p<pwd> msds_dev -e "SELECT COUNT(*) FROM msds_main;"

# 2) 直接打检索接口，看返回体里的 code/rows/total
#    GET http://localhost:18081/system/msds/search/intelligent?keyword=硫酸&searchType=general&sortBy=relevance
```

- 文档数远少于预期（正常应为 **2845** 篇）→ 数据库被清空过，需要重新导入数据集，见下节。
- 文档数正常但检索 0 条 → 才需要排查 `MsdsSearchMapper.xml` 的匹配条件。
- 页面提示「智能检索异常」而接口直调正常 → 前端响应体分支判断有问题（旧代码在响应体缺 `code`/`rows` 时误判为空结果）。

**MSDS 数据集导入（数据库被清空后恢复）**

完整数据集：`aboutproject/msdsdatabases/jfkjmsds20260310/msds_dev.sql`（19MB，2845 篇 `msds_main`）。
注意 `aboutproject/msdsdatabases/msds_complete_database.sql`（71KB）**只是初始化种子**，0 条 `msds_main`，用它重建库必然是空库。

导入要点（2026-11-19 实测流程）：

- 只导文档相关表（`msds_*`），**不要导 `sys_*`**，否则会覆盖当前菜单/用户/角色配置。
- 先备份：`mysqldump` 出 `msds_*` 文档表快照存到 `aboutproject/msdsdatabases/backup_*.sql`。
- 子表去掉自增 `id` 列、改用显式列清单插入，避免与现有 id 段冲突；主表保留原 id 以维持子表 `msds_id` 外键。
- `cas_number` / `msds_code` 是 UNIQUE，导入前先处理同名冲突（同名不同物时保留信息更完整的一条）。
- `SET FOREIGN_KEY_CHECKS=0` 时 ON DELETE CASCADE 不生效，需手工清理孤儿行。
- 导入用 `docker cp` 进容器后 `docker exec -i` 执行；Windows 管道传 30MB SQL 会超时。

**统计计数 / 热门搜索的「真实数据」链路**

这两处曾长期显示 0 或空，根因是**只有表和实体、没有写入路径**：

- `msds_document_statistics`（查看/下载/收藏计数）与 `msds_document_access_log`（访问明细）
  原本**没有任何 Mapper 写入代码**，页面计数永远是 0。现已补齐：
  `MsdsDocumentStatisticsMapper` → `MsdsDocumentStatisticsServiceImpl` →
  `MsdsDocumentStatisticsController`（`/system/msds/statistics/**`），
  详情页进入记 `view`、导出 PDF 记 `download`、点收藏记 `favorite`。
- `msds_search_suggestion`（策展词条）表原本**零数据**且**无对外 CRUD 接口**。
  现热门搜索 = `msds_search_history` 真实搜索历史聚合（近 30 天，按次数倒序）
  + 策展词条（`keyword_type='hot'`）合并，按关键词去重；
  策展词条可通过 `/system/msds/search/suggestion/**` 增删改查。

> **坑一**：`msds_audit_log` 表原本**根本不存在**（种子 SQL 和全量 dump 都没有），
> 而 `MsdsMainController.exportPdf` 会写审计日志 → 真实下载必然 500。
> 已补建该表并写回种子 SQL `msds_complete_database.sql`。

> **坑二**：`INSERT ... ON DUPLICATE KEY UPDATE` 在**首次插入**时不会走 UPDATE 分支，
> 若初始值写死为 0，则「第一次查看」不计数、第二次才 +1。
> 正确写法：VALUES 里按 action 决定初始值是否为 1。

**种子脚本 `msds_complete_database.sql` 的两个坑（高危）**

1. **硬编码 `USE msds_dev`** —— 想在临时库验证必须先改写该行，
   否则脚本会 DROP 并重建**生产库**的 `sys_*` 与 `msds_*` 表（2026-11-19 已因此清空过一次用户/角色/菜单）。
   验证前务必：`$c -replace 'USE msds_dev;','USE msds_seedtest;'`。
2. **缺少 `SET FOREIGN_KEY_CHECKS = 0`** —— `chemical_category` 早于 `msds_main` 被 DROP，
   而 `msds_main` 上有指向它的外键，MySQL 8.0 直接报 ERROR 3730，
   初始化在第 331 行中断，**后续所有表都建不出来**（这正是「容器重建后统计/收藏表全没了」的机制性原因）。
   已补：文件头 `SET FOREIGN_KEY_CHECKS = 0`，文件尾恢复。

> 增量补丁用独立文件承载，别塞进全量重建脚本：
> `aboutproject/msdsdatabases/msds_ext_menu_patch.sql`（菜单/权限，幂等可重复执行）。
> 备份来源：`msds_dev全20251031.sql`（含 sys_* 完整数据）。
> 注意各历史 dump 的 `sys_menu` 基线不同（2036/2043/2064 等菜单是 2025-10 之后手工加的，任何备份里都没有），
> 恢复时需按实测记录单独补回。
**MSDS 详情弹窗「看不清 + 整章空白」（2026-11-19 修复）**

- **字段值几乎不可见**：全局 `src/global.less` 的 `Descriptions增强` 残留了深色主题配色
  （`.ant-descriptions-item-content { color: #e6f7ff }`），白底上对比度约 1.1:1。
  全局已是「现代明亮风格」，此处必须用深色（内容 `#0f172a`、标签 `#334155`）；
  `.ant-timeline-item-content` 同理。对照实测：修复前计算色 `rgb(230,247,255)`，修复后 `rgb(15,23,42)`。
- **完整度是写死的**：`MsdsDetail.tsx` 里「85% / 12 个章节完整 / 4 个不完整」是假数据，
  现按各章节接口返回的真实字段填充率计算（占位值 `-`、`无资料` 视为未填写）。
- **第 16 章「其他信息」整章空白**：前端从未调用 `getOtherInfoByMsdsId`，
  且 `MsdsOtherInfoMapper.xml` 写的是 `reference_list`，而真实库表与全量 dump 的列名是
  **`references`（MySQL 保留字，SQL 里必须加反引号）** → `/system/msds/otherInfo/**` 直接 500。
  修复后该章可显示真实的数据来源/免责声明（1131 行记录里 114 行有免责声明）。
  种子 SQL 已同步改成 `` `references` ``。
- **改 mapper XML 后必须重打后端 jar**：mapper 打在 `ruoyi-system` jar 里再塞进 `ruoyi-admin.jar`，
  只改 XML 不重打，接口不会变。Windows 挂载盘编译要 40+ 分钟，可靠做法是
  把源码 tar 进容器本地盘 `/tmp` 再 `mvn -DskipTests package`（实测 1 分 17 秒），
  把 jar 拷回 `/app/ruoyi-admin/target/` 再重启容器（启动脚本会因 jar 比源码新而跳过重编译）。

**列表页搜索结果排序（精确匹配要排最前）**

`MsdsMainMapper.selectMsdsMainList` 用 `product_name like '%关键词%'` 匹配，
但排序若固定为 `order by create_time desc`，用户输入的化学品本身会被排到中间甚至第 4 页。
现按匹配质量排序：名称精确 > 别名精确 > CAS精确 > 英文名精确 > 名称前缀 > 别名前缀 > 其余，
同级再按 `length(product_name)`、`id` 升序；只有 CAS 关键词时 CAS 精确优先；无关键词保持原顺序。
> 例：搜「硫酸」→ 首条是 id=4777「硫酸」（CAS 7664-93-9），其次硫酸镉/硫酸汞…；
> 「亚硫酸氢钠」这类包含但非前缀的排到后面。
> 注意：库里可能**不存在**完全同名记录（例：搜「乙醇」无同名文档，最接近的是「乙醇[无水]」），
> 这属于数据实况，不要靠改排序掩盖。

### Port Mappings
- Frontend (Nginx): `localhost:180` → container:80, `localhost:1443` → container:443
- Frontend (dev): `localhost:8000` → container:8000
- Backend: `localhost:18081` → container:8080
- MySQL: `localhost:3306`
- Redis: `localhost:1379` → container:6379

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
