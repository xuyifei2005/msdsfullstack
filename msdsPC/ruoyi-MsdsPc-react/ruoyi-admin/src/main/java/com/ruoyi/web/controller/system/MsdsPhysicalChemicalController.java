package com.ruoyi.web.controller.system;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.MsdsPhysicalChemical;
import com.ruoyi.system.service.IMsdsPhysicalChemicalService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * MSDS理化特性Controller
 * 
 * @author ruoyi
 * @date 2024-01-15
 */
@RestController
@RequestMapping("/system/msds/physicalchemical")
public class MsdsPhysicalChemicalController extends BaseController
{
    @Autowired
    private IMsdsPhysicalChemicalService msdsPhysicalChemicalService;

    /**
     * 查询MSDS理化特性列表
     */
    @PreAuthorize("@ss.hasPermi('system:msds:list')")
    @GetMapping("/list")
    public TableDataInfo list(MsdsPhysicalChemical msdsPhysicalChemical)
    {
        startPage();
        List<MsdsPhysicalChemical> list = msdsPhysicalChemicalService.selectMsdsPhysicalChemicalList(msdsPhysicalChemical);
        return getDataTable(list);
    }

    /**
     * 导出MSDS理化特性列表
     */
    @PreAuthorize("@ss.hasPermi('system:msds:export')")
    @Log(title = "MSDS理化特性", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, MsdsPhysicalChemical msdsPhysicalChemical)
    {
        List<MsdsPhysicalChemical> list = msdsPhysicalChemicalService.selectMsdsPhysicalChemicalList(msdsPhysicalChemical);
        ExcelUtil<MsdsPhysicalChemical> util = new ExcelUtil<MsdsPhysicalChemical>(MsdsPhysicalChemical.class);
        util.exportExcel(response, list, "MSDS理化特性数据");
    }

    /**
     * 获取MSDS理化特性详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:msds:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(msdsPhysicalChemicalService.selectMsdsPhysicalChemicalById(id));
    }

    /**
     * 根据MSDS主表ID获取理化特性详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:msds:query')")
    @GetMapping(value = "/msds/{msdsId}")
    public AjaxResult getInfoByMsdsId(@PathVariable("msdsId") Long msdsId)
    {
        return success(msdsPhysicalChemicalService.selectMsdsPhysicalChemicalByMsdsId(msdsId));
    }

    /**
     * 新增MSDS理化特性
     */
    @PreAuthorize("@ss.hasPermi('system:msds:add')")
    @Log(title = "MSDS理化特性", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody MsdsPhysicalChemical msdsPhysicalChemical)
    {
        return toAjax(msdsPhysicalChemicalService.insertMsdsPhysicalChemical(msdsPhysicalChemical));
    }

    /**
     * 修改MSDS理化特性
     */
    @PreAuthorize("@ss.hasPermi('system:msds:edit')")
    @Log(title = "MSDS理化特性", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody MsdsPhysicalChemical msdsPhysicalChemical)
    {
        return toAjax(msdsPhysicalChemicalService.updateMsdsPhysicalChemical(msdsPhysicalChemical));
    }

    /**
     * 删除MSDS理化特性
     */
    @PreAuthorize("@ss.hasPermi('system:msds:remove')")
    @Log(title = "MSDS理化特性", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(msdsPhysicalChemicalService.deleteMsdsPhysicalChemicalByIds(ids));
    }

    /**
     * 根据MSDS主表ID删除理化特性
     */
    @PreAuthorize("@ss.hasPermi('system:msds:remove')")
    @Log(title = "MSDS理化特性", businessType = BusinessType.DELETE)
    @DeleteMapping("/msds/{msdsId}")
    public AjaxResult removeByMsdsId(@PathVariable Long msdsId)
    {
        return toAjax(msdsPhysicalChemicalService.deleteMsdsPhysicalChemicalByMsdsId(msdsId));
    }
}