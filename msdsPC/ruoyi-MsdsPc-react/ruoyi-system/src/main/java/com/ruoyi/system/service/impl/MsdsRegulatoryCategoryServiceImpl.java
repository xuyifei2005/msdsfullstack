package com.ruoyi.system.service.impl;

import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.domain.MsdsMain;
import com.ruoyi.system.domain.MsdsRegulatoryCategory;
import com.ruoyi.system.mapper.MsdsRegulatoryCategoryMapper;
import com.ruoyi.system.service.IMsdsRegulatoryCategoryService;

/**
 * MSDS 监管分类 Service 实现
 *
 * <p>所有标签数量均来自真实数据库聚合（msds_chemical_category_tag × msds_main），
 * 无数据即返回 0，不使用任何填充值。</p>
 *
 * @author ruoyi
 * @date 2026-11-20
 */
@Service
public class MsdsRegulatoryCategoryServiceImpl implements IMsdsRegulatoryCategoryService
{
    @Autowired
    private MsdsRegulatoryCategoryMapper categoryMapper;

    @Override
    public List<MsdsRegulatoryCategory> selectCategoryStats(MsdsMain query)
    {
        // 计数只受搜索条件影响，去掉「当前选中分类」，保证各标签数量稳定可比较
        MsdsMain baseQuery = new MsdsMain();
        baseQuery.setProductName(query.getProductName());
        baseQuery.setCompanyName(query.getCompanyName());
        baseQuery.setCasNumber(query.getCasNumber());
        baseQuery.setMsdsCode(query.getMsdsCode());
        baseQuery.setStatus(query.getStatus());
        baseQuery.setIsActive(query.getIsActive());

        List<MsdsRegulatoryCategory> categories = new ArrayList<>();

        MsdsRegulatoryCategory all = new MsdsRegulatoryCategory();
        all.setCategoryCode("ALL");
        all.setCategoryName("全部化学品");
        all.setShortName("全部");
        all.setSortNo(0);
        all.setColor("#1677ff");
        all.setDescription("显示全部 MSDS 文档，不做监管分类过滤。");
        all.setCount((long) categoryMapper.countMsdsByQuery(baseQuery));
        categories.add(all);

        List<MsdsRegulatoryCategory> realCategories = categoryMapper.selectCategoryStats(baseQuery);
        if (realCategories != null)
        {
            for (MsdsRegulatoryCategory item : realCategories)
            {
                if (item.getCount() == null)
                {
                    item.setCount(0L);
                }
                if (item.getCatalogCount() == null)
                {
                    item.setCatalogCount(0L);
                }
                categories.add(item);
            }
        }

        MsdsRegulatoryCategory unclassified = new MsdsRegulatoryCategory();
        unclassified.setCategoryCode("UNCLASSIFIED");
        unclassified.setCategoryName("未纳入上述名录");
        unclassified.setShortName("未分类");
        unclassified.setSortNo(99);
        unclassified.setColor("#8c8c8c");
        unclassified.setDescription("CAS 号与品名均未命中三部现行监管名录的 MSDS 文档。");
        unclassified.setCount((long) categoryMapper.countUnclassifiedByQuery(baseQuery));
        categories.add(unclassified);

        return categories;
    }

    @Override
    public List<MsdsRegulatoryCategory> selectMsdsCategoryItems(Long msdsId)
    {
        if (msdsId == null)
        {
            return new ArrayList<>();
        }
        return categoryMapper.selectMsdsCategoryItems(msdsId);
    }
}
