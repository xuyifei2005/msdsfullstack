-- ============================================================
-- MSDS菜单结构检查和修复脚本
-- 创建时间: 2025-01-XX
-- 说明: 检查并修复菜单层级关系异常问题
-- ============================================================

USE msds_dev;

-- ============================================================
-- 第一步：检查当前菜单结构
-- ============================================================

SELECT '========== 当前菜单结构诊断 ==========' AS '诊断信息';

-- 1. 检查所有MSDS相关菜单
SELECT 
    m.menu_id AS '菜单ID',
    m.menu_name AS '菜单名称',
    m.parent_id AS '父菜单ID',
    CASE 
        WHEN m.parent_id = 0 THEN '【一级菜单】'
        ELSE p.menu_name
    END AS '父菜单名称',
    m.order_num AS '排序',
    m.path AS '路由地址',
    m.component AS '组件路径',
    m.menu_type AS '类型',
    CASE 
        WHEN m.visible = '0' THEN '显示'
        ELSE '隐藏'
    END AS '是否可见',
    CASE 
        WHEN m.status = '0' THEN '正常'
        ELSE '停用'
    END AS '菜单状态',
    m.perms AS '权限标识',
    m.icon AS '图标'
FROM sys_menu m
LEFT JOIN sys_menu p ON m.parent_id = p.menu_id
WHERE m.menu_name LIKE '%MSDS%' 
   OR m.menu_name = '智能搜索'
   OR m.component LIKE 'Msds%'
   OR m.path LIKE '%msds%'
ORDER BY m.parent_id, m.order_num;

-- 2. 检查孤儿菜单（父菜单不存在的菜单项）
SELECT '---------- 孤儿菜单检查 ----------' AS '检查项';
SELECT 
    m.menu_id,
    m.menu_name,
    m.parent_id,
    '父菜单不存在！' AS '问题'
FROM sys_menu m
WHERE m.parent_id != 0 
  AND NOT EXISTS (
      SELECT 1 FROM sys_menu p WHERE p.menu_id = m.parent_id
  )
  AND (m.menu_name LIKE '%MSDS%' OR m.menu_name = '智能搜索');

-- 3. 检查菜单类型异常（一级菜单必须是M类型）
SELECT '---------- 菜单类型检查 ----------' AS '检查项';
SELECT 
    m.menu_id,
    m.menu_name,
    m.parent_id,
    m.menu_type,
    '一级菜单类型应为M（目录）' AS '问题'
FROM sys_menu m
WHERE m.parent_id = 0 
  AND m.menu_type != 'M'
  AND (m.menu_name LIKE '%MSDS%' OR m.menu_name = '智能搜索');

-- ============================================================
-- 第二步：备份当前菜单配置
-- ============================================================

DROP TABLE IF EXISTS sys_menu_backup_temp;
CREATE TABLE sys_menu_backup_temp AS
SELECT * FROM sys_menu 
WHERE menu_name LIKE '%MSDS%' 
   OR menu_name = '智能搜索'
   OR component LIKE 'Msds%';

SELECT '✅ 已备份菜单配置到临时表 sys_menu_backup_temp' AS '备份状态';

-- ============================================================
-- 第三步：修复菜单结构（推荐方案）
-- ============================================================

-- 方案A：将智能搜索恢复为二级菜单（推荐）
-- 这是最安全的方案，保持原有的菜单层级关系

-- 3.1 获取"MSDS管理"父菜单ID
SET @msds_parent_id = (
    SELECT menu_id 
    FROM sys_menu 
    WHERE menu_name = 'MSDS管理' 
      AND parent_id = 0 
    LIMIT 1
);

-- 如果父菜单不存在，创建它
INSERT INTO sys_menu (
    menu_name, parent_id, order_num, path, component, 
    is_frame, is_cache, menu_type, visible, status, 
    perms, icon, create_by, create_time
)
SELECT 'MSDS管理', 0, 2, 'msds', NULL, 
       1, 0, 'M', '0', '0', 
       '', 'form', 'admin', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM sys_menu 
    WHERE menu_name = 'MSDS管理' AND parent_id = 0
);

-- 更新父菜单ID
SET @msds_parent_id = (
    SELECT menu_id 
    FROM sys_menu 
    WHERE menu_name = 'MSDS管理' 
      AND parent_id = 0 
    LIMIT 1
);

-- 3.2 修复智能搜索菜单（恢复为二级菜单）
UPDATE sys_menu 
SET 
    parent_id = @msds_parent_id,
    menu_type = 'C',
    path = 'search',
    component = 'Msds/IntelligentSearch',
    order_num = 1,
    visible = '0',
    status = '0'
WHERE menu_name = '智能搜索';

-- 3.3 修复MSDS文档菜单
UPDATE sys_menu 
SET 
    parent_id = @msds_parent_id,
    menu_type = 'C',
    path = 'main',
    component = 'Msds/index',
    order_num = 2,
    visible = '0',
    status = '0'
WHERE menu_name IN ('MSDS文档', 'MSDS管理') 
  AND parent_id != 0;

-- 3.4 修复MSDS详情页面（隐藏菜单）
UPDATE sys_menu 
SET 
    parent_id = @msds_parent_id,
    menu_type = 'C',
    path = 'detail/:id',
    component = 'Msds/Detail',
    order_num = 99,
    visible = '1',
    status = '0'
WHERE menu_name = 'MSDS详情';

-- 3.5 删除重复或错误的菜单项
DELETE FROM sys_menu 
WHERE (menu_name LIKE '%MSDS%' OR menu_name = '智能搜索')
  AND (
      -- 删除父菜单不存在的孤儿菜单
      (parent_id != 0 AND NOT EXISTS (
          SELECT 1 FROM (SELECT menu_id FROM sys_menu) p 
          WHERE p.menu_id = parent_id
      ))
      OR
      -- 删除组件路径为空的非目录菜单
      (menu_type = 'C' AND (component IS NULL OR component = ''))
  );

-- ============================================================
-- 第四步：验证修复结果
-- ============================================================

SELECT '========== 修复后的菜单结构 ==========' AS '验证结果';

SELECT 
    m.menu_id AS '菜单ID',
    m.menu_name AS '菜单名称',
    CASE 
        WHEN m.parent_id = 0 THEN '【一级菜单】'
        ELSE CONCAT(p.menu_name, ' (ID:', m.parent_id, ')')
    END AS '父菜单',
    m.order_num AS '排序',
    m.path AS '路由',
    m.component AS '组件',
    CASE m.menu_type
        WHEN 'M' THEN '目录'
        WHEN 'C' THEN '菜单'
        WHEN 'F' THEN '按钮'
        ELSE m.menu_type
    END AS '类型',
    CASE 
        WHEN m.visible = '0' THEN '✓'
        ELSE '✗'
    END AS '可见',
    CASE 
        WHEN m.status = '0' THEN '✓'
        ELSE '✗'
    END AS '启用'
FROM sys_menu m
LEFT JOIN sys_menu p ON m.parent_id = p.menu_id
WHERE m.menu_name LIKE '%MSDS%' 
   OR m.menu_name = '智能搜索'
   OR m.component LIKE 'Msds%'
ORDER BY 
    CASE WHEN m.parent_id = 0 THEN 0 ELSE 1 END,
    m.parent_id, 
    m.order_num;

-- ============================================================
-- 第五步：清理前端缓存的提示
-- ============================================================

SELECT 
    '✅ 菜单结构修复完成！' AS '状态',
    '请执行以下步骤完成修复：' AS '下一步';

SELECT 
    1 AS '步骤',
    '在浏览器控制台执行: localStorage.clear()' AS '操作说明'
UNION ALL
SELECT 
    2 AS '步骤',
    '刷新浏览器页面: location.reload()' AS '操作说明'
UNION ALL
SELECT 
    3 AS '步骤',
    '重新登录系统，查看左侧菜单是否恢复正常' AS '操作说明';

-- ============================================================
-- 备选方案B：如果确实需要智能搜索作为一级菜单（不推荐）
-- 取消下面的注释以使用此方案
-- ============================================================

/*
-- 警告：此方案会破坏原有菜单结构，仅在确实需要时使用

-- 将智能搜索设置为一级菜单
UPDATE sys_menu 
SET 
    parent_id = 0,
    menu_type = 'M',  -- 一级菜单必须是目录类型
    path = 'intelligent-search',
    component = NULL,  -- 一级目录没有组件
    order_num = 2,
    visible = '0',
    status = '0',
    icon = 'search'
WHERE menu_name = '智能搜索';

-- 在智能搜索下创建实际的搜索页面作为子菜单
SET @search_parent_id = (SELECT menu_id FROM sys_menu WHERE menu_name = '智能搜索' AND parent_id = 0);

INSERT INTO sys_menu (
    menu_name, parent_id, order_num, path, component,
    is_frame, is_cache, menu_type, visible, status,
    perms, icon, create_by, create_time
)
VALUES (
    '搜索页面', @search_parent_id, 1, 'index', 'Msds/IntelligentSearch',
    1, 0, 'C', '0', '0',
    'system:msds:search', 'search', 'admin', NOW()
)
ON DUPLICATE KEY UPDATE
    parent_id = @search_parent_id,
    component = 'Msds/IntelligentSearch';
*/

-- ============================================================
-- 完成
-- ============================================================

SELECT 
    '📌 提示' AS '',
    '如需恢复备份，请执行: INSERT INTO sys_menu SELECT * FROM sys_menu_backup_temp;' AS '备注';

