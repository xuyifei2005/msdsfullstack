package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.MsdsFeedback;

/**
 * 意见反馈Service接口
 * 
 * @author ruoyi
 * @date 2025-01-27
 */
public interface IMsdsFeedbackService 
{
    /**
     * 查询意见反馈
     * 
     * @param id 意见反馈主键
     * @return 意见反馈
     */
    public MsdsFeedback selectMsdsFeedbackById(Long id);

    /**
     * 查询意见反馈列表
     * 
     * @param msdsFeedback 意见反馈
     * @return 意见反馈集合
     */
    public List<MsdsFeedback> selectMsdsFeedbackList(MsdsFeedback msdsFeedback);

    /**
     * 新增意见反馈
     * 
     * @param msdsFeedback 意见反馈
     * @return 结果
     */
    public int insertMsdsFeedback(MsdsFeedback msdsFeedback);

    /**
     * 修改意见反馈
     * 
     * @param msdsFeedback 意见反馈
     * @return 结果
     */
    public int updateMsdsFeedback(MsdsFeedback msdsFeedback);

    /**
     * 批量删除意见反馈
     * 
     * @param ids 需要删除的意见反馈主键集合
     * @return 结果
     */
    public int deleteMsdsFeedbackByIds(Long[] ids);

    /**
     * 删除意见反馈信息
     * 
     * @param id 意见反馈主键
     * @return 结果
     */
    public int deleteMsdsFeedbackById(Long id);
}
