package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.MsdsExposureControlMapper;
import com.ruoyi.system.domain.MsdsExposureControl;
import com.ruoyi.system.service.IMsdsExposureControlService;

/**
 * 接触控制/个体防护 服务层实现
 * 
 * @author ruoyi
 * @date 2024-02-18
 */
@Service
public class MsdsExposureControlServiceImpl implements IMsdsExposureControlService
{
    @Autowired
    private MsdsExposureControlMapper msdsExposureControlMapper;

    /**
     * 查询接触控制/个体防护信息
     * 
     * @param id 接触控制/个体防护主键
     * @return 接触控制/个体防护信息
     */
    @Override
    public MsdsExposureControl selectMsdsExposureControlById(Long id)
    {
        return msdsExposureControlMapper.selectMsdsExposureControlById(id);
    }

    /**
     * 根据MSDS主表ID查询接触控制/个体防护信息
     * 
     * @param msdsId MSDS主表ID
     * @return 接触控制/个体防护信息
     */
    @Override
    public MsdsExposureControl selectMsdsExposureControlByMsdsId(Long msdsId)
    {
        return msdsExposureControlMapper.selectMsdsExposureControlByMsdsId(msdsId);
    }

    /**
     * 查询接触控制/个体防护列表
     * 
     * @param msdsExposureControl 接触控制/个体防护信息
     * @return 接触控制/个体防护集合
     */
    @Override
    public List<MsdsExposureControl> selectMsdsExposureControlList(MsdsExposureControl msdsExposureControl)
    {
        return msdsExposureControlMapper.selectMsdsExposureControlList(msdsExposureControl);
    }

    /**
     * 新增接触控制/个体防护
     * 
     * @param msdsExposureControl 接触控制/个体防护信息
     * @return 结果
     */
    @Override
    public int insertMsdsExposureControl(MsdsExposureControl msdsExposureControl)
    {
        return msdsExposureControlMapper.insertMsdsExposureControl(msdsExposureControl);
    }

    /**
     * 修改接触控制/个体防护
     * 
     * @param msdsExposureControl 接触控制/个体防护信息
     * @return 结果
     */
    @Override
    public int updateMsdsExposureControl(MsdsExposureControl msdsExposureControl)
    {
        return msdsExposureControlMapper.updateMsdsExposureControl(msdsExposureControl);
    }

    /**
     * 批量删除接触控制/个体防护
     * 
     * @param ids 需要删除的接触控制/个体防护主键集合
     * @return 结果
     */
    @Override
    public int deleteMsdsExposureControlByIds(Long[] ids)
    {
        return msdsExposureControlMapper.deleteMsdsExposureControlByIds(ids);
    }

    /**
     * 删除接触控制/个体防护信息
     * 
     * @param id 接触控制/个体防护主键
     * @return 结果
     */
    @Override
    public int deleteMsdsExposureControlById(Long id)
    {
        return msdsExposureControlMapper.deleteMsdsExposureControlById(id);
    }
} 