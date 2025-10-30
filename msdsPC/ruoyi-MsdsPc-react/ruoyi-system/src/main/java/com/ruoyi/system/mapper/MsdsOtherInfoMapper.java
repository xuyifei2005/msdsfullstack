package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.MsdsOtherInfo;

/**
 * 其他信息Mapper接口
 * 
 * @author ruoyi
 * @date 2024-02-18
 */
public interface MsdsOtherInfoMapper
{
    /**
     * 查询其他信息
     * 
     * @param id 其他信息主键
     * @return 其他信息
     */
    public MsdsOtherInfo selectMsdsOtherInfoById(Long id);

    /**
     * 根据MSDS主表ID查询其他信息
     * 
     * @param msdsId MSDS主表ID
     * @return 其他信息
     */
    public MsdsOtherInfo selectMsdsOtherInfoByMsdsId(Long msdsId);

    /**
     * 查询其他信息列表
     * 
     * @param msdsOtherInfo 其他信息
     * @return 其他信息集合
     */
    public List<MsdsOtherInfo> selectMsdsOtherInfoList(MsdsOtherInfo msdsOtherInfo);

    /**
     * 新增其他信息
     * 
     * @param msdsOtherInfo 其他信息
     * @return 结果
     */
    public int insertMsdsOtherInfo(MsdsOtherInfo msdsOtherInfo);

    /**
     * 修改其他信息
     * 
     * @param msdsOtherInfo 其他信息
     * @return 结果
     */
    public int updateMsdsOtherInfo(MsdsOtherInfo msdsOtherInfo);

    /**
     * 删除其他信息
     * 
     * @param id 其他信息主键
     * @return 结果
     */
    public int deleteMsdsOtherInfoById(Long id);

    /**
     * 批量删除其他信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteMsdsOtherInfoByIds(Long[] ids);

    /**
     * 根据MSDS ID删除其他信息
     * 
     * @param msdsId MSDS主键
     * @return 结果
     */
    public int deleteMsdsOtherInfoByMsdsId(Long msdsId);
}