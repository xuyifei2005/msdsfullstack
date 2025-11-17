package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.WorkflowTask;

/**
 * 工作流任务 数据层
 * 
 * @author ruoyi
 * @date 2025-01-XX
 */
public interface WorkflowTaskMapper
{
    /**
     * 查询工作流任务
     * 
     * @param taskId 工作流任务主键
     * @return 工作流任务
     */
    public WorkflowTask selectWorkflowTaskById(Long taskId);

    /**
     * 查询工作流任务列表
     * 
     * @param workflowTask 工作流任务
     * @return 工作流任务集合
     */
    public List<WorkflowTask> selectWorkflowTaskList(WorkflowTask workflowTask);

    /**
     * 根据状态统计任务数量
     * 
     * @param status 任务状态
     * @return 任务数量
     */
    public int countByStatus(String status);

    /**
     * 新增工作流任务
     * 
     * @param workflowTask 工作流任务
     * @return 结果
     */
    public int insertWorkflowTask(WorkflowTask workflowTask);

    /**
     * 修改工作流任务
     * 
     * @param workflowTask 工作流任务
     * @return 结果
     */
    public int updateWorkflowTask(WorkflowTask workflowTask);

    /**
     * 删除工作流任务
     * 
     * @param taskId 工作流任务主键
     * @return 结果
     */
    public int deleteWorkflowTaskById(Long taskId);

    /**
     * 批量删除工作流任务
     * 
     * @param taskIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteWorkflowTaskByIds(Long[] taskIds);
}

