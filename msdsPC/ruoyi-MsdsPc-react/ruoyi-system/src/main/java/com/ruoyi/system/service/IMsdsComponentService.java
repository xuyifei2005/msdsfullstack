package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.MsdsComponent;

/**
 * MSDS成分/组成信息Service接口
 * 
 * @author ruoyi
 * @date 2024-01-15
 */
public interface IMsdsComponentService 
{
    /**
     * 查询MSDS成分/组成信息
     * 
     * @param id MSDS成分/组成信息主键
     * @return MSDS成分/组成信息
     */
    public MsdsComponent selectMsdsComponentById(Long id);

    /**
     * 查询MSDS成分/组成信息列表
     * 
     * @param msdsComponent MSDS成分/组成信息
     * @return MSDS成分/组成信息集合
     */
    public List<MsdsComponent> selectMsdsComponentList(MsdsComponent msdsComponent);

    /**
     * 根据MSDS主表ID查询成分/组成信息列表
     * 
     * @param msdsId MSDS主表ID
     * @return MSDS成分/组成信息集合
     */
    public List<MsdsComponent> selectMsdsComponentByMsdsId(Long msdsId);

    /**
     * 新增MSDS成分/组成信息
     * 
     * @param msdsComponent MSDS成分/组成信息
     * @return 结果
     */
    public int insertMsdsComponent(MsdsComponent msdsComponent);

    /**
     * 修改MSDS成分/组成信息
     * 
     * @param msdsComponent MSDS成分/组成信息
     * @return 结果
     */
    public int updateMsdsComponent(MsdsComponent msdsComponent);

    /**
     * 批量删除MSDS成分/组成信息
     * 
     * @param ids 需要删除的MSDS成分/组成信息主键集合
     * @return 结果
     */
    public int deleteMsdsComponentByIds(Long[] ids);

    /**
     * 删除MSDS成分/组成信息信息
     * 
     * @param id MSDS成分/组成信息主键
     * @return 结果
     */
    public int deleteMsdsComponentById(Long id);

    /**
     * 根据MSDS主表ID删除成分/组成信息
     * 
     * @param msdsId MSDS主表ID
     * @return 结果
     */
    public int deleteMsdsComponentByMsdsId(Long msdsId);

    /**
     * 批量保存MSDS成分/组成信息
     * 
     * @param components MSDS成分/组成信息列表
     * @return 结果
     */
    public int batchSaveMsdsComponent(List<MsdsComponent> components);
}