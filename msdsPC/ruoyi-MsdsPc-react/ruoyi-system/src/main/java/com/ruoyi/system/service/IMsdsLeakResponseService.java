package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.MsdsLeakResponse;

/**
 * 泄漏应急处理 服务层
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public interface IMsdsLeakResponseService
{
    /**
     * 查询泄漏应急处理
     * 
     * @param id 泄漏应急处理主键
     * @return 泄漏应急处理
     */
    public MsdsLeakResponse selectMsdsLeakResponseById(Long id);

    /**
     * 根据MSDS主表ID查询泄漏应急处理
     * 
     * @param msdsId MSDS主表ID
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
     * 批量删除泄漏应急处理
     * 
     * @param ids 需要删除的泄漏应急处理主键集合
     * @return 结果
     */
    public int deleteMsdsLeakResponseByIds(Long[] ids);

    /**
     * 删除泄漏应急处理
     * 
     * @param id 泄漏应急处理主键
     * @return 结果
     */
    public int deleteMsdsLeakResponseById(Long id);
} 