package com.ruoyi.system.mapper;

import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

/**
 * 仪表板统计数据Mapper接口
 * 
 * @author ruoyi
 * @date 2024-12-19
 */
public interface SysDashboardMapper 
{
    /**
     * 统计文档总数
     */
    public int countTotalDocuments();

    /**
     * 统计有效文档数
     */
    public int countValidDocuments();

    /**
     * 统计待审核文档数
     */
    public int countPendingDocuments();

    /**
     * 统计过期文档数
     */
    public int countExpiredDocuments();

    /**
     * 统计今日访问数
     */
    public int countTodayViews();

    /**
     * 统计本月访问数
     */
    public int countMonthViews();

    /**
     * 统计总访问数
     */
    public int countTotalViews();

    /**
     * 统计活跃用户数
     */
    public int countActiveUsers();

    /**
     * 统计今日下载数
     */
    public int countTodayDownloads();

    /**
     * 统计本月下载数
     */
    public int countMonthDownloads();

    /**
     * 统计总下载数
     */
    public int countTotalDownloads();

    /**
     * 统计化学品总数
     */
    public int countTotalChemicals();

    /**
     * 统计危险化学品数
     */
    public int countDangerousChemicals();

    /**
     * 统计CAS号数量
     */
    public int countCasNumbers();

    /**
     * 统计供应商数量
     */
    public int countSuppliers();

    /**
     * 获取访问趋势数据
     */
    public List<Map<String, Object>> getAccessTrendData(@Param("startDate") String startDate, 
                                                       @Param("endDate") String endDate, 
                                                       @Param("metricType") String metricType);

    /**
     * 获取用户活动数据
     */
    public List<Map<String, Object>> getUserActivityData();

    /**
     * 获取下载分析数据
     */
    public List<Map<String, Object>> getDownloadAnalyticsData(@Param("timeRange") String timeRange);

    /**
     * 获取热门文档数据
     */
    public List<Map<String, Object>> getHotDocumentsData(@Param("sortBy") String sortBy);
} 