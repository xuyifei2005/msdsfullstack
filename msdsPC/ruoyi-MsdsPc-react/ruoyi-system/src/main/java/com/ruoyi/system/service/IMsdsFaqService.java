package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.MsdsFaq;

/**
 * 常见问题Service接口
 * 
 * @author ruoyi
 * @date 2025-01-27
 */
public interface IMsdsFaqService 
{
    /**
     * 查询常见问题
     * 
     * @param id 常见问题主键
     * @return 常见问题
     */
    public MsdsFaq selectMsdsFaqById(Long id);

    /**
     * 查询常见问题列表
     * 
     * @param msdsFaq 常见问题
     * @return 常见问题集合
     */
    public List<MsdsFaq> selectMsdsFaqList(MsdsFaq msdsFaq);

    /**
     * 新增常见问题
     * 
     * @param msdsFaq 常见问题
     * @return 结果
     */
    public int insertMsdsFaq(MsdsFaq msdsFaq);

    /**
     * 修改常见问题
     * 
     * @param msdsFaq 常见问题
     * @return 结果
     */
    public int updateMsdsFaq(MsdsFaq msdsFaq);

    /**
     * 批量删除常见问题
     * 
     * @param ids 需要删除的常见问题主键集合
     * @return 结果
     */
    public int deleteMsdsFaqByIds(Long[] ids);

    /**
     * 删除常见问题信息
     * 
     * @param id 常见问题主键
     * @return 结果
     */
    public int deleteMsdsFaqById(Long id);
}
