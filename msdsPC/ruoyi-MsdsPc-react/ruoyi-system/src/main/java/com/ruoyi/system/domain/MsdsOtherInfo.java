package com.ruoyi.system.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.util.Date;

/**
 * 其他信息对象 msds_other_info
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public class MsdsOtherInfo extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 关联MSDS主表ID */
    @Excel(name = "关联MSDS主表ID")
    @NotNull(message = "关联MSDS主表ID不能为空")
    private Long msdsId;

    /** 参考文献 */
    @Excel(name = "参考文献")
    private String references;

    /** 数据来源 */
    @Excel(name = "数据来源")
    private String dataSources;

    /** 填表时间 */
    @Excel(name = "填表时间", dateFormat = "yyyy-MM-dd")
    private Date formFillTime;

    /** 填表部门 */
    @Excel(name = "填表部门")
    private String formFillDepartment;

    /** 填表人 */
    @Excel(name = "填表人")
    private String formFillPerson;

    /** 数据审核单位 */
    @Excel(name = "数据审核单位")
    private String dataAuditUnit;

    /** 数据审核人 */
    @Excel(name = "数据审核人")
    private String dataAuditPerson;

    /** 技术审查人 */
    @Excel(name = "技术审查人")
    private String technicalReviewPerson;

    /** 修改说明 */
    @Excel(name = "修改说明")
    private String modificationNotes;

    /** 培训要求 */
    @Excel(name = "培训要求")
    private String trainingRequirements;

    /** 其他信息 */
    @Excel(name = "其他信息")
    private String additionalInformation;

    /** 免责声明 */
    @Excel(name = "免责声明")
    private String disclaimer;

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

    public void setReferences(String references) 
    {
        this.references = references;
    }

    public String getReferences() 
    {
        return references;
    }

    public void setDataSources(String dataSources) 
    {
        this.dataSources = dataSources;
    }

    public String getDataSources() 
    {
        return dataSources;
    }

    public void setFormFillTime(Date formFillTime) 
    {
        this.formFillTime = formFillTime;
    }

    public Date getFormFillTime() 
    {
        return formFillTime;
    }

    public void setFormFillDepartment(String formFillDepartment) 
    {
        this.formFillDepartment = formFillDepartment;
    }

    public String getFormFillDepartment() 
    {
        return formFillDepartment;
    }

    public void setFormFillPerson(String formFillPerson) 
    {
        this.formFillPerson = formFillPerson;
    }

    public String getFormFillPerson() 
    {
        return formFillPerson;
    }

    public void setDataAuditUnit(String dataAuditUnit) 
    {
        this.dataAuditUnit = dataAuditUnit;
    }

    public String getDataAuditUnit() 
    {
        return dataAuditUnit;
    }

    public void setDataAuditPerson(String dataAuditPerson) 
    {
        this.dataAuditPerson = dataAuditPerson;
    }

    public String getDataAuditPerson() 
    {
        return dataAuditPerson;
    }

    public void setTechnicalReviewPerson(String technicalReviewPerson) 
    {
        this.technicalReviewPerson = technicalReviewPerson;
    }

    public String getTechnicalReviewPerson() 
    {
        return technicalReviewPerson;
    }

    public void setModificationNotes(String modificationNotes) 
    {
        this.modificationNotes = modificationNotes;
    }

    public String getModificationNotes() 
    {
        return modificationNotes;
    }

    public void setTrainingRequirements(String trainingRequirements) 
    {
        this.trainingRequirements = trainingRequirements;
    }

    public String getTrainingRequirements() 
    {
        return trainingRequirements;
    }

    public void setAdditionalInformation(String additionalInformation) 
    {
        this.additionalInformation = additionalInformation;
    }

    public String getAdditionalInformation() 
    {
        return additionalInformation;
    }

    public void setDisclaimer(String disclaimer) 
    {
        this.disclaimer = disclaimer;
    }

    public String getDisclaimer() 
    {
        return disclaimer;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("msdsId", getMsdsId())
            .append("references", getReferences())
            .append("dataSources", getDataSources())
            .append("formFillTime", getFormFillTime())
            .append("formFillDepartment", getFormFillDepartment())
            .append("formFillPerson", getFormFillPerson())
            .append("dataAuditUnit", getDataAuditUnit())
            .append("dataAuditPerson", getDataAuditPerson())
            .append("technicalReviewPerson", getTechnicalReviewPerson())
            .append("modificationNotes", getModificationNotes())
            .append("trainingRequirements", getTrainingRequirements())
            .append("additionalInformation", getAdditionalInformation())
            .append("disclaimer", getDisclaimer())
            .append("createTime", getCreateTime())
            .append("updateTime", getUpdateTime())
            .append("createBy", getCreateBy())
            .append("updateBy", getUpdateBy())
            .toString();
    }
} 