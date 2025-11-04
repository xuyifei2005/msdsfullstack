# Cursor Rules 使用说明

本项目的Cursor规则系统旨在为MSDS全栈开发项目提供标准化的开发规范和最佳实践指导。

## 规则文件结构

```
.cursor/rules/
├── project-global.mdc      # 项目全局规则（自动应用）
├── ruoyi-framework.mdc     # RuoYi框架二次开发规范（自动应用）
├── java-backend.mdc        # Java后端开发规则
├── react-frontend.mdc      # React前端开发规则
├── uniapp-mobile.mdc       # UniApp移动端开发规则
├── docker-deployment.mdc   # Docker部署配置规则
└── README.md              # 本说明文档
```

## 规则应用范围

### 🌐 全局规则 (project-global.mdc)
- **应用范围**: 所有文件（alwaysApply: true）
- **内容**: 项目架构概览、RuoYi框架说明、开发环境配置（WSL2 + Docker）、开发基本原则、MSDS业务特定注意事项
- **目的**: 确保团队成员了解项目整体架构和核心开发原则
- **环境说明**: 
  - 项目基于RuoYi框架进行二次开发
  - 后端和前端在Docker容器内编译运行
  - 移动端在HBuilderX和微信开发者工具中开发
  - 数据库为MySQL 8.0，运行在Docker容器中

### 📘 RuoYi框架规范 (ruoyi-framework.mdc) ⭐ 新增
- **应用范围**: 所有文件（alwaysApply: true）
- **内容**: RuoYi框架二次开发规范、代码生成器使用、权限系统、工具类、最佳实践
- **目的**: 确保开发遵循RuoYi框架规范，充分利用框架功能
- **重要性**: 
  - 本项目基于RuoYi-Vue、RuoYi-React、RuoYi-App三个框架
  - 必须遵循RuoYi的分层架构和命名规范
  - 复用RuoYi的用户管理、权限系统等核心功能
  - 通过扩展而非修改的方式实现MSDS业务

### ☕ Java后端规则 (java-backend.mdc)
- **应用范围**: `*.java` 文件
- **内容**: Docker容器内编译运行说明、RuoYi框架规范、Spring Boot最佳实践、MSDS业务逻辑规范
- **目的**: 规范Java后端代码质量，确保遵循企业级开发标准
- **重要提醒**: 所有Java代码必须在Docker容器内编译和运行，不在Windows主机上直接运行Maven

### ⚛️ React前端规则 (react-frontend.mdc)
- **应用范围**: `*.ts`, `*.tsx`, `*.js`, `*.jsx` 文件
- **内容**: Docker容器内编译运行说明、React组件开发、TypeScript类型定义、Ant Design使用规范
- **目的**: 统一前端开发风格，提升用户体验和代码维护性
- **重要提醒**: 前端代码在Docker容器内编译构建，最终通过Nginx容器提供服务

### 📱 UniApp移动端规则 (uniapp-mobile.mdc)
- **应用范围**: `*.vue` 文件和 `pages/**/*.js`, `components/**/*.js`, `utils/**/*.js`
- **内容**: HBuilderX开发流程、微信开发者工具调试、Vue组件开发、跨平台适配、移动端性能优化
- **目的**: 确保移动端应用的性能和兼容性
- **重要提醒**: 移动端不在Docker容器中开发，在Windows主机上使用HBuilderX编译到微信开发者工具

### 🐳 Docker部署规则 (docker-deployment.mdc)
- **应用范围**: Docker相关文件 (`**/docker-compose*.yml`, `**/Dockerfile*`, `**/*.sh`)
- **内容**: WSL2 + Docker Desktop环境配置、MySQL数据库配置、容器化最佳实践、部署脚本规范、监控配置、**CI/CD自动化部署**
- **目的**: 标准化部署流程，提升系统稳定性和可维护性
- **环境说明**: 所有容器运行在Windows 11的WSL2环境中，使用Docker Desktop管理
- **CI/CD**: 使用GitHub Actions进行自动化构建和部署，集成阿里云容器镜像服务

## 如何使用这些规则

### 1. 自动应用的规则
全局规则会自动应用到所有Cursor对话中，无需手动触发。

### 2. 文件特定规则
当您编辑特定类型的文件时，相应的规则会自动激活：
- 编辑 `.java` 文件 → 自动应用Java后端规则
- 编辑 `.tsx` 文件 → 自动应用React前端规则
- 编辑 `.vue` 文件 → 自动应用UniApp移动端规则
- 编辑 `docker-compose.yml` → 自动应用Docker部署规则

### 3. 手动引用规则
您也可以在与AI的对话中手动提及特定规则，例如：
- "请按照Java后端规则重构这个Service类"
- "根据React前端规则优化这个组件"

## 规则内容概览

### 代码质量原则
- **DRY (Don't Repeat Yourself)**: 避免重复代码
- **KISS (Keep It Simple, Stupid)**: 保持代码简单清晰
- **SOLID**: 遵循面向对象设计的五大原则

### 开发流程要求
- **思维链推理**: 从现象→原因→解决方案的逻辑链条思考
- **全局依赖考虑**: 每次修改都要审视相关依赖
- **增量验证**: 每个功能完成后立即测试验证
- **中文优先**: 代码注释、文档、commit信息使用中文

### 技术栈特定规范
- **后端**: Spring Boot + RuoYi框架，MyBatis Plus数据访问
- **前端**: React + TypeScript + Ant Design + Umi框架
- **移动端**: UniApp + Vue + uView UI组件库
- **部署**: Docker Compose + MySQL + Nginx

## 维护和更新

### 修改规则
1. 直接编辑 `.cursor/rules/` 目录下的对应 `.mdc` 文件
2. 遵循Markdown格式和Cursor规则语法
3. 更新后规则会立即生效

### 添加新规则
1. 在 `.cursor/rules/` 目录下创建新的 `.mdc` 文件
2. 设置合适的frontmatter（alwaysApply、globs、description）
3. 编写规则内容

### 最佳实践
- 规则应该具体、可操作，避免过于抽象
- 包含代码示例和反例对比
- 定期review和更新规则内容
- 与团队成员同步规则变更

## 获取帮助

如果您对这些规则有任何疑问或建议，请：
1. 查看项目文档 `aboutproject/` 目录
2. 参考具体的技术手册 `aboutproject/TechnicalManual/`
3. 联系项目架构师进行discussion

---

**注意**: 这些规则是活的文档，会随着项目发展和最佳实践的演进而不断更新。请定期关注规则变更，确保代码符合最新标准。
