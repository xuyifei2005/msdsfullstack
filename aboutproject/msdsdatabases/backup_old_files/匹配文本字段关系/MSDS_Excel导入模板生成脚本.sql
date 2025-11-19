-- =============================================
-- MSDS Excel导入模板生成脚本
-- 基于数据库表结构生成完整的Excel导入模板
-- =============================================

-- 1. 基础模板字段（仅包含必填字段）
CREATE TEMPORARY TABLE msds_basic_template AS
SELECT 
    'cas_number' as field_name, 'CAS登记号' as field_label, 'VARCHAR(50)' as data_type, 'NOT NULL UNIQUE' as constraints, '化学品CAS号' as pdf_mapping, 1 as sort_order, '必填' as required_level
UNION ALL SELECT 'msds_code', 'MSDS编号', 'VARCHAR(50)', 'NOT NULL UNIQUE', '技术说明书编码', 2, '必填'
UNION ALL SELECT 'product_name', '化学品中文名', 'VARCHAR(255)', 'NOT NULL', '中文名称', 3, '必填'
UNION ALL SELECT 'company_name', '企业名称', 'VARCHAR(255)', 'NOT NULL', '供应商名称', 4, '必填'
UNION ALL SELECT 'contact_phone', '联系电话', 'VARCHAR(50)', 'NOT NULL', '供应商电话', 5, '必填';

-- 2. 详细模板字段（包含主要业务字段）
CREATE TEMPORARY TABLE msds_detailed_template AS
SELECT 
    'cas_number' as field_name, 'CAS登记号' as field_label, 'VARCHAR(50)' as data_type, 'NOT NULL UNIQUE' as constraints, '化学品CAS号' as pdf_mapping, 1 as sort_order, '必填' as required_level
UNION ALL SELECT 'msds_code', 'MSDS编号', 'VARCHAR(50)', 'NOT NULL UNIQUE', '技术说明书编码', 2, '必填'
UNION ALL SELECT 'product_name', '化学品中文名', 'VARCHAR(255)', 'NOT NULL', '中文名称', 3, '必填'
UNION ALL SELECT 'product_alias', '化学品别名', 'VARCHAR(255)', 'NULL', '中文别名', 4, '可选'
UNION ALL SELECT 'product_english_name', '化学品英文名', 'VARCHAR(255)', 'NULL', '英文名称', 5, '可选'
UNION ALL SELECT 'company_name', '企业名称', 'VARCHAR(255)', 'NOT NULL', '供应商名称', 6, '必填'
UNION ALL SELECT 'company_address', '企业地址', 'TEXT', 'NULL', '供应商地址', 7, '可选'
UNION ALL SELECT 'contact_phone', '联系电话', 'VARCHAR(50)', 'NOT NULL', '供应商电话', 8, '必填'
UNION ALL SELECT 'email', '电子邮件地址', 'VARCHAR(100)', 'NULL', '供应商Email', 9, '可选'
UNION ALL SELECT 'emergency_phone', '企业应急电话', 'VARCHAR(50)', 'NULL', '供应商应急电话', 10, '可选'
UNION ALL SELECT 'fax_number', '传真号码', 'VARCHAR(50)', 'NULL', '供应商传真', 11, '可选'
UNION ALL SELECT 'recommended_usage', '产品推荐用途', 'TEXT', 'NULL', '推荐用途', 12, '可选'
UNION ALL SELECT 'restricted_usage', '产品限制用途', 'TEXT', 'NULL', '限制用途', 13, '可选'
UNION ALL SELECT 'version', 'MSDS版本号', 'VARCHAR(20)', 'DEFAULT 1.0', '版本号', 14, '可选'
UNION ALL SELECT 'revision_date', '修订日期', 'DATE', 'NULL', '修订日期', 15, '可选'
UNION ALL SELECT 'effective_date', '生效日期', 'DATE', 'NULL', '生效日期', 16, '可选'
UNION ALL SELECT 'status', '状态', 'ENUM', 'DEFAULT draft', '状态', 17, '可选'
UNION ALL SELECT 'approver', '审批人', 'VARCHAR(100)', 'NULL', '审批人', 18, '可选'
UNION ALL SELECT 'approval_date', '审批日期', 'DATE', 'NULL', '审批日期', 19, '可选'
-- 危险性概述字段
UNION ALL SELECT 'emergency_overview', '紧急情况概述', 'TEXT', 'NULL', '紧急情况概述', 20, '可选'
UNION ALL SELECT 'physical_state', '物理状态', 'VARCHAR(50)', 'NULL', '物理状态', 21, '可选'
UNION ALL SELECT 'odor', '气味', 'VARCHAR(100)', 'NULL', '气味', 22, '可选'
UNION ALL SELECT 'color', '颜色', 'VARCHAR(50)', 'NULL', '颜色', 23, '可选'
UNION ALL SELECT 'warning_word', '警示词', 'ENUM', 'NULL', '警示词', 24, '可选'
UNION ALL SELECT 'hazard_category', '危险性类别', 'VARCHAR(255)', 'NULL', '危险性类别', 25, '可选'
UNION ALL SELECT 'exposure_routes', '侵入途径', 'VARCHAR(255)', 'NULL', '侵入途径', 26, '可选'
UNION ALL SELECT 'health_hazards', '健康危害', 'TEXT', 'NULL', '健康危害', 27, '可选'
UNION ALL SELECT 'environmental_hazards', '环境危害', 'TEXT', 'NULL', '环境危害', 28, '可选'
UNION ALL SELECT 'fire_explosion_hazards', '燃爆危险', 'TEXT', 'NULL', '燃爆危险', 29, '可选'
-- 成分组成信息字段
UNION ALL SELECT 'component_name', '成分名称', 'VARCHAR(255)', 'NOT NULL', '成分名称', 30, '必填'
UNION ALL SELECT 'component_english_name', '成分英文名', 'VARCHAR(255)', 'NULL', '成分英文名', 31, '可选'
UNION ALL SELECT 'component_content', '成分含量/浓度', 'VARCHAR(100)', 'NULL', '含量', 32, '可选'
UNION ALL SELECT 'cas_number', 'CAS登记号', 'VARCHAR(50)', 'NULL', 'CAS号', 33, '可选'
UNION ALL SELECT 'molecular_formula', '分子式', 'VARCHAR(100)', 'NULL', '分子式', 34, '可选'
UNION ALL SELECT 'molecular_weight', '分子量', 'DECIMAL(10,2)', 'NULL', '分子量', 35, '可选'
UNION ALL SELECT 'is_hazardous', '是否为危险成分', 'TINYINT(1)', 'DEFAULT 0', '危险成分标识', 36, '可选'
-- 急救措施字段
UNION ALL SELECT 'skin_contact', '皮肤接触处理措施', 'TEXT', 'NULL', '皮肤接触处理措施', 37, '可选'
UNION ALL SELECT 'eye_contact', '眼睛接触处理措施', 'TEXT', 'NULL', '眼睛接触处理措施', 38, '可选'
UNION ALL SELECT 'inhalation', '吸入处理措施', 'TEXT', 'NULL', '吸入处理措施', 39, '可选'
UNION ALL SELECT 'ingestion', '食入处理措施', 'TEXT', 'NULL', '食入处理措施', 40, '可选'
-- 消防措施字段
UNION ALL SELECT 'hazard_characteristics', '危险特性', 'TEXT', 'NULL', '危险特性', 41, '可选'
UNION ALL SELECT 'harmful_combustion_products', '有害燃烧产物', 'TEXT', 'NULL', '有害燃烧产物', 42, '可选'
UNION ALL SELECT 'suitable_extinguishing_media', '适宜的灭火介质', 'TEXT', 'NULL', '灭火方法', 43, '可选'
UNION ALL SELECT 'flash_point', '闪点', 'VARCHAR(50)', 'NULL', '闪点', 44, '可选'
UNION ALL SELECT 'autoignition_temperature', '自燃温度', 'VARCHAR(50)', 'NULL', '自燃温度', 45, '可选'
-- 理化特性字段
UNION ALL SELECT 'appearance', '外观与性状', 'VARCHAR(255)', 'NULL', '外观与性状', 46, '可选'
UNION ALL SELECT 'melting_point', '熔点(℃)', 'VARCHAR(50)', 'NULL', '熔点(°C)', 47, '可选'
UNION ALL SELECT 'boiling_point', '沸点(℃)', 'VARCHAR(50)', 'NULL', '沸点(°C)', 48, '可选'
UNION ALL SELECT 'relative_density', '相对密度(水=1)', 'VARCHAR(50)', 'NULL', '相对密度(水=1)', 49, '可选'
UNION ALL SELECT 'vapor_pressure', '蒸气压(kPa)', 'VARCHAR(50)', 'NULL', '饱和蒸气压(kPa)', 50, '可选'
UNION ALL SELECT 'solubility', '溶解性', 'TEXT', 'NULL', '溶解性', 51, '可选'
UNION ALL SELECT 'ph_value', 'pH值', 'VARCHAR(20)', 'NULL', 'pH', 52, '可选'
UNION ALL SELECT 'ignition_temperature', '引燃温度(℃)', 'VARCHAR(50)', 'NULL', '引燃温度(°C)', 53, '可选'
UNION ALL SELECT 'explosive_limit_lower', '爆炸下限(%)', 'VARCHAR(50)', 'NULL', '爆炸下限%(V/V)', 54, '可选'
UNION ALL SELECT 'explosive_limit_upper', '爆炸上限(%)', 'VARCHAR(50)', 'NULL', '爆炸上限%(V/V)', 55, '可选'
UNION ALL SELECT 'molecular_formula', '分子式', 'VARCHAR(100)', 'NULL', '分子式', 56, '可选'
UNION ALL SELECT 'molecular_weight', '分子量', 'VARCHAR(50)', 'NULL', '分子量', 57, '可选'
-- 毒理学资料字段
UNION ALL SELECT 'acute_toxicity', '急性毒性', 'TEXT', 'NULL', '急性毒性', 58, '可选'
UNION ALL SELECT 'ld50_oral', 'LD50(经口,大鼠)', 'VARCHAR(100)', 'NULL', 'LD50经口', 59, '可选'
UNION ALL SELECT 'ld50_dermal', 'LD50(经皮,兔)', 'VARCHAR(100)', 'NULL', 'LD50经皮', 60, '可选'
UNION ALL SELECT 'lc50_inhalation', 'LC50(吸入,大鼠)', 'VARCHAR(100)', 'NULL', 'LC50吸入', 61, '可选'
UNION ALL SELECT 'skin_irritation', '皮肤刺激性', 'TEXT', 'NULL', '刺激性', 62, '可选'
UNION ALL SELECT 'eye_irritation', '眼睛刺激性', 'TEXT', 'NULL', '刺激性', 63, '可选'
UNION ALL SELECT 'sensitization', '致敏性', 'TEXT', 'NULL', '致敏性', 64, '可选'
UNION ALL SELECT 'mutagenicity', '致突变性', 'TEXT', 'NULL', '致突变性', 65, '可选'
UNION ALL SELECT 'carcinogenicity', '致癌性', 'TEXT', 'NULL', '致癌性', 66, '可选'
-- 运输信息字段
UNION ALL SELECT 'dangerous_goods_number', '危险货物编号', 'VARCHAR(50)', 'NULL', '危险货物编号', 67, '可选'
UNION ALL SELECT 'un_number', 'UN编号', 'VARCHAR(50)', 'NULL', 'UN编号', 68, '可选'
UNION ALL SELECT 'proper_shipping_name', '正确运输名称', 'VARCHAR(255)', 'NULL', '正确运输名称', 69, '可选'
UNION ALL SELECT 'transport_hazard_class', '运输危险类别', 'VARCHAR(50)', 'NULL', '运输危险类别', 70, '可选'
UNION ALL SELECT 'packing_group', '包装类别', 'VARCHAR(10)', 'NULL', '包装类别', 71, '可选'
UNION ALL SELECT 'packaging_marks', '包装标志', 'TEXT', 'NULL', '包装标志', 72, '可选'
UNION ALL SELECT 'packaging_method', '包装方法', 'TEXT', 'NULL', '包装方法', 73, '可选'
UNION ALL SELECT 'transportation_precautions', '运输注意事项', 'TEXT', 'NULL', '运输注意事项', 74, '可选'
-- 法规信息字段
UNION ALL SELECT 'regulatory_info', '法规信息综述', 'TEXT', 'NULL', '法规信息', 75, '可选'
UNION ALL SELECT 'domestic_regulations', '国内法规', 'TEXT', 'NULL', '国内法规', 76, '可选'
UNION ALL SELECT 'international_regulations', '国际法规', 'TEXT', 'NULL', '国际法规', 77, '可选'
UNION ALL SELECT 'china_dangerous_chemicals', '中国危险化学品目录', 'TINYINT(1)', 'DEFAULT 0', '中国危险化学品目录', 78, '可选'
UNION ALL SELECT 'reach_registration', 'REACH注册情况', 'TEXT', 'NULL', 'REACH注册情况', 79, '可选'
UNION ALL SELECT 'tsca_inventory', 'TSCA清单', 'TINYINT(1)', 'DEFAULT 0', 'TSCA清单', 80, '可选'
UNION ALL SELECT 'einecs_number', 'EINECS号', 'VARCHAR(50)', 'NULL', 'EINECS号', 81, '可选'
-- 其他信息字段
UNION ALL SELECT 'references', '参考文献', 'TEXT', 'NULL', '参考文献', 82, '可选'
UNION ALL SELECT 'data_sources', '数据来源', 'TEXT', 'NULL', '数据来源', 83, '可选'
UNION ALL SELECT 'form_fill_time', '填表时间', 'DATE', 'NULL', '填表时间', 84, '可选'
UNION ALL SELECT 'form_fill_department', '填表部门', 'VARCHAR(100)', 'NULL', '填表部门', 85, '可选'
UNION ALL SELECT 'form_fill_person', '填表人', 'VARCHAR(100)', 'NULL', '填表人', 86, '可选'
UNION ALL SELECT 'data_audit_unit', '数据审核单位', 'VARCHAR(100)', 'NULL', '数据审核单位', 87, '可选'
UNION ALL SELECT 'data_audit_person', '数据审核人', 'VARCHAR(100)', 'NULL', '数据审核人', 88, '可选'
UNION ALL SELECT 'technical_review_person', '技术审查人', 'VARCHAR(100)', 'NULL', '技术审查人', 89, '可选'
UNION ALL SELECT 'modification_notes', '修改说明', 'TEXT', 'NULL', '修改说明', 90, '可选'
UNION ALL SELECT 'additional_information', '其他信息', 'TEXT', 'NULL', '其他信息', 91, '可选';

-- 3. 完整模板字段（包含所有字段）
CREATE TEMPORARY TABLE msds_full_template AS
SELECT * FROM msds_detailed_template
UNION ALL
-- 添加更多详细字段
SELECT 'component_content_min', '含量下限(%)', 'DECIMAL(10,4)', 'NULL', '含量下限', 92, '可选'
UNION ALL SELECT 'component_content_max', '含量上限(%)', 'DECIMAL(10,4)', 'NULL', '含量上限', 93, '可选'
UNION ALL SELECT 'ec_number', 'EC号', 'VARCHAR(50)', 'NULL', 'EC号', 94, '可选'
UNION ALL SELECT 'hazard_level', '危险等级', 'VARCHAR(50)', 'NULL', '危险等级', 95, '可选'
UNION ALL SELECT 'component_function', '成分功能', 'VARCHAR(100)', 'NULL', '成分功能', 96, '可选'
-- 更多急救措施字段
UNION ALL SELECT 'general_notes', '一般注意事项', 'TEXT', 'NULL', '一般注意事项', 97, '可选'
UNION ALL SELECT 'symptoms_effects', '可能出现的症状和健康影响', 'TEXT', 'NULL', '症状和健康影响', 98, '可选'
UNION ALL SELECT 'immediate_medical_attention', '需要立即就医的情况', 'TEXT', 'NULL', '立即就医情况', 99, '可选'
UNION ALL SELECT 'antidote_treatment', '解毒剂及治疗方法', 'TEXT', 'NULL', '解毒剂及治疗方法', 100, '可选'
-- 更多消防措施字段
UNION ALL SELECT 'unsuitable_extinguishing_media', '不适宜的灭火介质', 'TEXT', 'NULL', '不适宜灭火介质', 101, '可选'
UNION ALL SELECT 'fire_fighting_equipment', '消防设备和防护装备', 'TEXT', 'NULL', '消防设备', 102, '可选'
UNION ALL SELECT 'fire_fighting_procedures', '特殊消防程序', 'TEXT', 'NULL', '特殊消防程序', 103, '可选'
UNION ALL SELECT 'flammability_limits', '燃烧性/爆炸极限', 'TEXT', 'NULL', '爆炸极限', 104, '可选'
UNION ALL SELECT 'fire_risk_classification', '建规火险分级', 'VARCHAR(50)', 'NULL', '建规火险分级', 105, '可选'
-- 更多理化特性字段
UNION ALL SELECT 'odor_threshold', '气味阈值', 'VARCHAR(50)', 'NULL', '气味阈值', 106, '可选'
UNION ALL SELECT 'vapor_density', '蒸气密度(空气=1)', 'VARCHAR(50)', 'NULL', '相对蒸气密度(空气=1)', 107, '可选'
UNION ALL SELECT 'vapor_pressure_temp', '蒸气压测定温度(℃)', 'VARCHAR(20)', 'NULL', '蒸气压测定温度', 108, '可选'
UNION ALL SELECT 'water_solubility', '水中溶解度', 'VARCHAR(100)', 'NULL', '水中溶解度', 109, '可选'
UNION ALL SELECT 'ph_concentration', 'pH值浓度条件', 'VARCHAR(50)', 'NULL', 'pH浓度条件', 110, '可选'
UNION ALL SELECT 'viscosity', '粘度', 'VARCHAR(50)', 'NULL', '粘度', 111, '可选'
UNION ALL SELECT 'partition_coefficient', '分配系数(正辛醇/水)', 'VARCHAR(50)', 'NULL', '辛醇/水分配系数的对数值', 112, '可选'
UNION ALL SELECT 'decomposition_temperature', '分解温度(℃)', 'VARCHAR(50)', 'NULL', '分解温度', 113, '可选'
UNION ALL SELECT 'main_components', '主要成分', 'TEXT', 'NULL', '主要成分', 114, '可选'
UNION ALL SELECT 'critical_temperature', '临界温度(℃)', 'VARCHAR(50)', 'NULL', '临界温度(°C)', 115, '可选'
UNION ALL SELECT 'flammability', '燃烧性', 'VARCHAR(50)', 'NULL', '燃烧性', 116, '可选'
UNION ALL SELECT 'heat_of_combustion', '燃烧热(kJ/mol)', 'VARCHAR(50)', 'NULL', '燃烧热(kJ/mol)', 117, '可选'
UNION ALL SELECT 'critical_pressure', '临界压力(MPa)', 'VARCHAR(50)', 'NULL', '临界压力(MPa)', 118, '可选'
UNION ALL SELECT 'main_usage', '主要用途', 'TEXT', 'NULL', '主要用途', 119, '可选'
UNION ALL SELECT 'other_properties', '其它理化性质', 'TEXT', 'NULL', '其它理化性质', 120, '可选'
-- 稳定性和反应性字段
UNION ALL SELECT 'stability', '稳定性', 'TEXT', 'NULL', '稳定性', 121, '可选'
UNION ALL SELECT 'reactivity', '反应性', 'TEXT', 'NULL', '反应性', 122, '可选'
UNION ALL SELECT 'incompatible_substances', '禁配物', 'TEXT', 'NULL', '禁配物', 123, '可选'
UNION ALL SELECT 'conditions_to_avoid', '避免接触的条件', 'TEXT', 'NULL', '避免接触的条件', 124, '可选'
UNION ALL SELECT 'hazardous_reactions', '可能的危险反应', 'TEXT', 'NULL', '危险反应', 125, '可选'
UNION ALL SELECT 'polymerization_hazard', '聚合危害', 'TEXT', 'NULL', '聚合危害', 126, '可选'
UNION ALL SELECT 'polymerization_conditions', '聚合反应条件', 'TEXT', 'NULL', '聚合反应条件', 127, '可选'
UNION ALL SELECT 'decomposition_products', '分解产物', 'TEXT', 'NULL', '分解产物', 128, '可选'
UNION ALL SELECT 'decomposition_conditions', '分解条件', 'TEXT', 'NULL', '分解条件', 129, '可选'
-- 更多毒理学字段
UNION ALL SELECT 'subacute_chronic', '亚急性和慢性毒性', 'TEXT', 'NULL', '亚急性和慢性毒性', 130, '可选'
UNION ALL SELECT 'respiratory_irritation', '呼吸道刺激性', 'TEXT', 'NULL', '刺激性', 131, '可选'
UNION ALL SELECT 'reproductive_toxicity', '生殖毒性', 'TEXT', 'NULL', '生殖毒性', 132, '可选'
UNION ALL SELECT 'carcinogen_classification', '致癌物分类', 'TEXT', 'NULL', '致癌物分类', 133, '可选'
UNION ALL SELECT 'specific_target_organ', '特定目标器官毒性', 'TEXT', 'NULL', '特定器官毒性', 134, '可选'
UNION ALL SELECT 'aspiration_hazard', '吸入危害', 'TEXT', 'NULL', '吸入危害', 135, '可选'
UNION ALL SELECT 'other_toxicity', '其他毒理学资料', 'TEXT', 'NULL', '其他毒理学资料', 136, '可选'
UNION ALL SELECT 'rtecs', 'RTECS编号', 'VARCHAR(100)', 'NULL', 'RTECS', 137, '可选'
-- 生态学资料字段
UNION ALL SELECT 'ecological_toxicity', '生态毒性', 'TEXT', 'NULL', '生态毒理毒性', 138, '可选'
UNION ALL SELECT 'fish_toxicity', '鱼类毒性', 'VARCHAR(100)', 'NULL', '鱼类毒性', 139, '可选'
UNION ALL SELECT 'invertebrate_toxicity', '无脊椎动物毒性', 'VARCHAR(100)', 'NULL', '无脊椎动物毒性', 140, '可选'
UNION ALL SELECT 'algae_toxicity', '藻类毒性', 'VARCHAR(100)', 'NULL', '藻类毒性', 141, '可选'
UNION ALL SELECT 'bacteria_toxicity', '细菌毒性', 'VARCHAR(100)', 'NULL', '细菌毒性', 142, '可选'
UNION ALL SELECT 'biodegradability', '生物降解性', 'TEXT', 'NULL', '生物降解性', 143, '可选'
UNION ALL SELECT 'biodegradation_rate', '生物降解速率', 'VARCHAR(50)', 'NULL', '生物降解速率', 144, '可选'
UNION ALL SELECT 'non_biodegradability', '非生物降解性', 'TEXT', 'NULL', '非生物降解性', 145, '可选'
UNION ALL SELECT 'photodegradation', '光降解', 'TEXT', 'NULL', '光降解', 146, '可选'
UNION ALL SELECT 'hydrolysis', '水解', 'TEXT', 'NULL', '水解', 147, '可选'
UNION ALL SELECT 'bioaccumulation', '生物富集或生物积累性', 'TEXT', 'NULL', '生物富集或生物积累性', 148, '可选'
UNION ALL SELECT 'bioconcentration_factor', '生物富集因子', 'VARCHAR(50)', 'NULL', '生物富集因子', 149, '可选'
UNION ALL SELECT 'mobility_in_soil', '土壤中迁移性', 'TEXT', 'NULL', '土壤中迁移性', 150, '可选'
UNION ALL SELECT 'other_environmental_effects', '其它有害作用', 'TEXT', 'NULL', '其它有害作用', 151, '可选'
UNION ALL SELECT 'ozone_depletion_potential', '臭氧消耗潜能值', 'VARCHAR(50)', 'NULL', '臭氧消耗潜能值', 152, '可选'
UNION ALL SELECT 'global_warming_potential', '全球变暖潜能值', 'VARCHAR(50)', 'NULL', '全球变暖潜能值', 153, '可选'
-- 废弃处置字段
UNION ALL SELECT 'waste_properties', '废弃物性质', 'TEXT', 'NULL', '废弃物性质', 154, '可选'
UNION ALL SELECT 'disposal_method', '废弃处置方法', 'TEXT', 'NULL', '废弃处置方法', 155, '可选'
UNION ALL SELECT 'disposal_precautions', '废弃注意事项', 'TEXT', 'NULL', '废弃注意事项', 156, '可选'
UNION ALL SELECT 'disposal_regulations', '废弃处置相关法规', 'TEXT', 'NULL', '废弃处置法规', 157, '可选'
UNION ALL SELECT 'container_disposal', '包装容器的处置', 'TEXT', 'NULL', '包装容器处置', 158, '可选'
UNION ALL SELECT 'recommended_disposal', '推荐的处置方法', 'TEXT', 'NULL', '推荐处置方法', 159, '可选'
UNION ALL SELECT 'prohibited_disposal', '禁止的处置方法', 'TEXT', 'NULL', '禁止处置方法', 160, '可选'
UNION ALL SELECT 'neutralization_method', '中和处理方法', 'TEXT', 'NULL', '中和处理方法', 161, '可选'
-- 更多运输信息字段
UNION ALL SELECT 'marine_pollutant', '海洋污染物', 'TINYINT(1)', 'DEFAULT 0', '海洋污染物', 162, '可选'
UNION ALL SELECT 'transport_in_bulk', '散装运输要求', 'TEXT', 'NULL', '散装运输要求', 163, '可选'
UNION ALL SELECT 'emergency_response_guide', '应急响应指南编号', 'VARCHAR(50)', 'NULL', '应急响应指南', 164, '可选'
UNION ALL SELECT 'imdg_rule_page', 'IMDG规则页码', 'VARCHAR(50)', 'NULL', 'IMDG规则页码字段', 165, '可选'
-- 更多法规信息字段
UNION ALL SELECT 'china_controlled_chemicals', '中国管制化学品', 'TINYINT(1)', 'DEFAULT 0', '中国管制化学品', 166, '可选'
UNION ALL SELECT 'prohibited_restricted', '禁用/限用情况', 'TEXT', 'NULL', '禁用限用情况', 167, '可选'
UNION ALL SELECT 'special_provisions', '特殊规定', 'TEXT', 'NULL', '特殊规定', 168, '可选'
-- 更多其他信息字段
UNION ALL SELECT 'training_requirements', '培训要求', 'TEXT', 'NULL', '培训要求', 169, '可选'
UNION ALL SELECT 'disclaimer', '免责声明', 'TEXT', 'NULL', '免责声明', 170, '可选';

-- 查询基础模板字段
SELECT 
    '基础模板' as template_type,
    field_name as '数据库字段名',
    field_label as '字段中文名',
    data_type as '数据类型',
    constraints as '约束条件',
    pdf_mapping as 'PDF文档对应字段',
    sort_order as '排序',
    required_level as '必填级别'
FROM msds_basic_template
ORDER BY sort_order;

-- 查询详细模板字段
SELECT 
    '详细模板' as template_type,
    field_name as '数据库字段名',
    field_label as '字段中文名',
    data_type as '数据类型',
    constraints as '约束条件',
    pdf_mapping as 'PDF文档对应字段',
    sort_order as '排序',
    required_level as '必填级别'
FROM msds_detailed_template
ORDER BY sort_order;

-- 查询完整模板字段
SELECT 
    '完整模板' as template_type,
    field_name as '数据库字段名',
    field_label as '字段中文名',
    data_type as '数据类型',
    constraints as '约束条件',
    pdf_mapping as 'PDF文档对应字段',
    sort_order as '排序',
    required_level as '必填级别'
FROM msds_full_template
ORDER BY sort_order;

-- 生成Excel模板字段统计
SELECT 
    '基础模板' as template_type,
    COUNT(*) as field_count,
    SUM(CASE WHEN required_level = '必填' THEN 1 ELSE 0 END) as required_fields,
    SUM(CASE WHEN required_level = '可选' THEN 1 ELSE 0 END) as optional_fields
FROM msds_basic_template
UNION ALL
SELECT 
    '详细模板',
    COUNT(*),
    SUM(CASE WHEN required_level = '必填' THEN 1 ELSE 0 END),
    SUM(CASE WHEN required_level = '可选' THEN 1 ELSE 0 END)
FROM msds_detailed_template
UNION ALL
SELECT 
    '完整模板',
    COUNT(*),
    SUM(CASE WHEN required_level = '必填' THEN 1 ELSE 0 END),
    SUM(CASE WHEN required_level = '可选' THEN 1 ELSE 0 END)
FROM msds_full_template;
