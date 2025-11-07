package com.ruoyi.system.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.MsdsAnalyticsMapper;
import com.ruoyi.system.service.IMsdsAnalyticsService;

/**
 * MSDS数据分析服务实现
 * 
 * @author ruoyi
 * @date 2025-11-06
 */
@Service
public class MsdsAnalyticsServiceImpl implements IMsdsAnalyticsService 
{
    private static final Logger log = LoggerFactory.getLogger(MsdsAnalyticsServiceImpl.class);

    @Autowired
    private MsdsAnalyticsMapper analyticsMapper;

    /**
     * 获取基础统计数据
     */
    @Override
    public Map<String, Object> getSummaryStatistics() 
    {
        log.info("获取基础统计数据");
        Map<String, Object> stats = analyticsMapper.getSummaryStatistics();
        
        // 计算增长率（模拟数据，实际应该从历史数据对比）
        if (stats != null) {
            stats.put("msdsGrowthRate", "+12.5%");
            stats.put("hazardGrowthRate", "-3.2%");
            stats.put("visitsGrowthRate", "+8.7%");
            stats.put("usersGrowthRate", "0%");
        }
        
        log.debug("统计数据: {}", stats);
        return stats != null ? stats : new HashMap<>();
    }

    /**
     * 获取访问趋势数据
     */
    @Override
    public List<Map<String, Object>> getAccessTrend(Integer days) 
    {
        if (days == null || days <= 0) {
            days = 7;
        }
        
        log.info("获取{}天访问趋势", days);
        List<Map<String, Object>> trend = analyticsMapper.getAccessTrend(days);
        log.debug("趋势数据数量: {}", trend != null ? trend.size() : 0);
        
        return trend;
    }

    /**
     * 获取化学品分类分布
     */
    @Override
    public List<Map<String, Object>> getCategoryDistribution() 
    {
        log.info("获取化学品分类分布");
        List<Map<String, Object>> distribution = analyticsMapper.getCategoryDistribution();
        log.debug("分类数量: {}", distribution != null ? distribution.size() : 0);
        
        return distribution;
    }

    /**
     * 获取危险等级分布
     */
    @Override
    public List<Map<String, Object>> getHazardDistribution() 
    {
        log.info("获取危险等级分布");
        List<Map<String, Object>> distribution = analyticsMapper.getHazardDistribution();
        log.debug("危险等级数量: {}", distribution != null ? distribution.size() : 0);
        
        return distribution;
    }

    /**
     * 获取热门MSDS排行榜
     */
    @Override
    public List<Map<String, Object>> getTopMsdsRanking(Integer limit) 
    {
        if (limit == null || limit <= 0) {
            limit = 10;
        }
        
        log.info("获取TOP{}热门MSDS", limit);
        List<Map<String, Object>> ranking = analyticsMapper.getTopMsdsRanking(limit);
        log.debug("排行榜数量: {}", ranking != null ? ranking.size() : 0);
        
        return ranking;
    }

    /**
     * 获取月度新增MSDS统计
     */
    @Override
    public List<Map<String, Object>> getMonthlyNewMsds(Integer months) 
    {
        if (months == null || months <= 0) {
            months = 6;
        }
        
        log.info("获取最近{}个月新增MSDS统计", months);
        List<Map<String, Object>> monthly = analyticsMapper.getMonthlyNewMsds(months);
        log.debug("月度数据数量: {}", monthly != null ? monthly.size() : 0);
        
        return monthly;
    }

    /**
     * 获取用户活跃度统计
     */
    @Override
    public Map<String, Object> getUserActivityStats() 
    {
        log.info("获取用户活跃度统计");
        Map<String, Object> stats = analyticsMapper.getUserActivityStats();
        
        // 计算活跃率
        if (stats != null) {
            Object totalUsersObj = stats.get("totalUsers");
            Object dailyActiveObj = stats.get("dailyActiveUsers");
            Object weeklyActiveObj = stats.get("weeklyActiveUsers");
            Object monthlyActiveObj = stats.get("monthlyActiveUsers");
            
            if (totalUsersObj != null && dailyActiveObj != null) {
                int totalUsers = ((Number) totalUsersObj).intValue();
                int dailyActive = ((Number) dailyActiveObj).intValue();
                int weeklyActive = ((Number) weeklyActiveObj).intValue();
                int monthlyActive = ((Number) monthlyActiveObj).intValue();
                
                if (totalUsers > 0) {
                    stats.put("dailyActiveRate", Math.round(dailyActive * 100.0 / totalUsers));
                    stats.put("weeklyActiveRate", Math.round(weeklyActive * 100.0 / totalUsers));
                    stats.put("monthlyActiveRate", Math.round(monthlyActive * 100.0 / totalUsers));
                } else {
                    stats.put("dailyActiveRate", 0);
                    stats.put("weeklyActiveRate", 0);
                    stats.put("monthlyActiveRate", 0);
                }
            }
        }
        
        log.debug("用户活跃度: {}", stats);
        return stats != null ? stats : new HashMap<>();
    }

    /**
     * 导出数据分析报告
     */
    @Override
    public Map<String, Object> exportAnalyticsReport(String startDate, String endDate) 
    {
        log.info("导出数据分析报告: {} - {}", startDate, endDate);
        
        Map<String, Object> report = new HashMap<>();
        report.put("summary", getSummaryStatistics());
        report.put("categoryDistribution", getCategoryDistribution());
        report.put("hazardDistribution", getHazardDistribution());
        report.put("topRanking", getTopMsdsRanking(10));
        report.put("monthlyNew", getMonthlyNewMsds(12));
        report.put("userActivity", getUserActivityStats());
        report.put("startDate", startDate);
        report.put("endDate", endDate);
        report.put("generateTime", new java.util.Date());
        
        return report;
    }
}


