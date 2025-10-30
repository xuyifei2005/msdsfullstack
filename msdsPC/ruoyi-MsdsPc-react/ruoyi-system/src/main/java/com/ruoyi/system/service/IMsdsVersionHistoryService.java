package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.MsdsVersionHistory;

/**
 * MSDS版本历史Service接口
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public interface IMsdsVersionHistoryService 
{
    /**
     * 查询MSDS版本历史
     * 
     * @param id MSDS版本历史主键
     * @return MSDS版本历史
     */
    public MsdsVersionHistory selectMsdsVersionHistoryById(Long id);

    /**
     * 根据MSDS ID查询版本历史列表
     * 
     * @param msdsId MSDS主表ID
     * @return MSDS版本历史集合
     */
    public List<MsdsVersionHistory> selectMsdsVersionHistoryByMsdsId(Long msdsId);

    /**
     * 根据MSDS ID和版本号查询版本历史
     * 
     * @param msdsId MSDS主表ID
     * @param version 版本号
     * @return MSDS版本历史
     */
    public MsdsVersionHistory selectMsdsVersionHistoryByMsdsIdAndVersion(Long msdsId, String version);

    /**
     * 查询MSDS版本历史列表
     * 
     * @param msdsVersionHistory MSDS版本历史
     * @return MSDS版本历史集合
     */
    public List<MsdsVersionHistory> selectMsdsVersionHistoryList(MsdsVersionHistory msdsVersionHistory);

    /**
     * 获取最新版本历史
     * 
     * @param msdsId MSDS主表ID
     * @return MSDS版本历史
     */
    public MsdsVersionHistory selectLatestVersionHistory(Long msdsId);

    /**
     * 根据变更人查询版本历史列表
     * 
     * @param changedBy 变更人
     * @return MSDS版本历史集合
     */
    public List<MsdsVersionHistory> selectMsdsVersionHistoryByChangedBy(String changedBy);

    /**
     * 新增MSDS版本历史
     * 
     * @param msdsVersionHistory MSDS版本历史
     * @return 结果
     */
    public int insertMsdsVersionHistory(MsdsVersionHistory msdsVersionHistory);

    /**
     * 修改MSDS版本历史
     * 
     * @param msdsVersionHistory MSDS版本历史
     * @return 结果
     */
    public int updateMsdsVersionHistory(MsdsVersionHistory msdsVersionHistory);

    /**
     * 批量删除MSDS版本历史
     * 
     * @param ids 需要删除的MSDS版本历史主键集合
     * @return 结果
     */
    public int deleteMsdsVersionHistoryByIds(Long[] ids);

    /**
     * 删除MSDS版本历史信息
     * 
     * @param id MSDS版本历史主键
     * @return 结果
     */
    public int deleteMsdsVersionHistoryById(Long id);

    /**
     * 根据MSDS ID删除版本历史
     * 
     * @param msdsId MSDS主表ID
     * @return 结果
     */
    public int deleteMsdsVersionHistoryByMsdsId(Long msdsId);

    /**
     * 校验版本号是否唯一
     * 
     * @param msdsVersionHistory MSDS版本历史信息
     * @return 结果
     */
    public boolean checkVersionUnique(MsdsVersionHistory msdsVersionHistory);
}