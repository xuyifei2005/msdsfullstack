package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.MsdsSearchSuggestion;
import org.apache.ibatis.annotations.Param;

/**
 * MSDS搜索建议Mapper接口
 * 
 * @author ruoyi
 * @date 2025-01-XX
 */
public interface MsdsSearchSuggestionMapper 
{
    /**
     * 查询搜索建议
     * 
     * @param suggestionId 搜索建议主键
     * @return 搜索建议
     */
    public MsdsSearchSuggestion selectMsdsSearchSuggestionBySuggestionId(Long suggestionId);

    /**
     * 查询搜索建议列表
     * 
     * @param msdsSearchSuggestion 搜索建议
     * @return 搜索建议集合
     */
    public List<MsdsSearchSuggestion> selectMsdsSearchSuggestionList(MsdsSearchSuggestion msdsSearchSuggestion);

    /**
     * 根据关键词类型查询激活的搜索建议
     * 
     * @param keywordType 关键词类型
     * @param limit 数量限制
     * @return 搜索建议集合
     */
    public List<MsdsSearchSuggestion> selectActiveByType(@Param("keywordType") String keywordType, @Param("limit") Integer limit);

    /**
     * 新增搜索建议
     * 
     * @param msdsSearchSuggestion 搜索建议
     * @return 结果
     */
    public int insertMsdsSearchSuggestion(MsdsSearchSuggestion msdsSearchSuggestion);

    /**
     * 修改搜索建议
     * 
     * @param msdsSearchSuggestion 搜索建议
     * @return 结果
     */
    public int updateMsdsSearchSuggestion(MsdsSearchSuggestion msdsSearchSuggestion);

    /**
     * 增加搜索次数
     * 
     * @param suggestionId 建议ID
     * @return 结果
     */
    public int incrementSearchCount(@Param("suggestionId") Long suggestionId);

    /**
     * 增加点击次数
     * 
     * @param suggestionId 建议ID
     * @return 结果
     */
    public int incrementClickCount(@Param("suggestionId") Long suggestionId);

    /**
     * 批量删除搜索建议
     * 
     * @param suggestionIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteMsdsSearchSuggestionBySuggestionIds(Long[] suggestionIds);
}

