package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.ChemicalCategoryMapper;
import com.ruoyi.system.domain.ChemicalCategory;
import com.ruoyi.system.service.IChemicalCategoryService;
import com.ruoyi.common.utils.StringUtils;

/**
 * 化学品分类Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
@Service
public class ChemicalCategoryServiceImpl implements IChemicalCategoryService 
{
    @Autowired
    private ChemicalCategoryMapper chemicalCategoryMapper;

    /**
     * 查询化学品分类
     * 
     * @param id 化学品分类主键
     * @return 化学品分类
     */
    @Override
    public ChemicalCategory selectChemicalCategoryById(Long id)
    {
        return chemicalCategoryMapper.selectChemicalCategoryById(id);
    }

    /**
     * 根据分类编码查询化学品分类
     * 
     * @param categoryCode 分类编码
     * @return 化学品分类
     */
    @Override
    public ChemicalCategory selectChemicalCategoryByCode(String categoryCode)
    {
        return chemicalCategoryMapper.selectChemicalCategoryByCode(categoryCode);
    }

    /**
     * 查询化学品分类列表
     * 
     * @param chemicalCategory 化学品分类
     * @return 化学品分类
     */
    @Override
    public List<ChemicalCategory> selectChemicalCategoryList(ChemicalCategory chemicalCategory)
    {
        return chemicalCategoryMapper.selectChemicalCategoryList(chemicalCategory);
    }

    /**
     * 查询子分类列表
     * 
     * @param parentId 父分类ID
     * @return 子分类集合
     */
    @Override
    public List<ChemicalCategory> selectChildCategories(Long parentId)
    {
        return chemicalCategoryMapper.selectChemicalCategoryByParentId(parentId);
    }

    /**
     * 查询活跃的化学品分类列表
     * 
     * @return 活跃分类集合
     */
    @Override
    public List<ChemicalCategory> selectActiveCategories()
    {
        return chemicalCategoryMapper.selectActiveChemicalCategoryList();
    }

    /**
     * 新增化学品分类
     * 
     * @param chemicalCategory 化学品分类
     * @return 结果
     */
    @Override
    public int insertChemicalCategory(ChemicalCategory chemicalCategory)
    {
        return chemicalCategoryMapper.insertChemicalCategory(chemicalCategory);
    }

    /**
     * 修改化学品分类
     * 
     * @param chemicalCategory 化学品分类
     * @return 结果
     */
    @Override
    public int updateChemicalCategory(ChemicalCategory chemicalCategory)
    {
        return chemicalCategoryMapper.updateChemicalCategory(chemicalCategory);
    }

    /**
     * 批量删除化学品分类
     * 
     * @param ids 需要删除的化学品分类主键
     * @return 结果
     */
    @Override
    public int deleteChemicalCategoryByIds(Long[] ids)
    {
        return chemicalCategoryMapper.deleteChemicalCategoryByIds(ids);
    }

    /**
     * 删除化学品分类信息
     * 
     * @param id 化学品分类主键
     * @return 结果
     */
    @Override
    public int deleteChemicalCategoryById(Long id)
    {
        return chemicalCategoryMapper.deleteChemicalCategoryById(id);
    }

    /**
     * 校验分类编码是否唯一
     * 
     * @param chemicalCategory 化学品分类信息
     * @return 结果
     */
    @Override
    public boolean checkCategoryCodeUnique(ChemicalCategory chemicalCategory)
    {
        Long categoryId = StringUtils.isNull(chemicalCategory.getId()) ? -1L : chemicalCategory.getId();
        int count = chemicalCategoryMapper.checkCategoryCodeUnique(chemicalCategory.getCategoryCode());
        if (count > 0)
        {
            // 如果存在记录，需要检查是否是当前记录本身
            ChemicalCategory existingCategory = chemicalCategoryMapper.selectChemicalCategoryByCode(chemicalCategory.getCategoryCode());
            if (StringUtils.isNotNull(existingCategory) && existingCategory.getId().longValue() != categoryId.longValue())
            {
                return false;
            }
        }
        return true;
    }

    /**
     * 检查是否存在子分类
     * 
     * @param id 分类ID
     * @return 结果
     */
    @Override
    public boolean hasChildCategories(Long id)
    {
        int result = chemicalCategoryMapper.hasChildByParentId(id);
        return result > 0;
    }
}