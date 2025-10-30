package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.MsdsRegulatory;

/**
 * 法规信息Mapper接口
 * 
 * @author ruoyi
 * @date 2024-02-18
 */
public interface MsdsRegulatoryMapper
{
    /**
     * 查询法规信息
     * 
     * @param id 法规信息主键
     * @return 法规信息
     */
    public MsdsRegulatory selectMsdsRegulatoryById(Long id);

    /**
     * 根据MSDS主表ID查询法规信息
     * 
     * @param msdsId MSDS主表ID
     * @return 法规信息
     */
    public MsdsRegulatory selectMsdsRegulatoryByMsdsId(Long msdsId);

    /**
     * 查询法规信息列表
     * 
     * @param msdsRegulatory 法规信息
     * @return 法规信息集合
     */
    public List<MsdsRegulatory> selectMsdsRegulatoryList(MsdsRegulatory msdsRegulatory);

    /**
     * 新增法规信息
     * 
     * @param msdsRegulatory 法规信息
     * @return 结果
     */
    public int insertMsdsRegulatory(MsdsRegulatory msdsRegulatory);

    /**
     * 修改法规信息
     * 
     * @param msdsRegulatory 法规信息
     * @return 结果
     */
    public int updateMsdsRegulatory(MsdsRegulatory msdsRegulatory);

    /**
     * 删除法规信息
     * 
     * @param id 法规信息主键
     * @return 结果
     */
    public int deleteMsdsRegulatoryById(Long id);

    /**
     * 批量删除法规信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteMsdsRegulatoryByIds(Long[] ids);

    /**
     * 根据MSDS ID删除法规信息
     * 
     * @param msdsId MSDS主键
     * @return 结果
     */
    public int deleteMsdsRegulatoryByMsdsId(Long msdsId);
}