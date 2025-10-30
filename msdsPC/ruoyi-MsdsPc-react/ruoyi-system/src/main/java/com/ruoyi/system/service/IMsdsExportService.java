package com.ruoyi.system.service;

import java.util.List;
import java.util.Map;
import jakarta.servlet.http.HttpServletResponse;
import com.ruoyi.system.domain.MsdsMain;

/**
 * MSDS数据导出Service接口
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public interface IMsdsExportService
{
    /**
     * 导出MSDS数据为Excel格式
     * 
     * @param response HTTP响应对象
     * @param msdsList MSDS数据列表
     * @param fileName 文件名
     */
    void exportToExcel(HttpServletResponse response, List<MsdsMain> msdsList, String fileName);

    /**
     * 导出MSDS数据为CSV格式
     * 
     * @param response HTTP响应对象
     * @param msdsList MSDS数据列表
     * @param fileName 文件名
     */
    void exportToCsv(HttpServletResponse response, List<MsdsMain> msdsList, String fileName);

    /**
     * 导出MSDS统计报表为Excel格式
     * 
     * @param response HTTP响应对象
     * @param statisticsData 统计数据
     * @param fileName 文件名
     */
    void exportStatisticsToExcel(HttpServletResponse response, Map<String, Object> statisticsData, String fileName);

    /**
     * 导出MSDS详细信息为Word格式
     * 
     * @param response HTTP响应对象
     * @param msdsMain MSDS主信息
     * @param fileName 文件名
     */
    void exportToWord(HttpServletResponse response, MsdsMain msdsMain, String fileName);

    /**
     * 导出MSDS详细信息为PDF格式
     * 
     * @param response HTTP响应对象
     * @param msdsMain MSDS主信息
     * @param fileName 文件名
     */
    void exportToPdf(HttpServletResponse response, MsdsMain msdsMain, String fileName);

    /**
     * 批量导出MSDS为压缩包
     * 
     * @param response HTTP响应对象
     * @param msdsList MSDS数据列表
     * @param format 导出格式（excel/word/pdf）
     * @param fileName 压缩包文件名
     */
    void batchExportAsZip(HttpServletResponse response, List<MsdsMain> msdsList, String format, String fileName);

    /**
     * 生成MSDS数据导入模板
     * 
     * @param response HTTP响应对象
     * @param templateType 模板类型（basic/detailed）
     */
    void generateImportTemplate(HttpServletResponse response, String templateType);
    
    /**
     * 生成MSDS数据导入模板（支持scope参数）
     * 
     * @param response HTTP响应对象
     * @param templateType 模板类型（basic/detailed/full）
     * @param scope 范围：all（全部表）或 tableName（指定表名）
     * @param tableName 当scope不为all时，指定的表名
     */
    void generateImportTemplate(HttpServletResponse response, String templateType, String scope, String tableName);

    /**
     * 导出审计日志报表
     */
    void exportAuditReport(HttpServletResponse response, Map<String, Object> auditData, String fileName);

    /**
     * 导出风险评估报告
     */
    void exportRiskAssessmentReport(HttpServletResponse response, Map<String, Object> riskData, String fileName);
}