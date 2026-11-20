package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.MsdsMain;
import com.ruoyi.system.domain.MsdsRegulatoryCategory;

/**
 * MSDS 监管分类 Mapper
 *
 * @author ruoyi
 * @date 2026-11-20
 */
public interface MsdsRegulatoryCategoryMapper
{
    /** 按当前查询条件统计各分类下的真实 MSDS 数量 */
    public List<MsdsRegulatoryCategory> selectCategoryStats(MsdsMain query);

    /** 当前查询条件下的 MSDS 总数（「全部」标签计数） */
    public int countMsdsByQuery(MsdsMain query);

    /** 当前查询条件下未命中任何监管分类的 MSDS 数量 */
    public int countUnclassifiedByQuery(MsdsMain query);

    /** 查询某一篇 MSDS 的监管分类及判定依据 */
    public List<MsdsRegulatoryCategory> selectMsdsCategoryItems(Long msdsId);
}
