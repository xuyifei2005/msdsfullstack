package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.MsdsLeakResponse;

/**
 * 泄漏应急处理Mapper接口
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public interface MsdsLeakResponseMapper 
{
    /**
     * 查询泄漏应急处理
     * 
     * @param id 泄漏应急处理主键
     * @return 泄漏应急处理
     */
    public MsdsLeakResponse selectMsdsLeakResponseById(Long id);

    /**
     * 根据MSDS ID查询泄漏应急处理
     * 
     * @param msdsId MSDS主键
     * @return 泄漏应急处理
     */
    public MsdsLeakResponse selectMsdsLeakResponseByMsdsId(Long msdsId);

    /**
     * 查询泄漏应急处理列表
     * 
     * @param msdsLeakResponse 泄漏应急处理
     * @return 泄漏应急处理集合
     */
    public List<MsdsLeakResponse> selectMsdsLeakResponseList(MsdsLeakResponse msdsLeakResponse);

    /**
     * 新增泄漏应急处理
     * 
     * @param msdsLeakResponse 泄漏应急处理
     * @return 结果
     */
    public int insertMsdsLeakResponse(MsdsLeakResponse msdsLeakResponse);

    /**
     * 修改泄漏应急处理
     * 
     * @param msdsLeakResponse 泄漏应急处理
     * @return 结果
     */
    public int updateMsdsLeakResponse(MsdsLeakResponse msdsLeakResponse);

    /**
     * 删除泄漏应急处理
     * 
     * @param id 泄漏应急处理主键
     * @return 结果
     */
    public int deleteMsdsLeakResponseById(Long id);

    /**
     * 批量删除泄漏应急处理
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteMsdsLeakResponseByIds(Long[] ids);

    /**
     * 根据MSDS ID删除泄漏应急处理
     * 
     * @param msdsId MSDS主键
     * @return 结果
     */
    public int deleteMsdsLeakResponseByMsdsId(Long msdsId);
} 