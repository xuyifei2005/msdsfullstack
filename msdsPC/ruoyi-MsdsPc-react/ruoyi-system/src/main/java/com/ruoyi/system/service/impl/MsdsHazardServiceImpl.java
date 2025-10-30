package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.MsdsHazardMapper;
import com.ruoyi.system.domain.MsdsHazard;
import com.ruoyi.system.service.IMsdsHazardService;

/**
 * MSDS危险性概述Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-01-15
 */
@Service
public class MsdsHazardServiceImpl implements IMsdsHazardService 
{
    @Autowired
    private MsdsHazardMapper msdsHazardMapper;

    /**
     * 查询MSDS危险性概述
     * 
     * @param id MSDS危险性概述主键
     * @return MSDS危险性概述
     */
    @Override
    public MsdsHazard selectMsdsHazardById(Long id)
    {
        return msdsHazardMapper.selectMsdsHazardById(id);
    }

    /**
     * 查询MSDS危险性概述列表
     * 
     * @param msdsHazard MSDS危险性概述
     * @return MSDS危险性概述
     */
    @Override
    public List<MsdsHazard> selectMsdsHazardList(MsdsHazard msdsHazard)
    {
        return msdsHazardMapper.selectMsdsHazardList(msdsHazard);
    }

    /**
     * 根据MSDS主表ID查询危险性概述
     * 
     * @param msdsId MSDS主表ID
     * @return MSDS危险性概述
     */
    @Override
    public MsdsHazard selectMsdsHazardByMsdsId(Long msdsId)
    {
        return msdsHazardMapper.selectMsdsHazardByMsdsId(msdsId);
    }

    /**
     * 新增MSDS危险性概述
     * 
     * @param msdsHazard MSDS危险性概述
     * @return 结果
     */
    @Override
    public int insertMsdsHazard(MsdsHazard msdsHazard)
    {
        return msdsHazardMapper.insertMsdsHazard(msdsHazard);
    }

    /**
     * 修改MSDS危险性概述
     * 
     * @param msdsHazard MSDS危险性概述
     * @return 结果
     */
    @Override
    public int updateMsdsHazard(MsdsHazard msdsHazard)
    {
        return msdsHazardMapper.updateMsdsHazard(msdsHazard);
    }

    /**
     * 批量删除MSDS危险性概述
     * 
     * @param ids 需要删除的MSDS危险性概述主键
     * @return 结果
     */
    @Override
    public int deleteMsdsHazardByIds(Long[] ids)
    {
        return msdsHazardMapper.deleteMsdsHazardByIds(ids);
    }

    /**
     * 删除MSDS危险性概述信息
     * 
     * @param id MSDS危险性概述主键
     * @return 结果
     */
    @Override
    public int deleteMsdsHazardById(Long id)
    {
        return msdsHazardMapper.deleteMsdsHazardById(id);
    }

    /**
     * 根据MSDS主表ID删除危险性概述
     * 
     * @param msdsId MSDS主表ID
     * @return 结果
     */
    @Override
    public int deleteMsdsHazardByMsdsId(Long msdsId)
    {
        return msdsHazardMapper.deleteMsdsHazardByMsdsId(msdsId);
    }
}