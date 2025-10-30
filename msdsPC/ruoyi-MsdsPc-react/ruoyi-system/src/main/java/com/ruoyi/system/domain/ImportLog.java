package com.ruoyi.system.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import java.util.Date;

/**
 * 导入日志对象 import_log
 * 
 * @author ruoyi
 * @date 2024-01-20
 */
public class ImportLog extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** 日志ID */
    private Long logId;

    /** 批次号 */
    @Excel(name = "批次号")
    private String batchNo;

    /** 文件名 */
    @Excel(name = "文件名")
    private String fileName;

    /** 文件大小(字节) */
    @Excel(name = "文件大小")
    private Long fileSize;

    /** 文件类型 */
    @Excel(name = "文件类型")
    private String fileType;

    /** 导入类型(MSDS_MAIN:主表导入, MSDS_COMPONENT:组分导入) */
    @Excel(name = "导入类型", readConverterExp = "MSDS_MAIN=主表导入,MSDS_COMPONENT=组分导入")
    private String importType;

    /** 导入状态(PENDING:待处理, PROCESSING:处理中, SUCCESS:成功, FAILED:失败, PARTIAL:部分成功) */
    @Excel(name = "导入状态", readConverterExp = "PENDING=待处理,PROCESSING=处理中,SUCCESS=成功,FAILED=失败,PARTIAL=部分成功")
    private String status;

    /** 总行数 */
    @Excel(name = "总行数")
    private Integer totalRows;

    /** 成功行数 */
    @Excel(name = "成功行数")
    private Integer successRows;

    /** 失败行数 */
    @Excel(name = "失败行数")
    private Integer failedRows;

    /** 警告行数 */
    @Excel(name = "警告行数")
    private Integer warningRows;

    /** 跳过行数 */
    @Excel(name = "跳过行数")
    private Integer skippedRows;

    /** 处理开始时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "处理开始时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date startTime;

    /** 处理结束时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "处理结束时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date endTime;

    /** 处理耗时(毫秒) */
    @Excel(name = "处理耗时(毫秒)")
    private Long processingTime;

    /** 错误信息 */
    @Excel(name = "错误信息")
    private String errorMessage;

    /** 错误码 */
    @Excel(name = "错误码")
    private String errorCode;

    /** 错误详情(JSON格式) */
    private String errorDetails;

    /** 校验结果(JSON格式) */
    private String validationResult;

    /** 导入配置(JSON格式) */
    private String importConfig;

    /** 操作用户ID */
    @Excel(name = "操作用户ID")
    private Long userId;

    /** 操作用户名 */
    @Excel(name = "操作用户名")
    private String userName;

    /** 客户端IP */
    @Excel(name = "客户端IP")
    private String clientIp;

    /** 用户代理 */
    private String userAgent;

    /** 备注 */
    @Excel(name = "备注")
    private String remarks;

    /** 是否删除(0:否, 1:是) */
    private String delFlag;

    public void setLogId(Long logId) {
        this.logId = logId;
    }

    public Long getLogId() {
        return logId;
    }

    public void setBatchNo(String batchNo) {
        this.batchNo = batchNo;
    }

    public String getBatchNo() {
        return batchNo;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileSize(Long fileSize) {
        this.fileSize = fileSize;
    }

    public Long getFileSize() {
        return fileSize;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public String getFileType() {
        return fileType;
    }

    public void setImportType(String importType) {
        this.importType = importType;
    }

    public String getImportType() {
        return importType;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStatus() {
        return status;
    }

    public void setTotalRows(Integer totalRows) {
        this.totalRows = totalRows;
    }

    public Integer getTotalRows() {
        return totalRows;
    }

    public void setSuccessRows(Integer successRows) {
        this.successRows = successRows;
    }

    public Integer getSuccessRows() {
        return successRows;
    }

    public void setFailedRows(Integer failedRows) {
        this.failedRows = failedRows;
    }

    public Integer getFailedRows() {
        return failedRows;
    }

    public void setWarningRows(Integer warningRows) {
        this.warningRows = warningRows;
    }

    public Integer getWarningRows() {
        return warningRows;
    }

    public void setSkippedRows(Integer skippedRows) {
        this.skippedRows = skippedRows;
    }

    public Integer getSkippedRows() {
        return skippedRows;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setProcessingTime(Long processingTime) {
        this.processingTime = processingTime;
    }

    public Long getProcessingTime() {
        return processingTime;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorCode(String errorCode) {
        this.errorCode = errorCode;
    }

    public String getErrorCode() {
        return errorCode;
    }

    public void setErrorDetails(String errorDetails) {
        this.errorDetails = errorDetails;
    }

    public String getErrorDetails() {
        return errorDetails;
    }

    public void setValidationResult(String validationResult) {
        this.validationResult = validationResult;
    }

    public String getValidationResult() {
        return validationResult;
    }

    public void setImportConfig(String importConfig) {
        this.importConfig = importConfig;
    }

    public String getImportConfig() {
        return importConfig;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserName() {
        return userName;
    }

    public void setClientIp(String clientIp) {
        this.clientIp = clientIp;
    }

    public String getClientIp() {
        return clientIp;
    }

    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }

    public String getUserAgent() {
        return userAgent;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setDelFlag(String delFlag) {
        this.delFlag = delFlag;
    }

    public String getDelFlag() {
        return delFlag;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("logId", getLogId())
            .append("batchNo", getBatchNo())
            .append("fileName", getFileName())
            .append("fileSize", getFileSize())
            .append("fileType", getFileType())
            .append("importType", getImportType())
            .append("status", getStatus())
            .append("totalRows", getTotalRows())
            .append("successRows", getSuccessRows())
            .append("failedRows", getFailedRows())
            .append("warningRows", getWarningRows())
            .append("skippedRows", getSkippedRows())
            .append("startTime", getStartTime())
            .append("endTime", getEndTime())
            .append("processingTime", getProcessingTime())
            .append("errorMessage", getErrorMessage())
            .append("errorCode", getErrorCode())
            .append("errorDetails", getErrorDetails())
            .append("validationResult", getValidationResult())
            .append("importConfig", getImportConfig())
            .append("userId", getUserId())
            .append("userName", getUserName())
            .append("clientIp", getClientIp())
            .append("userAgent", getUserAgent())
            .append("remarks", getRemarks())
            .append("delFlag", getDelFlag())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}