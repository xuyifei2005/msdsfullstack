package com.ruoyi.system.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

/**
 * 废弃处置对象 msds_disposal
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public class MsdsDisposal extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 关联MSDS主表ID */
    @Excel(name = "关联MSDS主表ID")
    @NotNull(message = "关联MSDS主表ID不能为空")
    private Long msdsId;

    /** 废弃物性质 */
    @Excel(name = "废弃物性质")
    private String wasteProperties;

    /** 废弃处置方法 */
    @Excel(name = "废弃处置方法")
    private String disposalMethod;

    /** 废弃注意事项 */
    @Excel(name = "废弃注意事项")
    private String disposalPrecautions;

    /** 废弃处置相关法规 */
    @Excel(name = "废弃处置相关法规")
    private String disposalRegulations;

    /** 包装容器的处置 */
    @Excel(name = "包装容器的处置")
    private String containerDisposal;

    /** 推荐的处置方法 */
    @Excel(name = "推荐的处置方法")
    private String recommendedDisposal;

    /** 禁止的处置方法 */
    @Excel(name = "禁止的处置方法")
    private String prohibitedDisposal;

    /** 中和处理方法 */
    @Excel(name = "中和处理方法")
    private String neutralizationMethod;

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

    public void setWasteProperties(String wasteProperties) 
    {
        this.wasteProperties = wasteProperties;
    }

    public String getWasteProperties() 
    {
        return wasteProperties;
    }

    public void setDisposalMethod(String disposalMethod) 
    {
        this.disposalMethod = disposalMethod;
    }

    public String getDisposalMethod() 
    {
        return disposalMethod;
    }

    public void setDisposalPrecautions(String disposalPrecautions) 
    {
        this.disposalPrecautions = disposalPrecautions;
    }

    public String getDisposalPrecautions() 
    {
        return disposalPrecautions;
    }

    public void setDisposalRegulations(String disposalRegulations) 
    {
        this.disposalRegulations = disposalRegulations;
    }

    public String getDisposalRegulations() 
    {
        return disposalRegulations;
    }

    public void setContainerDisposal(String containerDisposal) 
    {
        this.containerDisposal = containerDisposal;
    }

    public String getContainerDisposal() 
    {
        return containerDisposal;
    }

    public void setRecommendedDisposal(String recommendedDisposal) 
    {
        this.recommendedDisposal = recommendedDisposal;
    }

    public String getRecommendedDisposal() 
    {
        return recommendedDisposal;
    }

    public void setProhibitedDisposal(String prohibitedDisposal) 
    {
        this.prohibitedDisposal = prohibitedDisposal;
    }

    public String getProhibitedDisposal() 
    {
        return prohibitedDisposal;
    }

    public void setNeutralizationMethod(String neutralizationMethod) 
    {
        this.neutralizationMethod = neutralizationMethod;
    }

    public String getNeutralizationMethod() 
    {
        return neutralizationMethod;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("msdsId", getMsdsId())
            .append("wasteProperties", getWasteProperties())
            .append("disposalMethod", getDisposalMethod())
            .append("disposalPrecautions", getDisposalPrecautions())
            .append("disposalRegulations", getDisposalRegulations())
            .append("containerDisposal", getContainerDisposal())
            .append("recommendedDisposal", getRecommendedDisposal())
            .append("prohibitedDisposal", getProhibitedDisposal())
            .append("neutralizationMethod", getNeutralizationMethod())
            .append("createTime", getCreateTime())
            .append("updateTime", getUpdateTime())
            .append("createBy", getCreateBy())
            .append("updateBy", getUpdateBy())
            .toString();
    }
} 