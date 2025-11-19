# RuoYi框架二次开发说明

**项目**: MSDS全栈管理系统  
**基础框架**: RuoYi开源框架  
**文档日期**: 2025年1月

---

## 📚 项目框架基础

### 核心说明

本MSDS管理系统**完全基于开源RuoYi框架**进行二次开发，充分利用RuoYi提供的企业级基础功能，在此基础上扩展MSDS业务模块。

### 使用的RuoYi框架版本

| 框架组件 | 版本 | 用途 | 项目路径 |
|---------|------|------|---------|
| **RuoYi-Vue** | 后端框架 | Java后端服务 | msdsPC/ruoyi-MsdsPc-react |
| **RuoYi-React** | 前端框架 | Web管理后台 | msdsPC/ruoyi-MsdsPc-react/ruoyi-ui |
| **RuoYi-App** | 移动端框架 | 微信小程序 | wechatapps/RuoYi-Msds-App |

### RuoYi官方资源

- **官方文档**: https://doc.ruoyi.vip/
- **代码仓库**: https://gitee.com/y_project/RuoYi-Vue
- **在线演示**: http://vue.ruoyi.vip/
- **视频教程**: https://space.bilibili.com/490747061
- **开发手册**: https://doc.ruoyi.vip/ruoyi-vue/document/hjbs.html

---

## 🎯 RuoYi核心功能复用

### 后端（RuoYi-Vue）

#### 系统管理模块（完全复用）
- ✅ **用户管理**: sys_user表，用户CRUD、密码管理、状态管理
- ✅ **角色管理**: sys_role表，角色CRUD、权限分配
- ✅ **菜单管理**: sys_menu表，动态菜单、权限控制
- ✅ **部门管理**: sys_dept表，部门树形结构
- ✅ **岗位管理**: sys_post表，岗位信息管理
- ✅ **字典管理**: sys_dict_type/sys_dict_data，数据字典

#### 系统监控模块（完全复用）
- ✅ **在线用户**: 在线用户监控和强制下线
- ✅ **定时任务**: quartz定时任务管理
- ✅ **数据监控**: Druid数据源监控
- ✅ **服务监控**: 服务器资源监控
- ✅ **缓存监控**: Redis缓存监控

#### 系统工具模块（完全复用）
- ✅ **表单构建**: 拖拽式表单设计器
- ✅ **代码生成**: 自动生成CRUD代码
- ✅ **系统接口**: Swagger API文档

#### 日志模块（完全复用）
- ✅ **操作日志**: sys_oper_log，记录用户操作
- ✅ **登录日志**: sys_logininfor，记录登录信息

### 前端（RuoYi-React）

#### 布局组件（复用）
- ✅ **ProLayout**: Ant Design Pro布局组件
- ✅ **动态菜单**: 根据权限动态生成菜单
- ✅ **面包屑导航**: 自动生成面包屑
- ✅ **标签页**: 多标签页切换

#### 权限组件（复用）
- ✅ **路由守卫**: 权限路由控制
- ✅ **权限指令**: v-hasPermi指令
- ✅ **按钮权限**: 根据权限显示/隐藏按钮

#### 公共组件（复用）
- ✅ **字典标签**: DictTag组件
- ✅ **图片上传**: ImageUpload组件
- ✅ **文件上传**: FileUpload组件
- ✅ **富文本编辑器**: Editor组件

### 移动端（RuoYi-App）

#### 认证模块（复用）
- ✅ **微信授权登录**: 微信一键登录
- ✅ **JWT认证**: Token自动管理
- ✅ **自动刷新**: Token过期自动刷新

#### 工具模块（复用）
- ✅ **网络请求**: request封装，自动携带token
- ✅ **权限验证**: hasPermi方法
- ✅ **字典缓存**: 字典数据本地缓存
- ✅ **错误处理**: 统一错误处理机制

---

## 🆕 MSDS业务扩展模块

### 新增业务模块

#### 1. 化学品信息管理模块
```
功能：
- 化学品基础信息CRUD
- 化学品别名管理
- CAS号验证和查重
- 供应商信息关联

数据表：
- msds_chemical: 化学品主表
- msds_chemical_alias: 化学品别名表（可选）
```

#### 2. MSDS文档管理模块
```
功能：
- MSDS文件上传（PDF、Word、Excel、TXT）
- MSDS文档解析和信息提取
- 版本控制和历史版本管理
- 文档预览和下载

数据表：
- msds_document: MSDS文档表
- msds_document_version: 文档版本表（可选）
```

#### 3. 二维码管理模块
```
功能：
- 为化学品生成唯一二维码
- 二维码批量生成
- 二维码打印下载
- 扫码统计分析

数据表：
- msds_qrcode: 二维码信息表
```

#### 4. 查阅日志模块
```
功能：
- 记录用户查阅MSDS行为
- 区分扫码和搜索方式
- 查阅统计和分析
- 审计报告生成

数据表：
- msds_view_log: 查阅日志表
```

#### 5. 微信小程序功能模块
```
功能：
- 扫码查阅MSDS
- 关键词搜索
- MSDS在线预览
- 分享给同事/群聊
- 收藏常用MSDS
- 查阅历史记录

基于：
- RuoYi-App移动端框架
- 集成RuoYi的登录认证和权限验证
```

---

## 💻 开发规范

### 1. 模块命名规范

遵循RuoYi的命名约定：

#### 后端模块
```
ruoyi-MsdsPc-react/
├── ruoyi-admin/        # 管理后台（RuoYi原有）
├── ruoyi-framework/    # 框架核心（RuoYi原有）
├── ruoyi-system/       # 系统管理（RuoYi原有）
├── ruoyi-common/       # 公共模块（RuoYi原有）
├── ruoyi-generator/    # 代码生成器（RuoYi原有）
└── ruoyi-msds/         # MSDS业务模块（新增）⭐
    ├── controller/
    ├── service/
    ├── mapper/
    └── domain/
```

#### 包命名
```java
com.ruoyi.msds.controller   # MSDS控制器
com.ruoyi.msds.service      # MSDS服务层
com.ruoyi.msds.mapper       # MSDS数据访问层
com.ruoyi.msds.domain       # MSDS实体类
```

### 2. 代码规范

#### Controller层
```java
@RestController
@RequestMapping("/system/msds")
public class MsdsController extends BaseController {  // 继承RuoYi的BaseController
    
    @Autowired
    private IMsdsService msdsService;
    
    // 遵循RuoYi命名：list、getInfo、add、edit、remove
    @GetMapping("/list")
    public TableDataInfo list(Msds msds) {
        startPage();  // RuoYi分页
        List<Msds> list = msdsService.selectMsdsList(msds);
        return getDataTable(list);
    }
}
```

#### Service层
```java
// 接口命名：I{模块}Service
public interface IMsdsService {
    // 方法命名：select{实体}List
    List<Msds> selectMsdsList(Msds msds);
}

// 实现类命名：{模块}ServiceImpl
@Service
public class MsdsServiceImpl implements IMsdsService {
    @Autowired
    private MsdsMapper msdsMapper;
}
```

#### Entity实体类
```java
// 继承BaseEntity获取审计字段
public class Msds extends BaseEntity {
    private Long msdsId;
    
    @Excel(name = "化学品名称")  // RuoYi Excel导出
    private String chemicalName;
}
```

### 3. 权限配置

#### 权限标识符格式
```
system:msds:list      # 查看列表
system:msds:query     # 查看详情
system:msds:add       # 新增
system:msds:edit      # 修改
system:msds:remove    # 删除
system:msds:export    # 导出
```

#### 在菜单管理中配置
```
1. 登录Web管理后台
2. 系统管理 → 菜单管理
3. 新增菜单：
   - 菜单名称: MSDS管理
   - 父菜单: 系统管理
   - 路由地址: msds
   - 权限标识: system:msds:list
```

### 4. 使用RuoYi代码生成器

#### 快速生成CRUD代码
```
步骤：
1. 创建数据表（如msds_chemical）
2. 登录系统 → 系统工具 → 代码生成
3. 点击"导入"，选择msds_chemical表
4. 点击"编辑"配置生成信息：
   - 生成模块名: system
   - 业务名: chemical
   - 功能名: 化学品管理
   - 作者: your name
5. 点击"生成代码"
6. 下载代码包
7. 解压后导入到项目相应目录

生成内容：
- Java后端: Controller、Service、Mapper、Domain
- 前端页面: index.vue（列表）、components（表单）
- SQL脚本: 菜单权限SQL
```

---

## 📊 数据库设计规范

### RuoYi标准表（保留不改）

```sql
-- 用户相关
sys_user              # 用户信息表
sys_role              # 角色信息表
sys_user_role         # 用户角色关联表

-- 权限相关
sys_menu              # 菜单权限表
sys_role_menu         # 角色菜单关联表

-- 组织架构
sys_dept              # 部门表
sys_post              # 岗位表
sys_user_post         # 用户岗位关联表

-- 字典和配置
sys_dict_type         # 字典类型表
sys_dict_data         # 字典数据表
sys_config            # 参数配置表

-- 日志
sys_oper_log          # 操作日志表
sys_logininfor        # 登录日志表

-- 其他
sys_notice            # 通知公告表
sys_job               # 定时任务表
```

### MSDS业务扩展表（新增）

```sql
-- 化学品信息表
CREATE TABLE msds_chemical (
    chemical_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '化学品ID',
    name_cn VARCHAR(200) NOT NULL COMMENT '中文名称',
    name_en VARCHAR(200) COMMENT '英文名称',
    cas_number VARCHAR(50) UNIQUE COMMENT 'CAS号',
    molecular_formula VARCHAR(100) COMMENT '分子式',
    synonyms TEXT COMMENT '别名（逗号分隔）',
    supplier VARCHAR(200) COMMENT '供应商',
    manufacturer VARCHAR(200) COMMENT '生产商',
    ghs_classification VARCHAR(500) COMMENT 'GHS分类',
    create_by VARCHAR(64) COMMENT '创建者',
    create_time DATETIME COMMENT '创建时间',
    update_by VARCHAR(64) COMMENT '更新者',
    update_time DATETIME COMMENT '更新时间',
    remark VARCHAR(500) COMMENT '备注'
) COMMENT '化学品信息表';

-- MSDS文档表
CREATE TABLE msds_document (
    msds_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'MSDS文档ID',
    chemical_id BIGINT NOT NULL COMMENT '化学品ID',
    version VARCHAR(50) COMMENT '版本号',
    effective_date DATE COMMENT '生效日期',
    expiry_date DATE COMMENT '过期日期',
    file_path VARCHAR(500) NOT NULL COMMENT '文件路径',
    file_size BIGINT COMMENT '文件大小（字节）',
    file_type VARCHAR(50) COMMENT '文件类型',
    status CHAR(1) DEFAULT '0' COMMENT '状态（0当前 1历史）',
    create_by VARCHAR(64) COMMENT '创建者',
    create_time DATETIME COMMENT '创建时间',
    remark VARCHAR(500) COMMENT '备注',
    FOREIGN KEY (chemical_id) REFERENCES msds_chemical(chemical_id)
) COMMENT 'MSDS文档表';

-- 二维码表
CREATE TABLE msds_qrcode (
    qrcode_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '二维码ID',
    chemical_id BIGINT NOT NULL COMMENT '化学品ID',
    qrcode_content VARCHAR(500) COMMENT '二维码内容',
    qrcode_url VARCHAR(500) COMMENT '二维码图片URL',
    print_count INT DEFAULT 0 COMMENT '打印次数',
    create_time DATETIME COMMENT '创建时间',
    FOREIGN KEY (chemical_id) REFERENCES msds_chemical(chemical_id)
) COMMENT '二维码信息表';

-- 查阅日志表
CREATE TABLE msds_view_log (
    log_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '日志ID',
    user_id BIGINT COMMENT '用户ID',
    msds_id BIGINT COMMENT 'MSDS文档ID',
    view_type CHAR(1) COMMENT '查阅方式（0扫码 1搜索）',
    view_time DATETIME COMMENT '查阅时间',
    ip_address VARCHAR(128) COMMENT 'IP地址',
    FOREIGN KEY (user_id) REFERENCES sys_user(user_id),
    FOREIGN KEY (msds_id) REFERENCES msds_document(msds_id)
) COMMENT 'MSDS查阅日志表';
```

---

## 🛠️ 开发指南

### 1. 后端开发流程

#### 新增业务模块步骤

**Step 1: 创建数据表**
```sql
-- 在msdsdocker/msdsdatabaseinitdb/目录下创建SQL文件
CREATE TABLE msds_xxx (...);
```

**Step 2: 使用代码生成器**
```
1. 登录系统 → 系统工具 → 代码生成
2. 导入表 msds_xxx
3. 编辑配置 → 生成代码
4. 下载代码包
```

**Step 3: 导入生成的代码**
```bash
# 后端代码放到 ruoyi-system 或 ruoyi-msds 模块
src/main/java/com/ruoyi/msds/
├── controller/
├── service/
├── mapper/
└── domain/

# 前端代码放到 ruoyi-ui
src/views/msds/xxx/
```

**Step 4: 执行菜单SQL**
```sql
-- 在数据库中执行生成的菜单SQL
INSERT INTO sys_menu VALUES (...);
```

**Step 5: 重启服务**
```bash
# 进入后端容器重启
docker-compose restart backend
```

### 2. 前端开发流程

#### 使用RuoYi组件
```typescript
// 使用RuoYi的ProTable
import ProTable from '@ant-design/pro-table';
import { listMsds } from '@/api/system/msds';

// 使用RuoYi的字典组件
import DictTag from '@/components/DictTag';

// 使用RuoYi的上传组件
import FileUpload from '@/components/FileUpload';
```

### 3. 小程序开发流程

#### 使用RuoYi-App功能
```javascript
// 登录
import { login, getInfo } from '@/api/login'

// Token管理
import { getToken, setToken } from '@/utils/auth'

// 权限验证
import { hasPermi } from '@/utils/permission'

// API调用（自动带token）
import request from '@/utils/request'
```

---

## 🔐 RuoYi权限系统使用

### 权限配置完整流程

#### 1. 后端配置权限注解
```java
@PreAuthorize("@ss.hasPermi('system:msds:add')")
@PostMapping
public AjaxResult add(@RequestBody Msds msds) {
    return toAjax(msdsService.insertMsds(msds));
}
```

#### 2. 在菜单管理中配置权限
```
菜单路径: 系统管理 → 菜单管理
配置内容:
- 菜单名称: 新增MSDS
- 权限标识: system:msds:add
- 菜单类型: 按钮（F）
- 父菜单: MSDS管理
```

#### 3. 角色分配权限
```
角色路径: 系统管理 → 角色管理
操作:
1. 选择角色（如：实验室管理员）
2. 点击"修改" → "权限分配"
3. 勾选MSDS相关权限
4. 保存
```

#### 4. 用户分配角色
```
用户路径: 系统管理 → 用户管理
操作:
1. 选择用户
2. 点击"修改"
3. 分配角色（如：实验室管理员）
4. 保存
```

---

## 📖 RuoYi常用工具类

### 后端工具类

```java
// 1. 字符串工具 - StringUtils
StringUtils.isEmpty(str)
StringUtils.isNotEmpty(str)
StringUtils.nvl(value, defaultValue)

// 2. 日期工具 - DateUtils
DateUtils.getNowDate()
DateUtils.parseDate(dateStr)
DateUtils.dateTime(format, date)

// 3. 安全工具 - SecurityUtils
SecurityUtils.getUsername()      // 获取当前登录用户名
SecurityUtils.getUserId()        // 获取当前用户ID
SecurityUtils.getLoginUser()     // 获取当前登录用户信息

// 4. 文件工具 - FileUtils
FileUtils.writeBytes(filePath, data)
FileUtils.readBytes(filePath)
FileUtils.deleteFile(filePath)

// 5. 字典工具 - DictUtils
DictUtils.getDictLabel(dictType, dictValue)
DictUtils.getDictValue(dictType, dictLabel)

// 6. SQL注入过滤 - SqlUtil
SqlUtil.escapeOrderBySql(orderBy)

// 7. Bean工具 - BeanUtils
BeanUtils.copyProperties(source, target)

// 8. HTTP工具 - HttpUtils
HttpUtils.sendGet(url)
HttpUtils.sendPost(url, params)
```

### 前端工具类（小程序）

```javascript
// 1. Token管理
import { getToken, setToken, removeToken } from '@/utils/auth'

// 2. 权限验证
import { hasPermi, hasRole } from '@/utils/permission'

// 3. 字典工具
this.$dict.getDictLabel('sys_status', '0')
this.$dict.getDictDatas('sys_status')

// 4. 日期格式化
import { parseTime, formatTime } from '@/utils/ruoyi'
```

---

## ⚠️ 注意事项和最佳实践

### DO's（应该做的）

1. ✅ **充分利用RuoYi功能**: 不要重复实现已有功能
2. ✅ **遵循RuoYi规范**: 保持代码风格一致
3. ✅ **使用代码生成器**: 快速生成标准CRUD代码
4. ✅ **继承RuoYi基类**: 获取框架提供的便利方法
5. ✅ **复用RuoYi组件**: 前端UI组件、后端工具类
6. ✅ **查阅官方文档**: 遇到问题先看文档
7. ✅ **保持可升级性**: 扩展而不是修改框架代码

### DON'Ts（不应该做的）

1. ⛔ **不要修改RuoYi核心代码**: 保持框架完整性
2. ⛔ **不要删除RuoYi标准表**: 系统依赖这些表
3. ⛔ **不要重复实现功能**: 用户管理、权限系统等已有功能
4. ⛔ **不要违背RuoYi规范**: 保持命名和结构一致
5. ⛔ **不要绕过权限系统**: 使用RuoYi的权限注解
6. ⛔ **不要自定义返回格式**: 使用RuoYi的AjaxResult

---

## 🚀 常见开发场景

### 场景1: 新增业务表和CRUD功能

```
1. 设计数据表结构（继承BaseEntity字段）
2. 使用RuoYi代码生成器生成代码
3. 导入生成的代码到项目
4. 在菜单管理中配置菜单和权限
5. 测试功能
```

### 场景2: 文件上传功能

```java
// 后端：使用RuoYi的FileUploadUtils
@PostMapping("/upload")
public AjaxResult uploadFile(MultipartFile file) {
    String filePath = FileUploadUtils.upload(file);
    return AjaxResult.success(filePath);
}
```

### 场景3: Excel导入导出

```java
// 导出：使用RuoYi的@Excel注解和ExcelUtil
@PostMapping("/export")
public void export(HttpServletResponse response, Msds msds) {
    List<Msds> list = msdsService.selectMsdsList(msds);
    ExcelUtil<Msds> util = new ExcelUtil<>(Msds.class);
    util.exportExcel(response, list, "MSDS数据");
}

// 导入：使用ExcelUtil
@PostMapping("/importData")
public AjaxResult importData(MultipartFile file) {
    ExcelUtil<Msds> util = new ExcelUtil<>(Msds.class);
    List<Msds> list = util.importExcel(file.getInputStream());
    // 处理数据...
}
```

### 场景4: 定时任务

```
1. 登录系统 → 系统监控 → 定时任务
2. 新增定时任务：
   - 任务名称: MSDS过期检查
   - 调用目标: msdsTask.checkExpiry
   - cron表达式: 0 0 2 * * ?  （每天凌晨2点）
3. 创建任务类：
   @Component("msdsTask")
   public class MsdsTask {
       public void checkExpiry() {
           // 检查过期MSDS
       }
   }
```

---

## 📝 小程序与后端对接规范

### API返回格式（RuoYi统一格式）

```javascript
// 成功返回
{
  code: 200,
  msg: '操作成功',
  rows: [...],      // 列表数据（分页）
  total: 100,       // 总记录数（分页）
  data: {...}       // 详情数据
}

// 失败返回
{
  code: 500,
  msg: '操作失败：具体原因'
}
```

### 小程序请求示例

```javascript
// api/msds.js
import request from '@/utils/request'  // RuoYi封装的request

export function listMsds(params) {
  return request({
    url: '/system/msds/list',
    method: 'GET',
    params  // 自动添加token
  })
}

// 页面中使用
async loadData() {
  const res = await listMsds({
    pageNum: this.pageNum,
    pageSize: this.pageSize,
    chemicalName: this.searchText
  });
  
  if (res.code === 200) {
    this.msdsList = res.rows;
    this.total = res.total;
  } else {
    uni.showToast({
      title: res.msg,
      icon: 'none'
    });
  }
}
```

---

## 🎓 学习资源

### 新手入门

1. **RuoYi官方文档**（必读）
   - 快速开始: https://doc.ruoyi.vip/ruoyi-vue/document/qdsc.html
   - 部署指南: https://doc.ruoyi.vip/ruoyi-vue/document/hjbs.html

2. **视频教程**
   - B站官方账号: https://space.bilibili.com/490747061
   - 从零开始搭建RuoYi系统

3. **源码学习**
   - 代码仓库: https://gitee.com/y_project/RuoYi-Vue
   - 在线演示: http://vue.ruoyi.vip/ (admin/admin123)

### 常见问题

1. **如何添加新菜单？**
   - 系统管理 → 菜单管理 → 新增菜单

2. **如何配置权限？**
   - 在Controller使用@PreAuthorize注解
   - 在菜单管理中配置权限标识

3. **如何使用代码生成器？**
   - 系统工具 → 代码生成 → 导入表 → 生成代码

4. **如何处理文件上传？**
   - 使用RuoYi的FileUploadUtils工具类

5. **如何导出Excel？**
   - 实体类使用@Excel注解
   - 使用ExcelUtil工具类

---

## 📞 技术支持

### 问题排查顺序

1. 📖 **查阅RuoYi官方文档**: https://doc.ruoyi.vip/
2. 🔍 **搜索GitHub Issues**: https://github.com/yangzongzhuan/RuoYi-Vue/issues
3. 💬 **Gitee Issues**: https://gitee.com/y_project/RuoYi-Vue/issues
4. 👥 **RuoYi社区**: 官方QQ群等

### 本项目技术负责人

- **架构设计**: [填写负责人]
- **后端开发**: [填写负责人]
- **前端开发**: [填写负责人]
- **移动端开发**: [填写负责人]

---

**最后更新**: 2025年1月  
**维护者**: 技术团队  
**版本**: v1.0

