# MSDS实验室管理系统全栈项目规则

## 文档信息

- **版本**: v3.0
- **更新日期**: 2026-03-12
- **适用范围**: `d:\XUYIFEI\XUPROJECTS\msdsfullstack`
- **维护者**: MSDS 开发团队
- **更新依据**: 当前代码仓与容器编排实际配置

## 0. 核心原则

### 0.1 环境与执行原则

- 本地 Windows 主机负责代码编辑，容器负责运行与构建。
- 优先基于现有工程文件做最小改动，避免新增临时脚本和无关文档。
- 涉及编译、构建、部署、批量数据变更等高成本操作前，需要先确认。
- 优先使用项目现有工具链与自动化脚本。

### 0.2 协作与交付原则

- 先定位根因，再实施修复，避免表面补丁。
- 变更需同步考虑前后端契约、SQL、配置、文档一致性。
- 输出需包含：变更摘要、影响范围、验证步骤、回滚思路。

## 1. 当前项目结构（以仓库现状为准）

```text
msdsfullstack/
├── .trae/
│   ├── rules/
│   │   └── project_rules.md
│   └── skills/
├── aboutproject/
│   ├── ProgressPlan/
│   ├── msdsdatabases/
│   ├── 接口文档/
│   ├── 启动运行/
│   └── 部署实施/
├── msdsPC/
│   └── ruoyi-MsdsPc-react/
│       ├── react-ui/
│       ├── ruoyi-admin/
│       ├── ruoyi-system/
│       ├── ruoyi-framework/
│       ├── ruoyi-common/
│       ├── ruoyi-generator/
│       ├── ruoyi-quartz/
│       └── pom.xml
├── msdsdocker/
│   ├── docker-compose.yml
│   ├── docker-compose.prod.yml
│   ├── mysql/
│   ├── nginx/
│   └── msdsdatabaseinitdb/
├── pdf2xml/
└── wechatapps/
```

## 2. 技术栈基线（按实际配置）

### 2.1 PC 前端（`msdsPC/ruoyi-MsdsPc-react/react-ui`）

- React `18.3.0`
- TypeScript `5.6.2`
- Umi Max `@umijs/max 4.0.7`
- Ant Design `5.21.1`
- ProComponents `2.7.19`
- Node.js 要求 `>=18.0.0`

### 2.2 后端（`msdsPC/ruoyi-MsdsPc-react`）

- RuoYi `3.8.8`
- Spring Boot `3.3.0`
- Java `17`
- MyBatis Spring Boot Starter `3.0.3`
- Druid `1.2.23`
- MySQL Connector `8.2.0`

### 2.3 数据与中间件

- MySQL（容器 `msdsmysql`，数据库 `msds_dev`，字符集 `utf8mb4`）
- Redis（容器 `msdsredis`）

## 3. Docker 运行基线

### 3.1 开发编排（`msdsdocker/docker-compose.yml`）

- `msdsnginx`: `80:80`, `443:443`
- `msdsbackend`: `18081:8080`, `5005:5005`, `2222:22`
- `msdsfrontend`: `3000:8000`, `8000:8000`, `8001:8001`, `2223:22`
- `msdsmysql`: `3306:3306`
- `msdsredis`: 默认未映射宿主机端口，仅容器网络访问

### 3.2 生产编排（`msdsdocker/docker-compose.prod.yml`）

- `msdsbackend` 对外端口为 `18080:8080`
- `msdsnginx` 使用 `80/443`
- 敏感配置通过环境变量注入，禁止在代码中新增明文密钥

## 4. 开发规范

### 4.1 前端规范

- 使用函数式组件与 Hooks。
- 接口统一放在 `src/services`，禁止在页面组件内硬编码请求地址。
- 类型声明优先放在 `src/types` 或 `src/services/typings.d.ts`，避免滥用 `any`。
- 路由与菜单调整时同步修改 `config/routes.ts` 与权限配置。
- 优先沿用 ProComponents 与现有页面模式。

### 4.2 后端规范

- 严格遵循 Controller -> Service -> Mapper 分层。
- 统一返回结构：`AjaxResult` / `TableDataInfo`。
- SQL 优先放在 Mapper XML，不在业务层拼接复杂 SQL。
- 异常必须记录日志并按规范抛出，禁止吞异常。

### 4.3 数据库规范

- DDL 或结构变更必须在 `sql/` 或 `aboutproject/msdsdatabases/` 留存脚本。
- 命名：表字段使用 `snake_case`，Java 字段使用 `camelCase`。
- 涉及初始化/迁移时，确保与 `docker-compose` 挂载脚本一致。

## 5. 测试与质量门禁

### 5.1 前端

- 本地/容器内优先执行：
  - `npm run lint`
  - `npm run tsc`
  - `npm test` 或目标测试命令
- 关键交互页改动需补最小必要测试（Jest/Vitest）。

### 5.2 后端

- 优先执行：
  - `mvn test`
  - `mvn clean package`（必要时可加 `-DskipTests`）
- 关键业务改动需补最小必要单测或集成测试。

### 5.3 交付检查

- 功能正确、日志无异常、无新增高危告警。
- 前后端接口契约一致，回归路径可复现。

## 6. 常用操作（Windows + PowerShell）

### 6.1 启动开发环境

```powershell
cd d:\XUYIFEI\XUPROJECTS\msdsfullstack\msdsdocker
docker-compose up -d
docker-compose ps
```

### 6.2 查看服务日志

```powershell
docker-compose logs -f msdsbackend
docker-compose logs -f msdsfrontend
```

### 6.3 容器内执行构建

```powershell
docker-compose exec msdsbackend mvn test
docker-compose exec msdsbackend mvn clean package
docker-compose exec msdsfrontend npm run lint
docker-compose exec msdsfrontend npm run tsc
docker-compose exec msdsfrontend npm run build
```

## 7. 安全与配置管理

- 新增配置优先环境变量，不提交真实密钥、密码、证书私钥。
- 文档中的账号口令仅可作为示例占位，不得作为生产凭据。
- 对外暴露端口、上传路径、鉴权配置变更需评估安全影响。

## 8. 复杂任务清单机制

- 触发条件：跨模块、多步骤或高风险改动。
- 清单目录：`aboutproject/ProgressPlan/`
- 文件命名：`任务名+list.md`
- 状态约束：同一时刻仅允许一个 `in_progress`
- 每完成一项立即更新状态并记录时间、动作、结果。

## 9. 文档维护要求

- 本规则文件作为仓库级执行基线，变更必须与代码现状一致。
- 技术栈、端口、目录、构建命令发生变化时，需同步更新本文件。
- 与本规则冲突时，以当前仓库真实配置文件为最终依据。
