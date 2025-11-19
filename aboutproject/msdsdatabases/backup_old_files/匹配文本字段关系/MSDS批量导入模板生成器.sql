-- =============================================
-- MSDS批量导入模板生成器
-- 基于数据库表结构生成完整的Excel导入模板
-- =============================================

-- 1. 主表字段映射（msds_main）
-- 对应PDF文档中的"1.化学品企业标识"章节
CREATE TEMPORARY TABLE msds_main_template AS
SELECT 
    'cas_number' as field_name, 'CAS登记号' as field_label, 'VARCHAR(50)' as data_type, 'NOT NULL UNIQUE' as constraints, '化学品CAS号' as pdf_mapping,
    'basic' as template_type, 1 as sort_order, '必填' as required_level
UNION ALL SELECT 'msds_code', 'MSDS编号', 'VARCHAR(50)', 'NOT NULL UNIQUE', '技术说明书编码', 'basic', 2, '必填'
UNION ALL SELECT 'product_name', '化学品中文名', 'VARCHAR(255)', 'NOT NULL', '中文名称', 'basic', 3, '必填'
UNION ALL SELECT 'product_alias', '化学品别名', 'VARCHAR(255)', 'NULL', '中文别名', 'basic', 4, '可选'
UNION ALL SELECT 'product_english_name', '化学品英文名', 'VARCHAR(255)', 'NULL', '英文名称', 'basic', 5, '可选'
UNION ALL SELECT 'company_name', '企业名称', 'VARCHAR(255)', 'NOT NULL', '供应商名称', 'basic', 6, '必填'
UNION ALL SELECT 'company_address', '企业地址', 'TEXT', 'NULL', '供应商地址', 'basic', 7, '可选'
UNION ALL SELECT 'contact_phone', '联系电话', 'VARCHAR(50)', 'NOT NULL', '供应商电话', 'basic', 8, '必填'
UNION ALL SELECT 'email', '电子邮件地址', 'VARCHAR(100)', 'NULL', '供应商Email', 'basic', 9, '可选'
UNION ALL SELECT 'emergency_phone', '企业应急电话', 'VARCHAR(50)', 'NULL', '供应商应急电话', 'basic', 10, '可选'
UNION ALL SELECT 'fax_number', '传真号码', 'VARCHAR(50)', 'NULL', '供应商传真', 'basic', 11, '可选'
UNION ALL SELECT 'recommended_usage', '产品推荐用途', 'TEXT', 'NULL', '推荐用途', 'basic', 12, '可选'
UNION ALL SELECT 'restricted_usage', '产品限制用途', 'TEXT', 'NULL', '限制用途', 'basic', 13, '可选'
UNION ALL SELECT 'version', 'MSDS版本号', 'VARCHAR(20)', 'DEFAULT 1.0', '版本号', 'basic', 14, '可选'
UNION ALL SELECT 'revision_date', '修订日期', 'DATE', 'NULL', '修订日期', 'basic', 15, '可选'
UNION ALL SELECT 'effective_date', '生效日期', 'DATE', 'NULL', '生效日期', 'basic', 16, '可选'
UNION ALL SELECT 'status', '状态', 'ENUM', 'DEFAULT draft', '状态', 'basic', 17, '可选'
UNION ALL SELECT 'approver', '审批人', 'VARCHAR(100)', 'NULL', '审批人', 'basic', 18, '可选'
UNION ALL SELECT 'approval_date', '审批日期', 'DATE', 'NULL', '审批日期', 'basic', 19, '可选';

-- 2. 危险性概述表字段映射（msds_hazard）
-- 对应PDF文档中的"2.危险性概述"章节
CREATE TEMPORARY TABLE msds_hazard_template AS
SELECT 
    'emergency_overview' as field_name, '紧急情况概述' as field_label, 'TEXT' as data_type, 'NULL' as constraints, '紧急情况概述' as pdf_mapping,
    'detailed' as template_type, 1 as sort_order, '可选' as required_level
UNION ALL SELECT 'physical_state', '物理状态', 'VARCHAR(50)', 'NULL', '物理状态', 'detailed', 2, '可选'
UNION ALL SELECT 'odor', '气味', 'VARCHAR(100)', 'NULL', '气味', 'detailed', 3, '可选'
UNION ALL SELECT 'color', '颜色', 'VARCHAR(50)', 'NULL', '颜色', 'detailed', 4, '可选'
UNION ALL SELECT 'warning_word', '警示词', 'ENUM', 'NULL', '警示词', 'detailed', 5, '可选'
UNION ALL SELECT 'hazard_category', '危险性类别', 'VARCHAR(255)', 'NULL', '危险性类别', 'detailed', 6, '可选'
UNION ALL SELECT 'exposure_routes', '侵入途径', 'VARCHAR(255)', 'NULL', '侵入途径', 'detailed', 7, '可选'
UNION ALL SELECT 'health_hazards', '健康危害', 'TEXT', 'NULL', '健康危害', 'detailed', 8, '可选'
UNION ALL SELECT 'environmental_hazards', '环境危害', 'TEXT', 'NULL', '环境危害', 'detailed', 9, '可选'
UNION ALL SELECT 'fire_explosion_hazards', '燃爆危险', 'TEXT', 'NULL', '燃爆危险', 'detailed', 10, '可选'
UNION ALL SELECT 'hazard_description', '危险性说明', 'TEXT', 'NULL', '危险性说明', 'detailed', 11, '可选'
UNION ALL SELECT 'prevention_measures', '预防措施', 'TEXT', 'NULL', '预防措施', 'detailed', 12, '可选'
UNION ALL SELECT 'response_measures', '响应措施', 'TEXT', 'NULL', '响应措施', 'detailed', 13, '可选'
UNION ALL SELECT 'storage_measures', '储存措施', 'TEXT', 'NULL', '储存措施', 'detailed', 14, '可选'
UNION ALL SELECT 'disposal_measures', '废弃处置措施', 'TEXT', 'NULL', '废弃处置措施', 'detailed', 15, '可选';

-- 3. 成分组成信息表字段映射（msds_component）
-- 对应PDF文档中的"3.成分组成信息"章节
CREATE TEMPORARY TABLE msds_component_template AS
SELECT 
    'component_name' as field_name, '成分名称' as field_label, 'VARCHAR(255)' as data_type, 'NOT NULL' as constraints, '成分名称' as pdf_mapping,
    'detailed' as template_type, 1 as sort_order, '必填' as required_level
UNION ALL SELECT 'component_english_name', '成分英文名', 'VARCHAR(255)', 'NULL', '成分英文名', 'detailed', 2, '可选'
UNION ALL SELECT 'component_content', '成分含量/浓度', 'VARCHAR(100)', 'NULL', '含量', 'detailed', 3, '可选'
UNION ALL SELECT 'content_min', '含量下限(%)', 'DECIMAL(10,4)', 'NULL', '含量下限', 'detailed', 4, '可选'
UNION ALL SELECT 'content_max', '含量上限(%)', 'DECIMAL(10,4)', 'NULL', '含量上限', 'detailed', 5, '可选'
UNION ALL SELECT 'cas_number', 'CAS登记号', 'VARCHAR(50)', 'NULL', 'CAS号', 'detailed', 6, '可选'
UNION ALL SELECT 'ec_number', 'EC号', 'VARCHAR(50)', 'NULL', 'EC号', 'detailed', 7, '可选'
UNION ALL SELECT 'molecular_formula', '分子式', 'VARCHAR(100)', 'NULL', '分子式', 'detailed', 8, '可选'
UNION ALL SELECT 'molecular_weight', '分子量', 'DECIMAL(10,2)', 'NULL', '分子量', 'detailed', 9, '可选'
UNION ALL SELECT 'is_hazardous', '是否为危险成分', 'TINYINT(1)', 'DEFAULT 0', '危险成分标识', 'detailed', 10, '可选'
UNION ALL SELECT 'hazard_level', '危险等级', 'VARCHAR(50)', 'NULL', '危险等级', 'detailed', 11, '可选'
UNION ALL SELECT 'component_function', '成分功能', 'VARCHAR(100)', 'NULL', '成分功能', 'detailed', 12, '可选';

-- 4. 急救措施表字段映射（msds_first_aid）
-- 对应PDF文档中的"4.急救措施"章节
CREATE TEMPORARY TABLE msds_first_aid_template AS
SELECT 
    'skin_contact' as field_name, '皮肤接触处理措施' as field_label, 'TEXT' as data_type, 'NULL' as constraints, '皮肤接触处理措施' as pdf_mapping,
    'detailed' as template_type, 1 as sort_order, '可选' as required_level
UNION ALL SELECT 'eye_contact', '眼睛接触处理措施', 'TEXT', 'NULL', '眼睛接触处理措施', 'detailed', 2, '可选'
UNION ALL SELECT 'inhalation', '吸入处理措施', 'TEXT', 'NULL', '吸入处理措施', 'detailed', 3, '可选'
UNION ALL SELECT 'ingestion', '食入处理措施', 'TEXT', 'NULL', '食入处理措施', 'detailed', 4, '可选'
UNION ALL SELECT 'general_notes', '一般注意事项', 'TEXT', 'NULL', '一般注意事项', 'detailed', 5, '可选'
UNION ALL SELECT 'symptoms_effects', '可能出现的症状和健康影响', 'TEXT', 'NULL', '症状和健康影响', 'detailed', 6, '可选'
UNION ALL SELECT 'immediate_medical_attention', '需要立即就医的情况', 'TEXT', 'NULL', '立即就医情况', 'detailed', 7, '可选'
UNION ALL SELECT 'antidote_treatment', '解毒剂及治疗方法', 'TEXT', 'NULL', '解毒剂及治疗方法', 'detailed', 8, '可选';

-- 5. 消防措施表字段映射（msds_fire_fighting）
-- 对应PDF文档中的"5.消防措施"章节
CREATE TEMPORARY TABLE msds_fire_fighting_template AS
SELECT 
    'hazard_characteristics' as field_name, '危险特性' as field_label, 'TEXT' as data_type, 'NULL' as constraints, '危险特性' as pdf_mapping,
    'detailed' as template_type, 1 as sort_order, '可选' as required_level
UNION ALL SELECT 'harmful_combustion_products', '有害燃烧产物', 'TEXT', 'NULL', '有害燃烧产物', 'detailed', 2, '可选'
UNION ALL SELECT 'suitable_extinguishing_media', '适宜的灭火介质', 'TEXT', 'NULL', '灭火方法', 'detailed', 3, '可选'
UNION ALL SELECT 'unsuitable_extinguishing_media', '不适宜的灭火介质', 'TEXT', 'NULL', '不适宜灭火介质', 'detailed', 4, '可选'
UNION ALL SELECT 'fire_fighting_equipment', '消防设备和防护装备', 'TEXT', 'NULL', '消防设备', 'detailed', 5, '可选'
UNION ALL SELECT 'fire_fighting_procedures', '特殊消防程序', 'TEXT', 'NULL', '特殊消防程序', 'detailed', 6, '可选'
UNION ALL SELECT 'flash_point', '闪点', 'VARCHAR(50)', 'NULL', '闪点', 'detailed', 7, '可选'
UNION ALL SELECT 'autoignition_temperature', '自燃温度', 'VARCHAR(50)', 'NULL', '自燃温度', 'detailed', 8, '可选'
UNION ALL SELECT 'flammability_limits', '燃烧性/爆炸极限', 'TEXT', 'NULL', '爆炸极限', 'detailed', 9, '可选'
UNION ALL SELECT 'fire_risk_classification', '建规火险分级', 'VARCHAR(50)', 'NULL', '建规火险分级', 'detailed', 10, '可选';

-- 6. 泄漏应急处理表字段映射（msds_leak_response）
-- 对应PDF文档中的"6.泄漏应急处理"章节
CREATE TEMPORARY TABLE msds_leak_response_template AS
SELECT 
    'personal_precautions' as field_name, '个人防护措施' as field_label, 'TEXT' as data_type, 'NULL' as constraints, '个人防护措施' as pdf_mapping,
    'detailed' as template_type, 1 as sort_order, '可选' as required_level
UNION ALL SELECT 'environmental_precautions', '环境保护措施', 'TEXT', 'NULL', '环境保护措施', 'detailed', 2, '可选'
UNION ALL SELECT 'containment_cleanup', '泄漏化学品的收容、清除方法', 'TEXT', 'NULL', '收容清除方法', 'detailed', 3, '可选'
UNION ALL SELECT 'emergency_procedures', '应急处理程序', 'TEXT', 'NULL', '应急处理', 'detailed', 4, '可选'
UNION ALL SELECT 'elimination_methods', '消除方法', 'TEXT', 'NULL', '消除方法', 'detailed', 5, '可选'
UNION ALL SELECT 'equipment_materials', '清理时使用的器材', 'TEXT', 'NULL', '清理器材', 'detailed', 6, '可选'
UNION ALL SELECT 'prevent_secondary_hazards', '防止发生次生危害的预防措施', 'TEXT', 'NULL', '防止次生危害', 'detailed', 7, '可选';

-- 7. 操作处置与储存表字段映射（msds_handling_storage）
-- 对应PDF文档中的"7.操作处置与储存"章节
CREATE TEMPORARY TABLE msds_handling_storage_template AS
SELECT 
    'handling_precautions' as field_name, '操作注意事项' as field_label, 'TEXT' as data_type, 'NULL' as constraints, '操作注意事项' as pdf_mapping,
    'detailed' as template_type, 1 as sort_order, '可选' as required_level
UNION ALL SELECT 'storage_precautions', '储存注意事项', 'TEXT', 'NULL', '储存注意事项', 'detailed', 2, '可选'
UNION ALL SELECT 'optimal_temperature', '最佳储存温度', 'VARCHAR(50)', 'NULL', '最佳储存温度', 'detailed', 3, '可选'
UNION ALL SELECT 'temperature_range', '储存温度范围', 'VARCHAR(50)', 'NULL', '储存温度范围', 'detailed', 4, '可选'
UNION ALL SELECT 'humidity_requirements', '湿度要求', 'VARCHAR(50)', 'NULL', '湿度要求', 'detailed', 5, '可选'
UNION ALL SELECT 'storage_container', '储存容器要求', 'TEXT', 'NULL', '储存容器要求', 'detailed', 6, '可选'
UNION ALL SELECT 'incompatible_materials', '不相容的物质', 'TEXT', 'NULL', '不相容物质', 'detailed', 7, '可选'
UNION ALL SELECT 'storage_area_requirements', '储存区域要求', 'TEXT', 'NULL', '储存区域要求', 'detailed', 8, '可选'
UNION ALL SELECT 'shelf_life', '保质期', 'VARCHAR(50)', 'NULL', '保质期', 'detailed', 9, '可选';

-- 8. 接触控制/个体防护表字段映射（msds_exposure_control）
-- 对应PDF文档中的"8.接触控制/个体防护"章节
CREATE TEMPORARY TABLE msds_exposure_control_template AS
SELECT 
    'occupational_exposure_limit' as field_name, '职业接触限值' as field_label, 'TEXT' as data_type, 'NULL' as constraints, '接触限值' as pdf_mapping,
    'detailed' as template_type, 1 as sort_order, '可选' as required_level
UNION ALL SELECT 'china_mac', '中国MAC值(mg/m³)', 'VARCHAR(50)', 'NULL', '中国MAC(mg/m3)', 'detailed', 2, '可选'
UNION ALL SELECT 'usa_tlv_twa', '美国TLV-TWA值(mg/m³)', 'VARCHAR(50)', 'NULL', '美国TLV-TWA', 'detailed', 3, '可选'
UNION ALL SELECT 'usa_tlv_stel', '美国TLV-STEL值(mg/m³)', 'VARCHAR(50)', 'NULL', '美国TLV-STEL', 'detailed', 4, '可选'
UNION ALL SELECT 'former_soviet_mac', '前苏联MAC值(mg/m³)', 'VARCHAR(50)', 'NULL', '前苏联MAC', 'detailed', 5, '可选'
UNION ALL SELECT 'tlv_tn', 'TLV-TN值(mg/m³)', 'VARCHAR(50)', 'NULL', 'TLV-TN', 'detailed', 6, '可选'
UNION ALL SELECT 'tlv_wn', 'TLV-WN值(mg/m³)', 'VARCHAR(50)', 'NULL', 'TLV-WN', 'detailed', 7, '可选'
UNION ALL SELECT 'monitoring_method', '监测方法', 'TEXT', 'NULL', '监测方法', 'detailed', 8, '可选'
UNION ALL SELECT 'engineering_controls', '工程控制措施', 'TEXT', 'NULL', '工程控制', 'detailed', 9, '可选'
UNION ALL SELECT 'respiratory_protection', '呼吸系统防护', 'TEXT', 'NULL', '呼吸系统防护', 'detailed', 10, '可选'
UNION ALL SELECT 'eye_protection', '眼睛防护', 'TEXT', 'NULL', '眼睛防护', 'detailed', 11, '可选'
UNION ALL SELECT 'body_protection', '身体防护', 'TEXT', 'NULL', '身体防护', 'detailed', 12, '可选'
UNION ALL SELECT 'hand_protection', '手部防护', 'TEXT', 'NULL', '手防护', 'detailed', 13, '可选'
UNION ALL SELECT 'other_protection', '其他防护措施', 'TEXT', 'NULL', '其他防护', 'detailed', 14, '可选'
UNION ALL SELECT 'hygiene_measures', '卫生措施', 'TEXT', 'NULL', '卫生措施', 'detailed', 15, '可选';

-- 9. 理化特性表字段映射（msds_physical_chemical）
-- 对应PDF文档中的"9.理化特性"章节
CREATE TEMPORARY TABLE msds_physical_chemical_template AS
SELECT 
    'appearance' as field_name, '外观与性状' as field_label, 'VARCHAR(255)' as data_type, 'NULL' as constraints, '外观与性状' as pdf_mapping,
    'detailed' as template_type, 1 as sort_order, '可选' as required_level
UNION ALL SELECT 'odor', '气味', 'VARCHAR(100)', 'NULL', '气味', 'detailed', 2, '可选'
UNION ALL SELECT 'odor_threshold', '气味阈值', 'VARCHAR(50)', 'NULL', '气味阈值', 'detailed', 3, '可选'
UNION ALL SELECT 'melting_point', '熔点(℃)', 'VARCHAR(50)', 'NULL', '熔点(°C)', 'detailed', 4, '可选'
UNION ALL SELECT 'boiling_point', '沸点(℃)', 'VARCHAR(50)', 'NULL', '沸点(°C)', 'detailed', 5, '可选'
UNION ALL SELECT 'relative_density', '相对密度(水=1)', 'VARCHAR(50)', 'NULL', '相对密度(水=1)', 'detailed', 6, '可选'
UNION ALL SELECT 'vapor_density', '蒸气密度(空气=1)', 'VARCHAR(50)', 'NULL', '相对蒸气密度(空气=1)', 'detailed', 7, '可选'
UNION ALL SELECT 'vapor_pressure', '蒸气压(kPa)', 'VARCHAR(50)', 'NULL', '饱和蒸气压(kPa)', 'detailed', 8, '可选'
UNION ALL SELECT 'vapor_pressure_temp', '蒸气压测定温度(℃)', 'VARCHAR(20)', 'NULL', '蒸气压测定温度', 'detailed', 9, '可选'
UNION ALL SELECT 'solubility', '溶解性', 'TEXT', 'NULL', '溶解性', 'detailed', 10, '可选'
UNION ALL SELECT 'water_solubility', '水中溶解度', 'VARCHAR(100)', 'NULL', '水中溶解度', 'detailed', 11, '可选'
UNION ALL SELECT 'ph_value', 'pH值', 'VARCHAR(20)', 'NULL', 'pH', 'detailed', 12, '可选'
UNION ALL SELECT 'ph_concentration', 'pH值浓度条件', 'VARCHAR(50)', 'NULL', 'pH浓度条件', 'detailed', 13, '可选'
UNION ALL SELECT 'flash_point', '闪点(℃)', 'VARCHAR(50)', 'NULL', '闪点(°C)', 'detailed', 14, '可选'
UNION ALL SELECT 'ignition_temperature', '引燃温度(℃)', 'VARCHAR(50)', 'NULL', '引燃温度(°C)', 'detailed', 15, '可选'
UNION ALL SELECT 'explosive_limit_lower', '爆炸下限(%)', 'VARCHAR(50)', 'NULL', '爆炸下限%(V/V)', 'detailed', 16, '可选'
UNION ALL SELECT 'explosive_limit_upper', '爆炸上限(%)', 'VARCHAR(50)', 'NULL', '爆炸上限%(V/V)', 'detailed', 17, '可选'
UNION ALL SELECT 'viscosity', '粘度', 'VARCHAR(50)', 'NULL', '粘度', 'detailed', 18, '可选'
UNION ALL SELECT 'partition_coefficient', '分配系数(正辛醇/水)', 'VARCHAR(50)', 'NULL', '辛醇/水分配系数的对数值', 'detailed', 19, '可选'
UNION ALL SELECT 'decomposition_temperature', '分解温度(℃)', 'VARCHAR(50)', 'NULL', '分解温度', 'detailed', 20, '可选'
UNION ALL SELECT 'molecular_formula', '分子式', 'VARCHAR(100)', 'NULL', '分子式', 'detailed', 21, '可选'
UNION ALL SELECT 'main_components', '主要成分', 'TEXT', 'NULL', '主要成分', 'detailed', 22, '可选'
UNION ALL SELECT 'critical_temperature', '临界温度(℃)', 'VARCHAR(50)', 'NULL', '临界温度(°C)', 'detailed', 23, '可选'
UNION ALL SELECT 'autoignition_temperature', '自燃温度', 'VARCHAR(50)', 'NULL', '自燃温度', 'detailed', 24, '可选'
UNION ALL SELECT 'flammability', '燃烧性', 'VARCHAR(50)', 'NULL', '燃烧性', 'detailed', 25, '可选'
UNION ALL SELECT 'molecular_weight', '分子量', 'VARCHAR(50)', 'NULL', '分子量', 'detailed', 26, '可选'
UNION ALL SELECT 'heat_of_combustion', '燃烧热(kJ/mol)', 'VARCHAR(50)', 'NULL', '燃烧热(kJ/mol)', 'detailed', 27, '可选'
UNION ALL SELECT 'critical_pressure', '临界压力(MPa)', 'VARCHAR(50)', 'NULL', '临界压力(MPa)', 'detailed', 28, '可选'
UNION ALL SELECT 'main_usage', '主要用途', 'TEXT', 'NULL', '主要用途', 'detailed', 29, '可选'
UNION ALL SELECT 'other_properties', '其它理化性质', 'TEXT', 'NULL', '其它理化性质', 'detailed', 30, '可选';

-- 10. 稳定性和反应性表字段映射（msds_stability_reactivity）
-- 对应PDF文档中的"10.稳定性和反应活性"章节
CREATE TEMPORARY TABLE msds_stability_reactivity_template AS
SELECT 
    'stability' as field_name, '稳定性' as field_label, 'TEXT' as data_type, 'NULL' as constraints, '稳定性' as pdf_mapping,
    'detailed' as template_type, 1 as sort_order, '可选' as required_level
UNION ALL SELECT 'reactivity', '反应性', 'TEXT', 'NULL', '反应性', 'detailed', 2, '可选'
UNION ALL SELECT 'incompatible_substances', '禁配物', 'TEXT', 'NULL', '禁配物', 'detailed', 3, '可选'
UNION ALL SELECT 'conditions_to_avoid', '避免接触的条件', 'TEXT', 'NULL', '避免接触的条件', 'detailed', 4, '可选'
UNION ALL SELECT 'hazardous_reactions', '可能的危险反应', 'TEXT', 'NULL', '危险反应', 'detailed', 5, '可选'
UNION ALL SELECT 'polymerization_hazard', '聚合危害', 'TEXT', 'NULL', '聚合危害', 'detailed', 6, '可选'
UNION ALL SELECT 'polymerization_conditions', '聚合反应条件', 'TEXT', 'NULL', '聚合反应条件', 'detailed', 7, '可选'
UNION ALL SELECT 'decomposition_products', '分解产物', 'TEXT', 'NULL', '分解产物', 'detailed', 8, '可选'
UNION ALL SELECT 'decomposition_conditions', '分解条件', 'TEXT', 'NULL', '分解条件', 'detailed', 9, '可选';

-- 11. 毒理学资料表字段映射（msds_toxicological）
-- 对应PDF文档中的"11.毒理学信息"章节
CREATE TEMPORARY TABLE msds_toxicological_template AS
SELECT 
    'acute_toxicity' as field_name, '急性毒性' as field_label, 'TEXT' as data_type, 'NULL' as constraints, '急性毒性' as pdf_mapping,
    'detailed' as template_type, 1 as sort_order, '可选' as required_level
UNION ALL SELECT 'ld50_oral', 'LD50(经口,大鼠)', 'VARCHAR(100)', 'NULL', 'LD50经口', 'detailed', 2, '可选'
UNION ALL SELECT 'ld50_dermal', 'LD50(经皮,兔)', 'VARCHAR(100)', 'NULL', 'LD50经皮', 'detailed', 3, '可选'
UNION ALL SELECT 'lc50_inhalation', 'LC50(吸入,大鼠)', 'VARCHAR(100)', 'NULL', 'LC50吸入', 'detailed', 4, '可选'
UNION ALL SELECT 'subacute_chronic', '亚急性和慢性毒性', 'TEXT', 'NULL', '亚急性和慢性毒性', 'detailed', 5, '可选'
UNION ALL SELECT 'skin_irritation', '皮肤刺激性', 'TEXT', 'NULL', '刺激性', 'detailed', 6, '可选'
UNION ALL SELECT 'eye_irritation', '眼睛刺激性', 'TEXT', 'NULL', '刺激性', 'detailed', 7, '可选'
UNION ALL SELECT 'respiratory_irritation', '呼吸道刺激性', 'TEXT', 'NULL', '刺激性', 'detailed', 8, '可选'
UNION ALL SELECT 'sensitization', '致敏性', 'TEXT', 'NULL', '致敏性', 'detailed', 9, '可选'
UNION ALL SELECT 'mutagenicity', '致突变性', 'TEXT', 'NULL', '致突变性', 'detailed', 10, '可选'
UNION ALL SELECT 'teratogenicity', '致畸性', 'TEXT', 'NULL', '致畸性', 'detailed', 11, '可选'
UNION ALL SELECT 'reproductive_toxicity', '生殖毒性', 'TEXT', 'NULL', '生殖毒性', 'detailed', 12, '可选'
UNION ALL SELECT 'carcinogenicity', '致癌性', 'TEXT', 'NULL', '致癌性', 'detailed', 13, '可选'
UNION ALL SELECT 'carcinogen_classification', '致癌物分类', 'TEXT', 'NULL', '致癌物分类', 'detailed', 14, '可选'
UNION ALL SELECT 'specific_target_organ', '特定目标器官毒性', 'TEXT', 'NULL', '特定器官毒性', 'detailed', 15, '可选'
UNION ALL SELECT 'aspiration_hazard', '吸入危害', 'TEXT', 'NULL', '吸入危害', 'detailed', 16, '可选'
UNION ALL SELECT 'other_toxicity', '其他毒理学资料', 'TEXT', 'NULL', '其他毒理学资料', 'detailed', 17, '可选'
UNION ALL SELECT 'rtecs', 'RTECS编号', 'VARCHAR(100)', 'NULL', 'RTECS', 'detailed', 18, '可选';

-- 12. 生态学资料表字段映射（msds_ecological）
-- 对应PDF文档中的"12.生态学资料"章节
CREATE TEMPORARY TABLE msds_ecological_template AS
SELECT 
    'ecological_toxicity' as field_name, '生态毒性' as field_label, 'TEXT' as data_type, 'NULL' as constraints, '生态毒理毒性' as pdf_mapping,
    'detailed' as template_type, 1 as sort_order, '可选' as required_level
UNION ALL SELECT 'fish_toxicity', '鱼类毒性', 'VARCHAR(100)', 'NULL', '鱼类毒性', 'detailed', 2, '可选'
UNION ALL SELECT 'invertebrate_toxicity', '无脊椎动物毒性', 'VARCHAR(100)', 'NULL', '无脊椎动物毒性', 'detailed', 3, '可选'
UNION ALL SELECT 'algae_toxicity', '藻类毒性', 'VARCHAR(100)', 'NULL', '藻类毒性', 'detailed', 4, '可选'
UNION ALL SELECT 'bacteria_toxicity', '细菌毒性', 'VARCHAR(100)', 'NULL', '细菌毒性', 'detailed', 5, '可选'
UNION ALL SELECT 'biodegradability', '生物降解性', 'TEXT', 'NULL', '生物降解性', 'detailed', 6, '可选'
UNION ALL SELECT 'biodegradation_rate', '生物降解速率', 'VARCHAR(50)', 'NULL', '生物降解速率', 'detailed', 7, '可选'
UNION ALL SELECT 'non_biodegradability', '非生物降解性', 'TEXT', 'NULL', '非生物降解性', 'detailed', 8, '可选'
UNION ALL SELECT 'photodegradation', '光降解', 'TEXT', 'NULL', '光降解', 'detailed', 9, '可选'
UNION ALL SELECT 'hydrolysis', '水解', 'TEXT', 'NULL', '水解', 'detailed', 10, '可选'
UNION ALL SELECT 'bioaccumulation', '生物富集或生物积累性', 'TEXT', 'NULL', '生物富集或生物积累性', 'detailed', 11, '可选'
UNION ALL SELECT 'bioconcentration_factor', '生物富集因子', 'VARCHAR(50)', 'NULL', '生物富集因子', 'detailed', 12, '可选'
UNION ALL SELECT 'mobility_in_soil', '土壤中迁移性', 'TEXT', 'NULL', '土壤中迁移性', 'detailed', 13, '可选'
UNION ALL SELECT 'other_environmental_effects', '其它有害作用', 'TEXT', 'NULL', '其它有害作用', 'detailed', 14, '可选'
UNION ALL SELECT 'ozone_depletion_potential', '臭氧消耗潜能值', 'VARCHAR(50)', 'NULL', '臭氧消耗潜能值', 'detailed', 15, '可选'
UNION ALL SELECT 'global_warming_potential', '全球变暖潜能值', 'VARCHAR(50)', 'NULL', '全球变暖潜能值', 'detailed', 16, '可选';

-- 13. 废弃处置表字段映射（msds_disposal）
-- 对应PDF文档中的"13.废弃处置"章节
CREATE TEMPORARY TABLE msds_disposal_template AS
SELECT 
    'waste_properties' as field_name, '废弃物性质' as field_label, 'TEXT' as data_type, 'NULL' as constraints, '废弃物性质' as pdf_mapping,
    'detailed' as template_type, 1 as sort_order, '可选' as required_level
UNION ALL SELECT 'disposal_method', '废弃处置方法', 'TEXT', 'NULL', '废弃处置方法', 'detailed', 2, '可选'
UNION ALL SELECT 'disposal_precautions', '废弃注意事项', 'TEXT', 'NULL', '废弃注意事项', 'detailed', 3, '可选'
UNION ALL SELECT 'disposal_regulations', '废弃处置相关法规', 'TEXT', 'NULL', '废弃处置法规', 'detailed', 4, '可选'
UNION ALL SELECT 'container_disposal', '包装容器的处置', 'TEXT', 'NULL', '包装容器处置', 'detailed', 5, '可选'
UNION ALL SELECT 'recommended_disposal', '推荐的处置方法', 'TEXT', 'NULL', '推荐处置方法', 'detailed', 6, '可选'
UNION ALL SELECT 'prohibited_disposal', '禁止的处置方法', 'TEXT', 'NULL', '禁止处置方法', 'detailed', 7, '可选'
UNION ALL SELECT 'neutralization_method', '中和处理方法', 'TEXT', 'NULL', '中和处理方法', 'detailed', 8, '可选';

-- 14. 运输信息表字段映射（msds_transportation）
-- 对应PDF文档中的"14.运输信息"章节
CREATE TEMPORARY TABLE msds_transportation_template AS
SELECT 
    'dangerous_goods_number' as field_name, '危险货物编号' as field_label, 'VARCHAR(50)' as data_type, 'NULL' as constraints, '危险货物编号' as pdf_mapping,
    'detailed' as template_type, 1 as sort_order, '可选' as required_level
UNION ALL SELECT 'un_number', 'UN编号', 'VARCHAR(50)', 'NULL', 'UN编号', 'detailed', 2, '可选'
UNION ALL SELECT 'proper_shipping_name', '正确运输名称', 'VARCHAR(255)', 'NULL', '正确运输名称', 'detailed', 3, '可选'
UNION ALL SELECT 'transport_hazard_class', '运输危险类别', 'VARCHAR(50)', 'NULL', '运输危险类别', 'detailed', 4, '可选'
UNION ALL SELECT 'packing_group', '包装类别', 'VARCHAR(10)', 'NULL', '包装类别', 'detailed', 5, '可选'
UNION ALL SELECT 'packaging_marks', '包装标志', 'TEXT', 'NULL', '包装标志', 'detailed', 6, '可选'
UNION ALL SELECT 'packaging_method', '包装方法', 'TEXT', 'NULL', '包装方法', 'detailed', 7, '可选'
UNION ALL SELECT 'marine_pollutant', '海洋污染物', 'TINYINT(1)', 'DEFAULT 0', '海洋污染物', 'detailed', 8, '可选'
UNION ALL SELECT 'transport_in_bulk', '散装运输要求', 'TEXT', 'NULL', '散装运输要求', 'detailed', 9, '可选'
UNION ALL SELECT 'transportation_precautions', '运输注意事项', 'TEXT', 'NULL', '运输注意事项', 'detailed', 10, '可选'
UNION ALL SELECT 'emergency_response_guide', '应急响应指南编号', 'VARCHAR(50)', 'NULL', '应急响应指南', 'detailed', 11, '可选'
UNION ALL SELECT 'imdg_rule_page', 'IMDG规则页码', 'VARCHAR(50)', 'NULL', 'IMDG规则页码字段', 'detailed', 12, '可选';

-- 15. 法规信息表字段映射（msds_regulatory）
-- 对应PDF文档中的"15.法规信息"章节
CREATE TEMPORARY TABLE msds_regulatory_template AS
SELECT 
    'regulatory_info' as field_name, '法规信息综述' as field_label, 'TEXT' as data_type, 'NULL' as constraints, '法规信息' as pdf_mapping,
    'detailed' as template_type, 1 as sort_order, '可选' as required_level
UNION ALL SELECT 'domestic_regulations', '国内法规', 'TEXT', 'NULL', '国内法规', 'detailed', 2, '可选'
UNION ALL SELECT 'international_regulations', '国际法规', 'TEXT', 'NULL', '国际法规', 'detailed', 3, '可选'
UNION ALL SELECT 'china_dangerous_chemicals', '中国危险化学品目录', 'TINYINT(1)', 'DEFAULT 0', '中国危险化学品目录', 'detailed', 4, '可选'
UNION ALL SELECT 'china_controlled_chemicals', '中国管制化学品', 'TINYINT(1)', 'DEFAULT 0', '中国管制化学品', 'detailed', 5, '可选'
UNION ALL SELECT 'reach_registration', 'REACH注册情况', 'TEXT', 'NULL', 'REACH注册情况', 'detailed', 6, '可选'
UNION ALL SELECT 'tsca_inventory', 'TSCA清单', 'TINYINT(1)', 'DEFAULT 0', 'TSCA清单', 'detailed', 7, '可选'
UNION ALL SELECT 'einecs_number', 'EINECS号', 'VARCHAR(50)', 'NULL', 'EINECS号', 'detailed', 8, '可选'
UNION ALL SELECT 'prohibited_restricted', '禁用/限用情况', 'TEXT', 'NULL', '禁用限用情况', 'detailed', 9, '可选'
UNION ALL SELECT 'special_provisions', '特殊规定', 'TEXT', 'NULL', '特殊规定', 'detailed', 10, '可选';

-- 16. 其他信息表字段映射（msds_other_info）
-- 对应PDF文档中的"16.其他信息"章节
CREATE TEMPORARY TABLE msds_other_info_template AS
SELECT 
    'references' as field_name, '参考文献' as field_label, 'TEXT' as data_type, 'NULL' as constraints, '参考文献' as pdf_mapping,
    'detailed' as template_type, 1 as sort_order, '可选' as required_level
UNION ALL SELECT 'data_sources', '数据来源', 'TEXT', 'NULL', '数据来源', 'detailed', 2, '可选'
UNION ALL SELECT 'form_fill_time', '填表时间', 'DATE', 'NULL', '填表时间', 'detailed', 3, '可选'
UNION ALL SELECT 'form_fill_department', '填表部门', 'VARCHAR(100)', 'NULL', '填表部门', 'detailed', 4, '可选'
UNION ALL SELECT 'form_fill_person', '填表人', 'VARCHAR(100)', 'NULL', '填表人', 'detailed', 5, '可选'
UNION ALL SELECT 'data_audit_unit', '数据审核单位', 'VARCHAR(100)', 'NULL', '数据审核单位', 'detailed', 6, '可选'
UNION ALL SELECT 'data_audit_person', '数据审核人', 'VARCHAR(100)', 'NULL', '数据审核人', 'detailed', 7, '可选'
UNION ALL SELECT 'technical_review_person', '技术审查人', 'VARCHAR(100)', 'NULL', '技术审查人', 'detailed', 8, '可选'
UNION ALL SELECT 'modification_notes', '修改说明', 'TEXT', 'NULL', '修改说明', 'detailed', 9, '可选'
UNION ALL SELECT 'training_requirements', '培训要求', 'TEXT', 'NULL', '培训要求', 'detailed', 10, '可选'
UNION ALL SELECT 'additional_information', '其他信息', 'TEXT', 'NULL', '其他信息', 'detailed', 11, '可选'
UNION ALL SELECT 'disclaimer', '免责声明', 'TEXT', 'NULL', '免责声明', 'detailed', 12, '可选';

-- 生成完整的字段映射汇总表
CREATE TEMPORARY TABLE msds_field_mapping_summary AS
SELECT 
    'msds_main' as table_name, 'MSDS主信息表' as table_label, '1.化学品企业标识' as pdf_section,
    field_name, field_label, data_type, constraints, pdf_mapping, template_type, sort_order, required_level
FROM msds_main_template
UNION ALL
SELECT 'msds_hazard', '危险性概述表', '2.危险性概述', field_name, field_label, data_type, constraints, pdf_mapping, template_type, sort_order, required_level
FROM msds_hazard_template
UNION ALL
SELECT 'msds_component', '成分组成信息表', '3.成分组成信息', field_name, field_label, data_type, constraints, pdf_mapping, template_type, sort_order, required_level
FROM msds_component_template
UNION ALL
SELECT 'msds_first_aid', '急救措施表', '4.急救措施', field_name, field_label, data_type, constraints, pdf_mapping, template_type, sort_order, required_level
FROM msds_first_aid_template
UNION ALL
SELECT 'msds_fire_fighting', '消防措施表', '5.消防措施', field_name, field_label, data_type, constraints, pdf_mapping, template_type, sort_order, required_level
FROM msds_fire_fighting_template
UNION ALL
SELECT 'msds_leak_response', '泄漏应急处理表', '6.泄漏应急处理', field_name, field_label, data_type, constraints, pdf_mapping, template_type, sort_order, required_level
FROM msds_leak_response_template
UNION ALL
SELECT 'msds_handling_storage', '操作处置与储存表', '7.操作处置与储存', field_name, field_label, data_type, constraints, pdf_mapping, template_type, sort_order, required_level
FROM msds_handling_storage_template
UNION ALL
SELECT 'msds_exposure_control', '接触控制/个体防护表', '8.接触控制/个体防护', field_name, field_label, data_type, constraints, pdf_mapping, template_type, sort_order, required_level
FROM msds_exposure_control_template
UNION ALL
SELECT 'msds_physical_chemical', '理化特性表', '9.理化特性', field_name, field_label, data_type, constraints, pdf_mapping, template_type, sort_order, required_level
FROM msds_physical_chemical_template
UNION ALL
SELECT 'msds_stability_reactivity', '稳定性和反应性表', '10.稳定性和反应活性', field_name, field_label, data_type, constraints, pdf_mapping, template_type, sort_order, required_level
FROM msds_stability_reactivity_template
UNION ALL
SELECT 'msds_toxicological', '毒理学资料表', '11.毒理学信息', field_name, field_label, data_type, constraints, pdf_mapping, template_type, sort_order, required_level
FROM msds_toxicological_template
UNION ALL
SELECT 'msds_ecological', '生态学资料表', '12.生态学资料', field_name, field_label, data_type, constraints, pdf_mapping, template_type, sort_order, required_level
FROM msds_ecological_template
UNION ALL
SELECT 'msds_disposal', '废弃处置表', '13.废弃处置', field_name, field_label, data_type, constraints, pdf_mapping, template_type, sort_order, required_level
FROM msds_disposal_template
UNION ALL
SELECT 'msds_transportation', '运输信息表', '14.运输信息', field_name, field_label, data_type, constraints, pdf_mapping, template_type, sort_order, required_level
FROM msds_transportation_template
UNION ALL
SELECT 'msds_regulatory', '法规信息表', '15.法规信息', field_name, field_label, data_type, constraints, pdf_mapping, template_type, sort_order, required_level
FROM msds_regulatory_template
UNION ALL
SELECT 'msds_other_info', '其他信息表', '16.其他信息', field_name, field_label, data_type, constraints, pdf_mapping, template_type, sort_order, required_level
FROM msds_other_info_template;

-- 查询所有字段映射关系
SELECT 
    table_name as '数据库表名',
    table_label as '表中文名',
    pdf_section as 'PDF章节',
    field_name as '数据库字段名',
    field_label as '字段中文名',
    data_type as '数据类型',
    constraints as '约束条件',
    pdf_mapping as 'PDF文档对应字段',
    template_type as '模板类型',
    sort_order as '排序',
    required_level as '必填级别'
FROM msds_field_mapping_summary
ORDER BY 
    CASE table_name
        WHEN 'msds_main' THEN 1
        WHEN 'msds_hazard' THEN 2
        WHEN 'msds_component' THEN 3
        WHEN 'msds_first_aid' THEN 4
        WHEN 'msds_fire_fighting' THEN 5
        WHEN 'msds_leak_response' THEN 6
        WHEN 'msds_handling_storage' THEN 7
        WHEN 'msds_exposure_control' THEN 8
        WHEN 'msds_physical_chemical' THEN 9
        WHEN 'msds_stability_reactivity' THEN 10
        WHEN 'msds_toxicological' THEN 11
        WHEN 'msds_ecological' THEN 12
        WHEN 'msds_disposal' THEN 13
        WHEN 'msds_transportation' THEN 14
        WHEN 'msds_regulatory' THEN 15
        WHEN 'msds_other_info' THEN 16
    END,
    sort_order;

-- 生成基础模板字段（仅包含必填字段）
SELECT 
    table_name as '数据库表名',
    field_name as '数据库字段名',
    field_label as '字段中文名',
    data_type as '数据类型',
    pdf_mapping as 'PDF文档对应字段'
FROM msds_field_mapping_summary
WHERE required_level = '必填'
ORDER BY 
    CASE table_name
        WHEN 'msds_main' THEN 1
        WHEN 'msds_hazard' THEN 2
        WHEN 'msds_component' THEN 3
        WHEN 'msds_first_aid' THEN 4
        WHEN 'msds_fire_fighting' THEN 5
        WHEN 'msds_leak_response' THEN 6
        WHEN 'msds_handling_storage' THEN 7
        WHEN 'msds_exposure_control' THEN 8
        WHEN 'msds_physical_chemical' THEN 9
        WHEN 'msds_stability_reactivity' THEN 10
        WHEN 'msds_toxicological' THEN 11
        WHEN 'msds_ecological' THEN 12
        WHEN 'msds_disposal' THEN 13
        WHEN 'msds_transportation' THEN 14
        WHEN 'msds_regulatory' THEN 15
        WHEN 'msds_other_info' THEN 16
    END,
    sort_order;
