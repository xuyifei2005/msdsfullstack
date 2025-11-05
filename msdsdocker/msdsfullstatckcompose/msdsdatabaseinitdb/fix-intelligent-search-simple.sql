-- ============================================================
-- 简化方案：将智能搜索作为MSDS管理的子菜单
-- 这是最可靠的方案，确保能正常显示
-- ============================================================

USE msds_dev;

-- 获取MSDS管理的菜单ID
SET @msds_parent_id = (SELECT menu_id FROM sys_menu WHERE menu_name = 'MSDS管理' AND parent_id = 0 LIMIT 1);

-- 删除旧的智能搜索相关菜单
DELETE FROM sys_menu WHERE menu_id IN (2036, 2042);

-- 创建智能搜索作为MSDS管理下的子菜单
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
    '智能搜索',
    @msds_parent_id,
    0,
    'intelligent-search',
    'Msds/IntelligentSearch',
    1,
    0,
    'C',
    '0',
    '0',
    'system:msds:search',
    'search',
    'admin',
    NOW(),
    '智能搜索功能'
);

-- 验证结果
SELECT 
    m.menu_id,
    m.menu_name,
    m.parent_id,
    p.menu_name AS parent_menu_name,
    m.order_num,
    m.path,
    m.component,
    m.menu_type,
    m.visible
FROM sys_menu m
LEFT JOIN sys_menu p ON m.parent_id = p.menu_id
WHERE m.menu_name = '智能搜索' OR m.parent_id = @msds_parent_id
ORDER BY m.order_num;

