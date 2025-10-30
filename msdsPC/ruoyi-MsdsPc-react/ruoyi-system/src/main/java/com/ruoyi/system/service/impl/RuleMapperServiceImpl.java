package com.ruoyi.system.service.impl;

import java.util.*;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ruoyi.system.service.IMsdsMetadataService;
import com.ruoyi.system.service.IRuleMapperService;

/**
 * 规则映射器服务实现
 * 
 * @author ruoyi
 */
@Service
public class RuleMapperServiceImpl implements IRuleMapperService
{
    @Autowired
    private IMsdsMetadataService msdsMetadataService;
    
    // 预定义的枚举值映射
    private static final Map<String, List<String>> ENUM_MAPPINGS = new HashMap<>();
    
    // 预定义的格式规则映射
    private static final Map<String, String> PATTERN_MAPPINGS = new HashMap<>();
    
    static {
        // 初始化枚举值映射
        ENUM_MAPPINGS.put("status", Arrays.asList("0", "1")); // 停用/启用
        ENUM_MAPPINGS.put("gender", Arrays.asList("0", "1", "2")); // 未知/男/女
        ENUM_MAPPINGS.put("del_flag", Arrays.asList("0", "2")); // 正常/删除
        ENUM_MAPPINGS.put("visible", Arrays.asList("0", "1")); // 显示/隐藏
        
        // 初始化格式规则映射
        PATTERN_MAPPINGS.put("email", "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$");
        PATTERN_MAPPINGS.put("phone", "^1[3-9]\\d{9}$");
        PATTERN_MAPPINGS.put("mobile", "^1[3-9]\\d{9}$");
        PATTERN_MAPPINGS.put("tel", "^(\\d{3,4}-)?\\d{7,8}$");
        PATTERN_MAPPINGS.put("url", "^https?://[\\w\\-]+(\\.[\\w\\-]+)+([\\w\\-\\.,@?^=%&:/~\\+#]*[\\w\\-\\@?^=%&/~\\+#])?$");
        PATTERN_MAPPINGS.put("ip", "^((25[0-5]|2[0-4]\\d|[01]?\\d\\d?)\\.){3}(25[0-5]|2[0-4]\\d|[01]?\\d\\d?)$");
        PATTERN_MAPPINGS.put("code", "^[A-Za-z0-9_-]+$");
        PATTERN_MAPPINGS.put("name", "^[\\u4e00-\\u9fa5a-zA-Z0-9_-]+$");
    }
    
    @Override
    public List<ValidationRule> generateColumnRules(String tableName, Map<String, Object> columnMetadata)
    {
        List<ValidationRule> rules = new ArrayList<>();
        String columnName = (String) columnMetadata.get("column_name");
        
        // 生成必填规则
        ValidationRule requiredRule = generateRequiredRule(columnMetadata);
        if (requiredRule != null) {
            rules.add(requiredRule);
        }
        
        // 生成长度规则
        ValidationRule lengthRule = generateLengthRule(columnMetadata);
        if (lengthRule != null) {
            rules.add(lengthRule);
        }
        
        // 生成枚举规则
        ValidationRule enumRule = generateEnumRule(tableName, columnName, columnMetadata);
        if (enumRule != null) {
            rules.add(enumRule);
        }
        
        // 生成数值范围规则
        ValidationRule rangeRule = generateRangeRule(columnMetadata);
        if (rangeRule != null) {
            rules.add(rangeRule);
        }
        
        // 生成外键规则
        ValidationRule foreignKeyRule = generateForeignKeyRule(tableName, columnName);
        if (foreignKeyRule != null) {
            rules.add(foreignKeyRule);
        }
        
        // 生成唯一性规则
        ValidationRule uniqueRule = generateUniqueRule(tableName, columnName);
        if (uniqueRule != null) {
            rules.add(uniqueRule);
        }
        
        // 生成日期格式规则
        ValidationRule dateFormatRule = generateDateFormatRule(columnMetadata);
        if (dateFormatRule != null) {
            rules.add(dateFormatRule);
        }
        
        // 生成格式规则
        ValidationRule patternRule = generatePatternRule(tableName, columnName, columnMetadata);
        if (patternRule != null) {
            rules.add(patternRule);
        }
        
        // 按优先级排序
        rules.sort(Comparator.comparingInt(ValidationRule::getPriority));
        
        return rules;
    }
    
    @Override
    public Map<String, List<ValidationRule>> generateTableRules(String tableName)
    {
        Map<String, List<ValidationRule>> tableRules = new HashMap<>();
        
        // 获取表的所有列信息
        List<Map<String, Object>> columns = msdsMetadataService.getTableColumns(tableName);
        
        for (Map<String, Object> column : columns) {
            String columnName = (String) column.get("column_name");
            List<ValidationRule> columnRules = generateColumnRules(tableName, column);
            if (!columnRules.isEmpty()) {
                tableRules.put(columnName, columnRules);
            }
        }
        
        return tableRules;
    }
    
    @Override
    public ValidationRule generateRequiredRule(Map<String, Object> columnMetadata)
    {
        String isRequired = (String) columnMetadata.get("is_required");
        if ("1".equals(isRequired)) {
            Map<String, Object> parameters = new HashMap<>();
            parameters.put("required", true);
            return new ValidationRule(
                RuleType.REQUIRED,
                "此字段为必填项",
                parameters,
                1 // 最高优先级
            );
        }
        return null;
    }
    
    @Override
    public ValidationRule generateLengthRule(Map<String, Object> columnMetadata)
    {
        Long maxLength = (Long) columnMetadata.get("character_maximum_length");
        String dataType = (String) columnMetadata.get("data_type");
        
        if (maxLength != null && maxLength > 0 && isStringType(dataType)) {
            Map<String, Object> parameters = new HashMap<>();
            parameters.put("maxLength", maxLength);
            return new ValidationRule(
                RuleType.LENGTH,
                String.format("字符长度不能超过%d", maxLength),
                parameters,
                2
            );
        }
        return null;
    }
    
    @Override
    public ValidationRule generateEnumRule(String tableName, String columnName, Map<String, Object> columnMetadata)
    {
        // 检查是否有预定义的枚举值
        for (Map.Entry<String, List<String>> entry : ENUM_MAPPINGS.entrySet()) {
            if (columnName.toLowerCase().contains(entry.getKey())) {
                Map<String, Object> parameters = new HashMap<>();
                parameters.put("enumValues", entry.getValue());
                return new ValidationRule(
                    RuleType.ENUM,
                    String.format("值必须为：%s", String.join(", ", entry.getValue())),
                    parameters,
                    3
                );
            }
        }
        
        // 检查数据库中的枚举类型
        String columnType = (String) columnMetadata.get("column_type");
        if (columnType != null && columnType.toLowerCase().startsWith("enum")) {
            List<String> enumValues = extractEnumValues(columnType);
            if (!enumValues.isEmpty()) {
                Map<String, Object> parameters = new HashMap<>();
                parameters.put("enumValues", enumValues);
                return new ValidationRule(
                    RuleType.ENUM,
                    String.format("值必须为：%s", String.join(", ", enumValues)),
                    parameters,
                    3
                );
            }
        }
        
        return null;
    }
    
    @Override
    public ValidationRule generateRangeRule(Map<String, Object> columnMetadata)
    {
        String dataType = (String) columnMetadata.get("data_type");
        
        if (isNumericType(dataType)) {
            Map<String, Object> parameters = new HashMap<>();
            
            // 根据数据类型设置范围
            switch (dataType.toLowerCase()) {
                case "tinyint":
                    parameters.put("min", -128);
                    parameters.put("max", 127);
                    break;
                case "smallint":
                    parameters.put("min", -32768);
                    parameters.put("max", 32767);
                    break;
                case "mediumint":
                    parameters.put("min", -8388608);
                    parameters.put("max", 8388607);
                    break;
                case "int":
                case "integer":
                    parameters.put("min", Integer.MIN_VALUE);
                    parameters.put("max", Integer.MAX_VALUE);
                    break;
                case "bigint":
                    parameters.put("min", Long.MIN_VALUE);
                    parameters.put("max", Long.MAX_VALUE);
                    break;
                default:
                    return null;
            }
            
            return new ValidationRule(
                RuleType.RANGE,
                String.format("数值必须在%s到%s之间", parameters.get("min"), parameters.get("max")),
                parameters,
                4
            );
        }
        
        return null;
    }
    
    @Override
    public ValidationRule generateForeignKeyRule(String tableName, String columnName)
    {
        // 获取外键信息
        List<Map<String, Object>> foreignKeys = msdsMetadataService.getTableForeignKeys(tableName);
        
        for (Map<String, Object> fk : foreignKeys) {
            if (columnName.equals(fk.get("column_name"))) {
                String refTable = (String) fk.get("referenced_table_name");
                String refColumn = (String) fk.get("referenced_column_name");
                
                Map<String, Object> parameters = new HashMap<>();
                parameters.put("referencedTable", refTable);
                parameters.put("referencedColumn", refColumn);
                
                return new ValidationRule(
                    RuleType.FOREIGN_KEY,
                    String.format("值必须存在于表%s的%s字段中", refTable, refColumn),
                    parameters,
                    5
                );
            }
        }
        
        return null;
    }
    
    @Override
    public ValidationRule generateUniqueRule(String tableName, String columnName)
    {
        // 获取唯一约束信息
        List<Map<String, Object>> uniqueConstraints = msdsMetadataService.getTableUniqueConstraints(tableName);
        
        for (Map<String, Object> constraint : uniqueConstraints) {
            if (columnName.equals(constraint.get("column_name"))) {
                Map<String, Object> parameters = new HashMap<>();
                parameters.put("unique", true);
                
                return new ValidationRule(
                    RuleType.UNIQUE,
                    "此字段的值必须唯一",
                    parameters,
                    6
                );
            }
        }
        
        return null;
    }
    
    @Override
    public ValidationRule generateDateFormatRule(Map<String, Object> columnMetadata)
    {
        String dataType = (String) columnMetadata.get("data_type");
        
        if (isDateType(dataType)) {
            Map<String, Object> parameters = new HashMap<>();
            String format;
            
            switch (dataType.toLowerCase()) {
                case "date":
                    format = "yyyy-MM-dd";
                    break;
                case "datetime":
                case "timestamp":
                    format = "yyyy-MM-dd HH:mm:ss";
                    break;
                case "time":
                    format = "HH:mm:ss";
                    break;
                default:
                    return null;
            }
            
            parameters.put("dateFormat", format);
            
            return new ValidationRule(
                RuleType.DATE_FORMAT,
                String.format("日期格式必须为：%s", format),
                parameters,
                7
            );
        }
        
        return null;
    }
    
    @Override
    public ValidationRule generatePatternRule(String tableName, String columnName, Map<String, Object> columnMetadata)
    {
        // 检查是否有预定义的格式规则
        for (Map.Entry<String, String> entry : PATTERN_MAPPINGS.entrySet()) {
            if (columnName.toLowerCase().contains(entry.getKey())) {
                Map<String, Object> parameters = new HashMap<>();
                parameters.put("pattern", entry.getValue());
                
                return new ValidationRule(
                    RuleType.PATTERN,
                    String.format("%s格式不正确", entry.getKey()),
                    parameters,
                    8
                );
            }
        }
        
        return null;
    }
    
    @Override
    public Map<String, Object> convertToExcelValidation(List<ValidationRule> rules)
    {
        Map<String, Object> excelValidation = new HashMap<>();
        
        for (ValidationRule rule : rules) {
            switch (rule.getType()) {
                case REQUIRED:
                    excelValidation.put("allowBlank", false);
                    break;
                case LENGTH:
                    Long maxLength = (Long) rule.getParameters().get("maxLength");
                    excelValidation.put("textLength", maxLength);
                    break;
                case ENUM:
                    @SuppressWarnings("unchecked")
                    List<String> enumValues = (List<String>) rule.getParameters().get("enumValues");
                    excelValidation.put("listOfValues", enumValues);
                    break;
                case RANGE:
                    Object min = rule.getParameters().get("min");
                    Object max = rule.getParameters().get("max");
                    excelValidation.put("numericRange", Arrays.asList(min, max));
                    break;
                case DATE_FORMAT:
                    String dateFormat = (String) rule.getParameters().get("dateFormat");
                    excelValidation.put("dateFormat", dateFormat);
                    break;
                case PATTERN:
                    String pattern = (String) rule.getParameters().get("pattern");
                    excelValidation.put("customFormula", pattern);
                    break;
            }
        }
        
        // 合并所有错误消息
        String errorMessage = rules.stream()
            .map(ValidationRule::getMessage)
            .collect(Collectors.joining("; "));
        excelValidation.put("errorMessage", errorMessage);
        
        return excelValidation;
    }
    
    @Override
    public Map<String, Object> convertToFormValidation(List<ValidationRule> rules)
    {
        Map<String, Object> formValidation = new HashMap<>();
        List<Map<String, Object>> ruleList = new ArrayList<>();
        
        for (ValidationRule rule : rules) {
            Map<String, Object> ruleConfig = new HashMap<>();
            ruleConfig.put("type", rule.getType().name().toLowerCase());
            ruleConfig.put("message", rule.getMessage());
            ruleConfig.putAll(rule.getParameters());
            ruleList.add(ruleConfig);
        }
        
        formValidation.put("rules", ruleList);
        return formValidation;
    }
    
    // 辅助方法
    
    private boolean isStringType(String dataType) {
        return Arrays.asList("char", "varchar", "text", "tinytext", "mediumtext", "longtext")
            .contains(dataType.toLowerCase());
    }
    
    private boolean isNumericType(String dataType) {
        return Arrays.asList("tinyint", "smallint", "mediumint", "int", "integer", "bigint", 
            "float", "double", "decimal", "numeric")
            .contains(dataType.toLowerCase());
    }
    
    private boolean isDateType(String dataType) {
        return Arrays.asList("date", "datetime", "timestamp", "time")
            .contains(dataType.toLowerCase());
    }
    
    private List<String> extractEnumValues(String columnType) {
        List<String> values = new ArrayList<>();
        if (columnType.toLowerCase().startsWith("enum")) {
            String enumPart = columnType.substring(columnType.indexOf("(") + 1, columnType.lastIndexOf(")"));
            String[] parts = enumPart.split(",");
            for (String part : parts) {
                String value = part.trim().replaceAll("['\"]", "");
                values.add(value);
            }
        }
        return values;
    }
}