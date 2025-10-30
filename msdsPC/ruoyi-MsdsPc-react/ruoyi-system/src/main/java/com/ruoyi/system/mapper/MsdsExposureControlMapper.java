package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.MsdsExposureControl;

/**
 * 接触控制/个体防护Mapper接口
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public interface MsdsExposureControlMapper 
{
    /**
     * 查询接触控制/个体防护
     * 
     * @param id 接触控制/个体防护主键
     * @return 接触控制/个体防护
     */
    public MsdsExposureControl selectMsdsExposureControlById(Long id);

    /**
     * 根据MSDS ID查询接触控制/个体防护
     * 
     * @param msdsId MSDS主键
     * @return 接触控制/个体防护
     */
    public MsdsExposureControl selectMsdsExposureControlByMsdsId(Long msdsId);

    /**
     * 查询接触控制/个体防护列表
     * 
     * @param msdsExposureControl 接触控制/个体防护
     * @return 接触控制/个体防护集合
     */
    public List<MsdsExposureControl> selectMsdsExposureControlList(MsdsExposureControl msdsExposureControl);

    /**
     * 新增接触控制/个体防护
     * 
     * @param msdsExposureControl 接触控制/个体防护
     * @return 结果
     */
    public int insertMsdsExposureControl(MsdsExposureControl msdsExposureControl);

    /**
     * 修改接触控制/个体防护
     * 
     * @param msdsExposureControl 接触控制/个体防护
     * @return 结果
     */
    public int updateMsdsExposureControl(MsdsExposureControl msdsExposureControl);

    /**
     * 删除接触控制/个体防护
     * 
     * @param id 接触控制/个体防护主键
     * @return 结果
     */
    public int deleteMsdsExposureControlById(Long id);

    /**
     * 批量删除接触控制/个体防护
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteMsdsExposureControlByIds(Long[] ids);

    /**
     * 根据MSDS ID删除接触控制/个体防护
     * 
     * @param msdsId MSDS主键
     * @return 结果
     */
    public int deleteMsdsExposureControlByMsdsId(Long msdsId);
} 