package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.MsdsExposureControl;

/**
 * 接触控制/个体防护 服务层
 * 
 * @author ruoyi
 * @date 2024-02-18
 */
public interface IMsdsExposureControlService
{
    /**
     * 查询接触控制/个体防护信息
     * 
     * @param id 接触控制/个体防护主键
     * @return 接触控制/个体防护信息
     */
    public MsdsExposureControl selectMsdsExposureControlById(Long id);

    /**
     * 根据MSDS主表ID查询接触控制/个体防护信息
     * 
     * @param msdsId MSDS主表ID
     * @return 接触控制/个体防护信息
     */
    public MsdsExposureControl selectMsdsExposureControlByMsdsId(Long msdsId);

    /**
     * 查询接触控制/个体防护列表
     * 
     * @param msdsExposureControl 接触控制/个体防护信息
     * @return 接触控制/个体防护集合
     */
    public List<MsdsExposureControl> selectMsdsExposureControlList(MsdsExposureControl msdsExposureControl);

    /**
     * 新增接触控制/个体防护
     * 
     * @param msdsExposureControl 接触控制/个体防护信息
     * @return 结果
     */
    public int insertMsdsExposureControl(MsdsExposureControl msdsExposureControl);

    /**
     * 修改接触控制/个体防护
     * 
     * @param msdsExposureControl 接触控制/个体防护信息
     * @return 结果
     */
    public int updateMsdsExposureControl(MsdsExposureControl msdsExposureControl);

    /**
     * 批量删除接触控制/个体防护
     * 
     * @param ids 需要删除的接触控制/个体防护主键集合
     * @return 结果
     */
    public int deleteMsdsExposureControlByIds(Long[] ids);

    /**
     * 删除接触控制/个体防护信息
     * 
     * @param id 接触控制/个体防护主键
     * @return 结果
     */
    public int deleteMsdsExposureControlById(Long id);
} 