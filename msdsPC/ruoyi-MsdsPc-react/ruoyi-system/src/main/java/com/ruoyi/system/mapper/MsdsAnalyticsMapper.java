package com.ruoyi.system.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Param;

/**
 * MSDS数据分析Mapper接口
 * 
 * @author ruoyi
 * @date 2025-11-06
 */
public interface MsdsAnalyticsMapper 
{
    /**
     * 获取基础统计数据
     * 
     * @return 统计数据
     */
    public Map<String, Object> getSummaryStatistics();

    /**
     * 获取访问趋势数据
     * 
     * @param days 天数
     * @return 趋势数据列表
     */
    public List<Map<String, Object>> getAccessTrend(@Param("days") Integer days);

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
    public List<Map<String, Object>> getTopMsdsRanking(@Param("limit") Integer limit);

    /**
     * 获取月度新增MSDS统计
     * 
     * @param months 月数
     * @return 月度统计数据
     */
    public List<Map<String, Object>> getMonthlyNewMsds(@Param("months") Integer months);

    /**
     * 获取用户活跃度统计
     * 
     * @return 用户活跃度数据
     */
    public Map<String, Object> getUserActivityStats();
}


