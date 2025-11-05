package com.ruoyi.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * MSDS搜索建议对象 msds_search_suggestion
 * 
 * @author ruoyi
 * @date 2025-01-XX
 */
public class MsdsSearchSuggestion extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 建议ID */
    private Long suggestionId;

    /** 搜索关键词 */
    @Excel(name = "搜索关键词")
    private String keyword;

    /** 关键词类型: hot(热门), ai(AI推荐), related(相关词), cas(CAS号), formula(分子式) */
    @Excel(name = "关键词类型")
    private String keywordType;

    /** 关联CAS号 */
    @Excel(name = "关联CAS号")
    private String relatedCas;

    /** 关联MSDS文档ID */
    private Long relatedMsdsId;

    /** 搜索次数 */
    @Excel(name = "搜索次数")
    private Integer searchCount;

    /** 点击次数 */
    @Excel(name = "点击次数")
    private Integer clickCount;

    /** 排序顺序 */
    @Excel(name = "排序顺序")
    private Integer sortOrder;

    /** 是否启用: 0-禁用, 1-启用 */
    @Excel(name = "是否启用")
    private Integer isActive;

    /** 生效开始时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "生效开始时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date startTime;

    /** 生效结束时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "生效结束时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date endTime;

    public void setSuggestionId(Long suggestionId) 
    {
        this.suggestionId = suggestionId;
    }

    public Long getSuggestionId() 
    {
        return suggestionId;
    }

    public void setKeyword(String keyword) 
    {
        this.keyword = keyword;
    }

    public String getKeyword() 
    {
        return keyword;
    }

    public void setKeywordType(String keywordType) 
    {
        this.keywordType = keywordType;
    }

    public String getKeywordType() 
    {
        return keywordType;
    }

    public void setRelatedCas(String relatedCas) 
    {
        this.relatedCas = relatedCas;
    }

    public String getRelatedCas() 
    {
        return relatedCas;
    }

    public void setRelatedMsdsId(Long relatedMsdsId) 
    {
        this.relatedMsdsId = relatedMsdsId;
    }

    public Long getRelatedMsdsId() 
    {
        return relatedMsdsId;
    }

    public void setSearchCount(Integer searchCount) 
    {
        this.searchCount = searchCount;
    }

    public Integer getSearchCount() 
    {
        return searchCount;
    }

    public void setClickCount(Integer clickCount) 
    {
        this.clickCount = clickCount;
    }

    public Integer getClickCount() 
    {
        return clickCount;
    }

    public void setSortOrder(Integer sortOrder) 
    {
        this.sortOrder = sortOrder;
    }

    public Integer getSortOrder() 
    {
        return sortOrder;
    }

    public void setIsActive(Integer isActive) 
    {
        this.isActive = isActive;
    }

    public Integer getIsActive() 
    {
        return isActive;
    }

    public void setStartTime(Date startTime) 
    {
        this.startTime = startTime;
    }

    public Date getStartTime() 
    {
        return startTime;
    }

    public void setEndTime(Date endTime) 
    {
        this.endTime = endTime;
    }

    public Date getEndTime() 
    {
        return endTime;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("suggestionId", getSuggestionId())
            .append("keyword", getKeyword())
            .append("keywordType", getKeywordType())
            .append("relatedCas", getRelatedCas())
            .append("relatedMsdsId", getRelatedMsdsId())
            .append("searchCount", getSearchCount())
            .append("clickCount", getClickCount())
            .append("sortOrder", getSortOrder())
            .append("isActive", getIsActive())
            .append("startTime", getStartTime())
            .append("endTime", getEndTime())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}

