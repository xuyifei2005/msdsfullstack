package com.ruoyi.system.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.MsdsDisposalMapper;
import com.ruoyi.system.domain.MsdsDisposal;
import com.ruoyi.system.service.IMsdsDisposalService;

/**
 * 废弃处置Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
@Service
public class MsdsDisposalServiceImpl implements IMsdsDisposalService 
{
    @Autowired
    private MsdsDisposalMapper msdsDisposalMapper;

    /**
     * 查询废弃处置
     * 
     * @param id 废弃处置主键
     * @return 废弃处置
     */
    @Override
    public MsdsDisposal selectMsdsDisposalById(Long id)
    {
        return msdsDisposalMapper.selectMsdsDisposalById(id);
    }

    /**
     * 查询废弃处置列表
     * 
     * @param msdsDisposal 废弃处置
     * @return 废弃处置
     */
    @Override
    public List<MsdsDisposal> selectMsdsDisposalList(MsdsDisposal msdsDisposal)
    {
        return msdsDisposalMapper.selectMsdsDisposalList(msdsDisposal);
    }

    /**
     * 根据MSDS主表ID查询废弃处置信息
     * 
     * @param msdsId MSDS主表ID
     * @return 废弃处置信息
     */
    @Override
    public MsdsDisposal selectMsdsDisposalByMsdsId(Long msdsId)
    {
        return msdsDisposalMapper.selectMsdsDisposalByMsdsId(msdsId);
    }

    /**
     * 新增废弃处置
     * 
     * @param msdsDisposal 废弃处置
     * @return 结果
     */
    @Override
    public int insertMsdsDisposal(MsdsDisposal msdsDisposal)
    {
        msdsDisposal.setCreateTime(DateUtils.getNowDate());
        return msdsDisposalMapper.insertMsdsDisposal(msdsDisposal);
    }

    /**
     * 修改废弃处置
     * 
     * @param msdsDisposal 废弃处置
     * @return 结果
     */
    @Override
    public int updateMsdsDisposal(MsdsDisposal msdsDisposal)
    {
        msdsDisposal.setUpdateTime(DateUtils.getNowDate());
        return msdsDisposalMapper.updateMsdsDisposal(msdsDisposal);
    }

    /**
     * 批量删除废弃处置
     * 
     * @param ids 需要删除的废弃处置主键
     * @return 结果
     */
    @Override
    public int deleteMsdsDisposalByIds(Long[] ids)
    {
        return msdsDisposalMapper.deleteMsdsDisposalByIds(ids);
    }

    /**
     * 删除废弃处置信息
     * 
     * @param id 废弃处置主键
     * @return 结果
     */
    @Override
    public int deleteMsdsDisposalById(Long id)
    {
        return msdsDisposalMapper.deleteMsdsDisposalById(id);
    }

    /**
     * 根据MSDS主表ID删除废弃处置信息
     * 
     * @param msdsId MSDS主表ID
     * @return 结果
     */
    @Override
    public int deleteMsdsDisposalByMsdsId(Long msdsId)
    {
        return msdsDisposalMapper.deleteMsdsDisposalByMsdsId(msdsId);
    }
}