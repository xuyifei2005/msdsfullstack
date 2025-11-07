package com.ruoyi.web.controller.system;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.service.IMsdsAnalyticsService;

/**
 * MSDS数据分析Controller
 * 
 * @author ruoyi
 * @date 2025-11-06
 */
@RestController
@RequestMapping("/system/msds/analytics")
public class MsdsAnalyticsController extends BaseController
{
    @Autowired
    private IMsdsAnalyticsService analyticsService;

    /**
     * 获取基础统计数据
     */
    @PreAuthorize("@ss.hasPermi('system:analytics:summary')")
    @GetMapping("/summary")
    public AjaxResult getSummary()
    {
        logger.info("获取数据分析基础统计");
        Map<String, Object> summary = analyticsService.getSummaryStatistics();
        return success(summary);
    }

    /**
     * 获取访问趋势
     */
    @PreAuthorize("@ss.hasPermi('system:analytics:trend')")
    @GetMapping("/trend")
    public AjaxResult getAccessTrend(@RequestParam(value = "days", defaultValue = "7") Integer days)
    {
        logger.info("获取{}天访问趋势", days);
        List<Map<String, Object>> trend = analyticsService.getAccessTrend(days);
        return success(trend);
    }

    /**
     * 获取化学品分类分布
     */
    @PreAuthorize("@ss.hasPermi('system:analytics:category')")
    @GetMapping("/category")
    public AjaxResult getCategoryDistribution()
    {
        logger.info("获取化学品分类分布");
        List<Map<String, Object>> distribution = analyticsService.getCategoryDistribution();
        return success(distribution);
    }

    /**
     * 获取危险等级分布
     */
    @PreAuthorize("@ss.hasPermi('system:analytics:hazard')")
    @GetMapping("/hazard")
    public AjaxResult getHazardDistribution()
    {
        logger.info("获取危险等级分布");
        List<Map<String, Object>> distribution = analyticsService.getHazardDistribution();
        return success(distribution);
    }

    /**
     * 获取热门MSDS排行榜
     */
    @PreAuthorize("@ss.hasPermi('system:analytics:ranking')")
    @GetMapping("/ranking")
    public AjaxResult getTopRanking(@RequestParam(value = "limit", defaultValue = "10") Integer limit)
    {
        logger.info("获取TOP{}热门MSDS排行", limit);
        List<Map<String, Object>> ranking = analyticsService.getTopMsdsRanking(limit);
        return success(ranking);
    }

    /**
     * 获取月度新增MSDS统计
     */
    @PreAuthorize("@ss.hasPermi('system:analytics:monthly')")
    @GetMapping("/monthly")
    public AjaxResult getMonthlyNewMsds(@RequestParam(value = "months", defaultValue = "6") Integer months)
    {
        logger.info("获取最近{}个月新增MSDS", months);
        List<Map<String, Object>> monthly = analyticsService.getMonthlyNewMsds(months);
        return success(monthly);
    }

    /**
     * 获取用户活跃度统计
     */
    @PreAuthorize("@ss.hasPermi('system:analytics:users')")
    @GetMapping("/users")
    public AjaxResult getUserActivity()
    {
        logger.info("获取用户活跃度统计");
        Map<String, Object> activity = analyticsService.getUserActivityStats();
        return success(activity);
    }

    /**
     * 导出数据分析报告
     */
    @PreAuthorize("@ss.hasPermi('system:analytics:export')")
    @GetMapping("/export")
    public AjaxResult exportReport(
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate)
    {
        logger.info("导出数据分析报告: {} - {}", startDate, endDate);
        Map<String, Object> report = analyticsService.exportAnalyticsReport(startDate, endDate);
        return success(report);
    }
}


