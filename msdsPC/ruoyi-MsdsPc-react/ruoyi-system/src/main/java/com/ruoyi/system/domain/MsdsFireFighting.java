package com.ruoyi.system.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

/**
 * 消防措施对象 msds_fire_fighting
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public class MsdsFireFighting extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 关联MSDS主表ID */
    @Excel(name = "关联MSDS主表ID")
    @NotNull(message = "关联MSDS主表ID不能为空")
    private Long msdsId;

    /** 危险特性 */
    @Excel(name = "危险特性")
    private String hazardCharacteristics;

    /** 有害燃烧产物 */
    @Excel(name = "有害燃烧产物")
    private String harmfulCombustionProducts;

    /** 适宜的灭火介质 */
    @Excel(name = "适宜的灭火介质")
    private String suitableExtinguishingMedia;

    /** 不适宜的灭火介质 */
    @Excel(name = "不适宜的灭火介质")
    private String unsuitableExtinguishingMedia;

    /** 消防设备和防护装备 */
    @Excel(name = "消防设备和防护装备")
    private String fireFightingEquipment;

    /** 特殊消防程序 */
    @Excel(name = "特殊消防程序")
    private String fireFightingProcedures;

    /** 闪点 */
    @Excel(name = "闪点")
    private String flashPoint;

    /** 自燃温度 */
    @Excel(name = "自燃温度")
    private String autoignitionTemperature;

    /** 燃烧性/爆炸极限 */
    @Excel(name = "燃烧性/爆炸极限")
    private String flammabilityLimits;

    /** 建规火险分级 */
    @Excel(name = "建规火险分级")
    private String fireRiskClassification;

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

    public void setHazardCharacteristics(String hazardCharacteristics) 
    {
        this.hazardCharacteristics = hazardCharacteristics;
    }

    public String getHazardCharacteristics() 
    {
        return hazardCharacteristics;
    }

    public void setHarmfulCombustionProducts(String harmfulCombustionProducts) 
    {
        this.harmfulCombustionProducts = harmfulCombustionProducts;
    }

    public String getHarmfulCombustionProducts() 
    {
        return harmfulCombustionProducts;
    }

    public void setSuitableExtinguishingMedia(String suitableExtinguishingMedia) 
    {
        this.suitableExtinguishingMedia = suitableExtinguishingMedia;
    }

    public String getSuitableExtinguishingMedia() 
    {
        return suitableExtinguishingMedia;
    }

    public void setUnsuitableExtinguishingMedia(String unsuitableExtinguishingMedia) 
    {
        this.unsuitableExtinguishingMedia = unsuitableExtinguishingMedia;
    }

    public String getUnsuitableExtinguishingMedia() 
    {
        return unsuitableExtinguishingMedia;
    }

    public void setFireFightingEquipment(String fireFightingEquipment) 
    {
        this.fireFightingEquipment = fireFightingEquipment;
    }

    public String getFireFightingEquipment() 
    {
        return fireFightingEquipment;
    }

    public void setFireFightingProcedures(String fireFightingProcedures) 
    {
        this.fireFightingProcedures = fireFightingProcedures;
    }

    public String getFireFightingProcedures() 
    {
        return fireFightingProcedures;
    }

    public void setFlashPoint(String flashPoint) 
    {
        this.flashPoint = flashPoint;
    }

    public String getFlashPoint() 
    {
        return flashPoint;
    }

    public void setAutoignitionTemperature(String autoignitionTemperature) 
    {
        this.autoignitionTemperature = autoignitionTemperature;
    }

    public String getAutoignitionTemperature() 
    {
        return autoignitionTemperature;
    }

    public void setFlammabilityLimits(String flammabilityLimits) 
    {
        this.flammabilityLimits = flammabilityLimits;
    }

    public String getFlammabilityLimits() 
    {
        return flammabilityLimits;
    }

    public void setFireRiskClassification(String fireRiskClassification) 
    {
        this.fireRiskClassification = fireRiskClassification;
    }

    public String getFireRiskClassification() 
    {
        return fireRiskClassification;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("msdsId", getMsdsId())
            .append("hazardCharacteristics", getHazardCharacteristics())
            .append("harmfulCombustionProducts", getHarmfulCombustionProducts())
            .append("suitableExtinguishingMedia", getSuitableExtinguishingMedia())
            .append("unsuitableExtinguishingMedia", getUnsuitableExtinguishingMedia())
            .append("fireFightingEquipment", getFireFightingEquipment())
            .append("fireFightingProcedures", getFireFightingProcedures())
            .append("flashPoint", getFlashPoint())
            .append("autoignitionTemperature", getAutoignitionTemperature())
            .append("flammabilityLimits", getFlammabilityLimits())
            .append("fireRiskClassification", getFireRiskClassification())
            .append("createTime", getCreateTime())
            .append("updateTime", getUpdateTime())
            .append("createBy", getCreateBy())
            .append("updateBy", getUpdateBy())
            .toString();
    }
} 