package com.ruoyi.web.controller.system;

import java.util.List;
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
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.MsdsFireFighting;
import com.ruoyi.system.service.IMsdsFireFightingService;

/**
 * 消防措施 信息操作处理
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
@RestController
@RequestMapping("/system/msds/fireFighting")
public class MsdsFireFightingController extends BaseController
{
    @Autowired
    private IMsdsFireFightingService msdsFireFightingService;

    /**
     * 查询消防措施列表
     */
    @PreAuthorize("@ss.hasPermi('system:fireFighting:list')")
    @GetMapping("/list")
    public TableDataInfo list(MsdsFireFighting msdsFireFighting)
    {
        startPage();
        List<MsdsFireFighting> list = msdsFireFightingService.selectMsdsFireFightingList(msdsFireFighting);
        return getDataTable(list);
    }

    /**
     * 获取消防措施详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:fireFighting:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(msdsFireFightingService.selectMsdsFireFightingById(id));
    }

    /**
     * 根据MSDS主表ID获取消防措施
     */
    @PreAuthorize("@ss.hasPermi('system:fireFighting:query')")
    @GetMapping(value = "/msds/{msdsId}")
    public AjaxResult getInfoByMsdsId(@PathVariable("msdsId") Long msdsId)
    {
        return success(msdsFireFightingService.selectMsdsFireFightingByMsdsId(msdsId));
    }

    /**
     * 新增消防措施
     */
    @PreAuthorize("@ss.hasPermi('system:fireFighting:add')")
    @Log(title = "消防措施", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody MsdsFireFighting msdsFireFighting)
    {
        return toAjax(msdsFireFightingService.insertMsdsFireFighting(msdsFireFighting));
    }

    /**
     * 修改消防措施
     */
    @PreAuthorize("@ss.hasPermi('system:fireFighting:edit')")
    @Log(title = "消防措施", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody MsdsFireFighting msdsFireFighting)
    {
        return toAjax(msdsFireFightingService.updateMsdsFireFighting(msdsFireFighting));
    }

    /**
     * 删除消防措施
     */
    @PreAuthorize("@ss.hasPermi('system:fireFighting:remove')")
    @Log(title = "消防措施", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(msdsFireFightingService.deleteMsdsFireFightingByIds(ids));
    }
} 