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
import com.ruoyi.system.domain.MsdsHazard;
import com.ruoyi.system.service.IMsdsHazardService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * MSDS危险性概述Controller
 * 
 * @author ruoyi
 * @date 2024-01-15
 */
@RestController
@RequestMapping("/system/msds/hazard")
public class MsdsHazardController extends BaseController
{
    @Autowired
    private IMsdsHazardService msdsHazardService;

    /**
     * 查询MSDS危险性概述列表
     */
    @PreAuthorize("@ss.hasPermi('system:msds:list')")
    @GetMapping("/list")
    public TableDataInfo list(MsdsHazard msdsHazard)
    {
        startPage();
        List<MsdsHazard> list = msdsHazardService.selectMsdsHazardList(msdsHazard);
        return getDataTable(list);
    }

    /**
     * 导出MSDS危险性概述列表
     */
    @PreAuthorize("@ss.hasPermi('system:msds:export')")
    @Log(title = "MSDS危险性概述", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, MsdsHazard msdsHazard)
    {
        List<MsdsHazard> list = msdsHazardService.selectMsdsHazardList(msdsHazard);
        ExcelUtil<MsdsHazard> util = new ExcelUtil<MsdsHazard>(MsdsHazard.class);
        util.exportExcel(response, list, "MSDS危险性概述数据");
    }

    /**
     * 获取MSDS危险性概述详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:msds:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(msdsHazardService.selectMsdsHazardById(id));
    }

    /**
     * 根据MSDS主表ID获取危险性概述详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:msds:query')")
    @GetMapping(value = "/msds/{msdsId}")
    public AjaxResult getInfoByMsdsId(@PathVariable("msdsId") Long msdsId)
    {
        return success(msdsHazardService.selectMsdsHazardByMsdsId(msdsId));
    }

    /**
     * 新增MSDS危险性概述
     */
    @PreAuthorize("@ss.hasPermi('system:msds:add')")
    @Log(title = "MSDS危险性概述", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody MsdsHazard msdsHazard)
    {
        return toAjax(msdsHazardService.insertMsdsHazard(msdsHazard));
    }

    /**
     * 修改MSDS危险性概述
     */
    @PreAuthorize("@ss.hasPermi('system:msds:edit')")
    @Log(title = "MSDS危险性概述", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody MsdsHazard msdsHazard)
    {
        return toAjax(msdsHazardService.updateMsdsHazard(msdsHazard));
    }

    /**
     * 删除MSDS危险性概述
     */
    @PreAuthorize("@ss.hasPermi('system:msds:remove')")
    @Log(title = "MSDS危险性概述", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(msdsHazardService.deleteMsdsHazardByIds(ids));
    }

    /**
     * 根据MSDS主表ID删除危险性概述
     */
    @PreAuthorize("@ss.hasPermi('system:msds:remove')")
    @Log(title = "MSDS危险性概述", businessType = BusinessType.DELETE)
    @DeleteMapping("/msds/{msdsId}")
    public AjaxResult removeByMsdsId(@PathVariable Long msdsId)
    {
        return toAjax(msdsHazardService.deleteMsdsHazardByMsdsId(msdsId));
    }
}