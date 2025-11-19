/*
 Navicat Premium Data Transfer

 Source Server         : dockermsds_3306
 Source Server Type    : MySQL
 Source Server Version : 80042
 Source Host           : localhost:3306
 Source Schema         : msds_dev

 Target Server Type    : MySQL
 Target Server Version : 80042
 File Encoding         : 65001

 Date: 31/10/2025 15:48:20
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for chemical_category
-- ----------------------------
DROP TABLE IF EXISTS `chemical_category`;
CREATE TABLE `chemical_category`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `category_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类代码',
  `category_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类名称',
  `parent_id` int(0) NULL DEFAULT NULL COMMENT '父分类ID',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '分类描述',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '是否有效',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `category_code`(`category_code`) USING BTREE,
  INDEX `idx_parent_id`(`parent_id`) USING BTREE,
  INDEX `idx_category_code`(`category_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '化学品分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of chemical_category
-- ----------------------------
INSERT INTO `chemical_category` VALUES (1, 'INORGANIC', '无机化学品', NULL, '无机化合物', 1, '2025-07-02 06:15:14');
INSERT INTO `chemical_category` VALUES (2, 'ORGANIC', '有机化学品', NULL, '有机化合物', 1, '2025-07-02 06:15:14');
INSERT INTO `chemical_category` VALUES (3, 'POLYMER', '高分子材料', NULL, '聚合物及其制品', 1, '2025-07-02 06:15:14');
INSERT INTO `chemical_category` VALUES (4, 'MIXTURE', '混合物', NULL, '多种化学物质的混合物', 1, '2025-07-02 06:15:14');
INSERT INTO `chemical_category` VALUES (5, 'PREPARATION', '制剂', NULL, '含有添加剂的化学制品', 1, '2025-07-02 06:15:14');

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '代码生成业务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint(0) NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int(0) NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ghs_hazard_class
-- ----------------------------
DROP TABLE IF EXISTS `ghs_hazard_class`;
CREATE TABLE `ghs_hazard_class`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `class_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '危险类别代码',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '危险类别名称',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '危险类别',
  `pictogram` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '象形图代码',
  `signal_word` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '警示词',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '描述',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '是否有效',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `class_code`(`class_code`) USING BTREE,
  INDEX `idx_class_code`(`class_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'GHS危险性分类标准表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ghs_hazard_class
-- ----------------------------
INSERT INTO `ghs_hazard_class` VALUES (1, 'FLAM_LIQ_1', '易燃液体', '类别1', 'GHS02', 'DANGER', '闪点＜23℃且初沸点≤35℃', 1);
INSERT INTO `ghs_hazard_class` VALUES (2, 'FLAM_LIQ_2', '易燃液体', '类别2', 'GHS02', 'DANGER', '闪点＜23℃且初沸点＞35℃', 1);
INSERT INTO `ghs_hazard_class` VALUES (3, 'FLAM_LIQ_3', '易燃液体', '类别3', 'GHS02', 'WARNING', '闪点≥23℃且≤60℃', 1);
INSERT INTO `ghs_hazard_class` VALUES (4, 'ACUTE_TOX_1', '急性毒性', '类别1', 'GHS06', 'DANGER', '经口LD50≤5mg/kg', 1);
INSERT INTO `ghs_hazard_class` VALUES (5, 'ACUTE_TOX_2', '急性毒性', '类别2', 'GHS06', 'DANGER', '经口LD50＞5且≤50mg/kg', 1);
INSERT INTO `ghs_hazard_class` VALUES (6, 'ACUTE_TOX_3', '急性毒性', '类别3', 'GHS06', 'DANGER', '经口LD50＞50且≤300mg/kg', 1);
INSERT INTO `ghs_hazard_class` VALUES (7, 'ACUTE_TOX_4', '急性毒性', '类别4', 'GHS07', 'WARNING', '经口LD50＞300且≤2000mg/kg', 1);
INSERT INTO `ghs_hazard_class` VALUES (8, 'SKIN_CORR_1', '皮肤腐蚀', '类别1', 'GHS05', 'DANGER', '造成皮肤腐蚀', 1);
INSERT INTO `ghs_hazard_class` VALUES (9, 'EYE_IRR_2', '眼刺激', '类别2', 'GHS07', 'WARNING', '造成严重眼刺激', 1);
INSERT INTO `ghs_hazard_class` VALUES (10, 'CARC_1A', '致癌性', '类别1A', 'GHS08', 'DANGER', '已知对人类致癌', 1);
INSERT INTO `ghs_hazard_class` VALUES (11, 'CARC_1B', '致癌性', '类别1B', 'GHS08', 'DANGER', '可能对人类致癌', 1);
INSERT INTO `ghs_hazard_class` VALUES (12, 'AQUATIC_1', '水环境危害', '急性类别1', 'GHS09', 'WARNING', '对水生生物毒性极高', 1);

-- ----------------------------
-- Table structure for msds_approval_workflow
-- ----------------------------
DROP TABLE IF EXISTS `msds_approval_workflow`;
CREATE TABLE `msds_approval_workflow`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(0) NOT NULL COMMENT '关联MSDS主表ID',
  `step_no` int(0) NOT NULL COMMENT '审批步骤序号',
  `step_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '审批步骤名称',
  `approver` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审批人',
  `approval_status` enum('pending','approved','rejected','skipped') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'pending' COMMENT '审批状态',
  `approval_date` datetime(0) NULL DEFAULT NULL COMMENT '审批时间',
  `approval_comments` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '审批意见',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_msds_id`(`msds_id`) USING BTREE,
  INDEX `idx_step_no`(`step_no`) USING BTREE,
  INDEX `idx_approval_status`(`approval_status`) USING BTREE,
  CONSTRAINT `msds_approval_workflow_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'MSDS审批流程表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for msds_component
-- ----------------------------
DROP TABLE IF EXISTS `msds_component`;
CREATE TABLE `msds_component`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(0) NOT NULL COMMENT '关联MSDS主表ID',
  `component_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '成分名称',
  `component_english_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '成分英文名',
  `component_content` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '成分含量/浓度',
  `content_min` decimal(10, 4) NULL DEFAULT NULL COMMENT '含量下限(%)',
  `content_max` decimal(10, 4) NULL DEFAULT NULL COMMENT '含量上限(%)',
  `cas_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'CAS登记号',
  `ec_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'EC号',
  `molecular_formula` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '分子式',
  `molecular_weight` decimal(10, 2) NULL DEFAULT NULL COMMENT '分子量',
  `is_hazardous` tinyint(1) NULL DEFAULT 0 COMMENT '是否为危险成分(1:是,0:否)',
  `hazard_level` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '危险等级',
  `component_function` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '成分功能',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_msds_id`(`msds_id`) USING BTREE,
  INDEX `idx_component_name`(`component_name`) USING BTREE,
  INDEX `idx_cas_number`(`cas_number`) USING BTREE,
  CONSTRAINT `msds_component_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 68 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '成分/组成信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_component
-- ----------------------------
INSERT INTO `msds_component` VALUES (65, 165, '杀那脱；敌稻瘟', NULL, '100%', NULL, NULL, '115-31-1', NULL, NULL, NULL, 0, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_component` VALUES (66, 166, '尼古丁；烟碱', NULL, '100%', NULL, NULL, '54-11-5', NULL, NULL, NULL, 0, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_component` VALUES (67, 167, '0，0-二乙基硫代磷酰氯', NULL, '100%', NULL, NULL, '2524-04-1', NULL, NULL, NULL, 0, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_component` VALUES (68, 168, '1-(2-过氧化乙基己醇-1,3-二甲基丁基过氧化新戊酸酯', NULL, '≤52.0%', NULL, NULL, '228415-62-1', NULL, NULL, NULL, 0, NULL, NULL, '', NULL, '', NULL);

-- ----------------------------
-- Table structure for msds_disposal
-- ----------------------------
DROP TABLE IF EXISTS `msds_disposal`;
CREATE TABLE `msds_disposal`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(0) NOT NULL COMMENT '关联MSDS主表ID',
  `waste_properties` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '废弃物性质',
  `disposal_method` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '废弃处置方法',
  `disposal_precautions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '废弃注意事项',
  `disposal_regulations` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '废弃处置相关法规',
  `container_disposal` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '包装容器的处置',
  `recommended_disposal` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '推荐的处置方法',
  `prohibited_disposal` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '禁止的处置方法',
  `neutralization_method` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '中和处理方法',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id`) USING BTREE,
  CONSTRAINT `msds_disposal_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 39 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '废弃处置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_disposal
-- ----------------------------
INSERT INTO `msds_disposal` VALUES (36, 165, '处置前应参阅国家和地方有关法规。建议用焚烧法处置。', '无资料', NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_disposal` VALUES (37, 166, '处置前应参阅国家和地方有关法规。建议用焚烧法处置。', '无资料', NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_disposal` VALUES (38, 167, '处置前应参阅国家和地方有关法规。建议用焚烧法处置。', '无资料', NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_disposal` VALUES (39, 168, '无资料', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);

-- ----------------------------
-- Table structure for msds_ecological
-- ----------------------------
DROP TABLE IF EXISTS `msds_ecological`;
CREATE TABLE `msds_ecological`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(0) NOT NULL COMMENT '关联MSDS主表ID',
  `ecological_toxicity` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '生态毒性',
  `fish_toxicity` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '鱼类毒性',
  `invertebrate_toxicity` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '无脊椎动物毒性',
  `algae_toxicity` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '藻类毒性',
  `bacteria_toxicity` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '细菌毒性',
  `biodegradability` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '生物降解性',
  `biodegradation_rate` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生物降解速率',
  `non_biodegradability` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '非生物降解性',
  `photodegradation` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '光降解',
  `hydrolysis` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '水解',
  `bioaccumulation` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '生物富集或生物积累性',
  `bioconcentration_factor` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生物富集因子',
  `mobility_in_soil` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '土壤中迁移性',
  `other_environmental_effects` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '其它有害作用',
  `ozone_depletion_potential` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '臭氧消耗潜能值',
  `global_warming_potential` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '全球变暖潜能值',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id`) USING BTREE,
  CONSTRAINT `msds_ecological_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '生态学资料表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_ecological
-- ----------------------------
INSERT INTO `msds_ecological` VALUES (33, 167, '无资料', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-23 15:09:10', '', NULL);
INSERT INTO `msds_ecological` VALUES (34, 168, '无资料', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-23 15:09:24', '', NULL);

-- ----------------------------
-- Table structure for msds_exposure_control
-- ----------------------------
DROP TABLE IF EXISTS `msds_exposure_control`;
CREATE TABLE `msds_exposure_control`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(0) NOT NULL COMMENT '关联MSDS主表ID',
  `occupational_exposure_limit` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '职业接触限值',
  `china_mac` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '中国MAC值(mg/m³)',
  `usa_tlv_twa` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '美国TLV-TWA值(mg/m³)',
  `usa_tlv_stel` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '美国TLV-STEL值(mg/m³)',
  `former_soviet_mac` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '前苏联MAC值(mg/m³)',
  `tlv_tn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'TLV-TN值(mg/m³)',
  `tlv_wn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'TLV-WN值(mg/m³)',
  `monitoring_method` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '监测方法',
  `engineering_controls` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '工程控制措施',
  `respiratory_protection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '呼吸系统防护',
  `eye_protection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '眼睛防护',
  `body_protection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '身体防护',
  `hand_protection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '手部防护',
  `other_protection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '其他防护措施',
  `hygiene_measures` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '卫生措施',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id`) USING BTREE,
  CONSTRAINT `msds_exposure_control_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '接触控制/个体防护表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_exposure_control
-- ----------------------------
INSERT INTO `msds_exposure_control` VALUES (34, 165, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '生产过程密闭，加强通风。', '生产操作或农业使用时，佩戴防毒口罩。空气中浓度超标时，建议佩戴防毒面具。', '高浓度环境中，戴化学安全防护眼镜。', '穿工作服。', '戴防护手套。', NULL, NULL, NULL, '2025-10-22 06:29:21', '', NULL);
INSERT INTO `msds_exposure_control` VALUES (35, 166, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '严加密闭，提供充分的局部排风。', '空气中浓度超标时，佩带防毒面具。紧急事态抢救或逃生时，佩带自给式呼吸器。', '一般不需特殊防护。必要时戴安全防护眼镜。', '穿相应的防护服。', '戴防化学品手套。', NULL, NULL, NULL, '2025-10-22 06:32:14', '', NULL);
INSERT INTO `msds_exposure_control` VALUES (36, 167, NULL, '未制定标准', NULL, NULL, NULL, NULL, NULL, NULL, '密闭操作，局部排风。尽可能机械化、自动化。', '可能接触其蒸气时，必须佩带防毒面具。紧急事态抢救或逃生时，建议佩带自给式呼吸器。', '戴化学安全防护眼镜。', '穿工作服(防腐材料制作)。', '戴橡皮手套。', NULL, NULL, NULL, '2025-10-23 15:09:10', '', NULL);
INSERT INTO `msds_exposure_control` VALUES (37, 168, NULL, '无资料', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '佩戴化学护目镜（符合欧盟EN166或美国NIOSH标准）。', '穿阻燃防静电防护服和抗静电的防护靴。', NULL, NULL, NULL, NULL, '2025-10-23 15:09:24', '', NULL);

-- ----------------------------
-- Table structure for msds_fire_fighting
-- ----------------------------
DROP TABLE IF EXISTS `msds_fire_fighting`;
CREATE TABLE `msds_fire_fighting`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(0) NOT NULL COMMENT '关联MSDS主表ID',
  `hazard_characteristics` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '危险特性',
  `harmful_combustion_products` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '有害燃烧产物',
  `suitable_extinguishing_media` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '适宜的灭火介质',
  `unsuitable_extinguishing_media` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '不适宜的灭火介质',
  `fire_fighting_equipment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '消防设备和防护装备',
  `fire_fighting_procedures` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '特殊消防程序',
  `flash_point` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '闪点',
  `autoignition_temperature` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '自燃温度',
  `flammability_limits` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '燃烧性/爆炸极限',
  `fire_risk_classification` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '建规火险分级',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id`) USING BTREE,
  CONSTRAINT `msds_fire_fighting_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '消防措施表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_fire_fighting
-- ----------------------------
INSERT INTO `msds_fire_fighting` VALUES (34, 165, '遇明火、高热可燃。与氧化剂能发生强烈反应。受热分解，放出有毒的烟气。', '-氧化碳、二氧化碳、氮氧化物、氧化硫。', '泡沫、干粉、砂土。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-22 06:29:21', '', NULL);
INSERT INTO `msds_fire_fighting` VALUES (35, 166, '遇明火、高热可燃。与氧化剂可发生反应。受高热分解放出有毒的气体。', '一氧化碳、二氧化碳、氧化氮。', '雾状水、泡沫、抗溶性泡沫、干粉、二氧化碳、砂土。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-22 06:32:14', '', NULL);
INSERT INTO `msds_fire_fighting` VALUES (36, 167, '蚀性。', '一氧化碳、氧化硫、氯化氢、氧化磷。', '泡沫、二氧化碳、砂土、干粉。禁止用水。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-23 15:09:10', '', NULL);
INSERT INTO `msds_fire_fighting` VALUES (37, 168, '接触火焰可能会产生膨胀或爆炸性分解。', '无资料', '合适的灭火介质：使用适合火灾类型的合适的灭火剂。不合适的灭火介质：无特别说明。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-23 15:09:24', '', NULL);

-- ----------------------------
-- Table structure for msds_first_aid
-- ----------------------------
DROP TABLE IF EXISTS `msds_first_aid`;
CREATE TABLE `msds_first_aid`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(0) NOT NULL COMMENT '关联MSDS主表ID',
  `skin_contact` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '皮肤接触处理措施',
  `eye_contact` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '眼睛接触处理措施',
  `inhalation` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '吸入处理措施',
  `ingestion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '食入处理措施',
  `general_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '一般注意事项',
  `symptoms_effects` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '可能出现的症状和健康影响',
  `immediate_medical_attention` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '需要立即就医的情况',
  `antidote_treatment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '解毒剂及治疗方法',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id`) USING BTREE,
  CONSTRAINT `msds_first_aid_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '急救措施表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_first_aid
-- ----------------------------
INSERT INTO `msds_first_aid` VALUES (46, 165, '脱去污染的衣物，用肥皂水及清水彻底冲洗。就医。', '拉开眼睑，用流动清水冲洗15分钟。就医。', '脱离现场至空气新鲜处。呼吸困难时给输氧。呼吸停止时，立即进行人工呼吸。就医。', '误服者，饮适量温水，催吐。就医。', NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_first_aid` VALUES (47, 166, '立即脱去污染的衣着，用肥皂水及流动清水彻底冲洗污染的皮肤、头发、指甲等。就医。', '立即提起眼睑，用流动清水冲洗10分钟或用2％碳酸氢钠溶液冲洗。', '迅速脱离现场至空气新鲜处。呼吸困难时给输氧。呼吸停止时，立即进行人工呼吸。就医。', '误服者给饮大量温水，催吐，可用温水或1：5000高锰酸钾液彻底洗胃。就医。', NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_first_aid` VALUES (48, 167, '脱去污染的衣着，用肥皂水及清水彻底冲洗。若有灼伤，就医治疗。', '立即提起眼睑，用流动清水或生理盐水冲洗至少15分钟。就医。', '迅速脱离现场至空气新鲜处。保持呼吸道通畅。必要时进行人工呼吸。就医。', '患者清醒时立即漱口，给饮牛奶或蛋清。就医。', NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_first_aid` VALUES (49, 168, '脱去污染的衣着，用大量流动清水彻底冲洗。就医。', '立即翻开上下眼睑，用流动清水或生理盐水冲洗。就医。', '迅速脱离现场至空气新鲜处。保持呼吸道通畅。呼吸困难时给输氧。呼吸停止时，立即进 行人工呼吸。就医。', '误服者立即漱口，给饮牛奶或蛋清。就医。', NULL, NULL, NULL, NULL, '', NULL, '', NULL);

-- ----------------------------
-- Table structure for msds_ghs_hazard
-- ----------------------------
DROP TABLE IF EXISTS `msds_ghs_hazard`;
CREATE TABLE `msds_ghs_hazard`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(0) NOT NULL COMMENT '关联MSDS主表ID',
  `ghs_class_id` int(0) NOT NULL COMMENT '关联GHS危险类别ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_ghs`(`msds_id`, `ghs_class_id`) USING BTREE,
  INDEX `ghs_class_id`(`ghs_class_id`) USING BTREE,
  CONSTRAINT `msds_ghs_hazard_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `msds_ghs_hazard_ibfk_2` FOREIGN KEY (`ghs_class_id`) REFERENCES `ghs_hazard_class` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'MSDS-GHS危险性分类关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for msds_handling_storage
-- ----------------------------
DROP TABLE IF EXISTS `msds_handling_storage`;
CREATE TABLE `msds_handling_storage`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(0) NOT NULL COMMENT '关联MSDS主表ID',
  `handling_precautions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '操作注意事项',
  `storage_precautions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '储存注意事项',
  `optimal_temperature` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '最佳储存温度',
  `temperature_range` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '储存温度范围',
  `humidity_requirements` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '湿度要求',
  `storage_container` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '储存容器要求',
  `incompatible_materials` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '不相容的物质',
  `storage_area_requirements` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '储存区域要求',
  `shelf_life` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '保质期',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id`) USING BTREE,
  CONSTRAINT `msds_handling_storage_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作处置与储存表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_handling_storage
-- ----------------------------
INSERT INTO `msds_handling_storage` VALUES (34, 165, '无资料 储存于阴凉、通风仓间内。远离火种、热源。专人保管。保持容器密封。防潮、防晒。应 与氧化剂、碱类、食用化工原料分开存放。不能与粮食、食物、种子、饲料、各种日用 品混装、混运。操作现场不得吸烟、饮水、进食。搬运时要轻装轻卸，防止包装及容器损', '坏。分装和搬运作业要注意个人防护。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-22 06:29:21', '', NULL);
INSERT INTO `msds_handling_storage` VALUES (35, 166, '无资料 储存于阴凉、通风仓间内。远离火种、热源。防止阳光直射。保持容器密封。应与氧化剂、', '酸类、食用化工原料分开存放；不可混储混运。搬运时要轻装轻卸，防止包装及容器损坏。 分装和搬运作业要注意个人防护。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-22 06:32:14', '', NULL);
INSERT INTO `msds_handling_storage` VALUES (36, 167, '无资料', '储存于阴凉、通风仓间内。远离火种、热源。防止阳光直射。保持容器密封。应与氧化剂、 碱类、食用化工原料分开存放。分装和搬运作业要注意个人防护。搬运时要轻装轻卸，防止 包装及容器损坏。运输按规定路线行驶，勿在居民区和人口稠密区停留。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-23 15:09:10', '', NULL);
INSERT INTO `msds_handling_storage` VALUES (37, 168, NULL, '火花、明火和热表面。采取措施防止静电积累。 保持容器密闭。储存在干燥、阴凉和通风处。远离热源、火花、明火和热表面。存储于远 离不相容材料和食品容器的地方。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-23 15:09:24', '', NULL);

-- ----------------------------
-- Table structure for msds_hazard
-- ----------------------------
DROP TABLE IF EXISTS `msds_hazard`;
CREATE TABLE `msds_hazard`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(0) NOT NULL COMMENT '关联MSDS主表ID',
  `emergency_overview` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '紧急情况概述',
  `physical_state` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物理状态',
  `odor` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '气味',
  `color` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '颜色',
  `warning_word` enum('danger','warning') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '警示词(danger:危险,warning:警告)',
  `hazard_category` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '危险性类别',
  `exposure_routes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '侵入途径',
  `health_hazards` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '健康危害',
  `environmental_hazards` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '环境危害',
  `fire_explosion_hazards` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '燃爆危险',
  `hazard_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '危险性说明',
  `prevention_measures` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '预防措施',
  `response_measures` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '响应措施',
  `storage_measures` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '储存措施',
  `disposal_measures` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '废弃处置措施',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id`) USING BTREE,
  CONSTRAINT `msds_hazard_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 68 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '危险性概述表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_hazard
-- ----------------------------
INSERT INTO `msds_hazard` VALUES (65, 165, NULL, NULL, NULL, NULL, NULL, '第6.1类毒害品', '吸入 食入 经皮吸收 本品为低毒类杀菌剂。吸入、摄入或经皮肤吸收后会中毒。对眼睛、皮肤、粘膜和上呼吸', '道有刺激作用。受热分解释出有毒的氮氧化物和氧化硫烟雾。', '无资料', '本品可燃、具有刺激性', NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_hazard` VALUES (66, 166, NULL, NULL, NULL, NULL, NULL, '第6.1类 毒害品', '吸入 食入 经皮吸收 本品属神经毒，作用于植物神经、中枢神经及运动神经末梢，先兴奋，后抑制。能经消化道、 呼吸道和皮肤很快吸收，引起中毒。急性中毒表现有头痛、头晕、无力、恶心、呕吐、腹痛、', '腹泻、心律紊乱、心前区痛、呼吸困难、大汗、流涎、瞳孔缩小等。口服胃肠道有烧灼感。重 者尚有肌束震颤、进行性肌无力、血压降低、神志不清、谵妄、惊厥、高度呼吸困难。死于呼 吸和心脏麻痹。对眼睛、皮肤有刺激性。', '无资料', '本品可燃、剧毒、具有刺激性', NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_hazard` VALUES (67, 167, NULL, NULL, NULL, NULL, NULL, '第8.1类 酸性腐蚀品', '吸入 食入 经皮吸收', '水肿，化学性肺炎或肺水肿而致死。接触后出现烧灼感、咳嗽、喘息、喉炎、气短、头痛、恶\n心和呕吐。', '无资料', '本品腐蚀性、刺激性', NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_hazard` VALUES (68, 168, NULL, NULL, NULL, NULL, NULL, '有机过氧化物，D型。', '吸入、食入、皮肤接触、眼睛接触\n吸入该物质可能会引起对健康有害的影响或呼吸道不适。意外食入', NULL, '无资料', '无资料', NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);

-- ----------------------------
-- Table structure for msds_leak_response
-- ----------------------------
DROP TABLE IF EXISTS `msds_leak_response`;
CREATE TABLE `msds_leak_response`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(0) NOT NULL COMMENT '关联MSDS主表ID',
  `personal_precautions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '个人防护措施',
  `environmental_precautions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '环境保护措施',
  `containment_cleanup` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '泄漏化学品的收容、清除方法',
  `emergency_procedures` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '应急处理程序',
  `elimination_methods` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '消除方法',
  `equipment_materials` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '清理时使用的器材',
  `prevent_secondary_hazards` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '防止发生次生危害的预防措施',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id`) USING BTREE,
  CONSTRAINT `msds_leak_response_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '泄漏应急处理表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_leak_response
-- ----------------------------
INSERT INTO `msds_leak_response` VALUES (34, 165, NULL, NULL, NULL, '收容，然后收集、转移、回收或无害处理后废弃。', NULL, NULL, NULL, NULL, '2025-10-22 06:29:21', '', NULL);
INSERT INTO `msds_leak_response` VALUES (35, 166, NULL, NULL, NULL, '用沙土或其它不燃性吸附剂混合吸收，然后收集运至废物处理场所处置。也可以用大量水冲 洗，经稀释的洗水放入废水系统。如大量泄漏，利用围堤收容，然后收集、转移、回收或无 害处理后废弃。', NULL, NULL, NULL, NULL, '2025-10-22 06:32:14', '', NULL);
INSERT INTO `msds_leak_response` VALUES (36, 167, NULL, NULL, NULL, '疏散泄漏污染区人员至安全区，禁止无关人员进入污染区，切断火源。建议应急处理人员戴 正压自给式呼吸器，穿厂商特别推荐的化学防护服(完全隔离)。不要直接接触泄漏物，在确 应急处理： 保安全情况下堵漏。喷雾状水，减少蒸发。用沙土、蛭石或其它惰性材料吸收，然后收集运 至废物处理场所处置。也可以用不燃性分散剂制成的乳液刷洗，经稀释的洗水放入废水系统。 如大量泄漏，利用围堤收容，然后收集、转移、回收或无害处理后废弃。', NULL, NULL, NULL, NULL, '2025-10-23 15:09:10', '', NULL);
INSERT INTO `msds_leak_response` VALUES (37, 168, NULL, NULL, NULL, '保证充分的通风。清除所有点火源。迅速将人员撤离到安全区域，远离泄漏区域并处于上 采取措施防止进一步的泄漏或溢出。避免排放到周围环境中。少量泄漏时，可采用干砂或 惰性吸附材料吸收泄漏物，大量泄漏时需筑堤控制。附着物或收集物应存放在合适的密闭 容器中，并根据当地相关法律法规废弃处置。清除所有点火源，并采用防火花工具和防暴', NULL, NULL, NULL, NULL, '2025-10-23 15:09:24', '', NULL);

-- ----------------------------
-- Table structure for msds_main
-- ----------------------------
DROP TABLE IF EXISTS `msds_main`;
CREATE TABLE `msds_main`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'MSDS唯一标识',
  `cas_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'CAS登记号',
  `msds_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'MSDS编号',
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '化学品中文名',
  `product_alias` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '化学品别名',
  `product_english_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '化学品英文名',
  `category_id` int(0) NULL DEFAULT NULL COMMENT '化学品分类ID',
  `company_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '企业名称',
  `company_address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '企业地址',
  `zip_code` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮编',
  `fax_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '传真号码',
  `contact_phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '电子邮件地址',
  `emergency_phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '企业应急电话',
  `recommended_usage` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '产品推荐用途',
  `restricted_usage` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '产品限制用途',
  `version` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1.0' COMMENT 'MSDS版本号',
  `revision_date` date NULL DEFAULT NULL COMMENT '修订日期',
  `effective_date` date NULL DEFAULT NULL COMMENT '生效日期',
  `status` enum('draft','pending','approved','archived') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'draft' COMMENT '状态',
  `approver` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审批人',
  `approval_date` date NULL DEFAULT NULL COMMENT '审批日期',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '是否有效(1:有效,0:无效)',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `created_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `updated_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  `remark` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `cas_number`(`cas_number`) USING BTREE,
  UNIQUE INDEX `msds_code`(`msds_code`) USING BTREE,
  INDEX `category_id`(`category_id`) USING BTREE,
  INDEX `idx_msds_code`(`msds_code`) USING BTREE,
  INDEX `idx_product_name`(`product_name`) USING BTREE,
  INDEX `idx_company_name`(`company_name`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE,
  CONSTRAINT `msds_main_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `chemical_category` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 168 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'MSDS主信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_main
-- ----------------------------
INSERT INTO `msds_main` VALUES (165, '115-31-1', 'MSDS#2743', '(1R,2R,4R)-冰片-2-硫氰基醋酸酯', '敌稻瘟', '1,7,7-trimethylbicyclo(2,2,1)hept-2-yl thiocyanatoacetate', NULL, '化学品供应商', '化学品生产地址', NULL, '400-123-4568', '400-123-4567', 'contact@chemical.com', '400-999-8888', NULL, NULL, NULL, NULL, NULL, 'approved', NULL, NULL, 1, '2025-10-22 06:29:21', '2025-10-22 06:29:21', NULL, NULL, NULL);
INSERT INTO `msds_main` VALUES (166, '54-11-5', 'MSDS#1235', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', '烟碱；尼古丁；1-甲基-2-(3-吡啶', 'Nicotine', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'approved', NULL, NULL, 1, '2025-10-22 06:32:14', '2025-10-22 06:32:14', NULL, NULL, NULL);
INSERT INTO `msds_main` VALUES (167, '2524-04-1', 'MSDS#1083', '0，0-二乙基硫代磷酰氯', '无资料', '0，0-Diethylthiophosphoryl chloride', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'approved', NULL, NULL, 1, '2025-10-23 15:09:10', '2025-10-23 15:09:10', NULL, NULL, NULL);
INSERT INTO `msds_main` VALUES (168, '228415-62-1', '无资料', '1-(2-过氧化乙基己醇-1,3-二甲', '无资料', '1-(2-ethylhexanoylperoxy)-1,3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'approved', NULL, NULL, 1, '2025-10-23 15:09:24', '2025-10-23 15:09:24', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for msds_other_info
-- ----------------------------
DROP TABLE IF EXISTS `msds_other_info`;
CREATE TABLE `msds_other_info`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(0) NOT NULL COMMENT '关联MSDS主表ID',
  `references` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '参考文献',
  `data_sources` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '数据来源',
  `form_fill_time` date NULL DEFAULT NULL COMMENT '填表时间',
  `form_fill_department` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '填表部门',
  `form_fill_person` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '填表人',
  `data_audit_unit` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '数据审核单位',
  `data_audit_person` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '数据审核人',
  `technical_review_person` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '技术审查人',
  `modification_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '修改说明',
  `training_requirements` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '培训要求',
  `additional_information` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '其他信息',
  `disclaimer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '免责声明',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id`) USING BTREE,
  CONSTRAINT `msds_other_info_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '其他信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for msds_physical_chemical
-- ----------------------------
DROP TABLE IF EXISTS `msds_physical_chemical`;
CREATE TABLE `msds_physical_chemical`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(0) NOT NULL COMMENT '关联MSDS主表ID',
  `appearance` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '外观与性状',
  `odor` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '气味',
  `odor_threshold` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '气味阈值',
  `melting_point` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '熔点(℃)',
  `boiling_point` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '沸点(℃)',
  `relative_density` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '相对密度(水=1)',
  `vapor_density` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '蒸气密度(空气=1)',
  `vapor_pressure` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '蒸气压(kPa)',
  `vapor_pressure_temp` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '蒸气压测定温度(℃)',
  `solubility` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '溶解性',
  `water_solubility` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '水中溶解度',
  `pH_value` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'pH值',
  `ph_concentration` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'pH值浓度条件',
  `flash_point` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '闪点(℃)',
  `ignition_temperature` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '引燃温度(℃)',
  `explosive_limit_lower` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '爆炸下限(%)',
  `explosive_limit_upper` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '爆炸上限(%)',
  `viscosity` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '粘度',
  `partition_coefficient` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '分配系数(正辛醇/水)',
  `decomposition_temperature` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '分解温度(℃)',
  `molecular_formula` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '分子式',
  `main_components` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '主要成分',
  `critical_temperature` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '临界温度(℃)',
  `autoignition_temperature` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '自燃温度',
  `flammability` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '燃烧性',
  `molecular_weight` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '分子量',
  `heat_of_combustion` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '燃烧热(kJ/mol)',
  `critical_pressure` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '临界压力(MPa)',
  `main_usage` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '主要用途',
  `other_properties` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '其它理化性质',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id`) USING BTREE,
  CONSTRAINT `msds_physical_chemical_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '理化特性表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_physical_chemical
-- ----------------------------
INSERT INTO `msds_physical_chemical` VALUES (13, 167, '无色透明液体。', NULL, NULL, '-75', '85', '1.20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '110', NULL, NULL, NULL, NULL, NULL, NULL, 'C4H10C', NULL, NULL, '引燃温度(℃)：无资料', '可燃', '188.61', NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_physical_chemical` VALUES (14, 168, NULL, NULL, NULL, '无资料', '>35', '无资料', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '无资料', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '无资料', NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);

-- ----------------------------
-- Table structure for msds_regulatory
-- ----------------------------
DROP TABLE IF EXISTS `msds_regulatory`;
CREATE TABLE `msds_regulatory`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(0) NOT NULL COMMENT '关联MSDS主表ID',
  `regulatory_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '法规信息综述',
  `domestic_regulations` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '国内法规',
  `international_regulations` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '国际法规',
  `china_dangerous_chemicals` tinyint(1) NULL DEFAULT 0 COMMENT '中国危险化学品目录(1:是,0:否)',
  `china_controlled_chemicals` tinyint(1) NULL DEFAULT 0 COMMENT '中国管制化学品(1:是,0:否)',
  `reach_registration` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT 'REACH注册情况',
  `tsca_inventory` tinyint(1) NULL DEFAULT 0 COMMENT 'TSCA清单(1:在列,0:不在列)',
  `einecs_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'EINECS号',
  `prohibited_restricted` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '禁用/限用情况',
  `special_provisions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '特殊规定',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id`) USING BTREE,
  CONSTRAINT `msds_regulatory_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '法规信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_regulatory
-- ----------------------------
INSERT INTO `msds_regulatory` VALUES (36, 167, '无资料', NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_regulatory` VALUES (37, 168, '无资料', NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, '', NULL, '', NULL);

-- ----------------------------
-- Table structure for msds_stability_reactivity
-- ----------------------------
DROP TABLE IF EXISTS `msds_stability_reactivity`;
CREATE TABLE `msds_stability_reactivity`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(0) NOT NULL COMMENT '关联MSDS主表ID',
  `stability` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '稳定性',
  `reactivity` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '反应性',
  `incompatible_substances` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '禁配物',
  `conditions_to_avoid` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '避免接触的条件',
  `hazardous_reactions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '可能的危险反应',
  `polymerization_hazard` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '聚合危害',
  `polymerization_conditions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '聚合反应条件',
  `decomposition_products` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '分解产物',
  `decomposition_conditions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '分解条件',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id`) USING BTREE,
  CONSTRAINT `msds_stability_reactivity_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '稳定性和反应性表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_stability_reactivity
-- ----------------------------
INSERT INTO `msds_stability_reactivity` VALUES (34, 165, '稳定', NULL, '强氧化剂、强碱。', '无资料', NULL, '不能出现', NULL, '无资料', NULL, NULL, '2025-10-22 06:29:21', '', NULL);
INSERT INTO `msds_stability_reactivity` VALUES (35, 166, '稳定', NULL, '强氧化剂。', '无资料', NULL, '不能出现', NULL, '无资料', NULL, NULL, '2025-10-22 06:32:14', '', NULL);
INSERT INTO `msds_stability_reactivity` VALUES (36, 167, '稳定', NULL, '强氧化剂、水、强碱。', '无资料', NULL, '不能出现', NULL, '无资料', NULL, NULL, '2025-10-23 15:09:10', '', NULL);
INSERT INTO `msds_stability_reactivity` VALUES (37, 168, '在正确的使用和存储条件下是稳定的。', NULL, '无资料', '不相容物质，热、火焰和火花。', NULL, '无资料', NULL, '在正常的储存和使用条件下，不会产生危险的分解产物。', NULL, NULL, '2025-10-23 15:09:24', '', NULL);

-- ----------------------------
-- Table structure for msds_toxicological
-- ----------------------------
DROP TABLE IF EXISTS `msds_toxicological`;
CREATE TABLE `msds_toxicological`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(0) NOT NULL COMMENT '关联MSDS主表ID',
  `acute_toxicity` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '急性毒性',
  `ld50_oral` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'LD50(经口,大鼠)',
  `ld50_dermal` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'LD50(经皮,兔)',
  `lc50_inhalation` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'LC50(吸入,大鼠)',
  `subacute_chronic` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '亚急性和慢性毒性',
  `skin_irritation` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '皮肤刺激性',
  `eye_irritation` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '眼睛刺激性',
  `respiratory_irritation` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '呼吸道刺激性',
  `sensitization` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '致敏性',
  `mutagenicity` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '致突变性',
  `teratogenicity` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '致畸性',
  `reproductive_toxicity` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '生殖毒性',
  `carcinogenicity` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '致癌性',
  `carcinogen_classification` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '致癌物分类',
  `specific_target_organ` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '特定目标器官毒性',
  `aspiration_hazard` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '吸入危害',
  `other_toxicity` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '其他毒理学资料',
  `rtecs` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'RTECS编号',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id`) USING BTREE,
  CONSTRAINT `msds_toxicological_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 47 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '毒理学资料表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_toxicological
-- ----------------------------
INSERT INTO `msds_toxicological` VALUES (44, 165, 'LD50：1600mg／kg(大鼠经口)；6000mg／kg(兔经皮)LC50：', 'LD50：1600mg／kg(大鼠经口)', '6000mg／kg(兔经皮)', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_toxicological` VALUES (45, 166, '属高毒类LD50：50mg／kg(大鼠经口)；50mg／kg(兔经皮)LC50：', 'LD50：50mg／kg(大鼠经口)', '50mg／kg(兔经皮)', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_toxicological` VALUES (46, 167, 'LD50：1340mg／kg(大鼠经口)LO50：20ppm 4小时(大鼠吸入)', 'LD50：1340mg／kg(大鼠经口)', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_toxicological` VALUES (47, 168, '无资料', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);

-- ----------------------------
-- Table structure for msds_transportation
-- ----------------------------
DROP TABLE IF EXISTS `msds_transportation`;
CREATE TABLE `msds_transportation`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(0) NOT NULL COMMENT '关联MSDS主表ID',
  `dangerous_goods_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '危险货物编号',
  `un_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'UN编号',
  `proper_shipping_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '正确运输名称',
  `transport_hazard_class` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '运输危险类别',
  `packing_group` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '包装类别',
  `packaging_marks` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '包装标志',
  `packaging_method` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '包装方法',
  `marine_pollutant` tinyint(1) NULL DEFAULT 0 COMMENT '海洋污染物(1:是,0:否)',
  `transport_in_bulk` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '散装运输要求',
  `transportation_precautions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '运输注意事项',
  `emergency_response_guide` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '应急响应指南编号',
  `imdg_rule_page` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'IMDG规则页码',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id`) USING BTREE,
  INDEX `idx_un_number`(`un_number`) USING BTREE,
  INDEX `idx_dangerous_goods_number`(`dangerous_goods_number`) USING BTREE,
  CONSTRAINT `msds_transportation_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '运输信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_transportation
-- ----------------------------
INSERT INTO `msds_transportation` VALUES (34, 165, '无资料', '无资料 IMDG规则页码： 无资料', NULL, NULL, '无资料', NULL, '无资料', NULL, NULL, '无资料', NULL, NULL, NULL, '2025-10-22 06:29:21', '', NULL);
INSERT INTO `msds_transportation` VALUES (35, 166, '61868', '1654 IMDG规则页码： 6203', NULL, NULL, NULL, NULL, '无资料', NULL, NULL, '无资料', NULL, NULL, NULL, '2025-10-22 06:32:14', '', NULL);
INSERT INTO `msds_transportation` VALUES (36, 167, '81132', '2751', NULL, NULL, 'Ⅱ', NULL, '无资料', NULL, NULL, '无资料', NULL, NULL, NULL, '2025-10-23 15:09:10', '', NULL);
INSERT INTO `msds_transportation` VALUES (37, 168, '3115', '3115', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-10-23 15:09:24', '', NULL);

-- ----------------------------
-- Table structure for msds_version_history
-- ----------------------------
DROP TABLE IF EXISTS `msds_version_history`;
CREATE TABLE `msds_version_history`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint(0) NOT NULL COMMENT '关联MSDS主表ID',
  `version` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '版本号',
  `change_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '变更描述',
  `change_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '变更原因',
  `changed_sections` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '变更章节',
  `change_date` date NULL DEFAULT NULL COMMENT '变更日期',
  `changed_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '变更人',
  `approved_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审批人',
  `approval_date` date NULL DEFAULT NULL COMMENT '审批日期',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_msds_id`(`msds_id`) USING BTREE,
  INDEX `idx_version`(`version`) USING BTREE,
  INDEX `idx_change_date`(`change_date`) USING BTREE,
  CONSTRAINT `msds_version_history_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'MSDS版本历史表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob NULL COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Blob类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`, `calendar_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '日历信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Cron类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint(0) NOT NULL COMMENT '触发的时间',
  `sched_time` bigint(0) NOT NULL COMMENT '定时器制定的时间',
  `priority` int(0) NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`, `entry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '已触发的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '任务详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`, `lock_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '存储的悲观锁信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '暂停的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint(0) NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint(0) NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`, `instance_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '调度器状态表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint(0) NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint(0) NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint(0) NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '简单触发器的信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int(0) NULL DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int(0) NULL DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint(0) NULL DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint(0) NULL DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '同步机制的行锁表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint(0) NULL DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint(0) NULL DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int(0) NULL DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint(0) NOT NULL COMMENT '开始时间',
  `end_time` bigint(0) NULL DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint(0) NULL DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  INDEX `sched_name`(`sched_name`, `job_name`, `job_group`) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '触发器详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int(0) NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '参数配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2025-06-24 19:45:12', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2025-06-24 19:45:12', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2025-06-24 19:45:12', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2025-06-24 19:45:12', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2025-06-24 19:45:12', '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2025-06-24 19:45:12', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint(0) NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int(0) NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 109 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '部门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '若依科技', 0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-24 19:45:03', '', NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-24 19:45:03', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-24 19:45:03', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-24 19:45:03', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-24 19:45:03', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-24 19:45:03', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-24 19:45:03', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-24 19:45:03', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-24 19:45:03', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2025-06-24 19:45:03', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int(0) NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '字典数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '停用状态');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '字典类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2025-06-24 19:45:11', '', NULL, '登录状态列表');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '定时任务调度表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2025-06-24 19:45:13', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2025-06-24 19:45:13', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2025-06-24 19:45:13', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '异常信息',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime(0) NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status`) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 249 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码已失效', '2025-06-28 19:43:06');
INSERT INTO `sys_logininfor` VALUES (101, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-28 19:46:15');
INSERT INTO `sys_logininfor` VALUES (102, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-29 10:05:41');
INSERT INTO `sys_logininfor` VALUES (103, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-06-30 22:44:12');
INSERT INTO `sys_logininfor` VALUES (104, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-01 19:58:35');
INSERT INTO `sys_logininfor` VALUES (105, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-01 22:29:55');
INSERT INTO `sys_logininfor` VALUES (106, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-07-02 01:58:57');
INSERT INTO `sys_logininfor` VALUES (107, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-02 01:59:09');
INSERT INTO `sys_logininfor` VALUES (108, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-02 09:50:09');
INSERT INTO `sys_logininfor` VALUES (109, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-02 10:34:15');
INSERT INTO `sys_logininfor` VALUES (110, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-02 13:57:09');
INSERT INTO `sys_logininfor` VALUES (111, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-02 15:59:57');
INSERT INTO `sys_logininfor` VALUES (112, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-02 16:36:39');
INSERT INTO `sys_logininfor` VALUES (113, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-07-02 17:04:12');
INSERT INTO `sys_logininfor` VALUES (114, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-02 17:05:38');
INSERT INTO `sys_logininfor` VALUES (115, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-07-02 17:11:30');
INSERT INTO `sys_logininfor` VALUES (116, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-02 17:11:49');
INSERT INTO `sys_logininfor` VALUES (117, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-07-02 20:10:56');
INSERT INTO `sys_logininfor` VALUES (118, 'admin', '172.22.0.5', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-08-04 12:14:38');
INSERT INTO `sys_logininfor` VALUES (119, 'admin', '172.22.0.5', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-04 12:19:11');
INSERT INTO `sys_logininfor` VALUES (120, 'admin', '172.22.0.5', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-04 12:35:43');
INSERT INTO `sys_logininfor` VALUES (121, 'admin', '172.22.0.5', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-04 14:35:41');
INSERT INTO `sys_logininfor` VALUES (122, 'admin', '172.22.0.3', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-05 04:52:28');
INSERT INTO `sys_logininfor` VALUES (123, 'admin', '172.22.0.5', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-07 04:13:22');
INSERT INTO `sys_logininfor` VALUES (124, 'admin', '172.22.0.5', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-10 12:18:21');
INSERT INTO `sys_logininfor` VALUES (125, 'admin', '172.22.0.5', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-10 12:24:15');
INSERT INTO `sys_logininfor` VALUES (126, 'admin', '172.22.0.5', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-10 15:53:53');
INSERT INTO `sys_logininfor` VALUES (127, 'admin', '172.20.0.6', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-13 03:15:30');
INSERT INTO `sys_logininfor` VALUES (128, 'admin', '172.20.0.6', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-13 03:28:56');
INSERT INTO `sys_logininfor` VALUES (129, 'admin', '172.20.0.6', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-13 04:42:25');
INSERT INTO `sys_logininfor` VALUES (130, 'admin', '172.20.0.4', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-13 13:33:51');
INSERT INTO `sys_logininfor` VALUES (131, 'admin', '172.20.0.5', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-19 05:49:51');
INSERT INTO `sys_logininfor` VALUES (132, 'admin', '172.20.0.3', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-19 14:19:38');
INSERT INTO `sys_logininfor` VALUES (133, 'admin', '172.20.0.3', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-20 07:54:48');
INSERT INTO `sys_logininfor` VALUES (134, 'admin', '172.20.0.5', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-21 06:21:53');
INSERT INTO `sys_logininfor` VALUES (135, 'admin', '172.20.0.1', '内网IP', 'Mozilla', 'Windows 10', '1', '验证码已失效', '2025-08-21 07:27:37');
INSERT INTO `sys_logininfor` VALUES (136, 'admin', '172.20.0.5', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码已失效', '2025-08-25 14:44:15');
INSERT INTO `sys_logininfor` VALUES (137, 'admin', '172.20.0.5', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-25 14:44:25');
INSERT INTO `sys_logininfor` VALUES (138, 'admin', '172.20.0.6', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-26 05:39:36');
INSERT INTO `sys_logininfor` VALUES (139, 'admin', '172.20.0.6', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-08-26 05:40:06');
INSERT INTO `sys_logininfor` VALUES (140, 'admin', '172.20.0.2', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-09-01 04:46:26');
INSERT INTO `sys_logininfor` VALUES (141, 'admin', '172.20.0.3', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-09-05 13:52:43');
INSERT INTO `sys_logininfor` VALUES (142, 'admin', '172.20.0.3', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-09-05 14:30:05');
INSERT INTO `sys_logininfor` VALUES (143, 'admin', '172.20.0.3', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-09-05 14:31:52');
INSERT INTO `sys_logininfor` VALUES (144, 'admin', '172.20.0.3', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-09-07 07:24:23');
INSERT INTO `sys_logininfor` VALUES (145, 'admin', '172.20.0.1', '内网IP', 'Robot/Spider', 'Unknown', '1', '验证码已失效', '2025-09-07 08:46:27');
INSERT INTO `sys_logininfor` VALUES (146, 'admin', '172.20.0.6', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-08 03:45:27');
INSERT INTO `sys_logininfor` VALUES (147, 'admin', '172.20.0.6', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-08 14:11:43');
INSERT INTO `sys_logininfor` VALUES (148, 'admin', '172.20.0.6', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-09 00:46:59');
INSERT INTO `sys_logininfor` VALUES (149, 'admin', '172.20.0.6', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-09 01:29:15');
INSERT INTO `sys_logininfor` VALUES (150, 'admin', '172.20.0.6', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-09 02:19:39');
INSERT INTO `sys_logininfor` VALUES (151, 'admin', '172.20.0.6', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-09 13:01:19');
INSERT INTO `sys_logininfor` VALUES (152, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-10 03:55:22');
INSERT INTO `sys_logininfor` VALUES (153, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-10 05:39:36');
INSERT INTO `sys_logininfor` VALUES (154, 'admin', '172.20.0.6', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-11 05:11:31');
INSERT INTO `sys_logininfor` VALUES (155, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-11 13:16:55');
INSERT INTO `sys_logininfor` VALUES (156, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-11 23:06:01');
INSERT INTO `sys_logininfor` VALUES (157, 'admin', '172.20.0.2', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-12 00:47:56');
INSERT INTO `sys_logininfor` VALUES (158, 'admin', '172.20.0.4', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-15 13:05:37');
INSERT INTO `sys_logininfor` VALUES (159, 'admin', '172.20.0.1', '内网IP', 'Mozilla', 'Windows 10', '1', '验证码已失效', '2025-09-16 01:02:12');
INSERT INTO `sys_logininfor` VALUES (160, 'admin', '172.20.0.4', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-16 02:49:33');
INSERT INTO `sys_logininfor` VALUES (161, 'admin', '172.20.0.4', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-17 13:20:05');
INSERT INTO `sys_logininfor` VALUES (162, 'admin', '172.20.0.4', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-17 14:17:35');
INSERT INTO `sys_logininfor` VALUES (163, 'admin', '172.20.0.3', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-18 01:31:15');
INSERT INTO `sys_logininfor` VALUES (164, 'admin', '172.20.0.4', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-19 03:09:24');
INSERT INTO `sys_logininfor` VALUES (165, 'admin', '172.20.0.4', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-19 08:33:32');
INSERT INTO `sys_logininfor` VALUES (166, 'admin', '172.20.0.4', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-19 09:04:51');
INSERT INTO `sys_logininfor` VALUES (167, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-19 11:28:53');
INSERT INTO `sys_logininfor` VALUES (168, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-19 12:27:13');
INSERT INTO `sys_logininfor` VALUES (169, 'admin', '172.20.0.2', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2025-09-23 01:25:10');
INSERT INTO `sys_logininfor` VALUES (170, 'admin', '172.20.0.2', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-23 01:25:23');
INSERT INTO `sys_logininfor` VALUES (171, 'admin', '172.20.0.6', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-24 01:44:27');
INSERT INTO `sys_logininfor` VALUES (172, 'admin', '172.20.0.6', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-09-24 02:11:40');
INSERT INTO `sys_logininfor` VALUES (173, 'admin', '172.20.0.2', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-09-27 03:26:49');
INSERT INTO `sys_logininfor` VALUES (174, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-14 02:56:29');
INSERT INTO `sys_logininfor` VALUES (175, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-14 07:06:11');
INSERT INTO `sys_logininfor` VALUES (176, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-14 08:36:59');
INSERT INTO `sys_logininfor` VALUES (177, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-15 02:03:01');
INSERT INTO `sys_logininfor` VALUES (178, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-15 06:44:34');
INSERT INTO `sys_logininfor` VALUES (179, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-15 07:39:42');
INSERT INTO `sys_logininfor` VALUES (180, 'admin', '172.20.0.4', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-16 14:25:05');
INSERT INTO `sys_logininfor` VALUES (181, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2025-10-17 02:09:40');
INSERT INTO `sys_logininfor` VALUES (182, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-17 02:09:47');
INSERT INTO `sys_logininfor` VALUES (183, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-17 03:22:10');
INSERT INTO `sys_logininfor` VALUES (184, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-17 04:44:41');
INSERT INTO `sys_logininfor` VALUES (185, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-17 05:47:00');
INSERT INTO `sys_logininfor` VALUES (186, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2025-10-17 07:38:50');
INSERT INTO `sys_logininfor` VALUES (187, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-17 07:38:56');
INSERT INTO `sys_logininfor` VALUES (188, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-17 08:42:09');
INSERT INTO `sys_logininfor` VALUES (189, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-17 12:50:03');
INSERT INTO `sys_logininfor` VALUES (190, 'admin', '172.20.0.6', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-17 13:56:23');
INSERT INTO `sys_logininfor` VALUES (191, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-18 11:51:09');
INSERT INTO `sys_logininfor` VALUES (192, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-18 12:35:01');
INSERT INTO `sys_logininfor` VALUES (193, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-18 13:12:14');
INSERT INTO `sys_logininfor` VALUES (194, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-19 03:17:17');
INSERT INTO `sys_logininfor` VALUES (195, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-19 03:42:12');
INSERT INTO `sys_logininfor` VALUES (196, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-19 03:50:09');
INSERT INTO `sys_logininfor` VALUES (197, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-19 04:03:03');
INSERT INTO `sys_logininfor` VALUES (198, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-19 05:28:28');
INSERT INTO `sys_logininfor` VALUES (199, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-19 05:29:16');
INSERT INTO `sys_logininfor` VALUES (200, 'admin', '172.20.0.1', '内网IP', 'Robot/Spider', 'Unknown', '1', '验证码已失效', '2025-10-19 05:43:31');
INSERT INTO `sys_logininfor` VALUES (201, 'admin', '172.20.0.1', '内网IP', 'Mozilla', 'Windows 10', '1', '验证码已失效', '2025-10-19 05:43:57');
INSERT INTO `sys_logininfor` VALUES (202, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-19 09:28:25');
INSERT INTO `sys_logininfor` VALUES (203, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-19 11:03:29');
INSERT INTO `sys_logininfor` VALUES (204, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-19 11:16:45');
INSERT INTO `sys_logininfor` VALUES (205, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-19 12:17:23');
INSERT INTO `sys_logininfor` VALUES (206, 'admin', '172.20.0.6', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-20 01:33:59');
INSERT INTO `sys_logininfor` VALUES (207, 'admin', '172.20.0.6', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-20 01:41:38');
INSERT INTO `sys_logininfor` VALUES (208, 'admin', '172.20.0.6', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-20 01:50:39');
INSERT INTO `sys_logininfor` VALUES (209, 'admin', '172.20.0.6', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2025-10-20 02:28:43');
INSERT INTO `sys_logininfor` VALUES (210, 'admin', '172.20.0.6', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-20 02:28:51');
INSERT INTO `sys_logininfor` VALUES (211, 'admin', '172.20.0.6', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-20 03:07:56');
INSERT INTO `sys_logininfor` VALUES (212, 'admin', '172.20.0.6', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-20 03:16:17');
INSERT INTO `sys_logininfor` VALUES (213, 'admin', '172.20.0.6', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-20 03:49:30');
INSERT INTO `sys_logininfor` VALUES (214, 'admin', '172.20.0.6', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-20 05:57:03');
INSERT INTO `sys_logininfor` VALUES (215, 'admin', '172.20.0.4', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2025-10-21 01:22:49');
INSERT INTO `sys_logininfor` VALUES (216, 'admin', '172.20.0.4', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2025-10-21 01:55:22');
INSERT INTO `sys_logininfor` VALUES (217, 'admin', '172.20.0.4', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-21 02:02:56');
INSERT INTO `sys_logininfor` VALUES (218, 'admin', '172.20.0.4', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-21 03:17:55');
INSERT INTO `sys_logininfor` VALUES (219, 'admin', '172.20.0.4', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-21 03:51:43');
INSERT INTO `sys_logininfor` VALUES (220, 'admin', '172.20.0.4', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-21 04:03:30');
INSERT INTO `sys_logininfor` VALUES (221, 'admin', '172.20.0.4', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-21 04:12:03');
INSERT INTO `sys_logininfor` VALUES (222, 'admin', '172.20.0.4', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-21 06:05:56');
INSERT INTO `sys_logininfor` VALUES (223, 'admin', '172.20.0.4', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-21 06:40:40');
INSERT INTO `sys_logininfor` VALUES (224, 'admin', '172.20.0.4', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-21 08:05:22');
INSERT INTO `sys_logininfor` VALUES (225, 'admin', '172.20.0.6', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-22 03:14:37');
INSERT INTO `sys_logininfor` VALUES (226, 'admin', '172.20.0.6', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-22 06:21:03');
INSERT INTO `sys_logininfor` VALUES (227, 'admin', '172.20.0.2', '内网IP', 'Chrome 14', 'Windows 10', '1', '用户不存在/密码错误', '2025-10-23 14:37:21');
INSERT INTO `sys_logininfor` VALUES (228, 'admin', '172.20.0.2', '内网IP', 'Chrome 14', 'Windows 10', '1', '用户不存在/密码错误', '2025-10-23 14:37:41');
INSERT INTO `sys_logininfor` VALUES (229, 'admin', '172.20.0.2', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2025-10-23 14:37:50');
INSERT INTO `sys_logininfor` VALUES (230, 'admin', '172.20.0.2', '内网IP', 'Chrome 14', 'Windows 10', '1', '用户不存在/密码错误', '2025-10-23 14:37:55');
INSERT INTO `sys_logininfor` VALUES (231, 'admin', '172.20.0.2', '内网IP', 'Chrome 14', 'Windows 10', '1', '用户不存在/密码错误', '2025-10-23 14:38:10');
INSERT INTO `sys_logininfor` VALUES (232, 'admin', '172.20.0.2', '内网IP', 'Chrome 14', 'Windows 10', '1', '用户不存在/密码错误', '2025-10-23 14:39:22');
INSERT INTO `sys_logininfor` VALUES (233, 'admin', '172.20.0.2', '内网IP', 'Chrome 14', 'Windows 10', '1', '密码输入错误5次，帐户锁定10分钟', '2025-10-23 14:39:34');
INSERT INTO `sys_logininfor` VALUES (234, 'ry', '172.20.0.2', '内网IP', 'Chrome 14', 'Windows 10', '1', '用户不存在/密码错误', '2025-10-23 14:41:10');
INSERT INTO `sys_logininfor` VALUES (235, 'ry', '172.20.0.2', '内网IP', 'Chrome 14', 'Windows 10', '1', '用户不存在/密码错误', '2025-10-23 14:44:24');
INSERT INTO `sys_logininfor` VALUES (236, 'admin', '172.20.0.2', '内网IP', 'Chrome 14', 'Windows 10', '1', '密码输入错误5次，帐户锁定10分钟', '2025-10-23 14:45:20');
INSERT INTO `sys_logininfor` VALUES (237, 'admin', '172.20.0.2', '内网IP', 'Chrome 14', 'Windows 10', '1', '密码输入错误5次，帐户锁定10分钟', '2025-10-23 14:45:34');
INSERT INTO `sys_logininfor` VALUES (238, 'admin', '172.20.0.2', '内网IP', 'Chrome 14', 'Windows 10', '1', '密码输入错误5次，帐户锁定10分钟', '2025-10-23 14:49:22');
INSERT INTO `sys_logininfor` VALUES (239, 'admin', '172.20.0.2', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-23 14:49:32');
INSERT INTO `sys_logininfor` VALUES (240, 'admin', '172.20.0.2', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-24 08:00:38');
INSERT INTO `sys_logininfor` VALUES (241, 'admin', '172.20.0.2', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-24 10:22:25');
INSERT INTO `sys_logininfor` VALUES (242, 'admin', '172.20.0.6', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-24 13:02:23');
INSERT INTO `sys_logininfor` VALUES (243, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-25 13:08:45');
INSERT INTO `sys_logininfor` VALUES (244, 'admin', '172.20.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-27 01:35:55');
INSERT INTO `sys_logininfor` VALUES (245, 'admin', '172.20.0.4', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2025-10-27 13:16:05');
INSERT INTO `sys_logininfor` VALUES (246, 'admin', '172.20.0.4', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-27 13:16:12');
INSERT INTO `sys_logininfor` VALUES (247, 'admin', '172.19.0.6', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-10-30 01:25:52');
INSERT INTO `sys_logininfor` VALUES (248, 'admin', '172.19.0.6', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-10-30 01:27:16');
INSERT INTO `sys_logininfor` VALUES (249, 'admin', '172.19.0.6', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-10-30 02:27:37');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint(0) NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int(0) NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int(0) NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int(0) NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2007 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 10, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'SettingOutlined', 'admin', '2025-06-24 19:45:06', 'admin', '2025-07-02 17:07:51', '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 11, 'monitor', NULL, '', '', 1, 0, 'M', '0', '0', '', 'DashboardOutlined', 'admin', '2025-06-24 19:45:06', 'admin', '2025-07-02 17:08:03', '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 12, 'tool', NULL, '', '', 1, 0, 'M', '0', '0', '', 'ToolOutlined', 'admin', '2025-06-24 19:45:06', 'admin', '2025-07-02 17:08:31', '系统工具目录');
INSERT INTO `sys_menu` VALUES (4, '若依官网', 0, 4, 'http://ruoyi.vip', NULL, '', '', 1, 0, 'M', '1', '1', '', 'LinkOutlined', 'admin', '2025-06-24 19:45:06', 'admin', '2025-07-02 17:06:23', '若依官网地址');
INSERT INTO `sys_menu` VALUES (5, '控制台', 0, 0, 'dashboard', NULL, '', '', 1, 0, 'M', '1', '0', '', 'AppstoreOutlined', 'admin', '2025-06-24 19:45:06', '', NULL, '控制台');
INSERT INTO `sys_menu` VALUES (6, '个人', 0, 6, 'account', NULL, '', '', 1, 0, 'M', '1', '0', '', 'ProfileOutlined', 'admin', '2025-06-24 19:45:06', 'admin', '2025-07-02 17:07:22', '个人');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2025-06-24 19:45:06', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2025-06-24 19:45:06', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2025-06-24 19:45:06', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2025-06-24 19:45:06', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2025-06-24 19:45:06', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2025-06-24 19:45:06', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2025-06-24 19:45:06', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2025-06-24 19:45:06', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2025-06-24 19:45:06', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2025-06-24 19:45:06', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2025-06-24 19:45:06', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2025-06-24 19:45:06', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2025-06-24 19:45:06', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2025-06-24 19:45:06', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2025-06-24 19:45:06', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2025-06-24 19:45:06', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2025-06-24 19:45:06', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2025-06-24 19:45:06', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2025-06-24 19:45:06', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2025-06-24 19:45:06', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2025-06-24 19:45:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2000, 'MSDS管理', 0, 1, 'msds', NULL, '', '', 1, 0, 'M', '0', '0', '', 'FileTextOutlined', 'admin', '2025-06-29 10:32:17', 'admin', '2025-07-02 17:07:37', 'MSDS管理目录');
INSERT INTO `sys_menu` VALUES (2001, 'MSDS信息', 2000, 1, '/msds/main', 'msds/main/index', '', '', 1, 0, 'C', '0', '0', 'system:msds:list', 'file-text', 'admin', '2025-06-29 10:32:18', '', NULL, 'MSDS主信息菜单');
INSERT INTO `sys_menu` VALUES (2002, 'MSDS查询', 2001, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:msds:query', '#', 'admin', '2025-06-29 10:32:18', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2003, 'MSDS新增', 2001, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:msds:add', '#', 'admin', '2025-06-29 10:32:18', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2004, 'MSDS修改', 2001, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:msds:edit', '#', 'admin', '2025-06-29 10:32:18', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2005, 'MSDS删除', 2001, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:msds:remove', '#', 'admin', '2025-06-29 10:32:18', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2006, 'MSDS导出', 2001, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:msds:export', '#', 'admin', '2025-06-29 10:32:18', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2007, 'MSDS导入', 2001, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:msds:import', '#', 'admin', '2025-07-01 22:06:34', '', NULL, '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int(0) NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '通知公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '温馨提醒：2018-07-01 若依新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '0', 'admin', '2025-06-24 19:45:15', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (2, '维护通知：2018-07-01 若依系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '0', 'admin', '2025-06-24 19:45:15', '', NULL, '管理员');

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int(0) NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int(0) NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int(0) NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime(0) NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint(0) NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type`) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status`) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 420 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '操作日志记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (100, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '127.0.0.1', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: 无法解析出有效的MSDS信息\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-07-02 01:59:59', 1610);
INSERT INTO `sys_oper_log` VALUES (101, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '127.0.0.1', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: \\r\\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\\r\\n### The error may exist in URL [jar:file:/D:/.m2/com/ruoyi/ruoyi-system/3.8.8/ruoyi-system-3.8.8.jar!/mapper/system/MsdsMainMapper.xml]\\r\\n### The error may involve com.ruoyi.system.mapper.MsdsMainMapper.selectMsdsMainByProductName-Inline\\r\\n### The error occurred while setting parameters\\r\\n### SQL: select id, cas_number, msds_code, product_name, product_alias, product_english_name,                 category_id, company_name, company_address, zip_code, fax_number, contact_phone,                 email, emergency_phone, recommended_usage, restricted_usage, version,                 revision_date, effective_date, status, approver, approval_date,                is_active, create_by, create_time, update_by, update_time, remark         from msds_main               where product_name = ? and is_active = 1 limit 1\\r\\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\\n; bad SQL grammar []\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-07-02 09:51:29', 4524);
INSERT INTO `sys_oper_log` VALUES (102, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '127.0.0.1', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: \\r\\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\\r\\n### The error may exist in URL [jar:file:/D:/.m2/com/ruoyi/ruoyi-system/3.8.8/ruoyi-system-3.8.8.jar!/mapper/system/MsdsMainMapper.xml]\\r\\n### The error may involve com.ruoyi.system.mapper.MsdsMainMapper.selectMsdsMainByProductName-Inline\\r\\n### The error occurred while setting parameters\\r\\n### SQL: select id, cas_number, msds_code, product_name, product_alias, product_english_name,                 category_id, company_name, company_address, zip_code, fax_number, contact_phone,                 email, emergency_phone, recommended_usage, restricted_usage, version,                 revision_date, effective_date, status, approver, approval_date,                is_active, create_by, create_time, update_by, update_time, remark         from msds_main               where product_name = ? and is_active = 1 limit 1\\r\\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\\n; bad SQL grammar []\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-07-02 10:36:14', 2542);
INSERT INTO `sys_oper_log` VALUES (103, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '127.0.0.1', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: \\r\\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'remark\' in \'field list\'\\r\\n### The error may exist in URL [jar:file:/D:/.m2/com/ruoyi/ruoyi-system/3.8.8/ruoyi-system-3.8.8.jar!/mapper/system/MsdsMainMapper.xml]\\r\\n### The error may involve com.ruoyi.system.mapper.MsdsMainMapper.selectMsdsMainByProductName-Inline\\r\\n### The error occurred while setting parameters\\r\\n### SQL: select id, cas_number, msds_code, product_name, product_alias, product_english_name,             category_id, company_name, company_address, zip_code, fax_number, contact_phone,             email, emergency_phone, recommended_usage, restricted_usage, version,             revision_date, effective_date, status, approver, approval_date,             is_active, create_time, update_time, remark         from msds_main               where product_name = ? and is_active = 1 limit 1\\r\\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'remark\' in \'field list\'\\n; bad SQL grammar []\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-07-02 11:03:43', 2983);
INSERT INTO `sys_oper_log` VALUES (104, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '127.0.0.1', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: \\r\\n### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'remark\' in \'field list\'\\r\\n### The error may exist in URL [jar:file:/D:/.m2/com/ruoyi/ruoyi-system/3.8.8/ruoyi-system-3.8.8.jar!/mapper/system/MsdsMainMapper.xml]\\r\\n### The error may involve com.ruoyi.system.mapper.MsdsMainMapper.selectMsdsMainByProductName-Inline\\r\\n### The error occurred while setting parameters\\r\\n### SQL: select id, cas_number, msds_code, product_name, product_alias, product_english_name,             category_id, company_name, company_address, zip_code, fax_number, contact_phone,             email, emergency_phone, recommended_usage, restricted_usage, version,             revision_date, effective_date, status, approver, approval_date,             is_active, create_time, update_time, remark         from msds_main               where product_name = ? and is_active = 1 limit 1\\r\\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'remark\' in \'field list\'\\n; bad SQL grammar []\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-07-02 13:57:44', 1384);
INSERT INTO `sys_oper_log` VALUES (105, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '127.0.0.1', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[],\"successCount\":1,\"failureCount\":0}}', 0, NULL, '2025-07-02 16:37:26', 3007);
INSERT INTO `sys_oper_log` VALUES (106, 'MSDS主信息', 2, 'com.ruoyi.web.controller.system.MsdsMainController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/msds', '127.0.0.1', '内网IP', '{\"casNumber\":\"115-29-7\",\"companyAddress\":\"\",\"companyName\":\"2323\",\"contactPhone\":\"ghbghggf\",\"createTime\":\"2025-07-02 16:37:25\",\"email\":\"\",\"emergencyPhone\":\"\",\"faxNumber\":\"供应商Email：\",\"id\":1,\"isActive\":1,\"msdsCode\":\"MSDS#1597\",\"params\":{},\"productAlias\":\"1,2,3,4,7,7-六氯双环[2,2,1] 庚烯-(2)-双羟甲基-5,6-亚硫 酸酯；硫丹 \",\"productEnglishName\":\",2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedim  ethyl \",\"productName\":\"(1,4,5,6,7,7-六氯-8,9,10-三降 冰片-5-烯-2,3-亚基双亚甲基)亚 硫酸酯 \",\"status\":\"draft\",\"updateTime\":\"2025-07-02 16:37:25\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-02 16:43:41', 469);
INSERT INTO `sys_oper_log` VALUES (107, 'MSDS主信息', 5, 'com.ruoyi.web.controller.system.MsdsMainController.export()', 'POST', 1, 'admin', '研发部门', '/system/msds/export', '127.0.0.1', '内网IP', '{\"params\":{}}', NULL, 0, NULL, '2025-07-02 16:43:53', 2531);
INSERT INTO `sys_oper_log` VALUES (108, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '127.0.0.1', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[],\"successCount\":1,\"failureCount\":0}}', 0, NULL, '2025-07-02 16:44:55', 678);
INSERT INTO `sys_oper_log` VALUES (109, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"icon\":\"LinkOutlined\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":4,\"menuName\":\"若依官网\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"http://ruoyi.vip\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-02 17:06:16', 422);
INSERT INTO `sys_oper_log` VALUES (110, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"icon\":\"LinkOutlined\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":4,\"menuName\":\"若依官网\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"http://ruoyi.vip\",\"perms\":\"\",\"query\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-02 17:06:25', 1411);
INSERT INTO `sys_oper_log` VALUES (111, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"icon\":\"FileTextOutlined\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"MSDS管理\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"msds\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-02 17:07:01', 544);
INSERT INTO `sys_oper_log` VALUES (112, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"icon\":\"ProfileOutlined\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":6,\"menuName\":\"个人\",\"menuType\":\"M\",\"orderNum\":6,\"params\":{},\"parentId\":0,\"path\":\"account\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-02 17:07:22', 192);
INSERT INTO `sys_oper_log` VALUES (113, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"icon\":\"FileTextOutlined\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"MSDS管理\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"msds\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-02 17:07:38', 804);
INSERT INTO `sys_oper_log` VALUES (114, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"icon\":\"SettingOutlined\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1,\"menuName\":\"系统管理\",\"menuType\":\"M\",\"orderNum\":10,\"params\":{},\"parentId\":0,\"path\":\"system\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-02 17:07:52', 199);
INSERT INTO `sys_oper_log` VALUES (115, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"icon\":\"DashboardOutlined\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2,\"menuName\":\"系统监控\",\"menuType\":\"M\",\"orderNum\":11,\"params\":{},\"parentId\":0,\"path\":\"monitor\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-02 17:08:04', 1382);
INSERT INTO `sys_oper_log` VALUES (116, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"icon\":\"ToolOutlined\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":3,\"menuName\":\"系统工具\",\"menuType\":\"M\",\"orderNum\":12,\"params\":{},\"parentId\":0,\"path\":\"tool\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-07-02 17:08:31', 414);
INSERT INTO `sys_oper_log` VALUES (117, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.22.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[],\"successCount\":1,\"failureCount\":0}}', 0, NULL, '2025-08-04 12:19:36', 477);
INSERT INTO `sys_oper_log` VALUES (118, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.22.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[],\"successCount\":1,\"failureCount\":0}}', 0, NULL, '2025-08-04 12:36:17', 352);
INSERT INTO `sys_oper_log` VALUES (119, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/4', '172.22.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-04 12:42:45', 22);
INSERT INTO `sys_oper_log` VALUES (120, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/3', '172.22.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-04 12:42:48', 16);
INSERT INTO `sys_oper_log` VALUES (121, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/2', '172.22.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-04 12:42:57', 8);
INSERT INTO `sys_oper_log` VALUES (122, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/1', '172.22.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-04 12:42:59', 6);
INSERT INTO `sys_oper_log` VALUES (123, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.22.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[],\"successCount\":1,\"failureCount\":0}}', 0, NULL, '2025-08-04 12:43:11', 47);
INSERT INTO `sys_oper_log` VALUES (124, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/5', '172.22.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-04 13:08:04', 31);
INSERT INTO `sys_oper_log` VALUES (125, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.22.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[],\"successCount\":1,\"failureCount\":0}}', 0, NULL, '2025-08-04 13:08:12', 366);
INSERT INTO `sys_oper_log` VALUES (126, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/6', '172.22.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-04 14:35:55', 20);
INSERT INTO `sys_oper_log` VALUES (127, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.22.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[],\"successCount\":1,\"failureCount\":0}}', 0, NULL, '2025-08-04 14:36:14', 152);
INSERT INTO `sys_oper_log` VALUES (128, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/7', '172.22.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-04 14:49:00', 35);
INSERT INTO `sys_oper_log` VALUES (129, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.22.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[],\"successCount\":1,\"failureCount\":0}}', 0, NULL, '2025-08-04 14:49:08', 426);
INSERT INTO `sys_oper_log` VALUES (130, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/8', '172.22.0.3', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-05 04:52:47', 67);
INSERT INTO `sys_oper_log` VALUES (131, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.22.0.3', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[],\"successCount\":1,\"failureCount\":0}}', 0, NULL, '2025-08-05 04:52:59', 289);
INSERT INTO `sys_oper_log` VALUES (132, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.22.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[],\"successCount\":1,\"failureCount\":0}}', 0, NULL, '2025-08-07 04:14:05', 1299);
INSERT INTO `sys_oper_log` VALUES (133, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/10', '172.22.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-10 12:18:54', 91);
INSERT INTO `sys_oper_log` VALUES (134, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/9', '172.22.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-10 12:18:56', 10);
INSERT INTO `sys_oper_log` VALUES (135, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.22.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-08-10 12:19:10', 2276);
INSERT INTO `sys_oper_log` VALUES (136, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.22.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"225、丁基甲苯.pdf: MSDS主表数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-08-10 12:19:29', 49);
INSERT INTO `sys_oper_log` VALUES (137, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/11', '172.22.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-10 12:24:29', 11);
INSERT INTO `sys_oper_log` VALUES (138, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.22.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"1、四氢呋喃、tetrahydrofuran、109-99-9 - 副本.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-08-10 12:24:49', 131);
INSERT INTO `sys_oper_log` VALUES (139, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/12', '172.22.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-10 15:54:10', 23);
INSERT INTO `sys_oper_log` VALUES (140, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.22.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"1、四氢呋喃、tetrahydrofuran、109-99-9 - 副本.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-08-10 15:54:31', 205);
INSERT INTO `sys_oper_log` VALUES (141, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/13', '172.20.0.6', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-13 03:16:19', 97);
INSERT INTO `sys_oper_log` VALUES (142, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"1、四氢呋喃、tetrahydrofuran、109-99-9 - 副本.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-08-13 03:16:40', 1020);
INSERT INTO `sys_oper_log` VALUES (143, 'MSDS导入模板生成', 5, 'com.ruoyi.system.controller.MsdsExportController.generateImportTemplate()', 'GET', 1, 'admin', '研发部门', '/system/msds/export/template', '172.20.0.6', '内网IP', '{}', NULL, 0, NULL, '2025-08-13 03:16:55', 1103);
INSERT INTO `sys_oper_log` VALUES (144, 'MSDS导入模板生成', 5, 'com.ruoyi.system.controller.MsdsExportController.generateImportTemplate()', 'GET', 1, 'admin', '研发部门', '/system/msds/export/template', '172.20.0.6', '内网IP', '{\"type\":\"detailed\"}', NULL, 0, NULL, '2025-08-13 03:16:55', 85);
INSERT INTO `sys_oper_log` VALUES (145, 'MSDS导入模板生成', 5, 'com.ruoyi.system.controller.MsdsExportController.generateImportTemplate()', 'GET', 1, 'admin', '研发部门', '/system/msds/export/template', '172.20.0.6', '内网IP', '{}', NULL, 0, NULL, '2025-08-13 03:17:11', 57);
INSERT INTO `sys_oper_log` VALUES (146, 'MSDS导入模板生成', 5, 'com.ruoyi.system.controller.MsdsExportController.generateImportTemplate()', 'GET', 1, 'admin', '研发部门', '/system/msds/export/template', '172.20.0.6', '内网IP', '{\"type\":\"basic\"}', NULL, 0, NULL, '2025-08-13 03:17:11', 50);
INSERT INTO `sys_oper_log` VALUES (147, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/18', '172.20.0.6', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-13 04:42:38', 85);
INSERT INTO `sys_oper_log` VALUES (148, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"四氢呋喃、tetrahydrofuran、109-99-9.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-08-13 04:42:49', 642);
INSERT INTO `sys_oper_log` VALUES (149, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/19', '172.20.0.6', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-13 04:49:36', 62);
INSERT INTO `sys_oper_log` VALUES (150, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"四氢呋喃（别名THF）、tetrahydrofuran、109-99-9.txt: 不支持的文件格式\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-08-13 04:49:54', 1);
INSERT INTO `sys_oper_log` VALUES (151, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.4', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"四氢呋喃、tetrahydrofuran、109-99-9.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-08-13 13:34:24', 1846);
INSERT INTO `sys_oper_log` VALUES (152, 'MSDS主信息', 5, 'com.ruoyi.web.controller.system.MsdsMainController.export()', 'POST', 1, 'admin', '研发部门', '/system/msds/export', '172.20.0.5', '内网IP', '{\"params\":{}}', NULL, 0, NULL, '2025-08-19 05:50:24', 3453);
INSERT INTO `sys_oper_log` VALUES (153, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.3', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"1、四氢呋喃、tetrahydrofuran、109-99-9 - 副本.pdf: \\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'109-99-9\' for key \'msds_main.cas_number\'\\n### The error may exist in URL [jar:file:/root/.m2/repository/com/ruoyi/ruoyi-system/3.8.8/ruoyi-system-3.8.8.jar!/mapper/system/MsdsMainMapper.xml]\\n### The error may involve com.ruoyi.system.mapper.MsdsMainMapper.insertMsdsMain-Inline\\n### The error occurred while setting parameters\\n### SQL: insert into msds_main (             cas_number, msds_code, product_name, product_alias, product_english_name,              category_id, company_name, company_address, zip_code, fax_number,              contact_phone, email, emergency_phone, recommended_usage, restricted_usage,              version, revision_date, effective_date, status, approver, approval_date,             is_active, remark         )values(             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?, ?,             ?, ?         )\\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'109-99-9\' for key \'msds_main.cas_number\'\\n; Duplicate entry \'109-99-9\' for key \'msds_main.cas_number\'\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-08-19 14:20:16', 428);
INSERT INTO `sys_oper_log` VALUES (154, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/20', '172.20.0.3', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-19 14:20:29', 22);
INSERT INTO `sys_oper_log` VALUES (155, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.3', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"四氢呋喃、tetrahydrofuran、109-99-9.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-08-19 14:20:41', 169);
INSERT INTO `sys_oper_log` VALUES (156, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.3', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1R,2R,4R)-冰片-2-硫氰基醋酸酯、1,7,7-trimethylbicyclo(2,2,1)hept-2-yl thiocyanatoacetate、115-31-1.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-08-19 14:21:18', 244);
INSERT INTO `sys_oper_log` VALUES (157, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.3', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"1,1,3,3-四甲基丁基过氧新癸酸酯[含量≤52%,在水中稳定弥散]、1,1,3,3-tetramethylbutyl peroxyneodecanoate (not more than 52% as a stable dispersion in water)、51240-95-0.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-08-19 14:26:04', 131);
INSERT INTO `sys_oper_log` VALUES (158, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/24', '172.20.0.3', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-20 07:55:13', 94);
INSERT INTO `sys_oper_log` VALUES (159, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/23', '172.20.0.3', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-20 07:55:15', 10);
INSERT INTO `sys_oper_log` VALUES (160, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/22', '172.20.0.3', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-20 07:55:16', 9);
INSERT INTO `sys_oper_log` VALUES (161, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.3', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"四氢呋喃、tetrahydrofuran、109-99-9.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-08-20 07:55:28', 660);
INSERT INTO `sys_oper_log` VALUES (162, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/25', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-21 06:22:10', 85);
INSERT INTO `sys_oper_log` VALUES (163, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1R,4S,4aS,5R,6R,7S,8S,8aR)-1,2,3,4,10,10-六氯-1,4,4a,5,6,7,8,8a-八氢-6,7-环氧-1,4,5,8-二亚甲基萘、dieldrin(not less than 2% but not more than 90%)、60-57-1.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-08-21 06:22:22', 1031);
INSERT INTO `sys_oper_log` VALUES (164, 'MSDS文档预览', 0, 'com.ruoyi.web.controller.system.MsdsMainController.preview()', 'POST', 1, 'admin', '研发部门', '/system/msds/preview', '172.20.0.5', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"total\":1,\"previewList\":[{\"fileName\":\"(1R,4S,4aS,5R,6R,7S,8S,8aR)-1,2,3,4,10,10-六氯-1,4,4a,5,6,7,8,8a-八氢-6,7-环氧-1,4,5,8-二亚甲基萘、dieldrin(not less than 2% but not more than 90%)、60-57-1.pdf\",\"productEnglishName\":\"dieldrin(not less than 2% but not more\",\"companyName\":\"名称： 供应商\",\"casNumber\":\"60-57-1\",\"productName\":\"-1\",\"status\":\"warning\"}],\"successCount\":0,\"warningCount\":1,\"errorCount\":0}}', 0, NULL, '2025-08-21 06:22:28', 143);
INSERT INTO `sys_oper_log` VALUES (165, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/27', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-25 14:47:17', 67);
INSERT INTO `sys_oper_log` VALUES (166, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/26', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-25 14:47:19', 17);
INSERT INTO `sys_oper_log` VALUES (167, 'MSDS文档预览', 0, 'com.ruoyi.web.controller.system.MsdsMainController.preview()', 'POST', 1, 'admin', '研发部门', '/system/msds/preview', '172.20.0.5', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"total\":1,\"previewList\":[{\"fileName\":\"四氢呋喃、tetrahydrofuran、109-99-9.pdf\",\"productEnglishName\":\"tetrahydrofuran 英文别名： 无资料\",\"companyName\":\"名称： 供应商\",\"casNumber\":\"109-99-9\",\"productName\":\"四氢呋喃\",\"status\":\"warning\"}],\"previewSectionsMap\":{\"四氢呋喃、tetrahydrofuran、109-99-9.pdf\":[{\"id\":1,\"title\":\"第一部分 化学品及企业标识\",\"fields\":[{\"hint\":\"必填\",\"label\":\"化学品中文名\",\"value\":\"四氢呋喃\",\"key\":\"product_name\",\"status\":\"success\"},{\"hint\":\"建议填写\",\"label\":\"化学品英文名\",\"value\":\"tetrahydrofuran 英文别名： 无资料\",\"key\":\"product_english_name\",\"status\":\"success\"},{\"hint\":\"必填\",\"label\":\"CAS号\",\"value\":\"109-99-9\",\"key\":\"cas_number\",\"status\":\"success\"},{\"hint\":\"建议填写\",\"label\":\"生产企业\",\"value\":\"名称： 供应商\",\"key\":\"company_name\",\"status\":\"success\"},{\"hint\":\"建议填写\",\"label\":\"版本/修订\",\"key\":\"version\",\"status\":\"warning\"}]},{\"id\":2,\"title\":\"第二部分 危险性概述\",\"fields\":[]},{\"id\":3,\"title\":\"第三部分 成分/组成信息\",\"fields\":[]},{\"id\":4,\"title\":\"第四部分 急救措施\",\"fields\":[]},{\"id\":5,\"title\":\"第五部分 消防措施\",\"fields\":[]},{\"id\":6,\"title\":\"第六部分 泄漏应急处理\",\"fields\":[]},{\"id\":7,\"title\":\"第七部分 操作处置与储存\",\"fields\":[]},{\"id\":8,\"title\":\"第八部分 接触控制/个体防护\",\"fields\":[]},{\"id\":9,\"title\":\"第九部分 理化特性\",\"fields\":[]},{\"id\":10,\"title\":\"第十部分 稳定性和反应性\",\"fields\":[]},{\"id\":11,\"title\":\"第十一部分 毒理学资料\",\"fields\":[]},{\"id\":12,\"title\":\"第十二部分 生态学资料\",\"fields\":[]},{\"id\":13,\"title\":\"第十三部分 废弃处置\",\"fields\":[]},{\"id\":14,\"title\":\"第十四部分 运输信息\",\"fields\":[]},{\"id\":15,\"title\":\"第十五部分 法规信息\",\"fields\":[]},{\"id\":16,\"title\":\"第十六部分 其他信息\",\"fields\":[]}]},\"successCount\":0,\"warningCount\":1,\"errorCount\":0}}', 0, NULL, '2025-08-25 14:47:33', 545);
INSERT INTO `sys_oper_log` VALUES (168, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"四氢呋喃、tetrahydrofuran、109-99-9.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-08-25 14:48:27', 158);
INSERT INTO `sys_oper_log` VALUES (169, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/28', '172.20.0.6', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-08-26 05:40:19', 57);
INSERT INTO `sys_oper_log` VALUES (170, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"四氢呋喃、tetrahydrofuran、109-99-9.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-08-26 05:40:27', 647);
INSERT INTO `sys_oper_log` VALUES (171, 'MSDS文档预览', 0, 'com.ruoyi.web.controller.system.MsdsMainController.preview()', 'POST', 1, 'admin', '研发部门', '/system/msds/preview', '172.20.0.6', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"total\":1,\"previewList\":[{\"fileName\":\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf\",\"productEnglishName\":\"1,2,3,4,7,7-hexachloro-8,9,10\",\"companyName\":\"名称： 供应商\",\"casNumber\":\"115-29-7\",\"productName\":\"(1\",\"status\":\"warning\"}],\"previewSectionsMap\":{\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf\":[{\"id\":1,\"title\":\"第一部分 化学品及企业标识\",\"fields\":[{\"hint\":\"必填\",\"label\":\"化学品中文名\",\"value\":\"(1\",\"key\":\"product_name\",\"status\":\"success\"},{\"hint\":\"建议填写\",\"label\":\"化学品英文名\",\"value\":\"1,2,3,4,7,7-hexachloro-8,9,10\",\"key\":\"product_english_name\",\"status\":\"success\"},{\"hint\":\"必填\",\"label\":\"CAS号\",\"value\":\"115-29-7\",\"key\":\"cas_number\",\"status\":\"success\"},{\"hint\":\"建议填写\",\"label\":\"生产企业\",\"value\":\"名称： 供应商\",\"key\":\"company_name\",\"status\":\"success\"},{\"hint\":\"建议填写\",\"label\":\"版本/修订\",\"key\":\"version\",\"status\":\"warning\"}]},{\"id\":2,\"title\":\"第二部分 危险性概述\",\"fields\":[]},{\"id\":3,\"title\":\"第三部分 成分/组成信息\",\"fields\":[]},{\"id\":4,\"title\":\"第四部分 急救措施\",\"fields\":[]},{\"id\":5,\"title\":\"第五部分 消防措施\",\"fields\":[]},{\"id\":6,\"title\":\"第六部分 泄漏应急处理\",\"fields\":[]},{\"id\":7,\"title\":\"第七部分 操作处置与储存\",\"fields\":[]},{\"id\":8,\"title\":\"第八部分 接触控制/个体防护\",\"fields\":[]},{\"id\":9,\"title\":\"第九部分 理化特性\",\"fields\":[]},{\"id\":10,\"title\":\"第十部分 稳定性和反应性\",\"fields\":[]},{\"id\":11,\"title\":\"第十一部分 毒理学资料\",\"fields\":[]},{\"id\":12,\"title\":\"第十二部分 生态学资料\",\"fields\":[]},{\"id\":13,\"title\":\"第十三部分 废弃处置\",\"fields\":[]},{\"id\":14,\"title\":\"第十四部分 运输信息\",\"fields\":[]},{\"id\":15,\"title\":\"第十五部分 法规信息\",\"fields\":[]},{\"id\":16,\"title\":\"第十六部分 其他信息\",\"fields\":[]}]},\"successCount\":0,\"warningCount\":1,\"errorCount\":0}}', 0, NULL, '2025-08-26 05:40:59', 155);
INSERT INTO `sys_oper_log` VALUES (172, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-08-26 05:41:31', 126);
INSERT INTO `sys_oper_log` VALUES (173, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/30', '172.20.0.2', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-01 04:46:54', 66);
INSERT INTO `sys_oper_log` VALUES (174, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/29', '172.20.0.2', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-01 04:46:59', 31);
INSERT INTO `sys_oper_log` VALUES (175, 'MSDS文档预览', 0, 'com.ruoyi.web.controller.system.MsdsMainController.preview()', 'POST', 1, 'admin', '研发部门', '/system/msds/preview', '172.20.0.2', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"total\":1,\"previewList\":[{\"fileName\":\"四氢呋喃、tetrahydrofuran、109-99-9.pdf\",\"productEnglishName\":\"tetrahydrofuran\",\"companyName\":\"名称： 供应商\",\"casNumber\":\"109-99-9\",\"productName\":\"四氢呋喃\",\"status\":\"warning\"}],\"previewSectionsMap\":{\"四氢呋喃、tetrahydrofuran、109-99-9.pdf\":[{\"id\":1,\"title\":\"第一部分 化学品及企业标识\",\"fields\":[{\"hint\":\"必填\",\"label\":\"化学品中文名\",\"value\":\"四氢呋喃\",\"key\":\"product_name\",\"status\":\"success\"},{\"hint\":\"建议填写\",\"label\":\"化学品英文名\",\"value\":\"tetrahydrofuran\",\"key\":\"product_english_name\",\"status\":\"success\"},{\"hint\":\"必填\",\"label\":\"CAS号\",\"value\":\"109-99-9\",\"key\":\"cas_number\",\"status\":\"success\"},{\"hint\":\"建议填写\",\"label\":\"生产企业\",\"value\":\"名称： 供应商\",\"key\":\"company_name\",\"status\":\"success\"},{\"hint\":\"建议填写\",\"label\":\"版本/修订\",\"key\":\"version\",\"status\":\"warning\"}]},{\"id\":2,\"title\":\"第二部分 危险性概述\",\"fields\":[]},{\"id\":3,\"title\":\"第三部分 成分/组成信息\",\"fields\":[]},{\"id\":4,\"title\":\"第四部分 急救措施\",\"fields\":[]},{\"id\":5,\"title\":\"第五部分 消防措施\",\"fields\":[]},{\"id\":6,\"title\":\"第六部分 泄漏应急处理\",\"fields\":[]},{\"id\":7,\"title\":\"第七部分 操作处置与储存\",\"fields\":[]},{\"id\":8,\"title\":\"第八部分 接触控制/个体防护\",\"fields\":[]},{\"id\":9,\"title\":\"第九部分 理化特性\",\"fields\":[]},{\"id\":10,\"title\":\"第十部分 稳定性和反应性\",\"fields\":[]},{\"id\":11,\"title\":\"第十一部分 毒理学资料\",\"fields\":[]},{\"id\":12,\"title\":\"第十二部分 生态学资料\",\"fields\":[]},{\"id\":13,\"title\":\"第十三部分 废弃处置\",\"fields\":[]},{\"id\":14,\"title\":\"第十四部分 运输信息\",\"fields\":[]},{\"id\":15,\"title\":\"第十五部分 法规信息\",\"fields\":[]},{\"id\":16,\"title\":\"第十六部分 其他信息\",\"fields\":[]}]},\"successCount\":0,\"warningCount\":1,\"errorCount\":0}}', 0, NULL, '2025-09-01 04:47:18', 647);
INSERT INTO `sys_oper_log` VALUES (176, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.2', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"四氢呋喃、tetrahydrofuran、109-99-9.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-01 04:47:36', 178);
INSERT INTO `sys_oper_log` VALUES (177, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.2', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[{\"fileName\":\"(1R,4S,5R,8S)-1,2,3,4,10,10-六氯-1,4,4a,5,6,7,8,8a-八氢-6,7-环氧-1,4,5,8-二亚甲基萘[含量＞5%]、1,2,3,4,10,10-hexachloro-6,7-epoxy-1,4,4a,5,6,7,8,8a-octahydro-1,45,8-dimethanonaphthalene(more than 5%)、72-20-8.pdf\",\"chemicalName\":\"-1\",\"casNumber\":\"72-20-8\"},{\"fileName\":\"(E)-O,O-二甲基-O-[1-甲基-2-(二甲基氨基甲酰)乙烯基]磷酸酯[含量＞25%]、(E)-2-dimethylcarbamoyl-1-methylvinyl dimethyl phosphate(more than 25%)、141-66-2.pdf\",\"chemicalName\":\"-O\",\"casNumber\":\"141-66-2\"},{\"fileName\":\"1，1，1-三羟甲基丙烷、1，1，1-Trihydroxymethylpropane、77-99-6.pdf\",\"chemicalName\":\"1，1，1-三羟甲基丙烷\",\"casNumber\":\"77-99-6\"}],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\",\"(1R,2R,4R)-冰片-2-硫氰基醋酸酯、1,7,7-trimethylbicyclo(2,2,1)hept-2-yl thiocyanatoacetate、115-31-1.pdf: MSDS相关数据保存失败\",\"(1R,4S,4aS,5R,6R,7S,8S,8aR)-1,2,3,4,10,10-六氯-1,4,4a,5,6,7,8,8a-八氢-6,7-环氧-1,4,5,8-二亚甲基萘、dieldrin(not less than 2% but not more than 90%)、60-57-1.pdf: MSDS相关数据保存失败\",\"(2-氨基甲酰氧乙基)三甲基氯化铵、(2-carbamoyloxyethyl) trimethylammonium chloride、51-83-2.pdf: MSDS相关数据保存失败\",\"(E)-O,O-二甲基-O-[1-甲基-2-(1-苯基-乙氧基甲酰)乙烯基]磷酸酯、1-phenylethyl 3-(dimethoxyphosphinyloxy)isocrotonate powder、7700-17-6.pdf: MSDS相关数据保存失败\",\"(RS)-2-[4-(5-三氟甲基-2-吡啶氧基)苯氧基]丙酸丁酯、butyl 2-[4-[[5-(trifluoromethyl)-2-pyridyl]oxy]phenoxy]propionate、69806-50-4.pdf: \\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'供应商名称： 供应商地址：\' for key \'msds_main.msds_code\'\\n### The error may exist in URL [jar:nested:/app/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/MsdsMainMapper.xml]\\n### The error may involve com.ruoyi.system.mapper.MsdsMainMapper.insertMsdsMain-Inline\\n### The error occurred while setting parameters\\n### SQL: insert into msds_main (             cas_number, msds_code, product_name, product_alias, product_english_name,              category_id, company_name, compa', 0, NULL, '2025-09-01 04:48:32', 2128);
INSERT INTO `sys_oper_log` VALUES (178, 'MSDS主信息', 5, 'com.ruoyi.web.controller.system.MsdsMainController.export()', 'POST', 1, 'admin', '研发部门', '/system/msds/export', '172.20.0.2', '内网IP', '{\"params\":{}}', NULL, 0, NULL, '2025-09-01 04:50:28', 1684);
INSERT INTO `sys_oper_log` VALUES (179, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/54', '172.20.0.2', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-01 04:51:32', 15);
INSERT INTO `sys_oper_log` VALUES (180, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/53', '172.20.0.2', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-01 04:51:36', 8);
INSERT INTO `sys_oper_log` VALUES (181, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/49', '172.20.0.2', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-01 04:51:38', 9);
INSERT INTO `sys_oper_log` VALUES (182, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/51', '172.20.0.2', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-01 04:51:41', 11);
INSERT INTO `sys_oper_log` VALUES (183, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/52', '172.20.0.2', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-01 04:51:48', 16);
INSERT INTO `sys_oper_log` VALUES (184, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/36', '172.20.0.2', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-01 04:51:50', 25);
INSERT INTO `sys_oper_log` VALUES (185, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/38', '172.20.0.2', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-01 04:51:53', 11);
INSERT INTO `sys_oper_log` VALUES (186, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/39', '172.20.0.2', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-01 04:51:54', 11);
INSERT INTO `sys_oper_log` VALUES (187, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/40', '172.20.0.2', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-01 04:52:01', 13);
INSERT INTO `sys_oper_log` VALUES (188, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/34', '172.20.0.2', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-01 04:52:04', 10);
INSERT INTO `sys_oper_log` VALUES (189, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/41', '172.20.0.2', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-01 04:52:08', 10);
INSERT INTO `sys_oper_log` VALUES (190, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/46', '172.20.0.2', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-01 04:52:10', 9);
INSERT INTO `sys_oper_log` VALUES (191, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/47', '172.20.0.2', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-01 04:52:22', 8);
INSERT INTO `sys_oper_log` VALUES (192, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/48', '172.20.0.2', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-01 04:52:24', 17);
INSERT INTO `sys_oper_log` VALUES (193, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/32', '172.20.0.2', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-01 04:52:26', 10);
INSERT INTO `sys_oper_log` VALUES (194, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/33', '172.20.0.2', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-01 04:52:27', 11);
INSERT INTO `sys_oper_log` VALUES (195, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/35', '172.20.0.2', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-01 04:52:32', 14);
INSERT INTO `sys_oper_log` VALUES (196, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/31', '172.20.0.2', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-01 04:52:34', 20);
INSERT INTO `sys_oper_log` VALUES (197, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.2', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"MSDS主信息_1756702223009.xlsx: 不支持的文件格式\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-01 04:52:49', 1);
INSERT INTO `sys_oper_log` VALUES (198, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.2', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"MSDS主信息_1756702223009.xlsx: 不支持的文件格式\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-01 04:52:54', 1);
INSERT INTO `sys_oper_log` VALUES (199, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.2', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"MSDS主信息_1756702223009.xlsx: 不支持的文件格式\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-01 04:53:16', 0);
INSERT INTO `sys_oper_log` VALUES (200, 'MSDS文档预览', 0, 'com.ruoyi.web.controller.system.MsdsMainController.preview()', 'POST', 1, 'admin', '研发部门', '/system/msds/preview', '172.20.0.3', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"total\":1,\"previewList\":[{\"fileName\":\"四氢呋喃、tetrahydrofuran、109-99-9.pdf\",\"productEnglishName\":\"tetrahydrofuran\",\"companyName\":\"名称： 供应商\",\"casNumber\":\"109-99-9\",\"productName\":\"四氢呋喃\",\"status\":\"warning\"}],\"previewSectionsMap\":{\"四氢呋喃、tetrahydrofuran、109-99-9.pdf\":[{\"id\":1,\"title\":\"第一部分 化学品及企业标识\",\"fields\":[{\"hint\":\"必填\",\"label\":\"化学品中文名\",\"value\":\"四氢呋喃\",\"key\":\"product_name\",\"status\":\"success\"},{\"hint\":\"建议填写\",\"label\":\"化学品英文名\",\"value\":\"tetrahydrofuran\",\"key\":\"product_english_name\",\"status\":\"success\"},{\"hint\":\"必填\",\"label\":\"CAS号\",\"value\":\"109-99-9\",\"key\":\"cas_number\",\"status\":\"success\"},{\"hint\":\"建议填写\",\"label\":\"生产企业\",\"value\":\"名称： 供应商\",\"key\":\"company_name\",\"status\":\"success\"},{\"hint\":\"建议填写\",\"label\":\"版本/修订\",\"key\":\"version\",\"status\":\"warning\"}]},{\"id\":2,\"title\":\"第二部分 危险性概述\",\"fields\":[]},{\"id\":3,\"title\":\"第三部分 成分/组成信息\",\"fields\":[]},{\"id\":4,\"title\":\"第四部分 急救措施\",\"fields\":[]},{\"id\":5,\"title\":\"第五部分 消防措施\",\"fields\":[]},{\"id\":6,\"title\":\"第六部分 泄漏应急处理\",\"fields\":[]},{\"id\":7,\"title\":\"第七部分 操作处置与储存\",\"fields\":[]},{\"id\":8,\"title\":\"第八部分 接触控制/个体防护\",\"fields\":[]},{\"id\":9,\"title\":\"第九部分 理化特性\",\"fields\":[]},{\"id\":10,\"title\":\"第十部分 稳定性和反应性\",\"fields\":[]},{\"id\":11,\"title\":\"第十一部分 毒理学资料\",\"fields\":[]},{\"id\":12,\"title\":\"第十二部分 生态学资料\",\"fields\":[]},{\"id\":13,\"title\":\"第十三部分 废弃处置\",\"fields\":[]},{\"id\":14,\"title\":\"第十四部分 运输信息\",\"fields\":[]},{\"id\":15,\"title\":\"第十五部分 法规信息\",\"fields\":[]},{\"id\":16,\"title\":\"第十六部分 其他信息\",\"fields\":[]}]},\"successCount\":0,\"warningCount\":1,\"errorCount\":0}}', 0, NULL, '2025-09-05 14:30:30', 778);
INSERT INTO `sys_oper_log` VALUES (201, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.3', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"四氢呋喃、tetrahydrofuran、109-99-9.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-05 14:30:44', 284);
INSERT INTO `sys_oper_log` VALUES (202, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.3', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[{\"fileName\":\"(1R,4S,5R,8S)-1,2,3,4,10,10-六氯-1,4,4a,5,6,7,8,8a-八氢-6,7-环氧-1,4,5,8-二亚甲基萘[含量＞5%]、1,2,3,4,10,10-hexachloro-6,7-epoxy-1,4,4a,5,6,7,8,8a-octahydro-1,45,8-dimethanonaphthalene(more than 5%)、72-20-8.pdf\",\"chemicalName\":\"-1\",\"casNumber\":\"72-20-8\"},{\"fileName\":\"(E)-O,O-二甲基-O-[1-甲基-2-(二甲基氨基甲酰)乙烯基]磷酸酯[含量＞25%]、(E)-2-dimethylcarbamoyl-1-methylvinyl dimethyl phosphate(more than 25%)、141-66-2.pdf\",\"chemicalName\":\"-O\",\"casNumber\":\"141-66-2\"}],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\",\"(1R,2R,4R)-冰片-2-硫氰基醋酸酯、1,7,7-trimethylbicyclo(2,2,1)hept-2-yl thiocyanatoacetate、115-31-1.pdf: MSDS相关数据保存失败\",\"(1R,4S,4aS,5R,6R,7S,8S,8aR)-1,2,3,4,10,10-六氯-1,4,4a,5,6,7,8,8a-八氢-6,7-环氧-1,4,5,8-二亚甲基萘、dieldrin(not less than 2% but not more than 90%)、60-57-1.pdf: MSDS相关数据保存失败\",\"(2-氨基甲酰氧乙基)三甲基氯化铵、(2-carbamoyloxyethyl) trimethylammonium chloride、51-83-2.pdf: MSDS相关数据保存失败\",\"(E)-O,O-二甲基-O-[1-甲基-2-(1-苯基-乙氧基甲酰)乙烯基]磷酸酯、1-phenylethyl 3-(dimethoxyphosphinyloxy)isocrotonate powder、7700-17-6.pdf: MSDS相关数据保存失败\",\"(RS)-2-[4-(5-三氟甲基-2-吡啶氧基)苯氧基]丙酸丁酯、butyl 2-[4-[[5-(trifluoromethyl)-2-pyridyl]oxy]phenoxy]propionate、69806-50-4.pdf: \\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'供应商名称： 供应商地址：\' for key \'msds_main.msds_code\'\\n### The error may exist in URL [jar:nested:/app/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/MsdsMainMapper.xml]\\n### The error may involve com.ruoyi.system.mapper.MsdsMainMapper.insertMsdsMain-Inline\\n### The error occurred while setting parameters\\n### SQL: insert into msds_main (             cas_number, msds_code, product_name, product_alias, product_english_name,              category_id, company_name, company_address, zip_code, fax_number,              contact_phone, email, emergency_phone, recommended_usage, restricted_usage,', 0, NULL, '2025-09-05 15:22:44', 1673);
INSERT INTO `sys_oper_log` VALUES (203, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/61', '172.20.0.3', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-07 07:25:23', 36);
INSERT INTO `sys_oper_log` VALUES (204, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/62', '172.20.0.3', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-07 07:25:26', 11);
INSERT INTO `sys_oper_log` VALUES (205, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/63', '172.20.0.3', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-07 07:25:28', 9);
INSERT INTO `sys_oper_log` VALUES (206, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/64', '172.20.0.3', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-07 07:25:41', 12);
INSERT INTO `sys_oper_log` VALUES (207, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/66', '172.20.0.3', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-07 07:25:44', 8);
INSERT INTO `sys_oper_log` VALUES (208, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/60', '172.20.0.3', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-07 07:25:50', 10);
INSERT INTO `sys_oper_log` VALUES (209, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/59', '172.20.0.3', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-07 07:25:55', 15);
INSERT INTO `sys_oper_log` VALUES (210, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.3', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"四氢呋喃、tetrahydrofuran、109-99-9.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-07 07:26:15', 533);
INSERT INTO `sys_oper_log` VALUES (211, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.3', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-07 07:39:45', 163);
INSERT INTO `sys_oper_log` VALUES (212, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/68', '172.20.0.6', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-08 03:45:37', 55);
INSERT INTO `sys_oper_log` VALUES (213, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/67', '172.20.0.6', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-08 03:45:39', 16);
INSERT INTO `sys_oper_log` VALUES (214, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-08 03:45:49', 735);
INSERT INTO `sys_oper_log` VALUES (215, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"四氢呋喃、tetrahydrofuran、109-99-9.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-08 04:06:17', 112);
INSERT INTO `sys_oper_log` VALUES (216, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/69', '172.20.0.6', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-08 04:06:46', 12);
INSERT INTO `sys_oper_log` VALUES (217, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-08 04:07:03', 114);
INSERT INTO `sys_oper_log` VALUES (218, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/71', '172.20.0.6', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-08 14:12:25', 56);
INSERT INTO `sys_oper_log` VALUES (219, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/70', '172.20.0.6', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-08 14:12:27', 13);
INSERT INTO `sys_oper_log` VALUES (220, 'MSDS文档预览', 0, 'com.ruoyi.web.controller.system.MsdsMainController.preview()', 'POST', 1, 'admin', '研发部门', '/system/msds/preview', '172.20.0.6', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"total\":1,\"previewList\":[{\"fileName\":\"四氢呋喃、tetrahydrofuran、109-99-9.pdf\",\"productEnglishName\":\"tetrahydrofuran\",\"companyName\":\"名称： 供应商\",\"casNumber\":\"109-99-9\",\"productName\":\"四氢呋喃\",\"status\":\"warning\"}],\"previewSectionsMap\":{\"四氢呋喃、tetrahydrofuran、109-99-9.pdf\":[{\"id\":1,\"title\":\"第一部分 化学品及企业标识\",\"fields\":[{\"hint\":\"必填\",\"label\":\"化学品中文名\",\"value\":\"四氢呋喃\",\"key\":\"product_name\",\"status\":\"success\"},{\"hint\":\"建议填写\",\"label\":\"化学品英文名\",\"value\":\"tetrahydrofuran\",\"key\":\"product_english_name\",\"status\":\"success\"},{\"hint\":\"必填\",\"label\":\"CAS号\",\"value\":\"109-99-9\",\"key\":\"cas_number\",\"status\":\"success\"},{\"hint\":\"建议填写\",\"label\":\"生产企业\",\"value\":\"名称： 供应商\",\"key\":\"company_name\",\"status\":\"success\"},{\"hint\":\"建议填写\",\"label\":\"版本/修订\",\"key\":\"version\",\"status\":\"warning\"}]},{\"id\":2,\"title\":\"第二部分 危险性概述\",\"fields\":[]},{\"id\":3,\"title\":\"第三部分 成分/组成信息\",\"fields\":[]},{\"id\":4,\"title\":\"第四部分 急救措施\",\"fields\":[]},{\"id\":5,\"title\":\"第五部分 消防措施\",\"fields\":[]},{\"id\":6,\"title\":\"第六部分 泄漏应急处理\",\"fields\":[]},{\"id\":7,\"title\":\"第七部分 操作处置与储存\",\"fields\":[]},{\"id\":8,\"title\":\"第八部分 接触控制/个体防护\",\"fields\":[]},{\"id\":9,\"title\":\"第九部分 理化特性\",\"fields\":[]},{\"id\":10,\"title\":\"第十部分 稳定性和反应性\",\"fields\":[]},{\"id\":11,\"title\":\"第十一部分 毒理学资料\",\"fields\":[]},{\"id\":12,\"title\":\"第十二部分 生态学资料\",\"fields\":[]},{\"id\":13,\"title\":\"第十三部分 废弃处置\",\"fields\":[]},{\"id\":14,\"title\":\"第十四部分 运输信息\",\"fields\":[]},{\"id\":15,\"title\":\"第十五部分 法规信息\",\"fields\":[]},{\"id\":16,\"title\":\"第十六部分 其他信息\",\"fields\":[]}]},\"successCount\":0,\"warningCount\":1,\"errorCount\":0}}', 0, NULL, '2025-09-08 14:12:46', 435);
INSERT INTO `sys_oper_log` VALUES (221, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"四氢呋喃、tetrahydrofuran、109-99-9.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-08 14:12:59', 204);
INSERT INTO `sys_oper_log` VALUES (222, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[{\"fileName\":\"四氢呋喃、tetrahydrofuran、109-99-9.pdf\",\"chemicalName\":\"四氢呋喃\",\"casNumber\":\"109-99-9\"}],\"errorMessages\":[],\"successCount\":0,\"failureCount\":0}}', 0, NULL, '2025-09-08 14:13:19', 63);
INSERT INTO `sys_oper_log` VALUES (223, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-09 00:47:15', 794);
INSERT INTO `sys_oper_log` VALUES (224, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/73', '172.20.0.6', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-09 01:31:50', 55);
INSERT INTO `sys_oper_log` VALUES (225, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/72', '172.20.0.6', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-09 01:31:52', 17);
INSERT INTO `sys_oper_log` VALUES (226, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"四氢呋喃、tetrahydrofuran、109-99-9.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-09 01:31:59', 680);
INSERT INTO `sys_oper_log` VALUES (227, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/74', '172.20.0.6', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-09 02:19:46', 59);
INSERT INTO `sys_oper_log` VALUES (228, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-09 02:22:36', 591);
INSERT INTO `sys_oper_log` VALUES (229, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/75', '172.20.0.6', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-09 13:01:30', 58);
INSERT INTO `sys_oper_log` VALUES (230, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"四氢呋喃、tetrahydrofuran、109-99-9.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-09 13:01:46', 701);
INSERT INTO `sys_oper_log` VALUES (231, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/76', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-10 03:56:07', 75);
INSERT INTO `sys_oper_log` VALUES (232, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-10 03:56:29', 1348);
INSERT INTO `sys_oper_log` VALUES (233, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/77', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-10 05:39:45', 19);
INSERT INTO `sys_oper_log` VALUES (234, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-10 05:39:53', 352);
INSERT INTO `sys_oper_log` VALUES (235, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/78', '172.20.0.6', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-10 05:56:54', 66);
INSERT INTO `sys_oper_log` VALUES (236, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-10 05:57:01', 708);
INSERT INTO `sys_oper_log` VALUES (237, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/79', '172.20.0.6', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-11 05:11:45', 51);
INSERT INTO `sys_oper_log` VALUES (238, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-11 05:11:59', 849);
INSERT INTO `sys_oper_log` VALUES (239, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/80', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-11 13:17:07', 46);
INSERT INTO `sys_oper_log` VALUES (240, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-11 13:17:21', 705);
INSERT INTO `sys_oper_log` VALUES (241, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/81', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-11 23:06:12', 83);
INSERT INTO `sys_oper_log` VALUES (242, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-11 23:06:25', 1772);
INSERT INTO `sys_oper_log` VALUES (243, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/82', '172.20.0.2', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-12 00:48:07', 22);
INSERT INTO `sys_oper_log` VALUES (244, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.2', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-12 00:48:24', 419);
INSERT INTO `sys_oper_log` VALUES (245, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/85', '172.20.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-15 13:05:53', 32);
INSERT INTO `sys_oper_log` VALUES (246, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/86', '172.20.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-15 13:05:57', 16);
INSERT INTO `sys_oper_log` VALUES (247, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/84', '172.20.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-15 13:05:59', 7);
INSERT INTO `sys_oper_log` VALUES (248, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/83', '172.20.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-15 13:06:02', 17);
INSERT INTO `sys_oper_log` VALUES (249, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.4', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-15 13:06:18', 622);
INSERT INTO `sys_oper_log` VALUES (250, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/87', '172.20.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-16 05:00:09', 133);
INSERT INTO `sys_oper_log` VALUES (251, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.4', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-16 05:00:27', 1150);
INSERT INTO `sys_oper_log` VALUES (252, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.4', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-17 13:20:22', 619);
INSERT INTO `sys_oper_log` VALUES (253, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.4', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"四氢呋喃、tetrahydrofuran、109-99-9.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-17 13:20:53', 78);
INSERT INTO `sys_oper_log` VALUES (254, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/89', '172.20.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-17 13:22:01', 13);
INSERT INTO `sys_oper_log` VALUES (255, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/90', '172.20.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-17 13:22:06', 6);
INSERT INTO `sys_oper_log` VALUES (256, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.4', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-17 13:22:14', 77);
INSERT INTO `sys_oper_log` VALUES (257, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/91', '172.20.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-17 14:18:25', 151);
INSERT INTO `sys_oper_log` VALUES (258, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.4', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-17 14:18:48', 2562);
INSERT INTO `sys_oper_log` VALUES (259, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/92', '172.20.0.6', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-17 14:45:51', 62);
INSERT INTO `sys_oper_log` VALUES (260, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-17 14:46:12', 796);
INSERT INTO `sys_oper_log` VALUES (261, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/93', '172.20.0.3', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-18 01:31:24', 88);
INSERT INTO `sys_oper_log` VALUES (262, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.3', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-18 01:31:32', 872);
INSERT INTO `sys_oper_log` VALUES (263, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/94', '172.20.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-19 03:09:30', 39);
INSERT INTO `sys_oper_log` VALUES (264, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.4', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-19 08:34:09', 1234);
INSERT INTO `sys_oper_log` VALUES (265, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.4', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1R,4S,4aS,5R,6R,7S,8S,8aR)-1,2,3,4,10,10-六氯-1,4,4a,5,6,7,8,8a-八氢-6,7-环氧-1,4,5,8-二亚甲基萘、dieldrin(not less than 2% but not more than 90%)、60-57-1.docx: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-19 08:34:46', 1695);
INSERT INTO `sys_oper_log` VALUES (266, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/95', '172.20.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-19 08:34:56', 14);
INSERT INTO `sys_oper_log` VALUES (267, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.4', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"四氢呋喃、tetrahydrofuran、109-99-9.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-19 08:35:06', 218);
INSERT INTO `sys_oper_log` VALUES (268, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/97', '172.20.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-19 09:04:59', 50);
INSERT INTO `sys_oper_log` VALUES (269, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/96', '172.20.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-19 09:05:01', 11);
INSERT INTO `sys_oper_log` VALUES (270, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.4', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-19 09:05:09', 636);
INSERT INTO `sys_oper_log` VALUES (271, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/98', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-19 11:29:05', 30);
INSERT INTO `sys_oper_log` VALUES (272, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"四氢呋喃、tetrahydrofuran、109-99-9.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-19 11:29:23', 661);
INSERT INTO `sys_oper_log` VALUES (273, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/99', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-19 12:27:20', 54);
INSERT INTO `sys_oper_log` VALUES (274, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1R,4S,4aS,5R,6R,7S,8S,8aR)-1,2,3,4,10,10-六氯-1,4,4a,5,6,7,8,8a-八氢-6,7-环氧-1,4,5,8-二亚甲基萘、dieldrin(not less than 2% but not more than 90%)、60-57-1.docx: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-19 12:27:30', 1617);
INSERT INTO `sys_oper_log` VALUES (275, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-19 12:28:03', 764);
INSERT INTO `sys_oper_log` VALUES (276, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/101', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-19 12:56:40', 36);
INSERT INTO `sys_oper_log` VALUES (277, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/100', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-19 12:56:42', 13);
INSERT INTO `sys_oper_log` VALUES (278, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1R,4S,4aS,5R,6R,7S,8S,8aR)-1,2,3,4,10,10-六氯-1,4,4a,5,6,7,8,8a-八氢-6,7-环氧-1,4,5,8-二亚甲基萘、dieldrin(not less than 2% but not more than 90%)、60-57-1.docx: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-19 12:56:51', 1447);
INSERT INTO `sys_oper_log` VALUES (279, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/102', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-19 12:57:35', 21);
INSERT INTO `sys_oper_log` VALUES (280, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1R,4S,4aS,5R,6R,7S,8S,8aR)-1,2,3,4,10,10-六氯-1,4,4a,5,6,7,8,8a-八氢-6,7-环氧-1,4,5,8-二亚甲基萘、dieldrin(not less than 2% but not more than 90%)、60-57-1.docx: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-19 12:57:41', 222);
INSERT INTO `sys_oper_log` VALUES (281, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/103', '172.20.0.2', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-23 01:25:31', 50);
INSERT INTO `sys_oper_log` VALUES (282, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.2', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1R,4S,4aS,5R,6R,7S,8S,8aR)-1,2,3,4,10,10-六氯-1,4,4a,5,6,7,8,8a-八氢-6,7-环氧-1,4,5,8-二亚甲基萘、dieldrin(not less than 2% but not more than 90%)、60-57-1.docx: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-23 01:25:47', 1528);
INSERT INTO `sys_oper_log` VALUES (283, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/104', '172.20.0.6', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-09-24 01:44:35', 63);
INSERT INTO `sys_oper_log` VALUES (284, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-09-24 01:44:43', 861);
INSERT INTO `sys_oper_log` VALUES (285, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/105', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-14 07:06:21', 89);
INSERT INTO `sys_oper_log` VALUES (286, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-10-14 07:07:15', 660);
INSERT INTO `sys_oper_log` VALUES (287, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/106', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-15 07:40:15', 109);
INSERT INTO `sys_oper_log` VALUES (288, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-10-15 07:41:53', 1431);
INSERT INTO `sys_oper_log` VALUES (289, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/107', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-15 07:55:33', 12);
INSERT INTO `sys_oper_log` VALUES (290, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-10-15 07:55:47', 396);
INSERT INTO `sys_oper_log` VALUES (291, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/108', '172.20.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-16 14:25:19', 59);
INSERT INTO `sys_oper_log` VALUES (292, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/111', '172.20.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-16 14:42:53', 14);
INSERT INTO `sys_oper_log` VALUES (293, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.4', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1R,4S,4aS,5R,6R,7S,8S,8aR)-1,2,3,4,10,10-六氯-1,4,4a,5,6,7,8,8a-八氢-6,7-环氧-1,4,5,8-二亚甲基萘、dieldrin(not less than 2% but not more than 90%)、60-57-1.docx: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-10-16 15:05:26', 1587);
INSERT INTO `sys_oper_log` VALUES (294, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/112', '172.20.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-16 15:05:53', 12);
INSERT INTO `sys_oper_log` VALUES (295, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.4', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-10-16 15:06:40', 513);
INSERT INTO `sys_oper_log` VALUES (296, 'MSDS主信息', 5, 'com.ruoyi.web.controller.system.MsdsMainController.export()', 'POST', 1, 'admin', '研发部门', '/system/msds/export', '172.20.0.4', '内网IP', '{\"params\":{}}', NULL, 0, NULL, '2025-10-16 15:06:52', 198);
INSERT INTO `sys_oper_log` VALUES (297, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/113', '172.20.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-16 15:14:44', 10);
INSERT INTO `sys_oper_log` VALUES (298, 'MSDS文档导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importData()', 'POST', 1, 'admin', '研发部门', '/system/msds/import', '172.20.0.4', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"duplicates\":[],\"errorMessages\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf: MSDS相关数据保存失败\"],\"successCount\":0,\"failureCount\":1}}', 0, NULL, '2025-10-16 15:16:43', 130);
INSERT INTO `sys_oper_log` VALUES (299, 'MSDS文档预览', 0, 'com.ruoyi.web.controller.system.MsdsMainController.preview()', 'POST', 1, 'admin', '研发部门', '/system/msds/preview', '172.20.0.4', '内网IP', '', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"total\":1,\"previewList\":[{\"fileName\":\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf\",\"productEnglishName\":\"1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl\",\"companyName\":\"供应商\",\"casNumber\":\"115-29-7\",\"productName\":\"硫酸酯 中文别名： 酸酯；硫丹\",\"status\":\"warning\"}],\"previewSectionsMap\":{\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf\":[{\"id\":1,\"title\":\"第一部分 化学品及企业标识\",\"fields\":[{\"hint\":\"必填\",\"label\":\"化学品中文名\",\"value\":\"硫酸酯 中文别名： 酸酯；硫丹\",\"key\":\"product_name\",\"status\":\"success\"},{\"hint\":\"建议填写\",\"label\":\"化学品英文名\",\"value\":\"1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl\",\"key\":\"product_english_name\",\"status\":\"success\"},{\"hint\":\"必填\",\"label\":\"CAS号\",\"value\":\"115-29-7\",\"key\":\"cas_number\",\"status\":\"success\"},{\"hint\":\"建议填写\",\"label\":\"生产企业\",\"value\":\"供应商\",\"key\":\"company_name\",\"status\":\"success\"},{\"hint\":\"建议填写\",\"label\":\"版本/修订\",\"key\":\"version\",\"status\":\"warning\"}]},{\"id\":2,\"title\":\"第二部分 危险性概述\",\"fields\":[]},{\"id\":3,\"title\":\"第三部分 成分/组成信息\",\"fields\":[]},{\"id\":4,\"title\":\"第四部分 急救措施\",\"fields\":[]},{\"id\":5,\"title\":\"第五部分 消防措施\",\"fields\":[]},{\"id\":6,\"title\":\"第六部分 泄漏应急处理\",\"fields\":[]},{\"id\":7,\"title\":\"第七部分 操作处置与储存\",\"fields\":[]},{\"id\":8,\"title\":\"第八部分 接触控制/个体防护\",\"fields\":[]},{\"id\":9,\"title\":\"第九部分 理化特性\",\"fields\":[]},{\"id\":10,\"title\":\"第十部分 稳定性和反应性\",\"fields\":[]},{\"id\":11,\"title\":\"第十一部分 毒理学资料\",\"fields\":[]},{\"id\":12,\"title\":\"第十二部分 生态学资料\",\"fields\":[]},{\"id\":13,\"title\":\"第十三部分 废弃处置\",\"fields\":[]},{\"id\":14,\"title\":\"第十四部分 运输信息\",\"fields\":[]},{\"id\":15,\"title\":\"第十五部分 法规信息\",\"fields\":[]},{\"id\":16,\"title\":\"第十六部分 其他信息\",\"fields\":[]}]},\"successCount\":0,\"warningCount\":1,\"errorCount\":0}}', 0, NULL, '2025-10-16 15:16:45', 45);
INSERT INTO `sys_oper_log` VALUES (300, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/114', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 02:09:54', 42);
INSERT INTO `sys_oper_log` VALUES (301, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[\"第1条记录: \\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'company_name\' cannot be null\\n### The error may exist in URL [jar:nested:/app/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/MsdsMainMapper.xml]\\n### The error may involve com.ruoyi.system.mapper.MsdsMainMapper.insertMsdsMain-Inline\\n### The error occurred while setting parameters\\n### SQL: insert into msds_main (             cas_number, msds_code, product_name, product_alias, product_english_name,              category_id, company_name, company_address, zip_code, fax_number,              contact_phone, email, emergency_phone, recommended_usage, restricted_usage,              version, revision_date, effective_date, status, approver, approval_date,             is_active, remark         )values(             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?, ?,             ?, ?         )\\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'company_name\' cannot be null\\n; Column \'company_name\' cannot be null\"],\"successList\":[],\"duplicateCount\":0,\"successCount\":0,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":1}}', 0, NULL, '2025-10-17 02:30:31', 94);
INSERT INTO `sys_oper_log` VALUES (302, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[\"第1条记录: \\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'company_name\' cannot be null\\n### The error may exist in URL [jar:nested:/app/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/MsdsMainMapper.xml]\\n### The error may involve com.ruoyi.system.mapper.MsdsMainMapper.insertMsdsMain-Inline\\n### The error occurred while setting parameters\\n### SQL: insert into msds_main (             cas_number, msds_code, product_name, product_alias, product_english_name,              category_id, company_name, company_address, zip_code, fax_number,              contact_phone, email, emergency_phone, recommended_usage, restricted_usage,              version, revision_date, effective_date, status, approver, approval_date,             is_active, remark         )values(             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?, ?,             ?, ?         )\\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'company_name\' cannot be null\\n; Column \'company_name\' cannot be null\"],\"successList\":[],\"duplicateCount\":0,\"successCount\":0,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":1}}', 0, NULL, '2025-10-17 02:30:35', 12);
INSERT INTO `sys_oper_log` VALUES (303, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[\"第1条记录: \\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'company_name\' cannot be null\\n### The error may exist in URL [jar:nested:/app/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/MsdsMainMapper.xml]\\n### The error may involve com.ruoyi.system.mapper.MsdsMainMapper.insertMsdsMain-Inline\\n### The error occurred while setting parameters\\n### SQL: insert into msds_main (             cas_number, msds_code, product_name, product_alias, product_english_name,              category_id, company_name, company_address, zip_code, fax_number,              contact_phone, email, emergency_phone, recommended_usage, restricted_usage,              version, revision_date, effective_date, status, approver, approval_date,             is_active, remark         )values(             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?, ?,             ?, ?         )\\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'company_name\' cannot be null\\n; Column \'company_name\' cannot be null\"],\"successList\":[],\"duplicateCount\":0,\"successCount\":0,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":1}}', 0, NULL, '2025-10-17 02:30:49', 20);
INSERT INTO `sys_oper_log` VALUES (304, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[\"第1条记录: null\",\"第2条记录: \\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'company_name\' cannot be null\\n### The error may exist in URL [jar:nested:/app/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/MsdsMainMapper.xml]\\n### The error may involve com.ruoyi.system.mapper.MsdsMainMapper.insertMsdsMain-Inline\\n### The error occurred while setting parameters\\n### SQL: insert into msds_main (             cas_number, msds_code, product_name, product_alias, product_english_name,              category_id, company_name, company_address, zip_code, fax_number,              contact_phone, email, emergency_phone, recommended_usage, restricted_usage,              version, revision_date, effective_date, status, approver, approval_date,             is_active, remark         )values(             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?, ?,             ?, ?         )\\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'company_name\' cannot be null\\n; Column \'company_name\' cannot be null\"],\"successList\":[],\"duplicateCount\":0,\"successCount\":0,\"duplicateList\":[],\"totalCount\":2,\"failureCount\":2}}', 0, NULL, '2025-10-17 02:31:06', 61);
INSERT INTO `sys_oper_log` VALUES (305, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[\"第1条记录: \\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'company_name\' cannot be null\\n### The error may exist in URL [jar:nested:/app/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/MsdsMainMapper.xml]\\n### The error may involve com.ruoyi.system.mapper.MsdsMainMapper.insertMsdsMain-Inline\\n### The error occurred while setting parameters\\n### SQL: insert into msds_main (             cas_number, msds_code, product_name, product_alias, product_english_name,              category_id, company_name, company_address, zip_code, fax_number,              contact_phone, email, emergency_phone, recommended_usage, restricted_usage,              version, revision_date, effective_date, status, approver, approval_date,             is_active, remark         )values(             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?, ?,             ?, ?         )\\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'company_name\' cannot be null\\n; Column \'company_name\' cannot be null\"],\"successList\":[],\"duplicateCount\":0,\"successCount\":0,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":1}}', 0, NULL, '2025-10-17 02:32:08', 16);
INSERT INTO `sys_oper_log` VALUES (306, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[\"第1条记录: \\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'company_name\' cannot be null\\n### The error may exist in URL [jar:nested:/app/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/MsdsMainMapper.xml]\\n### The error may involve com.ruoyi.system.mapper.MsdsMainMapper.insertMsdsMain-Inline\\n### The error occurred while setting parameters\\n### SQL: insert into msds_main (             cas_number, msds_code, product_name, product_alias, product_english_name,              category_id, company_name, company_address, zip_code, fax_number,              contact_phone, email, emergency_phone, recommended_usage, restricted_usage,              version, revision_date, effective_date, status, approver, approval_date,             is_active, remark         )values(             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?, ?,             ?, ?         )\\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'company_name\' cannot be null\\n; Column \'company_name\' cannot be null\"],\"successList\":[],\"duplicateCount\":0,\"successCount\":0,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":1}}', 0, NULL, '2025-10-17 02:32:27', 16);
INSERT INTO `sys_oper_log` VALUES (307, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/115', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 03:22:19', 67);
INSERT INTO `sys_oper_log` VALUES (308, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[\"第1条记录: \\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\\n### The error may exist in URL [jar:nested:/app/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/MsdsFireFightingMapper.xml]\\n### The error may involve com.ruoyi.system.mapper.MsdsFireFightingMapper.insertMsdsFireFighting-Inline\\n### The error occurred while setting parameters\\n### SQL: insert into msds_fire_fighting (             msds_id, hazard_characteristics, harmful_combustion_products,             suitable_extinguishing_media, unsuitable_extinguishing_media,             fire_fighting_equipment, fire_fighting_procedures, flash_point,             autoignition_temperature, flammability_limits, fire_risk_classification,             create_by, create_time         )values(             ?, ?, ?,             ?, ?,             ?, ?, ?,             ?, ?, ?,             ?, NOW()         )\\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\\n; bad SQL grammar []\"],\"successList\":[],\"duplicateCount\":0,\"successCount\":0,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":1}}', 0, NULL, '2025-10-17 03:22:30', 140);
INSERT INTO `sys_oper_log` VALUES (309, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/116', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 04:45:42', 59);
INSERT INTO `sys_oper_log` VALUES (310, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[\"第1条记录: \\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\\n### The error may exist in URL [jar:nested:/app/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/MsdsFireFightingMapper.xml]\\n### The error may involve com.ruoyi.system.mapper.MsdsFireFightingMapper.insertMsdsFireFighting-Inline\\n### The error occurred while setting parameters\\n### SQL: insert into msds_fire_fighting (             msds_id, hazard_characteristics, harmful_combustion_products,             suitable_extinguishing_media, unsuitable_extinguishing_media,             fire_fighting_equipment, fire_fighting_procedures, flash_point,             autoignition_temperature, flammability_limits, fire_risk_classification,             create_by, create_time         )values(             ?, ?, ?,             ?, ?,             ?, ?, ?,             ?, ?, ?,             ?, NOW()         )\\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\\n; bad SQL grammar []\"],\"successList\":[],\"duplicateCount\":0,\"successCount\":0,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":1}}', 0, NULL, '2025-10-17 04:45:49', 769);
INSERT INTO `sys_oper_log` VALUES (311, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/117', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 05:47:07', 41);
INSERT INTO `sys_oper_log` VALUES (312, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[\"第1条记录: \\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\\n### The error may exist in URL [jar:nested:/app/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/MsdsToxicologicalMapper.xml]\\n### The error may involve com.ruoyi.system.mapper.MsdsToxicologicalMapper.insertMsdsToxicological-Inline\\n### The error occurred while setting parameters\\n### SQL: insert into msds_toxicological (             msds_id, acute_toxicity, ld50_oral, ld50_dermal, lc50_inhalation,             subacute_chronic, skin_irritation, eye_irritation, respiratory_irritation,             sensitization, mutagenicity, teratogenicity, reproductive_toxicity,             carcinogenicity, carcinogen_classification, specific_target_organ,             aspiration_hazard, other_toxicity, rtecs, create_by, create_time         )values(             ?, ?, ?, ?, ?,             ?, ?, ?, ?,             ?, ?, ?, ?,             ?, ?, ?,             ?, ?, ?, ?, NOW()         )\\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\\n; bad SQL grammar []\"],\"successList\":[],\"duplicateCount\":0,\"successCount\":0,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":1}}', 0, NULL, '2025-10-17 05:47:19', 74);
INSERT INTO `sys_oper_log` VALUES (313, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[],\"duplicateCount\":1,\"successCount\":0,\"duplicateList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-17 05:48:26', 21);
INSERT INTO `sys_oper_log` VALUES (314, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/118', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 05:49:07', 27);
INSERT INTO `sys_oper_log` VALUES (315, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[\"第1条记录: \\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\\n### The error may exist in URL [jar:nested:/app/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/MsdsToxicologicalMapper.xml]\\n### The error may involve com.ruoyi.system.mapper.MsdsToxicologicalMapper.insertMsdsToxicological-Inline\\n### The error occurred while setting parameters\\n### SQL: insert into msds_toxicological (             msds_id, acute_toxicity, ld50_oral, ld50_dermal, lc50_inhalation,             subacute_chronic, skin_irritation, eye_irritation, respiratory_irritation,             sensitization, mutagenicity, teratogenicity, reproductive_toxicity,             carcinogenicity, carcinogen_classification, specific_target_organ,             aspiration_hazard, other_toxicity, rtecs, create_by, create_time         )values(             ?, ?, ?, ?, ?,             ?, ?, ?, ?,             ?, ?, ?, ?,             ?, ?, ?,             ?, ?, ?, ?, NOW()         )\\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\\n; bad SQL grammar []\"],\"successList\":[],\"duplicateCount\":0,\"successCount\":0,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":1}}', 0, NULL, '2025-10-17 05:49:16', 24);
INSERT INTO `sys_oper_log` VALUES (316, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/119', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 06:06:21', 61);
INSERT INTO `sys_oper_log` VALUES (317, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"硫丹测试 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-17 06:06:57', 97);
INSERT INTO `sys_oper_log` VALUES (318, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/120', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 06:08:38', 18);
INSERT INTO `sys_oper_log` VALUES (319, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"硫丹测试 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-17 06:08:48', 24);
INSERT INTO `sys_oper_log` VALUES (320, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/121', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 06:15:02', 26);
INSERT INTO `sys_oper_log` VALUES (321, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"硫丹测试 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-17 06:15:11', 44);
INSERT INTO `sys_oper_log` VALUES (322, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/122', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 06:21:34', 26);
INSERT INTO `sys_oper_log` VALUES (323, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"硫丹测试 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-17 06:21:42', 81);
INSERT INTO `sys_oper_log` VALUES (324, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/123', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 06:24:28', 34);
INSERT INTO `sys_oper_log` VALUES (325, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[\"第1条记录: \\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\\n### The error may exist in URL [jar:nested:/app/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/MsdsFireFightingMapper.xml]\\n### The error may involve com.ruoyi.system.mapper.MsdsFireFightingMapper.insertMsdsFireFighting-Inline\\n### The error occurred while setting parameters\\n### SQL: insert into msds_fire_fighting (             msds_id, hazard_characteristics, harmful_combustion_products,             suitable_extinguishing_media, unsuitable_extinguishing_media,             fire_fighting_equipment, fire_fighting_procedures, flash_point,             autoignition_temperature, flammability_limits, fire_risk_classification,             create_by, create_time         )values(             ?, ?, ?,             ?, ?,             ?, ?, ?,             ?, ?, ?,             ?, NOW()         )\\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\\n; bad SQL grammar []\"],\"successList\":[],\"duplicateCount\":0,\"successCount\":0,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":1}}', 0, NULL, '2025-10-17 06:24:44', 272);
INSERT INTO `sys_oper_log` VALUES (326, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/124', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 07:39:02', 55);
INSERT INTO `sys_oper_log` VALUES (327, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[\"第1条记录: \\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\\n### The error may exist in URL [jar:nested:/app/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/MsdsFireFightingMapper.xml]\\n### The error may involve com.ruoyi.system.mapper.MsdsFireFightingMapper.insertMsdsFireFighting-Inline\\n### The error occurred while setting parameters\\n### SQL: insert into msds_fire_fighting (             msds_id, hazard_characteristics, harmful_combustion_products,             suitable_extinguishing_media, unsuitable_extinguishing_media,             fire_fighting_equipment, fire_fighting_procedures, flash_point,             autoignition_temperature, flammability_limits, fire_risk_classification,             create_by, create_time         )values(             ?, ?, ?,             ?, ?,             ?, ?, ?,             ?, ?, ?,             ?, NOW()         )\\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\\n; bad SQL grammar []\"],\"successList\":[],\"duplicateCount\":0,\"successCount\":0,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":1}}', 0, NULL, '2025-10-17 07:39:11', 106);
INSERT INTO `sys_oper_log` VALUES (328, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/125', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 08:42:16', 48);
INSERT INTO `sys_oper_log` VALUES (329, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[\"第1条记录: \\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\\n### The error may exist in URL [jar:nested:/app/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/MsdsFireFightingMapper.xml]\\n### The error may involve com.ruoyi.system.mapper.MsdsFireFightingMapper.insertMsdsFireFighting-Inline\\n### The error occurred while setting parameters\\n### SQL: insert into msds_fire_fighting (             msds_id, hazard_characteristics, harmful_combustion_products,             suitable_extinguishing_media, unsuitable_extinguishing_media,             fire_fighting_equipment, fire_fighting_procedures, flash_point,             autoignition_temperature, flammability_limits, fire_risk_classification,             create_by, create_time         )values(             ?, ?, ?,             ?, ?,             ?, ?, ?,             ?, ?, ?,             ?, NOW()         )\\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\\n; bad SQL grammar []\"],\"successList\":[],\"duplicateCount\":0,\"successCount\":0,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":1}}', 0, NULL, '2025-10-17 08:42:28', 130);
INSERT INTO `sys_oper_log` VALUES (330, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/126', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 08:43:12', 13);
INSERT INTO `sys_oper_log` VALUES (331, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"硫丹测试 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-17 08:43:19', 27);
INSERT INTO `sys_oper_log` VALUES (332, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/127', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 12:51:08', 1516);
INSERT INTO `sys_oper_log` VALUES (333, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[\"第1条记录: \\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\\n### The error may exist in URL [jar:nested:/app/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/MsdsFireFightingMapper.xml]\\n### The error may involve com.ruoyi.system.mapper.MsdsFireFightingMapper.insertMsdsFireFighting-Inline\\n### The error occurred while setting parameters\\n### SQL: insert into msds_fire_fighting (             msds_id, hazard_characteristics, harmful_combustion_products,             suitable_extinguishing_media, unsuitable_extinguishing_media,             fire_fighting_equipment, fire_fighting_procedures, flash_point,             autoignition_temperature, flammability_limits, fire_risk_classification,             create_by, create_time         )values(             ?, ?, ?,             ?, ?,             ?, ?, ?,             ?, ?, ?,             ?, NOW()         )\\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\\n; bad SQL grammar []\"],\"successList\":[],\"duplicateCount\":0,\"successCount\":0,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":1}}', 0, NULL, '2025-10-17 12:52:09', 2667);
INSERT INTO `sys_oper_log` VALUES (334, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/128', '172.20.0.6', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 13:56:31', 38);
INSERT INTO `sys_oper_log` VALUES (335, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[\"第1条记录: \\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\\n### The error may exist in URL [jar:nested:/app/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/MsdsFireFightingMapper.xml]\\n### The error may involve com.ruoyi.system.mapper.MsdsFireFightingMapper.insertMsdsFireFighting-Inline\\n### The error occurred while setting parameters\\n### SQL: insert into msds_fire_fighting (             msds_id, hazard_characteristics, harmful_combustion_products,             suitable_extinguishing_media, unsuitable_extinguishing_media,             fire_fighting_equipment, fire_fighting_procedures, flash_point,             autoignition_temperature, flammability_limits, fire_risk_classification,             create_by, create_time         )values(             ?, ?, ?,             ?, ?,             ?, ?, ?,             ?, ?, ?,             ?, NOW()         )\\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_by\' in \'field list\'\\n; bad SQL grammar []\"],\"successList\":[],\"duplicateCount\":0,\"successCount\":0,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":1}}', 0, NULL, '2025-10-17 13:56:40', 93);
INSERT INTO `sys_oper_log` VALUES (336, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/129', '172.20.0.6', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 14:00:59', 9);
INSERT INTO `sys_oper_log` VALUES (337, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"简单测试 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-17 14:01:09', 43);
INSERT INTO `sys_oper_log` VALUES (338, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/130', '172.20.0.6', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 14:09:50', 49);
INSERT INTO `sys_oper_log` VALUES (339, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-17 14:10:01', 294);
INSERT INTO `sys_oper_log` VALUES (340, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/131', '172.20.0.6', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 14:10:24', 11);
INSERT INTO `sys_oper_log` VALUES (341, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"简单测试 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-17 14:10:34', 51);
INSERT INTO `sys_oper_log` VALUES (342, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/132', '172.20.0.6', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 14:26:39', 31);
INSERT INTO `sys_oper_log` VALUES (343, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"简单测试 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-17 14:26:49', 103);
INSERT INTO `sys_oper_log` VALUES (344, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/133', '172.20.0.6', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 14:31:43', 18);
INSERT INTO `sys_oper_log` VALUES (345, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"完整测试化学品 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-17 14:31:50', 112);
INSERT INTO `sys_oper_log` VALUES (346, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/134', '172.20.0.6', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 14:39:10', 12);
INSERT INTO `sys_oper_log` VALUES (347, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"完整测试化学品 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-17 14:39:19', 132);
INSERT INTO `sys_oper_log` VALUES (348, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/135', '172.20.0.6', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-17 14:52:46', 34);
INSERT INTO `sys_oper_log` VALUES (349, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"完整测试化学品 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-17 14:53:01', 296);
INSERT INTO `sys_oper_log` VALUES (350, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/136', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-18 11:51:17', 60);
INSERT INTO `sys_oper_log` VALUES (351, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-18 11:51:24', 302);
INSERT INTO `sys_oper_log` VALUES (352, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/137', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-18 12:13:16', 53);
INSERT INTO `sys_oper_log` VALUES (353, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"完整测试化学品 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-18 12:13:31', 158);
INSERT INTO `sys_oper_log` VALUES (354, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[],\"duplicateCount\":1,\"successCount\":0,\"duplicateList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-18 12:14:01', 10);
INSERT INTO `sys_oper_log` VALUES (355, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[],\"duplicateCount\":1,\"successCount\":0,\"duplicateList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-18 12:14:17', 11);
INSERT INTO `sys_oper_log` VALUES (356, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/138', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-18 12:16:25', 15);
INSERT INTO `sys_oper_log` VALUES (357, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-18 12:16:31', 146);
INSERT INTO `sys_oper_log` VALUES (358, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/139', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-18 12:35:08', 17);
INSERT INTO `sys_oper_log` VALUES (359, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-18 12:35:21', 118);
INSERT INTO `sys_oper_log` VALUES (360, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/140', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-18 12:52:42', 18);
INSERT INTO `sys_oper_log` VALUES (361, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-18 12:52:54', 142);
INSERT INTO `sys_oper_log` VALUES (362, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/141', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-18 13:11:48', 23);
INSERT INTO `sys_oper_log` VALUES (363, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-18 13:12:25', 272);
INSERT INTO `sys_oper_log` VALUES (364, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/142', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-19 03:17:26', 82);
INSERT INTO `sys_oper_log` VALUES (365, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-19 03:17:33', 162);
INSERT INTO `sys_oper_log` VALUES (366, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/143', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-19 03:35:25', 29);
INSERT INTO `sys_oper_log` VALUES (367, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-19 03:35:31', 166);
INSERT INTO `sys_oper_log` VALUES (368, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/144', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-19 03:41:55', 28);
INSERT INTO `sys_oper_log` VALUES (369, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-19 03:42:24', 170);
INSERT INTO `sys_oper_log` VALUES (370, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/145', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-19 03:49:02', 10);
INSERT INTO `sys_oper_log` VALUES (371, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-19 03:49:10', 159);
INSERT INTO `sys_oper_log` VALUES (372, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/146', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-19 03:50:16', 9);
INSERT INTO `sys_oper_log` VALUES (373, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-19 03:50:23', 93);
INSERT INTO `sys_oper_log` VALUES (374, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/147', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-19 04:03:09', 11);
INSERT INTO `sys_oper_log` VALUES (375, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-19 04:03:16', 133);
INSERT INTO `sys_oper_log` VALUES (376, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/148', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-19 05:28:34', 31);
INSERT INTO `sys_oper_log` VALUES (377, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-19 05:28:41', 207);
INSERT INTO `sys_oper_log` VALUES (378, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/149', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-19 05:29:23', 23);
INSERT INTO `sys_oper_log` VALUES (379, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-19 05:29:33', 89);
INSERT INTO `sys_oper_log` VALUES (380, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/150', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-19 05:33:31', 36);
INSERT INTO `sys_oper_log` VALUES (381, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-19 05:33:49', 204);
INSERT INTO `sys_oper_log` VALUES (382, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/151', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-19 05:55:59', 76);
INSERT INTO `sys_oper_log` VALUES (383, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-19 05:56:08', 185);
INSERT INTO `sys_oper_log` VALUES (384, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/152', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-19 09:28:32', 109);
INSERT INTO `sys_oper_log` VALUES (385, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-19 09:28:40', 241);
INSERT INTO `sys_oper_log` VALUES (386, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/153', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-19 11:03:37', 9);
INSERT INTO `sys_oper_log` VALUES (387, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-19 11:05:06', 77);
INSERT INTO `sys_oper_log` VALUES (388, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/154', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-19 11:16:54', 21);
INSERT INTO `sys_oper_log` VALUES (389, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-19 11:17:02', 121);
INSERT INTO `sys_oper_log` VALUES (390, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/155', '172.20.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-19 12:17:33', 31);
INSERT INTO `sys_oper_log` VALUES (391, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-19 12:17:41', 179);
INSERT INTO `sys_oper_log` VALUES (392, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/156', '172.20.0.6', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-20 01:34:06', 64);
INSERT INTO `sys_oper_log` VALUES (393, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-20 01:34:14', 183);
INSERT INTO `sys_oper_log` VALUES (394, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/157', '172.20.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-21 06:09:59', 90);
INSERT INTO `sys_oper_log` VALUES (395, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.4', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-21 06:10:41', 154);
INSERT INTO `sys_oper_log` VALUES (396, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/158', '172.20.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-21 06:20:36', 61);
INSERT INTO `sys_oper_log` VALUES (397, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.4', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-21 06:20:48', 292);
INSERT INTO `sys_oper_log` VALUES (398, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/159', '172.20.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-21 06:41:48', 33);
INSERT INTO `sys_oper_log` VALUES (399, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.4', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-21 06:41:55', 203);
INSERT INTO `sys_oper_log` VALUES (400, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/160', '172.20.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-21 07:01:12', 35);
INSERT INTO `sys_oper_log` VALUES (401, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.4', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-21 07:01:19', 203);
INSERT INTO `sys_oper_log` VALUES (402, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/161', '172.20.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-21 07:10:20', 63);
INSERT INTO `sys_oper_log` VALUES (403, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.4', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-21 07:10:28', 261);
INSERT INTO `sys_oper_log` VALUES (404, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/162', '172.20.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-21 07:13:00', 15);
INSERT INTO `sys_oper_log` VALUES (405, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.4', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-21 07:13:07', 144);
INSERT INTO `sys_oper_log` VALUES (406, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.4', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[],\"duplicateCount\":1,\"successCount\":0,\"duplicateList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-21 07:13:11', 20);
INSERT INTO `sys_oper_log` VALUES (407, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/163', '172.20.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-21 07:20:38', 47);
INSERT INTO `sys_oper_log` VALUES (408, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.4', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-21 07:20:45', 241);
INSERT INTO `sys_oper_log` VALUES (409, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[\"第1条记录: \\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'company_name\' cannot be null\\n### The error may exist in URL [jar:nested:/app/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/MsdsMainMapper.xml]\\n### The error may involve com.ruoyi.system.mapper.MsdsMainMapper.insertMsdsMain-Inline\\n### The error occurred while setting parameters\\n### SQL: insert into msds_main (             cas_number, msds_code, product_name, product_alias, product_english_name,              category_id, company_name, company_address, zip_code, fax_number,              contact_phone, email, emergency_phone, recommended_usage, restricted_usage,              version, revision_date, effective_date, status, approver, approval_date,             is_active, remark         )values(             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?, ?,             ?, ?         )\\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'company_name\' cannot be null\\n; Column \'company_name\' cannot be null\"],\"successList\":[],\"duplicateCount\":0,\"successCount\":0,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":1}}', 0, NULL, '2025-10-22 03:15:00', 156);
INSERT INTO `sys_oper_log` VALUES (410, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[\"第1条记录: \\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'company_name\' cannot be null\\n### The error may exist in URL [jar:nested:/app/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/MsdsMainMapper.xml]\\n### The error may involve com.ruoyi.system.mapper.MsdsMainMapper.insertMsdsMain-Inline\\n### The error occurred while setting parameters\\n### SQL: insert into msds_main (             cas_number, msds_code, product_name, product_alias, product_english_name,              category_id, company_name, company_address, zip_code, fax_number,              contact_phone, email, emergency_phone, recommended_usage, restricted_usage,              version, revision_date, effective_date, status, approver, approval_date,             is_active, remark         )values(             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?, ?,             ?, ?         )\\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'company_name\' cannot be null\\n; Column \'company_name\' cannot be null\"],\"successList\":[],\"duplicateCount\":0,\"successCount\":0,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":1}}', 0, NULL, '2025-10-22 03:15:38', 26);
INSERT INTO `sys_oper_log` VALUES (411, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[\"第1条记录: \\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'company_name\' cannot be null\\n### The error may exist in URL [jar:nested:/app/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/MsdsMainMapper.xml]\\n### The error may involve com.ruoyi.system.mapper.MsdsMainMapper.insertMsdsMain-Inline\\n### The error occurred while setting parameters\\n### SQL: insert into msds_main (             cas_number, msds_code, product_name, product_alias, product_english_name,              category_id, company_name, company_address, zip_code, fax_number,              contact_phone, email, emergency_phone, recommended_usage, restricted_usage,              version, revision_date, effective_date, status, approver, approval_date,             is_active, remark         )values(             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?, ?,             ?, ?         )\\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'company_name\' cannot be null\\n; Column \'company_name\' cannot be null\"],\"successList\":[],\"duplicateCount\":0,\"successCount\":0,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":1}}', 0, NULL, '2025-10-22 03:21:50', 26);
INSERT INTO `sys_oper_log` VALUES (412, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[\"第1条记录: \\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'company_name\' cannot be null\\n### The error may exist in URL [jar:nested:/app/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/MsdsMainMapper.xml]\\n### The error may involve com.ruoyi.system.mapper.MsdsMainMapper.insertMsdsMain-Inline\\n### The error occurred while setting parameters\\n### SQL: insert into msds_main (             cas_number, msds_code, product_name, product_alias, product_english_name,              category_id, company_name, company_address, zip_code, fax_number,              contact_phone, email, emergency_phone, recommended_usage, restricted_usage,              version, revision_date, effective_date, status, approver, approval_date,             is_active, remark         )values(             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?, ?,             ?, ?         )\\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'company_name\' cannot be null\\n; Column \'company_name\' cannot be null\"],\"successList\":[],\"duplicateCount\":0,\"successCount\":0,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":1}}', 0, NULL, '2025-10-22 03:41:44', 21);
INSERT INTO `sys_oper_log` VALUES (413, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[\"第1条记录: \\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'company_name\' cannot be null\\n### The error may exist in URL [jar:nested:/app/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/MsdsMainMapper.xml]\\n### The error may involve com.ruoyi.system.mapper.MsdsMainMapper.insertMsdsMain-Inline\\n### The error occurred while setting parameters\\n### SQL: insert into msds_main (             cas_number, msds_code, product_name, product_alias, product_english_name,              category_id, company_name, company_address, zip_code, fax_number,              contact_phone, email, emergency_phone, recommended_usage, restricted_usage,              version, revision_date, effective_date, status, approver, approval_date,             is_active, remark         )values(             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?, ?,             ?, ?         )\\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'company_name\' cannot be null\\n; Column \'company_name\' cannot be null\"],\"successList\":[],\"duplicateCount\":0,\"successCount\":0,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":1}}', 0, NULL, '2025-10-22 03:43:36', 20);
INSERT INTO `sys_oper_log` VALUES (414, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[\"第1条记录: \\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'company_name\' cannot be null\\n### The error may exist in URL [jar:nested:/app/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/MsdsMainMapper.xml]\\n### The error may involve com.ruoyi.system.mapper.MsdsMainMapper.insertMsdsMain-Inline\\n### The error occurred while setting parameters\\n### SQL: insert into msds_main (             cas_number, msds_code, product_name, product_alias, product_english_name,              category_id, company_name, company_address, zip_code, fax_number,              contact_phone, email, emergency_phone, recommended_usage, restricted_usage,              version, revision_date, effective_date, status, approver, approval_date,             is_active, remark         )values(             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?, ?,             ?, ?         )\\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'company_name\' cannot be null\\n; Column \'company_name\' cannot be null\"],\"successList\":[],\"duplicateCount\":0,\"successCount\":0,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":1}}', 0, NULL, '2025-10-22 06:21:21', 105);
INSERT INTO `sys_oper_log` VALUES (415, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[\"第1条记录: \\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'company_name\' cannot be null\\n### The error may exist in URL [jar:nested:/app/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/MsdsMainMapper.xml]\\n### The error may involve com.ruoyi.system.mapper.MsdsMainMapper.insertMsdsMain-Inline\\n### The error occurred while setting parameters\\n### SQL: insert into msds_main (             cas_number, msds_code, product_name, product_alias, product_english_name,              category_id, company_name, company_address, zip_code, fax_number,              contact_phone, email, emergency_phone, recommended_usage, restricted_usage,              version, revision_date, effective_date, status, approver, approval_date,             is_active, remark         )values(             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?, ?,             ?, ?         )\\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Column \'company_name\' cannot be null\\n; Column \'company_name\' cannot be null\"],\"successList\":[],\"duplicateCount\":0,\"successCount\":0,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":1}}', 0, NULL, '2025-10-22 06:21:43', 75);
INSERT INTO `sys_oper_log` VALUES (416, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1R,2R,4R)-冰片-2-硫氰基醋酸酯 (CAS: 115-31-1)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-22 06:29:21', 289);
INSERT INTO `sys_oper_log` VALUES (417, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.6', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(S)-3-(1-甲基吡咯烷-2-基)吡啶 (CAS: 54-11-5)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-22 06:32:14', 139);
INSERT INTO `sys_oper_log` VALUES (418, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.2', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"0，0-二乙基硫代磷酰氯 (CAS: 2524-04-1)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-23 15:09:10', 224);
INSERT INTO `sys_oper_log` VALUES (419, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.20.0.2', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"1-(2-过氧化乙基己醇-1,3-二甲 (CAS: 228415-62-1)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-10-23 15:09:24', 147);
INSERT INTO `sys_oper_log` VALUES (420, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/164', '172.20.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-10-27 13:16:21', 80);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int(0) NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '岗位信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '董事长', 1, '0', 'admin', '2025-06-24 19:45:05', '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', '2025-06-24 19:45:05', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '0', 'admin', '2025-06-24 19:45:05', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'user', '普通员工', 4, '0', 'admin', '2025-06-24 19:45:05', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int(0) NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2025-06-24 19:45:05', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2025-06-24 19:45:05', '', NULL, '普通角色');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint(0) NOT NULL COMMENT '角色ID',
  `dept_id` bigint(0) NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色和部门关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint(0) NOT NULL COMMENT '角色ID',
  `menu_id` bigint(0) NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (1, 2000);
INSERT INTO `sys_role_menu` VALUES (1, 2001);
INSERT INTO `sys_role_menu` VALUES (1, 2002);
INSERT INTO `sys_role_menu` VALUES (1, 2003);
INSERT INTO `sys_role_menu` VALUES (1, 2004);
INSERT INTO `sys_role_menu` VALUES (1, 2005);
INSERT INTO `sys_role_menu` VALUES (1, 2006);
INSERT INTO `sys_role_menu` VALUES (1, 2007);
INSERT INTO `sys_role_menu` VALUES (2, 1);
INSERT INTO `sys_role_menu` VALUES (2, 2);
INSERT INTO `sys_role_menu` VALUES (2, 3);
INSERT INTO `sys_role_menu` VALUES (2, 4);
INSERT INTO `sys_role_menu` VALUES (2, 100);
INSERT INTO `sys_role_menu` VALUES (2, 101);
INSERT INTO `sys_role_menu` VALUES (2, 102);
INSERT INTO `sys_role_menu` VALUES (2, 103);
INSERT INTO `sys_role_menu` VALUES (2, 104);
INSERT INTO `sys_role_menu` VALUES (2, 105);
INSERT INTO `sys_role_menu` VALUES (2, 106);
INSERT INTO `sys_role_menu` VALUES (2, 107);
INSERT INTO `sys_role_menu` VALUES (2, 108);
INSERT INTO `sys_role_menu` VALUES (2, 109);
INSERT INTO `sys_role_menu` VALUES (2, 110);
INSERT INTO `sys_role_menu` VALUES (2, 111);
INSERT INTO `sys_role_menu` VALUES (2, 112);
INSERT INTO `sys_role_menu` VALUES (2, 113);
INSERT INTO `sys_role_menu` VALUES (2, 114);
INSERT INTO `sys_role_menu` VALUES (2, 115);
INSERT INTO `sys_role_menu` VALUES (2, 116);
INSERT INTO `sys_role_menu` VALUES (2, 117);
INSERT INTO `sys_role_menu` VALUES (2, 500);
INSERT INTO `sys_role_menu` VALUES (2, 501);
INSERT INTO `sys_role_menu` VALUES (2, 1000);
INSERT INTO `sys_role_menu` VALUES (2, 1001);
INSERT INTO `sys_role_menu` VALUES (2, 1002);
INSERT INTO `sys_role_menu` VALUES (2, 1003);
INSERT INTO `sys_role_menu` VALUES (2, 1004);
INSERT INTO `sys_role_menu` VALUES (2, 1005);
INSERT INTO `sys_role_menu` VALUES (2, 1006);
INSERT INTO `sys_role_menu` VALUES (2, 1007);
INSERT INTO `sys_role_menu` VALUES (2, 1008);
INSERT INTO `sys_role_menu` VALUES (2, 1009);
INSERT INTO `sys_role_menu` VALUES (2, 1010);
INSERT INTO `sys_role_menu` VALUES (2, 1011);
INSERT INTO `sys_role_menu` VALUES (2, 1012);
INSERT INTO `sys_role_menu` VALUES (2, 1013);
INSERT INTO `sys_role_menu` VALUES (2, 1014);
INSERT INTO `sys_role_menu` VALUES (2, 1015);
INSERT INTO `sys_role_menu` VALUES (2, 1016);
INSERT INTO `sys_role_menu` VALUES (2, 1017);
INSERT INTO `sys_role_menu` VALUES (2, 1018);
INSERT INTO `sys_role_menu` VALUES (2, 1019);
INSERT INTO `sys_role_menu` VALUES (2, 1020);
INSERT INTO `sys_role_menu` VALUES (2, 1021);
INSERT INTO `sys_role_menu` VALUES (2, 1022);
INSERT INTO `sys_role_menu` VALUES (2, 1023);
INSERT INTO `sys_role_menu` VALUES (2, 1024);
INSERT INTO `sys_role_menu` VALUES (2, 1025);
INSERT INTO `sys_role_menu` VALUES (2, 1026);
INSERT INTO `sys_role_menu` VALUES (2, 1027);
INSERT INTO `sys_role_menu` VALUES (2, 1028);
INSERT INTO `sys_role_menu` VALUES (2, 1029);
INSERT INTO `sys_role_menu` VALUES (2, 1030);
INSERT INTO `sys_role_menu` VALUES (2, 1031);
INSERT INTO `sys_role_menu` VALUES (2, 1032);
INSERT INTO `sys_role_menu` VALUES (2, 1033);
INSERT INTO `sys_role_menu` VALUES (2, 1034);
INSERT INTO `sys_role_menu` VALUES (2, 1035);
INSERT INTO `sys_role_menu` VALUES (2, 1036);
INSERT INTO `sys_role_menu` VALUES (2, 1037);
INSERT INTO `sys_role_menu` VALUES (2, 1038);
INSERT INTO `sys_role_menu` VALUES (2, 1039);
INSERT INTO `sys_role_menu` VALUES (2, 1040);
INSERT INTO `sys_role_menu` VALUES (2, 1041);
INSERT INTO `sys_role_menu` VALUES (2, 1042);
INSERT INTO `sys_role_menu` VALUES (2, 1043);
INSERT INTO `sys_role_menu` VALUES (2, 1044);
INSERT INTO `sys_role_menu` VALUES (2, 1045);
INSERT INTO `sys_role_menu` VALUES (2, 1046);
INSERT INTO `sys_role_menu` VALUES (2, 1047);
INSERT INTO `sys_role_menu` VALUES (2, 1048);
INSERT INTO `sys_role_menu` VALUES (2, 1049);
INSERT INTO `sys_role_menu` VALUES (2, 1050);
INSERT INTO `sys_role_menu` VALUES (2, 1051);
INSERT INTO `sys_role_menu` VALUES (2, 1052);
INSERT INTO `sys_role_menu` VALUES (2, 1053);
INSERT INTO `sys_role_menu` VALUES (2, 1054);
INSERT INTO `sys_role_menu` VALUES (2, 1055);
INSERT INTO `sys_role_menu` VALUES (2, 1056);
INSERT INTO `sys_role_menu` VALUES (2, 1057);
INSERT INTO `sys_role_menu` VALUES (2, 1058);
INSERT INTO `sys_role_menu` VALUES (2, 1059);
INSERT INTO `sys_role_menu` VALUES (2, 1060);
INSERT INTO `sys_role_menu` VALUES (2, 2000);
INSERT INTO `sys_role_menu` VALUES (2, 2001);
INSERT INTO `sys_role_menu` VALUES (2, 2002);
INSERT INTO `sys_role_menu` VALUES (2, 2003);
INSERT INTO `sys_role_menu` VALUES (2, 2004);
INSERT INTO `sys_role_menu` VALUES (2, 2005);
INSERT INTO `sys_role_menu` VALUES (2, 2006);
INSERT INTO `sys_role_menu` VALUES (2, 2007);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint(0) NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime(0) NULL DEFAULT NULL COMMENT '最后登录时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '172.19.0.6', '2025-10-30 10:27:38', 'admin', '2025-10-23 14:48:41', '', '2025-10-30 02:27:37', '管理员');
INSERT INTO `sys_user` VALUES (2, 105, 'ry', '若依', '00', 'ry@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2025-10-23 14:48:41', 'admin', '2025-10-23 14:48:41', '', NULL, '测试员');

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint(0) NOT NULL COMMENT '用户ID',
  `post_id` bigint(0) NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);
INSERT INTO `sys_user_post` VALUES (2, 2);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint(0) NOT NULL COMMENT '用户ID',
  `role_id` bigint(0) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户和角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);

-- ----------------------------
-- Table structure for system_log
-- ----------------------------
DROP TABLE IF EXISTS `system_log`;
CREATE TABLE `system_log`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `table_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '表名',
  `record_id` bigint(0) NOT NULL COMMENT '记录ID',
  `operation_type` enum('INSERT','UPDATE','DELETE') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '操作类型',
  `old_values` json NULL COMMENT '修改前的值',
  `new_values` json NULL COMMENT '修改后的值',
  `operator` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作人',
  `operation_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  `ip_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'IP地址',
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '用户代理',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_table_record`(`table_name`, `record_id`) USING BTREE,
  INDEX `idx_operation_time`(`operation_time`) USING BTREE,
  INDEX `idx_operator`(`operator`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统操作日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for testxumcp
-- ----------------------------
DROP TABLE IF EXISTS `testxumcp`;
CREATE TABLE `testxumcp`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `studen` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学生信息',
  `englig` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '英语相关',
  `user` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户信息',
  `logi` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '逻辑信息',
  `xutest` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '徐测试字段',
  `created_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `status` tinyint(0) NULL DEFAULT 1 COMMENT '状态: 1-正常, 0-禁用',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'MCP测试表 - 徐测试' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of testxumcp
-- ----------------------------
INSERT INTO `testxumcp` VALUES (1, '张三', 'English Level 1', 'user001', '登录成功', '这是徐测试的第一个测试数据', '2025-09-28 08:03:06', '2025-09-28 08:03:06', 1);
INSERT INTO `testxumcp` VALUES (2, '李四', 'English Level 2', 'user002', '登录失败', '这是徐测试的第二个测试数据', '2025-09-28 08:03:06', '2025-09-28 08:03:06', 1);
INSERT INTO `testxumcp` VALUES (3, '王五', 'English Level 3', 'user003', '登录超时', '这是徐测试的第三个测试数据', '2025-09-28 08:03:06', '2025-09-28 08:03:06', 1);

SET FOREIGN_KEY_CHECKS = 1;
