package com.ruoyi.system.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.util.Date;

/**
 * 系统操作日志对象 system_log
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
public class SystemLog extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 表名 */
    @Excel(name = "表名")
    @NotBlank(message = "表名不能为空")
    @Size(max = 50, message = "表名不能超过50个字符")
    private String tableName;

    /** 记录ID */
    @Excel(name = "记录ID")
    @NotNull(message = "记录ID不能为空")
    private Long recordId;

    /** 操作类型 */
    @Excel(name = "操作类型", readConverterExp = "INSERT=新增,UPDATE=修改,DELETE=删除")
    @NotBlank(message = "操作类型不能为空")
    private String operationType;

    /** 修改前的值 */
    @Excel(name = "修改前的值")
    private String oldValues;

    /** 修改后的值 */
    @Excel(name = "修改后的值")
    private String newValues;

    /** 操作人 */
    @Excel(name = "操作人")
    @Size(max = 100, message = "操作人不能超过100个字符")
    private String operator;

    /** 操作时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "操作时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date operationTime;

    /** IP地址 */
    @Excel(name = "IP地址")
    @Size(max = 50, message = "IP地址不能超过50个字符")
    private String ipAddress;

    /** 用户代理 */
    @Excel(name = "用户代理")
    private String userAgent;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }

    public void setTableName(String tableName) 
    {
        this.tableName = tableName;
    }

    public String getTableName() 
    {
        return tableName;
    }

    public void setRecordId(Long recordId) 
    {
        this.recordId = recordId;
    }

    public Long getRecordId() 
    {
        return recordId;
    }

    public void setOperationType(String operationType) 
    {
        this.operationType = operationType;
    }

    public String getOperationType() 
    {
        return operationType;
    }

    public void setOldValues(String oldValues) 
    {
        this.oldValues = oldValues;
    }

    public String getOldValues() 
    {
        return oldValues;
    }

    public void setNewValues(String newValues) 
    {
        this.newValues = newValues;
    }

    public String getNewValues() 
    {
        return newValues;
    }

    public void setOperator(String operator) 
    {
        this.operator = operator;
    }

    public String getOperator() 
    {
        return operator;
    }

    public void setOperationTime(Date operationTime) 
    {
        this.operationTime = operationTime;
    }

    public Date getOperationTime() 
    {
        return operationTime;
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
            .append("id", getId())
            .append("tableName", getTableName())
            .append("recordId", getRecordId())
            .append("operationType", getOperationType())
            .append("oldValues", getOldValues())
            .append("newValues", getNewValues())
            .append("operator", getOperator())
            .append("operationTime", getOperationTime())
            .append("ipAddress", getIpAddress())
            .append("userAgent", getUserAgent())
            .append("createTime", getCreateTime())
            .toString();
    }
}