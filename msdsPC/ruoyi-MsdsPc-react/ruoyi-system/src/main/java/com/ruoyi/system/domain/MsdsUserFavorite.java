package com.ruoyi.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * MSDS用户收藏对象 msds_user_favorite
 * 
 * @author ruoyi
 * @date 2025-01-XX
 */
public class MsdsUserFavorite extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 收藏ID */
    private Long favoriteId;

    /** 用户ID */
    @Excel(name = "用户ID")
    private Long userId;

    /** 用户名称 */
    @Excel(name = "用户名称")
    private String userName;

    /** MSDS文档ID */
    @Excel(name = "MSDS文档ID")
    private Long msdsId;

    /** MSDS文档名称 */
    @Excel(name = "MSDS文档名称")
    private String msdsName;

    /** CAS号 */
    @Excel(name = "CAS号")
    private String casNumber;

    /** 收藏夹名称 */
    @Excel(name = "收藏夹名称")
    private String folderName;

    /** 标签(逗号分隔) */
    @Excel(name = "标签")
    private String tags;

    /** 备注说明 */
    @Excel(name = "备注说明")
    private String note;

    public void setFavoriteId(Long favoriteId) 
    {
        this.favoriteId = favoriteId;
    }

    public Long getFavoriteId() 
    {
        return favoriteId;
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

    public void setMsdsId(Long msdsId) 
    {
        this.msdsId = msdsId;
    }

    public Long getMsdsId() 
    {
        return msdsId;
    }

    public void setMsdsName(String msdsName) 
    {
        this.msdsName = msdsName;
    }

    public String getMsdsName() 
    {
        return msdsName;
    }

    public void setCasNumber(String casNumber) 
    {
        this.casNumber = casNumber;
    }

    public String getCasNumber() 
    {
        return casNumber;
    }

    public void setFolderName(String folderName) 
    {
        this.folderName = folderName;
    }

    public String getFolderName() 
    {
        return folderName;
    }

    public void setTags(String tags) 
    {
        this.tags = tags;
    }

    public String getTags() 
    {
        return tags;
    }

    public void setNote(String note) 
    {
        this.note = note;
    }

    public String getNote() 
    {
        return note;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("favoriteId", getFavoriteId())
            .append("userId", getUserId())
            .append("userName", getUserName())
            .append("msdsId", getMsdsId())
            .append("msdsName", getMsdsName())
            .append("casNumber", getCasNumber())
            .append("folderName", getFolderName())
            .append("tags", getTags())
            .append("note", getNote())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}

