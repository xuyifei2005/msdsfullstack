package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.MsdsFireFightingMapper;
import com.ruoyi.system.domain.MsdsFireFighting;
import com.ruoyi.system.service.IMsdsFireFightingService;

/**
 * 消防措施 服务层实现
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
@Service
public class MsdsFireFightingServiceImpl implements IMsdsFireFightingService
{
    @Autowired
    private MsdsFireFightingMapper msdsFireFightingMapper;

    /**
     * 查询消防措施
     * 
     * @param id 消防措施主键
     * @return 消防措施
     */
    @Override
    public MsdsFireFighting selectMsdsFireFightingById(Long id)
    {
        return msdsFireFightingMapper.selectMsdsFireFightingById(id);
    }

    /**
     * 根据MSDS主表ID查询消防措施
     * 
     * @param msdsId MSDS主表ID
     * @return 消防措施
     */
    @Override
    public MsdsFireFighting selectMsdsFireFightingByMsdsId(Long msdsId)
    {
        return msdsFireFightingMapper.selectMsdsFireFightingByMsdsId(msdsId);
    }

    /**
     * 查询消防措施列表
     * 
     * @param msdsFireFighting 消防措施
     * @return 消防措施集合
     */
    @Override
    public List<MsdsFireFighting> selectMsdsFireFightingList(MsdsFireFighting msdsFireFighting)
    {
        return msdsFireFightingMapper.selectMsdsFireFightingList(msdsFireFighting);
    }

    /**
     * 新增消防措施
     * 
     * @param msdsFireFighting 消防措施
     * @return 结果
     */
    @Override
    public int insertMsdsFireFighting(MsdsFireFighting msdsFireFighting)
    {
        return msdsFireFightingMapper.insertMsdsFireFighting(msdsFireFighting);
    }

    /**
     * 修改消防措施
     * 
     * @param msdsFireFighting 消防措施
     * @return 结果
     */
    @Override
    public int updateMsdsFireFighting(MsdsFireFighting msdsFireFighting)
    {
        return msdsFireFightingMapper.updateMsdsFireFighting(msdsFireFighting);
    }

    /**
     * 批量删除消防措施
     * 
     * @param ids 需要删除的消防措施主键集合
     * @return 结果
     */
    @Override
    public int deleteMsdsFireFightingByIds(Long[] ids)
    {
        return msdsFireFightingMapper.deleteMsdsFireFightingByIds(ids);
    }

    /**
     * 删除消防措施
     * 
     * @param id 消防措施主键
     * @return 结果
     */
    @Override
    public int deleteMsdsFireFightingById(Long id)
    {
        return msdsFireFightingMapper.deleteMsdsFireFightingById(id);
    }
} 