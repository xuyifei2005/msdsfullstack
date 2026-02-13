-- =============================================
-- 安全智库数据库结构设计
-- 基于GB/T 16483-2008、GB/T 17519-2013标准
-- 兼容MySQL 5.7+和MySQL 8.0+
-- =============================================

-- 设置SQL模式，解决兼容性问题
SET SESSION sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';

-- 创建MSDS数据库
CREATE DATABASE IF NOT EXISTS msds_management 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE msds_management;

-- =============================================
-- 基础配置表
-- =============================================

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

-- =============================================
-- 主要业务表
-- =============================================

-- 1. MSDS主表 - 存储基本标识信息
CREATE TABLE IF NOT EXISTS msds_main (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'MSDS唯一标识',
    msds_code VARCHAR(50) NOT NULL UNIQUE COMMENT 'MSDS编号',
    product_name VARCHAR(255) NOT NULL COMMENT '化学品中文名',
    product_alias VARCHAR(255) COMMENT '化学品别名',
    product_english_name VARCHAR(255) COMMENT '化学品英文名',
    category_id INT COMMENT '化学品分类ID',
    company_name VARCHAR(255) NOT NULL COMMENT '企业名称',
    company_address TEXT COMMENT '企业地址',
    zip_code CHAR(10) COMMENT '邮编',
    fax_number VARCHAR(50) COMMENT '传真号码',
    contact_phone VARCHAR(50) NOT NULL COMMENT '联系电话',
    email VARCHAR(100) COMMENT '电子邮件地址',
    emergency_phone VARCHAR(50) COMMENT '企业应急电话',
    recommended_usage TEXT COMMENT '产品推荐用途',
    restricted_usage TEXT COMMENT '产品限制用途',
    version VARCHAR(20) DEFAULT '1.0' COMMENT 'MSDS版本号',
    revision_date DATE COMMENT '修订日期',
    effective_date DATE COMMENT '生效日期',
    status ENUM('draft', 'pending', 'approved', 'archived') DEFAULT 'draft' COMMENT '状态',
    approver VARCHAR(100) COMMENT '审批人',
    approval_date DATE COMMENT '审批日期',
    is_active TINYINT(1) DEFAULT 1 COMMENT '是否有效(1:有效,0:无效)',
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

-- 2. 危险性概述表
CREATE TABLE IF NOT EXISTS msds_hazard (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    emergency_overview TEXT COMMENT '紧急情况概述',
    physical_state VARCHAR(50) COMMENT '物理状态',
    odor VARCHAR(100) COMMENT '气味',
    color VARCHAR(50) COMMENT '颜色',
    warning_word ENUM('danger', 'warning') COMMENT '警示词(danger:危险,warning:警告)',
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

-- 3. 成分/组成信息表
CREATE TABLE IF NOT EXISTS msds_component (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    component_name VARCHAR(255) NOT NULL COMMENT '成分名称',
    component_english_name VARCHAR(255) COMMENT '成分英文名',
    component_content VARCHAR(100) COMMENT '成分含量/浓度',
    content_min DECIMAL(10,4) COMMENT '含量下限(%)',
    content_max DECIMAL(10,4) COMMENT '含量上限(%)',
    cas_number VARCHAR(50) COMMENT 'CAS登记号',
    ec_number VARCHAR(50) COMMENT 'EC号',
    molecular_formula VARCHAR(100) COMMENT '分子式',
    molecular_weight DECIMAL(10,2) COMMENT '分子量',
    is_hazardous TINYINT(1) DEFAULT 0 COMMENT '是否为危险成分(1:是,0:否)',
    hazard_level VARCHAR(50) COMMENT '危险等级',
    component_function VARCHAR(100) COMMENT '成分功能',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    INDEX idx_msds_id (msds_id),
    INDEX idx_component_name (component_name),
    INDEX idx_cas_number (cas_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='成分/组成信息表';

-- 4. 急救措施表
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

-- 5. 消防措施表
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
    flammability_limits TEXT COMMENT '燃烧性/爆炸极限',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='消防措施表';

-- 6. 泄漏应急处理表
CREATE TABLE IF NOT EXISTS msds_leak_response (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    personal_precautions TEXT COMMENT '个人防护措施',
    environmental_precautions TEXT COMMENT '环境保护措施',
    containment_cleanup TEXT COMMENT '泄漏化学品的收容、清除方法',
    emergency_procedures TEXT COMMENT '应急处理程序',
    elimination_methods TEXT COMMENT '消除方法',
    equipment_materials TEXT COMMENT '清理时使用的器材',
    prevent_secondary_hazards TEXT COMMENT '防止发生次生危害的预防措施',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='泄漏应急处理表';

-- 7. 操作处置与储存表
CREATE TABLE IF NOT EXISTS msds_handling_storage (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    handling_precautions TEXT COMMENT '操作注意事项',
    storage_precautions TEXT COMMENT '储存注意事项',
    optimal_temperature VARCHAR(50) COMMENT '最佳储存温度',
    temperature_range VARCHAR(50) COMMENT '储存温度范围',
    humidity_requirements VARCHAR(50) COMMENT '湿度要求',
    storage_container TEXT COMMENT '储存容器要求',
    incompatible_materials TEXT COMMENT '不相容的物质',
    storage_area_requirements TEXT COMMENT '储存区域要求',
    shelf_life VARCHAR(50) COMMENT '保质期',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作处置与储存表';

-- 8. 接触控制/个体防护表
CREATE TABLE IF NOT EXISTS msds_exposure_control (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    occupational_exposure_limit TEXT COMMENT '职业接触限值',
    china_mac VARCHAR(50) COMMENT '中国MAC值(mg/m³)',
    usa_tlv_twa VARCHAR(50) COMMENT '美国TLV-TWA值(mg/m³)',
    usa_tlv_stel VARCHAR(50) COMMENT '美国TLV-STEL值(mg/m³)',
    monitoring_method TEXT COMMENT '监测方法',
    engineering_controls TEXT COMMENT '工程控制措施',
    respiratory_protection TEXT COMMENT '呼吸系统防护',
    eye_protection TEXT COMMENT '眼睛防护',
    body_protection TEXT COMMENT '身体防护',
    hand_protection TEXT COMMENT '手部防护',
    other_protection TEXT COMMENT '其他防护措施',
    hygiene_measures TEXT COMMENT '卫生措施',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='接触控制/个体防护表';

-- 9. 理化特性表
CREATE TABLE IF NOT EXISTS msds_physical_chemical (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    appearance VARCHAR(255) COMMENT '外观与性状',
    odor VARCHAR(100) COMMENT '气味',
    odor_threshold VARCHAR(50) COMMENT '气味阈值',
    melting_point VARCHAR(50) COMMENT '熔点(℃)',
    boiling_point VARCHAR(50) COMMENT '沸点(℃)',
    relative_density VARCHAR(50) COMMENT '相对密度(水=1)',
    vapor_density VARCHAR(50) COMMENT '蒸气密度(空气=1)',
    vapor_pressure VARCHAR(50) COMMENT '蒸气压(kPa)',
    vapor_pressure_temp VARCHAR(20) COMMENT '蒸气压测定温度(℃)',
    solubility TEXT COMMENT '溶解性',
    water_solubility VARCHAR(100) COMMENT '水中溶解度',
    pH_value VARCHAR(20) COMMENT 'pH值',
    ph_concentration VARCHAR(50) COMMENT 'pH值浓度条件',
    flash_point VARCHAR(50) COMMENT '闪点(℃)',
    ignition_temperature VARCHAR(50) COMMENT '引燃温度(℃)',
    explosive_limit_lower VARCHAR(50) COMMENT '爆炸下限(%)',
    explosive_limit_upper VARCHAR(50) COMMENT '爆炸上限(%)',
    viscosity VARCHAR(50) COMMENT '粘度',
    partition_coefficient VARCHAR(50) COMMENT '分配系数(正辛醇/水)',
    decomposition_temperature VARCHAR(50) COMMENT '分解温度(℃)',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='理化特性表';

-- 10. 稳定性和反应性表
CREATE TABLE IF NOT EXISTS msds_stability_reactivity (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    stability TEXT COMMENT '稳定性',
    reactivity TEXT COMMENT '反应性',
    incompatible_substances TEXT COMMENT '禁配物',
    conditions_to_avoid TEXT COMMENT '避免接触的条件',
    hazardous_reactions TEXT COMMENT '可能的危险反应',
    polymerization_hazard TEXT COMMENT '聚合危害',
    polymerization_conditions TEXT COMMENT '聚合反应条件',
    decomposition_products TEXT COMMENT '分解产物',
    decomposition_conditions TEXT COMMENT '分解条件',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='稳定性和反应性表';

-- 11. 毒理学资料表
CREATE TABLE IF NOT EXISTS msds_toxicological (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    acute_toxicity TEXT COMMENT '急性毒性',
    ld50_oral VARCHAR(100) COMMENT 'LD50(经口,大鼠)',
    ld50_dermal VARCHAR(100) COMMENT 'LD50(经皮,兔)',
    lc50_inhalation VARCHAR(100) COMMENT 'LC50(吸入,大鼠)',
    subacute_chronic TEXT COMMENT '亚急性和慢性毒性',
    skin_irritation TEXT COMMENT '皮肤刺激性',
    eye_irritation TEXT COMMENT '眼睛刺激性',
    respiratory_irritation TEXT COMMENT '呼吸道刺激性',
    sensitization TEXT COMMENT '致敏性',
    mutagenicity TEXT COMMENT '致突变性',
    teratogenicity TEXT COMMENT '致畸性',
    reproductive_toxicity TEXT COMMENT '生殖毒性',
    carcinogenicity TEXT COMMENT '致癌性',
    carcinogen_classification TEXT COMMENT '致癌物分类',
    specific_target_organ TEXT COMMENT '特定目标器官毒性',
    aspiration_hazard TEXT COMMENT '吸入危害',
    other_toxicity TEXT COMMENT '其他毒理学资料',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='毒理学资料表';

-- 12. 生态学资料表
CREATE TABLE IF NOT EXISTS msds_ecological (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    ecological_toxicity TEXT COMMENT '生态毒性',
    fish_toxicity VARCHAR(100) COMMENT '鱼类毒性',
    invertebrate_toxicity VARCHAR(100) COMMENT '无脊椎动物毒性',
    algae_toxicity VARCHAR(100) COMMENT '藻类毒性',
    bacteria_toxicity VARCHAR(100) COMMENT '细菌毒性',
    biodegradability TEXT COMMENT '生物降解性',
    biodegradation_rate VARCHAR(50) COMMENT '生物降解速率',
    non_biodegradability TEXT COMMENT '非生物降解性',
    photodegradation TEXT COMMENT '光降解',
    hydrolysis TEXT COMMENT '水解',
    bioaccumulation TEXT COMMENT '生物富集或生物积累性',
    bioconcentration_factor VARCHAR(50) COMMENT '生物富集因子',
    mobility_in_soil TEXT COMMENT '土壤中迁移性',
    other_environmental_effects TEXT COMMENT '其它有害作用',
    ozone_depletion_potential VARCHAR(50) COMMENT '臭氧消耗潜能值',
    global_warming_potential VARCHAR(50) COMMENT '全球变暖潜能值',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='生态学资料表';

-- 13. 废弃处置表
CREATE TABLE IF NOT EXISTS msds_disposal (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    disposal_method TEXT COMMENT '废弃处置方法',
    disposal_precautions TEXT COMMENT '废弃注意事项',
    disposal_regulations TEXT COMMENT '废弃处置相关法规',
    container_disposal TEXT COMMENT '包装容器的处置',
    recommended_disposal TEXT COMMENT '推荐的处置方法',
    prohibited_disposal TEXT COMMENT '禁止的处置方法',
    neutralization_method TEXT COMMENT '中和处理方法',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='废弃处置表';

-- 14. 运输信息表
CREATE TABLE IF NOT EXISTS msds_transportation (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    dangerous_goods_number VARCHAR(50) COMMENT '危险货物编号',
    un_number VARCHAR(50) COMMENT 'UN编号',
    proper_shipping_name VARCHAR(255) COMMENT '正确运输名称',
    transport_hazard_class VARCHAR(50) COMMENT '运输危险类别',
    packing_group VARCHAR(10) COMMENT '包装类别',
    packaging_marks TEXT COMMENT '包装标志',
    packaging_method TEXT COMMENT '包装方法',
    marine_pollutant TINYINT(1) DEFAULT 0 COMMENT '海洋污染物(1:是,0:否)',
    transport_in_bulk TEXT COMMENT '散装运输要求',
    transportation_precautions TEXT COMMENT '运输注意事项',
    emergency_response_guide VARCHAR(50) COMMENT '应急响应指南编号',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id),
    INDEX idx_un_number (un_number),
    INDEX idx_dangerous_goods_number (dangerous_goods_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='运输信息表';

-- 15. 法规信息表
CREATE TABLE IF NOT EXISTS msds_regulatory (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    regulatory_info TEXT COMMENT '法规信息综述',
    domestic_regulations TEXT COMMENT '国内法规',
    international_regulations TEXT COMMENT '国际法规',
    china_dangerous_chemicals TINYINT(1) DEFAULT 0 COMMENT '中国危险化学品目录(1:是,0:否)',
    china_controlled_chemicals TINYINT(1) DEFAULT 0 COMMENT '中国管制化学品(1:是,0:否)',
    reach_registration TEXT COMMENT 'REACH注册情况',
    tsca_inventory TINYINT(1) DEFAULT 0 COMMENT 'TSCA清单(1:在列,0:不在列)',
    einecs_number VARCHAR(50) COMMENT 'EINECS号',
    prohibited_restricted TEXT COMMENT '禁用/限用情况',
    special_provisions TEXT COMMENT '特殊规定',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='法规信息表';

-- 16. 其他信息表
CREATE TABLE IF NOT EXISTS msds_other_info (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    references TEXT COMMENT '参考文献',
    data_sources TEXT COMMENT '数据来源',
    form_fill_time DATE COMMENT '填表时间',
    form_fill_department VARCHAR(100) COMMENT '填表部门',
    form_fill_person VARCHAR(100) COMMENT '填表人',
    data_audit_unit VARCHAR(100) COMMENT '数据审核单位',
    data_audit_person VARCHAR(100) COMMENT '数据审核人',
    technical_review_person VARCHAR(100) COMMENT '技术审查人',
    modification_notes TEXT COMMENT '修改说明',
    training_requirements TEXT COMMENT '培训要求',
    additional_information TEXT COMMENT '其他信息',
    disclaimer TEXT COMMENT '免责声明',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='其他信息表';

-- =============================================
-- 辅助功能表
-- =============================================

-- MSDS版本历史表
CREATE TABLE IF NOT EXISTS msds_version_history (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    version VARCHAR(20) NOT NULL COMMENT '版本号',
    change_description TEXT COMMENT '变更描述',
    change_reason TEXT COMMENT '变更原因',
    changed_sections TEXT COMMENT '变更章节',
    change_date DATE COMMENT '变更日期',
    changed_by VARCHAR(100) COMMENT '变更人',
    approved_by VARCHAR(100) COMMENT '审批人',
    approval_date DATE COMMENT '审批日期',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    INDEX idx_msds_id (msds_id),
    INDEX idx_version (version),
    INDEX idx_change_date (change_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MSDS版本历史表';

-- MSDS审批流程表
CREATE TABLE IF NOT EXISTS msds_approval_workflow (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    step_no INT NOT NULL COMMENT '审批步骤序号',
    step_name VARCHAR(100) NOT NULL COMMENT '审批步骤名称',
    approver VARCHAR(100) COMMENT '审批人',
    approval_status ENUM('pending', 'approved', 'rejected', 'skipped') DEFAULT 'pending' COMMENT '审批状态',
    approval_date DATETIME COMMENT '审批时间',
    approval_comments TEXT COMMENT '审批意见',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    INDEX idx_msds_id (msds_id),
    INDEX idx_step_no (step_no),
    INDEX idx_approval_status (approval_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MSDS审批流程表';

-- 系统日志表
CREATE TABLE IF NOT EXISTS system_log (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    table_name VARCHAR(50) NOT NULL COMMENT '表名',
    record_id BIGINT NOT NULL COMMENT '记录ID',
    operation_type ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL COMMENT '操作类型',
    old_values JSON COMMENT '修改前的值',
    new_values JSON COMMENT '修改后的值',
    operator VARCHAR(100) COMMENT '操作人',
    operation_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
    ip_address VARCHAR(50) COMMENT 'IP地址',
    user_agent TEXT COMMENT '用户代理',
    INDEX idx_table_record (table_name, record_id),
    INDEX idx_operation_time (operation_time),
    INDEX idx_operator (operator)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统操作日志表';

-- =============================================
-- 初始化基础数据
-- =============================================

-- 插入基本化学品分类
INSERT INTO chemical_category (category_code, category_name, description) VALUES 
('INORGANIC', '无机化学品', '无机化合物'),
('ORGANIC', '有机化学品', '有机化合物'),
('POLYMER', '高分子材料', '聚合物及其制品'),
('MIXTURE', '混合物', '多种化学物质的混合物'),
('PREPARATION', '制剂', '含有添加剂的化学制品');

-- 插入基本GHS危险类别
INSERT INTO ghs_hazard_class (class_code, class_name, category, pictogram, signal_word, description) VALUES 
('FLAM_LIQ_1', '易燃液体', '类别1', 'GHS02', 'DANGER', '闪点＜23℃且初沸点≤35℃'),
('FLAM_LIQ_2', '易燃液体', '类别2', 'GHS02', 'DANGER', '闪点＜23℃且初沸点＞35℃'),
('FLAM_LIQ_3', '易燃液体', '类别3', 'GHS02', 'WARNING', '闪点≥23℃且≤60℃'),
('ACUTE_TOX_1', '急性毒性', '类别1', 'GHS06', 'DANGER', '经口LD50≤5mg/kg'),
('ACUTE_TOX_2', '急性毒性', '类别2', 'GHS06', 'DANGER', '经口LD50＞5且≤50mg/kg'),
('ACUTE_TOX_3', '急性毒性', '类别3', 'GHS06', 'DANGER', '经口LD50＞50且≤300mg/kg'),
('ACUTE_TOX_4', '急性毒性', '类别4', 'GHS07', 'WARNING', '经口LD50＞300且≤2000mg/kg'),
('SKIN_CORR_1', '皮肤腐蚀', '类别1', 'GHS05', 'DANGER', '造成皮肤腐蚀'),
('EYE_IRR_2', '眼刺激', '类别2', 'GHS07', 'WARNING', '造成严重眼刺激'),
('CARC_1A', '致癌性', '类别1A', 'GHS08', 'DANGER', '已知对人类致癌'),
('CARC_1B', '致癌性', '类别1B', 'GHS08', 'DANGER', '可能对人类致癌'),
('AQUATIC_1', '水环境危害', '急性类别1', 'GHS09', 'WARNING', '对水生生物毒性极高');

-- 恢复默认SQL模式设置
SET SESSION sql_mode = DEFAULT;

-- =============================================
-- 创建完成提示
-- =============================================
SELECT '安全智库数据库创建完成！' as message,
       '数据库名称: msds_management' as database_name,
       '主要表数量: 18个' as table_count,
       '辅助表数量: 5个' as auxiliary_tables;