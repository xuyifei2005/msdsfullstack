
-- 创建MSDS数据库
CREATE DATABASE IF NOT EXISTS msds_management 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE msds_management;

-- 化学品分类表
CREATE TABLE IF NOT EXISTS chemical_category (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '分类ID',
    category_code VARCHAR(20) NOT NULL UNIQUE COMMENT '分类代码',
    category_name VARCHAR(100) NOT NULL COMMENT '分类名称',
    parent_id INT COMMENT '父分类ID',
    description TEXT COMMENT '分类描述',
    is_active TINYINT(1) DEFAULT 1 COMMENT '是否有效',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_parent_id (parent_id),
    INDEX idx_category_code (category_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='化学品分类表';

-- GHS危险性分类标准表
CREATE TABLE IF NOT EXISTS ghs_hazard_class (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    class_code VARCHAR(20) NOT NULL UNIQUE COMMENT '危险类别代码',
    class_name VARCHAR(100) NOT NULL COMMENT '危险类别名称',
    category VARCHAR(50) COMMENT '危险类别',
    pictogram VARCHAR(50) COMMENT '象形图代码',
    signal_word VARCHAR(20) COMMENT '警示词',
    description TEXT COMMENT '描述',
    is_active TINYINT(1) DEFAULT 1 COMMENT '是否有效',
    INDEX idx_class_code (class_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='GHS危险性分类标准表';

-- MSDS主表【1.化学品企业标识】
CREATE TABLE IF NOT EXISTS msds_main (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'MSDS唯一标识',
    cas_number VARCHAR(50) NOT NULL UNIQUE COMMENT 'CAS登记号',-----化学品CAS号：
    msds_code VARCHAR(50) NOT NULL UNIQUE COMMENT 'MSDS编号',-----技术说明书编码：
    product_name VARCHAR(255) NOT NULL COMMENT '化学品中文名',--------中文名称：
    product_alias VARCHAR(255) COMMENT '化学品别名',-------------中文别名：
    product_english_name VARCHAR(255) COMMENT '化学品英文名',--------英文名称：
    category_id INT COMMENT '化学品分类ID',
    company_name VARCHAR(255) NOT NULL COMMENT '企业名称',------供应商名称：
    company_address TEXT COMMENT '企业地址',-----供应商地址：
    zip_code CHAR(10) COMMENT '邮编',
    fax_number VARCHAR(50) COMMENT '传真号码',-----供应商传真：
    contact_phone VARCHAR(50) NOT NULL COMMENT '联系电话',-------供应商电话：
    email VARCHAR(100) COMMENT '电子邮件地址',-------供应商Email：
    emergency_phone VARCHAR(50) COMMENT '企业应急电话',-------供应商应急电话：
    recommended_usage TEXT COMMENT '产品推荐用途',
    restricted_usage TEXT COMMENT '产品限制用途',
    version VARCHAR(20) DEFAULT '1.0' COMMENT 'MSDS版本号',
    revision_date DATE COMMENT '修订日期',
    effective_date DATE COMMENT '生效日期',
    status ENUM('draft', 'pending', 'approved', 'archived') DEFAULT 'draft' COMMENT '状态',
    approver VARCHAR(100) COMMENT '审批人',
    approval_date DATE COMMENT '审批日期',
    is_active TINYINT(1) DEFAULT 1 COMMENT '是否有效',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(100) COMMENT '创建人',
    updated_by VARCHAR(100) COMMENT '更新人',
    FOREIGN KEY (category_id) REFERENCES chemical_category(id),
    INDEX idx_msds_code (msds_code),
    INDEX idx_product_name (product_name),
    INDEX idx_company_name (company_name),
    INDEX idx_status (status),
    INDEX idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MSDS主信息表';

-- 危险性概述表[2危险性概述]
CREATE TABLE IF NOT EXISTS msds_hazard (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    emergency_overview TEXT COMMENT '紧急情况概述',
    physical_state VARCHAR(50) COMMENT '物理状态',
    odor VARCHAR(100) COMMENT '气味',
    color VARCHAR(50) COMMENT '颜色',
    warning_word ENUM('danger', 'warning') COMMENT '警示词',
    hazard_description TEXT COMMENT '危险性说明',
    prevention_measures TEXT COMMENT '预防措施',
    response_measures TEXT COMMENT '响应措施',
    storage_measures TEXT COMMENT '储存措施',
    disposal_measures TEXT COMMENT '废弃处置措施',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='危险性概述表';

-- GHS危险性分类关联表
CREATE TABLE IF NOT EXISTS msds_ghs_hazard (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    ghs_class_id INT NOT NULL COMMENT '关联GHS危险类别ID',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    FOREIGN KEY (ghs_class_id) REFERENCES ghs_hazard_class(id),
    UNIQUE KEY uk_msds_ghs (msds_id, ghs_class_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MSDS-GHS危险性分类关联表';

-- 成分组成信息表[3.成分组成信息]
CREATE TABLE IF NOT EXISTS msds_component (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    component_name VARCHAR(255) NOT NULL COMMENT '成分名称',
    component_english_name VARCHAR(255) COMMENT '成分英文名',
    component_content VARCHAR(100) COMMENT '成分含量',
    content_min DECIMAL(10,4) COMMENT '含量下限',
    content_max DECIMAL(10,4) COMMENT '含量上限',
    cas_number VARCHAR(50) COMMENT 'CAS登记号',
    ec_number VARCHAR(50) COMMENT 'EC号',
    molecular_formula VARCHAR(100) COMMENT '分子式',
    molecular_weight DECIMAL(10,2) COMMENT '分子量',
    is_hazardous TINYINT(1) DEFAULT 0 COMMENT '是否为危险成分',
    hazard_level VARCHAR(50) COMMENT '危险等级',
    component_function VARCHAR(100) COMMENT '成分功能',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    INDEX idx_msds_id (msds_id),
    INDEX idx_component_name (component_name),
    INDEX idx_cas_number (cas_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='成分组成信息表';

-- 急救措施表[4.急救措施]
CREATE TABLE IF NOT EXISTS msds_first_aid (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    skin_contact TEXT COMMENT '皮肤接触处理措施',
    eye_contact TEXT COMMENT '眼睛接触处理措施',
    inhalation TEXT COMMENT '吸入处理措施',
    ingestion TEXT COMMENT '食入处理措施',
    general_notes TEXT COMMENT '一般注意事项',
    symptoms_effects TEXT COMMENT '可能出现的症状和健康影响',
    immediate_medical_attention TEXT COMMENT '需要立即就医的情况',
    antidote_treatment TEXT COMMENT '解毒剂及治疗方法',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='急救措施表';

-- 消防措施表[5.消防措施]
CREATE TABLE IF NOT EXISTS msds_fire_fighting (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    hazard_characteristics TEXT COMMENT '危险特性',
    harmful_combustion_products TEXT COMMENT '有害燃烧产物',
    suitable_extinguishing_media TEXT COMMENT '适宜的灭火介质',
    unsuitable_extinguishing_media TEXT COMMENT '不适宜的灭火介质',
    fire_fighting_equipment TEXT COMMENT '消防设备和防护装备',
    fire_fighting_procedures TEXT COMMENT '特殊消防程序',
    flash_point VARCHAR(50) COMMENT '闪点',
    autoignition_temperature VARCHAR(50) COMMENT '自燃温度',
    flammability_limits TEXT COMMENT '燃烧性爆炸极限',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='消防措施表';





















-- 插入基础数据
INSERT INTO chemical_category (category_code, category_name, description) VALUES 
('INORGANIC', '无机化学品', '无机化合物'),
('ORGANIC', '有机化学品', '有机化合物'),
('POLYMER', '高分子材料', '聚合物及其制品'),
('MIXTURE', '混合物', '多种化学物质的混合物'),
('PREPARATION', '制剂', '含有添加剂的化学制品');

INSERT INTO ghs_hazard_class (class_code, class_name, category, pictogram, signal_word, description) VALUES 
('FLAM_LIQ_1', '易燃液体', '类别1', 'GHS02', 'DANGER', '闪点小于23℃且初沸点小于等于35℃'),
('FLAM_LIQ_2', '易燃液体', '类别2', 'GHS02', 'DANGER', '闪点小于23℃且初沸点大于35℃'),
('FLAM_LIQ_3', '易燃液体', '类别3', 'GHS02', 'WARNING', '闪点大于等于23℃且小于等于60℃'),
('ACUTE_TOX_1', '急性毒性', '类别1', 'GHS06', 'DANGER', '经口LD50小于等于5mg/kg'),
('ACUTE_TOX_2', '急性毒性', '类别2', 'GHS06', 'DANGER', '经口LD50大于5且小于等于50mg/kg'),
('ACUTE_TOX_3', '急性毒性', '类别3', 'GHS06', 'DANGER', '经口LD50大于50且小于等于300mg/kg'),
('ACUTE_TOX_4', '急性毒性', '类别4', 'GHS07', 'WARNING', '经口LD50大于300且小于等于2000mg/kg'),
('SKIN_CORR_1', '皮肤腐蚀', '类别1', 'GHS05', 'DANGER', '造成皮肤腐蚀'),
('EYE_IRR_2', '眼刺激', '类别2', 'GHS07', 'WARNING', '造成严重眼刺激'),
('CARC_1A', '致癌性', '类别1A', 'GHS08', 'DANGER', '已知对人类致癌'),
('CARC_1B', '致癌性', '类别1B', 'GHS08', 'DANGER', '可能对人类致癌'),
('AQUATIC_1', '水环境危害', '急性类别1', 'GHS09', 'WARNING', '对水生生物毒性极高');

-- 恢复SQL模式
SET SESSION sql_mode = @old_sql_mode;

-- 验证安装
SELECT 'MSDS数据库安装完成！' as message;
SELECT COUNT(*) as table_count FROM information_schema.tables WHERE table_schema = 'msds_management';
SELECT COUNT(*) as category_count FROM chemical_category;
SELECT COUNT(*) as ghs_class_count FROM ghs_hazard_class; 