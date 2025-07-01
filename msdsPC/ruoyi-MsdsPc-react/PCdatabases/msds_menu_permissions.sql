-- MSDS管理菜单权限配置
-- 作者: ruoyi
-- 日期: 2025-06-29

-- 添加MSDS管理主菜单
INSERT INTO `sys_menu` VALUES ('2000', 'MSDS管理', '0', '5', 'msds', null, '', '', '1', '0', 'M', '0', '0', '', 'FileTextOutlined', 'admin', sysdate(), '', null, 'MSDS管理目录');

-- 添加MSDS主信息管理菜单
INSERT INTO `sys_menu` VALUES ('2001', 'MSDS信息', '2000', '1', 'main', '/msds/main', '', '', '1', '0', 'C', '0', '0', 'system:msds:list', 'file-text', 'admin', sysdate(), '', null, 'MSDS主信息菜单');

-- 添加MSDS主信息相关权限
INSERT INTO `sys_menu` VALUES ('2002', 'MSDS查询', '2001', '1', '#', '', '', '', '1', '0', 'F', '0', '0', 'system:msds:query', '#', 'admin', sysdate(), '', null, '');
INSERT INTO `sys_menu` VALUES ('2003', 'MSDS新增', '2001', '2', '#', '', '', '', '1', '0', 'F', '0', '0', 'system:msds:add', '#', 'admin', sysdate(), '', null, '');
INSERT INTO `sys_menu` VALUES ('2004', 'MSDS修改', '2001', '3', '#', '', '', '', '1', '0', 'F', '0', '0', 'system:msds:edit', '#', 'admin', sysdate(), '', null, '');
INSERT INTO `sys_menu` VALUES ('2005', 'MSDS删除', '2001', '4', '#', '', '', '', '1', '0', 'F', '0', '0', 'system:msds:remove', '#', 'admin', sysdate(), '', null, '');
INSERT INTO `sys_menu` VALUES ('2006', 'MSDS导出', '2001', '5', '#', '', '', '', '1', '0', 'F', '0', '0', 'system:msds:export', '#', 'admin', sysdate(), '', null, '');
INSERT INTO `sys_menu` VALUES ('2007', 'MSDS导入', '2001', '6', '#', '', '', '', '1', '0', 'F', '0', '0', 'system:msds:import', '#', 'admin', sysdate(), '', null, '');

-- 为超级管理员角色分配MSDS菜单权限
INSERT INTO `sys_role_menu` VALUES ('1', '2000');
INSERT INTO `sys_role_menu` VALUES ('1', '2001');
INSERT INTO `sys_role_menu` VALUES ('1', '2002');
INSERT INTO `sys_role_menu` VALUES ('1', '2003');
INSERT INTO `sys_role_menu` VALUES ('1', '2004');
INSERT INTO `sys_role_menu` VALUES ('1', '2005');
INSERT INTO `sys_role_menu` VALUES ('1', '2006');
INSERT INTO `sys_role_menu` VALUES ('1', '2007');

-- 为普通角色分配MSDS菜单权限（可选）
INSERT INTO `sys_role_menu` VALUES ('2', '2000');
INSERT INTO `sys_role_menu` VALUES ('2', '2001');
INSERT INTO `sys_role_menu` VALUES ('2', '2002');
INSERT INTO `sys_role_menu` VALUES ('2', '2003');
INSERT INTO `sys_role_menu` VALUES ('2', '2004');
INSERT INTO `sys_role_menu` VALUES ('2', '2005');
INSERT INTO `sys_role_menu` VALUES ('2', '2006');
INSERT INTO `sys_role_menu` VALUES ('2', '2007'); 