package com.ruoyi.common.exception;

import com.ruoyi.common.enums.MsdsErrorCode;
import com.ruoyi.common.exception.base.BaseException;

/**
 * MSDS业务异常类
 * 
 * @author ruoyi
 */
public class MsdsException extends BaseException {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * MSDS错误码
     */
    private MsdsErrorCode errorCode;
    
    /**
     * 构造函数 - 使用错误码枚举
     */
    public MsdsException(MsdsErrorCode errorCode) {
        super("msds", errorCode.getCode(), null, errorCode.getMessage());
        this.errorCode = errorCode;
    }
    
    /**
     * 构造函数 - 使用错误码枚举和参数
     */
    public MsdsException(MsdsErrorCode errorCode, Object... args) {
        super("msds", errorCode.getCode(), args, errorCode.formatMessage(args));
        this.errorCode = errorCode;
    }
    
    /**
     * 构造函数 - 使用错误码枚举和自定义消息
     */
    public MsdsException(MsdsErrorCode errorCode, String customMessage) {
        super("msds", errorCode.getCode(), null, customMessage);
        this.errorCode = errorCode;
    }
    
    /**
     * 构造函数 - 使用错误码枚举、自定义消息和原因
     */
    public MsdsException(MsdsErrorCode errorCode, String customMessage, Throwable cause) {
        super("msds", errorCode.getCode(), null, customMessage);
        this.errorCode = errorCode;
        this.initCause(cause);
    }
    
    /**
     * 构造函数 - 使用错误码枚举和原因
     */
    public MsdsException(MsdsErrorCode errorCode, Throwable cause) {
        super("msds", errorCode.getCode(), null, errorCode.getMessage());
        this.errorCode = errorCode;
        this.initCause(cause);
    }
    
    /**
     * 构造函数 - 兼容原有方式，使用字符串错误码
     */
    public MsdsException(String code, String message) {
        super("msds", code, null, message);
        this.errorCode = MsdsErrorCode.getByCode(code);
    }
    
    /**
     * 构造函数 - 兼容原有方式，使用字符串错误码和参数
     */
    public MsdsException(String code, Object[] args, String message) {
        super("msds", code, args, message);
        this.errorCode = MsdsErrorCode.getByCode(code);
    }
    
    /**
     * 获取MSDS错误码
     */
    public MsdsErrorCode getErrorCode() {
        return errorCode;
    }
    
    /**
     * 获取错误码字符串
     */
    public String getErrorCodeString() {
        return errorCode != null ? errorCode.getCode() : getCode();
    }
    
    /**
     * 静态工厂方法 - 创建MSDS异常
     */
    public static MsdsException of(MsdsErrorCode errorCode) {
        return new MsdsException(errorCode);
    }
    
    /**
     * 静态工厂方法 - 创建带参数的MSDS异常
     */
    public static MsdsException of(MsdsErrorCode errorCode, Object... args) {
        return new MsdsException(errorCode, args);
    }
    
    /**
     * 静态工厂方法 - 创建带自定义消息的MSDS异常
     */
    public static MsdsException of(MsdsErrorCode errorCode, String customMessage) {
        return new MsdsException(errorCode, customMessage);
    }
    
    /**
     * 静态工厂方法 - 创建带原因的MSDS异常
     */
    public static MsdsException of(MsdsErrorCode errorCode, Throwable cause) {
        return new MsdsException(errorCode, cause);
    }
    
    /**
     * 静态工厂方法 - 创建带自定义消息和原因的MSDS异常
     */
    public static MsdsException of(MsdsErrorCode errorCode, String customMessage, Throwable cause) {
        return new MsdsException(errorCode, customMessage, cause);
    }
}