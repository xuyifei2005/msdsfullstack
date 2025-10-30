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
import com.ruoyi.system.domain.MsdsHandlingStorage;
import com.ruoyi.system.service.IMsdsHandlingStorageService;

/**
 * 操作处置与储存 信息操作处理
 * 
 * @author ruoyi
 * @date 2024-02-18
 */
@RestController
@RequestMapping("/system/msds/handling")
public class MsdsHandlingStorageController extends BaseController
{
    @Autowired
    private IMsdsHandlingStorageService msdsHandlingStorageService;

    /**
     * 查询操作处置与储存列表
     */
    @PreAuthorize("@ss.hasPermi('system:handling:list')")
    @GetMapping("/list")
    public TableDataInfo list(MsdsHandlingStorage msdsHandlingStorage)
    {
        startPage();
        List<MsdsHandlingStorage> list = msdsHandlingStorageService.selectMsdsHandlingStorageList(msdsHandlingStorage);
        return getDataTable(list);
    }

    /**
     * 获取操作处置与储存详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:handling:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(msdsHandlingStorageService.selectMsdsHandlingStorageById(id));
    }

    /**
     * 根据MSDS主表ID获取操作处置与储存信息
     */
    @PreAuthorize("@ss.hasPermi('system:handling:query')")
    @GetMapping(value = "/msds/{msdsId}")
    public AjaxResult getInfoByMsdsId(@PathVariable("msdsId") Long msdsId)
    {
        return success(msdsHandlingStorageService.selectMsdsHandlingStorageByMsdsId(msdsId));
    }

    /**
     * 新增操作处置与储存
     */
    @PreAuthorize("@ss.hasPermi('system:handling:add')")
    @Log(title = "操作处置与储存", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody MsdsHandlingStorage msdsHandlingStorage)
    {
        return toAjax(msdsHandlingStorageService.insertMsdsHandlingStorage(msdsHandlingStorage));
    }

    /**
     * 修改操作处置与储存
     */
    @PreAuthorize("@ss.hasPermi('system:handling:edit')")
    @Log(title = "操作处置与储存", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody MsdsHandlingStorage msdsHandlingStorage)
    {
        return toAjax(msdsHandlingStorageService.updateMsdsHandlingStorage(msdsHandlingStorage));
    }

    /**
     * 删除操作处置与储存
     */
    @PreAuthorize("@ss.hasPermi('system:handling:remove')")
    @Log(title = "操作处置与储存", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(msdsHandlingStorageService.deleteMsdsHandlingStorageByIds(ids));
    }
} 