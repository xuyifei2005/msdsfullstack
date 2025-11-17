package com.ruoyi.system.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.system.domain.WorkflowTask;
import com.ruoyi.system.domain.WorkflowComment;
import com.ruoyi.system.domain.WorkflowActivity;
import com.ruoyi.system.mapper.WorkflowTaskMapper;
import com.ruoyi.system.mapper.WorkflowCommentMapper;
import com.ruoyi.system.mapper.WorkflowActivityMapper;
import com.ruoyi.system.service.IWorkflowTaskService;

/**
 * 工作流任务 服务层实现
 * 
 * @author ruoyi
 * @date 2025-01-XX
 */
@Service
public class WorkflowTaskServiceImpl implements IWorkflowTaskService
{
    private static final Logger logger = LoggerFactory.getLogger(WorkflowTaskServiceImpl.class);
    
    @Autowired
    private WorkflowTaskMapper workflowTaskMapper;
    
    @Autowired
    private WorkflowCommentMapper workflowCommentMapper;
    
    @Autowired
    private WorkflowActivityMapper workflowActivityMapper;

    /**
     * 查询工作流任务
     * 
     * @param taskId 工作流任务主键
     * @return 工作流任务
     */
    @Override
    public WorkflowTask selectWorkflowTaskById(Long taskId)
    {
        return workflowTaskMapper.selectWorkflowTaskById(taskId);
    }

    /**
     * 查询工作流任务列表
     * 
     * @param workflowTask 工作流任务
     * @return 工作流任务
     */
    @Override
    public List<WorkflowTask> selectWorkflowTaskList(WorkflowTask workflowTask)
    {
        return workflowTaskMapper.selectWorkflowTaskList(workflowTask);
    }

    /**
     * 获取工作流统计信息
     * 
     * @return 统计信息
     */
    @Override
    public Map<String, Object> getWorkflowStatistics()
    {
        Map<String, Object> statistics = new HashMap<>();
        statistics.put("pending", workflowTaskMapper.countByStatus("pending"));
        statistics.put("reviewing", workflowTaskMapper.countByStatus("reviewing"));
        statistics.put("approved", workflowTaskMapper.countByStatus("approved"));
        statistics.put("rejected", workflowTaskMapper.countByStatus("rejected"));
        return statistics;
    }

    /**
     * 新增工作流任务
     * 
     * @param workflowTask 工作流任务
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertWorkflowTask(WorkflowTask workflowTask)
    {
        workflowTask.setCreateBy(SecurityUtils.getUsername());
        workflowTask.setCreateTime(DateUtils.getNowDate());
        if (workflowTask.getStatus() == null || workflowTask.getStatus().isEmpty())
        {
            workflowTask.setStatus("pending");
        }
        if (workflowTask.getPriority() == null || workflowTask.getPriority().isEmpty())
        {
            workflowTask.setPriority("normal");
        }
        if (workflowTask.getProgress() == null)
        {
            workflowTask.setProgress(0);
        }
        if (workflowTask.getAttachmentCount() == null)
        {
            workflowTask.setAttachmentCount(0);
        }
        if (workflowTask.getCommentCount() == null)
        {
            workflowTask.setCommentCount(0);
        }
        
        int result = workflowTaskMapper.insertWorkflowTask(workflowTask);
        
        // 记录活动日志
        if (result > 0 && workflowTask.getTaskId() != null)
        {
            WorkflowActivity activity = new WorkflowActivity();
            activity.setTaskId(workflowTask.getTaskId());
            activity.setUserId(SecurityUtils.getUserId());
            activity.setUserName(SecurityUtils.getUsername());
            activity.setActionType("create");
            activity.setActionDescription("创建了新任务：" + workflowTask.getTaskTitle());
            activity.setCreateTime(DateUtils.getNowDate());
            workflowActivityMapper.insertWorkflowActivity(activity);
        }
        
        return result;
    }

    /**
     * 修改工作流任务
     * 
     * @param workflowTask 工作流任务
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateWorkflowTask(WorkflowTask workflowTask)
    {
        workflowTask.setUpdateBy(SecurityUtils.getUsername());
        workflowTask.setUpdateTime(DateUtils.getNowDate());
        return workflowTaskMapper.updateWorkflowTask(workflowTask);
    }

    /**
     * 批量删除工作流任务
     * 
     * @param taskIds 需要删除的工作流任务主键
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteWorkflowTaskByIds(Long[] taskIds)
    {
        // 删除关联的评论和活动日志
        for (Long taskId : taskIds)
        {
            workflowCommentMapper.deleteWorkflowCommentByTaskId(taskId);
            // 活动日志可以保留，不删除
        }
        return workflowTaskMapper.deleteWorkflowTaskByIds(taskIds);
    }

    /**
     * 删除工作流任务信息
     * 
     * @param taskId 工作流任务主键
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteWorkflowTaskById(Long taskId)
    {
        workflowCommentMapper.deleteWorkflowCommentByTaskId(taskId);
        return workflowTaskMapper.deleteWorkflowTaskById(taskId);
    }

    /**
     * 更新任务状态
     * 
     * @param taskId 任务ID
     * @param status 新状态
     * @param rejectionReason 拒绝原因（可选）
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateTaskStatus(Long taskId, String status, String rejectionReason)
    {
        WorkflowTask task = workflowTaskMapper.selectWorkflowTaskById(taskId);
        if (task == null)
        {
            return 0;
        }
        
        String oldStatus = task.getStatus();
        task.setStatus(status);
        if (rejectionReason != null && !rejectionReason.isEmpty())
        {
            task.setRejectionReason(rejectionReason);
        }
        if ("approved".equals(status))
        {
            task.setProgress(100);
        }
        task.setUpdateBy(SecurityUtils.getUsername());
        task.setUpdateTime(DateUtils.getNowDate());
        
        int result = workflowTaskMapper.updateWorkflowTask(task);
        
        // 记录活动日志
        if (result > 0)
        {
            WorkflowActivity activity = new WorkflowActivity();
            activity.setTaskId(taskId);
            activity.setUserId(SecurityUtils.getUserId());
            activity.setUserName(SecurityUtils.getUsername());
            activity.setActionType("status_change");
            activity.setActionDescription("任务状态变更为" + getStatusName(status));
            activity.setOldValue(oldStatus);
            activity.setNewValue(status);
            activity.setCreateTime(DateUtils.getNowDate());
            workflowActivityMapper.insertWorkflowActivity(activity);
            
            // 如果是通过或拒绝，记录额外日志
            if ("approved".equals(status))
            {
                WorkflowActivity approveActivity = new WorkflowActivity();
                approveActivity.setTaskId(taskId);
                approveActivity.setUserId(SecurityUtils.getUserId());
                approveActivity.setUserName(SecurityUtils.getUsername());
                approveActivity.setActionType("approve");
                approveActivity.setActionDescription("审核通过");
                approveActivity.setCreateTime(DateUtils.getNowDate());
                workflowActivityMapper.insertWorkflowActivity(approveActivity);
            }
            else if ("rejected".equals(status))
            {
                WorkflowActivity rejectActivity = new WorkflowActivity();
                rejectActivity.setTaskId(taskId);
                rejectActivity.setUserId(SecurityUtils.getUserId());
                rejectActivity.setUserName(SecurityUtils.getUsername());
                rejectActivity.setActionType("reject");
                rejectActivity.setActionDescription("拒绝任务");
                rejectActivity.setNewValue(rejectionReason);
                rejectActivity.setCreateTime(DateUtils.getNowDate());
                workflowActivityMapper.insertWorkflowActivity(rejectActivity);
            }
        }
        
        return result;
    }

    /**
     * 分配任务
     * 
     * @param taskId 任务ID
     * @param assigneeId 负责人ID
     * @param assigneeName 负责人姓名
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int assignTask(Long taskId, Long assigneeId, String assigneeName)
    {
        WorkflowTask task = workflowTaskMapper.selectWorkflowTaskById(taskId);
        if (task == null)
        {
            return 0;
        }
        
        task.setAssigneeId(assigneeId);
        task.setAssigneeName(assigneeName);
        task.setUpdateBy(SecurityUtils.getUsername());
        task.setUpdateTime(DateUtils.getNowDate());
        
        int result = workflowTaskMapper.updateWorkflowTask(task);
        
        // 记录活动日志
        if (result > 0)
        {
            WorkflowActivity activity = new WorkflowActivity();
            activity.setTaskId(taskId);
            activity.setUserId(SecurityUtils.getUserId());
            activity.setUserName(SecurityUtils.getUsername());
            activity.setActionType("assign");
            activity.setActionDescription("将任务分配给" + assigneeName);
            activity.setNewValue(assigneeName);
            activity.setCreateTime(DateUtils.getNowDate());
            workflowActivityMapper.insertWorkflowActivity(activity);
        }
        
        return result;
    }

    /**
     * 获取任务的评论列表
     * 
     * @param taskId 任务ID
     * @return 评论列表
     */
    @Override
    public List<WorkflowComment> getTaskComments(Long taskId)
    {
        return workflowCommentMapper.selectWorkflowCommentListByTaskId(taskId);
    }

    /**
     * 添加评论
     * 
     * @param comment 评论对象
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int addComment(WorkflowComment comment)
    {
        comment.setUserId(SecurityUtils.getUserId());
        comment.setUserName(SecurityUtils.getUsername());
        comment.setCreateBy(SecurityUtils.getUsername());
        comment.setCreateTime(DateUtils.getNowDate());
        
        int result = workflowCommentMapper.insertWorkflowComment(comment);
        
        // 更新任务的评论数量
        if (result > 0)
        {
            WorkflowTask task = workflowTaskMapper.selectWorkflowTaskById(comment.getTaskId());
            if (task != null)
            {
                task.setCommentCount((task.getCommentCount() == null ? 0 : task.getCommentCount()) + 1);
                workflowTaskMapper.updateWorkflowTask(task);
            }
            
            // 记录活动日志
            WorkflowActivity activity = new WorkflowActivity();
            activity.setTaskId(comment.getTaskId());
            activity.setUserId(SecurityUtils.getUserId());
            activity.setUserName(SecurityUtils.getUsername());
            activity.setActionType("comment");
            activity.setActionDescription("添加了评论");
            activity.setCreateTime(DateUtils.getNowDate());
            workflowActivityMapper.insertWorkflowActivity(activity);
        }
        
        return result;
    }

    /**
     * 获取任务的活动日志
     * 
     * @param taskId 任务ID
     * @return 活动日志列表
     */
    @Override
    public List<WorkflowActivity> getTaskActivities(Long taskId)
    {
        return workflowActivityMapper.selectWorkflowActivityListByTaskId(taskId);
    }

    /**
     * 获取最近活动列表
     * 
     * @param limit 限制数量
     * @return 活动列表
     */
    @Override
    public List<WorkflowActivity> getRecentActivities(int limit)
    {
        WorkflowActivity query = new WorkflowActivity();
        List<WorkflowActivity> activities = workflowActivityMapper.selectWorkflowActivityList(query);
        if (activities.size() > limit)
        {
            return activities.subList(0, limit);
        }
        return activities;
    }

    /**
     * 获取状态名称
     */
    private String getStatusName(String status)
    {
        switch (status)
        {
            case "pending":
                return "待处理";
            case "reviewing":
                return "审核中";
            case "approved":
                return "已通过";
            case "rejected":
                return "已拒绝";
            default:
                return status;
        }
    }
}

