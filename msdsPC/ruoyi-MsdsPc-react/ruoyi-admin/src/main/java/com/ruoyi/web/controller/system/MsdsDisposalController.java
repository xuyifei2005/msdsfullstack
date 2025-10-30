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
import com.ruoyi.system.domain.MsdsDisposal;
import com.ruoyi.system.service.IMsdsDisposalService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 废弃处置Controller
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
@RestController
@RequestMapping("/system/msds/disposal")
public class MsdsDisposalController extends BaseController
{
    @Autowired
    private IMsdsDisposalService msdsDisposalService;

    /**
     * 查询废弃处置列表
     */
    @PreAuthorize("@ss.hasPermi('system:disposal:list')")
    @GetMapping("/list")
    public TableDataInfo list(MsdsDisposal msdsDisposal)
    {
        startPage();
        List<MsdsDisposal> list = msdsDisposalService.selectMsdsDisposalList(msdsDisposal);
        return getDataTable(list);
    }

    /**
     * 导出废弃处置列表
     */
    @PreAuthorize("@ss.hasPermi('system:disposal:export')")
    @Log(title = "废弃处置", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, MsdsDisposal msdsDisposal)
    {
        List<MsdsDisposal> list = msdsDisposalService.selectMsdsDisposalList(msdsDisposal);
        ExcelUtil<MsdsDisposal> util = new ExcelUtil<MsdsDisposal>(MsdsDisposal.class);
        util.exportExcel(response, list, "废弃处置数据");
    }

    /**
     * 获取废弃处置详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:disposal:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(msdsDisposalService.selectMsdsDisposalById(id));
    }

    /**
     * 根据MSDS主表ID获取废弃处置详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:disposal:query')")
    @GetMapping(value = "/msds/{msdsId}")
    public AjaxResult getInfoByMsdsId(@PathVariable("msdsId") Long msdsId)
    {
        return success(msdsDisposalService.selectMsdsDisposalByMsdsId(msdsId));
    }

    /**
     * 新增废弃处置
     */
    @PreAuthorize("@ss.hasPermi('system:disposal:add')")
    @Log(title = "废弃处置", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody MsdsDisposal msdsDisposal)
    {
        return toAjax(msdsDisposalService.insertMsdsDisposal(msdsDisposal));
    }

    /**
     * 修改废弃处置
     */
    @PreAuthorize("@ss.hasPermi('system:disposal:edit')")
    @Log(title = "废弃处置", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody MsdsDisposal msdsDisposal)
    {
        return toAjax(msdsDisposalService.updateMsdsDisposal(msdsDisposal));
    }

    /**
     * 删除废弃处置
     */
    @PreAuthorize("@ss.hasPermi('system:disposal:remove')")
    @Log(title = "废弃处置", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(msdsDisposalService.deleteMsdsDisposalByIds(ids));
    }
}