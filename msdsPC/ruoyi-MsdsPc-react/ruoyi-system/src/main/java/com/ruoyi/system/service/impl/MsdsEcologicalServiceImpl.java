package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.MsdsEcologicalMapper;
import com.ruoyi.system.domain.MsdsEcological;
import com.ruoyi.system.service.IMsdsEcologicalService;

/**
 * 生态学资料 服务层实现
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
@Service
public class MsdsEcologicalServiceImpl implements IMsdsEcologicalService
{
    @Autowired
    private MsdsEcologicalMapper msdsEcologicalMapper;

    /**
     * 查询生态学资料
     * 
     * @param id 生态学资料主键
     * @return 生态学资料
     */
    @Override
    public MsdsEcological selectMsdsEcologicalById(Long id)
    {
        return msdsEcologicalMapper.selectMsdsEcologicalById(id);
    }

    /**
     * 根据MSDS主表ID查询生态学资料
     * 
     * @param msdsId MSDS主表ID
     * @return 生态学资料
     */
    @Override
    public MsdsEcological selectMsdsEcologicalByMsdsId(Long msdsId)
    {
        return msdsEcologicalMapper.selectMsdsEcologicalByMsdsId(msdsId);
    }

    /**
     * 查询生态学资料列表
     * 
     * @param msdsEcological 生态学资料
     * @return 生态学资料集合
     */
    @Override
    public List<MsdsEcological> selectMsdsEcologicalList(MsdsEcological msdsEcological)
    {
        return msdsEcologicalMapper.selectMsdsEcologicalList(msdsEcological);
    }

    /**
     * 新增生态学资料
     * 
     * @param msdsEcological 生态学资料
     * @return 结果
     */
    @Override
    public int insertMsdsEcological(MsdsEcological msdsEcological)
    {
        return msdsEcologicalMapper.insertMsdsEcological(msdsEcological);
    }

    /**
     * 修改生态学资料
     * 
     * @param msdsEcological 生态学资料
     * @return 结果
     */
    @Override
    public int updateMsdsEcological(MsdsEcological msdsEcological)
    {
        return msdsEcologicalMapper.updateMsdsEcological(msdsEcological);
    }

    /**
     * 批量删除生态学资料
     * 
     * @param ids 需要删除的生态学资料主键集合
     * @return 结果
     */
    @Override
    public int deleteMsdsEcologicalByIds(Long[] ids)
    {
        return msdsEcologicalMapper.deleteMsdsEcologicalByIds(ids);
    }

    /**
     * 删除生态学资料
     * 
     * @param id 生态学资料主键
     * @return 结果
     */
    @Override
    public int deleteMsdsEcologicalById(Long id)
    {
        return msdsEcologicalMapper.deleteMsdsEcologicalById(id);
    }
} 