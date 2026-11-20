package com.ruoyi.web.controller.system;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.MsdsMain;
import com.ruoyi.system.service.IMsdsRegulatoryCategoryService;

/**
 * MSDS 监管分类标签 Controller
 *
 * <p>GET /system/msds/regulatoryCategories        分类标签 + 真实计数（PC / 小程序共用）
 * GET /system/msds/regulatoryCategories/items  某篇 MSDS 的分类判定依据</p>
 *
 * @author ruoyi
 * @date 2026-11-20
 */
@RestController
@RequestMapping("/system/msds/regulatoryCategories")
public class MsdsRegulatoryCategoryController
{
    @Autowired
    private IMsdsRegulatoryCategoryService categoryService;

    /**
     * 分类标签列表（默认全部由前端置为 ALL）
     * 支持与列表页一致的搜索参数，用于按当前搜索条件实时计算各标签数量。
     */
    @PreAuthorize("@ss.hasPermi('system:msds:list')")
    @GetMapping
    public AjaxResult list(MsdsMain query)
    {
        return AjaxResult.success(categoryService.selectCategoryStats(query));
    }

    /** 分类判定依据（法规名录 + CAS 匹配证据） */
    @PreAuthorize("@ss.hasPermi('system:msds:list')")
    @GetMapping("/items")
    public AjaxResult items(@RequestParam("msdsId") Long msdsId)
    {
        return AjaxResult.success(categoryService.selectMsdsCategoryItems(msdsId));
    }
}
