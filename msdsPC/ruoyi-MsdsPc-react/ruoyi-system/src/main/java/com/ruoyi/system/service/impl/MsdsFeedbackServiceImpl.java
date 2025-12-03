package com.ruoyi.system.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.MsdsFeedbackMapper;
import com.ruoyi.system.domain.MsdsFeedback;
import com.ruoyi.system.service.IMsdsFeedbackService;

/**
 * 意见反馈Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-01-27
 */
@Service
public class MsdsFeedbackServiceImpl implements IMsdsFeedbackService 
{
    @Autowired
    private MsdsFeedbackMapper msdsFeedbackMapper;

    /**
     * 查询意见反馈
     * 
     * @param id 意见反馈主键
     * @return 意见反馈
     */
    @Override
    public MsdsFeedback selectMsdsFeedbackById(Long id)
    {
        return msdsFeedbackMapper.selectMsdsFeedbackById(id);
    }

    /**
     * 查询意见反馈列表
     * 
     * @param msdsFeedback 意见反馈
     * @return 意见反馈
     */
    @Override
    public List<MsdsFeedback> selectMsdsFeedbackList(MsdsFeedback msdsFeedback)
    {
        return msdsFeedbackMapper.selectMsdsFeedbackList(msdsFeedback);
    }

    /**
     * 新增意见反馈
     * 
     * @param msdsFeedback 意见反馈
     * @return 结果
     */
    @Override
    public int insertMsdsFeedback(MsdsFeedback msdsFeedback)
    {
        msdsFeedback.setCreateTime(DateUtils.getNowDate());
        return msdsFeedbackMapper.insertMsdsFeedback(msdsFeedback);
    }

    /**
     * 修改意见反馈
     * 
     * @param msdsFeedback 意见反馈
     * @return 结果
     */
    @Override
    public int updateMsdsFeedback(MsdsFeedback msdsFeedback)
    {
        msdsFeedback.setUpdateTime(DateUtils.getNowDate());
        return msdsFeedbackMapper.updateMsdsFeedback(msdsFeedback);
    }

    /**
     * 批量删除意见反馈
     * 
     * @param ids 需要删除的意见反馈主键
     * @return 结果
     */
    @Override
    public int deleteMsdsFeedbackByIds(Long[] ids)
    {
        return msdsFeedbackMapper.deleteMsdsFeedbackByIds(ids);
    }

    /**
     * 删除意见反馈信息
     * 
     * @param id 意见反馈主键
     * @return 结果
     */
    @Override
    public int deleteMsdsFeedbackById(Long id)
    {
        return msdsFeedbackMapper.deleteMsdsFeedbackById(id);
    }
}
