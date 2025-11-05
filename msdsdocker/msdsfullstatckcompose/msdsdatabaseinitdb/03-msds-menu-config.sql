-- ============================================================
-- MSDS智能搜索和详情页面菜单配置
-- 创建时间: 2025-01-XX
-- 说明: 添加智能搜索和MSDS详情页面的菜单项
-- ============================================================

USE msds_dev;

-- ============================================================
-- 1. 查找MSDS管理菜单的ID（假设父菜单名称为"MSDS管理"或"msds"）
-- ============================================================

-- 如果MSDS管理菜单不存在，先创建父菜单
INSERT INTO `sys_menu` (`menu_name`, `parent_id`, `order_num`, `path`, `component`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
SELECT 'MSDS管理', 0, 2, 'msds', NULL, 1, 0, 'M', '0', '0', '', 'form', 'admin', NOW(), '', NULL, 'MSDS文档管理菜单'
WHERE NOT EXISTS (
    SELECT 1 FROM `sys_menu` WHERE `menu_name` = 'MSDS管理' AND `parent_id` = 0
);

-- 获取MSDS管理菜单的ID
SET @msds_parent_id = (SELECT `menu_id` FROM `sys_menu` WHERE `menu_name` = 'MSDS管理' AND `parent_id` = 0 LIMIT 1);

-- ============================================================
-- 2. 添加智能搜索菜单
-- ============================================================

-- 删除可能已存在的智能搜索菜单（避免重复）
DELETE FROM `sys_menu` WHERE `menu_name` = '智能搜索' AND `path` = 'search';

-- 插入智能搜索菜单
INSERT INTO `sys_menu` (
    `menu_name`,
    `parent_id`,
    `order_num`,
    `path`,
    `component`,
    `is_frame`,
    `is_cache`,
    `menu_type`,
    `visible`,
    `status`,
    `perms`,
    `icon`,
    `create_by`,
    `create_time`,
    `update_by`,
    `update_time`,
    `remark`
) VALUES (
    '智能搜索',
    @msds_parent_id,
    2,
    '/msds/search',
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
    '',
    NULL,
    'MSDS智能搜索功能'
);

-- ============================================================
-- 3. 添加MSDS详情页面菜单（隐藏菜单，通过路由访问）
-- ============================================================

-- 删除可能已存在的详情页面菜单
DELETE FROM `sys_menu` WHERE `menu_name` = 'MSDS详情' AND `path` = 'detail/:id';

-- 插入MSDS详情页面菜单
INSERT INTO `sys_menu` (
    `menu_name`,
    `parent_id`,
    `order_num`,
    `path`,
    `component`,
    `is_frame`,
    `is_cache`,
    `menu_type`,
    `visible`,
    `status`,
    `perms`,
    `icon`,
    `create_by`,
    `create_time`,
    `update_by`,
    `update_time`,
    `remark`
) VALUES (
    'MSDS详情',
    @msds_parent_id,
    99,
    'detail/:id',
    'Msds/Detail',
    1,
    0,
    'C',
    '1',
    '0',
    'system:msds:detail',
    'eye',
    'admin',
    NOW(),
    '',
    NULL,
    'MSDS文档详情页面（隐藏菜单）'
);

-- ============================================================
-- 4. 添加MSDS文档管理菜单（如果不存在）
-- ============================================================

-- 删除可能已存在的MSDS管理菜单
DELETE FROM `sys_menu` WHERE `menu_name` = 'MSDS管理' AND `path` = 'main';

-- 插入MSDS文档管理菜单
INSERT INTO `sys_menu` (
    `menu_name`,
    `parent_id`,
    `order_num`,
    `path`,
    `component`,
    `is_frame`,
    `is_cache`,
    `menu_type`,
    `visible`,
    `status`,
    `perms`,
    `icon`,
    `create_by`,
    `create_time`,
    `update_by`,
    `update_time`,
    `remark`
) VALUES (
    'MSDS文档',
    @msds_parent_id,
    2,
    'main',
    'Msds/index',
    1,
    0,
    'C',
    '0',
    '0',
    'system:msds:list',
    'form',
    'admin',
    NOW(),
    '',
    NULL,
    'MSDS文档列表管理'
);

-- ============================================================
-- 5. 验证插入结果
-- ============================================================

SELECT 
    m.menu_id AS '菜单ID',
    m.menu_name AS '菜单名称',
    m.parent_id AS '父菜单ID',
    p.menu_name AS '父菜单名称',
    m.order_num AS '排序',
    m.path AS '路由地址',
    m.component AS '组件路径',
    m.visible AS '是否可见',
    m.status AS '菜单状态',
    m.perms AS '权限标识',
    m.icon AS '菜单图标'
FROM sys_menu m
LEFT JOIN sys_menu p ON m.parent_id = p.menu_id
WHERE m.parent_id = @msds_parent_id
   OR m.menu_id = @msds_parent_id
ORDER BY m.parent_id, m.order_num;

-- ============================================================
-- 完成提示
-- ============================================================

SELECT '✅ MSDS菜单配置完成！' AS '执行结果',
       '请刷新前端页面查看智能搜索菜单' AS '下一步操作';

