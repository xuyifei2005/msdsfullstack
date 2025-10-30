-- 测试环境数据库初始化脚本
-- H2数据库兼容MySQL语法

-- 创建MSDS主表
CREATE TABLE IF NOT EXISTS msds_main (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    msds_number VARCHAR(100) COMMENT 'MSDS编号',
    product_name VARCHAR(200) NOT NULL COMMENT '化学品中文名',
    product_english_name VARCHAR(200) COMMENT '化学品英文名',
    product_alias VARCHAR(500) COMMENT '化学品别名/CAS号',
    cas_number VARCHAR(50) COMMENT 'CAS号',
    company_name VARCHAR(200) COMMENT '企业名称',
    company_address VARCHAR(500) COMMENT '企业地址',
    company_phone VARCHAR(50) COMMENT '企业电话',
    company_fax VARCHAR(50) COMMENT '企业传真',
    company_email VARCHAR(100) COMMENT '企业邮箱',
    emergency_phone VARCHAR(50) COMMENT '应急电话',
    msds_version VARCHAR(50) COMMENT 'MSDS版本',
    revision_date DATE COMMENT '修订日期',
    file_name VARCHAR(255) COMMENT '原始文件名',
    file_path VARCHAR(500) COMMENT '文件存储路径',
    file_size BIGINT COMMENT '文件大小（字节）',
    file_type VARCHAR(20) COMMENT '文件类型',
    content_text LONGTEXT COMMENT '文档内容文本',
    parse_status VARCHAR(20) DEFAULT 'SUCCESS' COMMENT '解析状态：SUCCESS/FAILED/PARTIAL',
    parse_error_msg TEXT COMMENT '解析错误信息',
    create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    remark VARCHAR(500) DEFAULT NULL COMMENT '备注',
    del_flag CHAR(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）'
) COMMENT='MSDS主表';

-- 创建索引
CREATE INDEX idx_msds_main_product_name ON msds_main(product_name);
CREATE INDEX idx_msds_main_cas_number ON msds_main(cas_number);
CREATE INDEX idx_msds_main_msds_number ON msds_main(msds_number);
CREATE INDEX idx_msds_main_create_time ON msds_main(create_time);
CREATE INDEX idx_msds_main_parse_status ON msds_main(parse_status);

-- 创建MSDS详细信息表
CREATE TABLE IF NOT EXISTS msds_detail (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    msds_main_id BIGINT NOT NULL COMMENT 'MSDS主表ID',
    section_number INT COMMENT '章节号',
    section_title VARCHAR(200) COMMENT '章节标题',
    section_content LONGTEXT COMMENT '章节内容',
    create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (msds_main_id) REFERENCES msds_main(id) ON DELETE CASCADE
) COMMENT='MSDS详细信息表';

-- 创建索引
CREATE INDEX idx_msds_detail_main_id ON msds_detail(msds_main_id);
CREATE INDEX idx_msds_detail_section ON msds_detail(section_number);

-- 创建MSDS成分信息表
CREATE TABLE IF NOT EXISTS msds_component (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    msds_main_id BIGINT NOT NULL COMMENT 'MSDS主表ID',
    component_name VARCHAR(200) COMMENT '成分名称',
    component_cas VARCHAR(50) COMMENT '成分CAS号',
    component_percentage VARCHAR(50) COMMENT '成分含量百分比',
    component_classification VARCHAR(200) COMMENT '成分分类',
    hazard_statement TEXT COMMENT '危险性说明',
    create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (msds_main_id) REFERENCES msds_main(id) ON DELETE CASCADE
) COMMENT='MSDS成分信息表';

-- 创建索引
CREATE INDEX idx_msds_component_main_id ON msds_component(msds_main_id);
CREATE INDEX idx_msds_component_cas ON msds_component(component_cas);

-- 创建MSDS危险性信息表
CREATE TABLE IF NOT EXISTS msds_hazard (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    msds_main_id BIGINT NOT NULL COMMENT 'MSDS主表ID',
    hazard_category VARCHAR(100) COMMENT '危险性类别',
    hazard_level VARCHAR(50) COMMENT '危险等级',
    hazard_description TEXT COMMENT '危险性描述',
    precautionary_statement TEXT COMMENT '预防措施说明',
    signal_word VARCHAR(50) COMMENT '信号词',
    pictogram VARCHAR(100) COMMENT '象形图',
    create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (msds_main_id) REFERENCES msds_main(id) ON DELETE CASCADE
) COMMENT='MSDS危险性信息表';

-- 创建索引
CREATE INDEX idx_msds_hazard_main_id ON msds_hazard(msds_main_id);
CREATE INDEX idx_msds_hazard_category ON msds_hazard(hazard_category);

-- 创建MSDS物理化学性质表
CREATE TABLE IF NOT EXISTS msds_physical_property (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    msds_main_id BIGINT NOT NULL COMMENT 'MSDS主表ID',
    property_name VARCHAR(100) COMMENT '性质名称',
    property_value VARCHAR(200) COMMENT '性质值',
    property_unit VARCHAR(50) COMMENT '单位',
    test_method VARCHAR(200) COMMENT '测试方法',
    test_condition VARCHAR(200) COMMENT '测试条件',
    create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (msds_main_id) REFERENCES msds_main(id) ON DELETE CASCADE
) COMMENT='MSDS物理化学性质表';

-- 创建索引
CREATE INDEX idx_msds_physical_main_id ON msds_physical_property(msds_main_id);
CREATE INDEX idx_msds_physical_property ON msds_physical_property(property_name);

-- 创建系统用户表（简化版，用于测试）
CREATE TABLE IF NOT EXISTS sys_user (
    user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(30) NOT NULL COMMENT '用户账号',
    nick_name VARCHAR(30) NOT NULL COMMENT '用户昵称',
    email VARCHAR(50) DEFAULT '' COMMENT '用户邮箱',
    phonenumber VARCHAR(11) DEFAULT '' COMMENT '手机号码',
    sex CHAR(1) DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
    avatar VARCHAR(100) DEFAULT '' COMMENT '头像地址',
    password VARCHAR(100) DEFAULT '' COMMENT '密码',
    status CHAR(1) DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
    del_flag CHAR(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
    login_ip VARCHAR(128) DEFAULT '' COMMENT '最后登录IP',
    login_date DATETIME COMMENT '最后登录时间',
    create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    remark VARCHAR(500) DEFAULT NULL COMMENT '备注'
) COMMENT='用户信息表';

-- 插入测试用户
INSERT INTO sys_user (user_id, user_name, nick_name, email, password, status) VALUES 
(1, 'admin', '管理员', 'admin@test.com', '$2a$10$7JB720yubVSOfvam/RdMYeJ3VppJpd/SVjjzqiXY1qzHGhqQ/mc9O', '0'),
(2, 'test', '测试用户', 'test@test.com', '$2a$10$7JB720yubVSOfvam/RdMYeJ3VppJpd/SVjjzqiXY1qzHGhqQ/mc9O', '0');

-- 创建系统部门表（简化版，用于测试）
CREATE TABLE IF NOT EXISTS sys_dept (
    dept_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    parent_id BIGINT DEFAULT 0 COMMENT '父部门id',
    ancestors VARCHAR(50) DEFAULT '' COMMENT '祖级列表',
    dept_name VARCHAR(30) DEFAULT '' COMMENT '部门名称',
    order_num INT DEFAULT 0 COMMENT '显示顺序',
    leader VARCHAR(20) DEFAULT NULL COMMENT '负责人',
    phone VARCHAR(11) DEFAULT NULL COMMENT '联系电话',
    email VARCHAR(50) DEFAULT NULL COMMENT '邮箱',
    status CHAR(1) DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
    del_flag CHAR(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
    create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) COMMENT='部门表';

-- 插入测试部门
INSERT INTO sys_dept (dept_id, parent_id, ancestors, dept_name, order_num, leader, status) VALUES 
(100, 0, '0', '测试公司', 0, '管理员', '0'),
(101, 100, '0,100', '技术部', 1, '技术负责人', '0'),
(102, 100, '0,100', '安全部', 2, '安全负责人', '0');

-- 创建字典类型表（简化版，用于测试）
CREATE TABLE IF NOT EXISTS sys_dict_type (
    dict_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    dict_name VARCHAR(100) DEFAULT '' COMMENT '字典名称',
    dict_type VARCHAR(100) DEFAULT '' COMMENT '字典类型',
    status CHAR(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
    create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    remark VARCHAR(500) DEFAULT NULL COMMENT '备注'
) COMMENT='字典类型表';

-- 创建字典数据表（简化版，用于测试）
CREATE TABLE IF NOT EXISTS sys_dict_data (
    dict_code BIGINT AUTO_INCREMENT PRIMARY KEY,
    dict_sort INT DEFAULT 0 COMMENT '字典排序',
    dict_label VARCHAR(100) DEFAULT '' COMMENT '字典标签',
    dict_value VARCHAR(100) DEFAULT '' COMMENT '字典键值',
    dict_type VARCHAR(100) DEFAULT '' COMMENT '字典类型',
    css_class VARCHAR(100) DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
    list_class VARCHAR(100) DEFAULT NULL COMMENT '表格回显样式',
    is_default CHAR(1) DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
    status CHAR(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
    create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    remark VARCHAR(500) DEFAULT NULL COMMENT '备注'
) COMMENT='字典数据表';

-- 插入MSDS相关字典数据
INSERT INTO sys_dict_type (dict_name, dict_type, status, remark) VALUES 
('MSDS解析状态', 'msds_parse_status', '0', 'MSDS文档解析状态'),
('文件类型', 'file_type', '0', '支持的文件类型'),
('危险等级', 'hazard_level', '0', '化学品危险等级');

INSERT INTO sys_dict_data (dict_sort, dict_label, dict_value, dict_type, status) VALUES 
(1, '解析成功', 'SUCCESS', 'msds_parse_status', '0'),
(2, '解析失败', 'FAILED', 'msds_parse_status', '0'),
(3, '部分解析', 'PARTIAL', 'msds_parse_status', '0'),
(1, 'Word文档', 'DOC', 'file_type', '0'),
(2, 'Word文档', 'DOCX', 'file_type', '0'),
(3, 'PDF文档', 'PDF', 'file_type', '0'),
(4, '文本文件', 'TXT', 'file_type', '0'),
(1, '高危', 'HIGH', 'hazard_level', '0'),
(2, '中危', 'MEDIUM', 'hazard_level', '0'),
(3, '低危', 'LOW', 'hazard_level', '0');

-- 提交事务
COMMIT;