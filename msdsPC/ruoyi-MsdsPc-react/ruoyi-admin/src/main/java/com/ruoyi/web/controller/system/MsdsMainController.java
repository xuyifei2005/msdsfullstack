package com.ruoyi.web.controller.system;

import java.util.List;
import java.util.Map;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.utils.poi.ExcelValidationUtil;
import com.ruoyi.system.domain.MsdsMain;
import com.ruoyi.system.service.IMsdsMainService;
// 新增：允许匿名访问注解
import com.ruoyi.common.annotation.Anonymous;

/**
 * MSDS主信息 信息操作处理
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
@RestController
@RequestMapping("/system/msds")
public class MsdsMainController extends BaseController
{
    private static final Logger logger = LoggerFactory.getLogger(MsdsMainController.class);
    
    @Autowired
    private IMsdsMainService msdsMainService;

    /**
     * 获取MSDS主信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:msds:list')")
    @GetMapping("/list")
    public TableDataInfo list(MsdsMain msdsMain)
    {
        startPage();
        List<MsdsMain> list = msdsMainService.selectMsdsMainList(msdsMain);
        return getDataTable(list);
    }

    /**
     * 导出MSDS主信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:msds:export')")
    @Log(title = "MSDS主信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, MsdsMain msdsMain)
    {
        List<MsdsMain> list = msdsMainService.selectMsdsMainList(msdsMain);
        ExcelUtil<MsdsMain> util = new ExcelUtil<MsdsMain>(MsdsMain.class);
        util.exportExcel(response, list, "MSDS主信息数据");
    }

    /**
     * 根据MSDS主键获取详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:msds:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(msdsMainService.selectMsdsMainById(id));
    }

    /**
     * 新增MSDS主信息
     */
    @PreAuthorize("@ss.hasPermi('system:msds:add')")
    @Log(title = "MSDS主信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody MsdsMain msdsMain)
    {
        if (!msdsMainService.checkProductNameUnique(msdsMain))
        {
            return error("新增MSDS'" + msdsMain.getProductName() + "'失败，化学品名称已存在");
        }
        return toAjax(msdsMainService.insertMsdsMain(msdsMain));
    }

    /**
     * 修改MSDS主信息
     */
    @PreAuthorize("@ss.hasPermi('system:msds:edit')")
    @Log(title = "MSDS主信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody MsdsMain msdsMain)
    {
        if (!msdsMainService.checkProductNameUnique(msdsMain))
        {
            return error("修改MSDS'" + msdsMain.getProductName() + "'失败，化学品名称已存在");
        }
        return toAjax(msdsMainService.updateMsdsMain(msdsMain));
    }

    /**
     * 删除MSDS主信息
     */
    @PreAuthorize("@ss.hasPermi('system:msds:remove')")
    @Log(title = "MSDS主信息", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(msdsMainService.deleteMsdsMainByIds(ids));
    }

    /**
     * 导入MSDS文档
     */
    @PreAuthorize("@ss.hasPermi('system:msds:import')")
    @Log(title = "MSDS文档导入", businessType = BusinessType.IMPORT)
    @PostMapping("/import")
    public AjaxResult importData(
            @RequestParam(value = "files", required = false) MultipartFile[] filesParam,
            @RequestParam(value = "file", required = false) MultipartFile[] fileParam,
            @RequestParam(value = "overwriteDuplicates", defaultValue = "false") boolean overwriteDuplicates) 
    {
        try 
        {
            // 兼容处理：优先使用 files，其次使用 file
            MultipartFile[] files = (filesParam != null && filesParam.length > 0) ? filesParam : fileParam;

            if (files == null || files.length == 0) 
            {
                return error("请选择要导入的文件");
            }
            
            Map<String, Object> result = msdsMainService.importMsdsDocuments(files, overwriteDuplicates, getUsername());
            return success(result);
        } 
        catch (Exception e) 
        {
            logger.error("导入MSDS文档失败", e);
            return error("导入失败：" + e.getMessage());
        }
    }

    /**
     * 下载MSDS导入模板
     */
    @Anonymous
    @GetMapping("/importTemplate")
    public void importTemplate(HttpServletResponse response, 
                             @RequestParam(value = "templateType", defaultValue = "basic") String templateType,
                             @RequestParam(value = "scope", required = false) String scope,
                             @RequestParam(value = "tableName", required = false) String tableName)
    {
        msdsMainService.downloadImportTemplate(response, templateType, scope, tableName);
    }

    /**
     * Excel文件校验接口
     */
    @PreAuthorize("@ss.hasPermi('system:msds:import')")
    @Log(title = "Excel文件校验", businessType = BusinessType.OTHER)
    @PostMapping("/validateExcel")
    public AjaxResult validateExcel(@RequestParam("file") MultipartFile file)
    {
        try
        {
            if (file == null || file.isEmpty())
            {
                return error("请选择要校验的Excel文件");
            }
            
            // 检查文件类型
            String fileName = file.getOriginalFilename();
            if (fileName == null || (!fileName.endsWith(".xlsx") && !fileName.endsWith(".xls")))
            {
                return error("请上传Excel格式文件(.xlsx或.xls)");
            }
            
            // 执行Excel校验
            ExcelValidationUtil.ValidationResult<MsdsMain> result = ExcelValidationUtil.validateExcel(
                file.getInputStream(), MsdsMain.class, "Sheet1", 1);
            
            return success(result);
        }
        catch (Exception e)
        {
            logger.error("Excel文件校验失败", e);
            return error("校验失败：" + e.getMessage());
        }
    }

    /**
     * 导入CSV格式的MSDS数据
     */
    @PreAuthorize("@ss.hasPermi('system:msds:import')")
    @Log(title = "MSDS CSV导入", businessType = BusinessType.IMPORT)
    @PostMapping("/importCsv")
    public AjaxResult importCsv(
            @RequestParam("file") MultipartFile file,
            @RequestParam(value = "overwriteDuplicates", defaultValue = "false") boolean overwriteDuplicates)
    {
        try
        {
            if (file.isEmpty())
            {
                return error("请选择要导入的CSV文件");
            }
            
            // 验证文件格式
            String fileName = file.getOriginalFilename();
            if (fileName == null || !fileName.toLowerCase().endsWith(".csv"))
            {
                return error("请上传CSV格式的文件");
            }
            
            Map<String, Object> result = msdsMainService.importMsdsCsv(file, overwriteDuplicates, getUsername());
            return success(result);
        }
        catch (Exception e)
        {
            logger.error("导入CSV文件失败", e);
            return error("导入失败：" + e.getMessage());
        }
    }

    /**
     * 导入XML格式的MSDS数据
     */
    @PreAuthorize("@ss.hasPermi('system:msds:import')")
    @Log(title = "MSDS XML导入", businessType = BusinessType.IMPORT)
    @PostMapping("/importXml")
    public AjaxResult importXml(
            @RequestParam("file") MultipartFile[] files,
            @RequestParam(value = "overwriteDuplicates", defaultValue = "false") boolean overwriteDuplicates)
    {
        try
        {
            if (files == null || files.length == 0)
            {
                return error("请选择要导入的XML文件");
            }
            
            // 验证文件格式
            for (MultipartFile file : files) {
                if (file.isEmpty()) {
                    continue;
                }
                String fileName = file.getOriginalFilename();
                if (fileName == null || !fileName.toLowerCase().endsWith(".xml"))
                {
                    return error("请上传XML格式的文件: " + fileName);
                }
            }
            
            Map<String, Object> result = msdsMainService.importMsdsXmls(files, overwriteDuplicates, getUsername());
            return success(result);
        }
        catch (Exception e)
        {
            logger.error("导入XML文件失败", e);
            return error("导入失败：" + e.getMessage());
        }
    }

    /**
     * 下载XML格式导入模板
     */
    @Anonymous
    @GetMapping("/importXmlTemplate")
    public void importXmlTemplate(HttpServletResponse response)
    {
        try
        {
            msdsMainService.downloadXmlTemplate(response);
        }
        catch (Exception e)
        {
            logger.error("下载XML模板失败", e);
            throw new RuntimeException("下载XML模板失败：" + e.getMessage());
        }
    }

    /**
     * 导出MSDS为PDF格式
     */
    @PreAuthorize("@ss.hasPermi('system:msds:export')")
    @Log(title = "MSDS PDF导出", businessType = BusinessType.EXPORT)
    @PostMapping("/exportPdf")
    public void exportPdf(HttpServletResponse response, @RequestParam Long id)
    {
        try 
        {
            msdsMainService.exportMsdsToPdf(response, id);
        } 
        catch (Exception e) 
        {
            logger.error("导出MSDS PDF失败", e);
            throw new RuntimeException("导出PDF失败：" + e.getMessage());
        }
    }

    /**
     * 批量导出MSDS为PDF格式
     */
    @PreAuthorize("@ss.hasPermi('system:msds:export')")
    @Log(title = "MSDS批量PDF导出", businessType = BusinessType.EXPORT)
    @PostMapping("/batchExportPdf")
    public void batchExportPdf(HttpServletResponse response, @RequestParam Long[] ids)
    {
        try 
        {
            msdsMainService.batchExportMsdsToPdf(response, ids);
        } 
        catch (Exception e) 
        {
            logger.error("批量导出MSDS PDF失败", e);
            throw new RuntimeException("批量导出PDF失败：" + e.getMessage());
        }
    }

    /**
     * 获取MSDS统计信息
     */
    @PreAuthorize("@ss.hasPermi('system:msds:list')")
    @GetMapping("/statistics")
    public AjaxResult getStatistics()
    {
        Map<String, Object> statistics = msdsMainService.getMsdsStatistics();
        return success(statistics);
    }

    /**
     * 获取化学品使用情况统计
     */
    @PreAuthorize("@ss.hasPermi('system:msds:list')")
    @GetMapping("/usageStatistics")
    public AjaxResult getUsageStatistics(@RequestParam(defaultValue = "30") int days)
    {
        Map<String, Object> statistics = msdsMainService.getUsageStatistics(days);
        return success(statistics);
    }

    /**
     * 获取风险等级分布统计
     */
    @PreAuthorize("@ss.hasPermi('system:msds:list')")
    @GetMapping("/riskDistribution")
    public AjaxResult getRiskDistribution()
    {
        Map<String, Object> distribution = msdsMainService.getRiskDistribution();
        return success(distribution);
    }

    /**
     * 按文件路径导入MSDS文档
     */
    @PreAuthorize("@ss.hasPermi('system:msds:import')")
    @Log(title = "MSDS文档按路径导入", businessType = BusinessType.IMPORT)
    @PostMapping("/importByPath")
    public AjaxResult importByPath(
            @RequestParam("filePath") String filePath,
            @RequestParam(value = "overwriteDuplicates", defaultValue = "false") boolean overwriteDuplicates)
    {
        try
        {
            Map<String, Object> result = msdsMainService.importMsdsDocumentByPath(filePath, overwriteDuplicates, getUsername());
            return success(result);
        }
        catch (Exception e)
        {
            logger.error("按路径导入MSDS文档失败", e);
            return error("导入失败：" + e.getMessage());
        }
    }
    /**
     * 预览MSDS文档（仅解析不入库）
     */
    @PreAuthorize("@ss.hasPermi('system:msds:import')")
    @Log(title = "MSDS文档预览", businessType = BusinessType.OTHER)
    @PostMapping("/preview")
    public AjaxResult preview(
            @RequestParam(value = "files", required = false) MultipartFile[] filesParam,
            @RequestParam(value = "file", required = false) MultipartFile[] fileParam)
    {
        try
        {
            // 兼容处理：前端可能使用 file 或 files 字段
            MultipartFile[] files = (filesParam != null && filesParam.length > 0) ? filesParam : fileParam;
            if (files == null || files.length == 0)
            {
                return error("请选择要预览的文件");
            }
            Map<String, Object> result = msdsMainService.previewMsdsDocuments(files);
            return success(result);
        }
        catch (Exception e)
        {
            logger.error("预览MSDS文档失败", e);
            return error("预览失败：" + e.getMessage());
        }
    }
}
