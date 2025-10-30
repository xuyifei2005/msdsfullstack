package com.ruoyi.web.controller.msds.exception;

import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.msds.exception.MsdsBusinessException;
import com.ruoyi.common.utils.MsdsMessageUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpStatus;
import org.springframework.validation.BindException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.multipart.MaxUploadSizeExceededException;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.ConstraintViolationException;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * MSDS全局异常处理器
 * 用于统一处理MSDS业务相关的异常
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
@RestControllerAdvice(basePackages = "com.ruoyi.web.controller.msds")
@Order(1) // 优先级高于全局异常处理器
public class MsdsGlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(MsdsGlobalExceptionHandler.class);

    /**
     * MSDS业务异常处理
     * 
     * @param e MSDS业务异常
     * @param request HTTP请求
     * @return 错误响应
     */
    @ExceptionHandler(MsdsBusinessException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public AjaxResult handleMsdsBusinessException(MsdsBusinessException e, HttpServletRequest request) {
        String requestURI = request.getRequestURI();
        log.error("MSDS业务异常，请求地址'{}', 错误码'{}', 错误信息'{}'", requestURI, e.getErrorCode(), e.getMessage(), e);
        
        return AjaxResult.error(e.getErrorCode(), e.getLocalizedMessage());
    }

    /**
     * 参数验证异常处理（@Valid注解）
     * 
     * @param e 方法参数验证异常
     * @param request HTTP请求
     * @return 错误响应
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public AjaxResult handleMethodArgumentNotValidException(MethodArgumentNotValidException e, HttpServletRequest request) {
        String requestURI = request.getRequestURI();
        String errorMessage = e.getBindingResult().getFieldErrors().stream()
                .map(FieldError::getDefaultMessage)
                .collect(Collectors.joining(", "));
        
        log.error("MSDS参数验证异常，请求地址'{}', 错误信息'{}'", requestURI, errorMessage, e);
        
        return AjaxResult.error("MSDS03001", MsdsMessageUtils.getMessage("MSDS03001", errorMessage));
    }

    /**
     * 参数绑定异常处理
     * 
     * @param e 参数绑定异常
     * @param request HTTP请求
     * @return 错误响应
     */
    @ExceptionHandler(BindException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public AjaxResult handleBindException(BindException e, HttpServletRequest request) {
        String requestURI = request.getRequestURI();
        String errorMessage = e.getBindingResult().getFieldErrors().stream()
                .map(FieldError::getDefaultMessage)
                .collect(Collectors.joining(", "));
        
        log.error("MSDS参数绑定异常，请求地址'{}', 错误信息'{}'", requestURI, errorMessage, e);
        
        return AjaxResult.error("MSDS03001", MsdsMessageUtils.getMessage("MSDS03001", errorMessage));
    }

    /**
     * 约束违反异常处理
     * 
     * @param e 约束违反异常
     * @param request HTTP请求
     * @return 错误响应
     */
    @ExceptionHandler(ConstraintViolationException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public AjaxResult handleConstraintViolationException(ConstraintViolationException e, HttpServletRequest request) {
        String requestURI = request.getRequestURI();
        Set<ConstraintViolation<?>> violations = e.getConstraintViolations();
        String errorMessage = violations.stream()
                .map(ConstraintViolation::getMessage)
                .collect(Collectors.joining(", "));
        
        log.error("MSDS约束违反异常，请求地址'{}', 错误信息'{}'", requestURI, errorMessage, e);
        
        return AjaxResult.error("MSDS03001", MsdsMessageUtils.getMessage("MSDS03001", errorMessage));
    }

    /**
     * 文件上传大小超限异常处理
     * 
     * @param e 文件上传大小超限异常
     * @param request HTTP请求
     * @return 错误响应
     */
    @ExceptionHandler(MaxUploadSizeExceededException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public AjaxResult handleMaxUploadSizeExceededException(MaxUploadSizeExceededException e, HttpServletRequest request) {
        String requestURI = request.getRequestURI();
        long maxSize = e.getMaxUploadSize();
        String maxSizeMB = String.format("%.2f", maxSize / 1024.0 / 1024.0);
        
        log.error("MSDS文件上传大小超限异常，请求地址'{}', 最大允许大小'{}MB'", requestURI, maxSizeMB, e);
        
        return AjaxResult.error("MSDS02003", MsdsMessageUtils.getMessage("MSDS02003", maxSizeMB));
    }

    /**
     * 空指针异常处理
     * 
     * @param e 空指针异常
     * @param request HTTP请求
     * @return 错误响应
     */
    @ExceptionHandler(NullPointerException.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public AjaxResult handleNullPointerException(NullPointerException e, HttpServletRequest request) {
        String requestURI = request.getRequestURI();
        log.error("MSDS空指针异常，请求地址'{}'", requestURI, e);
        
        return AjaxResult.error("MSDS99001", MsdsMessageUtils.getMessage("MSDS99001"));
    }

    /**
     * 非法参数异常处理
     * 
     * @param e 非法参数异常
     * @param request HTTP请求
     * @return 错误响应
     */
    @ExceptionHandler(IllegalArgumentException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public AjaxResult handleIllegalArgumentException(IllegalArgumentException e, HttpServletRequest request) {
        String requestURI = request.getRequestURI();
        log.error("MSDS非法参数异常，请求地址'{}', 错误信息'{}'", requestURI, e.getMessage(), e);
        
        return AjaxResult.error("MSDS99002", MsdsMessageUtils.getMessage("MSDS99002", e.getMessage()));
    }

    /**
     * 运行时异常处理
     * 
     * @param e 运行时异常
     * @param request HTTP请求
     * @return 错误响应
     */
    @ExceptionHandler(RuntimeException.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public AjaxResult handleRuntimeException(RuntimeException e, HttpServletRequest request) {
        String requestURI = request.getRequestURI();
        log.error("MSDS运行时异常，请求地址'{}', 错误信息'{}'", requestURI, e.getMessage(), e);
        
        return AjaxResult.error("MSDS99003", MsdsMessageUtils.getMessage("MSDS99003", e.getMessage()));
    }

    /**
     * 通用异常处理
     * 
     * @param e 异常
     * @param request HTTP请求
     * @return 错误响应
     */
    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public AjaxResult handleException(Exception e, HttpServletRequest request) {
        String requestURI = request.getRequestURI();
        log.error("MSDS系统异常，请求地址'{}', 错误信息'{}'", requestURI, e.getMessage(), e);
        
        return AjaxResult.error("MSDS99001", MsdsMessageUtils.getMessage("MSDS99001"));
    }
}