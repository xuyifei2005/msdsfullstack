package com.ruoyi.system.domain.msds.exception;

import com.ruoyi.common.utils.MessageUtils;

/**
 * MSDS业务异常类
 * 用于处理MSDS业务相关的异常情况
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
public class MsdsBusinessException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    /**
     * 错误码
     */
    private String errorCode;

    /**
     * 错误消息参数
     */
    private Object[] args;

    /**
     * 构造函数
     * 
     * @param errorCode 错误码
     */
    public MsdsBusinessException(String errorCode) {
        super(MessageUtils.message(errorCode));
        this.errorCode = errorCode;
    }

    /**
     * 构造函数
     * 
     * @param errorCode 错误码
     * @param args 消息参数
     */
    public MsdsBusinessException(String errorCode, Object... args) {
        super(MessageUtils.message(errorCode, args));
        this.errorCode = errorCode;
        this.args = args;
    }

    /**
     * 构造函数
     * 
     * @param errorCode 错误码
     * @param cause 原因
     */
    public MsdsBusinessException(String errorCode, Throwable cause) {
        super(MessageUtils.message(errorCode), cause);
        this.errorCode = errorCode;
    }

    /**
     * 构造函数
     * 
     * @param errorCode 错误码
     * @param cause 原因
     * @param args 消息参数
     */
    public MsdsBusinessException(String errorCode, Throwable cause, Object... args) {
        super(MessageUtils.message(errorCode, args), cause);
        this.errorCode = errorCode;
        this.args = args;
    }

    /**
     * 获取错误码
     * 
     * @return 错误码
     */
    public String getErrorCode() {
        return errorCode;
    }

    /**
     * 设置错误码
     * 
     * @param errorCode 错误码
     */
    public void setErrorCode(String errorCode) {
        this.errorCode = errorCode;
    }

    /**
     * 获取错误消息参数
     * 
     * @return 错误消息参数
     */
    public Object[] getArgs() {
        return args;
    }

    /**
     * 设置错误消息参数
     * 
     * @param args 错误消息参数
     */
    public void setArgs(Object[] args) {
        this.args = args;
    }

    /**
     * 获取本地化错误消息
     * 
     * @return 本地化错误消息
     */
    public String getLocalizedMessage() {
        if (args != null && args.length > 0) {
            return MessageUtils.message(errorCode, args);
        }
        return MessageUtils.message(errorCode);
    }
}