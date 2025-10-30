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
import com.ruoyi.system.domain.MsdsStabilityReactivity;
import com.ruoyi.system.service.IMsdsStabilityReactivityService;

/**
 * 稳定性和反应性 信息操作处理
 * 
 * @author ruoyi
 * @date 2024-02-18
 */
@RestController
@RequestMapping("/system/msds/stabilityReactivity")
public class MsdsStabilityReactivityController extends BaseController
{
    @Autowired
    private IMsdsStabilityReactivityService msdsStabilityReactivityService;

    /**
     * 查询稳定性和反应性列表
     */
    @PreAuthorize("@ss.hasPermi('system:stability:list')")
    @GetMapping("/list")
    public TableDataInfo list(MsdsStabilityReactivity msdsStabilityReactivity)
    {
        startPage();
        List<MsdsStabilityReactivity> list = msdsStabilityReactivityService.selectMsdsStabilityReactivityList(msdsStabilityReactivity);
        return getDataTable(list);
    }

    /**
     * 获取稳定性和反应性详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:stability:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(msdsStabilityReactivityService.selectMsdsStabilityReactivityById(id));
    }

    /**
     * 根据MSDS主表ID获取稳定性和反应性信息
     */
    @PreAuthorize("@ss.hasPermi('system:stability:query')")
    @GetMapping(value = "/msds/{msdsId}")
    public AjaxResult getInfoByMsdsId(@PathVariable("msdsId") Long msdsId)
    {
        return success(msdsStabilityReactivityService.selectMsdsStabilityReactivityByMsdsId(msdsId));
    }

    /**
     * 新增稳定性和反应性
     */
    @PreAuthorize("@ss.hasPermi('system:stability:add')")
    @Log(title = "稳定性和反应性", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody MsdsStabilityReactivity msdsStabilityReactivity)
    {
        return toAjax(msdsStabilityReactivityService.insertMsdsStabilityReactivity(msdsStabilityReactivity));
    }

    /**
     * 修改稳定性和反应性
     */
    @PreAuthorize("@ss.hasPermi('system:stability:edit')")
    @Log(title = "稳定性和反应性", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody MsdsStabilityReactivity msdsStabilityReactivity)
    {
        return toAjax(msdsStabilityReactivityService.updateMsdsStabilityReactivity(msdsStabilityReactivity));
    }

    /**
     * 删除稳定性和反应性
     */
    @PreAuthorize("@ss.hasPermi('system:stability:remove')")
    @Log(title = "稳定性和反应性", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(msdsStabilityReactivityService.deleteMsdsStabilityReactivityByIds(ids));
    }
} 