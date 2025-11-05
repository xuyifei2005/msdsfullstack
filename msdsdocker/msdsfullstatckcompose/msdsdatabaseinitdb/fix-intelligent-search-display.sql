-- ============================================================
-- 修复智能搜索页面显示问题
-- 问题：点击智能搜索后页面是空的
-- 解决方案：配置正确的路由和组件关系
-- ============================================================

USE msds_dev;

-- 方案1：显示子菜单（当前已应用）
-- 这样用户可以看到"智能搜索 -> 搜索页面"的层级

UPDATE sys_menu SET visible = '0' WHERE menu_id = 2042;

-- ============================================================
-- 方案2：修改为默认路由（推荐）
-- 将子菜单的path改为空字符串，使其成为默认路由
-- ============================================================

-- 这个方案会让用户访问 /intelligent-search 时直接显示内容
UPDATE sys_menu 
SET 
    path = '',
    visible = '1'
WHERE menu_id = 2042;

-- ============================================================
-- 方案3：简化为单层菜单（如果不介意显示子菜单）
-- ============================================================

/*
-- 删除一级目录，将搜索页面提升为一级菜单
DELETE FROM sys_menu WHERE menu_id = 2036;

UPDATE sys_menu 
SET 
    parent_id = 0,
    menu_name = '智能搜索',
    path = 'intelligent-search',
    component = 'Msds/IntelligentSearch',
    menu_type = 'C',
    order_num = 1,
    visible = '0',
    icon = 'search'
WHERE menu_id = 2042;
*/

-- ============================================================
-- 验证当前配置
-- ============================================================

SELECT 
    menu_id,
    menu_name,
    parent_id,
    path,
    component,
    menu_type,
    visible,
    CONCAT('/intelligent-search', CASE WHEN path != '' THEN CONCAT('/', path) ELSE '' END) AS full_path
FROM sys_menu 
WHERE menu_id IN (2036, 2042)
ORDER BY parent_id, order_num;

