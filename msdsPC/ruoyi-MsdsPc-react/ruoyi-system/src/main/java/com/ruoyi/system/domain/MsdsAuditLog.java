package com.ruoyi.system.domain;

import java.io.Serializable;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.annotation.Excel.ColumnType;

/**
 * MSDS操作审计日志表 msds_audit_log
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public class MsdsAuditLog implements Serializable
{
    private static final long serialVersionUID = 1L;

    /** 日志ID */
    @Excel(name = "日志ID", cellType = ColumnType.NUMERIC)
    private Long logId;

    /** MSDS主信息ID */
    @Excel(name = "MSDS主信息ID")
    private Long msdsId;

    /** 操作类型 */
    @Excel(name = "操作类型", readConverterExp = "CREATE=新增,UPDATE=修改,DELETE=删除,IMPORT=导入,EXPORT=导出,VIEW=查看")
    private String operationType;

    /** 操作描述 */
    @Excel(name = "操作描述")
    private String operationDesc;

    /** 操作人员 */
    @Excel(name = "操作人员")
    private String operator;

    /** 操作人员ID */
    private Long operatorId;

    /** 操作时间 */
    @Excel(name = "操作时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date operationTime;

    /** 操作IP地址 */
    @Excel(name = "操作IP地址")
    private String ipAddress;

    /** 用户代理 */
    private String userAgent;

    /** 操作前数据 */
    private String beforeData;

    /** 操作后数据 */
    private String afterData;

    /** 操作结果 */
    @Excel(name = "操作结果", readConverterExp = "SUCCESS=成功,FAILED=失败")
    private String operationResult;

    /** 错误信息 */
    private String errorMessage;

    /** 备注 */
    private String remark;

    public Long getLogId()
    {
        return logId;
    }

    public void setLogId(Long logId)
    {
        this.logId = logId;
    }

    public Long getMsdsId()
    {
        return msdsId;
    }

    public void setMsdsId(Long msdsId)
    {
        this.msdsId = msdsId;
    }

    public String getOperationType()
    {
        return operationType;
    }

    public void setOperationType(String operationType)
    {
        this.operationType = operationType;
    }

    public String getOperationDesc()
    {
        return operationDesc;
    }

    public void setOperationDesc(String operationDesc)
    {
        this.operationDesc = operationDesc;
    }

    public String getOperator()
    {
        return operator;
    }

    public void setOperator(String operator)
    {
        this.operator = operator;
    }

    public Long getOperatorId()
    {
        return operatorId;
    }

    public void setOperatorId(Long operatorId)
    {
        this.operatorId = operatorId;
    }

    public Date getOperationTime()
    {
        return operationTime;
    }

    public void setOperationTime(Date operationTime)
    {
        this.operationTime = operationTime;
    }

    public String getIpAddress()
    {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress)
    {
        this.ipAddress = ipAddress;
    }

    public String getUserAgent()
    {
        return userAgent;
    }

    public void setUserAgent(String userAgent)
    {
        this.userAgent = userAgent;
    }

    public String getBeforeData()
    {
        return beforeData;
    }

    public void setBeforeData(String beforeData)
    {
        this.beforeData = beforeData;
    }

    public String getAfterData()
    {
        return afterData;
    }

    public void setAfterData(String afterData)
    {
        this.afterData = afterData;
    }

    public String getOperationResult()
    {
        return operationResult;
    }

    public void setOperationResult(String operationResult)
    {
        this.operationResult = operationResult;
    }

    public String getErrorMessage()
    {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage)
    {
        this.errorMessage = errorMessage;
    }

    public String getRemark()
    {
        return remark;
    }

    public void setRemark(String remark)
    {
        this.remark = remark;
    }

    @Override
    public String toString() {
        return "MsdsAuditLog{" +
                "logId=" + logId +
                ", msdsId=" + msdsId +
                ", operationType='" + operationType + '\'' +
                ", operationDesc='" + operationDesc + '\'' +
                ", operator='" + operator + '\'' +
                ", operatorId=" + operatorId +
                ", operationTime=" + operationTime +
                ", ipAddress='" + ipAddress + '\'' +
                ", userAgent='" + userAgent + '\'' +
                ", operationResult='" + operationResult + '\'' +
                ", errorMessage='" + errorMessage + '\'' +
                ", remark='" + remark + '\'' +
                '}';
    }
}