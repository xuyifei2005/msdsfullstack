package com.ruoyi.system.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import jakarta.validation.constraints.NotNull;

/**
 * 操作处置与储存对象 msds_handling_storage
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public class MsdsHandlingStorage extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 关联MSDS主表ID */
    @Excel(name = "关联MSDS主表ID")
    @NotNull(message = "关联MSDS主表ID不能为空")
    private Long msdsId;

    /** 操作注意事项 */
    @Excel(name = "操作注意事项")
    private String handlingPrecautions;

    /** 储存注意事项 */
    @Excel(name = "储存注意事项")
    private String storagePrecautions;

    /** 最佳储存温度 */
    @Excel(name = "最佳储存温度")
    private String optimalTemperature;

    /** 储存温度范围 */
    @Excel(name = "储存温度范围")
    private String temperatureRange;

    /** 湿度要求 */
    @Excel(name = "湿度要求")
    private String humidityRequirements;

    /** 储存容器要求 */
    @Excel(name = "储存容器要求")
    private String storageContainer;

    /** 不相容的物质 */
    @Excel(name = "不相容的物质")
    private String incompatibleMaterials;

    /** 储存区域要求 */
    @Excel(name = "储存区域要求")
    private String storageAreaRequirements;

    /** 保质期 */
    @Excel(name = "保质期")
    private String shelfLife;

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

    public void setHandlingPrecautions(String handlingPrecautions) 
    {
        this.handlingPrecautions = handlingPrecautions;
    }

    public String getHandlingPrecautions() 
    {
        return handlingPrecautions;
    }

    public void setStoragePrecautions(String storagePrecautions) 
    {
        this.storagePrecautions = storagePrecautions;
    }

    public String getStoragePrecautions() 
    {
        return storagePrecautions;
    }

    public void setOptimalTemperature(String optimalTemperature) 
    {
        this.optimalTemperature = optimalTemperature;
    }

    public String getOptimalTemperature() 
    {
        return optimalTemperature;
    }

    public void setTemperatureRange(String temperatureRange) 
    {
        this.temperatureRange = temperatureRange;
    }

    public String getTemperatureRange() 
    {
        return temperatureRange;
    }

    public void setHumidityRequirements(String humidityRequirements) 
    {
        this.humidityRequirements = humidityRequirements;
    }

    public String getHumidityRequirements() 
    {
        return humidityRequirements;
    }

    public void setStorageContainer(String storageContainer) 
    {
        this.storageContainer = storageContainer;
    }

    public String getStorageContainer() 
    {
        return storageContainer;
    }

    public void setIncompatibleMaterials(String incompatibleMaterials) 
    {
        this.incompatibleMaterials = incompatibleMaterials;
    }

    public String getIncompatibleMaterials() 
    {
        return incompatibleMaterials;
    }

    public void setStorageAreaRequirements(String storageAreaRequirements) 
    {
        this.storageAreaRequirements = storageAreaRequirements;
    }

    public String getStorageAreaRequirements() 
    {
        return storageAreaRequirements;
    }

    public void setShelfLife(String shelfLife) 
    {
        this.shelfLife = shelfLife;
    }

    public String getShelfLife() 
    {
        return shelfLife;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("msdsId", getMsdsId())
            .append("handlingPrecautions", getHandlingPrecautions())
            .append("storagePrecautions", getStoragePrecautions())
            .append("optimalTemperature", getOptimalTemperature())
            .append("temperatureRange", getTemperatureRange())
            .append("humidityRequirements", getHumidityRequirements())
            .append("storageContainer", getStorageContainer())
            .append("incompatibleMaterials", getIncompatibleMaterials())
            .append("storageAreaRequirements", getStorageAreaRequirements())
            .append("shelfLife", getShelfLife())
            .append("createTime", getCreateTime())
            .append("updateTime", getUpdateTime())
            .append("createBy", getCreateBy())
            .append("updateBy", getUpdateBy())
            .toString();
    }
} 