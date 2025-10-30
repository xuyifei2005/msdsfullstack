-- =============================================
-- 为MSDS业务表添加RuoYi标准审计字段
-- 执行说明：在MySQL数据库中执行此脚本
-- =============================================

USE msds_dev;

-- 1. 为msds_hazard表添加审计字段
ALTER TABLE msds_hazard 
ADD COLUMN IF NOT EXISTS create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN IF NOT EXISTS create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN IF NOT EXISTS update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN IF NOT EXISTS update_time DATETIME NULL COMMENT '更新时间';

-- 2. 为msds_component表添加审计字段
ALTER TABLE msds_component 
ADD COLUMN IF NOT EXISTS create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN IF NOT EXISTS create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN IF NOT EXISTS update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN IF NOT EXISTS update_time DATETIME NULL COMMENT '更新时间';

-- 3. 为msds_first_aid表添加审计字段
ALTER TABLE msds_first_aid 
ADD COLUMN IF NOT EXISTS create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN IF NOT EXISTS create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN IF NOT EXISTS update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN IF NOT EXISTS update_time DATETIME NULL COMMENT '更新时间';

-- 4. 为msds_fire_fighting表添加审计字段
ALTER TABLE msds_fire_fighting 
ADD COLUMN IF NOT EXISTS create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN IF NOT EXISTS create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN IF NOT EXISTS update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN IF NOT EXISTS update_time DATETIME NULL COMMENT '更新时间';

-- 5. 为msds_leak_response表添加审计字段
ALTER TABLE msds_leak_response 
ADD COLUMN IF NOT EXISTS create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN IF NOT EXISTS create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN IF NOT EXISTS update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN IF NOT EXISTS update_time DATETIME NULL COMMENT '更新时间';

-- 6. 为msds_handling_storage表添加审计字段
ALTER TABLE msds_handling_storage 
ADD COLUMN IF NOT EXISTS create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN IF NOT EXISTS create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN IF NOT EXISTS update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN IF NOT EXISTS update_time DATETIME NULL COMMENT '更新时间';

-- 7. 为msds_exposure_control表添加审计字段
ALTER TABLE msds_exposure_control 
ADD COLUMN IF NOT EXISTS create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN IF NOT EXISTS create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN IF NOT EXISTS update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN IF NOT EXISTS update_time DATETIME NULL COMMENT '更新时间';

-- 8. 为msds_physical_chemical表添加审计字段
ALTER TABLE msds_physical_chemical 
ADD COLUMN IF NOT EXISTS create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN IF NOT EXISTS create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN IF NOT EXISTS update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN IF NOT EXISTS update_time DATETIME NULL COMMENT '更新时间';

-- 9. 为msds_stability_reactivity表添加审计字段
ALTER TABLE msds_stability_reactivity 
ADD COLUMN IF NOT EXISTS create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN IF NOT EXISTS create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN IF NOT EXISTS update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN IF NOT EXISTS update_time DATETIME NULL COMMENT '更新时间';

-- 10. 为msds_toxicological表添加审计字段
ALTER TABLE msds_toxicological 
ADD COLUMN IF NOT EXISTS create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN IF NOT EXISTS create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN IF NOT EXISTS update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN IF NOT EXISTS update_time DATETIME NULL COMMENT '更新时间';

-- 11. 为msds_ecological表添加审计字段
ALTER TABLE msds_ecological 
ADD COLUMN IF NOT EXISTS create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN IF NOT EXISTS create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN IF NOT EXISTS update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN IF NOT EXISTS update_time DATETIME NULL COMMENT '更新时间';

-- 12. 为msds_disposal表添加审计字段
ALTER TABLE msds_disposal 
ADD COLUMN IF NOT EXISTS create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN IF NOT EXISTS create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN IF NOT EXISTS update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN IF NOT EXISTS update_time DATETIME NULL COMMENT '更新时间';

-- 13. 为msds_transportation表添加审计字段
ALTER TABLE msds_transportation 
ADD COLUMN IF NOT EXISTS create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN IF NOT EXISTS create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN IF NOT EXISTS update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN IF NOT EXISTS update_time DATETIME NULL COMMENT '更新时间';

-- 14. 为msds_regulatory表添加审计字段
ALTER TABLE msds_regulatory 
ADD COLUMN IF NOT EXISTS create_by VARCHAR(64) DEFAULT '' COMMENT '创建者',
ADD COLUMN IF NOT EXISTS create_time DATETIME NULL COMMENT '创建时间',
ADD COLUMN IF NOT EXISTS update_by VARCHAR(64) DEFAULT '' COMMENT '更新者',
ADD COLUMN IF NOT EXISTS update_time DATETIME NULL COMMENT '更新时间';

-- 15. 创建msds_other_info表（如果不存在）
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

-- 验证结果
SELECT 
  TABLE_NAME,
  COLUMN_NAME,
  DATA_TYPE,
  COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'msds_dev' 
  AND TABLE_NAME LIKE 'msds_%'
  AND COLUMN_NAME IN ('create_by', 'create_time', 'update_by', 'update_time')
ORDER BY TABLE_NAME, COLUMN_NAME;

SELECT '审计字段添加完成！' AS 'Status';

