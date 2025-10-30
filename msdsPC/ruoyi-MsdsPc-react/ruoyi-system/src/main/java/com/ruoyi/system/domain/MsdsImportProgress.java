package com.ruoyi.system.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import java.util.Date;

/**
 * MSDS导入进度对象 msds_import_progress
 * 
 * @author ruoyi
 * @date 2024-01-15
 */
public class MsdsImportProgress extends BaseEntity {
    
    private static final long serialVersionUID = 1L;
    
    /** 进度ID */
    private Long progressId;
    
    /** 任务ID */
    @Excel(name = "任务ID")
    private String taskId;
    
    /** 用户ID */
    @Excel(name = "用户ID")
    private Long userId;
    
    /** 用户名 */
    @Excel(name = "用户名")
    private String userName;
    
    /** 文件名 */
    @Excel(name = "文件名")
    private String fileName;
    
    /** 文件大小（字节） */
    @Excel(name = "文件大小")
    private Long fileSize;
    
    /** 任务状态（0-等待中，1-进行中，2-已完成，3-失败，4-已取消） */
    @Excel(name = "任务状态", readConverterExp = "0=等待中,1=进行中,2=已完成,3=失败,4=已取消")
    private Integer status;
    
    /** 总记录数 */
    @Excel(name = "总记录数")
    private Integer totalRecords;
    
    /** 已处理记录数 */
    @Excel(name = "已处理记录数")
    private Integer processedRecords;
    
    /** 成功记录数 */
    @Excel(name = "成功记录数")
    private Integer successRecords;
    
    /** 失败记录数 */
    @Excel(name = "失败记录数")
    private Integer failedRecords;
    
    /** 进度百分比 */
    @Excel(name = "进度百分比")
    private Integer progressPercent;
    
    /** 开始时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "开始时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date startTime;
    
    /** 结束时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "结束时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date endTime;
    
    /** 错误信息 */
    @Excel(name = "错误信息")
    private String errorMessage;
    
    /** 处理详情（JSON格式） */
    private String processDetails;
    
    /** IP地址 */
    @Excel(name = "IP地址")
    private String ipAddress;
    
    /** 浏览器信息 */
    @Excel(name = "浏览器信息")
    private String userAgent;
    
    public void setProgressId(Long progressId) {
        this.progressId = progressId;
    }
    
    public Long getProgressId() {
        return progressId;
    }
    
    public void setTaskId(String taskId) {
        this.taskId = taskId;
    }
    
    public String getTaskId() {
        return taskId;
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
    
    public void setStatus(Integer status) {
        this.status = status;
    }
    
    public Integer getStatus() {
        return status;
    }
    
    public void setTotalRecords(Integer totalRecords) {
        this.totalRecords = totalRecords;
    }
    
    public Integer getTotalRecords() {
        return totalRecords;
    }
    
    public void setProcessedRecords(Integer processedRecords) {
        this.processedRecords = processedRecords;
    }
    
    public Integer getProcessedRecords() {
        return processedRecords;
    }
    
    public void setSuccessRecords(Integer successRecords) {
        this.successRecords = successRecords;
    }
    
    public Integer getSuccessRecords() {
        return successRecords;
    }
    
    public void setFailedRecords(Integer failedRecords) {
        this.failedRecords = failedRecords;
    }
    
    public Integer getFailedRecords() {
        return failedRecords;
    }
    
    public void setProgressPercent(Integer progressPercent) {
        this.progressPercent = progressPercent;
    }
    
    public Integer getProgressPercent() {
        return progressPercent;
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
    
    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }
    
    public String getErrorMessage() {
        return errorMessage;
    }
    
    public void setProcessDetails(String processDetails) {
        this.processDetails = processDetails;
    }
    
    public String getProcessDetails() {
        return processDetails;
    }
    
    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }
    
    public String getIpAddress() {
        return ipAddress;
    }
    
    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }
    
    public String getUserAgent() {
        return userAgent;
    }
    
    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("progressId", getProgressId())
                .append("taskId", getTaskId())
                .append("userId", getUserId())
                .append("userName", getUserName())
                .append("fileName", getFileName())
                .append("fileSize", getFileSize())
                .append("status", getStatus())
                .append("totalRecords", getTotalRecords())
                .append("processedRecords", getProcessedRecords())
                .append("successRecords", getSuccessRecords())
                .append("failedRecords", getFailedRecords())
                .append("progressPercent", getProgressPercent())
                .append("startTime", getStartTime())
                .append("endTime", getEndTime())
                .append("errorMessage", getErrorMessage())
                .append("processDetails", getProcessDetails())
                .append("ipAddress", getIpAddress())
                .append("userAgent", getUserAgent())
                .append("createTime", getCreateTime())
                .append("updateTime", getUpdateTime())
                .toString();
    }
    
    /**
     * 任务状态枚举
     */
    public enum Status {
        WAITING(0, "等待中"),
        PROCESSING(1, "进行中"),
        COMPLETED(2, "已完成"),
        FAILED(3, "失败"),
        CANCELLED(4, "已取消");
        
        private final Integer code;
        private final String description;
        
        Status(Integer code, String description) {
            this.code = code;
            this.description = description;
        }
        
        public Integer getCode() {
            return code;
        }
        
        public String getDescription() {
            return description;
        }
        
        public static Status fromCode(Integer code) {
            for (Status status : values()) {
                if (status.getCode().equals(code)) {
                    return status;
                }
            }
            return WAITING;
        }
    }
}