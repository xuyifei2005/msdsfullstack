package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.MsdsStabilityReactivity;

/**
 * 稳定性和反应性 服务层
 * 
 * @author ruoyi
 * @date 2024-02-18
 */
public interface IMsdsStabilityReactivityService
{
    /**
     * 查询稳定性和反应性信息
     * 
     * @param id 稳定性和反应性主键
     * @return 稳定性和反应性信息
     */
    public MsdsStabilityReactivity selectMsdsStabilityReactivityById(Long id);

    /**
     * 根据MSDS主表ID查询稳定性和反应性信息
     * 
     * @param msdsId MSDS主表ID
     * @return 稳定性和反应性信息
     */
    public MsdsStabilityReactivity selectMsdsStabilityReactivityByMsdsId(Long msdsId);

    /**
     * 查询稳定性和反应性列表
     * 
     * @param msdsStabilityReactivity 稳定性和反应性信息
     * @return 稳定性和反应性集合
     */
    public List<MsdsStabilityReactivity> selectMsdsStabilityReactivityList(MsdsStabilityReactivity msdsStabilityReactivity);

    /**
     * 新增稳定性和反应性
     * 
     * @param msdsStabilityReactivity 稳定性和反应性信息
     * @return 结果
     */
    public int insertMsdsStabilityReactivity(MsdsStabilityReactivity msdsStabilityReactivity);

    /**
     * 修改稳定性和反应性
     * 
     * @param msdsStabilityReactivity 稳定性和反应性信息
     * @return 结果
     */
    public int updateMsdsStabilityReactivity(MsdsStabilityReactivity msdsStabilityReactivity);

    /**
     * 批量删除稳定性和反应性
     * 
     * @param ids 需要删除的稳定性和反应性主键集合
     * @return 结果
     */
    public int deleteMsdsStabilityReactivityByIds(Long[] ids);

    /**
     * 删除稳定性和反应性信息
     * 
     * @param id 稳定性和反应性主键
     * @return 结果
     */
    public int deleteMsdsStabilityReactivityById(Long id);
} 