-- ============================================================
-- MSDS实验室管理系统 - 生产环境数据库初始化脚本
-- 版本: v1.0
-- 更新日期: 2025-01-27
-- 说明: 创建所有必需的数据库表和初始化数据
-- ============================================================

-- 使用msds_dev数据库
USE msds_dev;

-- ============================================================
-- MSDS主表
-- ============================================================
CREATE TABLE IF NOT EXISTS `msds_main` (
    `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT 'MSDS主键ID',
    `msds_number` VARCHAR(100) DEFAULT NULL COMMENT 'MSDS编号',
    `product_name` VARCHAR(200) NOT NULL COMMENT '化学品中文名',
    `product_english_name` VARCHAR(200) DEFAULT NULL COMMENT '化学品英文名',
    `product_alias` VARCHAR(500) DEFAULT NULL COMMENT '化学品别名/CAS号',
    `cas_number` VARCHAR(50) DEFAULT NULL COMMENT 'CAS号',
    `company_name` VARCHAR(200) DEFAULT NULL COMMENT '企业名称',
    `company_address` VARCHAR(500) DEFAULT NULL COMMENT '企业地址',
    `company_phone` VARCHAR(50) DEFAULT NULL COMMENT '企业电话',
    `company_fax` VARCHAR(50) DEFAULT NULL COMMENT '企业传真',
    `company_email` VARCHAR(100) DEFAULT NULL COMMENT '企业邮箱',
    `emergency_phone` VARCHAR(50) DEFAULT NULL COMMENT '应急电话',
    `msds_version` VARCHAR(50) DEFAULT NULL COMMENT 'MSDS版本',
    `revision_date` DATE DEFAULT NULL COMMENT '修订日期',
    `file_name` VARCHAR(255) DEFAULT NULL COMMENT '原始文件名',
    `file_path` VARCHAR(500) DEFAULT NULL COMMENT '文件存储路径',
    `file_size` BIGINT(20) DEFAULT NULL COMMENT '文件大小（字节）',
    `file_type` VARCHAR(20) DEFAULT NULL COMMENT '文件类型',
    `content_text` LONGTEXT COMMENT '文档内容文本',
    `parse_status` VARCHAR(20) DEFAULT 'SUCCESS' COMMENT '解析状态：SUCCESS/FAILED/PARTIAL',
    `parse_error_msg` TEXT COMMENT '解析错误信息',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
    `del_flag` CHAR(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
    PRIMARY KEY (`id`),
    KEY `idx_msds_main_product_name` (`product_name`),
    KEY `idx_msds_main_cas_number` (`cas_number`),
    KEY `idx_msds_main_msds_number` (`msds_number`),
    KEY `idx_msds_main_create_time` (`create_time`),
    KEY `idx_msds_main_parse_status` (`parse_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MSDS主表';

-- ============================================================
-- MSDS详细信息表
-- ============================================================
CREATE TABLE IF NOT EXISTS `msds_detail` (
    `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `msds_main_id` BIGINT(20) NOT NULL COMMENT 'MSDS主表ID',
    `section_number` INT(11) DEFAULT NULL COMMENT '章节号',
    `section_title` VARCHAR(200) DEFAULT NULL COMMENT '章节标题',
    `section_content` LONGTEXT COMMENT '章节内容',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_msds_detail_main_id` (`msds_main_id`),
    KEY `idx_msds_detail_section` (`section_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MSDS详细信息表';

-- ============================================================
-- MSDS成分信息表
-- ============================================================
CREATE TABLE IF NOT EXISTS `msds_component` (
    `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `msds_main_id` BIGINT(20) NOT NULL COMMENT 'MSDS主表ID',
    `component_name` VARCHAR(200) DEFAULT NULL COMMENT '成分名称',
    `component_cas` VARCHAR(50) DEFAULT NULL COMMENT '成分CAS号',
    `component_percentage` VARCHAR(50) DEFAULT NULL COMMENT '成分含量百分比',
    `component_classification` VARCHAR(200) DEFAULT NULL COMMENT '成分分类',
    `hazard_statement` TEXT COMMENT '危险性说明',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_msds_component_main_id` (`msds_main_id`),
    KEY `idx_msds_component_cas` (`component_cas`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MSDS成分信息表';

-- ============================================================
-- MSDS危险性信息表
-- ============================================================
CREATE TABLE IF NOT EXISTS `msds_hazard` (
    `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `msds_main_id` BIGINT(20) NOT NULL COMMENT 'MSDS主表ID',
    `hazard_category` VARCHAR(100) DEFAULT NULL COMMENT '危险性类别',
    `hazard_level` VARCHAR(50) DEFAULT NULL COMMENT '危险等级',
    `hazard_description` TEXT COMMENT '危险性描述',
    `precautionary_statement` TEXT COMMENT '预防措施说明',
    `signal_word` VARCHAR(50) DEFAULT NULL COMMENT '信号词',
    `pictogram` VARCHAR(100) DEFAULT NULL COMMENT '象形图',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_msds_hazard_main_id` (`msds_main_id`),
    KEY `idx_msds_hazard_category` (`hazard_category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MSDS危险性信息表';

-- ============================================================
-- MSDS急救措施表
-- ============================================================
CREATE TABLE IF NOT EXISTS `msds_first_aid` (
    `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `msds_main_id` BIGINT(20) NOT NULL COMMENT 'MSDS主表ID',
    `symptoms` TEXT COMMENT '症状',
    `treatment` TEXT COMMENT '治疗方法',
    `special_treatment` TEXT COMMENT '特殊治疗',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_msds_first_aid_main_id` (`msds_main_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MSDS急救措施表';

-- ============================================================
-- MSDS消防措施表
-- ============================================================
CREATE TABLE IF NOT EXISTS `msds_fire_fighting` (
    `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `msds_main_id` BIGINT(20) NOT NULL COMMENT 'MSDS主表ID',
    `suitable_media` TEXT COMMENT '适合的灭火剂',
    `unsuitable_media` TEXT COMMENT '不适合的灭火剂',
    `specific_hazards` TEXT COMMENT '特定危险',
    `protective_equipment` TEXT COMMENT '防护装备',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_msds_fire_fighting_main_id` (`msds_main_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MSDS消防措施表';

-- ============================================================
-- MSDS泄漏应急处理表
-- ============================================================
CREATE TABLE IF NOT EXISTS `msds_leak_response` (
    `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `msds_main_id` BIGINT(20) NOT NULL COMMENT 'MSDS主表ID',
    `personal_precautions` TEXT COMMENT '个人防护',
    `environmental_precautions` TEXT COMMENT '环境保护',
    `cleaning_methods` TEXT COMMENT '清理方法',
    `reference_materials` TEXT COMMENT '参考材料',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_msds_leak_response_main_id` (`msds_main_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MSDS泄漏应急处理表';

-- ============================================================
-- MSDS操作和储存表
-- ============================================================
CREATE TABLE IF NOT EXISTS `msds_handling_storage` (
    `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `msds_main_id` BIGINT(20) NOT NULL COMMENT 'MSDS主表ID',
    `safe_handling` TEXT COMMENT '安全操作',
    `safe_storage` TEXT COMMENT '安全储存',
    `incompatible_materials` TEXT COMMENT '不相容材料',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_msds_handling_storage_main_id` (`msds_main_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MSDS操作和储存表';

-- ============================================================
-- MSDS暴露控制表
-- ============================================================
CREATE TABLE IF NOT EXISTS `msds_exposure_control` (
    `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `msds_main_id` BIGINT(20) NOT NULL COMMENT 'MSDS主表ID',
    `engineering_controls` TEXT COMMENT '工程控制',
    `ppe_respiratory` TEXT COMMENT '呼吸防护',
    `ppe_skin` TEXT COMMENT '皮肤防护',
    `ppe_eyes` TEXT COMMENT '眼部防护',
    `ppe_body` TEXT COMMENT '身体防护',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_msds_exposure_control_main_id` (`msds_main_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MSDS暴露控制表';

-- ============================================================
-- MSDS物理化学性质表
-- ============================================================
CREATE TABLE IF NOT EXISTS `msds_physical_chemical` (
    `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `msds_main_id` BIGINT(20) NOT NULL COMMENT 'MSDS主表ID',
    `appearance` VARCHAR(200) DEFAULT NULL COMMENT '外观',
    `odor` VARCHAR(200) DEFAULT NULL COMMENT '气味',
    `ph_value` VARCHAR(50) DEFAULT NULL COMMENT 'pH值',
    `melting_point` VARCHAR(50) DEFAULT NULL COMMENT '熔点',
    `boiling_point` VARCHAR(50) DEFAULT NULL COMMENT '沸点',
    `flash_point` VARCHAR(50) DEFAULT NULL COMMENT '闪点',
    `auto_ignition_temp` VARCHAR(50) DEFAULT NULL COMMENT '自燃温度',
    `explosion_limits` VARCHAR(100) DEFAULT NULL COMMENT '爆炸极限',
    `vapor_pressure` VARCHAR(50) DEFAULT NULL COMMENT '蒸气压',
    `density` VARCHAR(50) DEFAULT NULL COMMENT '密度',
    `solubility` TEXT COMMENT '溶解性',
    `viscosity` VARCHAR(50) DEFAULT NULL COMMENT '粘度',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_msds_physical_chemical_main_id` (`msds_main_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MSDS物理化学性质表';

-- ============================================================
-- MSDS稳定性和反应性表
-- ============================================================
CREATE TABLE IF NOT EXISTS `msds_stability_reactivity` (
    `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `msds_main_id` BIGINT(20) NOT NULL COMMENT 'MSDS主表ID',
    `chemical_stability` TEXT COMMENT '化学稳定性',
    `conditions_to_avoid` TEXT COMMENT '应避免的条件',
    `incompatible_materials` TEXT COMMENT '不相容材料',
    `hazardous_decomposition` TEXT COMMENT '危险分解产物',
    `hazardous_polymerization` TEXT COMMENT '危险聚合',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_msds_stability_reactivity_main_id` (`msds_main_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MSDS稳定性和反应性表';

-- ============================================================
-- MSDS毒理学信息表
-- ============================================================
CREATE TABLE IF NOT EXISTS `msds_toxicological` (
    `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `msds_main_id` BIGINT(20) NOT NULL COMMENT 'MSDS主表ID',
    `acute_toxicity` TEXT COMMENT '急性毒性',
    `skin_corrosion` TEXT COMMENT '皮肤腐蚀',
    `eye_irritation` TEXT COMMENT '眼部刺激',
    `sensitization` TEXT COMMENT '致敏性',
    `carcinogenicity` TEXT COMMENT '致癌性',
    `mutagenicity` TEXT COMMENT '致突变性',
    `reproductive_toxicity` TEXT COMMENT '生殖毒性',
    `target_organ_toxicity` TEXT COMMENT '靶器官毒性',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_msds_toxicological_main_id` (`msds_main_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MSDS毒理学信息表';

-- ============================================================
-- MSDS生态学信息表
-- ============================================================
CREATE TABLE IF NOT EXISTS `msds_ecological` (
    `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `msds_main_id` BIGINT(20) NOT NULL COMMENT 'MSDS主表ID',
    `ecotoxicity` TEXT COMMENT '生态毒性',
    `persistence` TEXT COMMENT '持久性',
    `bioaccumulation` TEXT COMMENT '生物累积性',
    `mobility` TEXT COMMENT '迁移性',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_msds_ecological_main_id` (`msds_main_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MSDS生态学信息表';

-- ============================================================
-- MSDS处置信息表
-- ============================================================
CREATE TABLE IF NOT EXISTS `msds_disposal` (
    `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `msds_main_id` BIGINT(20) NOT NULL COMMENT 'MSDS主表ID',
    `waste_treatment` TEXT COMMENT '废物处理',
    `contaminated_packaging` TEXT COMMENT '污染包装',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_msds_disposal_main_id` (`msds_main_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MSDS处置信息表';

-- ============================================================
-- MSDS运输信息表
-- ============================================================
CREATE TABLE IF NOT EXISTS `msds_transportation` (
    `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `msds_main_id` BIGINT(20) NOT NULL COMMENT 'MSDS主表ID',
    `un_number` VARCHAR(50) DEFAULT NULL COMMENT 'UN编号',
    `proper_shipping_name` VARCHAR(200) DEFAULT NULL COMMENT '正确运输名称',
    `transport_class` VARCHAR(50) DEFAULT NULL COMMENT '运输分类',
    `packing_group` VARCHAR(50) DEFAULT NULL COMMENT '包装类别',
    `environmental_hazard` VARCHAR(100) DEFAULT NULL COMMENT '环境危害',
    `special_precautions` TEXT COMMENT '特殊预防措施',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_msds_transportation_main_id` (`msds_main_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MSDS运输信息表';

-- ============================================================
-- MSDS法规信息表
-- ============================================================
CREATE TABLE IF NOT EXISTS `msds_regulatory` (
    `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `msds_main_id` BIGINT(20) NOT NULL COMMENT 'MSDS主表ID',
    `regulation_type` VARCHAR(100) DEFAULT NULL COMMENT '法规类型',
    `regulation_content` TEXT COMMENT '法规内容',
    `compliance_status` VARCHAR(50) DEFAULT NULL COMMENT '合规状态',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_msds_regulatory_main_id` (`msds_main_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MSDS法规信息表';

-- ============================================================
-- MSDS版本历史表
-- ============================================================
CREATE TABLE IF NOT EXISTS `msds_version_history` (
    `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `msds_main_id` BIGINT(20) NOT NULL COMMENT 'MSDS主表ID',
    `version_number` VARCHAR(50) DEFAULT NULL COMMENT '版本号',
    `revision_date` DATE DEFAULT NULL COMMENT '修订日期',
    `revision_reason` TEXT COMMENT '修订原因',
    `file_path` VARCHAR(500) DEFAULT NULL COMMENT '文件路径',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_msds_version_history_main_id` (`msds_main_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MSDS版本历史表';

-- ============================================================
-- MSDS审批工作流表
-- ============================================================
CREATE TABLE IF NOT EXISTS `msds_approval_workflow` (
    `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `msds_main_id` BIGINT(20) NOT NULL COMMENT 'MSDS主表ID',
    `workflow_type` VARCHAR(50) DEFAULT NULL COMMENT '工作流类型',
    `current_step` VARCHAR(50) DEFAULT NULL COMMENT '当前步骤',
    `status` VARCHAR(50) DEFAULT NULL COMMENT '状态',
    `applicant_id` BIGINT(20) DEFAULT NULL COMMENT '申请人ID',
    `approver_id` BIGINT(20) DEFAULT NULL COMMENT '审批人ID',
    `approval_time` DATETIME DEFAULT NULL COMMENT '审批时间',
    `approval_comment` TEXT COMMENT '审批意见',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_msds_approval_workflow_main_id` (`msds_main_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MSDS审批工作流表';

-- ============================================================
-- MSDS GHS危险性表
-- ============================================================
CREATE TABLE IF NOT EXISTS `msds_ghs_hazard` (
    `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `msds_main_id` BIGINT(20) NOT NULL COMMENT 'MSDS主表ID',
    `ghs_code` VARCHAR(50) DEFAULT NULL COMMENT 'GHS代码',
    `ghs_statement` TEXT COMMENT 'GHS说明',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_msds_ghs_hazard_main_id` (`msds_main_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='MSDS GHS危险性表';

-- ============================================================
-- 初始化完成
-- ============================================================
SELECT 'MSDS数据库表结构初始化完成！' AS message;
