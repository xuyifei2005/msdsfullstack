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
 * MSDS审批流程对象 msds_approval_workflow
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
public class MsdsApprovalWorkflow extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 关联MSDS主表ID */
    @Excel(name = "关联MSDS主表ID")
    @NotNull(message = "关联MSDS主表ID不能为空")
    private Long msdsId;

    /** 审批步骤序号 */
    @Excel(name = "审批步骤序号")
    @NotNull(message = "审批步骤序号不能为空")
    private Integer stepNo;

    /** 审批步骤名称 */
    @Excel(name = "审批步骤名称")
    @NotBlank(message = "审批步骤名称不能为空")
    @Size(max = 100, message = "审批步骤名称不能超过100个字符")
    private String stepName;

    /** 审批人 */
    @Excel(name = "审批人")
    @Size(max = 100, message = "审批人不能超过100个字符")
    private String approver;

    /** 审批状态 */
    @Excel(name = "审批状态", readConverterExp = "pending=待审批,approved=已审批,rejected=已拒绝,skipped=已跳过")
    private String approvalStatus;

    /** 审批时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "审批时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date approvalDate;

    /** 审批意见 */
    @Excel(name = "审批意见")
    private String approvalComments;

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

    public void setStepNo(Integer stepNo) 
    {
        this.stepNo = stepNo;
    }

    public Integer getStepNo() 
    {
        return stepNo;
    }

    public void setStepName(String stepName) 
    {
        this.stepName = stepName;
    }

    public String getStepName() 
    {
        return stepName;
    }

    public void setApprover(String approver) 
    {
        this.approver = approver;
    }

    public String getApprover() 
    {
        return approver;
    }

    public void setApprovalStatus(String approvalStatus) 
    {
        this.approvalStatus = approvalStatus;
    }

    public String getApprovalStatus() 
    {
        return approvalStatus;
    }

    public void setApprovalDate(Date approvalDate) 
    {
        this.approvalDate = approvalDate;
    }

    public Date getApprovalDate() 
    {
        return approvalDate;
    }

    public void setApprovalComments(String approvalComments) 
    {
        this.approvalComments = approvalComments;
    }

    public String getApprovalComments() 
    {
        return approvalComments;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("msdsId", getMsdsId())
            .append("stepNo", getStepNo())
            .append("stepName", getStepName())
            .append("approver", getApprover())
            .append("approvalStatus", getApprovalStatus())
            .append("approvalDate", getApprovalDate())
            .append("approvalComments", getApprovalComments())
            .append("createTime", getCreateTime())
            .toString();
    }
}