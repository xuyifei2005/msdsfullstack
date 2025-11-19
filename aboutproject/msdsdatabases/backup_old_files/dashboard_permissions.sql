-- Active: 1749896818141@@127.0.0.1@3306@msds_management
-- 仪表板权限配置SQL脚本

-- 添加仪表板菜单项
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) 
VALUES ('数据仪表板', 0, 1, 'dashboard', 'Dashboard/index', 1, 0, 'M', '0', '0', 'system:dashboard:view', 'dashboard', 'admin', now(), '', null, '数据仪表板菜单');

-- 获取刚插入的菜单ID（注意：这里需要根据实际情况调整）
SET @dashboard_menu_id = LAST_INSERT_ID();

-- 添加仪表板相关权限
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) 
VALUES 
('概览查看', @dashboard_menu_id, 1, '', '', 1, 0, 'F', '0', '0', 'system:dashboard:overview', '#', 'admin', now(), '', null, '仪表板概览查看'),
('趋势分析', @dashboard_menu_id, 2, '', '', 1, 0, 'F', '0', '0', 'system:dashboard:trend', '#', 'admin', now(), '', null, '访问趋势分析'),
('用户活动', @dashboard_menu_id, 3, '', '', 1, 0, 'F', '0', '0', 'system:dashboard:activity', '#', 'admin', now(), '', null, '用户活动分析'),
('下载分析', @dashboard_menu_id, 4, '', '', 1, 0, 'F', '0', '0', 'system:dashboard:download', '#', 'admin', now(), '', null, '下载分析'),
('热门文档', @dashboard_menu_id, 5, '', '', 1, 0, 'F', '0', '0', 'system:dashboard:hot', '#', 'admin', now(), '', null, '热门文档查看'),
('实时统计', @dashboard_menu_id, 6, '', '', 1, 0, 'F', '0', '0', 'system:dashboard:realtime', '#', 'admin', now(), '', null, '实时统计查看'),
('文档统计', @dashboard_menu_id, 7, '', '', 1, 0, 'F', '0', '0', 'system:dashboard:document', '#', 'admin', now(), '', null, '文档统计查看'),
('系统健康', @dashboard_menu_id, 8, '', '', 1, 0, 'F', '0', '0', 'system:dashboard:health', '#', 'admin', now(), '', null, '系统健康监控'),
('化学品统计', @dashboard_menu_id, 9, '', '', 1, 0, 'F', '0', '0', 'system:dashboard:chemical', '#', 'admin', now(), '', null, '化学品统计查看'),
('报告导出', @dashboard_menu_id, 10, '', '', 1, 0, 'F', '0', '0', 'system:dashboard:export', '#', 'admin', now(), '', null, '仪表板报告导出');

-- 为管理员角色分配仪表板权限
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 1, menu_id FROM sys_menu WHERE perms LIKE 'system:dashboard:%';

-- 创建仪表板相关数据表（如果不存在）

-- MSDS文档表
CREATE TABLE IF NOT EXISTS `msds_document` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '文档ID',
  `name` varchar(255) NOT NULL COMMENT '文档名称',
  `category` varchar(100) DEFAULT NULL COMMENT '文档分类',
  `chemical_id` bigint(20) DEFAULT NULL COMMENT '化学品ID',
  `file_path` varchar(500) DEFAULT NULL COMMENT '文件路径',
  `file_type` varchar(20) DEFAULT NULL COMMENT '文件类型',
  `file_size` bigint(20) DEFAULT NULL COMMENT '文件大小',
  `status` char(1) DEFAULT '0' COMMENT '状态（0待审核 1已审核 2已拒绝）',
  `expiry_date` datetime DEFAULT NULL COMMENT '过期时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MSDS文档表';

-- 化学品信息表
CREATE TABLE IF NOT EXISTS `msds_chemical` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '化学品ID',
  `name` varchar(255) NOT NULL COMMENT '化学品名称',
  `cas_number` varchar(50) DEFAULT NULL COMMENT 'CAS号',
  `molecular_formula` varchar(100) DEFAULT NULL COMMENT '分子式',
  `molecular_weight` decimal(10,4) DEFAULT NULL COMMENT '分子量',
  `danger_level` varchar(20) DEFAULT NULL COMMENT '危险级别（high/medium/low）',
  `category` varchar(100) DEFAULT NULL COMMENT '化学品分类',
  `supplier` varchar(255) DEFAULT NULL COMMENT '供应商',
  `manufacturer` varchar(255) DEFAULT NULL COMMENT '生产商',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_cas_number` (`cas_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='化学品信息表';

-- 访问日志表
CREATE TABLE IF NOT EXISTS `msds_access_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `user_id` bigint(20) DEFAULT NULL COMMENT '用户ID',
  `document_id` bigint(20) DEFAULT NULL COMMENT '文档ID',
  `access_type` varchar(20) DEFAULT NULL COMMENT '访问类型（view/search/download）',
  `ip_address` varchar(50) DEFAULT NULL COMMENT 'IP地址',
  `user_agent` varchar(500) DEFAULT NULL COMMENT '用户代理',
  `access_time` datetime DEFAULT NULL COMMENT '访问时间',
  `session_id` varchar(100) DEFAULT NULL COMMENT '会话ID',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_document_id` (`document_id`),
  KEY `idx_access_time` (`access_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='访问日志表';

-- 下载日志表
CREATE TABLE IF NOT EXISTS `msds_download_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `user_id` bigint(20) DEFAULT NULL COMMENT '用户ID',
  `document_id` bigint(20) DEFAULT NULL COMMENT '文档ID',
  `download_type` varchar(20) DEFAULT NULL COMMENT '下载类型（pdf/word/excel）',
  `file_size` bigint(20) DEFAULT NULL COMMENT '文件大小',
  `download_status` varchar(20) DEFAULT NULL COMMENT '下载状态（success/failed）',
  `ip_address` varchar(50) DEFAULT NULL COMMENT 'IP地址',
  `download_time` datetime DEFAULT NULL COMMENT '下载时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_document_id` (`document_id`),
  KEY `idx_download_time` (`download_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='下载日志表';

-- 插入一些示例数据
INSERT INTO `msds_chemical` (`name`, `cas_number`, `molecular_formula`, `molecular_weight`, `danger_level`, `category`, `supplier`) VALUES
('乙醇', '64-17-5', 'C2H6O', 46.0684, 'low', '有机溶剂', '上海化工有限公司'),
('甲醇', '67-56-1', 'CH4O', 32.0419, 'medium', '有机溶剂', '北京化学试剂厂'),
('丙酮', '67-64-1', 'C3H6O', 58.0791, 'medium', '有机溶剂', '广州试剂公司'),
('苯', '71-43-2', 'C6H6', 78.1118, 'high', '芳香烃', '天津化工集团'),
('甲苯', '108-88-3', 'C7H8', 92.1384, 'medium', '芳香烃', '深圳化学有限公司');

INSERT INTO `msds_document` (`name`, `category`, `chemical_id`, `file_type`, `status`, `expiry_date`) VALUES
('乙醇安全技术说明书', '有机溶剂', 1, 'PDF', '1', DATE_ADD(NOW(), INTERVAL 2 YEAR)),
('甲醇安全技术说明书', '有机溶剂', 2, 'PDF', '1', DATE_ADD(NOW(), INTERVAL 2 YEAR)),
('丙酮安全技术说明书', '有机溶剂', 3, 'PDF', '1', DATE_ADD(NOW(), INTERVAL 2 YEAR)),
('苯安全技术说明书', '芳香烃', 4, 'PDF', '0', DATE_ADD(NOW(), INTERVAL 2 YEAR)),
('甲苯安全技术说明书', '芳香烃', 5, 'PDF', '1', DATE_ADD(NOW(), INTERVAL 2 YEAR));

-- 插入一些访问日志示例数据
INSERT INTO `msds_access_log` (`user_id`, `document_id`, `access_type`, `ip_address`, `access_time`) VALUES
(1, 1, 'view', '192.168.1.100', NOW() - INTERVAL 1 DAY),
(1, 2, 'view', '192.168.1.100', NOW() - INTERVAL 2 DAY),
(2, 1, 'view', '192.168.1.101', NOW() - INTERVAL 3 DAY),
(2, 3, 'download', '192.168.1.101', NOW() - INTERVAL 1 DAY),
(3, 2, 'view', '192.168.1.102', NOW());

-- 插入一些下载日志示例数据
INSERT INTO `msds_download_log` (`user_id`, `document_id`, `download_type`, `file_size`, `download_status`, `ip_address`, `download_time`) VALUES
(1, 1, 'pdf', 1024000, 'success', '192.168.1.100', NOW() - INTERVAL 1 DAY),
(2, 3, 'pdf', 2048000, 'success', '192.168.1.101', NOW() - INTERVAL 1 DAY),
(3, 2, 'pdf', 1536000, 'success', '192.168.1.102', NOW()),
(1, 5, 'pdf', 1792000, 'success', '192.168.1.100', NOW()),
(2, 1, 'pdf', 1024000, 'success', '192.168.1.101', NOW() - INTERVAL 2 HOUR); 