-- Final Fix for MSDS Menu Structure
USE msds_dev;

-- Get parent menu ID
SET @msds_parent_id = (
    SELECT menu_id 
    FROM sys_menu 
    WHERE menu_name = 'MSDS管理' AND parent_id = 0 
    LIMIT 1
);

-- Fix: Move Intelligent Search to level 2 under MSDS Management
UPDATE sys_menu 
SET 
    parent_id = @msds_parent_id,
    menu_type = 'C',
    path = 'search',
    component = 'Msds/IntelligentSearch',
    order_num = 1,
    visible = '0',
    status = '0',
    icon = 'search'
WHERE menu_name = '智能搜索' AND menu_id = 2036;

-- Delete the orphan/corrupted menu entry
DELETE FROM sys_menu 
WHERE menu_id = parent_id
   OR (menu_name LIKE '%???%')
   OR (menu_name LIKE '%MSDS%' AND component IS NULL AND menu_type = 'C');

-- Verify the fix
SELECT 
    m.menu_id,
    m.menu_name,
    m.parent_id,
    CASE 
        WHEN m.parent_id = 0 THEN '[TOP LEVEL]'
        ELSE p.menu_name
    END AS parent_name,
    m.order_num,
    m.path,
    m.component,
    m.menu_type,
    m.visible,
    m.status
FROM sys_menu m
LEFT JOIN sys_menu p ON m.parent_id = p.menu_id
WHERE m.menu_name LIKE '%MSDS%' 
   OR m.menu_name = '智能搜索'
   OR m.component LIKE 'Msds%'
ORDER BY 
    CASE WHEN m.parent_id = 0 THEN 0 ELSE 1 END,
    m.parent_id, 
    m.order_num;

