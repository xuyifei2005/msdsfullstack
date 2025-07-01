-- =============================================
-- MSDS数据库常用查询示例
-- =============================================

USE msds_management;

-- 1. 基础查询 - 获取所有化学品基本信息
SELECT 
    m.msds_code as '编号',
    m.product_name as '中文名',
    m.product_english_name as '英文名',
    c.category_name as '分类',
    m.company_name as '企业名称',
    m.status as '状态',
    m.version as '版本',
    m.create_time as '创建时间'
FROM msds_main m
LEFT JOIN chemical_category c ON m.category_id = c.id
WHERE m.is_active = 1
ORDER BY m.create_time DESC;

-- 2. 危险化学品查询 - 查找包含危险成分的化学品
SELECT DISTINCT
    m.product_name as '化学品名称',
    m.company_name as '企业名称',
    comp.component_name as '危险成分',
    comp.hazard_level as '危险等级',
    comp.cas_number as 'CAS号'
FROM msds_main m
JOIN msds_component comp ON m.id = comp.msds_id
WHERE comp.is_hazardous = 1
    AND m.is_active = 1
ORDER BY m.product_name;

-- 3. GHS危险分类查询 - 按危险类别分组统计
SELECT 
    ghs.class_name as '危险类别',
    ghs.signal_word as '警示词',
    COUNT(mg.msds_id) as '化学品数量'
FROM ghs_hazard_class ghs
LEFT JOIN msds_ghs_hazard mg ON ghs.id = mg.ghs_class_id
LEFT JOIN msds_main m ON mg.msds_id = m.id AND m.is_active = 1
GROUP BY ghs.id, ghs.class_name, ghs.signal_word
ORDER BY COUNT(mg.msds_id) DESC;

-- 4. 完整MSDS信息查询 - 根据化学品名称查询完整信息
SELECT 
    m.product_name as '化学品名称',
    m.product_english_name as '英文名称',
    m.company_name as '企业名称',
    h.emergency_overview as '紧急情况概述',
    h.warning_word as '警示词',
    fa.skin_contact as '皮肤接触处理',
    fa.eye_contact as '眼睛接触处理',
    pc.appearance as '外观性状',
    pc.melting_point as '熔点',
    pc.boiling_point as '沸点'
FROM msds_main m
LEFT JOIN msds_hazard h ON m.id = h.msds_id
LEFT JOIN msds_first_aid fa ON m.id = fa.msds_id
LEFT JOIN msds_physical_chemical pc ON m.id = pc.msds_id
WHERE m.product_name LIKE '%[化学品名称]%'
    AND m.is_active = 1;

-- 5. 成分分析查询 - 查看化学品的成分组成
SELECT 
    m.product_name as '化学品名称',
    comp.component_name as '成分名称',
    comp.component_content as '含量',
    comp.cas_number as 'CAS号',
    comp.molecular_formula as '分子式',
    comp.is_hazardous as '是否危险成分'
FROM msds_main m
JOIN msds_component comp ON m.id = comp.msds_id
WHERE m.id = [MSDS_ID]
    AND m.is_active = 1
ORDER BY comp.is_hazardous DESC, comp.component_name;

-- 6. 储存条件查询 - 查看化学品储存要求
SELECT 
    m.product_name as '化学品名称',
    hs.storage_precautions as '储存注意事项',
    hs.optimal_temperature as '最佳温度',
    hs.temperature_range as '温度范围',
    hs.humidity_requirements as '湿度要求',
    hs.storage_container as '储存容器',
    hs.shelf_life as '保质期'
FROM msds_main m
JOIN msds_handling_storage hs ON m.id = hs.msds_id
WHERE m.is_active = 1
ORDER BY m.product_name;

-- 7. 运输信息查询 - 查看危险货物运输要求
SELECT 
    m.product_name as '化学品名称',
    t.dangerous_goods_number as '危险货物编号',
    t.un_number as 'UN编号',
    t.proper_shipping_name as '正确运输名称',
    t.transport_hazard_class as '运输危险类别',
    t.packing_group as '包装类别',
    t.marine_pollutant as '海洋污染物'
FROM msds_main m
JOIN msds_transportation t ON m.id = t.msds_id
WHERE m.is_active = 1
    AND t.un_number IS NOT NULL
ORDER BY t.un_number;

-- 8. 法规合规性查询 - 检查法规符合情况
SELECT 
    m.product_name as '化学品名称',
    r.china_dangerous_chemicals as '中国危险化学品目录',
    r.china_controlled_chemicals as '中国管制化学品',
    r.tsca_inventory as 'TSCA清单',
    r.reach_registration as 'REACH注册',
    r.einecs_number as 'EINECS号'
FROM msds_main m
JOIN msds_regulatory r ON m.id = r.msds_id
WHERE m.is_active = 1
ORDER BY m.product_name;

-- 9. 毒理学数据查询 - 查看毒性数据
SELECT 
    m.product_name as '化学品名称',
    tox.ld50_oral as '经口LD50',
    tox.ld50_dermal as '经皮LD50',
    tox.lc50_inhalation as '吸入LC50',
    tox.carcinogenicity as '致癌性',
    tox.carcinogen_classification as '致癌物分类'
FROM msds_main m
JOIN msds_toxicological tox ON m.id = tox.msds_id
WHERE m.is_active = 1
    AND (tox.ld50_oral IS NOT NULL 
         OR tox.carcinogenicity IS NOT NULL)
ORDER BY m.product_name;

-- 10. 环境影响查询 - 查看生态毒性数据
SELECT 
    m.product_name as '化学品名称',
    e.fish_toxicity as '鱼类毒性',
    e.biodegradability as '生物降解性',
    e.bioaccumulation as '生物富集性',
    e.ozone_depletion_potential as '臭氧消耗潜能',
    e.global_warming_potential as '全球变暖潜能'
FROM msds_main m
JOIN msds_ecological e ON m.id = e.msds_id
WHERE m.is_active = 1
ORDER BY m.product_name;

-- 11. 审批流程查询 - 查看MSDS审批状态
SELECT 
    m.product_name as '化学品名称',
    m.status as '当前状态',
    w.step_name as '审批步骤',
    w.approver as '审批人',
    w.approval_status as '审批状态',
    w.approval_date as '审批时间',
    w.approval_comments as '审批意见'
FROM msds_main m
LEFT JOIN msds_approval_workflow w ON m.id = w.msds_id
WHERE m.id = [MSDS_ID]
ORDER BY w.step_no;

-- 12. 版本历史查询 - 查看MSDS变更历史
SELECT 
    m.product_name as '化学品名称',
    vh.version as '版本号',
    vh.change_description as '变更描述',
    vh.change_reason as '变更原因',
    vh.changed_sections as '变更章节',
    vh.change_date as '变更日期',
    vh.changed_by as '变更人',
    vh.approved_by as '审批人'
FROM msds_main m
JOIN msds_version_history vh ON m.id = vh.msds_id
WHERE m.id = [MSDS_ID]
ORDER BY vh.change_date DESC;

-- 13. 统计查询 - MSDS数据统计
SELECT 
    '总计' as '统计项',
    COUNT(*) as '数量'
FROM msds_main 
WHERE is_active = 1

UNION ALL

SELECT 
    '待审批' as '统计项',
    COUNT(*) as '数量'
FROM msds_main 
WHERE is_active = 1 AND status = 'pending'

UNION ALL

SELECT 
    '已审批' as '统计项',
    COUNT(*) as '数量'
FROM msds_main 
WHERE is_active = 1 AND status = 'approved'

UNION ALL

SELECT 
    '包含危险成分' as '统计项',
    COUNT(DISTINCT msds_id) as '数量'
FROM msds_component 
WHERE is_hazardous = 1;

-- 14. 到期提醒查询 - 查找需要更新的MSDS
SELECT 
    m.product_name as '化学品名称',
    m.company_name as '企业名称',
    m.revision_date as '修订日期',
    m.effective_date as '生效日期',
    DATEDIFF(NOW(), m.revision_date) as '已修订天数',
    CASE 
        WHEN DATEDIFF(NOW(), m.revision_date) > 1095 THEN '需要更新'
        WHEN DATEDIFF(NOW(), m.revision_date) > 1000 THEN '即将到期'
        ELSE '正常'
    END as '状态提醒'
FROM msds_main m
WHERE m.is_active = 1
    AND m.revision_date IS NOT NULL
ORDER BY m.revision_date;

-- 15. CAS号重复检查
SELECT 
    comp.cas_number as 'CAS号',
    COUNT(DISTINCT m.id) as '化学品数量',
    GROUP_CONCAT(DISTINCT m.product_name SEPARATOR '; ') as '化学品名称列表'
FROM msds_component comp
JOIN msds_main m ON comp.msds_id = m.id
WHERE comp.cas_number IS NOT NULL 
    AND comp.cas_number != ''
    AND m.is_active = 1
GROUP BY comp.cas_number
HAVING COUNT(DISTINCT m.id) > 1
ORDER BY COUNT(DISTINCT m.id) DESC; 