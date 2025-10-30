package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.MsdsStabilityReactivity;

/**
 * 稳定性和反应性Mapper接口
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public interface MsdsStabilityReactivityMapper 
{
    /**
     * 查询稳定性和反应性
     * 
     * @param id 稳定性和反应性主键
     * @return 稳定性和反应性
     */
    public MsdsStabilityReactivity selectMsdsStabilityReactivityById(Long id);

    /**
     * 根据MSDS ID查询稳定性和反应性
     * 
     * @param msdsId MSDS主键
     * @return 稳定性和反应性
     */
    public MsdsStabilityReactivity selectMsdsStabilityReactivityByMsdsId(Long msdsId);

    /**
     * 查询稳定性和反应性列表
     * 
     * @param msdsStabilityReactivity 稳定性和反应性
     * @return 稳定性和反应性集合
     */
    public List<MsdsStabilityReactivity> selectMsdsStabilityReactivityList(MsdsStabilityReactivity msdsStabilityReactivity);

    /**
     * 新增稳定性和反应性
     * 
     * @param msdsStabilityReactivity 稳定性和反应性
     * @return 结果
     */
    public int insertMsdsStabilityReactivity(MsdsStabilityReactivity msdsStabilityReactivity);

    /**
     * 修改稳定性和反应性
     * 
     * @param msdsStabilityReactivity 稳定性和反应性
     * @return 结果
     */
    public int updateMsdsStabilityReactivity(MsdsStabilityReactivity msdsStabilityReactivity);

    /**
     * 删除稳定性和反应性
     * 
     * @param id 稳定性和反应性主键
     * @return 结果
     */
    public int deleteMsdsStabilityReactivityById(Long id);

    /**
     * 批量删除稳定性和反应性
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteMsdsStabilityReactivityByIds(Long[] ids);

    /**
     * 根据MSDS ID删除稳定性和反应性
     * 
     * @param msdsId MSDS主键
     * @return 结果
     */
    public int deleteMsdsStabilityReactivityByMsdsId(Long msdsId);
} 