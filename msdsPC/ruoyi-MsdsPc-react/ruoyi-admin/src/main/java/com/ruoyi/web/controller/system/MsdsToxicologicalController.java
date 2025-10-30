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
import com.ruoyi.system.domain.MsdsToxicological;
import com.ruoyi.system.service.IMsdsToxicologicalService;

/**
 * 毒理学资料 信息操作处理
 * 
 * @author ruoyi
 * @date 2024-02-18
 */
@RestController
@RequestMapping("/system/msds/toxicological")
public class MsdsToxicologicalController extends BaseController
{
    @Autowired
    private IMsdsToxicologicalService msdsToxicologicalService;

    /**
     * 查询毒理学资料列表
     */
    @PreAuthorize("@ss.hasPermi('system:toxicological:list')")
    @GetMapping("/list")
    public TableDataInfo list(MsdsToxicological msdsToxicological)
    {
        startPage();
        List<MsdsToxicological> list = msdsToxicologicalService.selectMsdsToxicologicalList(msdsToxicological);
        return getDataTable(list);
    }

    /**
     * 获取毒理学资料详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:toxicological:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(msdsToxicologicalService.selectMsdsToxicologicalById(id));
    }

    /**
     * 根据MSDS主表ID获取毒理学资料信息
     */
    @PreAuthorize("@ss.hasPermi('system:toxicological:query')")
    @GetMapping(value = "/msds/{msdsId}")
    public AjaxResult getInfoByMsdsId(@PathVariable("msdsId") Long msdsId)
    {
        return success(msdsToxicologicalService.selectMsdsToxicologicalByMsdsId(msdsId));
    }

    /**
     * 新增毒理学资料
     */
    @PreAuthorize("@ss.hasPermi('system:toxicological:add')")
    @Log(title = "毒理学资料", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody MsdsToxicological msdsToxicological)
    {
        return toAjax(msdsToxicologicalService.insertMsdsToxicological(msdsToxicological));
    }

    /**
     * 修改毒理学资料
     */
    @PreAuthorize("@ss.hasPermi('system:toxicological:edit')")
    @Log(title = "毒理学资料", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody MsdsToxicological msdsToxicological)
    {
        return toAjax(msdsToxicologicalService.updateMsdsToxicological(msdsToxicological));
    }

    /**
     * 删除毒理学资料
     */
    @PreAuthorize("@ss.hasPermi('system:toxicological:remove')")
    @Log(title = "毒理学资料", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(msdsToxicologicalService.deleteMsdsToxicologicalByIds(ids));
    }
} 