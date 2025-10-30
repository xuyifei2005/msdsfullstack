package com.ruoyi.system.service;

import java.util.List;
import java.util.Map;

/**
 * 列头映射服务接口
 * 提供Excel导入时的列头匹配、字段映射和校验建议功能
 * 
 * @author ruoyi
 */
public interface IColumnMappingService {
    
    /**
     * 列头映射结果
     */
    class ColumnMappingResult {
        private Map<String, String> mappedColumns;        // 成功映射的列：Excel列名 -> 数据库字段名
        private List<String> unmappedColumns;             // 未映射的Excel列名
        private List<String> missingRequiredColumns;      // 缺失的必填列
        private Map<String, List<String>> suggestions;    // 映射建议：Excel列名 -> 候选字段名列表
        private double mappingAccuracy;                   // 映射准确率
        
        // Getters and Setters
        public Map<String, String> getMappedColumns() { return mappedColumns; }
        public void setMappedColumns(Map<String, String> mappedColumns) { this.mappedColumns = mappedColumns; }
        
        public List<String> getUnmappedColumns() { return unmappedColumns; }
        public void setUnmappedColumns(List<String> unmappedColumns) { this.unmappedColumns = unmappedColumns; }
        
        public List<String> getMissingRequiredColumns() { return missingRequiredColumns; }
        public void setMissingRequiredColumns(List<String> missingRequiredColumns) { this.missingRequiredColumns = missingRequiredColumns; }
        
        public Map<String, List<String>> getSuggestions() { return suggestions; }
        public void setSuggestions(Map<String, List<String>> suggestions) { this.suggestions = suggestions; }
        
        public double getMappingAccuracy() { return mappingAccuracy; }
        public void setMappingAccuracy(double mappingAccuracy) { this.mappingAccuracy = mappingAccuracy; }
    }
    
    /**
     * 执行列头映射
     * 
     * @param excelHeaders Excel文件中的列头列表
     * @param targetClass 目标实体类
     * @return 列头映射结果
     */
    ColumnMappingResult mapColumns(List<String> excelHeaders, Class<?> targetClass);
    
    /**
     * 获取实体类的所有可映射字段信息
     * 
     * @param targetClass 目标实体类
     * @return 字段信息映射：字段名 -> 字段描述信息
     */
    Map<String, FieldInfo> getFieldInfoMap(Class<?> targetClass);
    
    /**
     * 智能匹配单个列头
     * 
     * @param excelHeader Excel列头
     * @param availableFields 可用字段列表
     * @return 匹配结果：字段名和匹配度
     */
    MatchResult matchSingleColumn(String excelHeader, List<String> availableFields);
    
    /**
     * 生成列头映射建议
     * 
     * @param unmappedHeaders 未映射的列头
     * @param availableFields 可用字段
     * @return 映射建议
     */
    Map<String, List<String>> generateMappingSuggestions(List<String> unmappedHeaders, List<String> availableFields);
    
    /**
     * 字段信息类
     */
    class FieldInfo {
        private String fieldName;          // 字段名
        private String displayName;        // 显示名称（中文）
        private String englishName;        // 英文名称
        private String description;        // 字段描述
        private boolean required;          // 是否必填
        private String dataType;          // 数据类型
        private Integer maxLength;        // 最大长度
        private String[] enumValues;      // 枚举值
        private String format;            // 格式要求
        
        // Constructors
        public FieldInfo() {}
        
        public FieldInfo(String fieldName, String displayName, String englishName, boolean required) {
            this.fieldName = fieldName;
            this.displayName = displayName;
            this.englishName = englishName;
            this.required = required;
        }
        
        // Getters and Setters
        public String getFieldName() { return fieldName; }
        public void setFieldName(String fieldName) { this.fieldName = fieldName; }
        
        public String getDisplayName() { return displayName; }
        public void setDisplayName(String displayName) { this.displayName = displayName; }
        
        public String getEnglishName() { return englishName; }
        public void setEnglishName(String englishName) { this.englishName = englishName; }
        
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
        
        public boolean isRequired() { return required; }
        public void setRequired(boolean required) { this.required = required; }
        
        public String getDataType() { return dataType; }
        public void setDataType(String dataType) { this.dataType = dataType; }
        
        public Integer getMaxLength() { return maxLength; }
        public void setMaxLength(Integer maxLength) { this.maxLength = maxLength; }
        
        public String[] getEnumValues() { return enumValues; }
        public void setEnumValues(String[] enumValues) { this.enumValues = enumValues; }
        
        public String getFormat() { return format; }
        public void setFormat(String format) { this.format = format; }
    }
    
    /**
     * 匹配结果类
     */
    class MatchResult {
        private String fieldName;      // 匹配的字段名
        private double similarity;     // 相似度 (0-1)
        private String matchType;      // 匹配类型：EXACT, FUZZY, ALIAS
        
        public MatchResult() {}
        
        public MatchResult(String fieldName, double similarity, String matchType) {
            this.fieldName = fieldName;
            this.similarity = similarity;
            this.matchType = matchType;
        }
        
        // Getters and Setters
        public String getFieldName() { return fieldName; }
        public void setFieldName(String fieldName) { this.fieldName = fieldName; }
        
        public double getSimilarity() { return similarity; }
        public void setSimilarity(double similarity) { this.similarity = similarity; }
        
        public String getMatchType() { return matchType; }
        public void setMatchType(String matchType) { this.matchType = matchType; }
    }
}