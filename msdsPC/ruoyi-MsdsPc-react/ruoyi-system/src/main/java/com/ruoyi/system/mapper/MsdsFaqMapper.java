package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.MsdsFaq;

/**
 * 常见问题Mapper接口
 * 
 * @author ruoyi
 * @date 2025-01-27
 */
public interface MsdsFaqMapper 
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
     * 删除常见问题
     * 
     * @param id 常见问题主键
     * @return 结果
     */
    public int deleteMsdsFaqById(Long id);

    /**
     * 批量删除常见问题
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteMsdsFaqByIds(Long[] ids);
}
