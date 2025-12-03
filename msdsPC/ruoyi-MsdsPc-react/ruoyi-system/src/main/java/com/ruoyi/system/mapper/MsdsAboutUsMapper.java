package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.MsdsAboutUs;

/**
 * 关于我们Mapper接口
 * 
 * @author ruoyi
 * @date 2025-01-27
 */
public interface MsdsAboutUsMapper 
{
    /**
     * 查询关于我们
     * 
     * @param id 关于我们主键
     * @return 关于我们
     */
    public MsdsAboutUs selectMsdsAboutUsById(Long id);

    /**
     * 查询关于我们列表
     * 
     * @param msdsAboutUs 关于我们
     * @return 关于我们集合
     */
    public List<MsdsAboutUs> selectMsdsAboutUsList(MsdsAboutUs msdsAboutUs);

    /**
     * 新增关于我们
     * 
     * @param msdsAboutUs 关于我们
     * @return 结果
     */
    public int insertMsdsAboutUs(MsdsAboutUs msdsAboutUs);

    /**
     * 修改关于我们
     * 
     * @param msdsAboutUs 关于我们
     * @return 结果
     */
    public int updateMsdsAboutUs(MsdsAboutUs msdsAboutUs);

    /**
     * 删除关于我们
     * 
     * @param id 关于我们主键
     * @return 结果
     */
    public int deleteMsdsAboutUsById(Long id);

    /**
     * 批量删除关于我们
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteMsdsAboutUsByIds(Long[] ids);
}
