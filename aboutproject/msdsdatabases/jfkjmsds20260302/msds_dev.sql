/*
 Navicat Premium Dump SQL

 Source Server         : localjfkj-dockermsds_3306
 Source Server Type    : MySQL
 Source Server Version : 80042 (8.0.42)
 Source Host           : localhost:3306
 Source Schema         : msds_dev

 Target Server Type    : MySQL
 Target Server Version : 80042 (8.0.42)
 File Encoding         : 65001

 Date: 02/03/2026 16:17:24
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for chemical_category
-- ----------------------------
DROP TABLE IF EXISTS `chemical_category`;
CREATE TABLE `chemical_category`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `category_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类代码',
  `category_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类名称',
  `parent_id` int NULL DEFAULT NULL COMMENT '父分类ID',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '分类描述',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '是否有效',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `category_code`(`category_code` ASC) USING BTREE,
  INDEX `idx_parent_id`(`parent_id` ASC) USING BTREE,
  INDEX `idx_category_code`(`category_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '化学品分类表' ROW_FORMAT = Dynamic;

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
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
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
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '代码生成业务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table
-- ----------------------------

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint NULL DEFAULT NULL COMMENT '归属表编号',
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
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------

-- ----------------------------
-- Table structure for ghs_hazard_class
-- ----------------------------
DROP TABLE IF EXISTS `ghs_hazard_class`;
CREATE TABLE `ghs_hazard_class`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `class_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '危险类别代码',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '危险类别名称',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '危险类别',
  `pictogram` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '象形图代码',
  `signal_word` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '警示词',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '描述',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '是否有效',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `class_code`(`class_code` ASC) USING BTREE,
  INDEX `idx_class_code`(`class_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'GHS危险性分类标准表' ROW_FORMAT = Dynamic;

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
-- Table structure for msds_about_us
-- ----------------------------
DROP TABLE IF EXISTS `msds_about_us`;
CREATE TABLE `msds_about_us`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标题',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '内容',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类型(about, privacy, terms)',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_type`(`type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '关于我们表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_about_us
-- ----------------------------
INSERT INTO `msds_about_us` VALUES (1, '关于我们有这样的系统说明', 'MSDS实验室管理系统...', 'about', '0', '', '2025-12-03 08:06:54', 'admin', '2025-12-04 12:08:30', NULL);
INSERT INTO `msds_about_us` VALUES (2, '隐私政策', '<p>隐私政策内容...</p>', 'privacy', '0', '', '2025-12-03 08:06:54', '', NULL, NULL);
INSERT INTO `msds_about_us` VALUES (3, '服务条款', '<p>服务条款内容...</p>', 'terms', '0', '', '2025-12-03 08:06:54', '', NULL, NULL);

-- ----------------------------
-- Table structure for msds_approval_workflow
-- ----------------------------
DROP TABLE IF EXISTS `msds_approval_workflow`;
CREATE TABLE `msds_approval_workflow`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
  `step_no` int NOT NULL COMMENT '审批步骤序号',
  `step_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '审批步骤名称',
  `approver` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审批人',
  `approval_status` enum('pending','approved','rejected','skipped') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'pending' COMMENT '审批状态',
  `approval_date` datetime NULL DEFAULT NULL COMMENT '审批时间',
  `approval_comments` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '审批意见',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_msds_id`(`msds_id` ASC) USING BTREE,
  INDEX `idx_step_no`(`step_no` ASC) USING BTREE,
  INDEX `idx_approval_status`(`approval_status` ASC) USING BTREE,
  CONSTRAINT `msds_approval_workflow_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'MSDS审批流程表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_approval_workflow
-- ----------------------------

-- ----------------------------
-- Table structure for msds_component
-- ----------------------------
DROP TABLE IF EXISTS `msds_component`;
CREATE TABLE `msds_component`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
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
  `create_time` datetime NULL DEFAULT NULL,
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_msds_id`(`msds_id` ASC) USING BTREE,
  INDEX `idx_component_name`(`component_name` ASC) USING BTREE,
  INDEX `idx_cas_number`(`cas_number` ASC) USING BTREE,
  CONSTRAINT `msds_component_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 80 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '成分/组成信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_component
-- ----------------------------
INSERT INTO `msds_component` VALUES (73, 174, '硫丹; (1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯', NULL, '100%', NULL, NULL, '115-29-7', NULL, NULL, NULL, 0, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_component` VALUES (74, 175, '杀那脱；敌稻瘟', NULL, '100%', NULL, NULL, '115-31-1', NULL, NULL, NULL, 0, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_component` VALUES (75, 176, '狄氏剂', NULL, '100%', NULL, NULL, '60-57-1', NULL, NULL, NULL, 0, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_component` VALUES (76, 177, '异狄氏剂', NULL, '100%', NULL, NULL, '72-20-8', NULL, NULL, NULL, 0, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_component` VALUES (77, 178, '(2-氨基甲酰氧乙基)三甲基氯化铵', NULL, '>=99%', NULL, NULL, '51-83-2', NULL, NULL, NULL, 0, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_component` VALUES (78, 179, '(E)-O,O-二甲基-O-[1-甲基-2-(二甲基氨基甲酰)乙烯基]磷酸酯[含量＞25%]', NULL, '大于25%', NULL, NULL, '141-66-2', NULL, NULL, NULL, 0, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_component` VALUES (79, 180, '氯氰菊酯；兴棉宝', NULL, '100%', NULL, NULL, '52315-07-8', NULL, NULL, NULL, 0, NULL, NULL, '', NULL, '', NULL);

-- ----------------------------
-- Table structure for msds_disposal
-- ----------------------------
DROP TABLE IF EXISTS `msds_disposal`;
CREATE TABLE `msds_disposal`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
  `waste_properties` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '废弃物性质',
  `disposal_method` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '废弃处置方法',
  `disposal_precautions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '废弃注意事项',
  `disposal_regulations` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '废弃处置相关法规',
  `container_disposal` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '包装容器的处置',
  `recommended_disposal` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '推荐的处置方法',
  `prohibited_disposal` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '禁止的处置方法',
  `neutralization_method` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '中和处理方法',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NULL DEFAULT NULL,
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id` ASC) USING BTREE,
  CONSTRAINT `msds_disposal_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 51 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '废弃处置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_disposal
-- ----------------------------
INSERT INTO `msds_disposal` VALUES (44, 174, '处置前应参阅国家和地方有关法规。建议用焚烧法处置。', '集中收集后交由有资质的危险废物处置单位进行高温焚烧或化学处理。焚烧时需确保完全燃烧，尾气需经碱洗和活性炭吸附处理。也可采用化学降解方法，在强碱条件下水解。', NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_disposal` VALUES (45, 175, '处置前应参阅国家和地方有关法规。建议用焚烧法处置。', '用控制焚烧法处置。焚烧炉排出的氮氧化物、氧化硫和氰化物通过洗涤器除去。也可采用化学处理法，在碱性条件下水解后，按危险废物进行处置。', NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_disposal` VALUES (46, 176, '处置前应参阅国家和地方有关法规。建议用焚烧法处置。', '集中收集后交由有资质的危险废物处置单位进行高温焚烧或化学处理。焚烧时需确保完全燃烧（>1100℃），尾气需经碱洗和活性炭吸附处理。也可采用化学降解方法，在强碱或金属催化剂条件下脱氯。', NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_disposal` VALUES (47, 177, '处置前应参阅国家和地方有关法规。建议用焚烧法处置。', '集中收集后交由有资质的危险废物处置单位进行高温焚烧或化学处理。焚烧时需确保完全燃烧（>1100℃），尾气需经碱洗和活性炭吸附处理。也可采用化学降解方法，在强碱或金属催化剂条件下脱氯。', NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_disposal` VALUES (48, 178, '处置前应参阅国家和地方有关法规。本品为剧毒物质，应按危险废物进行处置。', '集中收集后交由有资质的危险废物处置单位进行高温焚烧或化学处理。焚烧时需确保完全燃烧，尾气需经碱洗和活性炭吸附处理。空容器仍可能存在残留物危害，应远离热和火源，如有可能返还给供应商循环使用。', NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_disposal` VALUES (49, 179, '处置前应参阅国家和地方有关法规。建议用焚烧法处置。', '集中收集后交由有资质的危险废物处置单位进行高温焚烧或化学处理。焚烧时需确保完全燃烧（>1100℃），尾气需经碱洗和活性炭吸附处理。也可采用化学降解方法，在强碱条件下水解后，按危险废物进行处置。', NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_disposal` VALUES (50, 180, '处置前应参阅国家和地方有关法规。建议用焚烧法处置。', '集中收集后交由有资质的危险废物处置单位进行高温焚烧或化学处理。焚烧时需确保完全燃烧（>1100℃），尾气需经碱洗和活性炭吸附处理，特别注意去除氰化物。也可采用化学降解方法，在强碱条件下水解后，按危险废物进行处置。', NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);

-- ----------------------------
-- Table structure for msds_document_access_log
-- ----------------------------
DROP TABLE IF EXISTS `msds_document_access_log`;
CREATE TABLE `msds_document_access_log`  (
  `log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '??ID',
  `msds_id` bigint NOT NULL COMMENT 'MSDS??ID',
  `user_id` bigint NULL DEFAULT NULL COMMENT '??ID',
  `user_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '????',
  `access_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'access type: view, download, preview, print',
  `access_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `ip_address` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'IP??',
  `user_agent` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '????',
  `device_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '????: pc, mobile, tablet',
  `browser` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '???',
  `duration` int NULL DEFAULT NULL COMMENT '????(?)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  PRIMARY KEY (`log_id`) USING BTREE,
  INDEX `idx_msds_id`(`msds_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_access_type`(`access_type` ASC) USING BTREE,
  INDEX `idx_access_time`(`access_time` ASC) USING BTREE,
  INDEX `idx_msds_access_time`(`msds_id` ASC, `access_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 40 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'MSDS???????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_document_access_log
-- ----------------------------
INSERT INTO `msds_document_access_log` VALUES (1, 168, 1, 'admin', 'view', '2025-10-31 04:13:03', '192.168.1.119', '', 'pc', NULL, NULL, '2025-11-06 04:00:35');
INSERT INTO `msds_document_access_log` VALUES (2, 167, 1, 'admin', 'view', '2025-11-05 22:56:08', '192.168.1.131', '', 'pc', NULL, NULL, '2025-11-06 04:00:35');
INSERT INTO `msds_document_access_log` VALUES (3, 166, 1, 'admin', 'view', '2025-11-03 22:47:41', '192.168.1.121', '', 'pc', NULL, NULL, '2025-11-06 04:00:35');
INSERT INTO `msds_document_access_log` VALUES (4, 165, 1, 'admin', 'view', '2025-11-01 18:20:15', '192.168.1.195', '', 'pc', NULL, NULL, '2025-11-06 04:00:35');
INSERT INTO `msds_document_access_log` VALUES (5, 168, 1, 'admin', 'view', '2025-10-31 12:53:18', '192.168.1.40', '', 'tablet', NULL, NULL, '2025-11-06 04:00:35');
INSERT INTO `msds_document_access_log` VALUES (6, 167, 1, 'admin', 'view', '2025-10-31 16:54:17', '192.168.1.241', '', 'pc', NULL, NULL, '2025-11-06 04:00:35');
INSERT INTO `msds_document_access_log` VALUES (7, 166, 1, 'admin', 'view', '2025-11-01 11:52:07', '192.168.1.111', '', 'pc', NULL, NULL, '2025-11-06 04:00:35');
INSERT INTO `msds_document_access_log` VALUES (8, 165, 1, 'admin', 'view', '2025-11-02 23:08:07', '192.168.1.242', '', 'mobile', NULL, NULL, '2025-11-06 04:00:35');
INSERT INTO `msds_document_access_log` VALUES (9, 168, 1, 'admin', 'view', '2025-10-31 23:32:10', '192.168.1.30', '', 'pc', NULL, NULL, '2025-11-06 04:00:35');
INSERT INTO `msds_document_access_log` VALUES (10, 167, 1, 'admin', 'view', '2025-11-04 16:26:19', '192.168.1.104', '', 'mobile', NULL, NULL, '2025-11-06 04:00:35');
INSERT INTO `msds_document_access_log` VALUES (11, 166, 1, 'admin', 'view', '2025-11-05 21:30:37', '192.168.1.234', '', 'mobile', NULL, NULL, '2025-11-06 04:00:35');
INSERT INTO `msds_document_access_log` VALUES (12, 165, 1, 'admin', 'view', '2025-11-05 08:01:28', '192.168.1.0', '', 'mobile', NULL, NULL, '2025-11-06 04:00:35');
INSERT INTO `msds_document_access_log` VALUES (13, 168, 1, 'admin', 'view', '2025-11-02 11:33:32', '192.168.1.217', '', 'pc', NULL, NULL, '2025-11-06 04:00:35');
INSERT INTO `msds_document_access_log` VALUES (14, 167, 1, 'admin', 'view', '2025-11-06 12:11:49', '192.168.1.131', '', 'mobile', NULL, NULL, '2025-11-06 04:00:35');
INSERT INTO `msds_document_access_log` VALUES (15, 166, 1, 'admin', 'view', '2025-11-05 16:49:21', '192.168.1.240', '', 'pc', NULL, NULL, '2025-11-06 04:00:35');
INSERT INTO `msds_document_access_log` VALUES (16, 165, 1, 'admin', 'view', '2025-11-01 15:40:20', '192.168.1.30', '', 'pc', NULL, NULL, '2025-11-06 04:00:35');
INSERT INTO `msds_document_access_log` VALUES (17, 168, 1, 'admin', 'view', '2025-11-04 14:25:43', '192.168.1.11', '', 'tablet', NULL, NULL, '2025-11-06 04:00:35');
INSERT INTO `msds_document_access_log` VALUES (18, 167, 1, 'admin', 'view', '2025-11-03 17:05:06', '192.168.1.87', '', 'pc', NULL, NULL, '2025-11-06 04:00:35');
INSERT INTO `msds_document_access_log` VALUES (19, 166, 1, 'admin', 'view', '2025-11-04 20:53:35', '192.168.1.87', '', 'mobile', NULL, NULL, '2025-11-06 04:00:35');
INSERT INTO `msds_document_access_log` VALUES (20, 165, 1, 'admin', 'view', '2025-10-31 07:57:13', '192.168.1.212', '', 'tablet', NULL, NULL, '2025-11-06 04:00:35');
INSERT INTO `msds_document_access_log` VALUES (32, 168, 1, 'admin', 'download', '2025-10-11 13:14:13', '192.168.1.69', '', 'pc', NULL, NULL, '2025-11-06 04:00:35');
INSERT INTO `msds_document_access_log` VALUES (33, 167, 1, 'admin', 'download', '2025-10-31 09:45:12', '192.168.1.143', '', 'pc', NULL, NULL, '2025-11-06 04:00:35');
INSERT INTO `msds_document_access_log` VALUES (34, 166, 1, 'admin', 'download', '2025-11-04 22:23:07', '192.168.1.142', '', 'pc', NULL, NULL, '2025-11-06 04:00:35');
INSERT INTO `msds_document_access_log` VALUES (35, 165, 1, 'admin', 'download', '2025-10-23 22:58:25', '192.168.1.120', '', 'pc', NULL, NULL, '2025-11-06 04:00:35');
INSERT INTO `msds_document_access_log` VALUES (36, 168, 1, 'admin', 'download', '2025-10-08 16:59:45', '192.168.1.186', '', 'pc', NULL, NULL, '2025-11-06 04:00:35');
INSERT INTO `msds_document_access_log` VALUES (37, 167, 1, 'admin', 'download', '2025-11-07 02:52:06', '192.168.1.172', '', 'pc', NULL, NULL, '2025-11-06 04:00:35');
INSERT INTO `msds_document_access_log` VALUES (38, 166, 1, 'admin', 'download', '2025-10-22 18:04:41', '192.168.1.92', '', 'pc', NULL, NULL, '2025-11-06 04:00:35');
INSERT INTO `msds_document_access_log` VALUES (39, 165, 1, 'admin', 'download', '2025-11-05 08:18:52', '192.168.1.187', '', 'pc', NULL, NULL, '2025-11-06 04:00:35');

-- ----------------------------
-- Table structure for msds_document_statistics
-- ----------------------------
DROP TABLE IF EXISTS `msds_document_statistics`;
CREATE TABLE `msds_document_statistics`  (
  `stat_id` bigint NOT NULL AUTO_INCREMENT COMMENT '??ID',
  `msds_id` bigint NOT NULL COMMENT 'MSDS??ID',
  `view_count` int NULL DEFAULT 0 COMMENT '????',
  `download_count` int NULL DEFAULT 0 COMMENT '????',
  `favorite_count` int NULL DEFAULT 0 COMMENT '????',
  `share_count` int NULL DEFAULT 0 COMMENT '????',
  `last_view_time` datetime NULL DEFAULT NULL COMMENT '??????',
  `last_download_time` datetime NULL DEFAULT NULL COMMENT '??????',
  `last_favorite_time` datetime NULL DEFAULT NULL COMMENT '??????',
  `total_score` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '???',
  `score_count` int NULL DEFAULT 0 COMMENT '????',
  `avg_score` decimal(5, 2) NULL DEFAULT 0.00 COMMENT '????',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  PRIMARY KEY (`stat_id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id` ASC) USING BTREE,
  INDEX `idx_view_count`(`view_count` ASC) USING BTREE,
  INDEX `idx_download_count`(`download_count` ASC) USING BTREE,
  INDEX `idx_favorite_count`(`favorite_count` ASC) USING BTREE,
  INDEX `idx_avg_score`(`avg_score` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'MSDS?????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_document_statistics
-- ----------------------------
INSERT INTO `msds_document_statistics` VALUES (1, 165, 5, 2, 0, 0, '2025-11-05 08:01:28', '2025-11-05 08:18:52', NULL, 8.00, 6, 1.33, '2025-11-05 06:02:30', '2025-11-06 04:00:35');
INSERT INTO `msds_document_statistics` VALUES (2, 166, 5, 2, 0, 0, '2025-11-05 21:30:37', '2025-11-04 22:23:07', NULL, 9.00, 3, 3.00, '2025-11-05 06:02:30', '2025-11-06 04:00:35');
INSERT INTO `msds_document_statistics` VALUES (3, 167, 5, 2, 0, 0, '2025-11-06 12:11:49', '2025-11-07 02:52:06', NULL, 46.00, 8, 5.75, '2025-11-05 06:02:30', '2025-11-06 04:00:35');
INSERT INTO `msds_document_statistics` VALUES (4, 168, 5, 2, 0, 0, '2025-11-04 14:25:43', '2025-10-11 13:14:13', NULL, 43.00, 1, 43.00, '2025-11-05 06:02:30', '2025-11-06 04:00:35');

-- ----------------------------
-- Table structure for msds_ecological
-- ----------------------------
DROP TABLE IF EXISTS `msds_ecological`;
CREATE TABLE `msds_ecological`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
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
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id` ASC) USING BTREE,
  CONSTRAINT `msds_ecological_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 46 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '生态学资料表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_ecological
-- ----------------------------
INSERT INTO `msds_ecological` VALUES (39, 174, '对水生生物和陆生生物具有高毒性，对鱼类、鸟类和哺乳动物有害。LC50（96小时，鱼类）：0.002-0.01 mg/L。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-25 15:32:46', '', NULL);
INSERT INTO `msds_ecological` VALUES (40, 175, '本品为有机硫氰酸酯类农药，对水生生物可能具有毒性。应避免进入水体、土壤和地下水。对鱼类和其他水生生物可能有害。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-25 15:32:47', '', NULL);
INSERT INTO `msds_ecological` VALUES (41, 176, '对水生生物和陆生生物具有高毒性，对鱼类、鸟类和哺乳动物有害。LC50（96小时，鱼类）：0.001-0.01 mg/L。对鸟类影响尤其严重。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-25 15:32:47', '', NULL);
INSERT INTO `msds_ecological` VALUES (42, 177, '对水生生物和陆生生物具有高毒性，对鱼类、鸟类和哺乳动物有害。LC50（96小时，鱼类）：0.001-0.01 mg/L。对鸟类影响尤其严重。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-25 15:32:48', '', NULL);
INSERT INTO `msds_ecological` VALUES (43, 178, '对水生生物可能有害，应避免进入水体、土壤和地下水。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-25 15:32:48', '', NULL);
INSERT INTO `msds_ecological` VALUES (44, 179, '对水生生物具有高毒性，对鱼类和水生无脊椎动物尤其敏感。应避免进入水体、土壤和地下水。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-25 15:32:48', '', NULL);
INSERT INTO `msds_ecological` VALUES (45, 180, '对水生生物具有高毒性，对鱼类和水生无脊椎动物尤其敏感。应避免进入水体、土壤和地下水。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-25 15:32:49', '', NULL);

-- ----------------------------
-- Table structure for msds_exposure_control
-- ----------------------------
DROP TABLE IF EXISTS `msds_exposure_control`;
CREATE TABLE `msds_exposure_control`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
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
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id` ASC) USING BTREE,
  CONSTRAINT `msds_exposure_control_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '接触控制/个体防护表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_exposure_control
-- ----------------------------
INSERT INTO `msds_exposure_control` VALUES (42, 174, NULL, '未制订标准', NULL, NULL, NULL, NULL, NULL, NULL, '生产过程密闭，全面通风。提供安全淋浴和洗眼设备。', '空气中浓度超标时，应该佩戴防毒面具。紧急事态抢救或逃生时，建议佩戴自给式呼吸器。', '戴化学安全防护眼镜。', '穿相应的防护服。', '戴防化学品手套。', NULL, NULL, NULL, '2026-02-25 15:32:46', '', NULL);
INSERT INTO `msds_exposure_control` VALUES (43, 175, NULL, '无资料（建议参考类似农药标准：5mg/m³）', NULL, NULL, NULL, NULL, NULL, NULL, '生产过程密闭，加强通风。', '生产操作或农业使用时，佩戴防毒口罩。空气中浓度超标时，建议佩戴防毒面具。', '高浓度环境中，戴化学安全防护眼镜。', '穿工作服。', '戴防护手套。', NULL, NULL, NULL, '2026-02-25 15:32:47', '', NULL);
INSERT INTO `msds_exposure_control` VALUES (44, 176, NULL, '未制定标准', NULL, NULL, NULL, NULL, NULL, NULL, '密闭操作，局部排风。', '生产操作或农业使用时，建议佩戴自吸过滤式防毒面具（全面罩）。紧急事态抢救或撤离时，应该佩戴空气呼吸器。', '呼吸系统防护中已作防护。', '穿聚乙烯防毒服。', '戴橡胶手套。', NULL, NULL, NULL, '2026-02-25 15:32:47', '', NULL);
INSERT INTO `msds_exposure_control` VALUES (45, 177, NULL, '未制订标准', NULL, NULL, NULL, NULL, NULL, NULL, '严加密闭，提供充分的局部排风或全面排风。', '作业工人建议佩戴防毒面具。紧急事态抢救或逃生时，佩戴自给式呼吸器。', '戴化学安全防护眼镜。', '穿相应的防护服。', '戴防化学品手套。', NULL, NULL, NULL, '2026-02-25 15:32:48', '', NULL);
INSERT INTO `msds_exposure_control` VALUES (46, 178, NULL, '无资料', NULL, NULL, NULL, NULL, NULL, NULL, '密闭操作，局部排风。提供安全淋浴和洗眼设备。', '空气中浓度超标时，必须佩戴自吸过滤式防毒面具（全面罩）。紧急事态抢救或撤离时，应该佩戴空气呼吸器。', '佩戴化学护目镜（符合欧盟EN166或美国NIOSH标准）。', '穿阻燃防静电防护服和抗静电的防护靴。', '戴橡胶耐油手套。', NULL, NULL, NULL, '2026-02-25 15:32:48', '', NULL);
INSERT INTO `msds_exposure_control` VALUES (47, 179, NULL, '未制订标准', NULL, NULL, NULL, NULL, NULL, NULL, '严加密闭，提供充分的局部排风。', '生产操作或农业使用时，建议佩戴防毒口罩。紧急事态抢救或撤离时，佩带自给式呼吸器。', '一般不需特殊防护，但建议特殊情况下，戴化学安全防护眼镜。', '穿聚乙烯薄膜防毒服。', '戴防护手套。', NULL, NULL, NULL, '2026-02-25 15:32:48', '', NULL);
INSERT INTO `msds_exposure_control` VALUES (48, 180, NULL, '无资料', NULL, NULL, NULL, NULL, NULL, NULL, '密闭操作，局部排风。', '生产操作或农业使用时，应该佩戴防毒口罩。紧急事态抢救或逃生时，佩戴自给式呼吸器。', '戴安全防护眼镜。', '穿相应的防护服。', '戴防护手套。', NULL, NULL, NULL, '2026-02-25 15:32:49', '', NULL);

-- ----------------------------
-- Table structure for msds_faq
-- ----------------------------
DROP TABLE IF EXISTS `msds_faq`;
CREATE TABLE `msds_faq`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `question` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '问题',
  `answer` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '分类',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '常见问题表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_faq
-- ----------------------------
INSERT INTO `msds_faq` VALUES (1, '请问现在系统支持试用吗？', '现在免费支持使用', NULL, 5, '0', 'admin', '2025-12-04 01:57:04', 'admin', '2025-12-04 10:04:05', NULL);
INSERT INTO `msds_faq` VALUES (2, '请问可以商用吗？', '可以的我们有经销商渠道请跟和我联系并获取。', NULL, 0, '0', 'admin', '2025-12-04 01:57:04', 'admin', '2025-12-04 10:04:49', NULL);
INSERT INTO `msds_faq` VALUES (5, '如何退出登录？', '请点击[我的] - [应用设置] - [退出登录]即可退出登录', NULL, 0, '0', 'admin', '2025-12-04 01:57:04', '', NULL, NULL);
INSERT INTO `msds_faq` VALUES (6, '如何修改用户头像？', '请点击[我的] - [选择头像] - [点击提交]即可更换用户头像', NULL, 0, '0', 'admin', '2025-12-04 01:57:04', '', NULL, NULL);
INSERT INTO `msds_faq` VALUES (7, '如何修改登录密码？', '请点击[我的] - [应用设置] - [修改密码]即可修改登录密码', NULL, 0, '0', 'admin', '2025-12-04 01:57:04', '', NULL, NULL);

-- ----------------------------
-- Table structure for msds_feedback
-- ----------------------------
DROP TABLE IF EXISTS `msds_feedback`;
CREATE TABLE `msds_feedback`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户ID',
  `user_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户名',
  `feedback_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '反馈类型',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '反馈内容',
  `contact_info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系方式',
  `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '图片(JSON数组)',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0未处理 1已处理）',
  `reply_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '回复内容',
  `reply_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '回复人',
  `reply_time` datetime NULL DEFAULT NULL COMMENT '回复时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '意见反馈表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_feedback
-- ----------------------------
INSERT INTO `msds_feedback` VALUES (1, NULL, NULL, '功能建议', '系统出现了文档内容解析不够详细问题', '1809766557', 'http://192.168.0.101:18080/profile/upload/2025/12/04/4-kq1KBvZcR_6a4248fa203a02fad33f23e1373a7dc0_20251204042221A001.JPG', '0', NULL, NULL, NULL, 'admin', '2025-12-04 12:28:13', '', NULL, NULL);
INSERT INTO `msds_feedback` VALUES (2, NULL, NULL, '功能建议', '这个是我的一个测试发布', '122333445666', 'http://192.168.0.101:18080/profile/upload/2025/12/04/TkIL6A4WVcIqf41782266820cf3a0fe9da0f668a670c_20251204060431A001.JPG', '0', NULL, NULL, NULL, 'admin', '2025-12-04 14:04:34', '', NULL, NULL);
INSERT INTO `msds_feedback` VALUES (3, NULL, NULL, '功能建议', '提交基金那就好好', '1334456789987', 'http://192.168.0.101:18080/profile/upload/2025/12/04/LELO8ufCaq8215c7b55ebaa0a141c7239370f67d0f73_20251204060639A002.JPG', '0', NULL, NULL, NULL, 'admin', '2025-12-04 14:06:45', '', NULL, NULL);
INSERT INTO `msds_feedback` VALUES (4, NULL, NULL, '功能建议', '这个是一个测试反馈项目', '', 'http://192.168.0.101:18080/profile/upload/2025/12/04/hInyUQQJjOhO15c7b55ebaa0a141c7239370f67d0f73_20251204070651A001.JPG', '0', NULL, NULL, NULL, 'admin', '2025-12-04 15:06:53', '', NULL, NULL);
INSERT INTO `msds_feedback` VALUES (5, NULL, NULL, '性能问题', '测试意见反馈，使用的时候数据错误。', '', 'http://192.168.0.101:18080/profile/upload/2025/12/04/14HgEr2pinNF307c032a98049434f4753601abb073b5_20251204071836A002.JPG', '0', NULL, NULL, NULL, 'admin', '2025-12-04 15:18:45', '', NULL, NULL);
INSERT INTO `msds_feedback` VALUES (6, NULL, NULL, '其他', '咳咳咳，数据不通哦啊', '', 'http://192.168.0.101:18080/profile/upload/2025/12/04/Ow1JsMK17L1U1e0b9500d9a9aeaf8ba75788b7496f91_20251204071929A003.JPG', '0', NULL, NULL, NULL, 'admin', '2025-12-04 15:19:34', '', NULL, NULL);
INSERT INTO `msds_feedback` VALUES (7, NULL, NULL, '功能建议', '这个是测试发布的内容跟', '', 'http://192.168.0.101:18080/profile/upload/2025/12/04/SzoEiE5QP1u548730d89822d8423d30782827a7b44d9_20251204073507A004.png', '0', NULL, NULL, NULL, 'admin', '2025-12-04 15:35:10', '', NULL, NULL);

-- ----------------------------
-- Table structure for msds_fire_fighting
-- ----------------------------
DROP TABLE IF EXISTS `msds_fire_fighting`;
CREATE TABLE `msds_fire_fighting`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
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
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id` ASC) USING BTREE,
  CONSTRAINT `msds_fire_fighting_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '消防措施表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_fire_fighting
-- ----------------------------
INSERT INTO `msds_fire_fighting` VALUES (42, 174, '不易燃烧。受高热分解，放出有毒的烟气。', '一氧化碳、二氧化碳、氯化氢、氧化硫。', '泡沫、干粉、砂土。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-25 15:32:46', '', NULL);
INSERT INTO `msds_fire_fighting` VALUES (43, 175, '遇明火、高热可燃。与氧化剂能发生强烈反应。受热分解，放出有毒的烟气。', '一氧化碳、二氧化碳、氮氧化物、氧化硫、氰化物。', '泡沫、干粉、砂土。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-25 15:32:47', '', NULL);
INSERT INTO `msds_fire_fighting` VALUES (44, 176, '遇明火、高热可燃。', '一氧化碳、二氧化碳、氯化氢。', '消防人员须佩戴防毒面具、穿全身消防服，在上风向灭火。灭火剂：干粉、泡沫、砂土。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-25 15:32:47', '', NULL);
INSERT INTO `msds_fire_fighting` VALUES (45, 177, '不易燃烧。受高热分解，放出有毒的烟气。', '一氧化碳、二氧化碳、氯化氢。', '泡沫、干粉、砂土。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-25 15:32:48', '', NULL);
INSERT INTO `msds_fire_fighting` VALUES (46, 178, '安全阀泄漏出内容物。受热或接触火焰可能会产生膨胀或爆炸性分解。', '氯化氢、氮氧化物、一氧化碳、二氧化碳等有毒气体。', '合适的灭火介质：干粉、二氧化碳或耐醇泡沫。不合适的灭火介质：避免用太强烈的水汽灭火，因为它可能会使火苗蔓延分散。灭火时，应佩戴呼吸面具（符合MSHA/NIOSH要求的或相当的）并穿上全身防护服。在安全距离处、有充足防护的情况下灭火。防止消防水污染地表和地下水系统。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-25 15:32:48', '', NULL);
INSERT INTO `msds_fire_fighting` VALUES (47, 179, '遇明火、高热可燃。受热分解，放出氮、磷的氧化物等毒性气体。', '一氧化碳、二氧化碳、氧化氮、氧化磷。', '泡沫、二氧化碳、干粉、砂土。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-25 15:32:48', '', NULL);
INSERT INTO `msds_fire_fighting` VALUES (48, 180, '遇明火、高热可燃。受高熟分解，放出高毒的烟气。', '一氧化碳、二氧化碳、氮氧化物、氯化氢、氰化物。', '泡沫、干粉、砂土。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-25 15:32:49', '', NULL);

-- ----------------------------
-- Table structure for msds_first_aid
-- ----------------------------
DROP TABLE IF EXISTS `msds_first_aid`;
CREATE TABLE `msds_first_aid`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
  `skin_contact` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '皮肤接触处理措施',
  `eye_contact` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '眼睛接触处理措施',
  `inhalation` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '吸入处理措施',
  `ingestion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '食入处理措施',
  `general_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '一般注意事项',
  `symptoms_effects` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '可能出现的症状和健康影响',
  `immediate_medical_attention` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '需要立即就医的情况',
  `antidote_treatment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '解毒剂及治疗方法',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `create_time` datetime NULL DEFAULT NULL,
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id` ASC) USING BTREE,
  CONSTRAINT `msds_first_aid_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '急救措施表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_first_aid
-- ----------------------------
INSERT INTO `msds_first_aid` VALUES (54, 174, '用肥皂水及清水彻底冲洗。就医。', '拉开眼睑，用流动清水冲洗15分钟。就医。', '脱离现场至空气新鲜处。密切观察。就医。', '误服者，饮适量温水，催吐。就医。', NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_first_aid` VALUES (55, 175, '脱去污染的衣物，用肥皂水及清水彻底冲洗。就医。', '拉开眼睑，用流动清水冲洗15分钟。就医。', '脱离现场至空气新鲜处。呼吸困难时给输氧。呼吸停止时，立即进行人工呼吸。就医。', '误服者，饮适量温水，催吐。就医。', NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_first_aid` VALUES (56, 176, '立即脱去污染的衣着，用肥皂水和清水彻底冲洗皮肤。就医。', '提起眼睑，用流动清水或生理盐水冲洗。就医。', '迅速脱离现场至空气新鲜处。保持呼吸道通畅。如呼吸困难，给输氧。如呼吸停止，立即 进行人工呼吸。就医。', '饮足量温水，催吐。就医。', NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_first_aid` VALUES (57, 177, '用肥皂水及清水彻底冲洗。就医。', '拉开眼睑，用流动清水冲洗15分钟。就医。', '脱离现场至空气新鲜处。就医。', '误服者，饮适量温水，催吐。洗胃。就医。', NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_first_aid` VALUES (58, 178, '立即脱去污染的衣物。用大量肥皂水和清水冲洗皮肤。如有不适，就医。', '用大量水彻底冲洗至少15分钟。如有不适，就医。', '立即将患者移到新鲜空气处，保持呼吸畅通。如果呼吸困难，给于吸氧。如患者食入或吸入本物质，不得进行口对口人工呼吸。如果呼吸停止，立即进行心肺复苏术。立即就医。', '禁止催吐，切勿给失去知觉者从嘴里喂食任何东西。立即呼叫医生或中毒控制中心。', NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_first_aid` VALUES (59, 179, '脱去污染的衣着，用肥皂水及清水彻底冲洗。', '立即翻开上下眼睑，用流动清水冲洗15分钟。就医。', '脱离现场至空气新鲜处。呼吸困难时给输氧。呼吸停止时，立即进行人工呼吸。就医。', '误服者给饮牛奶或蛋清。立即就医。', NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_first_aid` VALUES (60, 180, '用肥皂水及清水彻底冲洗。就医。', '拉开眼睑，用流动清水冲洗15分钟。就医。', '脱离现场至空气新鲜处。呼吸困难时给输氧。呼吸停止时，立即进行人工呼吸。就医。', '误服者，饮适量温水，催吐。洗胃。就医。', NULL, NULL, NULL, NULL, '', NULL, '', NULL);

-- ----------------------------
-- Table structure for msds_ghs_hazard
-- ----------------------------
DROP TABLE IF EXISTS `msds_ghs_hazard`;
CREATE TABLE `msds_ghs_hazard`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
  `ghs_class_id` int NOT NULL COMMENT '关联GHS危险类别ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_ghs`(`msds_id` ASC, `ghs_class_id` ASC) USING BTREE,
  INDEX `ghs_class_id`(`ghs_class_id` ASC) USING BTREE,
  CONSTRAINT `msds_ghs_hazard_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `msds_ghs_hazard_ibfk_2` FOREIGN KEY (`ghs_class_id`) REFERENCES `ghs_hazard_class` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'MSDS-GHS危险性分类关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_ghs_hazard
-- ----------------------------

-- ----------------------------
-- Table structure for msds_handling_storage
-- ----------------------------
DROP TABLE IF EXISTS `msds_handling_storage`;
CREATE TABLE `msds_handling_storage`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
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
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id` ASC) USING BTREE,
  CONSTRAINT `msds_handling_storage_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作处置与储存表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_handling_storage
-- ----------------------------
INSERT INTO `msds_handling_storage` VALUES (42, 174, '操作人员必须经过专门培训，严格遵守操作规程。建议操作人员佩戴自吸过滤式防毒面具（全面罩），穿连衣式胶布防毒衣，戴橡胶手套。远离火种、热源，工作场所严禁吸烟。使用防爆型的通风系统和设备。防止蒸气泄漏到工作场所空气中。避免与氧化剂、酸类、碱类接触。搬运时要轻装轻卸，防止包装及容器损坏。配备相应品种和数量的消防器材及泄漏应急处理设备。倒空的容器可能残留有害物。操作现场不得吸烟、饮水、进食。', '储存于阴凉、通风仓间内。远离火种、热源。专人保管。保持容器密封。防止受潮和雨淋。 防止阳光曝晒。应与氧化剂、酸类、碱类分开存放。不能与粮食、食物、种子、饲料、各 种日用品混装、混运。操作现场不得吸烟、饮水、进食。搬运时要轻装轻卸，防止包装及 容器损坏。分装和搬运作业要注意个人防护。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-25 15:32:46', '', NULL);
INSERT INTO `msds_handling_storage` VALUES (43, 175, '操作人员必须经过专门培训，严格遵守操作规程。建议操作人员佩戴自吸过滤式防毒面具（半面罩），戴化学安全防护眼镜，穿防毒物渗透工作服，戴橡胶耐油手套。远离火种、热源，工作场所严禁吸烟。使用防爆型的通风系统和设备。避免与氧化剂、碱类接触。搬运时要轻装轻卸，防止包装及容器损坏。配备相应品种和数量的消防器材及泄漏应急处理设备。倒空的容器可能残留有害物。', '储存于阴凉、通风仓间内。远离火种、热源。专人保管。保持容器密封。防潮、防晒。应 与氧化剂、碱类、食用化工原料分开存放。不能与粮食、食物、种子、饲料、各种日用 品混装、混运。操作现场不得吸烟、饮水、进食。搬运时要轻装轻卸，防止包装及容器损 坏。分装和搬运作业要注意个人防护。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-25 15:32:47', '', NULL);
INSERT INTO `msds_handling_storage` VALUES (44, 176, '操作人员必须经过专门培训，严格遵守操作规程。建议操作人员佩戴自吸过滤式防毒面具（全面罩），穿聚乙烯防毒服，戴橡胶手套。远离火种、热源，工作场所严禁吸烟。使用防爆型的通风系统和设备。避免与氧化剂、酸类接触。搬运时要轻装轻卸，防止包装及容器损坏。配备相应品种和数量的消防器材及泄漏应急处理设备。倒空的容器可能残留有害物。应严格执行极毒物品\"五双\"管理制度。', '储存于阴凉、通风的库房。远离火种、热源。包装密封。应与氧化剂、酸类、食用化学品分开存放，切忌混储。配备相应品种和数量的消防器材。储区应备有合适的材料收容泄漏物。应严格执行极毒物品\"五双\"管理制度。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-25 15:32:47', '', NULL);
INSERT INTO `msds_handling_storage` VALUES (45, 177, '操作人员必须经过专门培训，严格遵守操作规程。建议操作人员佩戴自吸过滤式防毒面具（全面罩），穿聚乙烯防毒服，戴橡胶手套。远离火种、热源，工作场所严禁吸烟。使用防爆型的通风系统和设备。避免与氧化剂接触。搬运时要轻装轻卸，防止包装及容器损坏。配备相应品种和数量的消防器材及泄漏应急处理设备。倒空的容器可能残留有害物。应严格执行极毒物品\"五双\"管理制度。', '储存于阴凉、通风仓间内。远离火种、热源。管理应按“五双”管理制度执行。保持容器 密封。防止受潮和雨淋。防止阳光曝晒。应与氧化剂、食用化工原料分开存放。不能与粮 食、食物、种子、饲料、各种日用品混装、混运。操作现场不得吸烟、饮水、进食。搬运 时要轻装轻卸，防止包装及容器损坏。分装和搬运作业要注意个人防护。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-25 15:32:48', '', NULL);
INSERT INTO `msds_handling_storage` VALUES (46, 178, '操作人员必须经过专门培训，严格遵守操作规程。建议操作人员佩戴自吸过滤式防毒面具（全面罩），戴化学安全防护眼镜，穿防毒物渗透工作服，戴橡胶耐油手套。远离火种、热源，工作场所严禁吸烟。使用防爆型的通风系统和设备。防止粉尘泄漏到工作场所空气中。避免与氧化剂、碱类接触。搬运时要轻装轻卸，防止包装及容器损坏。配备相应品种和数量的消防器材及泄漏应急处理设备。倒空的容器可能残留有害物。', '储存于阴凉、通风的库房。远离火种、热源。保持容器密闭。储存在干燥、阴凉和通风处。远离热源、火花、明火和热表面。存储于远离不相容材料和食品容器的地方。储存温度一般不应高于32℃，相对湿度一般不应高于80%。应与氧化剂、碱类、食用化学品分开存放，切忌混储。配备相应品种和数量的消防器材。储区应备有合适的材料收容泄漏物。应严格执行极毒物品\"五双\"管理制度。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-25 15:32:48', '', NULL);
INSERT INTO `msds_handling_storage` VALUES (47, 179, '操作人员必须经过专门培训，严格遵守操作规程。建议操作人员佩戴自吸过滤式防毒面具（半面罩），戴化学安全防护眼镜，穿防毒物渗透工作服，戴防化学品手套。远离火种、热源，工作场所严禁吸烟。使用防爆型的通风系统和设备。防止粉尘泄漏到工作场所空气中。避免与氧化剂接触。搬运时要轻装轻卸，防止包装及容器损坏。配备相应品种和数量的消防器材及泄漏应急处理设备。倒空的容器可能残留有害物。', '储存于阴凉、通风仓间内。远离火种、热源。保持容器密封。防潮、防晒。寒冷季节要 注意保持库温在结晶点以上，防止冻裂容器及变质。专人保管。搬运时要轻装轻卸，防 止包装及容器损坏。分装和搬运作业要注意个人防护。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-25 15:32:48', '', NULL);
INSERT INTO `msds_handling_storage` VALUES (48, 180, '操作人员必须经过专门培训，严格遵守操作规程。建议操作人员佩戴自吸过滤式防毒面具（半面罩），戴化学安全防护眼镜，穿防毒物渗透工作服，戴防化学品手套。远离火种、热源，工作场所严禁吸烟。使用防爆型的通风系统和设备。防止粉尘泄漏到工作场所空气中。避免与氧化剂、碱类接触。搬运时要轻装轻卸，防止包装及容器损坏。配备相应品种和数量的消防器材及泄漏应急处理设备。倒空的容器可能残留有害物。', '储存于阴凉、通风仓间内。远离火种、热源。专人保管。保持容器密封。避光保存。防止 受潮和雨淋。防止阳光曝晒。应与氧化剂、碱类、食用化工原料分开存放。不能与粮食、 食物、种子、饲料、各种日用品混装、混运。操作现场不得吸烟、饮水、进食。搬运时要 轻装轻卸，防止包装及容器损坏。分装和搬运作业要注意个人防护。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-02-25 15:32:49', '', NULL);

-- ----------------------------
-- Table structure for msds_hazard
-- ----------------------------
DROP TABLE IF EXISTS `msds_hazard`;
CREATE TABLE `msds_hazard`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
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
  `create_time` datetime NULL DEFAULT NULL,
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id` ASC) USING BTREE,
  CONSTRAINT `msds_hazard_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 80 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '危险性概述表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_hazard
-- ----------------------------
INSERT INTO `msds_hazard` VALUES (73, 174, NULL, NULL, NULL, NULL, NULL, '第6.1类 毒害品', '吸入、食入、经皮吸收', '吸入、摄入或经皮肤吸收后会中毒。为高毒的有机氯杀虫剂。对人有致突变作用。对中枢神经系统有抑制作用，可引起头痛、眩晕、恶心、呕吐、共济失调、抽搐、昏迷等症状。长期接触可导致肝、肾损害，对皮肤有刺激作用。', '硫丹为持久性有机污染物（POPs），对水生生物和陆生生物具有高毒性，在环境中难以降解，具有生物富集性。应避免进入水体、土壤和地下水。已被列入《斯德哥尔摩公约》禁用名单。', '本品可燃、高毒', NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_hazard` VALUES (74, 175, NULL, NULL, NULL, NULL, NULL, '第6.1类毒害品', '吸入、食入、经皮吸收', '本品为低毒类杀菌剂。吸入、摄入或经皮肤吸收后会中毒。对眼睛、皮肤、粘膜和上呼吸道有刺激作用。受热分解释出有毒的氮氧化物和氧化硫烟雾。', '本品为有机硫氰酸酯类农药，对水生生物有毒，可能对水体环境产生长期不良影响。使用时应避免污染水源和土壤。', '本品可燃、具有刺激性', NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_hazard` VALUES (75, 176, NULL, NULL, NULL, NULL, NULL, '第6.1类 毒害品', '吸入、食入、经皮吸收', '吸入、摄入或经皮肤吸收后会中毒。为剧毒的有机氯杀虫剂。对中枢神经系统有抑制作用，可引起头痛、眩晕、恶心、呕吐、共济失调、抽搐、昏迷等症状。除上述症状外，还有咳嗽、呼吸困难、紫绀，甚至肺水肿。可致接触性皮炎。长期接触可导致肝、肾损害。', '狄氏剂为持久性有机污染物（POPs），对水生生物和陆生生物具有高毒性，在环境中极难降解，具有极强的生物富集性和生物放大作用。已被列入《斯德哥尔摩公约》禁用名单。应避免进入水体、土壤和地下水。', '本品可燃，剧毒。', NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_hazard` VALUES (76, 177, NULL, NULL, NULL, NULL, NULL, '第6.1类 毒害品', '吸入、食入、经皮吸收', '吸入、摄入或经皮肤吸收后会中毒。为高毒的有机氯杀虫剂。对中枢神经系统有抑制作用，可引起头痛、眩晕、恶心、呕吐、共济失调、抽搐等症状，重者引起昏迷。长期接触可导致肝、肾损害。', '异狄氏剂为持久性有机污染物（POPs），对水生生物和陆生生物具有高毒性，在环境中极难降解，具有极强的生物富集性和生物放大作用。已被列入《斯德哥尔摩公约》禁用名单。应避免进入水体、土壤和地下水。', '本品可燃、高毒', NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_hazard` VALUES (77, 178, NULL, NULL, NULL, NULL, NULL, '第6.1类毒害品（急毒性-口服，类别2）', '食入、吸入、皮肤接触、眼睛接触', '本品为胆碱能激动剂，口服毒性极高。吸入该物质可能会引起对健康有害的影响或呼吸道不适。意外食入可导致严重的胆碱能症状，包括：流涎、流泪、出汗、恶心、呕吐、腹泻、腹部绞痛、瞳孔缩小、视力模糊、支气管收缩、呼吸困难、心动过缓、低血压、肌肉震颤、抽搐、昏迷等。严重中毒可导致呼吸衰竭和死亡。对眼睛有强烈刺激作用，可引起瞳孔缩小、视力模糊。皮肤接触可引起局部刺激。', '对水生生物可能有害。应避免进入水体、土壤和地下水。该物质对环境可能有危害，对水体应给予特别注意。', '本品不燃，但受热分解可能产生有毒气体（氯化氢、氮氧化物、一氧化碳等）。', NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_hazard` VALUES (78, 179, NULL, NULL, NULL, NULL, NULL, '第6.1类 毒害品', '吸入 食入 经皮吸收', '本品为高毒有机磷杀虫剂，抑制胆碱酯酶活性。吸入、摄入或经皮肤吸收后会中毒。轻度中毒出现头痛、头晕、多汗、流涎、视力模糊、乏力、恶心、呕吐和胸闷等症状，全血胆碱酯酶活性可下降至正常值的70％以下；中度中毒以肌束震颤为特征，出现瞳孔缩小，呼吸困难，神态模糊，步态蹒跚等症状，全血胆碱酯酶活性可降至正常值的50％以下；重度中毒出现昏迷，惊厥、肺水肿、呼吸抑制和脑水肿等症状，全血胆碱酯酶活性在30％以下。对眼睛、皮肤、粘膜有刺激作用。接触后可能引起眼部不适、皮肤刺激和呼吸道刺激症状。本品可通过皮肤吸收。', '对水生生物具有高毒性。应避免进入水体、土壤和地下水。该物质对环境可能有危害，对水体应给予特别注意。在水生生物中可能发生生物蓄积。', '本品可燃，遇明火、高热有燃烧危险。受热分解产生有毒气体。', NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_hazard` VALUES (79, 180, NULL, NULL, NULL, NULL, NULL, '第6.1类 毒害品', '吸入 食入 经皮吸收', '属中等毒类。本品对皮肤、粘膜有刺激作用。误服中毒的症状有：头痛、头晕、恶心、呕\n吐、腹痛、胸闷、重者出现意识模糊和肺水肿。', '对水生生物具有高毒性。应避免进入水体、土壤和地下水。该物质对环境可能有危害，对水体应给予特别注意。在水生生物中可能发生生物蓄积。', '本品可燃、有毒、具有刺激性', NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);

-- ----------------------------
-- Table structure for msds_leak_response
-- ----------------------------
DROP TABLE IF EXISTS `msds_leak_response`;
CREATE TABLE `msds_leak_response`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
  `personal_precautions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '个人防护措施',
  `environmental_precautions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '环境保护措施',
  `containment_cleanup` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '泄漏化学品的收容、清除方法',
  `emergency_procedures` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '应急处理程序',
  `elimination_methods` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '消除方法',
  `equipment_materials` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '清理时使用的器材',
  `prevent_secondary_hazards` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '防止发生次生危害的预防措施',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id` ASC) USING BTREE,
  CONSTRAINT `msds_leak_response_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '泄漏应急处理表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_leak_response
-- ----------------------------
INSERT INTO `msds_leak_response` VALUES (42, 174, NULL, NULL, NULL, '隔离泄漏污染区，周围设警告标志，建议应急处理人员戴自给式呼吸器，穿化学防护服。 不要直接接触泄漏物，小心扫起，避免扬尘，收集于干燥净洁有盖的容器中，转移到安全 场所。用水刷洗泄漏污染区，经稀释的污水放入废水系统。如大量泄漏，收集回收或无害 处理后废弃。', NULL, NULL, NULL, NULL, '2026-02-25 15:32:46', '', NULL);
INSERT INTO `msds_leak_response` VALUES (43, 175, NULL, NULL, NULL, '隔离泄漏污染区，周围设警告标志，建议应急处理人员戴好防毒面具，穿化学防护服。 用不燃性分散剂制成的乳液刷洗，经稀释的污水放入废水系统。如大量泄漏，利用围堤 收容，然后收集、转移、回收或无害处理后废弃。', NULL, NULL, NULL, NULL, '2026-02-25 15:32:47', '', NULL);
INSERT INTO `msds_leak_response` VALUES (44, 176, NULL, NULL, NULL, '隔离泄漏污染区，限制出入。切断火源。建议应急处理人员戴防尘面具（全面罩），穿防 毒服。不要直接接触泄漏物。小量泄漏：避免扬尘，小心扫起，置于袋中转移至安全场所。 大量泄漏：收集回收或运至废物处理场所处置。', NULL, NULL, NULL, NULL, '2026-02-25 15:32:47', '', NULL);
INSERT INTO `msds_leak_response` VALUES (45, 177, NULL, NULL, NULL, '隔离泄漏污染区，周围设警告标志，切断火源。建议应急处理人员戴自给式呼吸器，穿化 学防护服。不要直接接触泄漏物，用砂土吸收，倒至空旷地方深埋。在污染区撒上石灰， 用大量水冲洗，经稀释的污水放入废水系统。如大量泄漏，收集回收或无害处理后废弃。', NULL, NULL, NULL, NULL, '2026-02-25 15:32:48', '', NULL);
INSERT INTO `msds_leak_response` VALUES (46, 178, NULL, NULL, NULL, '应急处理：迅速撤离泄漏污染区人员至安全区，并进行隔离，严格限制出入。切断火源。建议应急处理人员戴自给正压式呼吸器，穿防毒物渗透工作服。不要直接接触泄漏物。尽可能切断泄漏源。防止流入下水道、排洪沟等限制性空间。保证充分的通风。清除所有点火源。迅速将人员撤离到安全区域，远离泄漏区域并处于上风向。采取措施防止进一步的泄漏或溢出。避免排放到周围环境中。少量泄漏时，可采用干砂或惰性吸附材料吸收泄漏物，大量泄漏时需筑堤控制。附着物或收集物应存放在合适的密闭容器中，并根据当地相关法律法规废弃处置。清除所有点火源，并采用防火花工具和防爆设备。', NULL, NULL, NULL, NULL, '2026-02-25 15:32:48', '', NULL);
INSERT INTO `msds_leak_response` VALUES (47, 179, NULL, NULL, NULL, '疏散泄漏污染区人员至安全区，禁止无关人员进入污染区，切断火源。应急处理人员戴 正压自给式呼吸器，穿化学防护服。不要直接接触泄漏物，在确保安全情况下堵漏。喷 雾状水， 减少蒸发。用砂土或其它不燃性吸附剂混合吸收，然后收集于干燥洁净有盖的 容器中，运至废物处理场所。如大量泄漏，利用围堤收容，然后收集、转移、回收或无 害处理后废弃。', NULL, NULL, NULL, NULL, '2026-02-25 15:32:48', '', NULL);
INSERT INTO `msds_leak_response` VALUES (48, 180, NULL, NULL, NULL, '疏散泄漏污染区人员至安全区，禁止无关人员进入污染区，建议应急处理人员戴自给式呼 吸器，穿化学防护服。不要直接接触泄漏物，用砂土吸收，铲入提桶，倒至空旷地方深埋。 也可以用大量水冲洗，经稀释的污水放入废水系统。如大量泄漏，利用围堤收容，然后收 集、转移、回收或无害处理后废弃。', NULL, NULL, NULL, NULL, '2026-02-25 15:32:49', '', NULL);

-- ----------------------------
-- Table structure for msds_main
-- ----------------------------
DROP TABLE IF EXISTS `msds_main`;
CREATE TABLE `msds_main`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'MSDS唯一标识',
  `cas_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'CAS登记号',
  `msds_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'MSDS编号',
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '化学品中文名',
  `product_alias` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '化学品别名',
  `product_english_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '化学品英文名',
  `category_id` int NULL DEFAULT NULL COMMENT '化学品分类ID',
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
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `created_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `updated_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  `remark` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `cas_number`(`cas_number` ASC) USING BTREE,
  UNIQUE INDEX `msds_code`(`msds_code` ASC) USING BTREE,
  INDEX `category_id`(`category_id` ASC) USING BTREE,
  INDEX `idx_msds_code`(`msds_code` ASC) USING BTREE,
  INDEX `idx_product_name`(`product_name` ASC) USING BTREE,
  INDEX `idx_company_name`(`company_name` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE,
  CONSTRAINT `msds_main_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `chemical_category` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 181 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'MSDS主信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_main
-- ----------------------------
INSERT INTO `msds_main` VALUES (174, '115-29-7', 'MSDS-115-29-7', '(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯', '硫丹；硫丹酸酯；1,2,3,4,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基亚硫酸酯', '1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl sulfite; Endosulfan', NULL, '无资料', '无资料', NULL, '无资料', '无资料', '无资料', '无资料', NULL, NULL, NULL, NULL, NULL, 'approved', NULL, NULL, 1, '2026-02-25 15:32:46', '2026-02-25 15:32:46', NULL, NULL, NULL);
INSERT INTO `msds_main` VALUES (175, '115-31-1', 'MSDS-115-31-1', '(1R,2R,4R)-冰片-2-硫氰基醋酸酯', '敌稻瘟', '1,7,7-trimethylbicyclo(2,2,1)hept-2-yl thiocyanatoacetate', NULL, '无资料', '无资料', NULL, '无资料', '无资料', '无资料', '无资料', NULL, NULL, NULL, NULL, NULL, 'approved', NULL, NULL, 1, '2026-02-25 15:32:47', '2026-02-25 15:32:47', NULL, NULL, NULL);
INSERT INTO `msds_main` VALUES (176, '60-57-1', 'MSDS-60-57-1', '(1R,4S,4aS,5R,6R,7S,8S,8aR)-1,2,3,4,10,10-六氯-1,4,4a,5,6,7,8,8a-八氢-6,7-环氧-1,4,5,8-二亚甲基萘[含量2%～90%]', '狄氏剂；HEOD；1,2,3,4,10,10-六氯-6,7-环氧-1,4,4a,5,6,7,8,8a-八氢-1,4,5,8-二亚甲基萘', 'dieldrin(not less than 2% but not more than 90%)', NULL, '无资料', '无资料', NULL, '无资料', '无资料', '无资料', '无资料', NULL, NULL, NULL, NULL, NULL, 'approved', NULL, NULL, 1, '2026-02-25 15:32:47', '2026-02-25 15:32:47', NULL, NULL, NULL);
INSERT INTO `msds_main` VALUES (177, '72-20-8', 'MSDS-72-20-8', '(1R,4S,5R,8S)-1,2,3,4,10,10-六氯-1,4,4a,5,6,7,8,8a-八氢-6,7-环氧-1,4,5,8-二亚甲基萘[含量＞5%]', '异狄氏剂；异艾氏剂；HEOD；1,2,3,4,10,10-六氯-6,7-环氧-1,4,4a,5,6,7,8,8a-八氢-1,4,5,8-二亚甲基萘', '1,2,3,4,10,10-hexachloro-6,7-epoxy-1,4,4a,5,6,7,8,8a-octahydro-1,45,8-dimethanonaphthalene(more than 5%); Endrin', NULL, '无资料', '无资料', NULL, '无资料', '无资料', '无资料', '无资料', NULL, NULL, NULL, NULL, NULL, 'approved', NULL, NULL, 1, '2026-02-25 15:32:47', '2026-02-25 15:32:47', NULL, NULL, NULL);
INSERT INTO `msds_main` VALUES (178, '51-83-2', 'MSDS-51-83-2', '(2-氨基甲酰氧乙基)三甲基氯化铵', '氯化氨甲酰胆碱；卡巴考', '(2-carbamoyloxyethyl) trimethylammonium chloride', NULL, '无资料', '无资料', NULL, '无资料', '无资料', '无资料', '无资料', NULL, NULL, NULL, NULL, NULL, 'approved', NULL, NULL, 1, '2026-02-25 15:32:48', '2026-02-25 15:32:48', NULL, NULL, NULL);
INSERT INTO `msds_main` VALUES (179, '141-66-2', 'MSDS-141-66-2', '(E)-O,O-二甲基-O-[1-甲基-2-(二甲基氨基甲酰)乙烯基]磷酸酯[含量＞25%]', '百治磷；异丁烯酰胺', '(E)-2-dimethylcarbamoyl-1-methylvinyl dimethyl phosphate(more than 25%)', NULL, '上海一研生物科技有限公司', '上海市闵行区江月路2000号', NULL, '021-12345679', '021-12345678', 'info@shybio.com', '021-87654321', NULL, NULL, NULL, NULL, NULL, 'approved', NULL, NULL, 1, '2026-02-25 15:32:48', '2026-02-25 15:32:48', NULL, NULL, NULL);
INSERT INTO `msds_main` VALUES (180, '52315-07-8', 'MSDS-52315-07-8', '(RS)-α-氰基-3-苯氧基苄基(SR)-3-(2,2-二氯乙烯基)-2,2-二甲基环丙烷羧酸酯', '氯氰菊酯；兴棉宝', 'cyclopropanecarboxylic acid, 3-(2,2-dichloroethenyl)-2,2-dimethyl-, cyano(3-phenoxyphenyl)methyl ester', NULL, '无资料', '无资料', NULL, '无资料', '无资料', '无资料', '无资料', NULL, NULL, NULL, NULL, NULL, 'approved', NULL, NULL, 1, '2026-02-25 15:32:49', '2026-02-25 15:32:49', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for msds_other_info
-- ----------------------------
DROP TABLE IF EXISTS `msds_other_info`;
CREATE TABLE `msds_other_info`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
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
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id` ASC) USING BTREE,
  CONSTRAINT `msds_other_info_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '其他信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_other_info
-- ----------------------------
INSERT INTO `msds_other_info` VALUES (2, 174, NULL, '国际化学品安全卡（ICSC）、美国国立职业安全卫生研究所（NIOSH）、欧洲化学品管理局（ECHA）、中国化学品安全网、农药登记资料、《斯德哥尔摩公约》持久性有机污染物审查委员会报告等权威数据库和文献。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '本MSDS的信息仅适用于所指定的产品，除非特别指明，对于本产品与其他物质的混合物等情况不适用。本MSDS基于现有的可靠科学数据编制，但不对其准确性或完整性作任何保证。使用者应根据实际使用条件进行适当的安全评估和防护措施。', '', NULL, '', NULL);
INSERT INTO `msds_other_info` VALUES (3, 175, NULL, '国际化学品安全卡（ICSC）、美国国立职业安全卫生研究所（NIOSH）、欧洲化学品管理局（ECHA）、中国化学品安全网、农药登记资料、危险化学品分类信息表、杀那特安全技术说明书等权威数据库和文献。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '本MSDS的信息仅适用于所指定的产品，除非特别指明，对于本产品与其他物质的混合物等情况不适用。本MSDS基于现有的可靠科学数据编制，但不对其准确性或完整性作任何保证。使用者应根据实际使用条件进行适当的安全评估和防护措施。', '', NULL, '', NULL);
INSERT INTO `msds_other_info` VALUES (4, 176, NULL, '国际化学品安全卡（ICSC）、美国国立职业安全卫生研究所（NIOSH）、欧洲化学品管理局（ECHA）、中国化学品安全网、农药登记资料、《斯德哥尔摩公约》持久性有机污染物审查委员会报告等权威数据库和文献。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '本MSDS的信息仅适用于所指定的产品，除非特别指明，对于本产品与其他物质的混合物等情况不适用。本MSDS基于现有的可靠科学数据编制，但不对其准确性或完整性作任何保证。使用者应根据实际使用条件进行适当的安全评估和防护措施。', '', NULL, '', NULL);
INSERT INTO `msds_other_info` VALUES (5, 177, NULL, '国际化学品安全卡（ICSC）、美国国立职业安全卫生研究所（NIOSH）、欧洲化学品管理局（ECHA）、中国化学品安全网、农药登记资料、《斯德哥尔摩公约》持久性有机污染物审查委员会报告等权威数据库和文献。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '本MSDS的信息仅适用于所指定的产品，除非特别指明，对于本产品与其他物质的混合物等情况不适用。本MSDS基于现有的可靠科学数据编制，但不对其准确性或完整性作任何保证。使用者应根据实际使用条件进行适当的安全评估和防护措施。', '', NULL, '', NULL);
INSERT INTO `msds_other_info` VALUES (6, 178, NULL, '国际化学品安全卡（ICSC）、美国国立职业安全卫生研究所（NIOSH）、欧洲化学品管理局（ECHA）、中国化学品安全网、农药登记资料、《危险化学品目录》（2015版）、毒理学数据库等权威数据库和文献。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '本MSDS的信息仅适用于所指定的产品，除非特别指明，对于本产品与其他物质的混合物等情况不适用。本MSDS基于现有的可靠科学数据编制，但不对其准确性或完整性作任何保证。使用者应根据实际使用条件进行适当的安全评估和防护措施。', '', NULL, '', NULL);
INSERT INTO `msds_other_info` VALUES (7, 179, NULL, '国际化学品安全卡（ICSC）、美国国立职业安全卫生研究所（NIOSH）、欧洲化学品管理局（ECHA）、中国化学品安全网、农药登记资料、《危险化学品目录》（2015版）、毒理学数据库等权威数据库和文献。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '本MSDS的信息仅适用于所指定的产品，除非特别指明，对于本产品与其他物质的混合物等情况不适用。本MSDS基于现有的可靠科学数据编制，但不对其准确性或完整性作任何保证。使用者应根据实际使用条件进行适当的安全评估和防护措施。', '', NULL, '', NULL);
INSERT INTO `msds_other_info` VALUES (8, 180, NULL, '国际化学品安全卡（ICSC）、美国国立职业安全卫生研究所（NIOSH）、欧洲化学品管理局（ECHA）、中国化学品安全网、农药登记资料、《危险化学品目录》（2015版）、毒理学数据库等权威数据库和文献。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '本MSDS的信息仅适用于所指定的产品，除非特别指明，对于本产品与其他物质的混合物等情况不适用。本MSDS基于现有的可靠科学数据编制，但不对其准确性或完整性作任何保证。使用者应根据实际使用条件进行适当的安全评估和防护措施。', '', NULL, '', NULL);

-- ----------------------------
-- Table structure for msds_physical_chemical
-- ----------------------------
DROP TABLE IF EXISTS `msds_physical_chemical`;
CREATE TABLE `msds_physical_chemical`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
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
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id` ASC) USING BTREE,
  CONSTRAINT `msds_physical_chemical_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '理化特性表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_physical_chemical
-- ----------------------------
INSERT INTO `msds_physical_chemical` VALUES (19, 174, '二种异构体的混合物，是棕色结晶。', NULL, NULL, '70～100', '449.7ºC at 760mmHg', '1.745(20℃)', NULL, NULL, NULL, '几乎不溶于水，溶于大多数有机溶剂如丙酮、苯、二甲苯、氯仿等', NULL, NULL, NULL, '225.8ºC', NULL, NULL, NULL, NULL, NULL, NULL, 'C9H6Cl6O3S', NULL, NULL, '无资料（高温下分解，难以测定）', '可燃，但不易燃烧', '406.91', NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_physical_chemical` VALUES (20, 175, '黄色油状液体，有萜烯味。', NULL, NULL, '-48℃', '95／7.98×0.001kPa', '1.1465(25／4℃)', NULL, NULL, NULL, '不溶于水，易溶于醇、苯、氯仿、醚。', NULL, NULL, NULL, '82', NULL, NULL, NULL, NULL, NULL, NULL, 'C13H19NO2S', NULL, NULL, '无资料（建议开展自燃温度测试）', '可燃', '253.39', NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_physical_chemical` VALUES (21, 176, '工业品为褐色固体。', NULL, NULL, '175～176', '无资料', '1.75', NULL, NULL, NULL, '几乎不溶于水（0.186 mg/L），易溶于大多数有机溶剂如丙酮、苯、二甲苯、氯仿等', NULL, NULL, NULL, '无意义', NULL, NULL, NULL, NULL, NULL, NULL, 'C12H8Cl6O', NULL, NULL, '无资料', '可燃', '380.91', NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_physical_chemical` VALUES (22, 177, '白色结晶。', NULL, NULL, '245(分解)', '无资料', '1.65(25℃)', NULL, NULL, NULL, '几乎不溶于水（0.25 mg/L），易溶于大多数有机溶剂如丙酮、苯、二甲苯、氯仿等', NULL, NULL, NULL, '无资料', NULL, NULL, NULL, NULL, NULL, NULL, 'C12H8Cl6O', NULL, NULL, '无资料', '不燃', '380.90', NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_physical_chemical` VALUES (23, 178, '白色结晶性粉末或无色结晶', NULL, NULL, '204~205', '35', '不适用', NULL, NULL, NULL, '易溶于水，微溶于乙醇，几乎不溶于乙醚、氯仿', NULL, NULL, NULL, '不适用', NULL, NULL, NULL, NULL, NULL, NULL, 'C6H15ClN2O2', NULL, NULL, '无资料', '不燃', '182.65', NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_physical_chemical` VALUES (24, 179, '黄色至棕色液体。', NULL, NULL, '<25℃', '400', '1.216 (15°C)', NULL, NULL, NULL, '易溶于水、乙醇、丙酮、氯仿，微溶于苯、二甲苯', NULL, NULL, NULL, '100°C', NULL, NULL, NULL, NULL, NULL, NULL, 'C8H16NO5P', NULL, NULL, '引燃温度(℃)：无资料', '可燃', '237.22', NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_physical_chemical` VALUES (25, 180, '原药为黄棕色至深红褐色粘稠液体。', NULL, NULL, '无资料', '无资料', '1.24(20℃)', NULL, NULL, NULL, '几乎不溶于水，易溶于大多数有机溶剂如丙酮、乙醇、二甲苯、氯仿等', NULL, NULL, NULL, '80', NULL, NULL, NULL, NULL, NULL, NULL, 'C22H19Cl2NO3', NULL, NULL, '无资料', '可燃', '416.32', NULL, NULL, NULL, NULL, '', NULL, '', NULL);

-- ----------------------------
-- Table structure for msds_regulatory
-- ----------------------------
DROP TABLE IF EXISTS `msds_regulatory`;
CREATE TABLE `msds_regulatory`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
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
  `create_time` datetime NULL DEFAULT NULL,
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id` ASC) USING BTREE,
  CONSTRAINT `msds_regulatory_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '法规信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_regulatory
-- ----------------------------
INSERT INTO `msds_regulatory` VALUES (42, 174, '列入《危险化学品目录（2015版）》《危险货物品名表》（GB 12268-2012）及《危险化学品安全管理条例》。硫丹已被列入《斯德哥尔摩公约》持久性有机污染物（POPs）禁用名单，我国已禁止生产、使用和进出口。需遵守《农药管理条例》《危险废物污染环境防治法》等相关法规。', NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_regulatory` VALUES (43, 175, '《危险化学品安全管理条例》（国务院令第591号）、《危险化学品目录》（2015版）、《危险货物品名表》（GB 12268-2012）、《危险货物运输包装通用技术条件》（GB 12463-2009）、《危险货物道路运输安全管理办法》（交通运输部令2019年第29号）。本品属于第6.1类毒害品，应按照相关法规进行生产、储存、运输和使用。使用时应遵守《农药管理条例》相关规定。', NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_regulatory` VALUES (44, 176, '列入《危险化学品目录（2015版）》《危险货物品名表》（GB 12268-2012）及《危险化学品安全管理条例》。狄氏剂已被列入《斯德哥尔摩公约》持久性有机污染物（POPs）禁用名单，我国已禁止生产、使用和进出口。需遵守《农药管理条例》《危险废物污染环境防治法》《持久性有机污染物管理办法》等相关法规。', NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_regulatory` VALUES (45, 177, '列入《危险化学品目录（2015版）》《危险货物品名表》（GB 12268-2012）及《危险化学品安全管理条例》。异狄氏剂已被列入《斯德哥尔摩公约》持久性有机污染物（POPs）禁用名单，我国已禁止生产、使用和进出口。需遵守《农药管理条例》《危险废物污染环境防治法》《持久性有机污染物管理办法》等相关法规。', NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_regulatory` VALUES (46, 178, '《危险化学品安全管理条例》（国务院令第591号）、《危险化学品目录》（2015版）、《危险货物品名表》（GB 12268-2012）、《危险货物运输包装通用技术条件》（GB 12463-2009）、《危险货物道路运输安全管理办法》（交通运输部令2019年第29号）。本品属于第6.1类毒害品，应按照相关法规进行生产、储存、运输和使用。作为药品使用时，需遵守《药品管理法》相关规定。', NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_regulatory` VALUES (47, 179, '《危险化学品安全管理条例》（国务院令第591号）、《危险化学品目录》（2015版）、《危险货物品名表》（GB 12268-2012）、《危险货物运输包装通用技术条件》（GB 12463-2009）、《危险货物道路运输安全管理办法》（交通运输部令2019年第29号）。本品属于第6.1类毒害品，应按照相关法规进行生产、储存、运输和使用。使用时应遵守《农药管理条例》相关规定。', NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_regulatory` VALUES (48, 180, '《危险化学品安全管理条例》（国务院令第591号）、《危险化学品目录》（2015版）、《危险货物品名表》（GB 12268-2012）、《危险货物运输包装通用技术条件》（GB 12463-2009）、《危险货物道路运输安全管理办法》（交通运输部令2019年第29号）。本品属于第6.1类毒害品，应按照相关法规进行生产、储存、运输和使用。使用时应遵守《农药管理条例》相关规定。', NULL, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, '', NULL, '', NULL);

-- ----------------------------
-- Table structure for msds_search_history
-- ----------------------------
DROP TABLE IF EXISTS `msds_search_history`;
CREATE TABLE `msds_search_history`  (
  `search_id` bigint NOT NULL AUTO_INCREMENT COMMENT '????ID',
  `user_id` bigint NOT NULL COMMENT '??ID',
  `user_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '????',
  `search_keyword` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '?????',
  `search_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'general' COMMENT 'search type: general, semantic, cas, formula',
  `filter_params` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '????JSON??',
  `result_count` int NULL DEFAULT 0 COMMENT '??????',
  `search_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `ip_address` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'IP??',
  `user_agent` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '????',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??',
  PRIMARY KEY (`search_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_search_time`(`search_time` ASC) USING BTREE,
  INDEX `idx_search_keyword`(`search_keyword`(255) ASC) USING BTREE,
  INDEX `idx_user_search_time`(`user_id` ASC, `search_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 51 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'MSDS?????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_search_history
-- ----------------------------
INSERT INTO `msds_search_history` VALUES (1, 1, '', '硫酸', 'general', NULL, 0, '2025-11-05 17:15:47', '', '', '', '2025-11-05 09:15:47', '', '2025-11-05 09:15:47', NULL);
INSERT INTO `msds_search_history` VALUES (2, 1, '', '1-(2-过氧化乙基己醇-1,3-二甲', 'general', NULL, 1, '2025-11-05 21:56:43', '', '', '', '2025-11-05 13:56:43', '', '2025-11-05 13:56:43', NULL);
INSERT INTO `msds_search_history` VALUES (3, 1, '', '1-(2-过氧化乙基己醇-1,3-二甲', 'general', NULL, 1, '2025-11-05 21:56:46', '', '', '', '2025-11-05 13:56:45', '', '2025-11-05 13:56:45', NULL);
INSERT INTO `msds_search_history` VALUES (4, 1, '', '1-(2-过氧化乙基己醇-1,3-二甲', 'general', NULL, 1, '2025-11-05 21:56:50', '', '', '', '2025-11-05 13:56:49', '', '2025-11-05 13:56:49', NULL);
INSERT INTO `msds_search_history` VALUES (5, 1, '', '1-(2-过氧化乙基己醇-1,3-二甲', 'cas', NULL, 0, '2025-11-05 21:57:39', '', '', '', '2025-11-05 13:57:39', '', '2025-11-05 13:57:39', NULL);
INSERT INTO `msds_search_history` VALUES (6, 1, '', '1-(2-过氧化乙基己醇-1,3-二甲', 'cas', NULL, 0, '2025-11-05 21:57:41', '', '', '', '2025-11-05 13:57:40', '', '2025-11-05 13:57:40', NULL);
INSERT INTO `msds_search_history` VALUES (7, 1, '', '1-(2-过氧化乙基己醇-1,3-二甲', 'cas', NULL, 0, '2025-11-05 21:57:45', '', '', '', '2025-11-05 13:57:44', '', '2025-11-05 13:57:44', NULL);
INSERT INTO `msds_search_history` VALUES (8, 1, '', '228415-62-1', 'cas', NULL, 1, '2025-11-05 21:57:51', '', '', '', '2025-11-05 13:57:50', '', '2025-11-05 13:57:50', NULL);
INSERT INTO `msds_search_history` VALUES (9, 1, '', '1-(2-过氧化乙基己醇-1,3-二甲', 'cas', NULL, 0, '2025-11-05 21:57:57', '', '', '', '2025-11-05 13:57:56', '', '2025-11-05 13:57:56', NULL);
INSERT INTO `msds_search_history` VALUES (10, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-05 21:58:10', '', '', '', '2025-11-05 13:58:10', '', '2025-11-05 13:58:10', NULL);
INSERT INTO `msds_search_history` VALUES (11, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'cas', NULL, 0, '2025-11-05 21:58:19', '', '', '', '2025-11-05 13:58:19', '', '2025-11-05 13:58:19', NULL);
INSERT INTO `msds_search_history` VALUES (12, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'cas', NULL, 0, '2025-11-05 21:58:21', '', '', '', '2025-11-05 13:58:20', '', '2025-11-05 13:58:20', NULL);
INSERT INTO `msds_search_history` VALUES (13, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-05 22:35:32', '', '', '', '2025-11-05 14:35:32', '', '2025-11-05 14:35:32', NULL);
INSERT INTO `msds_search_history` VALUES (14, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-05 22:35:34', '', '', '', '2025-11-05 14:35:33', '', '2025-11-05 14:35:33', NULL);
INSERT INTO `msds_search_history` VALUES (15, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-05 22:35:35', '', '', '', '2025-11-05 14:35:35', '', '2025-11-05 14:35:35', NULL);
INSERT INTO `msds_search_history` VALUES (16, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-05 22:42:14', '', '', '', '2025-11-05 14:42:14', '', '2025-11-05 14:42:14', NULL);
INSERT INTO `msds_search_history` VALUES (17, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-05 22:42:16', '', '', '', '2025-11-05 14:42:16', '', '2025-11-05 14:42:16', NULL);
INSERT INTO `msds_search_history` VALUES (18, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'cas', NULL, 0, '2025-11-05 22:42:34', '', '', '', '2025-11-05 14:42:33', '', '2025-11-05 14:42:33', NULL);
INSERT INTO `msds_search_history` VALUES (19, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'cas', NULL, 0, '2025-11-05 22:42:35', '', '', '', '2025-11-05 14:42:35', '', '2025-11-05 14:42:35', NULL);
INSERT INTO `msds_search_history` VALUES (20, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-05 22:44:32', '', '', '', '2025-11-05 14:44:31', '', '2025-11-05 14:44:31', NULL);
INSERT INTO `msds_search_history` VALUES (21, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-05 22:44:34', '', '', '', '2025-11-05 14:44:34', '', '2025-11-05 14:44:34', NULL);
INSERT INTO `msds_search_history` VALUES (22, 1, '', '54-11-5', 'cas', NULL, 1, '2025-11-05 23:01:30', '', '', '', '2025-11-05 15:01:29', '', '2025-11-05 15:01:29', NULL);
INSERT INTO `msds_search_history` VALUES (23, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'cas', NULL, 0, '2025-11-05 23:01:31', '', '', '', '2025-11-05 15:01:31', '', '2025-11-05 15:01:31', NULL);
INSERT INTO `msds_search_history` VALUES (24, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'cas', NULL, 0, '2025-11-05 23:01:32', '', '', '', '2025-11-05 15:01:32', '', '2025-11-05 15:01:32', NULL);
INSERT INTO `msds_search_history` VALUES (25, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'cas', NULL, 0, '2025-11-05 23:01:33', '', '', '', '2025-11-05 15:01:33', '', '2025-11-05 15:01:33', NULL);
INSERT INTO `msds_search_history` VALUES (26, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-05 23:01:36', '', '', '', '2025-11-05 15:01:35', '', '2025-11-05 15:01:35', NULL);
INSERT INTO `msds_search_history` VALUES (27, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-05 23:01:37', '', '', '', '2025-11-05 15:01:36', '', '2025-11-05 15:01:36', NULL);
INSERT INTO `msds_search_history` VALUES (28, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-06 10:01:30', '', '', '', '2025-11-06 02:01:29', '', '2025-11-06 02:01:29', NULL);
INSERT INTO `msds_search_history` VALUES (29, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-06 10:01:33', '', '', '', '2025-11-06 02:01:32', '', '2025-11-06 02:01:32', NULL);
INSERT INTO `msds_search_history` VALUES (30, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-06 10:01:34', '', '', '', '2025-11-06 02:01:33', '', '2025-11-06 02:01:33', NULL);
INSERT INTO `msds_search_history` VALUES (31, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 0, '2025-11-06 10:01:52', '', '', '', '2025-11-06 02:01:51', '', '2025-11-06 02:01:51', NULL);
INSERT INTO `msds_search_history` VALUES (32, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 0, '2025-11-06 10:01:52', '', '', '', '2025-11-06 02:01:52', '', '2025-11-06 02:01:52', NULL);
INSERT INTO `msds_search_history` VALUES (33, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 0, '2025-11-06 10:02:00', '', '', '', '2025-11-06 02:02:00', '', '2025-11-06 02:02:00', NULL);
INSERT INTO `msds_search_history` VALUES (34, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-06 10:28:26', '', '', '', '2025-11-06 02:28:26', '', '2025-11-06 02:28:26', NULL);
INSERT INTO `msds_search_history` VALUES (35, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-06 10:28:29', '', '', '', '2025-11-06 02:28:28', '', '2025-11-06 02:28:28', NULL);
INSERT INTO `msds_search_history` VALUES (36, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-06 10:28:32', '', '', '', '2025-11-06 02:28:31', '', '2025-11-06 02:28:31', NULL);
INSERT INTO `msds_search_history` VALUES (37, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-06 10:28:34', '', '', '', '2025-11-06 02:28:33', '', '2025-11-06 02:28:33', NULL);
INSERT INTO `msds_search_history` VALUES (38, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-06 10:28:34', '', '', '', '2025-11-06 02:28:34', '', '2025-11-06 02:28:34', NULL);
INSERT INTO `msds_search_history` VALUES (39, 1, '', '吡啶', 'general', NULL, 1, '2025-11-06 10:32:42', '', '', '', '2025-11-06 02:32:42', '', '2025-11-06 02:32:42', NULL);
INSERT INTO `msds_search_history` VALUES (40, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-06 10:32:45', '', '', '', '2025-11-06 02:32:44', '', '2025-11-06 02:32:44', NULL);
INSERT INTO `msds_search_history` VALUES (41, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-06 10:32:48', '', '', '', '2025-11-06 02:32:48', '', '2025-11-06 02:32:48', NULL);
INSERT INTO `msds_search_history` VALUES (42, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-06 10:35:48', '', '', '', '2025-11-06 02:35:47', '', '2025-11-06 02:35:47', NULL);
INSERT INTO `msds_search_history` VALUES (43, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-06 10:35:49', '', '', '', '2025-11-06 02:35:48', '', '2025-11-06 02:35:48', NULL);
INSERT INTO `msds_search_history` VALUES (44, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-06 10:36:10', '', '', '', '2025-11-06 02:36:10', '', '2025-11-06 02:36:10', NULL);
INSERT INTO `msds_search_history` VALUES (45, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-06 10:36:11', '', '', '', '2025-11-06 02:36:11', '', '2025-11-06 02:36:11', NULL);
INSERT INTO `msds_search_history` VALUES (46, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-06 10:36:12', '', '', '', '2025-11-06 02:36:12', '', '2025-11-06 02:36:12', NULL);
INSERT INTO `msds_search_history` VALUES (47, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-06 10:36:22', '', '', '', '2025-11-06 02:36:22', '', '2025-11-06 02:36:22', NULL);
INSERT INTO `msds_search_history` VALUES (48, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-06 10:38:49', '', '', '', '2025-11-06 02:38:49', '', '2025-11-06 02:38:49', NULL);
INSERT INTO `msds_search_history` VALUES (49, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-06 11:25:45', '', '', '', '2025-11-06 03:25:44', '', '2025-11-06 03:25:44', NULL);
INSERT INTO `msds_search_history` VALUES (50, 1, '', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', 'general', NULL, 1, '2025-11-06 11:25:47', '', '', '', '2025-11-06 03:25:47', '', '2025-11-06 03:25:47', NULL);

-- ----------------------------
-- Table structure for msds_search_suggestion
-- ----------------------------
DROP TABLE IF EXISTS `msds_search_suggestion`;
CREATE TABLE `msds_search_suggestion`  (
  `suggestion_id` bigint NOT NULL AUTO_INCREMENT COMMENT '??ID',
  `keyword` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '?????',
  `keyword_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'hot' COMMENT 'keyword type: hot, ai, related, cas, formula',
  `related_cas` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??CAS?',
  `related_msds_id` bigint NULL DEFAULT NULL COMMENT '??MSDS??ID',
  `search_count` int NULL DEFAULT 0 COMMENT '????',
  `click_count` int NULL DEFAULT 0 COMMENT '????',
  `sort_order` int NULL DEFAULT 0 COMMENT '????',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '????: 0??, 1??',
  `start_time` datetime NULL DEFAULT NULL COMMENT '??????',
  `end_time` datetime NULL DEFAULT NULL COMMENT '??????',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??',
  PRIMARY KEY (`suggestion_id`) USING BTREE,
  UNIQUE INDEX `uk_keyword_type`(`keyword`(255) ASC, `keyword_type` ASC) USING BTREE,
  INDEX `idx_keyword_type`(`keyword_type` ASC) USING BTREE,
  INDEX `idx_search_count`(`search_count` ASC) USING BTREE,
  INDEX `idx_sort_order`(`sort_order` ASC) USING BTREE,
  INDEX `idx_is_active`(`is_active` ASC) USING BTREE,
  INDEX `idx_related_msds`(`related_msds_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'MSDS?????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_search_suggestion
-- ----------------------------

-- ----------------------------
-- Table structure for msds_stability_reactivity
-- ----------------------------
DROP TABLE IF EXISTS `msds_stability_reactivity`;
CREATE TABLE `msds_stability_reactivity`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
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
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id` ASC) USING BTREE,
  CONSTRAINT `msds_stability_reactivity_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '稳定性和反应性表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_stability_reactivity
-- ----------------------------
INSERT INTO `msds_stability_reactivity` VALUES (42, 174, '稳定', NULL, '强氧化剂、强酸、强碱、潮湿空气。', '避免接触强氧化剂、强酸、强碱、潮湿空气。避免受热分解。', NULL, '不能出现', NULL, '受热分解产生一氧化碳、二氧化碳、氯化氢、氧化硫等有毒气体。', NULL, NULL, '2026-02-25 15:32:46', '', NULL);
INSERT INTO `msds_stability_reactivity` VALUES (43, 175, '稳定', NULL, '强氧化剂、强碱。', '避免接触明火、高热。避免与强氧化剂、强碱接触。避免受热分解。', NULL, '不能出现', NULL, '受热分解产生有毒的氮氧化物、氧化硫烟雾和氰化物。', NULL, NULL, '2026-02-25 15:32:47', '', NULL);
INSERT INTO `msds_stability_reactivity` VALUES (44, 176, '稳定', NULL, '强氧化剂、强酸。', '避免接触明火、高热。避免与强氧化剂、强酸接触。', NULL, '不能出现', NULL, '受热分解产生一氧化碳、二氧化碳、氯化氢等有毒气体。', NULL, NULL, '2026-02-25 15:32:47', '', NULL);
INSERT INTO `msds_stability_reactivity` VALUES (45, 177, '稳定', NULL, '强氧化剂。', '避免接触明火、高热。避免与强氧化剂接触。', NULL, '不能出现', NULL, '受热分解产生一氧化碳、二氧化碳、氯化氢等有毒气体。', NULL, NULL, '2026-02-25 15:32:48', '', NULL);
INSERT INTO `msds_stability_reactivity` VALUES (46, 178, '在正确的使用和存储条件下是稳定的', NULL, '强氧化剂、强碱。与胆碱酯酶抑制剂（如有机磷农药）同时使用会增强毒性。', '避免接触明火、高热。避免与强氧化剂、强碱接触。避免受热分解。', NULL, '不能出现', NULL, '受热分解产生氯化氢、氮氧化物、一氧化碳、二氧化碳等有毒气体。', NULL, NULL, '2026-02-25 15:32:48', '', NULL);
INSERT INTO `msds_stability_reactivity` VALUES (47, 179, '稳定', NULL, '强氧化剂。', '避免接触明火、高热。避免与强氧化剂接触。避免受热分解。', NULL, '不能出现', NULL, '受热分解产生一氧化碳、二氧化碳、氧化氮、氧化磷等有毒气体。', NULL, NULL, '2026-02-25 15:32:48', '', NULL);
INSERT INTO `msds_stability_reactivity` VALUES (48, 180, '稳定', NULL, '强氧化剂、强碱。', '光照。', NULL, '不能出现', NULL, '受热分解产生一氧化碳、二氧化碳、氮氧化物、氯化氢、氰化物等有毒气体。', NULL, NULL, '2026-02-25 15:32:49', '', NULL);

-- ----------------------------
-- Table structure for msds_toxicological
-- ----------------------------
DROP TABLE IF EXISTS `msds_toxicological`;
CREATE TABLE `msds_toxicological`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
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
  `create_time` datetime NULL DEFAULT NULL,
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '',
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id` ASC) USING BTREE,
  CONSTRAINT `msds_toxicological_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 59 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '毒理学资料表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_toxicological
-- ----------------------------
INSERT INTO `msds_toxicological` VALUES (52, 174, 'LD50：18mg／kg(大鼠经口)；7.36mg／kg(小鼠经口)；34mg／kg(大鼠经皮)；LC50：0.002-0.01mg/L(96小时，鱼类)', 'LD50：18mg／kg(大鼠经口)', '34mg／kg(大鼠经皮)', '0.002-0.01mg/L(96小时，鱼类)', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_toxicological` VALUES (53, 175, 'LD50：1600mg/kg(大鼠经口)；6000mg/kg(兔经皮)。LC50：无资料（建议开展吸入毒性测试，方法参考OECD TG 403）。根据LD50值判断，本品为低毒类物质。', 'LD50：1600mg/kg(大鼠经口)', '6000mg/kg(兔经皮)', '无资料（建议开展吸入毒性测试，方法参考OECD TG 403）。根据LD50值判断，本品为低毒类物质。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_toxicological` VALUES (54, 176, 'LD50：46mg／kg(大鼠经口)LC50：', 'LD50：46mg／kg(大鼠经口)', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_toxicological` VALUES (55, 177, 'LD50：7.5～17.5mg／kg(大鼠经口)；15mg／kg(大鼠经皮)LC50：', NULL, '15mg／kg(大鼠经皮)', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_toxicological` VALUES (56, 178, 'LD50：0.25mg/kg（大鼠经口）；0.3mg/kg（小鼠经口）。属剧毒类物质。', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_toxicological` VALUES (57, 179, 'LD50：15-45mg／kg(大鼠经口)；42mg／kg(大鼠经皮)；兔LD50经皮为168－224mg/kg；人经口致死量估计为5－50mg/kg。LC50：无资料', NULL, '42mg／kg(大鼠经皮)', '无资料', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);
INSERT INTO `msds_toxicological` VALUES (58, 180, 'LD50：251mg／kg(大鼠经口)；1600mg／kg(大鼠经皮)LC50：', 'LD50：251mg／kg(大鼠经口)', '1600mg／kg(大鼠经皮)', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, '', NULL);

-- ----------------------------
-- Table structure for msds_transportation
-- ----------------------------
DROP TABLE IF EXISTS `msds_transportation`;
CREATE TABLE `msds_transportation`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
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
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_msds_id`(`msds_id` ASC) USING BTREE,
  INDEX `idx_un_number`(`un_number` ASC) USING BTREE,
  INDEX `idx_dangerous_goods_number`(`dangerous_goods_number` ASC) USING BTREE,
  CONSTRAINT `msds_transportation_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 46 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '运输信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_transportation
-- ----------------------------
INSERT INTO `msds_transportation` VALUES (41, 174, '61127', '2761', NULL, NULL, 'Ⅱ', NULL, '内层玻璃或金属容器，外覆钢桶/木箱，并配吸附材料防泄漏。包装应密封、防潮、防破损。', NULL, NULL, '运输前检查密封，防止跌落和碰撞。严禁与氧化剂、酸类、碱类、食用化学品混装混运，车辆需配备灭火器与泄漏应急装置。运输途中应防曝晒、雨淋，防高温。公路运输时要按规定路线行驶，勿在居民区和人口稠密区停留。', NULL, NULL, NULL, '2026-02-25 15:32:47', '', NULL);
INSERT INTO `msds_transportation` VALUES (42, 176, '61127', '2761', NULL, NULL, 'O52', NULL, '内层玻璃或金属容器，外覆钢桶/木箱，并配吸附材料防泄漏。包装应密封、防潮、防破损。', NULL, NULL, '运输前检查密封，防止跌落和碰撞。严禁与氧化剂、酸类、食用化学品混装混运，车辆需配备灭火器与泄漏应急装置。运输途中应防曝晒、雨淋，防高温。公路运输时要按规定路线行驶，勿在居民区和人口稠密区停留。狄氏剂为禁用物质，运输需遵守特殊规定。', NULL, NULL, NULL, '2026-02-25 15:32:47', '', NULL);
INSERT INTO `msds_transportation` VALUES (43, 177, '61127', '2761', NULL, NULL, 'Ⅱ', NULL, '内层玻璃或金属容器，外覆钢桶/木箱，并配吸附材料防泄漏。包装应密封、防潮、防破损。', NULL, NULL, '运输前检查密封，防止跌落和碰撞。严禁与氧化剂、食用化学品混装混运，车辆需配备灭火器与泄漏应急装置。运输途中应防曝晒、雨淋，防高温。公路运输时要按规定路线行驶，勿在居民区和人口稠密区停留。异狄氏剂为禁用物质，运输需遵守特殊规定。', NULL, NULL, NULL, '2026-02-25 15:32:48', '', NULL);
INSERT INTO `msds_transportation` VALUES (44, 179, '61874', '2783', NULL, NULL, 'Ⅱ', NULL, '内层玻璃或金属容器，外覆钢桶/木箱，并配吸附材料防泄漏。包装应密封、防潮、防破损。', NULL, NULL, '运输前检查密封，防止跌落和碰撞。严禁与氧化剂、食用化学品混装混运，车辆需配备灭火器与泄漏应急装置。运输途中应防曝晒、雨淋，防高温。公路运输时要按规定路线行驶，勿在居民区和人口稠密区停留。', NULL, NULL, NULL, '2026-02-25 15:32:48', '', NULL);
INSERT INTO `msds_transportation` VALUES (45, 180, '61904', '2588', NULL, NULL, 'Ⅲ', NULL, '内层玻璃或金属容器，外覆钢桶/木箱，并配吸附材料防泄漏。包装应密封、防潮、防破损。', NULL, NULL, '运输前检查密封，防止跌落和碰撞。严禁与氧化剂、碱类、食用化学品混装混运，车辆需配备灭火器与泄漏应急装置。运输途中应防曝晒、雨淋，防高温。公路运输时要按规定路线行驶，勿在居民区和人口稠密区停留。', NULL, NULL, NULL, '2026-02-25 15:32:49', '', NULL);

-- ----------------------------
-- Table structure for msds_user_favorite
-- ----------------------------
DROP TABLE IF EXISTS `msds_user_favorite`;
CREATE TABLE `msds_user_favorite`  (
  `favorite_id` bigint NOT NULL AUTO_INCREMENT COMMENT '??ID',
  `user_id` bigint NOT NULL COMMENT '??ID',
  `user_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '????',
  `msds_id` bigint NOT NULL COMMENT 'MSDS??ID',
  `msds_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'MSDS????',
  `cas_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'CAS?',
  `folder_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '??' COMMENT '?????',
  `tags` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??????',
  `note` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '????',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '????',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '???',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '????',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '??',
  PRIMARY KEY (`favorite_id`) USING BTREE,
  UNIQUE INDEX `uk_user_msds`(`user_id` ASC, `msds_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_msds_id`(`msds_id` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE,
  INDEX `idx_folder_name`(`folder_name` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'MSDS?????' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_user_favorite
-- ----------------------------

-- ----------------------------
-- Table structure for msds_version_history
-- ----------------------------
DROP TABLE IF EXISTS `msds_version_history`;
CREATE TABLE `msds_version_history`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
  `version` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '版本号',
  `change_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '变更描述',
  `change_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '变更原因',
  `changed_sections` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '变更章节',
  `change_date` date NULL DEFAULT NULL COMMENT '变更日期',
  `changed_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '变更人',
  `approved_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审批人',
  `approval_date` date NULL DEFAULT NULL COMMENT '审批日期',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_msds_id`(`msds_id` ASC) USING BTREE,
  INDEX `idx_version`(`version` ASC) USING BTREE,
  INDEX `idx_change_date`(`change_date` ASC) USING BTREE,
  CONSTRAINT `msds_version_history_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'MSDS版本历史表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of msds_version_history
-- ----------------------------

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
-- Records of qrtz_blob_triggers
-- ----------------------------

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
-- Records of qrtz_calendars
-- ----------------------------

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
-- Records of qrtz_cron_triggers
-- ----------------------------

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
  `fired_time` bigint NOT NULL COMMENT '触发的时间',
  `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
  `priority` int NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`, `entry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '已触发的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------

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
-- Records of qrtz_job_details
-- ----------------------------

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
-- Records of qrtz_locks
-- ----------------------------

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
-- Records of qrtz_paused_trigger_grps
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`, `instance_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '调度器状态表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '简单触发器的信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------

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
  `int_prop_1` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int NULL DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint NULL DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '同步机制的行锁表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simprop_triggers
-- ----------------------------

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
  `next_fire_time` bigint NULL DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint NULL DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int NULL DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint NOT NULL COMMENT '开始时间',
  `end_time` bigint NULL DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint NULL DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  INDEX `sched_name`(`sched_name` ASC, `job_name` ASC, `job_group` ASC) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '触发器详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
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
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 200 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '部门表' ROW_FORMAT = Dynamic;

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
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
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
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '字典类型表' ROW_FORMAT = Dynamic;

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
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
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
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '异常信息',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 426 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;

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
INSERT INTO `sys_logininfor` VALUES (250, 'admin', '172.19.0.7', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-04 01:33:23');
INSERT INTO `sys_logininfor` VALUES (251, 'admin', '172.19.0.8', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2025-11-04 06:00:47');
INSERT INTO `sys_logininfor` VALUES (252, 'admin', '172.19.0.8', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-04 06:00:58');
INSERT INTO `sys_logininfor` VALUES (253, 'admin', '172.19.0.5', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码已失效', '2025-11-04 12:32:40');
INSERT INTO `sys_logininfor` VALUES (254, 'admin', '172.19.0.5', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码已失效', '2025-11-04 12:56:41');
INSERT INTO `sys_logininfor` VALUES (255, 'admin', '172.19.0.4', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-05 00:55:30');
INSERT INTO `sys_logininfor` VALUES (256, 'admin', '172.19.0.4', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-05 01:16:54');
INSERT INTO `sys_logininfor` VALUES (257, 'admin', '172.19.0.4', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-11-05 01:58:16');
INSERT INTO `sys_logininfor` VALUES (258, 'admin', '172.19.0.4', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-05 02:00:51');
INSERT INTO `sys_logininfor` VALUES (259, 'admin', '172.19.0.4', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-05 04:41:10');
INSERT INTO `sys_logininfor` VALUES (260, 'admin', '172.19.0.4', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-11-05 04:51:17');
INSERT INTO `sys_logininfor` VALUES (261, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-05 08:34:01');
INSERT INTO `sys_logininfor` VALUES (262, 'admin', '172.19.0.4', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-05 12:20:30');
INSERT INTO `sys_logininfor` VALUES (263, 'admin', '172.19.0.4', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-05 12:25:34');
INSERT INTO `sys_logininfor` VALUES (264, 'admin', '172.19.0.4', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-05 13:18:42');
INSERT INTO `sys_logininfor` VALUES (265, 'admin', '172.19.0.4', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-05 13:30:23');
INSERT INTO `sys_logininfor` VALUES (266, 'admin', '172.19.0.4', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-05 14:35:19');
INSERT INTO `sys_logininfor` VALUES (267, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码已失效', '2025-11-06 00:52:58');
INSERT INTO `sys_logininfor` VALUES (268, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-06 00:53:19');
INSERT INTO `sys_logininfor` VALUES (269, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-06 02:01:03');
INSERT INTO `sys_logininfor` VALUES (270, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-06 02:36:02');
INSERT INTO `sys_logininfor` VALUES (271, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-06 03:25:35');
INSERT INTO `sys_logininfor` VALUES (272, 'admin', '172.19.0.2', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-07 00:56:10');
INSERT INTO `sys_logininfor` VALUES (273, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-07 01:51:18');
INSERT INTO `sys_logininfor` VALUES (274, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-07 04:02:25');
INSERT INTO `sys_logininfor` VALUES (275, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '1', '验证码错误', '2025-11-07 04:03:30');
INSERT INTO `sys_logininfor` VALUES (276, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-07 04:03:39');
INSERT INTO `sys_logininfor` VALUES (277, 'admin', '172.19.0.2', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-07 14:21:24');
INSERT INTO `sys_logininfor` VALUES (278, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-17 05:46:02');
INSERT INTO `sys_logininfor` VALUES (279, 'admin', '172.19.0.1', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-11-18 15:16:46');
INSERT INTO `sys_logininfor` VALUES (280, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-01 13:49:15');
INSERT INTO `sys_logininfor` VALUES (281, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-01 14:00:56');
INSERT INTO `sys_logininfor` VALUES (282, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-01 14:05:44');
INSERT INTO `sys_logininfor` VALUES (283, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-02 03:38:21');
INSERT INTO `sys_logininfor` VALUES (284, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-02 05:36:07');
INSERT INTO `sys_logininfor` VALUES (285, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-02 05:48:42');
INSERT INTO `sys_logininfor` VALUES (286, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-02 13:18:42');
INSERT INTO `sys_logininfor` VALUES (287, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-12-02 13:22:13');
INSERT INTO `sys_logininfor` VALUES (288, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-02 13:22:54');
INSERT INTO `sys_logininfor` VALUES (289, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-02 13:37:29');
INSERT INTO `sys_logininfor` VALUES (290, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-02 13:48:51');
INSERT INTO `sys_logininfor` VALUES (291, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-02 13:49:06');
INSERT INTO `sys_logininfor` VALUES (292, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-02 13:50:22');
INSERT INTO `sys_logininfor` VALUES (293, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-02 13:53:35');
INSERT INTO `sys_logininfor` VALUES (294, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-02 13:53:49');
INSERT INTO `sys_logininfor` VALUES (295, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-02 13:55:15');
INSERT INTO `sys_logininfor` VALUES (296, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-02 14:01:57');
INSERT INTO `sys_logininfor` VALUES (297, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码已失效', '2025-12-02 14:28:52');
INSERT INTO `sys_logininfor` VALUES (298, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-02 14:29:00');
INSERT INTO `sys_logininfor` VALUES (299, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码错误', '2025-12-02 14:42:11');
INSERT INTO `sys_logininfor` VALUES (300, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-02 14:42:15');
INSERT INTO `sys_logininfor` VALUES (301, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码错误', '2025-12-02 14:46:06');
INSERT INTO `sys_logininfor` VALUES (302, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-02 14:46:10');
INSERT INTO `sys_logininfor` VALUES (303, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-02 14:46:27');
INSERT INTO `sys_logininfor` VALUES (304, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码错误', '2025-12-02 14:48:22');
INSERT INTO `sys_logininfor` VALUES (305, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-02 14:48:26');
INSERT INTO `sys_logininfor` VALUES (306, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-02 14:54:12');
INSERT INTO `sys_logininfor` VALUES (307, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-02 14:57:43');
INSERT INTO `sys_logininfor` VALUES (308, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-02 15:01:06');
INSERT INTO `sys_logininfor` VALUES (309, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-02 15:03:44');
INSERT INTO `sys_logininfor` VALUES (310, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-02 15:04:05');
INSERT INTO `sys_logininfor` VALUES (311, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 00:51:07');
INSERT INTO `sys_logininfor` VALUES (312, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 00:59:52');
INSERT INTO `sys_logininfor` VALUES (313, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 01:01:33');
INSERT INTO `sys_logininfor` VALUES (314, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 01:03:49');
INSERT INTO `sys_logininfor` VALUES (315, 'admin', '172.19.0.1', '内网IP', 'Chrome Mobile', 'Android 1.x', '0', '登录成功', '2025-12-03 01:05:09');
INSERT INTO `sys_logininfor` VALUES (316, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 01:08:33');
INSERT INTO `sys_logininfor` VALUES (317, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 01:13:39');
INSERT INTO `sys_logininfor` VALUES (318, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 01:15:18');
INSERT INTO `sys_logininfor` VALUES (319, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 01:19:10');
INSERT INTO `sys_logininfor` VALUES (320, 'admin', '172.19.0.3', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-03 01:19:46');
INSERT INTO `sys_logininfor` VALUES (321, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 01:21:58');
INSERT INTO `sys_logininfor` VALUES (322, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 01:22:12');
INSERT INTO `sys_logininfor` VALUES (323, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 01:22:57');
INSERT INTO `sys_logininfor` VALUES (324, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 01:29:46');
INSERT INTO `sys_logininfor` VALUES (325, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 01:30:01');
INSERT INTO `sys_logininfor` VALUES (326, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 01:30:33');
INSERT INTO `sys_logininfor` VALUES (327, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 01:39:01');
INSERT INTO `sys_logininfor` VALUES (328, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 01:40:54');
INSERT INTO `sys_logininfor` VALUES (329, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码已失效', '2025-12-03 01:52:10');
INSERT INTO `sys_logininfor` VALUES (330, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 01:52:12');
INSERT INTO `sys_logininfor` VALUES (331, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 01:53:09');
INSERT INTO `sys_logininfor` VALUES (332, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码已失效', '2025-12-03 02:06:00');
INSERT INTO `sys_logininfor` VALUES (333, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 02:06:04');
INSERT INTO `sys_logininfor` VALUES (334, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 02:23:07');
INSERT INTO `sys_logininfor` VALUES (335, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 02:36:39');
INSERT INTO `sys_logininfor` VALUES (336, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 02:41:29');
INSERT INTO `sys_logininfor` VALUES (337, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 02:42:32');
INSERT INTO `sys_logininfor` VALUES (338, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 02:52:41');
INSERT INTO `sys_logininfor` VALUES (339, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 02:53:06');
INSERT INTO `sys_logininfor` VALUES (340, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 02:58:21');
INSERT INTO `sys_logininfor` VALUES (341, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 03:04:22');
INSERT INTO `sys_logininfor` VALUES (342, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 03:07:28');
INSERT INTO `sys_logininfor` VALUES (343, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 03:20:28');
INSERT INTO `sys_logininfor` VALUES (344, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 03:22:26');
INSERT INTO `sys_logininfor` VALUES (345, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 03:29:42');
INSERT INTO `sys_logininfor` VALUES (346, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 03:35:29');
INSERT INTO `sys_logininfor` VALUES (347, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 03:37:11');
INSERT INTO `sys_logininfor` VALUES (348, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 05:19:47');
INSERT INTO `sys_logininfor` VALUES (349, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 05:38:25');
INSERT INTO `sys_logininfor` VALUES (350, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 05:39:02');
INSERT INTO `sys_logininfor` VALUES (351, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码已失效', '2025-12-03 05:43:38');
INSERT INTO `sys_logininfor` VALUES (352, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 05:43:44');
INSERT INTO `sys_logininfor` VALUES (353, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 05:44:16');
INSERT INTO `sys_logininfor` VALUES (354, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 05:54:11');
INSERT INTO `sys_logininfor` VALUES (355, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 06:00:36');
INSERT INTO `sys_logininfor` VALUES (356, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 06:18:55');
INSERT INTO `sys_logininfor` VALUES (357, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 06:32:17');
INSERT INTO `sys_logininfor` VALUES (358, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 06:40:05');
INSERT INTO `sys_logininfor` VALUES (359, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 06:40:45');
INSERT INTO `sys_logininfor` VALUES (360, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码已失效', '2025-12-03 06:43:42');
INSERT INTO `sys_logininfor` VALUES (361, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 06:43:47');
INSERT INTO `sys_logininfor` VALUES (362, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 06:50:21');
INSERT INTO `sys_logininfor` VALUES (363, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码已失效', '2025-12-03 06:59:16');
INSERT INTO `sys_logininfor` VALUES (364, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 06:59:22');
INSERT INTO `sys_logininfor` VALUES (365, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 07:09:11');
INSERT INTO `sys_logininfor` VALUES (366, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 07:16:50');
INSERT INTO `sys_logininfor` VALUES (367, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 07:30:56');
INSERT INTO `sys_logininfor` VALUES (368, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 07:32:37');
INSERT INTO `sys_logininfor` VALUES (369, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 07:34:03');
INSERT INTO `sys_logininfor` VALUES (370, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 07:45:10');
INSERT INTO `sys_logininfor` VALUES (371, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 07:47:09');
INSERT INTO `sys_logininfor` VALUES (372, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 07:59:03');
INSERT INTO `sys_logininfor` VALUES (373, 'admin', '172.19.0.3', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-03 08:31:42');
INSERT INTO `sys_logininfor` VALUES (374, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-03 09:39:52');
INSERT INTO `sys_logininfor` VALUES (375, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 14:18:00');
INSERT INTO `sys_logininfor` VALUES (376, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '退出成功', '2025-12-03 14:18:20');
INSERT INTO `sys_logininfor` VALUES (377, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 14:20:05');
INSERT INTO `sys_logininfor` VALUES (378, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码错误', '2025-12-03 14:20:57');
INSERT INTO `sys_logininfor` VALUES (379, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 14:21:05');
INSERT INTO `sys_logininfor` VALUES (380, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码错误', '2025-12-03 14:25:46');
INSERT INTO `sys_logininfor` VALUES (381, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 14:25:51');
INSERT INTO `sys_logininfor` VALUES (382, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 14:29:10');
INSERT INTO `sys_logininfor` VALUES (383, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-03 14:33:56');
INSERT INTO `sys_logininfor` VALUES (384, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-04 01:12:40');
INSERT INTO `sys_logininfor` VALUES (385, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-04 01:13:50');
INSERT INTO `sys_logininfor` VALUES (386, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-04 01:23:19');
INSERT INTO `sys_logininfor` VALUES (387, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-04 02:02:45');
INSERT INTO `sys_logininfor` VALUES (388, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-04 02:03:13');
INSERT INTO `sys_logininfor` VALUES (389, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-04 03:45:20');
INSERT INTO `sys_logininfor` VALUES (390, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-04 03:47:03');
INSERT INTO `sys_logininfor` VALUES (391, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '1', '验证码已失效', '2025-12-04 04:07:20');
INSERT INTO `sys_logininfor` VALUES (392, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-04 04:07:25');
INSERT INTO `sys_logininfor` VALUES (393, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-04 04:08:12');
INSERT INTO `sys_logininfor` VALUES (394, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-04 04:21:26');
INSERT INTO `sys_logininfor` VALUES (395, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-04 04:31:07');
INSERT INTO `sys_logininfor` VALUES (396, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-04 04:41:20');
INSERT INTO `sys_logininfor` VALUES (397, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-04 04:56:53');
INSERT INTO `sys_logininfor` VALUES (398, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-04 05:45:08');
INSERT INTO `sys_logininfor` VALUES (399, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-04 05:46:00');
INSERT INTO `sys_logininfor` VALUES (400, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-04 06:06:17');
INSERT INTO `sys_logininfor` VALUES (401, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-04 06:07:16');
INSERT INTO `sys_logininfor` VALUES (402, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-04 07:05:13');
INSERT INTO `sys_logininfor` VALUES (403, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-04 07:06:14');
INSERT INTO `sys_logininfor` VALUES (404, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-04 07:34:42');
INSERT INTO `sys_logininfor` VALUES (405, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-04 07:46:35');
INSERT INTO `sys_logininfor` VALUES (406, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-04 08:36:44');
INSERT INTO `sys_logininfor` VALUES (407, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-04 08:40:09');
INSERT INTO `sys_logininfor` VALUES (408, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-04 08:42:27');
INSERT INTO `sys_logininfor` VALUES (409, 'admin', '172.19.0.1', '内网IP', 'Mobile Safari', 'Mac OS X (iPhone)', '0', '登录成功', '2025-12-04 09:19:38');
INSERT INTO `sys_logininfor` VALUES (410, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-05 01:13:18');
INSERT INTO `sys_logininfor` VALUES (411, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-05 02:58:03');
INSERT INTO `sys_logininfor` VALUES (412, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2025-12-06 12:29:46');
INSERT INTO `sys_logininfor` VALUES (413, 'admin', '172.19.0.3', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-17 13:53:35');
INSERT INTO `sys_logininfor` VALUES (414, 'admin', '172.19.0.3', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-17 14:22:21');
INSERT INTO `sys_logininfor` VALUES (415, 'admin', '172.19.0.3', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-17 15:11:23');
INSERT INTO `sys_logininfor` VALUES (416, 'admin', '172.19.0.3', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2026-01-17 15:12:00');
INSERT INTO `sys_logininfor` VALUES (417, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-01-29 09:48:21');
INSERT INTO `sys_logininfor` VALUES (418, 'admin', '172.19.0.3', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-02-13 05:06:39');
INSERT INTO `sys_logininfor` VALUES (419, 'admin', '172.19.0.3', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-02-13 11:08:57');
INSERT INTO `sys_logininfor` VALUES (420, 'admin', '172.19.0.3', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-02-13 11:14:21');
INSERT INTO `sys_logininfor` VALUES (421, 'admin', '172.19.0.3', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-02-13 11:45:31');
INSERT INTO `sys_logininfor` VALUES (422, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-02-13 15:19:06');
INSERT INTO `sys_logininfor` VALUES (423, 'admin', '172.19.0.5', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-02-13 21:21:25');
INSERT INTO `sys_logininfor` VALUES (424, 'admin', '172.19.0.4', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-02-25 05:39:01');
INSERT INTO `sys_logininfor` VALUES (425, 'admin', '172.19.0.3', '内网IP', 'Chrome 14', 'Windows 10', '0', '登录成功', '2026-02-25 15:30:06');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2067 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 50, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'SettingOutlined', 'admin', '2025-06-24 19:45:06', 'admin', '2025-11-05 08:51:34', '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 11, 'monitor', NULL, '', '', 1, 0, 'M', '0', '0', '', 'DashboardOutlined', 'admin', '2025-06-24 19:45:06', 'admin', '2025-07-02 17:08:03', '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 12, 'tool', NULL, '', '', 1, 0, 'M', '0', '0', '', 'ToolOutlined', 'admin', '2025-06-24 19:45:06', 'admin', '2025-07-02 17:08:31', '系统工具目录');
INSERT INTO `sys_menu` VALUES (4, '公司官网', 0, 100, 'jfkj.com', NULL, '', '', 1, 0, 'M', '0', '0', '', 'LinkOutlined', 'admin', '2025-06-24 19:45:06', 'admin', '2026-02-13 15:22:16', '若依官网地址');
INSERT INTO `sys_menu` VALUES (5, '控制台', 0, 0, 'dashboard', NULL, '', '', 1, 0, 'M', '0', '0', '', 'AppstoreOutlined', 'admin', '2025-06-24 19:45:06', 'admin', '2025-11-05 02:03:28', '控制台');
INSERT INTO `sys_menu` VALUES (6, '用户协作', 0, 46, 'account', NULL, '', '', 1, 0, 'M', '0', '0', '', 'ProfileOutlined', 'admin', '2025-06-24 19:45:06', 'admin', '2025-12-04 01:38:42', '个人');
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
INSERT INTO `sys_menu` VALUES (2000, 'MSDS管理', 0, 10, 'msds', NULL, '', '', 1, 0, 'M', '0', '0', '', 'FileTextOutlined', 'admin', '2025-06-29 10:32:17', 'admin', '2025-11-05 08:46:15', 'MSDS管理目录');
INSERT INTO `sys_menu` VALUES (2001, 'MSDS信息', 2000, 1, '/msds/main', 'msds/main/index', '', '', 1, 0, 'C', '0', '0', 'system:msds:list', 'file-text', 'admin', '2025-06-29 10:32:18', 'admin', '2025-11-05 13:42:28', 'MSDS主信息菜单');
INSERT INTO `sys_menu` VALUES (2002, 'MSDS查询', 2001, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:msds:query', '#', 'admin', '2025-06-29 10:32:18', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2003, 'MSDS新增', 2001, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:msds:add', '#', 'admin', '2025-06-29 10:32:18', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2004, 'MSDS修改', 2001, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:msds:edit', '#', 'admin', '2025-06-29 10:32:18', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2005, 'MSDS删除', 2001, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:msds:remove', '#', 'admin', '2025-06-29 10:32:18', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2006, 'MSDS导出', 2001, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:msds:export', '#', 'admin', '2025-06-29 10:32:18', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2007, 'MSDS导入', 2001, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:msds:import', '#', 'admin', '2025-07-01 22:06:34', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2036, '智能搜索', 0, 1, 'intelligent-search', NULL, NULL, '', 1, 0, 'M', '0', '0', 'system:msds:search', 'search', 'admin', '2025-11-05 09:30:12', 'admin', '2025-11-05 13:29:18', 'MSDS智能搜索功能');
INSERT INTO `sys_menu` VALUES (2042, '智能搜索', 2036, 1, 'index', 'Msds/IntelligentSearch', NULL, '', 1, 0, 'C', '1', '0', 'system:msds:search', 'search', 'admin', '2025-11-05 12:57:34', 'admin', '2025-11-05 13:38:52', '搜索页面');
INSERT INTO `sys_menu` VALUES (2043, '数据分析', 2000, 2, 'analytics', 'Analytics/DataReport', NULL, '', 1, 0, 'C', '0', '0', 'system:analytics:view', 'bar-chart', 'admin', '2025-11-06 04:05:54', '', NULL, '数据分析报告页面');
INSERT INTO `sys_menu` VALUES (2044, '基础统计', 2043, 1, '#', NULL, NULL, '', 1, 0, 'F', '0', '0', 'system:analytics:summary', '#', 'admin', '2025-11-06 04:05:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2045, '访问趋势', 2043, 2, '#', NULL, NULL, '', 1, 0, 'F', '0', '0', 'system:analytics:trend', '#', 'admin', '2025-11-06 04:05:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2046, '分类分布', 2043, 3, '#', NULL, NULL, '', 1, 0, 'F', '0', '0', 'system:analytics:category', '#', 'admin', '2025-11-06 04:05:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2047, '危险等级', 2043, 4, '#', NULL, NULL, '', 1, 0, 'F', '0', '0', 'system:analytics:hazard', '#', 'admin', '2025-11-06 04:05:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2048, '热门排行', 2043, 5, '#', NULL, NULL, '', 1, 0, 'F', '0', '0', 'system:analytics:ranking', '#', 'admin', '2025-11-06 04:05:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2049, '月度统计', 2043, 6, '#', NULL, NULL, '', 1, 0, 'F', '0', '0', 'system:analytics:monthly', '#', 'admin', '2025-11-06 04:05:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2050, '用户活跃度', 2043, 7, '#', NULL, NULL, '', 1, 0, 'F', '0', '0', 'system:analytics:users', '#', 'admin', '2025-11-06 04:05:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2051, '导出报告', 2043, 8, '#', NULL, NULL, '', 1, 0, 'F', '0', '0', 'system:analytics:export', '#', 'admin', '2025-11-06 04:05:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2053, '工作流看板', 2052, 1, 'workflow/board', 'Workflow/index', NULL, '', 1, 0, 'C', '0', '0', 'system:workflow:list', 'dashboard', 'admin', '2025-11-07 01:29:34', '', NULL, '协作工作流看板页面');
INSERT INTO `sys_menu` VALUES (2054, '工作流查询', 2053, 1, '#', NULL, NULL, '', 1, 0, 'F', '0', '0', 'system:workflow:query', '#', 'admin', '2025-11-07 01:29:34', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2055, '工作流新增', 2053, 2, '#', NULL, NULL, '', 1, 0, 'F', '0', '0', 'system:workflow:add', '#', 'admin', '2025-11-07 01:29:34', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2056, '工作流修改', 2053, 3, '#', NULL, NULL, '', 1, 0, 'F', '0', '0', 'system:workflow:edit', '#', 'admin', '2025-11-07 01:29:34', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2057, '工作流删除', 2053, 4, '#', NULL, NULL, '', 1, 0, 'F', '0', '0', 'system:workflow:remove', '#', 'admin', '2025-11-07 01:29:34', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2058, '协作工作流', 0, 3, 'workflow', NULL, NULL, '', 1, 0, 'M', '0', '0', '', 'team', 'admin', '2025-11-07 02:11:05', '', NULL, '协作工作流管理菜单');
INSERT INTO `sys_menu` VALUES (2059, '工作流看板', 2058, 1, 'board', 'Workflow/index', NULL, '', 1, 0, 'C', '0', '0', 'system:workflow:list', 'dashboard', 'admin', '2025-11-07 02:11:05', '', NULL, '协作工作流看板页面');
INSERT INTO `sys_menu` VALUES (2060, '工作流查询', 2059, 1, '#', NULL, NULL, '', 1, 0, 'F', '0', '0', 'system:workflow:query', '#', 'admin', '2025-11-07 02:11:05', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2061, '工作流新增', 2059, 2, '#', NULL, NULL, '', 1, 0, 'F', '0', '0', 'system:workflow:add', '#', 'admin', '2025-11-07 02:11:05', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2062, '工作流修改', 2059, 3, '#', NULL, NULL, '', 1, 0, 'F', '0', '0', 'system:workflow:edit', '#', 'admin', '2025-11-07 02:11:05', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2063, '工作流删除', 2059, 4, '#', NULL, NULL, '', 1, 0, 'F', '0', '0', 'system:workflow:remove', '#', 'admin', '2025-11-07 02:11:05', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2064, '常见问题', 6, 100, 'faq', 'Msds/Faq', NULL, '', 1, 0, 'C', '0', '0', 'system:faq:list', 'question', 'admin', '2025-12-03 08:52:42', 'admin', '2025-12-04 07:41:04', '常见问题管理菜单');
INSERT INTO `sys_menu` VALUES (2065, '意见反馈', 6, 101, 'feedback', 'Msds/Feedback', NULL, '', 1, 0, 'C', '0', '0', 'system:feedback:list', 'message', 'admin', '2025-12-03 08:52:42', 'admin', '2025-12-04 07:41:15', '意见反馈管理菜单');
INSERT INTO `sys_menu` VALUES (2066, '关于我们', 6, 102, 'about', 'Msds/About', NULL, '', 1, 0, 'C', '0', '0', 'system:about:list', 'info', 'admin', '2025-12-03 08:52:42', 'admin', '2025-12-04 07:41:21', '关于我们管理菜单');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '通知公告表' ROW_FORMAT = Dynamic;

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
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 496 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '操作日志记录' ROW_FORMAT = Dynamic;

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
INSERT INTO `sys_oper_log` VALUES (421, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.4', '内网IP', '{\"children\":[],\"icon\":\"AppstoreOutlined\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":5,\"menuName\":\"控制台\",\"menuType\":\"M\",\"orderNum\":0,\"params\":{},\"parentId\":0,\"path\":\"dashboard\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 02:03:28', 46);
INSERT INTO `sys_oper_log` VALUES (422, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.4', '内网IP', '{\"children\":[],\"icon\":\"LinkOutlined\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":4,\"menuName\":\"若依官网\",\"menuType\":\"M\",\"orderNum\":100,\"params\":{},\"parentId\":0,\"path\":\"http://ruoyi.vip\",\"perms\":\"\",\"query\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 02:03:46', 13);
INSERT INTO `sys_oper_log` VALUES (423, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.4', '内网IP', '{\"children\":[],\"icon\":\"LinkOutlined\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":4,\"menuName\":\"若依官网\",\"menuType\":\"M\",\"orderNum\":100,\"params\":{},\"parentId\":0,\"path\":\"http://ruoyi.vip\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 02:03:51', 13);
INSERT INTO `sys_oper_log` VALUES (424, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '172.19.0.5', '内网IP', '{\"tables\":\"msds_search_history\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 08:38:13', 189);
INSERT INTO `sys_oper_log` VALUES (425, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '172.19.0.5', '内网IP', '{\"tables\":\"msds_search_history\"}', NULL, 0, NULL, '2025-11-05 08:38:20', 648);
INSERT INTO `sys_oper_log` VALUES (426, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.5', '内网IP', '{\"children\":[],\"component\":\"Msds/IntelligentSearch\",\"icon\":\"search\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2014,\"menuName\":\"智能搜索\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"search\",\"perms\":\"system:msds:search\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 08:45:33', 26);
INSERT INTO `sys_oper_log` VALUES (427, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.5', '内网IP', '{\"children\":[],\"component\":\"Msds/Detail\",\"icon\":\"eye\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2015,\"menuName\":\"MSDS详情\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"detail/:id\",\"perms\":\"system:msds:detail\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 08:45:59', 17);
INSERT INTO `sys_oper_log` VALUES (428, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.5', '内网IP', '{\"children\":[],\"icon\":\"FileTextOutlined\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"MSDS管理\",\"menuType\":\"M\",\"orderNum\":6,\"params\":{},\"parentId\":0,\"path\":\"msds\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 08:46:15', 17);
INSERT INTO `sys_oper_log` VALUES (429, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.5', '内网IP', '{\"children\":[],\"icon\":\"SettingOutlined\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1,\"menuName\":\"系统管理\",\"menuType\":\"M\",\"orderNum\":50,\"params\":{},\"parentId\":0,\"path\":\"system\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 08:51:34', 13);
INSERT INTO `sys_oper_log` VALUES (430, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.5', '内网IP', '{\"children\":[],\"component\":\"Msds/IntelligentSearch\",\"icon\":\"search\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2017,\"menuName\":\"智能搜索\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"search\",\"perms\":\"system:msds:search\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 08:52:03', 19);
INSERT INTO `sys_oper_log` VALUES (431, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.5', '内网IP', '{\"children\":[],\"component\":\"Msds/Detail\",\"icon\":\"eye\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2018,\"menuName\":\"MSDS详情\",\"menuType\":\"C\",\"orderNum\":8,\"params\":{},\"parentId\":0,\"path\":\"detail/:id\",\"perms\":\"system:msds:detail\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 08:53:43', 15);
INSERT INTO `sys_oper_log` VALUES (432, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.5', '内网IP', '{\"children\":[],\"component\":\"Msds/index\",\"icon\":\"form\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2019,\"menuName\":\"MSDS文档\",\"menuType\":\"C\",\"orderNum\":8,\"params\":{},\"parentId\":0,\"path\":\"main\",\"perms\":\"system:msds:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 08:57:02', 11);
INSERT INTO `sys_oper_log` VALUES (433, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.5', '内网IP', '{\"children\":[],\"component\":\"Msds/Detail\",\"icon\":\"eye\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2025,\"menuName\":\"MSDS详情\",\"menuType\":\"C\",\"orderNum\":8,\"params\":{},\"parentId\":0,\"path\":\"detail/:id\",\"perms\":\"system:msds:detail\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 09:17:56', 19);
INSERT INTO `sys_oper_log` VALUES (434, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.5', '内网IP', '{\"children\":[],\"component\":\"Msds/Detail\",\"icon\":\"eye\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2028,\"menuName\":\"MSDS详情\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":0,\"path\":\"detail/:id\",\"perms\":\"system:msds:detail\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 09:22:18', 13);
INSERT INTO `sys_oper_log` VALUES (435, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.5', '内网IP', '{\"children\":[],\"component\":\"Msds/IntelligentSearch\",\"icon\":\"search\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2027,\"menuName\":\"智能搜索\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"/msds/search\",\"perms\":\"system:msds:search\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 09:23:30', 12);
INSERT INTO `sys_oper_log` VALUES (436, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2031', '172.19.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 09:25:13', 30);
INSERT INTO `sys_oper_log` VALUES (437, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.5', '内网IP', '{\"children\":[],\"component\":\"Msds/IntelligentSearch\",\"icon\":\"search\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2030,\"menuName\":\"智能搜索\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":0,\"path\":\"/msds/search\",\"perms\":\"system:msds:search\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 09:25:39', 14);
INSERT INTO `sys_oper_log` VALUES (438, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.5', '内网IP', '{\"children\":[],\"component\":\"Msds/IntelligentSearch\",\"icon\":\"search\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2036,\"menuName\":\"智能搜索\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":0,\"path\":\"/msds/search\",\"perms\":\"system:msds:search\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 09:30:54', 18);
INSERT INTO `sys_oper_log` VALUES (439, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.4', '内网IP', '{\"children\":[],\"component\":\"Msds/IntelligentSearch\",\"icon\":\"search\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2036,\"menuName\":\"智能搜索\",\"menuType\":\"M\",\"orderNum\":5,\"params\":{},\"parentId\":2000,\"path\":\"search\",\"perms\":\"system:msds:search\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 12:41:40', 40);
INSERT INTO `sys_oper_log` VALUES (440, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.4', '内网IP', '{\"children\":[],\"icon\":\"search\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2036,\"menuName\":\"智能搜索\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"intelligent-search\",\"perms\":\"system:msds:search\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 12:52:38', 16);
INSERT INTO `sys_oper_log` VALUES (441, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.4', '内网IP', '{\"children\":[],\"component\":\"Msds/IntelligentSearch\",\"icon\":\"search\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2042,\"menuName\":\"智能搜索\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2036,\"path\":\"index\",\"perms\":\"system:msds:search\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 13:09:05', 15);
INSERT INTO `sys_oper_log` VALUES (442, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.4', '内网IP', '{\"children\":[],\"component\":\"Msds/index\",\"icon\":\"form\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2038,\"menuName\":\"MSDS文档\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2000,\"path\":\"main\",\"perms\":\"system:msds:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 13:09:25', 14);
INSERT INTO `sys_oper_log` VALUES (443, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.4', '内网IP', '{\"children\":[],\"component\":\"Msds/IntelligentSearch\",\"icon\":\"search\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2042,\"menuName\":\"智能搜索\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2036,\"path\":\"/intelligent-search/index\",\"perms\":\"system:msds:search\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 13:18:09', 14);
INSERT INTO `sys_oper_log` VALUES (444, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.4', '内网IP', '{\"children\":[],\"component\":\"Msds/IntelligentSearch\",\"icon\":\"search\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2042,\"menuName\":\"智能搜索\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2036,\"path\":\"/intelligent-search\",\"perms\":\"system:msds:search\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 13:25:07', 46);
INSERT INTO `sys_oper_log` VALUES (445, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.4', '内网IP', '{\"children\":[],\"icon\":\"search\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2036,\"menuName\":\"智能搜索\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":0,\"path\":\"intelligent-search\",\"perms\":\"system:msds:search\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 13:29:18', 37);
INSERT INTO `sys_oper_log` VALUES (446, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.4', '内网IP', '{\"children\":[],\"component\":\"Msds/IntelligentSearch\",\"icon\":\"search\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2042,\"menuName\":\"智能搜索\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2036,\"path\":\"index\",\"perms\":\"system:msds:search\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 13:29:53', 17);
INSERT INTO `sys_oper_log` VALUES (447, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.4', '内网IP', '{\"children\":[],\"component\":\"Msds/IntelligentSearch\",\"icon\":\"search\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2042,\"menuName\":\"智能搜索\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2036,\"path\":\"index\",\"perms\":\"system:msds:search\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 13:38:52', 17);
INSERT INTO `sys_oper_log` VALUES (448, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.4', '内网IP', '{\"children\":[],\"component\":\"msds/main/index\",\"icon\":\"file-text\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"MSDS信息\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"/msds/main\",\"perms\":\"system:msds:list\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 13:39:14', 13);
INSERT INTO `sys_oper_log` VALUES (449, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.4', '内网IP', '{\"children\":[],\"component\":\"msds/main/index\",\"icon\":\"file-text\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"MSDS信息\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"/main\",\"perms\":\"system:msds:list\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 13:40:04', 15);
INSERT INTO `sys_oper_log` VALUES (450, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.4', '内网IP', '{\"children\":[],\"component\":\"msds/main/index\",\"icon\":\"file-text\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"MSDS信息\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"/main\",\"perms\":\"system:msds:list\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 13:41:10', 18);
INSERT INTO `sys_oper_log` VALUES (451, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.4', '内网IP', '{\"children\":[],\"component\":\"msds/main/index\",\"icon\":\"file-text\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"MSDS信息\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"/msds/main\",\"perms\":\"system:msds:list\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-05 13:42:28', 15);
INSERT INTO `sys_oper_log` VALUES (452, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/1', '172.19.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-11-06 03:26:09', 107);
INSERT INTO `sys_oper_log` VALUES (453, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/168', '172.19.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-01 14:06:06', 112);
INSERT INTO `sys_oper_log` VALUES (454, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/167', '172.19.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-01 14:06:08', 18);
INSERT INTO `sys_oper_log` VALUES (455, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/166', '172.19.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-01 14:06:10', 21);
INSERT INTO `sys_oper_log` VALUES (456, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/165', '172.19.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-01 14:06:13', 14);
INSERT INTO `sys_oper_log` VALUES (457, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.19.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"1,1-二-(叔丁基过氧)-3,3,5-三甲基环己烷[含量≤57%,含惰性固体≥43%] (CAS: 6731-36-8)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-12-01 14:13:27', 479);
INSERT INTO `sys_oper_log` VALUES (458, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.19.0.5', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1R,2R,4R)-冰片-2-硫氰基醋酸酯 (CAS: 115-31-1)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-12-01 14:19:30', 294);
INSERT INTO `sys_oper_log` VALUES (459, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'admin', '研发部门', '/system/user/profile/avatar', '172.19.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2025/12/02/8uHLYYrT86Mdb1a5d83565389211bab00eebed99c462_20251202143028A001.png\",\"code\":200}', 0, NULL, '2025-12-02 14:30:28', 521);
INSERT INTO `sys_oper_log` VALUES (460, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.19.0.3', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-12-03 01:26:06', 203);
INSERT INTO `sys_oper_log` VALUES (461, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.19.0.3', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[],\"successList\":[\"(1R,4S,4aS,5R,6R,7S,8S,8aR)-1,2,3,4,10,10-六氯-1,4,4a,5,6,7,8,8a-八氢-6,7-环氧-1,4,5,8-二亚甲基萘[含量2%～90%] (CAS: 60-57-1)\"],\"duplicateCount\":0,\"successCount\":1,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":0}}', 0, NULL, '2025-12-03 01:26:37', 96);
INSERT INTO `sys_oper_log` VALUES (462, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.19.0.3', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[\"第1条记录: \\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'无资料\' for key \'msds_main.msds_code\'\\n### The error may exist in URL [jar:nested:/app/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/MsdsMainMapper.xml]\\n### The error may involve com.ruoyi.system.mapper.MsdsMainMapper.insertMsdsMain-Inline\\n### The error occurred while setting parameters\\n### SQL: insert into msds_main (             cas_number, msds_code, product_name, product_alias, product_english_name,              category_id, company_name, company_address, zip_code, fax_number,              contact_phone, email, emergency_phone, recommended_usage, restricted_usage,              version, revision_date, effective_date, status, approver, approval_date,             is_active, remark         )values(             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?,             ?, ?, ?, ?, ?, ?,             ?, ?         )\\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'无资料\' for key \'msds_main.msds_code\'\\n; Duplicate entry \'无资料\' for key \'msds_main.msds_code\'\"],\"successList\":[],\"duplicateCount\":0,\"successCount\":0,\"duplicateList\":[],\"totalCount\":1,\"failureCount\":1}}', 0, NULL, '2025-12-03 01:26:53', 34);
INSERT INTO `sys_oper_log` VALUES (463, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'admin', '研发部门', '/system/user/profile', '172.19.0.1', '内网IP', '{\"admin\":true,\"avatar\":\"/profile/avatar/2025/12/02/8uHLYYrT86Mdb1a5d83565389211bab00eebed99c462_20251202143028A001.png\",\"createBy\":\"admin\",\"createTime\":\"2025-10-23 06:48:41\",\"delFlag\":\"0\",\"dept\":{\"ancestors\":\"0,100,101\",\"children\":[],\"deptId\":103,\"deptName\":\"研发部门\",\"leader\":\"若依\",\"orderNum\":1,\"params\":{\"@type\":\"java.util.HashMap\"},\"parentId\":101,\"status\":\"0\"},\"deptId\":103,\"email\":\"xyf@163.com\",\"loginDate\":\"2025-12-04 01:12:40\",\"loginIp\":\"172.19.0.1\",\"nickName\":\"xyadmin\",\"params\":{\"@type\":\"java.util.HashMap\"},\"phonenumber\":\"15888888888\",\"remark\":\"管理员\",\"roles\":[{\"admin\":true,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{\"@type\":\"java.util.HashMap\"},\"roleId\":1,\"roleKey\":\"admin\",\"roleName\":\"超级管理员\",\"roleSort\":1,\"status\":\"0\"}],\"sex\":\"1\",\"status\":\"0\",\"userId\":1,\"userName\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-04 01:16:47', 41);
INSERT INTO `sys_oper_log` VALUES (464, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.5', '内网IP', '{\"children\":[],\"icon\":\"ProfileOutlined\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":6,\"menuName\":\"个人\",\"menuType\":\"M\",\"orderNum\":6,\"params\":{},\"parentId\":0,\"path\":\"account\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-04 01:38:05', 41);
INSERT INTO `sys_oper_log` VALUES (465, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.5', '内网IP', '{\"children\":[],\"icon\":\"ProfileOutlined\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":6,\"menuName\":\"个人\",\"menuType\":\"M\",\"orderNum\":46,\"params\":{},\"parentId\":0,\"path\":\"account\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-04 01:38:25', 15);
INSERT INTO `sys_oper_log` VALUES (466, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.5', '内网IP', '{\"children\":[],\"icon\":\"ProfileOutlined\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":6,\"menuName\":\"用户协作\",\"menuType\":\"M\",\"orderNum\":46,\"params\":{},\"parentId\":0,\"path\":\"account\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-04 01:38:42', 13);
INSERT INTO `sys_oper_log` VALUES (467, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.5', '内网IP', '{\"children\":[],\"component\":\"Msds/Faq\",\"icon\":\"question\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2064,\"menuName\":\"常见问题管理\",\"menuType\":\"C\",\"orderNum\":100,\"params\":{},\"parentId\":6,\"path\":\"faq\",\"perms\":\"system:faq:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-04 01:39:29', 13);
INSERT INTO `sys_oper_log` VALUES (468, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.5', '内网IP', '{\"children\":[],\"component\":\"Msds/Feedback\",\"icon\":\"message\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2065,\"menuName\":\"意见反馈管理\",\"menuType\":\"C\",\"orderNum\":101,\"params\":{},\"parentId\":6,\"path\":\"feedback\",\"perms\":\"system:feedback:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-04 01:39:40', 13);
INSERT INTO `sys_oper_log` VALUES (469, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.5', '内网IP', '{\"children\":[],\"component\":\"Msds/About\",\"icon\":\"info\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2066,\"menuName\":\"关于我们管理\",\"menuType\":\"C\",\"orderNum\":102,\"params\":{},\"parentId\":6,\"path\":\"about\",\"perms\":\"system:about:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-04 01:39:59', 16);
INSERT INTO `sys_oper_log` VALUES (470, '常见问题', 2, 'com.ruoyi.web.controller.system.MsdsFaqController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/faq', '172.19.0.5', '内网IP', '{\"answer\":\"现在免费支持使用\",\"id\":1,\"params\":{},\"question\":\"请问现在系统支持试用吗？\",\"sortOrder\":5,\"status\":\"0\",\"updateBy\":\"admin\",\"updateTime\":\"2025-12-04 02:04:05\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-04 02:04:05', 94);
INSERT INTO `sys_oper_log` VALUES (471, '常见问题', 2, 'com.ruoyi.web.controller.system.MsdsFaqController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/faq', '172.19.0.5', '内网IP', '{\"answer\":\"可以的我们有经销商渠道请跟和我联系并获取。\",\"id\":2,\"params\":{},\"question\":\"请问可以商用吗？\",\"sortOrder\":0,\"status\":\"0\",\"updateBy\":\"admin\",\"updateTime\":\"2025-12-04 02:04:49\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-04 02:04:49', 17);
INSERT INTO `sys_oper_log` VALUES (472, '常见问题', 3, 'com.ruoyi.web.controller.system.MsdsFaqController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/faq/3', '172.19.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-04 02:04:52', 27);
INSERT INTO `sys_oper_log` VALUES (473, '常见问题', 3, 'com.ruoyi.web.controller.system.MsdsFaqController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/faq/4', '172.19.0.5', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-04 02:05:00', 14);
INSERT INTO `sys_oper_log` VALUES (474, '关于我们', 2, 'com.ruoyi.web.controller.system.MsdsAboutUsController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/about', '172.19.0.5', '内网IP', '{\"content\":\"MSDS实验室管理系统...\",\"id\":1,\"params\":{},\"status\":\"0\",\"title\":\"关于我们有这样的系统说明\",\"type\":\"about\",\"updateBy\":\"admin\",\"updateTime\":\"2025-12-04 04:08:30\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-04 04:08:30', 46);
INSERT INTO `sys_oper_log` VALUES (475, '意见反馈', 1, 'com.ruoyi.web.controller.system.MsdsFeedbackController.appAdd()', 'POST', 1, 'admin', '研发部门', '/system/feedback/app/add', '172.19.0.1', '内网IP', '{\"contactInfo\":\"1809766557\",\"content\":\"系统出现了文档内容解析不够详细问题\",\"createBy\":\"admin\",\"createTime\":\"2025-12-04 04:22:23\",\"feedbackType\":\"功能建议\",\"images\":\"http://192.168.0.101:18080/profile/upload/2025/12/04/4-kq1KBvZcR_6a4248fa203a02fad33f23e1373a7dc0_20251204042221A001.JPG\",\"params\":{}}', NULL, 1, '\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'feedback_type\' in \'field list\'\n### The error may exist in URL [jar:nested:/app/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/MsdsFeedbackMapper.xml]\n### The error may involve com.ruoyi.system.mapper.MsdsFeedbackMapper.insertMsdsFeedback-Inline\n### The error occurred while setting parameters\n### SQL: insert into msds_feedback          ( feedback_type,             content,             contact_info,             images,                                                                 create_by,             create_time )           values ( ?,             ?,             ?,             ?,                                                                 ?,             ? )\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'feedback_type\' in \'field list\'\n; bad SQL grammar []', '2025-12-04 04:22:23', 38);
INSERT INTO `sys_oper_log` VALUES (476, '意见反馈', 1, 'com.ruoyi.web.controller.system.MsdsFeedbackController.appAdd()', 'POST', 1, 'admin', '研发部门', '/system/feedback/app/add', '172.19.0.1', '内网IP', '{\"contactInfo\":\"1809766557\",\"content\":\"系统出现了文档内容解析不够详细问题\",\"createBy\":\"admin\",\"createTime\":\"2025-12-04 04:22:29\",\"feedbackType\":\"功能建议\",\"images\":\"http://192.168.0.101:18080/profile/upload/2025/12/04/4-kq1KBvZcR_6a4248fa203a02fad33f23e1373a7dc0_20251204042221A001.JPG\",\"params\":{}}', NULL, 1, '\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'feedback_type\' in \'field list\'\n### The error may exist in URL [jar:nested:/app/ruoyi-admin/target/ruoyi-admin.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/MsdsFeedbackMapper.xml]\n### The error may involve com.ruoyi.system.mapper.MsdsFeedbackMapper.insertMsdsFeedback-Inline\n### The error occurred while setting parameters\n### SQL: insert into msds_feedback          ( feedback_type,             content,             contact_info,             images,                                                                 create_by,             create_time )           values ( ?,             ?,             ?,             ?,                                                                 ?,             ? )\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'feedback_type\' in \'field list\'\n; bad SQL grammar []', '2025-12-04 04:22:29', 5);
INSERT INTO `sys_oper_log` VALUES (477, '意见反馈', 1, 'com.ruoyi.web.controller.system.MsdsFeedbackController.appAdd()', 'POST', 1, 'admin', '研发部门', '/system/feedback/app/add', '172.19.0.1', '内网IP', '{\"contactInfo\":\"1809766557\",\"content\":\"系统出现了文档内容解析不够详细问题\",\"createBy\":\"admin\",\"createTime\":\"2025-12-04 04:28:13\",\"feedbackType\":\"功能建议\",\"id\":1,\"images\":\"http://192.168.0.101:18080/profile/upload/2025/12/04/4-kq1KBvZcR_6a4248fa203a02fad33f23e1373a7dc0_20251204042221A001.JPG\",\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-04 04:28:13', 27);
INSERT INTO `sys_oper_log` VALUES (478, '意见反馈', 1, 'com.ruoyi.web.controller.system.MsdsFeedbackController.appAdd()', 'POST', 1, 'admin', '研发部门', '/system/feedback/app/add', '172.19.0.1', '内网IP', '{\"contactInfo\":\"122333445666\",\"content\":\"这个是我的一个测试发布\",\"createBy\":\"admin\",\"createTime\":\"2025-12-04 06:04:33\",\"feedbackType\":\"功能建议\",\"id\":2,\"images\":\"http://192.168.0.101:18080/profile/upload/2025/12/04/TkIL6A4WVcIqf41782266820cf3a0fe9da0f668a670c_20251204060431A001.JPG\",\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-04 06:04:33', 39);
INSERT INTO `sys_oper_log` VALUES (479, '意见反馈', 1, 'com.ruoyi.web.controller.system.MsdsFeedbackController.appAdd()', 'POST', 1, 'admin', '研发部门', '/system/feedback/app/add', '172.19.0.1', '内网IP', '{\"contactInfo\":\"1334456789987\",\"content\":\"提交基金那就好好\",\"createBy\":\"admin\",\"createTime\":\"2025-12-04 06:06:45\",\"feedbackType\":\"功能建议\",\"id\":3,\"images\":\"http://192.168.0.101:18080/profile/upload/2025/12/04/LELO8ufCaq8215c7b55ebaa0a141c7239370f67d0f73_20251204060639A002.JPG\",\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-04 06:06:45', 11);
INSERT INTO `sys_oper_log` VALUES (480, '意见反馈', 1, 'com.ruoyi.web.controller.system.MsdsFeedbackController.appAdd()', 'POST', 1, 'admin', '研发部门', '/system/feedback/app/add', '172.19.0.1', '内网IP', '{\"contactInfo\":\"\",\"content\":\"这个是一个测试反馈项目\",\"createBy\":\"admin\",\"createTime\":\"2025-12-04 07:06:52\",\"feedbackType\":\"功能建议\",\"id\":4,\"images\":\"http://192.168.0.101:18080/profile/upload/2025/12/04/hInyUQQJjOhO15c7b55ebaa0a141c7239370f67d0f73_20251204070651A001.JPG\",\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-04 07:06:52', 55);
INSERT INTO `sys_oper_log` VALUES (481, '意见反馈', 1, 'com.ruoyi.web.controller.system.MsdsFeedbackController.appAdd()', 'POST', 1, 'admin', '研发部门', '/system/feedback/app/add', '172.19.0.1', '内网IP', '{\"contactInfo\":\"\",\"content\":\"测试意见反馈，使用的时候数据错误。\",\"createBy\":\"admin\",\"createTime\":\"2025-12-04 07:18:45\",\"feedbackType\":\"性能问题\",\"id\":5,\"images\":\"http://192.168.0.101:18080/profile/upload/2025/12/04/14HgEr2pinNF307c032a98049434f4753601abb073b5_20251204071836A002.JPG\",\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-04 07:18:45', 18);
INSERT INTO `sys_oper_log` VALUES (482, '意见反馈', 1, 'com.ruoyi.web.controller.system.MsdsFeedbackController.appAdd()', 'POST', 1, 'admin', '研发部门', '/system/feedback/app/add', '172.19.0.1', '内网IP', '{\"contactInfo\":\"\",\"content\":\"咳咳咳，数据不通哦啊\",\"createBy\":\"admin\",\"createTime\":\"2025-12-04 07:19:33\",\"feedbackType\":\"其他\",\"id\":6,\"images\":\"http://192.168.0.101:18080/profile/upload/2025/12/04/Ow1JsMK17L1U1e0b9500d9a9aeaf8ba75788b7496f91_20251204071929A003.JPG\",\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-04 07:19:33', 29);
INSERT INTO `sys_oper_log` VALUES (483, '意见反馈', 1, 'com.ruoyi.web.controller.system.MsdsFeedbackController.appAdd()', 'POST', 1, 'admin', '研发部门', '/system/feedback/app/add', '172.19.0.1', '内网IP', '{\"contactInfo\":\"\",\"content\":\"这个是测试发布的内容跟\",\"createBy\":\"admin\",\"createTime\":\"2025-12-04 07:35:09\",\"feedbackType\":\"功能建议\",\"id\":7,\"images\":\"http://192.168.0.101:18080/profile/upload/2025/12/04/SzoEiE5QP1u548730d89822d8423d30782827a7b44d9_20251204073507A004.png\",\"params\":{}}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-04 07:35:09', 14);
INSERT INTO `sys_oper_log` VALUES (484, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.5', '内网IP', '{\"children\":[],\"component\":\"Msds/Faq\",\"icon\":\"question\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2064,\"menuName\":\"常见问题\",\"menuType\":\"C\",\"orderNum\":100,\"params\":{},\"parentId\":6,\"path\":\"faq\",\"perms\":\"system:faq:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-04 07:41:04', 56);
INSERT INTO `sys_oper_log` VALUES (485, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.5', '内网IP', '{\"children\":[],\"component\":\"Msds/Feedback\",\"icon\":\"message\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2065,\"menuName\":\"意见反馈\",\"menuType\":\"C\",\"orderNum\":101,\"params\":{},\"parentId\":6,\"path\":\"feedback\",\"perms\":\"system:feedback:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-04 07:41:15', 23);
INSERT INTO `sys_oper_log` VALUES (486, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.5', '内网IP', '{\"children\":[],\"component\":\"Msds/About\",\"icon\":\"info\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2066,\"menuName\":\"关于我们\",\"menuType\":\"C\",\"orderNum\":102,\"params\":{},\"parentId\":6,\"path\":\"about\",\"perms\":\"system:about:list\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-12-04 07:41:21', 17);
INSERT INTO `sys_oper_log` VALUES (487, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/4', '172.19.0.5', '内网IP', '{}', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2026-02-13 15:20:55', 198);
INSERT INTO `sys_oper_log` VALUES (488, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.5', '内网IP', '{\"children\":[],\"icon\":\"LinkOutlined\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":4,\"menuName\":\"公司官网\",\"menuType\":\"M\",\"orderNum\":100,\"params\":{},\"parentId\":0,\"path\":\"jfkj.com\",\"perms\":\"\",\"query\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-13 15:21:51', 86);
INSERT INTO `sys_oper_log` VALUES (489, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.5', '内网IP', '{\"children\":[],\"icon\":\"LinkOutlined\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":4,\"menuName\":\"公司官网\",\"menuType\":\"M\",\"orderNum\":100,\"params\":{},\"parentId\":0,\"path\":\"jfkj.com\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-13 15:21:51', 84);
INSERT INTO `sys_oper_log` VALUES (490, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '172.19.0.5', '内网IP', '{\"children\":[],\"icon\":\"LinkOutlined\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":4,\"menuName\":\"公司官网\",\"menuType\":\"M\",\"orderNum\":100,\"params\":{},\"parentId\":0,\"path\":\"jfkj.com\",\"perms\":\"\",\"query\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-13 15:22:16', 74);
INSERT INTO `sys_oper_log` VALUES (491, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/169', '172.19.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-25 05:39:35', 202);
INSERT INTO `sys_oper_log` VALUES (492, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/170', '172.19.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-25 05:39:38', 27);
INSERT INTO `sys_oper_log` VALUES (493, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/171', '172.19.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-25 05:39:41', 229);
INSERT INTO `sys_oper_log` VALUES (494, 'MSDS主信息', 3, 'com.ruoyi.web.controller.system.MsdsMainController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/msds/172', '172.19.0.4', '内网IP', '{}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-25 05:39:44', 28);
INSERT INTO `sys_oper_log` VALUES (495, 'MSDS XML导入', 6, 'com.ruoyi.web.controller.system.MsdsMainController.importXml()', 'POST', 1, 'admin', '研发部门', '/system/msds/importXml', '172.19.0.3', '内网IP', '{\"overwriteDuplicates\":\"false\"}', '{\"msg\":\"操作成功\",\"code\":200,\"data\":{\"failureList\":[\"(E)-O,O-二甲基-O-[1-甲基-2-(1-苯基-乙氧基甲酰)乙烯基]磷酸酯、1-phenylethyl 3-(dimethoxyphosphinyloxy)isocrotonate powder、7700-17-6.xml: XML document structures must start and end within the same entity.\",\"(RS)-2-[4-(5-三氟甲基-2-吡啶氧基)苯氧基]丙酸丁酯、butyl 2-[4-[[5-(trifluoromethyl)-2-pyridyl]oxy]phenoxy]propionate、69806-50-4.xml: Content is not allowed in trailing section.\",\"(S)-3-(1-甲基吡咯烷-2-基)吡啶、Nicotine、54-11-5.xml: The element type \\\"packing_group\\\" must be terminated by the matching end-tag \\\"</packing_group>\\\".\"],\"successList\":[\"(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 (CAS: 115-29-7)\",\"(1R,2R,4R)-冰片-2-硫氰基醋酸酯 (CAS: 115-31-1)\",\"(1R,4S,4aS,5R,6R,7S,8S,8aR)-1,2,3,4,10,10-六氯-1,4,4a,5,6,7,8,8a-八氢-6,7-环氧-1,4,5,8-二亚甲基萘[含量2%～90%] (CAS: 60-57-1)\",\"(1R,4S,5R,8S)-1,2,3,4,10,10-六氯-1,4,4a,5,6,7,8,8a-八氢-6,7-环氧-1,4,5,8-二亚甲基萘[含量＞5%] (CAS: 72-20-8)\",\"(2-氨基甲酰氧乙基)三甲基氯化铵 (CAS: 51-83-2)\",\"(E)-O,O-二甲基-O-[1-甲基-2-(二甲基氨基甲酰)乙烯基]磷酸酯[含量＞25%] (CAS: 141-66-2)\",\"(RS)-α-氰基-3-苯氧基苄基(SR)-3-(2,2-二氯乙烯基)-2,2-二甲基环丙烷羧酸酯 (CAS: 52315-07-8)\"],\"duplicateCount\":0,\"successCount\":7,\"duplicateList\":[],\"totalCount\":7,\"failureCount\":3}}', 0, NULL, '2026-02-25 15:32:49', 3261);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '岗位信息表' ROW_FORMAT = Dynamic;

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
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

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
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
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
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
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
INSERT INTO `sys_role_menu` VALUES (1, 2043);
INSERT INTO `sys_role_menu` VALUES (1, 2044);
INSERT INTO `sys_role_menu` VALUES (1, 2045);
INSERT INTO `sys_role_menu` VALUES (1, 2046);
INSERT INTO `sys_role_menu` VALUES (1, 2047);
INSERT INTO `sys_role_menu` VALUES (1, 2048);
INSERT INTO `sys_role_menu` VALUES (1, 2049);
INSERT INTO `sys_role_menu` VALUES (1, 2050);
INSERT INTO `sys_role_menu` VALUES (1, 2051);
INSERT INTO `sys_role_menu` VALUES (1, 2052);
INSERT INTO `sys_role_menu` VALUES (1, 2053);
INSERT INTO `sys_role_menu` VALUES (1, 2054);
INSERT INTO `sys_role_menu` VALUES (1, 2055);
INSERT INTO `sys_role_menu` VALUES (1, 2056);
INSERT INTO `sys_role_menu` VALUES (1, 2057);
INSERT INTO `sys_role_menu` VALUES (1, 2058);
INSERT INTO `sys_role_menu` VALUES (1, 2059);
INSERT INTO `sys_role_menu` VALUES (1, 2060);
INSERT INTO `sys_role_menu` VALUES (1, 2061);
INSERT INTO `sys_role_menu` VALUES (1, 2062);
INSERT INTO `sys_role_menu` VALUES (1, 2063);
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
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
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
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', 'xyadmin', '00', 'xyf@163.com', '15888888888', '1', '/profile/avatar/2025/12/02/8uHLYYrT86Mdb1a5d83565389211bab00eebed99c462_20251202143028A001.png', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '172.19.0.3', '2026-02-25 15:30:06', 'admin', '2025-10-23 14:48:41', '', '2026-02-25 15:30:06', '管理员');
INSERT INTO `sys_user` VALUES (2, 105, 'ry', '若依', '00', 'ry@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2025-10-23 14:48:41', 'admin', '2025-10-23 14:48:41', '', NULL, '测试员');

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
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
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
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
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `table_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '表名',
  `record_id` bigint NOT NULL COMMENT '记录ID',
  `operation_type` enum('INSERT','UPDATE','DELETE') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '操作类型',
  `old_values` json NULL COMMENT '修改前的值',
  `new_values` json NULL COMMENT '修改后的值',
  `operator` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作人',
  `operation_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  `ip_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'IP地址',
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '用户代理',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_table_record`(`table_name` ASC, `record_id` ASC) USING BTREE,
  INDEX `idx_operation_time`(`operation_time` ASC) USING BTREE,
  INDEX `idx_operator`(`operator` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统操作日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_log
-- ----------------------------

-- ----------------------------
-- Table structure for testxumcp
-- ----------------------------
DROP TABLE IF EXISTS `testxumcp`;
CREATE TABLE `testxumcp`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `studen` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学生信息',
  `englig` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '英语相关',
  `user` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户信息',
  `logi` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '逻辑信息',
  `xutest` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '徐测试字段',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态: 1-正常, 0-禁用',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'MCP测试表 - 徐测试' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of testxumcp
-- ----------------------------
INSERT INTO `testxumcp` VALUES (1, '张三', 'English Level 1', 'user001', '登录成功', '这是徐测试的第一个测试数据', '2025-09-28 08:03:06', '2025-09-28 08:03:06', 1);
INSERT INTO `testxumcp` VALUES (2, '李四', 'English Level 2', 'user002', '登录失败', '这是徐测试的第二个测试数据', '2025-09-28 08:03:06', '2025-09-28 08:03:06', 1);
INSERT INTO `testxumcp` VALUES (3, '王五', 'English Level 3', 'user003', '登录超时', '这是徐测试的第三个测试数据', '2025-09-28 08:03:06', '2025-09-28 08:03:06', 1);

-- ----------------------------
-- Table structure for workflow_activity
-- ----------------------------
DROP TABLE IF EXISTS `workflow_activity`;
CREATE TABLE `workflow_activity`  (
  `activity_id` bigint NOT NULL AUTO_INCREMENT COMMENT '活动ID',
  `task_id` bigint NOT NULL COMMENT '任务ID',
  `user_id` bigint NOT NULL COMMENT '操作用户ID',
  `user_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '操作用户姓名',
  `action_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '操作类型：create-创建, assign-分配, status_change-状态变更, comment-评论, approve-通过, reject-拒绝',
  `action_description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作描述',
  `old_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '旧值（用于状态变更）',
  `new_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '新值（用于状态变更）',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`activity_id`) USING BTREE,
  INDEX `idx_task`(`task_id` ASC) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_action_type`(`action_type` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '工作流活动日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of workflow_activity
-- ----------------------------
INSERT INTO `workflow_activity` VALUES (1, 1, 2, '李四', 'create', '创建了新任务：乙醇MSDS文档审核', NULL, NULL, '2025-11-07 01:28:23');
INSERT INTO `workflow_activity` VALUES (2, 1, 2, '李四', 'assign', '将任务分配给张三', NULL, '张三', '2025-11-07 01:28:23');
INSERT INTO `workflow_activity` VALUES (3, 1, 1, '张三', 'comment', '添加了评论', NULL, NULL, '2025-11-07 01:28:23');
INSERT INTO `workflow_activity` VALUES (4, 1, 2, '李四', 'comment', '添加了评论', NULL, NULL, '2025-11-07 01:28:23');
INSERT INTO `workflow_activity` VALUES (5, 4, 2, '李四', 'create', '创建了新任务：异丙醇MSDS技术审核', NULL, NULL, '2025-11-07 01:28:23');
INSERT INTO `workflow_activity` VALUES (6, 4, 1, '张三', 'status_change', '任务状态变更为审核中', 'pending', 'reviewing', '2025-11-07 01:28:23');
INSERT INTO `workflow_activity` VALUES (7, 4, 1, '张三', 'comment', '添加了评论', NULL, NULL, '2025-11-07 01:28:23');
INSERT INTO `workflow_activity` VALUES (8, 6, 2, '李四', 'create', '创建了新任务：氯化钠MSDS审核', NULL, NULL, '2025-11-07 01:28:23');
INSERT INTO `workflow_activity` VALUES (9, 6, 3, '王五', 'status_change', '任务状态变更为已通过', 'reviewing', 'approved', '2025-11-07 01:28:23');
INSERT INTO `workflow_activity` VALUES (10, 6, 3, '王五', 'approve', '审核通过', NULL, NULL, '2025-11-07 01:28:23');
INSERT INTO `workflow_activity` VALUES (11, 8, 2, '李四', 'create', '创建了新任务：汞MSDS文档', NULL, NULL, '2025-11-07 01:28:23');
INSERT INTO `workflow_activity` VALUES (12, 8, 1, '张三', 'status_change', '任务状态变更为已拒绝', 'reviewing', 'rejected', '2025-11-07 01:28:23');
INSERT INTO `workflow_activity` VALUES (13, 8, 1, '张三', 'reject', '拒绝任务', NULL, '急性毒性数据缺失，应急处理措施不够详细', '2025-11-07 01:28:23');

-- ----------------------------
-- Table structure for workflow_attachment
-- ----------------------------
DROP TABLE IF EXISTS `workflow_attachment`;
CREATE TABLE `workflow_attachment`  (
  `attachment_id` bigint NOT NULL AUTO_INCREMENT COMMENT '附件ID',
  `task_id` bigint NOT NULL COMMENT '任务ID',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文件名',
  `file_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文件路径',
  `file_size` bigint NULL DEFAULT NULL COMMENT '文件大小（字节）',
  `file_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文件类型',
  `upload_user_id` bigint NULL DEFAULT NULL COMMENT '上传用户ID',
  `upload_user_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '上传用户姓名',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`attachment_id`) USING BTREE,
  INDEX `idx_task`(`task_id` ASC) USING BTREE,
  INDEX `idx_upload_user`(`upload_user_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '工作流任务附件表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of workflow_attachment
-- ----------------------------

-- ----------------------------
-- Table structure for workflow_comment
-- ----------------------------
DROP TABLE IF EXISTS `workflow_comment`;
CREATE TABLE `workflow_comment`  (
  `comment_id` bigint NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `task_id` bigint NOT NULL COMMENT '任务ID',
  `user_id` bigint NOT NULL COMMENT '评论人ID',
  `user_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '评论人姓名',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '评论内容',
  `parent_id` bigint NULL DEFAULT NULL COMMENT '父评论ID（用于回复）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`comment_id`) USING BTREE,
  INDEX `idx_task`(`task_id` ASC) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_parent`(`parent_id` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '工作流评论表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of workflow_comment
-- ----------------------------
INSERT INTO `workflow_comment` VALUES (1, 1, 1, '张三', '这个文档需要重点关注安全防护措施部分', NULL, 'admin', '2025-11-07 01:28:23', '', '2025-11-07 01:28:23');
INSERT INTO `workflow_comment` VALUES (2, 1, 2, '李四', '同意，我已经标注了需要修改的地方', NULL, 'admin', '2025-11-07 01:28:23', '', '2025-11-07 01:28:23');
INSERT INTO `workflow_comment` VALUES (3, 4, 1, '张三', '技术审核已完成60%，预计明天完成', NULL, 'admin', '2025-11-07 01:28:23', '', '2025-11-07 01:28:23');
INSERT INTO `workflow_comment` VALUES (4, 6, 3, '王五', '审核通过，可以发布', NULL, 'admin', '2025-11-07 01:28:23', '', '2025-11-07 01:28:23');
INSERT INTO `workflow_comment` VALUES (5, 6, 2, '李四', '同意发布', NULL, 'admin', '2025-11-07 01:28:23', '', '2025-11-07 01:28:23');
INSERT INTO `workflow_comment` VALUES (6, 6, 1, '张三', '已发布', NULL, 'admin', '2025-11-07 01:28:23', '', '2025-11-07 01:28:23');
INSERT INTO `workflow_comment` VALUES (7, 7, 4, '赵六', '更新完成', NULL, 'admin', '2025-11-07 01:28:23', '', '2025-11-07 01:28:23');
INSERT INTO `workflow_comment` VALUES (8, 8, 1, '张三', '审核意见：急性毒性数据缺失，应急处理措施不够详细', NULL, 'admin', '2025-11-07 01:28:23', '', '2025-11-07 01:28:23');

-- ----------------------------
-- Table structure for workflow_task
-- ----------------------------
DROP TABLE IF EXISTS `workflow_task`;
CREATE TABLE `workflow_task`  (
  `task_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `task_title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务标题',
  `task_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '任务描述',
  `task_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'msds_review' COMMENT '任务类型：msds_review-MSDS审核, msds_update-MSDS更新, msds_format-MSDS格式规范',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'pending' COMMENT '任务状态：pending-待处理, reviewing-审核中, approved-已通过, rejected-已拒绝',
  `priority` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'normal' COMMENT '优先级：urgent-紧急, normal-普通, low-低',
  `assignee_id` bigint NULL DEFAULT NULL COMMENT '负责人ID',
  `assignee_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '负责人姓名',
  `creator_id` bigint NOT NULL COMMENT '创建人ID',
  `creator_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人姓名',
  `msds_id` bigint NULL DEFAULT NULL COMMENT '关联的MSDS ID',
  `msds_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联的MSDS名称',
  `due_date` datetime NULL DEFAULT NULL COMMENT '截止日期',
  `progress` int NULL DEFAULT 0 COMMENT '进度百分比（0-100）',
  `attachment_count` int NULL DEFAULT 0 COMMENT '附件数量',
  `comment_count` int NULL DEFAULT 0 COMMENT '评论数量',
  `reviewer_ids` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审核人ID列表（逗号分隔）',
  `reviewer_names` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审核人姓名列表（逗号分隔）',
  `rejection_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '拒绝原因',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`task_id`) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_assignee`(`assignee_id` ASC) USING BTREE,
  INDEX `idx_creator`(`creator_id` ASC) USING BTREE,
  INDEX `idx_msds`(`msds_id` ASC) USING BTREE,
  INDEX `idx_due_date`(`due_date` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '工作流任务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of workflow_task
-- ----------------------------
INSERT INTO `workflow_task` VALUES (1, '乙醇MSDS文档审核', '需要对新上传的乙醇MSDS文档进行安全性审核', 'msds_review', 'pending', 'urgent', 1, '张三', 2, '李四', 1, '乙醇', '2025-11-08 01:28:23', 0, 3, 2, NULL, NULL, NULL, 'admin', '2025-11-07 01:28:23', '', '2025-11-07 01:28:23', NULL);
INSERT INTO `workflow_task` VALUES (2, '甲醇MSDS信息更新', '更新甲醇的物理化学性质和安全防护措施', 'msds_update', 'pending', 'normal', 2, '李四', 3, '王五', 2, '甲醇', '2025-11-09 01:28:23', 0, 1, 0, NULL, NULL, NULL, 'admin', '2025-11-07 01:28:23', '', '2025-11-07 01:28:23', NULL);
INSERT INTO `workflow_task` VALUES (3, '丙酮MSDS格式规范', '检查并规范丙酮MSDS文档的格式', 'msds_format', 'pending', 'low', 3, '王五', 1, '张三', 3, '丙酮', '2025-11-12 01:28:23', 0, 0, 0, NULL, NULL, NULL, 'admin', '2025-11-07 01:28:23', '', '2025-11-07 01:28:23', NULL);
INSERT INTO `workflow_task` VALUES (4, '异丙醇MSDS技术审核', '技术专家正在审核异丙醇的安全数据', 'msds_review', 'reviewing', 'normal', 1, '张三', 2, '李四', 4, '异丙醇', '2025-11-08 01:28:23', 60, 2, 1, NULL, NULL, NULL, 'admin', '2025-11-07 01:28:23', '', '2025-11-07 01:28:23', NULL);
INSERT INTO `workflow_task` VALUES (5, '苯MSDS安全评估', '高危化学品安全评估，需要多人审核', 'msds_review', 'reviewing', 'urgent', 2, '李四', 1, '张三', 5, '苯', '2025-11-07 01:28:23', 0, 1, 0, NULL, NULL, NULL, 'admin', '2025-11-07 01:28:23', '', '2025-11-07 01:28:23', NULL);
INSERT INTO `workflow_task` VALUES (6, '氯化钠MSDS审核', '已通过安全审核，可以发布使用', 'msds_review', 'approved', 'normal', 3, '王五', 2, '李四', 6, '氯化钠', '2025-11-06 01:28:23', 100, 2, 3, NULL, NULL, NULL, 'admin', '2025-11-07 01:28:23', '', '2025-11-07 01:28:23', NULL);
INSERT INTO `workflow_task` VALUES (7, '硫酸MSDS更新', '更新版本已通过审核', 'msds_update', 'approved', 'normal', 4, '赵六', 3, '王五', 7, '硫酸', '2025-11-05 01:28:23', 100, 1, 1, NULL, NULL, NULL, 'admin', '2025-11-07 01:28:23', '', '2025-11-07 01:28:23', NULL);
INSERT INTO `workflow_task` VALUES (8, '汞MSDS文档', '安全信息不完整，需要重新编写', 'msds_review', 'rejected', 'normal', 1, '张三', 2, '李四', 8, '汞', '2025-11-04 01:28:23', 0, 1, 1, NULL, NULL, NULL, 'admin', '2025-11-07 01:28:23', '', '2025-11-07 01:28:23', NULL);

-- ----------------------------
-- View structure for v_access_trend
-- ----------------------------
DROP VIEW IF EXISTS `v_access_trend`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_access_trend` AS select cast(`msds_document_access_log`.`access_time` as date) AS `access_date`,count(0) AS `total_visits`,count(distinct `msds_document_access_log`.`user_id`) AS `unique_users`,sum((case when (`msds_document_access_log`.`access_type` = 'view') then 1 else 0 end)) AS `view_count`,sum((case when (`msds_document_access_log`.`access_type` = 'download') then 1 else 0 end)) AS `download_count`,sum((case when (`msds_document_access_log`.`device_type` = 'mobile') then 1 else 0 end)) AS `mobile_visits`,sum((case when (`msds_document_access_log`.`device_type` = 'pc') then 1 else 0 end)) AS `pc_visits` from `msds_document_access_log` group by `access_date` order by `access_date` desc;

-- ----------------------------
-- View structure for v_msds_analytics
-- ----------------------------
DROP VIEW IF EXISTS `v_msds_analytics`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_msds_analytics` AS select `m`.`id` AS `id`,`m`.`cas_number` AS `cas_number`,`m`.`product_name` AS `product_name`,`m`.`product_english_name` AS `product_english_name`,`c`.`category_name` AS `category_name`,`c`.`category_code` AS `category_code`,`h`.`warning_word` AS `warning_word`,`h`.`hazard_category` AS `hazard_category`,(case when ((`h`.`warning_word` = 'danger') or (`h`.`hazard_category` like '%毒害%')) then 'high' when ((`h`.`warning_word` = 'warning') or (`h`.`hazard_category` like '%腐蚀%') or (`h`.`hazard_category` like '%易燃%')) then 'medium' else 'low' end) AS `hazard_level`,`s`.`view_count` AS `view_count`,`s`.`download_count` AS `download_count`,`s`.`favorite_count` AS `favorite_count`,`s`.`avg_score` AS `avg_score`,`m`.`create_time` AS `create_time`,`m`.`update_time` AS `update_time` from (((`msds_main` `m` left join `chemical_category` `c` on((`m`.`category_id` = `c`.`id`))) left join `msds_hazard` `h` on((`m`.`id` = `h`.`msds_id`))) left join `msds_document_statistics` `s` on((`m`.`id` = `s`.`msds_id`))) where (`m`.`is_active` = 1);

SET FOREIGN_KEY_CHECKS = 1;
