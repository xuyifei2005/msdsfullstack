-- ============================================================
-- 协作工作流菜单配置
-- 创建时间: 2025-01-XX
-- 说明: 在MSDS管理和系统监控之间添加协作工作流菜单
-- ============================================================

USE msds_dev;

-- ============================================================
-- 第1步：查找MSDS管理菜单的ID（作为参考，用于确定order_num）
-- ============================================================

SELECT 
    menu_id, 
    menu_name, 
    parent_id, 
    path, 
    component,
    order_num 
FROM sys_menu 
WHERE menu_name LIKE '%MSDS%' 
  AND parent_id = 0 
  AND menu_type = 'M'
ORDER BY menu_id;

-- ============================================================
-- 第2步：查找系统监控菜单的ID（用于确定order_num）
-- ============================================================

SELECT 
    menu_id, 
    menu_name, 
    parent_id, 
    path, 
    component,
    order_num 
FROM sys_menu 
WHERE menu_name LIKE '%监控%' 
  AND parent_id = 0 
  AND menu_type = 'M'
ORDER BY menu_id;

-- ============================================================
-- 第3步：插入协作工作流一级菜单（位于MSDS管理和系统监控之间）
-- ============================================================

-- 删除可能已存在的菜单（避免重复）
DELETE FROM sys_menu WHERE menu_name = '协作工作流' AND parent_id = 0;

-- 插入协作工作流一级菜单
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
    '协作工作流',                              -- menu_name
    0,                                         -- parent_id（一级菜单）
    3,                                         -- order_num（位于MSDS管理之后，系统监控之前）
    'workflow',                                -- path
    NULL,                                      -- component（一级菜单不需要component）
    1,                                         -- is_frame
    0,                                         -- is_cache
    'M',                                       -- menu_type: M=目录
    '0',                                       -- visible: 0=显示
    '0',                                       -- status: 0=正常
    '',                                        -- perms（一级菜单不需要权限标识）
    'team',                                    -- icon
    'admin',                                   -- create_by
    NOW(),                                     -- create_time
    '协作工作流管理菜单'                        -- remark
);

-- ============================================================
-- 第4步：获取协作工作流菜单的ID
-- ============================================================

SET @workflow_parent_id = (
    SELECT menu_id 
    FROM sys_menu 
    WHERE menu_name = '协作工作流' 
      AND parent_id = 0
      AND path = 'workflow'
    ORDER BY menu_id DESC 
    LIMIT 1
);

-- ============================================================
-- 第5步：插入协作工作流子菜单
-- ============================================================

-- 5.1 工作流看板（主页面）
INSERT INTO sys_menu (
    menu_name, parent_id, order_num, path, component, is_frame, is_cache, 
    menu_type, visible, status, perms, icon, create_by, create_time, remark
)
VALUES (
    '工作流看板', @workflow_parent_id, 1, 'board', 'Workflow/index', 
    1, 0, 'C', '0', '0', 'system:workflow:list', 'dashboard', 'admin', NOW(), 
    '协作工作流看板页面'
);

-- ============================================================
-- 第6步：插入操作权限按钮
-- ============================================================

-- 6.1 查询刚才插入的工作流看板菜单的menu_id
SET @workflow_board_id = (
    SELECT menu_id 
    FROM sys_menu 
    WHERE menu_name = '工作流看板' 
      AND parent_id = @workflow_parent_id
      AND path = 'board'
    ORDER BY menu_id DESC 
    LIMIT 1
);

-- 6.2 插入操作权限：查询
INSERT INTO sys_menu (
    menu_name, parent_id, order_num, path, perms, menu_type, visible, status, create_by, create_time
)
VALUES (
    '工作流查询', @workflow_board_id, 1, '#', 'system:workflow:query', 'F', '0', '0', 'admin', NOW()
);

-- 6.3 插入操作权限：新增
INSERT INTO sys_menu (
    menu_name, parent_id, order_num, path, perms, menu_type, visible, status, create_by, create_time
)
VALUES (
    '工作流新增', @workflow_board_id, 2, '#', 'system:workflow:add', 'F', '0', '0', 'admin', NOW()
);

-- 6.4 插入操作权限：修改
INSERT INTO sys_menu (
    menu_name, parent_id, order_num, path, perms, menu_type, visible, status, create_by, create_time
)
VALUES (
    '工作流修改', @workflow_board_id, 3, '#', 'system:workflow:edit', 'F', '0', '0', 'admin', NOW()
);

-- 6.5 插入操作权限：删除
INSERT INTO sys_menu (
    menu_name, parent_id, order_num, path, perms, menu_type, visible, status, create_by, create_time
)
VALUES (
    '工作流删除', @workflow_board_id, 4, '#', 'system:workflow:remove', 'F', '0', '0', 'admin', NOW()
);

-- ============================================================
-- 第7步：为超级管理员角色分配协作工作流菜单权限
-- ============================================================

-- 7.1 获取所有协作工作流相关的menu_id
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 1 as role_id, menu_id
FROM sys_menu
WHERE (menu_name = '协作工作流' AND parent_id = 0)
   OR (parent_id = @workflow_parent_id)
   OR (perms LIKE 'system:workflow:%')
ON DUPLICATE KEY UPDATE role_id = role_id;

-- ============================================================
-- 第8步：验证菜单配置
-- ============================================================

-- 8.1 查看协作工作流菜单树
SELECT 
    m.menu_id,
    m.menu_name,
    m.parent_id,
    m.path,
    m.component,
    m.perms,
    m.menu_type,
    m.icon,
    m.order_num,
    p.menu_name as parent_name
FROM sys_menu m
LEFT JOIN sys_menu p ON m.parent_id = p.menu_id
WHERE m.menu_name LIKE '%协作工作流%' 
   OR m.perms LIKE 'system:workflow:%'
   OR m.menu_id = @workflow_parent_id
ORDER BY m.parent_id, m.order_num;

-- 8.2 验证超级管理员权限
SELECT 
    r.role_name,
    m.menu_name,
    m.perms,
    m.menu_type
FROM sys_role r
JOIN sys_role_menu rm ON r.role_id = rm.role_id
JOIN sys_menu m ON rm.menu_id = m.menu_id
WHERE r.role_id = 1 
  AND (m.menu_name LIKE '%协作工作流%' OR m.perms LIKE 'system:workflow:%')
ORDER BY m.menu_id;

-- ============================================================
-- 完成提示
-- ============================================================
SELECT 
    '协作工作流菜单配置完成' as message,
    (SELECT COUNT(*) FROM sys_menu WHERE menu_name = '协作工作流' AND parent_id = 0) as menu_added,
    (SELECT COUNT(*) FROM sys_menu WHERE perms LIKE 'system:workflow:%') as permissions_added,
    (SELECT COUNT(*) FROM sys_role_menu WHERE role_id = 1 AND menu_id IN (SELECT menu_id FROM sys_menu WHERE perms LIKE 'system:workflow:%' OR menu_name LIKE '%协作工作流%')) as role_permissions,
    NOW() as completion_time;
