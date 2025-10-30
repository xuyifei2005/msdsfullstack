package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.MsdsHandlingStorageMapper;
import com.ruoyi.system.domain.MsdsHandlingStorage;
import com.ruoyi.system.service.IMsdsHandlingStorageService;

/**
 * 操作处置与储存 服务层实现
 * 
 * @author ruoyi
 * @date 2024-02-18
 */
@Service
public class MsdsHandlingStorageServiceImpl implements IMsdsHandlingStorageService
{
    @Autowired
    private MsdsHandlingStorageMapper msdsHandlingStorageMapper;

    /**
     * 查询操作处置与储存信息
     * 
     * @param id 操作处置与储存主键
     * @return 操作处置与储存信息
     */
    @Override
    public MsdsHandlingStorage selectMsdsHandlingStorageById(Long id)
    {
        return msdsHandlingStorageMapper.selectMsdsHandlingStorageById(id);
    }

    /**
     * 根据MSDS主表ID查询操作处置与储存信息
     * 
     * @param msdsId MSDS主表ID
     * @return 操作处置与储存信息
     */
    @Override
    public MsdsHandlingStorage selectMsdsHandlingStorageByMsdsId(Long msdsId)
    {
        return msdsHandlingStorageMapper.selectMsdsHandlingStorageByMsdsId(msdsId);
    }

    /**
     * 查询操作处置与储存列表
     * 
     * @param msdsHandlingStorage 操作处置与储存信息
     * @return 操作处置与储存集合
     */
    @Override
    public List<MsdsHandlingStorage> selectMsdsHandlingStorageList(MsdsHandlingStorage msdsHandlingStorage)
    {
        return msdsHandlingStorageMapper.selectMsdsHandlingStorageList(msdsHandlingStorage);
    }

    /**
     * 新增操作处置与储存
     * 
     * @param msdsHandlingStorage 操作处置与储存信息
     * @return 结果
     */
    @Override
    public int insertMsdsHandlingStorage(MsdsHandlingStorage msdsHandlingStorage)
    {
        return msdsHandlingStorageMapper.insertMsdsHandlingStorage(msdsHandlingStorage);
    }

    /**
     * 修改操作处置与储存
     * 
     * @param msdsHandlingStorage 操作处置与储存信息
     * @return 结果
     */
    @Override
    public int updateMsdsHandlingStorage(MsdsHandlingStorage msdsHandlingStorage)
    {
        return msdsHandlingStorageMapper.updateMsdsHandlingStorage(msdsHandlingStorage);
    }

    /**
     * 批量删除操作处置与储存
     * 
     * @param ids 需要删除的操作处置与储存主键集合
     * @return 结果
     */
    @Override
    public int deleteMsdsHandlingStorageByIds(Long[] ids)
    {
        return msdsHandlingStorageMapper.deleteMsdsHandlingStorageByIds(ids);
    }

    /**
     * 删除操作处置与储存信息
     * 
     * @param id 操作处置与储存主键
     * @return 结果
     */
    @Override
    public int deleteMsdsHandlingStorageById(Long id)
    {
        return msdsHandlingStorageMapper.deleteMsdsHandlingStorageById(id);
    }
} 