-- ============================================================
-- 数据分析报告菜单配置
-- 创建时间: 2025-11-06
-- 说明: 在MSDS管理菜单下添加数据分析报告子菜单
-- ============================================================

USE msds_dev;

-- ============================================================
-- 第1步：查找MSDS管理一级菜单的menu_id
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
-- 第2步：插入数据分析报告菜单
-- 注意：这里使用动态查询MSDS管理的menu_id作为parent_id
-- ============================================================

-- 2.1 插入数据分析菜单（作为MSDS管理的子菜单）
INSERT INTO sys_menu (
    menu_name, 
    parent_id, 
    order_num, 
    path, 
    component, 
    is_frame, 
    menu_type, 
    visible, 
    status, 
    perms, 
    icon, 
    create_by, 
    create_time,
    remark
)
SELECT 
    '数据分析',                              -- menu_name
    m.menu_id,                                -- parent_id（MSDS管理的menu_id）
    2,                                         -- order_num（排在MSDS信息之后）
    'analytics',                               -- path
    'Analytics/DataReport',                    -- component
    1,                                         -- is_frame
    'C',                                       -- menu_type: C=菜单
    '0',                                       -- visible: 0=显示
    '0',                                       -- status: 0=正常
    'system:analytics:view',                   -- perms
    'bar-chart',                               -- icon
    'admin',                                   -- create_by
    NOW(),                                     -- create_time
    '数据分析报告页面'                        -- remark
FROM sys_menu m
WHERE m.menu_name = 'MSDS管理' 
  AND m.parent_id = 0 
  AND m.menu_type = 'M'
LIMIT 1;

-- ============================================================
-- 第3步：插入数据分析的操作权限按钮
-- ============================================================

-- 3.1 查询刚才插入的数据分析菜单的menu_id
SET @analytics_menu_id = (
    SELECT menu_id 
    FROM sys_menu 
    WHERE menu_name = '数据分析' 
      AND path = 'analytics'
      AND component = 'Analytics/DataReport'
    ORDER BY menu_id DESC 
    LIMIT 1
);

-- 3.2 插入操作权限：查看基础统计
INSERT INTO sys_menu (
    menu_name, parent_id, order_num, path, perms, menu_type, visible, status, create_by, create_time
)
VALUES (
    '基础统计', @analytics_menu_id, 1, '#', 'system:analytics:summary', 'F', '0', '0', 'admin', NOW()
);

-- 3.3 插入操作权限：查看趋势
INSERT INTO sys_menu (
    menu_name, parent_id, order_num, path, perms, menu_type, visible, status, create_by, create_time
)
VALUES (
    '访问趋势', @analytics_menu_id, 2, '#', 'system:analytics:trend', 'F', '0', '0', 'admin', NOW()
);

-- 3.4 插入操作权限：查看分类
INSERT INTO sys_menu (
    menu_name, parent_id, order_num, path, perms, menu_type, visible, status, create_by, create_time
)
VALUES (
    '分类分布', @analytics_menu_id, 3, '#', 'system:analytics:category', 'F', '0', '0', 'admin', NOW()
);

-- 3.5 插入操作权限：查看危险等级
INSERT INTO sys_menu (
    menu_name, parent_id, order_num, path, perms, menu_type, visible, status, create_by, create_time
)
VALUES (
    '危险等级', @analytics_menu_id, 4, '#', 'system:analytics:hazard', 'F', '0', '0', 'admin', NOW()
);

-- 3.6 插入操作权限：查看排行榜
INSERT INTO sys_menu (
    menu_name, parent_id, order_num, path, perms, menu_type, visible, status, create_by, create_time
)
VALUES (
    '热门排行', @analytics_menu_id, 5, '#', 'system:analytics:ranking', 'F', '0', '0', 'admin', NOW()
);

-- 3.7 插入操作权限：查看月度统计
INSERT INTO sys_menu (
    menu_name, parent_id, order_num, path, perms, menu_type, visible, status, create_by, create_time
)
VALUES (
    '月度统计', @analytics_menu_id, 6, '#', 'system:analytics:monthly', 'F', '0', '0', 'admin', NOW()
);

-- 3.8 插入操作权限：查看用户活跃度
INSERT INTO sys_menu (
    menu_name, parent_id, order_num, path, perms, menu_type, visible, status, create_by, create_time
)
VALUES (
    '用户活跃度', @analytics_menu_id, 7, '#', 'system:analytics:users', 'F', '0', '0', 'admin', NOW()
);

-- 3.9 插入操作权限：导出报告
INSERT INTO sys_menu (
    menu_name, parent_id, order_num, path, perms, menu_type, visible, status, create_by, create_time
)
VALUES (
    '导出报告', @analytics_menu_id, 8, '#', 'system:analytics:export', 'F', '0', '0', 'admin', NOW()
);

-- ============================================================
-- 第4步：为超级管理员角色分配数据分析菜单权限
-- ============================================================

-- 4.1 获取所有数据分析相关的menu_id
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 1 as role_id, menu_id
FROM sys_menu
WHERE (menu_name = '数据分析' AND component = 'Analytics/DataReport')
   OR (perms LIKE 'system:analytics:%')
ON DUPLICATE KEY UPDATE role_id = role_id;

-- ============================================================
-- 第5步：验证菜单配置
-- ============================================================

-- 5.1 查看数据分析菜单树
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
WHERE m.menu_name LIKE '%数据分析%' 
   OR m.perms LIKE 'system:analytics:%'
   OR m.menu_id = @analytics_menu_id
ORDER BY m.parent_id, m.order_num;

-- 5.2 验证超级管理员权限
SELECT 
    r.role_name,
    m.menu_name,
    m.perms,
    m.menu_type
FROM sys_role r
JOIN sys_role_menu rm ON r.role_id = rm.role_id
JOIN sys_menu m ON rm.menu_id = m.menu_id
WHERE r.role_id = 1 
  AND (m.menu_name LIKE '%数据分析%' OR m.perms LIKE 'system:analytics:%')
ORDER BY m.menu_id;

-- ============================================================
-- 完成提示
-- ============================================================
SELECT 
    '数据分析菜单配置完成' as message,
    (SELECT COUNT(*) FROM sys_menu WHERE menu_name = '数据分析' AND component = 'Analytics/DataReport') as menu_added,
    (SELECT COUNT(*) FROM sys_menu WHERE perms LIKE 'system:analytics:%') as permissions_added,
    (SELECT COUNT(*) FROM sys_role_menu WHERE role_id = 1 AND menu_id IN (SELECT menu_id FROM sys_menu WHERE perms LIKE 'system:analytics:%')) as role_permissions,
    NOW() as completion_time;


