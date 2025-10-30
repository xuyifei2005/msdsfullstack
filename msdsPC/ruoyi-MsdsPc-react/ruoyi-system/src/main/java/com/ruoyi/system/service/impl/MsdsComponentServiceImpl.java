package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.MsdsComponentMapper;
import com.ruoyi.system.domain.MsdsComponent;
import com.ruoyi.system.service.IMsdsComponentService;

/**
 * MSDS成分/组成信息Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-01-15
 */
@Service
public class MsdsComponentServiceImpl implements IMsdsComponentService 
{
    @Autowired
    private MsdsComponentMapper msdsComponentMapper;

    /**
     * 查询MSDS成分/组成信息
     * 
     * @param id MSDS成分/组成信息主键
     * @return MSDS成分/组成信息
     */
    @Override
    public MsdsComponent selectMsdsComponentById(Long id)
    {
        return msdsComponentMapper.selectMsdsComponentById(id);
    }

    /**
     * 查询MSDS成分/组成信息列表
     * 
     * @param msdsComponent MSDS成分/组成信息
     * @return MSDS成分/组成信息
     */
    @Override
    public List<MsdsComponent> selectMsdsComponentList(MsdsComponent msdsComponent)
    {
        return msdsComponentMapper.selectMsdsComponentList(msdsComponent);
    }

    /**
     * 根据MSDS主表ID查询成分/组成信息列表
     * 
     * @param msdsId MSDS主表ID
     * @return MSDS成分/组成信息集合
     */
    @Override
    public List<MsdsComponent> selectMsdsComponentByMsdsId(Long msdsId)
    {
        return msdsComponentMapper.selectMsdsComponentByMsdsId(msdsId);
    }

    /**
     * 新增MSDS成分/组成信息
     * 
     * @param msdsComponent MSDS成分/组成信息
     * @return 结果
     */
    @Override
    public int insertMsdsComponent(MsdsComponent msdsComponent)
    {
        return msdsComponentMapper.insertMsdsComponent(msdsComponent);
    }

    /**
     * 修改MSDS成分/组成信息
     * 
     * @param msdsComponent MSDS成分/组成信息
     * @return 结果
     */
    @Override
    public int updateMsdsComponent(MsdsComponent msdsComponent)
    {
        return msdsComponentMapper.updateMsdsComponent(msdsComponent);
    }

    /**
     * 批量删除MSDS成分/组成信息
     * 
     * @param ids 需要删除的MSDS成分/组成信息主键
     * @return 结果
     */
    @Override
    public int deleteMsdsComponentByIds(Long[] ids)
    {
        return msdsComponentMapper.deleteMsdsComponentByIds(ids);
    }

    /**
     * 删除MSDS成分/组成信息信息
     * 
     * @param id MSDS成分/组成信息主键
     * @return 结果
     */
    @Override
    public int deleteMsdsComponentById(Long id)
    {
        return msdsComponentMapper.deleteMsdsComponentById(id);
    }

    /**
     * 根据MSDS主表ID删除成分/组成信息
     * 
     * @param msdsId MSDS主表ID
     * @return 结果
     */
    @Override
    public int deleteMsdsComponentByMsdsId(Long msdsId)
    {
        return msdsComponentMapper.deleteMsdsComponentByMsdsId(msdsId);
    }

    /**
     * 批量保存MSDS成分/组成信息
     * 
     * @param components MSDS成分/组成信息列表
     * @return 结果
     */
    @Override
    public int batchSaveMsdsComponent(List<MsdsComponent> components)
    {
        int result = 0;
        for (MsdsComponent component : components) {
            if (component.getId() == null) {
                // 新增
                result += msdsComponentMapper.insertMsdsComponent(component);
            } else {
                // 更新
                result += msdsComponentMapper.updateMsdsComponent(component);
            }
        }
        return result;
    }
}