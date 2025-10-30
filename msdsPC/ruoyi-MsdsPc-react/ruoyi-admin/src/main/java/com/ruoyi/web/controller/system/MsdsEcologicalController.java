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
import com.ruoyi.system.domain.MsdsEcological;
import com.ruoyi.system.service.IMsdsEcologicalService;

/**
 * 生态学资料 信息操作处理
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
@RestController
@RequestMapping("/system/msds/ecology")
public class MsdsEcologicalController extends BaseController
{
    @Autowired
    private IMsdsEcologicalService msdsEcologicalService;

    /**
     * 查询生态学资料列表
     */
    @PreAuthorize("@ss.hasPermi('system:ecological:list')")
    @GetMapping("/list")
    public TableDataInfo list(MsdsEcological msdsEcological)
    {
        startPage();
        List<MsdsEcological> list = msdsEcologicalService.selectMsdsEcologicalList(msdsEcological);
        return getDataTable(list);
    }

    /**
     * 获取生态学资料详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:ecological:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(msdsEcologicalService.selectMsdsEcologicalById(id));
    }

    /**
     * 根据MSDS主表ID获取生态学资料
     */
    @PreAuthorize("@ss.hasPermi('system:ecological:query')")
    @GetMapping(value = "/msds/{msdsId}")
    public AjaxResult getInfoByMsdsId(@PathVariable("msdsId") Long msdsId)
    {
        return success(msdsEcologicalService.selectMsdsEcologicalByMsdsId(msdsId));
    }

    /**
     * 新增生态学资料
     */
    @PreAuthorize("@ss.hasPermi('system:ecological:add')")
    @Log(title = "生态学资料", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody MsdsEcological msdsEcological)
    {
        return toAjax(msdsEcologicalService.insertMsdsEcological(msdsEcological));
    }

    /**
     * 修改生态学资料
     */
    @PreAuthorize("@ss.hasPermi('system:ecological:edit')")
    @Log(title = "生态学资料", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody MsdsEcological msdsEcological)
    {
        return toAjax(msdsEcologicalService.updateMsdsEcological(msdsEcological));
    }

    /**
     * 删除生态学资料
     */
    @PreAuthorize("@ss.hasPermi('system:ecological:remove')")
    @Log(title = "生态学资料", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(msdsEcologicalService.deleteMsdsEcologicalByIds(ids));
    }
} 