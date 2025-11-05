-- ============================================================
-- 修复智能搜索数据问题
-- 创建时间: 2025-11-05
-- 说明: 修复msds_main表中is_active字段，确保智能搜索能正常工作
-- ============================================================

USE msds_dev;

-- 1. 检查当前msds_main表的is_active字段值分布
SELECT 
    CASE 
        WHEN is_active IS NULL THEN 'NULL'
        WHEN is_active = 1 THEN '有效(1)'
        WHEN is_active = 0 THEN '无效(0)'
        ELSE CONCAT('其他值(', is_active, ')')
    END AS is_active_status,
    COUNT(*) AS count
FROM msds_main
GROUP BY is_active
ORDER BY is_active DESC;

-- 2. 查看所有化学品名称包含"吡啶"的记录
SELECT id, cas_number, product_name, is_active, status, create_time
FROM msds_main
WHERE product_name LIKE '%吡啶%'
   OR product_english_name LIKE '%pyrrolidin%'
   OR product_alias LIKE '%吡啶%';

-- 3. 将所有is_active为NULL或0的记录设置为1（有效）
-- 只要status是'已批准'的记录，就应该是有效的
UPDATE msds_main
SET is_active = 1
WHERE (is_active IS NULL OR is_active = 0)
  AND status = '已批准';

-- 4. 将所有status不是'已批准'但is_active为1的记录设置为0
UPDATE msds_main
SET is_active = 0
WHERE is_active = 1
  AND status != '已批准';

-- 5. 确保所有记录都有is_active值（默认为1）
UPDATE msds_main
SET is_active = 1
WHERE is_active IS NULL;

-- 6. 验证修复结果
SELECT 
    '修复后的数据统计' AS description,
    COUNT(*) AS total_count,
    SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END) AS active_count,
    SUM(CASE WHEN is_active = 0 THEN 1 ELSE 0 END) AS inactive_count,
    SUM(CASE WHEN is_active IS NULL THEN 1 ELSE 0 END) AS null_count
FROM msds_main;

-- 7. 查看"(S)-3-(1-甲基吡咯烷-2-基)吡啶"的记录状态
SELECT 
    id,
    cas_number,
    product_name,
    product_english_name,
    is_active,
    status,
    create_time,
    update_time
FROM msds_main
WHERE product_name LIKE '%(S)-3-(1-甲基吡咯烷-2-基)吡啶%'
   OR cas_number = '54-11-5';

-- 8. 为现有MSDS文档补充统计记录（如果不存在）
INSERT IGNORE INTO msds_document_statistics 
    (msds_id, view_count, download_count, favorite_count, create_time, update_time)
SELECT 
    id, 
    0, 
    0, 
    0, 
    NOW(), 
    NOW()
FROM msds_main
WHERE id NOT IN (SELECT msds_id FROM msds_document_statistics);

-- 9. 显示完成信息
SELECT 
    '数据修复完成' AS message,
    NOW() AS completion_time;

