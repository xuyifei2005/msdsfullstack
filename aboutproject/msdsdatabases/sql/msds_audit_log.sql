-- ----------------------------
-- Table structure for msds_audit_log
-- ----------------------------
DROP TABLE IF EXISTS `msds_audit_log`;
CREATE TABLE `msds_audit_log`  (
  `log_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `msds_id` bigint(20) NULL DEFAULT NULL COMMENT 'MSDS主信息ID',
  `operation_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作类型（CREATE/UPDATE/DELETE/VIEW/EXPORT/IMPORT）',
  `operation_desc` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作描述',
  `before_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '操作前数据（JSON格式）',
  `after_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '操作后数据（JSON格式）',
  `operator` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作人员',
  `operator_id` bigint(20) NULL DEFAULT NULL COMMENT '操作人员ID',
  `operation_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `ip_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'IP地址',
  `user_agent` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户代理',
  `operation_result` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作结果（SUCCESS/FAILED）',
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '错误信息',
  PRIMARY KEY (`log_id`) USING BTREE,
  INDEX `idx_msds_id`(`msds_id`) USING BTREE,
  INDEX `idx_operation_type`(`operation_type`) USING BTREE,
  INDEX `idx_operator`(`operator`) USING BTREE,
  INDEX `idx_operation_time`(`operation_time`) USING BTREE,
  INDEX `idx_operation_result`(`operation_result`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'MSDS操作审计日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- 插入菜单权限数据
-- ----------------------------

-- 主菜单
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, query, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('MSDS审计日志', 2000, 6, 'auditlog', 'system/auditlog/index', '', 1, 0, 'C', '0', '0', 'system:auditlog:list', 'log', 'admin', sysdate(), '', null, 'MSDS操作审计日志菜单');

-- 获取刚插入的菜单ID
SET @menu_id = LAST_INSERT_ID();

-- 子菜单权限
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, query, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES 
('MSDS审计日志查询', @menu_id, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:auditlog:query', '#', 'admin', sysdate(), '', null, ''),
('MSDS审计日志新增', @menu_id, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:auditlog:add', '#', 'admin', sysdate(), '', null, ''),
('MSDS审计日志修改', @menu_id, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:auditlog:edit', '#', 'admin', sysdate(), '', null, ''),
('MSDS审计日志删除', @menu_id, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:auditlog:remove', '#', 'admin', sysdate(), '', null, ''),
('MSDS审计日志导出', @menu_id, 5, '', '', '', 1, 0, 'F', '0', '0', 'system:auditlog:export', '#', 'admin', sysdate(), '', null, '');

-- 示例数据
INSERT INTO msds_audit_log (msds_id, operation_type, operation_desc, operator, operator_id, operation_time, ip_address, operation_result)
VALUES 
(1, 'CREATE', '创建MSDS文档：测试化学品A', 'admin', 1, NOW(), '127.0.0.1', 'SUCCESS'),
(1, 'UPDATE', '更新MSDS文档：测试化学品A', 'admin', 1, NOW(), '127.0.0.1', 'SUCCESS'),
(2, 'CREATE', '创建MSDS文档：测试化学品B', 'admin', 1, NOW(), '127.0.0.1', 'SUCCESS'),
(1, 'EXPORT', '导出MSDS文档：测试化学品A', 'admin', 1, NOW(), '127.0.0.1', 'SUCCESS'),
(NULL, 'IMPORT', '批量导入MSDS文档', 'admin', 1, NOW(), '127.0.0.1', 'FAILED');