-- =============================================
-- 为MSDS业务表添加RuoYi标准审计字段
-- =============================================

USE msds_dev;

-- 1. msds_hazard
ALTER TABLE msds_hazard 
ADD COLUMN create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN update_time DATETIME NULL COMMENT '更新时间';

-- 2. msds_component
ALTER TABLE msds_component 
ADD COLUMN create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN update_time DATETIME NULL COMMENT '更新时间';

-- 3. msds_first_aid
ALTER TABLE msds_first_aid 
ADD COLUMN create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN update_time DATETIME NULL COMMENT '更新时间';

-- 4. msds_fire_fighting
ALTER TABLE msds_fire_fighting 
ADD COLUMN create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN update_time DATETIME NULL COMMENT '更新时间';

-- 5. msds_leak_response
ALTER TABLE msds_leak_response 
ADD COLUMN create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN update_time DATETIME NULL COMMENT '更新时间';

-- 6. msds_handling_storage
ALTER TABLE msds_handling_storage 
ADD COLUMN create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN update_time DATETIME NULL COMMENT '更新时间';

-- 7. msds_exposure_control
ALTER TABLE msds_exposure_control 
ADD COLUMN create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN update_time DATETIME NULL COMMENT '更新时间';

-- 8. msds_physical_chemical
ALTER TABLE msds_physical_chemical 
ADD COLUMN create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN update_time DATETIME NULL COMMENT '更新时间';

-- 9. msds_stability_reactivity
ALTER TABLE msds_stability_reactivity 
ADD COLUMN create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN update_time DATETIME NULL COMMENT '更新时间';

-- 10. msds_toxicological
ALTER TABLE msds_toxicological 
ADD COLUMN create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN update_time DATETIME NULL COMMENT '更新时间';

-- 11. msds_ecological
ALTER TABLE msds_ecological 
ADD COLUMN create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN update_time DATETIME NULL COMMENT '更新时间';

-- 12. msds_disposal
ALTER TABLE msds_disposal 
ADD COLUMN create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN update_time DATETIME NULL COMMENT '更新时间';

-- 13. msds_transportation
ALTER TABLE msds_transportation 
ADD COLUMN create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN update_time DATETIME NULL COMMENT '更新时间';

-- 14. msds_regulatory
ALTER TABLE msds_regulatory 
ADD COLUMN create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN update_time DATETIME NULL COMMENT '更新时间';

-- 15. msds_other_info
CREATE TABLE IF NOT EXISTS msds_other_info (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    msds_id BIGINT NOT NULL COMMENT '关联MSDS主表ID',
    `references` TEXT COMMENT '参考文献',
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
    create_time DATETIME NULL COMMENT '创建时间',
    update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time DATETIME NULL COMMENT '更新时间',
    FOREIGN KEY (msds_id) REFERENCES msds_main(id) ON DELETE CASCADE,
    UNIQUE KEY uk_msds_id (msds_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='其他信息表';

