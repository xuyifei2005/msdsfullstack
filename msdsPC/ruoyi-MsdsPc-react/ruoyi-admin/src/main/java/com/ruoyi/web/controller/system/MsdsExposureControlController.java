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
import com.ruoyi.system.domain.MsdsExposureControl;
import com.ruoyi.system.service.IMsdsExposureControlService;

/**
 * 接触控制/个体防护 信息操作处理
 * 
 * @author ruoyi
 * @date 2024-02-18
 */
@RestController
@RequestMapping("/system/msds/exposure")
public class MsdsExposureControlController extends BaseController
{
    @Autowired
    private IMsdsExposureControlService msdsExposureControlService;

    /**
     * 查询接触控制/个体防护列表
     */
    @PreAuthorize("@ss.hasPermi('system:exposure:list')")
    @GetMapping("/list")
    public TableDataInfo list(MsdsExposureControl msdsExposureControl)
    {
        startPage();
        List<MsdsExposureControl> list = msdsExposureControlService.selectMsdsExposureControlList(msdsExposureControl);
        return getDataTable(list);
    }

    /**
     * 获取接触控制/个体防护详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:exposure:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(msdsExposureControlService.selectMsdsExposureControlById(id));
    }

    /**
     * 根据MSDS主表ID获取接触控制/个体防护信息
     */
    @PreAuthorize("@ss.hasPermi('system:exposure:query')")
    @GetMapping(value = "/msds/{msdsId}")
    public AjaxResult getInfoByMsdsId(@PathVariable("msdsId") Long msdsId)
    {
        return success(msdsExposureControlService.selectMsdsExposureControlByMsdsId(msdsId));
    }

    /**
     * 新增接触控制/个体防护
     */
    @PreAuthorize("@ss.hasPermi('system:exposure:add')")
    @Log(title = "接触控制/个体防护", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody MsdsExposureControl msdsExposureControl)
    {
        return toAjax(msdsExposureControlService.insertMsdsExposureControl(msdsExposureControl));
    }

    /**
     * 修改接触控制/个体防护
     */
    @PreAuthorize("@ss.hasPermi('system:exposure:edit')")
    @Log(title = "接触控制/个体防护", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody MsdsExposureControl msdsExposureControl)
    {
        return toAjax(msdsExposureControlService.updateMsdsExposureControl(msdsExposureControl));
    }

    /**
     * 删除接触控制/个体防护
     */
    @PreAuthorize("@ss.hasPermi('system:exposure:remove')")
    @Log(title = "接触控制/个体防护", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(msdsExposureControlService.deleteMsdsExposureControlByIds(ids));
    }
} 