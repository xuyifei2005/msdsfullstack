
-- FAQ Management
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
VALUES('常见问题管理', 1, 100, 'faq', 'Msds/Faq', 1, 0, 'C', '0', '0', 'system:faq:list', 'question', 'admin', NOW(), '常见问题管理菜单');

-- Feedback Management
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
VALUES('意见反馈管理', 1, 101, 'feedback', 'Msds/Feedback', 1, 0, 'C', '0', '0', 'system:feedback:list', 'message', 'admin', NOW(), '意见反馈管理菜单');

-- About Us Management
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, remark)
VALUES('关于我们管理', 1, 102, 'about', 'Msds/About', 1, 0, 'C', '0', '0', 'system:about:list', 'info', 'admin', NOW(), '关于我们管理菜单');
