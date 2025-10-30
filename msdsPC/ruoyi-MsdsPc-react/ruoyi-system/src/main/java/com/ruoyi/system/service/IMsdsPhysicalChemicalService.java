package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.MsdsPhysicalChemical;

/**
 * MSDS理化特性Service接口
 * 
 * @author ruoyi
 * @date 2024-01-15
 */
public interface IMsdsPhysicalChemicalService 
{
    /**
     * 查询MSDS理化特性
     * 
     * @param id MSDS理化特性主键
     * @return MSDS理化特性
     */
    public MsdsPhysicalChemical selectMsdsPhysicalChemicalById(Long id);

    /**
     * 查询MSDS理化特性列表
     * 
     * @param msdsPhysicalChemical MSDS理化特性
     * @return MSDS理化特性集合
     */
    public List<MsdsPhysicalChemical> selectMsdsPhysicalChemicalList(MsdsPhysicalChemical msdsPhysicalChemical);

    /**
     * 根据MSDS主表ID查询理化特性
     * 
     * @param msdsId MSDS主表ID
     * @return MSDS理化特性
     */
    public MsdsPhysicalChemical selectMsdsPhysicalChemicalByMsdsId(Long msdsId);

    /**
     * 新增MSDS理化特性
     * 
     * @param msdsPhysicalChemical MSDS理化特性
     * @return 结果
     */
    public int insertMsdsPhysicalChemical(MsdsPhysicalChemical msdsPhysicalChemical);

    /**
     * 修改MSDS理化特性
     * 
     * @param msdsPhysicalChemical MSDS理化特性
     * @return 结果
     */
    public int updateMsdsPhysicalChemical(MsdsPhysicalChemical msdsPhysicalChemical);

    /**
     * 批量删除MSDS理化特性
     * 
     * @param ids 需要删除的MSDS理化特性主键集合
     * @return 结果
     */
    public int deleteMsdsPhysicalChemicalByIds(Long[] ids);

    /**
     * 删除MSDS理化特性信息
     * 
     * @param id MSDS理化特性主键
     * @return 结果
     */
    public int deleteMsdsPhysicalChemicalById(Long id);

    /**
     * 根据MSDS主表ID删除理化特性
     * 
     * @param msdsId MSDS主表ID
     * @return 结果
     */
    public int deleteMsdsPhysicalChemicalByMsdsId(Long msdsId);
}