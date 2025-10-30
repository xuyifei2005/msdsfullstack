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
import com.ruoyi.system.domain.MsdsLeakResponse;
import com.ruoyi.system.service.IMsdsLeakResponseService;

/**
 * 泄漏应急处理 信息操作处理
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
@RestController
@RequestMapping("/system/msds/leakResponse")
public class MsdsLeakResponseController extends BaseController
{
    @Autowired
    private IMsdsLeakResponseService msdsLeakResponseService;

    /**
     * 查询泄漏应急处理列表
     */
    @PreAuthorize("@ss.hasPermi('system:leakResponse:list')")
    @GetMapping("/list")
    public TableDataInfo list(MsdsLeakResponse msdsLeakResponse)
    {
        startPage();
        List<MsdsLeakResponse> list = msdsLeakResponseService.selectMsdsLeakResponseList(msdsLeakResponse);
        return getDataTable(list);
    }

    /**
     * 获取泄漏应急处理详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:leakResponse:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(msdsLeakResponseService.selectMsdsLeakResponseById(id));
    }

    /**
     * 根据MSDS主表ID获取泄漏应急处理
     */
    @PreAuthorize("@ss.hasPermi('system:leakResponse:query')")
    @GetMapping(value = "/msds/{msdsId}")
    public AjaxResult getInfoByMsdsId(@PathVariable("msdsId") Long msdsId)
    {
        return success(msdsLeakResponseService.selectMsdsLeakResponseByMsdsId(msdsId));
    }

    /**
     * 新增泄漏应急处理
     */
    @PreAuthorize("@ss.hasPermi('system:leakResponse:add')")
    @Log(title = "泄漏应急处理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody MsdsLeakResponse msdsLeakResponse)
    {
        return toAjax(msdsLeakResponseService.insertMsdsLeakResponse(msdsLeakResponse));
    }

    /**
     * 修改泄漏应急处理
     */
    @PreAuthorize("@ss.hasPermi('system:leakResponse:edit')")
    @Log(title = "泄漏应急处理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody MsdsLeakResponse msdsLeakResponse)
    {
        return toAjax(msdsLeakResponseService.updateMsdsLeakResponse(msdsLeakResponse));
    }

    /**
     * 删除泄漏应急处理
     */
    @PreAuthorize("@ss.hasPermi('system:leakResponse:remove')")
    @Log(title = "泄漏应急处理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(msdsLeakResponseService.deleteMsdsLeakResponseByIds(ids));
    }
} 