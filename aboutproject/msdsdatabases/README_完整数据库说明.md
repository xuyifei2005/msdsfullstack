# MSDS实验室管理系统 - 完整数据库文件说明

## 文件信息

- **文件名**: `msds_complete_database.sql`
- **版本**: v1.0
- **创建日期**: 2025-01-27
- **数据库**: MySQL 8.0+
- **字符集**: utf8mb4
- **排序规则**: utf8mb4_unicode_ci

## 文件概述

这是MSDS实验室管理系统的完整数据库初始化文件，整合了所有原有的分散SQL文件，提供了一个完整、无重复、无遗漏的数据库结构。

## 数据库结构统计

- **数据库表**: 48个
- **初始化数据**: 74条INSERT语句
- **索引**: 12个
- **视图**: 2个
- **存储过程**: 2个
- **触发器**: 2个

## 主要功能模块

### 1. RuoYi框架系统表 (22个表)
- `sys_user` - 用户信息表
- `sys_role` - 角色信息表
- `sys_menu` - 菜单权限表
- `sys_dept` - 部门表
- `sys_post` - 岗位信息表
- `sys_dict_type` - 字典类型表
- `sys_dict_data` - 字典数据表
- `sys_config` - 参数配置表
- `sys_notice` - 通知公告表
- `sys_oper_log` - 操作日志记录
- `sys_logininfor` - 系统访问记录
- `sys_job` - 定时任务调度表
- `sys_job_log` - 定时任务调度日志表
- 以及相关的关联表

### 2. MSDS核心业务表 (18个表)
- `msds_main` - MSDS主信息表
- `msds_hazard` - 危险性概述
- `msds_component` - 成分组成信息
- `msds_first_aid` - 急救措施
- `msds_fire_fighting` - 消防措施
- `msds_leak_response` - 泄漏应急处理
- `msds_handling_storage` - 操作处置与储存
- `msds_exposure_control` - 接触控制和个体防护
- `msds_physical_chemical` - 理化特性
- `msds_stability_reactivity` - 稳定性和反应活性
- `msds_toxicological` - 毒理学信息
- `msds_ecological` - 生态学信息
- `msds_disposal` - 废弃处置
- `msds_transportation` - 运输信息
- `msds_regulatory` - 法规信息
- `msds_other_info` - 其他信息
- `msds_ghs_hazard` - GHS危险性关联表
- `msds_version_history` - 版本历史记录
- `msds_approval_workflow` - 审批流程

### 3. 基础数据表 (2个表)
- `chemical_category` - 化学品分类
- `ghs_hazard_class` - GHS危险性分类

### 4. Quartz定时任务表 (6个表)
- `QRTZ_JOB_DETAILS` - 作业详细信息
- `QRTZ_TRIGGERS` - 触发器信息
- `QRTZ_SIMPLE_TRIGGERS` - 简单触发器
- `QRTZ_CRON_TRIGGERS` - Cron触发器
- `QRTZ_FIRED_TRIGGERS` - 已触发的触发器
- `QRTZ_SCHEDULER_STATE` - 调度器状态

## 初始化数据

### 系统用户
- **管理员**: admin / admin123
- **普通用户**: msds_user / admin123

### 系统角色
- 超级管理员 (admin)
- MSDS管理员 (msds_admin)
- MSDS用户 (msds_user)

### 岗位信息
- 董事长、项目经理、人力资源、普通员工
- 实验室主任、安全员、化学师

### 菜单权限
- 系统管理模块
- MSDS管理模块（包含信息管理、分类管理、审批等）

### 基础数据
- 8个化学品分类
- 26个GHS危险性分类

## 高级功能

### 视图 (Views)
1. **v_msds_complete** - MSDS完整信息视图
   - 整合MSDS主信息、分类、成分统计等
2. **v_msds_approval_status** - MSDS审批状态视图
   - 显示MSDS审批流程状态

### 存储过程 (Stored Procedures)
1. **GenerateMsdsCode** - MSDS编号生成
   - 自动生成格式：分类代码-年份-4位序号
2. **UpdateMsdsStatus** - MSDS状态更新
   - 更新状态并记录变更历史

### 触发器 (Triggers)
1. **tr_msds_main_update** - MSDS主表更新时间触发器
2. **tr_msds_component_change** - MSDS组件变更记录触发器

### 索引优化
- MSDS主表：产品名称、公司名称、状态、创建时间、分类ID
- 成分表：MSDS ID、成分名称、CAS号
- 版本历史：MSDS ID、变更日期
- 审批流程：MSDS ID、审批状态

## 使用说明

### 1. 数据库创建
```sql
-- 直接执行完整SQL文件
mysql -u root -p < msds_complete_database.sql
```

### 2. 连接配置
```properties
# 数据库连接配置
spring.datasource.url=jdbc:mysql://localhost:3306/msds_dev?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
spring.datasource.username=msds_user
spring.datasource.password=msds_dev_password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```

### 3. 容器环境配置
```yaml
# Docker环境变量
MYSQL_DATABASE: msds_dev
MYSQL_USER: msds_user
MYSQL_PASSWORD: msds_dev_password
MYSQL_ROOT_PASSWORD: root_password
```

## 数据完整性保证

### 外键约束
- 所有MSDS子表都有对主表的外键约束
- 分类表有层级关系约束
- 用户角色权限有完整的关联约束

### 数据验证
- 必填字段的NOT NULL约束
- 状态字段的枚举值约束
- 日期字段的默认值设置
- 字符长度限制

### 审计功能
- 创建时间、更新时间自动记录
- 创建人、更新人字段
- 版本历史完整记录
- 操作日志记录

## 性能优化

### 索引策略
- 主键索引：所有表都有自增主键
- 外键索引：所有外键字段都有索引
- 查询索引：常用查询字段建立索引
- 复合索引：多字段查询建立复合索引

### 查询优化
- 视图简化复杂查询
- 存储过程提高执行效率
- 分页查询支持
- 软删除避免物理删除

## 安全特性

### 数据安全
- 密码加密存储（BCrypt）
- 敏感信息字段保护
- SQL注入防护
- 权限控制完整

### 访问控制
- 基于角色的权限控制（RBAC）
- 菜单级权限控制
- 按钮级权限控制
- 数据级权限控制

## 扩展性设计

### 表结构扩展
- 预留扩展字段
- 灵活的分类体系
- 可配置的审批流程
- 支持多版本管理

### 功能扩展
- 插件化菜单系统
- 可配置的字典系统
- 灵活的通知系统
- 扩展的日志系统

## 维护说明

### 定期维护
- 日志清理：系统自动清理过期日志
- 数据备份：建议每日备份重要数据
- 索引优化：定期分析和优化索引
- 性能监控：监控数据库性能指标

### 升级说明
- 版本控制：使用版本号管理数据库变更
- 增量更新：提供增量SQL脚本
- 数据迁移：提供数据迁移工具
- 回滚机制：支持版本回滚

## 注意事项

1. **SQL模式**: 文件开头设置了兼容的SQL模式，执行完成后会恢复
2. **字符集**: 确保MySQL服务器支持utf8mb4字符集
3. **权限**: 执行用户需要有创建数据库和表的权限
4. **依赖**: 确保MySQL版本8.0+，支持所有使用的特性
5. **备份**: 在生产环境执行前请先备份现有数据

## 文件整合说明

本文件整合了以下原有文件的内容：
- `install_msds_database.sql` - 基础MSDS表结构
- `ry_react.sql` - RuoYi框架系统表
- `msds_menu_permissions.sql` - 菜单权限配置
- `quartz.sql` - 定时任务表
- `MSDS批量导入SQL脚本.sql` - 批量导入相关
- `数据库文档结构存储表.sql` - 完整表结构
- 其他相关SQL文件

整合过程中：
- ✅ 消除了重复的表定义
- ✅ 统一了数据库名称为 `msds_dev`
- ✅ 补充了缺失的表结构
- ✅ 添加了完整的索引和约束
- ✅ 提供了丰富的初始化数据
- ✅ 增加了高级功能（视图、存储过程、触发器）

---

**维护者**: AI PM  
**最后更新**: 2025-01-27  
**版本**: v1.0