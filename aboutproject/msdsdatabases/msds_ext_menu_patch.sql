-- ============================================================
-- MSDS 扩展：热门搜索词条管理 / 我的收藏 菜单与权限补丁
-- ------------------------------------------------------------
-- 用法（幂等，可重复执行）：
--   docker exec -i msdsmysql mysql -uroot -p<pwd> msds_dev < <本文件>
--
-- 说明：
--   msds_complete_database.sql 是「全量重建」脚本（会 DROP TABLE sys_menu
--   并按旧 id 体系重新插入），因此新增菜单不能用追加 INSERT 的方式写进它，
--   否则与重建逻辑冲突。这里用独立补丁承载，可重复执行。
-- ============================================================

-- ---------- 菜单 ----------
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (2100, '我的收藏', 2000, '3', 'favorite', 'Msds/Favorite', NULL, '', 1, 0, 'C', '0', '0', 'system:msds:favorite', 'star', 'admin', NOW(), '', NULL, '用户收藏的MSDS文档')
ON DUPLICATE KEY UPDATE menu_name = VALUES(menu_name), component = VALUES(component), perms = VALUES(perms), remark = VALUES(remark);

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (2101, '搜索词条', 2000, '4', 'suggestion', 'Msds/Suggestion', NULL, '', 1, 0, 'C', '0', '0', 'system:msds:suggestion', 'profile', 'admin', NOW(), '', NULL, '热门搜索策展词条维护')
ON DUPLICATE KEY UPDATE menu_name = VALUES(menu_name), component = VALUES(component), perms = VALUES(perms), remark = VALUES(remark);

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (2102, '词条查询', 2101, '1', '#', NULL, NULL, '', 1, 0, 'F', '0', '0', 'system:msds:suggestion:query', '#', 'admin', NOW(), '', NULL, '')
ON DUPLICATE KEY UPDATE menu_name = VALUES(menu_name), perms = VALUES(perms);

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (2103, '词条新增', 2101, '2', '#', NULL, NULL, '', 1, 0, 'F', '0', '0', 'system:msds:suggestion:add', '#', 'admin', NOW(), '', NULL, '')
ON DUPLICATE KEY UPDATE menu_name = VALUES(menu_name), perms = VALUES(perms);

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (2104, '词条修改', 2101, '3', '#', NULL, NULL, '', 1, 0, 'F', '0', '0', 'system:msds:suggestion:edit', '#', 'admin', NOW(), '', NULL, '')
ON DUPLICATE KEY UPDATE menu_name = VALUES(menu_name), perms = VALUES(perms);

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query, route_name, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES (2105, '词条删除', 2101, '4', '#', NULL, NULL, '', 1, 0, 'F', '0', '0', 'system:msds:suggestion:remove', '#', 'admin', NOW(), '', NULL, '')
ON DUPLICATE KEY UPDATE menu_name = VALUES(menu_name), perms = VALUES(perms);

-- ---------- 角色授权 ----------
-- role_id=1 超级管理员：全部菜单
INSERT IGNORE INTO sys_role_menu (role_id, menu_id) VALUES (1, 2100), (1, 2101), (1, 2102), (1, 2103), (1, 2104), (1, 2105);
-- role_id=2 普通角色：仅「我的收藏」（词条维护属运营职能，不下放）
INSERT IGNORE INTO sys_role_menu (role_id, menu_id) VALUES (2, 2100);

-- ---------- 清理失效引用 ----------
-- 统计表/访问日志中指向已不存在文档的孤儿行
DELETE s FROM msds_document_statistics s LEFT JOIN msds_main m ON m.id = s.msds_id WHERE m.id IS NULL;
DELETE a FROM msds_document_access_log a LEFT JOIN msds_main m ON m.id = a.msds_id WHERE m.id IS NULL;
-- 收藏表中指向已不存在文档的孤儿行
DELETE f FROM msds_user_favorite f LEFT JOIN msds_main m ON m.id = f.msds_id WHERE m.id IS NULL;
