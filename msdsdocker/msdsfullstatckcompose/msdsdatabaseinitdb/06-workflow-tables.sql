-- ============================================================
-- 协作工作流模块数据库表
-- 创建时间: 2025-01-XX
-- 说明: 创建协作工作流相关的数据表
-- ============================================================

USE msds_dev;

-- ============================================================
-- 1. 工作流任务表 (workflow_task)
-- ============================================================
DROP TABLE IF EXISTS `workflow_task`;
CREATE TABLE `workflow_task` (
  `task_id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `task_title` VARCHAR(200) NOT NULL COMMENT '任务标题',
  `task_description` TEXT COMMENT '任务描述',
  `task_type` VARCHAR(50) DEFAULT 'msds_review' COMMENT '任务类型：msds_review-MSDS审核, msds_update-MSDS更新, msds_format-MSDS格式规范',
  `status` VARCHAR(20) DEFAULT 'pending' COMMENT '任务状态：pending-待处理, reviewing-审核中, approved-已通过, rejected-已拒绝',
  `priority` VARCHAR(20) DEFAULT 'normal' COMMENT '优先级：urgent-紧急, normal-普通, low-低',
  `assignee_id` BIGINT(20) COMMENT '负责人ID',
  `assignee_name` VARCHAR(100) COMMENT '负责人姓名',
  `creator_id` BIGINT(20) NOT NULL COMMENT '创建人ID',
  `creator_name` VARCHAR(100) COMMENT '创建人姓名',
  `msds_id` BIGINT(20) COMMENT '关联的MSDS ID',
  `msds_name` VARCHAR(200) COMMENT '关联的MSDS名称',
  `due_date` DATETIME COMMENT '截止日期',
  `progress` INT(3) DEFAULT 0 COMMENT '进度百分比（0-100）',
  `attachment_count` INT(5) DEFAULT 0 COMMENT '附件数量',
  `comment_count` INT(5) DEFAULT 0 COMMENT '评论数量',
  `reviewer_ids` VARCHAR(500) COMMENT '审核人ID列表（逗号分隔）',
  `reviewer_names` VARCHAR(500) COMMENT '审核人姓名列表（逗号分隔）',
  `rejection_reason` TEXT COMMENT '拒绝原因',
  `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`task_id`),
  KEY `idx_status` (`status`),
  KEY `idx_assignee` (`assignee_id`),
  KEY `idx_creator` (`creator_id`),
  KEY `idx_msds` (`msds_id`),
  KEY `idx_due_date` (`due_date`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工作流任务表';

-- ============================================================
-- 2. 工作流评论表 (workflow_comment)
-- ============================================================
DROP TABLE IF EXISTS `workflow_comment`;
CREATE TABLE `workflow_comment` (
  `comment_id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `task_id` BIGINT(20) NOT NULL COMMENT '任务ID',
  `user_id` BIGINT(20) NOT NULL COMMENT '评论人ID',
  `user_name` VARCHAR(100) NOT NULL COMMENT '评论人姓名',
  `content` TEXT NOT NULL COMMENT '评论内容',
  `parent_id` BIGINT(20) DEFAULT NULL COMMENT '父评论ID（用于回复）',
  `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`comment_id`),
  KEY `idx_task` (`task_id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工作流评论表';

-- ============================================================
-- 3. 工作流活动日志表 (workflow_activity)
-- ============================================================
DROP TABLE IF EXISTS `workflow_activity`;
CREATE TABLE `workflow_activity` (
  `activity_id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '活动ID',
  `task_id` BIGINT(20) NOT NULL COMMENT '任务ID',
  `user_id` BIGINT(20) NOT NULL COMMENT '操作用户ID',
  `user_name` VARCHAR(100) NOT NULL COMMENT '操作用户姓名',
  `action_type` VARCHAR(50) NOT NULL COMMENT '操作类型：create-创建, assign-分配, status_change-状态变更, comment-评论, approve-通过, reject-拒绝',
  `action_description` VARCHAR(500) COMMENT '操作描述',
  `old_value` VARCHAR(500) COMMENT '旧值（用于状态变更）',
  `new_value` VARCHAR(500) COMMENT '新值（用于状态变更）',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`activity_id`),
  KEY `idx_task` (`task_id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_action_type` (`action_type`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工作流活动日志表';

-- ============================================================
-- 4. 工作流任务附件表 (workflow_attachment)
-- ============================================================
DROP TABLE IF EXISTS `workflow_attachment`;
CREATE TABLE `workflow_attachment` (
  `attachment_id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '附件ID',
  `task_id` BIGINT(20) NOT NULL COMMENT '任务ID',
  `file_name` VARCHAR(255) NOT NULL COMMENT '文件名',
  `file_path` VARCHAR(500) NOT NULL COMMENT '文件路径',
  `file_size` BIGINT(20) COMMENT '文件大小（字节）',
  `file_type` VARCHAR(50) COMMENT '文件类型',
  `upload_user_id` BIGINT(20) COMMENT '上传用户ID',
  `upload_user_name` VARCHAR(100) COMMENT '上传用户姓名',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`attachment_id`),
  KEY `idx_task` (`task_id`),
  KEY `idx_upload_user` (`upload_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工作流任务附件表';

-- ============================================================
-- 5. 插入初始测试数据
-- ============================================================

-- 插入测试任务数据
INSERT INTO `workflow_task` (`task_title`, `task_description`, `task_type`, `status`, `priority`, `assignee_id`, `assignee_name`, `creator_id`, `creator_name`, `msds_id`, `msds_name`, `due_date`, `progress`, `attachment_count`, `comment_count`, `create_by`) VALUES
('乙醇MSDS文档审核', '需要对新上传的乙醇MSDS文档进行安全性审核', 'msds_review', 'pending', 'urgent', 1, '张三', 2, '李四', 1, '乙醇', DATE_ADD(NOW(), INTERVAL 1 DAY), 0, 3, 2, 'admin'),
('甲醇MSDS信息更新', '更新甲醇的物理化学性质和安全防护措施', 'msds_update', 'pending', 'normal', 2, '李四', 3, '王五', 2, '甲醇', DATE_ADD(NOW(), INTERVAL 2 DAY), 0, 1, 0, 'admin'),
('丙酮MSDS格式规范', '检查并规范丙酮MSDS文档的格式', 'msds_format', 'pending', 'low', 3, '王五', 1, '张三', 3, '丙酮', DATE_ADD(NOW(), INTERVAL 5 DAY), 0, 0, 0, 'admin'),
('异丙醇MSDS技术审核', '技术专家正在审核异丙醇的安全数据', 'msds_review', 'reviewing', 'normal', 1, '张三', 2, '李四', 4, '异丙醇', DATE_ADD(NOW(), INTERVAL 1 DAY), 60, 2, 1, 'admin'),
('苯MSDS安全评估', '高危化学品安全评估，需要多人审核', 'msds_review', 'reviewing', 'urgent', 2, '李四', 1, '张三', 5, '苯', NOW(), 0, 1, 0, 'admin'),
('氯化钠MSDS审核', '已通过安全审核，可以发布使用', 'msds_review', 'approved', 'normal', 3, '王五', 2, '李四', 6, '氯化钠', DATE_SUB(NOW(), INTERVAL 1 DAY), 100, 2, 3, 'admin'),
('硫酸MSDS更新', '更新版本已通过审核', 'msds_update', 'approved', 'normal', 4, '赵六', 3, '王五', 7, '硫酸', DATE_SUB(NOW(), INTERVAL 2 DAY), 100, 1, 1, 'admin'),
('汞MSDS文档', '安全信息不完整，需要重新编写', 'msds_review', 'rejected', 'normal', 1, '张三', 2, '李四', 8, '汞', DATE_SUB(NOW(), INTERVAL 3 DAY), 0, 1, 1, 'admin');

-- 插入测试评论数据
INSERT INTO `workflow_comment` (`task_id`, `user_id`, `user_name`, `content`, `create_by`) VALUES
(1, 1, '张三', '这个文档需要重点关注安全防护措施部分', 'admin'),
(1, 2, '李四', '同意，我已经标注了需要修改的地方', 'admin'),
(4, 1, '张三', '技术审核已完成60%，预计明天完成', 'admin'),
(6, 3, '王五', '审核通过，可以发布', 'admin'),
(6, 2, '李四', '同意发布', 'admin'),
(6, 1, '张三', '已发布', 'admin'),
(7, 4, '赵六', '更新完成', 'admin'),
(8, 1, '张三', '审核意见：急性毒性数据缺失，应急处理措施不够详细', 'admin');

-- 插入测试活动日志数据
INSERT INTO `workflow_activity` (`task_id`, `user_id`, `user_name`, `action_type`, `action_description`, `old_value`, `new_value`) VALUES
(1, 2, '李四', 'create', '创建了新任务：乙醇MSDS文档审核', NULL, NULL),
(1, 2, '李四', 'assign', '将任务分配给张三', NULL, '张三'),
(1, 1, '张三', 'comment', '添加了评论', NULL, NULL),
(1, 2, '李四', 'comment', '添加了评论', NULL, NULL),
(4, 2, '李四', 'create', '创建了新任务：异丙醇MSDS技术审核', NULL, NULL),
(4, 1, '张三', 'status_change', '任务状态变更为审核中', 'pending', 'reviewing'),
(4, 1, '张三', 'comment', '添加了评论', NULL, NULL),
(6, 2, '李四', 'create', '创建了新任务：氯化钠MSDS审核', NULL, NULL),
(6, 3, '王五', 'status_change', '任务状态变更为已通过', 'reviewing', 'approved'),
(6, 3, '王五', 'approve', '审核通过', NULL, NULL),
(8, 2, '李四', 'create', '创建了新任务：汞MSDS文档', NULL, NULL),
(8, 1, '张三', 'status_change', '任务状态变更为已拒绝', 'reviewing', 'rejected'),
(8, 1, '张三', 'reject', '拒绝任务', NULL, '急性毒性数据缺失，应急处理措施不够详细');

-- ============================================================
-- 完成提示
-- ============================================================
SELECT 
    '协作工作流表创建完成' as message,
    (SELECT COUNT(*) FROM workflow_task) as task_count,
    (SELECT COUNT(*) FROM workflow_comment) as comment_count,
    (SELECT COUNT(*) FROM workflow_activity) as activity_count,
    NOW() as completion_time;

