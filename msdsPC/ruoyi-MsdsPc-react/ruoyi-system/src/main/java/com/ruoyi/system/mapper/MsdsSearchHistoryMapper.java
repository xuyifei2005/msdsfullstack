package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.MsdsSearchHistory;

/**
 * MSDS搜索历史Mapper接口
 * 
 * @author ruoyi
 * @date 2025-01-XX
 */
public interface MsdsSearchHistoryMapper 
{
    /**
     * 查询搜索历史
     * 
     * @param searchId 搜索历史主键
     * @return 搜索历史
     */
    public MsdsSearchHistory selectMsdsSearchHistoryBySearchId(Long searchId);

    /**
     * 查询搜索历史列表
     * 
     * @param msdsSearchHistory 搜索历史
     * @return 搜索历史集合
     */
    public List<MsdsSearchHistory> selectMsdsSearchHistoryList(MsdsSearchHistory msdsSearchHistory);

    /**
     * 查询用户最近的搜索历史
     * 
     * @param userId 用户ID
     * @param limit 数量限制
     * @return 搜索历史集合
     */
    public List<MsdsSearchHistory> selectRecentSearchHistory(Long userId, Integer limit);

    /**
     * 新增搜索历史
     * 
     * @param msdsSearchHistory 搜索历史
     * @return 结果
     */
    public int insertMsdsSearchHistory(MsdsSearchHistory msdsSearchHistory);

    /**
     * 批量删除搜索历史
     * 
     * @param searchIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteMsdsSearchHistoryBySearchIds(Long[] searchIds);

    /**
     * 删除用户的搜索历史
     * 
     * @param userId 用户ID
     * @return 结果
     */
    public int deleteMsdsSearchHistoryByUserId(Long userId);

    /**
     * 获取热门搜索关键词
     * 
     * @param limit 数量限制
     * @return 关键词列表
     */
    public List<String> selectHotSearchKeywords(Integer limit);
}

