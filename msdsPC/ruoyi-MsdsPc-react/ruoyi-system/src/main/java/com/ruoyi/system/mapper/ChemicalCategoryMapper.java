package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.ChemicalCategory;

/**
 * 化学品分类Mapper接口
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
public interface ChemicalCategoryMapper 
{
    /**
     * 查询化学品分类
     * 
     * @param id 化学品分类主键
     * @return 化学品分类
     */
    public ChemicalCategory selectChemicalCategoryById(Long id);

    /**
     * 根据分类编码查询化学品分类
     * 
     * @param categoryCode 分类编码
     * @return 化学品分类
     */
    public ChemicalCategory selectChemicalCategoryByCode(String categoryCode);

    /**
     * 查询化学品分类列表
     * 
     * @param chemicalCategory 化学品分类
     * @return 化学品分类集合
     */
    public List<ChemicalCategory> selectChemicalCategoryList(ChemicalCategory chemicalCategory);

    /**
     * 查询子分类列表
     * 
     * @param parentId 父分类ID
     * @return 子分类集合
     */
    public List<ChemicalCategory> selectChemicalCategoryByParentId(Long parentId);

    /**
     * 查询活跃的化学品分类列表
     * 
     * @return 活跃的化学品分类集合
     */
    public List<ChemicalCategory> selectActiveChemicalCategoryList();

    /**
     * 新增化学品分类
     * 
     * @param chemicalCategory 化学品分类
     * @return 结果
     */
    public int insertChemicalCategory(ChemicalCategory chemicalCategory);

    /**
     * 修改化学品分类
     * 
     * @param chemicalCategory 化学品分类
     * @return 结果
     */
    public int updateChemicalCategory(ChemicalCategory chemicalCategory);

    /**
     * 删除化学品分类
     * 
     * @param id 化学品分类主键
     * @return 结果
     */
    public int deleteChemicalCategoryById(Long id);

    /**
     * 批量删除化学品分类
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteChemicalCategoryByIds(Long[] ids);

    /**
     * 检查分类编码是否存在
     * 
     * @param categoryCode 分类编码
     * @return 结果
     */
    public int checkCategoryCodeUnique(String categoryCode);

    /**
     * 检查是否存在子分类
     * 
     * @param parentId 父分类ID
     * @return 结果
     */
    public int hasChildByParentId(Long parentId);
}