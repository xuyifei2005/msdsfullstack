-- ----------------------------
-- Table structure for sys_import_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_import_log`;
CREATE TABLE `sys_import_log` (
  `log_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `batch_no` varchar(50) NOT NULL COMMENT '批次号',
  `file_name` varchar(255) NOT NULL COMMENT '文件名',
  `file_size` bigint(20) DEFAULT NULL COMMENT '文件大小(字节)',
  `file_type` varchar(50) DEFAULT NULL COMMENT '文件类型(xlsx,xls,csv,txt等)',
  `import_type` varchar(50) NOT NULL COMMENT '导入类型(MSDS,COMPONENT,USER等)',
  `status` varchar(20) NOT NULL DEFAULT 'PENDING' COMMENT '导入状态(PENDING,PROCESSING,SUCCESS,FAILED,PARTIAL_SUCCESS,CANCELLED)',
  `total_rows` int(11) DEFAULT NULL COMMENT '总行数',
  `success_rows` int(11) DEFAULT 0 COMMENT '成功行数',
  `failed_rows` int(11) DEFAULT 0 COMMENT '失败行数',
  `warning_rows` int(11) DEFAULT 0 COMMENT '警告行数',
  `skipped_rows` int(11) DEFAULT 0 COMMENT '跳过行数',
  `start_time` datetime DEFAULT NULL COMMENT '处理开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '处理结束时间',
  `processing_time` bigint(20) DEFAULT NULL COMMENT '处理耗时(毫秒)',
  `error_message` text COMMENT '错误信息',
  `error_code` varchar(20) DEFAULT NULL COMMENT '错误码',
  `error_details` longtext COMMENT '错误详情(JSON格式)',
  `validation_result` longtext COMMENT '校验结果(JSON格式)',
  `import_config` text COMMENT '导入配置(JSON格式)',
  `user_id` bigint(20) DEFAULT NULL COMMENT '操作用户ID',
  `user_name` varchar(50) DEFAULT NULL COMMENT '操作用户名',
  `client_ip` varchar(128) DEFAULT NULL COMMENT '客户端IP',
  `user_agent` varchar(500) DEFAULT NULL COMMENT '用户代理',
  `remarks` varchar(500) DEFAULT NULL COMMENT '备注',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志(0代表存在 2代表删除)',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`log_id`),
  UNIQUE KEY `uk_batch_no` (`batch_no`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_import_type` (`import_type`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_file_type` (`file_type`),
  KEY `idx_error_code` (`error_code`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='导入日志表';

-- ----------------------------
-- Records of sys_import_log
-- ----------------------------
INSERT INTO `sys_import_log` VALUES 
(1, 'IMP202401201030001001', 'msds_sample.xlsx', 51200, 'xlsx', 'MSDS', 'SUCCESS', 100, 95, 3, 2, 0, '2024-01-20 10:30:15', '2024-01-20 10:32:45', 150000, NULL, NULL, NULL, '{"totalErrors":3,"totalWarnings":2,"columnMapping":{"化学品中文名":"productName","英文名":"productEnglishName","CAS号":"productAlias"}}', '{"skipEmptyRows":true,"validateRequired":true,"autoMapping":true}', 1, 'admin', '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', '测试导入MSDS数据', '0', 'admin', '2024-01-20 10:30:00', 'admin', '2024-01-20 10:32:45'),
(2, 'IMP202401201045001002', 'component_data.csv', 25600, 'csv', 'COMPONENT', 'FAILED', 50, 0, 50, 0, 0, '2024-01-20 10:45:10', '2024-01-20 10:45:30', 20000, '文件格式错误，无法解析CSV文件', '1001', '{"errors":[{"row":1,"column":"A","message":"文件编码错误"}]}', NULL, '{"encoding":"UTF-8","delimiter":","}', 1, 'admin', '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', '组件数据导入失败', '0', 'admin', '2024-01-20 10:45:00', 'admin', '2024-01-20 10:45:30'),
(3, 'IMP202401201100001003', 'user_list.xlsx', 76800, 'xlsx', 'USER', 'PROCESSING', 200, 150, 0, 0, 0, '2024-01-20 11:00:05', NULL, NULL, NULL, NULL, NULL, NULL, '{"batchSize":50,"validateEmail":true}', 2, 'operator', '192.168.1.101', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', '用户数据批量导入', '0', 'operator', '2024-01-20 11:00:00', 'operator', '2024-01-20 11:00:05');

-- ----------------------------
-- 创建索引以优化查询性能
-- ----------------------------
-- 复合索引：用户+时间范围查询
CREATE INDEX `idx_user_time` ON `sys_import_log` (`user_id`, `create_time`);

-- 复合索引：状态+类型查询
CREATE INDEX `idx_status_type` ON `sys_import_log` (`status`, `import_type`);

-- 复合索引：时间范围+删除标志
CREATE INDEX `idx_time_del` ON `sys_import_log` (`create_time`, `del_flag`);

-- 全文索引：文件名搜索
-- ALTER TABLE `sys_import_log` ADD FULLTEXT(`file_name`);

-- ----------------------------
-- 添加表注释和字段注释
-- ----------------------------
ALTER TABLE `sys_import_log` COMMENT = '导入日志表 - 记录所有文件导入操作的详细信息，包括处理状态、错误信息、性能指标等';

-- 状态字段说明：
-- PENDING: 待处理 - 文件已上传，等待处理
-- PROCESSING: 处理中 - 正在解析和导入数据
-- SUCCESS: 成功 - 所有数据导入成功
-- FAILED: 失败 - 导入过程中发生错误，无法继续
-- PARTIAL_SUCCESS: 部分成功 - 部分数据导入成功，部分失败
-- CANCELLED: 已取消 - 用户主动取消导入操作

-- 导入类型说明：
-- MSDS: MSDS安全数据表导入
-- COMPONENT: 化学品组分数据导入
-- USER: 用户数据导入
-- TEMPLATE: 模板数据导入
-- BATCH: 批量数据导入