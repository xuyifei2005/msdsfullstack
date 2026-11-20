package com.ruoyi.system.domain;

/**
 * MSDS 监管分类（易制毒 / 易制爆 / 剧毒）字典与统计对象
 *
 * <p>数据来自真实法规名录：msds_regulatory_category / msds_regulatory_catalog /
 * msds_chemical_category_tag，计数为按当前查询条件实时聚合的真实记录数。</p>
 *
 * @author ruoyi
 * @date 2026-11-20
 */
public class MsdsRegulatoryCategory
{
    /** 分类代码：ALL / PRECURSOR / EXPLOSIVE / TOXIC / UNCLASSIFIED */
    private String categoryCode;

    /** 分类全称 */
    private String categoryName;

    /** 标签短名 */
    private String shortName;

    /** 展示顺序 */
    private Integer sortNo;

    /** 标签主题色 */
    private String color;

    /** 分类说明 */
    private String description;

    /** 依据的法规名录 */
    private String sourceDocument;

    /** 名录公开来源 */
    private String sourceUrl;

    /** 当前查询条件下的 MSDS 数量（真实统计） */
    private Long count;

    /** 名录条目数（真实统计） */
    private Long catalogCount;

    /** 名录内细分类，逗号分隔（如 第一类,第二类,第三类） */
    private String subCategories;

    /** 命中的细分类（items 接口） */
    private String subCategory;

    /** 命中的名录品名（items 接口） */
    private String catalogName;

    /** 匹配方式 CAS / NAME（items 接口） */
    private String matchType;

    /** 判定依据（items 接口） */
    private String evidence;

    public String getCategoryCode() { return categoryCode; }
    public void setCategoryCode(String categoryCode) { this.categoryCode = categoryCode; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getShortName() { return shortName; }
    public void setShortName(String shortName) { this.shortName = shortName; }

    public Integer getSortNo() { return sortNo; }
    public void setSortNo(Integer sortNo) { this.sortNo = sortNo; }

    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getSourceDocument() { return sourceDocument; }
    public void setSourceDocument(String sourceDocument) { this.sourceDocument = sourceDocument; }

    public String getSourceUrl() { return sourceUrl; }
    public void setSourceUrl(String sourceUrl) { this.sourceUrl = sourceUrl; }

    public Long getCount() { return count; }
    public void setCount(Long count) { this.count = count; }

    public Long getCatalogCount() { return catalogCount; }
    public void setCatalogCount(Long catalogCount) { this.catalogCount = catalogCount; }

    public String getSubCategories() { return subCategories; }
    public void setSubCategories(String subCategories) { this.subCategories = subCategories; }

    public String getSubCategory() { return subCategory; }
    public void setSubCategory(String subCategory) { this.subCategory = subCategory; }

    public String getCatalogName() { return catalogName; }
    public void setCatalogName(String catalogName) { this.catalogName = catalogName; }

    public String getMatchType() { return matchType; }
    public void setMatchType(String matchType) { this.matchType = matchType; }

    public String getEvidence() { return evidence; }
    public void setEvidence(String evidence) { this.evidence = evidence; }
}
