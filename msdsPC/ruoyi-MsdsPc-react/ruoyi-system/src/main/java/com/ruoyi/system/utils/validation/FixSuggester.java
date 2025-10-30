package com.ruoyi.system.utils.validation;

import com.ruoyi.common.annotation.Excel;
import org.springframework.stereotype.Component;

import java.lang.reflect.Field;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Pattern;

/**
 * 自动修复建议器
 * 为校验错误提供智能修复建议和自动修复功能
 * 
 * @author ruoyi
 */
@Component
public class FixSuggester {
    
    // 常用日期格式
    private static final String[] DATE_FORMATS = {
        "yyyy-MM-dd", "yyyy/MM/dd", "yyyy-MM-dd HH:mm:ss", 
        "yyyy/MM/dd HH:mm:ss", "dd/MM/yyyy", "MM/dd/yyyy",
        "yyyy年MM月dd日", "yyyy.MM.dd"
    };
    
    // 标准日期格式
    private static final String STANDARD_DATE_FORMAT = "yyyy-MM-dd";
    
    // 常见错误映射
    private static final Map<String, String> COMMON_FIXES = new HashMap<>();
    
    static {
        // 常见拼写错误修正
        COMMON_FIXES.put("是", "是");
        COMMON_FIXES.put("否", "否");
        COMMON_FIXES.put("有", "有");
        COMMON_FIXES.put("无", "无");
        COMMON_FIXES.put("yes", "是");
        COMMON_FIXES.put("no", "否");
        COMMON_FIXES.put("true", "是");
        COMMON_FIXES.put("false", "否");
        COMMON_FIXES.put("1", "是");
        COMMON_FIXES.put("0", "否");
    }
    
    /**
     * 修复建议结果
     */
    public static class FixSuggestion {
        private String originalValue;
        private String suggestedValue;
        private String fixType;
        private String description;
        private double confidence;
        private boolean autoFixable;
        
        public FixSuggestion(String originalValue, String suggestedValue, String fixType, String description) {
            this.originalValue = originalValue;
            this.suggestedValue = suggestedValue;
            this.fixType = fixType;
            this.description = description;
            this.confidence = 1.0;
            this.autoFixable = true;
        }
        
        public FixSuggestion(String originalValue, String suggestedValue, String fixType, String description, double confidence) {
            this.originalValue = originalValue;
            this.suggestedValue = suggestedValue;
            this.fixType = fixType;
            this.description = description;
            this.confidence = confidence;
            this.autoFixable = confidence > 0.8;
        }
        
        // Getters and Setters
        public String getOriginalValue() { return originalValue; }
        public void setOriginalValue(String originalValue) { this.originalValue = originalValue; }
        
        public String getSuggestedValue() { return suggestedValue; }
        public void setSuggestedValue(String suggestedValue) { this.suggestedValue = suggestedValue; }
        
        public String getFixType() { return fixType; }
        public void setFixType(String fixType) { this.fixType = fixType; }
        
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
        
        public double getConfidence() { return confidence; }
        public void setConfidence(double confidence) { this.confidence = confidence; }
        
        public boolean isAutoFixable() { return autoFixable; }
        public void setAutoFixable(boolean autoFixable) { this.autoFixable = autoFixable; }
    }
    
    /**
     * 生成修复建议
     */
    public List<FixSuggestion> generateFixSuggestions(String value, Field field, String errorCode) {
        List<FixSuggestion> suggestions = new ArrayList<>();
        
        if (value == null) {
            return suggestions;
        }
        
        switch (errorCode) {
            case "REQUIRED_FIELD_MISSING":
                suggestions.addAll(generateRequiredFieldSuggestions(value, field));
                break;
            case "FIELD_LENGTH_EXCEEDED":
                suggestions.addAll(generateLengthFixSuggestions(value, field));
                break;
            case "INVALID_DATE_FORMAT":
                suggestions.addAll(generateDateFormatSuggestions(value, field));
                break;
            case "INVALID_NUMBER_FORMAT":
                suggestions.addAll(generateNumberFormatSuggestions(value, field));
                break;
            case "INVALID_ENUM_VALUE":
                suggestions.addAll(generateEnumValueSuggestions(value, field));
                break;
            case "INVALID_EMAIL_FORMAT":
                suggestions.addAll(generateEmailFormatSuggestions(value, field));
                break;
            case "INVALID_PHONE_FORMAT":
                suggestions.addAll(generatePhoneFormatSuggestions(value, field));
                break;
            case "INVALID_CAS_FORMAT":
                suggestions.addAll(generateCasFormatSuggestions(value, field));
                break;
            default:
                suggestions.addAll(generateGeneralSuggestions(value, field));
                break;
        }
        
        return suggestions;
    }
    
    /**
     * 自动修复值
     */
    public String autoFixValue(String value, Field field, String errorCode) {
        List<FixSuggestion> suggestions = generateFixSuggestions(value, field, errorCode);
        
        // 返回置信度最高且可自动修复的建议
        return suggestions.stream()
                .filter(FixSuggestion::isAutoFixable)
                .max(Comparator.comparing(FixSuggestion::getConfidence))
                .map(FixSuggestion::getSuggestedValue)
                .orElse(value);
    }
    
    /**
     * 生成必填字段建议
     */
    private List<FixSuggestion> generateRequiredFieldSuggestions(String value, Field field) {
        List<FixSuggestion> suggestions = new ArrayList<>();
        Excel excelAnnotation = field.getAnnotation(Excel.class);
        String fieldName = excelAnnotation != null ? excelAnnotation.name() : field.getName();
        
        // 根据字段类型提供默认值建议
        Class<?> fieldType = field.getType();
        if (fieldType == String.class) {
            if (fieldName.contains("名称") || fieldName.contains("Name")) {
                suggestions.add(new FixSuggestion(value, "待填写", "DEFAULT_VALUE", "提供默认占位符", 0.7));
            } else if (fieldName.contains("状态") || fieldName.contains("Status")) {
                suggestions.add(new FixSuggestion(value, "正常", "DEFAULT_VALUE", "设置默认状态", 0.8));
            }
        } else if (fieldType == Integer.class || fieldType == int.class) {
            suggestions.add(new FixSuggestion(value, "0", "DEFAULT_VALUE", "设置默认数值", 0.7));
        } else if (fieldType == Date.class) {
            String currentDate = new SimpleDateFormat(STANDARD_DATE_FORMAT).format(new Date());
            suggestions.add(new FixSuggestion(value, currentDate, "DEFAULT_VALUE", "使用当前日期", 0.6));
        }
        
        return suggestions;
    }
    
    /**
     * 生成长度修复建议
     */
    private List<FixSuggestion> generateLengthFixSuggestions(String value, Field field) {
        List<FixSuggestion> suggestions = new ArrayList<>();
        Excel excelAnnotation = field.getAnnotation(Excel.class);
        
        if (excelAnnotation != null && excelAnnotation.width() > 0) {
            int maxLength = (int) excelAnnotation.width();
            if (value.length() > maxLength) {
                // 截断建议
                String truncated = value.substring(0, maxLength);
                suggestions.add(new FixSuggestion(value, truncated, "TRUNCATE", 
                    String.format("截断至 %d 个字符", maxLength), 0.9));
                
                // 智能截断（保留重要信息）
                String smartTruncated = smartTruncate(value, maxLength);
                if (!smartTruncated.equals(truncated)) {
                    suggestions.add(new FixSuggestion(value, smartTruncated, "SMART_TRUNCATE", 
                        "智能截断，保留关键信息", 0.95));
                }
            }
        }
        
        return suggestions;
    }
    
    /**
     * 生成日期格式建议
     */
    private List<FixSuggestion> generateDateFormatSuggestions(String value, Field field) {
        List<FixSuggestion> suggestions = new ArrayList<>();
        
        // 尝试解析各种日期格式并转换为标准格式
        for (String format : DATE_FORMATS) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat(format);
                sdf.setLenient(false);
                Date date = sdf.parse(value);
                
                SimpleDateFormat standardSdf = new SimpleDateFormat(STANDARD_DATE_FORMAT);
                String standardDate = standardSdf.format(date);
                
                suggestions.add(new FixSuggestion(value, standardDate, "DATE_FORMAT_CONVERSION", 
                    String.format("将 %s 格式转换为标准格式 %s", format, STANDARD_DATE_FORMAT), 0.95));
                break; // 找到第一个匹配的格式就停止
            } catch (ParseException e) {
                // 继续尝试下一个格式
            }
        }
        
        // 如果无法解析，提供常见修复建议
        if (suggestions.isEmpty()) {
            // 移除多余字符
            String cleaned = value.replaceAll("[^0-9\\-/年月日.]", "");
            if (!cleaned.equals(value)) {
                suggestions.add(new FixSuggestion(value, cleaned, "CLEAN_DATE", 
                    "移除日期中的无效字符", 0.7));
            }
            
            // 提供示例
            String currentDate = new SimpleDateFormat(STANDARD_DATE_FORMAT).format(new Date());
            suggestions.add(new FixSuggestion(value, currentDate, "DATE_EXAMPLE", 
                "使用标准日期格式示例", 0.5));
        }
        
        return suggestions;
    }
    
    /**
     * 生成数字格式建议
     */
    private List<FixSuggestion> generateNumberFormatSuggestions(String value, Field field) {
        List<FixSuggestion> suggestions = new ArrayList<>();
        
        // 移除非数字字符（保留小数点和负号）
        String cleaned = value.replaceAll("[^0-9.\\-]", "");
        if (!cleaned.equals(value) && !cleaned.isEmpty()) {
            suggestions.add(new FixSuggestion(value, cleaned, "CLEAN_NUMBER", 
                "移除数字中的无效字符", 0.9));
        }
        
        // 处理中文数字
        String chineseConverted = convertChineseNumbers(value);
        if (!chineseConverted.equals(value)) {
            suggestions.add(new FixSuggestion(value, chineseConverted, "CHINESE_NUMBER_CONVERSION", 
                "将中文数字转换为阿拉伯数字", 0.85));
        }
        
        // 处理百分比
        if (value.contains("%")) {
            String percentValue = value.replace("%", "").trim();
            try {
                double num = Double.parseDouble(percentValue);
                suggestions.add(new FixSuggestion(value, String.valueOf(num), "PERCENT_CONVERSION", 
                    "移除百分号，保留数值", 0.8));
            } catch (NumberFormatException e) {
                // 忽略
            }
        }
        
        return suggestions;
    }
    
    /**
     * 生成枚举值建议
     */
    private List<FixSuggestion> generateEnumValueSuggestions(String value, Field field) {
        List<FixSuggestion> suggestions = new ArrayList<>();
        Excel excelAnnotation = field.getAnnotation(Excel.class);
        
        if (excelAnnotation == null) {
            return suggestions;
        }
        
        List<String> validValues = new ArrayList<>();
        
        // 收集所有有效枚举值
        if (!excelAnnotation.readConverterExp().isEmpty()) {
            String[] enumPairs = excelAnnotation.readConverterExp().split(",");
            for (String pair : enumPairs) {
                if (pair.contains("=")) {
                    String key = pair.split("=")[0].trim();
                    String val = pair.split("=")[1].trim();
                    validValues.add(key);
                    validValues.add(val);
                }
            }
        }
        
        if (excelAnnotation.combo().length > 0) {
            String[] comboValues = excelAnnotation.combo();
            for (String comboValue : comboValues) {
                validValues.add(comboValue.trim());
            }
        }
        
        // 查找最相似的枚举值
        String bestMatch = findBestMatch(value, validValues);
        if (bestMatch != null) {
            double similarity = calculateSimilarity(value.toLowerCase(), bestMatch.toLowerCase());
            suggestions.add(new FixSuggestion(value, bestMatch, "ENUM_FUZZY_MATCH", 
                String.format("模糊匹配到最相似的枚举值（相似度：%.2f）", similarity), similarity));
        }
        
        // 常见映射修复
        String commonFix = COMMON_FIXES.get(value.toLowerCase().trim());
        if (commonFix != null && validValues.contains(commonFix)) {
            suggestions.add(new FixSuggestion(value, commonFix, "COMMON_MAPPING", 
                "使用常见值映射", 0.95));
        }
        
        return suggestions;
    }
    
    /**
     * 生成邮箱格式建议
     */
    private List<FixSuggestion> generateEmailFormatSuggestions(String value, Field field) {
        List<FixSuggestion> suggestions = new ArrayList<>();
        
        // 移除空格
        String trimmed = value.trim().replaceAll("\\s+", "");
        if (!trimmed.equals(value)) {
            suggestions.add(new FixSuggestion(value, trimmed, "TRIM_SPACES", 
                "移除邮箱中的空格", 0.9));
        }
        
        // 常见域名修正
        String corrected = trimmed;
        corrected = corrected.replaceAll("@gmial\\.", "@gmail.");
        corrected = corrected.replaceAll("@163\\.", "@163.com");
        corrected = corrected.replaceAll("@qq\\.", "@qq.com");
        
        if (!corrected.equals(trimmed)) {
            suggestions.add(new FixSuggestion(value, corrected, "DOMAIN_CORRECTION", 
                "修正常见域名拼写错误", 0.85));
        }
        
        return suggestions;
    }
    
    /**
     * 生成电话格式建议
     */
    private List<FixSuggestion> generatePhoneFormatSuggestions(String value, Field field) {
        List<FixSuggestion> suggestions = new ArrayList<>();
        
        // 移除非数字字符（保留连字符）
        String cleaned = value.replaceAll("[^0-9\\-]", "");
        if (!cleaned.equals(value)) {
            suggestions.add(new FixSuggestion(value, cleaned, "CLEAN_PHONE", 
                "移除电话号码中的无效字符", 0.9));
        }
        
        // 标准化手机号格式
        String digitsOnly = value.replaceAll("[^0-9]", "");
        if (digitsOnly.length() == 11 && digitsOnly.startsWith("1")) {
            suggestions.add(new FixSuggestion(value, digitsOnly, "MOBILE_FORMAT", 
                "标准化手机号格式", 0.95));
        }
        
        return suggestions;
    }
    
    /**
     * 生成CAS号格式建议
     */
    private List<FixSuggestion> generateCasFormatSuggestions(String value, Field field) {
        List<FixSuggestion> suggestions = new ArrayList<>();
        
        // 移除空格和其他无效字符
        String cleaned = value.trim().replaceAll("[^0-9\\-]", "");
        if (!cleaned.equals(value)) {
            suggestions.add(new FixSuggestion(value, cleaned, "CLEAN_CAS", 
                "移除CAS号中的无效字符", 0.9));
        }
        
        // 尝试修复CAS号格式
        String digitsOnly = value.replaceAll("[^0-9]", "");
        if (digitsOnly.length() >= 5) {
            // 尝试构造标准CAS号格式
            String formatted = formatCasNumber(digitsOnly);
            if (formatted != null) {
                suggestions.add(new FixSuggestion(value, formatted, "CAS_FORMAT", 
                    "格式化为标准CAS号", 0.8));
            }
        }
        
        return suggestions;
    }
    
    /**
     * 生成通用建议
     */
    private List<FixSuggestion> generateGeneralSuggestions(String value, Field field) {
        List<FixSuggestion> suggestions = new ArrayList<>();
        
        // 去除首尾空格
        String trimmed = value.trim();
        if (!trimmed.equals(value)) {
            suggestions.add(new FixSuggestion(value, trimmed, "TRIM", 
                "移除首尾空格", 1.0));
        }
        
        // 统一大小写
        Excel excelAnnotation = field.getAnnotation(Excel.class);
        String fieldName = excelAnnotation != null ? excelAnnotation.name() : field.getName();
        
        if (fieldName.toLowerCase().contains("email") || fieldName.contains("邮箱")) {
            String lowercase = trimmed.toLowerCase();
            if (!lowercase.equals(trimmed)) {
                suggestions.add(new FixSuggestion(value, lowercase, "LOWERCASE", 
                    "邮箱地址转换为小写", 0.9));
            }
        }
        
        return suggestions;
    }
    
    /**
     * 智能截断文本
     */
    private String smartTruncate(String text, int maxLength) {
        if (text.length() <= maxLength) {
            return text;
        }
        
        // 尝试在单词边界截断
        int lastSpace = text.lastIndexOf(' ', maxLength);
        if (lastSpace > maxLength * 0.8) {
            return text.substring(0, lastSpace);
        }
        
        // 尝试在标点符号处截断
        String punctuation = ".,;:!?";
        for (int i = maxLength - 1; i >= maxLength * 0.8; i--) {
            if (punctuation.indexOf(text.charAt(i)) >= 0) {
                return text.substring(0, i + 1);
            }
        }
        
        // 默认截断
        return text.substring(0, maxLength);
    }
    
    /**
     * 转换中文数字
     */
    private String convertChineseNumbers(String text) {
        Map<String, String> chineseNumbers = new HashMap<>();
        chineseNumbers.put("一", "1");
        chineseNumbers.put("二", "2");
        chineseNumbers.put("三", "3");
        chineseNumbers.put("四", "4");
        chineseNumbers.put("五", "5");
        chineseNumbers.put("六", "6");
        chineseNumbers.put("七", "7");
        chineseNumbers.put("八", "8");
        chineseNumbers.put("九", "9");
        chineseNumbers.put("零", "0");
        
        String result = text;
        for (Map.Entry<String, String> entry : chineseNumbers.entrySet()) {
            result = result.replace(entry.getKey(), entry.getValue());
        }
        
        return result;
    }
    
    /**
     * 格式化CAS号
     */
    private String formatCasNumber(String digits) {
        if (digits.length() < 5) {
            return null;
        }
        
        // 标准CAS号格式：XXXXXX-XX-X
        if (digits.length() >= 7) {
            String part1 = digits.substring(0, digits.length() - 3);
            String part2 = digits.substring(digits.length() - 3, digits.length() - 1);
            String part3 = digits.substring(digits.length() - 1);
            return part1 + "-" + part2 + "-" + part3;
        }
        
        return null;
    }
    
    /**
     * 在候选值中找到最佳匹配
     */
    private String findBestMatch(String input, List<String> candidates) {
        String bestMatch = null;
        double bestSimilarity = 0.0;
        
        for (String candidate : candidates) {
            double similarity = calculateSimilarity(input.toLowerCase(), candidate.toLowerCase());
            if (similarity > bestSimilarity && similarity > 0.5) {
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