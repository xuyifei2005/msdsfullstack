package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.WorkflowComment;

/**
 * 工作流评论 数据层
 * 
 * @author ruoyi
 * @date 2025-01-XX
 */
public interface WorkflowCommentMapper
{
    /**
     * 查询工作流评论
     * 
     * @param commentId 工作流评论主键
     * @return 工作流评论
     */
    public WorkflowComment selectWorkflowCommentById(Long commentId);

    /**
     * 查询工作流评论列表
     * 
     * @param workflowComment 工作流评论
     * @return 工作流评论集合
     */
    public List<WorkflowComment> selectWorkflowCommentList(WorkflowComment workflowComment);

    /**
     * 根据任务ID查询评论列表
     * 
     * @param taskId 任务ID
     * @return 工作流评论集合
     */
    public List<WorkflowComment> selectWorkflowCommentListByTaskId(Long taskId);

    /**
     * 新增工作流评论
     * 
     * @param workflowComment 工作流评论
     * @return 结果
     */
    public int insertWorkflowComment(WorkflowComment workflowComment);

    /**
     * 修改工作流评论
     * 
     * @param workflowComment 工作流评论
     * @return 结果
     */
    public int updateWorkflowComment(WorkflowComment workflowComment);

    /**
     * 删除工作流评论
     * 
     * @param commentId 工作流评论主键
     * @return 结果
     */
    public int deleteWorkflowCommentById(Long commentId);

    /**
     * 批量删除工作流评论
     * 
     * @param commentIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteWorkflowCommentByIds(Long[] commentIds);

    /**
     * 根据任务ID删除评论
     * 
     * @param taskId 任务ID
     * @return 结果
     */
    public int deleteWorkflowCommentByTaskId(Long taskId);
}

