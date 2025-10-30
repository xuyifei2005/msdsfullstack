package com.ruoyi.system.service.impl;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.system.service.IColumnMappingService;
import org.springframework.stereotype.Service;

import java.lang.reflect.Field;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 列头映射服务实现类
 * 
 * @author ruoyi
 */
@Service
public class ColumnMappingServiceImpl implements IColumnMappingService {
    
    // 相似度阈值
    private static final double SIMILARITY_THRESHOLD = 0.6;
    private static final double HIGH_SIMILARITY_THRESHOLD = 0.8;
    
    // 常见别名映射
    private static final Map<String, String[]> COMMON_ALIASES = new HashMap<>();
    
    static {
        // 初始化常见别名映射
        COMMON_ALIASES.put("productName", new String[]{"产品名称", "化学品名称", "中文名", "产品中文名", "Product Name", "Chemical Name"});
        COMMON_ALIASES.put("productEnglishName", new String[]{"英文名", "产品英文名", "English Name", "Product English Name"});
        COMMON_ALIASES.put("productAlias", new String[]{"化学品别名", "中文别名", "别名", "Alias", "别名(中文)", "中文别名(化学品)"});
        COMMON_ALIASES.put("casNumber", new String[]{"CAS号", "CAS", "CAS Number", "CAS NO"});
        COMMON_ALIASES.put("companyName", new String[]{"企业名称", "公司名称", "Company Name", "Enterprise Name"});
        COMMON_ALIASES.put("versionNumber", new String[]{"版本号", "Version", "Version Number"});
        COMMON_ALIASES.put("createTime", new String[]{"创建时间", "Create Time", "Creation Date"});
        COMMON_ALIASES.put("updateTime", new String[]{"更新时间", "Update Time", "Modification Date"});
    }
    
    @Override
    public ColumnMappingResult mapColumns(List<String> excelHeaders, Class<?> targetClass) {
        ColumnMappingResult result = new ColumnMappingResult();
        
        // 获取目标类的字段信息
        Map<String, FieldInfo> fieldInfoMap = getFieldInfoMap(targetClass);
        List<String> availableFields = new ArrayList<>(fieldInfoMap.keySet());
        
        // 初始化结果对象
        Map<String, String> mappedColumns = new HashMap<>();
        List<String> unmappedColumns = new ArrayList<>();
        List<String> missingRequiredColumns = new ArrayList<>();
        Map<String, List<String>> suggestions = new HashMap<>();
        
        // 执行列头映射
        for (String excelHeader : excelHeaders) {
            MatchResult matchResult = matchSingleColumn(excelHeader, availableFields);
            
            if (matchResult != null && matchResult.getSimilarity() >= SIMILARITY_THRESHOLD) {
                mappedColumns.put(excelHeader, matchResult.getFieldName());
                availableFields.remove(matchResult.getFieldName());
            } else {
                unmappedColumns.add(excelHeader);
                // 生成建议
                List<String> columnSuggestions = generateColumnSuggestions(excelHeader, availableFields);
                if (!columnSuggestions.isEmpty()) {
                    suggestions.put(excelHeader, columnSuggestions);
                }
            }
        }
        
        // 检查缺失的必填字段
        for (String fieldName : availableFields) {
            FieldInfo fieldInfo = fieldInfoMap.get(fieldName);
            if (fieldInfo != null && fieldInfo.isRequired()) {
                missingRequiredColumns.add(fieldName);
            }
        }
        
        // 计算映射准确率
        double mappingAccuracy = (double) mappedColumns.size() / excelHeaders.size();
        
        // 设置结果
        result.setMappedColumns(mappedColumns);
        result.setUnmappedColumns(unmappedColumns);
        result.setMissingRequiredColumns(missingRequiredColumns);
        result.setSuggestions(suggestions);
        result.setMappingAccuracy(mappingAccuracy);
        
        return result;
    }
    
    @Override
    public Map<String, FieldInfo> getFieldInfoMap(Class<?> targetClass) {
        Map<String, FieldInfo> fieldInfoMap = new HashMap<>();
        
        Field[] fields = targetClass.getDeclaredFields();
        for (Field field : fields) {
            Excel excelAnnotation = field.getAnnotation(Excel.class);
            if (excelAnnotation != null) {
                FieldInfo fieldInfo = new FieldInfo();
                fieldInfo.setFieldName(field.getName());
                fieldInfo.setDisplayName(excelAnnotation.name());
                fieldInfo.setRequired(true); // 默认设置为必填，可根据业务需求调整
                fieldInfo.setDataType(field.getType().getSimpleName());
                
                // 设置枚举值
                if (!excelAnnotation.readConverterExp().isEmpty()) {
                    String[] enumPairs = excelAnnotation.readConverterExp().split(",");
                    List<String> enumValues = new ArrayList<>();
                    for (String pair : enumPairs) {
                        if (pair.contains("=")) {
                            enumValues.add(pair.split("=")[0]);
                        }
                    }
                    fieldInfo.setEnumValues(enumValues.toArray(new String[0]));
                }
                
                // 设置组合框选项
                if (excelAnnotation.combo().length > 0) {
                    fieldInfo.setEnumValues(excelAnnotation.combo());
                }
                
                fieldInfoMap.put(field.getName(), fieldInfo);
            }
        }
        
        return fieldInfoMap;
    }
    
    @Override
    public MatchResult matchSingleColumn(String excelHeader, List<String> availableFields) {
        if (excelHeader == null || excelHeader.trim().isEmpty()) {
            return null;
        }
        
        String normalizedHeader = normalizeString(excelHeader);
        MatchResult bestMatch = null;
        double bestSimilarity = 0.0;
        
        for (String fieldName : availableFields) {
            // 检查别名匹配
            String[] aliases = COMMON_ALIASES.get(fieldName);
            if (aliases != null) {
                for (String alias : aliases) {
                    double similarity = calculateSimilarity(normalizedHeader, normalizeString(alias));
                    if (similarity > bestSimilarity) {
                        bestSimilarity = similarity;
                        bestMatch = new MatchResult(fieldName, similarity, 
                            similarity >= HIGH_SIMILARITY_THRESHOLD ? "EXACT" : "FUZZY");
                    }
                }
            }
            
            // 直接字段名匹配
            double fieldSimilarity = calculateSimilarity(normalizedHeader, normalizeString(fieldName));
            if (fieldSimilarity > bestSimilarity) {
                bestSimilarity = fieldSimilarity;
                bestMatch = new MatchResult(fieldName, fieldSimilarity, 
                    fieldSimilarity >= HIGH_SIMILARITY_THRESHOLD ? "EXACT" : "FUZZY");
            }
        }
        
        return bestMatch;
    }
    
    @Override
    public Map<String, List<String>> generateMappingSuggestions(List<String> unmappedHeaders, List<String> availableFields) {
        Map<String, List<String>> suggestions = new HashMap<>();
        
        for (String header : unmappedHeaders) {
            List<String> columnSuggestions = generateColumnSuggestions(header, availableFields);
            if (!columnSuggestions.isEmpty()) {
                suggestions.put(header, columnSuggestions);
            }
        }
        
        return suggestions;
    }
    
    /**
     * 为单个列头生成建议
     */
    private List<String> generateColumnSuggestions(String excelHeader, List<String> availableFields) {
        List<MatchResult> matches = new ArrayList<>();
        String normalizedHeader = normalizeString(excelHeader);
        
        for (String fieldName : availableFields) {
            // 检查别名匹配
            String[] aliases = COMMON_ALIASES.get(fieldName);
            if (aliases != null) {
                for (String alias : aliases) {
                    double similarity = calculateSimilarity(normalizedHeader, normalizeString(alias));
                    if (similarity > 0.3) { // 降低建议阈值
                        matches.add(new MatchResult(fieldName, similarity, "ALIAS"));
                        break; // 每个字段只添加一次
                    }
                }
            }
            
            // 直接字段名匹配
            double fieldSimilarity = calculateSimilarity(normalizedHeader, normalizeString(fieldName));
            if (fieldSimilarity > 0.3) {
                matches.add(new MatchResult(fieldName, fieldSimilarity, "FIELD"));
            }
        }
        
        // 按相似度排序并返回前3个建议
        return matches.stream()
                .sorted((a, b) -> Double.compare(b.getSimilarity(), a.getSimilarity()))
                .limit(3)
                .map(MatchResult::getFieldName)
                .collect(Collectors.toList());
    }
    
    /**
     * 字符串标准化
     */
    private String normalizeString(String str) {
        if (str == null) return "";
        
        return str.trim()
                .toLowerCase()
                .replaceAll("[\\s\\-_]+", "")  // 移除空格、横线、下划线
                .replaceAll("[（）()\\[\\]【】]", "")  // 移除括号
                .replaceAll("[：:]", "");  // 移除冒号
    }
    
    /**
     * 计算字符串相似度（使用编辑距离算法）
     */
    private double calculateSimilarity(String str1, String str2) {
        if (str1 == null || str2 == null) return 0.0;
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
        
        // 初始化
        for (int i = 0; i <= m; i++) {
            dp[i][0] = i;
        }
        for (int j = 0; j <= n; j++) {
            dp[0][j] = j;
        }
        
        // 动态规划计算编辑距离
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