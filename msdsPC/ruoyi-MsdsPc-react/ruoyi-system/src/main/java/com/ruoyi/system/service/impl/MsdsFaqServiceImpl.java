package com.ruoyi.system.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.MsdsFaqMapper;
import com.ruoyi.system.domain.MsdsFaq;
import com.ruoyi.system.service.IMsdsFaqService;

/**
 * 常见问题Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-01-27
 */
@Service
public class MsdsFaqServiceImpl implements IMsdsFaqService 
{
    @Autowired
    private MsdsFaqMapper msdsFaqMapper;

    /**
     * 查询常见问题
     * 
     * @param id 常见问题主键
     * @return 常见问题
     */
    @Override
    public MsdsFaq selectMsdsFaqById(Long id)
    {
        return msdsFaqMapper.selectMsdsFaqById(id);
    }

    /**
     * 查询常见问题列表
     * 
     * @param msdsFaq 常见问题
     * @return 常见问题
     */
    @Override
    public List<MsdsFaq> selectMsdsFaqList(MsdsFaq msdsFaq)
    {
        return msdsFaqMapper.selectMsdsFaqList(msdsFaq);
    }

    /**
     * 新增常见问题
     * 
     * @param msdsFaq 常见问题
     * @return 结果
     */
    @Override
    public int insertMsdsFaq(MsdsFaq msdsFaq)
    {
        msdsFaq.setCreateTime(DateUtils.getNowDate());
        return msdsFaqMapper.insertMsdsFaq(msdsFaq);
    }

    /**
     * 修改常见问题
     * 
     * @param msdsFaq 常见问题
     * @return 结果
     */
    @Override
    public int updateMsdsFaq(MsdsFaq msdsFaq)
    {
        msdsFaq.setUpdateTime(DateUtils.getNowDate());
        return msdsFaqMapper.updateMsdsFaq(msdsFaq);
    }

    /**
     * 批量删除常见问题
     * 
     * @param ids 需要删除的常见问题主键
     * @return 结果
     */
    @Override
    public int deleteMsdsFaqByIds(Long[] ids)
    {
        return msdsFaqMapper.deleteMsdsFaqByIds(ids);
    }

    /**
     * 删除常见问题信息
     * 
     * @param id 常见问题主键
     * @return 结果
     */
    @Override
    public int deleteMsdsFaqById(Long id)
    {
        return msdsFaqMapper.deleteMsdsFaqById(id);
    }
}
