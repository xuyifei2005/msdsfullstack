package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.MsdsToxicological;

/**
 * 毒理学资料Mapper接口
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public interface MsdsToxicologicalMapper 
{
    /**
     * 查询毒理学资料
     * 
     * @param id 毒理学资料主键
     * @return 毒理学资料
     */
    public MsdsToxicological selectMsdsToxicologicalById(Long id);

    /**
     * 根据MSDS ID查询毒理学资料
     * 
     * @param msdsId MSDS主键
     * @return 毒理学资料
     */
    public MsdsToxicological selectMsdsToxicologicalByMsdsId(Long msdsId);

    /**
     * 查询毒理学资料列表
     * 
     * @param msdsToxicological 毒理学资料
     * @return 毒理学资料集合
     */
    public List<MsdsToxicological> selectMsdsToxicologicalList(MsdsToxicological msdsToxicological);

    /**
     * 新增毒理学资料
     * 
     * @param msdsToxicological 毒理学资料
     * @return 结果
     */
    public int insertMsdsToxicological(MsdsToxicological msdsToxicological);

    /**
     * 修改毒理学资料
     * 
     * @param msdsToxicological 毒理学资料
     * @return 结果
     */
    public int updateMsdsToxicological(MsdsToxicological msdsToxicological);

    /**
     * 删除毒理学资料
     * 
     * @param id 毒理学资料主键
     * @return 结果
     */
    public int deleteMsdsToxicologicalById(Long id);

    /**
     * 批量删除毒理学资料
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteMsdsToxicologicalByIds(Long[] ids);

    /**
     * 根据MSDS ID删除毒理学资料
     * 
     * @param msdsId MSDS主键
     * @return 结果
     */
    public int deleteMsdsToxicologicalByMsdsId(Long msdsId);
} 