package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.MsdsToxicologicalMapper;
import com.ruoyi.system.domain.MsdsToxicological;
import com.ruoyi.system.service.IMsdsToxicologicalService;

/**
 * 毒理学资料 服务层实现
 * 
 * @author ruoyi
 * @date 2024-02-18
 */
@Service
public class MsdsToxicologicalServiceImpl implements IMsdsToxicologicalService
{
    @Autowired
    private MsdsToxicologicalMapper msdsToxicologicalMapper;

    /**
     * 查询毒理学资料信息
     * 
     * @param id 毒理学资料主键
     * @return 毒理学资料信息
     */
    @Override
    public MsdsToxicological selectMsdsToxicologicalById(Long id)
    {
        return msdsToxicologicalMapper.selectMsdsToxicologicalById(id);
    }

    /**
     * 根据MSDS主表ID查询毒理学资料信息
     * 
     * @param msdsId MSDS主表ID
     * @return 毒理学资料信息
     */
    @Override
    public MsdsToxicological selectMsdsToxicologicalByMsdsId(Long msdsId)
    {
        return msdsToxicologicalMapper.selectMsdsToxicologicalByMsdsId(msdsId);
    }

    /**
     * 查询毒理学资料列表
     * 
     * @param msdsToxicological 毒理学资料信息
     * @return 毒理学资料集合
     */
    @Override
    public List<MsdsToxicological> selectMsdsToxicologicalList(MsdsToxicological msdsToxicological)
    {
        return msdsToxicologicalMapper.selectMsdsToxicologicalList(msdsToxicological);
    }

    /**
     * 新增毒理学资料
     * 
     * @param msdsToxicological 毒理学资料信息
     * @return 结果
     */
    @Override
    public int insertMsdsToxicological(MsdsToxicological msdsToxicological)
    {
        return msdsToxicologicalMapper.insertMsdsToxicological(msdsToxicological);
    }

    /**
     * 修改毒理学资料
     * 
     * @param msdsToxicological 毒理学资料信息
     * @return 结果
     */
    @Override
    public int updateMsdsToxicological(MsdsToxicological msdsToxicological)
    {
        return msdsToxicologicalMapper.updateMsdsToxicological(msdsToxicological);
    }

    /**
     * 批量删除毒理学资料
     * 
     * @param ids 需要删除的毒理学资料主键集合
     * @return 结果
     */
    @Override
    public int deleteMsdsToxicologicalByIds(Long[] ids)
    {
        return msdsToxicologicalMapper.deleteMsdsToxicologicalByIds(ids);
    }

    /**
     * 删除毒理学资料信息
     * 
     * @param id 毒理学资料主键
     * @return 结果
     */
    @Override
    public int deleteMsdsToxicologicalById(Long id)
    {
        return msdsToxicologicalMapper.deleteMsdsToxicologicalById(id);
    }
} 