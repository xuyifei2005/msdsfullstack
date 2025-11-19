# PC端MSDS管理系统UI设计规范

## 1. 设计概述

### 1.1 设计理念
本设计规范基于现代化的企业级应用设计理念，结合科研环境的专业性要求，旨在为MSDS管理系统提供一致、高效、专业的用户界面设计标准。

### 1.2 设计原则
- **专业性**：体现科研环境的严谨性和专业性
- **一致性**：保持界面元素和交互方式的统一
- **高效性**：优化操作流程，提高工作效率
- **可用性**：界面简洁明了，易于理解和操作
- **可访问性**：考虑不同用户群体的使用需求
- **可扩展性**：设计系统能够适应未来功能扩展

### 1.3 目标用户
- **科研人员**：主要使用者，需要快速查阅MSDS信息
- **实验室管理员**：负责MSDS数据的管理和维护
- **安全管理员**：关注化学品安全合规性
- **系统管理员**：负责系统配置和用户管理

## 2. 视觉设计规范

### 2.1 色彩系统

#### 2.1.1 主色调
```css
/* 主品牌色 - 专业蓝 */
--primary-color: #1890ff;
--primary-light: #40a9ff;
--primary-dark: #096dd9;
--primary-hover: #40a9ff;
--primary-active: #096dd9;
```

#### 2.1.2 辅助色彩
```css
/* 成功色 */
--success-color: #52c41a;
--success-light: #73d13d;
--success-dark: #389e0d;

/* 警告色 */
--warning-color: #faad14;
--warning-light: #ffc53d;
--warning-dark: #d48806;

/* 错误色 */
--error-color: #ff4d4f;
--error-light: #ff7875;
--error-dark: #cf1322;

/* 信息色 */
--info-color: #1890ff;
--info-light: #40a9ff;
--info-dark: #096dd9;
```

#### 2.1.3 中性色彩
```css
/* 文字色彩 */
--text-primary: #262626;
--text-secondary: #595959;
--text-tertiary: #8c8c8c;
--text-quaternary: #bfbfbf;
--text-disabled: #d9d9d9;

/* 背景色彩 */
--bg-primary: #ffffff;
--bg-secondary: #fafafa;
--bg-tertiary: #f5f5f5;
--bg-quaternary: #f0f0f0;
--bg-disabled: #f5f5f5;

/* 边框色彩 */
--border-primary: #d9d9d9;
--border-secondary: #f0f0f0;
--border-light: #f5f5f5;
```

#### 2.1.4 危险等级色彩（GHS标准）
```css
/* 极高危险 */
--danger-critical: #d32f2f;
/* 高危险 */
--danger-high: #f57c00;
/* 中等危险 */
--danger-medium: #fbc02d;
/* 低危险 */
--danger-low: #388e3c;
/* 无危险 */
--danger-none: #757575;
```

### 2.2 字体规范

#### 2.2.1 字体族
```css
/* 主字体 */
--font-family-primary: "Microsoft YaHei", "PingFang SC", "Helvetica Neue", Arial, sans-serif;

/* 等宽字体（用于代码、CAS号等） */
--font-family-mono: "SF Mono", Monaco, "Cascadia Code", "Roboto Mono", Consolas, "Courier New", monospace;

/* 数字字体 */
--font-family-number: "SF Pro Display", "PingFang SC", "Helvetica Neue", Arial, sans-serif;
```

#### 2.2.2 字体大小
```css
/* 标题字体 */
--font-size-h1: 24px;
--font-size-h2: 20px;
--font-size-h3: 18px;
--font-size-h4: 16px;
--font-size-h5: 14px;
--font-size-h6: 12px;

/* 正文字体 */
--font-size-large: 16px;
--font-size-base: 14px;
--font-size-small: 12px;
--font-size-mini: 10px;
```

#### 2.2.3 字体权重
```css
--font-weight-light: 300;
--font-weight-normal: 400;
--font-weight-medium: 500;
--font-weight-semibold: 600;
--font-weight-bold: 700;
```

#### 2.2.4 行高
```css
--line-height-tight: 1.2;
--line-height-normal: 1.5;
--line-height-relaxed: 1.6;
--line-height-loose: 2.0;
```

### 2.3 间距系统

#### 2.3.1 基础间距
```css
/* 基础间距单位 */
--spacing-xs: 4px;
--spacing-sm: 8px;
--spacing-md: 16px;
--spacing-lg: 24px;
--spacing-xl: 32px;
--spacing-xxl: 48px;
--spacing-xxxl: 64px;
```

#### 2.3.2 组件间距
```css
/* 组件内部间距 */
--component-padding-xs: 4px 8px;
--component-padding-sm: 8px 12px;
--component-padding-md: 12px 16px;
--component-padding-lg: 16px 24px;
--component-padding-xl: 24px 32px;

/* 组件外部间距 */
--component-margin-xs: 4px;
--component-margin-sm: 8px;
--component-margin-md: 16px;
--component-margin-lg: 24px;
--component-margin-xl: 32px;
```

### 2.4 圆角规范
```css
--border-radius-xs: 2px;
--border-radius-sm: 4px;
--border-radius-md: 6px;
--border-radius-lg: 8px;
--border-radius-xl: 12px;
--border-radius-round: 50%;
```

### 2.5 阴影规范
```css
/* 卡片阴影 */
--shadow-card: 0 2px 8px rgba(0, 0, 0, 0.1);
--shadow-card-hover: 0 4px 16px rgba(0, 0, 0, 0.15);

/* 弹窗阴影 */
--shadow-modal: 0 8px 32px rgba(0, 0, 0, 0.2);

/* 下拉阴影 */
--shadow-dropdown: 0 4px 12px rgba(0, 0, 0, 0.15);

/* 按钮阴影 */
--shadow-button: 0 2px 4px rgba(0, 0, 0, 0.1);
```

## 3. 组件设计规范

### 3.1 按钮组件

#### 3.1.1 按钮类型
**主要按钮（Primary Button）**
- 用途：主要操作，如提交、保存、确认
- 样式：蓝色背景，白色文字
- 状态：默认、悬停、激活、禁用

**次要按钮（Secondary Button）**
- 用途：次要操作，如取消、重置
- 样式：白色背景，蓝色边框和文字
- 状态：默认、悬停、激活、禁用

**危险按钮（Danger Button）**
- 用途：危险操作，如删除、清空
- 样式：红色背景，白色文字
- 状态：默认、悬停、激活、禁用

**文本按钮（Text Button）**
- 用途：轻量级操作，如链接、更多
- 样式：无背景，蓝色文字
- 状态：默认、悬停、激活、禁用

#### 3.1.2 按钮尺寸
```css
/* 大按钮 */
.btn-large {
  height: 40px;
  padding: 0 24px;
  font-size: 16px;
}

/* 中等按钮 */
.btn-medium {
  height: 32px;
  padding: 0 16px;
  font-size: 14px;
}

/* 小按钮 */
.btn-small {
  height: 24px;
  padding: 0 12px;
  font-size: 12px;
}
```

#### 3.1.3 按钮状态
```css
/* 默认状态 */
.btn-primary {
  background-color: var(--primary-color);
  border-color: var(--primary-color);
  color: #ffffff;
}

/* 悬停状态 */
.btn-primary:hover {
  background-color: var(--primary-hover);
  border-color: var(--primary-hover);
}

/* 激活状态 */
.btn-primary:active {
  background-color: var(--primary-active);
  border-color: var(--primary-active);
}

/* 禁用状态 */
.btn-primary:disabled {
  background-color: var(--bg-disabled);
  border-color: var(--border-primary);
  color: var(--text-disabled);
  cursor: not-allowed;
}
```

### 3.2 输入组件

#### 3.2.1 文本输入框
```css
.input {
  height: 32px;
  padding: 4px 12px;
  border: 1px solid var(--border-primary);
  border-radius: var(--border-radius-sm);
  font-size: var(--font-size-base);
  transition: all 0.3s;
}

.input:focus {
  border-color: var(--primary-color);
  box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.2);
  outline: none;
}

.input:disabled {
  background-color: var(--bg-disabled);
  color: var(--text-disabled);
  cursor: not-allowed;
}

.input.error {
  border-color: var(--error-color);
}

.input.error:focus {
  box-shadow: 0 0 0 2px rgba(255, 77, 79, 0.2);
}
```

#### 3.2.2 搜索框
```css
.search-input {
  position: relative;
  display: flex;
  align-items: center;
}

.search-input input {
  padding-left: 40px;
  border-radius: var(--border-radius-lg);
}

.search-input .search-icon {
  position: absolute;
  left: 12px;
  color: var(--text-tertiary);
  z-index: 1;
}
```

#### 3.2.3 选择器
```css
.select {
  min-width: 120px;
  height: 32px;
  border: 1px solid var(--border-primary);
  border-radius: var(--border-radius-sm);
  background-color: var(--bg-primary);
  cursor: pointer;
}

.select:hover {
  border-color: var(--primary-hover);
}

.select.open {
  border-color: var(--primary-color);
  box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.2);
}
```

### 3.3 表格组件

#### 3.3.1 表格样式
```css
.table {
  width: 100%;
  border-collapse: collapse;
  background-color: var(--bg-primary);
}

.table th {
  background-color: var(--bg-tertiary);
  padding: 12px 16px;
  text-align: left;
  font-weight: var(--font-weight-medium);
  border-bottom: 1px solid var(--border-primary);
}

.table td {
  padding: 12px 16px;
  border-bottom: 1px solid var(--border-secondary);
}

.table tr:hover {
  background-color: var(--bg-secondary);
}

.table tr.selected {
  background-color: rgba(24, 144, 255, 0.1);
}
```

#### 3.3.2 表格操作
```css
.table-actions {
  display: flex;
  gap: var(--spacing-sm);
  justify-content: flex-end;
  margin-bottom: var(--spacing-md);
}

.table-pagination {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: var(--spacing-md);
  padding: var(--spacing-md) 0;
}
```

### 3.4 卡片组件

#### 3.4.1 基础卡片
```css
.card {
  background-color: var(--bg-primary);
  border: 1px solid var(--border-secondary);
  border-radius: var(--border-radius-lg);
  box-shadow: var(--shadow-card);
  overflow: hidden;
}

.card:hover {
  box-shadow: var(--shadow-card-hover);
}

.card-header {
  padding: var(--spacing-md) var(--spacing-lg);
  border-bottom: 1px solid var(--border-secondary);
  background-color: var(--bg-secondary);
}

.card-body {
  padding: var(--spacing-lg);
}

.card-footer {
  padding: var(--spacing-md) var(--spacing-lg);
  border-top: 1px solid var(--border-secondary);
  background-color: var(--bg-secondary);
}
```

#### 3.4.2 MSDS卡片
```css
.msds-card {
  position: relative;
  cursor: pointer;
  transition: all 0.3s;
}

.msds-card .danger-level {
  position: absolute;
  top: var(--spacing-md);
  right: var(--spacing-md);
  width: 12px;
  height: 12px;
  border-radius: var(--border-radius-round);
}

.msds-card .chemical-name {
  font-size: var(--font-size-h4);
  font-weight: var(--font-weight-medium);
  margin-bottom: var(--spacing-sm);
}

.msds-card .cas-number {
  font-family: var(--font-family-mono);
  color: var(--text-secondary);
  font-size: var(--font-size-small);
}
```

### 3.5 导航组件

#### 3.5.1 顶部导航
```css
.navbar {
  height: 64px;
  background-color: var(--bg-primary);
  border-bottom: 1px solid var(--border-secondary);
  display: flex;
  align-items: center;
  padding: 0 var(--spacing-lg);
  box-shadow: var(--shadow-card);
}

.navbar-brand {
  font-size: var(--font-size-h3);
  font-weight: var(--font-weight-bold);
  color: var(--primary-color);
}

.navbar-menu {
  display: flex;
  margin-left: auto;
  gap: var(--spacing-lg);
}

.navbar-item {
  padding: var(--spacing-sm) var(--spacing-md);
  border-radius: var(--border-radius-sm);
  cursor: pointer;
  transition: all 0.3s;
}

.navbar-item:hover {
  background-color: var(--bg-secondary);
}

.navbar-item.active {
  background-color: var(--primary-color);
  color: var(--bg-primary);
}
```

#### 3.5.2 侧边导航
```css
.sidebar {
  width: 240px;
  background-color: var(--bg-primary);
  border-right: 1px solid var(--border-secondary);
  height: 100vh;
  overflow-y: auto;
}

.sidebar-menu {
  padding: var(--spacing-md);
}

.sidebar-item {
  display: flex;
  align-items: center;
  padding: var(--spacing-md);
  border-radius: var(--border-radius-sm);
  cursor: pointer;
  transition: all 0.3s;
  margin-bottom: var(--spacing-xs);
}

.sidebar-item:hover {
  background-color: var(--bg-secondary);
}

.sidebar-item.active {
  background-color: rgba(24, 144, 255, 0.1);
  color: var(--primary-color);
}

.sidebar-item .icon {
  margin-right: var(--spacing-md);
  font-size: 16px;
}
```

### 3.6 模态框组件

#### 3.6.1 基础模态框
```css
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal {
  background-color: var(--bg-primary);
  border-radius: var(--border-radius-lg);
  box-shadow: var(--shadow-modal);
  max-width: 90vw;
  max-height: 90vh;
  overflow: hidden;
}

.modal-header {
  padding: var(--spacing-lg);
  border-bottom: 1px solid var(--border-secondary);
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.modal-title {
  font-size: var(--font-size-h3);
  font-weight: var(--font-weight-medium);
}

.modal-close {
  background: none;
  border: none;
  font-size: 20px;
  cursor: pointer;
  color: var(--text-tertiary);
}

.modal-body {
  padding: var(--spacing-lg);
  overflow-y: auto;
}

.modal-footer {
  padding: var(--spacing-lg);
  border-top: 1px solid var(--border-secondary);
  display: flex;
  justify-content: flex-end;
  gap: var(--spacing-md);
}
```

### 3.7 表单组件

#### 3.7.1 表单布局
```css
.form {
  max-width: 600px;
}

.form-group {
  margin-bottom: var(--spacing-lg);
}

.form-label {
  display: block;
  margin-bottom: var(--spacing-sm);
  font-weight: var(--font-weight-medium);
  color: var(--text-primary);
}

.form-label.required::after {
  content: " *";
  color: var(--error-color);
}

.form-control {
  width: 100%;
  padding: var(--spacing-sm) var(--spacing-md);
  border: 1px solid var(--border-primary);
  border-radius: var(--border-radius-sm);
  font-size: var(--font-size-base);
  transition: all 0.3s;
}

.form-control:focus {
  border-color: var(--primary-color);
  box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.2);
  outline: none;
}

.form-help {
  margin-top: var(--spacing-xs);
  font-size: var(--font-size-small);
  color: var(--text-tertiary);
}

.form-error {
  margin-top: var(--spacing-xs);
  font-size: var(--font-size-small);
  color: var(--error-color);
}
```

#### 3.7.2 表单验证
```css
.form-control.error {
  border-color: var(--error-color);
}

.form-control.error:focus {
  box-shadow: 0 0 0 2px rgba(255, 77, 79, 0.2);
}

.form-control.success {
  border-color: var(--success-color);
}

.form-control.success:focus {
  box-shadow: 0 0 0 2px rgba(82, 196, 26, 0.2);
}
```

## 4. 布局规范

### 4.1 网格系统

#### 4.1.1 容器
```css
.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 var(--spacing-lg);
}

.container-fluid {
  width: 100%;
  padding: 0 var(--spacing-lg);
}
```

#### 4.1.2 网格布局
```css
.row {
  display: flex;
  flex-wrap: wrap;
  margin: 0 calc(var(--spacing-md) / -2);
}

.col {
  flex: 1;
  padding: 0 calc(var(--spacing-md) / 2);
}

.col-1 { flex: 0 0 8.333333%; }
.col-2 { flex: 0 0 16.666667%; }
.col-3 { flex: 0 0 25%; }
.col-4 { flex: 0 0 33.333333%; }
.col-6 { flex: 0 0 50%; }
.col-8 { flex: 0 0 66.666667%; }
.col-9 { flex: 0 0 75%; }
.col-12 { flex: 0 0 100%; }
```

### 4.2 页面布局

#### 4.2.1 主布局
```css
.app-layout {
  display: flex;
  height: 100vh;
}

.app-sidebar {
  flex: 0 0 240px;
  background-color: var(--bg-primary);
  border-right: 1px solid var(--border-secondary);
}

.app-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.app-header {
  flex: 0 0 64px;
  background-color: var(--bg-primary);
  border-bottom: 1px solid var(--border-secondary);
}

.app-content {
  flex: 1;
  padding: var(--spacing-lg);
  overflow-y: auto;
  background-color: var(--bg-secondary);
}
```

#### 4.2.2 内容区域
```css
.content-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: var(--spacing-lg);
}

.content-title {
  font-size: var(--font-size-h2);
  font-weight: var(--font-weight-medium);
  color: var(--text-primary);
}

.content-actions {
  display: flex;
  gap: var(--spacing-md);
}

.content-body {
  background-color: var(--bg-primary);
  border-radius: var(--border-radius-lg);
  padding: var(--spacing-lg);
  box-shadow: var(--shadow-card);
}
```

## 5. 交互规范

### 5.1 动画效果

#### 5.1.1 过渡动画
```css
/* 基础过渡 */
.transition-base {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* 快速过渡 */
.transition-fast {
  transition: all 0.15s cubic-bezier(0.4, 0, 0.2, 1);
}

/* 慢速过渡 */
.transition-slow {
  transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}
```

#### 5.1.2 加载动画
```css
@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.loading-spinner {
  animation: spin 1s linear infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}

.loading-pulse {
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}
```

### 5.2 状态反馈

#### 5.2.1 悬停状态
```css
.hover-lift {
  transition: transform 0.3s, box-shadow 0.3s;
}

.hover-lift:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-card-hover);
}
```

#### 5.2.2 激活状态
```css
.active-scale {
  transition: transform 0.15s;
}

.active-scale:active {
  transform: scale(0.98);
}
```

### 5.3 响应式设计

#### 5.3.1 断点定义
```css
/* 断点变量 */
:root {
  --breakpoint-xs: 480px;
  --breakpoint-sm: 768px;
  --breakpoint-md: 992px;
  --breakpoint-lg: 1200px;
  --breakpoint-xl: 1600px;
}
```

#### 5.3.2 媒体查询
```css
/* 小屏设备 */
@media (max-width: 767px) {
  .app-layout {
    flex-direction: column;
  }
  
  .app-sidebar {
    flex: 0 0 auto;
    width: 100%;
    height: auto;
  }
  
  .container {
    padding: 0 var(--spacing-md);
  }
}

/* 中等屏幕 */
@media (min-width: 768px) and (max-width: 991px) {
  .app-sidebar {
    flex: 0 0 200px;
  }
}

/* 大屏幕 */
@media (min-width: 1200px) {
  .container {
    max-width: 1400px;
  }
}
```

## 6. 图标规范

### 6.1 图标库
推荐使用 **Ant Design Icons** 或 **Feather Icons** 作为主要图标库，确保图标风格的一致性。

### 6.2 图标尺寸
```css
.icon-xs { font-size: 12px; }
.icon-sm { font-size: 14px; }
.icon-md { font-size: 16px; }
.icon-lg { font-size: 20px; }
.icon-xl { font-size: 24px; }
.icon-xxl { font-size: 32px; }
```

### 6.3 图标颜色
```css
.icon-primary { color: var(--primary-color); }
.icon-success { color: var(--success-color); }
.icon-warning { color: var(--warning-color); }
.icon-error { color: var(--error-color); }
.icon-muted { color: var(--text-tertiary); }
```

### 6.4 常用图标映射
- **搜索**：search
- **添加**：plus
- **编辑**：edit
- **删除**：delete / trash
- **下载**：download
- **上传**：upload
- **设置**：settings
- **用户**：user
- **文件**：file
- **文件夹**：folder
- **危险**：alert-triangle
- **成功**：check-circle
- **信息**：info-circle

## 7. 可访问性规范

### 7.1 颜色对比度
- 正常文本：对比度至少 4.5:1
- 大文本（18px+）：对比度至少 3:1
- 图形和UI组件：对比度至少 3:1

### 7.2 键盘导航
- 所有交互元素必须支持键盘访问
- 焦点指示器必须清晰可见
- Tab键顺序必须逻辑合理

### 7.3 屏幕阅读器支持
- 使用语义化HTML标签
- 提供适当的ARIA标签
- 图片必须有alt属性
- 表单控件必须有标签

## 8. 性能优化

### 8.1 CSS优化
- 使用CSS变量减少重复代码
- 避免深层嵌套选择器
- 使用transform和opacity进行动画
- 合理使用will-change属性

### 8.2 图片优化
- 使用适当的图片格式（WebP优先）
- 提供不同分辨率的图片
- 实现图片懒加载
- 使用CSS Sprites减少HTTP请求

### 8.3 字体优化
- 使用font-display: swap
- 预加载关键字体
- 使用系统字体作为fallback

## 9. 浏览器兼容性

### 9.1 支持的浏览器
- Chrome 88+
- Firefox 85+
- Safari 14+
- Edge 88+

### 9.2 兼容性处理
- 使用Autoprefixer处理CSS前缀
- 提供Polyfill支持旧版本浏览器
- 使用feature detection而非browser detection

## 10. 设计工具和资源

### 10.1 推荐工具
- **设计工具**：Figma, Sketch
- **原型工具**：Figma, Principle
- **图标工具**：Iconfont, Feather Icons
- **颜色工具**：Coolors, Adobe Color

### 10.2 设计资源
- **字体**：思源黑体, Inter, SF Pro
- **图片**：Unsplash, Pexels
- **插图**：unDraw, Illustrations

## 11. 维护和更新

### 11.1 版本控制
- 使用语义化版本号（Semantic Versioning）
- 记录每次更新的变更内容
- 提供迁移指南

### 11.2 反馈机制
- 定期收集用户反馈
- 监控设计系统使用情况
- 持续优化和改进

### 11.3 文档维护
- 保持文档的实时性
- 提供使用示例和最佳实践
- 定期审查和更新规范

---

本设计规范将作为PC端MSDS管理系统UI设计的权威指南，确保整个系统的视觉一致性和用户体验质量。所有设计和开发人员都应严格遵循本规范进行工作。