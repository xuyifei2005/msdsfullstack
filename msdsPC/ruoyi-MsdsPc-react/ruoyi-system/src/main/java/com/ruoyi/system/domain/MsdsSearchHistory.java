package com.ruoyi.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * MSDS搜索历史对象 msds_search_history
 * 
 * @author ruoyi
 * @date 2025-01-XX
 */
public class MsdsSearchHistory extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 搜索记录ID */
    private Long searchId;

    /** 用户ID */
    @Excel(name = "用户ID")
    private Long userId;

    /** 用户名称 */
    @Excel(name = "用户名称")
    private String userName;

    /** 搜索关键词 */
    @Excel(name = "搜索关键词")
    private String searchKeyword;

    /** 搜索类型: general(普通), semantic(语义), cas(CAS号), formula(分子式) */
    @Excel(name = "搜索类型")
    private String searchType;

    /** 筛选参数(JSON格式) */
    private String filterParams;

    /** 搜索结果数量 */
    @Excel(name = "搜索结果数量")
    private Integer resultCount;

    /** 搜索时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "搜索时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date searchTime;

    /** IP地址 */
    @Excel(name = "IP地址")
    private String ipAddress;

    /** 用户代理 */
    private String userAgent;

    public void setSearchId(Long searchId) 
    {
        this.searchId = searchId;
    }

    public Long getSearchId() 
    {
        return searchId;
    }

    public void setUserId(Long userId) 
    {
        this.userId = userId;
    }

    public Long getUserId() 
    {
        return userId;
    }

    public void setUserName(String userName) 
    {
        this.userName = userName;
    }

    public String getUserName() 
    {
        return userName;
    }

    public void setSearchKeyword(String searchKeyword) 
    {
        this.searchKeyword = searchKeyword;
    }

    public String getSearchKeyword() 
    {
        return searchKeyword;
    }

    public void setSearchType(String searchType) 
    {
        this.searchType = searchType;
    }

    public String getSearchType() 
    {
        return searchType;
    }

    public void setFilterParams(String filterParams) 
    {
        this.filterParams = filterParams;
    }

    public String getFilterParams() 
    {
        return filterParams;
    }

    public void setResultCount(Integer resultCount) 
    {
        this.resultCount = resultCount;
    }

    public Integer getResultCount() 
    {
        return resultCount;
    }

    public void setSearchTime(Date searchTime) 
    {
        this.searchTime = searchTime;
    }

    public Date getSearchTime() 
    {
        return searchTime;
    }

    public void setIpAddress(String ipAddress) 
    {
        this.ipAddress = ipAddress;
    }

    public String getIpAddress() 
    {
        return ipAddress;
    }

    public void setUserAgent(String userAgent) 
    {
        this.userAgent = userAgent;
    }

    public String getUserAgent() 
    {
        return userAgent;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("searchId", getSearchId())
            .append("userId", getUserId())
            .append("userName", getUserName())
            .append("searchKeyword", getSearchKeyword())
            .append("searchType", getSearchType())
            .append("filterParams", getFilterParams())
            .append("resultCount", getResultCount())
            .append("searchTime", getSearchTime())
            .append("ipAddress", getIpAddress())
            .append("userAgent", getUserAgent())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}

