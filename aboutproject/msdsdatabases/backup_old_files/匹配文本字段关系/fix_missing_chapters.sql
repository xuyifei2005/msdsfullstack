-- =============================================
-- 修复MSDS缺失章节数据
-- MSDS ID: 141
-- CAS: 115-29-7
-- 化学品: (1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯
-- =============================================

USE msds_dev;

-- 修复第2章：危险性概述
UPDATE msds_hazard SET 
    hazard_category = '第6.1类 毒害品',
    exposure_routes = '吸入、食入、经皮吸收',
    health_hazards = '吸入、摄入或经皮肤吸收后会中毒。为高毒的有机氯杀虫剂。对人有致突变作用。对中枢神经系统有损害。可引起惊厥。一般表现为头痛、痉挛、口吐泡沫。本品受热分解放出氯和氧化硫烟雾。',
    environmental_hazards = '无资料',
    fire_explosion_hazards = '本品可燃、高毒',
    update_time = NOW()
WHERE msds_id = 141;

-- 如果不存在记录，则插入
INSERT INTO msds_hazard (msds_id, hazard_category, exposure_routes, health_hazards, environmental_hazards, fire_explosion_hazards, create_time, update_time)
SELECT 141, '第6.1类 毒害品', '吸入、食入、经皮吸收', 
       '吸入、摄入或经皮肤吸收后会中毒。为高毒的有机氯杀虫剂。对人有致突变作用。对中枢神经系统有损害。可引起惊厥。一般表现为头痛、痉挛、口吐泡沫。本品受热分解放出氯和氧化硫烟雾。',
       '无资料', '本品可燃、高毒', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM msds_hazard WHERE msds_id = 141);

-- 验证修复结果
SELECT '第2章：危险性概述' as chapter, 
       CASE 
           WHEN hazard_category IS NOT NULL AND exposure_routes IS NOT NULL 
           THEN '✓ 已修复' 
           ELSE '✗ 仍有问题' 
       END as status,
       hazard_category, exposure_routes, health_hazards
FROM msds_hazard WHERE msds_id = 141;

-- =============================================
-- 检查其他章节数据是否完整
-- =============================================

-- 第3章：成分信息（已有数据）
SELECT '第3章：成分信息' as chapter,
       CASE WHEN COUNT(*) > 0 THEN '✓ 有数据' ELSE '✗ 无数据' END as status,
       COUNT(*) as record_count
FROM msds_component WHERE msds_id = 141;

-- 第4章：急救措施（已有数据）
SELECT '第4章：急救措施' as chapter,
       CASE WHEN skin_contact IS NOT NULL THEN '✓ 有数据' ELSE '✗ 无数据' END as status,
       skin_contact, eye_contact, inhalation
FROM msds_first_aid WHERE msds_id = 141;

-- 第5章：消防措施（已有数据）
SELECT '第5章：消防措施' as chapter,
       CASE WHEN hazard_characteristics IS NOT NULL THEN '✓ 有数据' ELSE '✗ 无数据' END as status,
       hazard_characteristics, harmful_combustion_products
FROM msds_fire_fighting WHERE msds_id = 141;

-- 第6章：泄漏应急处理
SELECT '第6章：泄漏应急处理' as chapter,
       CASE WHEN emergency_procedures IS NOT NULL THEN '✓ 有数据' ELSE '✗ 无数据' END as status,
       emergency_procedures
FROM msds_leak_response WHERE msds_id = 141;

-- 第7章：操作处置与储存
SELECT '第7章：操作处置与储存' as chapter,
       CASE WHEN handling_precautions IS NOT NULL THEN '✓ 有数据' ELSE '✗ 无数据' END as status,
       handling_precautions, storage_precautions
FROM msds_handling_storage WHERE msds_id = 141;

-- 第8章：接触控制/个体防护
SELECT '第8章：接触控制/个体防护' as chapter,
       CASE WHEN respiratory_protection IS NOT NULL THEN '✓ 有数据' ELSE '✗ 无数据' END as status,
       china_mac, respiratory_protection, eye_protection
FROM msds_exposure_control WHERE msds_id = 141;

-- 第9章：理化特性
SELECT '第9章：理化特性' as chapter,
       CASE WHEN appearance IS NOT NULL THEN '✓ 有数据' ELSE '✗ 无数据' END as status,
       appearance, melting_point, boiling_point
FROM msds_physical_chemical WHERE msds_id = 141;

-- 第10章：稳定性和反应活性
SELECT '第10章：稳定性和反应活性' as chapter,
       CASE WHEN stability IS NOT NULL THEN '✓ 有数据' ELSE '✗ 无数据' END as status,
       stability, incompatible_substances
FROM msds_stability_reactivity WHERE msds_id = 141;

-- 第11章：毒理学信息
SELECT '第11章：毒理学信息' as chapter,
       CASE WHEN acute_toxicity IS NOT NULL THEN '✓ 有数据' ELSE '✗ 无数据' END as status,
       acute_toxicity
FROM msds_toxicological WHERE msds_id = 141;

-- 第12章：生态学信息
SELECT '第12章：生态学信息' as chapter,
       CASE WHEN ecological_toxicity IS NOT NULL THEN '✓ 有数据' ELSE '✗ 无数据' END as status,
       ecological_toxicity
FROM msds_ecological WHERE msds_id = 141;

-- 第13章：废弃处置
SELECT '第13章：废弃处置' as chapter,
       CASE WHEN disposal_method IS NOT NULL THEN '✓ 有数据' ELSE '✗ 无数据' END as status,
       waste_properties, disposal_method
FROM msds_disposal WHERE msds_id = 141;

-- 第14章：运输信息
SELECT '第14章：运输信息' as chapter,
       CASE WHEN un_number IS NOT NULL THEN '✓ 有数据' ELSE '✗ 无数据' END as status,
       dangerous_goods_number, un_number
FROM msds_transportation WHERE msds_id = 141;

-- 第15章：法规信息
SELECT '第15章：法规信息' as chapter,
       CASE WHEN regulatory_info IS NOT NULL THEN '✓ 有数据' ELSE '✗ 无数据' END as status,
       regulatory_info
FROM msds_regulatory WHERE msds_id = 141;

