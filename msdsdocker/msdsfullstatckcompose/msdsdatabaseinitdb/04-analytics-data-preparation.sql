-- ============================================================
-- 数据分析报告 - 数据准备脚本（方案A：最小化快速实现）
-- 创建时间: 2025-11-06
-- 说明: 修复现有数据，插入模拟数据用于数据分析报告演示
-- ============================================================

USE msds_dev;

-- ============================================================
-- 第1部分：修复msds_main的category_id（化学品分类）
-- ============================================================

-- 1.1 将含有"吡啶"、"甲基"等有机特征的化学品分类为"有机化学品"（category_id=2）
UPDATE msds_main 
SET category_id = 2 
WHERE (product_name REGEXP '醇|酮|醚|酯|烷|烯|苯|吡啶|甲基|乙基|丙基|丁基|pyrrolidin|methyl|ethyl'
       OR product_english_name REGEXP 'ol$|one|ane|ene|yl|methyl|ethyl|pyrrolidin')
  AND category_id IS NULL;

-- 1.2 将含有"酸"、"盐"等无机特征的化学品分类为"无机化学品"（category_id=1）
UPDATE msds_main 
SET category_id = 1 
WHERE (product_name REGEXP '酸|碱|盐|氯|钠|钾|硫|磷|氮|过氧化'
       OR product_english_name REGEXP 'acid|base|chloride|sulfate|phosphate|peroxide')
  AND category_id IS NULL;

-- 1.3 将含有"聚"、"树脂"等高分子特征的化学品分类为"高分子材料"（category_id=3）
UPDATE msds_main 
SET category_id = 3 
WHERE (product_name REGEXP '聚|树脂|橡胶|纤维|塑料'
       OR product_english_name REGEXP 'poly|resin|rubber')
  AND category_id IS NULL;

-- 1.4 剩余的默认分类为"混合物"（category_id=4）
UPDATE msds_main 
SET category_id = 4 
WHERE category_id IS NULL;

-- 1.5 验证分类结果
SELECT 
  c.category_name,
  COUNT(m.id) as count
FROM msds_main m
LEFT JOIN chemical_category c ON m.category_id = c.id
WHERE m.is_active = 1
GROUP BY c.id, c.category_name
ORDER BY count DESC;

-- ============================================================
-- 第2部分：插入模拟访问日志数据（用于演示）
-- ============================================================

-- 2.1 为现有的4个MSDS插入模拟访问记录（最近30天）
-- 使用存储过程或循环插入数据

-- 插入最近7天的访问记录（每天每个MSDS有随机访问）
INSERT INTO msds_document_access_log (msds_id, user_id, user_name, access_type, access_time, ip_address, device_type)
SELECT 
  m.id as msds_id,
  1 as user_id,
  'admin' as user_name,
  'view' as access_type,
  DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 7) DAY) + INTERVAL FLOOR(RAND() * 86400) SECOND as access_time,
  CONCAT('192.168.1.', FLOOR(RAND() * 255)) as ip_address,
  ELT(FLOOR(RAND() * 3) + 1, 'pc', 'mobile', 'tablet') as device_type
FROM msds_main m
CROSS JOIN (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) as t
WHERE m.is_active = 1;

-- 插入下载记录
INSERT INTO msds_document_access_log (msds_id, user_id, user_name, access_type, access_time, ip_address, device_type)
SELECT 
  m.id as msds_id,
  1 as user_id,
  'admin' as user_name,
  'download' as access_type,
  DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 30) DAY) + INTERVAL FLOOR(RAND() * 86400) SECOND as access_time,
  CONCAT('192.168.1.', FLOOR(RAND() * 255)) as ip_address,
  'pc' as device_type
FROM msds_main m
CROSS JOIN (SELECT 1 UNION SELECT 2) as t
WHERE m.is_active = 1;

-- ============================================================
-- 第3部分：更新文档统计数据
-- ============================================================

-- 3.1 基于访问日志更新统计表的访问次数
UPDATE msds_document_statistics s
SET view_count = (
  SELECT COUNT(*) 
  FROM msds_document_access_log 
  WHERE msds_id = s.msds_id AND access_type = 'view'
),
download_count = (
  SELECT COUNT(*) 
  FROM msds_document_access_log 
  WHERE msds_id = s.msds_id AND access_type = 'download'
),
favorite_count = (
  SELECT COUNT(*) 
  FROM msds_user_favorite 
  WHERE msds_id = s.msds_id
),
last_view_time = (
  SELECT MAX(access_time) 
  FROM msds_document_access_log 
  WHERE msds_id = s.msds_id AND access_type = 'view'
),
last_download_time = (
  SELECT MAX(access_time) 
  FROM msds_document_access_log 
  WHERE msds_id = s.msds_id AND access_type = 'download'
);

-- 3.2 为有访问记录的MSDS设置随机评分
UPDATE msds_document_statistics 
SET 
  total_score = FLOOR(RAND() * 50) + 1,
  score_count = FLOOR(RAND() * 10) + 1
WHERE msds_id IN (SELECT DISTINCT msds_id FROM msds_document_access_log);

-- 3.3 计算平均评分
UPDATE msds_document_statistics 
SET avg_score = ROUND(total_score / score_count, 2)
WHERE score_count > 0;

-- ============================================================
-- 第4部分：创建数据分析视图（简化查询）
-- ============================================================

-- 4.1 创建MSDS详细统计视图
CREATE OR REPLACE VIEW v_msds_analytics AS
SELECT 
  m.id,
  m.cas_number,
  m.product_name,
  m.product_english_name,
  c.category_name,
  c.category_code,
  h.warning_word,
  h.hazard_category,
  CASE 
    WHEN h.warning_word = 'danger' OR h.hazard_category LIKE '%毒害%' THEN 'high'
    WHEN h.warning_word = 'warning' OR h.hazard_category LIKE '%腐蚀%' OR h.hazard_category LIKE '%易燃%' THEN 'medium'
    ELSE 'low'
  END as hazard_level,
  s.view_count,
  s.download_count,
  s.favorite_count,
  s.avg_score,
  m.create_time,
  m.update_time
FROM msds_main m
LEFT JOIN chemical_category c ON m.category_id = c.id
LEFT JOIN msds_hazard h ON m.id = h.msds_id
LEFT JOIN msds_document_statistics s ON m.id = s.msds_id
WHERE m.is_active = 1;

-- 4.2 创建访问趋势视图
CREATE OR REPLACE VIEW v_access_trend AS
SELECT 
  DATE(access_time) as access_date,
  COUNT(*) as total_visits,
  COUNT(DISTINCT user_id) as unique_users,
  SUM(CASE WHEN access_type = 'view' THEN 1 ELSE 0 END) as view_count,
  SUM(CASE WHEN access_type = 'download' THEN 1 ELSE 0 END) as download_count,
  SUM(CASE WHEN device_type = 'mobile' THEN 1 ELSE 0 END) as mobile_visits,
  SUM(CASE WHEN device_type = 'pc' THEN 1 ELSE 0 END) as pc_visits
FROM msds_document_access_log
GROUP BY access_date
ORDER BY access_date DESC;

-- ============================================================
-- 第5部分：验证数据
-- ============================================================

-- 5.1 验证分类分布
SELECT 
  '分类分布' as description,
  c.category_name,
  COUNT(m.id) as count
FROM msds_main m
LEFT JOIN chemical_category c ON m.category_id = c.id
WHERE m.is_active = 1
GROUP BY c.id, c.category_name;

-- 5.2 验证危险等级分布
SELECT 
  '危险等级分布' as description,
  CASE 
    WHEN h.warning_word = 'danger' OR h.hazard_category LIKE '%毒害%' THEN '高危'
    WHEN h.warning_word = 'warning' OR h.hazard_category LIKE '%腐蚀%' THEN '中等'
    ELSE '低危'
  END as hazard_level,
  COUNT(DISTINCT m.id) as count
FROM msds_main m
LEFT JOIN msds_hazard h ON m.id = h.msds_id
WHERE m.is_active = 1
GROUP BY hazard_level;

-- 5.3 验证访问日志统计
SELECT 
  '访问日志统计' as description,
  COUNT(*) as total_logs,
  COUNT(DISTINCT msds_id) as unique_msds,
  COUNT(DISTINCT user_id) as unique_users,
  MIN(access_time) as earliest_access,
  MAX(access_time) as latest_access
FROM msds_document_access_log;

-- 5.4 验证统计数据
SELECT 
  '文档统计' as description,
  m.product_name,
  s.view_count,
  s.download_count,
  s.favorite_count
FROM msds_main m
LEFT JOIN msds_document_statistics s ON m.id = s.msds_id
WHERE m.is_active = 1
ORDER BY s.view_count DESC;

-- ============================================================
-- 完成提示
-- ============================================================
SELECT 
  '数据分析报告数据准备完成' as message,
  COUNT(*) as total_msds,
  (SELECT COUNT(*) FROM msds_document_access_log) as total_access_logs,
  (SELECT COUNT(*) FROM msds_document_statistics) as total_statistics,
  NOW() as completion_time
FROM msds_main
WHERE is_active = 1;

