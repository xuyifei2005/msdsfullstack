package com.ruoyi.system.domain;

import java.util.Date;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.annotation.Excel.ColumnType;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 工作流任务对象 workflow_task
 * 
 * @author ruoyi
 * @date 2025-01-XX
 */
public class WorkflowTask extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 任务ID */
    @Excel(name = "任务ID", cellType = ColumnType.NUMERIC)
    private Long taskId;

    /** 任务标题 */
    @Excel(name = "任务标题")
    private String taskTitle;

    /** 任务描述 */
    @Excel(name = "任务描述")
    private String taskDescription;

    /** 任务类型 */
    @Excel(name = "任务类型", readConverterExp = "msds_review=MSDS审核,msds_update=MSDS更新,msds_format=MSDS格式规范")
    private String taskType;

    /** 任务状态 */
    @Excel(name = "任务状态", readConverterExp = "pending=待处理,reviewing=审核中,approved=已通过,rejected=已拒绝")
    private String status;

    /** 优先级 */
    @Excel(name = "优先级", readConverterExp = "urgent=紧急,normal=普通,low=低")
    private String priority;

    /** 负责人ID */
    private Long assigneeId;

    /** 负责人姓名 */
    @Excel(name = "负责人")
    private String assigneeName;

    /** 创建人ID */
    private Long creatorId;

    /** 创建人姓名 */
    @Excel(name = "创建人")
    private String creatorName;

    /** 关联的MSDS ID */
    private Long msdsId;

    /** 关联的MSDS名称 */
    @Excel(name = "MSDS名称")
    private String msdsName;

    /** 截止日期 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "截止日期", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date dueDate;

    /** 进度百分比 */
    @Excel(name = "进度", cellType = ColumnType.NUMERIC)
    private Integer progress;

    /** 附件数量 */
    private Integer attachmentCount;

    /** 评论数量 */
    private Integer commentCount;

    /** 审核人ID列表 */
    private String reviewerIds;

    /** 审核人姓名列表 */
    private String reviewerNames;

    /** 拒绝原因 */
    private String rejectionReason;

    public void setTaskId(Long taskId) 
    {
        this.taskId = taskId;
    }

    public Long getTaskId() 
    {
        return taskId;
    }

    public void setTaskTitle(String taskTitle) 
    {
        this.taskTitle = taskTitle;
    }

    public String getTaskTitle() 
    {
        return taskTitle;
    }

    public void setTaskDescription(String taskDescription) 
    {
        this.taskDescription = taskDescription;
    }

    public String getTaskDescription() 
    {
        return taskDescription;
    }

    public void setTaskType(String taskType) 
    {
        this.taskType = taskType;
    }

    public String getTaskType() 
    {
        return taskType;
    }

    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }

    public void setPriority(String priority) 
    {
        this.priority = priority;
    }

    public String getPriority() 
    {
        return priority;
    }

    public void setAssigneeId(Long assigneeId) 
    {
        this.assigneeId = assigneeId;
    }

    public Long getAssigneeId() 
    {
        return assigneeId;
    }

    public void setAssigneeName(String assigneeName) 
    {
        this.assigneeName = assigneeName;
    }

    public String getAssigneeName() 
    {
        return assigneeName;
    }

    public void setCreatorId(Long creatorId) 
    {
        this.creatorId = creatorId;
    }

    public Long getCreatorId() 
    {
        return creatorId;
    }

    public void setCreatorName(String creatorName) 
    {
        this.creatorName = creatorName;
    }

    public String getCreatorName() 
    {
        return creatorName;
    }

    public void setMsdsId(Long msdsId) 
    {
        this.msdsId = msdsId;
    }

    public Long getMsdsId() 
    {
        return msdsId;
    }

    public void setMsdsName(String msdsName) 
    {
        this.msdsName = msdsName;
    }

    public String getMsdsName() 
    {
        return msdsName;
    }

    public void setDueDate(Date dueDate) 
    {
        this.dueDate = dueDate;
    }

    public Date getDueDate() 
    {
        return dueDate;
    }

    public void setProgress(Integer progress) 
    {
        this.progress = progress;
    }

    public Integer getProgress() 
    {
        return progress;
    }

    public void setAttachmentCount(Integer attachmentCount) 
    {
        this.attachmentCount = attachmentCount;
    }

    public Integer getAttachmentCount() 
    {
        return attachmentCount;
    }

    public void setCommentCount(Integer commentCount) 
    {
        this.commentCount = commentCount;
    }

    public Integer getCommentCount() 
    {
        return commentCount;
    }

    public void setReviewerIds(String reviewerIds) 
    {
        this.reviewerIds = reviewerIds;
    }

    public String getReviewerIds() 
    {
        return reviewerIds;
    }

    public void setReviewerNames(String reviewerNames) 
    {
        this.reviewerNames = reviewerNames;
    }

    public String getReviewerNames() 
    {
        return reviewerNames;
    }

    public void setRejectionReason(String rejectionReason) 
    {
        this.rejectionReason = rejectionReason;
    }

    public String getRejectionReason() 
    {
        return rejectionReason;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("taskId", getTaskId())
            .append("taskTitle", getTaskTitle())
            .append("taskDescription", getTaskDescription())
            .append("taskType", getTaskType())
            .append("status", getStatus())
            .append("priority", getPriority())
            .append("assigneeId", getAssigneeId())
            .append("assigneeName", getAssigneeName())
            .append("creatorId", getCreatorId())
            .append("creatorName", getCreatorName())
            .append("msdsId", getMsdsId())
            .append("msdsName", getMsdsName())
            .append("dueDate", getDueDate())
            .append("progress", getProgress())
            .append("attachmentCount", getAttachmentCount())
            .append("commentCount", getCommentCount())
            .append("reviewerIds", getReviewerIds())
            .append("reviewerNames", getReviewerNames())
            .append("rejectionReason", getRejectionReason())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}

