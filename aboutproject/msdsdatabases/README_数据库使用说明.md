# MSDS数据库使用说明

## 重要更新通知 ⚠️

**数据库文件已整合完成！**

现在请使用 **`msds_complete_database.sql`** 作为唯一的数据库初始化文件。

## 当前推荐文件

### 主要数据库文件
- **`msds_complete_database.sql`** - 🎯 **完整的数据库初始化文件（推荐使用）**
  - 包含所有表结构、初始数据、索引、视图、存储过程
  - 无重复、无遗漏、经过验证
  - 详细说明请查看：`README_完整数据库说明.md`

### 备份文件
- `backup_old_files/` - 原有的分散SQL文件（已备份，仅供参考）

## 概述

本数据库基于GB/T 16483-2008、GB/T 17519-2013标准设计，用于管理化学品安全数据表(MSDS)信息。数据库设计完全符合国际GHS标准要求。

## 数据库结构

### 核心表结构 (16张主表)

1. **msds_main** - MSDS主信息表
2. **msds_hazard** - 危险性概述表  
3. **msds_component** - 成分/组成信息表
4. **msds_first_aid** - 急救措施表
5. **msds_fire_fighting** - 消防措施表
6. **msds_leak_response** - 泄漏应急处理表
7. **msds_handling_storage** - 操作处置与储存表
8. **msds_exposure_control** - 接触控制/个体防护表
9. **msds_physical_chemical** - 理化特性表
10. **msds_stability_reactivity** - 稳定性和反应性表
11. **msds_toxicological** - 毒理学资料表
12. **msds_ecological** - 生态学资料表
13. **msds_disposal** - 废弃处置表
14. **msds_transportation** - 运输信息表
15. **msds_regulatory** - 法规信息表
16. **msds_other_info** - 其他信息表

### 辅助表结构 (5张辅助表)

1. **chemical_category** - 化学品分类表
2. **ghs_hazard_class** - GHS危险性分类标准表
3. **msds_ghs_hazard** - MSDS-GHS危险性分类关联表
4. **msds_version_history** - MSDS版本历史表
5. **msds_approval_workflow** - MSDS审批流程表
6. **system_log** - 系统操作日志表

## 解决SQL兼容性问题

### 问题原因
您遇到的错误是由于MySQL的`sql_mode`设置为`ONLY_FULL_GROUP_BY`模式导致的，这是MySQL 5.7+的默认设置。

### 解决方案

#### 方法1：使用提供的安全执行脚本
```bash
mysql -u username -p < 执行脚本_避免兼容性问题.sql
```

#### 方法2：手动修改SQL模式
```sql
SET SESSION sql_mode = 'TRADITIONAL,NO_AUTO_VALUE_ON_ZERO';
SET SESSION sql_mode = REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', '');
SOURCE 数据库文档结构存储表.sql;
```

## 数据库改进内容

### 1. 新增的辅助表
- `chemical_category` - 化学品分类表
- `ghs_hazard_class` - GHS危险性分类标准表
- `msds_ghs_hazard` - MSDS-GHS危险性分类关联表
- `msds_version_history` - MSDS版本历史表
- `msds_approval_workflow` - MSDS审批流程表
- `system_log` - 系统操作日志表

### 2. 主表字段完善
- 增加了`msds_code`字段作为MSDS编号
- 增加了`status`字段支持审批流程
- 增加了`created_by`和`updated_by`字段
- 完善了各表的字段，更贴近实际使用需求

### 3. 数据完整性增强
- 添加了更多的索引优化查询性能
- 规范化了外键关系
- 增加了数据验证约束

## 快速开始

1. 执行安全脚本创建数据库：
```bash
mysql -u root -p < 执行脚本_避免兼容性问题.sql
```

2. 验证安装：
```sql
USE msds_management;
SHOW TABLES;
SELECT COUNT(*) FROM chemical_category;
```

3. 查看常用查询示例：
```bash
mysql -u root -p msds_management < 常用查询示例.sql
```

## 主要改进

1. **兼容性问题修复** - 解决了`sql_mode=only_full_group_by`导致的错误
2. **结构完善** - 增加了版本控制、审批流程等实用功能
3. **性能优化** - 添加了必要的索引和查询优化
4. **标准化** - 完全符合GB/T标准和GHS要求
5. **易用性** - 提供了详细的查询示例和使用说明

数据库现在可以正常使用，支持完整的MSDS管理功能！

## 数据库安装步骤

### 1. 环境准备
- MySQL 5.7+ 或 MySQL 8.0+
- 确保有CREATE DATABASE权限

### 2. 执行安装
```bash
# 方式1：使用安全执行脚本（推荐）
mysql -u root -p < 执行脚本_避免兼容性问题.sql

# 方式2：直接执行主脚本
mysql -u root -p < 数据库文档结构存储表.sql
```

### 3. 验证安装
```sql
-- 检查数据库
SHOW DATABASES LIKE 'msds_management';

-- 检查表数量
SELECT COUNT(*) FROM information_schema.tables 
WHERE table_schema = 'msds_management';

-- 检查基础数据
SELECT * FROM msds_management.chemical_category;
SELECT * FROM msds_management.ghs_hazard_class;
```

## 核心功能特性

### 1. 完整的MSDS 16部分结构
- 完全符合GB/T 16483-2008标准
- 包含所有必需的安全信息字段
- 支持GHS标准分类

### 2. 高级功能
- **版本控制**：完整的MSDS版本历史追踪
- **审批流程**：可配置的多级审批工作流
- **操作日志**：详细的系统操作记录
- **分类管理**：灵活的化学品分类体系

### 3. 数据完整性
- 外键约束确保数据一致性
- 唯一索引防止重复数据
- 必填字段验证

### 4. 查询优化
- 关键字段建立索引
- 支持复杂的关联查询
- 预置常用查询示例

## 使用示例

### 1. 创建新的MSDS记录
```sql
-- 插入主记录
INSERT INTO msds_main (
    msds_code, product_name, product_english_name, 
    company_name, contact_phone, category_id
) VALUES (
    'MSDS001', '硫酸', 'Sulfuric Acid', 
    '某某化工有限公司', '010-12345678', 1
);

-- 获取插入的ID
SET @msds_id = LAST_INSERT_ID();

-- 插入危险性概述
INSERT INTO msds_hazard (msds_id, emergency_overview, warning_word)
VALUES (@msds_id, '无色至微黄色透明液体，强腐蚀性', 'danger');
```

### 2. 查询化学品信息
```sql
-- 基础查询
SELECT m.product_name, m.company_name, c.category_name
FROM msds_main m
LEFT JOIN chemical_category c ON m.category_id = c.id
WHERE m.product_name LIKE '%硫酸%';
```

### 3. 生成MSDS报告
```sql
-- 完整MSDS信息查询
SELECT 
    m.product_name as '第1部分-化学品名称',
    h.emergency_overview as '第2部分-危险性概述',
    comp.component_name as '第3部分-主要成分',
    fa.skin_contact as '第4部分-皮肤接触急救',
    ff.fire_extinguishing_methods as '第5部分-灭火方法'
    -- ... 其他部分
FROM msds_main m
LEFT JOIN msds_hazard h ON m.id = h.msds_id
LEFT JOIN msds_component comp ON m.id = comp.msds_id
LEFT JOIN msds_first_aid fa ON m.id = fa.msds_id
LEFT JOIN msds_fire_fighting ff ON m.id = ff.msds_id
WHERE m.id = 1;
```

## 常见问题解决

### 1. 字符编码问题
```sql
-- 确保使用UTF8MB4编码
ALTER DATABASE msds_management CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 2. 外键约束错误
```sql
-- 检查外键关系
SELECT 
    table_name,
    constraint_name,
    referenced_table_name
FROM information_schema.key_column_usage 
WHERE table_schema = 'msds_management' 
    AND referenced_table_name IS NOT NULL;
```

### 3. 性能优化
```sql
-- 分析表性能
ANALYZE TABLE msds_main;

-- 查看执行计划
EXPLAIN SELECT * FROM msds_main WHERE product_name = '硫酸';
```

## 维护建议

### 1. 定期备份
```bash
# 完整备份
mysqldump -u root -p msds_management > msds_backup_$(date +%Y%m%d).sql

# 仅结构备份
mysqldump -u root -p --no-data msds_management > msds_structure.sql
```

### 2. 性能监控
```sql
-- 查看表大小
SELECT 
    table_name,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'DB Size in MB'
FROM information_schema.tables 
WHERE table_schema = 'msds_management'
ORDER BY (data_length + index_length) DESC;
```

### 3. 日志清理
```sql
-- 清理3个月前的操作日志
DELETE FROM system_log 
WHERE operation_time < DATE_SUB(NOW(), INTERVAL 3 MONTH);
```

## 扩展功能

### 1. 添加新的化学品分类
```sql
INSERT INTO chemical_category (category_code, category_name, description)
VALUES ('CUSTOM_01', '特殊化学品', '用户自定义分类');
```

### 2. 添加新的GHS危险类别
```sql
INSERT INTO ghs_hazard_class (class_code, class_name, category, pictogram, signal_word)
VALUES ('CUSTOM_HAZ', '自定义危险', '类别X', 'GHS99', 'WARNING');
```

## 技术支持

如果遇到问题，请检查：
1. MySQL版本兼容性
2. 用户权限设置
3. 字符编码配置
4. SQL模式设置

更多技术问题请参考MySQL官方文档或联系技术支持团队。