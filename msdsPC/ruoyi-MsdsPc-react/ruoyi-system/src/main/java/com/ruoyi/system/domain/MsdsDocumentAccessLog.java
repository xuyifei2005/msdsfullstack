package com.ruoyi.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * MSDS文档访问日志对象 msds_document_access_log
 * 
 * @author ruoyi
 * @date 2025-01-XX
 */
public class MsdsDocumentAccessLog extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 日志ID */
    private Long logId;

    /** MSDS文档ID */
    @Excel(name = "MSDS文档ID")
    private Long msdsId;

    /** 用户ID */
    @Excel(name = "用户ID")
    private Long userId;

    /** 用户名称 */
    @Excel(name = "用户名称")
    private String userName;

    /** 访问类型: view(查看), download(下载), preview(预览), print(打印) */
    @Excel(name = "访问类型")
    private String accessType;

    /** 访问时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "访问时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date accessTime;

    /** IP地址 */
    @Excel(name = "IP地址")
    private String ipAddress;

    /** 用户代理 */
    private String userAgent;

    /** 设备类型: pc, mobile, tablet */
    @Excel(name = "设备类型")
    private String deviceType;

    /** 浏览器 */
    @Excel(name = "浏览器")
    private String browser;

    /** 访问时长(秒) */
    @Excel(name = "访问时长")
    private Integer duration;

    public void setLogId(Long logId) 
    {
        this.logId = logId;
    }

    public Long getLogId() 
    {
        return logId;
    }

    public void setMsdsId(Long msdsId) 
    {
        this.msdsId = msdsId;
    }

    public Long getMsdsId() 
    {
        return msdsId;
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

    public void setAccessType(String accessType) 
    {
        this.accessType = accessType;
    }

    public String getAccessType() 
    {
        return accessType;
    }

    public void setAccessTime(Date accessTime) 
    {
        this.accessTime = accessTime;
    }

    public Date getAccessTime() 
    {
        return accessTime;
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

    public void setDeviceType(String deviceType) 
    {
        this.deviceType = deviceType;
    }

    public String getDeviceType() 
    {
        return deviceType;
    }

    public void setBrowser(String browser) 
    {
        this.browser = browser;
    }

    public String getBrowser() 
    {
        return browser;
    }

    public void setDuration(Integer duration) 
    {
        this.duration = duration;
    }

    public Integer getDuration() 
    {
        return duration;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("logId", getLogId())
            .append("msdsId", getMsdsId())
            .append("userId", getUserId())
            .append("userName", getUserName())
            .append("accessType", getAccessType())
            .append("accessTime", getAccessTime())
            .append("ipAddress", getIpAddress())
            .append("userAgent", getUserAgent())
            .append("deviceType", getDeviceType())
            .append("browser", getBrowser())
            .append("duration", getDuration())
            .append("createTime", getCreateTime())
            .toString();
    }
}

