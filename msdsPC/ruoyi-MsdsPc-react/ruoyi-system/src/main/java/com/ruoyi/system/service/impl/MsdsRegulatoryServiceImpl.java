package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.MsdsRegulatoryMapper;
import com.ruoyi.system.domain.MsdsRegulatory;
import com.ruoyi.system.service.IMsdsRegulatoryService;

/**
 * 法规信息 服务层实现
 * 
 * @author ruoyi
 * @date 2024-02-18
 */
@Service
public class MsdsRegulatoryServiceImpl implements IMsdsRegulatoryService
{
    @Autowired
    private MsdsRegulatoryMapper msdsRegulatoryMapper;

    /**
     * 查询法规信息
     * 
     * @param id 法规信息主键
     * @return 法规信息
     */
    @Override
    public MsdsRegulatory selectMsdsRegulatoryById(Long id)
    {
        return msdsRegulatoryMapper.selectMsdsRegulatoryById(id);
    }

    /**
     * 根据MSDS主表ID查询法规信息
     * 
     * @param msdsId MSDS主表ID
     * @return 法规信息
     */
    @Override
    public MsdsRegulatory selectMsdsRegulatoryByMsdsId(Long msdsId)
    {
        return msdsRegulatoryMapper.selectMsdsRegulatoryByMsdsId(msdsId);
    }

    /**
     * 查询法规信息列表
     * 
     * @param msdsRegulatory 法规信息
     * @return 法规信息集合
     */
    @Override
    public List<MsdsRegulatory> selectMsdsRegulatoryList(MsdsRegulatory msdsRegulatory)
    {
        return msdsRegulatoryMapper.selectMsdsRegulatoryList(msdsRegulatory);
    }

    /**
     * 新增法规信息
     * 
     * @param msdsRegulatory 法规信息
     * @return 结果
     */
    @Override
    public int insertMsdsRegulatory(MsdsRegulatory msdsRegulatory)
    {
        return msdsRegulatoryMapper.insertMsdsRegulatory(msdsRegulatory);
    }

    /**
     * 修改法规信息
     * 
     * @param msdsRegulatory 法规信息
     * @return 结果
     */
    @Override
    public int updateMsdsRegulatory(MsdsRegulatory msdsRegulatory)
    {
        return msdsRegulatoryMapper.updateMsdsRegulatory(msdsRegulatory);
    }

    /**
     * 批量删除法规信息
     * 
     * @param ids 需要删除的法规信息主键
     * @return 结果
     */
    @Override
    public int deleteMsdsRegulatoryByIds(Long[] ids)
    {
        return msdsRegulatoryMapper.deleteMsdsRegulatoryByIds(ids);
    }

    /**
     * 删除法规信息信息
     * 
     * @param id 法规信息主键
     * @return 结果
     */
    @Override
    public int deleteMsdsRegulatoryById(Long id)
    {
        return msdsRegulatoryMapper.deleteMsdsRegulatoryById(id);
    }
}