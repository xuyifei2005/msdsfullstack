package com.ruoyi.system.domain;

import java.math.BigDecimal;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * MSDS文档统计对象 msds_document_statistics
 * 
 * @author ruoyi
 * @date 2025-01-XX
 */
public class MsdsDocumentStatistics extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 统计ID */
    private Long statId;

    /** MSDS文档ID */
    @Excel(name = "MSDS文档ID")
    private Long msdsId;

    /** 查看次数 */
    @Excel(name = "查看次数")
    private Integer viewCount;

    /** 下载次数 */
    @Excel(name = "下载次数")
    private Integer downloadCount;

    /** 收藏次数 */
    @Excel(name = "收藏次数")
    private Integer favoriteCount;

    /** 分享次数 */
    @Excel(name = "分享次数")
    private Integer shareCount;

    /** 最后查看时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "最后查看时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date lastViewTime;

    /** 最后下载时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "最后下载时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date lastDownloadTime;

    /** 最后收藏时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "最后收藏时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date lastFavoriteTime;

    /** 总评分 */
    @Excel(name = "总评分")
    private BigDecimal totalScore;

    /** 评分次数 */
    @Excel(name = "评分次数")
    private Integer scoreCount;

    /** 平均评分 */
    @Excel(name = "平均评分")
    private BigDecimal avgScore;

    public void setStatId(Long statId) 
    {
        this.statId = statId;
    }

    public Long getStatId() 
    {
        return statId;
    }

    public void setMsdsId(Long msdsId) 
    {
        this.msdsId = msdsId;
    }

    public Long getMsdsId() 
    {
        return msdsId;
    }

    public void setViewCount(Integer viewCount) 
    {
        this.viewCount = viewCount;
    }

    public Integer getViewCount() 
    {
        return viewCount;
    }

    public void setDownloadCount(Integer downloadCount) 
    {
        this.downloadCount = downloadCount;
    }

    public Integer getDownloadCount() 
    {
        return downloadCount;
    }

    public void setFavoriteCount(Integer favoriteCount) 
    {
        this.favoriteCount = favoriteCount;
    }

    public Integer getFavoriteCount() 
    {
        return favoriteCount;
    }

    public void setShareCount(Integer shareCount) 
    {
        this.shareCount = shareCount;
    }

    public Integer getShareCount() 
    {
        return shareCount;
    }

    public void setLastViewTime(Date lastViewTime) 
    {
        this.lastViewTime = lastViewTime;
    }

    public Date getLastViewTime() 
    {
        return lastViewTime;
    }

    public void setLastDownloadTime(Date lastDownloadTime) 
    {
        this.lastDownloadTime = lastDownloadTime;
    }

    public Date getLastDownloadTime() 
    {
        return lastDownloadTime;
    }

    public void setLastFavoriteTime(Date lastFavoriteTime) 
    {
        this.lastFavoriteTime = lastFavoriteTime;
    }

    public Date getLastFavoriteTime() 
    {
        return lastFavoriteTime;
    }

    public void setTotalScore(BigDecimal totalScore) 
    {
        this.totalScore = totalScore;
    }

    public BigDecimal getTotalScore() 
    {
        return totalScore;
    }

    public void setScoreCount(Integer scoreCount) 
    {
        this.scoreCount = scoreCount;
    }

    public Integer getScoreCount() 
    {
        return scoreCount;
    }

    public void setAvgScore(BigDecimal avgScore) 
    {
        this.avgScore = avgScore;
    }

    public BigDecimal getAvgScore() 
    {
        return avgScore;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("statId", getStatId())
            .append("msdsId", getMsdsId())
            .append("viewCount", getViewCount())
            .append("downloadCount", getDownloadCount())
            .append("favoriteCount", getFavoriteCount())
            .append("shareCount", getShareCount())
            .append("lastViewTime", getLastViewTime())
            .append("lastDownloadTime", getLastDownloadTime())
            .append("lastFavoriteTime", getLastFavoriteTime())
            .append("totalScore", getTotalScore())
            .append("scoreCount", getScoreCount())
            .append("avgScore", getAvgScore())
            .append("createTime", getCreateTime())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}

