package com.ruoyi.system.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

/**
 * 生态学资料对象 msds_ecological
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public class MsdsEcological extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 关联MSDS主表ID */
    @Excel(name = "关联MSDS主表ID")
    @NotNull(message = "关联MSDS主表ID不能为空")
    private Long msdsId;

    /** 生态毒性 */
    @Excel(name = "生态毒性")
    private String ecologicalToxicity;

    /** 鱼类毒性 */
    @Excel(name = "鱼类毒性")
    private String fishToxicity;

    /** 无脊椎动物毒性 */
    @Excel(name = "无脊椎动物毒性")
    private String invertebrateToxicity;

    /** 藻类毒性 */
    @Excel(name = "藻类毒性")
    private String algaeToxicity;

    /** 细菌毒性 */
    @Excel(name = "细菌毒性")
    private String bacteriaToxicity;

    /** 生物降解性 */
    @Excel(name = "生物降解性")
    private String biodegradability;

    /** 生物降解速率 */
    @Excel(name = "生物降解速率")
    private String biodegradationRate;

    /** 非生物降解性 */
    @Excel(name = "非生物降解性")
    private String nonBiodegradability;

    /** 光降解 */
    @Excel(name = "光降解")
    private String photodegradation;

    /** 水解 */
    @Excel(name = "水解")
    private String hydrolysis;

    /** 生物富集或生物积累性 */
    @Excel(name = "生物富集或生物积累性")
    private String bioaccumulation;

    /** 生物富集因子 */
    @Excel(name = "生物富集因子")
    private String bioconcentrationFactor;

    /** 土壤中迁移性 */
    @Excel(name = "土壤中迁移性")
    private String mobilityInSoil;

    /** 其它有害作用 */
    @Excel(name = "其它有害作用")
    private String otherEnvironmentalEffects;

    /** 臭氧消耗潜能值 */
    @Excel(name = "臭氧消耗潜能值")
    private String ozoneDepletionPotential;

    /** 全球变暖潜能值 */
    @Excel(name = "全球变暖潜能值")
    private String globalWarmingPotential;

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

    public void setEcologicalToxicity(String ecologicalToxicity) 
    {
        this.ecologicalToxicity = ecologicalToxicity;
    }

    public String getEcologicalToxicity() 
    {
        return ecologicalToxicity;
    }

    public void setFishToxicity(String fishToxicity) 
    {
        this.fishToxicity = fishToxicity;
    }

    public String getFishToxicity() 
    {
        return fishToxicity;
    }

    public void setInvertebrateToxicity(String invertebrateToxicity) 
    {
        this.invertebrateToxicity = invertebrateToxicity;
    }

    public String getInvertebrateToxicity() 
    {
        return invertebrateToxicity;
    }

    public void setAlgaeToxicity(String algaeToxicity) 
    {
        this.algaeToxicity = algaeToxicity;
    }

    public String getAlgaeToxicity() 
    {
        return algaeToxicity;
    }

    public void setBacteriaToxicity(String bacteriaToxicity) 
    {
        this.bacteriaToxicity = bacteriaToxicity;
    }

    public String getBacteriaToxicity() 
    {
        return bacteriaToxicity;
    }

    public void setBiodegradability(String biodegradability) 
    {
        this.biodegradability = biodegradability;
    }

    public String getBiodegradability() 
    {
        return biodegradability;
    }

    public void setBiodegradationRate(String biodegradationRate) 
    {
        this.biodegradationRate = biodegradationRate;
    }

    public String getBiodegradationRate() 
    {
        return biodegradationRate;
    }

    public void setNonBiodegradability(String nonBiodegradability) 
    {
        this.nonBiodegradability = nonBiodegradability;
    }

    public String getNonBiodegradability() 
    {
        return nonBiodegradability;
    }

    public void setPhotodegradation(String photodegradation) 
    {
        this.photodegradation = photodegradation;
    }

    public String getPhotodegradation() 
    {
        return photodegradation;
    }

    public void setHydrolysis(String hydrolysis) 
    {
        this.hydrolysis = hydrolysis;
    }

    public String getHydrolysis() 
    {
        return hydrolysis;
    }

    public void setBioaccumulation(String bioaccumulation) 
    {
        this.bioaccumulation = bioaccumulation;
    }

    public String getBioaccumulation() 
    {
        return bioaccumulation;
    }

    public void setBioconcentrationFactor(String bioconcentrationFactor) 
    {
        this.bioconcentrationFactor = bioconcentrationFactor;
    }

    public String getBioconcentrationFactor() 
    {
        return bioconcentrationFactor;
    }

    public void setMobilityInSoil(String mobilityInSoil) 
    {
        this.mobilityInSoil = mobilityInSoil;
    }

    public String getMobilityInSoil() 
    {
        return mobilityInSoil;
    }

    public void setOtherEnvironmentalEffects(String otherEnvironmentalEffects) 
    {
        this.otherEnvironmentalEffects = otherEnvironmentalEffects;
    }

    public String getOtherEnvironmentalEffects() 
    {
        return otherEnvironmentalEffects;
    }

    public void setOzoneDepletionPotential(String ozoneDepletionPotential) 
    {
        this.ozoneDepletionPotential = ozoneDepletionPotential;
    }

    public String getOzoneDepletionPotential() 
    {
        return ozoneDepletionPotential;
    }

    public void setGlobalWarmingPotential(String globalWarmingPotential) 
    {
        this.globalWarmingPotential = globalWarmingPotential;
    }

    public String getGlobalWarmingPotential() 
    {
        return globalWarmingPotential;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("msdsId", getMsdsId())
            .append("ecologicalToxicity", getEcologicalToxicity())
            .append("fishToxicity", getFishToxicity())
            .append("invertebrateToxicity", getInvertebrateToxicity())
            .append("algaeToxicity", getAlgaeToxicity())
            .append("bacteriaToxicity", getBacteriaToxicity())
            .append("biodegradability", getBiodegradability())
            .append("biodegradationRate", getBiodegradationRate())
            .append("nonBiodegradability", getNonBiodegradability())
            .append("photodegradation", getPhotodegradation())
            .append("hydrolysis", getHydrolysis())
            .append("bioaccumulation", getBioaccumulation())
            .append("bioconcentrationFactor", getBioconcentrationFactor())
            .append("mobilityInSoil", getMobilityInSoil())
            .append("otherEnvironmentalEffects", getOtherEnvironmentalEffects())
            .append("ozoneDepletionPotential", getOzoneDepletionPotential())
            .append("globalWarmingPotential", getGlobalWarmingPotential())
            .append("createTime", getCreateTime())
            .append("updateTime", getUpdateTime())
            .append("createBy", getCreateBy())
            .append("updateBy", getUpdateBy())
            .toString();
    }
} 