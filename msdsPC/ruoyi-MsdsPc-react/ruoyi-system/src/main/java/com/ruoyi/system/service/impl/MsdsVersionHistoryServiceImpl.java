package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.MsdsVersionHistoryMapper;
import com.ruoyi.system.domain.MsdsVersionHistory;
import com.ruoyi.system.service.IMsdsVersionHistoryService;
import com.ruoyi.common.utils.StringUtils;

/**
 * MSDS版本历史Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
@Service
public class MsdsVersionHistoryServiceImpl implements IMsdsVersionHistoryService 
{
    @Autowired
    private MsdsVersionHistoryMapper msdsVersionHistoryMapper;

    /**
     * 查询MSDS版本历史
     * 
     * @param id MSDS版本历史主键
     * @return MSDS版本历史
     */
    @Override
    public MsdsVersionHistory selectMsdsVersionHistoryById(Long id)
    {
        return msdsVersionHistoryMapper.selectMsdsVersionHistoryById(id);
    }

    /**
     * 根据MSDS ID查询版本历史列表
     * 
     * @param msdsId MSDS主表ID
     * @return MSDS版本历史集合
     */
    @Override
    public List<MsdsVersionHistory> selectMsdsVersionHistoryByMsdsId(Long msdsId)
    {
        return msdsVersionHistoryMapper.selectMsdsVersionHistoryByMsdsId(msdsId);
    }

    /**
     * 根据MSDS ID和版本号查询版本历史
     * 
     * @param msdsId MSDS主表ID
     * @param version 版本号
     * @return MSDS版本历史
     */
    @Override
    public MsdsVersionHistory selectMsdsVersionHistoryByMsdsIdAndVersion(Long msdsId, String version)
    {
        return msdsVersionHistoryMapper.selectMsdsVersionHistoryByMsdsIdAndVersion(msdsId, version);
    }

    /**
     * 查询MSDS版本历史列表
     * 
     * @param msdsVersionHistory MSDS版本历史
     * @return MSDS版本历史集合
     */
    @Override
    public List<MsdsVersionHistory> selectMsdsVersionHistoryList(MsdsVersionHistory msdsVersionHistory)
    {
        return msdsVersionHistoryMapper.selectMsdsVersionHistoryList(msdsVersionHistory);
    }

    /**
     * 获取最新版本历史
     * 
     * @param msdsId MSDS主表ID
     * @return MSDS版本历史
     */
    @Override
    public MsdsVersionHistory selectLatestVersionHistory(Long msdsId)
    {
        return msdsVersionHistoryMapper.selectLatestVersionByMsdsId(msdsId);
    }

    /**
     * 根据变更人查询版本历史列表
     * 
     * @param changedBy 变更人
     * @return MSDS版本历史集合
     */
    @Override
    public List<MsdsVersionHistory> selectMsdsVersionHistoryByChangedBy(String changedBy)
    {
        return msdsVersionHistoryMapper.selectMsdsVersionHistoryByChangedBy(changedBy);
    }

    /**
     * 新增MSDS版本历史
     * 
     * @param msdsVersionHistory MSDS版本历史
     * @return 结果
     */
    @Override
    public int insertMsdsVersionHistory(MsdsVersionHistory msdsVersionHistory)
    {
        return msdsVersionHistoryMapper.insertMsdsVersionHistory(msdsVersionHistory);
    }

    /**
     * 修改MSDS版本历史
     * 
     * @param msdsVersionHistory MSDS版本历史
     * @return 结果
     */
    @Override
    public int updateMsdsVersionHistory(MsdsVersionHistory msdsVersionHistory)
    {
        return msdsVersionHistoryMapper.updateMsdsVersionHistory(msdsVersionHistory);
    }

    /**
     * 批量删除MSDS版本历史
     * 
     * @param ids 需要删除的MSDS版本历史主键集合
     * @return 结果
     */
    @Override
    public int deleteMsdsVersionHistoryByIds(Long[] ids)
    {
        return msdsVersionHistoryMapper.deleteMsdsVersionHistoryByIds(ids);
    }

    /**
     * 删除MSDS版本历史信息
     * 
     * @param id MSDS版本历史主键
     * @return 结果
     */
    @Override
    public int deleteMsdsVersionHistoryById(Long id)
    {
        return msdsVersionHistoryMapper.deleteMsdsVersionHistoryById(id);
    }

    /**
     * 根据MSDS ID删除版本历史
     * 
     * @param msdsId MSDS主表ID
     * @return 结果
     */
    @Override
    public int deleteMsdsVersionHistoryByMsdsId(Long msdsId)
    {
        return msdsVersionHistoryMapper.deleteMsdsVersionHistoryByMsdsId(msdsId);
    }

    /**
     * 校验版本号是否唯一
     * 
     * @param msdsVersionHistory MSDS版本历史信息
     * @return 结果
     */
    @Override
    public boolean checkVersionUnique(MsdsVersionHistory msdsVersionHistory)
    {
        Long historyId = StringUtils.isNull(msdsVersionHistory.getId()) ? -1L : msdsVersionHistory.getId();
        int count = msdsVersionHistoryMapper.checkVersionUnique(msdsVersionHistory.getMsdsId(), msdsVersionHistory.getVersion());
        // 如果count > 0，说明存在重复的版本，需要进一步检查是否是当前记录
        if (count > 0)
        {
            // 查询具体的版本历史记录来比较ID
            MsdsVersionHistory existingVersion = msdsVersionHistoryMapper.selectMsdsVersionHistoryByMsdsIdAndVersion(
                msdsVersionHistory.getMsdsId(), msdsVersionHistory.getVersion());
            if (StringUtils.isNotNull(existingVersion) && existingVersion.getId().longValue() != historyId.longValue())
            {
                return false;
            }
        }
        return true;
    }
}