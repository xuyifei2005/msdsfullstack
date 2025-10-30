package com.ruoyi.system.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import jakarta.validation.constraints.NotNull;

/**
 * 运输信息对象 msds_transportation
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public class MsdsTransportation extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 关联MSDS主表ID */
    @Excel(name = "关联MSDS主表ID")
    @NotNull(message = "关联MSDS主表ID不能为空")
    private Long msdsId;

    /** 危险货物编号 */
    @Excel(name = "危险货物编号")
    private String dangerousGoodsNumber;

    /** UN编号 */
    @Excel(name = "UN编号")
    private String unNumber;

    /** 正确运输名称 */
    @Excel(name = "正确运输名称")
    private String properShippingName;

    /** 运输危险类别 */
    @Excel(name = "运输危险类别")
    private String transportHazardClass;

    /** 包装类别 */
    @Excel(name = "包装类别")
    private String packingGroup;

    /** 包装标志 */
    @Excel(name = "包装标志")
    private String packagingMarks;

    /** 包装方法 */
    @Excel(name = "包装方法")
    private String packagingMethod;

    /** 海洋污染物(1:是,0:否) */
    @Excel(name = "海洋污染物", readConverterExp = "1=是,0=否")
    private Integer marinePollutant;

    /** 散装运输要求 */
    @Excel(name = "散装运输要求")
    private String transportInBulk;

    /** 运输注意事项 */
    @Excel(name = "运输注意事项")
    private String transportationPrecautions;

    /** 应急响应指南编号 */
    @Excel(name = "应急响应指南编号")
    private String emergencyResponseGuide;

    /** IMDG规则页码 */
    @Excel(name = "IMDG规则页码")
    private String imdgRulePage;

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

    public void setDangerousGoodsNumber(String dangerousGoodsNumber) 
    {
        this.dangerousGoodsNumber = dangerousGoodsNumber;
    }

    public String getDangerousGoodsNumber() 
    {
        return dangerousGoodsNumber;
    }

    public void setUnNumber(String unNumber) 
    {
        this.unNumber = unNumber;
    }

    public String getUnNumber() 
    {
        return unNumber;
    }

    public void setProperShippingName(String properShippingName) 
    {
        this.properShippingName = properShippingName;
    }

    public String getProperShippingName() 
    {
        return properShippingName;
    }

    public void setTransportHazardClass(String transportHazardClass) 
    {
        this.transportHazardClass = transportHazardClass;
    }

    public String getTransportHazardClass() 
    {
        return transportHazardClass;
    }

    public void setPackingGroup(String packingGroup) 
    {
        this.packingGroup = packingGroup;
    }

    public String getPackingGroup() 
    {
        return packingGroup;
    }

    public void setPackagingMarks(String packagingMarks) 
    {
        this.packagingMarks = packagingMarks;
    }

    public String getPackagingMarks() 
    {
        return packagingMarks;
    }

    public void setPackagingMethod(String packagingMethod) 
    {
        this.packagingMethod = packagingMethod;
    }

    public String getPackagingMethod() 
    {
        return packagingMethod;
    }

    public void setMarinePollutant(Integer marinePollutant) 
    {
        this.marinePollutant = marinePollutant;
    }

    public Integer getMarinePollutant() 
    {
        return marinePollutant;
    }

    public void setTransportInBulk(String transportInBulk) 
    {
        this.transportInBulk = transportInBulk;
    }

    public String getTransportInBulk() 
    {
        return transportInBulk;
    }

    public void setTransportationPrecautions(String transportationPrecautions) 
    {
        this.transportationPrecautions = transportationPrecautions;
    }

    public String getTransportationPrecautions() 
    {
        return transportationPrecautions;
    }

    public void setEmergencyResponseGuide(String emergencyResponseGuide) 
    {
        this.emergencyResponseGuide = emergencyResponseGuide;
    }

    public String getEmergencyResponseGuide() 
    {
        return emergencyResponseGuide;
    }

    public void setImdgRulePage(String imdgRulePage) 
    {
        this.imdgRulePage = imdgRulePage;
    }

    public String getImdgRulePage() 
    {
        return imdgRulePage;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("msdsId", getMsdsId())
            .append("dangerousGoodsNumber", getDangerousGoodsNumber())
            .append("unNumber", getUnNumber())
            .append("properShippingName", getProperShippingName())
            .append("transportHazardClass", getTransportHazardClass())
            .append("packingGroup", getPackingGroup())
            .append("packagingMarks", getPackagingMarks())
            .append("packagingMethod", getPackagingMethod())
            .append("marinePollutant", getMarinePollutant())
            .append("transportInBulk", getTransportInBulk())
            .append("transportationPrecautions", getTransportationPrecautions())
            .append("emergencyResponseGuide", getEmergencyResponseGuide())
            .append("imdgRulePage", getImdgRulePage())
            .append("createTime", getCreateTime())
            .append("updateTime", getUpdateTime())
            .append("createBy", getCreateBy())
            .append("updateBy", getUpdateBy())
            .toString();
    }
} 