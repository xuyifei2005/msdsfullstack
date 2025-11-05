-- Quick Fix for MSDS Menu Structure
-- Simplified version without Chinese aliases

USE msds_dev;

-- Step 1: Get or create MSDS parent menu
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

SET @msds_parent_id = (
    SELECT menu_id 
    FROM sys_menu 
    WHERE menu_name = 'MSDS管理' AND parent_id = 0 
    LIMIT 1
);

-- Step 2: Fix Intelligent Search menu (restore to level 2)
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

-- Step 3: Fix MSDS Document menu
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

-- Step 4: Fix MSDS Detail page (hidden menu)
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

-- Step 5: Delete duplicate or orphan menus
DELETE FROM sys_menu 
WHERE (menu_name LIKE '%MSDS%' OR menu_name = '智能搜索')
  AND parent_id != 0 
  AND NOT EXISTS (
      SELECT 1 FROM (SELECT menu_id FROM sys_menu) p 
      WHERE p.menu_id = parent_id
  );

-- Step 6: Verify results
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

