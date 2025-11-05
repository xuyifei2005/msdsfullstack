package com.ruoyi.system.mapper;

import java.util.List;
import java.util.Map;
import com.ruoyi.system.domain.MsdsMain;
import org.apache.ibatis.annotations.Param;

/**
 * MSDS智能搜索Mapper接口
 * 
 * @author ruoyi
 * @date 2025-01-XX
 */
public interface MsdsSearchMapper 
{
    /**
     * 智能搜索MSDS文档
     * 
     * @param keyword 搜索关键词
     * @param searchType 搜索类型
     * @param filters 筛选条件
     * @return MSDS文档列表
     */
    public List<MsdsMain> intelligentSearch(@Param("keyword") String keyword, 
                                            @Param("searchType") String searchType,
                                            @Param("filters") Map<String, Object> filters);

    /**
     * 按CAS号搜索
     * 
     * @param casNumber CAS号
     * @return MSDS文档列表
     */
    public List<MsdsMain> searchByCasNumber(@Param("casNumber") String casNumber);

    /**
     * 按分子式搜索
     * 
     * @param formula 分子式
     * @return MSDS文档列表
     */
    public List<MsdsMain> searchByFormula(@Param("formula") String formula);

    /**
     * 按化学品名称搜索（支持模糊匹配）
     * 
     * @param name 化学品名称
     * @return MSDS文档列表
     */
    public List<MsdsMain> searchByChemicalName(@Param("name") String name);

    /**
     * 按供应商搜索
     * 
     * @param supplier 供应商名称
     * @return MSDS文档列表
     */
    public List<MsdsMain> searchBySupplier(@Param("supplier") String supplier);

    /**
     * 高级搜索
     * 
     * @param filters 筛选条件
     * @return MSDS文档列表
     */
    public List<MsdsMain> advancedSearch(@Param("filters") Map<String, Object> filters);

    /**
     * 获取搜索建议
     * 
     * @param keyword 关键词
     * @param limit 数量限制
     * @return 建议列表
     */
    public List<Map<String, Object>> getSearchSuggestions(@Param("keyword") String keyword, @Param("limit") Integer limit);

    /**
     * 获取相关文档
     * 
     * @param msdsId 文档ID
     * @param limit 数量限制
     * @return MSDS文档列表
     */
    public List<MsdsMain> getRelatedDocuments(@Param("msdsId") Long msdsId, @Param("limit") Integer limit);
}

