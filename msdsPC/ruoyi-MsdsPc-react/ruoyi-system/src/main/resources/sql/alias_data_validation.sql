-- ========================================
-- MSDS中文别名数据质量验证脚本
-- 用于检查修复后的别名导入效果
-- ========================================

-- 1. 检查别名字段中包含CAS号的记录（应该被修复）
SELECT 
    id,
    product_name,
    product_alias,
    cas_number,
    create_time
FROM msds_main 
WHERE product_alias IS NOT NULL 
  AND product_alias REGEXP '[0-9]+-[0-9]+-[0-9]+'
ORDER BY create_time DESC
LIMIT 20;

-- 2. 统计别名字段数据分布
SELECT 
    CASE 
        WHEN product_alias IS NULL THEN '无别名'
        WHEN product_alias = '' THEN '空别名'
        WHEN LENGTH(product_alias) < 10 THEN '短别名(<10字符)'
        WHEN LENGTH(product_alias) < 50 THEN '中等别名(10-50字符)'
        ELSE '长别名(>50字符)'
    END AS alias_category,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM msds_main), 2) as percentage
FROM msds_main 
GROUP BY alias_category
ORDER BY count DESC;

-- 3. 检查中文别名提取效果
SELECT 
    id,
    product_name,
    product_alias,
    CASE 
        WHEN product_alias REGEXP '[\u4e00-\u9fff]' THEN '包含中文'
        WHEN product_alias IS NOT NULL AND product_alias != '' THEN '仅英文/数字'
        ELSE '无别名'
    END as alias_type,
    create_time
FROM msds_main 
WHERE product_alias IS NOT NULL 
  AND product_alias != ''
ORDER BY create_time DESC
LIMIT 30;

-- 4. 检查可能遗漏的中文别名（产品名称包含括号但别名为空）
SELECT 
    id,
    product_name,
    product_alias,
    cas_number,
    create_time
FROM msds_main 
WHERE product_name REGEXP '[（(][^)）]*[）)]'
  AND (product_alias IS NULL OR product_alias = '')
ORDER BY create_time DESC
LIMIT 20;

-- 5. 验证CAS号字段的正确性
SELECT 
    id,
    product_name,
    cas_number,
    product_alias,
    CASE 
        WHEN cas_number REGEXP '^[0-9]+-[0-9]+-[0-9]+$' THEN '格式正确'
        WHEN cas_number IS NULL OR cas_number = '' THEN '无CAS号'
        ELSE '格式错误'
    END as cas_status,
    create_time
FROM msds_main 
ORDER BY create_time DESC
LIMIT 30;

-- 6. 检查别名字段长度分布
SELECT 
    LENGTH(product_alias) as alias_length,
    COUNT(*) as count
FROM msds_main 
WHERE product_alias IS NOT NULL 
  AND product_alias != ''
GROUP BY LENGTH(product_alias)
ORDER BY alias_length;

-- 7. 查找重复的别名内容
SELECT 
    product_alias,
    COUNT(*) as duplicate_count,
    GROUP_CONCAT(product_name SEPARATOR '; ') as products
FROM msds_main 
WHERE product_alias IS NOT NULL 
  AND product_alias != ''
GROUP BY product_alias
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC
LIMIT 10;

-- 8. 检查最近导入的数据质量
SELECT 
    DATE(create_time) as import_date,
    COUNT(*) as total_records,
    SUM(CASE WHEN product_alias IS NOT NULL AND product_alias != '' THEN 1 ELSE 0 END) as with_alias,
    SUM(CASE WHEN product_alias REGEXP '[\u4e00-\u9fff]' THEN 1 ELSE 0 END) as with_chinese_alias,
    SUM(CASE WHEN product_alias REGEXP '[0-9]+-[0-9]+-[0-9]+' THEN 1 ELSE 0 END) as alias_contains_cas,
    ROUND(SUM(CASE WHEN product_alias IS NOT NULL AND product_alias != '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as alias_coverage_rate
FROM msds_main 
WHERE create_time >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY DATE(create_time)
ORDER BY import_date DESC;

-- 9. 检查特定化学品的别名提取效果
SELECT 
    product_name,
    product_alias,
    cas_number,
    create_time
FROM msds_main 
WHERE product_name IN ('苯', '甲苯', '二甲苯', '乙醇', '丙酮', '苯酚')
   OR product_name LIKE '%苯%'
   OR product_name LIKE '%甲苯%'
   OR product_name LIKE '%二甲苯%'
ORDER BY product_name, create_time DESC;

-- 10. 生成数据质量报告摘要
SELECT 
    '总记录数' as metric,
    COUNT(*) as value
FROM msds_main
UNION ALL
SELECT 
    '有别名记录数',
    COUNT(*)
FROM msds_main 
WHERE product_alias IS NOT NULL AND product_alias != ''
UNION ALL
SELECT 
    '包含中文别名记录数',
    COUNT(*)
FROM msds_main 
WHERE product_alias REGEXP '[\u4e00-\u9fff]'
UNION ALL
SELECT 
    '别名包含CAS号记录数（需修复）',
    COUNT(*)
FROM msds_main 
WHERE product_alias REGEXP '[0-9]+-[0-9]+-[0-9]+'
UNION ALL
SELECT 
    '别名覆盖率(%)',
    ROUND(
        (SELECT COUNT(*) FROM msds_main WHERE product_alias IS NOT NULL AND product_alias != '') * 100.0 / 
        (SELECT COUNT(*) FROM msds_main), 2
    )
UNION ALL
SELECT 
    '中文别名覆盖率(%)',
    ROUND(
        (SELECT COUNT(*) FROM msds_main WHERE product_alias REGEXP '[\u4e00-\u9fff]') * 100.0 / 
        (SELECT COUNT(*) FROM msds_main), 2
    );