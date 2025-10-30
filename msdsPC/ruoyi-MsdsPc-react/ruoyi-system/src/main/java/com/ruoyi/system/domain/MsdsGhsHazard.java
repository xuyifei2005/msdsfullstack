package com.ruoyi.system.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import jakarta.validation.constraints.NotNull;

/**
 * MSDS-GHS危险性分类关联对象 msds_ghs_hazard
 * 
 * @author ruoyi
 * @date 2025-01-22
 */
public class MsdsGhsHazard extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 关联MSDS主表ID */
    @Excel(name = "关联MSDS主表ID")
    @NotNull(message = "关联MSDS主表ID不能为空")
    private Long msdsId;

    /** 关联GHS危险类别ID */
    @Excel(name = "关联GHS危险类别ID")
    @NotNull(message = "关联GHS危险类别ID不能为空")
    private Long ghsClassId;

    /** GHS危险类别信息（关联查询时使用） */
    private GhsHazardClass ghsHazardClass;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }

    public void setMsdsId(Long msdsId) 
    {
        this.msdsId = msdsId;
    }

    public Long getMsdsId() 
    {
        return msdsId;
    }

    public void setGhsClassId(Long ghsClassId) 
    {
        this.ghsClassId = ghsClassId;
    }

    public Long getGhsClassId() 
    {
        return ghsClassId;
    }

    public void setGhsHazardClass(GhsHazardClass ghsHazardClass) 
    {
        this.ghsHazardClass = ghsHazardClass;
    }

    public GhsHazardClass getGhsHazardClass() 
    {
        return ghsHazardClass;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("msdsId", getMsdsId())
            .append("ghsClassId", getGhsClassId())
            .append("ghsHazardClass", getGhsHazardClass())
            .toString();
    }
}