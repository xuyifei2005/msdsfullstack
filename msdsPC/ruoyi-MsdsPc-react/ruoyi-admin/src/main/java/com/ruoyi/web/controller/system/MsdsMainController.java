package com.ruoyi.web.controller.system;

import java.util.List;
import java.util.Map;
import jakarta.servlet.http.HttpServletResponse;
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
import com.ruoyi.system.domain.MsdsMain;
import com.ruoyi.system.service.IMsdsMainService;

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
        msdsMain.setCreateBy(getUsername());
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
        msdsMain.setUpdateBy(getUsername());
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
            @RequestParam("file") MultipartFile[] files,
            @RequestParam(value = "overwriteDuplicates", defaultValue = "false") boolean overwriteDuplicates) 
    {
        try 
        {
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
    @PostMapping("/importTemplate")
    public void importTemplate(HttpServletResponse response)
    {
        msdsMainService.downloadImportTemplate(response);
    }
}
