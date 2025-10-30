package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.MsdsDisposal;

/**
 * 废弃处置Service接口
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public interface IMsdsDisposalService 
{
    /**
     * 查询废弃处置
     * 
     * @param id 废弃处置主键
     * @return 废弃处置
     */
    public MsdsDisposal selectMsdsDisposalById(Long id);

    /**
     * 查询废弃处置列表
     * 
     * @param msdsDisposal 废弃处置
     * @return 废弃处置集合
     */
    public List<MsdsDisposal> selectMsdsDisposalList(MsdsDisposal msdsDisposal);

    /**
     * 根据MSDS主表ID查询废弃处置信息
     * 
     * @param msdsId MSDS主表ID
     * @return 废弃处置信息
     */
    public MsdsDisposal selectMsdsDisposalByMsdsId(Long msdsId);

    /**
     * 新增废弃处置
     * 
     * @param msdsDisposal 废弃处置
     * @return 结果
     */
    public int insertMsdsDisposal(MsdsDisposal msdsDisposal);

    /**
     * 修改废弃处置
     * 
     * @param msdsDisposal 废弃处置
     * @return 结果
     */
    public int updateMsdsDisposal(MsdsDisposal msdsDisposal);

    /**
     * 批量删除废弃处置
     * 
     * @param ids 需要删除的废弃处置主键集合
     * @return 结果
     */
    public int deleteMsdsDisposalByIds(Long[] ids);

    /**
     * 删除废弃处置信息
     * 
     * @param id 废弃处置主键
     * @return 结果
     */
    public int deleteMsdsDisposalById(Long id);

    /**
     * 根据MSDS主表ID删除废弃处置信息
     * 
     * @param msdsId MSDS主表ID
     * @return 结果
     */
    public int deleteMsdsDisposalByMsdsId(Long msdsId);
}