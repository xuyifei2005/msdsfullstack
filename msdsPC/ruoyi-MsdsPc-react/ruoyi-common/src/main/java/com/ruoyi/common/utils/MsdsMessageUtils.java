package com.ruoyi.common.utils;

import com.ruoyi.common.enums.MsdsErrorCode;
import com.ruoyi.common.utils.MessageUtils;
import com.ruoyi.common.utils.spring.SpringUtils;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Component;

import jakarta.annotation.Resource;
import java.util.Locale;

/**
 * MSDS消息工具类
 * 用于获取MSDS业务相关的国际化消息
 * 
 * @author ruoyi
 */
@Component
public class MsdsMessageUtils {
    
    @Resource
    private MessageSource messageSource;
    
    /**
     * 根据错误码枚举获取国际化消息
     */
    public static String getMessage(MsdsErrorCode errorCode) {
        return getMessage(errorCode.getCode());
    }
    
    /**
     * 根据错误码枚举和参数获取国际化消息
     */
    public static String getMessage(MsdsErrorCode errorCode, Object... args) {
        return getMessage(errorCode.getCode(), args);
    }
    
    /**
     * 根据消息键获取国际化消息
     */
    public static String getMessage(String key) {
        try {
            return MessageUtils.message(key);
        } catch (Exception e) {
            // 如果获取失败，返回默认消息
            MsdsErrorCode errorCode = MsdsErrorCode.getByCode(key);
            return errorCode != null ? errorCode.getMessage() : key;
        }
    }
    
    /**
     * 根据消息键和参数获取国际化消息
     */
    public static String getMessage(String key, Object... args) {
        try {
            return MessageUtils.message(key, args);
        } catch (Exception e) {
            // 如果获取失败，返回默认消息
            MsdsErrorCode errorCode = MsdsErrorCode.getByCode(key);
            return errorCode != null ? errorCode.formatMessage(args) : key;
        }
    }
    
    /**
     * 根据消息键和指定语言环境获取国际化消息
     */
    public static String getMessage(String key, Locale locale) {
        try {
            return SpringUtils.getBean(MessageSource.class).getMessage(key, null, locale);
        } catch (Exception e) {
            // 如果获取失败，返回默认消息
            MsdsErrorCode errorCode = MsdsErrorCode.getByCode(key);
            return errorCode != null ? errorCode.getMessage() : key;
        }
    }
    
    /**
     * 根据消息键、参数和指定语言环境获取国际化消息
     */
    public static String getMessage(String key, Object[] args, Locale locale) {
        try {
            return SpringUtils.getBean(MessageSource.class).getMessage(key, args, locale);
        } catch (Exception e) {
            // 如果获取失败，返回默认消息
            MsdsErrorCode errorCode = MsdsErrorCode.getByCode(key);
            return errorCode != null ? errorCode.formatMessage(args) : key;
        }
    }
    
    /**
     * 获取当前语言环境
     */
    public static Locale getCurrentLocale() {
        return LocaleContextHolder.getLocale();
    }
    
    /**
     * 获取成功消息
     */
    public static String getSuccessMessage(String operation) {
        return getMessage("msds." + operation + ".success");
    }
    
    /**
     * 获取确认消息
     */
    public static String getConfirmMessage(String operation) {
        return getMessage("msds.confirm." + operation);
    }
    
    /**
     * 获取字段标签
     */
    public static String getFieldLabel(String fieldName) {
        return getMessage("msds.field." + fieldName);
    }
    
    /**
     * 检查是否为MSDS错误码
     */
    public static boolean isMsdsErrorCode(String code) {
        return code != null && code.startsWith("MSDS") && MsdsErrorCode.exists(code);
    }
    
    /**
     * 格式化MSDS错误消息
     */
    public static String formatMsdsError(String code, Object... args) {
        if (isMsdsErrorCode(code)) {
            return getMessage(code, args);
        }
        return code;
    }
}