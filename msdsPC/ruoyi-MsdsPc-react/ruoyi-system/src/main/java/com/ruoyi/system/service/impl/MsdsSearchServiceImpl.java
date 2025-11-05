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
        // 执行搜索
        List<MsdsMain> results;
        
        if (StringUtils.isEmpty(searchType)) {
            searchType = "general";
        }
        
        switch (searchType.toLowerCase()) {
            case "cas":
                results = searchMapper.searchByCasNumber(keyword);
                break;
            case "formula":
                results = searchMapper.searchByFormula(keyword);
                break;
            case "semantic":
                // 语义搜索，当前使用通用搜索实现
                results = searchMapper.intelligentSearch(keyword, searchType, filters);
                break;
            default:
                results = searchMapper.intelligentSearch(keyword, searchType, filters);
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
     * 获取热门搜索
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
        
        return searchSuggestionMapper.selectActiveByType("hot", limit);
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

