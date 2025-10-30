package com.ruoyi.system.service;

import java.util.List;
import java.util.Map;

/**
 * 仪表板统计数据Service接口
 * 
 * @author ruoyi
 * @date 2024-12-19
 */
public interface ISysDashboardService 
{
    /**
     * 获取文档统计数据
     * 
     * @return 文档统计数据
     */
    public Map<String, Object> getDocumentStats();

    /**
     * 获取访问统计数据
     * 
     * @return 访问统计数据
     */
    public Map<String, Object> getAccessStats();

    /**
     * 获取下载统计数据
     * 
     * @return 下载统计数据
     */
    public Map<String, Object> getDownloadStats();

    /**
     * 获取系统统计数据
     * 
     * @return 系统统计数据
     */
    public Map<String, Object> getSystemStats();

    /**
     * 获取化学品统计数据
     * 
     * @return 化学品统计数据
     */
    public Map<String, Object> getChemicalStats();

    /**
     * 获取访问趋势数据
     * 
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @param metricType 指标类型
     * @return 访问趋势数据
     */
    public List<Map<String, Object>> getAccessTrendData(String startDate, String endDate, String metricType);

    /**
     * 获取用户活动数据
     * 
     * @return 用户活动数据
     */
    public List<Map<String, Object>> getUserActivityData();

    /**
     * 获取下载分析数据
     * 
     * @param timeRange 时间范围
     * @return 下载分析数据
     */
    public List<Map<String, Object>> getDownloadAnalyticsData(String timeRange);

    /**
     * 获取热门文档数据
     * 
     * @param sortBy 排序方式
     * @return 热门文档数据
     */
    public List<Map<String, Object>> getHotDocumentsData(String sortBy);

    /**
     * 获取实时统计数据
     * 
     * @return 实时统计数据
     */
    public Map<String, Object> getRealtimeStats();

    /**
     * 获取系统健康数据
     * 
     * @return 系统健康数据
     */
    public Map<String, Object> getSystemHealthData();

    /**
     * 导出PDF报告
     * 
     * @param dateRange 日期范围
     */
    public void exportPdfReport(List<String> dateRange);

    /**
     * 导出Excel报告
     * 
     * @param dateRange 日期范围
     */
    public void exportExcelReport(List<String> dateRange);
} 