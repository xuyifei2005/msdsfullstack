package com.ruoyi.system.service.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.MsdsMain;
import com.ruoyi.system.domain.MsdsSearchHistory;
import com.ruoyi.system.domain.MsdsSearchSuggestion;
import com.ruoyi.system.mapper.MsdsSearchMapper;
import com.ruoyi.system.mapper.MsdsSearchHistoryMapper;
import com.ruoyi.system.mapper.MsdsSearchSuggestionMapper;
import com.ruoyi.system.service.IMsdsSearchService;

/**
 * MSDS智能搜索服务实现
 * 
 * @author ruoyi
 * @date 2025-01-XX
 */
@Service
public class MsdsSearchServiceImpl implements IMsdsSearchService 
{
    private static final Logger log = LoggerFactory.getLogger(MsdsSearchServiceImpl.class);

    @Autowired
    private MsdsSearchMapper searchMapper;

    @Autowired
    private MsdsSearchHistoryMapper searchHistoryMapper;

    @Autowired
    private MsdsSearchSuggestionMapper searchSuggestionMapper;

    /**
     * 智能搜索MSDS文档
     *
     * @param keyword 搜索关键词
     * @param searchType 搜索类型
     * @param filters 筛选条件
     * @param userId 用户ID
     * @return MSDS文档列表
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public List<MsdsMain> intelligentSearch(String keyword, String searchType, Map<String, Object> filters, Long userId) 
    {
        log.info("智能搜索开始 - keyword: {}, searchType: {}, filters: {}, userId: {}", keyword, searchType, filters, userId);
        
        // 执行搜索
        List<MsdsMain> results;
        
        if (StringUtils.isEmpty(searchType)) {
            searchType = "general";
        }
        
        log.debug("使用搜索类型: {}", searchType);
        
        switch (searchType.toLowerCase()) {
            case "cas":
                log.debug("执行CAS号搜索: {}", keyword);
                results = searchMapper.searchByCasNumber(keyword);
                break;
            case "formula":
                log.debug("执行分子式搜索: {}", keyword);
                results = searchMapper.searchByFormula(keyword);
                break;
            case "semantic":
                // 语义搜索，当前使用通用搜索实现
                log.debug("执行语义搜索: {}", keyword);
                results = searchMapper.intelligentSearch(keyword, searchType, filters);
                break;
            default:
                log.debug("执行通用搜索: {}", keyword);
                results = searchMapper.intelligentSearch(keyword, searchType, filters);
        }
        
        log.info("搜索完成 - 找到 {} 条记录", results != null ? results.size() : 0);
        
        if (results != null && !results.isEmpty()) {
            log.debug("搜索结果示例: 第一条记录ID={}, 名称={}", 
                     results.get(0).getId(), results.get(0).getProductName());
        }
        
        // 记录搜索历史
        if (userId != null && StringUtils.isNotEmpty(keyword)) {
            try {
                MsdsSearchHistory history = new MsdsSearchHistory();
                history.setUserId(userId);
                history.setSearchKeyword(keyword);
                history.setSearchType(searchType);
                history.setResultCount(results != null ? results.size() : 0);
                history.setSearchTime(new Date());
                recordSearchHistory(history);
                log.debug("搜索历史已记录");
            } catch (Exception e) {
                log.error("记录搜索历史失败", e);
            }
        }
        
        return results;
    }

    /**
     * 获取搜索建议
     *
     * @param keyword 关键词
     * @param limit 数量限制
     * @return 建议列表
     */
    @Override
    public List<Map<String, Object>> getSearchSuggestions(String keyword, Integer limit) 
    {
        if (StringUtils.isEmpty(keyword)) {
            return null;
        }
        
        if (limit == null || limit <= 0) {
            limit = 10;
        }
        
        return searchMapper.getSearchSuggestions(keyword, limit);
    }

    /**
     * 危险性分类检索关键字（与前端筛选项一一对应）
     */
    private static final List<String> HAZARD_KEYWORDS = java.util.Arrays.asList("易燃", "腐蚀", "毒", "氧化");

    /** 热门搜索的统计窗口（天） */
    private static final int HOT_SEARCH_DAYS = 30;

    /**
     * 获取危险性分类的真实文档数量
     *
     * @return 关键字与文档数量的映射列表
     */
    @Override
    public List<Map<String, Object>> getHazardFacetCounts()
    {
        return searchMapper.getHazardFacetCounts(HAZARD_KEYWORDS);
    }

    /**
     * 获取热门搜索
     *
     * <p>数据来源为两个真实来源的合并：
     * <ol>
     *   <li><b>实际搜索行为</b>：按 msds_search_history 中用户真实输入过的关键词
     *       聚合搜索次数（近 30 天），这是热门搜索的主要来源；</li>
     *   <li><b>运营策展词条</b>：msds_search_suggestion 中 keyword_type='hot' 的词条
     *       （如安全月推荐的重点品种），按 sort_order 优先展示。</li>
     * </ol>
     * 两者按关键词去重：实际搜索次数优先，其次用策展词条的搜索次数。</p>
     *
     * @param limit 数量限制
     * @return 热门搜索列表
     */
    @Override
    public List<MsdsSearchSuggestion> getHotSearches(Integer limit) 
    {
        if (limit == null || limit <= 0) {
            limit = 10;
        }

        // 1. 运营策展的热门词条（人工维护，可控顺序）
        List<MsdsSearchSuggestion> curated = searchSuggestionMapper.selectActiveByType("hot", limit);
        Map<String, MsdsSearchSuggestion> merged = new java.util.LinkedHashMap<>();
        if (curated != null) {
            for (MsdsSearchSuggestion item : curated) {
                if (item.getKeyword() != null && !item.getKeyword().isEmpty()) {
                    if (item.getSearchCount() == null) {
                        item.setSearchCount(0);
                    }
                    merged.put(item.getKeyword(), item);
                }
            }
        }

        // 2. 真实搜索历史聚合（近 30 天的实际搜索次数）
        List<Map<String, Object>> hotStats = searchHistoryMapper.selectHotKeywordStats(HOT_SEARCH_DAYS, limit * 2);
        if (hotStats != null) {
            for (Map<String, Object> row : hotStats) {
                Object keywordObj = row.get("keyword");
                if (keywordObj == null) {
                    continue;
                }
                String keyword = String.valueOf(keywordObj);
                if (keyword.isEmpty()) {
                    continue;
                }
                int searchCount = row.get("searchCount") == null
                        ? 0 : Integer.parseInt(String.valueOf(row.get("searchCount")));

                MsdsSearchSuggestion existing = merged.get(keyword);
                if (existing != null) {
                    // 策展词条已存在：累加真实搜索次数，保留策展的展示顺序
                    existing.setSearchCount((existing.getSearchCount() == null ? 0 : existing.getSearchCount()) + searchCount);
                }
                else {
                    MsdsSearchSuggestion suggestion = new MsdsSearchSuggestion();
                    suggestion.setKeyword(keyword);
                    suggestion.setKeywordType("hot");
                    suggestion.setSearchCount(searchCount);
                    suggestion.setClickCount(0);
                    suggestion.setIsActive(1);
                    merged.put(keyword, suggestion);
                }
            }
        }

        // 3. 按搜索次数倒序输出（次数相同则策展词条在前）
        List<MsdsSearchSuggestion> result = new java.util.ArrayList<>(merged.values());
        result.sort((a, b) -> {
            int ca = a.getSearchCount() == null ? 0 : a.getSearchCount();
            int cb = b.getSearchCount() == null ? 0 : b.getSearchCount();
            if (ca != cb) {
                return Integer.compare(cb, ca);
            }
            int sa = a.getSortOrder() == null ? Integer.MAX_VALUE : a.getSortOrder();
            int sb = b.getSortOrder() == null ? Integer.MAX_VALUE : b.getSortOrder();
            return Integer.compare(sa, sb);
        });

        return result.size() > limit ? result.subList(0, limit) : result;
    }

    /**
     * 查询搜索建议词条列表（供运营维护）
     */
    @Override
    public List<MsdsSearchSuggestion> listSuggestions(MsdsSearchSuggestion suggestion)
    {
        return searchSuggestionMapper.selectMsdsSearchSuggestionList(suggestion);
    }

    /**
     * 新增搜索建议词条
     */
    @Override
    public int addSuggestion(MsdsSearchSuggestion suggestion)
    {
        if (suggestion.getCreateTime() == null) {
            suggestion.setCreateTime(new java.util.Date());
        }
        return searchSuggestionMapper.insertMsdsSearchSuggestion(suggestion);
    }

    /**
     * 修改搜索建议词条
     */
    @Override
    public int editSuggestion(MsdsSearchSuggestion suggestion)
    {
        suggestion.setUpdateTime(new java.util.Date());
        return searchSuggestionMapper.updateMsdsSearchSuggestion(suggestion);
    }

    /**
     * 删除搜索建议词条
     */
    @Override
    public int removeSuggestions(Long[] suggestionIds)
    {
        return searchSuggestionMapper.deleteMsdsSearchSuggestionBySuggestionIds(suggestionIds);
    }

    /**
     * 获取用户搜索历史
     *
     * @param userId 用户ID
     * @param limit 数量限制
     * @return 搜索历史列表
     */
    @Override
    public List<MsdsSearchHistory> getUserSearchHistory(Long userId, Integer limit) 
    {
        if (userId == null) {
            return null;
        }
        
        if (limit == null || limit <= 0) {
            limit = 20;
        }
        
        return searchHistoryMapper.selectRecentSearchHistory(userId, limit);
    }

    /**
     * 清除用户搜索历史
     *
     * @param userId 用户ID
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int clearUserSearchHistory(Long userId) 
    {
        if (userId == null) {
            return 0;
        }
        
        return searchHistoryMapper.deleteMsdsSearchHistoryByUserId(userId);
    }

    /**
     * 删除搜索历史
     *
     * @param searchIds 搜索记录ID数组
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deleteSearchHistory(Long[] searchIds) 
    {
        return searchHistoryMapper.deleteMsdsSearchHistoryBySearchIds(searchIds);
    }

    /**
     * 获取相关文档
     *
     * @param msdsId 文档ID
     * @param limit 数量限制
     * @return MSDS文档列表
     */
    @Override
    public List<MsdsMain> getRelatedDocuments(Long msdsId, Integer limit) 
    {
        if (msdsId == null) {
            return null;
        }
        
        if (limit == null || limit <= 0) {
            limit = 5;
        }
        
        return searchMapper.getRelatedDocuments(msdsId, limit);
    }

    /**
     * 高级搜索
     *
     * @param filters 筛选条件
     * @return MSDS文档列表
     */
    @Override
    public List<MsdsMain> advancedSearch(Map<String, Object> filters) 
    {
        return searchMapper.advancedSearch(filters);
    }

    /**
     * 记录搜索行为
     *
     * @param searchHistory 搜索历史记录
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int recordSearchHistory(MsdsSearchHistory searchHistory) 
    {
        return searchHistoryMapper.insertMsdsSearchHistory(searchHistory);
    }

    /**
     * 更新搜索建议统计
     *
     * @param keyword 关键词
     * @param clicked 是否被点击
     * @return 结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateSuggestionStats(String keyword, boolean clicked) 
    {
        // 根据关键词查找建议
        MsdsSearchSuggestion searchSuggestion = new MsdsSearchSuggestion();
        searchSuggestion.setKeyword(keyword);
        List<MsdsSearchSuggestion> suggestions = searchSuggestionMapper.selectMsdsSearchSuggestionList(searchSuggestion);
        
        if (suggestions != null && !suggestions.isEmpty()) {
            MsdsSearchSuggestion suggestion = suggestions.get(0);
            if (clicked) {
                return searchSuggestionMapper.incrementClickCount(suggestion.getSuggestionId());
            } else {
                return searchSuggestionMapper.incrementSearchCount(suggestion.getSuggestionId());
            }
        }
        
        return 0;
    }
}

