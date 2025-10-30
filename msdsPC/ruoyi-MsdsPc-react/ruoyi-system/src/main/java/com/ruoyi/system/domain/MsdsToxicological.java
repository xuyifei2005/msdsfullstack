package com.ruoyi.system.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import jakarta.validation.constraints.NotNull;

/**
 * 毒理学资料对象 msds_toxicological
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public class MsdsToxicological extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 关联MSDS主表ID */
    @Excel(name = "关联MSDS主表ID")
    @NotNull(message = "关联MSDS主表ID不能为空")
    private Long msdsId;

    /** 急性毒性 */
    @Excel(name = "急性毒性")
    private String acuteToxicity;

    /** LD50(经口,大鼠) */
    @Excel(name = "LD50(经口,大鼠)")
    private String ld50Oral;

    /** LD50(经皮,兔) */
    @Excel(name = "LD50(经皮,兔)")
    private String ld50Dermal;

    /** LC50(吸入,大鼠) */
    @Excel(name = "LC50(吸入,大鼠)")
    private String lc50Inhalation;

    /** 亚急性和慢性毒性 */
    @Excel(name = "亚急性和慢性毒性")
    private String subacuteChronic;

    /** 皮肤刺激性 */
    @Excel(name = "皮肤刺激性")
    private String skinIrritation;

    /** 眼睛刺激性 */
    @Excel(name = "眼睛刺激性")
    private String eyeIrritation;

    /** 呼吸道刺激性 */
    @Excel(name = "呼吸道刺激性")
    private String respiratoryIrritation;

    /** 致敏性 */
    @Excel(name = "致敏性")
    private String sensitization;

    /** 致突变性 */
    @Excel(name = "致突变性")
    private String mutagenicity;

    /** 致畸性 */
    @Excel(name = "致畸性")
    private String teratogenicity;

    /** 生殖毒性 */
    @Excel(name = "生殖毒性")
    private String reproductiveToxicity;

    /** 致癌性 */
    @Excel(name = "致癌性")
    private String carcinogenicity;

    /** 致癌物分类 */
    @Excel(name = "致癌物分类")
    private String carcinogenClassification;

    /** 特定目标器官毒性 */
    @Excel(name = "特定目标器官毒性")
    private String specificTargetOrgan;

    /** 吸入危害 */
    @Excel(name = "吸入危害")
    private String aspirationHazard;

    /** 其他毒理学资料 */
    @Excel(name = "其他毒理学资料")
    private String otherToxicity;

    /** RTECS编号 */
    @Excel(name = "RTECS编号")
    private String rtecs;

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

    public void setAcuteToxicity(String acuteToxicity) 
    {
        this.acuteToxicity = acuteToxicity;
    }

    public String getAcuteToxicity() 
    {
        return acuteToxicity;
    }

    public void setLd50Oral(String ld50Oral) 
    {
        this.ld50Oral = ld50Oral;
    }

    public String getLd50Oral() 
    {
        return ld50Oral;
    }

    public void setLd50Dermal(String ld50Dermal) 
    {
        this.ld50Dermal = ld50Dermal;
    }

    public String getLd50Dermal() 
    {
        return ld50Dermal;
    }

    public void setLc50Inhalation(String lc50Inhalation) 
    {
        this.lc50Inhalation = lc50Inhalation;
    }

    public String getLc50Inhalation() 
    {
        return lc50Inhalation;
    }

    public void setSubacuteChronic(String subacuteChronic) 
    {
        this.subacuteChronic = subacuteChronic;
    }

    public String getSubacuteChronic() 
    {
        return subacuteChronic;
    }

    public void setSkinIrritation(String skinIrritation) 
    {
        this.skinIrritation = skinIrritation;
    }

    public String getSkinIrritation() 
    {
        return skinIrritation;
    }

    public void setEyeIrritation(String eyeIrritation) 
    {
        this.eyeIrritation = eyeIrritation;
    }

    public String getEyeIrritation() 
    {
        return eyeIrritation;
    }

    public void setRespiratoryIrritation(String respiratoryIrritation) 
    {
        this.respiratoryIrritation = respiratoryIrritation;
    }

    public String getRespiratoryIrritation() 
    {
        return respiratoryIrritation;
    }

    public void setSensitization(String sensitization) 
    {
        this.sensitization = sensitization;
    }

    public String getSensitization() 
    {
        return sensitization;
    }

    public void setMutagenicity(String mutagenicity) 
    {
        this.mutagenicity = mutagenicity;
    }

    public String getMutagenicity() 
    {
        return mutagenicity;
    }

    public void setTeratogenicity(String teratogenicity) 
    {
        this.teratogenicity = teratogenicity;
    }

    public String getTeratogenicity() 
    {
        return teratogenicity;
    }

    public void setReproductiveToxicity(String reproductiveToxicity) 
    {
        this.reproductiveToxicity = reproductiveToxicity;
    }

    public String getReproductiveToxicity() 
    {
        return reproductiveToxicity;
    }

    public void setCarcinogenicity(String carcinogenicity) 
    {
        this.carcinogenicity = carcinogenicity;
    }

    public String getCarcinogenicity() 
    {
        return carcinogenicity;
    }

    public void setCarcinogenClassification(String carcinogenClassification) 
    {
        this.carcinogenClassification = carcinogenClassification;
    }

    public String getCarcinogenClassification() 
    {
        return carcinogenClassification;
    }

    public void setSpecificTargetOrgan(String specificTargetOrgan) 
    {
        this.specificTargetOrgan = specificTargetOrgan;
    }

    public String getSpecificTargetOrgan() 
    {
        return specificTargetOrgan;
    }

    public void setAspirationHazard(String aspirationHazard) 
    {
        this.aspirationHazard = aspirationHazard;
    }

    public String getAspirationHazard() 
    {
        return aspirationHazard;
    }

    public void setOtherToxicity(String otherToxicity) 
    {
        this.otherToxicity = otherToxicity;
    }

    public String getOtherToxicity() 
    {
        return otherToxicity;
    }

    public void setRtecs(String rtecs) 
    {
        this.rtecs = rtecs;
    }

    public String getRtecs() 
    {
        return rtecs;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("msdsId", getMsdsId())
            .append("acuteToxicity", getAcuteToxicity())
            .append("ld50Oral", getLd50Oral())
            .append("ld50Dermal", getLd50Dermal())
            .append("lc50Inhalation", getLc50Inhalation())
            .append("subacuteChronic", getSubacuteChronic())
            .append("skinIrritation", getSkinIrritation())
            .append("eyeIrritation", getEyeIrritation())
            .append("respiratoryIrritation", getRespiratoryIrritation())
            .append("sensitization", getSensitization())
            .append("mutagenicity", getMutagenicity())
            .append("teratogenicity", getTeratogenicity())
            .append("reproductiveToxicity", getReproductiveToxicity())
            .append("carcinogenicity", getCarcinogenicity())
            .append("carcinogenClassification", getCarcinogenClassification())
            .append("specificTargetOrgan", getSpecificTargetOrgan())
            .append("aspirationHazard", getAspirationHazard())
            .append("otherToxicity", getOtherToxicity())
            .append("rtecs", getRtecs())
            .append("createTime", getCreateTime())
            .append("updateTime", getUpdateTime())
            .append("createBy", getCreateBy())
            .append("updateBy", getUpdateBy())
            .toString();
    }
} 