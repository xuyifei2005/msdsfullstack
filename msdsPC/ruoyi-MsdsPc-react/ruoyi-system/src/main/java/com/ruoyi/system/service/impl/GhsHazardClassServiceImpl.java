package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.GhsHazardClassMapper;
import com.ruoyi.system.domain.GhsHazardClass;
import com.ruoyi.system.service.IGhsHazardClassService;
import com.ruoyi.common.utils.StringUtils;

/**
 * GHS危险性分类标准Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
@Service
public class GhsHazardClassServiceImpl implements IGhsHazardClassService 
{
    @Autowired
    private GhsHazardClassMapper ghsHazardClassMapper;

    /**
     * 查询GHS危险性分类标准
     * 
     * @param id GHS危险性分类标准主键
     * @return GHS危险性分类标准
     */
    @Override
    public GhsHazardClass selectGhsHazardClassById(Long id)
    {
        return ghsHazardClassMapper.selectGhsHazardClassById(id);
    }

    /**
     * 根据分类编码查询GHS危险性分类标准
     * 
     * @param classCode 分类编码
     * @return GHS危险性分类标准
     */
    @Override
    public GhsHazardClass selectGhsHazardClassByCode(String classCode)
    {
        return ghsHazardClassMapper.selectGhsHazardClassByCode(classCode);
    }

    /**
     * 查询GHS危险性分类标准列表
     * 
     * @param ghsHazardClass GHS危险性分类标准
     * @return GHS危险性分类标准
     */
    @Override
    public List<GhsHazardClass> selectGhsHazardClassList(GhsHazardClass ghsHazardClass)
    {
        return ghsHazardClassMapper.selectGhsHazardClassList(ghsHazardClass);
    }

    /**
     * 根据类别查询GHS危险性分类标准列表
     * 
     * @param category 类别
     * @return GHS危险性分类标准集合
     */
    @Override
    public List<GhsHazardClass> selectGhsHazardClassByCategory(String category)
    {
        return ghsHazardClassMapper.selectGhsHazardClassByCategory(category);
    }

    /**
     * 根据象形图查询GHS危险性分类标准列表
     * 
     * @param pictogram 象形图
     * @return GHS危险性分类标准集合
     */
    @Override
    public List<GhsHazardClass> selectGhsHazardClassByPictogram(String pictogram)
    {
        return ghsHazardClassMapper.selectGhsHazardClassByPictogram(pictogram);
    }

    /**
     * 查询活跃的GHS危险性分类标准列表
     * 
     * @return GHS危险性分类标准集合
     */
    @Override
    public List<GhsHazardClass> selectActiveGhsHazardClasses()
    {
        return ghsHazardClassMapper.selectActiveGhsHazardClassList();
    }

    /**
     * 新增GHS危险性分类标准
     * 
     * @param ghsHazardClass GHS危险性分类标准
     * @return 结果
     */
    @Override
    public int insertGhsHazardClass(GhsHazardClass ghsHazardClass)
    {
        return ghsHazardClassMapper.insertGhsHazardClass(ghsHazardClass);
    }

    /**
     * 修改GHS危险性分类标准
     * 
     * @param ghsHazardClass GHS危险性分类标准
     * @return 结果
     */
    @Override
    public int updateGhsHazardClass(GhsHazardClass ghsHazardClass)
    {
        return ghsHazardClassMapper.updateGhsHazardClass(ghsHazardClass);
    }

    /**
     * 批量删除GHS危险性分类标准
     * 
     * @param ids 需要删除的GHS危险性分类标准主键
     * @return 结果
     */
    @Override
    public int deleteGhsHazardClassByIds(Long[] ids)
    {
        return ghsHazardClassMapper.deleteGhsHazardClassByIds(ids);
    }

    /**
     * 删除GHS危险性分类标准信息
     * 
     * @param id GHS危险性分类标准主键
     * @return 结果
     */
    @Override
    public int deleteGhsHazardClassById(Long id)
    {
        return ghsHazardClassMapper.deleteGhsHazardClassById(id);
    }

    /**
     * 校验分类编码是否唯一
     * 
     * @param ghsHazardClass GHS危险性分类标准信息
     * @return 结果
     */
    @Override
    public boolean checkClassCodeUnique(GhsHazardClass ghsHazardClass)
    {
        Long classId = StringUtils.isNull(ghsHazardClass.getId()) ? -1L : ghsHazardClass.getId();
        int count = ghsHazardClassMapper.checkClassCodeUnique(ghsHazardClass.getClassCode());
        if (count > 0)
        {
            // 如果存在记录，需要检查是否是当前记录本身
            GhsHazardClass existingClass = ghsHazardClassMapper.selectGhsHazardClassByCode(ghsHazardClass.getClassCode());
            if (StringUtils.isNotNull(existingClass) && existingClass.getId().longValue() != classId.longValue())
            {
                return false;
            }
        }
        return true;
    }
}