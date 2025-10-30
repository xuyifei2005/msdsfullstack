package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.MsdsFirstAidMapper;
import com.ruoyi.system.domain.MsdsFirstAid;
import com.ruoyi.system.service.IMsdsFirstAidService;

/**
 * MSDS急救措施Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-01-15
 */
@Service
public class MsdsFirstAidServiceImpl implements IMsdsFirstAidService 
{
    @Autowired
    private MsdsFirstAidMapper msdsFirstAidMapper;

    /**
     * 查询MSDS急救措施
     * 
     * @param id MSDS急救措施主键
     * @return MSDS急救措施
     */
    @Override
    public MsdsFirstAid selectMsdsFirstAidById(Long id)
    {
        return msdsFirstAidMapper.selectMsdsFirstAidById(id);
    }

    /**
     * 查询MSDS急救措施列表
     * 
     * @param msdsFirstAid MSDS急救措施
     * @return MSDS急救措施
     */
    @Override
    public List<MsdsFirstAid> selectMsdsFirstAidList(MsdsFirstAid msdsFirstAid)
    {
        return msdsFirstAidMapper.selectMsdsFirstAidList(msdsFirstAid);
    }

    /**
     * 根据MSDS主表ID查询急救措施
     * 
     * @param msdsId MSDS主表ID
     * @return MSDS急救措施
     */
    @Override
    public MsdsFirstAid selectMsdsFirstAidByMsdsId(Long msdsId)
    {
        return msdsFirstAidMapper.selectMsdsFirstAidByMsdsId(msdsId);
    }

    /**
     * 新增MSDS急救措施
     * 
     * @param msdsFirstAid MSDS急救措施
     * @return 结果
     */
    @Override
    public int insertMsdsFirstAid(MsdsFirstAid msdsFirstAid)
    {
        return msdsFirstAidMapper.insertMsdsFirstAid(msdsFirstAid);
    }

    /**
     * 修改MSDS急救措施
     * 
     * @param msdsFirstAid MSDS急救措施
     * @return 结果
     */
    @Override
    public int updateMsdsFirstAid(MsdsFirstAid msdsFirstAid)
    {
        return msdsFirstAidMapper.updateMsdsFirstAid(msdsFirstAid);
    }

    /**
     * 批量删除MSDS急救措施
     * 
     * @param ids 需要删除的MSDS急救措施主键
     * @return 结果
     */
    @Override
    public int deleteMsdsFirstAidByIds(Long[] ids)
    {
        return msdsFirstAidMapper.deleteMsdsFirstAidByIds(ids);
    }

    /**
     * 删除MSDS急救措施信息
     * 
     * @param id MSDS急救措施主键
     * @return 结果
     */
    @Override
    public int deleteMsdsFirstAidById(Long id)
    {
        return msdsFirstAidMapper.deleteMsdsFirstAidById(id);
    }

    /**
     * 根据MSDS主表ID删除急救措施
     * 
     * @param msdsId MSDS主表ID
     * @return 结果
     */
    @Override
    public int deleteMsdsFirstAidByMsdsId(Long msdsId)
    {
        return msdsFirstAidMapper.deleteMsdsFirstAidByMsdsId(msdsId);
    }
}