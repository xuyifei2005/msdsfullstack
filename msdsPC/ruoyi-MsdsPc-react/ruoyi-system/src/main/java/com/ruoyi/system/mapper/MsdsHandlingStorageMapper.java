package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.MsdsHandlingStorage;

/**
 * 操作处置与储存Mapper接口
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public interface MsdsHandlingStorageMapper 
{
    /**
     * 查询操作处置与储存
     * 
     * @param id 操作处置与储存主键
     * @return 操作处置与储存
     */
    public MsdsHandlingStorage selectMsdsHandlingStorageById(Long id);

    /**
     * 根据MSDS ID查询操作处置与储存
     * 
     * @param msdsId MSDS主键
     * @return 操作处置与储存
     */
    public MsdsHandlingStorage selectMsdsHandlingStorageByMsdsId(Long msdsId);

    /**
     * 查询操作处置与储存列表
     * 
     * @param msdsHandlingStorage 操作处置与储存
     * @return 操作处置与储存集合
     */
    public List<MsdsHandlingStorage> selectMsdsHandlingStorageList(MsdsHandlingStorage msdsHandlingStorage);

    /**
     * 新增操作处置与储存
     * 
     * @param msdsHandlingStorage 操作处置与储存
     * @return 结果
     */
    public int insertMsdsHandlingStorage(MsdsHandlingStorage msdsHandlingStorage);

    /**
     * 修改操作处置与储存
     * 
     * @param msdsHandlingStorage 操作处置与储存
     * @return 结果
     */
    public int updateMsdsHandlingStorage(MsdsHandlingStorage msdsHandlingStorage);

    /**
     * 删除操作处置与储存
     * 
     * @param id 操作处置与储存主键
     * @return 结果
     */
    public int deleteMsdsHandlingStorageById(Long id);

    /**
     * 批量删除操作处置与储存
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteMsdsHandlingStorageByIds(Long[] ids);

    /**
     * 根据MSDS ID删除操作处置与储存
     * 
     * @param msdsId MSDS主键
     * @return 结果
     */
    public int deleteMsdsHandlingStorageByMsdsId(Long msdsId);
} 