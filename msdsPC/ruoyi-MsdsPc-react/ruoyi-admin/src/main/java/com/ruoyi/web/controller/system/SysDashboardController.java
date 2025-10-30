package com.ruoyi.web.controller.system;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.service.ISysDashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 仪表板统计数据Controller
 * 
 * @author ruoyi
 * @date 2024-12-19
 */
@RestController
@RequestMapping("/system/dashboard")
public class SysDashboardController extends BaseController
{
    @Autowired
    private ISysDashboardService dashboardService;

    /**
     * 获取仪表板概览数据
     */
    @PreAuthorize("@ss.hasPermi('system:dashboard:overview')")
    @GetMapping("/overview")
    public AjaxResult getOverview()
    {
        Map<String, Object> overview = new HashMap<>();
        
        // 获取文档统计
        Map<String, Object> documentStats = dashboardService.getDocumentStats();
        overview.put("documentStats", documentStats);
        
        // 获取访问统计
        Map<String, Object> accessStats = dashboardService.getAccessStats();
        overview.put("accessStats", accessStats);
        
        // 获取下载统计
        Map<String, Object> downloadStats = dashboardService.getDownloadStats();
        overview.put("downloadStats", downloadStats);
        
        // 获取系统统计
        Map<String, Object> systemStats = dashboardService.getSystemStats();
        overview.put("systemStats", systemStats);
        
        // 获取化学品统计
        Map<String, Object> chemicalStats = dashboardService.getChemicalStats();
        overview.put("chemicalStats", chemicalStats);
        
        return success(overview);
    }

    /**
     * 获取访问趋势数据
     */
    @PreAuthorize("@ss.hasPermi('system:dashboard:trend')")
    @GetMapping("/access-trend")
    public AjaxResult getAccessTrend(@RequestParam String startDate, 
                                   @RequestParam String endDate,
                                   @RequestParam(defaultValue = "visits") String metricType)
    {
        List<Map<String, Object>> trendData = dashboardService.getAccessTrendData(startDate, endDate, metricType);
        return success(trendData);
    }

    /**
     * 获取用户活动数据
     */
    @PreAuthorize("@ss.hasPermi('system:dashboard:activity')")
    @GetMapping("/user-activity")
    public AjaxResult getUserActivity()
    {
        List<Map<String, Object>> activityData = dashboardService.getUserActivityData();
        return success(activityData);
    }

    /**
     * 获取下载分析数据
     */
    @PreAuthorize("@ss.hasPermi('system:dashboard:download')")
    @GetMapping("/download-analytics")
    public AjaxResult getDownloadAnalytics(@RequestParam(defaultValue = "30d") String timeRange)
    {
        List<Map<String, Object>> downloadData = dashboardService.getDownloadAnalyticsData(timeRange);
        return success(downloadData);
    }

    /**
     * 获取热门文档排行
     */
    @PreAuthorize("@ss.hasPermi('system:dashboard:hot')")
    @GetMapping("/hot-documents")
    public AjaxResult getHotDocuments(@RequestParam(defaultValue = "views") String sortBy)
    {
        List<Map<String, Object>> hotDocuments = dashboardService.getHotDocumentsData(sortBy);
        return success(hotDocuments);
    }

    /**
     * 获取实时统计数据
     */
    @PreAuthorize("@ss.hasPermi('system:dashboard:realtime')")
    @GetMapping("/realtime-stats")
    public AjaxResult getRealtimeStats()
    {
        Map<String, Object> realtimeStats = dashboardService.getRealtimeStats();
        return success(realtimeStats);
    }

    /**
     * 获取文档统计数据
     */
    @PreAuthorize("@ss.hasPermi('system:dashboard:document')")
    @GetMapping("/document-stats")
    public AjaxResult getDocumentStats()
    {
        Map<String, Object> documentStats = dashboardService.getDocumentStats();
        return success(documentStats);
    }

    /**
     * 获取系统健康监控数据
     */
    @PreAuthorize("@ss.hasPermi('system:dashboard:health')")
    @GetMapping("/system-health")
    public AjaxResult getSystemHealth()
    {
        Map<String, Object> systemHealth = dashboardService.getSystemHealthData();
        return success(systemHealth);
    }

    /**
     * 获取化学品统计数据
     */
    @PreAuthorize("@ss.hasPermi('system:dashboard:chemical')")
    @GetMapping("/chemical-stats")
    public AjaxResult getChemicalStats()
    {
        Map<String, Object> chemicalStats = dashboardService.getChemicalStats();
        return success(chemicalStats);
    }

    /**
     * 导出仪表板报告
     */
    @Log(title = "仪表板", businessType = BusinessType.EXPORT)
    @PreAuthorize("@ss.hasPermi('system:dashboard:export')")
    @PostMapping("/export-report")
    public void exportReport(@RequestBody Map<String, Object> params)
    {
        String format = (String) params.get("format");
        List<String> dateRange = (List<String>) params.get("dateRange");
        
        if ("pdf".equals(format))
        {
            dashboardService.exportPdfReport(dateRange);
        }
        else if ("excel".equals(format))
        {
            dashboardService.exportExcelReport(dateRange);
        }
    }
} 