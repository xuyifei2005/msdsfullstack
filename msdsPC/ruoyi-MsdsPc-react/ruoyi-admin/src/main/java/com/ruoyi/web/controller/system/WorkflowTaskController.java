package com.ruoyi.web.controller.system;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.WorkflowTask;
import com.ruoyi.system.domain.WorkflowComment;
import com.ruoyi.system.domain.WorkflowActivity;
import com.ruoyi.system.service.IWorkflowTaskService;

/**
 * 工作流任务 信息操作处理
 * 
 * @author ruoyi
 * @date 2025-01-XX
 */
@RestController
@RequestMapping("/system/workflow")
public class WorkflowTaskController extends BaseController
{
    @Autowired
    private IWorkflowTaskService workflowTaskService;

    /**
     * 查询工作流任务列表
     */
    @PreAuthorize("@ss.hasPermi('system:workflow:list')")
    @GetMapping("/list")
    public TableDataInfo list(WorkflowTask workflowTask)
    {
        startPage();
        List<WorkflowTask> list = workflowTaskService.selectWorkflowTaskList(workflowTask);
        return getDataTable(list);
    }

    /**
     * 获取工作流统计信息
     */
    @PreAuthorize("@ss.hasPermi('system:workflow:list')")
    @GetMapping("/statistics")
    public AjaxResult getStatistics()
    {
        Map<String, Object> statistics = workflowTaskService.getWorkflowStatistics();
        return success(statistics);
    }

    /**
     * 根据任务ID获取详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:workflow:query')")
    @GetMapping(value = "/{taskId}")
    public AjaxResult getInfo(@PathVariable("taskId") Long taskId)
    {
        WorkflowTask task = workflowTaskService.selectWorkflowTaskById(taskId);
        if (task != null)
        {
            // 获取评论列表
            List<WorkflowComment> comments = workflowTaskService.getTaskComments(taskId);
            // 获取活动日志
            List<WorkflowActivity> activities = workflowTaskService.getTaskActivities(taskId);
            
            Map<String, Object> result = new java.util.HashMap<>();
            result.put("task", task);
            result.put("comments", comments);
            result.put("activities", activities);
            return success(result);
        }
        return success(task);
    }

    /**
     * 新增工作流任务
     */
    @PreAuthorize("@ss.hasPermi('system:workflow:add')")
    @Log(title = "工作流任务", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody WorkflowTask workflowTask)
    {
        return toAjax(workflowTaskService.insertWorkflowTask(workflowTask));
    }

    /**
     * 修改工作流任务
     */
    @PreAuthorize("@ss.hasPermi('system:workflow:edit')")
    @Log(title = "工作流任务", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody WorkflowTask workflowTask)
    {
        return toAjax(workflowTaskService.updateWorkflowTask(workflowTask));
    }

    /**
     * 删除工作流任务
     */
    @PreAuthorize("@ss.hasPermi('system:workflow:remove')")
    @Log(title = "工作流任务", businessType = BusinessType.DELETE)
    @DeleteMapping("/{taskIds}")
    public AjaxResult remove(@PathVariable Long[] taskIds)
    {
        return toAjax(workflowTaskService.deleteWorkflowTaskByIds(taskIds));
    }

    /**
     * 更新任务状态
     */
    @PreAuthorize("@ss.hasPermi('system:workflow:edit')")
    @Log(title = "工作流任务", businessType = BusinessType.UPDATE)
    @PutMapping("/status")
    public AjaxResult updateStatus(@RequestBody Map<String, Object> params)
    {
        Long taskId = Long.valueOf(params.get("taskId").toString());
        String status = params.get("status").toString();
        String rejectionReason = params.containsKey("rejectionReason") ? params.get("rejectionReason").toString() : null;
        return toAjax(workflowTaskService.updateTaskStatus(taskId, status, rejectionReason));
    }

    /**
     * 分配任务
     */
    @PreAuthorize("@ss.hasPermi('system:workflow:edit')")
    @Log(title = "工作流任务", businessType = BusinessType.UPDATE)
    @PutMapping("/assign")
    public AjaxResult assignTask(@RequestBody Map<String, Object> params)
    {
        Long taskId = Long.valueOf(params.get("taskId").toString());
        Long assigneeId = Long.valueOf(params.get("assigneeId").toString());
        String assigneeName = params.get("assigneeName").toString();
        return toAjax(workflowTaskService.assignTask(taskId, assigneeId, assigneeName));
    }

    /**
     * 获取任务的评论列表
     */
    @PreAuthorize("@ss.hasPermi('system:workflow:query')")
    @GetMapping("/{taskId}/comments")
    public AjaxResult getComments(@PathVariable("taskId") Long taskId)
    {
        List<WorkflowComment> comments = workflowTaskService.getTaskComments(taskId);
        return success(comments);
    }

    /**
     * 添加评论
     */
    @PreAuthorize("@ss.hasPermi('system:workflow:edit')")
    @Log(title = "工作流评论", businessType = BusinessType.INSERT)
    @PostMapping("/comment")
    public AjaxResult addComment(@Validated @RequestBody WorkflowComment comment)
    {
        return toAjax(workflowTaskService.addComment(comment));
    }

    /**
     * 获取任务的活动日志
     */
    @PreAuthorize("@ss.hasPermi('system:workflow:query')")
    @GetMapping("/{taskId}/activities")
    public AjaxResult getActivities(@PathVariable("taskId") Long taskId)
    {
        List<WorkflowActivity> activities = workflowTaskService.getTaskActivities(taskId);
        return success(activities);
    }

    /**
     * 获取最近活动列表
     */
    @PreAuthorize("@ss.hasPermi('system:workflow:list')")
    @GetMapping("/recent-activities")
    public AjaxResult getRecentActivities()
    {
        List<WorkflowActivity> activities = workflowTaskService.getRecentActivities(10);
        return success(activities);
    }
}

