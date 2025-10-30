package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.MsdsTransportationMapper;
import com.ruoyi.system.domain.MsdsTransportation;
import com.ruoyi.system.service.IMsdsTransportationService;

/**
 * 运输信息 服务层实现
 * 
 * @author ruoyi
 * @date 2024-02-18
 */
@Service
public class MsdsTransportationServiceImpl implements IMsdsTransportationService
{
    @Autowired
    private MsdsTransportationMapper msdsTransportationMapper;

    /**
     * 查询运输信息
     * 
     * @param id 运输信息主键
     * @return 运输信息
     */
    @Override
    public MsdsTransportation selectMsdsTransportationById(Long id)
    {
        return msdsTransportationMapper.selectMsdsTransportationById(id);
    }

    /**
     * 根据MSDS主表ID查询运输信息
     * 
     * @param msdsId MSDS主表ID
     * @return 运输信息
     */
    @Override
    public MsdsTransportation selectMsdsTransportationByMsdsId(Long msdsId)
    {
        return msdsTransportationMapper.selectMsdsTransportationByMsdsId(msdsId);
    }

    /**
     * 查询运输信息列表
     * 
     * @param msdsTransportation 运输信息
     * @return 运输信息集合
     */
    @Override
    public List<MsdsTransportation> selectMsdsTransportationList(MsdsTransportation msdsTransportation)
    {
        return msdsTransportationMapper.selectMsdsTransportationList(msdsTransportation);
    }

    /**
     * 新增运输信息
     * 
     * @param msdsTransportation 运输信息
     * @return 结果
     */
    @Override
    public int insertMsdsTransportation(MsdsTransportation msdsTransportation)
    {
        return msdsTransportationMapper.insertMsdsTransportation(msdsTransportation);
    }

    /**
     * 修改运输信息
     * 
     * @param msdsTransportation 运输信息
     * @return 结果
     */
    @Override
    public int updateMsdsTransportation(MsdsTransportation msdsTransportation)
    {
        return msdsTransportationMapper.updateMsdsTransportation(msdsTransportation);
    }

    /**
     * 批量删除运输信息
     * 
     * @param ids 需要删除的运输信息主键集合
     * @return 结果
     */
    @Override
    public int deleteMsdsTransportationByIds(Long[] ids)
    {
        return msdsTransportationMapper.deleteMsdsTransportationByIds(ids);
    }

    /**
     * 删除运输信息
     * 
     * @param id 运输信息主键
     * @return 结果
     */
    @Override
    public int deleteMsdsTransportationById(Long id)
    {
        return msdsTransportationMapper.deleteMsdsTransportationById(id);
    }
} 