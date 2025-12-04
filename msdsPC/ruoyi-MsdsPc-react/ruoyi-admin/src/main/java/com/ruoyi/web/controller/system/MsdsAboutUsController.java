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
import com.ruoyi.system.domain.MsdsAboutUs;
import com.ruoyi.system.service.IMsdsAboutUsService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 关于我们Controller
 * 
 * @author ruoyi
 * @date 2025-01-27
 */
@RestController
@RequestMapping("/system/about")
public class MsdsAboutUsController extends BaseController
{
    @Autowired
    private IMsdsAboutUsService msdsAboutUsService;

    /**
     * 查询关于我们列表 (App端使用)
     */
    @GetMapping("/app/list")
    public TableDataInfo appList(MsdsAboutUs msdsAboutUs)
    {
        startPage();
        List<MsdsAboutUs> list = msdsAboutUsService.selectMsdsAboutUsList(msdsAboutUs);
        return getDataTable(list);
    }

    /**
     * 查询关于我们列表
     */
    @PreAuthorize("@ss.hasPermi('system:about:list')")
    @GetMapping("/list")
    public TableDataInfo list(MsdsAboutUs msdsAboutUs)
    {
        startPage();
        List<MsdsAboutUs> list = msdsAboutUsService.selectMsdsAboutUsList(msdsAboutUs);
        return getDataTable(list);
    }

    /**
     * 导出关于我们列表
     */
    @PreAuthorize("@ss.hasPermi('system:about:export')")
    @Log(title = "关于我们", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, MsdsAboutUs msdsAboutUs)
    {
        List<MsdsAboutUs> list = msdsAboutUsService.selectMsdsAboutUsList(msdsAboutUs);
        ExcelUtil<MsdsAboutUs> util = new ExcelUtil<MsdsAboutUs>(MsdsAboutUs.class);
        util.exportExcel(response, list, "关于我们数据");
    }

    /**
     * 获取关于我们详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:about:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return AjaxResult.success(msdsAboutUsService.selectMsdsAboutUsById(id));
    }

    /**
     * 新增关于我们
     */
    @PreAuthorize("@ss.hasPermi('system:about:add')")
    @Log(title = "关于我们", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody MsdsAboutUs msdsAboutUs)
    {
        msdsAboutUs.setCreateBy(getUsername());
        return toAjax(msdsAboutUsService.insertMsdsAboutUs(msdsAboutUs));
    }

    /**
     * 修改关于我们
     */
    @PreAuthorize("@ss.hasPermi('system:about:edit')")
    @Log(title = "关于我们", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody MsdsAboutUs msdsAboutUs)
    {
        msdsAboutUs.setUpdateBy(getUsername());
        return toAjax(msdsAboutUsService.updateMsdsAboutUs(msdsAboutUs));
    }

    /**
     * 删除关于我们
     */
    @PreAuthorize("@ss.hasPermi('system:about:remove')")
    @Log(title = "关于我们", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(msdsAboutUsService.deleteMsdsAboutUsByIds(ids));
    }
}
