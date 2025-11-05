-- ============================================================
-- 将"智能搜索"设置为一级菜单的正确配置
-- 创建时间: 2025-01-XX
-- 说明: 正确配置一级菜单的层级结构和属性
-- ============================================================

USE msds_dev;

-- ============================================================
-- 方案A: 智能搜索作为一级目录（推荐）
-- ============================================================

-- 第一步：将智能搜索设置为一级目录
UPDATE sys_menu 
SET 
    parent_id = 0,                     -- 一级菜单
    menu_type = 'M',                   -- 必须是M（目录）类型
    path = 'intelligent-search',       -- 一级菜单路径
    component = NULL,                  -- 一级目录没有组件
    order_num = 1,                     -- 排序（调整到第一位）
    visible = '0',                     -- 显示
    status = '0',                      -- 启用
    icon = 'search',                   -- 图标
    perms = ''                         -- 一级目录通常不需要权限
WHERE menu_name = '智能搜索';

-- 第二步：在智能搜索目录下创建实际的搜索页面（作为二级菜单）
-- 获取智能搜索菜单的ID
SET @search_menu_id = (
    SELECT menu_id 
    FROM sys_menu 
    WHERE menu_name = '智能搜索' AND parent_id = 0 
    LIMIT 1
);

-- 删除可能已存在的搜索页面菜单
DELETE FROM sys_menu 
WHERE menu_name = '搜索页面' 
  AND parent_id = @search_menu_id;

-- 创建搜索页面作为二级菜单
INSERT INTO sys_menu (
    menu_name,
    parent_id,
    order_num,
    path,
    component,
    is_frame,
    is_cache,
    menu_type,
    visible,
    status,
    perms,
    icon,
    create_by,
    create_time,
    remark
) VALUES (
    '搜索页面',
    @search_menu_id,                   -- 父菜单是智能搜索
    1,
    'index',                           -- 二级菜单路径
    'Msds/IntelligentSearch',          -- 组件路径
    1,
    0,
    'C',                               -- C类型（菜单）
    '0',                               -- 显示
    '0',                               -- 启用
    'system:msds:search',              -- 权限标识
    'search',
    'admin',
    NOW(),
    '智能搜索页面'
);

-- ============================================================
-- 可选：调整MSDS管理菜单的排序，让智能搜索显示在前面
-- ============================================================
UPDATE sys_menu 
SET order_num = 2 
WHERE menu_name = 'MSDS管理' AND parent_id = 0;

-- ============================================================
-- 验证配置结果
-- ============================================================

SELECT '========== 一级菜单配置 ==========' AS info;

-- 查看所有一级菜单
SELECT 
    menu_id,
    menu_name,
    order_num,
    path,
    component,
    menu_type,
    visible,
    status,
    icon,
    CASE 
        WHEN menu_type = 'M' THEN '✓ 正确（目录）'
        WHEN menu_type = 'C' THEN '✗ 错误（应为M）'
        ELSE menu_type
    END AS type_check,
    CASE 
        WHEN component IS NULL THEN '✓ 正确'
        ELSE '✗ 一级目录不应有组件'
    END AS component_check
FROM sys_menu 
WHERE parent_id = 0 
  AND (menu_name = '智能搜索' OR menu_name = 'MSDS管理')
ORDER BY order_num;

SELECT '========== 智能搜索子菜单 ==========' AS info;

-- 查看智能搜索下的子菜单
SELECT 
    m.menu_id,
    m.menu_name,
    m.parent_id,
    p.menu_name AS parent_menu_name,
    m.order_num,
    m.path,
    m.component,
    m.menu_type,
    m.visible,
    CASE 
        WHEN m.menu_type = 'C' THEN '✓ 正确（菜单）'
        ELSE '注意类型'
    END AS type_check,
    CASE 
        WHEN m.component IS NOT NULL THEN '✓ 正确'
        ELSE '✗ 二级菜单应有组件'
    END AS component_check
FROM sys_menu m
JOIN sys_menu p ON m.parent_id = p.menu_id
WHERE p.menu_name = '智能搜索' AND p.parent_id = 0
ORDER BY m.order_num;

SELECT '========== 完整菜单树 ==========' AS info;

-- 显示完整的菜单树结构
SELECT 
    CASE 
        WHEN m.parent_id = 0 THEN CONCAT('【', m.menu_name, '】')
        ELSE CONCAT('  ├── ', m.menu_name)
    END AS menu_tree,
    m.menu_id,
    m.path,
    m.component,
    m.menu_type,
    m.order_num
FROM sys_menu m
WHERE (m.parent_id = 0 AND m.menu_name IN ('智能搜索', 'MSDS管理'))
   OR (m.parent_id IN (
       SELECT menu_id FROM sys_menu 
       WHERE parent_id = 0 
       AND menu_name IN ('智能搜索', 'MSDS管理')
   ))
ORDER BY 
    CASE WHEN m.parent_id = 0 THEN m.order_num ELSE 999 END,
    m.parent_id,
    m.order_num;

-- ============================================================
-- 访问路径说明
-- ============================================================

SELECT 
    '✅ 配置完成！' AS status,
    '智能搜索已设置为一级菜单' AS result;

SELECT 
    '访问路径' AS info,
    '/intelligent-search/index' AS path,
    '访问此路径即可打开智能搜索页面' AS description
UNION ALL
SELECT 
    '菜单显示',
    '智能搜索（一级） → 搜索页面（二级）',
    '前端会显示此菜单结构';

-- ============================================================
-- 重要提示
-- ============================================================

SELECT 
    '⚠️ 重要提示' AS notice,
    '配置完成后需要清理前端缓存：localStorage.clear() 然后刷新页面' AS action;

-- ============================================================
-- 备选方案：如果不想显示二级菜单
-- ============================================================

/*
如果您希望点击一级菜单直接进入搜索页面（不显示子菜单展开），
可以使用以下配置：

UPDATE sys_menu 
SET 
    parent_id = 0,
    menu_type = 'M',
    path = 'intelligent-search',
    component = NULL,
    redirect = '/intelligent-search/index',  -- 添加重定向
    order_num = 1,
    visible = '0',
    status = '0',
    icon = 'search'
WHERE menu_name = '智能搜索';

-- 同时设置子菜单为隐藏
UPDATE sys_menu 
SET visible = '1'  -- 1表示隐藏
WHERE parent_id = @search_menu_id;
*/

