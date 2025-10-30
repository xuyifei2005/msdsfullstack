package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.MsdsVersionHistory;

/**
 * MSDS版本历史Mapper接口
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
public interface MsdsVersionHistoryMapper 
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
     * @param msdsId MSDS主键
     * @return MSDS版本历史集合
     */
    public List<MsdsVersionHistory> selectMsdsVersionHistoryByMsdsId(Long msdsId);

    /**
     * 根据MSDS ID和版本号查询版本历史
     * 
     * @param msdsId MSDS主键
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
     * 查询指定MSDS的最新版本
     * 
     * @param msdsId MSDS主键
     * @return MSDS版本历史
     */
    public MsdsVersionHistory selectLatestVersionByMsdsId(Long msdsId);

    /**
     * 查询指定用户的变更历史
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
     * 删除MSDS版本历史
     * 
     * @param id MSDS版本历史主键
     * @return 结果
     */
    public int deleteMsdsVersionHistoryById(Long id);

    /**
     * 批量删除MSDS版本历史
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteMsdsVersionHistoryByIds(Long[] ids);

    /**
     * 根据MSDS ID删除版本历史
     * 
     * @param msdsId MSDS主键
     * @return 结果
     */
    public int deleteMsdsVersionHistoryByMsdsId(Long msdsId);

    /**
     * 检查版本号是否存在
     * 
     * @param msdsId MSDS主键
     * @param version 版本号
     * @return 结果
     */
    public int checkVersionUnique(Long msdsId, String version);
}