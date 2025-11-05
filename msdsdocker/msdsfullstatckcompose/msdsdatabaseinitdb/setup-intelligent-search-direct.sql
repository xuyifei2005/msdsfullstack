-- ============================================================
-- 配置智能搜索：点击直接跳转（不显示子菜单）
-- ============================================================

USE msds_dev;

-- Step 1: 确保智能搜索是一级目录
UPDATE sys_menu 
SET 
    parent_id = 0,
    menu_type = 'M',
    component = NULL,
    path = 'intelligent-search',
    order_num = 1,
    visible = '0',
    status = '0',
    icon = 'search'
WHERE menu_id = 2036;

-- Step 2: 删除可能存在的旧的搜索页面
DELETE FROM sys_menu 
WHERE parent_id = 2036 
  AND menu_type = 'C';

-- Step 3: 创建隐藏的搜索页面子菜单
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
    2036,
    1,
    'index',
    'Msds/IntelligentSearch',
    1,
    0,
    'C',
    '1',
    '0',
    'system:msds:search',
    'search',
    'admin',
    NOW(),
    '智能搜索页面'
);

-- Verify the configuration
SELECT 
    menu_id,
    menu_name,
    parent_id,
    path,
    component,
    menu_type,
    CASE visible 
        WHEN '0' THEN 'Show'
        WHEN '1' THEN 'Hidden'
    END AS visibility
FROM sys_menu 
WHERE menu_id = 2036 
   OR parent_id = 2036
ORDER BY parent_id, order_num;

