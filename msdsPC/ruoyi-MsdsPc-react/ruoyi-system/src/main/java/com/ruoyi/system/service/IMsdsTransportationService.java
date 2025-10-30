package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.MsdsTransportation;

/**
 * 运输信息 服务层
 * 
 * @author ruoyi
 * @date 2024-02-18
 */
public interface IMsdsTransportationService
{
    /**
     * 查询运输信息
     * 
     * @param id 运输信息主键
     * @return 运输信息
     */
    public MsdsTransportation selectMsdsTransportationById(Long id);

    /**
     * 根据MSDS主表ID查询运输信息
     * 
     * @param msdsId MSDS主表ID
     * @return 运输信息
     */
    public MsdsTransportation selectMsdsTransportationByMsdsId(Long msdsId);

    /**
     * 查询运输信息列表
     * 
     * @param msdsTransportation 运输信息
     * @return 运输信息集合
     */
    public List<MsdsTransportation> selectMsdsTransportationList(MsdsTransportation msdsTransportation);

    /**
     * 新增运输信息
     * 
     * @param msdsTransportation 运输信息
     * @return 结果
     */
    public int insertMsdsTransportation(MsdsTransportation msdsTransportation);

    /**
     * 修改运输信息
     * 
     * @param msdsTransportation 运输信息
     * @return 结果
     */
    public int updateMsdsTransportation(MsdsTransportation msdsTransportation);

    /**
     * 批量删除运输信息
     * 
     * @param ids 需要删除的运输信息主键集合
     * @return 结果
     */
    public int deleteMsdsTransportationByIds(Long[] ids);

    /**
     * 删除运输信息
     * 
     * @param id 运输信息主键
     * @return 结果
     */
    public int deleteMsdsTransportationById(Long id);
} 