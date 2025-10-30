package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.MsdsFireFighting;

/**
 * 消防措施 服务层
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public interface IMsdsFireFightingService
{
    /**
     * 查询消防措施
     * 
     * @param id 消防措施主键
     * @return 消防措施
     */
    public MsdsFireFighting selectMsdsFireFightingById(Long id);

    /**
     * 根据MSDS主表ID查询消防措施
     * 
     * @param msdsId MSDS主表ID
     * @return 消防措施
     */
    public MsdsFireFighting selectMsdsFireFightingByMsdsId(Long msdsId);

    /**
     * 查询消防措施列表
     * 
     * @param msdsFireFighting 消防措施
     * @return 消防措施集合
     */
    public List<MsdsFireFighting> selectMsdsFireFightingList(MsdsFireFighting msdsFireFighting);

    /**
     * 新增消防措施
     * 
     * @param msdsFireFighting 消防措施
     * @return 结果
     */
    public int insertMsdsFireFighting(MsdsFireFighting msdsFireFighting);

    /**
     * 修改消防措施
     * 
     * @param msdsFireFighting 消防措施
     * @return 结果
     */
    public int updateMsdsFireFighting(MsdsFireFighting msdsFireFighting);

    /**
     * 批量删除消防措施
     * 
     * @param ids 需要删除的消防措施主键集合
     * @return 结果
     */
    public int deleteMsdsFireFightingByIds(Long[] ids);

    /**
     * 删除消防措施
     * 
     * @param id 消防措施主键
     * @return 结果
     */
    public int deleteMsdsFireFightingById(Long id);
} 