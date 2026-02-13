-- =============================================
-- MSDS实验室管理系统 - 完整数据库初始化脚本
-- 版本: v2.0
-- 创建时间: 2025-01-27
-- 数据库: MySQL 8.0.42
-- 字符集: UTF8MB4
-- 基于: RuoYi框架 + 安全智库
-- 标准: GB/T 16483-2008、GB/T 17519-2013
-- =============================================

-- 设置SQL模式，避免兼容性问题
SET @old_sql_mode = @@sql_mode;
SET SESSION sql_mode = 'TRADITIONAL,NO_AUTO_VALUE_ON_ZERO';
SET SESSION sql_mode = REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', '');

-- 创建MSDS数据库
CREATE DATABASE IF NOT EXISTS msds_dev 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE msds_dev;

-- =============================================
-- 1. RuoYi系统基础表
-- =============================================

-- 部门表
DROP TABLE IF EXISTS sys_dept;
CREATE TABLE sys_dept (
  dept_id           bigint(20)      not null auto_increment    comment '部门id',
  parent_id         bigint(20)      default 0                  comment '父部门id',
  ancestors         varchar(50)     default ''                 comment '祖级列表',
  dept_name         varchar(30)     default ''                 comment '部门名称',
  order_num         int(4)          default 0                  comment '显示顺序',
  leader            varchar(20)     default null               comment '负责人',
  phone             varchar(11)     default null               comment '联系电话',
  email             varchar(50)     default null               comment '邮箱',
  status            char(1)         default '0'                comment '部门状态（0正常 1停用）',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  primary key (dept_id)
) engine=innodb auto_increment=200 comment = '部门表';

-- 用户信息表
DROP TABLE IF EXISTS sys_user;
CREATE TABLE sys_user (
  user_id           bigint(20)      not null auto_increment    comment '用户ID',
  dept_id           bigint(20)      default null               comment '部门ID',
  user_name         varchar(30)     not null                   comment '用户账号',
  nick_name         varchar(30)     not null                   comment '用户昵称',
  user_type         varchar(2)      default '00'               comment '用户类型（00系统用户）',
  email             varchar(50)     default ''                 comment '用户邮箱',
  phonenumber       varchar(11)     default ''                 comment '手机号码',
  sex               char(1)         default '0'                comment '用户性别（0男 1女 2未知）',
  avatar            varchar(100)    default ''                 comment '头像地址',
  password          varchar(100)    default ''                 comment '密码',
  status            char(1)         default '0'                comment '帐号状态（0正常 1停用）',
  del_flag          char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  login_ip          varchar(128)    default ''                 comment '最后登录IP',
  login_date        datetime                                   comment '最后登录时间',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (user_id)
) engine=innodb auto_increment=100 comment = '用户信息表';

-- 岗位信息表
DROP TABLE IF EXISTS sys_post;
CREATE TABLE sys_post (
  post_id       bigint(20)      not null auto_increment    comment '岗位ID',
  post_code     varchar(64)     not null                   comment '岗位编码',
  post_name     varchar(50)     not null                   comment '岗位名称',
  post_sort     int(4)          not null                   comment '显示顺序',
  status        char(1)         not null                   comment '状态（0正常 1停用）',
  create_by     varchar(64)     default ''                 comment '创建者',
  create_time   datetime                                   comment '创建时间',
  update_by     varchar(64)     default ''                 comment '更新者',
  update_time   datetime                                   comment '更新时间',
  remark        varchar(500)    default null               comment '备注',
  primary key (post_id)
) engine=innodb comment = '岗位信息表';

-- 角色信息表
DROP TABLE IF EXISTS sys_role;
CREATE TABLE sys_role (
  role_id              bigint(20)      not null auto_increment    comment '角色ID',
  role_name            varchar(30)     not null                   comment '角色名称',
  role_key             varchar(100)    not null                   comment '角色权限字符串',
  role_sort            int(4)          not null                   comment '显示顺序',
  data_scope           char(1)         default '1'                comment '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  menu_check_strictly  tinyint(1)      default 1                  comment '菜单树选择项是否关联显示',
  dept_check_strictly  tinyint(1)      default 1                  comment '部门树选择项是否关联显示',
  status               char(1)         not null                   comment '角色状态（0正常 1停用）',
  del_flag             char(1)         default '0'                comment '删除标志（0代表存在 2代表删除）',
  create_by            varchar(64)     default ''                 comment '创建者',
  create_time          datetime                                   comment '创建时间',
  update_by            varchar(64)     default ''                 comment '更新者',
  update_time          datetime                                   comment '更新时间',
  remark               varchar(500)    default null               comment '备注',
  primary key (role_id)
) engine=innodb auto_increment=100 comment = '角色信息表';

-- 菜单权限表
DROP TABLE IF EXISTS sys_menu;
CREATE TABLE sys_menu (
  menu_id           bigint(20)      not null auto_increment    comment '菜单ID',
  menu_name         varchar(50)     not null                   comment '菜单名称',
  parent_id         bigint(20)      default 0                  comment '父菜单ID',
  order_num         int(4)          default 0                  comment '显示顺序',
  path              varchar(200)    default ''                 comment '路由地址',
  component         varchar(255)    default null               comment '组件路径',
  query             varchar(255)    default null               comment '路由参数',
  is_frame          int(1)          default 1                  comment '是否为外链（0是 1否）',
  is_cache          int(1)          default 0                  comment '是否缓存（0缓存 1不缓存）',
  menu_type         char(1)         default ''                 comment '菜单类型（M目录 C菜单 F按钮）',
  visible           char(1)         default 0                  comment '菜单状态（0显示 1隐藏）',
  status            char(1)         default 0                  comment '菜单状态（0正常 1停用）',
  perms             varchar(100)    default null               comment '权限标识',
  icon              varchar(100)    default '#'                comment '菜单图标',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default ''                 comment '备注',
  primary key (menu_id)
) engine=innodb auto_increment=2000 comment = '菜单权限表';

-- 用户和角色关联表
DROP TABLE IF EXISTS sys_user_role;
CREATE TABLE sys_user_role (
  user_id   bigint(20) not null comment '用户ID',
  role_id   bigint(20) not null comment '角色ID',
  primary key(user_id, role_id)
) engine=innodb comment = '用户和角色关联表';

-- 角色和菜单关联表
DROP TABLE IF EXISTS sys_role_menu;
CREATE TABLE sys_role_menu (
  role_id   bigint(20) not null comment '角色ID',
  menu_id   bigint(20) not null comment '菜单ID',
  primary key(role_id, menu_id)
) engine=innodb comment = '角色和菜单关联表';

-- 用户和岗位关联表
DROP TABLE IF EXISTS sys_user_post;
CREATE TABLE sys_user_post (
  user_id   bigint(20) not null comment '用户ID',
  post_id   bigint(20) not null comment '岗位ID',
  primary key (user_id, post_id)
) engine=innodb comment = '用户与岗位关联表';

-- 角色和部门关联表
DROP TABLE IF EXISTS sys_role_dept;
CREATE TABLE sys_role_dept (
  role_id   bigint(20) not null comment '角色ID',
  dept_id   bigint(20) not null comment '部门ID',
  primary key(role_id, dept_id)
) engine=innodb comment = '角色和部门关联表';

-- 操作日志记录
DROP TABLE IF EXISTS sys_oper_log;
CREATE TABLE sys_oper_log (
  oper_id           bigint(20)      not null auto_increment    comment '日志主键',
  title             varchar(50)     default ''                 comment '模块标题',
  business_type     int(2)          default 0                  comment '业务类型（0其它 1新增 2修改 3删除）',
  method            varchar(100)    default ''                 comment '方法名称',
  request_method    varchar(10)     default ''                 comment '请求方式',
  operator_type     int(1)          default 0                  comment '操作类别（0其它 1后台用户 2手机端用户）',
  oper_name         varchar(50)     default ''                 comment '操作人员',
  dept_name         varchar(50)     default ''                 comment '部门名称',
  oper_url          varchar(255)    default ''                 comment '请求URL',
  oper_ip           varchar(128)    default ''                 comment '主机地址',
  oper_location     varchar(255)    default ''                 comment '操作地点',
  oper_param        varchar(2000)   default ''                 comment '请求参数',
  json_result       varchar(2000)   default ''                 comment '返回参数',
  status            int(1)          default 0                  comment '操作状态（0正常 1异常）',
  error_msg         varchar(2000)   default ''                 comment '错误消息',
  oper_time         datetime                                   comment '操作时间',
  cost_time         bigint(20)      default 0                  comment '消耗时间',
  primary key (oper_id),
  key idx_sys_oper_log_bt (business_type),
  key idx_sys_oper_log_s  (status),
  key idx_sys_oper_log_ot (oper_time)
) engine=innodb auto_increment=100 comment = '操作日志记录';

-- 系统访问记录
DROP TABLE IF EXISTS sys_logininfor;
CREATE TABLE sys_logininfor (
  info_id        bigint(20)     not null auto_increment   comment '访问ID',
  user_name      varchar(50)    default ''                comment '用户账号',
  ipaddr         varchar(128)   default ''                comment '登录IP地址',
  login_location varchar(255)   default ''                comment '登录地点',
  browser        varchar(50)    default ''                comment '浏览器类型',
  os             varchar(50)    default ''                comment '操作系统',
  status         char(1)        default '0'               comment '登录状态（0成功 1失败）',
  msg            varchar(255)   default ''                comment '提示消息',
  login_time     datetime                                 comment '访问时间',
  primary key (info_id),
  key idx_sys_logininfor_s  (status),
  key idx_sys_logininfor_lt (login_time)
) engine=innodb auto_increment=100 comment = '系统访问记录';

-- 定时任务调度表
DROP TABLE IF EXISTS sys_job;
CREATE TABLE sys_job (
  job_id              bigint(20)    not null auto_increment    comment '任务ID',
  job_name            varchar(64)   default ''                 comment '任务名称',
  job_group           varchar(64)   default 'DEFAULT'          comment '任务组名',
  invoke_target       varchar(500)  not null                   comment '调用目标字符串',
  cron_expression     varchar(255)  default ''                 comment 'cron执行表达式',
  misfire_policy      varchar(20)   default '3'                comment '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  concurrent          char(1)       default '1'                comment '是否并发执行（0允许 1禁止）',
  status              char(1)       default '0'                comment '状态（0正常 1暂停）',
  create_by           varchar(64)   default ''                 comment '创建者',
  create_time         datetime                                 comment '创建时间',
  update_by           varchar(64)   default ''                 comment '更新者',
  update_time         datetime                                 comment '更新时间',
  remark              varchar(500)  default ''                 comment '备注信息',
  primary key (job_id, job_name, job_group)
) engine=innodb auto_increment=100 comment = '定时任务调度表';

-- 定时任务调度日志表
DROP TABLE IF EXISTS sys_job_log;
CREATE TABLE sys_job_log (
  job_log_id          bigint(20)     not null auto_increment    comment '任务日志ID',
  job_name            varchar(64)    not null                   comment '任务名称',
  job_group           varchar(64)    not null                   comment '任务组名',
  invoke_target       varchar(500)   not null                   comment '调用目标字符串',
  job_message         varchar(500)                              comment '日志信息',
  status              char(1)        default '0'                comment '执行状态（0正常 1失败）',
  exception_info      varchar(2000)  default ''                 comment '异常信息',
  create_time         datetime                                  comment '创建时间',
  primary key (job_log_id)
) engine=innodb comment = '定时任务调度日志表';

-- 通知公告表
DROP TABLE IF EXISTS sys_notice;
CREATE TABLE sys_notice (
  notice_id         int(4)          not null auto_increment    comment '公告ID',
  notice_title      varchar(50)     not null                   comment '公告标题',
  notice_type       char(1)         not null                   comment '公告类型（1通知 2公告）',
  notice_content    longblob                                   comment '公告内容',
  status            char(1)         default '0'                comment '公告状态（0正常 1关闭）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(255)    default null               comment '备注',
  primary key (notice_id)
) engine=innodb auto_increment=10 comment = '通知公告表';

DROP TABLE IF EXISTS sys_config;
CREATE TABLE sys_config (
  config_id         int(5)          not null auto_increment    comment '参数主键',
  config_name       varchar(100)    default ''                 comment '参数名称',
  config_key        varchar(100)    default ''                 comment '参数键名',
  config_value      varchar(500)    default ''                 comment '参数键值',
  config_type       char(1)         default 'N'                comment '系统内置（Y是 N否）',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (config_id)
) engine=innodb auto_increment=100 comment = '参数配置表';

-- 代码生成业务表
DROP TABLE IF EXISTS gen_table;
CREATE TABLE gen_table (
  table_id          bigint(20)      not null auto_increment    comment '编号',
  table_name        varchar(200)    default ''                 comment '表名称',
  table_comment     varchar(500)    default ''                 comment '表描述',
  sub_table_name    varchar(64)     default null               comment '关联子表的表名',
  sub_table_fk_name varchar(64)     default null               comment '子表关联的外键名',
  class_name        varchar(100)    default ''                 comment '实体类名称',
  tpl_category      varchar(200)    default 'crud'             comment '使用的模板（crud单表操作 tree树表操作）',
  package_name      varchar(100)                               comment '生成包路径',
  module_name       varchar(30)                                comment '生成模块名',
  business_name     varchar(30)                                comment '生成业务名',
  function_name     varchar(50)                                comment '生成功能名',
  function_author   varchar(50)                                comment '生成功能作者',
  gen_type          char(1)         default '0'                comment '生成代码方式（0zip压缩包 1自定义路径）',
  gen_path          varchar(200)    default '/'                comment '生成路径（不填默认项目路径）',
  options           varchar(1000)                              comment '其它生成选项',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  remark            varchar(500)    default null               comment '备注',
  primary key (table_id)
) engine=innodb auto_increment=1 comment = '代码生成业务表';

-- 代码生成业务表字段
DROP TABLE IF EXISTS gen_table_column;
CREATE TABLE gen_table_column (
  column_id         bigint(20)      not null auto_increment    comment '编号',
  table_id          bigint(20)                                 comment '归属表编号',
  column_name       varchar(200)                               comment '列名称',
  column_comment    varchar(500)                               comment '列描述',
  column_type       varchar(100)                               comment '列类型',
  java_type         varchar(500)                               comment 'JAVA类型',
  java_field        varchar(200)                               comment 'JAVA字段名',
  is_pk             char(1)                                    comment '是否主键（1是）',
  is_increment      char(1)                                    comment '是否自增（1是）',
  is_required       char(1)                                    comment '是否必填（1是）',
  is_insert         char(1)                                    comment '是否为插入字段（1是）',
  is_edit           char(1)                                    comment '是否编辑字段（1是）',
  is_list           char(1)                                    comment '是否列表字段（1是）',
  is_query          char(1)                                    comment '是否查询字段（1是）',
  query_type        varchar(200)    default 'EQ'               comment '查询方式（等于、不等于、大于、小于、范围）',
  html_type         varchar(200)                               comment '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  dict_type         varchar(200)    default ''                 comment '字典类型',
  sort              int                                        comment '排序',
  create_by         varchar(64)     default ''                 comment '创建者',
  create_time       datetime                                   comment '创建时间',
  update_by         varchar(64)     default ''                 comment '更新者',
  update_time       datetime                                   comment '更新时间',
  primary key (column_id)
) engine=innodb auto_increment=1 comment = '代码生成业务表字段';

-- =============================================
-- 2. 化学品基础数据表
-- =============================================

-- 化学品分类表
DROP TABLE IF EXISTS chemical_category;
CREATE TABLE chemical_category (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '分类ID',
    category_code VARCHAR(20) NOT NULL UNIQUE COMMENT '分类代码',
    category_name VARCHAR(100) NOT NULL COMMENT '分类名称',
    parent_id INT COMMENT '父分类ID',
    description TEXT COMMENT '分类描述',
    is_active TINYINT(1) DEFAULT 1 COMMENT '是否有效',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_parent_id (parent_id),
    INDEX idx_category_code (category_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='化学品分类表';

-- GHS危险性分类标准表
DROP TABLE IF EXISTS ghs_hazard_class;
CREATE TABLE ghs_hazard_class (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    class_code VARCHAR(20) NOT NULL UNIQUE COMMENT '危险类别代码',
    class_name VARCHAR(100) NOT NULL COMMENT '危险类别名称',
    category VARCHAR(50) COMMENT '危险类别',
    pictogram VARCHAR(50) COMMENT '象形图代码',
    signal_word VARCHAR(20) COMMENT '警示词',
    description TEXT COMMENT '描述',
    is_active TINYINT(1) DEFAULT 1 COMMENT '是否有效',
    INDEX idx_class_code (class_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='GHS危险性分类标准表';

-- =============================================
-- 3. MSDS核心业务表
-- =============================================

-- MSDS主表
DROP TABLE IF EXISTS msds_main;
CREATE TABLE msds_main (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'MSDS唯一标识',
    msds_code VARCHAR(50) NOT NULL UNIQUE COMMENT 'MSDS编号',
    product_name VARCHAR(255) NOT NULL COMMENT '化学品中文名',
    product_alias VARCHAR(255) COMMENT '化学品别名',
    product_english_name VARCHAR(255) COMMENT '化学品英文名',
    category_id INT COMMENT '化学品分类ID',
    company_name VARCHAR(255) NOT NULL COMMENT '企业名称',
    company_address TEXT COMMENT '企业地址',
    zip_code CHAR(10) COMMENT '邮编',
    fax_number VARCHAR(50) COMMENT '传真号码',
    contact_phone VARCHAR(50) NOT NULL COMMENT '联系电话',
    email VARCHAR(100) COMMENT '电子邮件地址',
    emergency_phone VARCHAR(50) COMMENT '企业应急电话',
    recommended_usage TEXT COMMENT '产品推荐用途',
    restricted_usage TEXT COMMENT '产品限制用途',
    version VARCHAR(20) DEFAULT '1.0' COMMENT 'MSDS版本号',
    revision_date DATE COMMENT '修订日期',
    effective_date DATE COMMENT '生效日期',
    status ENUM('draft', 'pending', 'approved', 'archived') DEFAULT 'draft' COMMENT '状态',
    approver VARCHAR(100) COMMENT '审批人',
    approval_date DATE COMMENT '审批日期',
    is_active TINYINT(1) DEFAULT 1 COMMENT '是否有效',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(100) COMMENT '创建人',
    updated_by VARCHAR(100) COMMENT '更新人',
    FOREIGN KEY (category_id) REFERENCES chemical_category(id),
    INDEX idx_msds_code (msds_code),
    INDEX idx_product_name (product_name),
    INDEX idx_company_name (company_name),
    INDEX idx_status (status),
    INDEX idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MSDS主信息表';

-- 危险性概述表
DROP TABLE IF EXISTS msds_hazard;
CREATE TABLE msds_hazard (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    emergency_overview TEXT COMMENT '紧急情况概述',
    physical_state VARCHAR(50) COMMENT '物理状态',
    odor VARCHAR(100) COMMENT '气味',
    color VARCHAR(50) COMMENT '颜色',
    warning_word ENUM('danger', 'warning') COMMENT '警示词',
    hazard_description TEXT COMMENT '危险性说明',
    prevention_measures TEXT COMMENT '预防措施',
    response_measures TEXT COMMENT '响应措施',
    storage_measures TEXT COMMENT '储存措施',
    disposal_measures TEXT COMMENT '废弃处置措施',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='危险性概述表';

-- GHS危险性分类关联表
DROP TABLE IF EXISTS msds_ghs_hazard;
CREATE TABLE msds_ghs_hazard (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    ghs_class_id INT NOT NULL COMMENT '关联GHS危险类别ID',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    FOREIGN KEY (ghs_class_id) REFERENCES ghs_hazard_class(id),
    UNIQUE KEY uk_msds_ghs (msds_id, ghs_class_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MSDS-GHS危险性分类关联表';

-- 成分组成信息表
DROP TABLE IF EXISTS msds_component;
CREATE TABLE msds_component (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    component_name VARCHAR(255) NOT NULL COMMENT '成分名称',
    component_english_name VARCHAR(255) COMMENT '成分英文名',
    component_content VARCHAR(100) COMMENT '成分含量',
    content_min DECIMAL(10,4) COMMENT '含量下限',
    content_max DECIMAL(10,4) COMMENT '含量上限',
    cas_number VARCHAR(50) COMMENT 'CAS登记号',
    ec_number VARCHAR(50) COMMENT 'EC号',
    molecular_formula VARCHAR(100) COMMENT '分子式',
    molecular_weight DECIMAL(10,2) COMMENT '分子量',
    is_hazardous TINYINT(1) DEFAULT 0 COMMENT '是否为危险成分',
    hazard_level VARCHAR(50) COMMENT '危险等级',
    component_function VARCHAR(100) COMMENT '成分功能',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    INDEX idx_msds_id (msds_id),
    INDEX idx_component_name (component_name),
    INDEX idx_cas_number (cas_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='成分组成信息表';

-- 急救措施表
DROP TABLE IF EXISTS msds_first_aid;
CREATE TABLE msds_first_aid (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    skin_contact TEXT COMMENT '皮肤接触处理措施',
    eye_contact TEXT COMMENT '眼睛接触处理措施',
    inhalation TEXT COMMENT '吸入处理措施',
    ingestion TEXT COMMENT '食入处理措施',
    general_notes TEXT COMMENT '一般注意事项',
    symptoms_effects TEXT COMMENT '可能出现的症状和健康影响',
    immediate_medical_attention TEXT COMMENT '需要立即就医的情况',
    antidote_treatment TEXT COMMENT '解毒剂及治疗方法',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='急救措施表';

-- 消防措施表
DROP TABLE IF EXISTS msds_fire_fighting;
CREATE TABLE msds_fire_fighting (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    hazard_characteristics TEXT COMMENT '危险特性',
    harmful_combustion_products TEXT COMMENT '有害燃烧产物',
    suitable_extinguishing_media TEXT COMMENT '适宜的灭火介质',
    unsuitable_extinguishing_media TEXT COMMENT '不适宜的灭火介质',
    fire_fighting_equipment TEXT COMMENT '消防设备和防护装备',
    fire_fighting_procedures TEXT COMMENT '特殊消防程序',
    flash_point VARCHAR(50) COMMENT '闪点',
    autoignition_temperature VARCHAR(50) COMMENT '自燃温度',
    flammability_limits TEXT COMMENT '燃烧性爆炸极限',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='消防措施表';

-- 泄漏应急处理表
DROP TABLE IF EXISTS msds_leak_response;
CREATE TABLE msds_leak_response (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    personal_precautions TEXT COMMENT '个人防护措施',
    environmental_precautions TEXT COMMENT '环境保护措施',
    containment_cleanup TEXT COMMENT '泄漏化学品的收容、清除方法',
    emergency_procedures TEXT COMMENT '应急处理程序',
    elimination_methods TEXT COMMENT '消除方法',
    equipment_materials TEXT COMMENT '所需设备和材料',
    prevent_secondary_hazards TEXT COMMENT '防止发生次生灾害的预防措施',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='泄漏应急处理表';

-- 操作处置与储存表
DROP TABLE IF EXISTS msds_handling_storage;
CREATE TABLE msds_handling_storage (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    handling_precautions TEXT COMMENT '操作注意事项',
    storage_precautions TEXT COMMENT '储存注意事项',
    optimal_temperature VARCHAR(50) COMMENT '最适宜储存温度',
    temperature_range VARCHAR(50) COMMENT '储存温度范围',
    humidity_requirements VARCHAR(50) COMMENT '湿度要求',
    storage_container TEXT COMMENT '储存容器要求',
    incompatible_materials TEXT COMMENT '禁配物',
    storage_area_requirements TEXT COMMENT '储存区域要求',
    shelf_life VARCHAR(50) COMMENT '保质期',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作处置与储存表';

-- 接触控制/个体防护表
DROP TABLE IF EXISTS msds_exposure_control;
CREATE TABLE msds_exposure_control (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    occupational_exposure_limit TEXT COMMENT '职业接触限值',
    china_mac VARCHAR(50) COMMENT '中国MAC值',
    usa_tlv_twa VARCHAR(50) COMMENT '美国TLV-TWA值',
    usa_tlv_stel VARCHAR(50) COMMENT '美国TLV-STEL值',
    former_soviet_mac VARCHAR(50) COMMENT '前苏联MAC值',
    tlv_tn VARCHAR(50) COMMENT 'TLV-TN值',
    tlv_wn VARCHAR(50) COMMENT 'TLV-WN值',
    monitoring_method TEXT COMMENT '监测方法',
    engineering_controls TEXT COMMENT '工程控制措施',
    respiratory_protection TEXT COMMENT '呼吸系统防护',
    eye_protection TEXT COMMENT '眼睛防护',
    body_protection TEXT COMMENT '身体防护',
    hand_protection TEXT COMMENT '手防护',
    other_protection TEXT COMMENT '其他防护要求',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='接触控制/个体防护表';

-- 理化特性表
DROP TABLE IF EXISTS msds_physical_chemical;
CREATE TABLE msds_physical_chemical (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    appearance VARCHAR(100) COMMENT '外观',
    ph_value VARCHAR(50) COMMENT 'pH值',
    melting_point VARCHAR(50) COMMENT '熔点',
    boiling_point VARCHAR(50) COMMENT '沸点',
    flash_point VARCHAR(50) COMMENT '闪点',
    evaporation_rate VARCHAR(50) COMMENT '蒸发速率',
    flammability VARCHAR(100) COMMENT '易燃性',
    explosion_limits VARCHAR(100) COMMENT '爆炸极限',
    vapor_pressure VARCHAR(50) COMMENT '蒸气压',
    vapor_density VARCHAR(50) COMMENT '蒸气密度',
    relative_density VARCHAR(50) COMMENT '相对密度',
    solubility TEXT COMMENT '溶解性',
    partition_coefficient VARCHAR(50) COMMENT '正辛醇/水分配系数',
    autoignition_temperature VARCHAR(50) COMMENT '自燃温度',
    decomposition_temperature VARCHAR(50) COMMENT '分解温度',
    viscosity VARCHAR(50) COMMENT '粘度',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='理化特性表';

-- 稳定性和反应性表
DROP TABLE IF EXISTS msds_stability_reactivity;
CREATE TABLE msds_stability_reactivity (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    stability TEXT COMMENT '稳定性',
    dangerous_reactions TEXT COMMENT '危险反应',
    conditions_to_avoid TEXT COMMENT '应避免的条件',
    incompatible_materials TEXT COMMENT '禁配物',
    hazardous_decomposition_products TEXT COMMENT '危险的分解产物',
    polymerization TEXT COMMENT '聚合危害',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='稳定性和反应性表';

-- 毒理学资料表
DROP TABLE IF EXISTS msds_toxicological;
CREATE TABLE msds_toxicological (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    acute_toxicity TEXT COMMENT '急性毒性',
    skin_corrosion_irritation TEXT COMMENT '皮肤腐蚀/刺激',
    serious_eye_damage TEXT COMMENT '严重眼损伤/眼刺激',
    respiratory_sensitization TEXT COMMENT '呼吸道或皮肤过敏',
    germ_cell_mutagenicity TEXT COMMENT '生殖细胞致突变性',
    carcinogenicity TEXT COMMENT '致癌性',
    reproductive_toxicity TEXT COMMENT '生殖毒性',
    specific_target_organ_toxicity TEXT COMMENT '特定目标器官系统毒性',
    aspiration_hazard TEXT COMMENT '吸入危害',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='毒理学资料表';

-- 生态学资料表
DROP TABLE IF EXISTS msds_ecological;
CREATE TABLE msds_ecological (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    ecological_toxicity TEXT COMMENT '生态毒性',
    biodegradability TEXT COMMENT '生物降解性',
    non_biodegradability TEXT COMMENT '非生物降解性',
    bioaccumulation TEXT COMMENT '生物富集或生物积累性',
    other_environmental_effects TEXT COMMENT '其它有害作用',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='生态学资料表';

-- 废弃处置表
DROP TABLE IF EXISTS msds_disposal;
CREATE TABLE msds_disposal (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    waste_treatment_methods TEXT COMMENT '废物处理方法',
    disposal_precautions TEXT COMMENT '处置前预处理要求',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='废弃处置表';

-- 运输信息表
DROP TABLE IF EXISTS msds_transportation;
CREATE TABLE msds_transportation (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    un_number VARCHAR(20) COMMENT 'UN编号',
    un_proper_shipping_name VARCHAR(255) COMMENT 'UN运输名称',
    transport_hazard_class VARCHAR(50) COMMENT '运输危险性类别',
    packing_group VARCHAR(20) COMMENT '包装类别',
    environmental_hazards TEXT COMMENT '环境危害',
    special_precautions TEXT COMMENT '运输注意事项',
    bulk_transport TEXT COMMENT '散装运输',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='运输信息表';

-- 法规信息表
DROP TABLE IF EXISTS msds_regulatory;
CREATE TABLE msds_regulatory (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    safety_health_environment_regulations TEXT COMMENT '安全、健康和环境法规',
    chemical_safety_assessment TEXT COMMENT '化学品安全评估',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='法规信息表';

-- 其他信息表
DROP TABLE IF EXISTS msds_other_info;
CREATE TABLE msds_other_info (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    reference_list TEXT COMMENT '参考文献',
    data_sources TEXT COMMENT '数据来源',
    form_fill_time DATE COMMENT '填表时间',
    form_fill_department VARCHAR(100) COMMENT '填表部门',
    form_fill_person VARCHAR(100) COMMENT '填表人',
    data_audit_unit VARCHAR(100) COMMENT '数据审核单位',
    data_audit_person VARCHAR(100) COMMENT '数据审核人',
    technical_review_person VARCHAR(100) COMMENT '技术审查人',
    modification_notes TEXT COMMENT '修改说明',
    training_requirements TEXT COMMENT '培训要求',
    additional_information TEXT COMMENT '其他信息',
    disclaimer TEXT COMMENT '免责声明',
    create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
    create_time DATETIME COMMENT '创建时间',
    update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time DATETIME COMMENT '更新时间',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='其他信息表';

-- =============================================
-- 4. MSDS辅助功能表
-- =============================================

-- MSDS版本历史表
DROP TABLE IF EXISTS msds_version_history;
CREATE TABLE msds_version_history (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    version VARCHAR(20) NOT NULL COMMENT '版本号',
    change_description TEXT COMMENT '变更描述',
    change_reason TEXT COMMENT '变更原因',
    changed_sections TEXT COMMENT '变更章节',
    change_date DATE COMMENT '变更日期',
    changed_by VARCHAR(100) COMMENT '变更人',
    approved_by VARCHAR(100) COMMENT '审批人',
    approval_date DATE COMMENT '审批日期',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    INDEX idx_msds_id (msds_id),
    INDEX idx_version (version),
    INDEX idx_change_date (change_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MSDS版本历史表';

-- MSDS审批流程表
DROP TABLE IF EXISTS msds_approval_workflow;
CREATE TABLE msds_approval_workflow (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    step_no INT NOT NULL COMMENT '审批步骤序号',
    step_name VARCHAR(100) NOT NULL COMMENT '审批步骤名称',
    approver VARCHAR(100) COMMENT '审批人',
    approval_status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending' COMMENT '审批状态',
    approval_date DATE COMMENT '审批日期',
    approval_comments TEXT COMMENT '审批意见',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    INDEX idx_msds_id (msds_id),
    INDEX idx_approval_status (approval_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MSDS审批流程表';

-- =============================================
-- 5. Quartz定时任务表
-- =============================================

DROP TABLE IF EXISTS QRTZ_FIRED_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_PAUSED_TRIGGER_GRPS;
DROP TABLE IF EXISTS QRTZ_SCHEDULER_STATE;
DROP TABLE IF EXISTS QRTZ_LOCKS;
DROP TABLE IF EXISTS QRTZ_SIMPLE_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_SIMPROP_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_CRON_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_BLOB_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_JOB_DETAILS;
DROP TABLE IF EXISTS QRTZ_CALENDARS;

-- 存储每一个已配置的 jobDetail 的详细信息
CREATE TABLE QRTZ_JOB_DETAILS (
    sched_name           varchar(120)    not null            comment '调度名称',
    job_name             varchar(200)    not null            comment '任务名称',
    job_group            varchar(200)    not null            comment '任务组名',
    description          varchar(250)    null                comment '相关介绍',
    job_class_name       varchar(250)    not null            comment '执行任务类名称',
    is_durable           varchar(1)      not null            comment '是否持久化',
    is_nonconcurrent     varchar(1)      not null            comment '是否并发',
    is_update_data       varchar(1)      not null            comment '是否更新数据',
    requests_recovery    varchar(1)      not null            comment '是否接受恢复执行',
    job_data             blob            null                comment '存放持久化job对象',
    primary key (sched_name, job_name, job_group)
) engine=innodb comment = '任务详细信息表';

-- 存储已配置的 Trigger 的信息
CREATE TABLE QRTZ_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_name         varchar(200)    not null            comment '触发器的名字',
    trigger_group        varchar(200)    not null            comment '触发器所属组的名字',
    job_name             varchar(200)    not null            comment 'qrtz_job_details表job_name的外键',
    job_group            varchar(200)    not null            comment 'qrtz_job_details表job_group的外键',
    description          varchar(250)    null                comment '相关介绍',
    next_fire_time       bigint(13)      null                comment '上一次触发时间（毫秒）',
    prev_fire_time       bigint(13)      null                comment '下一次触发时间（默认为-1表示不触发）',
    priority             integer         null                comment '优先级',
    trigger_state        varchar(16)     not null            comment '触发器状态',
    trigger_type         varchar(8)      not null            comment '触发器的类型',
    start_time           bigint(13)      not null            comment '开始时间',
    end_time             bigint(13)      null                comment '结束时间',
    calendar_name        varchar(200)    null                comment '日程表名称',
    misfire_instr        smallint(2)     null                comment '补偿执行的策略',
    job_data             blob            null                comment '存放持久化job对象',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, job_name, job_group) references QRTZ_JOB_DETAILS(sched_name, job_name, job_group)
) engine=innodb comment = '触发器详细信息表';

-- 存储简单的 Trigger，包括重复次数，间隔，以及已触的次数
CREATE TABLE QRTZ_SIMPLE_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_name         varchar(200)    not null            comment '触发器名称',
    trigger_group        varchar(200)    not null            comment '触发器组名',
    repeat_count         bigint(7)       not null            comment '重复的次数统计',
    repeat_interval      bigint(12)      not null            comment '重复的间隔时间',
    times_triggered      bigint(10)      not null            comment '已经触发的次数',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) engine=innodb comment = '简单触发器的信息表';

-- 存储 Cron Trigger，包括 Cron 表达式和时区信息
CREATE TABLE QRTZ_CRON_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_name         varchar(200)    not null            comment '触发器名称',
    trigger_group        varchar(200)    not null            comment '触发器组名',
    cron_expression      varchar(200)    not null            comment 'cron表达式',
    time_zone_id         varchar(80)                         comment '时区',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) engine=innodb comment = 'Cron类型的触发器表';

-- Trigger 作为 Blob 类型存储(用于 Quartz 用户用 JDBC 创建他们自己定制的 Trigger 类型，JobStore 并不知道如何存储实例的时候)
CREATE TABLE QRTZ_BLOB_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_name         varchar(200)    not null            comment '触发器名称',
    trigger_group        varchar(200)    not null            comment '触发器组名',
    blob_data            blob            null                comment '存放持久化Trigger对象',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) engine=innodb comment = 'Blob类型的触发器表';

-- 以 Blob 类型存储存放日历信息， quartz可配置一个日历来指定一个时间范围
CREATE TABLE QRTZ_CALENDARS (
    sched_name           varchar(120)    not null            comment '调度名称',
    calendar_name        varchar(200)    not null            comment '日历名称',
    calendar             blob            not null            comment '存放持久化calendar对象',
    primary key (sched_name, calendar_name)
) engine=innodb comment = '日历信息表';

-- 存储已暂停的 Trigger 组的信息
CREATE TABLE QRTZ_PAUSED_TRIGGER_GRPS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_group        varchar(200)    not null            comment '触发器组名',
    primary key (sched_name, trigger_group)
) engine=innodb comment = '暂停的触发器表';

-- 存储与已触发的 Trigger 相关的状态信息，以及相联Job的执行信息
CREATE TABLE QRTZ_FIRED_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    entry_id             varchar(95)     not null            comment '调度器实例id',
    trigger_name         varchar(200)    not null            comment '触发器名称',
    trigger_group        varchar(200)    not null            comment '触发器组名',
    instance_name        varchar(200)    not null            comment '调度器实例名',
    fired_time           bigint(13)      not null            comment '触发的时间',
    sched_time           bigint(13)      not null            comment '定时器制定的时间',
    priority             integer         not null            comment '优先级',
    state                varchar(16)     not null            comment '状态',
    job_name             varchar(200)    null                comment '任务名称',
    job_group            varchar(200)    null                comment '任务组名',
    is_nonconcurrent     varchar(1)      null                comment '是否并发',
    requests_recovery    varchar(1)      null                comment '是否接受恢复执行',
    primary key (sched_name, entry_id)
) engine=innodb comment = '已触发的触发器表';

-- 存储少量的有关 Scheduler 的状态信息，假如是用于集群中，可以看到其他的 Scheduler 实例
CREATE TABLE QRTZ_SCHEDULER_STATE (
    sched_name           varchar(120)    not null            comment '调度名称',
    instance_name        varchar(200)    not null            comment '实例名称',
    last_checkin_time    bigint(13)      not null            comment '上次检查时间',
    checkin_interval     bigint(13)      not null            comment '检查间隔时间',
    primary key (sched_name, instance_name)
) engine=innodb comment = '调度器状态表';

-- 存储程序的悲观锁的信息(假如使用了悲观锁)
CREATE TABLE QRTZ_LOCKS (
    sched_name           varchar(120)    not null            comment '调度名称',
    lock_name            varchar(40)     not null            comment '悲观锁名称',
    primary key (sched_name, lock_name)
) engine=innodb comment = '存储的悲观锁信息表';

-- 同一trigger同一时间只能有一个实例运行，如果使用了@DisallowConcurrentExecution
CREATE TABLE QRTZ_SIMPROP_TRIGGERS (
    sched_name           varchar(120)    not null            comment '调度名称',
    trigger_name         varchar(200)    not null            comment '触发器名称',
    trigger_group        varchar(200)    not null            comment '触发器组名',
    str_prop_1           varchar(512)    null                comment 'String类型的trigger的第一个参数',
    str_prop_2           varchar(512)    null                comment 'String类型的trigger的第二个参数',
    str_prop_3           varchar(512)    null                comment 'String类型的trigger的第三个参数',
    int_prop_1           int             null                comment 'int类型的trigger的第一个参数',
    int_prop_2           int             null                comment 'int类型的trigger的第二个参数',
    long_prop_1          bigint          null                comment 'long类型的trigger的第一个参数',
    long_prop_2          bigint          null                comment 'long类型的trigger的第二个参数',
    dec_prop_1           numeric(13,4)   null                comment 'decimal类型的trigger的第一个参数',
    dec_prop_2           numeric(13,4)   null                comment 'decimal类型的trigger的第二个参数',
    bool_prop_1          varchar(1)      null                comment 'Boolean类型的trigger的第一个参数',
    bool_prop_2          varchar(1)      null                comment 'Boolean类型的trigger的第二个参数',
    primary key (sched_name, trigger_name, trigger_group),
    foreign key (sched_name, trigger_name, trigger_group) references QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
) engine=innodb comment = '同步机制的行锁表';

-- =============================================
-- 6. 初始化基础数据
-- =============================================

-- 初始化部门数据
INSERT INTO sys_dept VALUES(100,  0,   '0',          'MSDS实验室',   0, '管理员', '15888888888', 'admin@msds.com', '0', '0', 'admin', NOW(), '', null);
INSERT INTO sys_dept VALUES(101,  100, '0,100',      '化学实验室', 1, '实验室主任', '15888888888', 'lab@msds.com', '0', '0', 'admin', NOW(), '', null);
INSERT INTO sys_dept VALUES(102,  100, '0,100',      '安全管理部', 2, '安全主管', '15888888888', 'safety@msds.com', '0', '0', 'admin', NOW(), '', null);
INSERT INTO sys_dept VALUES(103,  101, '0,100,101',  '有机化学组',   1, '组长', '15888888888', 'organic@msds.com', '0', '0', 'admin', NOW(), '', null);
INSERT INTO sys_dept VALUES(104,  101, '0,100,101',  '无机化学组',   2, '组长', '15888888888', 'inorganic@msds.com', '0', '0', 'admin', NOW(), '', null);
INSERT INTO sys_dept VALUES(105,  102, '0,100,102',  '危化品管理组',   1, '组长', '15888888888', 'hazmat@msds.com', '0', '0', 'admin', NOW(), '', null);

-- 初始化用户数据
INSERT INTO sys_user VALUES(1,  103, 'admin', 'MSDS管理员', '00', 'admin@msds.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', NOW(), 'admin', NOW(), '', null, '系统管理员');
INSERT INTO sys_user VALUES(2,  105, 'msds_user',    'MSDS用户', '00', 'user@msds.com',  '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', NOW(), 'admin', NOW(), '', null, 'MSDS普通用户');

-- 初始化岗位数据
INSERT INTO sys_post VALUES(1, 'ceo',  '董事长',    1, '0', 'admin', NOW(), '', null, '');
INSERT INTO sys_post VALUES(2, 'se',   '项目经理',  2, '0', 'admin', NOW(), '', null, '');
INSERT INTO sys_post VALUES(3, 'hr',   '人力资源',  3, '0', 'admin', NOW(), '', null, '');
INSERT INTO sys_post VALUES(4, 'user', '普通员工',  4, '0', 'admin', NOW(), '', null, '');
INSERT INTO sys_post VALUES(5, 'lab_manager', '实验室主任', 5, '0', 'admin', NOW(), '', null, '');
INSERT INTO sys_post VALUES(6, 'safety_officer', '安全员', 6, '0', 'admin', NOW(), '', null, '');
INSERT INTO sys_post VALUES(7, 'chemist', '化学师', 7, '0', 'admin', NOW(), '', null, '');

-- 初始化角色数据
INSERT INTO sys_role VALUES('1', '超级管理员',  'admin',  1, 1, 1, 1, '0', '0', 'admin', NOW(), '', null, '超级管理员');
INSERT INTO sys_role VALUES('2', 'MSDS管理员', 'msds_admin', 2, 2, 1, 1, '0', '0', 'admin', NOW(), '', null, 'MSDS管理员');
INSERT INTO sys_role VALUES('3', 'MSDS用户', 'msds_user', 3, 2, 1, 1, '0', '0', 'admin', NOW(), '', null, 'MSDS普通用户');

-- 初始化菜单数据
INSERT INTO sys_menu VALUES('1', '系统管理', '0', '1', 'system',           null, '', 1, 0, 'M', '0', '0', '', 'system',   'admin', NOW(), '', null, '系统管理目录');
INSERT INTO sys_menu VALUES('2', '系统监控', '0', '2', 'monitor',          null, '', 1, 0, 'M', '0', '0', '', 'monitor',  'admin', NOW(), '', null, '系统监控目录');
INSERT INTO sys_menu VALUES('3', '系统工具', '0', '3', 'tool',             null, '', 1, 0, 'M', '0', '0', '', 'tool',     'admin', NOW(), '', null, '系统工具目录');
INSERT INTO sys_menu VALUES('4', 'MSDS管理', '0', '4', 'msds',             null, '', 1, 0, 'M', '0', '0', '', 'msds',     'admin', NOW(), '', null, 'MSDS管理目录');

-- MSDS管理子菜单
INSERT INTO sys_menu VALUES('1001', 'MSDS信息管理', '4', '1', 'msds/main', 'msds/main/index', '', 1, 0, 'C', '0', '0', 'msds:main:list', 'msds', 'admin', NOW(), '', null, 'MSDS信息管理菜单');
INSERT INTO sys_menu VALUES('1002', '化学品分类', '4', '2', 'msds/category', 'msds/category/index', '', 1, 0, 'C', '0', '0', 'msds:category:list', 'category', 'admin', NOW(), '', null, '化学品分类菜单');
INSERT INTO sys_menu VALUES('1003', 'GHS危险分类', '4', '3', 'msds/ghs', 'msds/ghs/index', '', 1, 0, 'C', '0', '0', 'msds:ghs:list', 'ghs', 'admin', NOW(), '', null, 'GHS危险分类菜单');
INSERT INTO sys_menu VALUES('1004', 'MSDS审批', '4', '4', 'msds/approval', 'msds/approval/index', '', 1, 0, 'C', '0', '0', 'msds:approval:list', 'approval', 'admin', NOW(), '', null, 'MSDS审批菜单');

-- MSDS信息管理按钮
INSERT INTO sys_menu VALUES('1011', 'MSDS查询', '1001', '1',  '', '', '', 1, 0, 'F', '0', '0', 'msds:main:query',        '#', 'admin', NOW(), '', null, '');
INSERT INTO sys_menu VALUES('1012', 'MSDS新增', '1001', '2',  '', '', '', 1, 0, 'F', '0', '0', 'msds:main:add',          '#', 'admin', NOW(), '', null, '');
INSERT INTO sys_menu VALUES('1013', 'MSDS修改', '1001', '3',  '', '', '', 1, 0, 'F', '0', '0', 'msds:main:edit',         '#', 'admin', NOW(), '', null, '');
INSERT INTO sys_menu VALUES('1014', 'MSDS删除', '1001', '4',  '', '', '', 1, 0, 'F', '0', '0', 'msds:main:remove',       '#', 'admin', NOW(), '', null, '');
INSERT INTO sys_menu VALUES('1015', 'MSDS导出', '1001', '5',  '', '', '', 1, 0, 'F', '0', '0', 'msds:main:export',       '#', 'admin', NOW(), '', null, '');
INSERT INTO sys_menu VALUES('1016', 'MSDS导入', '1001', '6',  '', '', '', 1, 0, 'F', '0', '0', 'msds:main:import',       '#', 'admin', NOW(), '', null, '');

-- 用户和角色关联
INSERT INTO sys_user_role VALUES ('1', '1');
INSERT INTO sys_user_role VALUES ('2', '3');

-- 角色和菜单关联
INSERT INTO sys_role_menu VALUES ('1', '1');
INSERT INTO sys_role_menu VALUES ('1', '2');
INSERT INTO sys_role_menu VALUES ('1', '3');
INSERT INTO sys_role_menu VALUES ('1', '4');
INSERT INTO sys_role_menu VALUES ('1', '1001');
INSERT INTO sys_role_menu VALUES ('1', '1002');
INSERT INTO sys_role_menu VALUES ('1', '1003');
INSERT INTO sys_role_menu VALUES ('1', '1004');
INSERT INTO sys_role_menu VALUES ('1', '1011');
INSERT INTO sys_role_menu VALUES ('1', '1012');
INSERT INTO sys_role_menu VALUES ('1', '1013');
INSERT INTO sys_role_menu VALUES ('1', '1014');
INSERT INTO sys_role_menu VALUES ('1', '1015');
INSERT INTO sys_role_menu VALUES ('1', '1016');

INSERT INTO sys_role_menu VALUES ('2', '4');
INSERT INTO sys_role_menu VALUES ('2', '1001');
INSERT INTO sys_role_menu VALUES ('2', '1002');
INSERT INTO sys_role_menu VALUES ('2', '1003');
INSERT INTO sys_role_menu VALUES ('2', '1004');
INSERT INTO sys_role_menu VALUES ('2', '1011');
INSERT INTO sys_role_menu VALUES ('2', '1012');
INSERT INTO sys_role_menu VALUES ('2', '1013');
INSERT INTO sys_role_menu VALUES ('2', '1014');
INSERT INTO sys_role_menu VALUES ('2', '1015');
INSERT INTO sys_role_menu VALUES ('2', '1016');

INSERT INTO sys_role_menu VALUES ('3', '4');
INSERT INTO sys_role_menu VALUES ('3', '1001');
INSERT INTO sys_role_menu VALUES ('3', '1002');
INSERT INTO sys_role_menu VALUES ('3', '1003');
INSERT INTO sys_role_menu VALUES ('3', '1011');

-- 用户和岗位关联
INSERT INTO sys_user_post VALUES ('1', '1');
INSERT INTO sys_user_post VALUES ('2', '7');

-- 初始化化学品分类数据
INSERT INTO chemical_category (category_code, category_name, parent_id, description) VALUES
('CHEM_001', '有机化学品', NULL, '有机化学品大类'),
('CHEM_002', '无机化学品', NULL, '无机化学品大类'),
('CHEM_003', '危险化学品', NULL, '危险化学品大类'),
('CHEM_004', '易燃液体', 3, '易燃液体类危险化学品'),
('CHEM_005', '腐蚀性物质', 3, '腐蚀性物质类危险化学品'),
('CHEM_006', '有毒物质', 3, '有毒物质类危险化学品'),
('CHEM_007', '氧化性物质', 3, '氧化性物质类危险化学品'),
('CHEM_008', '爆炸性物质', 3, '爆炸性物质类危险化学品');

-- 初始化GHS危险性分类数据
INSERT INTO ghs_hazard_class (class_code, class_name, category, pictogram, signal_word, description) VALUES
('GHS01', '爆炸物', '物理危险', 'GHS01', 'DANGER', '在火焰影响下能够爆炸的物质和混合物'),
('GHS02', '易燃气体', '物理危险', 'GHS02', 'DANGER', '在常温常压下为气态的易燃物质'),
('GHS03', '氧化性气体', '物理危险', 'GHS03', 'DANGER', '通过提供氧气能够引起或促使其他物质燃烧的气体'),
('GHS04', '加压气体', '物理危险', 'GHS04', 'WARNING', '装在压力容器中的气体'),
('GHS05', '易燃液体', '物理危险', 'GHS02', 'DANGER', '闪点不高于93℃的液体'),
('GHS06', '易燃固体', '物理危险', 'GHS02', 'DANGER', '容易燃烧的固体'),
('GHS07', '自反应物质', '物理危险', 'GHS02', 'DANGER', '热不稳定液体或固体'),
('GHS08', '自燃液体', '物理危险', 'GHS02', 'DANGER', '即使在小量情况下也能在与空气接触后5分钟之内引燃的液体'),
('GHS09', '自燃固体', '物理危险', 'GHS02', 'DANGER', '即使在小量情况下也能在与空气接触后5分钟之内引燃的固体'),
('GHS10', '自热物质', '物理危险', 'GHS02', 'DANGER', '除自燃液体或自燃固体外，与空气接触无需外部能源即能自热的液体或固体'),
('GHS11', '遇水放出易燃气体的物质', '物理危险', 'GHS02', 'DANGER', '与水相互作用能够放出易燃气体的固体或液体'),
('GHS12', '氧化性液体', '物理危险', 'GHS03', 'DANGER', '本身未必燃烧，但通常因放出氧气可能引起或促使其他物质燃烧的液体'),
('GHS13', '氧化性固体', '物理危险', 'GHS03', 'DANGER', '本身未必燃烧，但通常因放出氧气可能引起或促使其他物质燃烧的固体'),
('GHS14', '有机过氧化物', '物理危险', 'GHS02', 'DANGER', '含有二价-O-O-结构的有机物质'),
('GHS15', '金属腐蚀物', '物理危险', 'GHS05', 'WARNING', '通过化学作用对金属造成实质损害或甚至破坏金属的物质'),
('GHS16', '急性毒性', '健康危险', 'GHS06', 'DANGER', '能够在相对较短的时间内少量一次或多次接触后引起死亡或明显毒性效应的物质'),
('GHS17', '皮肤腐蚀/刺激', '健康危险', 'GHS05', 'DANGER', '对皮肤组织产生不可逆损害的物质'),
('GHS18', '严重眼损伤/眼刺激', '健康危险', 'GHS05', 'DANGER', '对眼睛前表面或眼睑产生组织损害的物质'),
('GHS19', '呼吸道或皮肤过敏', '健康危险', 'GHS07', 'WARNING', '导致呼吸道过敏或皮肤过敏反应的物质'),
('GHS20', '生殖细胞致突变性', '健康危险', 'GHS08', 'DANGER', '可能引起人类生殖细胞遗传性损害的物质'),
('GHS21', '致癌性', '健康危险', 'GHS08', 'DANGER', '引起癌症或增加癌症发生率的物质'),
('GHS22', '生殖毒性', '健康危险', 'GHS08', 'DANGER', '对成人的性功能和生育能力或对后代的发育产生不良影响的物质'),
('GHS23', '特定目标器官毒性-一次接触', '健康危险', 'GHS07', 'WARNING', '一次接触后对特定目标器官产生毒性的物质'),
('GHS24', '特定目标器官毒性-反复接触', '健康危险', 'GHS08', 'DANGER', '反复接触后对特定目标器官产生毒性的物质'),
('GHS25', '吸入危险', '健康危险', 'GHS08', 'DANGER', '可能吸入并阻塞呼吸道的液体或固体'),
('GHS26', '危害水生环境', '环境危险', 'GHS09', 'WARNING', '对水生生物有害的物质');

-- 初始化系统通知
INSERT INTO sys_notice VALUES('1', 'MSDS系统上线通知', '2', 0x3C703EE7B3BBE7BB9FE7AEA1E79086E59198E5B7B2E4B88AE7BABFEFBC8CE8AFB7E5908CE4BA8BE4BDBFE794A8EFBC813C2F703E, '0', 'admin', NOW(), '', null, 'MSDS实验室管理系统正式上线');
INSERT INTO sys_notice VALUES('2', '系统维护通知', '1', 0x3C703EE7B3BBE7BB9FE5B086E4BA8EE4BB8AE697A5E6999AE4B88AE7BBB4E68AA4EFBC8CE8AFB7E5A4A7E5AEB6E79FA5E6999EEFBC813C2F703E, '0', 'admin', NOW(), '', null, '系统维护通知');

INSERT INTO sys_config VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', NOW(), '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO sys_config VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', NOW(), '', NULL, '初始化密码 123456');
INSERT INTO sys_config VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', NOW(), '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO sys_config VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', NOW(), '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO sys_config VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', NOW(), '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO sys_config VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', NOW(), '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');

-- 初始化定时任务
INSERT INTO sys_job VALUES(1, 'MSDS数据同步', 'DEFAULT', 'msdsTask.syncData', '0 0 1 * * ?', '3', '1', '1', 'admin', NOW(), '', null, 'MSDS数据同步任务');
INSERT INTO sys_job VALUES(2, '系统日志清理', 'DEFAULT', 'logTask.cleanLogs', '0 0 2 * * ?', '3', '1', '1', 'admin', NOW(), '', null, '系统日志清理任务');

-- =============================================
-- 7. 创建索引和约束
-- =============================================

-- MSDS主表索引
CREATE INDEX idx_msds_main_product_name ON msds_main(product_name);
CREATE INDEX idx_msds_main_company_name ON msds_main(company_name);
CREATE INDEX idx_msds_main_status ON msds_main(status);
CREATE INDEX idx_msds_main_create_time ON msds_main(create_time);
CREATE INDEX idx_msds_main_category_id ON msds_main(category_id);

-- 成分表索引
CREATE INDEX idx_msds_component_msds_id ON msds_component(msds_id);
CREATE INDEX idx_msds_component_name ON msds_component(component_name);
CREATE INDEX idx_msds_component_cas ON msds_component(cas_number);

-- 版本历史表索引
CREATE INDEX idx_msds_version_msds_id ON msds_version_history(msds_id);
CREATE INDEX idx_msds_version_date ON msds_version_history(change_date);

-- 审批流程表索引
CREATE INDEX idx_msds_approval_msds_id ON msds_approval_workflow(msds_id);
CREATE INDEX idx_msds_approval_status ON msds_approval_workflow(approval_status);

-- =============================================
-- 8. 创建视图
-- =============================================

-- MSDS完整信息视图
CREATE VIEW v_msds_complete AS
SELECT 
    m.id,
    m.msds_code,
    m.product_name,
    m.product_alias,
    m.product_english_name,
    c.category_name,
    m.company_name,
    m.contact_phone,
    m.email,
    m.version,
    m.status,
    m.create_time,
    m.update_time,
    COUNT(DISTINCT comp.id) as component_count,
    COUNT(DISTINCT ghs.id) as ghs_hazard_count
FROM msds_main m
LEFT JOIN chemical_category c ON m.category_id = c.id
LEFT JOIN msds_component comp ON m.id = comp.msds_id
LEFT JOIN msds_ghs_hazard ghs ON m.id = ghs.msds_id
WHERE m.is_active = 1
GROUP BY m.id;

-- MSDS审批状态视图
CREATE VIEW v_msds_approval_status AS
SELECT 
    m.id,
    m.msds_code,
    m.product_name,
    m.status,
    aw.step_name,
    aw.approver,
    aw.approval_status,
    aw.approval_date,
    aw.approval_comments
FROM msds_main m
LEFT JOIN msds_approval_workflow aw ON m.id = aw.msds_id
WHERE m.is_active = 1;

-- =============================================
-- 9. 创建存储过程
-- =============================================

DELIMITER $$

-- 创建MSDS编号生成存储过程
CREATE PROCEDURE GenerateMsdsCode(
    IN p_category_id INT,
    OUT p_msds_code VARCHAR(50)
)
BEGIN
    DECLARE v_category_code VARCHAR(20);
    DECLARE v_sequence INT DEFAULT 1;
    DECLARE v_year VARCHAR(4);
    
    -- 获取当前年份
    SET v_year = YEAR(CURDATE());
    
    -- 获取分类代码
    SELECT category_code INTO v_category_code 
    FROM chemical_category 
    WHERE id = p_category_id;
    
    -- 获取当年该分类的最大序号
    SELECT IFNULL(MAX(CAST(SUBSTRING(msds_code, -4) AS UNSIGNED)), 0) + 1 
    INTO v_sequence
    FROM msds_main 
    WHERE msds_code LIKE CONCAT(v_category_code, '-', v_year, '-%');
    
    -- 生成MSDS编号：分类代码-年份-4位序号
    SET p_msds_code = CONCAT(v_category_code, '-', v_year, '-', LPAD(v_sequence, 4, '0'));
END$$

-- 创建MSDS状态更新存储过程
CREATE PROCEDURE UpdateMsdsStatus(
    IN p_msds_id BIGINT,
    IN p_new_status VARCHAR(20),
    IN p_operator VARCHAR(100)
)
BEGIN
    DECLARE v_old_status VARCHAR(20);
    
    -- 获取当前状态
    SELECT status INTO v_old_status FROM msds_main WHERE id = p_msds_id;
    
    -- 更新状态
    UPDATE msds_main 
    SET status = p_new_status, 
        updated_by = p_operator, 
        update_time = NOW()
    WHERE id = p_msds_id;
    
    -- 记录状态变更历史
    INSERT INTO msds_version_history (
        msds_id, 
        version, 
        change_description, 
        change_reason, 
        changed_sections, 
        change_date, 
        changed_by
    ) VALUES (
        p_msds_id,
        (SELECT version FROM msds_main WHERE id = p_msds_id),
        CONCAT('状态从 ', v_old_status, ' 变更为 ', p_new_status),
        '状态更新',
        '状态',
        CURDATE(),
        p_operator
    );
END$$

DELIMITER ;

-- =============================================
-- 10. 创建触发器
-- =============================================

DELIMITER $$

-- MSDS主表更新时间触发器
CREATE TRIGGER tr_msds_main_update 
BEFORE UPDATE ON msds_main
FOR EACH ROW
BEGIN
    SET NEW.update_time = NOW();
END$$

-- MSDS组件变更记录触发器
CREATE TRIGGER tr_msds_component_change
AFTER INSERT ON msds_component
FOR EACH ROW
BEGIN
    INSERT INTO msds_version_history (
        msds_id, 
        version, 
        change_description, 
        change_reason, 
        changed_sections, 
        change_date, 
        changed_by
    ) VALUES (
        NEW.msds_id,
        (SELECT version FROM msds_main WHERE id = NEW.msds_id),
        CONCAT('新增成分：', NEW.component_name),
        '成分信息更新',
        '成分组成信息',
        CURDATE(),
        USER()
    );
END$$

DELIMITER ;

-- =============================================
-- 11. 数据验证和完整性检查
-- =============================================

-- 验证数据库创建
SELECT 'Database msds_dev created successfully' as status;

-- 验证表创建
SELECT COUNT(*) as table_count FROM information_schema.tables 
WHERE table_schema = 'msds_dev';

-- 验证基础数据
SELECT 'Chemical categories:', COUNT(*) FROM chemical_category;
SELECT 'GHS hazard classes:', COUNT(*) FROM ghs_hazard_class;
SELECT 'System users:', COUNT(*) FROM sys_user;
SELECT 'System roles:', COUNT(*) FROM sys_role;
SELECT 'System menus:', COUNT(*) FROM sys_menu;

-- 恢复SQL模式
SET SESSION sql_mode = @old_sql_mode;

-- =============================================
-- 12. 使用说明
-- =============================================

/*
数据库使用说明：

1. 连接信息：
   - 数据库名：msds_dev
   - 字符集：utf8mb4
   - 排序规则：utf8mb4_unicode_ci

2. 默认用户：
   - 管理员：admin / admin123
   - 普通用户：msds_user / admin123

3. 主要功能表：
   - msds_main：MSDS主信息表
   - msds_*：MSDS各章节详细信息表
   - chemical_category：化学品分类
   - ghs_hazard_class：GHS危险分类

4. 系统表：
   - sys_*：RuoYi框架系统表
   - QRTZ_*：Quartz定时任务表

5. 扩展功能：
   - 视图：v_msds_complete, v_msds_approval_status
   - 存储过程：GenerateMsdsCode, UpdateMsdsStatus
   - 触发器：自动更新时间、变更记录

6. 注意事项：
   - 所有MSDS相关表都有外键约束
   - 支持软删除（is_active字段）
   - 完整的审计日志功能
   - 支持版本控制和审批流程
*/

-- 数据库初始化完成
SELECT 'MSDS Database Initialization Completed Successfully!' as message;
