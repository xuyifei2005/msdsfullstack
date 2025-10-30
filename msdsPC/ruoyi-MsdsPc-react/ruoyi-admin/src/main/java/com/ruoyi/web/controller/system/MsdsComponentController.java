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
import com.ruoyi.system.domain.MsdsComponent;
import com.ruoyi.system.service.IMsdsComponentService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * MSDS成分/组成信息Controller
 * 
 * @author ruoyi
 * @date 2024-01-15
 */
@RestController
@RequestMapping("/system/msds/component")
public class MsdsComponentController extends BaseController
{
    @Autowired
    private IMsdsComponentService msdsComponentService;

    /**
     * 查询MSDS成分/组成信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:msds:list')")
    @GetMapping("/list")
    public TableDataInfo list(MsdsComponent msdsComponent)
    {
        startPage();
        List<MsdsComponent> list = msdsComponentService.selectMsdsComponentList(msdsComponent);
        return getDataTable(list);
    }

    /**
     * 导出MSDS成分/组成信息列表
     */
    @PreAuthorize("@ss.hasPermi('system:msds:export')")
    @Log(title = "MSDS成分/组成信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, MsdsComponent msdsComponent)
    {
        List<MsdsComponent> list = msdsComponentService.selectMsdsComponentList(msdsComponent);
        ExcelUtil<MsdsComponent> util = new ExcelUtil<MsdsComponent>(MsdsComponent.class);
        util.exportExcel(response, list, "MSDS成分/组成信息数据");
    }

    /**
     * 获取MSDS成分/组成信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:msds:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(msdsComponentService.selectMsdsComponentById(id));
    }

    /**
     * 根据MSDS主表ID获取成分/组成信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:msds:query')")
    @GetMapping(value = "/msds/{msdsId}")
    public AjaxResult getInfoByMsdsId(@PathVariable("msdsId") Long msdsId)
    {
        List<MsdsComponent> list = msdsComponentService.selectMsdsComponentByMsdsId(msdsId);
        return success(list);
    }

    /**
     * 新增MSDS成分/组成信息
     */
    @PreAuthorize("@ss.hasPermi('system:msds:add')")
    @Log(title = "MSDS成分/组成信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody MsdsComponent msdsComponent)
    {
        return toAjax(msdsComponentService.insertMsdsComponent(msdsComponent));
    }

    /**
     * 修改MSDS成分/组成信息
     */
    @PreAuthorize("@ss.hasPermi('system:msds:edit')")
    @Log(title = "MSDS成分/组成信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody MsdsComponent msdsComponent)
    {
        return toAjax(msdsComponentService.updateMsdsComponent(msdsComponent));
    }

    /**
     * 删除MSDS成分/组成信息
     */
    @PreAuthorize("@ss.hasPermi('system:msds:remove')")
    @Log(title = "MSDS成分/组成信息", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(msdsComponentService.deleteMsdsComponentByIds(ids));
    }

    /**
     * 根据MSDS主表ID删除成分/组成信息
     */
    @PreAuthorize("@ss.hasPermi('system:msds:remove')")
    @Log(title = "MSDS成分/组成信息", businessType = BusinessType.DELETE)
    @DeleteMapping("/msds/{msdsId}")
    public AjaxResult removeByMsdsId(@PathVariable Long msdsId)
    {
        return toAjax(msdsComponentService.deleteMsdsComponentByMsdsId(msdsId));
    }

    /**
     * 批量保存成分/组成信息
     */
    @PreAuthorize("@ss.hasPermi('system:msds:edit')")
    @Log(title = "MSDS成分/组成信息", businessType = BusinessType.INSERT)
    @PostMapping("/batch")
    public AjaxResult batchSave(@RequestBody List<MsdsComponent> components)
    {
        return toAjax(msdsComponentService.batchSaveMsdsComponent(components));
    }

    /**
     * 验证CAS号格式
     */
    @GetMapping("/validate/cas")
    public AjaxResult validateCasNumber(@PathVariable("casNumber") String casNumber)
    {
        // 简单的CAS号格式验证：数字-数字-数字
        boolean isValid = casNumber.matches("\\d{1,7}-\\d{2}-\\d");
        return success(isValid);
    }

    /**
     * 根据CAS号查询化学品信息
     */
    @GetMapping("/chemical/cas")
    public AjaxResult getChemicalInfoByCas(@PathVariable("casNumber") String casNumber)
    {
        // 这里可以集成外部化学品数据库API
        // 暂时返回空结果
        return success(null);
    }
}