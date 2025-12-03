
DROP TABLE IF EXISTS `msds_faq`;
CREATE TABLE `msds_faq` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `question` varchar(500) NOT NULL COMMENT '问题',
  `answer` text NOT NULL COMMENT '回答',
  `category` varchar(100) DEFAULT NULL COMMENT '分类',
  `sort_order` int(11) DEFAULT 0 COMMENT '排序',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='常见问题表';

DROP TABLE IF EXISTS `msds_feedback`;
CREATE TABLE `msds_feedback` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(20) DEFAULT NULL COMMENT '用户ID',
  `user_name` varchar(64) DEFAULT NULL COMMENT '用户名',
  `content` text NOT NULL COMMENT '反馈内容',
  `contact_info` varchar(255) DEFAULT NULL COMMENT '联系方式',
  `images` text DEFAULT NULL COMMENT '图片(JSON数组)',
  `status` char(1) DEFAULT '0' COMMENT '状态（0未处理 1已处理）',
  `reply_content` text DEFAULT NULL COMMENT '回复内容',
  `reply_by` varchar(64) DEFAULT NULL COMMENT '回复人',
  `reply_time` datetime DEFAULT NULL COMMENT '回复时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='意见反馈表';

DROP TABLE IF EXISTS `msds_about_us`;
CREATE TABLE `msds_about_us` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(200) NOT NULL COMMENT '标题',
  `content` longtext COMMENT '内容',
  `type` varchar(50) NOT NULL COMMENT '类型(about, privacy, terms)',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='关于我们表';

INSERT INTO `msds_about_us` (`title`, `content`, `type`, `create_time`, `status`) VALUES 
('关于我们', '<p>MSDS实验室管理系统...</p>', 'about', NOW(), '0'),
('隐私政策', '<p>隐私政策内容...</p>', 'privacy', NOW(), '0'),
('服务条款', '<p>服务条款内容...</p>', 'terms', NOW(), '0');
