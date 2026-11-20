package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.MsdsMain;
import com.ruoyi.system.domain.MsdsRegulatoryCategory;

/**
 * MSDS 监管分类 Service 接口
 *
 * @author ruoyi
 * @date 2026-11-20
 */
public interface IMsdsRegulatoryCategoryService
{
    /**
     * 查询分类标签（含「全部」「未分类」）及真实计数
     * 计数基于当前搜索条件，不受当前选中的分类影响，保证切换标签时数量稳定。
     */
    public List<MsdsRegulatoryCategory> selectCategoryStats(MsdsMain query);

    /** 查询某一篇 MSDS 的监管分类与判定依据 */
    public List<MsdsRegulatoryCategory> selectMsdsCategoryItems(Long msdsId);
}
