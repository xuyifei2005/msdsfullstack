package com.ruoyi.web.controller.system;

import java.util.List;
import java.util.Map;
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
import com.ruoyi.system.domain.MsdsAuditLog;
import com.ruoyi.system.service.IMsdsAuditLogService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * MSDS操作审计日志Controller
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
@RestController
@RequestMapping("/system/auditlog")
public class MsdsAuditLogController extends BaseController
{
    @Autowired
    private IMsdsAuditLogService msdsAuditLogService;

    /**
     * 查询MSDS操作审计日志列表
     */
    @PreAuthorize("@ss.hasPermi('system:auditlog:list')")
    @GetMapping("/list")
    public TableDataInfo list(MsdsAuditLog msdsAuditLog)
    {
        startPage();
        List<MsdsAuditLog> list = msdsAuditLogService.selectMsdsAuditLogList(msdsAuditLog);
        return getDataTable(list);
    }

    /**
     * 导出MSDS操作审计日志列表
     */
    @PreAuthorize("@ss.hasPermi('system:auditlog:export')")
    @Log(title = "MSDS操作审计日志", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, MsdsAuditLog msdsAuditLog)
    {
        List<MsdsAuditLog> list = msdsAuditLogService.selectMsdsAuditLogList(msdsAuditLog);
        ExcelUtil<MsdsAuditLog> util = new ExcelUtil<MsdsAuditLog>(MsdsAuditLog.class);
        util.exportExcel(response, list, "MSDS操作审计日志数据");
    }

    /**
     * 获取MSDS操作审计日志详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:auditlog:query')")
    @GetMapping(value = "/{logId}")
    public AjaxResult getInfo(@PathVariable("logId") Long logId)
    {
        return success(msdsAuditLogService.selectMsdsAuditLogByLogId(logId));
    }

    /**
     * 新增MSDS操作审计日志
     */
    @PreAuthorize("@ss.hasPermi('system:auditlog:add')")
    @Log(title = "MSDS操作审计日志", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody MsdsAuditLog msdsAuditLog)
    {
        return toAjax(msdsAuditLogService.insertMsdsAuditLog(msdsAuditLog));
    }

    /**
     * 修改MSDS操作审计日志
     */
    @PreAuthorize("@ss.hasPermi('system:auditlog:edit')")
    @Log(title = "MSDS操作审计日志", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody MsdsAuditLog msdsAuditLog)
    {
        return toAjax(msdsAuditLogService.updateMsdsAuditLog(msdsAuditLog));
    }

    /**
     * 删除MSDS操作审计日志
     */
    @PreAuthorize("@ss.hasPermi('system:auditlog:remove')")
    @Log(title = "MSDS操作审计日志", businessType = BusinessType.DELETE)
    @DeleteMapping("/{logIds}")
    public AjaxResult remove(@PathVariable Long[] logIds)
    {
        return toAjax(msdsAuditLogService.deleteMsdsAuditLogByLogIds(logIds));
    }

    /**
     * 根据MSDS ID查询操作日志
     */
    @PreAuthorize("@ss.hasPermi('system:auditlog:query')")
    @GetMapping("/msds/{msdsId}")
    public AjaxResult getMsdsLogs(@PathVariable("msdsId") Long msdsId)
    {
        List<MsdsAuditLog> logs = msdsAuditLogService.selectMsdsAuditLogByMsdsId(msdsId);
        return success(logs);
    }

    /**
     * 获取审计统计信息
     */
    @PreAuthorize("@ss.hasPermi('system:auditlog:query')")
    @GetMapping("/statistics")
    public AjaxResult getStatistics()
    {
        Map<String, Object> statistics = msdsAuditLogService.getAuditStatistics();
        return success(statistics);
    }

    /**
     * 获取操作类型分布统计
     */
    @PreAuthorize("@ss.hasPermi('system:auditlog:query')")
    @GetMapping("/operationTypes")
    public AjaxResult getOperationTypeStatistics()
    {
        Map<String, Object> statistics = msdsAuditLogService.getOperationTypeStatistics();
        return success(statistics);
    }

    /**
     * 获取操作人员活跃度统计
     */
    @PreAuthorize("@ss.hasPermi('system:auditlog:query')")
    @GetMapping("/operators")
    public AjaxResult getOperatorStatistics(Integer days)
    {
        if (days == null || days <= 0) {
            days = 30; // 默认30天
        }
        Map<String, Object> statistics = msdsAuditLogService.getOperatorStatistics(days);
        return success(statistics);
    }
}