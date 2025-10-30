package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.MsdsToxicological;

/**
 * 毒理学资料 服务层
 * 
 * @author ruoyi
 * @date 2024-02-18
 */
public interface IMsdsToxicologicalService
{
    /**
     * 查询毒理学资料信息
     * 
     * @param id 毒理学资料主键
     * @return 毒理学资料信息
     */
    public MsdsToxicological selectMsdsToxicologicalById(Long id);

    /**
     * 根据MSDS主表ID查询毒理学资料信息
     * 
     * @param msdsId MSDS主表ID
     * @return 毒理学资料信息
     */
    public MsdsToxicological selectMsdsToxicologicalByMsdsId(Long msdsId);

    /**
     * 查询毒理学资料列表
     * 
     * @param msdsToxicological 毒理学资料信息
     * @return 毒理学资料集合
     */
    public List<MsdsToxicological> selectMsdsToxicologicalList(MsdsToxicological msdsToxicological);

    /**
     * 新增毒理学资料
     * 
     * @param msdsToxicological 毒理学资料信息
     * @return 结果
     */
    public int insertMsdsToxicological(MsdsToxicological msdsToxicological);

    /**
     * 修改毒理学资料
     * 
     * @param msdsToxicological 毒理学资料信息
     * @return 结果
     */
    public int updateMsdsToxicological(MsdsToxicological msdsToxicological);

    /**
     * 批量删除毒理学资料
     * 
     * @param ids 需要删除的毒理学资料主键集合
     * @return 结果
     */
    public int deleteMsdsToxicologicalByIds(Long[] ids);

    /**
     * 删除毒理学资料信息
     * 
     * @param id 毒理学资料主键
     * @return 结果
     */
    public int deleteMsdsToxicologicalById(Long id);
} 