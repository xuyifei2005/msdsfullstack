package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.MsdsHandlingStorage;

/**
 * 操作处置与储存 服务层
 * 
 * @author ruoyi
 * @date 2024-02-18
 */
public interface IMsdsHandlingStorageService
{
    /**
     * 查询操作处置与储存信息
     * 
     * @param id 操作处置与储存主键
     * @return 操作处置与储存信息
     */
    public MsdsHandlingStorage selectMsdsHandlingStorageById(Long id);

    /**
     * 根据MSDS主表ID查询操作处置与储存信息
     * 
     * @param msdsId MSDS主表ID
     * @return 操作处置与储存信息
     */
    public MsdsHandlingStorage selectMsdsHandlingStorageByMsdsId(Long msdsId);

    /**
     * 查询操作处置与储存列表
     * 
     * @param msdsHandlingStorage 操作处置与储存信息
     * @return 操作处置与储存集合
     */
    public List<MsdsHandlingStorage> selectMsdsHandlingStorageList(MsdsHandlingStorage msdsHandlingStorage);

    /**
     * 新增操作处置与储存
     * 
     * @param msdsHandlingStorage 操作处置与储存信息
     * @return 结果
     */
    public int insertMsdsHandlingStorage(MsdsHandlingStorage msdsHandlingStorage);

    /**
     * 修改操作处置与储存
     * 
     * @param msdsHandlingStorage 操作处置与储存信息
     * @return 结果
     */
    public int updateMsdsHandlingStorage(MsdsHandlingStorage msdsHandlingStorage);

    /**
     * 批量删除操作处置与储存
     * 
     * @param ids 需要删除的操作处置与储存主键集合
     * @return 结果
     */
    public int deleteMsdsHandlingStorageByIds(Long[] ids);

    /**
     * 删除操作处置与储存信息
     * 
     * @param id 操作处置与储存主键
     * @return 结果
     */
    public int deleteMsdsHandlingStorageById(Long id);
} 