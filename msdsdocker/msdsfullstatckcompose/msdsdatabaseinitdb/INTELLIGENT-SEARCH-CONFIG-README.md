# 智能搜索菜单配置说明

## ✅ 配置完成状态

### 当前配置
"智能搜索"已成功配置为一级菜单，并实现了**点击直接跳转到搜索页面**的效果。

### 菜单结构

```
智能搜索（一级目录）
  └── 搜索页面（二级菜单，隐藏）
```

### 配置详情

| 项目 | 智能搜索（一级） | 搜索页面（二级） |
|-----|--------------|----------------|
| menu_id | 2036 | 2042 |
| parent_id | 0 | 2036 |
| menu_type | M（目录） | C（菜单） |
| component | NULL | Msds/IntelligentSearch |
| path | intelligent-search | index |
| visible | 0（显示） | 1（隐藏）⭐ |
| order_num | 1（第二位） | 1 |
| icon | search | search |

### 访问路径
```
/intelligent-search/index
```

## 🎯 用户体验

### 左侧导航栏显示
```
📊 控制台
🔍 智能搜索  ⬅️ 点击这里
👤 个人
📁 MSDS管理
  ├── MSDS信息
  ├── MSDS文档
  └── MSDS详情（隐藏）
⚙️ 系统监控
🔧 系统工具
⚙️ 系统管理
```

### 点击行为
1. **用户看到**：左侧导航栏只显示"智能搜索"，没有子菜单展开图标
2. **点击后**：直接进入智能搜索页面
3. **路由地址**：浏览器地址栏显示 `/intelligent-search/index`
4. **面包屑**：显示 "智能搜索 / 搜索页面"

### 技术原理
- 一级菜单是目录类型（M），作为路由容器
- 二级菜单（实际页面）设为隐藏（visible='1'）
- 前端自动跳转到第一个可用的子路由
- 用户体验上感觉像"直接点击一级菜单打开页面"

## 🔧 必须执行的操作

### ⚠️ 清理前端缓存（必须！）

配置完成后，**必须清理浏览器缓存**才能看到更新的菜单。

#### 方法1：浏览器控制台（推荐）

1. 按 `F12` 打开开发者工具
2. 切换到 **Console（控制台）** 标签
3. 执行以下命令：

```javascript
// 清理所有本地存储
localStorage.clear()

// 刷新页面
location.reload()
```

#### 方法2：强制刷新
- Windows: `Ctrl + Shift + R` 或 `Ctrl + F5`
- Mac: `Cmd + Shift + R`

#### 方法3：重新登录
1. 点击右上角退出登录
2. 关闭浏览器标签页
3. 重新打开浏览器并登录系统

## 📊 菜单排序

当前一级菜单排序（从上到下）：

| 排序 | 菜单名称 | order_num |
|-----|---------|-----------|
| 1 | 控制台 | 0 |
| 2 | **智能搜索** ⭐ | 1 |
| 3 | 个人 | 6 |
| 4 | MSDS管理 | 10 |
| 5 | 系统监控 | 11 |
| 6 | 系统工具 | 12 |
| 7 | 系统管理 | 50 |
| 8 | 若依官网 | 100 |

## 🔍 如何调整菜单位置

如果想调整智能搜索在导航栏中的位置，修改 `order_num` 字段：

```sql
-- 将智能搜索移到最顶部（第一位）
UPDATE sys_menu SET order_num = -1 WHERE menu_id = 2036;

-- 将智能搜索移到MSDS管理之后
UPDATE sys_menu SET order_num = 11 WHERE menu_id = 2036;
```

## 💡 其他配置选项

### 选项A：显示子菜单（展开式）

如果您希望点击"智能搜索"后显示子菜单（而不是直接跳转）：

```sql
UPDATE sys_menu SET visible = '0' WHERE menu_id = 2042;
```

效果：
```
智能搜索
  └── 搜索页面  ⬅️ 显示这个子菜单
```

### 选项B：修改菜单名称

```sql
-- 修改一级菜单名称
UPDATE sys_menu SET menu_name = 'MSDS搜索' WHERE menu_id = 2036;

-- 修改子菜单名称
UPDATE sys_menu SET menu_name = '搜索' WHERE menu_id = 2042;
```

### 选项C：更换图标

```sql
UPDATE sys_menu SET icon = 'SearchOutlined' WHERE menu_id = 2036;
```

常用图标：
- `SearchOutlined` - 放大镜
- `FileSearchOutlined` - 文件搜索
- `AuditOutlined` - 审计
- `ScanOutlined` - 扫描

## 🐛 故障排查

### 问题1：清理缓存后仍然看不到菜单

**解决方案**：
```javascript
// 在浏览器控制台执行
localStorage.clear()
sessionStorage.clear()
location.href = '/user/login'  // 强制返回登录页
```

### 问题2：点击后显示404

**检查路由配置**：
1. 确认组件路径：`Msds/IntelligentSearch`
2. 确认文件存在：`react-ui/src/pages/Msds/IntelligentSearch/index.tsx`

### 问题3：导航栏消失了

**原因**：菜单配置错误导致前端解析失败

**解决方案**：
```sql
-- 恢复为标准的二级菜单配置
UPDATE sys_menu SET parent_id = 2000 WHERE menu_id = 2036;
```

然后清理缓存，刷新页面。

## 📝 配置脚本位置

- 完整配置脚本：`msdsdocker/msdsfullstatckcompose/msdsdatabaseinitdb/setup-intelligent-search-direct.sql`
- 菜单修复脚本：`msdsdocker/msdsfullstatckcompose/msdsdatabaseinitdb/fix-menu-structure.sql`
- 原始配置脚本：`msdsdocker/msdsfullstatckcompose/msdsdatabaseinitdb/03-msds-menu-config.sql`

## 📞 技术支持

如有问题，请检查：
1. 浏览器控制台的错误信息（F12 → Console）
2. 后端日志：`docker logs msdsbackend`
3. 前端日志：`docker logs msdsfrontend`

---

**配置日期**: 2025-01-XX  
**最后更新**: 2025-01-XX  
**配置状态**: ✅ 已完成并验证

