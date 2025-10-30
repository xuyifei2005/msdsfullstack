package com.ruoyi.system.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import jakarta.servlet.http.HttpServletResponse;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.MsdsMain;
import com.ruoyi.system.service.IMsdsExportService;
import com.ruoyi.system.service.IMsdsMainService;

/**
 * MSDS数据导出Controller
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
@RestController
@RequestMapping("/system/msds/export")
public class MsdsExportController extends BaseController
{
    @Autowired
    private IMsdsExportService msdsExportService;
    
    @Autowired
    private IMsdsMainService msdsMainService;

    /**
     * 导出MSDS数据为Excel格式
     */
    @PreAuthorize("@ss.hasPermi('system:msds:export')")
    @Log(title = "MSDS数据导出", businessType = BusinessType.EXPORT)
    @PostMapping("/excel")
    public void exportExcel(HttpServletResponse response, @RequestBody MsdsMain msdsMain)
    {
        List<MsdsMain> list = msdsMainService.selectMsdsMainList(msdsMain);
        String fileName = "MSDS数据_" + System.currentTimeMillis();
        msdsExportService.exportToExcel(response, list, fileName);
    }

    /**
     * 导出MSDS数据为CSV格式
     */
    @PreAuthorize("@ss.hasPermi('system:msds:export')")
    @Log(title = "MSDS数据导出", businessType = BusinessType.EXPORT)
    @PostMapping("/csv")
    public void exportCsv(HttpServletResponse response, @RequestBody MsdsMain msdsMain)
    {
        List<MsdsMain> list = msdsMainService.selectMsdsMainList(msdsMain);
        String fileName = "MSDS数据_" + System.currentTimeMillis();
        msdsExportService.exportToCsv(response, list, fileName);
    }

    /**
     * 导出单个MSDS详细信息为Word格式
     */
    @PreAuthorize("@ss.hasPermi('system:msds:export')")
    @Log(title = "MSDS详情导出", businessType = BusinessType.EXPORT)
    @GetMapping("/word/{id}")
    public void exportWord(HttpServletResponse response, @PathVariable("id") Long id)
    {
        MsdsMain msdsMain = msdsMainService.selectMsdsMainById(id);
        if (msdsMain == null)
        {
            throw new RuntimeException("MSDS数据不存在");
        }
        
        String fileName = "MSDS详情_" + (StringUtils.isNotEmpty(msdsMain.getProductName()) ? 
            msdsMain.getProductName() : msdsMain.getMsdsCode()) + "_" + System.currentTimeMillis();
        msdsExportService.exportToWord(response, msdsMain, fileName);
    }

    /**
     * 批量导出MSDS为压缩包
     */
    @PreAuthorize("@ss.hasPermi('system:msds:export')")
    @Log(title = "MSDS批量导出", businessType = BusinessType.EXPORT)
    @PostMapping("/batch")
    public void batchExport(HttpServletResponse response, 
                           @RequestBody MsdsMain msdsMain,
                           @RequestParam(value = "format", defaultValue = "excel") String format)
    {
        List<MsdsMain> list = msdsMainService.selectMsdsMainList(msdsMain);
        if (list.isEmpty())
        {
            throw new RuntimeException("没有找到符合条件的MSDS数据");
        }
        
        String fileName = "MSDS批量导出_" + format + "_" + System.currentTimeMillis();
        msdsExportService.batchExportAsZip(response, list, format, fileName);
    }

    /**
     * 根据ID列表批量导出MSDS
     */
    @PreAuthorize("@ss.hasPermi('system:msds:export')")
    @Log(title = "MSDS批量导出", businessType = BusinessType.EXPORT)
    @PostMapping("/batchByIds")
    public void batchExportByIds(HttpServletResponse response, 
                                @RequestParam("ids") Long[] ids,
                                @RequestParam(value = "format", defaultValue = "excel") String format)
    {
        if (ids == null || ids.length == 0)
        {
            throw new RuntimeException("请选择要导出的MSDS数据");
        }
        
        List<MsdsMain> list = msdsMainService.selectMsdsMainByIds(ids);
        if (list.isEmpty())
        {
            throw new RuntimeException("没有找到符合条件的MSDS数据");
        }
        
        String fileName = "MSDS批量导出_" + format + "_" + System.currentTimeMillis();
        msdsExportService.batchExportAsZip(response, list, format, fileName);
    }

    /**
     * 导出MSDS统计报表
     */
    @PreAuthorize("@ss.hasPermi('system:msds:export')")
    @Log(title = "MSDS统计报表导出", businessType = BusinessType.EXPORT)
    @GetMapping("/statistics")
    public void exportStatistics(HttpServletResponse response)
    {
        // 获取统计数据
        Map<String, Object> statisticsData = new HashMap<>();
        
        // 获取基础统计信息
        Map<String, Object> basicStats = msdsMainService.getMsdsStatistics();
        statisticsData.putAll(basicStats);
        
        // 获取使用情况统计
        Map<String, Object> usageStats = msdsMainService.getUsageStatistics(30); // 最近30天
        statisticsData.put("usageStatistics", usageStats);
        
        // 获取风险分布统计
        Map<String, Object> riskStats = msdsMainService.getRiskDistribution();
        statisticsData.put("riskDistribution", riskStats);
        
        String fileName = "MSDS统计报表_" + System.currentTimeMillis();
        msdsExportService.exportStatisticsToExcel(response, statisticsData, fileName);
    }

    /**
     * 生成MSDS数据导入模板
     */
    @PreAuthorize("@ss.hasPermi('system:msds:import')")
    @Log(title = "MSDS导入模板生成", businessType = BusinessType.EXPORT)
    @GetMapping("/template")
    public void generateImportTemplate(HttpServletResponse response,
                                     @RequestParam(value = "type", defaultValue = "basic") String templateType,
                                     @RequestParam(value = "scope", defaultValue = "all") String scope,
                                     @RequestParam(value = "tableName", required = false) String tableName)
    {
        // 验证参数
        if (!"all".equals(scope) && StringUtils.isEmpty(tableName)) {
            throw new IllegalArgumentException("当scope不为all时，必须指定tableName参数");
        }
        
        msdsExportService.generateImportTemplate(response, templateType, scope, tableName);
    }

    /**
     * 导出审计日志报表
     */
    @PreAuthorize("@ss.hasPermi('system:msds:audit:export')")
    @Log(title = "MSDS审计日志导出", businessType = BusinessType.EXPORT)
    @PostMapping("/auditReport")
    public void exportAuditReport(HttpServletResponse response,
                                 @RequestParam(value = "startDate", required = false) String startDate,
                                 @RequestParam(value = "endDate", required = false) String endDate,
                                 @RequestParam(value = "operationType", required = false) String operationType)
    {
        Map<String, Object> auditData = new HashMap<>();
        auditData.put("startDate", startDate);
        auditData.put("endDate", endDate);
        auditData.put("operationType", operationType);
        
        String fileName = "MSDS审计日志报表_" + System.currentTimeMillis();
        msdsExportService.exportAuditReport(response, auditData, fileName);
    }

    /**
     * 导出风险评估报告
     */
    @PreAuthorize("@ss.hasPermi('system:msds:risk:export')")
    @Log(title = "MSDS风险评估报告导出", businessType = BusinessType.EXPORT)
    @PostMapping("/riskReport")
    public void exportRiskAssessmentReport(HttpServletResponse response,
                                          @RequestParam(value = "riskLevel", required = false) String riskLevel,
                                          @RequestParam(value = "companyName", required = false) String companyName)
    {
        Map<String, Object> riskData = new HashMap<>();
        riskData.put("riskLevel", riskLevel);
        riskData.put("companyName", companyName);
        
        String fileName = "MSDS风险评估报告_" + System.currentTimeMillis();
        msdsExportService.exportRiskAssessmentReport(response, riskData, fileName);
    }

    /**
     * 获取支持的导出格式列表
     */
    @PreAuthorize("@ss.hasPermi('system:msds:list')")
    @GetMapping("/formats")
    public AjaxResult getSupportedFormats()
    {
        Map<String, Object> formats = new HashMap<>();
        formats.put("excel", "Excel格式 (.xlsx)");
        formats.put("csv", "CSV格式 (.csv)");
        formats.put("word", "Word格式 (.docx)");
        formats.put("pdf", "PDF格式 (.pdf)");
        
        return AjaxResult.success(formats);
    }

    /**
     * 获取导入模板类型列表
     */
    @PreAuthorize("@ss.hasPermi('system:msds:list')")
    @GetMapping("/templateTypes")
    public AjaxResult getTemplateTypes()
    {
        Map<String, Object> types = new HashMap<>();
        types.put("basic", "基础模板 - 包含必要字段");
        types.put("detailed", "详细模板 - 包含所有字段");
        
        return AjaxResult.success(types);
    }

    /**
     * 获取导出任务状态（预留接口，用于大数据量异步导出）
     */
    @PreAuthorize("@ss.hasPermi('system:msds:export')")
    @GetMapping("/status/{taskId}")
    public AjaxResult getExportStatus(@PathVariable("taskId") String taskId)
    {
        // 预留接口，用于异步导出任务状态查询
        Map<String, Object> status = new HashMap<>();
        status.put("taskId", taskId);
        status.put("status", "completed");
        status.put("progress", 100);
        status.put("message", "导出完成");
        
        return AjaxResult.success(status);
    }

    /**
     * 验证导出参数
     */
    private void validateExportParams(String format, List<MsdsMain> dataList)
    {
        if (StringUtils.isEmpty(format))
        {
            throw new RuntimeException("导出格式不能为空");
        }
        
        if (!"excel".equals(format) && !"csv".equals(format) && !"word".equals(format))
        {
            throw new RuntimeException("不支持的导出格式: " + format);
        }
        
        if (dataList == null || dataList.isEmpty())
        {
            throw new RuntimeException("没有可导出的数据");
        }
        
        if (dataList.size() > 10000)
        {
            throw new RuntimeException("导出数据量过大，请分批导出（单次最多10000条）");
        }
    }
}