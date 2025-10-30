package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.MsdsLeakResponseMapper;
import com.ruoyi.system.domain.MsdsLeakResponse;
import com.ruoyi.system.service.IMsdsLeakResponseService;

/**
 * 泄漏应急处理 服务层实现
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
@Service
public class MsdsLeakResponseServiceImpl implements IMsdsLeakResponseService
{
    @Autowired
    private MsdsLeakResponseMapper msdsLeakResponseMapper;

    /**
     * 查询泄漏应急处理
     * 
     * @param id 泄漏应急处理主键
     * @return 泄漏应急处理
     */
    @Override
    public MsdsLeakResponse selectMsdsLeakResponseById(Long id)
    {
        return msdsLeakResponseMapper.selectMsdsLeakResponseById(id);
    }

    /**
     * 根据MSDS主表ID查询泄漏应急处理
     * 
     * @param msdsId MSDS主表ID
     * @return 泄漏应急处理
     */
    @Override
    public MsdsLeakResponse selectMsdsLeakResponseByMsdsId(Long msdsId)
    {
        return msdsLeakResponseMapper.selectMsdsLeakResponseByMsdsId(msdsId);
    }

    /**
     * 查询泄漏应急处理列表
     * 
     * @param msdsLeakResponse 泄漏应急处理
     * @return 泄漏应急处理集合
     */
    @Override
    public List<MsdsLeakResponse> selectMsdsLeakResponseList(MsdsLeakResponse msdsLeakResponse)
    {
        return msdsLeakResponseMapper.selectMsdsLeakResponseList(msdsLeakResponse);
    }

    /**
     * 新增泄漏应急处理
     * 
     * @param msdsLeakResponse 泄漏应急处理
     * @return 结果
     */
    @Override
    public int insertMsdsLeakResponse(MsdsLeakResponse msdsLeakResponse)
    {
        return msdsLeakResponseMapper.insertMsdsLeakResponse(msdsLeakResponse);
    }

    /**
     * 修改泄漏应急处理
     * 
     * @param msdsLeakResponse 泄漏应急处理
     * @return 结果
     */
    @Override
    public int updateMsdsLeakResponse(MsdsLeakResponse msdsLeakResponse)
    {
        return msdsLeakResponseMapper.updateMsdsLeakResponse(msdsLeakResponse);
    }

    /**
     * 批量删除泄漏应急处理
     * 
     * @param ids 需要删除的泄漏应急处理主键集合
     * @return 结果
     */
    @Override
    public int deleteMsdsLeakResponseByIds(Long[] ids)
    {
        return msdsLeakResponseMapper.deleteMsdsLeakResponseByIds(ids);
    }

    /**
     * 删除泄漏应急处理
     * 
     * @param id 泄漏应急处理主键
     * @return 结果
     */
    @Override
    public int deleteMsdsLeakResponseById(Long id)
    {
        return msdsLeakResponseMapper.deleteMsdsLeakResponseById(id);
    }
} 