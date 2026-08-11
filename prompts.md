# MSDS 实验室管理系统 — 实施开发提示词 (v1.4 同步版)

## Context
本项目基于 RuoYi 框架。v1.4 版本已实现了 Dashboard、AI 智能解析、移动端收藏/历史、帮助中心等核心功能。

**技术栈:**
- 前端: React 18, UmiJS 4, Ant Design 5.
- 后端: Java 17, Spring Boot 3.3.0, MyBatis Plus.
- 移动端: UniApp (Vue 3).

---

## 阶段一：基础架构同步 (检查点)

### Prompt 1: 后端实体与权限同步
> "检查 `ruoyi-system` 模块中已有的业务表：`msds_main`, `msds_import_progress`, `msds_audit_log` 等。
> 
> 要求：
> 1. 验证 `MsdsMain` 实体类是否完整包含 GHS 危险性分类、H/P 声明等 AI 解析字段。
> 2. 检查 `ruoyi-admin` 中的 Controller 是否已实现对应接口。
> 3. 确保所有业务接口都已在 `sys_menu` 中配置权限，并可通过 `@PreAuthorize` 拦截。"

---

## 阶段二：PC 端功能增强与优化

### Prompt 2: Dashboard 数据可视化增强
> "在 `react-ui/src/pages/Dashboard` 基础上：
> 1. 集成 `ECharts` 或 `Ant Design Charts`，优化查阅趋势折线图的交互。
> 2. 增加‘风险品分类分布’饼图，支持点击饼块跳转到对应的列表筛选页。
> 3. 确保系统监控组件能实时反映 `msdsbackend` 容器的资源占用。"

### Prompt 3: AI 解析对比页交互优化
> "优化 `react-ui/src/pages/Msds/AiImport` 页面：
> 1. 实现双栏布局：左侧嵌入 `react-pdf-viewer`，右侧展示 AI 提取表单。
> 2. 增加‘定位’功能：点击表单字段，左侧 PDF 自动滚动到对应关键词区域。
> 3. 完善低置信度字段的视觉提示（如黄色边框）。"

---

## 阶段三：移动端小程序功能完善

### Prompt 4: 搜索建议与热门词推荐
> "在小程序搜索框实现实时联想功能。
> 1. 当用户输入关键词时，调用后端搜索接口返回建议列表。
> 2. 在搜索页展示‘热门搜索’和‘历史搜索’标签，点击标签快速搜索。
> 3. 确保搜索历史能与后端同步，实现多端一致。"

### Prompt 5: 详情页离线缓存策略
> "在小程序详情页引入缓存机制。
> 1. 当用户查阅 MSDS 时，自动将 PDF 摘要和关键元数据存入 `uni.setStorage`。
> 2. 在离线状态下，用户进入详情页应能看到已缓存的摘要信息，并提示‘当前为离线版本’。"

---

## 阶段四：未来演进预研

### Prompt 6: IoT 联动端点预研 (环境传感器)
> "在后端增加 `MsdsIotController`。
> 1. 定义接收传感器数据的 DTO (温度、湿度、VOC 浓度)。
> 2. 实现一个逻辑：当 VOC 浓度超过阈值时，查询该实验室区域关联的所有高风险 MSDS，并触发告警推送。
> 3. 前端 Dashboard 增加‘环境状态’实时监控卡片。"

---

## Final Checklist
- [x] v1.4 已实现功能 (Dashboard, AI, 收藏历史) 运行正常。
- [ ] 审批流程闭环 (Workflow) 逻辑已完全跑通。
- [ ] 移动端搜索建议功能响应时间 < 200ms。
- [ ] 所有新功能均有对应的审计日志记录。
