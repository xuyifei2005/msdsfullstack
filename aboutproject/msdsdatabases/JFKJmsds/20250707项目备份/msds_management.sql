/*
Navicat MySQL Data Transfer

Source Server         : localhost[8.0.12]3306
Source Server Version : 80012
Source Host           : localhost:3306
Source Database       : msds_management

Target Server Type    : MYSQL
Target Server Version : 80012
File Encoding         : 65001

Date: 2025-07-07 10:32:25
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for chemical_category
-- ----------------------------
DROP TABLE IF EXISTS `chemical_category`;
CREATE TABLE `chemical_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `category_code` varchar(20) NOT NULL COMMENT '分类代码',
  `category_name` varchar(100) NOT NULL COMMENT '分类名称',
  `parent_id` int(11) DEFAULT NULL COMMENT '父分类ID',
  `description` text COMMENT '分类描述',
  `is_active` tinyint(1) DEFAULT '1' COMMENT '是否有效',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `category_code` (`category_code`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_category_code` (`category_code`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='化学品分类表';

-- ----------------------------
-- Records of chemical_category
-- ----------------------------
INSERT INTO `chemical_category` VALUES ('1', 'INORGANIC', '无机化学品', null, '无机化合物', '1', '2025-07-02 06:15:14');
INSERT INTO `chemical_category` VALUES ('2', 'ORGANIC', '有机化学品', null, '有机化合物', '1', '2025-07-02 06:15:14');
INSERT INTO `chemical_category` VALUES ('3', 'POLYMER', '高分子材料', null, '聚合物及其制品', '1', '2025-07-02 06:15:14');
INSERT INTO `chemical_category` VALUES ('4', 'MIXTURE', '混合物', null, '多种化学物质的混合物', '1', '2025-07-02 06:15:14');
INSERT INTO `chemical_category` VALUES ('5', 'PREPARATION', '制剂', null, '含有添加剂的化学制品', '1', '2025-07-02 06:15:14');

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table` (
  `table_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='代码生成业务表';

-- ----------------------------
-- Records of gen_table
-- ----------------------------

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column` (
  `column_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint(20) DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '字典类型',
  `sort` int(11) DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='代码生成业务表字段';

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------

-- ----------------------------
-- Table structure for ghs_hazard_class
-- ----------------------------
DROP TABLE IF EXISTS `ghs_hazard_class`;
CREATE TABLE `ghs_hazard_class` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `class_code` varchar(20) NOT NULL COMMENT '危险类别代码',
  `class_name` varchar(100) NOT NULL COMMENT '危险类别名称',
  `category` varchar(50) DEFAULT NULL COMMENT '危险类别',
  `pictogram` varchar(50) DEFAULT NULL COMMENT '象形图代码',
  `signal_word` varchar(20) DEFAULT NULL COMMENT '警示词',
  `description` text COMMENT '描述',
  `is_active` tinyint(1) DEFAULT '1' COMMENT '是否有效',
  PRIMARY KEY (`id`),
  UNIQUE KEY `class_code` (`class_code`),
  KEY `idx_class_code` (`class_code`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='GHS危险性分类标准表';

-- ----------------------------
-- Records of ghs_hazard_class
-- ----------------------------
INSERT INTO `ghs_hazard_class` VALUES ('1', 'FLAM_LIQ_1', '易燃液体', '类别1', 'GHS02', 'DANGER', '闪点＜23℃且初沸点≤35℃', '1');
INSERT INTO `ghs_hazard_class` VALUES ('2', 'FLAM_LIQ_2', '易燃液体', '类别2', 'GHS02', 'DANGER', '闪点＜23℃且初沸点＞35℃', '1');
INSERT INTO `ghs_hazard_class` VALUES ('3', 'FLAM_LIQ_3', '易燃液体', '类别3', 'GHS02', 'WARNING', '闪点≥23℃且≤60℃', '1');
INSERT INTO `ghs_hazard_class` VALUES ('4', 'ACUTE_TOX_1', '急性毒性', '类别1', 'GHS06', 'DANGER', '经口LD50≤5mg/kg', '1');
INSERT INTO `ghs_hazard_class` VALUES ('5', 'ACUTE_TOX_2', '急性毒性', '类别2', 'GHS06', 'DANGER', '经口LD50＞5且≤50mg/kg', '1');
INSERT INTO `ghs_hazard_class` VALUES ('6', 'ACUTE_TOX_3', '急性毒性', '类别3', 'GHS06', 'DANGER', '经口LD50＞50且≤300mg/kg', '1');
INSERT INTO `ghs_hazard_class` VALUES ('7', 'ACUTE_TOX_4', '急性毒性', '类别4', 'GHS07', 'WARNING', '经口LD50＞300且≤2000mg/kg', '1');
INSERT INTO `ghs_hazard_class` VALUES ('8', 'SKIN_CORR_1', '皮肤腐蚀', '类别1', 'GHS05', 'DANGER', '造成皮肤腐蚀', '1');
INSERT INTO `ghs_hazard_class` VALUES ('9', 'EYE_IRR_2', '眼刺激', '类别2', 'GHS07', 'WARNING', '造成严重眼刺激', '1');
INSERT INTO `ghs_hazard_class` VALUES ('10', 'CARC_1A', '致癌性', '类别1A', 'GHS08', 'DANGER', '已知对人类致癌', '1');
INSERT INTO `ghs_hazard_class` VALUES ('11', 'CARC_1B', '致癌性', '类别1B', 'GHS08', 'DANGER', '可能对人类致癌', '1');
INSERT INTO `ghs_hazard_class` VALUES ('12', 'AQUATIC_1', '水环境危害', '急性类别1', 'GHS09', 'WARNING', '对水生生物毒性极高', '1');

-- ----------------------------
-- Table structure for msds_approval_workflow
-- ----------------------------
DROP TABLE IF EXISTS `msds_approval_workflow`;
CREATE TABLE `msds_approval_workflow` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(20) NOT NULL COMMENT '关联MSDS主表ID',
  `step_no` int(11) NOT NULL COMMENT '审批步骤序号',
  `step_name` varchar(100) NOT NULL COMMENT '审批步骤名称',
  `approver` varchar(100) DEFAULT NULL COMMENT '审批人',
  `approval_status` enum('pending','approved','rejected','skipped') DEFAULT 'pending' COMMENT '审批状态',
  `approval_date` datetime DEFAULT NULL COMMENT '审批时间',
  `approval_comments` text COMMENT '审批意见',
  PRIMARY KEY (`id`),
  KEY `idx_msds_id` (`msds_id`),
  KEY `idx_step_no` (`step_no`),
  KEY `idx_approval_status` (`approval_status`),
  CONSTRAINT `msds_approval_workflow_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='MSDS审批流程表';

-- ----------------------------
-- Records of msds_approval_workflow
-- ----------------------------

-- ----------------------------
-- Table structure for msds_component
-- ----------------------------
DROP TABLE IF EXISTS `msds_component`;
CREATE TABLE `msds_component` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(20) NOT NULL COMMENT '关联MSDS主表ID',
  `component_name` varchar(255) NOT NULL COMMENT '成分名称',
  `component_english_name` varchar(255) DEFAULT NULL COMMENT '成分英文名',
  `component_content` varchar(100) DEFAULT NULL COMMENT '成分含量/浓度',
  `content_min` decimal(10,4) DEFAULT NULL COMMENT '含量下限(%)',
  `content_max` decimal(10,4) DEFAULT NULL COMMENT '含量上限(%)',
  `cas_number` varchar(50) DEFAULT NULL COMMENT 'CAS登记号',
  `ec_number` varchar(50) DEFAULT NULL COMMENT 'EC号',
  `molecular_formula` varchar(100) DEFAULT NULL COMMENT '分子式',
  `molecular_weight` decimal(10,2) DEFAULT NULL COMMENT '分子量',
  `is_hazardous` tinyint(1) DEFAULT '0' COMMENT '是否为危险成分(1:是,0:否)',
  `hazard_level` varchar(50) DEFAULT NULL COMMENT '危险等级',
  `component_function` varchar(100) DEFAULT NULL COMMENT '成分功能',
  PRIMARY KEY (`id`),
  KEY `idx_msds_id` (`msds_id`),
  KEY `idx_component_name` (`component_name`),
  KEY `idx_cas_number` (`cas_number`),
  CONSTRAINT `msds_component_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='成分/组成信息表';

-- ----------------------------
-- Records of msds_component
-- ----------------------------

-- ----------------------------
-- Table structure for msds_disposal
-- ----------------------------
DROP TABLE IF EXISTS `msds_disposal`;
CREATE TABLE `msds_disposal` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(20) NOT NULL COMMENT '关联MSDS主表ID',
  `waste_properties` text COMMENT '废弃物性质',
  `disposal_method` text COMMENT '废弃处置方法',
  `disposal_precautions` text COMMENT '废弃注意事项',
  `disposal_regulations` text COMMENT '废弃处置相关法规',
  `container_disposal` text COMMENT '包装容器的处置',
  `recommended_disposal` text COMMENT '推荐的处置方法',
  `prohibited_disposal` text COMMENT '禁止的处置方法',
  `neutralization_method` text COMMENT '中和处理方法',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  CONSTRAINT `msds_disposal_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='废弃处置表';

-- ----------------------------
-- Records of msds_disposal
-- ----------------------------

-- ----------------------------
-- Table structure for msds_ecological
-- ----------------------------
DROP TABLE IF EXISTS `msds_ecological`;
CREATE TABLE `msds_ecological` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(20) NOT NULL COMMENT '关联MSDS主表ID',
  `ecological_toxicity` text COMMENT '生态毒性',
  `fish_toxicity` varchar(100) DEFAULT NULL COMMENT '鱼类毒性',
  `invertebrate_toxicity` varchar(100) DEFAULT NULL COMMENT '无脊椎动物毒性',
  `algae_toxicity` varchar(100) DEFAULT NULL COMMENT '藻类毒性',
  `bacteria_toxicity` varchar(100) DEFAULT NULL COMMENT '细菌毒性',
  `biodegradability` text COMMENT '生物降解性',
  `biodegradation_rate` varchar(50) DEFAULT NULL COMMENT '生物降解速率',
  `non_biodegradability` text COMMENT '非生物降解性',
  `photodegradation` text COMMENT '光降解',
  `hydrolysis` text COMMENT '水解',
  `bioaccumulation` text COMMENT '生物富集或生物积累性',
  `bioconcentration_factor` varchar(50) DEFAULT NULL COMMENT '生物富集因子',
  `mobility_in_soil` text COMMENT '土壤中迁移性',
  `other_environmental_effects` text COMMENT '其它有害作用',
  `ozone_depletion_potential` varchar(50) DEFAULT NULL COMMENT '臭氧消耗潜能值',
  `global_warming_potential` varchar(50) DEFAULT NULL COMMENT '全球变暖潜能值',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  CONSTRAINT `msds_ecological_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='生态学资料表';

-- ----------------------------
-- Records of msds_ecological
-- ----------------------------

-- ----------------------------
-- Table structure for msds_exposure_control
-- ----------------------------
DROP TABLE IF EXISTS `msds_exposure_control`;
CREATE TABLE `msds_exposure_control` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(20) NOT NULL COMMENT '关联MSDS主表ID',
  `occupational_exposure_limit` text COMMENT '职业接触限值',
  `china_mac` varchar(50) DEFAULT NULL COMMENT '中国MAC值(mg/m³)',
  `usa_tlv_twa` varchar(50) DEFAULT NULL COMMENT '美国TLV-TWA值(mg/m³)',
  `usa_tlv_stel` varchar(50) DEFAULT NULL COMMENT '美国TLV-STEL值(mg/m³)',
  `former_soviet_mac` varchar(50) DEFAULT NULL COMMENT '前苏联MAC值(mg/m³)',
  `tlv_tn` varchar(50) DEFAULT NULL COMMENT 'TLV-TN值(mg/m³)',
  `tlv_wn` varchar(50) DEFAULT NULL COMMENT 'TLV-WN值(mg/m³)',
  `monitoring_method` text COMMENT '监测方法',
  `engineering_controls` text COMMENT '工程控制措施',
  `respiratory_protection` text COMMENT '呼吸系统防护',
  `eye_protection` text COMMENT '眼睛防护',
  `body_protection` text COMMENT '身体防护',
  `hand_protection` text COMMENT '手部防护',
  `other_protection` text COMMENT '其他防护措施',
  `hygiene_measures` text COMMENT '卫生措施',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  CONSTRAINT `msds_exposure_control_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='接触控制/个体防护表';

-- ----------------------------
-- Records of msds_exposure_control
-- ----------------------------

-- ----------------------------
-- Table structure for msds_fire_fighting
-- ----------------------------
DROP TABLE IF EXISTS `msds_fire_fighting`;
CREATE TABLE `msds_fire_fighting` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(20) NOT NULL COMMENT '关联MSDS主表ID',
  `hazard_characteristics` text COMMENT '危险特性',
  `harmful_combustion_products` text COMMENT '有害燃烧产物',
  `suitable_extinguishing_media` text COMMENT '适宜的灭火介质',
  `unsuitable_extinguishing_media` text COMMENT '不适宜的灭火介质',
  `fire_fighting_equipment` text COMMENT '消防设备和防护装备',
  `fire_fighting_procedures` text COMMENT '特殊消防程序',
  `flash_point` varchar(50) DEFAULT NULL COMMENT '闪点',
  `autoignition_temperature` varchar(50) DEFAULT NULL COMMENT '自燃温度',
  `flammability_limits` text COMMENT '燃烧性/爆炸极限',
  `fire_risk_classification` varchar(50) DEFAULT NULL COMMENT '建规火险分级',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  CONSTRAINT `msds_fire_fighting_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='消防措施表';

-- ----------------------------
-- Records of msds_fire_fighting
-- ----------------------------

-- ----------------------------
-- Table structure for msds_first_aid
-- ----------------------------
DROP TABLE IF EXISTS `msds_first_aid`;
CREATE TABLE `msds_first_aid` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(20) NOT NULL COMMENT '关联MSDS主表ID',
  `skin_contact` text COMMENT '皮肤接触处理措施',
  `eye_contact` text COMMENT '眼睛接触处理措施',
  `inhalation` text COMMENT '吸入处理措施',
  `ingestion` text COMMENT '食入处理措施',
  `general_notes` text COMMENT '一般注意事项',
  `symptoms_effects` text COMMENT '可能出现的症状和健康影响',
  `immediate_medical_attention` text COMMENT '需要立即就医的情况',
  `antidote_treatment` text COMMENT '解毒剂及治疗方法',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  CONSTRAINT `msds_first_aid_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='急救措施表';

-- ----------------------------
-- Records of msds_first_aid
-- ----------------------------

-- ----------------------------
-- Table structure for msds_ghs_hazard
-- ----------------------------
DROP TABLE IF EXISTS `msds_ghs_hazard`;
CREATE TABLE `msds_ghs_hazard` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(20) NOT NULL COMMENT '关联MSDS主表ID',
  `ghs_class_id` int(11) NOT NULL COMMENT '关联GHS危险类别ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_ghs` (`msds_id`,`ghs_class_id`),
  KEY `ghs_class_id` (`ghs_class_id`),
  CONSTRAINT `msds_ghs_hazard_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE,
  CONSTRAINT `msds_ghs_hazard_ibfk_2` FOREIGN KEY (`ghs_class_id`) REFERENCES `ghs_hazard_class` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='MSDS-GHS危险性分类关联表';

-- ----------------------------
-- Records of msds_ghs_hazard
-- ----------------------------

-- ----------------------------
-- Table structure for msds_handling_storage
-- ----------------------------
DROP TABLE IF EXISTS `msds_handling_storage`;
CREATE TABLE `msds_handling_storage` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(20) NOT NULL COMMENT '关联MSDS主表ID',
  `handling_precautions` text COMMENT '操作注意事项',
  `storage_precautions` text COMMENT '储存注意事项',
  `optimal_temperature` varchar(50) DEFAULT NULL COMMENT '最佳储存温度',
  `temperature_range` varchar(50) DEFAULT NULL COMMENT '储存温度范围',
  `humidity_requirements` varchar(50) DEFAULT NULL COMMENT '湿度要求',
  `storage_container` text COMMENT '储存容器要求',
  `incompatible_materials` text COMMENT '不相容的物质',
  `storage_area_requirements` text COMMENT '储存区域要求',
  `shelf_life` varchar(50) DEFAULT NULL COMMENT '保质期',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  CONSTRAINT `msds_handling_storage_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='操作处置与储存表';

-- ----------------------------
-- Records of msds_handling_storage
-- ----------------------------

-- ----------------------------
-- Table structure for msds_hazard
-- ----------------------------
DROP TABLE IF EXISTS `msds_hazard`;
CREATE TABLE `msds_hazard` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(20) NOT NULL COMMENT '关联MSDS主表ID',
  `emergency_overview` text COMMENT '紧急情况概述',
  `physical_state` varchar(50) DEFAULT NULL COMMENT '物理状态',
  `odor` varchar(100) DEFAULT NULL COMMENT '气味',
  `color` varchar(50) DEFAULT NULL COMMENT '颜色',
  `warning_word` enum('danger','warning') DEFAULT NULL COMMENT '警示词(danger:危险,warning:警告)',
  `hazard_category` varchar(255) DEFAULT NULL COMMENT '危险性类别',
  `exposure_routes` varchar(255) DEFAULT NULL COMMENT '侵入途径',
  `health_hazards` text COMMENT '健康危害',
  `environmental_hazards` text COMMENT '环境危害',
  `fire_explosion_hazards` text COMMENT '燃爆危险',
  `hazard_description` text COMMENT '危险性说明',
  `prevention_measures` text COMMENT '预防措施',
  `response_measures` text COMMENT '响应措施',
  `storage_measures` text COMMENT '储存措施',
  `disposal_measures` text COMMENT '废弃处置措施',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  CONSTRAINT `msds_hazard_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='危险性概述表';

-- ----------------------------
-- Records of msds_hazard
-- ----------------------------

-- ----------------------------
-- Table structure for msds_leak_response
-- ----------------------------
DROP TABLE IF EXISTS `msds_leak_response`;
CREATE TABLE `msds_leak_response` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(20) NOT NULL COMMENT '关联MSDS主表ID',
  `personal_precautions` text COMMENT '个人防护措施',
  `environmental_precautions` text COMMENT '环境保护措施',
  `containment_cleanup` text COMMENT '泄漏化学品的收容、清除方法',
  `emergency_procedures` text COMMENT '应急处理程序',
  `elimination_methods` text COMMENT '消除方法',
  `equipment_materials` text COMMENT '清理时使用的器材',
  `prevent_secondary_hazards` text COMMENT '防止发生次生危害的预防措施',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  CONSTRAINT `msds_leak_response_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='泄漏应急处理表';

-- ----------------------------
-- Records of msds_leak_response
-- ----------------------------

-- ----------------------------
-- Table structure for msds_main
-- ----------------------------
DROP TABLE IF EXISTS `msds_main`;
CREATE TABLE `msds_main` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'MSDS唯一标识',
  `cas_number` varchar(50) NOT NULL COMMENT 'CAS登记号',
  `msds_code` varchar(50) NOT NULL COMMENT 'MSDS编号',
  `product_name` varchar(255) NOT NULL COMMENT '化学品中文名',
  `product_alias` varchar(255) DEFAULT NULL COMMENT '化学品别名',
  `product_english_name` varchar(255) DEFAULT NULL COMMENT '化学品英文名',
  `category_id` int(11) DEFAULT NULL COMMENT '化学品分类ID',
  `company_name` varchar(255) NOT NULL COMMENT '企业名称',
  `company_address` text COMMENT '企业地址',
  `zip_code` char(10) DEFAULT NULL COMMENT '邮编',
  `fax_number` varchar(50) DEFAULT NULL COMMENT '传真号码',
  `contact_phone` varchar(50) NOT NULL COMMENT '联系电话',
  `email` varchar(100) DEFAULT NULL COMMENT '电子邮件地址',
  `emergency_phone` varchar(50) DEFAULT NULL COMMENT '企业应急电话',
  `recommended_usage` text COMMENT '产品推荐用途',
  `restricted_usage` text COMMENT '产品限制用途',
  `version` varchar(20) DEFAULT '1.0' COMMENT 'MSDS版本号',
  `revision_date` date DEFAULT NULL COMMENT '修订日期',
  `effective_date` date DEFAULT NULL COMMENT '生效日期',
  `status` enum('draft','pending','approved','archived') DEFAULT 'draft' COMMENT '状态',
  `approver` varchar(100) DEFAULT NULL COMMENT '审批人',
  `approval_date` date DEFAULT NULL COMMENT '审批日期',
  `is_active` tinyint(1) DEFAULT '1' COMMENT '是否有效(1:有效,0:无效)',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `created_by` varchar(100) DEFAULT NULL COMMENT '创建人',
  `updated_by` varchar(100) DEFAULT NULL COMMENT '更新人',
  `remark` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `cas_number` (`cas_number`),
  UNIQUE KEY `msds_code` (`msds_code`),
  KEY `category_id` (`category_id`),
  KEY `idx_msds_code` (`msds_code`),
  KEY `idx_product_name` (`product_name`),
  KEY `idx_company_name` (`company_name`),
  KEY `idx_status` (`status`),
  KEY `idx_create_time` (`create_time`),
  CONSTRAINT `msds_main_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `chemical_category` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='MSDS主信息表';

-- ----------------------------
-- Records of msds_main
-- ----------------------------
INSERT INTO `msds_main` VALUES ('1', '115-29-7', 'MSDS#1597', '(1,4,5,6,7,7-六氯-8,9,10-三降 冰片-5-烯-2,3-亚基双亚甲基)亚 硫酸酯 ', '1,2,3,4,7,7-六氯双环[2,2,1] 庚烯-(2)-双羟甲基-5,6-亚硫 酸酯；硫丹 ', ',2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedim  ethyl ', null, '2323', '', null, '供应商Email：', 'ghbghggf', '', '', null, null, null, null, null, 'draft', null, null, '1', '2025-07-02 16:37:25', '2025-07-02 16:43:40', null, null, null);
INSERT INTO `msds_main` VALUES ('2', '115-31-1', 'MSDS#2743', '(1R,2R,4R)-冰片-2-硫氰基醋酸酯 中文别名： 敌稻瘟', '敌稻瘟', '1,7,7-trimethylbicyclo(2,2,1)h', null, '名称： 供应商地址：', '供应商电话： 供应商应急电话：', null, '供应商Email：', '供应商应急电话：', '第二部分：危险性概述', '供应商传真： 供应商Email：', null, null, null, null, null, 'draft', null, null, '1', '2025-07-02 16:44:54', '2025-07-02 16:44:54', null, null, null);

-- ----------------------------
-- Table structure for msds_physical_chemical
-- ----------------------------
DROP TABLE IF EXISTS `msds_physical_chemical`;
CREATE TABLE `msds_physical_chemical` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(20) NOT NULL COMMENT '关联MSDS主表ID',
  `appearance` varchar(255) DEFAULT NULL COMMENT '外观与性状',
  `odor` varchar(100) DEFAULT NULL COMMENT '气味',
  `odor_threshold` varchar(50) DEFAULT NULL COMMENT '气味阈值',
  `melting_point` varchar(50) DEFAULT NULL COMMENT '熔点(℃)',
  `boiling_point` varchar(50) DEFAULT NULL COMMENT '沸点(℃)',
  `relative_density` varchar(50) DEFAULT NULL COMMENT '相对密度(水=1)',
  `vapor_density` varchar(50) DEFAULT NULL COMMENT '蒸气密度(空气=1)',
  `vapor_pressure` varchar(50) DEFAULT NULL COMMENT '蒸气压(kPa)',
  `vapor_pressure_temp` varchar(20) DEFAULT NULL COMMENT '蒸气压测定温度(℃)',
  `solubility` text COMMENT '溶解性',
  `water_solubility` varchar(100) DEFAULT NULL COMMENT '水中溶解度',
  `pH_value` varchar(20) DEFAULT NULL COMMENT 'pH值',
  `ph_concentration` varchar(50) DEFAULT NULL COMMENT 'pH值浓度条件',
  `flash_point` varchar(50) DEFAULT NULL COMMENT '闪点(℃)',
  `ignition_temperature` varchar(50) DEFAULT NULL COMMENT '引燃温度(℃)',
  `explosive_limit_lower` varchar(50) DEFAULT NULL COMMENT '爆炸下限(%)',
  `explosive_limit_upper` varchar(50) DEFAULT NULL COMMENT '爆炸上限(%)',
  `viscosity` varchar(50) DEFAULT NULL COMMENT '粘度',
  `partition_coefficient` varchar(50) DEFAULT NULL COMMENT '分配系数(正辛醇/水)',
  `decomposition_temperature` varchar(50) DEFAULT NULL COMMENT '分解温度(℃)',
  `molecular_formula` varchar(100) DEFAULT NULL COMMENT '分子式',
  `main_components` text COMMENT '主要成分',
  `critical_temperature` varchar(50) DEFAULT NULL COMMENT '临界温度(℃)',
  `autoignition_temperature` varchar(50) DEFAULT NULL COMMENT '自燃温度',
  `flammability` varchar(50) DEFAULT NULL COMMENT '燃烧性',
  `molecular_weight` varchar(50) DEFAULT NULL COMMENT '分子量',
  `heat_of_combustion` varchar(50) DEFAULT NULL COMMENT '燃烧热(kJ/mol)',
  `critical_pressure` varchar(50) DEFAULT NULL COMMENT '临界压力(MPa)',
  `main_usage` text COMMENT '主要用途',
  `other_properties` text COMMENT '其它理化性质',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  CONSTRAINT `msds_physical_chemical_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='理化特性表';

-- ----------------------------
-- Records of msds_physical_chemical
-- ----------------------------

-- ----------------------------
-- Table structure for msds_regulatory
-- ----------------------------
DROP TABLE IF EXISTS `msds_regulatory`;
CREATE TABLE `msds_regulatory` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(20) NOT NULL COMMENT '关联MSDS主表ID',
  `regulatory_info` text COMMENT '法规信息综述',
  `domestic_regulations` text COMMENT '国内法规',
  `international_regulations` text COMMENT '国际法规',
  `china_dangerous_chemicals` tinyint(1) DEFAULT '0' COMMENT '中国危险化学品目录(1:是,0:否)',
  `china_controlled_chemicals` tinyint(1) DEFAULT '0' COMMENT '中国管制化学品(1:是,0:否)',
  `reach_registration` text COMMENT 'REACH注册情况',
  `tsca_inventory` tinyint(1) DEFAULT '0' COMMENT 'TSCA清单(1:在列,0:不在列)',
  `einecs_number` varchar(50) DEFAULT NULL COMMENT 'EINECS号',
  `prohibited_restricted` text COMMENT '禁用/限用情况',
  `special_provisions` text COMMENT '特殊规定',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  CONSTRAINT `msds_regulatory_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='法规信息表';

-- ----------------------------
-- Records of msds_regulatory
-- ----------------------------

-- ----------------------------
-- Table structure for msds_stability_reactivity
-- ----------------------------
DROP TABLE IF EXISTS `msds_stability_reactivity`;
CREATE TABLE `msds_stability_reactivity` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(20) NOT NULL COMMENT '关联MSDS主表ID',
  `stability` text COMMENT '稳定性',
  `reactivity` text COMMENT '反应性',
  `incompatible_substances` text COMMENT '禁配物',
  `conditions_to_avoid` text COMMENT '避免接触的条件',
  `hazardous_reactions` text COMMENT '可能的危险反应',
  `polymerization_hazard` text COMMENT '聚合危害',
  `polymerization_conditions` text COMMENT '聚合反应条件',
  `decomposition_products` text COMMENT '分解产物',
  `decomposition_conditions` text COMMENT '分解条件',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  CONSTRAINT `msds_stability_reactivity_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='稳定性和反应性表';

-- ----------------------------
-- Records of msds_stability_reactivity
-- ----------------------------

-- ----------------------------
-- Table structure for msds_toxicological
-- ----------------------------
DROP TABLE IF EXISTS `msds_toxicological`;
CREATE TABLE `msds_toxicological` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(20) NOT NULL COMMENT '关联MSDS主表ID',
  `acute_toxicity` text COMMENT '急性毒性',
  `ld50_oral` varchar(100) DEFAULT NULL COMMENT 'LD50(经口,大鼠)',
  `ld50_dermal` varchar(100) DEFAULT NULL COMMENT 'LD50(经皮,兔)',
  `lc50_inhalation` varchar(100) DEFAULT NULL COMMENT 'LC50(吸入,大鼠)',
  `subacute_chronic` text COMMENT '亚急性和慢性毒性',
  `skin_irritation` text COMMENT '皮肤刺激性',
  `eye_irritation` text COMMENT '眼睛刺激性',
  `respiratory_irritation` text COMMENT '呼吸道刺激性',
  `sensitization` text COMMENT '致敏性',
  `mutagenicity` text COMMENT '致突变性',
  `teratogenicity` text COMMENT '致畸性',
  `reproductive_toxicity` text COMMENT '生殖毒性',
  `carcinogenicity` text COMMENT '致癌性',
  `carcinogen_classification` text COMMENT '致癌物分类',
  `specific_target_organ` text COMMENT '特定目标器官毒性',
  `aspiration_hazard` text COMMENT '吸入危害',
  `other_toxicity` text COMMENT '其他毒理学资料',
  `rtecs` varchar(100) DEFAULT NULL COMMENT 'RTECS编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  CONSTRAINT `msds_toxicological_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='毒理学资料表';

-- ----------------------------
-- Records of msds_toxicological
-- ----------------------------

-- ----------------------------
-- Table structure for msds_transportation
-- ----------------------------
DROP TABLE IF EXISTS `msds_transportation`;
CREATE TABLE `msds_transportation` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(20) NOT NULL COMMENT '关联MSDS主表ID',
  `dangerous_goods_number` varchar(50) DEFAULT NULL COMMENT '危险货物编号',
  `un_number` varchar(50) DEFAULT NULL COMMENT 'UN编号',
  `proper_shipping_name` varchar(255) DEFAULT NULL COMMENT '正确运输名称',
  `transport_hazard_class` varchar(50) DEFAULT NULL COMMENT '运输危险类别',
  `packing_group` varchar(10) DEFAULT NULL COMMENT '包装类别',
  `packaging_marks` text COMMENT '包装标志',
  `packaging_method` text COMMENT '包装方法',
  `marine_pollutant` tinyint(1) DEFAULT '0' COMMENT '海洋污染物(1:是,0:否)',
  `transport_in_bulk` text COMMENT '散装运输要求',
  `transportation_precautions` text COMMENT '运输注意事项',
  `emergency_response_guide` varchar(50) DEFAULT NULL COMMENT '应急响应指南编号',
  `imdg_rule_page` varchar(50) DEFAULT NULL COMMENT 'IMDG规则页码',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  KEY `idx_un_number` (`un_number`),
  KEY `idx_dangerous_goods_number` (`dangerous_goods_number`),
  CONSTRAINT `msds_transportation_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='运输信息表';

-- ----------------------------
-- Records of msds_transportation
-- ----------------------------

-- ----------------------------
-- Table structure for msds_version_history
-- ----------------------------
DROP TABLE IF EXISTS `msds_version_history`;
CREATE TABLE `msds_version_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(20) NOT NULL COMMENT '关联MSDS主表ID',
  `version` varchar(20) NOT NULL COMMENT '版本号',
  `change_description` text COMMENT '变更描述',
  `change_reason` text COMMENT '变更原因',
  `changed_sections` text COMMENT '变更章节',
  `change_date` date DEFAULT NULL COMMENT '变更日期',
  `changed_by` varchar(100) DEFAULT NULL COMMENT '变更人',
  `approved_by` varchar(100) DEFAULT NULL COMMENT '审批人',
  `approval_date` date DEFAULT NULL COMMENT '审批日期',
  PRIMARY KEY (`id`),
  KEY `idx_msds_id` (`msds_id`),
  KEY `idx_version` (`version`),
  KEY `idx_change_date` (`change_date`),
  CONSTRAINT `msds_version_history_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='MSDS版本历史表';

-- ----------------------------
-- Records of msds_version_history
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Blob类型的触发器表';

-- ----------------------------
-- Records of qrtz_blob_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars` (
  `sched_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`,`calendar_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='日历信息表';

-- ----------------------------
-- Records of qrtz_calendars
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Cron类型的触发器表';

-- ----------------------------
-- Records of qrtz_cron_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint(13) NOT NULL COMMENT '触发的时间',
  `sched_time` bigint(13) NOT NULL COMMENT '定时器制定的时间',
  `priority` int(11) NOT NULL COMMENT '优先级',
  `state` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`,`entry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='已触发的触发器表';

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details` (
  `sched_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`job_name`,`job_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='任务详细信息表';

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks` (
  `sched_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`,`lock_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='存储的悲观锁信息表';

-- ----------------------------
-- Records of qrtz_locks
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps` (
  `sched_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`,`trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='暂停的触发器表';

-- ----------------------------
-- Records of qrtz_paused_trigger_grps
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state` (
  `sched_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint(13) NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint(13) NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`,`instance_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='调度器状态表';

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint(7) NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint(12) NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint(10) NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='简单触发器的信息表';

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int(11) DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int(11) DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint(20) DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint(20) DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='同步机制的行锁表';

-- ----------------------------
-- Records of qrtz_simprop_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers` (
  `sched_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint(13) DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint(13) DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int(11) DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint(13) NOT NULL COMMENT '开始时间',
  `end_time` bigint(13) DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint(2) DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`),
  KEY `sched_name` (`sched_name`,`job_name`,`job_group`),
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='触发器详细信息表';

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for system_log
-- ----------------------------
DROP TABLE IF EXISTS `system_log`;
CREATE TABLE `system_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `table_name` varchar(50) NOT NULL COMMENT '表名',
  `record_id` bigint(20) NOT NULL COMMENT '记录ID',
  `operation_type` enum('INSERT','UPDATE','DELETE') NOT NULL COMMENT '操作类型',
  `old_values` json DEFAULT NULL COMMENT '修改前的值',
  `new_values` json DEFAULT NULL COMMENT '修改后的值',
  `operator` varchar(100) DEFAULT NULL COMMENT '操作人',
  `operation_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  `ip_address` varchar(50) DEFAULT NULL COMMENT 'IP地址',
  `user_agent` text COMMENT '用户代理',
  PRIMARY KEY (`id`),
  KEY `idx_table_record` (`table_name`,`record_id`),
  KEY `idx_operation_time` (`operation_time`),
  KEY `idx_operator` (`operator`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统操作日志表';

-- ----------------------------
-- Records of system_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config` (
  `config_id` int(5) NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) COLLATE utf8mb4_unicode_ci DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='参数配置表';

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES ('1', '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2025-06-24 19:45:12', '', null, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES ('2', '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2025-06-24 19:45:12', '', null, '初始化密码 123456');
INSERT INTO `sys_config` VALUES ('3', '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2025-06-24 19:45:12', '', null, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES ('4', '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2025-06-24 19:45:12', '', null, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES ('5', '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2025-06-24 19:45:12', '', null, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES ('6', '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2025-06-24 19:45:12', '', null, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept` (
  `dept_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint(20) DEFAULT '0' COMMENT '父部门id',
  `ancestors` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '部门名称',
  `order_num` int(4) DEFAULT '0' COMMENT '显示顺序',
  `leader` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮箱',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=200 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='部门表';

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES ('100', '0', '0', '若依科技', '0', '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-24 19:45:03', '', null);
INSERT INTO `sys_dept` VALUES ('101', '100', '0,100', '深圳总公司', '1', '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-24 19:45:03', '', null);
INSERT INTO `sys_dept` VALUES ('102', '100', '0,100', '长沙分公司', '2', '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-24 19:45:03', '', null);
INSERT INTO `sys_dept` VALUES ('103', '101', '0,100,101', '研发部门', '1', '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-24 19:45:03', '', null);
INSERT INTO `sys_dept` VALUES ('104', '101', '0,100,101', '市场部门', '2', '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-24 19:45:03', '', null);
INSERT INTO `sys_dept` VALUES ('105', '101', '0,100,101', '测试部门', '3', '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-24 19:45:03', '', null);
INSERT INTO `sys_dept` VALUES ('106', '101', '0,100,101', '财务部门', '4', '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-24 19:45:03', '', null);
INSERT INTO `sys_dept` VALUES ('107', '101', '0,100,101', '运维部门', '5', '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-24 19:45:03', '', null);
INSERT INTO `sys_dept` VALUES ('108', '102', '0,100,102', '市场部门', '1', '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-24 19:45:03', '', null);
INSERT INTO `sys_dept` VALUES ('109', '102', '0,100,102', '财务部门', '2', '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-24 19:45:03', '', null);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data` (
  `dict_code` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int(4) DEFAULT '0' COMMENT '字典排序',
  `dict_label` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) COLLATE utf8mb4_unicode_ci DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='字典数据表';

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES ('1', '1', '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2025-06-24 19:45:11', '', null, '性别男');
INSERT INTO `sys_dict_data` VALUES ('2', '2', '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2025-06-24 19:45:11', '', null, '性别女');
INSERT INTO `sys_dict_data` VALUES ('3', '3', '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2025-06-24 19:45:11', '', null, '性别未知');
INSERT INTO `sys_dict_data` VALUES ('4', '1', '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2025-06-24 19:45:11', '', null, '显示菜单');
INSERT INTO `sys_dict_data` VALUES ('5', '2', '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2025-06-24 19:45:11', '', null, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES ('6', '1', '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2025-06-24 19:45:11', '', null, '正常状态');
INSERT INTO `sys_dict_data` VALUES ('7', '2', '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2025-06-24 19:45:11', '', null, '停用状态');
INSERT INTO `sys_dict_data` VALUES ('8', '1', '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2025-06-24 19:45:11', '', null, '正常状态');
INSERT INTO `sys_dict_data` VALUES ('9', '2', '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2025-06-24 19:45:11', '', null, '停用状态');
INSERT INTO `sys_dict_data` VALUES ('10', '1', '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2025-06-24 19:45:11', '', null, '默认分组');
INSERT INTO `sys_dict_data` VALUES ('11', '2', '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2025-06-24 19:45:11', '', null, '系统分组');
INSERT INTO `sys_dict_data` VALUES ('12', '1', '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2025-06-24 19:45:11', '', null, '系统默认是');
INSERT INTO `sys_dict_data` VALUES ('13', '2', '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2025-06-24 19:45:11', '', null, '系统默认否');
INSERT INTO `sys_dict_data` VALUES ('14', '1', '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2025-06-24 19:45:11', '', null, '通知');
INSERT INTO `sys_dict_data` VALUES ('15', '2', '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2025-06-24 19:45:11', '', null, '公告');
INSERT INTO `sys_dict_data` VALUES ('16', '1', '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2025-06-24 19:45:11', '', null, '正常状态');
INSERT INTO `sys_dict_data` VALUES ('17', '2', '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2025-06-24 19:45:11', '', null, '关闭状态');
INSERT INTO `sys_dict_data` VALUES ('18', '99', '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-06-24 19:45:11', '', null, '其他操作');
INSERT INTO `sys_dict_data` VALUES ('19', '1', '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-06-24 19:45:11', '', null, '新增操作');
INSERT INTO `sys_dict_data` VALUES ('20', '2', '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-06-24 19:45:11', '', null, '修改操作');
INSERT INTO `sys_dict_data` VALUES ('21', '3', '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-06-24 19:45:11', '', null, '删除操作');
INSERT INTO `sys_dict_data` VALUES ('22', '4', '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2025-06-24 19:45:11', '', null, '授权操作');
INSERT INTO `sys_dict_data` VALUES ('23', '5', '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-06-24 19:45:11', '', null, '导出操作');
INSERT INTO `sys_dict_data` VALUES ('24', '6', '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-06-24 19:45:11', '', null, '导入操作');
INSERT INTO `sys_dict_data` VALUES ('25', '7', '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-06-24 19:45:11', '', null, '强退操作');
INSERT INTO `sys_dict_data` VALUES ('26', '8', '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-06-24 19:45:11', '', null, '生成操作');
INSERT INTO `sys_dict_data` VALUES ('27', '9', '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-06-24 19:45:11', '', null, '清空操作');
INSERT INTO `sys_dict_data` VALUES ('28', '1', '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2025-06-24 19:45:11', '', null, '正常状态');
INSERT INTO `sys_dict_data` VALUES ('29', '2', '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2025-06-24 19:45:11', '', null, '停用状态');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type` (
  `dict_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '字典类型',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`),
  UNIQUE KEY `dict_type` (`dict_type`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='字典类型表';

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES ('1', '用户性别', 'sys_user_sex', '0', 'admin', '2025-06-24 19:45:11', '', null, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES ('2', '菜单状态', 'sys_show_hide', '0', 'admin', '2025-06-24 19:45:11', '', null, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES ('3', '系统开关', 'sys_normal_disable', '0', 'admin', '2025-06-24 19:45:11', '', null, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES ('4', '任务状态', 'sys_job_status', '0', 'admin', '2025-06-24 19:45:11', '', null, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES ('5', '任务分组', 'sys_job_group', '0', 'admin', '2025-06-24 19:45:11', '', null, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES ('6', '系统是否', 'sys_yes_no', '0', 'admin', '2025-06-24 19:45:11', '', null, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES ('7', '通知类型', 'sys_notice_type', '0', 'admin', '2025-06-24 19:45:11', '', null, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES ('8', '通知状态', 'sys_notice_status', '0', 'admin', '2025-06-24 19:45:11', '', null, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES ('9', '操作类型', 'sys_oper_type', '0', 'admin', '2025-06-24 19:45:11', '', null, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES ('10', '系统状态', 'sys_common_status', '0', 'admin', '2025-06-24 19:45:11', '', null, '登录状态列表');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job` (
  `job_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`,`job_name`,`job_group`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='定时任务调度表';

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES ('1', '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2025-06-24 19:45:13', '', null, '');
INSERT INTO `sys_job` VALUES ('2', '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2025-06-24 19:45:13', '', null, '');
INSERT INTO `sys_job` VALUES ('3', '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2025-06-24 19:45:13', '', null, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log` (
  `job_log_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '日志信息',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '异常信息',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='定时任务调度日志表';

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor` (
  `info_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '操作系统',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '提示消息',
  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`),
  KEY `idx_sys_logininfor_s` (`status`),
  KEY `idx_sys_logininfor_lt` (`login_time`)
) ENGINE=InnoDB AUTO_INCREMENT=118 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统访问记录';

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES ('100', 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码已失效', '2025-06-28 19:43:06');
INSERT INTO `sys_logininfor` VALUES ('101', 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-28 19:46:15');
INSERT INTO `sys_logininfor` VALUES ('102', 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-29 10:05:41');
INSERT INTO `sys_logininfor` VALUES ('103', 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-30 22:44:12');
INSERT INTO `sys_logininfor` VALUES ('104', 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-01 19:58:35');
INSERT INTO `sys_logininfor` VALUES ('105', 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-01 22:29:55');
INSERT INTO `sys_logininfor` VALUES ('106', 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-07-02 01:58:57');
INSERT INTO `sys_logininfor` VALUES ('107', 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-02 01:59:09');
INSERT INTO `sys_logininfor` VALUES ('108', 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-02 09:50:09');
INSERT INTO `sys_logininfor` VALUES ('109', 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-02 10:34:15');
INSERT INTO `sys_logininfor` VALUES ('110', 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-02 13:57:09');
INSERT INTO `sys_logininfor` VALUES ('111', 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-02 15:59:57');
INSERT INTO `sys_logininfor` VALUES ('112', 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-02 16:36:39');
INSERT INTO `sys_logininfor` VALUES ('113', 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-07-02 17:04:12');
INSERT INTO `sys_logininfor` VALUES ('114', 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-02 17:05:38');
INSERT INTO `sys_logininfor` VALUES ('115', 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-07-02 17:11:30');
INSERT INTO `sys_logininfor` VALUES ('116', 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-02 17:11:49');
INSERT INTO `sys_logininfor` VALUES ('117', 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-02 20:10:56');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `menu_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint(20) DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int(4) DEFAULT '0' COMMENT '显示顺序',
  `path` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '路由名称',
  `is_frame` int(1) DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `is_cache` int(1) DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2008 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='菜单权限表';

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES ('1', '系统管理', '0', '10', 'system', null, '', '', '1', '0', 'M', '0', '0', '', 'SettingOutlined', 'admin', '2025-06-24 19:45:06', 'admin', '2025-07-02 17:07:51', '系统管理目录');
INSERT INTO `sys_menu` VALUES ('2', '系统监控', '0', '11', 'monitor', null, '', '', '1', '0', 'M', '0', '0', '', 'DashboardOutlined', 'admin', '2025-06-24 19:45:06', 'admin', '2025-07-02 17:08:03', '系统监控目录');
INSERT INTO `sys_menu` VALUES ('3', '系统工具', '0', '12', 'tool', null, '', '', '1', '0', 'M', '0', '0', '', 'ToolOutlined', 'admin', '2025-06-24 19:45:06', 'admin', '2025-07-02 17:08:31', '系统工具目录');
INSERT INTO `sys_menu` VALUES ('4', '若依官网', '0', '4', 'http://ruoyi.vip', null, '', '', '1', '0', 'M', '1', '1', '', 'LinkOutlined', 'admin', '2025-06-24 19:45:06', 'admin', '2025-07-02 17:06:23', '若依官网地址');
INSERT INTO `sys_menu` VALUES ('5', '控制台', '0', '0', 'dashboard', null, '', '', '1', '0', 'M', '1', '0', '', 'AppstoreOutlined', 'admin', '2025-06-24 19:45:06', '', null, '控制台');
INSERT INTO `sys_menu` VALUES ('6', '个人', '0', '6', 'account', null, '', '', '1', '0', 'M', '1', '0', '', 'ProfileOutlined', 'admin', '2025-06-24 19:45:06', 'admin', '2025-07-02 17:07:22', '个人');
INSERT INTO `sys_menu` VALUES ('100', '用户管理', '1', '1', 'user', 'system/user/index', '', '', '1', '0', 'C', '0', '0', 'system:user:list', 'user', 'admin', '2025-06-24 19:45:06', '', null, '用户管理菜单');
INSERT INTO `sys_menu` VALUES ('101', '角色管理', '1', '2', 'role', 'system/role/index', '', '', '1', '0', 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2025-06-24 19:45:06', '', null, '角色管理菜单');
INSERT INTO `sys_menu` VALUES ('102', '菜单管理', '1', '3', 'menu', 'system/menu/index', '', '', '1', '0', 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2025-06-24 19:45:06', '', null, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES ('103', '部门管理', '1', '4', 'dept', 'system/dept/index', '', '', '1', '0', 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2025-06-24 19:45:06', '', null, '部门管理菜单');
INSERT INTO `sys_menu` VALUES ('104', '岗位管理', '1', '5', 'post', 'system/post/index', '', '', '1', '0', 'C', '0', '0', 'system:post:list', 'post', 'admin', '2025-06-24 19:45:06', '', null, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES ('105', '字典管理', '1', '6', 'dict', 'system/dict/index', '', '', '1', '0', 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2025-06-24 19:45:06', '', null, '字典管理菜单');
INSERT INTO `sys_menu` VALUES ('106', '参数设置', '1', '7', 'config', 'system/config/index', '', '', '1', '0', 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2025-06-24 19:45:06', '', null, '参数设置菜单');
INSERT INTO `sys_menu` VALUES ('107', '通知公告', '1', '8', 'notice', 'system/notice/index', '', '', '1', '0', 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2025-06-24 19:45:06', '', null, '通知公告菜单');
INSERT INTO `sys_menu` VALUES ('108', '日志管理', '1', '9', 'log', '', '', '', '1', '0', 'M', '0', '0', '', 'log', 'admin', '2025-06-24 19:45:06', '', null, '日志管理菜单');
INSERT INTO `sys_menu` VALUES ('109', '在线用户', '2', '1', 'online', 'monitor/online/index', '', '', '1', '0', 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2025-06-24 19:45:06', '', null, '在线用户菜单');
INSERT INTO `sys_menu` VALUES ('110', '定时任务', '2', '2', 'job', 'monitor/job/index', '', '', '1', '0', 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2025-06-24 19:45:06', '', null, '定时任务菜单');
INSERT INTO `sys_menu` VALUES ('111', '数据监控', '2', '3', 'druid', 'monitor/druid/index', '', '', '1', '0', 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2025-06-24 19:45:06', '', null, '数据监控菜单');
INSERT INTO `sys_menu` VALUES ('112', '服务监控', '2', '4', 'server', 'monitor/server/index', '', '', '1', '0', 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2025-06-24 19:45:06', '', null, '服务监控菜单');
INSERT INTO `sys_menu` VALUES ('113', '缓存监控', '2', '5', 'cache', 'monitor/cache/index', '', '', '1', '0', 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2025-06-24 19:45:06', '', null, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES ('114', '缓存列表', '2', '6', 'cacheList', 'monitor/cache/list', '', '', '1', '0', 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2025-06-24 19:45:06', '', null, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES ('115', '表单构建', '3', '1', 'build', 'tool/build/index', '', '', '1', '0', 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2025-06-24 19:45:06', '', null, '表单构建菜单');
INSERT INTO `sys_menu` VALUES ('116', '代码生成', '3', '2', 'gen', 'tool/gen/index', '', '', '1', '0', 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2025-06-24 19:45:06', '', null, '代码生成菜单');
INSERT INTO `sys_menu` VALUES ('117', '系统接口', '3', '3', 'swagger', 'tool/swagger/index', '', '', '1', '0', 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2025-06-24 19:45:06', '', null, '系统接口菜单');
INSERT INTO `sys_menu` VALUES ('500', '操作日志', '108', '1', 'operlog', 'monitor/operlog/index', '', '', '1', '0', 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2025-06-24 19:45:06', '', null, '操作日志菜单');
INSERT INTO `sys_menu` VALUES ('501', '登录日志', '108', '2', 'logininfor', 'monitor/logininfor/index', '', '', '1', '0', 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2025-06-24 19:45:06', '', null, '登录日志菜单');
INSERT INTO `sys_menu` VALUES ('1000', '用户查询', '100', '1', '', '', '', '', '1', '0', 'F', '0', '0', 'system:user:query', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1001', '用户新增', '100', '2', '', '', '', '', '1', '0', 'F', '0', '0', 'system:user:add', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1002', '用户修改', '100', '3', '', '', '', '', '1', '0', 'F', '0', '0', 'system:user:edit', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1003', '用户删除', '100', '4', '', '', '', '', '1', '0', 'F', '0', '0', 'system:user:remove', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1004', '用户导出', '100', '5', '', '', '', '', '1', '0', 'F', '0', '0', 'system:user:export', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1005', '用户导入', '100', '6', '', '', '', '', '1', '0', 'F', '0', '0', 'system:user:import', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1006', '重置密码', '100', '7', '', '', '', '', '1', '0', 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1007', '角色查询', '101', '1', '', '', '', '', '1', '0', 'F', '0', '0', 'system:role:query', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1008', '角色新增', '101', '2', '', '', '', '', '1', '0', 'F', '0', '0', 'system:role:add', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1009', '角色修改', '101', '3', '', '', '', '', '1', '0', 'F', '0', '0', 'system:role:edit', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1010', '角色删除', '101', '4', '', '', '', '', '1', '0', 'F', '0', '0', 'system:role:remove', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1011', '角色导出', '101', '5', '', '', '', '', '1', '0', 'F', '0', '0', 'system:role:export', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1012', '菜单查询', '102', '1', '', '', '', '', '1', '0', 'F', '0', '0', 'system:menu:query', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1013', '菜单新增', '102', '2', '', '', '', '', '1', '0', 'F', '0', '0', 'system:menu:add', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1014', '菜单修改', '102', '3', '', '', '', '', '1', '0', 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1015', '菜单删除', '102', '4', '', '', '', '', '1', '0', 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1016', '部门查询', '103', '1', '', '', '', '', '1', '0', 'F', '0', '0', 'system:dept:query', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1017', '部门新增', '103', '2', '', '', '', '', '1', '0', 'F', '0', '0', 'system:dept:add', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1018', '部门修改', '103', '3', '', '', '', '', '1', '0', 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1019', '部门删除', '103', '4', '', '', '', '', '1', '0', 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1020', '岗位查询', '104', '1', '', '', '', '', '1', '0', 'F', '0', '0', 'system:post:query', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1021', '岗位新增', '104', '2', '', '', '', '', '1', '0', 'F', '0', '0', 'system:post:add', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1022', '岗位修改', '104', '3', '', '', '', '', '1', '0', 'F', '0', '0', 'system:post:edit', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1023', '岗位删除', '104', '4', '', '', '', '', '1', '0', 'F', '0', '0', 'system:post:remove', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1024', '岗位导出', '104', '5', '', '', '', '', '1', '0', 'F', '0', '0', 'system:post:export', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1025', '字典查询', '105', '1', '#', '', '', '', '1', '0', 'F', '0', '0', 'system:dict:query', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1026', '字典新增', '105', '2', '#', '', '', '', '1', '0', 'F', '0', '0', 'system:dict:add', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1027', '字典修改', '105', '3', '#', '', '', '', '1', '0', 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1028', '字典删除', '105', '4', '#', '', '', '', '1', '0', 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1029', '字典导出', '105', '5', '#', '', '', '', '1', '0', 'F', '0', '0', 'system:dict:export', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1030', '参数查询', '106', '1', '#', '', '', '', '1', '0', 'F', '0', '0', 'system:config:query', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1031', '参数新增', '106', '2', '#', '', '', '', '1', '0', 'F', '0', '0', 'system:config:add', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1032', '参数修改', '106', '3', '#', '', '', '', '1', '0', 'F', '0', '0', 'system:config:edit', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1033', '参数删除', '106', '4', '#', '', '', '', '1', '0', 'F', '0', '0', 'system:config:remove', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1034', '参数导出', '106', '5', '#', '', '', '', '1', '0', 'F', '0', '0', 'system:config:export', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1035', '公告查询', '107', '1', '#', '', '', '', '1', '0', 'F', '0', '0', 'system:notice:query', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1036', '公告新增', '107', '2', '#', '', '', '', '1', '0', 'F', '0', '0', 'system:notice:add', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1037', '公告修改', '107', '3', '#', '', '', '', '1', '0', 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1038', '公告删除', '107', '4', '#', '', '', '', '1', '0', 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1039', '操作查询', '500', '1', '#', '', '', '', '1', '0', 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1040', '操作删除', '500', '2', '#', '', '', '', '1', '0', 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1041', '日志导出', '500', '3', '#', '', '', '', '1', '0', 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1042', '登录查询', '501', '1', '#', '', '', '', '1', '0', 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1043', '登录删除', '501', '2', '#', '', '', '', '1', '0', 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1044', '日志导出', '501', '3', '#', '', '', '', '1', '0', 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1045', '账户解锁', '501', '4', '#', '', '', '', '1', '0', 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1046', '在线查询', '109', '1', '#', '', '', '', '1', '0', 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1047', '批量强退', '109', '2', '#', '', '', '', '1', '0', 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1048', '单条强退', '109', '3', '#', '', '', '', '1', '0', 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1049', '任务查询', '110', '1', '#', '', '', '', '1', '0', 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1050', '任务新增', '110', '2', '#', '', '', '', '1', '0', 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1051', '任务修改', '110', '3', '#', '', '', '', '1', '0', 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1052', '任务删除', '110', '4', '#', '', '', '', '1', '0', 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1053', '状态修改', '110', '5', '#', '', '', '', '1', '0', 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1054', '任务导出', '110', '6', '#', '', '', '', '1', '0', 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1055', '生成查询', '116', '1', '#', '', '', '', '1', '0', 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1056', '生成修改', '116', '2', '#', '', '', '', '1', '0', 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1057', '生成删除', '116', '3', '#', '', '', '', '1', '0', 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1058', '导入代码', '116', '4', '#', '', '', '', '1', '0', 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1059', '预览代码', '116', '5', '#', '', '', '', '1', '0', 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('1060', '生成代码', '116', '6', '#', '', '', '', '1', '0', 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2025-06-24 19:45:06', '', null, '');
INSERT INTO `sys_menu` VALUES ('2000', 'MSDS管理', '0', '1', 'msds', null, '', '', '1', '0', 'M', '0', '0', '', 'FileTextOutlined', 'admin', '2025-06-29 10:32:17', 'admin', '2025-07-02 17:07:37', 'MSDS管理目录');
INSERT INTO `sys_menu` VALUES ('2001', 'MSDS信息', '2000', '1', '/msds/main', 'msds/main/index', '', '', '1', '0', 'C', '0', '0', 'system:msds:list', 'file-text', 'admin', '2025-06-29 10:32:18', '', null, 'MSDS主信息菜单');
INSERT INTO `sys_menu` VALUES ('2002', 'MSDS查询', '2001', '1', '#', '', '', '', '1', '0', 'F', '0', '0', 'system:msds:query', '#', 'admin', '2025-06-29 10:32:18', '', null, '');
INSERT INTO `sys_menu` VALUES ('2003', 'MSDS新增', '2001', '2', '#', '', '', '', '1', '0', 'F', '0', '0', 'system:msds:add', '#', 'admin', '2025-06-29 10:32:18', '', null, '');
INSERT INTO `sys_menu` VALUES ('2004', 'MSDS修改', '2001', '3', '#', '', '', '', '1', '0', 'F', '0', '0', 'system:msds:edit', '#', 'admin', '2025-06-29 10:32:18', '', null, '');
INSERT INTO `sys_menu` VALUES ('2005', 'MSDS删除', '2001', '4', '#', '', '', '', '1', '0', 'F', '0', '0', 'system:msds:remove', '#', 'admin', '2025-06-29 10:32:18', '', null, '');
INSERT INTO `sys_menu` VALUES ('2006', 'MSDS导出', '2001', '5', '#', '', '', '', '1', '0', 'F', '0', '0', 'system:msds:export', '#', 'admin', '2025-06-29 10:32:18', '', null, '');
INSERT INTO `sys_menu` VALUES ('2007', 'MSDS导入', '2001', '6', '#', '', '', '', '1', '0', 'F', '0', '0', 'system:msds:import', '#', 'admin', '2025-07-01 22:06:34', '', null, '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice` (
  `notice_id` int(4) NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob COMMENT '公告内容',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='通知公告表';

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES ('1', '温馨提醒：2018-07-01 若依新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '0', 'admin', '2025-06-24 19:45:15', '', null, '管理员');
INSERT INTO `sys_notice` VALUES ('2', '维护通知：2018-07-01 若依系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '0', 'admin', '2025-06-24 19:45:15', '', null, '管理员');

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log` (
  `oper_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '模块标题',
  `business_type` int(2) DEFAULT '0' COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '请求方式',
  `operator_type` int(1) DEFAULT '0' COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '返回参数',
  `status` int(1) DEFAULT '0' COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint(20) DEFAULT '0' COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`),
  KEY `idx_sys_oper_log_bt` (`business_type`),
  KEY `idx_sys_oper_log_s` (`status`),
  KEY `idx_sys_oper_log_ot` (`oper_time`)
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作日志记录';

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES ('100', 'MSDS文档导入', '6', 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', '1', 'admin', '研发部门', '/system/msds/import', '127.0.0.1', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: 无法解析出有效的MSDS信息\"],\"successCount\":0,\"failureCount\":1}}', '0', null, '2025-07-02 01:59:59', '1610');
INSERT INTO `sys_oper_log` VALUES ('101', 'MSDS文档导入', '6', 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', '1', 'admin', '研发部门', '/system/msds/import', '127.0.0.1', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: \\r\\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\\r\\n### The error may exist in URL [jar:file:/D:/.m2/com/ruoyi/ruoyi-system/3.8.8/ruoyi-system-3.8.8.jar!/mapper/system/MsdsMainMapper.xml]\\r\\n### The error may involve com.ruoyi.system.mapper.MsdsMainMapper.selectMsdsMainByProductName-Inline\\r\\n### The error occurred while setting parameters\\r\\n### SQL: select id, cas_number, msds_code, product_name, product_alias, product_english_name,                 category_id, company_name, company_address, zip_code, fax_number, contact_phone,                 email, emergency_phone, recommended_usage, restricted_usage, version,                 revision_date, effective_date, status, approver, approval_date,                is_active, create_by, create_time, update_by, update_time, remark         from msds_main               where product_name = ? and is_active = 1 limit 1\\r\\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\\n; bad SQL grammar []\"],\"successCount\":0,\"failureCount\":1}}', '0', null, '2025-07-02 09:51:29', '4524');
INSERT INTO `sys_oper_log` VALUES ('102', 'MSDS文档导入', '6', 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', '1', 'admin', '研发部门', '/system/msds/import', '127.0.0.1', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: \\r\\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\\r\\n### The error may exist in URL [jar:file:/D:/.m2/com/ruoyi/ruoyi-system/3.8.8/ruoyi-system-3.8.8.jar!/mapper/system/MsdsMainMapper.xml]\\r\\n### The error may involve com.ruoyi.system.mapper.MsdsMainMapper.selectMsdsMainByProductName-Inline\\r\\n### The error occurred while setting parameters\\r\\n### SQL: select id, cas_number, msds_code, product_name, product_alias, product_english_name,                 category_id, company_name, company_address, zip_code, fax_number, contact_phone,                 email, emergency_phone, recommended_usage, restricted_usage, version,                 revision_date, effective_date, status, approver, approval_date,                is_active, create_by, create_time, update_by, update_time, remark         from msds_main               where product_name = ? and is_active = 1 limit 1\\r\\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\\n; bad SQL grammar []\"],\"successCount\":0,\"failureCount\":1}}', '0', null, '2025-07-02 10:36:14', '2542');
INSERT INTO `sys_oper_log` VALUES ('103', 'MSDS文档导入', '6', 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', '1', 'admin', '研发部门', '/system/msds/import', '127.0.0.1', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: \\r\\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'remark\' in \'field list\'\\r\\n### The error may exist in URL [jar:file:/D:/.m2/com/ruoyi/ruoyi-system/3.8.8/ruoyi-system-3.8.8.jar!/mapper/system/MsdsMainMapper.xml]\\r\\n### The error may involve com.ruoyi.system.mapper.MsdsMainMapper.selectMsdsMainByProductName-Inline\\r\\n### The error occurred while setting parameters\\r\\n### SQL: select id, cas_number, msds_code, product_name, product_alias, product_english_name,             category_id, company_name, company_address, zip_code, fax_number, contact_phone,             email, emergency_phone, recommended_usage, restricted_usage, version,             revision_date, effective_date, status, approver, approval_date,             is_active, create_time, update_time, remark         from msds_main               where product_name = ? and is_active = 1 limit 1\\r\\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'remark\' in \'field list\'\\n; bad SQL grammar []\"],\"successCount\":0,\"failureCount\":1}}', '0', null, '2025-07-02 11:03:43', '2983');
INSERT INTO `sys_oper_log` VALUES ('104', 'MSDS文档导入', '6', 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', '1', 'admin', '研发部门', '/system/msds/import', '127.0.0.1', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: \\r\\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'remark\' in \'field list\'\\r\\n### The error may exist in URL [jar:file:/D:/.m2/com/ruoyi/ruoyi-system/3.8.8/ruoyi-system-3.8.8.jar!/mapper/system/MsdsMainMapper.xml]\\r\\n### The error may involve com.ruoyi.system.mapper.MsdsMainMapper.selectMsdsMainByProductName-Inline\\r\\n### The error occurred while setting parameters\\r\\n### SQL: select id, cas_number, msds_code, product_name, product_alias, product_english_name,             category_id, company_name, company_address, zip_code, fax_number, contact_phone,             email, emergency_phone, recommended_usage, restricted_usage, version,             revision_date, effective_date, status, approver, approval_date,             is_active, create_time, update_time, remark         from msds_main               where product_name = ? and is_active = 1 limit 1\\r\\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'remark\' in \'field list\'\\n; bad SQL grammar []\"],\"successCount\":0,\"failureCount\":1}}', '0', null, '2025-07-02 13:57:44', '1384');
INSERT INTO `sys_oper_log` VALUES ('105', 'MSDS文档导入', '6', 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', '1', 'admin', '研发部门', '/system/msds/import', '127.0.0.1', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[],\"successCount\":1,\"failureCount\":0}}', '0', null, '2025-07-02 16:37:26', '3007');
INSERT INTO `sys_oper_log` VALUES ('106', 'MSDS主信息', '2', 'com.ruoyi.web.controller.system.MsdsMainController.edit()', 'PUT', '1', 'admin', '研发部门', '/system/msds', '127.0.0.1', '内网IP', '{\"casNumber\":\"115-29-7\",\"companyAddress\":\"\",\"companyName\":\"2323\",\"contactPhone\":\"ghbghggf\",\"createTime\":\"2025-07-02 16:37:25\",\"email\":\"\",\"emergencyPhone\":\"\",\"faxNumber\":\"供应商Email：\",\"id\":1,\"isActive\":1,\"msdsCode\":\"MSDS#1597\",\"params\":{},\"productAlias\":\"1,2,3,4,7,7-六氯双环[2,2,1] 庚烯-(2)-双羟甲基-5,6-亚硫 酸酯；硫丹 \",\"productEnglishName\":\",2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedim  ethyl \",\"productName\":\"(1,4,5,6,7,7-六氯-8,9,10-三降 冰片-5-烯-2,3-亚基双亚甲基)亚 硫酸酯 \",\"status\":\"draft\",\"updateTime\":\"2025-07-02 16:37:25\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2025-07-02 16:43:41', '469');
INSERT INTO `sys_oper_log` VALUES ('107', 'MSDS主信息', '5', 'com.ruoyi.web.controller.system.MsdsMainController.export()', 'POST', '1', 'admin', '研发部门', '/system/msds/export', '127.0.0.1', '内网IP', '{\"params\":{}}', null, '0', null, '2025-07-02 16:43:53', '2531');
INSERT INTO `sys_oper_log` VALUES ('108', 'MSDS文档导入', '6', 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', '1', 'admin', '研发部门', '/system/msds/import', '127.0.0.1', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[],\"successCount\":1,\"failureCount\":0}}', '0', null, '2025-07-02 16:44:55', '678');
INSERT INTO `sys_oper_log` VALUES ('109', '菜单管理', '2', 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', '1', 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"icon\":\"LinkOutlined\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":4,\"menuName\":\"若依官网\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"http://ruoyi.vip\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2025-07-02 17:06:16', '422');
INSERT INTO `sys_oper_log` VALUES ('110', '菜单管理', '2', 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', '1', 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"icon\":\"LinkOutlined\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":4,\"menuName\":\"若依官网\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"http://ruoyi.vip\",\"perms\":\"\",\"query\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2025-07-02 17:06:25', '1411');
INSERT INTO `sys_oper_log` VALUES ('111', '菜单管理', '2', 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', '1', 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"icon\":\"FileTextOutlined\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"MSDS管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"msds\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2025-07-02 17:07:01', '544');
INSERT INTO `sys_oper_log` VALUES ('112', '菜单管理', '2', 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', '1', 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"icon\":\"ProfileOutlined\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":6,\"menuName\":\"个人\",\"menuType\":\"M\",\"orderNum\":6,\"params\":{},\"parentId\":0,\"path\":\"account\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2025-07-02 17:07:22', '192');
INSERT INTO `sys_oper_log` VALUES ('113', '菜单管理', '2', 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', '1', 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"icon\":\"FileTextOutlined\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"MSDS管理\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"msds\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2025-07-02 17:07:38', '804');
INSERT INTO `sys_oper_log` VALUES ('114', '菜单管理', '2', 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', '1', 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"icon\":\"SettingOutlined\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1,\"menuName\":\"系统管理\",\"menuType\":\"M\",\"orderNum\":10,\"params\":{},\"parentId\":0,\"path\":\"system\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2025-07-02 17:07:52', '199');
INSERT INTO `sys_oper_log` VALUES ('115', '菜单管理', '2', 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', '1', 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"icon\":\"DashboardOutlined\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2,\"menuName\":\"系统监控\",\"menuType\":\"M\",\"orderNum\":11,\"params\":{},\"parentId\":0,\"path\":\"monitor\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2025-07-02 17:08:04', '1382');
INSERT INTO `sys_oper_log` VALUES ('116', '菜单管理', '2', 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', '1', 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"icon\":\"ToolOutlined\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":3,\"menuName\":\"系统工具\",\"menuType\":\"M\",\"orderNum\":12,\"params\":{},\"parentId\":0,\"path\":\"tool\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', '0', null, '2025-07-02 17:08:31', '414');

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post` (
  `post_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int(4) NOT NULL COMMENT '显示顺序',
  `status` char(1) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='岗位信息表';

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES ('1', 'ceo', '董事长', '1', '0', 'admin', '2025-06-24 19:45:05', '', null, '');
INSERT INTO `sys_post` VALUES ('2', 'se', '项目经理', '2', '0', 'admin', '2025-06-24 19:45:05', '', null, '');
INSERT INTO `sys_post` VALUES ('3', 'hr', '人力资源', '3', '0', 'admin', '2025-06-24 19:45:05', '', null, '');
INSERT INTO `sys_post` VALUES ('4', 'user', '普通员工', '4', '0', 'admin', '2025-06-24 19:45:05', '', null, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `role_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int(4) NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) DEFAULT '1' COMMENT '部门树选择项是否关联显示',
  `status` char(1) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色信息表';

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES ('1', '超级管理员', 'admin', '1', '1', '1', '1', '0', '0', 'admin', '2025-06-24 19:45:05', '', null, '超级管理员');
INSERT INTO `sys_role` VALUES ('2', '普通角色', 'common', '2', '2', '1', '1', '0', '0', 'admin', '2025-06-24 19:45:05', '', null, '普通角色');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept` (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `dept_id` bigint(20) NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`,`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色和部门关联表';

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES ('2', '100');
INSERT INTO `sys_role_dept` VALUES ('2', '101');
INSERT INTO `sys_role_dept` VALUES ('2', '105');

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu` (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `menu_id` bigint(20) NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色和菜单关联表';

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES ('1', '2000');
INSERT INTO `sys_role_menu` VALUES ('1', '2001');
INSERT INTO `sys_role_menu` VALUES ('1', '2002');
INSERT INTO `sys_role_menu` VALUES ('1', '2003');
INSERT INTO `sys_role_menu` VALUES ('1', '2004');
INSERT INTO `sys_role_menu` VALUES ('1', '2005');
INSERT INTO `sys_role_menu` VALUES ('1', '2006');
INSERT INTO `sys_role_menu` VALUES ('1', '2007');
INSERT INTO `sys_role_menu` VALUES ('2', '1');
INSERT INTO `sys_role_menu` VALUES ('2', '2');
INSERT INTO `sys_role_menu` VALUES ('2', '3');
INSERT INTO `sys_role_menu` VALUES ('2', '4');
INSERT INTO `sys_role_menu` VALUES ('2', '100');
INSERT INTO `sys_role_menu` VALUES ('2', '101');
INSERT INTO `sys_role_menu` VALUES ('2', '102');
INSERT INTO `sys_role_menu` VALUES ('2', '103');
INSERT INTO `sys_role_menu` VALUES ('2', '104');
INSERT INTO `sys_role_menu` VALUES ('2', '105');
INSERT INTO `sys_role_menu` VALUES ('2', '106');
INSERT INTO `sys_role_menu` VALUES ('2', '107');
INSERT INTO `sys_role_menu` VALUES ('2', '108');
INSERT INTO `sys_role_menu` VALUES ('2', '109');
INSERT INTO `sys_role_menu` VALUES ('2', '110');
INSERT INTO `sys_role_menu` VALUES ('2', '111');
INSERT INTO `sys_role_menu` VALUES ('2', '112');
INSERT INTO `sys_role_menu` VALUES ('2', '113');
INSERT INTO `sys_role_menu` VALUES ('2', '114');
INSERT INTO `sys_role_menu` VALUES ('2', '115');
INSERT INTO `sys_role_menu` VALUES ('2', '116');
INSERT INTO `sys_role_menu` VALUES ('2', '117');
INSERT INTO `sys_role_menu` VALUES ('2', '500');
INSERT INTO `sys_role_menu` VALUES ('2', '501');
INSERT INTO `sys_role_menu` VALUES ('2', '1000');
INSERT INTO `sys_role_menu` VALUES ('2', '1001');
INSERT INTO `sys_role_menu` VALUES ('2', '1002');
INSERT INTO `sys_role_menu` VALUES ('2', '1003');
INSERT INTO `sys_role_menu` VALUES ('2', '1004');
INSERT INTO `sys_role_menu` VALUES ('2', '1005');
INSERT INTO `sys_role_menu` VALUES ('2', '1006');
INSERT INTO `sys_role_menu` VALUES ('2', '1007');
INSERT INTO `sys_role_menu` VALUES ('2', '1008');
INSERT INTO `sys_role_menu` VALUES ('2', '1009');
INSERT INTO `sys_role_menu` VALUES ('2', '1010');
INSERT INTO `sys_role_menu` VALUES ('2', '1011');
INSERT INTO `sys_role_menu` VALUES ('2', '1012');
INSERT INTO `sys_role_menu` VALUES ('2', '1013');
INSERT INTO `sys_role_menu` VALUES ('2', '1014');
INSERT INTO `sys_role_menu` VALUES ('2', '1015');
INSERT INTO `sys_role_menu` VALUES ('2', '1016');
INSERT INTO `sys_role_menu` VALUES ('2', '1017');
INSERT INTO `sys_role_menu` VALUES ('2', '1018');
INSERT INTO `sys_role_menu` VALUES ('2', '1019');
INSERT INTO `sys_role_menu` VALUES ('2', '1020');
INSERT INTO `sys_role_menu` VALUES ('2', '1021');
INSERT INTO `sys_role_menu` VALUES ('2', '1022');
INSERT INTO `sys_role_menu` VALUES ('2', '1023');
INSERT INTO `sys_role_menu` VALUES ('2', '1024');
INSERT INTO `sys_role_menu` VALUES ('2', '1025');
INSERT INTO `sys_role_menu` VALUES ('2', '1026');
INSERT INTO `sys_role_menu` VALUES ('2', '1027');
INSERT INTO `sys_role_menu` VALUES ('2', '1028');
INSERT INTO `sys_role_menu` VALUES ('2', '1029');
INSERT INTO `sys_role_menu` VALUES ('2', '1030');
INSERT INTO `sys_role_menu` VALUES ('2', '1031');
INSERT INTO `sys_role_menu` VALUES ('2', '1032');
INSERT INTO `sys_role_menu` VALUES ('2', '1033');
INSERT INTO `sys_role_menu` VALUES ('2', '1034');
INSERT INTO `sys_role_menu` VALUES ('2', '1035');
INSERT INTO `sys_role_menu` VALUES ('2', '1036');
INSERT INTO `sys_role_menu` VALUES ('2', '1037');
INSERT INTO `sys_role_menu` VALUES ('2', '1038');
INSERT INTO `sys_role_menu` VALUES ('2', '1039');
INSERT INTO `sys_role_menu` VALUES ('2', '1040');
INSERT INTO `sys_role_menu` VALUES ('2', '1041');
INSERT INTO `sys_role_menu` VALUES ('2', '1042');
INSERT INTO `sys_role_menu` VALUES ('2', '1043');
INSERT INTO `sys_role_menu` VALUES ('2', '1044');
INSERT INTO `sys_role_menu` VALUES ('2', '1045');
INSERT INTO `sys_role_menu` VALUES ('2', '1046');
INSERT INTO `sys_role_menu` VALUES ('2', '1047');
INSERT INTO `sys_role_menu` VALUES ('2', '1048');
INSERT INTO `sys_role_menu` VALUES ('2', '1049');
INSERT INTO `sys_role_menu` VALUES ('2', '1050');
INSERT INTO `sys_role_menu` VALUES ('2', '1051');
INSERT INTO `sys_role_menu` VALUES ('2', '1052');
INSERT INTO `sys_role_menu` VALUES ('2', '1053');
INSERT INTO `sys_role_menu` VALUES ('2', '1054');
INSERT INTO `sys_role_menu` VALUES ('2', '1055');
INSERT INTO `sys_role_menu` VALUES ('2', '1056');
INSERT INTO `sys_role_menu` VALUES ('2', '1057');
INSERT INTO `sys_role_menu` VALUES ('2', '1058');
INSERT INTO `sys_role_menu` VALUES ('2', '1059');
INSERT INTO `sys_role_menu` VALUES ('2', '1060');
INSERT INTO `sys_role_menu` VALUES ('2', '2000');
INSERT INTO `sys_role_menu` VALUES ('2', '2001');
INSERT INTO `sys_role_menu` VALUES ('2', '2002');
INSERT INTO `sys_role_menu` VALUES ('2', '2003');
INSERT INTO `sys_role_menu` VALUES ('2', '2004');
INSERT INTO `sys_role_menu` VALUES ('2', '2005');
INSERT INTO `sys_role_menu` VALUES ('2', '2006');
INSERT INTO `sys_role_menu` VALUES ('2', '2007');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint(20) DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '手机号码',
  `sex` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '密码',
  `status` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `del_flag` char(1) COLLATE utf8mb4_unicode_ci DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `create_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户信息表';

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES ('1', '103', 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2025-07-02 21:23:04', 'admin', '2025-06-24 19:45:04', '', '2025-07-02 21:23:04', '管理员');
INSERT INTO `sys_user` VALUES ('2', '105', 'ry', '若依', '00', 'ry@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2025-06-24 19:45:04', 'admin', '2025-06-24 19:45:04', '', null, '测试员');

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post` (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `post_id` bigint(20) NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`,`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户与岗位关联表';

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES ('1', '1');
INSERT INTO `sys_user_post` VALUES ('2', '2');

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户和角色关联表';

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES ('1', '1');
INSERT INTO `sys_user_role` VALUES ('2', '2');
