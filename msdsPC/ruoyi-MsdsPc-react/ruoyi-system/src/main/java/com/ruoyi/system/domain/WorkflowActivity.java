package com.ruoyi.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;

/**
 * 工作流活动日志对象 workflow_activity
 * 
 * @author ruoyi
 * @date 2025-01-XX
 */
public class WorkflowActivity
{
    /** 活动ID */
    private Long activityId;

    /** 任务ID */
    private Long taskId;

    /** 操作用户ID */
    private Long userId;

    /** 操作用户姓名 */
    @Excel(name = "操作用户")
    private String userName;

    /** 操作类型 */
    @Excel(name = "操作类型")
    private String actionType;

    /** 操作描述 */
    @Excel(name = "操作描述")
    private String actionDescription;

    /** 旧值 */
    private String oldValue;

    /** 新值 */
    private String newValue;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "创建时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    public void setActivityId(Long activityId) 
    {
        this.activityId = activityId;
    }

    public Long getActivityId() 
    {
        return activityId;
    }

    public void setTaskId(Long taskId) 
    {
        this.taskId = taskId;
    }

    public Long getTaskId() 
    {
        return taskId;
    }

    public void setUserId(Long userId) 
    {
        this.userId = userId;
    }

    public Long getUserId() 
    {
        return userId;
    }

    public void setUserName(String userName) 
    {
        this.userName = userName;
    }

    public String getUserName() 
    {
        return userName;
    }

    public void setActionType(String actionType) 
    {
        this.actionType = actionType;
    }

    public String getActionType() 
    {
        return actionType;
    }

    public void setActionDescription(String actionDescription) 
    {
        this.actionDescription = actionDescription;
    }

    public String getActionDescription() 
    {
        return actionDescription;
    }

    public void setOldValue(String oldValue) 
    {
        this.oldValue = oldValue;
    }

    public String getOldValue() 
    {
        return oldValue;
    }

    public void setNewValue(String newValue) 
    {
        this.newValue = newValue;
    }

    public String getNewValue() 
    {
        return newValue;
    }

    public void setCreateTime(Date createTime) 
    {
        this.createTime = createTime;
    }

    public Date getCreateTime() 
    {
        return createTime;
    }
}

