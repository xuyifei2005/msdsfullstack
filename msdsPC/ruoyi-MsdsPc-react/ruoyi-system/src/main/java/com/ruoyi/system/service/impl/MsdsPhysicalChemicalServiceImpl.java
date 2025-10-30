package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.MsdsPhysicalChemicalMapper;
import com.ruoyi.system.domain.MsdsPhysicalChemical;
import com.ruoyi.system.service.IMsdsPhysicalChemicalService;

/**
 * MSDS理化特性Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-01-15
 */
@Service
public class MsdsPhysicalChemicalServiceImpl implements IMsdsPhysicalChemicalService 
{
    @Autowired
    private MsdsPhysicalChemicalMapper msdsPhysicalChemicalMapper;

    /**
     * 查询MSDS理化特性
     * 
     * @param id MSDS理化特性主键
     * @return MSDS理化特性
     */
    @Override
    public MsdsPhysicalChemical selectMsdsPhysicalChemicalById(Long id)
    {
        return msdsPhysicalChemicalMapper.selectMsdsPhysicalChemicalById(id);
    }

    /**
     * 查询MSDS理化特性列表
     * 
     * @param msdsPhysicalChemical MSDS理化特性
     * @return MSDS理化特性
     */
    @Override
    public List<MsdsPhysicalChemical> selectMsdsPhysicalChemicalList(MsdsPhysicalChemical msdsPhysicalChemical)
    {
        return msdsPhysicalChemicalMapper.selectMsdsPhysicalChemicalList(msdsPhysicalChemical);
    }

    /**
     * 根据MSDS主表ID查询理化特性
     * 
     * @param msdsId MSDS主表ID
     * @return MSDS理化特性
     */
    @Override
    public MsdsPhysicalChemical selectMsdsPhysicalChemicalByMsdsId(Long msdsId)
    {
        return msdsPhysicalChemicalMapper.selectMsdsPhysicalChemicalByMsdsId(msdsId);
    }

    /**
     * 新增MSDS理化特性
     * 
     * @param msdsPhysicalChemical MSDS理化特性
     * @return 结果
     */
    @Override
    public int insertMsdsPhysicalChemical(MsdsPhysicalChemical msdsPhysicalChemical)
    {
        return msdsPhysicalChemicalMapper.insertMsdsPhysicalChemical(msdsPhysicalChemical);
    }

    /**
     * 修改MSDS理化特性
     * 
     * @param msdsPhysicalChemical MSDS理化特性
     * @return 结果
     */
    @Override
    public int updateMsdsPhysicalChemical(MsdsPhysicalChemical msdsPhysicalChemical)
    {
        return msdsPhysicalChemicalMapper.updateMsdsPhysicalChemical(msdsPhysicalChemical);
    }

    /**
     * 批量删除MSDS理化特性
     * 
     * @param ids 需要删除的MSDS理化特性主键
     * @return 结果
     */
    @Override
    public int deleteMsdsPhysicalChemicalByIds(Long[] ids)
    {
        return msdsPhysicalChemicalMapper.deleteMsdsPhysicalChemicalByIds(ids);
    }

    /**
     * 删除MSDS理化特性信息
     * 
     * @param id MSDS理化特性主键
     * @return 结果
     */
    @Override
    public int deleteMsdsPhysicalChemicalById(Long id)
    {
        return msdsPhysicalChemicalMapper.deleteMsdsPhysicalChemicalById(id);
    }

    /**
     * 根据MSDS主表ID删除理化特性
     * 
     * @param msdsId MSDS主表ID
     * @return 结果
     */
    @Override
    public int deleteMsdsPhysicalChemicalByMsdsId(Long msdsId)
    {
        return msdsPhysicalChemicalMapper.deleteMsdsPhysicalChemicalByMsdsId(msdsId);
    }
}