# MSDS 实验室管理系统 — 实施开发提示词 (Implementation Prompts)

## Context
本项目是一个基于 RuoYi 框架的 MSDS (化学品安全技术说明书) 管理系统。
- **PC端**: React + Ant Design Pro + Spring Boot，负责数据录入、审计与管理。
- **移动端**: UniApp (微信小程序)，负责现场扫码、即时搜索与应急查阅。

**技术栈:**
- 前端: React 18, UmiJS 4, Ant Design 5, ProComponents.
- 后端: Java 17, Spring Boot 3.3.0, MyBatis Plus (RuoYi-Vue 变种).
- 移动端: UniApp (Vue 3), uView UI.

---

## 阶段一：后端基础与数据建模

### Prompt 1: 数据库表结构与后端实体类
> "参考 `aboutproject/PRD/PRD.md` 中的数据模型建议，在 `ruoyi-system` 模块中创建 MSDS 核心业务表：`msds_chemical` (化学品信息), `msds_document` (文档版本), `msds_qrcode` (二维码记录)。
> 
> 要求：
> 1. 遵循 RuoYi 规范，继承 `BaseEntity`，包含 `del_flag` 和审计字段。
> 2. 使用 MyBatis Plus 生成对应的 Domain, Mapper, Service 接口及实现类。
> 3. 在 `ruoyi-admin` 中创建对应的 Controller 骨架，实现基础的 CRUD 接口。"

**Goal:** 建立后端数据基座，确保数据库映射正确。
**Checkpoint:** 运行 `mvn clean package` 通过，且数据库中生成对应表。

---

## 阶段二：PC 端核心功能开发

### Prompt 2: 前端 API 定义与类型声明
> "在 `react-ui/src/services` 目录下创建 `msds` 文件夹。
> 1. 根据后端接口定义 `msds.ts` 请求函数（list, getInfo, add, edit, remove）。
> 2. 在 `typings.d.ts` 中定义 `MsdsItem`, `MsdsQuery` 等 TypeScript 接口，禁止使用 `any`。
> 3. 确保请求工具使用项目现有的 `request` 拦截器以处理 Token。"

**Goal:** 建立前后端契约。
**Checkpoint:** 编译无类型错误，接口定义与后端 Swagger 保持一致。

### Prompt 3: MSDS 列表页与导入功能
> "在 `react-ui/src/pages/Msds` 下实现主列表页。
> 1. 使用 `ProTable` 展示化学品列表，包含：名称、CAS号、危险性等级、更新时间。
> 2. 实现“导入”功能：点击弹出 `Modal`，支持拖拽上传 PDF/DOCX 文件。
> 3. 关联 `msds_import_progress` 接口显示实时进度。"

**Goal:** 实现管理员最核心的数据录入入口。
**Checkpoint:** 页面能正常渲染，且能触发上传弹窗。

### Prompt 4: 16 部分结构化详情编辑页
> "实现 `/msds/detail/:id` 详情编辑页。
> 1. 参考 `06-ux-spec.md` 的布局，使用 `Anchor` (锚点) 实现 16 个部分的快捷跳转。
> 2. 使用 `ProForm` 的分步表单或长表单形式，结构化编辑急救、消防、理化性质等字段。
> 3. 集成 GHS 象形图选择器。"

**Goal:** 提供深度的 MSDS 内容管理能力。
**Checkpoint:** 各章节内容能正常保存并回显。

---

## 阶段三：移动端小程序开发

### Prompt 5: 小程序首页与扫码逻辑
> "在 `wechatapps/RuoYi-Msds-App` 中开发首页。
> 1. 设计简洁的搜索框和巨大的“扫一扫”按钮。
> 2. 调用 `uni.scanCode` 接口，解析二维码内容（URL/ID）。
> 3. 成功后跳转至详情页 `/pages/msds/detail`。"

**Goal:** 实现现场即时查阅的入口。
**Checkpoint:** 手机模拟器能成功调起扫码。

### Prompt 6: 小程序 MSDS 详情页 (置顶急救)
> "开发移动端详情页。
> 1. 顶部卡片高亮展示：GHS 象形图、核心危险性说明。
> 2. 醒目展示“急救措施”和“泄漏处置”，支持一键拨打实验室电话。
> 3. 下方使用 Webview 或 PDF 插件预览 MSDS 原件全文。"

**Goal:** 确保在应急情况下用户能秒级获取关键信息。
**Checkpoint:** 详情页布局符合 `06-ux-spec.md` 规范。

---

## 阶段四：未来演进功能 (可选)

### Prompt 7: AI 智能解析预研
> "在后端增加一个 AI 解析端点。
> 1. 接收 PDF 文件流，调用 OCR 或大模型接口提取 CAS 和名称。
> 2. 返回解析结果和置信度。
> 3. 前端在上传后自动填充这些字段，并用黄色高亮低置信度内容。"

### Prompt 8: IoT 联动
> "在后端增加一个 IoT 联动端点。
> 1. 接收实验室设备状态（如温度、湿度）。
> 2. 触发对应的 MSDS 文档更新。
> 3. 前端在详情页展示设备状态。"
---

## Final Checklist
- [ ] 后端权限控制 (perms) 与菜单配置已同步。
- [ ] 移动端扫码与 PC 端生成的二维码内容闭环。
- [ ] 审计日志能记录每一次查阅和下载行为。
- [ ] 所有页面在不同分辨率下适配良好。
