package com.ruoyi.system.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.MsdsAboutUsMapper;
import com.ruoyi.system.domain.MsdsAboutUs;
import com.ruoyi.system.service.IMsdsAboutUsService;

/**
 * 关于我们Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-01-27
 */
@Service
public class MsdsAboutUsServiceImpl implements IMsdsAboutUsService 
{
    @Autowired
    private MsdsAboutUsMapper msdsAboutUsMapper;

    /**
     * 查询关于我们
     * 
     * @param id 关于我们主键
     * @return 关于我们
     */
    @Override
    public MsdsAboutUs selectMsdsAboutUsById(Long id)
    {
        return msdsAboutUsMapper.selectMsdsAboutUsById(id);
    }

    /**
     * 查询关于我们列表
     * 
     * @param msdsAboutUs 关于我们
     * @return 关于我们
     */
    @Override
    public List<MsdsAboutUs> selectMsdsAboutUsList(MsdsAboutUs msdsAboutUs)
    {
        return msdsAboutUsMapper.selectMsdsAboutUsList(msdsAboutUs);
    }

    /**
     * 新增关于我们
     * 
     * @param msdsAboutUs 关于我们
     * @return 结果
     */
    @Override
    public int insertMsdsAboutUs(MsdsAboutUs msdsAboutUs)
    {
        msdsAboutUs.setCreateTime(DateUtils.getNowDate());
        return msdsAboutUsMapper.insertMsdsAboutUs(msdsAboutUs);
    }

    /**
     * 修改关于我们
     * 
     * @param msdsAboutUs 关于我们
     * @return 结果
     */
    @Override
    public int updateMsdsAboutUs(MsdsAboutUs msdsAboutUs)
    {
        msdsAboutUs.setUpdateTime(DateUtils.getNowDate());
        return msdsAboutUsMapper.updateMsdsAboutUs(msdsAboutUs);
    }

    /**
     * 批量删除关于我们
     * 
     * @param ids 需要删除的关于我们主键
     * @return 结果
     */
    @Override
    public int deleteMsdsAboutUsByIds(Long[] ids)
    {
        return msdsAboutUsMapper.deleteMsdsAboutUsByIds(ids);
    }

    /**
     * 删除关于我们信息
     * 
     * @param id 关于我们主键
     * @return 结果
     */
    @Override
    public int deleteMsdsAboutUsById(Long id)
    {
        return msdsAboutUsMapper.deleteMsdsAboutUsById(id);
    }
}
