# MSDS 管理文件系统 - 设计规范说明文档

## 1. 文档概述

本文档定义了MSDS管理文件系统PC端Web版本的设计规范，包括视觉风格、组件标准、交互规范等，旨在确保整个产品具有一致性和专业性的用户体验。

**版本**: v1.0  
**创建日期**: 2024年1月  
**设计师**: 高级UI/UX设计师  
**适用平台**: PC端Web浏览器

---

## 2. 设计原则

### 2.1 核心设计原则

- **专业性**: 面向科研实验室的专业化学品管理，界面需体现严肃、可靠的专业感
- **安全性**: 强调化学品安全信息的重要性，通过视觉层次突出安全相关内容
- **效率性**: 优化科研人员的工作流程，减少操作步骤，提升查阅效率
- **一致性**: 保持整个系统的视觉和交互一致性
- **可访问性**: 确保界面在不同分辨率和环境下都能良好显示

### 2.2 设计目标

- 打造现代、专业、易用的实验室管理系统界面
- 建立清晰的信息层次和视觉引导
- 提供直观的操作反馈和状态指示
- 确保关键安全信息的可见性和可读性

---

## 3. 视觉风格系统

### 3.1 色彩规范

#### 主色调 (Primary Colors)
- **主蓝色**: `#3B82F6` (rgb(59, 130, 246))
  - 用途: 主要按钮、链接、活跃状态
  - 悬停: `#2563EB`
  - 禁用: `#93C5FD`

- **深灰色**: `#1F2937` (rgb(31, 41, 55))
  - 用途: 主要文字、导航栏背景
  - 变体: `#374151` (次要背景)

#### 功能色彩 (Functional Colors)
- **成功绿**: `#10B981` - 成功状态、最新版本标识
- **警告橙**: `#F59E0B` - 警告信息、需要关注
- **危险红**: `#EF4444` - 错误状态、危险化学品标识
- **信息蓝**: `#3B82F6` - 信息提示、普通状态

#### 中性色 (Neutral Colors)
- **浅灰**: `#F9FAFB` - 页面背景
- **中灰**: `#6B7280` - 次要文字
- **边框灰**: `#E5E7EB` - 分割线、边框
- **白色**: `#FFFFFF` - 卡片背景、主要内容区

#### GHS危险性标识色彩
- **易燃**: `#EF4444` (红色)
- **腐蚀**: `#DC2626` (深红)
- **毒性**: `#7C2D12` (棕红)
- **刺激**: `#F59E0B` (橙色)
- **环境**: `#059669` (绿色)

### 3.2 字体规范

#### 主要字体
- **中文**: `"PingFang SC", "Microsoft YaHei", "SimHei", sans-serif`
- **英文**: `"Inter", "Helvetica Neue", "Arial", sans-serif`
- **等宽字体** (用于CAS号等): `"JetBrains Mono", "Monaco", monospace`

#### 字体大小层级
- **标题1**: `32px` / `2rem` - 页面主标题
- **标题2**: `24px` / `1.5rem` - 区块标题
- **标题3**: `18px` / `1.125rem` - 卡片标题
- **正文**: `16px` / `1rem` - 主要内容
- **小字**: `14px` / `0.875rem` - 次要信息
- **极小**: `12px` / `0.75rem` - 标签、辅助文字

#### 字重规范
- **粗体**: `font-weight: 700` - 重要标题
- **半粗**: `font-weight: 600` - 次级标题
- **常规**: `font-weight: 400` - 正文内容
- **细体**: `font-weight: 300` - 辅助信息

### 3.3 间距系统

#### 基础间距单位: 4px
- **xs**: `4px` - 细微间距
- **sm**: `8px` - 小间距
- **base**: `16px` - 基础间距
- **lg**: `24px` - 大间距
- **xl**: `32px` - 超大间距
- **2xl**: `48px` - 区块间距
- **3xl**: `64px` - 页面级间距

#### 组件内边距
- **按钮**: `12px 24px`
- **输入框**: `12px 16px`
- **卡片**: `24px`
- **表格单元格**: `12px 16px`

### 3.4 圆角规范
- **小圆角**: `4px` - 按钮、标签
- **中圆角**: `8px` - 卡片、输入框
- **大圆角**: `12px` - 模态框、大卡片
- **圆形**: `50%` - 头像、状态指示器

### 3.5 阴影规范
- **轻微阴影**: `0 1px 3px rgba(0, 0, 0, 0.12)`
- **普通阴影**: `0 4px 6px rgba(0, 0, 0, 0.07)`
- **明显阴影**: `0 10px 25px rgba(0, 0, 0, 0.15)`
- **悬浮阴影**: `0 20px 40px rgba(0, 0, 0, 0.1)`

---

## 4. 组件规范

### 4.1 按钮 (Buttons)

#### 主要按钮 (Primary)
```css
background: #3B82F6;
color: white;
padding: 12px 24px;
border-radius: 8px;
font-weight: 600;
```

#### 次要按钮 (Secondary)
```css
background: transparent;
color: #3B82F6;
border: 1px solid #3B82F6;
padding: 12px 24px;
border-radius: 8px;
```

#### 危险按钮 (Danger)
```css
background: #EF4444;
color: white;
padding: 12px 24px;
border-radius: 8px;
```

### 4.2 输入框 (Input Fields)

#### 基础输入框
```css
border: 1px solid #D1D5DB;
border-radius: 8px;
padding: 12px 16px;
font-size: 16px;
focus: border-color: #3B82F6, box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
```

#### 搜索框
- 带搜索图标
- 较宽的宽度适应
- 实时搜索提示

### 4.3 卡片 (Cards)

#### 标准卡片
```css
background: white;
border-radius: 12px;
box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12);
padding: 24px;
border: 1px solid #F3F4F6;
```

#### 悬浮效果
```css
hover: {
  transform: translateY(-2px);
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
}
```

### 4.4 表格 (Tables)

#### 表头样式
```css
background: #F9FAFB;
font-weight: 600;
color: #374151;
padding: 12px 16px;
border-bottom: 1px solid #E5E7EB;
```

#### 表格行
```css
padding: 16px;
border-bottom: 1px solid #F3F4F6;
hover: background: #F9FAFB;
```

### 4.5 标签 (Tags)

#### 状态标签
- **成功**: 绿色背景 `#ECFDF5`, 绿色文字 `#059669`
- **警告**: 橙色背景 `#FFFBEB`, 橙色文字 `#D97706`
- **危险**: 红色背景 `#FEF2F2`, 红色文字 `#DC2626`
- **信息**: 蓝色背景 `#EFF6FF`, 蓝色文字 `#2563EB`

#### GHS危险性标签
- 小尺寸: `24px × 24px`
- 中尺寸: `32px × 32px`
- 圆角: `4px`
- 白色图标，彩色背景

---

## 5. 交互规范

### 5.1 动效规范

#### 基础动效时长
- **快速**: `150ms` - 悬浮、点击反馈
- **标准**: `300ms` - 状态切换、模态框
- **慢速**: `500ms` - 页面转场

#### 缓动函数
- **标准**: `ease-in-out` - 大部分动效
- **进入**: `ease-out` - 元素出现
- **离开**: `ease-in` - 元素消失

### 5.2 反馈规范

#### 按钮反馈
- 悬浮: 轻微阴影增强
- 点击: 微缩放效果 `scale(0.98)`
- 禁用: 透明度降低至 `0.6`

#### 表单反馈
- 聚焦: 边框颜色改变 + 外围光晕
- 错误: 红色边框 + 错误提示
- 成功: 绿色边框 + 成功图标

### 5.3 状态指示

#### 加载状态
- 使用统一的加载动画
- 骨架屏用于内容加载
- 进度条用于文件上传

#### 数据状态
- 空状态: 友好的空状态插图
- 错误状态: 明确的错误信息和解决建议
- 成功状态: 绿色勾选图标确认

---

## 6. 图标系统

### 6.1 图标库
**使用 FontAwesome 6.4.0**

### 6.2 核心图标定义

#### 导航图标
- 仪表板: `fa-tachometer-alt`
- 搜索: `fa-search`
- 文档管理: `fa-file-alt`
- 上传: `fa-cloud-upload-alt`
- 用户管理: `fa-users`
- 设置: `fa-cog`

#### 操作图标
- 编辑: `fa-edit`
- 删除: `fa-trash`
- 下载: `fa-download`
- 预览: `fa-eye`
- 收藏: `fa-star`
- 分享: `fa-share`

#### 状态图标
- 成功: `fa-check-circle`
- 警告: `fa-exclamation-triangle`
- 错误: `fa-times-circle`
- 信息: `fa-info-circle`

#### 化学相关图标
- 化学烧瓶: `fa-flask`
- 安全: `fa-shield-alt`
- 火焰: `fa-fire`
- 感叹号: `fa-exclamation`

### 6.3 图标使用规范

#### 尺寸规范
- **小**: `14px` - 内联图标
- **标准**: `16px` - 按钮图标
- **中**: `20px` - 导航图标
- **大**: `24px` - 页面图标
- **超大**: `32px` - 功能区图标

#### 颜色规范
- 跟随文字颜色
- 功能性图标使用对应的功能色彩
- 悬浮时可有颜色变化

---

## 7. 响应式设计

### 7.1 断点设置
- **Desktop**: ≥ 1024px
- **Tablet**: 768px - 1023px
- **Mobile**: < 768px

### 7.2 布局适配
- **桌面优先**: 主要针对PC端设计
- **适度响应**: 确保在中等屏幕上可用
- **移动友好**: 基本功能在移动设备上可访问

---

## 8. 可访问性规范

### 8.1 颜色对比度
- 正文文字对比度 ≥ 4.5:1
- 大号文字对比度 ≥ 3:1
- 非文字元素对比度 ≥ 3:1

### 8.2 键盘导航
- 所有交互元素支持Tab键导航
- 明确的焦点指示器
- 合理的Tab顺序

### 8.3 屏幕阅读器
- 语义化HTML结构
- 适当的ARIA标签
- 图片alt文本描述

---

## 9. 设计资源

### 9.1 设计文件组织
```
design/
├── prototypes/          # HTML原型文件
│   ├── index.html      # 主入口展示页
│   ├── login.html      # 登录界面
│   ├── dashboard.html  # 仪表板
│   ├── search.html     # 搜索界面
│   ├── msds-detail.html # MSDS详情
│   ├── msds-management.html # 文档管理
│   ├── user-management.html # 用户管理
│   └── settings.html   # 系统设置
├── specs/              # 设计规范文档
│   └── Design_Spec.md  # 本文档
└── assets/             # 设计资源
    ├── images/         # 图片资源
    ├── icons/          # 自定义图标
    └── fonts/          # 字体文件
```

### 9.2 代码规范
- 使用Tailwind CSS实现样式
- 保持HTML语义化
- 组件化的CSS类命名
- 响应式优先的开发方式

---

## 10. 版本记录

| 版本 | 日期 | 更新内容 | 更新人 |
|------|------|----------|--------|
| v1.0 | 2024-01-15 | 初始版本创建，包含完整设计规范 | 高级UI/UX设计师 |

---

## 11. 附录

### 11.1 设计检查清单
- [ ] 色彩对比度符合可访问性要求
- [ ] 字体大小清晰可读
- [ ] 间距布局符合规范
- [ ] 交互反馈及时明确
- [ ] 状态指示清晰易懂
- [ ] 图标语义正确
- [ ] 响应式适配良好

### 11.2 设计参考
- [Material Design Guidelines](https://material.io/design)
- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [Web Content Accessibility Guidelines (WCAG) 2.1](https://www.w3.org/WAI/WCAG21/quickref/)

---

**文档结束** 