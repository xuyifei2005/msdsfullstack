package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.MsdsStabilityReactivityMapper;
import com.ruoyi.system.domain.MsdsStabilityReactivity;
import com.ruoyi.system.service.IMsdsStabilityReactivityService;

/**
 * 稳定性和反应性 服务层实现
 * 
 * @author ruoyi
 * @date 2024-02-18
 */
@Service
public class MsdsStabilityReactivityServiceImpl implements IMsdsStabilityReactivityService
{
    @Autowired
    private MsdsStabilityReactivityMapper msdsStabilityReactivityMapper;

    /**
     * 查询稳定性和反应性信息
     * 
     * @param id 稳定性和反应性主键
     * @return 稳定性和反应性信息
     */
    @Override
    public MsdsStabilityReactivity selectMsdsStabilityReactivityById(Long id)
    {
        return msdsStabilityReactivityMapper.selectMsdsStabilityReactivityById(id);
    }

    /**
     * 根据MSDS主表ID查询稳定性和反应性信息
     * 
     * @param msdsId MSDS主表ID
     * @return 稳定性和反应性信息
     */
    @Override
    public MsdsStabilityReactivity selectMsdsStabilityReactivityByMsdsId(Long msdsId)
    {
        return msdsStabilityReactivityMapper.selectMsdsStabilityReactivityByMsdsId(msdsId);
    }

    /**
     * 查询稳定性和反应性列表
     * 
     * @param msdsStabilityReactivity 稳定性和反应性信息
     * @return 稳定性和反应性集合
     */
    @Override
    public List<MsdsStabilityReactivity> selectMsdsStabilityReactivityList(MsdsStabilityReactivity msdsStabilityReactivity)
    {
        return msdsStabilityReactivityMapper.selectMsdsStabilityReactivityList(msdsStabilityReactivity);
    }

    /**
     * 新增稳定性和反应性
     * 
     * @param msdsStabilityReactivity 稳定性和反应性信息
     * @return 结果
     */
    @Override
    public int insertMsdsStabilityReactivity(MsdsStabilityReactivity msdsStabilityReactivity)
    {
        return msdsStabilityReactivityMapper.insertMsdsStabilityReactivity(msdsStabilityReactivity);
    }

    /**
     * 修改稳定性和反应性
     * 
     * @param msdsStabilityReactivity 稳定性和反应性信息
     * @return 结果
     */
    @Override
    public int updateMsdsStabilityReactivity(MsdsStabilityReactivity msdsStabilityReactivity)
    {
        return msdsStabilityReactivityMapper.updateMsdsStabilityReactivity(msdsStabilityReactivity);
    }

    /**
     * 批量删除稳定性和反应性
     * 
     * @param ids 需要删除的稳定性和反应性主键集合
     * @return 结果
     */
    @Override
    public int deleteMsdsStabilityReactivityByIds(Long[] ids)
    {
        return msdsStabilityReactivityMapper.deleteMsdsStabilityReactivityByIds(ids);
    }

    /**
     * 删除稳定性和反应性信息
     * 
     * @param id 稳定性和反应性主键
     * @return 结果
     */
    @Override
    public int deleteMsdsStabilityReactivityById(Long id)
    {
        return msdsStabilityReactivityMapper.deleteMsdsStabilityReactivityById(id);
    }
} 