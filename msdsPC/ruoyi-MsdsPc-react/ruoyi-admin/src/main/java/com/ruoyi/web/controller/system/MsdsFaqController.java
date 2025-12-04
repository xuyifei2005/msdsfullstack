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
import com.ruoyi.system.domain.MsdsFaq;
import com.ruoyi.system.service.IMsdsFaqService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 常见问题Controller
 * 
 * @author ruoyi
 * @date 2025-01-27
 */
@RestController
@RequestMapping("/system/faq")
public class MsdsFaqController extends BaseController
{
    @Autowired
    private IMsdsFaqService msdsFaqService;

    /**
     * 查询常见问题列表
     */
    @PreAuthorize("@ss.hasPermi('system:faq:list')")
    @GetMapping("/list")
    public TableDataInfo list(MsdsFaq msdsFaq)
    {
        startPage();
        List<MsdsFaq> list = msdsFaqService.selectMsdsFaqList(msdsFaq);
        return getDataTable(list);
    }

    /**
     * 查询常见问题列表 (App端使用)
     */
    @GetMapping("/app/list")
    public TableDataInfo appList(MsdsFaq msdsFaq)
    {
        startPage();
        List<MsdsFaq> list = msdsFaqService.selectMsdsFaqList(msdsFaq);
        return getDataTable(list);
    }

    /**
     * 导出常见问题列表
     */
    @PreAuthorize("@ss.hasPermi('system:faq:export')")
    @Log(title = "常见问题", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, MsdsFaq msdsFaq)
    {
        List<MsdsFaq> list = msdsFaqService.selectMsdsFaqList(msdsFaq);
        ExcelUtil<MsdsFaq> util = new ExcelUtil<MsdsFaq>(MsdsFaq.class);
        util.exportExcel(response, list, "常见问题数据");
    }

    /**
     * 获取常见问题详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:faq:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return AjaxResult.success(msdsFaqService.selectMsdsFaqById(id));
    }

    /**
     * 新增常见问题
     */
    @PreAuthorize("@ss.hasPermi('system:faq:add')")
    @Log(title = "常见问题", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody MsdsFaq msdsFaq)
    {
        msdsFaq.setCreateBy(getUsername());
        return toAjax(msdsFaqService.insertMsdsFaq(msdsFaq));
    }

    /**
     * 修改常见问题
     */
    @PreAuthorize("@ss.hasPermi('system:faq:edit')")
    @Log(title = "常见问题", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody MsdsFaq msdsFaq)
    {
        msdsFaq.setUpdateBy(getUsername());
        return toAjax(msdsFaqService.updateMsdsFaq(msdsFaq));
    }

    /**
     * 删除常见问题
     */
    @PreAuthorize("@ss.hasPermi('system:faq:remove')")
    @Log(title = "常见问题", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(msdsFaqService.deleteMsdsFaqByIds(ids));
    }
}
