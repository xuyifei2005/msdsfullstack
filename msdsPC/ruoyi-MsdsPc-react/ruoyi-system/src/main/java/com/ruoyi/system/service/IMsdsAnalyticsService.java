package com.ruoyi.system.service;

import java.util.List;
import java.util.Map;

/**
 * MSDS数据分析服务接口
 * 
 * @author ruoyi
 * @date 2025-11-06
 */
public interface IMsdsAnalyticsService 
{
    /**
     * 获取基础统计数据
     * 
     * @return 统计数据Map
     */
    public Map<String, Object> getSummaryStatistics();

    /**
     * 获取访问趋势数据
     * 
     * @param days 天数（7, 30, 90）
     * @return 趋势数据列表
     */
    public List<Map<String, Object>> getAccessTrend(Integer days);

    /**
     * 获取化学品分类分布
     * 
     * @return 分类分布数据
     */
    public List<Map<String, Object>> getCategoryDistribution();

    /**
     * 获取危险等级分布
     * 
     * @return 危险等级分布数据
     */
    public List<Map<String, Object>> getHazardDistribution();

    /**
     * 获取热门MSDS排行榜
     * 
     * @param limit 排行数量
     * @return 排行榜数据
     */
    public List<Map<String, Object>> getTopMsdsRanking(Integer limit);

    /**
     * 获取月度新增MSDS统计
     * 
     * @param months 月数
     * @return 月度统计数据
     */
    public List<Map<String, Object>> getMonthlyNewMsds(Integer months);

    /**
     * 获取用户活跃度统计
     * 
     * @return 用户活跃度数据
     */
    public Map<String, Object> getUserActivityStats();

    /**
     * 导出数据分析报告
     * 
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 报告数据
     */
    public Map<String, Object> exportAnalyticsReport(String startDate, String endDate);
}


