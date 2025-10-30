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
import com.ruoyi.system.domain.MsdsRegulatory;
import com.ruoyi.system.service.IMsdsRegulatoryService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 法规信息Controller
 * 
 * @author ruoyi
 * @date 2024-02-18
 */
@RestController
@RequestMapping("/system/msds/regulatory")
public class MsdsRegulatoryController extends BaseController
{
    @Autowired
    private IMsdsRegulatoryService msdsRegulatoryService;

    /**
     * 查询法规信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:regulatory:list')")
    @GetMapping("/list")
    public TableDataInfo list(MsdsRegulatory msdsRegulatory)
    {
        startPage();
        List<MsdsRegulatory> list = msdsRegulatoryService.selectMsdsRegulatoryList(msdsRegulatory);
        return getDataTable(list);
    }

    /**
     * 导出法规信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:regulatory:export')")
    @Log(title = "法规信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, MsdsRegulatory msdsRegulatory)
    {
        List<MsdsRegulatory> list = msdsRegulatoryService.selectMsdsRegulatoryList(msdsRegulatory);
        ExcelUtil<MsdsRegulatory> util = new ExcelUtil<MsdsRegulatory>(MsdsRegulatory.class);
        util.exportExcel(response, list, "法规信息数据");
    }

    /**
     * 获取法规信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:regulatory:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(msdsRegulatoryService.selectMsdsRegulatoryById(id));
    }

    /**
     * 根据MSDS主表ID获取法规信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:regulatory:query')")
    @GetMapping(value = "/msds/{msdsId}")
    public AjaxResult getInfoByMsdsId(@PathVariable("msdsId") Long msdsId)
    {
        return success(msdsRegulatoryService.selectMsdsRegulatoryByMsdsId(msdsId));
    }

    /**
     * 新增法规信息
     */
    @PreAuthorize("@ss.hasPermi('system:regulatory:add')")
    @Log(title = "法规信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody MsdsRegulatory msdsRegulatory)
    {
        return toAjax(msdsRegulatoryService.insertMsdsRegulatory(msdsRegulatory));
    }

    /**
     * 修改法规信息
     */
    @PreAuthorize("@ss.hasPermi('system:regulatory:edit')")
    @Log(title = "法规信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody MsdsRegulatory msdsRegulatory)
    {
        return toAjax(msdsRegulatoryService.updateMsdsRegulatory(msdsRegulatory));
    }

    /**
     * 删除法规信息
     */
    @PreAuthorize("@ss.hasPermi('system:regulatory:remove')")
    @Log(title = "法规信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(msdsRegulatoryService.deleteMsdsRegulatoryByIds(ids));
    }
}