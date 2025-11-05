# MSDS智能搜索模块数据库表结构说明

## 概述

本文档说明了MSDS智能搜索功能所需的数据表结构。根据 `intelligent-search.html` 原型设计，系统需要支持以下功能：

1. **搜索历史记录** - 记录用户搜索行为
2. **搜索建议** - 热门搜索词、AI推荐、搜索联想
3. **用户收藏** - 用户收藏的MSDS文档
4. **文档统计** - 文档查看、下载、收藏等统计数据
5. **访问日志** - 详细的文档访问日志

## 数据表列表

### 1. msds_search_history - 搜索历史表

**功能**: 记录用户的搜索历史记录

**主要字段**:
- `search_id`: 搜索记录ID（主键）
- `user_id`: 用户ID
- `search_keyword`: 搜索关键词
- `search_type`: 搜索类型（general, semantic, cas, formula）
- `filter_params`: 筛选参数（JSON格式）
- `result_count`: 搜索结果数量
- `search_time`: 搜索时间

**索引**:
- `idx_user_id`: 用户ID索引
- `idx_search_time`: 搜索时间索引
- `idx_search_keyword`: 搜索关键词索引（前缀索引）
- `idx_user_search_time`: 用户ID+搜索时间联合索引

### 2. msds_search_suggestion - 搜索建议表

**功能**: 存储热门搜索词、AI建议、搜索联想等

**主要字段**:
- `suggestion_id`: 建议ID（主键）
- `keyword`: 搜索关键词
- `keyword_type`: 关键词类型（hot, ai, related, cas, formula）
- `related_cas`: 关联CAS号
- `related_msds_id`: 关联MSDS文档ID
- `search_count`: 搜索次数
- `click_count`: 点击次数
- `sort_order`: 排序顺序
- `is_active`: 是否启用

**索引**:
- `uk_keyword_type`: 关键词+类型唯一索引
- `idx_keyword_type`: 关键词类型索引
- `idx_search_count`: 搜索次数索引
- `idx_sort_order`: 排序顺序索引

### 3. msds_user_favorite - 用户收藏表

**功能**: 用户收藏的MSDS文档

**主要字段**:
- `favorite_id`: 收藏ID（主键）
- `user_id`: 用户ID
- `msds_id`: MSDS文档ID
- `msds_name`: MSDS文档名称
- `cas_number`: CAS号
- `folder_name`: 收藏夹名称
- `tags`: 标签（逗号分隔）
- `note`: 备注说明

**索引**:
- `uk_user_msds`: 用户ID+MSDS ID唯一索引（防止重复收藏）
- `idx_user_id`: 用户ID索引
- `idx_msds_id`: MSDS ID索引
- `idx_folder_name`: 收藏夹名称索引

### 4. msds_document_statistics - 文档统计表

**功能**: 记录MSDS文档的查看、下载、收藏等统计数据

**主要字段**:
- `stat_id`: 统计ID（主键）
- `msds_id`: MSDS文档ID（唯一）
- `view_count`: 查看次数
- `download_count`: 下载次数
- `favorite_count`: 收藏次数
- `share_count`: 分享次数
- `last_view_time`: 最后查看时间
- `last_download_time`: 最后下载时间
- `last_favorite_time`: 最后收藏时间
- `total_score`: 总评分
- `score_count`: 评分次数
- `avg_score`: 平均评分

**索引**:
- `uk_msds_id`: MSDS ID唯一索引
- `idx_view_count`: 查看次数索引
- `idx_download_count`: 下载次数索引
- `idx_favorite_count`: 收藏次数索引
- `idx_avg_score`: 平均评分索引

### 5. msds_document_access_log - 文档访问日志表

**功能**: 记录文档的详细访问日志（查看、下载等操作）

**主要字段**:
- `log_id`: 日志ID（主键）
- `msds_id`: MSDS文档ID
- `user_id`: 用户ID
- `access_type`: 访问类型（view, download, preview, print）
- `access_time`: 访问时间
- `ip_address`: IP地址
- `user_agent`: 用户代理
- `device_type`: 设备类型（pc, mobile, tablet）
- `browser`: 浏览器
- `duration`: 访问时长（秒）

**索引**:
- `idx_msds_id`: MSDS ID索引
- `idx_user_id`: 用户ID索引
- `idx_access_type`: 访问类型索引
- `idx_access_time`: 访问时间索引
- `idx_msds_access_time`: MSDS ID+访问时间联合索引

## 表关系图

```
msds_main (MSDS主表)
    ├── msds_document_statistics (1:1) - 文档统计
    ├── msds_document_access_log (1:N) - 访问日志
    ├── msds_user_favorite (1:N) - 用户收藏
    └── msds_search_suggestion (1:N) - 搜索建议关联

sys_user (用户表)
    ├── msds_search_history (1:N) - 搜索历史
    ├── msds_user_favorite (1:N) - 用户收藏
    └── msds_document_access_log (1:N) - 访问日志
```

## 使用说明

### 初始化数据

SQL文件已包含初始化数据脚本，包括：
- 热门搜索建议（乙醇、甲醇、丙酮等）
- 现有MSDS文档的统计记录初始化

### 数据维护

1. **搜索历史清理**: 建议定期清理过期的搜索历史（如90天前）
2. **搜索建议更新**: 根据搜索统计自动更新热门搜索词
3. **统计数据汇总**: 定期汇总访问日志到统计表

### 性能优化建议

1. **索引优化**: 已为常用查询字段创建索引
2. **分区策略**: 访问日志表建议按时间分区
3. **归档策略**: 定期归档历史访问日志

## 创建时间

2025-01-XX

## 相关文件

- `02-msds-search-tables.sql` - 表结构SQL脚本
- `intelligent-search.html` - 前端原型设计

