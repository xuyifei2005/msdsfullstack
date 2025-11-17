package com.ruoyi.system.service;

import java.util.List;
import java.util.Map;
import com.ruoyi.system.domain.WorkflowTask;
import com.ruoyi.system.domain.WorkflowComment;
import com.ruoyi.system.domain.WorkflowActivity;

/**
 * 工作流任务 服务层
 * 
 * @author ruoyi
 * @date 2025-01-XX
 */
public interface IWorkflowTaskService
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
     * 获取工作流统计信息
     * 
     * @return 统计信息
     */
    public Map<String, Object> getWorkflowStatistics();

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
     * 批量删除工作流任务
     * 
     * @param taskIds 需要删除的工作流任务主键集合
     * @return 结果
     */
    public int deleteWorkflowTaskByIds(Long[] taskIds);

    /**
     * 删除工作流任务信息
     * 
     * @param taskId 工作流任务主键
     * @return 结果
     */
    public int deleteWorkflowTaskById(Long taskId);

    /**
     * 更新任务状态
     * 
     * @param taskId 任务ID
     * @param status 新状态
     * @param rejectionReason 拒绝原因（可选）
     * @return 结果
     */
    public int updateTaskStatus(Long taskId, String status, String rejectionReason);

    /**
     * 分配任务
     * 
     * @param taskId 任务ID
     * @param assigneeId 负责人ID
     * @param assigneeName 负责人姓名
     * @return 结果
     */
    public int assignTask(Long taskId, Long assigneeId, String assigneeName);

    /**
     * 获取任务的评论列表
     * 
     * @param taskId 任务ID
     * @return 评论列表
     */
    public List<WorkflowComment> getTaskComments(Long taskId);

    /**
     * 添加评论
     * 
     * @param comment 评论对象
     * @return 结果
     */
    public int addComment(WorkflowComment comment);

    /**
     * 获取任务的活动日志
     * 
     * @param taskId 任务ID
     * @return 活动日志列表
     */
    public List<WorkflowActivity> getTaskActivities(Long taskId);

    /**
     * 获取最近活动列表
     * 
     * @param limit 限制数量
     * @return 活动列表
     */
    public List<WorkflowActivity> getRecentActivities(int limit);
}

