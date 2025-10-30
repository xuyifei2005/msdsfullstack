package com.ruoyi.system.service;

import java.util.List;
import java.util.Map;

/**
 * 规则映射器服务接口
 * 
 * @author ruoyi
 */
public interface IRuleMapperService
{
    /**
     * 校验规则类型枚举
     */
    enum RuleType {
        REQUIRED,      // 必填规则
        LENGTH,        // 长度规则
        PATTERN,       // 格式规则
        ENUM,          // 枚举规则
        RANGE,         // 数值范围规则
        FOREIGN_KEY,   // 外键规则
        UNIQUE,        // 唯一性规则
        DATE_FORMAT    // 日期格式规则
    }
    
    /**
     * 校验规则定义
     */
    class ValidationRule {
        private RuleType type;
        private String message;
        private Map<String, Object> parameters;
        private int priority;
        
        public ValidationRule(RuleType type, String message, Map<String, Object> parameters, int priority) {
            this.type = type;
            this.message = message;
            this.parameters = parameters;
            this.priority = priority;
        }
        
        // Getters and Setters
        public RuleType getType() { return type; }
        public void setType(RuleType type) { this.type = type; }
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
        public Map<String, Object> getParameters() { return parameters; }
        public void setParameters(Map<String, Object> parameters) { this.parameters = parameters; }
        public int getPriority() { return priority; }
        public void setPriority(int priority) { this.priority = priority; }
    }
    
    /**
     * 根据表元数据生成字段校验规则
     * 
     * @param tableName 表名
     * @param columnMetadata 列元数据
     * @return 校验规则列表
     */
    List<ValidationRule> generateColumnRules(String tableName, Map<String, Object> columnMetadata);
    
    /**
     * 根据表元数据生成所有字段的校验规则
     * 
     * @param tableName 表名
     * @return 字段名到校验规则列表的映射
     */
    Map<String, List<ValidationRule>> generateTableRules(String tableName);
    
    /**
     * 生成必填规则
     * 
     * @param columnMetadata 列元数据
     * @return 必填规则，如果不是必填则返回null
     */
    ValidationRule generateRequiredRule(Map<String, Object> columnMetadata);
    
    /**
     * 生成长度规则
     * 
     * @param columnMetadata 列元数据
     * @return 长度规则，如果没有长度限制则返回null
     */
    ValidationRule generateLengthRule(Map<String, Object> columnMetadata);
    
    /**
     * 生成枚举规则
     * 
     * @param tableName 表名
     * @param columnName 列名
     * @param columnMetadata 列元数据
     * @return 枚举规则，如果不是枚举字段则返回null
     */
    ValidationRule generateEnumRule(String tableName, String columnName, Map<String, Object> columnMetadata);
    
    /**
     * 生成数值范围规则
     * 
     * @param columnMetadata 列元数据
     * @return 数值范围规则，如果不是数值字段则返回null
     */
    ValidationRule generateRangeRule(Map<String, Object> columnMetadata);
    
    /**
     * 生成外键规则
     * 
     * @param tableName 表名
     * @param columnName 列名
     * @return 外键规则，如果不是外键字段则返回null
     */
    ValidationRule generateForeignKeyRule(String tableName, String columnName);
    
    /**
     * 生成唯一性规则
     * 
     * @param tableName 表名
     * @param columnName 列名
     * @return 唯一性规则，如果不是唯一字段则返回null
     */
    ValidationRule generateUniqueRule(String tableName, String columnName);
    
    /**
     * 生成日期格式规则
     * 
     * @param columnMetadata 列元数据
     * @return 日期格式规则，如果不是日期字段则返回null
     */
    ValidationRule generateDateFormatRule(Map<String, Object> columnMetadata);
    
    /**
     * 生成格式规则（正则表达式）
     * 
     * @param tableName 表名
     * @param columnName 列名
     * @param columnMetadata 列元数据
     * @return 格式规则，如果没有特定格式要求则返回null
     */
    ValidationRule generatePatternRule(String tableName, String columnName, Map<String, Object> columnMetadata);
    
    /**
     * 将校验规则转换为Excel数据验证格式
     * 
     * @param rules 校验规则列表
     * @return Excel数据验证配置
     */
    Map<String, Object> convertToExcelValidation(List<ValidationRule> rules);
    
    /**
     * 将校验规则转换为前端表单验证格式
     * 
     * @param rules 校验规则列表
     * @return 前端表单验证配置
     */
    Map<String, Object> convertToFormValidation(List<ValidationRule> rules);
}