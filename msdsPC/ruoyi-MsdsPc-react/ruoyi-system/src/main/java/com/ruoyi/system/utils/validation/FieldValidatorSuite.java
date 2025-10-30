package com.ruoyi.system.utils.validation;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.utils.poi.ExcelValidationUtil;
import org.springframework.stereotype.Component;

import java.lang.reflect.Field;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Pattern;

/**
 * 字段校验器套件
 * 提供全面的字段校验功能，包括必填、类型、长度、枚举、格式等校验
 * 
 * @author ruoyi
 */
@Component
public class FieldValidatorSuite {
    
    // 常用日期格式
    private static final String[] DATE_FORMATS = {
        "yyyy-MM-dd", "yyyy/MM/dd", "yyyy-MM-dd HH:mm:ss", 
        "yyyy/MM/dd HH:mm:ss", "dd/MM/yyyy", "MM/dd/yyyy"
    };
    
    // 数字格式正则
    private static final Pattern NUMBER_PATTERN = Pattern.compile("^-?\\d+(\\.\\d+)?$");
    private static final Pattern INTEGER_PATTERN = Pattern.compile("^-?\\d+$");
    private static final Pattern POSITIVE_NUMBER_PATTERN = Pattern.compile("^\\d+(\\.\\d+)?$");
    
    // 常用格式正则
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
        "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile(
        "^1[3-9]\\d{9}$|^0\\d{2,3}-?\\d{7,8}$");
    private static final Pattern CAS_PATTERN = Pattern.compile(
        "^\\d{2,7}-\\d{2}-\\d$");
    
    /**
     * 校验结果类
     */
    public static class ValidationResult {
        private boolean valid;
        private String errorMessage;
        private String suggestion;
        private String errorCode;
        private Object correctedValue;
        
        public ValidationResult(boolean valid) {
            this.valid = valid;
        }
        
        public ValidationResult(boolean valid, String errorMessage) {
            this.valid = valid;
            this.errorMessage = errorMessage;
        }
        
        public ValidationResult(boolean valid, String errorMessage, String suggestion) {
            this.valid = valid;
            this.errorMessage = errorMessage;
            this.suggestion = suggestion;
        }
        
        public ValidationResult(boolean valid, String errorMessage, String suggestion, String errorCode) {
            this.valid = valid;
            this.errorMessage = errorMessage;
            this.suggestion = suggestion;
            this.errorCode = errorCode;
        }
        
        // Getters and Setters
        public boolean isValid() { return valid; }
        public void setValid(boolean valid) { this.valid = valid; }
        
        public String getErrorMessage() { return errorMessage; }
        public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }
        
        public String getSuggestion() { return suggestion; }
        public void setSuggestion(String suggestion) { this.suggestion = suggestion; }
        
        public String getErrorCode() { return errorCode; }
        public void setErrorCode(String errorCode) { this.errorCode = errorCode; }
        
        public Object getCorrectedValue() { return correctedValue; }
        public void setCorrectedValue(Object correctedValue) { this.correctedValue = correctedValue; }
    }
    
    /**
     * 必填字段校验
     */
    public ValidationResult validateRequired(Object value, Field field) {
        Excel excelAnnotation = field.getAnnotation(Excel.class);
        if (excelAnnotation == null) {
            return new ValidationResult(true);
        }
        
        if (value == null || (value instanceof String && ((String) value).trim().isEmpty())) {
            return new ValidationResult(false, 
                String.format("字段 '%s' 为必填项，不能为空", excelAnnotation.name()),
                "请填写该字段的值",
                "REQUIRED_FIELD_MISSING");
        }
        
        return new ValidationResult(true);
    }
    
    /**
     * 字段长度校验
     */
    public ValidationResult validateLength(Object value, Field field) {
        if (value == null) {
            return new ValidationResult(true);
        }
        
        String strValue = value.toString();
        Excel excelAnnotation = field.getAnnotation(Excel.class);
        
        if (excelAnnotation != null && excelAnnotation.width() > 0) {
            int maxLength = (int) excelAnnotation.width();
            if (strValue.length() > maxLength) {
                return new ValidationResult(false,
                    String.format("字段 '%s' 长度超过限制，最大长度为 %d，当前长度为 %d", 
                        excelAnnotation.name(), maxLength, strValue.length()),
                    String.format("请将内容缩短至 %d 个字符以内", maxLength),
                    "FIELD_LENGTH_EXCEEDED");
            }
        }
        
        return new ValidationResult(true);
    }
    
    /**
     * 数据类型校验
     */
    public ValidationResult validateDataType(Object value, Field field) {
        if (value == null) {
            return new ValidationResult(true);
        }
        
        String strValue = value.toString().trim();
        if (strValue.isEmpty()) {
            return new ValidationResult(true);
        }
        
        Class<?> fieldType = field.getType();
        Excel excelAnnotation = field.getAnnotation(Excel.class);
        String fieldName = excelAnnotation != null ? excelAnnotation.name() : field.getName();
        
        // 数字类型校验
        if (fieldType == Integer.class || fieldType == int.class ||
            fieldType == Long.class || fieldType == long.class) {
            if (!INTEGER_PATTERN.matcher(strValue).matches()) {
                return new ValidationResult(false,
                    String.format("字段 '%s' 必须为整数，当前值：%s", fieldName, strValue),
                    "请输入有效的整数值",
                    "INVALID_INTEGER_FORMAT");
            }
        } else if (fieldType == Double.class || fieldType == double.class ||
                   fieldType == Float.class || fieldType == float.class) {
            if (!NUMBER_PATTERN.matcher(strValue).matches()) {
                return new ValidationResult(false,
                    String.format("字段 '%s' 必须为数字，当前值：%s", fieldName, strValue),
                    "请输入有效的数字值",
                    "INVALID_NUMBER_FORMAT");
            }
        } else if (fieldType == Date.class) {
            if (!isValidDate(strValue)) {
                return new ValidationResult(false,
                    String.format("字段 '%s' 日期格式不正确，当前值：%s", fieldName, strValue),
                    "请使用格式：yyyy-MM-dd 或 yyyy/MM/dd",
                    "INVALID_DATE_FORMAT");
            }
        }
        
        return new ValidationResult(true);
    }
    
    /**
     * 枚举值校验
     */
    public ValidationResult validateEnumValue(Object value, Field field) {
        if (value == null) {
            return new ValidationResult(true);
        }
        
        String strValue = value.toString().trim();
        if (strValue.isEmpty()) {
            return new ValidationResult(true);
        }
        
        Excel excelAnnotation = field.getAnnotation(Excel.class);
        if (excelAnnotation == null) {
            return new ValidationResult(true);
        }
        
        String fieldName = excelAnnotation.name();
        List<String> validValues = new ArrayList<>();
        
        // 检查 readConverterExp 枚举
        if (!excelAnnotation.readConverterExp().isEmpty()) {
            String[] enumPairs = excelAnnotation.readConverterExp().split(",");
            for (String pair : enumPairs) {
                if (pair.contains("=")) {
                    String key = pair.split("=")[0].trim();
                    String val = pair.split("=")[1].trim();
                    validValues.add(key);
                    validValues.add(val);
                    if (key.equals(strValue) || val.equals(strValue)) {
                        return new ValidationResult(true);
                    }
                }
            }
        }
        
        // 检查 combo 枚举
        if (excelAnnotation.combo().length > 0) {
            String[] comboValues = excelAnnotation.combo();
            for (String comboValue : comboValues) {
                String trimmedValue = comboValue.trim();
                validValues.add(trimmedValue);
                if (trimmedValue.equals(strValue)) {
                    return new ValidationResult(true);
                }
            }
        }
        
        if (!validValues.isEmpty()) {
            // 尝试模糊匹配
            String suggestion = findBestMatch(strValue, validValues);
            return new ValidationResult(false,
                String.format("字段 '%s' 的值 '%s' 不在允许的枚举值范围内", fieldName, strValue),
                suggestion != null ? String.format("建议使用：%s", suggestion) : 
                    String.format("允许的值：%s", String.join(", ", validValues)),
                "INVALID_ENUM_VALUE");
        }
        
        return new ValidationResult(true);
    }
    
    /**
     * 格式校验（正则表达式、特殊格式）
     */
    public ValidationResult validateFormat(Object value, Field field) {
        if (value == null) {
            return new ValidationResult(true);
        }
        
        String strValue = value.toString().trim();
        if (strValue.isEmpty()) {
            return new ValidationResult(true);
        }
        
        Excel excelAnnotation = field.getAnnotation(Excel.class);
        String fieldName = excelAnnotation != null ? excelAnnotation.name() : field.getName();
        
        // 根据字段名判断特殊格式
        if (fieldName.contains("邮箱") || fieldName.toLowerCase().contains("email")) {
            if (!EMAIL_PATTERN.matcher(strValue).matches()) {
                return new ValidationResult(false,
                    String.format("字段 '%s' 邮箱格式不正确：%s", fieldName, strValue),
                    "请输入有效的邮箱地址，如：example@domain.com",
                    "INVALID_EMAIL_FORMAT");
            }
        } else if (fieldName.contains("电话") || fieldName.contains("手机") || 
                   fieldName.toLowerCase().contains("phone")) {
            if (!PHONE_PATTERN.matcher(strValue).matches()) {
                return new ValidationResult(false,
                    String.format("字段 '%s' 电话号码格式不正确：%s", fieldName, strValue),
                    "请输入有效的电话号码，如：13812345678 或 010-12345678",
                    "INVALID_PHONE_FORMAT");
            }
        } else if (fieldName.contains("CAS") || fieldName.toLowerCase().contains("cas")) {
            if (!CAS_PATTERN.matcher(strValue).matches()) {
                return new ValidationResult(false,
                    String.format("字段 '%s' CAS号格式不正确：%s", fieldName, strValue),
                    "请输入有效的CAS号，格式如：64-17-5",
                    "INVALID_CAS_FORMAT");
            }
        }
        
        return new ValidationResult(true);
    }
    
    /**
     * 数值范围校验
     */
    public ValidationResult validateNumberRange(Object value, Field field) {
        if (value == null) {
            return new ValidationResult(true);
        }
        
        String strValue = value.toString().trim();
        if (strValue.isEmpty()) {
            return new ValidationResult(true);
        }
        
        Excel excelAnnotation = field.getAnnotation(Excel.class);
        String fieldName = excelAnnotation != null ? excelAnnotation.name() : field.getName();
        
        // 检查是否为数字类型字段
        Class<?> fieldType = field.getType();
        if (fieldType == Integer.class || fieldType == int.class ||
            fieldType == Long.class || fieldType == long.class ||
            fieldType == Double.class || fieldType == double.class ||
            fieldType == Float.class || fieldType == float.class) {
            
            try {
                double numValue = Double.parseDouble(strValue);
                
                // 根据字段名判断合理范围
                if (fieldName.contains("百分比") || fieldName.contains("比例")) {
                    if (numValue < 0 || numValue > 100) {
                        return new ValidationResult(false,
                            String.format("字段 '%s' 的值 %s 超出合理范围", fieldName, strValue),
                            "百分比应在 0-100 之间",
                            "NUMBER_OUT_OF_RANGE");
                    }
                } else if (fieldName.contains("温度")) {
                    if (numValue < -273.15 || numValue > 1000) {
                        return new ValidationResult(false,
                            String.format("字段 '%s' 的值 %s 超出合理范围", fieldName, strValue),
                            "温度应在 -273.15°C 到 1000°C 之间",
                            "TEMPERATURE_OUT_OF_RANGE");
                    }
                } else if (fieldName.contains("pH")) {
                    if (numValue < 0 || numValue > 14) {
                        return new ValidationResult(false,
                            String.format("字段 '%s' 的值 %s 超出合理范围", fieldName, strValue),
                            "pH值应在 0-14 之间",
                            "PH_OUT_OF_RANGE");
                    }
                }
            } catch (NumberFormatException e) {
                return new ValidationResult(false,
                    String.format("字段 '%s' 的值 '%s' 不是有效数字", fieldName, strValue),
                    "请输入有效的数字值",
                    "INVALID_NUMBER_FORMAT");
            }
        }
        
        return new ValidationResult(true);
    }
    
    /**
     * 综合字段校验
     */
    public List<ValidationResult> validateField(Object value, Field field) {
        List<ValidationResult> results = new ArrayList<>();
        
        // 必填校验
        ValidationResult requiredResult = validateRequired(value, field);
        if (!requiredResult.isValid()) {
            results.add(requiredResult);
            return results; // 必填校验失败，不继续其他校验
        }
        
        // 如果值为空且非必填，跳过其他校验
        if (value == null || (value instanceof String && ((String) value).trim().isEmpty())) {
            return results;
        }
        
        // 长度校验
        ValidationResult lengthResult = validateLength(value, field);
        if (!lengthResult.isValid()) {
            results.add(lengthResult);
        }
        
        // 数据类型校验
        ValidationResult typeResult = validateDataType(value, field);
        if (!typeResult.isValid()) {
            results.add(typeResult);
        }
        
        // 枚举值校验
        ValidationResult enumResult = validateEnumValue(value, field);
        if (!enumResult.isValid()) {
            results.add(enumResult);
        }
        
        // 格式校验
        ValidationResult formatResult = validateFormat(value, field);
        if (!formatResult.isValid()) {
            results.add(formatResult);
        }
        
        // 数值范围校验
        ValidationResult rangeResult = validateNumberRange(value, field);
        if (!rangeResult.isValid()) {
            results.add(rangeResult);
        }
        
        return results;
    }
    
    /**
     * 检查日期格式是否有效
     */
    private boolean isValidDate(String dateStr) {
        for (String format : DATE_FORMATS) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat(format);
                sdf.setLenient(false);
                sdf.parse(dateStr);
                return true;
            } catch (ParseException e) {
                // 继续尝试下一个格式
            }
        }
        return false;
    }
    
    /**
     * 在候选值中找到最佳匹配
     */
    private String findBestMatch(String input, List<String> candidates) {
        String bestMatch = null;
        double bestSimilarity = 0.0;
        
        for (String candidate : candidates) {
            double similarity = calculateSimilarity(input.toLowerCase(), candidate.toLowerCase());
            if (similarity > bestSimilarity && similarity > 0.6) {
                bestSimilarity = similarity;
                bestMatch = candidate;
            }
        }
        
        return bestMatch;
    }
    
    /**
     * 计算字符串相似度
     */
    private double calculateSimilarity(String str1, String str2) {
        if (str1.equals(str2)) return 1.0;
        
        int maxLength = Math.max(str1.length(), str2.length());
        if (maxLength == 0) return 1.0;
        
        int editDistance = calculateEditDistance(str1, str2);
        return 1.0 - (double) editDistance / maxLength;
    }
    
    /**
     * 计算编辑距离
     */
    private int calculateEditDistance(String str1, String str2) {
        int m = str1.length();
        int n = str2.length();
        
        int[][] dp = new int[m + 1][n + 1];
        
        for (int i = 0; i <= m; i++) {
            dp[i][0] = i;
        }
        for (int j = 0; j <= n; j++) {
            dp[0][j] = j;
        }
        
        for (int i = 1; i <= m; i++) {
            for (int j = 1; j <= n; j++) {
                if (str1.charAt(i - 1) == str2.charAt(j - 1)) {
                    dp[i][j] = dp[i - 1][j - 1];
                } else {
                    dp[i][j] = Math.min(
                        Math.min(dp[i - 1][j] + 1, dp[i][j - 1] + 1),
                        dp[i - 1][j - 1] + 1
                    );
                }
            }
        }
        
        return dp[m][n];
    }
}