package com.ruoyi.system.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.util.Date;

/**
 * MSDS版本历史对象 msds_version_history
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
public class MsdsVersionHistory extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 关联MSDS主表ID */
    @Excel(name = "关联MSDS主表ID")
    @NotNull(message = "关联MSDS主表ID不能为空")
    private Long msdsId;

    /** 版本号 */
    @Excel(name = "版本号")
    @NotBlank(message = "版本号不能为空")
    @Size(max = 20, message = "版本号不能超过20个字符")
    private String version;

    /** 变更描述 */
    @Excel(name = "变更描述")
    private String changeDescription;

    /** 变更原因 */
    @Excel(name = "变更原因")
    private String changeReason;

    /** 变更章节 */
    @Excel(name = "变更章节")
    private String changedSections;

    /** 变更日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "变更日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date changeDate;

    /** 变更人 */
    @Excel(name = "变更人")
    @Size(max = 100, message = "变更人不能超过100个字符")
    private String changedBy;

    /** 审批人 */
    @Excel(name = "审批人")
    @Size(max = 100, message = "审批人不能超过100个字符")
    private String approvedBy;

    /** 审批日期 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "审批日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date approvalDate;

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

    public void setVersion(String version) 
    {
        this.version = version;
    }

    public String getVersion() 
    {
        return version;
    }

    public void setChangeDescription(String changeDescription) 
    {
        this.changeDescription = changeDescription;
    }

    public String getChangeDescription() 
    {
        return changeDescription;
    }

    public void setChangeReason(String changeReason) 
    {
        this.changeReason = changeReason;
    }

    public String getChangeReason() 
    {
        return changeReason;
    }

    public void setChangedSections(String changedSections) 
    {
        this.changedSections = changedSections;
    }

    public String getChangedSections() 
    {
        return changedSections;
    }

    public void setChangeDate(Date changeDate) 
    {
        this.changeDate = changeDate;
    }

    public Date getChangeDate() 
    {
        return changeDate;
    }

    public void setChangedBy(String changedBy) 
    {
        this.changedBy = changedBy;
    }

    public String getChangedBy() 
    {
        return changedBy;
    }

    public void setApprovedBy(String approvedBy) 
    {
        this.approvedBy = approvedBy;
    }

    public String getApprovedBy() 
    {
        return approvedBy;
    }

    public void setApprovalDate(Date approvalDate) 
    {
        this.approvalDate = approvalDate;
    }

    public Date getApprovalDate() 
    {
        return approvalDate;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("msdsId", getMsdsId())
            .append("version", getVersion())
            .append("changeDescription", getChangeDescription())
            .append("changeReason", getChangeReason())
            .append("changedSections", getChangedSections())
            .append("changeDate", getChangeDate())
            .append("changedBy", getChangedBy())
            .append("approvedBy", getApprovedBy())
            .append("approvalDate", getApprovalDate())
            .append("createTime", getCreateTime())
            .toString();
    }
}