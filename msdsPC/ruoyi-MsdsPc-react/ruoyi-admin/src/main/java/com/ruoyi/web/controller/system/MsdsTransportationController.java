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
import com.ruoyi.system.domain.MsdsTransportation;
import com.ruoyi.system.service.IMsdsTransportationService;

/**
 * 运输信息 信息操作处理
 * 
 * @author ruoyi
 * @date 2024-02-18
 */
@RestController
@RequestMapping("/system/msds/transport")
public class MsdsTransportationController extends BaseController
{
    @Autowired
    private IMsdsTransportationService msdsTransportationService;

    /**
     * 查询运输信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:transportation:list')")
    @GetMapping("/list")
    public TableDataInfo list(MsdsTransportation msdsTransportation)
    {
        startPage();
        List<MsdsTransportation> list = msdsTransportationService.selectMsdsTransportationList(msdsTransportation);
        return getDataTable(list);
    }

    /**
     * 获取运输信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:transportation:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(msdsTransportationService.selectMsdsTransportationById(id));
    }

    /**
     * 根据MSDS主表ID获取运输信息
     */
    @PreAuthorize("@ss.hasPermi('system:transportation:query')")
    @GetMapping(value = "/msds/{msdsId}")
    public AjaxResult getInfoByMsdsId(@PathVariable("msdsId") Long msdsId)
    {
        return success(msdsTransportationService.selectMsdsTransportationByMsdsId(msdsId));
    }

    /**
     * 新增运输信息
     */
    @PreAuthorize("@ss.hasPermi('system:transportation:add')")
    @Log(title = "运输信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody MsdsTransportation msdsTransportation)
    {
        return toAjax(msdsTransportationService.insertMsdsTransportation(msdsTransportation));
    }

    /**
     * 修改运输信息
     */
    @PreAuthorize("@ss.hasPermi('system:transportation:edit')")
    @Log(title = "运输信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody MsdsTransportation msdsTransportation)
    {
        return toAjax(msdsTransportationService.updateMsdsTransportation(msdsTransportation));
    }

    /**
     * 删除运输信息
     */
    @PreAuthorize("@ss.hasPermi('system:transportation:remove')")
    @Log(title = "运输信息", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(msdsTransportationService.deleteMsdsTransportationByIds(ids));
    }
} 