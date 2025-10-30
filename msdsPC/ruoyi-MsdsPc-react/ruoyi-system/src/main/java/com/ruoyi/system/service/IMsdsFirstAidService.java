package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.MsdsFirstAid;

/**
 * MSDS急救措施Service接口
 * 
 * @author ruoyi
 * @date 2024-01-15
 */
public interface IMsdsFirstAidService 
{
    /**
     * 查询MSDS急救措施
     * 
     * @param id MSDS急救措施主键
     * @return MSDS急救措施
     */
    public MsdsFirstAid selectMsdsFirstAidById(Long id);

    /**
     * 查询MSDS急救措施列表
     * 
     * @param msdsFirstAid MSDS急救措施
     * @return MSDS急救措施集合
     */
    public List<MsdsFirstAid> selectMsdsFirstAidList(MsdsFirstAid msdsFirstAid);

    /**
     * 根据MSDS主表ID查询急救措施
     * 
     * @param msdsId MSDS主表ID
     * @return MSDS急救措施
     */
    public MsdsFirstAid selectMsdsFirstAidByMsdsId(Long msdsId);

    /**
     * 新增MSDS急救措施
     * 
     * @param msdsFirstAid MSDS急救措施
     * @return 结果
     */
    public int insertMsdsFirstAid(MsdsFirstAid msdsFirstAid);

    /**
     * 修改MSDS急救措施
     * 
     * @param msdsFirstAid MSDS急救措施
     * @return 结果
     */
    public int updateMsdsFirstAid(MsdsFirstAid msdsFirstAid);

    /**
     * 批量删除MSDS急救措施
     * 
     * @param ids 需要删除的MSDS急救措施主键集合
     * @return 结果
     */
    public int deleteMsdsFirstAidByIds(Long[] ids);

    /**
     * 删除MSDS急救措施信息
     * 
     * @param id MSDS急救措施主键
     * @return 结果
     */
    public int deleteMsdsFirstAidById(Long id);

    /**
     * 根据MSDS主表ID删除急救措施
     * 
     * @param msdsId MSDS主表ID
     * @return 结果
     */
    public int deleteMsdsFirstAidByMsdsId(Long msdsId);
}