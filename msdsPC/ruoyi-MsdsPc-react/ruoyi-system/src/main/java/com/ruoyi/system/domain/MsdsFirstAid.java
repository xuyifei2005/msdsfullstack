package com.ruoyi.system.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

/**
 * MSDS急救措施表对象 msds_first_aid
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public class MsdsFirstAid extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 关联MSDS主表ID */
    @Excel(name = "关联MSDS主表ID")
    @NotNull(message = "关联MSDS主表ID不能为空")
    private Long msdsId;

    /** 皮肤接触处理措施 */
    @Excel(name = "皮肤接触处理措施")
    private String skinContact;

    /** 眼睛接触处理措施 */
    @Excel(name = "眼睛接触处理措施")
    private String eyeContact;

    /** 吸入处理措施 */
    @Excel(name = "吸入处理措施")
    private String inhalation;

    /** 食入处理措施 */
    @Excel(name = "食入处理措施")
    private String ingestion;

    /** 一般注意事项 */
    @Excel(name = "一般注意事项")
    private String generalNotes;

    /** 可能出现的症状和健康影响 */
    @Excel(name = "可能出现的症状和健康影响")
    private String symptomsEffects;

    /** 需要立即就医的情况 */
    @Excel(name = "需要立即就医的情况")
    private String immediateMedicalAttention;

    /** 解毒剂及治疗方法 */
    @Excel(name = "解毒剂及治疗方法")
    private String antidoteTreatment;

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

    public void setSkinContact(String skinContact)
    {
        this.skinContact = skinContact;
    }

    public String getSkinContact()
    {
        return skinContact;
    }

    public void setEyeContact(String eyeContact)
    {
        this.eyeContact = eyeContact;
    }

    public String getEyeContact()
    {
        return eyeContact;
    }

    public void setInhalation(String inhalation)
    {
        this.inhalation = inhalation;
    }

    public String getInhalation()
    {
        return inhalation;
    }

    public void setIngestion(String ingestion)
    {
        this.ingestion = ingestion;
    }

    public String getIngestion()
    {
        return ingestion;
    }

    public void setGeneralNotes(String generalNotes)
    {
        this.generalNotes = generalNotes;
    }

    public String getGeneralNotes()
    {
        return generalNotes;
    }

    public void setSymptomsEffects(String symptomsEffects)
    {
        this.symptomsEffects = symptomsEffects;
    }

    public String getSymptomsEffects()
    {
        return symptomsEffects;
    }

    public void setImmediateMedicalAttention(String immediateMedicalAttention)
    {
        this.immediateMedicalAttention = immediateMedicalAttention;
    }

    public String getImmediateMedicalAttention()
    {
        return immediateMedicalAttention;
    }

    public void setAntidoteTreatment(String antidoteTreatment)
    {
        this.antidoteTreatment = antidoteTreatment;
    }

    public String getAntidoteTreatment()
    {
        return antidoteTreatment;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("msdsId", getMsdsId())
            .append("skinContact", getSkinContact())
            .append("eyeContact", getEyeContact())
            .append("inhalation", getInhalation())
            .append("ingestion", getIngestion())
            .append("generalNotes", getGeneralNotes())
            .append("symptomsEffects", getSymptomsEffects())
            .append("immediateMedicalAttention", getImmediateMedicalAttention())
            .append("antidoteTreatment", getAntidoteTreatment())
            .toString();
    }
} 