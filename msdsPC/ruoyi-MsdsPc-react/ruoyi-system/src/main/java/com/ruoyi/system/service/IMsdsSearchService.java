package com.ruoyi.system.service;

import java.util.List;
import java.util.Map;
import com.ruoyi.system.domain.MsdsMain;
import com.ruoyi.system.domain.MsdsSearchHistory;
import com.ruoyi.system.domain.MsdsSearchSuggestion;

/**
 * MSDS智能搜索服务接口
 * 
 * @author ruoyi
 * @date 2025-01-XX
 */
public interface IMsdsSearchService 
{
    /**
     * 智能搜索MSDS文档
     * 
     * @param keyword 搜索关键词
     * @param searchType 搜索类型 (general, semantic, cas, formula)
     * @param filters 筛选条件
     * @param userId 用户ID（可选，用于记录搜索历史）
     * @return MSDS文档列表
     */
    public List<MsdsMain> intelligentSearch(String keyword, String searchType, Map<String, Object> filters, Long userId);

    /**
     * 获取搜索建议
     * 
     * @param keyword 关键词
     * @param limit 数量限制
     * @return 建议列表
     */
    public List<Map<String, Object>> getSearchSuggestions(String keyword, Integer limit);

    /**
     * 获取危险性分类的真实文档数量（用于高级筛选项计数）
     *
     * @return 关键字与文档数量的映射列表
     */
    public List<Map<String, Object>> getHazardFacetCounts();

    /**
     * 获取热门搜索
     * 
     * @param limit 数量限制
     * @return 热门搜索列表
     */
    public List<MsdsSearchSuggestion> getHotSearches(Integer limit);

    /**
     * 查询搜索建议词条列表（供运营维护）
     *
     * @param suggestion 查询条件
     * @return 词条列表
     */
    public List<MsdsSearchSuggestion> listSuggestions(MsdsSearchSuggestion suggestion);

    /**
     * 新增搜索建议词条
     *
     * @param suggestion 词条
     * @return 结果
     */
    public int addSuggestion(MsdsSearchSuggestion suggestion);

    /**
     * 修改搜索建议词条
     *
     * @param suggestion 词条
     * @return 结果
     */
    public int editSuggestion(MsdsSearchSuggestion suggestion);

    /**
     * 删除搜索建议词条
     *
     * @param suggestionIds 词条ID数组
     * @return 结果
     */
    public int removeSuggestions(Long[] suggestionIds);

    /**
     * 获取用户搜索历史
     * 
     * @param userId 用户ID
     * @param limit 数量限制
     * @return 搜索历史列表
     */
    public List<MsdsSearchHistory> getUserSearchHistory(Long userId, Integer limit);

    /**
     * 清除用户搜索历史
     * 
     * @param userId 用户ID
     * @return 结果
     */
    public int clearUserSearchHistory(Long userId);

    /**
     * 删除搜索历史
     * 
     * @param searchIds 搜索记录ID数组
     * @return 结果
     */
    public int deleteSearchHistory(Long[] searchIds);

    /**
     * 获取相关文档
     * 
     * @param msdsId 文档ID
     * @param limit 数量限制
     * @return MSDS文档列表
     */
    public List<MsdsMain> getRelatedDocuments(Long msdsId, Integer limit);

    /**
     * 高级搜索
     * 
     * @param filters 筛选条件
     * @return MSDS文档列表
     */
    public List<MsdsMain> advancedSearch(Map<String, Object> filters);

    /**
     * 记录搜索行为（内部使用）
     * 
     * @param searchHistory 搜索历史记录
     * @return 结果
     */
    public int recordSearchHistory(MsdsSearchHistory searchHistory);

    /**
     * 更新搜索建议统计
     * 
     * @param keyword 关键词
     * @param clicked 是否被点击
     * @return 结果
     */
    public int updateSuggestionStats(String keyword, boolean clicked);
}

