package com.ruoyi.system.enums;

/**
 * 导入错误码枚举
 * 定义标准化的错误码体系，用于导入过程中的错误分类和处理
 * 
 * @author ruoyi
 */
public enum ImportErrorCode {
    
    // ========== 文件相关错误 (1000-1099) ==========
    FILE_NOT_FOUND("1001", "文件不存在", "请检查文件路径是否正确"),
    FILE_TOO_LARGE("1002", "文件过大", "文件大小超过限制，请压缩后重试"),
    FILE_TYPE_NOT_SUPPORTED("1003", "文件类型不支持", "仅支持Excel(.xlsx/.xls)文件"),
    FILE_CORRUPTED("1004", "文件损坏", "文件无法正常读取，请重新上传"),
    FILE_EMPTY("1005", "文件为空", "文件中没有数据，请检查文件内容"),
    FILE_READ_ERROR("1006", "文件读取失败", "文件读取过程中发生错误"),
    
    // ========== 表结构相关错误 (1100-1199) ==========
    SHEET_NOT_FOUND("1101", "工作表不存在", "未找到指定的工作表"),
    HEADER_ROW_NOT_FOUND("1102", "表头行不存在", "未找到有效的表头行"),
    HEADER_COLUMN_MISSING("1103", "必需列头缺失", "缺少必需的列头字段"),
    HEADER_COLUMN_DUPLICATE("1104", "列头重复", "存在重复的列头"),
    HEADER_COLUMN_UNRECOGNIZED("1105", "列头无法识别", "存在无法识别的列头"),
    TEMPLATE_MISMATCH("1106", "模板不匹配", "文件结构与预期模板不符"),
    
    // ========== 数据校验错误 (1200-1299) ==========
    REQUIRED_FIELD_MISSING("1201", "必填字段为空", "请填写必填字段"),
    FIELD_LENGTH_EXCEEDED("1202", "字段长度超限", "字段内容超过最大长度限制"),
    INVALID_DATA_TYPE("1203", "数据类型错误", "字段数据类型不符合要求"),
    INVALID_DATE_FORMAT("1204", "日期格式错误", "日期格式不正确，请使用yyyy-MM-dd格式"),
    INVALID_NUMBER_FORMAT("1205", "数字格式错误", "数字格式不正确"),
    INVALID_EMAIL_FORMAT("1206", "邮箱格式错误", "邮箱地址格式不正确"),
    INVALID_PHONE_FORMAT("1207", "电话格式错误", "电话号码格式不正确"),
    INVALID_ENUM_VALUE("1208", "枚举值无效", "字段值不在允许的枚举范围内"),
    INVALID_REGEX_PATTERN("1209", "格式校验失败", "字段内容不符合格式要求"),
    INVALID_RANGE_VALUE("1210", "数值范围错误", "数值超出允许范围"),
    INVALID_CAS_FORMAT("1211", "CAS号格式错误", "CAS号格式不正确"),
    
    // ========== 业务逻辑错误 (1300-1399) ==========
    DUPLICATE_RECORD("1301", "记录重复", "存在重复的记录"),
    FOREIGN_KEY_CONSTRAINT("1302", "外键约束违反", "关联数据不存在"),
    BUSINESS_RULE_VIOLATION("1303", "业务规则违反", "数据不符合业务规则"),
    DATA_CONSISTENCY_ERROR("1304", "数据一致性错误", "数据之间存在冲突"),
    REFERENCE_DATA_MISSING("1305", "参考数据缺失", "缺少必要的参考数据"),
    WORKFLOW_STATE_ERROR("1306", "工作流状态错误", "当前状态不允许此操作"),
    
    // ========== 系统错误 (1400-1499) ==========
    DATABASE_CONNECTION_ERROR("1401", "数据库连接失败", "无法连接到数据库"),
    DATABASE_OPERATION_ERROR("1402", "数据库操作失败", "数据库操作过程中发生错误"),
    MEMORY_OVERFLOW("1403", "内存溢出", "处理数据量过大，内存不足"),
    TIMEOUT_ERROR("1404", "操作超时", "操作执行时间过长"),
    PERMISSION_DENIED("1405", "权限不足", "当前用户没有执行此操作的权限"),
    SYSTEM_BUSY("1406", "系统繁忙", "系统当前繁忙，请稍后重试"),
    CONFIGURATION_ERROR("1407", "配置错误", "系统配置不正确"),
    
    // ========== 网络相关错误 (1500-1599) ==========
    NETWORK_ERROR("1501", "网络错误", "网络连接异常"),
    REQUEST_TIMEOUT("1502", "请求超时", "请求处理超时"),
    SERVICE_UNAVAILABLE("1503", "服务不可用", "相关服务暂时不可用"),
    
    // ========== 未知错误 (9999) ==========
    UNKNOWN_ERROR("9999", "未知错误", "发生了未知错误，请联系管理员");
    
    private final String code;
    private final String message;
    private final String suggestion;
    
    ImportErrorCode(String code, String message, String suggestion) {
        this.code = code;
        this.message = message;
        this.suggestion = suggestion;
    }
    
    public String getCode() {
        return code;
    }
    
    public String getMessage() {
        return message;
    }
    
    public String getSuggestion() {
        return suggestion;
    }
    
    /**
     * 根据错误码获取枚举
     */
    public static ImportErrorCode getByCode(String code) {
        for (ImportErrorCode errorCode : values()) {
            if (errorCode.getCode().equals(code)) {
                return errorCode;
            }
        }
        return UNKNOWN_ERROR;
    }
    
    /**
     * 判断是否为文件相关错误
     */
    public boolean isFileError() {
        return code.startsWith("10");
    }
    
    /**
     * 判断是否为表结构相关错误
     */
    public boolean isStructureError() {
        return code.startsWith("11");
    }
    
    /**
     * 判断是否为数据校验错误
     */
    public boolean isValidationError() {
        return code.startsWith("12");
    }
    
    /**
     * 判断是否为业务逻辑错误
     */
    public boolean isBusinessError() {
        return code.startsWith("13");
    }
    
    /**
     * 判断是否为系统错误
     */
    public boolean isSystemError() {
        return code.startsWith("14");
    }
    
    /**
     * 判断是否为网络相关错误
     */
    public boolean isNetworkError() {
        return code.startsWith("15");
    }
    
    /**
     * 判断是否为严重错误（需要停止处理）
     */
    public boolean isCriticalError() {
        return isFileError() || isSystemError() || isNetworkError();
    }
    
    /**
     * 判断是否为可恢复错误（可以继续处理其他行）
     */
    public boolean isRecoverableError() {
        return isValidationError() || isBusinessError();
    }
    
    /**
     * 获取错误级别
     */
    public String getLevel() {
        if (isCriticalError()) {
            return "CRITICAL";
        } else if (isRecoverableError()) {
            return "WARNING";
        } else {
            return "ERROR";
        }
    }
    
    /**
     * 格式化错误信息
     */
    public String formatError(Object... args) {
        if (args.length > 0) {
            return String.format(message, args);
        }
        return message;
    }
    
    /**
     * 格式化建议信息
     */
    public String formatSuggestion(Object... args) {
        if (args.length > 0) {
            return String.format(suggestion, args);
        }
        return suggestion;
    }
    
    @Override
    public String toString() {
        return String.format("[%s] %s - %s", code, message, suggestion);
    }
}