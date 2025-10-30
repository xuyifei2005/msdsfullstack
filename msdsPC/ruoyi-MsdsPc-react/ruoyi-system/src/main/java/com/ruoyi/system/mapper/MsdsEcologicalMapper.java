package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.MsdsEcological;

/**
 * 生态学资料Mapper接口
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public interface MsdsEcologicalMapper 
{
    /**
     * 查询生态学资料
     * 
     * @param id 生态学资料主键
     * @return 生态学资料
     */
    public MsdsEcological selectMsdsEcologicalById(Long id);

    /**
     * 根据MSDS ID查询生态学资料
     * 
     * @param msdsId MSDS主键
     * @return 生态学资料
     */
    public MsdsEcological selectMsdsEcologicalByMsdsId(Long msdsId);

    /**
     * 查询生态学资料列表
     * 
     * @param msdsEcological 生态学资料
     * @return 生态学资料集合
     */
    public List<MsdsEcological> selectMsdsEcologicalList(MsdsEcological msdsEcological);

    /**
     * 新增生态学资料
     * 
     * @param msdsEcological 生态学资料
     * @return 结果
     */
    public int insertMsdsEcological(MsdsEcological msdsEcological);

    /**
     * 修改生态学资料
     * 
     * @param msdsEcological 生态学资料
     * @return 结果
     */
    public int updateMsdsEcological(MsdsEcological msdsEcological);

    /**
     * 删除生态学资料
     * 
     * @param id 生态学资料主键
     * @return 结果
     */
    public int deleteMsdsEcologicalById(Long id);

    /**
     * 批量删除生态学资料
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteMsdsEcologicalByIds(Long[] ids);

    /**
     * 根据MSDS ID删除生态学资料
     * 
     * @param msdsId MSDS主键
     * @return 结果
     */
    public int deleteMsdsEcologicalByMsdsId(Long msdsId);
} 