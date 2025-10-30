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
import com.ruoyi.system.domain.MsdsFirstAid;
import com.ruoyi.system.service.IMsdsFirstAidService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * MSDS急救措施Controller
 * 
 * @author ruoyi
 * @date 2024-01-15
 */
@RestController
@RequestMapping("/system/msds/firstaid")
public class MsdsFirstAidController extends BaseController
{
    @Autowired
    private IMsdsFirstAidService msdsFirstAidService;

    /**
     * 查询MSDS急救措施列表
     */
    @PreAuthorize("@ss.hasPermi('system:msds:list')")
    @GetMapping("/list")
    public TableDataInfo list(MsdsFirstAid msdsFirstAid)
    {
        startPage();
        List<MsdsFirstAid> list = msdsFirstAidService.selectMsdsFirstAidList(msdsFirstAid);
        return getDataTable(list);
    }

    /**
     * 导出MSDS急救措施列表
     */
    @PreAuthorize("@ss.hasPermi('system:msds:export')")
    @Log(title = "MSDS急救措施", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, MsdsFirstAid msdsFirstAid)
    {
        List<MsdsFirstAid> list = msdsFirstAidService.selectMsdsFirstAidList(msdsFirstAid);
        ExcelUtil<MsdsFirstAid> util = new ExcelUtil<MsdsFirstAid>(MsdsFirstAid.class);
        util.exportExcel(response, list, "MSDS急救措施数据");
    }

    /**
     * 获取MSDS急救措施详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:msds:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(msdsFirstAidService.selectMsdsFirstAidById(id));
    }

    /**
     * 根据MSDS主表ID获取急救措施详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:msds:query')")
    @GetMapping(value = "/msds/{msdsId}")
    public AjaxResult getInfoByMsdsId(@PathVariable("msdsId") Long msdsId)
    {
        return success(msdsFirstAidService.selectMsdsFirstAidByMsdsId(msdsId));
    }

    /**
     * 新增MSDS急救措施
     */
    @PreAuthorize("@ss.hasPermi('system:msds:add')")
    @Log(title = "MSDS急救措施", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody MsdsFirstAid msdsFirstAid)
    {
        return toAjax(msdsFirstAidService.insertMsdsFirstAid(msdsFirstAid));
    }

    /**
     * 修改MSDS急救措施
     */
    @PreAuthorize("@ss.hasPermi('system:msds:edit')")
    @Log(title = "MSDS急救措施", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody MsdsFirstAid msdsFirstAid)
    {
        return toAjax(msdsFirstAidService.updateMsdsFirstAid(msdsFirstAid));
    }

    /**
     * 删除MSDS急救措施
     */
    @PreAuthorize("@ss.hasPermi('system:msds:remove')")
    @Log(title = "MSDS急救措施", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(msdsFirstAidService.deleteMsdsFirstAidByIds(ids));
    }

    /**
     * 根据MSDS主表ID删除急救措施
     */
    @PreAuthorize("@ss.hasPermi('system:msds:remove')")
    @Log(title = "MSDS急救措施", businessType = BusinessType.DELETE)
    @DeleteMapping("/msds/{msdsId}")
    public AjaxResult removeByMsdsId(@PathVariable Long msdsId)
    {
        return toAjax(msdsFirstAidService.deleteMsdsFirstAidByMsdsId(msdsId));
    }
}