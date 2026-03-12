package com.ruoyi.web.controller.system;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.ip.IpUtils;
import com.ruoyi.system.domain.MsdsMain;
import com.ruoyi.system.domain.MsdsSearchHistory;
import com.ruoyi.system.domain.MsdsSearchSuggestion;
import com.ruoyi.system.service.IMsdsSearchService;

/**
 * MSDS智能搜索Controller
 * 
 * @author ruoyi
 * @date 2025-01-XX
 */
@RestController
@RequestMapping("/system/msds/search")
public class MsdsSearchController extends BaseController
{
    @Autowired
    private IMsdsSearchService searchService;

    /**
     * 智能搜索MSDS文档
     */
    @PreAuthorize("@ss.hasAnyPermi('system:msds:search,system:msds:list,system:msds:query')")
    @GetMapping("/intelligent")
    public TableDataInfo intelligentSearch(
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "searchType", required = false, defaultValue = "general") String searchType,
            @RequestParam(value = "documentType", required = false) String documentType,
            @RequestParam(value = "categoryId", required = false) Long categoryId,
            @RequestParam(value = "supplier", required = false) String supplier,
            @RequestParam(value = "sortBy", required = false, defaultValue = "relevance") String sortBy,
            HttpServletRequest request)
    {
        logger.info("收到智能搜索请求 - keyword: {}, searchType: {}, documentType: {}, categoryId: {}, supplier: {}, sortBy: {}",
                   keyword, searchType, documentType, categoryId, supplier, sortBy);
        try {
            Map<String, Object> filters = new HashMap<>();
            if (StringUtils.isNotEmpty(documentType)) {
                filters.put("documentType", documentType);
            }
            if (categoryId != null) {
                filters.put("categoryId", categoryId);
            }
            if (StringUtils.isNotEmpty(supplier)) {
                filters.put("supplier", supplier);
            }
            filters.put("sortBy", sortBy);

            Long userId = null;
            try {
                userId = SecurityUtils.getUserId();
                logger.debug("当前用户ID: {}", userId);
            } catch (Exception e) {
                logger.debug("获取用户ID失败，使用匿名搜索", e);
            }

            startPage();
            List<MsdsMain> list = searchService.intelligentSearch(keyword, searchType, filters, userId);
            TableDataInfo dataTable = getDataTable(list);
            logger.info("智能搜索完成 - 返回 {} 条记录，总数: {}", list.size(), dataTable.getTotal());
            return dataTable;
        } catch (Exception e) {
            logger.error("智能搜索执行失败", e);
            TableDataInfo failed = new TableDataInfo();
            failed.setCode(500);
            failed.setMsg("智能搜索服务异常，请稍后重试");
            failed.setRows(java.util.Collections.emptyList());
            failed.setTotal(0);
            return failed;
        }
    }

    /**
     * 高级搜索
     */
    @PreAuthorize("@ss.hasAnyPermi('system:msds:search,system:msds:list,system:msds:query')")
    @PostMapping("/advanced")
    public TableDataInfo advancedSearch(@RequestBody Map<String, Object> filters)
    {
        startPage();
        List<MsdsMain> list = searchService.advancedSearch(filters);
        return getDataTable(list);
    }

    /**
     * 获取搜索建议
     */
    @GetMapping("/suggestions")
    public AjaxResult getSearchSuggestions(
            @RequestParam("keyword") String keyword,
            @RequestParam(value = "limit", required = false, defaultValue = "10") Integer limit)
    {
        List<Map<String, Object>> suggestions = searchService.getSearchSuggestions(keyword, limit);
        return success(suggestions);
    }

    /**
     * 获取热门搜索
     */
    @GetMapping("/hot")
    public AjaxResult getHotSearches(
            @RequestParam(value = "limit", required = false, defaultValue = "10") Integer limit)
    {
        List<MsdsSearchSuggestion> hotSearches = searchService.getHotSearches(limit);
        return success(hotSearches);
    }

    /**
     * 获取用户搜索历史
     */
    @PreAuthorize("@ss.hasAnyPermi('system:msds:search,system:msds:list,system:msds:query')")
    @GetMapping("/history")
    public AjaxResult getUserSearchHistory(
            @RequestParam(value = "limit", required = false, defaultValue = "20") Integer limit)
    {
        Long userId = SecurityUtils.getUserId();
        List<MsdsSearchHistory> history = searchService.getUserSearchHistory(userId, limit);
        return success(history);
    }

    /**
     * 清除搜索历史
     */
    @PreAuthorize("@ss.hasAnyPermi('system:msds:search,system:msds:list,system:msds:query')")
    @Log(title = "搜索历史", businessType = BusinessType.DELETE)
    @DeleteMapping("/history/clear")
    public AjaxResult clearSearchHistory()
    {
        Long userId = SecurityUtils.getUserId();
        int result = searchService.clearUserSearchHistory(userId);
        return toAjax(result);
    }

    /**
     * 删除搜索历史记录
     */
    @PreAuthorize("@ss.hasAnyPermi('system:msds:search,system:msds:list,system:msds:query')")
    @Log(title = "搜索历史", businessType = BusinessType.DELETE)
    @DeleteMapping("/history/{searchIds}")
    public AjaxResult deleteSearchHistory(@PathVariable Long[] searchIds)
    {
        return toAjax(searchService.deleteSearchHistory(searchIds));
    }

    /**
     * 获取相关文档
     */
    @PreAuthorize("@ss.hasPermi('system:msds:query')")
    @GetMapping("/related/{msdsId}")
    public AjaxResult getRelatedDocuments(
            @PathVariable Long msdsId,
            @RequestParam(value = "limit", required = false, defaultValue = "5") Integer limit)
    {
        List<MsdsMain> relatedDocs = searchService.getRelatedDocuments(msdsId, limit);
        return success(relatedDocs);
    }

    /**
     * 记录搜索行为（供前端主动调用）
     */
    @PostMapping("/record")
    public AjaxResult recordSearch(@RequestBody MsdsSearchHistory searchHistory, HttpServletRequest request)
    {
        try {
            // 获取用户信息
            Long userId = SecurityUtils.getUserId();
            String userName = SecurityUtils.getUsername();
            
            searchHistory.setUserId(userId);
            searchHistory.setUserName(userName);
            searchHistory.setIpAddress(IpUtils.getIpAddr(request));
            searchHistory.setUserAgent(request.getHeader("User-Agent"));
            
            int result = searchService.recordSearchHistory(searchHistory);
            return toAjax(result);
        } catch (Exception e) {
            logger.error("记录搜索历史失败", e);
            return error("记录搜索历史失败");
        }
    }

    /**
     * 更新搜索建议统计
     */
    @PostMapping("/suggestion/stat")
    public AjaxResult updateSuggestionStat(
            @RequestParam("keyword") String keyword,
            @RequestParam(value = "clicked", required = false, defaultValue = "false") boolean clicked)
    {
        int result = searchService.updateSuggestionStats(keyword, clicked);
        return toAjax(result);
    }
}

