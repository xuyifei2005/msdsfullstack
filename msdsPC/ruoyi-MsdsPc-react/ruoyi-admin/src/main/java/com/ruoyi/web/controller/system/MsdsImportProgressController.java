package com.ruoyi.web.controller.system;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.MsdsImportProgress;
import com.ruoyi.system.service.IMsdsImportProgressService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.ServletUtils;
import com.ruoyi.common.utils.ip.IpUtils;

/**
 * MSDS导入进度Controller
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
@RestController
@RequestMapping("/system/msds/import/progress")
public class MsdsImportProgressController extends BaseController
{
    @Autowired
    private IMsdsImportProgressService msdsImportProgressService;

    /**
     * 查询MSDS导入进度列表
     */
    @PreAuthorize("@ss.hasPermi('system:msds:import:list')")
    @GetMapping("/list")
    public TableDataInfo list(MsdsImportProgress msdsImportProgress)
    {
        startPage();
        List<MsdsImportProgress> list = msdsImportProgressService.selectMsdsImportProgressList(msdsImportProgress);
        return getDataTable(list);
    }
    
    /**
     * 查询当前用户的导入进度列表
     */
    @GetMapping("/my")
    public AjaxResult myProgress()
    {
        Long userId = SecurityUtils.getUserId();
        List<MsdsImportProgress> list = msdsImportProgressService.selectMsdsImportProgressByUserId(userId);
        return AjaxResult.success(list);
    }
    
    /**
     * 根据任务ID查询导入进度
     */
    @GetMapping("/task/{taskId}")
    public AjaxResult getByTaskId(@PathVariable("taskId") String taskId)
    {
        // 检查权限：只能查询自己的任务或管理员权限
        MsdsImportProgress progress = msdsImportProgressService.selectMsdsImportProgressByTaskId(taskId);
        if (progress == null) {
            return AjaxResult.error("任务不存在");
        }
        
        Long currentUserId = SecurityUtils.getUserId();
        if (!progress.getUserId().equals(currentUserId) && !SecurityUtils.isAdmin(currentUserId)) {
            return AjaxResult.error("无权限查看此任务");
        }
        
        return AjaxResult.success(progress);
    }
    
    /**
     * 查询正在处理的任务（管理员权限）
     */
    @PreAuthorize("@ss.hasPermi('system:msds:import:monitor')")
    @GetMapping("/processing")
    public AjaxResult getProcessingTasks()
    {
        List<MsdsImportProgress> list = msdsImportProgressService.selectProcessingTasks();
        return AjaxResult.success(list);
    }
    
    /**
     * 查询超时任务（管理员权限）
     */
    @PreAuthorize("@ss.hasPermi('system:msds:import:monitor')")
    @GetMapping("/timeout/{minutes}")
    public AjaxResult getTimeoutTasks(@PathVariable("minutes") Integer minutes)
    {
        List<MsdsImportProgress> list = msdsImportProgressService.selectTimeoutTasks(minutes);
        return AjaxResult.success(list);
    }
    
    /**
     * 统计任务数量
     */
    @GetMapping("/count")
    public AjaxResult getTaskCount()
    {
        Long userId = SecurityUtils.getUserId();
        
        int totalTasks = msdsImportProgressService.countUserTasks(userId, null);
        int processingTasks = msdsImportProgressService.countUserTasks(userId, 
                MsdsImportProgress.Status.PROCESSING.getCode());
        int waitingTasks = msdsImportProgressService.countUserTasks(userId, 
                MsdsImportProgress.Status.WAITING.getCode());
        
        AjaxResult result = AjaxResult.success();
        result.put("total", totalTasks);
        result.put("processing", processingTasks);
        result.put("waiting", waitingTasks);
        
        return result;
    }
    
    /**
     * 系统任务统计（管理员权限）
     */
    @PreAuthorize("@ss.hasPermi('system:msds:import:monitor')")
    @GetMapping("/system/count")
    public AjaxResult getSystemTaskCount()
    {
        int totalTasks = msdsImportProgressService.countSystemTasks(null);
        int processingTasks = msdsImportProgressService.countSystemTasks(
                MsdsImportProgress.Status.PROCESSING.getCode());
        int waitingTasks = msdsImportProgressService.countSystemTasks(
                MsdsImportProgress.Status.WAITING.getCode());
        
        AjaxResult result = AjaxResult.success();
        result.put("total", totalTasks);
        result.put("processing", processingTasks);
        result.put("waiting", waitingTasks);
        
        return result;
    }

    /**
     * 导出MSDS导入进度列表
     */
    @PreAuthorize("@ss.hasPermi('system:msds:import:export')")
    @Log(title = "MSDS导入进度", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, MsdsImportProgress msdsImportProgress)
    {
        List<MsdsImportProgress> list = msdsImportProgressService.selectMsdsImportProgressList(msdsImportProgress);
        ExcelUtil<MsdsImportProgress> util = new ExcelUtil<MsdsImportProgress>(MsdsImportProgress.class);
        util.exportExcel(response, list, "MSDS导入进度数据");
    }

    /**
     * 获取MSDS导入进度详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:msds:import:query')")
    @GetMapping(value = "/{progressId}")
    public AjaxResult getInfo(@PathVariable("progressId") Long progressId)
    {
        MsdsImportProgress progress = msdsImportProgressService.selectMsdsImportProgressByProgressId(progressId);
        
        // 检查权限：只能查询自己的任务或管理员权限
        Long currentUserId = SecurityUtils.getUserId();
        if (progress != null && !progress.getUserId().equals(currentUserId) && !SecurityUtils.isAdmin(currentUserId)) {
            return AjaxResult.error("无权限查看此任务");
        }
        
        return AjaxResult.success(progress);
    }

    /**
     * 修改MSDS导入进度
     */
    @PreAuthorize("@ss.hasPermi('system:msds:import:edit')")
    @Log(title = "MSDS导入进度", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody MsdsImportProgress msdsImportProgress)
    {
        // 检查权限：只能修改自己的任务或管理员权限
        Long currentUserId = SecurityUtils.getUserId();
        MsdsImportProgress existingProgress = msdsImportProgressService.selectMsdsImportProgressByProgressId(
                msdsImportProgress.getProgressId());
        
        if (existingProgress != null && !existingProgress.getUserId().equals(currentUserId) 
                && !SecurityUtils.isAdmin(currentUserId)) {
            return AjaxResult.error("无权限修改此任务");
        }
        
        return toAjax(msdsImportProgressService.updateMsdsImportProgress(msdsImportProgress));
    }
    
    /**
     * 取消任务
     */
    @PostMapping("/cancel/{taskId}")
    public AjaxResult cancelTask(@PathVariable("taskId") String taskId)
    {
        // 检查权限：只能取消自己的任务或管理员权限
        MsdsImportProgress progress = msdsImportProgressService.selectMsdsImportProgressByTaskId(taskId);
        if (progress == null) {
            return AjaxResult.error("任务不存在");
        }
        
        Long currentUserId = SecurityUtils.getUserId();
        if (!progress.getUserId().equals(currentUserId) && !SecurityUtils.isAdmin(currentUserId)) {
            return AjaxResult.error("无权限取消此任务");
        }
        
        // 只能取消等待中或进行中的任务
        if (progress.getStatus() != MsdsImportProgress.Status.WAITING.getCode() 
                && progress.getStatus() != MsdsImportProgress.Status.PROCESSING.getCode()) {
            return AjaxResult.error("任务状态不允许取消");
        }
        
        String reason = "用户主动取消";
        return toAjax(msdsImportProgressService.cancelTask(taskId, reason));
    }

    /**
     * 删除MSDS导入进度
     */
    @PreAuthorize("@ss.hasPermi('system:msds:import:remove')")
    @Log(title = "MSDS导入进度", businessType = BusinessType.DELETE)
    @DeleteMapping("/{progressIds}")
    public AjaxResult remove(@PathVariable Long[] progressIds)
    {
        // 检查权限：只能删除自己的任务或管理员权限
        Long currentUserId = SecurityUtils.getUserId();
        if (!SecurityUtils.isAdmin(currentUserId)) {
            for (Long progressId : progressIds) {
                MsdsImportProgress progress = msdsImportProgressService.selectMsdsImportProgressByProgressId(progressId);
                if (progress != null && !progress.getUserId().equals(currentUserId)) {
                    return AjaxResult.error("无权限删除他人的任务记录");
                }
            }
        }
        
        return toAjax(msdsImportProgressService.deleteMsdsImportProgressByProgressIds(progressIds));
    }
    
    /**
     * 清理过期记录（管理员权限）
     */
    @PreAuthorize("@ss.hasPermi('system:msds:import:clean')")
    @Log(title = "MSDS导入进度", businessType = BusinessType.CLEAN)
    @DeleteMapping("/clean/{days}")
    public AjaxResult cleanExpired(@PathVariable("days") Integer days)
    {
        if (days == null || days < 1) {
            return AjaxResult.error("保留天数必须大于0");
        }
        
        int cleanedCount = msdsImportProgressService.cleanExpiredProgress(days);
        return AjaxResult.success("已清理 " + cleanedCount + " 条过期记录");
    }
    
    /**
     * 检查用户是否有正在进行的任务
     */
    @GetMapping("/check/processing")
    public AjaxResult checkProcessingTask()
    {
        Long userId = SecurityUtils.getUserId();
        boolean hasProcessing = msdsImportProgressService.hasProcessingTask(userId);
        
        AjaxResult result = AjaxResult.success();
        result.put("hasProcessing", hasProcessing);
        
        return result;
    }
}