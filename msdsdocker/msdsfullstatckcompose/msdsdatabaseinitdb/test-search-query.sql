-- ============================================================
-- 测试智能搜索SQL查询
-- ============================================================

USE msds_dev;

-- 1. 测试COUNT查询（这个返回1）
SELECT count(0) 
FROM msds_main m 
LEFT JOIN msds_document_statistics s ON m.id = s.msds_id 
WHERE m.is_active = 1 
  AND m.cas_number LIKE concat('%', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', '%');

-- 2. 测试实际SELECT查询（看看能否查到数据）
SELECT m.id, m.cas_number, m.product_name, m.is_active
FROM msds_main m 
LEFT JOIN msds_document_statistics s ON m.id = s.msds_id 
WHERE m.is_active = 1 
  AND m.cas_number LIKE concat('%', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', '%');

-- 3. 用正确的CAS号测试
SELECT m.id, m.cas_number, m.product_name, m.is_active
FROM msds_main m 
LEFT JOIN msds_document_statistics s ON m.id = s.msds_id 
WHERE m.is_active = 1 
  AND m.cas_number LIKE concat('%', '54-11-5', '%');

-- 4. 用化学品名称测试（应该用这个）
SELECT m.id, m.cas_number, m.product_name, m.is_active
FROM msds_main m 
LEFT JOIN msds_document_statistics s ON m.id = s.msds_id 
WHERE m.is_active = 1 
  AND (
    m.product_name LIKE concat('%', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', '%')
    OR m.product_alias LIKE concat('%', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', '%')
    OR m.product_english_name LIKE concat('%', '(S)-3-(1-甲基吡咯烷-2-基)吡啶', '%')
  );

-- 5. 验证is_active和统计表关联
SELECT 
    m.id,
    m.cas_number,
    m.product_name,
    m.is_active,
    s.stat_id,
    s.view_count
FROM msds_main m 
LEFT JOIN msds_document_statistics s ON m.id = s.msds_id 
WHERE m.id = 166;

