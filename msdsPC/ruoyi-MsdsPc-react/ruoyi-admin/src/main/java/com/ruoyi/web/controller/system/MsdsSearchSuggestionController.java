package com.ruoyi.web.controller.system;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
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
import com.ruoyi.system.domain.MsdsSearchSuggestion;
import com.ruoyi.system.service.IMsdsSearchService;

/**
 * 热门搜索词条维护 Controller
 *
 * <p>用于维护 msds_search_suggestion 中的运营策展词条（如安全月重点品种）。
 * 热门搜索列表由「真实搜索历史聚合」+「本表策展词条」合并而成。</p>
 *
 * @author ruoyi
 * @date 2026-11-19
 */
@RestController
@RequestMapping("/system/msds/search/suggestion")
public class MsdsSearchSuggestionController extends BaseController
{
    @Autowired
    private IMsdsSearchService searchService;

    /**
     * 查询搜索词条列表
     */
    @PreAuthorize("@ss.hasPermi('system:msds:list')")
    @GetMapping("/list")
    public TableDataInfo list(MsdsSearchSuggestion suggestion)
    {
        List<MsdsSearchSuggestion> list = searchService.listSuggestions(suggestion);
        return getDataTable(list);
    }

    /**
     * 新增搜索词条
     */
    @PreAuthorize("@ss.hasPermi('system:msds:edit')")
    @Log(title = "热门搜索词条", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody MsdsSearchSuggestion suggestion)
    {
        return toAjax(searchService.addSuggestion(suggestion));
    }

    /**
     * 修改搜索词条
     */
    @PreAuthorize("@ss.hasPermi('system:msds:edit')")
    @Log(title = "热门搜索词条", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody MsdsSearchSuggestion suggestion)
    {
        return toAjax(searchService.editSuggestion(suggestion));
    }

    /**
     * 删除搜索词条
     */
    @PreAuthorize("@ss.hasPermi('system:msds:remove')")
    @Log(title = "热门搜索词条", businessType = BusinessType.DELETE)
    @DeleteMapping("/{suggestionIds}")
    public AjaxResult remove(@PathVariable Long[] suggestionIds)
    {
        return toAjax(searchService.removeSuggestions(suggestionIds));
    }
}
