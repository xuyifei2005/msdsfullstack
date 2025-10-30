package com.ruoyi.system.domain.msds.utils;

import com.ruoyi.system.domain.msds.constants.MsdsErrorCode;
import com.ruoyi.system.domain.msds.exception.MsdsBusinessException;
import com.ruoyi.common.utils.StringUtils;

/**
 * MSDS异常工具类
 * 提供便捷的异常抛出方法
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
public class MsdsExceptionUtils {

    /**
     * 私有构造函数，防止实例化
     */
    private MsdsExceptionUtils() {
        throw new UnsupportedOperationException("This is a utility class and cannot be instantiated");
    }

    /**
     * 抛出MSDS业务异常
     * 
     * @param errorCode 错误码
     */
    public static void throwBusinessException(String errorCode) {
        throw new MsdsBusinessException(errorCode);
    }

    /**
     * 抛出MSDS业务异常
     * 
     * @param errorCode 错误码
     * @param args 消息参数
     */
    public static void throwBusinessException(String errorCode, Object... args) {
        throw new MsdsBusinessException(errorCode, args);
    }

    /**
     * 抛出MSDS业务异常
     * 
     * @param errorCode 错误码
     * @param cause 原因
     */
    public static void throwBusinessException(String errorCode, Throwable cause) {
        throw new MsdsBusinessException(errorCode, cause);
    }

    /**
     * 抛出MSDS业务异常
     * 
     * @param errorCode 错误码
     * @param cause 原因
     * @param args 消息参数
     */
    public static void throwBusinessException(String errorCode, Throwable cause, Object... args) {
        throw new MsdsBusinessException(errorCode, cause, args);
    }

    // ========== 常用异常抛出方法 ==========

    /**
     * 抛出记录不存在异常
     * 
     * @param recordType 记录类型
     */
    public static void throwRecordNotFound(String recordType) {
        throwBusinessException(MsdsErrorCode.MSDS01001, recordType);
    }

    /**
     * 抛出记录已存在异常
     * 
     * @param recordType 记录类型
     */
    public static void throwRecordExists(String recordType) {
        throwBusinessException(MsdsErrorCode.MSDS01002, recordType);
    }

    /**
     * 抛出必填字段缺失异常
     * 
     * @param fieldName 字段名
     */
    public static void throwRequiredFieldMissing(String fieldName) {
        throwBusinessException(MsdsErrorCode.MSDS03002, fieldName);
    }

    /**
     * 抛出字段长度超出限制异常
     * 
     * @param fieldName 字段名
     * @param maxLength 最大长度
     */
    public static void throwFieldLengthExceeded(String fieldName, int maxLength) {
        throwBusinessException(MsdsErrorCode.MSDS03003, fieldName, maxLength);
    }

    /**
     * 抛出字段格式不正确异常
     * 
     * @param fieldName 字段名
     */
    public static void throwFieldFormatIncorrect(String fieldName) {
        throwBusinessException(MsdsErrorCode.MSDS03004, fieldName);
    }

    /**
     * 抛出枚举值无效异常
     * 
     * @param fieldName 字段名
     * @param validValues 有效值
     */
    public static void throwInvalidEnumValue(String fieldName, String validValues) {
        throwBusinessException(MsdsErrorCode.MSDS03005, fieldName, validValues);
    }

    /**
     * 抛出访问被拒绝异常
     */
    public static void throwAccessDenied() {
        throwBusinessException(MsdsErrorCode.MSDS04001);
    }

    /**
     * 抛出权限不足异常
     */
    public static void throwInsufficientPermissions() {
        throwBusinessException(MsdsErrorCode.MSDS04002);
    }

    /**
     * 抛出用户未认证异常
     */
    public static void throwUserUnauthorized() {
        throwBusinessException(MsdsErrorCode.MSDS04003);
    }

    /**
     * 抛出文件上传失败异常
     */
    public static void throwFileUploadFailed() {
        throwBusinessException(MsdsErrorCode.MSDS02001);
    }

    /**
     * 抛出不支持的文件格式异常
     * 
     * @param supportedFormats 支持的格式
     */
    public static void throwUnsupportedFileFormat(String supportedFormats) {
        throwBusinessException(MsdsErrorCode.MSDS02002, supportedFormats);
    }

    /**
     * 抛出文件大小超出限制异常
     * 
     * @param maxSizeMB 最大大小（MB）
     */
    public static void throwFileSizeExceeded(String maxSizeMB) {
        throwBusinessException(MsdsErrorCode.MSDS02003, maxSizeMB);
    }

    /**
     * 抛出文件解析失败异常
     * 
     * @param reason 失败原因
     */
    public static void throwFileParsingFailed(String reason) {
        throwBusinessException(MsdsErrorCode.MSDS02005, reason);
    }

    /**
     * 抛出数据库操作失败异常
     */
    public static void throwDatabaseOperationFailed() {
        throwBusinessException(MsdsErrorCode.MSDS06001);
    }

    /**
     * 抛出系统繁忙异常
     */
    public static void throwSystemBusy() {
        throwBusinessException(MsdsErrorCode.MSDS06003);
    }

    /**
     * 抛出导入任务不存在异常
     * 
     * @param taskId 任务ID
     */
    public static void throwImportTaskNotFound(String taskId) {
        throwBusinessException(MsdsErrorCode.MSDS07001, taskId);
    }

    /**
     * 抛出导入任务正在运行异常
     */
    public static void throwImportTaskRunning() {
        throwBusinessException(MsdsErrorCode.MSDS07002);
    }

    /**
     * 抛出用户有正在进行的导入任务异常
     */
    public static void throwUserHasActiveImportTask() {
        throwBusinessException(MsdsErrorCode.MSDS07009);
    }

    /**
     * 抛出模板不存在异常
     */
    public static void throwTemplateNotFound() {
        throwBusinessException(MsdsErrorCode.MSDS08001);
    }

    /**
     * 抛出模板生成失败异常
     * 
     * @param reason 失败原因
     */
    public static void throwTemplateGenerationFailed(String reason) {
        throwBusinessException(MsdsErrorCode.MSDS08002, reason);
    }

    /**
     * 抛出未知错误异常
     */
    public static void throwUnknownError() {
        throwBusinessException(MsdsErrorCode.MSDS99001);
    }

    /**
     * 抛出参数错误异常
     * 
     * @param paramName 参数名
     */
    public static void throwParameterError(String paramName) {
        throwBusinessException(MsdsErrorCode.MSDS99002, paramName);
    }

    /**
     * 抛出操作失败异常
     * 
     * @param operation 操作名称
     */
    public static void throwOperationFailed(String operation) {
        throwBusinessException(MsdsErrorCode.MSDS99003, operation);
    }

    // ========== 条件检查方法 ==========

    /**
     * 检查条件，如果为false则抛出异常
     * 
     * @param condition 条件
     * @param errorCode 错误码
     */
    public static void checkCondition(boolean condition, String errorCode) {
        if (!condition) {
            throwBusinessException(errorCode);
        }
    }

    /**
     * 检查条件，如果为false则抛出异常
     * 
     * @param condition 条件
     * @param errorCode 错误码
     * @param args 消息参数
     */
    public static void checkCondition(boolean condition, String errorCode, Object... args) {
        if (!condition) {
            throwBusinessException(errorCode, args);
        }
    }

    /**
     * 检查对象不为空
     * 
     * @param obj 对象
     * @param errorCode 错误码
     */
    public static void checkNotNull(Object obj, String errorCode) {
        checkCondition(obj != null, errorCode);
    }

    /**
     * 检查对象不为空
     * 
     * @param obj 对象
     * @param errorCode 错误码
     * @param args 消息参数
     */
    public static void checkNotNull(Object obj, String errorCode, Object... args) {
        checkCondition(obj != null, errorCode, args);
    }

    /**
     * 检查字符串不为空
     * 
     * @param str 字符串
     * @param errorCode 错误码
     */
    public static void checkNotEmpty(String str, String errorCode) {
        checkCondition(StringUtils.isNotEmpty(str), errorCode);
    }

    /**
     * 检查字符串不为空
     * 
     * @param str 字符串
     * @param errorCode 错误码
     * @param args 消息参数
     */
    public static void checkNotEmpty(String str, String errorCode, Object... args) {
        checkCondition(StringUtils.isNotEmpty(str), errorCode, args);
    }
}