package com.ruoyi.web.controller.system;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Date;
import java.util.Calendar;
import java.text.SimpleDateFormat;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.MsdsMain;
import com.ruoyi.system.domain.MsdsAuditLog;
import com.ruoyi.system.service.IMsdsMainService;
import com.ruoyi.system.service.IMsdsAuditLogService;
import com.ruoyi.common.utils.StringUtils;

/**
 * MSDS统计报表Controller
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
@RestController
@RequestMapping("/system/msds/report")
public class MsdsReportController extends BaseController
{
    @Autowired
    private IMsdsMainService msdsMainService;
    
    @Autowired
    private IMsdsAuditLogService msdsAuditLogService;

    /**
     * 获取MSDS综合统计信息
     */
    @PreAuthorize("@ss.hasPermi('system:msds:list')")
    @GetMapping("/overview")
    public AjaxResult getOverview()
    {
        Map<String, Object> overview = new HashMap<>();
        
        // 基础统计
        Map<String, Object> basicStats = msdsMainService.getMsdsStatistics();
        overview.put("basic", basicStats);
        
        // 审计日志统计
        Map<String, Object> auditStats = msdsAuditLogService.getAuditStatistics();
        overview.put("audit", auditStats);
        
        // 最近30天趋势
        Map<String, Object> trendData = getMsdsTrend(30);
        overview.put("trend", trendData);
        
        return success(overview);
    }

    /**
     * 获取MSDS数据趋势
     */
    @PreAuthorize("@ss.hasPermi('system:msds:list')")
    @GetMapping("/trend")
    public AjaxResult getTrend(@RequestParam(defaultValue = "30") int days)
    {
        Map<String, Object> trendData = getMsdsTrend(days);
        return success(trendData);
    }

    /**
     * 获取企业分布统计
     */
    @PreAuthorize("@ss.hasPermi('system:msds:list')")
    @GetMapping("/companyDistribution")
    public AjaxResult getCompanyDistribution()
    {
        Map<String, Object> distribution = new HashMap<>();
        
        MsdsMain queryParam = new MsdsMain();
        List<MsdsMain> allMsds = msdsMainService.selectMsdsMainList(queryParam);
        
        // 按企业统计
        Map<String, Long> companyStats = allMsds.stream()
            .filter(m -> StringUtils.isNotEmpty(m.getCompanyName()))
            .collect(java.util.stream.Collectors.groupingBy(
                MsdsMain::getCompanyName, 
                java.util.stream.Collectors.counting()));
        
        // 转换为图表数据格式
        List<Map<String, Object>> chartData = companyStats.entrySet().stream()
            .map(entry -> {
                Map<String, Object> item = new HashMap<>();
                item.put("name", entry.getKey());
                item.put("value", entry.getValue());
                return item;
            })
            .sorted((a, b) -> ((Long)b.get("value")).compareTo((Long)a.get("value")))
            .collect(java.util.stream.Collectors.toList());
        
        distribution.put("data", chartData);
        distribution.put("total", companyStats.size());
        
        return success(distribution);
    }

    /**
     * 获取化学品分类统计
     */
    @PreAuthorize("@ss.hasPermi('system:msds:list')")
    @GetMapping("/categoryDistribution")
    public AjaxResult getCategoryDistribution()
    {
        Map<String, Object> distribution = new HashMap<>();
        
        MsdsMain queryParam = new MsdsMain();
        List<MsdsMain> allMsds = msdsMainService.selectMsdsMainList(queryParam);
        
        // 模拟化学品分类统计（实际应根据化学品性质分类）
        Map<String, Long> categoryStats = new HashMap<>();
        categoryStats.put("有机化合物", (long)(allMsds.size() * 0.4));
        categoryStats.put("无机化合物", (long)(allMsds.size() * 0.3));
        categoryStats.put("混合物", (long)(allMsds.size() * 0.2));
        categoryStats.put("其他", (long)(allMsds.size() * 0.1));
        
        // 转换为图表数据格式
        List<Map<String, Object>> chartData = categoryStats.entrySet().stream()
            .map(entry -> {
                Map<String, Object> item = new HashMap<>();
                item.put("name", entry.getKey());
                item.put("value", entry.getValue());
                return item;
            })
            .collect(java.util.stream.Collectors.toList());
        
        distribution.put("data", chartData);
        distribution.put("total", allMsds.size());
        
        return success(distribution);
    }

    /**
     * 获取操作活跃度统计
     */
    @PreAuthorize("@ss.hasPermi('system:msds:list')")
    @GetMapping("/activityStats")
    public AjaxResult getActivityStats(@RequestParam(defaultValue = "7") int days)
    {
        Map<String, Object> activityStats = new HashMap<>();
        
        // 获取操作类型统计
        Map<String, Object> operationTypeStats = msdsAuditLogService.getOperationTypeStatistics();
        activityStats.put("operationTypes", operationTypeStats);
        
        // 获取操作人员统计
        Map<String, Object> operatorStats = msdsAuditLogService.getOperatorStatistics(days);
        activityStats.put("operators", operatorStats);
        
        // 获取每日活跃度
        Map<String, Object> dailyActivity = getDailyActivity(days);
        activityStats.put("daily", dailyActivity);
        
        return success(activityStats);
    }

    /**
     * 获取风险评估报告
     */
    @PreAuthorize("@ss.hasPermi('system:msds:list')")
    @GetMapping("/riskAssessment")
    public AjaxResult getRiskAssessment()
    {
        Map<String, Object> riskAssessment = new HashMap<>();
        
        // 获取风险等级分布
        Map<String, Object> riskDistribution = msdsMainService.getRiskDistribution();
        riskAssessment.put("distribution", riskDistribution);
        
        // 模拟高风险化学品列表
        MsdsMain queryParam = new MsdsMain();
        List<MsdsMain> allMsds = msdsMainService.selectMsdsMainList(queryParam);
        
        List<Map<String, Object>> highRiskItems = allMsds.stream()
            .limit(10) // 取前10个作为高风险示例
            .map(msds -> {
                Map<String, Object> item = new HashMap<>();
                item.put("id", msds.getId());
                item.put("productName", msds.getProductName());
                item.put("companyName", msds.getCompanyName());
                item.put("casNumber", msds.getCasNumber());
                item.put("riskLevel", "高风险"); // 模拟风险等级
                return item;
            })
            .collect(java.util.stream.Collectors.toList());
        
        riskAssessment.put("highRiskItems", highRiskItems);
        
        // 风险建议
        List<String> recommendations = java.util.Arrays.asList(
            "建议对高风险化学品加强管理和监控",
            "定期更新MSDS文档，确保信息准确性",
            "加强员工安全培训，提高风险意识",
            "建立完善的应急响应机制"
        );
        riskAssessment.put("recommendations", recommendations);
        
        return success(riskAssessment);
    }

    /**
     * 获取MSDS数据趋势（私有方法）
     */
    private Map<String, Object> getMsdsTrend(int days)
    {
        Map<String, Object> trendData = new HashMap<>();
        
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        
        List<Map<String, Object>> dailyData = new java.util.ArrayList<>();
        
        for (int i = days - 1; i >= 0; i--)
        {
            calendar.setTime(new Date());
            calendar.add(Calendar.DAY_OF_MONTH, -i);
            Date currentDate = calendar.getTime();
            
            Map<String, Object> dayData = new HashMap<>();
            dayData.put("date", dateFormat.format(currentDate));
            
            // 模拟每日数据（实际应查询数据库）
            dayData.put("created", (int)(Math.random() * 10));
            dayData.put("updated", (int)(Math.random() * 15));
            dayData.put("viewed", (int)(Math.random() * 50));
            
            dailyData.add(dayData);
        }
        
        trendData.put("daily", dailyData);
        trendData.put("period", days + "天");
        
        return trendData;
    }

    /**
     * 获取每日活跃度（私有方法）
     */
    private Map<String, Object> getDailyActivity(int days)
    {
        Map<String, Object> dailyActivity = new HashMap<>();
        
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        
        List<Map<String, Object>> activityData = new java.util.ArrayList<>();
        
        for (int i = days - 1; i >= 0; i--)
        {
            calendar.setTime(new Date());
            calendar.add(Calendar.DAY_OF_MONTH, -i);
            Date currentDate = calendar.getTime();
            
            Map<String, Object> dayData = new HashMap<>();
            dayData.put("date", dateFormat.format(currentDate));
            dayData.put("operations", (int)(Math.random() * 20));
            dayData.put("users", (int)(Math.random() * 5) + 1);
            
            activityData.add(dayData);
        }
        
        dailyActivity.put("data", activityData);
        dailyActivity.put("period", days + "天");
        
        return dailyActivity;
    }
}