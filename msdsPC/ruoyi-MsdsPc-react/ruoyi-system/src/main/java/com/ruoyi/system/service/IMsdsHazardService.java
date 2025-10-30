package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.MsdsHazard;

/**
 * MSDS危险性概述Service接口
 * 
 * @author ruoyi
 * @date 2024-01-15
 */
public interface IMsdsHazardService 
{
    /**
     * 查询MSDS危险性概述
     * 
     * @param id MSDS危险性概述主键
     * @return MSDS危险性概述
     */
    public MsdsHazard selectMsdsHazardById(Long id);

    /**
     * 查询MSDS危险性概述列表
     * 
     * @param msdsHazard MSDS危险性概述
     * @return MSDS危险性概述集合
     */
    public List<MsdsHazard> selectMsdsHazardList(MsdsHazard msdsHazard);

    /**
     * 根据MSDS主表ID查询危险性概述
     * 
     * @param msdsId MSDS主表ID
     * @return MSDS危险性概述
     */
    public MsdsHazard selectMsdsHazardByMsdsId(Long msdsId);

    /**
     * 新增MSDS危险性概述
     * 
     * @param msdsHazard MSDS危险性概述
     * @return 结果
     */
    public int insertMsdsHazard(MsdsHazard msdsHazard);

    /**
     * 修改MSDS危险性概述
     * 
     * @param msdsHazard MSDS危险性概述
     * @return 结果
     */
    public int updateMsdsHazard(MsdsHazard msdsHazard);

    /**
     * 批量删除MSDS危险性概述
     * 
     * @param ids 需要删除的MSDS危险性概述主键集合
     * @return 结果
     */
    public int deleteMsdsHazardByIds(Long[] ids);

    /**
     * 删除MSDS危险性概述信息
     * 
     * @param id MSDS危险性概述主键
     * @return 结果
     */
    public int deleteMsdsHazardById(Long id);

    /**
     * 根据MSDS主表ID删除危险性概述
     * 
     * @param msdsId MSDS主表ID
     * @return 结果
     */
    public int deleteMsdsHazardByMsdsId(Long msdsId);
}