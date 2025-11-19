-- =============================================
-- MSDS批量导入SQL脚本
-- 支持数据验证、错误处理和事务管理
-- =============================================

-- 1. 创建临时导入表
CREATE TEMPORARY TABLE temp_msds_import (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cas_number VARCHAR(50),
    msds_code VARCHAR(50),
    product_name VARCHAR(255),
    product_alias VARCHAR(255),
    product_english_name VARCHAR(255),
    company_name VARCHAR(255),
    company_address TEXT,
    contact_phone VARCHAR(50),
    email VARCHAR(100),
    emergency_phone VARCHAR(50),
    fax_number VARCHAR(50),
    recommended_usage TEXT,
    restricted_usage TEXT,
    version VARCHAR(20),
    revision_date DATE,
    effective_date DATE,
    status VARCHAR(20),
    approver VARCHAR(100),
    approval_date DATE,
    -- 危险性概述字段
    emergency_overview TEXT,
    physical_state VARCHAR(50),
    odor VARCHAR(100),
    color VARCHAR(50),
    warning_word VARCHAR(20),
    hazard_category VARCHAR(255),
    exposure_routes VARCHAR(255),
    health_hazards TEXT,
    environmental_hazards TEXT,
    fire_explosion_hazards TEXT,
    -- 成分组成信息字段
    component_name VARCHAR(255),
    component_english_name VARCHAR(255),
    component_content VARCHAR(100),
    component_content_min DECIMAL(10,4),
    component_content_max DECIMAL(10,4),
    component_cas_number VARCHAR(50),
    ec_number VARCHAR(50),
    molecular_formula VARCHAR(100),
    molecular_weight DECIMAL(10,2),
    is_hazardous TINYINT(1),
    hazard_level VARCHAR(50),
    component_function VARCHAR(100),
    -- 急救措施字段
    skin_contact TEXT,
    eye_contact TEXT,
    inhalation TEXT,
    ingestion TEXT,
    general_notes TEXT,
    symptoms_effects TEXT,
    immediate_medical_attention TEXT,
    antidote_treatment TEXT,
    -- 消防措施字段
    hazard_characteristics TEXT,
    harmful_combustion_products TEXT,
    suitable_extinguishing_media TEXT,
    unsuitable_extinguishing_media TEXT,
    fire_fighting_equipment TEXT,
    fire_fighting_procedures TEXT,
    flash_point VARCHAR(50),
    autoignition_temperature VARCHAR(50),
    flammability_limits TEXT,
    fire_risk_classification VARCHAR(50),
    -- 泄漏应急处理字段
    personal_precautions TEXT,
    environmental_precautions TEXT,
    containment_cleanup TEXT,
    emergency_procedures TEXT,
    elimination_methods TEXT,
    equipment_materials TEXT,
    prevent_secondary_hazards TEXT,
    -- 操作处置与储存字段
    handling_precautions TEXT,
    storage_precautions TEXT,
    optimal_temperature VARCHAR(50),
    temperature_range VARCHAR(50),
    humidity_requirements VARCHAR(50),
    storage_container TEXT,
    incompatible_materials TEXT,
    storage_area_requirements TEXT,
    shelf_life VARCHAR(50),
    -- 接触控制/个体防护字段
    occupational_exposure_limit TEXT,
    china_mac VARCHAR(50),
    usa_tlv_twa VARCHAR(50),
    usa_tlv_stel VARCHAR(50),
    former_soviet_mac VARCHAR(50),
    tlv_tn VARCHAR(50),
    tlv_wn VARCHAR(50),
    monitoring_method TEXT,
    engineering_controls TEXT,
    respiratory_protection TEXT,
    eye_protection TEXT,
    body_protection TEXT,
    hand_protection TEXT,
    other_protection TEXT,
    hygiene_measures TEXT,
    -- 理化特性字段
    appearance VARCHAR(255),
    odor_threshold VARCHAR(50),
    melting_point VARCHAR(50),
    boiling_point VARCHAR(50),
    relative_density VARCHAR(50),
    vapor_density VARCHAR(50),
    vapor_pressure VARCHAR(50),
    vapor_pressure_temp VARCHAR(20),
    solubility TEXT,
    water_solubility VARCHAR(100),
    ph_value VARCHAR(20),
    ph_concentration VARCHAR(50),
    ignition_temperature VARCHAR(50),
    explosive_limit_lower VARCHAR(50),
    explosive_limit_upper VARCHAR(50),
    viscosity VARCHAR(50),
    partition_coefficient VARCHAR(50),
    decomposition_temperature VARCHAR(50),
    main_components TEXT,
    critical_temperature VARCHAR(50),
    flammability VARCHAR(50),
    heat_of_combustion VARCHAR(50),
    critical_pressure VARCHAR(50),
    main_usage TEXT,
    other_properties TEXT,
    -- 稳定性和反应性字段
    stability TEXT,
    reactivity TEXT,
    incompatible_substances TEXT,
    conditions_to_avoid TEXT,
    hazardous_reactions TEXT,
    polymerization_hazard TEXT,
    polymerization_conditions TEXT,
    decomposition_products TEXT,
    decomposition_conditions TEXT,
    -- 毒理学资料字段
    acute_toxicity TEXT,
    ld50_oral VARCHAR(100),
    ld50_dermal VARCHAR(100),
    lc50_inhalation VARCHAR(100),
    subacute_chronic TEXT,
    skin_irritation TEXT,
    eye_irritation TEXT,
    respiratory_irritation TEXT,
    sensitization TEXT,
    mutagenicity TEXT,
    teratogenicity TEXT,
    reproductive_toxicity TEXT,
    carcinogenicity TEXT,
    carcinogen_classification TEXT,
    specific_target_organ TEXT,
    aspiration_hazard TEXT,
    other_toxicity TEXT,
    rtecs VARCHAR(100),
    -- 生态学资料字段
    ecological_toxicity TEXT,
    fish_toxicity VARCHAR(100),
    invertebrate_toxicity VARCHAR(100),
    algae_toxicity VARCHAR(100),
    bacteria_toxicity VARCHAR(100),
    biodegradability TEXT,
    biodegradation_rate VARCHAR(50),
    non_biodegradability TEXT,
    photodegradation TEXT,
    hydrolysis TEXT,
    bioaccumulation TEXT,
    bioconcentration_factor VARCHAR(50),
    mobility_in_soil TEXT,
    other_environmental_effects TEXT,
    ozone_depletion_potential VARCHAR(50),
    global_warming_potential VARCHAR(50),
    -- 废弃处置字段
    waste_properties TEXT,
    disposal_method TEXT,
    disposal_precautions TEXT,
    disposal_regulations TEXT,
    container_disposal TEXT,
    recommended_disposal TEXT,
    prohibited_disposal TEXT,
    neutralization_method TEXT,
    -- 运输信息字段
    dangerous_goods_number VARCHAR(50),
    un_number VARCHAR(50),
    proper_shipping_name VARCHAR(255),
    transport_hazard_class VARCHAR(50),
    packing_group VARCHAR(10),
    packaging_marks TEXT,
    packaging_method TEXT,
    marine_pollutant TINYINT(1),
    transport_in_bulk TEXT,
    transportation_precautions TEXT,
    emergency_response_guide VARCHAR(50),
    imdg_rule_page VARCHAR(50),
    -- 法规信息字段
    regulatory_info TEXT,
    domestic_regulations TEXT,
    international_regulations TEXT,
    china_dangerous_chemicals TINYINT(1),
    china_controlled_chemicals TINYINT(1),
    reach_registration TEXT,
    tsca_inventory TINYINT(1),
    einecs_number VARCHAR(50),
    prohibited_restricted TEXT,
    special_provisions TEXT,
    -- 其他信息字段
    references TEXT,
    data_sources TEXT,
    form_fill_time DATE,
    form_fill_department VARCHAR(100),
    form_fill_person VARCHAR(100),
    data_audit_unit VARCHAR(100),
    data_audit_person VARCHAR(100),
    technical_review_person VARCHAR(100),
    modification_notes TEXT,
    training_requirements TEXT,
    additional_information TEXT,
    disclaimer TEXT,
    -- 导入状态字段
    import_status ENUM('PENDING', 'VALIDATING', 'VALIDATED', 'IMPORTING', 'SUCCESS', 'FAILED') DEFAULT 'PENDING',
    validation_errors TEXT,
    import_errors TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. 数据验证存储过程
DELIMITER //
CREATE PROCEDURE ValidateMsdsImportData()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE import_id INT;
    DECLARE validation_errors TEXT DEFAULT '';
    DECLARE error_count INT DEFAULT 0;
    
    DECLARE import_cursor CURSOR FOR 
        SELECT id FROM temp_msds_import WHERE import_status = 'PENDING';
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- 开始事务
    START TRANSACTION;
    
    OPEN import_cursor;
    
    read_loop: LOOP
        FETCH import_cursor INTO import_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- 重置错误信息
        SET validation_errors = '';
        SET error_count = 0;
        
        -- 验证必填字段
        IF NOT EXISTS (
            SELECT 1 FROM temp_msds_import 
            WHERE id = import_id 
            AND cas_number IS NOT NULL 
            AND cas_number != ''
        ) THEN
            SET validation_errors = CONCAT(validation_errors, 'CAS登记号不能为空; ');
            SET error_count = error_count + 1;
        END IF;
        
        IF NOT EXISTS (
            SELECT 1 FROM temp_msds_import 
            WHERE id = import_id 
            AND msds_code IS NOT NULL 
            AND msds_code != ''
        ) THEN
            SET validation_errors = CONCAT(validation_errors, 'MSDS编号不能为空; ');
            SET error_count = error_count + 1;
        END IF;
        
        IF NOT EXISTS (
            SELECT 1 FROM temp_msds_import 
            WHERE id = import_id 
            AND product_name IS NOT NULL 
            AND product_name != ''
        ) THEN
            SET validation_errors = CONCAT(validation_errors, '化学品中文名不能为空; ');
            SET error_count = error_count + 1;
        END IF;
        
        IF NOT EXISTS (
            SELECT 1 FROM temp_msds_import 
            WHERE id = import_id 
            AND company_name IS NOT NULL 
            AND company_name != ''
        ) THEN
            SET validation_errors = CONCAT(validation_errors, '企业名称不能为空; ');
            SET error_count = error_count + 1;
        END IF;
        
        IF NOT EXISTS (
            SELECT 1 FROM temp_msds_import 
            WHERE id = import_id 
            AND contact_phone IS NOT NULL 
            AND contact_phone != ''
        ) THEN
            SET validation_errors = CONCAT(validation_errors, '联系电话不能为空; ');
            SET error_count = error_count + 1;
        END IF;
        
        -- 验证CAS号格式
        IF EXISTS (
            SELECT 1 FROM temp_msds_import 
            WHERE id = import_id 
            AND cas_number IS NOT NULL 
            AND cas_number != ''
            AND cas_number NOT REGEXP '^[0-9]{1,7}-[0-9]{2}-[0-9]$'
        ) THEN
            SET validation_errors = CONCAT(validation_errors, 'CAS号格式不正确，应为XXXXXXX-XX-X格式; ');
            SET error_count = error_count + 1;
        END IF;
        
        -- 验证邮箱格式
        IF EXISTS (
            SELECT 1 FROM temp_msds_import 
            WHERE id = import_id 
            AND email IS NOT NULL 
            AND email != ''
            AND email NOT REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$'
        ) THEN
            SET validation_errors = CONCAT(validation_errors, '邮箱格式不正确; ');
            SET error_count = error_count + 1;
        END IF;
        
        -- 验证日期格式
        IF EXISTS (
            SELECT 1 FROM temp_msds_import 
            WHERE id = import_id 
            AND revision_date IS NOT NULL 
            AND revision_date = '0000-00-00'
        ) THEN
            SET validation_errors = CONCAT(validation_errors, '修订日期格式不正确; ');
            SET error_count = error_count + 1;
        END IF;
        
        IF EXISTS (
            SELECT 1 FROM temp_msds_import 
            WHERE id = import_id 
            AND effective_date IS NOT NULL 
            AND effective_date = '0000-00-00'
        ) THEN
            SET validation_errors = CONCAT(validation_errors, '生效日期格式不正确; ');
            SET error_count = error_count + 1;
        END IF;
        
        IF EXISTS (
            SELECT 1 FROM temp_msds_import 
            WHERE id = import_id 
            AND approval_date IS NOT NULL 
            AND approval_date = '0000-00-00'
        ) THEN
            SET validation_errors = CONCAT(validation_errors, '审批日期格式不正确; ');
            SET error_count = error_count + 1;
        END IF;
        
        -- 验证数值范围
        IF EXISTS (
            SELECT 1 FROM temp_msds_import 
            WHERE id = import_id 
            AND component_content_min IS NOT NULL 
            AND (component_content_min < 0 OR component_content_min > 100)
        ) THEN
            SET validation_errors = CONCAT(validation_errors, '成分含量下限应在0-100之间; ');
            SET error_count = error_count + 1;
        END IF;
        
        IF EXISTS (
            SELECT 1 FROM temp_msds_import 
            WHERE id = import_id 
            AND component_content_max IS NOT NULL 
            AND (component_content_max < 0 OR component_content_max > 100)
        ) THEN
            SET validation_errors = CONCAT(validation_errors, '成分含量上限应在0-100之间; ');
            SET error_count = error_count + 1;
        END IF;
        
        IF EXISTS (
            SELECT 1 FROM temp_msds_import 
            WHERE id = import_id 
            AND component_content_min IS NOT NULL 
            AND component_content_max IS NOT NULL 
            AND component_content_min > component_content_max
        ) THEN
            SET validation_errors = CONCAT(validation_errors, '成分含量下限不能大于上限; ');
            SET error_count = error_count + 1;
        END IF;
        
        -- 更新验证结果
        IF error_count = 0 THEN
            UPDATE temp_msds_import 
            SET import_status = 'VALIDATED', 
                validation_errors = NULL 
            WHERE id = import_id;
        ELSE
            UPDATE temp_msds_import 
            SET import_status = 'FAILED', 
                validation_errors = validation_errors 
            WHERE id = import_id;
        END IF;
        
    END LOOP;
    
    CLOSE import_cursor;
    
    -- 提交事务
    COMMIT;
    
END //
DELIMITER ;

-- 3. 数据导入存储过程
DELIMITER //
CREATE PROCEDURE ImportMsdsData()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE import_id INT;
    DECLARE import_errors TEXT DEFAULT '';
    DECLARE error_count INT DEFAULT 0;
    DECLARE msds_main_id BIGINT;
    
    DECLARE import_cursor CURSOR FOR 
        SELECT id FROM temp_msds_import WHERE import_status = 'VALIDATED';
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    -- 开始事务
    START TRANSACTION;
    
    OPEN import_cursor;
    
    read_loop: LOOP
        FETCH import_cursor INTO import_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- 重置错误信息
        SET import_errors = '';
        SET error_count = 0;
        
        -- 更新状态为导入中
        UPDATE temp_msds_import 
        SET import_status = 'IMPORTING' 
        WHERE id = import_id;
        
        -- 检查是否已存在相同的CAS号
        IF EXISTS (
            SELECT 1 FROM msds_main 
            WHERE cas_number = (SELECT cas_number FROM temp_msds_import WHERE id = import_id)
        ) THEN
            SET import_errors = CONCAT(import_errors, 'CAS号已存在; ');
            SET error_count = error_count + 1;
        END IF;
        
        -- 检查是否已存在相同的MSDS编号
        IF EXISTS (
            SELECT 1 FROM msds_main 
            WHERE msds_code = (SELECT msds_code FROM temp_msds_import WHERE id = import_id)
        ) THEN
            SET import_errors = CONCAT(import_errors, 'MSDS编号已存在; ');
            SET error_count = error_count + 1;
        END IF;
        
        -- 如果没有错误，开始导入
        IF error_count = 0 THEN
            -- 插入主表数据
            INSERT INTO msds_main (
                cas_number, msds_code, product_name, product_alias, product_english_name,
                company_name, company_address, contact_phone, email, emergency_phone,
                fax_number, recommended_usage, restricted_usage, version, revision_date,
                effective_date, status, approver, approval_date, is_active,
                create_time, update_time, created_by, updated_by
            ) VALUES (
                (SELECT cas_number FROM temp_msds_import WHERE id = import_id),
                (SELECT msds_code FROM temp_msds_import WHERE id = import_id),
                (SELECT product_name FROM temp_msds_import WHERE id = import_id),
                (SELECT product_alias FROM temp_msds_import WHERE id = import_id),
                (SELECT product_english_name FROM temp_msds_import WHERE id = import_id),
                (SELECT company_name FROM temp_msds_import WHERE id = import_id),
                (SELECT company_address FROM temp_msds_import WHERE id = import_id),
                (SELECT contact_phone FROM temp_msds_import WHERE id = import_id),
                (SELECT email FROM temp_msds_import WHERE id = import_id),
                (SELECT emergency_phone FROM temp_msds_import WHERE id = import_id),
                (SELECT fax_number FROM temp_msds_import WHERE id = import_id),
                (SELECT recommended_usage FROM temp_msds_import WHERE id = import_id),
                (SELECT restricted_usage FROM temp_msds_import WHERE id = import_id),
                COALESCE((SELECT version FROM temp_msds_import WHERE id = import_id), '1.0'),
                (SELECT revision_date FROM temp_msds_import WHERE id = import_id),
                (SELECT effective_date FROM temp_msds_import WHERE id = import_id),
                COALESCE((SELECT status FROM temp_msds_import WHERE id = import_id), 'draft'),
                (SELECT approver FROM temp_msds_import WHERE id = import_id),
                (SELECT approval_date FROM temp_msds_import WHERE id = import_id),
                1, NOW(), NOW(), 'system', 'system'
            );
            
            -- 获取插入的主表ID
            SET msds_main_id = LAST_INSERT_ID();
            
            -- 插入危险性概述数据
            INSERT INTO msds_hazard (
                msds_id, emergency_overview, physical_state, odor, color, warning_word,
                hazard_category, exposure_routes, health_hazards, environmental_hazards,
                fire_explosion_hazards
            ) VALUES (
                msds_main_id,
                (SELECT emergency_overview FROM temp_msds_import WHERE id = import_id),
                (SELECT physical_state FROM temp_msds_import WHERE id = import_id),
                (SELECT odor FROM temp_msds_import WHERE id = import_id),
                (SELECT color FROM temp_msds_import WHERE id = import_id),
                (SELECT warning_word FROM temp_msds_import WHERE id = import_id),
                (SELECT hazard_category FROM temp_msds_import WHERE id = import_id),
                (SELECT exposure_routes FROM temp_msds_import WHERE id = import_id),
                (SELECT health_hazards FROM temp_msds_import WHERE id = import_id),
                (SELECT environmental_hazards FROM temp_msds_import WHERE id = import_id),
                (SELECT fire_explosion_hazards FROM temp_msds_import WHERE id = import_id)
            );
            
            -- 插入成分组成信息数据
            INSERT INTO msds_component (
                msds_id, component_name, component_english_name, component_content,
                content_min, content_max, cas_number, ec_number, molecular_formula,
                molecular_weight, is_hazardous, hazard_level, component_function
            ) VALUES (
                msds_main_id,
                (SELECT component_name FROM temp_msds_import WHERE id = import_id),
                (SELECT component_english_name FROM temp_msds_import WHERE id = import_id),
                (SELECT component_content FROM temp_msds_import WHERE id = import_id),
                (SELECT component_content_min FROM temp_msds_import WHERE id = import_id),
                (SELECT component_content_max FROM temp_msds_import WHERE id = import_id),
                (SELECT component_cas_number FROM temp_msds_import WHERE id = import_id),
                (SELECT ec_number FROM temp_msds_import WHERE id = import_id),
                (SELECT molecular_formula FROM temp_msds_import WHERE id = import_id),
                (SELECT molecular_weight FROM temp_msds_import WHERE id = import_id),
                COALESCE((SELECT is_hazardous FROM temp_msds_import WHERE id = import_id), 0),
                (SELECT hazard_level FROM temp_msds_import WHERE id = import_id),
                (SELECT component_function FROM temp_msds_import WHERE id = import_id)
            );
            
            -- 插入急救措施数据
            INSERT INTO msds_first_aid (
                msds_id, skin_contact, eye_contact, inhalation, ingestion,
                general_notes, symptoms_effects, immediate_medical_attention, antidote_treatment
            ) VALUES (
                msds_main_id,
                (SELECT skin_contact FROM temp_msds_import WHERE id = import_id),
                (SELECT eye_contact FROM temp_msds_import WHERE id = import_id),
                (SELECT inhalation FROM temp_msds_import WHERE id = import_id),
                (SELECT ingestion FROM temp_msds_import WHERE id = import_id),
                (SELECT general_notes FROM temp_msds_import WHERE id = import_id),
                (SELECT symptoms_effects FROM temp_msds_import WHERE id = import_id),
                (SELECT immediate_medical_attention FROM temp_msds_import WHERE id = import_id),
                (SELECT antidote_treatment FROM temp_msds_import WHERE id = import_id)
            );
            
            -- 插入消防措施数据
            INSERT INTO msds_fire_fighting (
                msds_id, hazard_characteristics, harmful_combustion_products,
                suitable_extinguishing_media, unsuitable_extinguishing_media,
                fire_fighting_equipment, fire_fighting_procedures, flash_point,
                autoignition_temperature, flammability_limits, fire_risk_classification
            ) VALUES (
                msds_main_id,
                (SELECT hazard_characteristics FROM temp_msds_import WHERE id = import_id),
                (SELECT harmful_combustion_products FROM temp_msds_import WHERE id = import_id),
                (SELECT suitable_extinguishing_media FROM temp_msds_import WHERE id = import_id),
                (SELECT unsuitable_extinguishing_media FROM temp_msds_import WHERE id = import_id),
                (SELECT fire_fighting_equipment FROM temp_msds_import WHERE id = import_id),
                (SELECT fire_fighting_procedures FROM temp_msds_import WHERE id = import_id),
                (SELECT flash_point FROM temp_msds_import WHERE id = import_id),
                (SELECT autoignition_temperature FROM temp_msds_import WHERE id = import_id),
                (SELECT flammability_limits FROM temp_msds_import WHERE id = import_id),
                (SELECT fire_risk_classification FROM temp_msds_import WHERE id = import_id)
            );
            
            -- 更新状态为成功
            UPDATE temp_msds_import 
            SET import_status = 'SUCCESS', 
                import_errors = NULL 
            WHERE id = import_id;
            
        ELSE
            -- 更新状态为失败
            UPDATE temp_msds_import 
            SET import_status = 'FAILED', 
                import_errors = import_errors 
            WHERE id = import_id;
        END IF;
        
    END LOOP;
    
    CLOSE import_cursor;
    
    -- 提交事务
    COMMIT;
    
END //
DELIMITER ;

-- 4. 导入结果查询
CREATE VIEW v_msds_import_results AS
SELECT 
    id,
    cas_number,
    msds_code,
    product_name,
    company_name,
    import_status,
    validation_errors,
    import_errors,
    created_at,
    updated_at
FROM temp_msds_import
ORDER BY created_at DESC;

-- 5. 导入统计查询
CREATE VIEW v_msds_import_statistics AS
SELECT 
    import_status as '导入状态',
    COUNT(*) as '记录数量',
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM temp_msds_import), 2) as '百分比'
FROM temp_msds_import
GROUP BY import_status
UNION ALL
SELECT 
    '总计' as '导入状态',
    COUNT(*) as '记录数量',
    100.00 as '百分比'
FROM temp_msds_import;

-- 6. 使用示例
-- 步骤1: 将Excel数据导入到临时表
-- LOAD DATA INFILE 'msds_import_data.csv' 
-- INTO TABLE temp_msds_import
-- FIELDS TERMINATED BY ',' 
-- ENCLOSED BY '"' 
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS;

-- 步骤2: 验证数据
-- CALL ValidateMsdsImportData();

-- 步骤3: 查看验证结果
-- SELECT * FROM v_msds_import_results;

-- 步骤4: 导入数据
-- CALL ImportMsdsData();

-- 步骤5: 查看导入统计
-- SELECT * FROM v_msds_import_statistics;

-- 步骤6: 查看最终结果
-- SELECT * FROM v_msds_import_results;
