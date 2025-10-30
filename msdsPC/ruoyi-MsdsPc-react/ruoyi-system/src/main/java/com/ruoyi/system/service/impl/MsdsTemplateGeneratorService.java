package com.ruoyi.system.service.impl;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.utils.DatabaseMetadataUtils;
import com.ruoyi.system.utils.DatabaseMetadataUtils.TableInfo;
import com.ruoyi.system.utils.DatabaseMetadataUtils.ColumnInfo;
import com.ruoyi.system.service.IMsdsMetadataService;
import com.ruoyi.system.service.IRuleMapperService;
import com.ruoyi.system.service.IMsdsTemplateXlsxWriter;
// import com.ruoyi.system.domain.metadata.TableMetadata; // 不再使用，改用 DatabaseMetadataUtils.TableInfo
// import com.ruoyi.system.domain.metadata.ColumnMetadata; // 不存在，使用 DatabaseMetadataUtils.ColumnInfo
import com.ruoyi.system.service.IRuleMapperService.ValidationRule;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.cache.annotation.Cacheable;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.lang.reflect.Field;
import java.util.*;
import java.util.Arrays;
import java.util.stream.Collectors;
import java.util.List;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;
import java.util.HashMap;
import java.util.Map;

/**
 * MSDS模板生成器服务
 * 基于数据库元数据动态生成Excel导入模板
 * 
 * @author ruoyi
 */
@Service
public class MsdsTemplateGeneratorService {
    
    private static final Logger log = LoggerFactory.getLogger(MsdsTemplateGeneratorService.class);
    
    @Autowired
    private DatabaseMetadataUtils databaseMetadataUtils;
    
    @Autowired
    private IMsdsMetadataService msdsMetadataService;
    
    @Autowired
    private IRuleMapperService ruleMapperService;
    
    @Autowired
    private IMsdsTemplateXlsxWriter templateXlsxWriter;
    
    /**
     * 模板类型枚举
     */
    public enum TemplateType {
        BASIC("basic", "基础模板", "包含核心字段的简化模板"),
        DETAILED("detailed", "详细模板", "包含主要业务字段的详细模板"),
        FULL("full", "完整模板", "包含所有字段的完整模板");
        
        private final String code;
        private final String name;
        private final String description;
        
        TemplateType(String code, String name, String description) {
            this.code = code;
            this.name = name;
            this.description = description;
        }
        
        public String getCode() { return code; }
        public String getName() { return name; }
        public String getDescription() { return description; }
        
        public static TemplateType fromCode(String code) {
            for (TemplateType type : values()) {
                if (type.code.equals(code)) {
                    return type;
                }
            }
            return BASIC;
        }
    }
    
    /**
     * 生成Excel模板
     * 
     * @param templateType 模板类型
     * @return Excel文件字节数组
     */
    public byte[] generateTemplate(String templateType) {
        return generateTemplate(templateType, "all", null);
    }
    
    /**
     * 生成Excel模板（支持scope参数）
     * 
     * @param templateType 模板类型
     * @param scope 范围：all（全部表）或 tableName（指定表名）
     * @param tableName 当scope不为all时，指定的表名
     * @return Excel文件字节数组
     */
    @Cacheable(value = "msdsTemplate", key = "#templateType + '_' + #scope + '_' + (#tableName != null ? #tableName : 'null')")
    public byte[] generateTemplate(String templateType, String scope, String tableName) {
        TemplateType type = TemplateType.fromCode(templateType);
        log.info("开始生成{}模板，scope: {}, tableName: {}", type.getName(), scope, tableName);
        
        try {
            log.info("开始生成模板 - 类型: {}, 范围: {}, 表名: {}", type, scope, tableName);
            
            // 获取表元数据
            List<DatabaseMetadataUtils.TableInfo> tables;
            if ("all".equals(scope)) {
                log.debug("获取所有MSDS相关表的元数据");
                tables = databaseMetadataUtils.getMsdsTablesMetadata();
                log.debug("获取到 {} 个表的元数据", tables.size());
                
                // 根据模板类型过滤表
                tables = filterTablesByTemplateType(tables, type);
                log.debug("过滤后剩余 {} 个表", tables.size());
            } else {
                log.debug("获取指定表的元数据: {}", tableName);
                DatabaseMetadataUtils.TableInfo table = databaseMetadataUtils.getTableMetadata(tableName);
                if (table == null) {
                    log.error("表不存在: {}", tableName);
                    throw new IllegalArgumentException("表不存在: " + tableName);
                }
                tables = Arrays.asList(table);
                log.debug("成功获取表 {} 的元数据，包含 {} 个字段", tableName, table.getColumns().size());
            }
            
            if (tables.isEmpty()) {
                log.warn("没有找到符合条件的表 - 类型: {}, 范围: {}, 表名: {}", type, scope, tableName);
                throw new IllegalArgumentException("没有找到符合条件的表");
            }
            
            // 转换TableMetadata为Map格式
            log.debug("转换表元数据为Map格式");
            Map<String, List<Map<String, Object>>> tableMetadata = convertTableMetadataToMap(tables);
            
            // 获取验证规则
            log.debug("获取验证规则");
            Map<String, Map<String, Map<String, Object>>> validationRules = getValidationRules(tables);
            log.debug("获取到 {} 个表的验证规则", validationRules.size());
            
            // 使用新的Excel写出器生成模板
            log.debug("开始生成Excel模板");
            byte[] result = templateXlsxWriter.generateTemplate(
                tableMetadata,
                validationRules,
                IMsdsTemplateXlsxWriter.HeaderStyle.PROFESSIONAL,
                IMsdsTemplateXlsxWriter.ExampleDataType.SIMPLE,
                true, // includeInstructions
                true  // includeDictionary
            );
            
            log.info("模板生成成功，大小: {} 字节", result.length);
            return result;
            
        } catch (IllegalArgumentException e) {
            log.error("参数错误: {}", e.getMessage());
            throw e;
        } catch (Exception e) {
            log.error("生成模板失败 - 类型: {}, 范围: {}, 表名: {}, 错误: {}", type, scope, tableName, e.getMessage(), e);
            throw new RuntimeException("生成模板失败: " + e.getMessage(), e);
        }
    }
    
    /**
     * 转换TableInfo为Map格式
     */
    private Map<String, List<Map<String, Object>>> convertTableMetadataToMap(List<DatabaseMetadataUtils.TableInfo> tables) {
        Map<String, List<Map<String, Object>>> result = new HashMap<>();
        
        for (DatabaseMetadataUtils.TableInfo table : tables) {
            log.debug("转换表 {} 的元数据，包含 {} 个字段", table.getTableName(), table.getColumns().size());
            List<Map<String, Object>> columns = new ArrayList<>();
            
            for (DatabaseMetadataUtils.ColumnInfo column : table.getColumns()) {
                Map<String, Object> columnMap = new HashMap<>();
                columnMap.put("COLUMN_NAME", column.getColumnName());
                columnMap.put("DATA_TYPE", column.getDataType());
                columnMap.put("COLUMN_SIZE", column.getColumnSize());
                columnMap.put("IS_NULLABLE", column.isNullable());
                columnMap.put("COLUMN_DEF", column.getDefaultValue());
                columnMap.put("REMARKS", column.getRemarks());
                columnMap.put("IS_AUTOINCREMENT", column.isAutoIncrement());
                columnMap.put("COLUMN_KEY", column.isPrimaryKey() ? "PRI" : "");
                columns.add(columnMap);
            }
            
            result.put(table.getTableName(), columns);
            log.debug("表 {} 转换完成，包含 {} 个字段映射", table.getTableName(), columns.size());
        }
        
        log.debug("所有表元数据转换完成，共 {} 个表", result.size());
        return result;
    }
    
    /**
     * 获取验证规则
     */
    private Map<String, Map<String, Map<String, Object>>> getValidationRules(List<DatabaseMetadataUtils.TableInfo> tables) {
        Map<String, Map<String, Map<String, Object>>> result = new HashMap<>();
        
        for (DatabaseMetadataUtils.TableInfo table : tables) {
            log.debug("生成表 {} 的验证规则", table.getTableName());
            Map<String, Map<String, Object>> tableRules = new HashMap<>();
            
            for (DatabaseMetadataUtils.ColumnInfo column : table.getColumns()) {
                Map<String, Object> columnRules = new HashMap<>();
                
                // 必填规则
                if (!column.isNullable()) {
                    columnRules.put("required", true);
                }
                
                // 长度规则
                if (column.getColumnSize() > 0) {
                    columnRules.put("maxLength", column.getColumnSize());
                }
                
                // 数据类型规则
                columnRules.put("dataType", column.getDataType());
                
                if (!columnRules.isEmpty()) {
                    tableRules.put(column.getColumnName(), columnRules);
                }
            }
            
            if (!tableRules.isEmpty()) {
                result.put(table.getTableName(), tableRules);
                log.debug("表 {} 生成了 {} 个字段的验证规则", table.getTableName(), tableRules.size());
            } else {
                log.debug("表 {} 没有生成验证规则", table.getTableName());
            }
        }
        
        log.debug("验证规则生成完成，共 {} 个表", result.size());
        return result;
    }
    
    /**
     * 根据模板类型过滤表
     */
    private List<DatabaseMetadataUtils.TableInfo> filterTablesByTemplateType(List<DatabaseMetadataUtils.TableInfo> tables, TemplateType type) {
        log.debug("根据模板类型 {} 过滤表，原始表数量: {}", type, tables.size());
        
        List<DatabaseMetadataUtils.TableInfo> filteredTables;
        switch (type) {
            case BASIC:
                // 基础模板只包含核心表
                filteredTables = tables.stream()
                    .filter(table -> isBasicTable(table.getTableName()))
                    .collect(Collectors.toList());
                log.debug("基础模板过滤后表数量: {}", filteredTables.size());
                break;
            case DETAILED:
                // 详细模板包含主要业务表
                filteredTables = tables.stream()
                    .filter(table -> isDetailedTable(table.getTableName()))
                    .collect(Collectors.toList());
                log.debug("详细模板过滤后表数量: {}", filteredTables.size());
                break;
            case FULL:
            default:
                // 完整模板包含所有表
                filteredTables = tables;
                log.debug("完整模板包含所有表，数量: {}", filteredTables.size());
                break;
        }
        
        if (log.isDebugEnabled()) {
            List<String> tableNames = filteredTables.stream()
                .map(DatabaseMetadataUtils.TableInfo::getTableName)
                .collect(Collectors.toList());
            log.debug("过滤后的表列表: {}", tableNames);
        }
        
        return filteredTables;
    }
    
    /**
     * 判断是否为基础表
     */
    private boolean isBasicTable(String tableName) {
        return "msds_main".equals(tableName) || "msds_component".equals(tableName);
    }
    
    /**
     * 判断是否为详细表
     */
    private boolean isDetailedTable(String tableName) {
        return isBasicTable(tableName) || 
               "msds_first_aid".equals(tableName) || 
               "msds_fire_fighting".equals(tableName) || 
               "msds_handling_storage".equals(tableName);
    }
    
    /**
     * 兼容旧版本的生成方法（已废弃，保留向后兼容）
     * @deprecated 使用新的基于元数据的生成方法
     */
    @Deprecated
    private byte[] generateTemplateOld(String templateType, String scope, String tableName) {
        TemplateType type = TemplateType.fromCode(templateType);
        log.info("开始生成{}模板，scope: {}, tableName: {}", type.getName(), scope, tableName);
        
        try (XSSFWorkbook workbook = new XSSFWorkbook()) {
            // 创建样式
            Map<String, CellStyle> styles = createStyles(workbook);
            
            // 根据scope参数生成不同的Sheet
            if ("all".equals(scope)) {
                // 根据模板类型生成不同的Sheet
                switch (type) {
                    case BASIC:
                        generateBasicTemplate(workbook, styles);
                        break;
                    case DETAILED:
                        generateDetailedTemplate(workbook, styles);
                        break;
                    case FULL:
                        generateFullTemplate(workbook, styles);
                        break;
                }
            } else {
                // 生成指定表的模板
                generateSingleTableTemplate(workbook, styles, tableName, type);
            }
            
            // 添加说明Sheet
            generateInstructionSheet(workbook, styles, type);
            generateFieldDescriptionSheet(workbook, styles, type, scope, tableName);
            
            // 转换为字节数组
            try (ByteArrayOutputStream outputStream = new ByteArrayOutputStream()) {
                workbook.write(outputStream);
                byte[] result = outputStream.toByteArray();
                log.info("成功生成{}模板，大小: {} bytes", type.getName(), result.length);
                return result;
            }
            
        } catch (IOException e) {
            log.error("生成Excel模板失败", e);
            throw new RuntimeException("生成Excel模板失败: " + e.getMessage(), e);
        }
    }
    
    /**
     * 生成基础模板
     */
    private void generateBasicTemplate(XSSFWorkbook workbook, Map<String, CellStyle> styles) {
        // 只包含msds_main表的核心字段
        DatabaseMetadataUtils.TableInfo mainTable = databaseMetadataUtils.getTableMetadata("msds_main");
        if (mainTable != null) {
            List<DatabaseMetadataUtils.ColumnInfo> basicColumns = mainTable.getColumns().stream()
                .filter(this::isBasicField)
                .collect(Collectors.toList());
            
            createDataSheet(workbook, styles, "MSDS基础信息", mainTable, basicColumns);
        }
    }
    
    /**
     * 生成详细模板
     */
    private void generateDetailedTemplate(XSSFWorkbook workbook, Map<String, CellStyle> styles) {
        // 包含msds_main的所有字段
        DatabaseMetadataUtils.TableInfo mainTable = databaseMetadataUtils.getTableMetadata("msds_main");
        if (mainTable != null) {
            createDataSheet(workbook, styles, "MSDS主要信息", mainTable, mainTable.getColumns());
        }
        
        // 包含主要关联表
        String[] detailedTables = {"msds_hazard", "msds_physical_chemical", "msds_first_aid"};
        for (String tableName : detailedTables) {
            DatabaseMetadataUtils.TableInfo tableInfo = databaseMetadataUtils.getTableMetadata(tableName);
            if (tableInfo != null) {
                String sheetName = databaseMetadataUtils.getTableDisplayName(tableInfo);
                createDataSheet(workbook, styles, sheetName, tableInfo, tableInfo.getColumns());
            }
        }
    }
    
    /**
     * 生成完整模板
     */
    private void generateFullTemplate(XSSFWorkbook workbook, Map<String, CellStyle> styles) {
        // 获取所有MSDS相关表
        List<DatabaseMetadataUtils.TableInfo> allTables = databaseMetadataUtils.getMsdsTablesMetadata();
        
        for (DatabaseMetadataUtils.TableInfo tableInfo : allTables) {
            String sheetName = databaseMetadataUtils.getTableDisplayName(tableInfo);
            createDataSheet(workbook, styles, sheetName, tableInfo, tableInfo.getColumns());
        }
    }
    
    /**
     * 创建数据Sheet
     */
    private void createDataSheet(XSSFWorkbook workbook, Map<String, CellStyle> styles, 
                                String sheetName, DatabaseMetadataUtils.TableInfo tableInfo, List<DatabaseMetadataUtils.ColumnInfo> columns) {
        Sheet sheet = workbook.createSheet(sheetName);
        
        // 创建标题行
        Row titleRow = sheet.createRow(0);
        titleRow.setHeight((short) 600);
        
        // 创建表头行
        Row headerRow = sheet.createRow(1);
        headerRow.setHeight((short) 400);
        
        // 创建字段说明行
        Row descRow = sheet.createRow(2);
        descRow.setHeight((short) 300);
        
        int colIndex = 0;
        for (ColumnInfo column : columns) {
            // 设置列宽
            sheet.setColumnWidth(colIndex, 4000);
            
            // 标题行 - 显示表名
            if (colIndex == 0) {
                Cell titleCell = titleRow.createCell(colIndex);
                titleCell.setCellValue(databaseMetadataUtils.getTableDisplayName(tableInfo));
                titleCell.setCellStyle(styles.get("title"));
                
                // 合并标题行
                if (columns.size() > 1) {
                    sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, columns.size() - 1));
                }
            }
            
            // 表头行 - 显示列名
            Cell headerCell = headerRow.createCell(colIndex);
            String displayName = databaseMetadataUtils.getColumnDisplayName(column);
            if (databaseMetadataUtils.isRequiredField(column)) {
                displayName += "*";
            }
            headerCell.setCellValue(displayName);
            headerCell.setCellStyle(styles.get("header"));
            
            // 字段说明行
            Cell descCell = descRow.createCell(colIndex);
            String description = buildFieldDescription(column);
            descCell.setCellValue(description);
            descCell.setCellStyle(styles.get("description"));
            
            colIndex++;
        }
        
        // 添加数据示例行
        Row exampleRow = sheet.createRow(3);
        exampleRow.setHeight((short) 300);
        
        colIndex = 0;
        for (DatabaseMetadataUtils.ColumnInfo column : columns) {
            Cell exampleCell = exampleRow.createCell(colIndex);
            String example = generateExampleValue(column);
            exampleCell.setCellValue(example);
            exampleCell.setCellStyle(styles.get("example"));
            colIndex++;
        }
        
        // 冻结前4行
        sheet.createFreezePane(0, 4);
        
        log.debug("创建数据Sheet: {} ({}列)", sheetName, columns.size());
    }
    
    /**
     * 生成导入说明Sheet
     */
    private void generateInstructionSheet(XSSFWorkbook workbook, Map<String, CellStyle> styles, TemplateType templateType) {
        Sheet sheet = workbook.createSheet("导入说明");
        
        int rowIndex = 0;
        
        // 标题
        Row titleRow = sheet.createRow(rowIndex++);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("MSDS数据导入模板使用说明");
        titleCell.setCellStyle(styles.get("title"));
        
        rowIndex++; // 空行
        
        // 模板信息
        Row templateInfoRow = sheet.createRow(rowIndex++);
        templateInfoRow.createCell(0).setCellValue("模板类型:");
        templateInfoRow.createCell(1).setCellValue(templateType.getName());
        
        Row templateDescRow = sheet.createRow(rowIndex++);
        templateDescRow.createCell(0).setCellValue("模板说明:");
        templateDescRow.createCell(1).setCellValue(templateType.getDescription());
        
        rowIndex++; // 空行
        
        // 使用说明
        String[] instructions = {
            "1. 请按照表头要求填写数据，带*号的字段为必填项",
            "2. 请勿修改表头行和字段说明行",
            "3. 数据从第5行开始填写",
            "4. 日期格式请使用: yyyy-MM-dd 或 yyyy-MM-dd HH:mm:ss",
            "5. 数值字段请填写数字，不要包含单位",
            "6. 选择字段请参考字段说明中的可选值",
            "7. 导入前请检查数据格式和完整性",
            "8. 如有疑问请联系系统管理员"
        };
        
        Row instructionTitleRow = sheet.createRow(rowIndex++);
        instructionTitleRow.createCell(0).setCellValue("使用说明:");
        instructionTitleRow.getCell(0).setCellStyle(styles.get("header"));
        
        for (String instruction : instructions) {
            Row instructionRow = sheet.createRow(rowIndex++);
            instructionRow.createCell(0).setCellValue(instruction);
        }
        
        // 设置列宽
        sheet.setColumnWidth(0, 8000);
        sheet.setColumnWidth(1, 6000);
    }
    
    /**
     * 生成单表模板
     */
    private void generateSingleTableTemplate(XSSFWorkbook workbook, Map<String, CellStyle> styles, String tableName, TemplateType templateType) {
        if (StringUtils.isEmpty(tableName)) {
            throw new RuntimeException("表名不能为空");
        }
        
        DatabaseMetadataUtils.TableInfo tableInfo = databaseMetadataUtils.getTableMetadata(tableName);
        if (tableInfo == null) {
            throw new RuntimeException("未找到表: " + tableName);
        }
        
        List<DatabaseMetadataUtils.ColumnInfo> columns = getColumnsForTemplate(tableInfo, templateType);
        String sheetName = databaseMetadataUtils.getTableDisplayName(tableInfo);
        
        createDataSheet(workbook, styles, sheetName, tableInfo, columns);
        log.info("生成单表模板: {} ({}列)", tableName, columns.size());
    }
    
    /**
     * 生成字段说明Sheet
     */
    private void generateFieldDescriptionSheet(XSSFWorkbook workbook, Map<String, CellStyle> styles, TemplateType templateType) {
        generateFieldDescriptionSheet(workbook, styles, templateType, "all", null);
    }
    
    /**
     * 生成字段说明Sheet（支持scope参数）
     */
    private void generateFieldDescriptionSheet(XSSFWorkbook workbook, Map<String, CellStyle> styles, TemplateType templateType, String scope, String tableName) {
        Sheet sheet = workbook.createSheet("字段说明");
        
        // 创建表头
        Row headerRow = sheet.createRow(0);
        String[] headers = {"表名", "字段名", "字段类型", "是否必填", "字段说明", "示例值"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(styles.get("header"));
        }
        
        int rowIndex = 1;
        
        // 根据scope和模板类型获取相应的表信息
        List<DatabaseMetadataUtils.TableInfo> tables;
        if ("all".equals(scope)) {
            tables = getTablesForTemplate(templateType);
        } else {
            // 单表模式
            DatabaseMetadataUtils.TableInfo tableInfo = databaseMetadataUtils.getTableMetadata(tableName);
            tables = tableInfo != null ? Arrays.asList(tableInfo) : new ArrayList<>();
        }
        
        for (DatabaseMetadataUtils.TableInfo tableInfo : tables) {
            List<DatabaseMetadataUtils.ColumnInfo> columns = getColumnsForTemplate(tableInfo, templateType);
            
            for (DatabaseMetadataUtils.ColumnInfo column : columns) {
                Row row = sheet.createRow(rowIndex++);
                
                row.createCell(0).setCellValue(databaseMetadataUtils.getTableDisplayName(tableInfo));
                row.createCell(1).setCellValue(databaseMetadataUtils.getColumnDisplayName(column));
                row.createCell(2).setCellValue(column.getDataType() + "(" + column.getColumnSize() + ")");
                row.createCell(3).setCellValue(databaseMetadataUtils.isRequiredField(column) ? "是" : "否");
                row.createCell(4).setCellValue(buildFieldDescription(column));
                row.createCell(5).setCellValue(generateExampleValue(column));
            }
        }
        
        // 设置列宽
        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }
    }
    
    /**
     * 根据模板类型获取表信息
     */
    private List<DatabaseMetadataUtils.TableInfo> getTablesForTemplate(TemplateType templateType) {
        switch (templateType) {
            case BASIC:
                DatabaseMetadataUtils.TableInfo mainTable = databaseMetadataUtils.getTableMetadata("msds_main");
                return mainTable != null ? Arrays.asList(mainTable) : new ArrayList<>();
                
            case DETAILED:
                List<DatabaseMetadataUtils.TableInfo> detailedTables = new ArrayList<>();
                String[] tableNames = {"msds_main", "msds_hazard", "msds_physical_chemical", "msds_first_aid"};
                for (String tableName : tableNames) {
                    DatabaseMetadataUtils.TableInfo table = databaseMetadataUtils.getTableMetadata(tableName);
                    if (table != null) {
                        detailedTables.add(table);
                    }
                }
                return detailedTables;
                
            case FULL:
                return databaseMetadataUtils.getMsdsTablesMetadata();
                
            default:
                return new ArrayList<>();
        }
    }
    
    /**
     * 根据模板类型获取列信息
     */
    private List<DatabaseMetadataUtils.ColumnInfo> getColumnsForTemplate(DatabaseMetadataUtils.TableInfo tableInfo, TemplateType templateType) {
        if (templateType == TemplateType.BASIC && "msds_main".equals(tableInfo.getTableName())) {
            return tableInfo.getColumns().stream()
                .filter(this::isBasicField)
                .collect(Collectors.toList());
        }
        return tableInfo.getColumns();
    }
    
    /**
     * 判断是否为基础字段
     */
    private boolean isBasicField(DatabaseMetadataUtils.ColumnInfo column) {
        String columnName = column.getColumnName().toLowerCase();
        
        // 基础字段列表
        Set<String> basicFields = new HashSet<>(Arrays.asList(
            "id", "cas_number", "msds_code", "product_name", "product_english_name",
            "manufacturer", "supplier", "emergency_phone", "create_time", "update_time"
        ));
        
        return basicFields.contains(columnName) || databaseMetadataUtils.isRequiredField(column);
    }
    
    /**
     * 构建字段描述
     */
    private String buildFieldDescription(DatabaseMetadataUtils.ColumnInfo column) {
        StringBuilder desc = new StringBuilder();
        
        if (column.getRemarks() != null && !column.getRemarks().trim().isEmpty()) {
            desc.append(column.getRemarks());
        } else {
            desc.append(column.getColumnName());
        }
        
        if (column.isPrimaryKey()) {
            desc.append(" [主键]");
        }
        
        if (column.isAutoIncrement()) {
            desc.append(" [自增]");
        }
        
        if (!column.isNullable()) {
            desc.append(" [必填]");
        }
        
        if (column.getDefaultValue() != null && !column.getDefaultValue().trim().isEmpty()) {
            desc.append(" [默认值: ").append(column.getDefaultValue()).append("]");
        }
        
        return desc.toString();
    }
    
    /**
     * 生成示例值
     */
    private String generateExampleValue(DatabaseMetadataUtils.ColumnInfo column) {
        String columnName = column.getColumnName().toLowerCase();
        String dataType = column.getDataType();
        
        // 根据字段名生成示例值
        if (columnName.contains("name")) {
            return "示例名称";
        } else if (columnName.contains("code")) {
            return "CODE001";
        } else if (columnName.contains("cas")) {
            return "7732-18-5";
        } else if (columnName.contains("phone")) {
            return "400-123-4567";
        } else if (columnName.contains("email")) {
            return "example@company.com";
        } else if (columnName.contains("url") || columnName.contains("website")) {
            return "https://www.example.com";
        } else if (columnName.contains("date") || columnName.contains("time")) {
            return "2024-01-01";
        }
        
        // 根据数据类型生成示例值
        switch (dataType) {
            case "Integer":
            case "Long":
                return "1";
            case "Double":
            case "BigDecimal":
                return "1.0";
            case "Boolean":
                return "true";
            case "Date":
                return "2024-01-01";
            default:
                return "示例文本";
        }
    }
    
    /**
     * 创建Excel样式
     */
    private Map<String, CellStyle> createStyles(XSSFWorkbook workbook) {
        Map<String, CellStyle> styles = new HashMap<>();
        
        // 标题样式
        CellStyle titleStyle = workbook.createCellStyle();
        Font titleFont = workbook.createFont();
        titleFont.setBold(true);
        titleFont.setFontHeightInPoints((short) 16);
        titleStyle.setFont(titleFont);
        titleStyle.setAlignment(HorizontalAlignment.CENTER);
        titleStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        titleStyle.setFillForegroundColor(IndexedColors.LIGHT_BLUE.getIndex());
        titleStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        setBorder(titleStyle);
        styles.put("title", titleStyle);
        
        // 表头样式
        CellStyle headerStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerFont.setFontHeightInPoints((short) 12);
        headerStyle.setFont(headerFont);
        headerStyle.setAlignment(HorizontalAlignment.CENTER);
        headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        setBorder(headerStyle);
        styles.put("header", headerStyle);
        
        // 描述样式
        CellStyle descStyle = workbook.createCellStyle();
        Font descFont = workbook.createFont();
        descFont.setFontHeightInPoints((short) 9);
        descFont.setColor(IndexedColors.DARK_BLUE.getIndex());
        descStyle.setFont(descFont);
        descStyle.setAlignment(HorizontalAlignment.CENTER);
        descStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        descStyle.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
        descStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        setBorder(descStyle);
        styles.put("description", descStyle);
        
        // 示例样式
        CellStyle exampleStyle = workbook.createCellStyle();
        Font exampleFont = workbook.createFont();
        exampleFont.setFontHeightInPoints((short) 10);
        exampleFont.setItalic(true);
        exampleFont.setColor(IndexedColors.DARK_GREEN.getIndex());
        exampleStyle.setFont(exampleFont);
        exampleStyle.setAlignment(HorizontalAlignment.CENTER);
        exampleStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        exampleStyle.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
        exampleStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        setBorder(exampleStyle);
        styles.put("example", exampleStyle);
        
        return styles;
    }
    
    /**
     * 设置边框
     */
    private void setBorder(CellStyle style) {
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        style.setTopBorderColor(IndexedColors.BLACK.getIndex());
        style.setBottomBorderColor(IndexedColors.BLACK.getIndex());
        style.setLeftBorderColor(IndexedColors.BLACK.getIndex());
        style.setRightBorderColor(IndexedColors.BLACK.getIndex());
    }
}