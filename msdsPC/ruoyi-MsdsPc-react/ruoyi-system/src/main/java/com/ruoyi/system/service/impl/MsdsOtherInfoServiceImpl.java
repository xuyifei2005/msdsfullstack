package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.MsdsOtherInfoMapper;
import com.ruoyi.system.domain.MsdsOtherInfo;
import com.ruoyi.system.service.IMsdsOtherInfoService;

/**
 * 其他信息 服务层实现
 * 
 * @author ruoyi
 * @date 2024-02-18
 */
@Service
public class MsdsOtherInfoServiceImpl implements IMsdsOtherInfoService
{
    @Autowired
    private MsdsOtherInfoMapper msdsOtherInfoMapper;

    /**
     * 查询其他信息
     * 
     * @param id 其他信息主键
     * @return 其他信息
     */
    @Override
    public MsdsOtherInfo selectMsdsOtherInfoById(Long id)
    {
        return msdsOtherInfoMapper.selectMsdsOtherInfoById(id);
    }

    /**
     * 根据MSDS主表ID查询其他信息
     * 
     * @param msdsId MSDS主表ID
     * @return 其他信息
     */
    @Override
    public MsdsOtherInfo selectMsdsOtherInfoByMsdsId(Long msdsId)
    {
        return msdsOtherInfoMapper.selectMsdsOtherInfoByMsdsId(msdsId);
    }

    /**
     * 查询其他信息列表
     * 
     * @param msdsOtherInfo 其他信息
     * @return 其他信息集合
     */
    @Override
    public List<MsdsOtherInfo> selectMsdsOtherInfoList(MsdsOtherInfo msdsOtherInfo)
    {
        return msdsOtherInfoMapper.selectMsdsOtherInfoList(msdsOtherInfo);
    }

    /**
     * 新增其他信息
     * 
     * @param msdsOtherInfo 其他信息
     * @return 结果
     */
    @Override
    public int insertMsdsOtherInfo(MsdsOtherInfo msdsOtherInfo)
    {
        return msdsOtherInfoMapper.insertMsdsOtherInfo(msdsOtherInfo);
    }

    /**
     * 修改其他信息
     * 
     * @param msdsOtherInfo 其他信息
     * @return 结果
     */
    @Override
    public int updateMsdsOtherInfo(MsdsOtherInfo msdsOtherInfo)
    {
        return msdsOtherInfoMapper.updateMsdsOtherInfo(msdsOtherInfo);
    }

    /**
     * 批量删除其他信息
     * 
     * @param ids 需要删除的其他信息主键
     * @return 结果
     */
    @Override
    public int deleteMsdsOtherInfoByIds(Long[] ids)
    {
        return msdsOtherInfoMapper.deleteMsdsOtherInfoByIds(ids);
    }

    /**
     * 删除其他信息信息
     * 
     * @param id 其他信息主键
     * @return 结果
     */
    @Override
    public int deleteMsdsOtherInfoById(Long id)
    {
        return msdsOtherInfoMapper.deleteMsdsOtherInfoById(id);
    }
}