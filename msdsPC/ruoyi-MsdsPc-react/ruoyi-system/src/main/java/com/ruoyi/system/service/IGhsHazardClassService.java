package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.GhsHazardClass;

/**
 * GHS危险性分类标准Service接口
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public interface IGhsHazardClassService 
{
    /**
     * 查询GHS危险性分类标准
     * 
     * @param id GHS危险性分类标准主键
     * @return GHS危险性分类标准
     */
    public GhsHazardClass selectGhsHazardClassById(Long id);

    /**
     * 根据分类编码查询GHS危险性分类标准
     * 
     * @param classCode 分类编码
     * @return GHS危险性分类标准
     */
    public GhsHazardClass selectGhsHazardClassByCode(String classCode);

    /**
     * 查询GHS危险性分类标准列表
     * 
     * @param ghsHazardClass GHS危险性分类标准
     * @return GHS危险性分类标准集合
     */
    public List<GhsHazardClass> selectGhsHazardClassList(GhsHazardClass ghsHazardClass);

    /**
     * 根据类别查询GHS危险性分类标准列表
     * 
     * @param category 类别
     * @return GHS危险性分类标准集合
     */
    public List<GhsHazardClass> selectGhsHazardClassByCategory(String category);

    /**
     * 根据象形图查询GHS危险性分类标准列表
     * 
     * @param pictogram 象形图
     * @return GHS危险性分类标准集合
     */
    public List<GhsHazardClass> selectGhsHazardClassByPictogram(String pictogram);

    /**
     * 查询活跃的GHS危险性分类标准列表
     * 
     * @return 活跃分类集合
     */
    public List<GhsHazardClass> selectActiveGhsHazardClasses();

    /**
     * 新增GHS危险性分类标准
     * 
     * @param ghsHazardClass GHS危险性分类标准
     * @return 结果
     */
    public int insertGhsHazardClass(GhsHazardClass ghsHazardClass);

    /**
     * 修改GHS危险性分类标准
     * 
     * @param ghsHazardClass GHS危险性分类标准
     * @return 结果
     */
    public int updateGhsHazardClass(GhsHazardClass ghsHazardClass);

    /**
     * 批量删除GHS危险性分类标准
     * 
     * @param ids 需要删除的GHS危险性分类标准主键集合
     * @return 结果
     */
    public int deleteGhsHazardClassByIds(Long[] ids);

    /**
     * 删除GHS危险性分类标准信息
     * 
     * @param id GHS危险性分类标准主键
     * @return 结果
     */
    public int deleteGhsHazardClassById(Long id);

    /**
     * 校验分类编码是否唯一
     * 
     * @param ghsHazardClass GHS危险性分类标准信息
     * @return 结果
     */
    public boolean checkClassCodeUnique(GhsHazardClass ghsHazardClass);
}