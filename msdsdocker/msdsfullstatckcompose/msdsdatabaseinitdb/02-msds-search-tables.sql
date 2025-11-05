-- ============================================================
-- MSDS智能搜索模块数据库表结构
-- 创建时间: 2025-01-XX
-- 说明: 支持智能搜索、搜索历史、用户收藏、文档统计等功能
-- ============================================================

-- 使用msds_dev数据库
USE msds_dev;

-- ============================================================
-- 1. 搜索历史表 (msds_search_history)
-- 功能: 记录用户的搜索历史记录
-- ============================================================
DROP TABLE IF EXISTS `msds_search_history`;
CREATE TABLE `msds_search_history` (
  `search_id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '搜索记录ID',
  `user_id` BIGINT(20) NOT NULL COMMENT '用户ID',
  `user_name` VARCHAR(64) DEFAULT '' COMMENT '用户名称',
  `search_keyword` VARCHAR(500) NOT NULL COMMENT '搜索关键词',
  `search_type` VARCHAR(50) DEFAULT 'general' COMMENT 'search type: general, semantic, cas, formula',
  `filter_params` TEXT COMMENT '筛选参数JSON格式',
  `result_count` INT(11) DEFAULT 0 COMMENT '搜索结果数量',
  `search_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '搜索时间',
  `ip_address` VARCHAR(128) DEFAULT '' COMMENT 'IP地址',
  `user_agent` VARCHAR(500) DEFAULT '' COMMENT '用户代理',
  `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`search_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_search_time` (`search_time`),
  KEY `idx_search_keyword` (`search_keyword`(255)),
  KEY `idx_user_search_time` (`user_id`, `search_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MSDS搜索历史表';

-- ============================================================
-- 2. 搜索建议表 (msds_search_suggestion)
-- 功能: 存储热门搜索词、AI建议、搜索联想等
-- ============================================================
DROP TABLE IF EXISTS `msds_search_suggestion`;
CREATE TABLE `msds_search_suggestion` (
  `suggestion_id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '建议ID',
  `keyword` VARCHAR(500) NOT NULL COMMENT '搜索关键词',
  `keyword_type` VARCHAR(50) DEFAULT 'hot' COMMENT 'keyword type: hot, ai, related, cas, formula',
  `related_cas` VARCHAR(50) DEFAULT NULL COMMENT '关联CAS号',
  `related_msds_id` BIGINT(20) DEFAULT NULL COMMENT '关联MSDS文档ID',
  `search_count` INT(11) DEFAULT 0 COMMENT '搜索次数',
  `click_count` INT(11) DEFAULT 0 COMMENT '点击次数',
  `sort_order` INT(11) DEFAULT 0 COMMENT '排序顺序',
  `is_active` TINYINT(1) DEFAULT 1 COMMENT '是否启用: 0禁用, 1启用',
  `start_time` DATETIME DEFAULT NULL COMMENT '生效开始时间',
  `end_time` DATETIME DEFAULT NULL COMMENT '生效结束时间',
  `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`suggestion_id`),
  UNIQUE KEY `uk_keyword_type` (`keyword`(255), `keyword_type`),
  KEY `idx_keyword_type` (`keyword_type`),
  KEY `idx_search_count` (`search_count`),
  KEY `idx_sort_order` (`sort_order`),
  KEY `idx_is_active` (`is_active`),
  KEY `idx_related_msds` (`related_msds_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MSDS搜索建议表';

-- ============================================================
-- 3. 用户收藏表 (msds_user_favorite)
-- 功能: 用户收藏的MSDS文档
-- ============================================================
DROP TABLE IF EXISTS `msds_user_favorite`;
CREATE TABLE `msds_user_favorite` (
  `favorite_id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `user_id` BIGINT(20) NOT NULL COMMENT '用户ID',
  `user_name` VARCHAR(64) DEFAULT '' COMMENT '用户名称',
  `msds_id` BIGINT(20) NOT NULL COMMENT 'MSDS文档ID',
  `msds_name` VARCHAR(255) DEFAULT '' COMMENT 'MSDS文档名称',
  `cas_number` VARCHAR(50) DEFAULT NULL COMMENT 'CAS号',
  `folder_name` VARCHAR(100) DEFAULT '默认' COMMENT '收藏夹名称',
  `tags` VARCHAR(500) DEFAULT NULL COMMENT '标签逗号分隔',
  `note` VARCHAR(1000) DEFAULT NULL COMMENT '备注说明',
  `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`favorite_id`),
  UNIQUE KEY `uk_user_msds` (`user_id`, `msds_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_msds_id` (`msds_id`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_folder_name` (`folder_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MSDS用户收藏表';

-- ============================================================
-- 4. 文档统计表 (msds_document_statistics)
-- 功能: 记录MSDS文档的查看、下载、收藏等统计数据
-- ============================================================
DROP TABLE IF EXISTS `msds_document_statistics`;
CREATE TABLE `msds_document_statistics` (
  `stat_id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '统计ID',
  `msds_id` BIGINT(20) NOT NULL COMMENT 'MSDS文档ID',
  `view_count` INT(11) DEFAULT 0 COMMENT '查看次数',
  `download_count` INT(11) DEFAULT 0 COMMENT '下载次数',
  `favorite_count` INT(11) DEFAULT 0 COMMENT '收藏次数',
  `share_count` INT(11) DEFAULT 0 COMMENT '分享次数',
  `last_view_time` DATETIME DEFAULT NULL COMMENT '最后查看时间',
  `last_download_time` DATETIME DEFAULT NULL COMMENT '最后下载时间',
  `last_favorite_time` DATETIME DEFAULT NULL COMMENT '最后收藏时间',
  `total_score` DECIMAL(10,2) DEFAULT 0.00 COMMENT '总评分',
  `score_count` INT(11) DEFAULT 0 COMMENT '评分次数',
  `avg_score` DECIMAL(5,2) DEFAULT 0.00 COMMENT '平均评分',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`stat_id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  KEY `idx_view_count` (`view_count`),
  KEY `idx_download_count` (`download_count`),
  KEY `idx_favorite_count` (`favorite_count`),
  KEY `idx_avg_score` (`avg_score`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MSDS文档统计表';

-- ============================================================
-- 5. 文档访问日志表 (msds_document_access_log)
-- 功能: 记录文档的详细访问日志（查看、下载等操作）
-- ============================================================
DROP TABLE IF EXISTS `msds_document_access_log`;
CREATE TABLE `msds_document_access_log` (
  `log_id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `msds_id` BIGINT(20) NOT NULL COMMENT 'MSDS文档ID',
  `user_id` BIGINT(20) DEFAULT NULL COMMENT '用户ID',
  `user_name` VARCHAR(64) DEFAULT '' COMMENT '用户名称',
  `access_type` VARCHAR(20) NOT NULL COMMENT 'access type: view, download, preview, print',
  `access_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '访问时间',
  `ip_address` VARCHAR(128) DEFAULT '' COMMENT 'IP地址',
  `user_agent` VARCHAR(500) DEFAULT '' COMMENT '用户代理',
  `device_type` VARCHAR(50) DEFAULT NULL COMMENT '设备类型: pc, mobile, tablet',
  `browser` VARCHAR(100) DEFAULT NULL COMMENT '浏览器',
  `duration` INT(11) DEFAULT NULL COMMENT '访问时长(秒)',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`log_id`),
  KEY `idx_msds_id` (`msds_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_access_type` (`access_type`),
  KEY `idx_access_time` (`access_time`),
  KEY `idx_msds_access_time` (`msds_id`, `access_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MSDS文档访问日志表';

-- ============================================================
-- 初始化数据
-- ============================================================

-- 插入一些热门搜索建议（使用INSERT IGNORE避免重复）
INSERT IGNORE INTO `msds_search_suggestion` (`keyword`, `keyword_type`, `search_count`, `sort_order`, `is_active`, `create_time`) VALUES
('乙醇', 'hot', 156, 1, 1, NOW()),
('甲醇', 'hot', 142, 2, 1, NOW()),
('丙酮', 'hot', 128, 3, 1, NOW()),
('盐酸', 'hot', 115, 4, 1, NOW()),
('硫酸', 'hot', 98, 5, 1, NOW()),
('64-17-5', 'cas', 45, 1, 1, NOW()),
('67-56-1', 'cas', 38, 2, 1, NOW()),
('易燃液体', 'hot', 89, 6, 1, NOW()),
('腐蚀性', 'hot', 76, 7, 1, NOW()),
('有毒物质', 'hot', 65, 8, 1, NOW());

-- 为现有MSDS文档初始化统计记录（使用INSERT IGNORE避免重复）
INSERT IGNORE INTO `msds_document_statistics` (`msds_id`, `view_count`, `download_count`, `favorite_count`, `create_time`)
SELECT `id`, 0, 0, 0, NOW()
FROM `msds_main`
WHERE `id` NOT IN (SELECT `msds_id` FROM `msds_document_statistics`);

