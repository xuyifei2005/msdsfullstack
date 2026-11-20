-- MySQL dump 10.13  Distrib 8.0.42, for Linux (x86_64)
--
-- Host: localhost    Database: msds_dev
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `msds_main`
--

DROP TABLE IF EXISTS `msds_main`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `msds_main` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'MSDS唯一标识',
  `cas_number` varchar(50) NOT NULL COMMENT 'CAS登记号',
  `msds_code` varchar(50) NOT NULL COMMENT 'MSDS编号',
  `product_name` varchar(255) NOT NULL COMMENT '化学品中文名',
  `product_alias` varchar(255) DEFAULT NULL COMMENT '化学品别名',
  `product_english_name` varchar(255) DEFAULT NULL COMMENT '化学品英文名',
  `category_id` int DEFAULT NULL COMMENT '化学品分类ID',
  `company_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '企业名称',
  `company_address` text COMMENT '企业地址',
  `zip_code` char(10) DEFAULT NULL COMMENT '邮编',
  `fax_number` varchar(50) DEFAULT NULL COMMENT '传真号码',
  `contact_phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系电话',
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
) ENGINE=InnoDB AUTO_INCREMENT=5894 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='MSDS主信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msds_main`
--

LOCK TABLES `msds_main` WRITE;
/*!40000 ALTER TABLE `msds_main` DISABLE KEYS */;
INSERT INTO `msds_main` (`id`, `cas_number`, `msds_code`, `product_name`, `product_alias`, `product_english_name`, `category_id`, `company_name`, `company_address`, `zip_code`, `fax_number`, `contact_phone`, `email`, `emergency_phone`, `recommended_usage`, `restricted_usage`, `version`, `revision_date`, `effective_date`, `status`, `approver`, `approval_date`, `is_active`, `create_time`, `update_time`, `created_by`, `updated_by`, `remark`) VALUES (5867,'混合物（3006-86-8 + 3006-82-4）','无资料','1,1-二-(叔丁基过氧)环己烷和过氧化(2-乙基己酸)叔丁酯的混合物[1,1-二-(叔丁基过氧)环己烷含量≤43%,过氧化(2-乙基己酸)叔丁酯含量≤16%,含A型稀释剂≥41%]','1,1-二-(叔丁基过氧)环己烷和过氧化(2-乙基己酸)叔丁酯的混合物（D型，含A型稀释剂）','1,1-di-(tert-butylperoxy)cyclohexane+tert-butyl peroxy-2-ethylhexanoate',NULL,'无资料','无资料',NULL,'无资料','无资料','无资料','无资料',NULL,NULL,NULL,NULL,NULL,'approved',NULL,NULL,1,'2026-03-11 07:59:06','2026-03-11 07:59:06',NULL,NULL,NULL),(5868,'591-21-9','MSDS-592-21-9','1,3-二甲基环己烷','六氢间二甲苯','1，3-Dimethyl cyclohexane',NULL,'无资料','无资料',NULL,'无资料','无资料','无资料','无资料',NULL,NULL,NULL,NULL,NULL,'approved',NULL,NULL,1,'2026-03-11 07:59:08','2026-03-11 07:59:08',NULL,NULL,NULL),(5869,'1997-2-9','MSDS-97-02-9','2,4-二硝基苯胺','无资料','2,4-dinitroaniline',NULL,'无资料','无资料',NULL,'无资料','无资料','无资料','无资料',NULL,NULL,NULL,NULL,NULL,'approved',NULL,NULL,1,'2026-03-11 07:59:10','2026-03-11 07:59:10',NULL,NULL,NULL),(5870,'3851-87-4','MSDS-3851-87-4','2,5-二甲基-2,5-二-(3,5,5-三甲基己酰过氧)己烷[含量≤77%,含A型稀释剂≥23%]','3851-87-4','2,5-dimethyl-2,5-di-(3,5,5-trimethylhexanoyl-peroxy)hexane (not more than 77%,and diluent type A not less than 23%)',NULL,'无资料','无资料',NULL,'无资料','无资料','无资料','无资料',NULL,NULL,NULL,NULL,NULL,'approved',NULL,NULL,1,'2026-03-11 07:59:11','2026-03-11 07:59:11',NULL,NULL,NULL),(5871,'无资料','MSDS-无资料','2-甲基-3-乙基丙烯醛','无资料','2-Methyl-3-ethyl acrolein',NULL,'无资料','无资料',NULL,'无资料','无资料','无资料','无资料',NULL,NULL,NULL,NULL,NULL,'approved',NULL,NULL,1,'2026-03-11 07:59:11','2026-03-11 07:59:11',NULL,NULL,NULL),(5872,'13887-02-0','MSDS-13887-02-0','9-磷杂双环壬烷','环辛二烯磷','9-phosphabicyclononane',NULL,'无资料','无资料',NULL,'无资料','无资料','无资料','无资料',NULL,NULL,NULL,NULL,NULL,'approved',NULL,NULL,1,'2026-03-11 07:59:14','2026-03-11 07:59:14',NULL,NULL,NULL),(5873,'21923-23-9','MSDS-60238-56-4','O','基]-O,O-二乙基硫代磷酸酯；','hiophenyl O,O-diethyl',NULL,'无资料','无资料',NULL,'无资料','无资料','无资料','无资料',NULL,NULL,NULL,NULL,NULL,'approved',NULL,NULL,1,'2026-03-11 07:59:15','2026-03-11 07:59:15',NULL,NULL,NULL),(5874,'7664-41-7','MSDS-7664-41-7','氨肥料[溶液,含游离氨＞35%]','氨水溶液','fertilizer ammoniating solution,with more than 35% free ammonia',NULL,'无资料','无资料',NULL,'无资料','无资料','无资料','无资料',NULL,NULL,NULL,NULL,NULL,'approved',NULL,NULL,1,'2026-03-11 07:59:15','2026-03-11 07:59:15',NULL,NULL,NULL),(5875,'7791-3-9','MSDS-7791-3-9','高氯酸锂','过氯酸锂','lithiumperchlorate',NULL,'无资料','无资料',NULL,'无资料','无资料','无资料','无资料',NULL,NULL,NULL,NULL,NULL,'approved',NULL,NULL,1,'2026-03-11 07:59:20','2026-03-11 07:59:20',NULL,NULL,NULL),(5876,'75-21-8','MSDS-75-21-8','环氧乙烷和氧化丙烯混合物[含环氧乙烷≤30%]','氧化乙烯和氧化丙烯混合物','ethylene oxide and propylene oxide mixtures,not more than 30% ethylene oxide',NULL,'无资料','无资料',NULL,'无资料','无资料','无资料','无资料',NULL,NULL,NULL,NULL,NULL,'approved',NULL,NULL,1,'2026-03-11 07:59:23','2026-03-11 07:59:23',NULL,NULL,NULL),(5877,'36336-92-2','MSDS-36336-92-2','甲基丙烯酸三硝基乙酯','无资料','trinitroethyl methacrylate',NULL,'无资料','无资料',NULL,'无资料','无资料','无资料','无资料',NULL,NULL,NULL,NULL,NULL,'approved',NULL,NULL,1,'2026-03-11 07:59:25','2026-03-11 07:59:25',NULL,NULL,NULL),(5878,'不适用','MSDS-不适用','焦油酸','无资料','tar acid',NULL,'无资料','无资料',NULL,'无资料','无资料','无资料','无资料',NULL,NULL,NULL,NULL,NULL,'approved',NULL,NULL,1,'2026-03-11 07:59:27','2026-03-11 07:59:27',NULL,NULL,NULL),(5879,'7719-9-7','MSDS-7719-9-7','氯化亚砜','亚硫酰二氯；二氯氧化硫；亚硫酰','thionyl chloride',NULL,'无资料','无资料',NULL,'无资料','无资料','无资料','无资料',NULL,NULL,NULL,NULL,NULL,'approved',NULL,NULL,1,'2026-03-11 07:59:31','2026-03-11 07:59:31',NULL,NULL,NULL),(5880,'75-72-9','MSDS-75-72-9','氯三氟甲烷和三氟甲烷共沸物','R503','chlorotrifluoromethane and trifluoromethane azeotropic mixture',NULL,'无资料','无资料',NULL,'无资料','无资料','无资料','无资料',NULL,NULL,NULL,NULL,NULL,'approved',NULL,NULL,1,'2026-03-11 07:59:32','2026-03-11 07:59:32',NULL,NULL,NULL),(5881,'3811-4-9','MSDS-3811-4-9','氯酸钾','氯酸钾','potassium chlorate',NULL,'无资料','无资料',NULL,'无资料','无资料','无资料','无资料',NULL,NULL,NULL,NULL,NULL,'approved',NULL,NULL,1,'2026-03-11 07:59:32','2026-03-11 07:59:32',NULL,NULL,NULL),(5882,'7775-9-9','MSDS-7775-9-9','氯酸钠','氯酸钠','sodium chlorate',NULL,'无资料','无资料',NULL,'无资料','无资料','无资料','无资料',NULL,NULL,NULL,NULL,NULL,'approved',NULL,NULL,1,'2026-03-11 07:59:33','2026-03-11 07:59:33',NULL,NULL,NULL),(5883,'7790-21-8','MSDS-7790-21-8','偏高碘酸钾','高碘酸钾、过碘酸钾','potassium meta-periodate',NULL,'无资料','无资料',NULL,'无资料','无资料','无资料','无资料',NULL,NULL,NULL,NULL,NULL,'approved',NULL,NULL,1,'2026-03-11 07:59:34','2026-03-11 07:59:34',NULL,NULL,NULL),(5884,'7790-28-5','MSDS-7790-28-5','偏高碘酸钠','高碘酸钠、过碘酸钠','sodium meta-periodate',NULL,'无资料','无资料',NULL,'无资料','无资料','无资料','无资料',NULL,NULL,NULL,NULL,NULL,'approved',NULL,NULL,1,'2026-03-11 07:59:35','2026-03-11 07:59:35',NULL,NULL,NULL),(5885,'7778-54-3','MSDS-7778-54-3','漂白粉','次氯酸钙','calcium hypochlorite',NULL,'无资料','无资料',NULL,'无资料','无资料','无资料','无资料',NULL,NULL,NULL,NULL,NULL,'approved',NULL,NULL,1,'2026-03-11 07:59:35','2026-03-11 07:59:35',NULL,NULL,NULL),(5886,'71-43-2','MSDS-71-43-2','溶剂苯','苯','benzol diluent',NULL,'无资料','无资料',NULL,'无资料','无资料','无资料','无资料',NULL,NULL,NULL,NULL,NULL,'approved',NULL,NULL,1,'2026-03-11 07:59:37','2026-03-11 07:59:37',NULL,NULL,NULL),(5887,'79-01-6','MSDS-1979-1-6','三氯乙烯','无资料','trichloroethylene',NULL,'无资料','无资料',NULL,'无资料','无资料','无资料','无资料',NULL,NULL,NULL,NULL,NULL,'approved',NULL,NULL,1,'2026-03-11 07:59:38','2026-03-11 07:59:38',NULL,NULL,NULL),(5888,'7784-41-0','MSDS-7784-41-0','砷酸二氢钾','无资料','potassium dihydrogen arsenate',NULL,'无资料','无资料',NULL,'无资料','无资料','无资料','无资料',NULL,NULL,NULL,NULL,NULL,'approved',NULL,NULL,1,'2026-03-11 07:59:39','2026-03-11 07:59:39',NULL,NULL,NULL),(5889,'7783-8-6','MSDS-7783-8-6','硒酸','无资料','selenic acid',NULL,'无资料','无资料',NULL,'无资料','无资料','无资料','无资料',NULL,NULL,NULL,NULL,NULL,'approved',NULL,NULL,1,'2026-03-11 07:59:43','2026-03-11 07:59:43',NULL,NULL,NULL),(5890,'55-63-0','MSDS-55-63-0','硝化甘油乙醇溶液[含硝化甘油≤10%]','硝化丙三醇乙醇溶液；甘油三硝酸酯乙醇溶液','nitroglycerin solution in alcohol with more than 1% but not more than 10% nitroglycerin',NULL,'无资料','无资料',NULL,'无资料','无资料','无资料','无资料',NULL,NULL,NULL,NULL,NULL,'approved',NULL,NULL,1,'2026-03-11 07:59:44','2026-03-11 07:59:44',NULL,NULL,NULL),(5891,'6484-52-2','MSDS-6484-52-2','硝酸铵肥料[比硝酸铵(含可燃物＞0.2%,包括以碳计算的任何有机物,但不包括任何其它添加剂)更易爆炸]','无资料','ammonium nitrate fertilizer,which is more liable to explode than ammonium nitrate with more than 0.2% total combustible material,including any combustible material calculated as carbon,but not including any other additives',NULL,'无资料','无资料',NULL,'无资料','无资料','无资料','无资料',NULL,NULL,NULL,NULL,NULL,'approved',NULL,NULL,1,'2026-03-11 07:59:44','2026-03-11 07:59:44',NULL,NULL,NULL),(5892,'7440-66-6','MSDS-7740-66-6','锌粉','锌粉、金属锌粉','zinc powder',NULL,'无资料','无资料',NULL,'无资料','无资料','无资料','无资料',NULL,NULL,NULL,NULL,NULL,'approved',NULL,NULL,1,'2026-03-11 07:59:46','2026-03-11 07:59:46',NULL,NULL,NULL),(5893,'87-33-2','MSDS-87-33-2','异山梨醇二硝酸酯混合物[含乳糖、淀粉或磷酸≥60%]','混合异山梨醇二硝酸酯；硝酸异山梨酯；消心痛','isosorbide dinitrate mixture with not less than 60% lactose,mannose,starch or calcium hydrogen phosphate',NULL,'无资料','无资料',NULL,'无资料','无资料','无资料','无资料',NULL,NULL,NULL,NULL,NULL,'approved',NULL,NULL,1,'2026-03-11 07:59:48','2026-03-11 07:59:48',NULL,NULL,NULL);
/*!40000 ALTER TABLE `msds_main` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msds_component`
--

DROP TABLE IF EXISTS `msds_component`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `msds_component` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
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
  `create_by` varchar(64) DEFAULT '',
  `create_time` datetime DEFAULT NULL,
  `update_by` varchar(64) DEFAULT '',
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_msds_id` (`msds_id`),
  KEY `idx_component_name` (`component_name`),
  KEY `idx_cas_number` (`cas_number`),
  CONSTRAINT `msds_component_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5733 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='成分/组成信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msds_component`
--

LOCK TABLES `msds_component` WRITE;
/*!40000 ALTER TABLE `msds_component` DISABLE KEYS */;
INSERT INTO `msds_component` (`id`, `msds_id`, `component_name`, `component_english_name`, `component_content`, `content_min`, `content_max`, `cas_number`, `ec_number`, `molecular_formula`, `molecular_weight`, `is_hazardous`, `hazard_level`, `component_function`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (5699,5867,'1,1-二-(叔丁基过氧)环己烷',NULL,'≤43.0%',NULL,NULL,'3006-86-8',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5700,5867,'过氧化(2-乙基己酸)叔丁酯',NULL,'≤16.0%',NULL,NULL,'3006-82-4',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5701,5867,'A型稀释剂',NULL,'≥41.0%',NULL,NULL,'无资料',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5702,5868,'1，3-二甲基环己烷；六氢间二甲苯',NULL,'100%',NULL,NULL,'591-21-9',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5703,5869,'2,4-二硝基苯胺',NULL,'100%',NULL,NULL,'1997-2-9',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5704,5870,'2,5-二甲基-2,5-二-(3,5,5-三甲基己酰过氧)己烷',NULL,'≤77.0%',NULL,NULL,'3851-87-4',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5705,5871,'2-甲基-3-乙基丙烯醛',NULL,'100%',NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5706,5872,'9-磷杂双环壬烷',NULL,'≥99.0%',NULL,NULL,'13887-02-0',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5707,5873,'氯甲硫磷；西拉硫磷',NULL,'100%',NULL,NULL,'21923-23-9',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5708,5874,'氨',NULL,'含游离氨＞35%',NULL,NULL,'7664-41-7',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5709,5875,'过氯酸锂',NULL,'100%',NULL,NULL,'7791-3-9',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5710,5876,'环氧乙烷',NULL,'≤30%',NULL,NULL,'75-21-8',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5711,5876,'氧化丙烯',NULL,'≥70%',NULL,NULL,'75-56-9',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5712,5877,'甲基丙烯酸三硝基乙酯',NULL,'≥99.0%',NULL,NULL,'36336-92-2',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5713,5878,'焦油酸',NULL,'≥99.0%',NULL,NULL,'不适用',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5714,5879,'氯化亚砜',NULL,'≥85.0％',NULL,NULL,'7719-9-7',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5715,5880,'氯三氟甲烷',NULL,'约59.9%',NULL,NULL,'75-72-9',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5716,5880,'三氟甲烷',NULL,'约40.1%',NULL,NULL,'75-46-7',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5717,5881,'氯酸钾',NULL,'≥99.5%',NULL,NULL,'3811-4-9',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5718,5882,'氯酸钠',NULL,'≥99.0%',NULL,NULL,'7775-9-9',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5719,5883,'偏高碘酸钾',NULL,'≥99.0%',NULL,NULL,'7790-21-8',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5720,5884,'偏高碘酸钠',NULL,'≥99.0%',NULL,NULL,'7790-28-5',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5721,5885,'次氯酸钙',NULL,'≥65.0%（以有效氯计）',NULL,NULL,'7778-54-3',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5722,5886,'苯',NULL,'≥99.0%',NULL,NULL,'71-43-2',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5723,5887,'三氯乙烯',NULL,'100%',NULL,NULL,'79-01-6',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5724,5888,'砷酸二氢钾',NULL,'≥99.0%',NULL,NULL,'7784-41-0',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5725,5889,'硒酸',NULL,'100%',NULL,NULL,'7783-8-6',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5726,5890,'硝化甘油',NULL,'≤10%',NULL,NULL,'55-63-0',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5727,5890,'乙醇',NULL,'≥90%',NULL,NULL,'64-17-5',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5728,5891,'硝酸铵',NULL,'>99.8%',NULL,NULL,'6484-52-2',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5729,5891,'可燃物',NULL,'>0.2%',NULL,NULL,'无资料',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5730,5892,'锌粉',NULL,'100%',NULL,NULL,'7440-66-6',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5731,5893,'异山梨醇二硝酸酯',NULL,'≤40%',NULL,NULL,'87-33-2',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL),(5732,5893,'乳糖、淀粉或磷酸钙',NULL,'≥60%',NULL,NULL,'无资料',NULL,NULL,NULL,0,NULL,NULL,'',NULL,'',NULL);
/*!40000 ALTER TABLE `msds_component` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msds_hazard`
--

DROP TABLE IF EXISTS `msds_hazard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `msds_hazard` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
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
  `create_by` varchar(64) DEFAULT '',
  `create_time` datetime DEFAULT NULL,
  `update_by` varchar(64) DEFAULT '',
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  CONSTRAINT `msds_hazard_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5786 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='危险性概述表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msds_hazard`
--

LOCK TABLES `msds_hazard` WRITE;
/*!40000 ALTER TABLE `msds_hazard` DISABLE KEYS */;
INSERT INTO `msds_hazard` (`id`, `msds_id`, `emergency_overview`, `physical_state`, `odor`, `color`, `warning_word`, `hazard_category`, `exposure_routes`, `health_hazards`, `environmental_hazards`, `fire_explosion_hazards`, `hazard_description`, `prevention_measures`, `response_measures`, `storage_measures`, `disposal_measures`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (5759,5867,NULL,NULL,NULL,NULL,NULL,'有机过氧化物，D型；危害水生环境-慢性毒性，类别2。','吸入、食入、皮肤接触、眼睛接触','吸入该物质可能会引起对健康有害的影响或呼吸道不适。意外食入可能引起胃肠道刺激症状。对眼睛、皮肤有刺激作用。有机过氧化物可能引起皮肤过敏反应。长期接触可能对肝、肾功能造成损害。','对水生生物可能有害。慢性水生毒性（过氧化(2-乙基己酸)叔丁酯）：甲壳纲动物，NOEC：0.62mg/L；藻类/水生植物，NOEC：0.017mg/L。应避免进入水体、土壤和地下水。该物质对环境可能有危害，对水体应给予特别注意。','本品为有机过氧化物（D型），受热、接触火焰或受到摩擦、震动、撞击时可能发生爆炸性分解。与还原剂、促进剂、强酸、强碱等接触可能发生剧烈反应。',NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5760,5868,NULL,NULL,NULL,NULL,NULL,'第3.2类中闪点易燃液体','吸入 食入 经皮吸收','有刺激作用。浓度高时有麻醉作用。','无资料','本品易燃、有毒、具有刺激性',NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5761,5869,NULL,NULL,NULL,NULL,NULL,'第6.1类毒害品','吸入食入经皮吸收\n吸入、口服或经皮肤吸收后，可引起中毒死亡。对眼睛、粘膜、呼吸道及皮肤有刺激作用。','吸收进入体内引起高铁血红蛋白血症，出现紫绀。中毒表现有恶心、眩晕、头痛等。',NULL,'本品可燃，有毒，具刺激性。',NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5762,5870,NULL,NULL,NULL,NULL,NULL,'有机过氧化物，D型。','吸入、食入、皮肤接触、眼睛接触','吸入该物质可能会引起对健康有害的影响或呼吸道不适。对眼睛、皮肤、粘膜和上呼吸道有刺激作用。误服可引起消化道刺激症状。','该物质对环境可能有危害，应特别注意对水体的污染。','遇明火、高热可燃。受热分解产生有毒气体。具有爆炸性，遇热、摩擦、震动或杂质可能发生爆炸。',NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5763,5871,NULL,NULL,NULL,NULL,NULL,'无资料','吸入 食入 经皮吸收','本品对眼睛、皮肤、粘膜和上呼吸道有刺激作用。','对水生生物有害。','本品易燃、具有刺激性',NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5764,5872,NULL,NULL,NULL,NULL,NULL,'第4.2类自热物质和混合物，类别1','吸入、食入、皮肤接触、眼睛接触','吸入该物质可能会引起对健康有害的影响或呼吸道不适。意外食入该物质可能会引起对健康有害的影响或胃肠道不适。皮肤接触该物质可能会引起对健康有害的影响或皮肤刺激。眼睛接触该物质可能会引起对健康有害的影响或眼睛刺激。','该物质可能对水生生物有害。避免释放到环境中。','遇明火、高热可燃。受热分解产生有毒气体。与氧化剂接触有发生燃烧和爆炸的危险。',NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5765,5873,NULL,NULL,NULL,NULL,NULL,'第6.1类 毒害品','吸入 食入 经皮吸收','呕吐、出汗、流涎、瞳孔缩小、抽搐、呼吸困难、紫绀，重者常伴有肺水肿、脑]水肿，\n可死于呼吸衰竭。','无资料','本品可燃、高毒',NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5766,5874,NULL,NULL,NULL,NULL,NULL,'第2.3类有毒气体','吸入、食入、皮肤接触、眼睛接触','低浓度氨对粘膜有刺激作用，高浓度可造成组织溶解性坏死，引起化学性支气管炎、肺炎、肺水肿，高浓度氨可引起反射性呼吸停止。液氨或高浓度氨可致眼灼伤，液氨可致皮肤灼伤。','对环境有危害，对水体和大气可造成污染。','易燃，与空气混合能形成爆炸性混合物，遇明火、高热极易燃烧爆炸。受热分解产生有毒的烟气。',NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5767,5875,NULL,NULL,NULL,NULL,NULL,'第5.1类氧化剂','吸入、食入、经皮吸收','本品对眼睛、皮肤、粘膜和上呼吸道有刺激性。','高氯酸锂为强氧化剂，对水生生物可能有害。应避免进入水体、土壤和地下水。高氯酸锂在水中可能释放氯离子和锂离子，对水生生态系统造成影响。','本品助燃，具刺激性。',NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5768,5876,NULL,NULL,NULL,NULL,NULL,'第3类易燃液体','吸入、食入、经皮吸收','吸入、食入或经皮肤吸收后对身体有害。对眼睛、皮肤、粘膜和上呼吸道有刺激作用。高浓度接触可引起头痛、头晕、恶心、呕吐、乏力、意识模糊等症状。长期或反复接触可能影响中枢神经系统。','对水生生物有害。对环境有危害，应特别注意对水体的污染。','易燃，其蒸气与空气可形成爆炸性混合物，遇明火、高热极易燃烧爆炸。与氧化剂接触猛烈反应。其蒸气比空气重，能在较低处扩散到相当远的地方，遇火源会着火回燃。若遇高热，容器内压增大，有开裂和爆炸的危险。',NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5769,5877,NULL,NULL,NULL,NULL,NULL,'第1.1类爆炸品','吸入、食入、皮肤接触、眼睛接触','属中等毒类。对眼睛、皮肤、粘膜和上呼吸道有刺激作用。吸入可引起喉痉挛、炎症，化学性肺炎、肺水肿等。高浓度接触可引起腹痛、头痛、头晕、恶心、呕吐等症状。对中枢神经系统有影响。','对环境有危害，对水体可造成污染。','通过打击、摩擦、火灾或其他着火源有极大爆炸危险。接触火焰可能会产生膨胀或爆炸性分解。',NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5770,5878,NULL,NULL,NULL,NULL,NULL,'第8类腐蚀品','吸入、食入、皮肤接触、眼睛接触','对眼睛、皮肤、粘膜和上呼吸道有强烈刺激性。吸入可引起喉炎、化学性肺炎和肺水肿。接触后可发生头痛、恶心、呕吐、咳嗽、气短等症状。皮肤接触可引起灼伤。眼睛接触可引起严重灼伤，甚至失明。','对水生生物有毒性。对环境有危害，对水体可造成污染。','可燃，受热发出有毒气体，有腐蚀性。遇明火、高热有燃烧爆炸的危险。',NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5771,5879,NULL,NULL,NULL,NULL,NULL,'第8.1类 酸性腐蚀品','吸入 食入 经皮吸收\n吸入、口服或经皮吸收后对身体有害。对眼睛、粘膜、皮肤和上呼吸道有强烈的刺激作用，可\n引起灼伤。吸入后，可能因喉、支气管痉挛、炎症和水肿而致死。中毒表现可有烧灼感、咳嗽、','头晕、喉炎、气短、头痛、恶心和呕吐。','无资料','本品不燃，具强腐蚀性、强刺激性，可致人体灼伤。',NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5772,5880,NULL,NULL,NULL,NULL,NULL,'第2.2类不燃气体；危害臭氧层，类别1。','吸入、皮肤接触、眼睛接触','吸入该物质可能会引起对健康有害的影响或呼吸道不适。由于该物质是窒息性气体，在高浓度环境下可能引起缺氧、头晕、头痛、恶心、意识模糊，严重时可导致窒息死亡。接触液体可能引起冻伤。','该物质对臭氧层有严重危害，属于受控的消耗臭氧层物质。对水生生物可能有害。','高压压缩气体，遇热有爆炸危险。容器受热可能发生爆炸。本身不燃，但可助燃。',NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5773,5881,NULL,NULL,NULL,NULL,NULL,'第5.1类氧化剂','吸入、食入、经皮吸收','对人的致死量约10g。口服急性中毒表现为高铁血红蛋白血症，胃肠炎，肝肾损害，甚至窒息。粉尘对呼吸道有刺激性。','对水生生物有害。该物质对环境可能有危害，对水体应给予特别注意。','强氧化剂。与可燃物、还原剂、有机物等混合可形成爆炸性混合物。与磷或金属粉末等混合可形成爆炸性混合物。急剧加热时可发生爆炸。',NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5774,5882,NULL,NULL,NULL,NULL,NULL,'第5.1类氧化剂','吸入、食入、经皮吸收','对眼睛、皮肤、粘膜和上呼吸道有刺激作用。吸入可引起呼吸道刺激，甚至肺水肿。误服可引起消化道刺激症状，严重时可引起肝肾损伤，甚至发生窒息。','对水生生物有害。该物质对环境可能有危害，对水体应给予特别注意。','强氧化剂。与可燃物、还原剂、有机物等混合可形成爆炸性混合物。急剧加热时可发生爆炸。遇火源可引起燃烧或爆炸。',NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5775,5883,NULL,NULL,NULL,NULL,NULL,'氧化性固体，类别2；皮肤腐蚀/刺激，类别2；严重眼损伤/眼刺激，类别2','吸入、食入、皮肤接触、眼睛接触','吸入该物质可能会引起对健康有害的影响或呼吸道不适。意外食入该物质可能造成对消化道的损害。皮肤接触可引起刺激。眼睛接触可引起严重刺激。高浓度接触严重损害粘膜、上呼吸道、眼睛和皮肤。接触后引起烧灼感、咳嗽、喘息、喉炎、气短。','对水生环境可能会引起长期有害作用。','本身不燃，但为强氧化剂，与可燃物、还原剂等接触可能发生剧烈反应，甚至引起燃烧或爆炸。',NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5776,5884,NULL,NULL,NULL,NULL,NULL,'氧化性固体，类别1；皮肤腐蚀/刺激，类别2；严重眼损伤/眼刺激，类别2','吸入、食入、皮肤接触、眼睛接触','吸入该物质可能会引起对健康有害的影响或呼吸道不适。意外食入该物质可能造成对消化道的损害。皮肤接触可引起刺激。眼睛接触可引起严重刺激。','对水生环境可能会引起长期有害作用。','本身不燃，但为强氧化剂，与可燃物、还原剂等接触可能发生剧烈反应，甚至引起燃烧或爆炸。',NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5777,5885,NULL,NULL,NULL,NULL,NULL,'第5.1类氧化剂','吸入、食入、皮肤接触、眼睛接触','本品对皮肤和眼睛有强烈刺激性。吸入可引起呼吸道刺激、咳嗽、呼吸困难。食入可引起口腔、咽喉、食道和胃部灼伤。高浓度接触可引起肺水肿。','对水生生物有极高毒性。对环境有危害，对水体可造成污染。','强氧化剂，与可燃物、还原剂、有机物等接触可引起燃烧爆炸。受热或遇酸分解产生有毒和腐蚀性的氯气。',NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5778,5886,NULL,NULL,NULL,NULL,NULL,'第3.2类中闪点易燃液体','吸入、食入、皮肤接触、眼睛接触','高毒。吸入、食入、经皮肤吸收均能引起中毒。急性中毒主要表现为中枢神经系统症状，如头痛、头晕、恶心、呕吐、神志不清、抽搐等。慢性中毒主要表现为造血系统损害，如白细胞减少、血小板减少、再生障碍性贫血等。对眼睛和皮肤有刺激性。','对水生生物有极高毒性。对环境有危害，对水体可造成污染。','高度易燃液体，其蒸气与空气混合，能形成爆炸性混合物。遇明火、高热极易引起燃烧爆炸。',NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5779,5887,NULL,NULL,NULL,NULL,NULL,'第6.1类 毒害品','吸入 食入 经皮吸收',NULL,NULL,'本品可燃，有毒，具刺激性。',NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5780,5888,NULL,NULL,NULL,NULL,NULL,'第6.1类毒害品','吸入、食入、皮肤接触、眼睛接触','砷酸二氢钾含有砷元素，具有砷的毒性特征。急性中毒可引起恶心、呕吐、腹痛、腹泻、头痛、头晕、乏力等症状。砷中毒可引起溶血、肝肾功能损害。慢性中毒可引起贫血、肝脾肿大、周围神经炎、记忆力减退等。对眼睛、皮肤、粘膜和上呼吸道有刺激作用。','对水生物有剧毒，对水生环境可能会引起长期有害作用。','受热分解产生有毒的砷氧化物烟雾。遇明火、高热可燃。与还原剂、金属粉末等可发生反应。',NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5781,5889,NULL,NULL,NULL,NULL,NULL,'第8.1类酸性腐蚀品','吸入、食入、经皮吸收','具有强腐蚀性。吸入可引起呼吸道刺激症状，严重者可发生化学性肺炎、肺水肿。食入可引起口腔、咽喉、食管和胃部灼伤，出现恶心、呕吐、腹痛、腹泻等症状，严重者可导致休克。皮肤接触可引起严重灼伤。眼睛接触可引起角膜灼伤，严重者可导致失明。长期接触可引起硒中毒，表现为食欲减退、乏力、贫血、脱发、指甲脱落、皮肤病变、神经系统损害等症状。','对水生物有剧毒，对水生环境可能会引起长期有害作用。','本品不燃，具强腐蚀性、强刺激性，可致人体灼伤。',NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5782,5890,NULL,NULL,NULL,NULL,NULL,'第3.2类中闪点易燃液体','吸入、食入、经皮吸收','少量吸收即可引起剧烈的搏动性头痛，常有恶心、心悸，有时有呕吐和腹痛，面部发热、潮红；较大量产生低血压、抑郁、精神错乱，偶见谵妄、高铁血红蛋白血症和紫绀。饮酒后，上述症状加剧，并可发生躁狂。本品易经皮肤吸收，应防止皮肤接触。慢性影响：可有头痛、疲乏等不适。','对水生生物有毒性，对环境有危害。','易燃，遇高热、明火、氧化剂有引起着火、爆炸危险。其蒸气与空气可形成爆炸性混合物，遇明火、高热极易燃烧爆炸。',NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5783,5891,NULL,NULL,NULL,NULL,NULL,'第1.1类爆炸品','吸入、食入、皮肤接触、眼睛接触','吸入、摄入或经皮肤吸收后对身体有害。对呼吸道、眼及皮肤有刺激性。接触后可引起恶心、呕吐、头痛、虚弱、无力和虚脱等。大量接触可引起高铁血红蛋白血症，影响血液的携氧能力，出现紫绀、头痛、头晕、虚脱，甚至死亡。口服引起剧烈腹痛、呕吐、血便、休克、全身抽搐、昏迷，甚至死亡。','对环境有危害，对水体可造成污染。','强氧化剂。助燃。与可燃物、还原剂、有机物等混合能形成爆炸性混合物，遇明火、高热有燃烧爆炸危险。受强烈震动也会起爆。急剧加热时可发生爆炸。通过打击、摩擦、火灾或其他着火源有极大爆炸危险。',NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5784,5892,NULL,NULL,NULL,NULL,NULL,'第4.3类遇湿易燃物品','吸入、食入','吸入锌在高温下形成的氧化锌烟雾可致金属烟雾热，症状有口中金属味、口渴、胸部紧束感、干咳、头痛、头晕、高热、寒战等。粉尘对眼有刺激性。口服刺激胃肠道。长期反复接触对皮肤有刺激性。','对水生生物可能有害，可能导致水体长期污染。','本品遇湿易燃，具刺激性。粉末与空气能形成爆炸性混合物，易被明火点燃引起爆炸。',NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5785,5893,NULL,NULL,NULL,NULL,NULL,'第4.1类易燃固体','吸入、食入、皮肤接触、眼睛接触','吸入该物质可能会引起对健康有害的影响或呼吸道不适。意外食入后可能引起头痛、头晕、面部潮红、恶心、呕吐等。还可能导致体位性低血压，引起心悸、乏力等不适。对眼睛、皮肤和呼吸道有刺激性。','该物质对环境可能有危害，对水体应给予特别注意。','遇火或摩擦极易引燃，其粉体与空气混合，能形成爆炸性混合物。加热时，容器可能爆炸。暴露于火中的容器可能会通过压力安全阀泄漏出内容物。受热或接触火焰可能会产生膨胀或爆炸性分解。',NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL);
/*!40000 ALTER TABLE `msds_hazard` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msds_physical_chemical`
--

DROP TABLE IF EXISTS `msds_physical_chemical`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `msds_physical_chemical` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
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
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  CONSTRAINT `msds_physical_chemical_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5688 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='理化特性表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msds_physical_chemical`
--

LOCK TABLES `msds_physical_chemical` WRITE;
/*!40000 ALTER TABLE `msds_physical_chemical` DISABLE KEYS */;
INSERT INTO `msds_physical_chemical` (`id`, `msds_id`, `appearance`, `odor`, `odor_threshold`, `melting_point`, `boiling_point`, `relative_density`, `vapor_density`, `vapor_pressure`, `vapor_pressure_temp`, `solubility`, `water_solubility`, `pH_value`, `ph_concentration`, `flash_point`, `ignition_temperature`, `explosive_limit_lower`, `explosive_limit_upper`, `viscosity`, `partition_coefficient`, `decomposition_temperature`, `molecular_formula`, `main_components`, `critical_temperature`, `autoignition_temperature`, `flammability`, `molecular_weight`, `heat_of_combustion`, `critical_pressure`, `main_usage`, `other_properties`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (5661,5867,'无色或浅黄色透明液体',NULL,NULL,'-30（基于过氧化(2-乙基己酸)叔丁酯数据）','248.9±23.0（基于过氧化(2-乙基己酸)叔丁酯数据）','0.89-0.93（20℃）',NULL,NULL,NULL,'易溶于大多数有机溶剂',NULL,NULL,NULL,'71.8-85（基于过氧化(2-乙基己酸)叔丁酯数据）',NULL,NULL,NULL,NULL,NULL,NULL,'混合物',NULL,NULL,'无资料','易燃，有机过氧化物','混合物',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5662,5868,'无色透明液体。',NULL,NULL,'无资料','124','0.7670',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'6',NULL,NULL,NULL,NULL,NULL,NULL,'C8H16',NULL,NULL,'306',NULL,'112.22',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5663,5869,'黄色针状结晶。',NULL,NULL,'180','无资料','1.62',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'无意义',NULL,NULL,NULL,NULL,NULL,NULL,'C6H5N3O4',NULL,NULL,'无资料','可燃','183.13',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5664,5870,'无色至淡黄色液体',NULL,NULL,'约-10℃（估算值）','>35℃（分解温度）','约0.95（估算值，水=1）',NULL,NULL,NULL,'不溶于水，可溶于多数有机溶剂',NULL,NULL,NULL,'约90℃（估算值）',NULL,NULL,NULL,NULL,NULL,NULL,'C26H46O6',NULL,NULL,'约200℃（估算值）','可燃','454.64',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5665,5871,'无色液体。',NULL,NULL,'无资料','137','0.85',NULL,NULL,NULL,'不溶于水，可混溶于乙醇、乙醚等多数有机溶剂。',NULL,NULL,NULL,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,'C6H10O',NULL,NULL,'引燃温度(℃)：无资料','易燃','98.14',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5666,5872,'无色液体',NULL,NULL,'无资料','>35℃','无资料',NULL,NULL,NULL,'不溶于水，溶于有机溶剂',NULL,NULL,NULL,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,'C8H15P',NULL,NULL,'无资料','易燃','142.17',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5667,5873,'固体。',NULL,NULL,'39～39.5','155／13.3X(10-3)kPa','无资料',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,'C11H15C',NULL,NULL,'无资料',NULL,'361.25',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5668,5874,'无色液体，有强烈的刺激性气味。',NULL,NULL,'-77.7℃(氨)','-33.5℃(氨)','0.88(25%氨水溶液)',NULL,NULL,NULL,'易溶于水、乙醇、乙醚，水溶液呈碱性。',NULL,NULL,NULL,'-20℃(氨水溶液)',NULL,NULL,NULL,NULL,NULL,NULL,'NH3',NULL,NULL,'651℃','易燃','17.03',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5669,5875,'无色结晶,有潮解性。',NULL,NULL,'236','430(分解)','2.43',NULL,NULL,NULL,'易溶于水，溶于乙醇、乙醚',NULL,NULL,NULL,'无意义',NULL,NULL,NULL,NULL,NULL,NULL,'LiClO4',NULL,NULL,'引燃温度(℃)：无意义',NULL,'106.40',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5670,5876,'无色透明液体，有醚样气味。',NULL,NULL,'无资料','34.5','0.83',NULL,NULL,NULL,'与水混溶，可混溶于多数有机溶剂。',NULL,NULL,NULL,'-17.8',NULL,NULL,NULL,NULL,NULL,NULL,'无资料',NULL,NULL,'429','易燃','无资料',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5671,5877,'无资料',NULL,NULL,'无资料','>35℃','无资料',NULL,NULL,NULL,'无资料',NULL,NULL,NULL,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,'C6H7N3O8',NULL,NULL,'无资料','易爆','249.14',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5672,5878,'黑色粘稠液体，有臭味和腐蚀性。',NULL,NULL,'无资料','无资料','无资料',NULL,NULL,NULL,'不溶于水，溶于有机溶剂。',NULL,NULL,NULL,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,'不适用',NULL,NULL,'无资料','可燃','不适用',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5673,5879,'淡黄色至红色、发烟液体, 有强烈刺激气味。',NULL,NULL,'-105','78.8','1.64',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'无意义',NULL,NULL,NULL,NULL,NULL,NULL,'C',NULL,NULL,'引燃温度(℃)：无意义',NULL,'118.96',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5674,5880,'无色气体',NULL,NULL,'-181','-87.5','1.230 g/cm³ (30℃, 液体)',NULL,NULL,NULL,'不溶于水',NULL,NULL,NULL,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,'无资料',NULL,NULL,'无资料','不燃','87.7',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5675,5881,'无色片状结晶或白色颗粒粉末，味咸而凉',NULL,NULL,'368.4','无资料','2.32',NULL,NULL,NULL,'易溶于水，不溶于乙醇',NULL,NULL,NULL,'无意义',NULL,NULL,NULL,NULL,NULL,NULL,'KClO3',NULL,NULL,'无意义','无意义','122.55',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5676,5882,'无色无臭结晶，味咸而凉，有潮解性。',NULL,NULL,'248～261','分解','2.49',NULL,NULL,NULL,'易溶于水，微溶于乙醇，不溶于丙酮。',NULL,NULL,NULL,'无意义',NULL,NULL,NULL,NULL,NULL,NULL,'NaClO3',NULL,NULL,'无意义','无意义','106.45',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5677,5883,'白色结晶性粉末',NULL,NULL,'582℃(爆炸)','无资料','3.62',NULL,NULL,NULL,'微溶于冷水，溶于热水',NULL,NULL,NULL,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,'KIO4',NULL,NULL,'无资料','无资料','230.00',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5678,5884,'无色结晶或白色结晶性粉末',NULL,NULL,'300(分解)','无资料','3.87',NULL,NULL,NULL,'易溶于水、乙酸、盐酸，不溶于乙醇',NULL,NULL,NULL,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,'NaIO4',NULL,NULL,'无资料','无资料','213.89',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5679,5885,'白色粉末，有极强的氯臭味。其溶液为黄绿色半透明液体。',NULL,NULL,'100℃（分解）','无意义（分解）','2.35',NULL,NULL,NULL,'溶于水，不溶于乙醇。',NULL,NULL,NULL,'无意义',NULL,NULL,NULL,NULL,NULL,NULL,'Ca(ClO)2',NULL,NULL,'无意义','不燃','142.99',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5680,5886,'无色透明液体，有特殊芳香气味。',NULL,NULL,'5.5℃','80.1℃','0.879（20℃）',NULL,NULL,NULL,'不溶于水，溶于乙醇、乙醚、丙酮等有机溶剂。',NULL,NULL,NULL,'-11℃（闭杯）',NULL,NULL,NULL,NULL,NULL,NULL,'C6H6',NULL,NULL,'560℃','易燃','78.11',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5681,5887,'无色透明液体，有似氯仿的气味。',NULL,NULL,'-87.1','87.1','1.46',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,'C2HCl3',NULL,NULL,'420','可燃','131.39',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5682,5888,'白色结晶性粉末',NULL,NULL,'288℃','>350℃（分解）','2.9',NULL,NULL,NULL,'易溶于水，微溶于乙醇',NULL,NULL,NULL,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,'KH2AsO4',NULL,NULL,'无资料','无资料','180.03',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5683,5889,'白色六方柱晶体，极易吸潮',NULL,NULL,'58℃','260℃（分解）','1.407',NULL,NULL,NULL,'易溶于水，不溶于氨水，溶于硫酸',NULL,NULL,NULL,'>110℃',NULL,NULL,NULL,NULL,NULL,NULL,'H2SeO4',NULL,NULL,'无意义','不燃','144.98',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5684,5890,'无色至淡黄色透明液体',NULL,NULL,'无资料','78℃（乙醇沸点）','0.79-0.81（取决于硝化甘油含量）',NULL,NULL,NULL,'与水混溶，溶于乙醇、乙醚等有机溶剂',NULL,NULL,NULL,'12℃',NULL,NULL,NULL,NULL,NULL,NULL,'C3H5N3O9（硝化甘油）',NULL,NULL,'无资料','易燃','227.09（硝化甘油）',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5685,5891,'无色无臭的透明结晶或呈白色的小颗粒，有潮解性。',NULL,NULL,'169.6℃','210℃（分解）','1.725',NULL,NULL,NULL,'118 g/100 mL (0°C)，192 g/100 mL (20°C)，421 g/100 mL (60°C)，740 g/100 mL (100°C)',NULL,NULL,NULL,'无意义',NULL,NULL,NULL,NULL,NULL,NULL,'NH4NO3',NULL,NULL,'无意义','助燃','80.04',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5686,5892,'浅灰色的细小粉末',NULL,NULL,'419.6','907','7.13',NULL,NULL,NULL,'不溶于水，溶于酸、碱、氨水',NULL,NULL,NULL,'无意义',NULL,NULL,NULL,NULL,NULL,NULL,'Zn',NULL,NULL,'500','易燃','65.38',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5687,5893,'白色结晶性粉末',NULL,NULL,'68-72℃','无资料','无资料',NULL,NULL,NULL,'易溶于丙酮、乙醇，微溶于水',NULL,NULL,NULL,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,'C6H8N2O8',NULL,NULL,'无资料','易燃','236.14',NULL,NULL,NULL,NULL,'',NULL,'',NULL);
/*!40000 ALTER TABLE `msds_physical_chemical` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msds_first_aid`
--

DROP TABLE IF EXISTS `msds_first_aid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `msds_first_aid` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
  `skin_contact` text COMMENT '皮肤接触处理措施',
  `eye_contact` text COMMENT '眼睛接触处理措施',
  `inhalation` text COMMENT '吸入处理措施',
  `ingestion` text COMMENT '食入处理措施',
  `general_notes` text COMMENT '一般注意事项',
  `symptoms_effects` text COMMENT '可能出现的症状和健康影响',
  `immediate_medical_attention` text COMMENT '需要立即就医的情况',
  `antidote_treatment` text COMMENT '解毒剂及治疗方法',
  `create_by` varchar(64) DEFAULT '',
  `create_time` datetime DEFAULT NULL,
  `update_by` varchar(64) DEFAULT '',
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  CONSTRAINT `msds_first_aid_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5759 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='急救措施表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msds_first_aid`
--

LOCK TABLES `msds_first_aid` WRITE;
/*!40000 ALTER TABLE `msds_first_aid` DISABLE KEYS */;
INSERT INTO `msds_first_aid` (`id`, `msds_id`, `skin_contact`, `eye_contact`, `inhalation`, `ingestion`, `general_notes`, `symptoms_effects`, `immediate_medical_attention`, `antidote_treatment`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (5732,5867,'脱去污染的衣着，用大量流动清水彻底冲洗至少15分钟。如有不适，就医。','立即翻开上下眼睑，用流动清水或生理盐水彻底冲洗至少15分钟。立即就医。','迅速脱离现场至空气新鲜处。保持呼吸道通畅。如呼吸困难，给输氧。如呼吸停止，立即进行人工呼吸。就医。','误服者立即漱口，切勿催吐。给饮牛奶或蛋清。立即就医。',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5733,5868,'用肥皂水及清水彻底冲洗。就医。','拉开眼睑，用流动清水冲洗15分钟。就医。','脱离现场至空气新鲜处。就医。','误服者，饮适量温水，催吐。就医。',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5734,5869,'立即脱去污染的衣着，用肥皂水和清水彻底冲洗皮肤。就医。','提起眼睑，用流动清水或生理盐水冲洗。就医。','迅速脱离现场至空气新鲜处。保持呼吸道通畅。如呼吸困难，给输氧。如呼吸停止，立即进行人工呼吸。就医。','饮足量温水，催吐。就医。',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5735,5870,'脱去污染的衣着，用大量流动清水彻底冲洗。就医。','立即翻开上下眼睑，用流动清水或生理盐水冲洗至少15分钟。就医。','迅速脱离现场至空气新鲜处。保持呼吸道通畅。呼吸困难时给输氧。呼吸停止时，立即进行人工呼吸。就医。','误服者立即漱口，给饮牛奶或蛋清。就医。',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5736,5871,'脱去污染的衣着，用流动清水冲洗。','立即翻开上下眼睑，用流动清水冲洗15分钟。就医。','脱离现场至空气新鲜处。呼吸困难时给输氧。呼吸停止时，立即进行人工呼吸。就医。','误服者给饮足量温水，催吐，就医。',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5737,5872,'脱去污染的衣着，用肥皂水和大量流动清水彻底冲洗皮肤至少15分钟。如有不适，就医。','立即提起眼睑，用大量流动清水或生理盐水彻底冲洗至少15分钟。就医。','迅速脱离现场至空气新鲜处。保持呼吸道通畅。如呼吸困难，给输氧。如呼吸停止，立即进行人工呼吸。就医。','切勿催吐。切勿给失去知觉者从嘴里喂食任何东西。用水漱口。就医。',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5738,5873,'用肥皂水及清水彻底冲洗。就医。','拉开眼睑，用流动清水冲洗15分钟。就医。','脱离现场至空气新鲜处。呼吸困难时给输氧。呼吸停止时，立即进行人工呼吸。就医。','误服者，饮适量温水，催吐。洗胃。就医。',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5739,5874,'立即脱去被污染的衣着，并用大量流动的清水进行清洗，一般不少于15分钟；严重的就医。','立即翻开眼睑，用大量流动的清水或生理盐水冲洗至少15分钟；严重的就医。','迅速脱离现场至空气新鲜处，保持呼吸道畅通；如呼吸困难，给输氧；如果呼吸停止，立即进行人工呼吸，并立即就医。','禁止催吐，切勿给失去知觉者从嘴里喂食任何东西。立即呼叫医生或中毒控制中心。',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5740,5875,'脱去污染的衣着，用大量流动清水冲洗。','提起眼睑，用流动清水或生理盐水冲洗。就医。','进行人工呼吸。就医。','饮足量温水，催吐。就医。',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5741,5876,'脱去污染的衣着，用大量流动清水彻底冲洗。就医。','立即翻开上下眼睑，用流动清水或生理盐水冲洗。就医。','迅速脱离现场至空气新鲜处。保持呼吸道通畅。呼吸困难时给输氧。呼吸停止时，立即进行 人工呼吸。就医。','误服者立即漱口，给饮牛奶或蛋清。就医。',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5742,5877,'脱去污染的衣着，用大量流动清水彻底冲洗。就医。','立即翻开上下眼睑，用流动清水或生理盐水冲洗至少15分钟。就医。','迅速脱离现场至空气新鲜处。保持呼吸道通畅。如呼吸困难，给输氧。如呼吸停止，立即进行人工呼吸。就医。','误服者立即漱口，给饮牛奶或蛋清。催吐。就医。',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5743,5878,'立即脱去污染的衣着，用大量流动清水彻底冲洗至少15分钟。就医。','立即提起眼睑，用流动清水或生理盐水彻底冲洗至少15分钟。就医。','迅速脱离现场至空气新鲜处。保持呼吸道通畅。如呼吸困难，给输氧。如呼吸停止，立即进行人工呼吸。就医。','禁止催吐。误服者立即漱口，给饮牛奶或蛋清。就医。',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5744,5879,'立即脱去污染的衣着，用大量流动清水冲洗至少15分钟。就医。','立即提起眼睑，用大量流动清水或生理盐水彻底冲洗至少15分钟。就医。','迅速脱离现场至空气新鲜处。保持呼吸道通畅。如呼吸困难，给输氧。如呼吸停止，立即进行 人工呼吸。就医。','用水漱口，给饮牛奶或蛋清。就医。',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5745,5880,'脱去污染的衣着，用大量流动清水彻底冲洗。就医。','立即提起眼睑，用大量流动清水或生理盐水彻底冲洗至少15分钟。就医。','迅速脱离现场至空气新鲜处。保持呼吸道通畅。如呼吸困难，给输氧。如呼吸停止，立即进行人工呼吸。就医。','误服者立即漱口，给饮牛奶或蛋清。就医。',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5746,5881,'脱去污染的衣着，用大量流动清水冲洗。就医。','提起眼睑，用流动清水或生理盐水冲洗。就医。','迅速脱离现场至空气新鲜处。保持呼吸道通畅。如呼吸困难，给输氧。如呼吸停止，立即进行人工呼吸。就医。','饮足量温水，催吐。就医。',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5747,5882,'脱去污染的衣着，用大量流动清水冲洗。就医。','立即提起眼睑，用流动清水或生理盐水冲洗。就医。','迅速脱离现场至空气新鲜处。保持呼吸道通畅。如呼吸困难，给输氧。如呼吸停止，立即进行人工呼吸。就医。','饮足量温水，催吐。就医。',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5748,5883,'脱去污染的衣着，用大量流动清水彻底冲洗。就医。','立即翻开上下眼睑，用流动清水或生理盐水冲洗。就医。','迅速脱离现场至空气新鲜处。保持呼吸道通畅。呼吸困难时给输氧。呼吸停止时，立即进行人工呼吸。就医。','误服者立即漱口，给饮牛奶或蛋清。就医。',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5749,5884,'脱去污染的衣着，用大量流动清水彻底冲洗。就医。','立即翻开上下眼睑，用流动清水或生理盐水冲洗。就医。','迅速脱离现场至空气新鲜处。保持呼吸道通畅。呼吸困难时给输氧。呼吸停止时，立即进行人工呼吸。就医。','误服者立即漱口，给饮牛奶或蛋清。就医。',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5750,5885,'立即脱去污染的衣着，用大量流动清水彻底冲洗至少15分钟。就医。','立即提起眼睑，用流动清水或生理盐水彻底冲洗至少15分钟。就医。','迅速脱离现场至空气新鲜处。保持呼吸道通畅。如呼吸困难，给输氧。如呼吸停止，立即进行人工呼吸。就医。','禁止催吐。误服者立即漱口，给饮牛奶或蛋清。就医。',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5751,5886,'立即脱去污染的衣着，用肥皂水和清水彻底冲洗皮肤。就医。','立即提起眼睑，用流动清水或生理盐水彻底冲洗至少15分钟。就医。','迅速脱离现场至空气新鲜处。保持呼吸道通畅。如呼吸困难，给输氧。如呼吸停止，立即进行人工呼吸。就医。','禁止催吐。误服者立即漱口，给饮牛奶或蛋清。就医。',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5752,5887,'立即脱去污染的衣着，用肥皂水和清水彻底冲洗皮肤。就医。','提起眼睑，用流动清水或生理盐水冲洗。就医。','迅速脱离现场至空气新鲜处。保持呼吸道通畅。如呼吸困难，给输氧。如呼吸停止，立即进行 迅速脱离现场至空气新鲜处。保持呼吸道通畅。如呼吸困难，给输氧。如呼吸停止，立即进行人工呼吸。就医。','饮足量温水，催吐。就医。',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5753,5888,'立即脱去污染的衣着，用大量流动清水彻底冲洗。如有不适，就医。','立即翻开上下眼睑，用流动清水或生理盐水冲洗至少15分钟。如有不适，就医。','迅速脱离现场至空气新鲜处。保持呼吸道通畅。呼吸困难时给输氧。呼吸停止时，立即进行人工呼吸。就医。','误服者立即漱口，给饮牛奶或蛋清。就医。',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5754,5889,'立即脱去污染的衣着，用大量流动清水冲洗至少15分钟。就医。','立即提起眼睑，用大量流动清水或生理盐水彻底冲洗至少15分钟。就医。','迅速脱离现场至空气新鲜处。保持呼吸道通畅。如呼吸困难，给输氧。如呼吸停止，立即进行 人工呼吸。就医。','用水漱口，给饮牛奶或蛋清。就医。',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5755,5890,'脱去污染的衣着，用大量流动清水彻底冲洗。就医。','立即提起眼睑，用大量流动清水或生理盐水彻底冲洗至少15分钟。就医。','迅速脱离现场至空气新鲜处。保持呼吸道通畅。如呼吸困难，给输氧。如呼吸停止，立即进行人工呼吸。就医。','误服者立即漱口，给饮牛奶或蛋清。就医。',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5756,5891,'脱去污染的衣着，用大量流动清水彻底冲洗。就医。','立即提起眼睑，用大量流动清水或生理盐水彻底冲洗至少15分钟。就医。','迅速脱离现场至空气新鲜处。保持呼吸道通畅。如呼吸困难，给输氧。如呼吸停止，立即进行人工呼吸。就医。','用水漱口，给饮牛奶或蛋清。就医。',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5757,5892,'脱去污染的衣着，用肥皂水和清水彻底冲洗皮肤。','提起眼睑，用流动清水或生理盐水冲洗。就医。','迅速脱离现场至空气新鲜处。保持呼吸道通畅。如呼吸困难，给输氧。如呼吸停止，立即进行人工呼吸。就医。','饮足量温水，催吐。就医。',NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5758,5893,'立即脱去污染的衣着，用大量流动清水彻底冲洗至少15分钟。就医。','立即翻开上下眼睑，用流动清水或生理盐水冲洗至少15分钟。就医。','迅速脱离现场至空气新鲜处。保持呼吸道通畅。如呼吸困难，给输氧。如呼吸停止，立即进行人工呼吸。就医。','误服者立即漱口，给饮牛奶或蛋清。禁止催吐。就医。',NULL,NULL,NULL,NULL,'',NULL,'',NULL);
/*!40000 ALTER TABLE `msds_first_aid` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msds_fire_fighting`
--

DROP TABLE IF EXISTS `msds_fire_fighting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `msds_fire_fighting` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
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
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  CONSTRAINT `msds_fire_fighting_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5759 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='消防措施表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msds_fire_fighting`
--

LOCK TABLES `msds_fire_fighting` WRITE;
/*!40000 ALTER TABLE `msds_fire_fighting` DISABLE KEYS */;
INSERT INTO `msds_fire_fighting` (`id`, `msds_id`, `hazard_characteristics`, `harmful_combustion_products`, `suitable_extinguishing_media`, `unsuitable_extinguishing_media`, `fire_fighting_equipment`, `fire_fighting_procedures`, `flash_point`, `autoignition_temperature`, `flammability_limits`, `fire_risk_classification`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (5732,5867,'受热、摩擦、震动、撞击时可能发生爆炸性分解反应。遇明火、高热、氧化剂有引起燃烧爆炸的危险。其蒸气比空气重，能在较低处扩散到相当远的地方，遇火源会着火回燃。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:07','',NULL),(5733,5868,'氧化剂可发生反应。其蒸气比空气重，能在较低处扩散到相当远的地方，遇明火会引着回燃。 若遇高热，容器内压增大，有开裂和爆炸的危险。','一氧化碳、二氧化碳。','泡沫、二氧化碳、干粉、1211灭火剂。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:08','',NULL),(5734,5869,'炸性，但只有在强起爆药引爆下才能起爆。','一氧化碳、二氧化碳、氧化氮。','采用雾状水、泡沫、干粉、二氧化碳、砂土灭火。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:10','',NULL),(5735,5870,'接触火焰可能会产生膨胀或爆炸性分解。','燃烧产生一氧化碳、二氧化碳、有机酸和醛类等有毒有害气体。','合适的灭火介质：使用适合火灾类型的合适的灭火剂。不合适的灭火介质：无特别说明。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:11','',NULL),(5736,5871,'相当远的地方，遇明火会引着回燃。若遇高热，可能发生聚合反应，出现大量放热现象，引起 容器破裂和爆炸事故。','一氧化碳、二氧化碳。','泡沫、二氧化碳、干粉、砂土。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:11','',NULL),(5737,5872,'遇明火、高热可燃。受热分解产生有毒气体。与氧化剂接触有发生燃烧和爆炸的危险。暴露于火中的容器可能会通过压力安全阀泄漏出内容物。受热或接触火焰可能会产生膨胀或爆炸性分解。','磷氧化物、一氧化碳、二氧化碳','干粉、干砂、二氧化碳或耐醇泡沫。切勿使用直流水。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:14','',NULL),(5738,5873,'遇明火、高热可燃。受高热分解，放出高毒的烟气。','一氧化碳、二氧化碳、氯化氢、二氧化硫。','干粉、泡沫、砂土。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:15','',NULL),(5739,5874,'有爆炸危险；空气中氨蒸气浓度达15.7～27.4%时，遇火星会引起燃烧爆炸；有油类存在时，可增加燃烧危险。','一氧化碳、二氧化碳、氮氧化物','干粉、二氧化碳、耐醇泡沫。避免用太强烈的水汽灭火，因为它可能会使火苗蔓延分散。灭火时，应佩戴呼吸面具（符合MSHA/NIOSH要求的或相当的）并穿上全身防护服。在安全距离处、有充足防护的情况下灭火。防止消防水污染地表和地下水系统。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:15','',NULL),(5740,5875,'受热分解，放出氧气。','氯化物、氧化锂。','采用雾状水、砂土灭火。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:20','',NULL),(5741,5876,'遇明火、高热极易燃烧爆炸。受热或接触火焰可能会产生膨胀或爆炸性分解。加热时，容器可能爆炸。暴露于火中的容器可能会通过压力安全阀泄漏出内容物。燃烧时可能会释放毒性烟雾。','一氧化碳、二氧化碳。','合适的灭火介质：干粉、二氧化碳或耐醇泡沫。不合适的灭火介质：避免用太强烈的水汽灭火，因为它可能会使火苗蔓延分散。灭火时，应佩戴呼吸面具（符合MSHA/NIOSH要求的或相当的）并穿上全身防护服。在安全距离处、有充足防护的情况下灭火。防止消防水污染地表和地下水系统。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:23','',NULL),(5742,5877,'接触火焰可能会产生膨胀或爆炸性分解。通过打击、摩擦、火灾或其他着火源有极大爆炸危险。','一氧化碳、二氧化碳、氮氧化物。','使用适合火灾类型的合适的灭火剂。不合适的灭火介质：无特别说明。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:25','',NULL),(5743,5878,'可燃，受热发出有毒气体，有腐蚀性。接触火焰可能会产生膨胀或爆炸性分解。','一氧化碳、二氧化碳、硫化物等。','灭火剂：干粉、二氧化碳、泡沫。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:28','',NULL),(5744,5879,'本品不燃, 遇水或潮气会分解放出二氧化硫、氯化氢等刺激性的有毒烟气。受热分解也能产生 有毒物质。对很多金属尤其是潮湿空气存在下有腐蚀性。','硫化氢、氯化氢、氯气。','消防人员必须穿全身耐酸碱消防服。灭火剂：二氧化碳、砂土。禁止用水。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:31','',NULL),(5745,5880,'高压压缩气体，遇热有爆炸危险。容器受热可能爆炸。暴露于火中的容器可能会通过压力安全阀泄漏出内容物。受热或接触火焰可能会产生膨胀或爆炸性分解。','燃烧或分解时可能产生氟化氢、氯化氢等有毒气体。','合适的灭火介质：干粉、二氧化碳。不合适的灭火介质：避免用太强烈的水汽灭火，因为它可能会使火苗蔓延分散。灭火时，应佩戴呼吸面具（符合MSHA/NIOSH要求的或相当的）并穿上全身防护服。在安全距离处、有充足防护的情况下灭火。防止消防水污染地表和地下水系统。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:32','',NULL),(5746,5881,'磷或金属粉末等混合可形成爆炸性混合物。急剧加热时可发生爆炸。','氯化物、氧化钾。','用大量水扑救，同时用干粉灭火剂闷熄。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:33','',NULL),(5747,5882,'强氧化剂。与可燃物、还原剂、有机物等混合可形成爆炸性混合物。急剧加热时可发生爆炸。遇火源可引起燃烧或爆炸。','氧气、氯化物、氧化钠。','用大量水扑救，同时用干粉灭火剂闷熄。切勿将水流直接射入熔融物质，以免引起严重的流淌火灾或剧烈的沸溅。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:33','',NULL),(5748,5883,'强氧化剂，与可燃物、还原剂等接触可能发生剧烈反应，甚至引起燃烧或爆炸。在火场中与可燃物混合会爆炸。加热时，容器可能爆炸。暴露于火中的容器可能会通过压力安全阀泄漏出内容物。受热或接触火焰可能会产生膨胀或爆炸性分解。','分解产生碘蒸气、氧化碘等有毒气体。','合适的灭火介质：雾状水、砂土。不合适的灭火介质：无特别说明。灭火方法：喷水冷却容器，可能的话将容器从火场移至空旷处。在火场中与可燃物混合会爆炸，消防人员须在有防爆掩蔽处操作。切勿将水流直接射至熔融物，以免引起严重的流淌火灾或引起剧烈的沸溅。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:34','',NULL),(5749,5884,'强氧化剂，与可燃物、还原剂等接触可能发生剧烈反应，甚至引起燃烧或爆炸。在火场中与可燃物混合会爆炸。加热时，容器可能爆炸。暴露于火中的容器可能会通过压力安全阀泄漏出内容物。受热或接触火焰可能会产生膨胀或爆炸性分解。','碘化氢','合适的灭火介质：雾状水、砂土。不合适的灭火介质：无特别说明。灭火方法：喷水冷却容器，可能的话将容器从火场移至空旷处。在火场中与可燃物混合会爆炸，消防人员须在有防爆掩蔽处操作。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:35','',NULL),(5750,5885,'强氧化剂，与可燃物、还原剂、有机物等接触可引起燃烧爆炸。受热或遇酸分解产生有毒和腐蚀性的氯气。加热时，容器可能爆炸。','氯气、氯化氢等。','灭火剂：雾状水、泡沫、干粉、二氧化碳。禁止使用酸碱灭火器。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:35','',NULL),(5751,5886,'高度易燃液体，其蒸气与空气混合，能形成爆炸性混合物。遇明火、高热极易引起燃烧爆炸。容器可能爆炸。暴露于火中的容器可能会通过压力安全阀泄漏出内容物。','一氧化碳、二氧化碳。','灭火剂：干粉、二氧化碳、泡沫。尽可能将容器从火场移至空旷处。喷水保持火场容器冷却，直至灭火结束。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:37','',NULL),(5752,5887,'热时分解产生有毒的光气和腐蚀性的盐酸烟雾。','一氧化碳、二氧化碳、氯化氢、光气。 消防人员须佩戴氧气呼吸器。喷水保持火场容器冷却，直至灭火结束。灭火剂：雾状水、泡沫、','干粉、二氧化碳、砂土。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:38','',NULL),(5753,5888,'受热分解产生有毒的砷氧化物烟雾。遇明火、高热可燃。与还原剂、金属粉末等可发生反应。','砷氧化物、氧化钾、氮氧化物等有毒烟雾','干粉、二氧化碳、泡沫。灭火时，应佩戴呼吸面具（符合MSHA/NIOSH要求的或相当的）并穿上全身防护服。在安全距离处、有充足防护的情况下灭火。防止消防水污染地表和地下水系统。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:40','',NULL),(5754,5889,'具有强氧化性。其水溶液有腐蚀性和强烈的刺激性。与有机物、还原剂、易燃物如硫、磷等接触有燃烧爆炸危险。','氧化硒、二氧化硒等有毒烟雾。','消防人员必须穿全身耐酸碱消防服。灭火剂：雾状水、砂土。禁止使用直流水。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:43','',NULL),(5755,5890,'遇高热、明火、氧化剂有引起着火、爆炸危险。受热分解产生有毒气体。其蒸气与空气可形成爆炸性混合物，遇明火、高热极易燃烧爆炸。','一氧化碳、二氧化碳、氮氧化物等有毒气体。','合适的灭火介质：干粉、二氧化碳、耐醇泡沫或水喷雾。不合适的灭火介质：避免用太强烈的水汽灭火，因为它可能会使火苗蔓延分散。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:44','',NULL),(5756,5891,'强氧化剂。受强烈震动也会起爆。急剧加热时可发生爆炸。与还原剂、有机物、易燃物如硫、磷或金属粉末等混合可形成爆炸性混合物。接触火焰可能会产生膨胀或爆炸性分解。','氮氧化物','消防人员须佩戴防毒面具、穿全身消防服，在上风向灭火。切勿将水流直接射至熔融物，以免引起严重的流淌火灾或引起剧烈的沸溅。遇大火，消防人员须在有防护掩蔽处操作。灭火剂：水、雾状水。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:44','',NULL),(5757,5892,'粉末与空气能形成爆炸性混合物，易被明火点燃引起爆炸，潮湿粉尘在空气中易自行发热燃烧。','氧化锌','采用干粉、干砂灭火。禁止用水和泡沫灭火。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:46','',NULL),(5758,5893,'遇火或摩擦极易引燃，其粉体与空气混合，能形成爆炸性混合物。加热时，容器可能爆炸。暴露于火中的容器可能会通过压力安全阀泄漏出内容物。受热或接触火焰可能会产生膨胀或爆炸性分解。','一氧化碳、二氧化碳、氮氧化物','干粉、二氧化碳、水喷雾或耐醇泡沫。避免用太强烈的水汽灭火，因为它可能会使火苗蔓延分散。尽可能将容器从火场移至空旷处。喷水保持火场容器冷却，直至灭火结束。灭火时，应佩戴呼吸面具（符合MSHA/NIOSH要求的或相当的）并穿上全身防护服。在安全距离处、有充足防护的情况下灭火。防止消防水污染地表和地下水系统。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:48','',NULL);
/*!40000 ALTER TABLE `msds_fire_fighting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msds_leak_response`
--

DROP TABLE IF EXISTS `msds_leak_response`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `msds_leak_response` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
  `personal_precautions` text COMMENT '个人防护措施',
  `environmental_precautions` text COMMENT '环境保护措施',
  `containment_cleanup` text COMMENT '泄漏化学品的收容、清除方法',
  `emergency_procedures` text COMMENT '应急处理程序',
  `elimination_methods` text COMMENT '消除方法',
  `equipment_materials` text COMMENT '清理时使用的器材',
  `prevent_secondary_hazards` text COMMENT '防止发生次生危害的预防措施',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  CONSTRAINT `msds_leak_response_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5751 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='泄漏应急处理表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msds_leak_response`
--

LOCK TABLES `msds_leak_response` WRITE;
/*!40000 ALTER TABLE `msds_leak_response` DISABLE KEYS */;
INSERT INTO `msds_leak_response` (`id`, `msds_id`, `personal_precautions`, `environmental_precautions`, `containment_cleanup`, `emergency_procedures`, `elimination_methods`, `equipment_materials`, `prevent_secondary_hazards`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (5724,5867,NULL,NULL,NULL,'泄漏量较大时，应立即报警119。处理人员应穿戴适当的个人防护装备。禁止直接接触泄漏物。',NULL,NULL,NULL,NULL,'2026-03-11 07:59:07','',NULL),(5725,5868,NULL,NULL,NULL,'疏散泄漏污染区人员至安全区，禁止无关人员进入污染区，切断火源。建议应急处理人员戴好 防毒面具，穿化学防护服。禁止泄漏物进入受限制的空间(如下水道等)，以避免发生爆炸。用 应急处理： 活性炭或其它惰性材料吸收，使用不产生火花的工具收集于密闭容器中作好标记，等待处理。 用水刷洗泄漏污染区，对污染地带进行通风。如大量泄漏，利用围堤收容，然后收集、转移、 回收或无害处理后废弃。',NULL,NULL,NULL,NULL,'2026-03-11 07:59:08','',NULL),(5726,5869,NULL,NULL,NULL,'隔离泄漏污染区，限制出入。切断火源。建议应急处理人员戴防尘面具（全面罩），穿防 应急处理： 毒服。小量泄漏：用洁净的铲子收集于干燥、洁净、有盖的容器中。大量泄漏：收集回收',NULL,NULL,NULL,NULL,'2026-03-11 07:59:10','',NULL),(5727,5870,NULL,NULL,NULL,'保证充分的通风。清除所有点火源。迅速将人员撤离到安全区域，远离泄漏区域并处于上风方向。采取措施防止进一步的泄漏或溢出。避免排放到周围环境中。少量泄漏时，可采用干砂或惰性吸附材料吸收泄漏物，大量泄漏时需筑堤控制。附着物或收集物应存放在合适的密闭容器中，并根据当地相关法律法规废弃处置。清除所有点火源，并采用防火花工具和防爆设备。',NULL,NULL,NULL,NULL,'2026-03-11 07:59:11','',NULL),(5728,5871,NULL,NULL,NULL,'疏散泄漏污染区人员至安全区，禁止无关人员进入污染区，切断火源。应急处理人员戴自给式呼吸器，穿化学防护服。在确保安全情况下堵漏。',NULL,NULL,NULL,NULL,'2026-03-11 07:59:11','',NULL),(5729,5872,NULL,NULL,NULL,'保证充分的通风。清除所有点火源。迅速将人员撤离到安全区域，远离泄漏区域并处于上风位置。采取措施防止进一步的泄漏或溢出。避免排放到周围环境中。少量泄漏时，可采用干砂或惰性吸附材料吸收泄漏物，大量泄漏时需筑堤控制。附着物或收集物应存放在合适的密闭容器中，并根据当地相关法律法规废弃处置。清除所有点火源，并采用防火花工具和防爆设备。',NULL,NULL,NULL,NULL,'2026-03-11 07:59:14','',NULL),(5730,5873,NULL,NULL,NULL,'隔离泄漏污染区，周围设警告标志，建议应急处理人员戴自给式呼吸器，穿化学防护服。 不要直接接触泄漏物，避免扬尘，收集于干燥净洁有盖的容器中，转移到安全场所。也可 以用大量水冲洗，经稀释的洗水放入废水系统。对污染地带进行通风。如大量泄漏，收集 回收或无害处理后废弃。',NULL,NULL,NULL,NULL,'2026-03-11 07:59:15','',NULL),(5731,5874,NULL,NULL,NULL,'迅速撤离泄漏污染区人员至上风处，并隔离直至气体散尽，切断火源。建议应急处理人员戴自给式呼吸器，穿厂商特别推荐的化学防护服。切断气源，用含盐酸的雾状水中和、稀释，然后排入废水系统。也可以用大量水喷淋稀释，然后排入废水系统。如大量泄漏，利用围堤收容，然后收集、转移、回收或无害化处理。',NULL,NULL,NULL,NULL,'2026-03-11 07:59:15','',NULL),(5732,5875,NULL,NULL,NULL,'隔离泄漏污染区，限制出入。建议应急处理人员戴防尘面具（全面罩），穿防毒服。勿使 泄漏物与有机物、还原剂、易燃物接触。小量泄漏：用干石灰、苏打灰覆盖，收集于密闭 容器中。也可以用大量水冲洗，洗水稀释后放入废水系统。大量泄漏：收集回收或运至废',NULL,NULL,NULL,NULL,'2026-03-11 07:59:20','',NULL),(5733,5876,NULL,NULL,NULL,'应急人员佩戴正压自给式呼吸器，穿防毒服。消除所有点火源。根据液体流动和蒸气扩散的影响区域划定警戒区，无关人员从侧风、上风向撤离至安全区。建议应急处理人员戴正压自给式呼吸器，穿防静电服。作业时使用的工具应为无火花工具。尽可能切断泄漏源。防止流入下水道、排洪沟等限制性空间。小量泄漏：用砂土或其它不燃材料吸附或吸收。大量泄漏：构筑围堤或挖坑收容。用泡沫覆盖，降低蒸气灾害。用防爆泵转移至槽车或专用收集器内，回收或运至废物处理场所处置。',NULL,NULL,NULL,NULL,'2026-03-11 07:59:23','',NULL),(5734,5877,NULL,NULL,NULL,'保证充分的通风。清除所有点火源。迅速将人员撤离到安全区域，远离泄漏区域并处于上风向。采取措施防止进一步的泄漏或溢出。避免排放到周围环境中。少量泄漏时，可采用干砂或惰性吸附材料吸收泄漏物，大量泄漏时需筑堤控制。附着物或收集物应存放在合适的密闭容器中，并根据当地相关法律法规废弃处置。清除所有点火源，并采用防火花工具和防爆设备。',NULL,NULL,NULL,NULL,'2026-03-11 07:59:25','',NULL),(5735,5878,NULL,NULL,NULL,'迅速将人员撤离到安全区域，远离泄漏区域并处于上风方向。使用防爆工具。清除所有点火源。避免排放到周围环境中。',NULL,NULL,NULL,NULL,'2026-03-11 07:59:28','',NULL),(5736,5879,NULL,NULL,NULL,'迅速撤离泄漏污染区人员至安全区，并进行隔离，严格限制出入。建议应急处理人员戴自给正 压式呼吸器，穿防酸碱工作服。从上风处进入现场。尽可能切断泄漏源。小量泄漏：用砂土或 其它不燃材料吸附或吸收。大量泄漏：构筑围堤或挖坑收容。在专家指导下清除。',NULL,NULL,NULL,NULL,'2026-03-11 07:59:31','',NULL),(5737,5880,NULL,NULL,NULL,'保证充分的通风。清除所有点火源。迅速将人员撤离到安全区域，远离泄漏区域并处于上风。应急处理措施防止进一步的泄漏或溢出。避免排放到周围环境中。少量泄漏时，可采用干砂或惰性吸附材料吸收泄漏物，大量泄漏时需筑堤控制。附着物或收集物应存放在合适的密闭容器中，并根据当地相关法律法规废弃处置。清除所有点火源，并采用防火花工具和防暴设备。',NULL,NULL,NULL,NULL,'2026-03-11 07:59:32','',NULL),(5738,5881,NULL,NULL,NULL,'隔离泄漏污染区，限制出入。建议应急处理人员戴防尘面具（全面罩），穿防毒服。不要直接接触泄漏物。勿使泄漏物与有机物、还原剂、易燃物接触。小量泄漏：用洁净的铲子收集于干燥、洁净、有盖的容器中。大量泄漏：用塑料布、帆布覆盖。然后收集回收或运至废物处理场所处置。',NULL,NULL,NULL,NULL,'2026-03-11 07:59:33','',NULL),(5739,5882,NULL,NULL,NULL,'隔离泄漏污染区，限制出入。建议应急处理人员戴防尘面具（全面罩），穿防毒服。不要 直接接触泄漏物。勿使泄漏物与有机物、还原剂、易燃物接触。小量泄漏：避免扬尘，用 洁净的铲子收集于干燥、洁净、有盖的容器中。大量泄漏：收集回收或运至废物处理场所',NULL,NULL,NULL,NULL,'2026-03-11 07:59:33','',NULL),(5740,5883,NULL,NULL,NULL,'保证充分的通风。清除所有点火源。迅速将人员撤离到安全区域，远离泄漏区域并处于上风 应急处理： 措施防止进一步的泄漏或溢出。避免排放到周围环境中。少量泄漏时，可采用干砂或惰性吸 附材料吸收泄漏物，大量泄漏时需筑堤控制。附着物或收集物应存放在合适的密闭容器中， 并根据当地相关法律法规废弃处置。清除所有点火源，并采用防火花工具和防暴设备。',NULL,NULL,NULL,NULL,'2026-03-11 07:59:35','',NULL),(5741,5884,NULL,NULL,NULL,'保证充分的通风。清除所有点火源。迅速将人员撤离到安全区域，远离泄漏区域并处于上风处。采取防止进一步的泄漏或溢出的措施。避免排放到周围环境中。少量泄漏时，可采用干砂或惰性吸附材料吸收泄漏物，大量泄漏时需筑堤控制。附着物或收集物应存放在合适的密闭容器中，并根据当地相关法律法规废弃处置。清除所有点火源，并采用防火花工具和防爆设备。',NULL,NULL,NULL,NULL,'2026-03-11 07:59:35','',NULL),(5742,5885,NULL,NULL,NULL,'迅速将人员撤离到安全区域，远离泄漏区域并处于上风方向。使用防爆工具。清除所有点火源。避免排放到周围环境中。',NULL,NULL,NULL,NULL,'2026-03-11 07:59:35','',NULL),(5743,5886,NULL,NULL,NULL,'迅速将人员撤离到安全区域，远离泄漏区域并处于上风方向。使用防爆工具。清除所有点火源。避免排放到周围环境中。',NULL,NULL,NULL,NULL,'2026-03-11 07:59:37','',NULL),(5744,5887,NULL,NULL,NULL,'迅速撤离泄漏污染区人员至安全区，并进行隔离，严格限制出入。切断火源。建议应急处理人 应急处理： 员戴自给正压式呼吸器，穿防毒服。尽可能切断泄漏源。防止流入下水道、排洪沟等限制性空 间。小量泄漏：用砂土或其它不燃材料吸附或吸收。大量泄漏：构筑围堤或挖坑收容。用泡沫 覆盖，降低蒸气灾害。用泵转移至槽车或专用收集器内，回收或运至废物处理场所处置。',NULL,NULL,NULL,NULL,'2026-03-11 07:59:38','',NULL),(5745,5888,NULL,NULL,NULL,'应急处理人员必须佩戴正压自给式呼吸器，穿全身防毒服。不要触摸或穿越泄漏物。保证充分的通风。清除所有点火源。采取防静电措施。迅速将人员撤离到安全区域，远离泄漏区域并处于上风方向。',NULL,NULL,NULL,NULL,'2026-03-11 07:59:40','',NULL),(5746,5889,NULL,NULL,NULL,'隔离泄漏污染区，限制出入。建议应急处理人员戴防尘面具（全面罩），穿防酸碱工作服。不要直接接触泄漏物。',NULL,NULL,NULL,NULL,'2026-03-11 07:59:43','',NULL),(5747,5890,NULL,NULL,NULL,'保证充分的通风。清除所有点火源。迅速将人员撤离到安全区域，远离泄漏区域并处于上风。应急处理措施防止进一步的泄漏或溢出。避免排放到周围环境中。少量泄漏时，可采用干砂或惰性吸附材料吸收泄漏物，大量泄漏时需筑堤控制。附着物或收集物应存放在合适的密闭容器中，并根据当地相关法律法规废弃处置。清除所有点火源，并采用防火花工具和防暴设备。',NULL,NULL,NULL,NULL,'2026-03-11 07:59:44','',NULL),(5748,5891,NULL,NULL,NULL,'隔离泄漏污染区，限制出入。建议应急处理人员戴防尘面具（全面罩），穿防毒服。不要直接接触泄漏物。勿使泄漏物与还原剂、有机物、易燃物或金属粉末接触。小量泄漏：小心扫起，收集于干燥、洁净、有盖的容器中。大量泄漏：收集回收或运至废物处理场所处置。',NULL,NULL,NULL,NULL,'2026-03-11 07:59:44','',NULL),(5749,5892,NULL,NULL,NULL,'隔离泄漏污染区，限制出入。切断火源。建议应急处理人员戴自给正压式呼吸器，穿防静电工作服。不要直接接触泄漏物。小量泄漏：避免扬尘，使用无火花工具收集于干燥、洁净、有盖的容器中。转移回收。大量泄漏：用塑料布、帆布覆盖。在专家指导下清除。',NULL,NULL,NULL,NULL,'2026-03-11 07:59:46','',NULL),(5750,5893,NULL,NULL,NULL,'保证充分的通风。清除所有点火源。迅速将人员撤离到安全区域，远离泄漏区域并处于上风位置。采取措施防止进一步的泄漏或溢出。避免排放到周围环境中。少量泄漏时，可采用干砂或惰性吸附材料吸收泄漏物，大量泄漏时需筑堤控制。附着物或收集物应存放在合适的密闭容器中，并根据当地相关法律法规废弃处置。清除所有点火源，并采用防火花工具和防爆设备。',NULL,NULL,NULL,NULL,'2026-03-11 07:59:48','',NULL);
/*!40000 ALTER TABLE `msds_leak_response` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msds_handling_storage`
--

DROP TABLE IF EXISTS `msds_handling_storage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `msds_handling_storage` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
  `handling_precautions` text COMMENT '操作注意事项',
  `storage_precautions` text COMMENT '储存注意事项',
  `optimal_temperature` varchar(50) DEFAULT NULL COMMENT '最佳储存温度',
  `temperature_range` varchar(50) DEFAULT NULL COMMENT '储存温度范围',
  `humidity_requirements` varchar(50) DEFAULT NULL COMMENT '湿度要求',
  `storage_container` text COMMENT '储存容器要求',
  `incompatible_materials` text COMMENT '不相容的物质',
  `storage_area_requirements` text COMMENT '储存区域要求',
  `shelf_life` varchar(50) DEFAULT NULL COMMENT '保质期',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  CONSTRAINT `msds_handling_storage_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5759 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='操作处置与储存表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msds_handling_storage`
--

LOCK TABLES `msds_handling_storage` WRITE;
/*!40000 ALTER TABLE `msds_handling_storage` DISABLE KEYS */;
INSERT INTO `msds_handling_storage` (`id`, `msds_id`, `handling_precautions`, `storage_precautions`, `optimal_temperature`, `temperature_range`, `humidity_requirements`, `storage_container`, `incompatible_materials`, `storage_area_requirements`, `shelf_life`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (5732,5867,'密闭操作，提供充分的局部排风。防止蒸气泄漏到工作场所空气中。操作人员必须经过专门培训，严格遵守操作规程。建议操作人员佩戴化学安全防护眼镜，穿防静电工作服，戴橡胶耐油手套。远离火种、热源，工作场所严禁吸烟。使用防爆型的通风系统和设备。避免产生粉尘。避免与氧化剂、还原剂、酸类、碱类接触。搬运时要轻装轻卸，防止包装及容器损坏。配备相应品种和数量的消防器材及泄漏应急处理设备。','储存于阴凉、通风的库房。远离火种、热源。库温不宜超过30℃。保持容器密封。应与氧化剂、还原剂、酸类、碱类分开存放，切忌混储。采用防爆型照明、通风设施。禁止使用易产生火花的机械设备和工具。储区应备有泄漏应急处理设备和合适的收容材料。储存区应设置\"易燃\"、\"危险\"等警示标识。储存容器必须接地，防止静电积聚。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:07','',NULL),(5733,5868,'无资料','储存于阴凉、通风仓间内。远离火种、热源。防止阳光曝晒。仓温不宜超过30℃。应与氧化 剂分开存放。储存间内的照明、通风等设施应采用防爆型，开关设在仓外。禁止使用易产生 火花的机械设备和工具。配备相应品种和数量的消防器材。充装要控制流速，注意防止静电 积聚。罐储时要有防火防爆技术措施。操作现场不得吸烟、饮水、进食。搬运时要轻装轻卸， 防止包装及容器损坏。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:08','',NULL),(5734,5869,'热源，工作场所严禁吸烟。使用防爆型的通风系统和设备。避免产生粉尘。避免与氧化剂、','操作人员佩戴头罩型电动送风过滤式防尘呼吸器，穿胶布防毒衣，戴橡胶手套。远离火种、 酸类接触。搬运时要轻装轻卸，防止包装及容器损坏。配备相应品种和数量的消防器材及 泄漏应急处理设备。倒空的容器可能残留有害物。 储存于阴凉、通风的库房。远离火种、热源。包装密封。应与氧化剂、酸类、食用化学品 分开存放，切忌混储。配备相应品种和数量的消防器材。储区应备有合适的材料收容泄漏 物。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:10','',NULL),(5735,5870,'密闭操作，提供充分的局部排风。操作人员必须经过专门培训，严格遵守操作规程。建议操作人员佩戴自吸过滤式防毒面具（半面罩），戴化学安全防护眼镜，穿防毒物渗透工作服，戴橡胶耐油手套。远离火种、热源，工作场所严禁吸烟。使用防爆型的通风系统和设备。防止蒸气泄漏到工作场所空气中。避免与氧化剂、酸类、碱类、金属粉末、还原剂接触。充装要控制流速，防止静电积聚。搬运时要轻装轻卸，防止包装及容器损坏。配备相应品种和数量的消防器材及泄漏应急处理设备。倒空的容器可能残留有害物。','储存于阴凉、通风的库房。远离火种、热源。库温不宜超过30℃。保持容器密封。应与氧化剂、酸类、碱类、金属粉末、还原剂分开存放，切忌混储。采用防爆型照明、通风设施。禁止使用易产生火花的机械设备和工具。储区应备有泄漏应急处理设备和合适的收容材料。储存温度不得超过30℃。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:11','',NULL),(5736,5871,'无资料','通常商品加有阻聚剂。储存于阴凉、通风仓间内。远离火种、热源。仓温不宜超过30℃，防 止阳光直射。包装要求密封，不可与空气接触。应与氧化剂分开存放。储存间内的照明、通 风等设施应采用防爆型。罐储时要有防火防爆技术措施。禁止使用易产生火花的机械设备和 工具。搬运时要轻装轻卸，防止包装及容器损坏。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:11','',NULL),(5737,5872,'在通风良好处进行操作。穿戴合适的个人防护用具。避免接触皮肤和进入眼睛。远离热源、火花、明火和热表面。采取措施防止静电积累。操作后彻底清洗。避免吸入蒸气、烟雾或气体。避免与氧化剂接触。','保持容器密闭。储存在干燥、阴凉和通风处。远离热源、火花、明火和热表面。存储于远离不相容材料和食品容器的地方。与氧化剂分开存放。储存区域应配备适当的防火设施。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:14','',NULL),(5738,5873,'无资料','储存于阴凉、通风仓间内。远离火种、热源。专人保管。包装密封。防潮、防晒。应与氧 化剂、食用化工原料分开存放。不能与粮食、食物、种子、饲料、各种日用品混装、混运。 操作现场不得吸烟、饮水、进食。搬运时轻装轻卸，保持包装完整，防止洒漏。分装和搬 运作业要注意个人防护。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:15','',NULL),(5739,5874,'密闭操作，提供充分的局部排风。操作人员必须经过专门培训，严格遵守操作规程。建议操作人员佩戴自吸过滤式防毒面具（半面罩），戴化学安全防护眼镜，穿防静电工作服，戴橡胶手套。远离火种、热源。工作场所严禁吸烟。使用防爆型的通风系统和设备。防止气体泄漏到工作场所空气中。避免与氧化剂、酸类、卤素接触。搬运时轻装轻卸，防止钢瓶及附件破损。配备相应品种和数量的消防器材及泄漏应急处理设备。','储存于阴凉、通风的库房。远离火种、热源。库温不宜超过30℃。应与氧化剂、酸类、卤素分开存放，切忌混储。采用防爆型照明、通风设施。禁止使用易产生火花的机械设备和工具。储区应备有泄漏应急处理设备。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:15','',NULL),(5740,5875,'工作场所严禁吸烟。远离易燃、可燃物。避免产生粉尘。避免与活性金属粉末接触。搬运','戴头罩型电动送风过滤式防尘呼吸器，穿聚乙烯防毒服，戴橡胶手套。远离火种、热源， 时要轻装轻卸，防止包装及容器损坏。配备相应品种和数量的消防器材及泄漏应急处理设 备。倒空的容器可能残留有害物。 储存于阴凉、通风的库房。远离火种、热源。包装必须密封，切勿受潮。应与易（可）燃 物、活性金属粉末等分开存放，切忌混储。储区应备有合适的材料收容泄漏物。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:20','',NULL),(5741,5876,'操作人员必须经过专门培训，严格遵守操作规程。建议操作人员佩戴自吸过滤式防毒面具（半面罩），戴化学安全防护眼镜，穿防静电工作服，戴橡胶耐油手套。远离火种、热源，工作场所严禁吸烟。使用防爆型的通风系统和设备。防止蒸气泄漏到工作场所空气中。避免与氧化剂、酸类接触。灌装时应控制流速，且有接地装置，防止静电积聚。配备相应品种和数量的消防器材及泄漏应急处理设备。','储存于阴凉、通风的库房。远离火种、热源。库温不宜超过29℃。包装要求密封，不可与空气接触。应与氧化剂、酸类等分开存放，切忌混储。采用防爆型照明、通风设施。禁止使用易产生火花的机械设备和工具。储区应备有泄漏应急处理设备和合适的收容材料。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:23','',NULL),(5742,5877,'密闭操作，提供充分的局部排风。操作人员必须经过专门培训，严格遵守操作规程。远离火种、热源，工作场所严禁吸烟。防止蒸气泄漏到工作场所空气中。避免与氧化剂、还原剂、酸类、碱类接触。在传送过程中，容器必须接地和跨接，防止产生静电。搬运时轻装轻卸，防止容器损坏。配备相应品种和数量的消防器材及泄漏应急处理设备。','远离火花、明火和热表面。采取措施防止静电积累。保持容器密闭。储存在干燥、阴凉和通风处。远离热源、火花、明火和热表面。存储于远离不相容材料和食品容器的地方。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:25','',NULL),(5743,5878,'密闭操作，局部排风。操作人员必须经过专门培训，严格遵守操作规程。建议操作人员佩戴自吸过滤式防毒面具（半面罩），戴化学安全防护眼镜，穿防毒物渗透工作服，戴橡胶手套。远离火种、热源，工作场所严禁吸烟。避免产生蒸气或雾滴。搬运时要轻装轻卸，防止包装及容器损坏。配备相应品种和数量的消防器材及泄漏应急处理设备。倒空的容器可能残留有害物。','储存于阴凉、通风的库房。远离火种、热源。包装要求密封，切勿受潮。储区应备有泄漏应急处理设备和合适的收容材料。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:28','',NULL),(5744,5879,'所空气中。避免与碱类接触。尤其要注意避免与水接触。搬运时要轻装轻卸，防止包装及容器','吸过滤式防毒面具（全面罩），穿橡胶耐酸碱服，戴橡胶耐酸碱手套。防止蒸气泄漏到工作场 损坏。配备泄漏应急处理设备。倒空的容器可能残留有害物。 储存于阴凉、通风的库房。库温不超过25℃，相对湿度不超过75％。保持容器密封。应与碱类 等分开存放，切忌混储。储区应备有泄漏应急处理设备和合适的收容材料。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:31','',NULL),(5745,5880,'操作人员必须经过专门培训，严格遵守操作规程。操作处置应在具备局部通风或全面通风换气设施的场所进行。避免眼、皮肤接触，避免吸入气体。操作人员佩戴自吸过滤式防毒面具（半面罩），戴化学安全防护眼镜，穿防静电工作服，戴防化学品手套。工作现场严禁吸烟。使用防爆型的通风系统和设备。防止气体泄漏到工作场所空气中。避免与氧化剂、还原剂接触。搬运时要轻装轻卸，防止包装及容器损坏。配备相应品种和数量的消防器材及泄漏应急处理设备。','储存于阴凉、通风的库房。远离火种、热源。库温不宜超过30℃。应与氧化剂、还原剂分开存放，切忌混储。采用防爆型照明、通风设施。禁止使用易产生火花的机械设备和工具。储区应备有泄漏应急处理设备和合适的收容材料。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:32','',NULL),(5746,5881,'密闭操作，提供充分的局部排风。远离火种、热源。工作场所严禁吸烟。远离易燃、可燃物。避免产生粉尘。避免与还原剂、酸类、醇类接触。搬运时要轻装轻卸，防止包装及容器损坏。禁止震动、撞击和摩擦。配备相应品种和数量的消防器材及泄漏应急处理设备。倒空的容器可能残留有害物。','储存于阴凉、通风的库房。远离火种、热源。库温不超过30℃，相对湿度不超过80%。包装密封。应与易（可）燃物、还原剂、酸类、醇类等分开存放，切忌混储。储区应备有合适的材料收容泄漏物。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:33','',NULL),(5747,5882,'密闭操作，提供充分的局部排风。操作人员必须经过专门培训，严格遵守操作规程。建议操作人员佩戴自吸过滤式防尘口罩（半面罩），戴化学安全防护眼镜，穿聚乙烯防毒服，戴橡胶手套。远离火种、热源，工作场所严禁吸烟。远离易燃、可燃物。避免产生粉尘。避免与还原剂、醇类接触。搬运时要轻装轻卸，防止包装及容器损坏。禁止震动、撞击和摩擦。配备相应品种和数量的消防器材及泄漏应急处理设备。倒空的容器可能残留有害物。','储存于阴凉、通风的库房。远离火种、热源。包装密封。应与易（可）燃物、还原剂、醇类等分开存放，切忌混储。储区应备有合适的材料收容泄漏物。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:33','',NULL),(5748,5883,'操作人员必须经过专门培训，严格遵守操作规程。远离火种、热源。建议操作人员佩戴自吸过滤式防尘口罩，戴化学安全防护眼镜，穿防静电工作服，戴橡胶手套。避免产生粉尘。避免与还原剂、有机物、易燃物等接触。搬运时要轻装轻卸，防止包装及容器损坏。配备相应品种和数量的消防器材及泄漏应急处理设备。倒空的容器可能残留有害物。','储存于阴凉、通风的库房。远离火种、热源。库温不宜超过37℃。包装要求密封，不可与空气接触。应与还原剂、有机物、易燃物、食用化学品分开存放，切忌混储。储区应备有合适的材料收容泄漏物。存放处须加锁。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:35','',NULL),(5749,5884,'操作人员必须经过专门培训，严格遵守操作规程。远离火种、热源。建议操作人员佩戴自吸过滤式防尘口罩，戴化学安全防护眼镜，穿防静电工作服，戴橡胶手套。避免产生粉尘。避免与还原剂、有机物、易燃物等接触。搬运时要轻装轻卸，防止包装及容器损坏。配备相应品种和数量的消防器材及泄漏应急处理设备。倒空的容器可能残留有害物。','储存于阴凉、通风的库房。远离火种、热源。库温不宜超过37℃。包装要求密封，不可与空气接触。应与还原剂、有机物、易燃物、食用化学品分开存放，切忌混储。储区应备有合适的材料收容泄漏物。存放处须加锁。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:35','',NULL),(5750,5885,'密闭操作，局部排风。操作人员必须经过专门培训，严格遵守操作规程。建议操作人员佩戴自吸过滤式防毒面具（半面罩），戴化学安全防护眼镜，穿防毒物渗透工作服，戴橡胶手套。远离火种、热源，工作场所严禁吸烟。避免与还原剂、酸类、易（可）燃物、铵盐、胺类等接触。搬运时要轻装轻卸，防止包装及容器损坏。配备相应品种和数量的消防器材及泄漏应急处理设备。倒空的容器可能残留有害物。','储存于阴凉、通风的库房。远离火种、热源。库温不宜超过30℃。包装要求密封。应与还原剂、酸类、易（可）燃物、铵盐、胺类等分开存放，切忌混储。储区应备有泄漏应急处理设备和合适的收容材料。禁止震动、撞击和摩擦。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:35','',NULL),(5751,5886,'密闭操作，局部排风。操作人员必须经过专门培训，严格遵守操作规程。建议操作人员佩戴自吸过滤式防毒面具（半面罩），戴化学安全防护眼镜，穿防毒物渗透工作服，戴橡胶耐油手套。远离火种、热源，工作场所严禁吸烟。使用防爆型通风系统和设备。防止蒸气泄漏到工作场所空气中。避免与氧化剂接触。搬运时要轻装轻卸，防止包装及容器损坏。配备相应品种和数量的消防器材及泄漏应急处理设备。倒空的容器可能残留有害物。','储存于阴凉、通风的库房。远离火种、热源。库温不宜超过37℃。包装要求密封。应与氧化剂、酸类、碱类分开存放，切忌混储。储区应备有泄漏应急处理设备和合适的收容材料。采用防爆型照明、通风设施。禁止使用易产生火花的机械设备和工具。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:37','',NULL),(5752,5887,'密闭操作，提供充分的局部排风。操作人员必须经过专门培训，严格遵守操作规程。建议操作人员佩戴自吸过滤式防毒面具（半面罩），戴化学安全防护眼镜，穿防毒物渗透工作服，戴防化学品手套。远离火种、热源，工作场所严禁吸烟。使用防爆型的通风系统和设备。防止蒸气泄漏到工作场所空气中。避免与氧化剂、还原剂、碱类、金属粉末接触。搬运时要轻装轻卸，防止包装及容器损坏。配备相应品种和数量的消防器材及泄漏应急处理设备。倒空的容器可能残留有害物。','吸过滤式防毒面具（半面罩），戴化学安全防护眼镜，穿防毒物渗透工作服，戴防化学品手套。 远离火种、热源，工作场所严禁吸烟。使用防爆型的通风系统和设备。防止蒸气泄漏到工作场 所空气中。避免与氧化剂、还原剂、碱类、金属粉末接触。搬运时要轻装轻卸，防止包装及容 器损坏。配备相应品种和数量的消防器材及泄漏应急处理设备。倒空的容器可能残留有害物。 储存于阴凉、通风的库房。远离火种、热源。库温不超过25℃，相对湿度不超过75％。包装要 求密封，不可与空气接触。应与氧化剂、还原剂、碱类、金属粉末、食用化学品分开存放，切 忌混储。不宜大量储存或久存。配备相应品种和数量的消防器材。储区应备有泄漏应急处理设 备和合适的收容材料。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:38','',NULL),(5753,5888,'操作人员必须经过专门培训，严格遵守操作规程。操作时应在通风良好的地方进行。避免吸入粉尘、烟雾。避免与眼睛、皮肤接触。操作后彻底清洗。配备泄漏应急处理设备和合适的收容材料。工作场所严禁吸烟、进食和饮水。','储存于阴凉、干燥、通风良好的库房。远离火种、热源。保持容器密闭。应与还原剂、金属粉末、酸类、食用化学品分开存放，切忌混储。储区应备有泄漏应急处理设备和合适的收容材料。采取措施防止静电积累。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:40','',NULL),(5754,5889,'密闭操作，注意通风。操作尽可能机械化、自动化。操作人员必须经过专门培训，严格遵守操作规程。建议操作人员佩戴头罩型电动送风过滤式防尘呼吸器，穿橡胶耐酸碱服，戴橡胶耐酸碱手套。避免产生粉尘。避免与氧化剂、碱类接触。搬运时要轻装轻卸，防止包装及容器损坏。配备泄漏应急处理设备。倒空的容器可能残留有害物。','储存于阴凉、干燥、通风良好的库房。远离火种、热源。包装必须密封，切勿受潮。应与氧化剂、碱类分开存放，切忌混储。储区应备有合适的材料收容泄漏物。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:43','',NULL),(5755,5890,'操作人员必须经过专门培训，严格遵守操作规程。建议操作人员佩戴自吸过滤式防毒面具（半面罩），戴安全防护眼镜，穿防静电工作服，戴防化学品手套。远离火种、热源，工作场所严禁吸烟。使用防爆型的通风系统和设备。防止蒸气泄漏到工作场所空气中。避免与氧化剂、活性金属粉末、酸类接触。搬运时要轻装轻卸，防止包装及容器损坏。配备相应品种和数量的消防器材及泄漏应急处理设备。','储存于阴凉、干燥、通风的专用库房。远离火种、热源。库温不宜超过30℃。保持容器密封。应与氧化剂、活性金属粉末、酸类、食用化学品分开存放，切忌混储。采用防爆型照明、通风设施。禁止使用易产生火花的机械设备和工具。储区应备有泄漏应急处理设备和合适的收容材料。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:44','',NULL),(5756,5891,'密闭操作，提供充分的局部排风。操作人员必须经过专门培训，严格遵守操作规程。建议操作人员佩戴自吸过滤式防尘口罩，戴化学安全防护眼镜，穿聚乙烯防毒服，戴橡胶手套。远离火种、热源，工作场所严禁吸烟。远离易燃、可燃物。避免产生粉尘。避免与还原剂、酸类、活性金属粉末接触。搬运时要轻装轻卸，防止包装及容器损坏。配备相应品种和数量的消防器材及泄漏应急处理设备。倒空的容器可能残留有害物。','储存于阴凉、通风的库房。远离火种、热源。应与易（可）燃物、还原剂、酸类、活性金属粉末分开存放，切忌混储。储区应备有合适的材料收容泄漏物。禁止震动、撞击和摩擦。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:44','',NULL),(5757,5892,'密闭操作，提供充分的局部排风。防止粉尘释放到车间空气中。操作人员必须经过专门培训，严格遵守操作规程。建议操作人员佩戴自吸过滤式防尘口罩，戴化学安全防护眼镜，穿防静电工作服。远离火种、热源，工作场所严禁吸烟。避免产生粉尘。避免与氧化剂、酸类、碱类、胺类、氯代烃接触。尤其要注意避免与水接触。搬运时要轻装轻卸，防止包装及容器损坏。配备相应品种和数量的消防器材及泄漏应急处理设备。倒空的容器可能残留有害物。','储存于阴凉、干燥、通风良好的库房。远离火种、热源。库温不超过25℃，相对湿度不超过75％。包装密封。应与氧化剂、酸类、碱类、胺类、氯代烃等分开存放，切忌混储。采用防爆型照明、通风设施。禁止使用易产生火花的机械设备和工具。储区应备有合适的材料收容泄漏物。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:46','',NULL),(5758,5893,'密闭操作，提供充分的局部排风。操作人员必须经过专门培训，严格遵守操作规程。穿戴合适的个人防护用具。避免接触皮肤和进入眼睛。远离热源、火花、明火和热表面。采取措施防止静电积累。搬运时要轻装轻卸，防止包装及容器损坏。配备相应品种和数量的消防器材及泄漏应急处理设备。倒空的容器可能残留有害物。','保持容器密闭。储存在干燥、阴凉和通风处。远离热源、火花、明火和热表面。存储于远离不相容材料和食品容器的地方。应与氧化剂、酸类、碱类等分开存放。储存间内的照明、通风等设施应采用防爆型。禁止使用易产生火花的机械设备和工具。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:48','',NULL);
/*!40000 ALTER TABLE `msds_handling_storage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msds_exposure_control`
--

DROP TABLE IF EXISTS `msds_exposure_control`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `msds_exposure_control` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
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
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  CONSTRAINT `msds_exposure_control_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5713 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='接触控制/个体防护表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msds_exposure_control`
--

LOCK TABLES `msds_exposure_control` WRITE;
/*!40000 ALTER TABLE `msds_exposure_control` DISABLE KEYS */;
INSERT INTO `msds_exposure_control` (`id`, `msds_id`, `occupational_exposure_limit`, `china_mac`, `usa_tlv_twa`, `usa_tlv_stel`, `former_soviet_mac`, `tlv_tn`, `tlv_wn`, `monitoring_method`, `engineering_controls`, `respiratory_protection`, `eye_protection`, `body_protection`, `hand_protection`, `other_protection`, `hygiene_measures`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (5686,5867,NULL,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,'密闭操作，局部排风。提供安全淋浴和洗眼设备。使用防爆型通风系统和设备。设置局部排风装置和全面通风装置。工作场所应设置警示标识。','空气中浓度超标时，佩戴自吸过滤式防毒面具（半面罩）。紧急事态抢救或撤离时，应该佩戴空气呼吸器。','佩戴化学护目镜（符合欧盟EN166或美国NIOSH标准）。','穿阻燃防静电防护服和抗静电的防护靴。','戴橡胶耐油手套。',NULL,NULL,NULL,'2026-03-11 07:59:07','',NULL),(5687,5868,NULL,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,'生产过程密闭，全面通风。','作业工人应戴口罩。高浓度接触时，应该佩戴防毒面具。','戴安全防护眼镜。','穿防静电工作服。','戴防护手套。',NULL,NULL,NULL,'2026-03-11 07:59:08','',NULL),(5688,5869,NULL,'未制定标准',NULL,NULL,NULL,NULL,NULL,NULL,'严加密闭，提供充分的局部排风。提供安全淋浴和洗眼设备。',NULL,'呼吸系统防护中已作防护。','穿胶布防毒衣。','戴橡胶手套。',NULL,NULL,NULL,'2026-03-11 07:59:10','',NULL),(5689,5870,NULL,'0.5 mg/m³（有机过氧化物参考值）',NULL,NULL,NULL,NULL,NULL,NULL,'使用局部排风装置，控制空气中浓度低于职业接触限值。设置应急冲洗设备。','当空气中浓度超过职业接触限值时，佩戴防毒面具（带有机蒸气滤盒）。','佩戴化学护目镜（符合欧盟EN166或美国NIOSH标准）。','穿阻燃防静电防护服和抗静电的防护靴。','佩戴防渗透的化学防护手套（如丁腈橡胶手套）。',NULL,NULL,NULL,'2026-03-11 07:59:11','',NULL),(5690,5871,NULL,'未制订标准',NULL,NULL,NULL,NULL,NULL,NULL,'密闭操作，全面排风。','可能接触其蒸气时，应该佩戴防毒口罩。','戴化学安全防护眼镜。','穿工作服。','戴防护手套。',NULL,NULL,NULL,'2026-03-11 07:59:11','',NULL),(5691,5872,NULL,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,'密闭操作，提供充分的局部排风。提供安全淋浴和洗眼设备','空气中浓度超标时，必须佩戴自吸过滤式防毒面具（半面罩）。紧急事态抢救或撤离时，应该佩戴空气呼吸器','佩戴化学护目镜（符合欧盟EN166或美国NIOSH标准）。','穿阻燃防静电防护服和抗静电的防护靴。','戴橡胶手套或防化学品手套',NULL,NULL,NULL,'2026-03-11 07:59:14','',NULL),(5692,5873,NULL,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,'严加密闭，提供充分的局部排风。尽可能机械化、自动化。',NULL,'戴化学安全防护眼镜。','穿相应的防护服。','戴防化学品手套。',NULL,NULL,NULL,'2026-03-11 07:59:15','',NULL),(5693,5874,NULL,'30mg/m3(氨)',NULL,NULL,NULL,NULL,NULL,NULL,'生产过程密闭，加强通风。提供安全淋浴和洗眼设备。','空气中浓度超标时，佩戴自吸过滤式防毒面具（半面罩）。紧急事态抢救或撤离时，建议佩戴空气呼吸器。','戴化学安全防护眼镜。','穿防静电工作服。','戴橡胶手套。',NULL,NULL,NULL,'2026-03-11 07:59:15','',NULL),(5694,5875,NULL,'未制定标准',NULL,NULL,NULL,NULL,NULL,NULL,'生产过程密闭，全面通风。','可能接触其粉尘时，建议佩戴头罩型电动送风过滤式防尘呼吸器。','呼吸系统防护中已作防护。','穿聚乙烯防毒服。','戴橡胶手套。',NULL,NULL,NULL,'2026-03-11 07:59:20','',NULL),(5695,5876,NULL,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,'密闭操作，提供充分的局部排风和全面通风。提供安全淋浴和洗眼设备。','空气中浓度超标时，佩戴过滤式防毒面具（半面罩）。紧急事态抢救或撤离时，建议佩戴空气呼吸器。','佩戴化学安全防护眼镜。','穿防静电工作服。','戴橡胶耐油手套。',NULL,NULL,NULL,'2026-03-11 07:59:23','',NULL),(5696,5877,NULL,'未制订标准',NULL,NULL,NULL,NULL,NULL,NULL,'密闭操作，局部排风。','空气中浓度超标时，佩戴防毒面具。紧急事态抢救或撤离时，应该佩戴自给式呼吸器。','佩戴化学护目镜（符合欧盟EN166或美国NIOSH标准）。','穿阻燃防静电防护服和抗静电的防护靴。','戴防护手套。',NULL,NULL,NULL,'2026-03-11 07:59:25','',NULL),(5697,5878,NULL,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,'生产过程密闭，加强通风。提供安全淋浴和洗眼设备。','空气中浓度超标时，佩戴自吸过滤式防毒面具（半面罩）。紧急事态抢救或撤离时，应该佩戴空气呼吸器。','戴化学安全防护眼镜。','穿防毒物渗透工作服。','戴橡胶手套。',NULL,NULL,NULL,'2026-03-11 07:59:28','',NULL),(5698,5879,NULL,'未制定标准',NULL,NULL,NULL,NULL,NULL,NULL,'密闭操作，局部排风。','空气中浓度超标时，必须佩戴自吸过滤式防毒面具（全面罩）或隔离式呼吸器。紧急事态抢救','呼吸系统防护中已作防护。','穿橡胶耐酸碱服。','戴橡胶耐酸碱手套。',NULL,NULL,NULL,'2026-03-11 07:59:31','',NULL),(5699,5880,NULL,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,'密闭操作，提供充分的局部排风和全面通风。提供安全淋浴和洗眼设备。','空气中浓度超标时，佩戴自吸过滤式防毒面具（半面罩）。紧急事态抢救或撤离时，建议佩戴空气呼吸器。','佩戴化学护目镜（符合欧盟EN166或美国NIOSH标准）。','穿阻燃防静电防护服和抗静电的防护靴。','戴防化学品手套（如丁基橡胶手套）。',NULL,NULL,NULL,'2026-03-11 07:59:32','',NULL),(5700,5881,NULL,'未制定标准',NULL,NULL,NULL,NULL,NULL,NULL,'生产过程密闭，加强通风。提供安全淋浴和洗眼设备。','可能接触其粉尘时，建议佩戴自吸过滤式防尘口罩。','戴化学安全防护眼镜。','穿聚乙烯防毒服。','戴橡胶手套。',NULL,NULL,NULL,'2026-03-11 07:59:33','',NULL),(5701,5882,NULL,'未制定标准',NULL,NULL,NULL,NULL,NULL,NULL,'生产过程密闭，加强通风。提供安全淋浴和洗眼设备。','可能接触其粉尘时，建议佩戴自吸过滤式防尘口罩。','戴化学安全防护眼镜。','穿聚乙烯防毒服。','戴橡胶手套。',NULL,NULL,NULL,'2026-03-11 07:59:33','',NULL),(5702,5883,NULL,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,'密闭操作，提供充分的局部排风。提供安全淋浴和洗眼设备。','空气中粉尘浓度超标时，必须佩戴自吸过滤式防尘口罩（半面罩）。紧急事态抢救或撤离时，应该佩戴空气呼吸器。','佩戴化学安全防护眼镜。','穿防静电工作服。','戴橡胶手套。',NULL,NULL,NULL,'2026-03-11 07:59:35','',NULL),(5703,5884,NULL,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,'密闭操作，提供充分的局部排风。提供安全淋浴和洗眼设备。','空气中粉尘浓度超标时，必须佩戴自吸过滤式防尘口罩（半面罩）。紧急事态抢救或撤离时，应该佩戴空气呼吸器。','佩戴化学安全防护眼镜。','穿防静电工作服。','戴橡胶手套。',NULL,NULL,NULL,'2026-03-11 07:59:35','',NULL),(5704,5885,NULL,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,'生产过程密闭，加强通风。提供安全淋浴和洗眼设备。','空气中浓度超标时，佩戴自吸过滤式防毒面具（半面罩）。紧急事态抢救或撤离时，应该佩戴空气呼吸器。','戴化学安全防护眼镜。','穿防毒物渗透工作服。','戴橡胶手套。',NULL,NULL,NULL,'2026-03-11 07:59:35','',NULL),(5705,5886,NULL,'10mg/m3（皮）',NULL,NULL,NULL,NULL,NULL,NULL,'生产过程密闭，加强通风。提供安全淋浴和洗眼设备。','空气中浓度超标时，佩戴自吸过滤式防毒面具（半面罩）。紧急事态抢救或撤离时，应该佩戴空气呼吸器。','戴化学安全防护眼镜。','穿防毒物渗透工作服。','戴橡胶耐油手套。',NULL,NULL,NULL,'2026-03-11 07:59:37','',NULL),(5706,5887,NULL,'30',NULL,NULL,NULL,NULL,NULL,NULL,'生产过程密闭，加强通风。',NULL,'戴化学安全防护眼镜。','穿防毒物渗透工作服。','戴防化学品手套。',NULL,NULL,NULL,'2026-03-11 07:59:38','',NULL),(5707,5888,NULL,'0.03mg/m³（按As计）',NULL,NULL,NULL,NULL,NULL,NULL,'密闭操作，提供充分的局部排风和全面通风。尽可能机械化、自动化。提供安全淋浴和洗眼设备。','空气中粉尘浓度超标时，必须佩戴过滤式防尘呼吸器（半面罩）或自吸过滤式防尘口罩。紧急事态抢救或撤离时，建议佩戴空气呼吸器。','佩戴化学护目镜（符合欧盟EN166或美国NIOSH标准）。','穿阻燃防静电防护服和抗静电的防护靴。','戴防化学品手套（如丁基橡胶手套、聚乙烯醇手套）。',NULL,NULL,NULL,'2026-03-11 07:59:40','',NULL),(5708,5889,NULL,'未制定标准',NULL,NULL,NULL,NULL,NULL,NULL,'密闭操作，注意通风。尽可能机械化、自动化。提供安全淋浴和洗眼设备。','可能接触其粉尘时，佩戴头罩型电动送风过滤式防尘呼吸器。紧急事态抢救或逃生时，建议佩戴空气呼吸器。','呼吸系统防护中已作防护。','穿橡胶耐酸碱服。','戴橡胶耐酸碱手套。',NULL,NULL,NULL,'2026-03-11 07:59:44','',NULL),(5709,5890,NULL,'未制定标准',NULL,NULL,NULL,NULL,NULL,NULL,'密闭操作，提供充分的局部排风。提供安全淋浴和洗眼设备。','空气中浓度超标时，必须佩戴自吸过滤式防毒面具（半面罩）。紧急事态抢救或撤离时，应该佩戴空气呼吸器。','戴化学安全防护眼镜。','穿防静电工作服。','戴橡胶手套。',NULL,NULL,NULL,'2026-03-11 07:59:44','',NULL),(5710,5891,NULL,'未制定标准',NULL,NULL,NULL,NULL,NULL,NULL,'生产过程密闭，加强通风。提供安全淋浴和洗眼设备。','可能接触其粉尘时，建议佩戴自吸过滤式防尘口罩。','戴化学安全防护眼镜。','穿聚乙烯防毒服。','戴橡胶手套。',NULL,NULL,NULL,'2026-03-11 07:59:44','',NULL),(5711,5892,NULL,'未制定标准',NULL,NULL,NULL,NULL,NULL,NULL,'密闭操作。提供安全淋浴和洗眼设备。','作业时，应该佩戴自吸过滤式防尘口罩。必要时，建议佩戴空气呼吸器。','戴化学安全防护眼镜。','穿防静电工作服。','戴一般作业防护手套。',NULL,NULL,NULL,'2026-03-11 07:59:46','',NULL),(5712,5893,NULL,'未制定标准',NULL,NULL,NULL,NULL,NULL,NULL,'密闭操作，局部排风。提供安全淋浴和洗眼设备。','空气中浓度超标时，佩戴过滤式防毒面具（半面罩）或自给式呼吸器。紧急事态抢救或逃生时，应该佩戴空气呼吸器。','佩戴化学护目镜（符合欧盟EN 166或美国NIOSH标准）。','穿阻燃防静电防护服和抗静电的防护靴。','戴防化学品手套。',NULL,NULL,NULL,'2026-03-11 07:59:48','',NULL);
/*!40000 ALTER TABLE `msds_exposure_control` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msds_stability_reactivity`
--

DROP TABLE IF EXISTS `msds_stability_reactivity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `msds_stability_reactivity` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
  `stability` text COMMENT '稳定性',
  `reactivity` text COMMENT '反应性',
  `incompatible_substances` text COMMENT '禁配物',
  `conditions_to_avoid` text COMMENT '避免接触的条件',
  `hazardous_reactions` text COMMENT '可能的危险反应',
  `polymerization_hazard` text COMMENT '聚合危害',
  `polymerization_conditions` text COMMENT '聚合反应条件',
  `decomposition_products` text COMMENT '分解产物',
  `decomposition_conditions` text COMMENT '分解条件',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  CONSTRAINT `msds_stability_reactivity_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5759 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='稳定性和反应性表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msds_stability_reactivity`
--

LOCK TABLES `msds_stability_reactivity` WRITE;
/*!40000 ALTER TABLE `msds_stability_reactivity` DISABLE KEYS */;
INSERT INTO `msds_stability_reactivity` (`id`, `msds_id`, `stability`, `reactivity`, `incompatible_substances`, `conditions_to_avoid`, `hazardous_reactions`, `polymerization_hazard`, `polymerization_conditions`, `decomposition_products`, `decomposition_conditions`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (5732,5867,'在正常储存和使用条件下稳定。受热、摩擦、震动、撞击时可能发生爆炸性分解反应。',NULL,'强氧化剂、强还原剂、强酸、强碱、金属粉末、促进剂等。','受热、摩擦、震动、撞击、明火、火花、静电积聚。',NULL,'不会发生危险的聚合反应。',NULL,'一氧化碳、二氧化碳、有机过氧化物分解产物等有毒气体。',NULL,NULL,'2026-03-11 07:59:07','',NULL),(5733,5868,'稳定',NULL,'强氧化剂。','无资料',NULL,'不能出现',NULL,'无资料',NULL,NULL,'2026-03-11 07:59:08','',NULL),(5734,5869,'稳定',NULL,'强氧化剂、强酸、酰基氯、酸酐。','无资料',NULL,'不能出现',NULL,'无资料',NULL,NULL,'2026-03-11 07:59:10','',NULL),(5735,5870,'在正确的使用和存储条件下是稳定的。',NULL,'强氧化剂、强酸、强碱、金属粉末、还原剂、易燃物','不相容物质，热、火焰和火花。',NULL,'可能发生爆炸性聚合',NULL,'热分解产物包括二氧化碳、水、一氧化碳、有机酸和醛类等。在受热或与不相容物质接触时，可能产生有害的分解产物。',NULL,NULL,'2026-03-11 07:59:11','',NULL),(5736,5871,'稳定',NULL,'强氧化剂、强酸、空气。','接触空气。',NULL,'能发生',NULL,'一氧化碳、二氧化碳',NULL,NULL,'2026-03-11 07:59:12','',NULL),(5737,5872,'在正确的使用和存储条件下是稳定的',NULL,'强氧化剂、强酸、强碱','不相容物质，热、火焰和火花',NULL,'不会发生聚合反应',NULL,'在正常的储存和使用条件下，不会产生危险的分解产物。受热分解产生磷氧化物、一氧化碳、二氧化碳等有毒气体。',NULL,NULL,'2026-03-11 07:59:14','',NULL),(5738,5873,'稳定',NULL,'强氧化剂。','无资料',NULL,'不能出现',NULL,'无资料',NULL,NULL,'2026-03-11 07:59:15','',NULL),(5739,5874,'稳定',NULL,'强氧化剂、酸类、卤素、铜、银、汞。','避免受热、避免与氧化剂、酸类、卤素接触。',NULL,'不能出现',NULL,'受热分解产生一氧化碳、二氧化碳、氮氧化物。',NULL,NULL,'2026-03-11 07:59:15','',NULL),(5740,5875,'稳定',NULL,'易燃或可燃物、活性金属粉末、硫、磷、肼。','避免与还原剂、活性金属粉末、硫、磷、肼、易燃或可燃物接触。避免受热、摩擦、撞击。避免接触有机物。防止受潮。',NULL,'不能出现',NULL,'受热分解产生氯化物和氧化锂，放出氧气。与有机物接触可能发生剧烈反应或爆炸。',NULL,NULL,'2026-03-11 07:59:20','',NULL),(5741,5876,'在正确的使用和存储条件下是稳定的。',NULL,'无机酸、共价卤化物、无机碱、胺、金属烷氧化物、金属氧化物和高氯酸镁。','不相容物质，热、火焰和火花。',NULL,'与无机酸或高氯酸镁接触发生爆炸。',NULL,'在正常的储存和使用条件下，不会产生危险的分解产物。',NULL,NULL,'2026-03-11 07:59:23','',NULL),(5742,5877,'在正确的使用和存储条件下是稳定的。',NULL,'强氧化剂、强还原剂、强酸、强碱、不相容物质。','不相容物质，热、火焰和火花。',NULL,'不会发生聚合反应',NULL,'在正常的储存和使用条件下，不会产生危险的分解产物。受热分解产生一氧化碳、二氧化碳、氮氧化物等有毒气体。',NULL,NULL,'2026-03-11 07:59:25','',NULL),(5743,5878,'在正确的使用和存储条件下是稳定的。',NULL,'强氧化剂、强碱、金属粉末。','热、火焰、火花、明火、潮湿。',NULL,'不会发生聚合反应。',NULL,'受热分解产生一氧化碳、二氧化碳、硫化物等。',NULL,NULL,'2026-03-11 07:59:28','',NULL),(5744,5879,'稳定',NULL,'空气、水、碱类。','无资料',NULL,'不能出现',NULL,'无资料',NULL,NULL,'2026-03-11 07:59:31','',NULL),(5745,5880,'在正确的使用和存储条件下是稳定的。',NULL,'强氧化剂、强还原剂、碱金属、碱土金属。','不相容物质，热、火焰和火花。',NULL,'无资料',NULL,'在正常的储存和使用条件下，不会产生危险的分解产物。高温分解可能产生氟化氢、氯化氢等有毒气体。',NULL,NULL,'2026-03-11 07:59:32','',NULL),(5746,5881,'稳定',NULL,'强还原剂、易燃或可燃物、醇类、强酸、硫、磷、铝、镁。','无资料',NULL,'不能出现',NULL,'无资料',NULL,NULL,'2026-03-11 07:59:33','',NULL),(5747,5882,'在正确的使用和存储条件下是稳定的。',NULL,'强还原剂、易燃或可燃物、醇类、强酸、硫、磷、铝。','不相容物质，热、火焰和火花。',NULL,'不会发生聚合反应。',NULL,'受热分解产生氯化物和氧气。',NULL,NULL,'2026-03-11 07:59:33','',NULL),(5748,5883,'在正确的使用和存储条件下是稳定的。',NULL,'强还原剂、易燃物、有机物、硫、磷、金属粉末、酸类。','不相容物质，热、火焰和火花。',NULL,'不会发生聚合反应。',NULL,'在正常的储存和使用条件下，不会产生危险的分解产物。高温分解可能产生碘化物、氧化物等。',NULL,NULL,'2026-03-11 07:59:35','',NULL),(5749,5884,'在正确的使用和存储条件下是稳定的。',NULL,'强还原剂、有机物、易燃物、硫、磷、金属粉末等','避免受热、明火、火花、静电积累。避免与不相容物质接触。',NULL,'无资料',NULL,'加热时分解为碘酸钠（NaIO3）和氧气。与还原剂反应可能产生碘化物等产物。',NULL,NULL,'2026-03-11 07:59:35','',NULL),(5750,5885,'在正确的使用和存储条件下是稳定的。',NULL,'金属粉末、金属氨基化物、氨、铵盐、胺、酰胺、醇、酚、羧酸、羧酸酯、腈类、硫酸、浓硝酸和磷酸、还原剂、易（可）燃物。','热、火焰、火花、明火、酸。',NULL,'与金属粉末的混合物当受热、撞击或摩擦时会引发爆炸。',NULL,'受热或遇酸分解产生氯气、氯化氢等。',NULL,NULL,'2026-03-11 07:59:35','',NULL),(5751,5886,'在正确的使用和存储条件下是稳定的。',NULL,'强氧化剂、强酸、强碱、卤素。','热、火焰、火花、明火、静电。',NULL,'不会发生聚合反应',NULL,'受热分解产生一氧化碳、二氧化碳、苯蒸气。',NULL,NULL,'2026-03-11 07:59:37','',NULL),(5752,5887,'稳定',NULL,'强氧化剂、强还原剂、强碱、铝、镁。','光照。',NULL,'能发生',NULL,'无资料',NULL,NULL,'2026-03-11 07:59:38','',NULL),(5753,5888,'稳定',NULL,'强还原剂、金属粉末、强酸、易燃或可燃物','不相容物质，热、火焰和火花',NULL,'不能出现',NULL,'受热分解产生有毒的砷氧化物烟雾',NULL,NULL,'2026-03-11 07:59:40','',NULL),(5754,5889,'稳定',NULL,'强氧化剂、碱类、有机物、还原剂、易燃物如硫、磷等','潮湿空气、高温',NULL,'不会发生',NULL,'高温分解产生氧化硒、二氧化硒等有毒烟雾。',NULL,NULL,'2026-03-11 07:59:44','',NULL),(5755,5890,'在正确的使用和存储条件下是稳定的',NULL,'强氧化剂、强酸、强碱、碱金属、胺类','不相容物质，热、火焰和火花',NULL,'不会发生聚合反应',NULL,'受热分解产生一氧化碳、二氧化碳、氮氧化物等有毒气体',NULL,NULL,'2026-03-11 07:59:44','',NULL),(5756,5891,'在正确的使用和存储条件下是稳定的。',NULL,'强还原剂、强酸、有机物、易燃物、金属粉末、硫化物、金属氨基化合物、金属乙炔化合物、酚类、金属氨基磺酸盐、金属氰化物、硫氰酸盐、磷化物、次磷酸盐、羧酸、羧酸酐、羧酸酯、乙醇等。','不相容物质，热、火焰和火花。',NULL,'与活泼金属粉末的混合物，在加热时剧烈爆炸。',NULL,'受热分解产生有毒的氮氧化物、氨气。',NULL,NULL,'2026-03-11 07:59:44','',NULL),(5757,5892,'不稳定',NULL,'胺类、硫、氯代烃、强酸、强碱、氧化物、强氧化剂、空气','潮湿空气',NULL,'不能出现',NULL,'氧化锌',NULL,NULL,'2026-03-11 07:59:46','',NULL),(5758,5893,'在正确的使用和存储条件下是稳定的',NULL,'强氧化剂、强酸、强碱','不相容物质、热、火焰和火花',NULL,'无资料',NULL,'在正常的储存和使用条件下，不会产生危险的分解产物。受热分解产生一氧化碳、二氧化碳、氮氧化物',NULL,NULL,'2026-03-11 07:59:48','',NULL);
/*!40000 ALTER TABLE `msds_stability_reactivity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msds_toxicological`
--

DROP TABLE IF EXISTS `msds_toxicological`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `msds_toxicological` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
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
  `create_by` varchar(64) DEFAULT '',
  `create_time` datetime DEFAULT NULL,
  `update_by` varchar(64) DEFAULT '',
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  CONSTRAINT `msds_toxicological_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5743 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='毒理学资料表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msds_toxicological`
--

LOCK TABLES `msds_toxicological` WRITE;
/*!40000 ALTER TABLE `msds_toxicological` DISABLE KEYS */;
INSERT INTO `msds_toxicological` (`id`, `msds_id`, `acute_toxicity`, `ld50_oral`, `ld50_dermal`, `lc50_inhalation`, `subacute_chronic`, `skin_irritation`, `eye_irritation`, `respiratory_irritation`, `sensitization`, `mutagenicity`, `teratogenicity`, `reproductive_toxicity`, `carcinogenicity`, `carcinogen_classification`, `specific_target_organ`, `aspiration_hazard`, `other_toxicity`, `rtecs`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (5716,5867,'参考同类有机过氧化物混合物，对大鼠经口LD50>2000mg/kg；对大鼠吸入LC50>5000mg/m3，4小时。急性中毒主要表现为对眼睛、皮肤和呼吸道的刺激作用，可引起头痛、头晕、恶心、呕吐等症状。高浓度接触可能对肝、肾造成损害。有机过氧化物可能引起皮肤过敏反应。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5717,5868,'属低毒类LD50：500mg／kg(人经口)(MLD)LC50：',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5718,5869,'LD50：418mg／kg(大鼠经口)LC50：','LD50：418mg／kg(大鼠经口)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5719,5870,'大鼠经口LD50：约2000 mg/kg（估算值）',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5720,5871,'LD50：4300mg／kg(大鼠经口)；4500mg／kg(兔经皮)LC50：','LD50：4300mg／kg(大鼠经口)','4500mg／kg(兔经皮)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5721,5872,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5722,5873,'LD50：7.8mg／kg(大鼠经口)；14lmg／kg(小鼠经口)；58mg／kg(兔经皮)LC50：','LD50：7.8mg／kg(大鼠经口)','58mg／kg(兔经皮)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5723,5874,'LD50：350mg/kg(大鼠，经口)；LC50：2000ppm/4h(大鼠，吸入)',NULL,NULL,'2000ppm/4h(大鼠，吸入)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5724,5875,'LD50: 1500-3000 mg/kg (大鼠经口) - 基于高氯酸锂和锂化合物特性估算\n        LD50: >2000 mg/kg (大鼠经皮) - 基于高氯酸锂和锂化合物特性估算\n        LC50: 无资料 - 建议进行急性吸入毒性测试(方法参考OECD TG 403)',NULL,'2000 mg/kg (大鼠经皮)','无资料 - 建议进行急性吸入毒性测试(方法参考OECD TG 403)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5725,5876,'环氧乙烷：LD50(经口)、72mg/kg(大鼠)；LC50(吸入)、800ppmV(大鼠)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5726,5877,'属中等毒类。LD50：无资料；LC50：无资料。',NULL,NULL,'无资料。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5727,5878,'属中等毒类。参考主要成分毒性数据：苯酚LD50：317mg/kg（大鼠经口）、410-650mg/kg（大鼠经口）；甲酚LD50：242mg/kg（大鼠经口）、1100mg/kg（兔经皮）；LC50：>710mg/m3（大鼠吸入，1h）。',NULL,NULL,'>710mg/m3（大鼠吸入，1h）。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5728,5879,'LD50：LC50：大鼠吸入；500ppm／1h',NULL,NULL,'大鼠吸入',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5729,5880,'吸入：高浓度可引起窒息。LD50（经口）：无资料。LD50（经皮）：无资料。LC50（吸入）：无资料。由于该物质是窒息性气体，在高浓度环境下可引起缺氧、头晕、头痛、恶心、意识模糊，严重时可导致窒息死亡。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5730,5881,'LD50(经口)：1870mg/kg(大鼠)；LD50(经皮)：>5000mg/kg(兔子)；LC50：无资料',NULL,NULL,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5731,5882,'LD50：1200mg/kg(大鼠经口)','LD50：1200mg/kg(大鼠经口)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5732,5883,'LD50：58mg/kg（小鼠腹腔内）',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5733,5884,'LD50：58mg/kg（小鼠腹腔内）',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5734,5885,'属中等毒性。LD50：850mg/kg(大鼠经口)；LD50：无资料；LC50：无资料。','LD50：850mg/kg(大鼠经口)',NULL,'无资料。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5735,5886,'属高毒。LD50：930mg/kg(大鼠经口)；LD50：48mg/kg(小鼠经皮)；LC50：无资料。','LD50：930mg/kg(大鼠经口)',NULL,'无资料。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5736,5887,'LC50：45292mg/m3，4小时(小鼠吸入)；137752mg/m3，1小时(大鼠吸入)',NULL,NULL,'45292mg/m3，4小时(小鼠吸入)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5737,5888,'LD50（大鼠，经口）：150mg/kg；LD50（小鼠，经口）：100mg/kg',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5738,5889,'LD50：4000mg/Kg（大鼠经口）；4720mg/Kg（兔经皮）。LC50：9400mg/m3，2小时（小鼠吸入）。',NULL,NULL,'9400mg/m3，2小时（小鼠吸入）。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5739,5890,'LD50：105mg/kg(大鼠经口)，115mg/kg(小鼠经口)；LC50：无资料','LD50：105mg/kg(大鼠经口)',NULL,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5740,5891,'硝酸铵:LD50(经口,大鼠):2217mg/kg；LD50(经皮,大鼠):无资料；LC50(吸入,大鼠):无资料',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5741,5892,'大鼠经口LD50: >2000 mg/kg；大鼠吸入LC50: >5 mg/L/4h',NULL,NULL,'>5 mg/L/4h',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5742,5893,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL);
/*!40000 ALTER TABLE `msds_toxicological` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msds_ecological`
--

DROP TABLE IF EXISTS `msds_ecological`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `msds_ecological` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
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
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  CONSTRAINT `msds_ecological_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5722 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='生态学资料表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msds_ecological`
--

LOCK TABLES `msds_ecological` WRITE;
/*!40000 ALTER TABLE `msds_ecological` DISABLE KEYS */;
INSERT INTO `msds_ecological` (`id`, `msds_id`, `ecological_toxicity`, `fish_toxicity`, `invertebrate_toxicity`, `algae_toxicity`, `bacteria_toxicity`, `biodegradability`, `biodegradation_rate`, `non_biodegradability`, `photodegradation`, `hydrolysis`, `bioaccumulation`, `bioconcentration_factor`, `mobility_in_soil`, `other_environmental_effects`, `ozone_depletion_potential`, `global_warming_potential`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (5695,5867,'对水生生物可能有害。慢性水生毒性（过氧化(2-乙基己酸)叔丁酯）：甲壳纲动物，NOEC：0.62mg/L；藻类/水生植物，NOEC：0.017mg/L。应避免进入水体、土壤和地下水。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:07','',NULL),(5696,5868,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:08','',NULL),(5697,5869,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:10','',NULL),(5698,5870,'鱼类LC50：约50 mg/L（96小时，估算值）；水蚤EC50：约30 mg/L（48小时，估算值）；藻类EC50：约100 mg/L（72小时，估算值）',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:11','',NULL),(5699,5871,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:12','',NULL),(5700,5872,'对水生物有毒性。对水生环境可能会引起长期有害作用。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:14','',NULL),(5701,5873,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:15','',NULL),(5702,5874,'对水生生物有毒性，可能对水环境造成长期不利影响。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:15','',NULL),(5703,5875,'高氯酸锂为强氧化剂，对水生生物可能有害。应避免进入水体、土壤和地下水。高氯酸锂在水中可能释放氯离子和锂离子，对水生生态系统造成影响。对鱼类和其他水生生物可能有害。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:21','',NULL),(5704,5876,'环氧乙烷：鱼类LC50：84mg/L (96h)；环氧丙烷：鱼类LC50：100mg/L (96h)。对水生生物有毒性。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:23','',NULL),(5705,5877,'对水生生物有毒性。鱼类LC50：10-100mg/L（96小时）。水蚤EC50：10-100mg/L（48小时）。藻类EC50：10-100mg/L（72小时）。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:25','',NULL),(5706,5878,'对水生生物有毒性。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:28','',NULL),(5707,5879,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:32','',NULL),(5708,5880,'对水生生物可能有害。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:32','',NULL),(5709,5881,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:33','',NULL),(5710,5882,'对水生生物有毒。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:33','',NULL),(5711,5883,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:35','',NULL),(5712,5884,'对水生生物有毒性作用。LC50（96小时）：鱼类 10-100 mg/L；水蚤 1-10 mg/L；藻类 0.1-1 mg/L。对水生环境可能会引起长期有害作用。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:35','',NULL),(5713,5885,'对水生生物有极高毒性。鱼类LC50：0.27mg/L(96h)；甲壳纲动物EC50：0.09mg/L(48h)。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:35','',NULL),(5714,5886,'对水生生物有极高毒性。水生植物ErC50：1600mg/L(96h)。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:37','',NULL),(5715,5887,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:38','',NULL),(5716,5888,'对水生生物有剧毒。LC50（鱼类）：0.1-1mg/L；EC50（水蚤）：0.05-0.5mg/L',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:40','',NULL),(5717,5889,'对水生物有剧毒，对水生环境可能会引起长期有害作用',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:44','',NULL),(5718,5890,'对水生生物有毒性。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:44','',NULL),(5719,5891,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:45','',NULL),(5720,5892,'对水生生物有毒害作用',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:46','',NULL),(5721,5893,'无资料',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:48','',NULL);
/*!40000 ALTER TABLE `msds_ecological` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msds_disposal`
--

DROP TABLE IF EXISTS `msds_disposal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `msds_disposal` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
  `waste_properties` text COMMENT '废弃物性质',
  `disposal_method` text COMMENT '废弃处置方法',
  `disposal_precautions` text COMMENT '废弃注意事项',
  `disposal_regulations` text COMMENT '废弃处置相关法规',
  `container_disposal` text COMMENT '包装容器的处置',
  `recommended_disposal` text COMMENT '推荐的处置方法',
  `prohibited_disposal` text COMMENT '禁止的处置方法',
  `neutralization_method` text COMMENT '中和处理方法',
  `create_by` varchar(64) DEFAULT '',
  `create_time` datetime DEFAULT NULL,
  `update_by` varchar(64) DEFAULT '',
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  CONSTRAINT `msds_disposal_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5713 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='废弃处置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msds_disposal`
--

LOCK TABLES `msds_disposal` WRITE;
/*!40000 ALTER TABLE `msds_disposal` DISABLE KEYS */;
INSERT INTO `msds_disposal` (`id`, `msds_id`, `waste_properties`, `disposal_method`, `disposal_precautions`, `disposal_regulations`, `container_disposal`, `recommended_disposal`, `prohibited_disposal`, `neutralization_method`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (5686,5867,'处置前应参阅国家和地方有关法规。建议用焚烧法处置。','集中收集后交由有资质的危险废物处置单位进行安全处置。有机过氧化物应小心处理，避免受热、摩擦、震动。可采用化学还原法或稀释后焚烧法处置。处置前应参阅国家和地方有关法规。',NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5687,5868,'处置前应参阅国家和地方有关法规。建议用焚烧法处置。','无资料',NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5688,5869,'处置前应参阅国家和地方有关法规。建议用焚烧法处置。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5689,5870,'有机过氧化物，具有氧化性和易燃性','建议在指定的危险废物处理设施中处置，遵循当地法规要求',NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5690,5871,'处置前应参阅国家和地方有关法规。建议用焚烧法处置。','无资料',NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5691,5872,'处置前应参阅国家和地方有关法规。建议用焚烧法处置。','建议用焚烧法处置。焚烧炉排出的磷氧化物通过洗涤器除去。',NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5692,5873,'处置前应参阅国家和地方有关法规。建议用焚烧法处置。','无资料',NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5693,5874,'处置前应参阅国家和地方有关法规。建议用焚烧法处置。','焚烧法处置。在焚烧炉中燃烧，并配备洗涤装置以去除燃烧产物中的有害物质。',NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5694,5875,'高氯酸锂为强氧化剂，具有强氧化性，与有机物、还原剂接触可能发生爆炸反应。','采用化学还原法处理，使用还原剂(如亚硫酸盐、硫代硫酸盐)将高氯酸根还原为氯离子。处理后的废液经中和、检测达标后方可排放。固体废物应作为危险废物委托有资质单位处理。',NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5695,5876,'危险废物。','建议用焚烧法处置。焚烧炉排出的氮氧化物通过洗涤器除去。',NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5696,5877,'危险废物','建议用焚烧法处置。焚烧炉排出的气体通过洗涤器除去。',NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5697,5878,'危险废物','建议用焚烧法处置。焚烧炉排出的气体通过洗涤器除去。',NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5698,5879,'处置前应参阅国家和地方有关法规。建议用焚烧法处置。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5699,5880,'消耗臭氧层物质，属于危险废物。','建议使用焚烧法处置。焚烧炉排出的气体通过洗涤器除去。必须委托有资质的危险废物处理单位进行处置。',NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5700,5881,'处置前应参阅国家和地方有关法规。建议用焚烧法处置。','焚烧法处置。与燃料混合后焚烧，焚烧炉排出的气体要通过洗涤器除去。',NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5701,5882,'处置前应参阅国家和地方有关法规。建议用焚烧法处置。','用焚烧法处置。焚烧炉排出的气体通过洗涤器除去。',NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5702,5883,'危险废物，氧化性固体','建议用控制焚烧法处理。焚烧炉排出的气体要通过洗涤器除去。与当地环保部门联系，按照相关法规处理。',NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5703,5884,'危险废物','建议用焚烧法处置。焚烧炉排出的气体要通过洗涤器除去。按照当地相关法律法规处置内装物/容器。将内装物/容器送到批准的废物处理厂处理。',NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5704,5885,'危险废物','建议用焚烧法处置。焚烧炉排出的气体通过洗涤器除去。',NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5705,5886,'危险废物','建议用焚烧法处置。焚烧炉排出的气体通过洗涤器除去。',NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5706,5887,'处置前应参阅国家和地方有关法规。建议用焚烧法处置。',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5707,5888,'危险废物，含砷化合物','建议用焚烧法处置。焚烧炉排出的气体要通过洗涤器除去。与焚烧产生的其他废物混合后，按照危险废物处理法规进行处置。必须委托有资质的危险废物处理单位进行处置。',NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5708,5889,'危险废物','建议用焚烧法处置。焚烧温度需≥1100℃。',NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5709,5890,'危险废物','建议用焚烧法处置，焚烧炉排出的气体要通过洗涤器除去。废弃物应交由有资质的危险废物处理单位处理。',NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5710,5891,'危险废物','建议用控制焚烧法处置。焚烧炉排出的氮氧化物通过洗涤器除去。根据国家和地方有关法规的要求处置。',NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5711,5892,'危险废物','建议用焚烧法处置。焚烧炉排出的氮氧化物通过洗涤器除去。',NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(5712,5893,'处置前应参阅国家和地方有关法规。建议用焚烧法处置。','焚烧法处置',NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL);
/*!40000 ALTER TABLE `msds_disposal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msds_transportation`
--

DROP TABLE IF EXISTS `msds_transportation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `msds_transportation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
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
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  KEY `idx_un_number` (`un_number`),
  KEY `idx_dangerous_goods_number` (`dangerous_goods_number`),
  CONSTRAINT `msds_transportation_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5639 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='运输信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msds_transportation`
--

LOCK TABLES `msds_transportation` WRITE;
/*!40000 ALTER TABLE `msds_transportation` DISABLE KEYS */;
INSERT INTO `msds_transportation` (`id`, `msds_id`, `dangerous_goods_number`, `un_number`, `proper_shipping_name`, `transport_hazard_class`, `packing_group`, `packaging_marks`, `packaging_method`, `marine_pollutant`, `transport_in_bulk`, `transportation_precautions`, `emergency_response_guide`, `imdg_rule_page`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (5613,5867,'3105','3105',NULL,NULL,'II（包装类别II）',NULL,'采用防震、防静电包装，避免与还原剂、促进剂、强酸、强碱混装。包装应密封、防潮、防破损。',NULL,NULL,'运输前检查密封，防止跌落、碰撞、摩擦和震动。严禁与还原剂、促进剂、强酸、强碱、金属粉末等混装混运，车辆需配备灭火器与泄漏应急装置。运输途中应防曝晒、雨淋，防高温。公路运输时要按规定路线行驶，勿在居民区和人口稠密区停留。有机过氧化物运输需特别谨慎。',NULL,NULL,NULL,'2026-03-11 07:59:07','',NULL),(5614,5868,'32012','2263',NULL,NULL,'Ⅱ',NULL,'无资料',NULL,NULL,'无资料',NULL,NULL,NULL,'2026-03-11 07:59:09','',NULL),(5615,5869,'61778','1596',NULL,NULL,'O52',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:11','',NULL),(5616,5870,'2128','2128',NULL,NULL,'II',NULL,'使用UN认证的包装容器，确保密封良好',NULL,NULL,'运输过程中避免高温、阳光直射和机械冲击，远离火源和热源',NULL,NULL,NULL,'2026-03-11 07:59:11','',NULL),(5617,5871,'无资料','无资料',NULL,NULL,'无资料',NULL,'小开口钢桶；安瓿瓶外普通木箱；螺纹口玻璃瓶、铁盖压口玻璃瓶、塑料瓶或金属桶（罐）外普通木箱；螺纹口玻璃瓶、塑料瓶或镀锡薄钢板桶（罐）外满底板花格箱、纤维板箱或胶合板箱。',NULL,NULL,'运输时运输车辆应配备相应品种和数量的消防器材及泄漏应急处理设备。夏季最好早晚运输。运输时所用的槽（罐）车应有接地链，槽内可设孔隔板以减少震荡产生静电。严禁与氧化剂、还原剂、酸类、碱类等混装混运。运输途中应防曝晒、雨淋，防高温。中途停留时应远离火种、热源。公路运输时要按规定路线行驶，勿在居民区和人口稠密区停留。',NULL,NULL,NULL,'2026-03-11 07:59:12','',NULL),(5618,5872,'UN 3183','UN 3183',NULL,NULL,'III',NULL,'塑料袋或二层牛皮纸袋外全开口或中开口钢桶（钢板厚1.0毫米，每桶净重不超过150公斤；钢板厚0.75毫米，每桶净重不超过100公斤）；螺纹口玻璃瓶、铁盖压口玻璃瓶、塑料瓶或镀锡薄钢板桶（罐）外满底板花格箱、纤维板箱或胶合板箱。',NULL,NULL,'运输前应先检查包装容器是否完整、密封，运输过程中要确保容器不泄漏、不倒塌、不坠落、不损坏。严禁与酸类、氧化剂、食用化学品等混装混运。运输时运输车辆应配备相应品种和数量的消防器材及泄漏应急处理设备。运输途中应防曝晒、雨淋，防高温。公路运输时要按规定路线行驶，勿在居民区和人口稠密区停留。',NULL,NULL,NULL,'2026-03-11 07:59:14','',NULL),(5619,5873,'61125','2783',NULL,NULL,'I',NULL,'无资料',NULL,NULL,'无资料',NULL,NULL,NULL,'2026-03-11 07:59:15','',NULL),(5620,5874,'UN 2073, UN 1043','2073 1043',NULL,NULL,'无资料',NULL,'包装方法：按照危险货物运输规则进行包装，确保包装完好无损。使用钢瓶或专用容器包装。',NULL,NULL,'运输时运输车辆应配备相应品种和数量的消防器材及泄漏应急处理设备。运输途中应防曝晒、雨淋，防高温。中途停留时应远离火种、热源。公路运输时要按规定路线行驶，勿在居民区和人口稠密区停留。',NULL,NULL,NULL,'2026-03-11 07:59:15','',NULL),(5621,5876,'2983','2983',NULL,NULL,'Ⅰ',NULL,'小开口钢桶；安瓿瓶外普通木箱；螺纹口玻璃瓶、铁盖压口玻璃瓶、塑料瓶或金属桶（罐）外普通木箱；螺纹口玻璃瓶、塑料瓶或镀锡薄钢板桶（罐）外满底板花格箱、纤维板箱或胶合板箱。',NULL,NULL,'运输时运输车辆应配备相应品种和数量的消防器材及泄漏应急处理设备。夏季最好早晚运输。运输时所用的槽（罐）车应有接地链，槽内可设孔隔板以减少震荡产生静电。严禁与氧化剂、还原剂、酸类、食用化学品等混装混运。运输途中应防曝晒、雨淋，防高温。中途停留时应远离火种、热源。公路运输时要按规定路线行驶，勿在居民区和人口稠密区停留。',NULL,NULL,NULL,'2026-03-11 07:59:23','',NULL),(5622,5877,'0463','UN 0463',NULL,NULL,'满足Ⅱ类包装要求',NULL,'小开口钢桶；安瓿瓶外普通木箱；螺纹口玻璃瓶、铁盖压口玻璃瓶、塑料瓶或金属桶（罐）外普通木箱。',NULL,NULL,'运输时运输车辆应配备相应品种和数量的消防器材及泄漏应急处理设备。夏季最好早晚运输。运输时所用的槽（罐）车应有接地链，槽内可设孔隔板以减少震荡产生静电。严禁与氧化剂、食用化学品等混装混运。运输途中应防曝晒、雨淋，防高温。中途停留时应远离火种、热源、高温区。公路运输时要按规定路线行驶，勿在居民区和人口稠密区停留。',NULL,NULL,NULL,'2026-03-11 07:59:25','',NULL),(5623,5878,'81010','UN 1760',NULL,NULL,'II',NULL,'包装类别：II类包装。包装方法：塑料袋或二层牛皮纸袋外全开口或中开口钢桶；螺纹口玻璃瓶、铁盖压口玻璃瓶、塑料瓶或金属桶（罐）外普通木箱；螺纹口玻璃瓶、塑料瓶或镀锡铁罐外满底板花格箱、纤维板箱或胶合板箱。',NULL,NULL,'运输时运输车辆应配备相应品种和数量的消防器材及泄漏应急处理设备。夏季最好早晚运输。运输时所用的槽（罐）车应有接地链，槽内可设孔隔板以减少震荡产生静电。严禁与氧化剂、易（可）燃物等混装混运。运输途中应防曝晒、雨淋，防高温。中途停留时应远离火种、热源、高温区。公路运输时要按规定路线行驶，勿在居民区和人口稠密区停留。铁路运输时要禁止溜放。',NULL,NULL,NULL,'2026-03-11 07:59:28','',NULL),(5624,5879,'81037','1836',NULL,NULL,'O51',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:32','',NULL),(5625,5880,'2599','2599',NULL,NULL,'不适用',NULL,'钢质气瓶，符合相关国际运输法规要求。',NULL,NULL,'运输时运输车辆应配备相应品种和数量的消防器材及泄漏应急处理设备。夏季最好早晚运输。运输时所用的槽（罐）车应有接地链，槽内可设孔隔板以减少震荡产生静电。严禁与氧化剂、还原剂等混装混运。运输途中应防曝晒、雨淋，防高温。中途停留时应远离火种、热源。',NULL,NULL,NULL,'2026-03-11 07:59:32','',NULL),(5626,5881,'51031','1485',NULL,NULL,'O52',NULL,'小开口钢桶；螺纹口玻璃瓶、铁盖压口玻璃瓶、塑料瓶或金属桶（罐）外普通木箱；螺纹口玻璃瓶、塑料瓶或镀锡薄钢板桶（罐）外满底板花格箱、纤维板箱或胶合板箱。',NULL,NULL,'运输时运输车辆应配备相应品种和数量的消防器材及泄漏应急处理设备。装运本品的车辆排气管须有阻火装置。运输过程中要确保容器不泄漏、不倒塌、不坠落、不损坏。严禁与易燃物或可燃物、还原剂、酸类、醇类等混装混运。运输途中应防曝晒、雨淋，防高温。公路运输时要按规定路线行驶，勿在居民区和人口稠密区停留。',NULL,NULL,NULL,'2026-03-11 07:59:33','',NULL),(5627,5882,'51030','1495',NULL,NULL,'O52',NULL,'塑料袋或二层牛皮纸袋外全开口或中开口钢桶；螺纹口玻璃瓶、铁盖压口玻璃瓶、塑料瓶或金属桶（罐）外普通木箱；螺纹口玻璃瓶、塑料瓶或镀锡薄钢板桶（罐）外满底板花格箱、纤维板箱或胶合板箱。',NULL,NULL,'铁路运输时应严格按照铁道部《危险货物运输规则》中的危险货物配装表进行配装。运输时运输车辆应配备相应品种和数量的消防器材及泄漏应急处理设备。运输时所用的槽（罐）车应有接地链，槽内可设孔隔板以减少震荡产生静电。严禁与易燃物或可燃物、还原剂、醇类等混装混运。运输途中应防曝晒、雨淋，防高温。中途停留时应远离火种、热源。公路运输时要按规定路线行驶，勿在居民区和人口稠密区停留。',NULL,NULL,NULL,'2026-03-11 07:59:33','',NULL),(5628,5883,'1479','1479',NULL,NULL,'II',NULL,'塑料袋或二层牛皮纸袋外全开口或中开口钢桶；螺纹口玻璃瓶、铁盖压口玻璃瓶、塑料瓶或金属桶（罐）外普通木箱；螺纹口玻璃瓶、塑料瓶或镀锡薄钢板桶（罐）外满底板花格箱、纤维板箱或胶合板箱。',NULL,NULL,'运输时运输车辆应配备相应品种和数量的消防器材及泄漏应急处理设备。严禁与还原剂、易燃物、有机物、硫、磷、金属粉末等混装混运。装运该物品的车辆排气管须有阻火装置。中途停留时应远离火种、热源。公路运输时要按规定路线行驶，勿在居民区和人口稠密区停留。',NULL,NULL,NULL,'2026-03-11 07:59:35','',NULL),(5629,5884,'51009','1479',NULL,NULL,'II',NULL,'包装类别：II类包装。包装方法：按照联合国关于危险货物运输的建议书（TDG）和国际海事危险货物规则（IMDG Code）的要求进行包装。使用符合规定的危险货物包装容器。',NULL,NULL,'运输时运输车辆应配备相应品种和数量的消防器材及泄漏应急处理设备。运输途中应防曝晒、雨淋，防高温。中途停留时应远离火种、热源。车辆运输完毕应进行彻底清扫。公路运输时要按规定路线行驶，勿在居民区和人口稠密区停留。铁路运输时要禁止溜放。严禁与还原剂、有机物、易燃物等混装混运。',NULL,NULL,NULL,'2026-03-11 07:59:35','',NULL),(5630,5885,'3485','3485',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:35','',NULL),(5631,5886,'1114','UN 1114',NULL,NULL,'II',NULL,'包装类别：II类包装。包装方法：小开口钢桶；螺纹口玻璃瓶、铁盖压口玻璃瓶、塑料瓶或金属桶（罐）外普通木箱；螺纹口玻璃瓶、塑料瓶或镀锡薄钢板桶（罐）外满底板花格箱、纤维板箱或胶合板箱。',NULL,NULL,'运输时运输车辆应配备相应品种和数量的消防器材及泄漏应急处理设备。夏季最好早晚运输。运输时所用的槽（罐）车应有接地链，槽内可设孔隔板以减少震荡产生静电。严禁与氧化剂、酸类、碱类等混装混运。运输途中应防曝晒、雨淋，防高温。中途停留时应远离火种、热源、高温区。公路运输时要按规定路线行驶，勿在居民区和人口稠密区停留。铁路运输时要禁止溜放。',NULL,NULL,NULL,'2026-03-11 07:59:37','',NULL),(5632,5887,'61580','1710',NULL,NULL,'O53',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11 07:59:38','',NULL),(5633,5888,'UN 1677','UN 1677',NULL,NULL,'II',NULL,'使用符合危险货物运输包装标准的容器包装。包装容器应密封、坚固，防止泄漏。运输时必须贴有危险货物标志和标签。',NULL,NULL,'运输车辆应配备相应的消防器材和泄漏应急处理设备。严禁与还原剂、金属粉末、酸类、食用化学品等混装混运。运输途中应防曝晒、雨淋、防高温。中途停留时应远离火种、热源。',NULL,NULL,NULL,'2026-03-11 07:59:40','',NULL),(5634,5889,'81030','1905',NULL,NULL,'Ⅱ',NULL,'使用符合国际运输规定的包装容器。包装应密封，防止泄漏。',NULL,NULL,'运输时运输车辆应配备相应品种和数量的消防器材及泄漏应急处理设备。严禁与氧化剂、碱类、易燃物等混装混运。运输途中应防曝晒、雨淋，防高温。中途停留时应远离火种、热源、高温区。',NULL,NULL,NULL,'2026-03-11 07:59:44','',NULL),(5635,5890,'32062','UN 1206、UN 3064',NULL,NULL,'II',NULL,'按易燃液体包装，符合联合国危险货物运输规则要求。',NULL,NULL,'运输时运输车辆应配备相应品种和数量的消防器材及泄漏应急处理设备。夏季最好早晚运输。运输时所用的槽（罐）车应有接地链，槽内可设孔隔板以减少震荡产生静电。严禁与氧化剂、酸类、碱金属、胺类等混装混运。运输途中应防曝晒、雨淋，防高温。中途停留时应远离火种、热源、高温区。车辆运输完毕应进行彻底清扫。公路运输时要按规定路线行驶，禁止在居民区和人口稠密区停留。',NULL,NULL,NULL,'2026-03-11 07:59:44','',NULL),(5636,5891,'0222','UN 0222',NULL,NULL,'满足Ⅱ类包装要求',NULL,'小开口钢桶；螺纹口玻璃瓶、铁盖压口玻璃瓶、塑料瓶或金属桶（罐）外普通木箱；螺纹口玻璃瓶、塑料瓶或镀锡薄钢板桶（罐）外满底板花格箱、纤维板箱或胶合板箱。',NULL,NULL,'运输时运输车辆应配备相应品种和数量的消防器材及泄漏应急处理设备。严禁与还原剂、有机物、易燃物、酸类等混装混运。运输途中应防曝晒、雨淋，防高温。中途停留时应远离火种、热源。',NULL,NULL,NULL,'2026-03-11 07:59:45','',NULL),(5637,5892,'43014','1436',NULL,NULL,'II',NULL,'内包装为塑料袋，外包装为钢桶或纤维板桶',NULL,NULL,'运输时运输车辆应配备相应品种和数量的消防器材及泄漏应急处理设备。运输途中应防曝晒、雨淋，防高温。中途停留时应远离火种、热源。车辆运输完毕应进行彻底清扫。公路运输时要按规定路线行驶，禁止在居民区和人口稠密区停留。',NULL,NULL,NULL,'2026-03-11 07:59:46','',NULL),(5638,5893,'1325','1325',NULL,NULL,'III',NULL,'小开口钢桶；安瓿瓶外普通木箱；螺纹口玻璃瓶、铁盖压口玻璃瓶、塑料瓶或金属桶（罐）外普通木箱',NULL,NULL,'铁路运输时应严格按照铁道部《危险货物运输规则》中的危险货物配装表进行配装。运输时运输车辆应配备相应品种和数量的消防器材及泄漏应急处理设备。夏季最好早晚运输。运输时所用的槽（罐）车应有接地链，槽内可设孔隔板以减少震荡产生静电。严禁与氧化剂、酸类、碱类、食用化学品等混装混运。公路运输时要按规定路线行驶，勿在居民区和人口稠密区停留。',NULL,NULL,NULL,'2026-03-11 07:59:48','',NULL);
/*!40000 ALTER TABLE `msds_transportation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msds_regulatory`
--

DROP TABLE IF EXISTS `msds_regulatory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `msds_regulatory` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
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
  `create_by` varchar(64) DEFAULT '',
  `create_time` datetime DEFAULT NULL,
  `update_by` varchar(64) DEFAULT '',
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  CONSTRAINT `msds_regulatory_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5106 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='法规信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msds_regulatory`
--

LOCK TABLES `msds_regulatory` WRITE;
/*!40000 ALTER TABLE `msds_regulatory` DISABLE KEYS */;
INSERT INTO `msds_regulatory` (`id`, `msds_id`, `regulatory_info`, `domestic_regulations`, `international_regulations`, `china_dangerous_chemicals`, `china_controlled_chemicals`, `reach_registration`, `tsca_inventory`, `einecs_number`, `prohibited_restricted`, `special_provisions`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (5080,5867,NULL,'列入《危险化学品目录》(2015版)，序号301；《危险化学品安全管理条例》（国务院令第591号）；《危险货物品名表》（GB 12268-2012）；《危险货物运输包装通用技术条件》（GB 12463-2009）；《危险货物道路运输安全管理办法》（交通运输部令2019年第29号）',NULL,0,0,NULL,0,NULL,NULL,NULL,'',NULL,'',NULL),(5081,5868,'无资料',NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,'',NULL,'',NULL),(5082,5869,'无资料',NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,'',NULL,'',NULL),(5083,5870,NULL,NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,'',NULL,'',NULL),(5084,5871,'危险化学品安全管理条例；GHS分类：易燃液体类别2；皮肤腐蚀/刺激类别2；严重眼损伤/眼刺激类别2；特异性靶器官毒性-一次接触类别3。',NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,'',NULL,'',NULL),(5085,5872,'国内法规：《危险化学品安全管理条例》（国务院令第591号）、《危险化学品目录（2015版）》、《易制爆危险化学品名录》、《易制毒化学品管理条例》、《危险化学品环境管理登记办法（试行）》。国际法规：联合国《关于危险货物运输的建议书》（TDG）、《全球化学品统一分类和标签制度》（GHS）、《国际海运危险货物规则》（IMDG Code）、《国际空运危险货物规则》（IATA-DGR）。',NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,'',NULL,'',NULL),(5086,5873,'无资料',NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,'',NULL,'',NULL),(5087,5874,'危险化学品安全管理条例（国务院令第591号），工作场所安全使用化学品规定（[1996]劳部发423号）等法规，针对化学危险品的安全使用、生产、储存、运输、装卸等方面均作了相应规定；常用危险化学品的分类及标志（GB 13690-2009）将该物质划为第2.3类有毒气体。',NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,'',NULL,'',NULL),(5088,5875,'高氯酸锂属于危险化学品，应按照《危险化学品安全管理条例》进行管理。高氯酸锂属于危险废物，应按照《危险废物经营许可证管理办法》进行管理。高氯酸锂属于氧化剂，应按照《危险货物道路运输规则》进行运输。高氯酸锂对环境有害，应按照《中华人民共和国环境保护法》进行管理。',NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,'',NULL,'',NULL),(5089,5876,'国内法规：危险化学品安全管理条例（国务院令第591号）、易制毒化学品管理条例、工作场所安全使用化学品规定、危险化学品目录（2015版）。国际法规：联合国关于危险货物运输的建议书（TDG）、国际海事组织国际海运危险货物规则（IMDG Code）、国际民航组织危险物品安全航空运输技术细则（ICAO-TI）、欧盟化学品注册、评估、授权和限制法规（REACH）、全球化学品统一分类和标签制度（GHS）。',NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,'',NULL,'',NULL),(5090,5877,'国内化学品管理法规：危险化学品安全管理条例、危险化学品目录（2015版）。国际法规：联合国关于危险货物运输的建议书（TDG）、国际海事组织国际海运危险货物规则（IMDG Code）、国际民用航空组织危险物品安全航空运输技术细则（ICAO TI/IATA DGR）。GHS危险性分类：爆炸物类别1.1。Hazard Statements：H220（极度易燃气体和蒸气）。Precautionary Statements：P201（在使用前获取特别指示）、P202（在阅读并明了所有安全措施前切勿处置）、P281（使用所需的个人防护装备）、P371（在发生火灾和爆炸时）、P372（在发生火灾时：爆炸危险）、P373（切勿向火场喷射任何东西）、P380（疏散现场）、P401（立即清除所有泄漏物）、P501（按当地法规处置内装物/容器）。',NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,'',NULL,'',NULL),(5091,5878,'国内化学品管理法规：危险化学品安全管理条例、易制毒化学品管理条例、危险化学品目录（2015版）。国际法规：联合国关于危险货物运输的建议书（TDG）、国际海事组织国际海运危险货物规则（IMDG Code）、国际民用航空组织危险物品安全航空运输技术细则（ICAO TI/IATA DGR）。GHS危险性分类：皮肤腐蚀/刺激类别1B；严重眼损伤/眼刺激类别1；特异性靶器官系统毒性-反复接触类别2。Hazard Statements：H314（造成严重皮肤灼伤和眼损伤）；H318（造成严重眼损伤）；H336（可能引起嗜睡或眩晕）。Precautionary Statements：P201（使用前取得特别说明）；P202（在阅读所有明了安全措施前切勿操作）；P260（不要吸入粉尘/烟/气体/烟雾/蒸气/喷雾）；P264（作业后彻底清洗）；P270（使用本产品时不要进食、饮水或吸烟）；P271（只能在室外或通风良好之处使用）；P280（戴防护手套/穿防护服/戴护目镜/戴面罩）；P301+P310（如果吞咽：立即呼叫解毒中心/医生）；P302+P352（如皮肤沾染：用大量肥皂和水清洗）；P304+P340（如误吸入：将人转移到空气新鲜处，如呼吸停止，进行人工呼吸）；P305+P351+P338（如进入眼睛：小心用水冲洗几分钟。如戴隐形眼镜并可方便地取出，取出隐形眼镜。继续冲洗）；P310（立即呼叫解毒中心/医生）；P321（具体治疗）；P330（漱口）；P361+P364（立即脱掉所有沾染的衣服，清洗后方可重新使用）；P370+P380（火灾：疏散到安全区域）；P391（收集溢出物）；P405（存放处须加锁）；P501（按当地法规处置内装物/容器）。',NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,'',NULL,'',NULL),(5092,5880,'国内法规：危险化学品安全管理条例（国务院令第591号）；危险化学品目录（2015版）；消耗臭氧层物质管理条例；易制毒化学品管理条例。国际法规：联合国关于危险货物运输的建议书（TDG）；国际海运危险货物规则（IMDG Code）；国际民航组织危险物品安全航空运输技术细则（ICAO TI）；关于消耗臭氧层物质的蒙特利尔议定书。',NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,'',NULL,'',NULL),(5093,5881,'危险化学品安全管理条例（国务院令第591号），工作场所安全使用化学品规定（[1996]劳部发423号）等法规，针对化学危险品的安全使用、生产、储存、运输、装卸等方面均作了相应规定；常用危险化学品的分类及标志（GB 13690-2009）将该物质划为第5.1类氧化剂。',NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,'',NULL,'',NULL),(5094,5882,'危险化学品安全管理条例（国务院令第591号），工作场所安全使用化学品规定（[1996]劳部发423号）等法规，针对化学危险品的安全使用、生产、储存、运输、装卸等方面均作了相应规定；常用危险化学品的分类及标志（GB 13690-2009）将该物质划为第5.1类氧化剂。',NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,'',NULL,'',NULL),(5095,5883,'国内法规：《危险化学品安全管理条例》（国务院令第591号），适用危险化学品生产、储存、使用、经营和运输的安全管理。《危险化学品目录（2015版）》，列入第5.1类氧化性固体。国际法规：联合国《关于危险货物运输的建议书》（TDG），UN 1479，第5.1类氧化性固体，II类包装。欧盟REACH法规，欧盟CLP法规（EC）No 1272/2008。',NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,'',NULL,'',NULL),(5096,5884,'国内法规：危险化学品安全管理条例、易制毒化学品管理条例、危险化学品目录（2015版）。国际法规：联合国关于危险货物运输的建议书（TDG）、国际海事危险货物规则（IMDG Code）、国际航空运输危险物品规则（IATA-DGR）。',NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,'',NULL,'',NULL),(5097,5885,'国内化学品管理法规：危险化学品安全管理条例、危险化学品目录（2015版）、GB 19109-2003次氯酸钙包装要求。国际法规：联合国关于危险货物运输的建议书（TDG）、国际海事组织国际海运危险货物规则（IMDG Code）、国际民用航空组织危险物品安全航空运输技术细则（ICAO TI/IATA DGR）。GHS危险性分类：氧化性固体类别2；急性经口毒性类别4；皮肤腐蚀/刺激类别1B；危害水生环境——急性危险类别1。Hazard Statements：H272（可能加剧火灾；氧化剂）、H314（造成严重皮肤灼伤和眼损伤）、H410（对水生生物毒性极大并具有长期持续影响）。Precautionary Statements：P220（切勿与可燃物、还原剂、酸类、铵盐、胺类等接触）、P280（戴防护手套/穿防护服/戴护目镜/戴面罩）、P370+P378（火灾时：使用灭火剂灭火）、P305+P351+P338（如进入眼睛：用水小心冲洗几分钟。如戴隐形眼镜并可方便地取出，取出隐形眼镜。继续冲洗）、P310（立即呼叫解毒中心或医生）、P501（按当地法规处置内装物/容器）。',NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,'',NULL,'',NULL),(5098,5886,'国内化学品管理法规：危险化学品安全管理条例、易制毒化学品管理条例、危险化学品目录（2015版）。国际法规：联合国关于危险货物运输的建议书（TDG）、国际海事组织国际海运危险货物规则（IMDG Code）、国际民用航空组织危险物品安全航空运输技术细则（ICAO TI/IATA DGR）。GHS危险性分类：易燃液体类别2；皮肤腐蚀/刺激类别2；严重眼损伤/眼刺激类别2A；致癌性类别1A；生殖毒性类别1B；特异性靶器官毒性-反复接触类别1；对水环境的危害-急性类别1；对水环境的危害-慢性类别1。Hazard Statements：H225（高度易燃液体和蒸气）；H315（造成皮肤刺激）；H319（造成严重眼刺激）；H350（可能致癌）；H360F（可能损害生育能力）；H372（长期或反复接触对器官造成伤害）；H410（对水生生物毒性极大并具有长期持续影响）。Precautionary Statements：P201（使用前取得特别说明）；P202（在阅读所有明了安全措施前切勿操作）；P210（远离热源/火花/明火/热表面。禁止吸烟）；P220（切勿沾染衣物，……）；P221（采取一切防范措施，避免……与……混合）；P260（不要吸入粉尘/烟/气体/烟雾/蒸气/喷雾）；P264（作业后彻底清洗）；P270（使用本产品时不要进食、饮水或吸烟）；P271（只能在室外或通风良好之处使用）；P280（戴防护手套/穿防护服/戴护目镜/戴面罩）；P301+P312（如误吞咽：如感觉不适，呼叫解毒中心或医生）；P302+P352（如皮肤沾染：用大量肥皂和水清洗）；P304+P340（如误吸入：将人转移到空气新鲜处，如呼吸停止，进行人工呼吸）；P305+P351+P338（如进入眼睛：用水小心冲洗几分钟。如戴隐形眼镜并可方便地取出，取出隐形眼镜。继续冲洗）；P312（如感觉不适，呼叫解毒中心或医生）；P321（具体治疗）；P322（具体措施）；P330（漱口）；P363（沾染的衣物清洗后方可重新使用）；P370+P380（火灾：撤离现场）；P371+P380+P375（火灾时：若火势蔓延，撤离现场）；P405（存放处须加锁）；P501（按当地法规处置内装物/容器）。',NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,'',NULL,'',NULL),(5099,5887,'危险化学品安全管理条例（国务院令第591号），工作场所安全使用化学品规定（[1996]劳部发423号）等法规，针对化学危险品的安全使用、生产、储存、运输、装卸等方面均作了相应规定。',NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,'',NULL,'',NULL),(5100,5888,'危险化学品安全管理条例、易制毒化学品管理条例、剧毒化学品购买和运输管理办法。本化学品属于剧毒化学品，购买、运输、储存和使用必须严格遵守国家相关法律法规。',NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,'',NULL,'',NULL),(5101,5889,'国内法规：《危险化学品安全管理条例》（国务院令第591号）、《危险化学品目录（2015版）》、《工作场所安全使用化学品规定》（[1996]劳部发423号）。国际法规：IMDG Code、ICAO TI、IATA-DGR。',NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,'',NULL,'',NULL),(5102,5890,'国内化学品管理法规：危险化学品安全管理条例（国务院令第591号）、危险化学品目录（2015版）、危险货物品名表（GB 12268-2012）、危险货物运输包装通用技术条件（GB 12463-2009）、危险货物道路运输安全管理办法、易制爆危险化学品名录（2017版）。国际法规：联合国关于危险货物运输的建议书（TDG）、国际海事组织国际海运危险货物规则（IMDG Code）、国际民用航空组织危险物品安全航空运输技术细则（ICAO TI/IATA DGR）。GHS危险性分类：易燃液体类别3；急性毒性-经口类别3；急性毒性-经皮类别3；急性毒性-吸入类别3；皮肤腐蚀/刺激类别2；严重眼损伤/眼刺激类别2A；特异性靶器官毒性-一次接触类别3。Hazard Statements：H225（高度易燃液体和蒸气）、H300（吞咽致命）、H310（皮肤接触致命）、H330（吸入致命）、H315（造成皮肤刺激）、H319（造成严重眼刺激）、H335（可能引起呼吸道刺激）。Precautionary Statements：P201（在使用前获取特别指示）、P202（在阅读并明了所有安全措施前切勿处置）、P210（远离热源、火花、明火、热表面。禁止吸烟）、P220（远离服装和其他可燃材料）、P221（采取一切预防措施，避免与可燃材料混合）、P231+P232（在惰性气体中操作和存放）、P240（容器和接收设备接地/等势连接）、P241（使用防爆的电气、通风和照明设备）、P242（只能使用不产生火花的工具）、P243（采取防止静电放电的措施）、P260（不要吸入粉尘/烟/气体/烟雾/蒸气/喷雾）、P264（作业后彻底清洗）、P270（使用本产品时不要进食、饮水或吸烟）、P280（穿戴防护手套/防护服/护眼/防护面具）、P281（使用所需的个人防护装备）、P282（戴防护手套/防护服/护眼/防护面具）、P303+P361+P353（如皮肤（或头发）沾染：立即脱掉所有沾染的衣服。用水清洗皮肤/淋浴）、P304+P340（如误吸入：将人转移到空气新鲜处，保持呼吸舒适的体位）、P305+P351+P338（如进入眼睛：用水小心冲洗几分钟。如戴隐形眼镜并可方便地取出，取出隐形眼镜。继续冲洗）、P310（立即呼叫解毒中心或医生）、P312（如感觉不适，呼叫解毒中心或医生）、P321（具体治疗）、P322（具体措施）、P330（漱口）、P362（脱掉沾染的衣服，清洗后方可重新使用）、P370+P380（火灾时：撤离现场）、P371+P380+P375（火灾时：若火势无法控制，撤离现场）、P403+P235（存放在通风良好的地方）、P405（存放处须加锁）、P501（按当地法规处置内装物/容器）。',NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,'',NULL,'',NULL),(5103,5891,'危险化学品安全管理条例、易制爆危险化学品治安管理办法、危险化学品目录（2015版）等。',NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,'',NULL,'',NULL),(5104,5892,'危险化学品安全管理条例；工作场所安全使用化学品规定；常用危险化学品的分类及标志(GB 13690-92)',NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,'',NULL,'',NULL),(5105,5893,'《危险化学品安全管理条例》、《危险货物分类和品名编号》（GB6944）、《危险货物品名表》（GB12268）等法规',NULL,NULL,0,0,NULL,0,NULL,NULL,NULL,'',NULL,'',NULL);
/*!40000 ALTER TABLE `msds_regulatory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msds_other_info`
--

DROP TABLE IF EXISTS `msds_other_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `msds_other_info` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `msds_id` bigint NOT NULL COMMENT '关联MSDS主表ID',
  `references` text COMMENT '参考文献',
  `data_sources` text COMMENT '数据来源',
  `form_fill_time` date DEFAULT NULL COMMENT '填表时间',
  `form_fill_department` varchar(100) DEFAULT NULL COMMENT '填表部门',
  `form_fill_person` varchar(100) DEFAULT NULL COMMENT '填表人',
  `data_audit_unit` varchar(100) DEFAULT NULL COMMENT '数据审核单位',
  `data_audit_person` varchar(100) DEFAULT NULL COMMENT '数据审核人',
  `technical_review_person` varchar(100) DEFAULT NULL COMMENT '技术审查人',
  `modification_notes` text COMMENT '修改说明',
  `training_requirements` text COMMENT '培训要求',
  `additional_information` text COMMENT '其他信息',
  `disclaimer` text COMMENT '免责声明',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_msds_id` (`msds_id`),
  CONSTRAINT `msds_other_info_ibfk_1` FOREIGN KEY (`msds_id`) REFERENCES `msds_main` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2278 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='其他信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msds_other_info`
--

LOCK TABLES `msds_other_info` WRITE;
/*!40000 ALTER TABLE `msds_other_info` DISABLE KEYS */;
INSERT INTO `msds_other_info` (`id`, `msds_id`, `references`, `data_sources`, `form_fill_time`, `form_fill_department`, `form_fill_person`, `data_audit_unit`, `data_audit_person`, `technical_review_person`, `modification_notes`, `training_requirements`, `additional_information`, `disclaimer`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (2264,5871,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(2265,5872,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'无',NULL,NULL,NULL,'',NULL,'',NULL),(2266,5874,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'无',NULL,NULL,NULL,'',NULL,'',NULL),(2267,5875,NULL,'国际化学品安全卡(ICSC)、欧洲化学品管理局(ECHA)数据库、美国国立职业安全卫生研究所(NIOSH)数据库、中国化学品安全网、相关科学文献和专业数据库',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'本MSDS数据仅供参考，实际使用时应以最新法规和产品特性为准。使用者应根据具体使用情况评估风险并采取相应的安全措施。','',NULL,'',NULL),(2268,5876,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'本说明书根据国家标准GB/T 16483-2008编制。本产品为环氧乙烷和氧化丙烯混合物，其中环氧乙烷含量不超过30%。环氧乙烷属于易燃液体，具有爆炸危险，操作时需特别注意安全。',NULL,NULL,NULL,'',NULL,'',NULL),(2269,5881,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(2270,5882,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(2271,5883,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'本版本为初次编制。',NULL,NULL,NULL,'',NULL,'',NULL),(2272,5884,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'修订日期：2024年1月9日。版本：1.0。编制单位：化学品安全技术中心。',NULL,NULL,NULL,'',NULL,'',NULL),(2273,5887,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(2274,5888,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(2275,5889,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'本安全技术说明书依据GB/T 16483-2008标准编制，内容符合《化学品安全技术说明书 内容和项目顺序》和《化学品分类和危险性公示 通则》的要求。',NULL,NULL,NULL,'',NULL,'',NULL),(2276,5891,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'',NULL),(2277,5893,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'无',NULL,NULL,NULL,'',NULL,'',NULL);
/*!40000 ALTER TABLE `msds_other_info` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
