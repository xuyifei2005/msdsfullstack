package com.ruoyi.system.service.impl;

import java.util.*;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ruoyi.system.mapper.MsdsMetadataMapper;
import com.ruoyi.system.service.IMsdsMetadataService;

/**
 * MSDS元数据抽取服务实现
 * 
 * @author ruoyi
 */
@Service
public class MsdsMetadataServiceImpl implements IMsdsMetadataService
{
    @Autowired
    private MsdsMetadataMapper msdsMetadataMapper;
    
    // MSDS相关表的分组定义
    private static final Map<String, List<String>> TABLE_GROUPS = new HashMap<>();
    
    static {
        TABLE_GROUPS.put("main", Arrays.asList("msds_main"));
        TABLE_GROUPS.put("exposure", Arrays.asList("msds_exposure_control"));
        TABLE_GROUPS.put("physical", Arrays.asList("msds_physical_chemical"));
        TABLE_GROUPS.put("basic", Arrays.asList(
            "msds_hazard_identification", "msds_composition_information", 
            "msds_first_aid_measures", "msds_fire_fighting_measures",
            "msds_accidental_release_measures", "msds_handling_storage",
            "msds_stability_reactivity", "msds_toxicological_information",
            "msds_ecological_information", "msds_disposal_considerations",
            "msds_transport_information", "msds_regulatory_information",
            "msds_other_information"
        ));
    }
    
    @Override
    public Map<String, Object> getTableMetadata(String tableName)
    {
        Map<String, Object> metadata = new HashMap<>();
        
        // 获取表基本信息
        Map<String, Object> tableInfo = msdsMetadataMapper.getTableInfo(tableName);
        if (tableInfo != null) {
            metadata.put("tableName", tableName);
            metadata.put("tableComment", tableInfo.get("table_comment"));
            metadata.put("engine", tableInfo.get("engine"));
            metadata.put("charset", tableInfo.get("table_collation"));
        }
        
        // 获取列信息
        List<Map<String, Object>> columns = getTableColumns(tableName);
        metadata.put("columns", columns);
        
        // 获取约束信息
        List<Map<String, Object>> constraints = getTableConstraints(tableName);
        metadata.put("constraints", constraints);
        
        // 获取索引信息
        List<Map<String, Object>> indexes = getTableIndexes(tableName);
        metadata.put("indexes", indexes);
        
        // 获取外键信息
        List<Map<String, Object>> foreignKeys = getTableForeignKeys(tableName);
        metadata.put("foreignKeys", foreignKeys);
        
        return metadata;
    }
    
    @Override
    public List<Map<String, Object>> getTableColumns(String tableName)
    {
        List<Map<String, Object>> columns = msdsMetadataMapper.getTableColumns(tableName);
        
        // 增强列信息，添加Java类型映射和校验规则
        for (Map<String, Object> column : columns) {
            enhanceColumnInfo(column);
        }
        
        return columns;
    }
    
    @Override
    public List<Map<String, Object>> getTableConstraints(String tableName)
    {
        return msdsMetadataMapper.getTableConstraints(tableName);
    }
    
    @Override
    public List<Map<String, Object>> getTableIndexes(String tableName)
    {
        return msdsMetadataMapper.getTableIndexes(tableName);
    }
    
    @Override
    public List<Map<String, Object>> getTableForeignKeys(String tableName)
    {
        return msdsMetadataMapper.getTableForeignKeys(tableName);
    }
    
    @Override
    public List<Map<String, Object>> getTableUniqueConstraints(String tableName)
    {
        return msdsMetadataMapper.getTableUniqueConstraints(tableName);
    }
    
    @Override
    public List<String> getMsdsTables()
    {
        List<String> allTables = new ArrayList<>();
        for (List<String> tables : TABLE_GROUPS.values()) {
            allTables.addAll(tables);
        }
        return allTables.stream().distinct().collect(Collectors.toList());
    }
    
    @Override
    public Map<String, Map<String, Object>> getTablesMetadata(String scope)
    {
        Map<String, Map<String, Object>> result = new HashMap<>();
        
        List<String> tables;
        if ("all".equals(scope)) {
            tables = getMsdsTables();
        } else {
            tables = TABLE_GROUPS.getOrDefault(scope, new ArrayList<>());
        }
        
        for (String tableName : tables) {
            // 检查表是否存在
            if (msdsMetadataMapper.tableExists(tableName)) {
                result.put(tableName, getTableMetadata(tableName));
            }
        }
        
        return result;
    }
    
    @Override
    public Map<String, String> getTableDictTypes(String tableName)
    {
        Map<String, String> dictTypes = new HashMap<>();
        
        // 根据表名和字段名推断字典类型
        List<Map<String, Object>> columns = getTableColumns(tableName);
        for (Map<String, Object> column : columns) {
            String columnName = (String) column.get("column_name");
            String dictType = inferDictType(tableName, columnName);
            if (dictType != null) {
                dictTypes.put(columnName, dictType);
            }
        }
        
        return dictTypes;
    }
    
    @Override
    public Map<String, List<String>> getTableEnumValues(String tableName)
    {
        Map<String, List<String>> enumValues = new HashMap<>();
        
        // 根据表名和字段名推断枚举值
        List<Map<String, Object>> columns = getTableColumns(tableName);
        for (Map<String, Object> column : columns) {
            String columnName = (String) column.get("column_name");
            List<String> values = inferEnumValues(tableName, columnName);
            if (values != null && !values.isEmpty()) {
                enumValues.put(columnName, values);
            }
        }
        
        return enumValues;
    }
    
    /**
     * 增强列信息
     */
    private void enhanceColumnInfo(Map<String, Object> column)
    {
        String columnType = (String) column.get("column_type");
        String dataType = (String) column.get("data_type");
        
        // 添加Java类型映射
        String javaType = mapToJavaType(dataType, columnType);
        column.put("java_type", javaType);
        
        // 添加长度信息
        Long maxLength = extractMaxLength(columnType);
        if (maxLength != null) {
            column.put("max_length", maxLength);
        }
        
        // 添加精度信息
        Map<String, Integer> precision = extractPrecision(columnType);
        if (precision != null) {
            column.put("numeric_precision", precision.get("precision"));
            column.put("numeric_scale", precision.get("scale"));
        }
        
        // 添加校验规则
        Map<String, Object> validationRules = generateValidationRules(column);
        column.put("validation_rules", validationRules);
    }
    
    /**
     * 映射到Java类型
     */
    private String mapToJavaType(String dataType, String columnType)
    {
        switch (dataType.toLowerCase()) {
            case "tinyint":
            case "smallint":
            case "mediumint":
            case "int":
            case "integer":
                return "Integer";
            case "bigint":
                return "Long";
            case "float":
                return "Float";
            case "double":
            case "decimal":
            case "numeric":
                return "BigDecimal";
            case "char":
            case "varchar":
            case "text":
            case "tinytext":
            case "mediumtext":
            case "longtext":
                return "String";
            case "date":
            case "datetime":
            case "timestamp":
                return "Date";
            case "time":
                return "Time";
            case "blob":
            case "tinyblob":
            case "mediumblob":
            case "longblob":
                return "byte[]";
            default:
                return "String";
        }
    }
    
    /**
     * 提取最大长度
     */
    private Long extractMaxLength(String columnType)
    {
        if (columnType.contains("(")) {
            String lengthStr = columnType.substring(columnType.indexOf("(") + 1, columnType.indexOf(")"));
            if (lengthStr.contains(",")) {
                lengthStr = lengthStr.substring(0, lengthStr.indexOf(","));
            }
            try {
                return Long.parseLong(lengthStr);
            } catch (NumberFormatException e) {
                return null;
            }
        }
        return null;
    }
    
    /**
     * 提取精度信息
     */
    private Map<String, Integer> extractPrecision(String columnType)
    {
        if (columnType.contains("(") && columnType.contains(",")) {
            String precisionStr = columnType.substring(columnType.indexOf("(") + 1, columnType.indexOf(")"));
            String[] parts = precisionStr.split(",");
            if (parts.length == 2) {
                try {
                    Map<String, Integer> result = new HashMap<>();
                    result.put("precision", Integer.parseInt(parts[0].trim()));
                    result.put("scale", Integer.parseInt(parts[1].trim()));
                    return result;
                } catch (NumberFormatException e) {
                    return null;
                }
            }
        }
        return null;
    }
    
    /**
     * 生成校验规则
     */
    private Map<String, Object> generateValidationRules(Map<String, Object> column)
    {
        Map<String, Object> rules = new HashMap<>();
        
        // 必填规则
        String isNullable = (String) column.get("is_nullable");
        if ("NO".equals(isNullable)) {
            rules.put("required", true);
        }
        
        // 长度规则
        Long maxLength = (Long) column.get("max_length");
        if (maxLength != null) {
            rules.put("maxLength", maxLength);
        }
        
        // 数值范围规则
        String dataType = (String) column.get("data_type");
        if ("int".equals(dataType) || "integer".equals(dataType)) {
            rules.put("min", Integer.MIN_VALUE);
            rules.put("max", Integer.MAX_VALUE);
        } else if ("bigint".equals(dataType)) {
            rules.put("min", Long.MIN_VALUE);
            rules.put("max", Long.MAX_VALUE);
        }
        
        return rules;
    }
    
    /**
     * 推断字典类型
     */
    private String inferDictType(String tableName, String columnName)
    {
        // 根据字段名推断字典类型
        if (columnName.contains("status")) {
            return "sys_common_status";
        } else if (columnName.contains("type")) {
            return tableName + "_" + columnName;
        } else if (columnName.contains("level")) {
            return "sys_common_level";
        }
        return null;
    }
    
    /**
     * 推断枚举值
     */
    private List<String> inferEnumValues(String tableName, String columnName)
    {
        // 根据字段名推断枚举值
        if (columnName.contains("status")) {
            return Arrays.asList("0", "1"); // 停用/启用
        } else if (columnName.contains("gender")) {
            return Arrays.asList("0", "1", "2"); // 未知/男/女
        }
        return null;
    }
}