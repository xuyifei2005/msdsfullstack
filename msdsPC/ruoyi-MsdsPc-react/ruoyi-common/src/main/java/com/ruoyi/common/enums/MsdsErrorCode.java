package com.ruoyi.common.enums;

import java.text.MessageFormat;

/**
 * MSDS业务错误码枚举
 * 错误码规范：MSDS + 模块代码(2位) + 错误序号(3位)
 * 
 * @author ruoyi
 */
public enum MsdsErrorCode {
    
    // ========== MSDS主信息模块 (01) ==========
    MSDS_NOT_FOUND("MSDS01001", "MSDS记录不存在"),
    MSDS_ALREADY_EXISTS("MSDS01002", "MSDS记录已存在"),
    MSDS_PRODUCT_NAME_REQUIRED("MSDS01003", "产品名称不能为空"),
    MSDS_CAS_NUMBER_INVALID("MSDS01004", "CAS号格式不正确"),
    MSDS_STATUS_INVALID("MSDS01005", "MSDS状态无效"),
    MSDS_DELETE_FAILED("MSDS01006", "MSDS删除失败，存在关联数据"),
    MSDS_UPDATE_FAILED("MSDS01007", "MSDS更新失败"),
    MSDS_CREATE_FAILED("MSDS01008", "MSDS创建失败"),
    
    // ========== 文件导入模块 (02) ==========
    FILE_UPLOAD_FAILED("MSDS02001", "文件上传失败"),
    FILE_FORMAT_UNSUPPORTED("MSDS02002", "不支持的文件格式"),
    FILE_SIZE_EXCEEDED("MSDS02003", "文件大小超出限制"),
    FILE_CONTENT_INVALID("MSDS02004", "文件内容格式错误"),
    FILE_PARSE_FAILED("MSDS02005", "文件解析失败"),
    FILE_ENCODING_ERROR("MSDS02006", "文件编码错误"),
    EXCEL_TEMPLATE_ERROR("MSDS02007", "Excel模板格式错误"),
    WORD_PARSE_ERROR("MSDS02008", "Word文档解析失败"),
    TXT_PARSE_ERROR("MSDS02009", "TXT文件解析失败"),
    
    // ========== 数据验证模块 (03) ==========
    VALIDATION_FAILED("MSDS03001", "数据验证失败"),
    REQUIRED_FIELD_MISSING("MSDS03002", "必填字段缺失"),
    FIELD_LENGTH_EXCEEDED("MSDS03003", "字段长度超出限制"),
    FIELD_FORMAT_INVALID("MSDS03004", "字段格式不正确"),
    ENUM_VALUE_INVALID("MSDS03005", "枚举值无效"),
    DATE_FORMAT_INVALID("MSDS03006", "日期格式不正确"),
    NUMBER_FORMAT_INVALID("MSDS03007", "数字格式不正确"),
    
    // ========== 权限控制模块 (04) ==========
    ACCESS_DENIED("MSDS04001", "访问被拒绝"),
    PERMISSION_INSUFFICIENT("MSDS04002", "权限不足"),
    USER_NOT_AUTHORIZED("MSDS04003", "用户未授权"),
    ROLE_PERMISSION_DENIED("MSDS04004", "角色权限不足"),
    
    // ========== 业务逻辑模块 (05) ==========
    BUSINESS_RULE_VIOLATION("MSDS05001", "违反业务规则"),
    DUPLICATE_ENTRY("MSDS05002", "重复条目"),
    REFERENCE_CONSTRAINT("MSDS05003", "存在引用约束"),
    WORKFLOW_STATE_ERROR("MSDS05004", "工作流状态错误"),
    AUDIT_LOG_FAILED("MSDS05005", "审计日志记录失败"),
    
    // ========== 系统错误模块 (06) ==========
    DATABASE_ERROR("MSDS06001", "数据库操作失败"),
    NETWORK_ERROR("MSDS06002", "网络连接失败"),
    SYSTEM_BUSY("MSDS06003", "系统繁忙，请稍后重试"),
    CONFIG_ERROR("MSDS06004", "系统配置错误"),
    CACHE_ERROR("MSDS06005", "缓存操作失败"),
    
    // ========== 模板管理模块 (07) ==========
    TEMPLATE_NOT_FOUND("MSDS07001", "模板不存在"),
    TEMPLATE_GENERATE_FAILED("MSDS07002", "模板生成失败"),
    TEMPLATE_DOWNLOAD_FAILED("MSDS07003", "模板下载失败"),
    TEMPLATE_CACHE_EXPIRED("MSDS07004", "模板缓存已过期"),
    
    // ========== 数据导出模块 (08) ==========
    EXPORT_FAILED("MSDS08001", "数据导出失败"),
    EXPORT_FORMAT_UNSUPPORTED("MSDS08002", "不支持的导出格式"),
    EXPORT_DATA_EMPTY("MSDS08003", "导出数据为空"),
    EXPORT_PERMISSION_DENIED("MSDS08004", "导出权限不足"),
    
    // ========== 搜索查询模块 (09) ==========
    SEARCH_FAILED("MSDS09001", "搜索失败"),
    SEARCH_CRITERIA_INVALID("MSDS09002", "搜索条件无效"),
    SEARCH_RESULT_TOO_LARGE("MSDS09003", "搜索结果过多，请缩小搜索范围"),
    
    // ========== 通用错误 (99) ==========
    UNKNOWN_ERROR("MSDS99001", "未知错误"),
    PARAMETER_ERROR("MSDS99002", "参数错误"),
    OPERATION_FAILED("MSDS99003", "操作失败"),
    SERVICE_UNAVAILABLE("MSDS99004", "服务不可用");
    
    private final String code;
    private final String message;
    
    MsdsErrorCode(String code, String message) {
        this.code = code;
        this.message = message;
    }
    
    public String getCode() {
        return code;
    }
    
    public String getMessage() {
        return message;
    }
    
    /**
     * 格式化错误消息
     */
    public String formatMessage(Object... args) {
        if (args == null || args.length == 0) {
            return this.message;
        }
        return MessageFormat.format(this.message, args);
    }
    
    /**
     * 根据错误码字符串获取枚举值
     */
    public static MsdsErrorCode getByCode(String code) {
        if (code == null || code.trim().isEmpty()) {
            return UNKNOWN_ERROR;
        }
        
        for (MsdsErrorCode errorCode : values()) {
            if (errorCode.getCode().equals(code)) {
                return errorCode;
            }
        }
        
        // 如果找不到对应的错误码，返回未知错误
        return UNKNOWN_ERROR;
    }
    
    /**
     * 检查错误码是否存在
     */
    public static boolean exists(String code) {
        if (code == null || code.trim().isEmpty()) {
            return false;
        }
        
        for (MsdsErrorCode errorCode : values()) {
            if (errorCode.getCode().equals(code)) {
                return true;
            }
        }
        
        return false;
    }
}