/*
Navicat MySQL Data Transfer

Source Server         : localhost[8.0.12]3306
Source Server Version : 80012
Source Host           : localhost:3306
Source Database       : msds_management

Target Server Type    : MYSQL
Target Server Version : 80012
File Encoding         : 65001

Date: 2025-06-24 19:40:11
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
INSERT INTO `chemical_category` VALUES ('1', 'INORGANIC', '无机化学品', null, '无机化合物', '1', '2025-06-18 21:24:51');
INSERT INTO `chemical_category` VALUES ('2', 'ORGANIC', '有机化学品', null, '有机化合物', '1', '2025-06-18 21:24:51');
INSERT INTO `chemical_category` VALUES ('3', 'POLYMER', '高分子材料', null, '聚合物及其制品', '1', '2025-06-18 21:24:51');
INSERT INTO `chemical_category` VALUES ('4', 'MIXTURE', '混合物', null, '多种化学物质的混合物', '1', '2025-06-18 21:24:51');
INSERT INTO `chemical_category` VALUES ('5', 'PREPARATION', '制剂', null, '含有添加剂的化学制品', '1', '2025-06-18 21:24:51');

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
INSERT INTO `ghs_hazard_class` VALUES ('1', 'FLAM_LIQ_1', '易燃液体', '类别1', 'GHS02', 'DANGER', '闪点小于23℃且初沸点小于等于35℃', '1');
INSERT INTO `ghs_hazard_class` VALUES ('2', 'FLAM_LIQ_2', '易燃液体', '类别2', 'GHS02', 'DANGER', '闪点小于23℃且初沸点大于35℃', '1');
INSERT INTO `ghs_hazard_class` VALUES ('3', 'FLAM_LIQ_3', '易燃液体', '类别3', 'GHS02', 'WARNING', '闪点大于等于23℃且小于等于60℃', '1');
INSERT INTO `ghs_hazard_class` VALUES ('4', 'ACUTE_TOX_1', '急性毒性', '类别1', 'GHS06', 'DANGER', '经口LD50小于等于5mg/kg', '1');
INSERT INTO `ghs_hazard_class` VALUES ('5', 'ACUTE_TOX_2', '急性毒性', '类别2', 'GHS06', 'DANGER', '经口LD50大于5且小于等于50mg/kg', '1');
INSERT INTO `ghs_hazard_class` VALUES ('6', 'ACUTE_TOX_3', '急性毒性', '类别3', 'GHS06', 'DANGER', '经口LD50大于50且小于等于300mg/kg', '1');
INSERT INTO `ghs_hazard_class` VALUES ('7', 'ACUTE_TOX_4', '急性毒性', '类别4', 'GHS07', 'WARNING', '经口LD50大于300且小于等于2000mg/kg', '1');
INSERT INTO `ghs_hazard_class` VALUES ('8', 'SKIN_CORR_1', '皮肤腐蚀', '类别1', 'GHS05', 'DANGER', '造成皮肤腐蚀', '1');
INSERT INTO `ghs_hazard_class` VALUES ('9', 'EYE_IRR_2', '眼刺激', '类别2', 'GHS07', 'WARNING', '造成严重眼刺激', '1');
INSERT INTO `ghs_hazard_class` VALUES ('10', 'CARC_1A', '致癌性', '类别1A', 'GHS08', 'DANGER', '已知对人类致癌', '1');
INSERT INTO `ghs_hazard_class` VALUES ('11', 'CARC_1B', '致癌性', '类别1B', 'GHS08', 'DANGER', '可能对人类致癌', '1');
INSERT INTO `ghs_hazard_class` VALUES ('12', 'AQUATIC_1', '水环境危害', '急性类别1', 'GHS09', 'WARNING', '对水生生物毒性极高', '1');

-- ----------------------------
-- Table structure for msds_component
-- ----------------------------
DROP TABLE IF EXISTS `msds_component`;
CREATE TABLE `msds_component` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(20) NOT NULL COMMENT '关联MSDS主表ID',
  `component_name` varchar(255) NOT NULL COMMENT '成分名称',
  `component_content` varchar(100) DEFAULT NULL COMMENT '成分含量/浓度',
  `cas_number` varchar(50) DEFAULT NULL COMMENT 'CAS登记号',
  `is_hazardous` tinyint(1) DEFAULT '0' COMMENT '是否为危险成分(1:是,0:否)',
  `hazard_level` varchar(50) DEFAULT NULL COMMENT '危险等级',
  PRIMARY KEY (`id`),
  KEY `idx_msds_id` (`msds_id`),
  KEY `idx_component_name` (`component_name`),
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
  `disposal_method` text COMMENT '废弃处置方法',
  `disposal_precautions` text COMMENT '废弃注意事项',
  `disposal_regulations` text COMMENT '废弃处置相关法规',
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
  `biodegradability` text COMMENT '生物降解性',
  `non_biodegradability` text COMMENT '非生物降解性',
  `bioaccumulation` text COMMENT '生物富集或生物积累性',
  `other_environmental_effects` text COMMENT '其它有害作用',
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
  `monitoring_method` text COMMENT '监测方法',
  `engineering_controls` text COMMENT '工程控制措施',
  `respiratory_protection` text COMMENT '呼吸系统防护',
  `eye_protection` text COMMENT '眼睛防护',
  `body_protection` text COMMENT '身体防护',
  `hand_protection` text COMMENT '手部防护',
  `other_protection` text COMMENT '其他防护措施',
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
  `fire_extinguishing_methods` text COMMENT '灭火方法',
  `fire_fighting_equipment` text COMMENT '消防设备和防护装备',
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
  `symptoms` text COMMENT '可能出现的症状',
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
  `humidity_requirements` varchar(50) DEFAULT NULL COMMENT '湿度要求',
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
  `ghs_hazard_class` text COMMENT 'GHS危险性类别',
  `pictogram` varchar(100) DEFAULT NULL COMMENT '象形图',
  `warning_word` varchar(50) DEFAULT NULL COMMENT '警示词(危险/警告)',
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
  `emergency_procedures` text COMMENT '应急处理程序',
  `elimination_methods` text COMMENT '消除方法',
  `personal_protection` text COMMENT '个人防护措施',
  `environmental_protection` text COMMENT '环境保护措施',
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
  `product_name` varchar(255) NOT NULL COMMENT '化学品中文名',
  `product_alias` varchar(255) DEFAULT NULL COMMENT '化学品别名',
  `product_english_name` varchar(255) DEFAULT NULL COMMENT '化学品英文名',
  `company_name` varchar(255) NOT NULL COMMENT '企业名称',
  `company_address` text COMMENT '企业地址',
  `zip_code` char(10) DEFAULT NULL COMMENT '邮编',
  `fax_number` varchar(50) DEFAULT NULL COMMENT '传真号码',
  `contact_phone` varchar(50) NOT NULL COMMENT '联系电话',
  `email` varchar(100) DEFAULT NULL COMMENT '电子邮件地址',
  `emergency_phone` varchar(50) DEFAULT NULL COMMENT '企业应急电话',
  `recommended_usage` text COMMENT '产品推荐用途',
  `restricted_usage` text COMMENT '产品限制用途',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `version` varchar(20) DEFAULT NULL COMMENT 'MSDS版本号',
  `is_active` tinyint(1) DEFAULT '1' COMMENT '是否有效(1:有效,0:无效)',
  PRIMARY KEY (`id`),
  KEY `idx_product_name` (`product_name`),
  KEY `idx_company_name` (`company_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='MSDS主信息表';

-- ----------------------------
-- Records of msds_main
-- ----------------------------

-- ----------------------------
-- Table structure for msds_other_info
-- ----------------------------
DROP TABLE IF EXISTS `msds_other_info`;
CREATE TABLE `msds_other_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(20) NOT NULL COMMENT '关联MSDS主表ID',
  `references` text COMMENT '参考文献',
  `form_fill_time` date DEFAULT NULL COMMENT '填表时间',
  `form_fill_department` varchar(100) DEFAULT NULL COMMENT '填表部门',
  `data_audit_unit` varchar(100) DEFAULT NULL COMMENT '数据审核单位',
  `modification_notes` text COMMENT '修改说明',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  CONSTRAINT `msds_other_info_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='其他信息表';

-- ----------------------------
-- Records of msds_other_info
-- ----------------------------

-- ----------------------------
-- Table structure for msds_physical_chemical
-- ----------------------------
DROP TABLE IF EXISTS `msds_physical_chemical`;
CREATE TABLE `msds_physical_chemical` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(20) NOT NULL COMMENT '关联MSDS主表ID',
  `appearance` varchar(255) DEFAULT NULL COMMENT '外观与性状',
  `melting_point` varchar(50) DEFAULT NULL COMMENT '熔点(℃)',
  `boiling_point` varchar(50) DEFAULT NULL COMMENT '沸点(℃)',
  `relative_density` varchar(50) DEFAULT NULL COMMENT '相对密度(水=1)',
  `vapor_density` varchar(50) DEFAULT NULL COMMENT '蒸气密度(空气=1)',
  `vapor_pressure` varchar(50) DEFAULT NULL COMMENT '蒸气压(kPa)',
  `solubility` text COMMENT '溶解性',
  `pH_value` varchar(20) DEFAULT NULL COMMENT 'pH值',
  `flash_point` varchar(50) DEFAULT NULL COMMENT '闪点',
  `ignition_temperature` varchar(50) DEFAULT NULL COMMENT '引燃温度',
  `explosive_limit` text COMMENT '爆炸极限',
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
  `regulatory_info` text COMMENT '法规信息',
  `domestic_regulations` text COMMENT '国内法规',
  `international_regulations` text COMMENT '国际法规',
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
  `incompatible_substances` text COMMENT '禁配物',
  `conditions_to_avoid` text COMMENT '避免接触的条件',
  `polymerization_hazard` text COMMENT '聚合危害',
  `decomposition_products` text COMMENT '分解产物',
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
  `subacute_chronic` text COMMENT '亚急性和慢性毒性',
  `irritation` text COMMENT '刺激性',
  `sensitization` text COMMENT '致敏性',
  `mutagenicity` text COMMENT '致突变性',
  `teratogenicity` text COMMENT '致畸性',
  `carcinogenicity` text COMMENT '致癌性',
  `other_toxicity` text COMMENT '其他毒理学资料',
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
  `packaging_marks` text COMMENT '包装标志',
  `packaging_class` varchar(50) DEFAULT NULL COMMENT '包装类别',
  `packaging_method` text COMMENT '包装方法',
  `transportation_precautions` text COMMENT '运输注意事项',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  KEY `idx_un_number` (`un_number`),
  CONSTRAINT `msds_transportation_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='运输信息表';

-- ----------------------------
-- Records of msds_transportation
-- ----------------------------
