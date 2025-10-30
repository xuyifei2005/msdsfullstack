# 项目开发规则 - MSDS管理系统

作为本项目的高级系统架构师和Clean Code专家，我为团队制定以下开发规则，旨在确保代码质量、提升开发效率、降低维护成本。所有团队成员必须严格遵守。

## 1. 核心设计原则

- **SOLID**: 
  - **单一职责原则 (SRP)**: 每个组件/模块/函数只做一件事，且做好。
  - **开闭原则 (OCP)**: 对扩展开放，对修改关闭。优先通过增加新代码来扩展功能，而非修改现有稳定代码。
  - **里氏替换原则 (LSP)**: 子类必须能够替换其父类。在组件继承和扩展时需注意。
  - **接口隔离原则 (ISP)**: 使用多个专门的接口，而不是一个庞大的通用接口。在定义组件`props`和`events`时尤为重要。
  - **依赖倒置原则 (DIP)**: 高层模块不应依赖于低层模块，二者都应依赖于抽象。例如，业务逻辑应依赖于抽象的API服务层，而不是具体的`uni.request`实现。

- **DRY (Don't Repeat Yourself)**: 避免重复代码。将通用逻辑、UI元素、工具函数等封装成可复用的组件或模块。

- **KISS (Keep It Simple, Stupid)**: 保持代码和设计的简洁性。避免过度设计和不必要的复杂性。

## 2. uni-app 与 Vue 开发规范

1.  **组件库**: 项目已集成 `uni-ui` 和 `ColorUI`，应优先使用这两个库中的组件来构建界面，以保证UI风格的统一性。在实现设计规范中的iOS风格时，可以利用这两个库或自定义样式来模拟。
2.  **Vue版本**: 项目基于 `Vue 2`，所有代码都必须遵循 `Vue 2` 的语法和API规范。
3.  **跨端兼容性**: 
    - **条件编译**: 优先使用条件编译（`#ifdef`, `#endif`）来处理平台特有的逻辑和UI差异。
    - **API**: 优先使用 `uni-app` 提供的跨端API（`uni.*`），避免直接调用特定平台的原生API（如 `wx.*`），除非必要。
4.  **页面路由**: 所有页面的注册和跳转配置必须在 `pages.json` 中进行统一管理。

## 3. 代码风格与格式化

- **语言**: 遵循 `JavaScript (ES6+)` 和 `Vue 2` 的最新社区标准。
- **格式化**: 推荐在项目中配置 `ESLint` 和 `Prettier`。所有代码在提交前**必须**通过格式化和Lint检查，确保风格统一和代码质量。
- **命名规范**:
  - **目录**: 全部小写，多个单词用 `-` 连接 (kebab-case)，例如 `user-info`。
  - **Vue组件文件**: `PascalCase.vue` (例如: `UserProfile.vue`)。
  - **JS/SCSS文件**: `camelCase.js` 或 `kebab-case.scss` (例如: `userInfo.js`, `global-style.scss`)。
  - **组件名 (in template)**: 使用 `kebab-case` (例如: `<user-profile></user-profile>`)。
  - **变量/函数**: `camelCase` (例如: `let userName`, `function getUserProfile()`)。
  - **常量**: `UPPER_CASE` (例如: `const API_TIMEOUT = 5000`)。
- **注释**: 
  - 对复杂的业务逻辑、算法或临时解决方案添加必要的注释。
  - 公共的、可复用的JS函数/模块应包含 JSDoc 注释。

## 4. 项目结构

项目已基于 `RuoYi-App` 初始化，遵循其既定结构。关键目录规范如下：

```
/
├── api/              # API请求封装，按模块划分
├── components/       # 全局可复用Vue组件
├── config.js         # 全局配置文件 (如API基地址)
├── main.js           # 应用入口文件
├── manifest.json     # uni-app应用配置
├── pages.json        # 页面路由与全局样式配置
├── pages/            # 业务页面，按功能模块划分
├── permission.js     # 路由与权限控制
├── plugins/          # 插件 (如auth.js, modal.js)
├── static/           # 静态资源 (图片, 字体, CSS)
├── store/            # Vuex状态管理
│   ├── index.js      # Vuex入口
│   └── modules/      # 按模块划分的Vuex模块
├── uni.scss          # uni-app内置的全局SCSS变量
└── utils/            # 工具函数
```

## 5. 状态管理

- **选型**: 项目已集成 `Vuex`，所有跨页面、跨组件的共享状态**必须**通过 `Vuex` 进行管理。
- **原则**: 
  - **严格遵循单向数据流**: 只能通过 `mutations` 修改 `state`，异步操作必须在 `actions` 中完成。
  - **模块化**: 按照业务功能在 `store/modules/` 目录下创建独立的Vuex模块。
  - **命名空间**: 为避免冲突，所有Vuex模块**必须**开启命名空间 (`namespaced: true`)。

## 6. 版本控制 (Git)

- **分支模型**: 遵循 `Git Flow` 或类似的稳定分支模型。
  - `main`/`master`: 稳定的生产版本。
  - `develop`: 最新的开发版本。
  - `feature/xxx`: 功能开发分支。
  - `fix/xxx`: Bug修复分支。
- **提交信息**: 遵循 `Conventional Commits` 规范。
  - 格式: `<type>(<scope>): <subject>`
  - 示例: `feat(msds): add search functionality`
  - 示例: `fix(auth): correct login validation logic`
- **Code Review**: 所有向 `develop` 分支合并的请求**必须**经过至少一位其他团队成员的Code Review。

## 7. 测试

- **单元测试**: 推荐使用 `Jest` 对核心业务逻辑（如 `utils` 中的函数）、`Vuex` 的 `actions` 和 `mutations` 编写单元测试。
- **E2E测试**: 对于关键的用户流程（如登录、MSDS搜索、表单提交），推荐使用 `Cypress` 或 `Playwright` 编写端到端测试。
- **自动化**: 鼓励将测试脚本集成到CI/CD流水线中，以实现自动化测试。

## 8. 依赖管理

- **`package.json`**: 虽然当前项目未包含，但强烈建议引入 `package.json` 来管理前端依赖（如 `ESLint`, `Prettier` 等开发工具）。
- **包管理器**: 推荐使用 `npm`, `yarn` 或 `pnpm` 来安装和管理依赖。
- **版本锁定**: **必须**将 `package-lock.json` (或 `yarn.lock`, `pnpm-lock.yaml`) 文件提交到版本库，确保团队成员使用完全一致的依赖版本。
- **`uni_modules`**: uni-app的插件市场模块通过 `uni_modules` 目录管理，遵循其自身的更新机制。

---
*此规则文档将作为项目开发的最高准则，并会根据项目进展持续更新。*