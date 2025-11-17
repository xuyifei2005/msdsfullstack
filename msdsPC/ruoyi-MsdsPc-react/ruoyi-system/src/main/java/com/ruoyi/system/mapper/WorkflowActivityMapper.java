package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.WorkflowActivity;

/**
 * 工作流活动日志 数据层
 * 
 * @author ruoyi
 * @date 2025-01-XX
 */
public interface WorkflowActivityMapper
{
    /**
     * 查询工作流活动日志
     * 
     * @param activityId 工作流活动日志主键
     * @return 工作流活动日志
     */
    public WorkflowActivity selectWorkflowActivityById(Long activityId);

    /**
     * 查询工作流活动日志列表
     * 
     * @param workflowActivity 工作流活动日志
     * @return 工作流活动日志集合
     */
    public List<WorkflowActivity> selectWorkflowActivityList(WorkflowActivity workflowActivity);

    /**
     * 根据任务ID查询活动日志列表
     * 
     * @param taskId 任务ID
     * @return 工作流活动日志集合
     */
    public List<WorkflowActivity> selectWorkflowActivityListByTaskId(Long taskId);

    /**
     * 新增工作流活动日志
     * 
     * @param workflowActivity 工作流活动日志
     * @return 结果
     */
    public int insertWorkflowActivity(WorkflowActivity workflowActivity);

    /**
     * 修改工作流活动日志
     * 
     * @param workflowActivity 工作流活动日志
     * @return 结果
     */
    public int updateWorkflowActivity(WorkflowActivity workflowActivity);

    /**
     * 删除工作流活动日志
     * 
     * @param activityId 工作流活动日志主键
     * @return 结果
     */
    public int deleteWorkflowActivityById(Long activityId);

    /**
     * 批量删除工作流活动日志
     * 
     * @param activityIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteWorkflowActivityByIds(Long[] activityIds);
}

