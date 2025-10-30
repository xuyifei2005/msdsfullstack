package com.ruoyi.system.service.impl;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.CellRangeAddressList;
import org.apache.poi.xssf.usermodel.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.ruoyi.system.service.IMsdsTemplateXlsxWriter;

/**
 * MSDS模板Excel写出器实现类
 * 
 * @author ruoyi
 */
@Service
public class MsdsTemplateXlsxWriterImpl implements IMsdsTemplateXlsxWriter
{
    private static final Logger log = LoggerFactory.getLogger(MsdsTemplateXlsxWriterImpl.class);
    // 预定义的示例数据映射
    private static final Map<String, Map<String, String>> EXAMPLE_DATA_MAP = new HashMap<>();
    
    // 预定义的列宽映射
    private static final Map<String, Integer> COLUMN_WIDTH_MAP = new HashMap<>();
    
    static {
        // 初始化示例数据映射
        initExampleDataMap();
        
        // 初始化列宽映射
        initColumnWidthMap();
    }
    
    private static void initExampleDataMap() {
        // 化学品基本信息示例
        Map<String, String> chemicalExamples = new HashMap<>();
        chemicalExamples.put("chemical_name", "苯");
        chemicalExamples.put("cas_number", "71-43-2");
        chemicalExamples.put("molecular_formula", "C6H6");
        chemicalExamples.put("molecular_weight", "78.11");
        chemicalExamples.put("purity", "99.5");
        chemicalExamples.put("appearance", "无色透明液体");
        chemicalExamples.put("odor", "特殊芳香味");
        chemicalExamples.put("ph_value", "7.0");
        chemicalExamples.put("melting_point", "5.5");
        chemicalExamples.put("boiling_point", "80.1");
        chemicalExamples.put("flash_point", "-11");
        chemicalExamples.put("density", "0.8765");
        chemicalExamples.put("solubility", "微溶于水，易溶于有机溶剂");
        EXAMPLE_DATA_MAP.put("chemical", chemicalExamples);
        
        // 危险性信息示例
        Map<String, String> hazardExamples = new HashMap<>();
        hazardExamples.put("hazard_class", "易燃液体");
        hazardExamples.put("hazard_category", "类别2");
        hazardExamples.put("signal_word", "危险");
        hazardExamples.put("hazard_statement", "H225 高度易燃液体和蒸气");
        hazardExamples.put("precautionary_statement", "P210 远离热源、火花、明火和热表面");
        EXAMPLE_DATA_MAP.put("hazard", hazardExamples);
        
        // 通用示例
        Map<String, String> generalExamples = new HashMap<>();
        generalExamples.put("name", "示例名称");
        generalExamples.put("code", "EXAMPLE001");
        generalExamples.put("description", "这是一个示例描述");
        generalExamples.put("status", "有效");
        generalExamples.put("create_time", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        generalExamples.put("update_time", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        generalExamples.put("remark", "备注信息");
        EXAMPLE_DATA_MAP.put("general", generalExamples);
    }
    
    private static void initColumnWidthMap() {
        COLUMN_WIDTH_MAP.put("id", 10);
        COLUMN_WIDTH_MAP.put("name", 20);
        COLUMN_WIDTH_MAP.put("code", 15);
        COLUMN_WIDTH_MAP.put("description", 30);
        COLUMN_WIDTH_MAP.put("remark", 25);
        COLUMN_WIDTH_MAP.put("create_time", 20);
        COLUMN_WIDTH_MAP.put("update_time", 20);
        COLUMN_WIDTH_MAP.put("status", 10);
        COLUMN_WIDTH_MAP.put("chemical_name", 25);
        COLUMN_WIDTH_MAP.put("cas_number", 15);
        COLUMN_WIDTH_MAP.put("molecular_formula", 20);
        COLUMN_WIDTH_MAP.put("molecular_weight", 15);
        COLUMN_WIDTH_MAP.put("hazard_statement", 40);
        COLUMN_WIDTH_MAP.put("precautionary_statement", 40);
    }
    
    @Override
    public XSSFWorkbook createWorkbook() {
        return new XSSFWorkbook();
    }
    
    @Override
    public int createTableSheet(XSSFWorkbook workbook, String tableName, 
                               List<Map<String, Object>> columns, 
                               HeaderStyle headerStyle, 
                               ExampleDataType exampleDataType) {
        XSSFSheet sheet = workbook.createSheet(tableName);
        int sheetIndex = workbook.getSheetIndex(sheet);
        
        // 创建双行列头
        createDoubleRowHeader(workbook, sheetIndex, columns, headerStyle);
        
        // 设置列宽度
        setColumnWidths(workbook, sheetIndex, columns);
        
        // 添加示例数据行
        if (exampleDataType != ExampleDataType.NONE) {
            addExampleRows(workbook, sheetIndex, columns, exampleDataType, 2);
        }
        
        // 冻结窗格（冻结前两行）
        freezePanes(workbook, sheetIndex, 0, 2);
        
        return sheetIndex;
    }
    
    @Override
    public void createDoubleRowHeader(XSSFWorkbook workbook, int sheetIndex, 
                                     List<Map<String, Object>> columns, 
                                     HeaderStyle headerStyle) {
        XSSFSheet sheet = workbook.getSheetAt(sheetIndex);
        Map<String, CellStyle> styleMap = createStyleMap(workbook, headerStyle);
        
        // 创建第一行（中文列名）
        Row headerRow1 = sheet.createRow(0);
        headerRow1.setHeight((short) 600); // 设置行高
        
        // 创建第二行（英文列名/字段名）
        Row headerRow2 = sheet.createRow(1);
        headerRow2.setHeight((short) 500);
        
        for (int i = 0; i < columns.size(); i++) {
            Map<String, Object> column = columns.get(i);
            
            // 第一行：中文列名或注释
            Cell cell1 = headerRow1.createCell(i);
            String comment = (String) column.get("COLUMN_COMMENT");
            String columnName = (String) column.get("COLUMN_NAME");
            cell1.setCellValue(comment != null && !comment.trim().isEmpty() ? comment : columnName);
            cell1.setCellStyle(styleMap.get("header1"));
            
            // 第二行：英文字段名
            Cell cell2 = headerRow2.createCell(i);
            cell2.setCellValue(columnName);
            cell2.setCellStyle(styleMap.get("header2"));
        }
    }
    
    @Override
    public void addExampleRows(XSSFWorkbook workbook, int sheetIndex, 
                              List<Map<String, Object>> columns, 
                              ExampleDataType exampleDataType, 
                              int startRow) {
        XSSFSheet sheet = workbook.getSheetAt(sheetIndex);
        Map<String, CellStyle> styleMap = createStyleMap(workbook, HeaderStyle.BASIC);
        
        int rowCount = getExampleRowCount(exampleDataType);
        
        for (int rowIndex = 0; rowIndex < rowCount; rowIndex++) {
            Row row = sheet.createRow(startRow + rowIndex);
            
            for (int colIndex = 0; colIndex < columns.size(); colIndex++) {
                Map<String, Object> column = columns.get(colIndex);
                Cell cell = row.createCell(colIndex);
                
                String exampleValue = generateExampleData(column, exampleDataType);
                cell.setCellValue(exampleValue);
                cell.setCellStyle(styleMap.get("data"));
            }
        }
    }
    
    @Override
    public void setColumnWidths(XSSFWorkbook workbook, int sheetIndex, 
                               List<Map<String, Object>> columns) {
        XSSFSheet sheet = workbook.getSheetAt(sheetIndex);
        
        for (int i = 0; i < columns.size(); i++) {
            Map<String, Object> column = columns.get(i);
            int width = calculateOptimalColumnWidth(column);
            sheet.setColumnWidth(i, width * 256); // POI使用256为单位
        }
    }
    
    @Override
    public void applyDataValidation(XSSFWorkbook workbook, int sheetIndex, 
                                   List<Map<String, Object>> columns, 
                                   Map<String, Map<String, Object>> validationRules, 
                                   int startRow, int endRow) {
        XSSFSheet sheet = workbook.getSheetAt(sheetIndex);
        DataValidationHelper validationHelper = sheet.getDataValidationHelper();
        
        for (int colIndex = 0; colIndex < columns.size(); colIndex++) {
            Map<String, Object> column = columns.get(colIndex);
            String columnName = (String) column.get("COLUMN_NAME");
            
            Map<String, Object> rules = validationRules.get(columnName);
            if (rules == null || rules.isEmpty()) {
                continue;
            }
            
            // 创建验证区域
            CellRangeAddressList addressList = new CellRangeAddressList(startRow, endRow, colIndex, colIndex);
            
            // 根据规则类型创建验证
            DataValidationConstraint constraint = createValidationConstraint(validationHelper, rules);
            if (constraint != null) {
                DataValidation validation = validationHelper.createValidation(constraint, addressList);
                validation.setShowErrorBox(true);
                validation.setErrorStyle(DataValidation.ErrorStyle.STOP);
                validation.createErrorBox("输入错误", getValidationErrorMessage(rules));
                sheet.addValidationData(validation);
            }
        }
    }
    
    @Override
    public int createInstructionSheet(XSSFWorkbook workbook, Map<String, Object> instructions) {
        XSSFSheet sheet = workbook.createSheet("使用说明");
        int sheetIndex = workbook.getSheetIndex(sheet);
        
        Map<String, CellStyle> styleMap = createStyleMap(workbook, HeaderStyle.PROFESSIONAL);
        
        int rowIndex = 0;
        
        // 标题
        Row titleRow = sheet.createRow(rowIndex++);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("MSDS导入模板使用说明");
        titleCell.setCellStyle(styleMap.get("title"));
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 5));
        
        rowIndex++; // 空行
        
        // 基本说明
        String[] basicInstructions = {
            "1. 请严格按照模板格式填写数据，不要修改表头结构",
            "2. 必填字段不能为空，请确保数据完整性",
            "3. 日期格式请使用：yyyy-MM-dd 或 yyyy-MM-dd HH:mm:ss",
            "4. 数值字段请输入有效的数字",
            "5. 枚举字段请从下拉列表中选择",
            "6. 导入前请检查数据格式和内容的正确性"
        };
        
        for (String instruction : basicInstructions) {
            Row row = sheet.createRow(rowIndex++);
            Cell cell = row.createCell(0);
            cell.setCellValue(instruction);
            cell.setCellStyle(styleMap.get("data"));
            sheet.addMergedRegion(new CellRangeAddress(rowIndex - 1, rowIndex - 1, 0, 5));
        }
        
        // 设置列宽
        sheet.setColumnWidth(0, 80 * 256);
        
        return sheetIndex;
    }
    
    @Override
    public int createDictionarySheet(XSSFWorkbook workbook, Map<String, List<String>> dictionaries) {
        XSSFSheet sheet = workbook.createSheet("数据字典");
        int sheetIndex = workbook.getSheetIndex(sheet);
        
        Map<String, CellStyle> styleMap = createStyleMap(workbook, HeaderStyle.COLORFUL);
        
        int colIndex = 0;
        
        for (Map.Entry<String, List<String>> entry : dictionaries.entrySet()) {
            String dictName = entry.getKey();
            List<String> values = entry.getValue();
            
            // 创建字典标题
            Row titleRow = sheet.getRow(0);
            if (titleRow == null) {
                titleRow = sheet.createRow(0);
            }
            Cell titleCell = titleRow.createCell(colIndex);
            titleCell.setCellValue(dictName);
            titleCell.setCellStyle(styleMap.get("header1"));
            
            // 填充字典值
            for (int i = 0; i < values.size(); i++) {
                Row row = sheet.getRow(i + 1);
                if (row == null) {
                    row = sheet.createRow(i + 1);
                }
                Cell cell = row.createCell(colIndex);
                cell.setCellValue(values.get(i));
                cell.setCellStyle(styleMap.get("data"));
            }
            
            // 设置列宽
            sheet.setColumnWidth(colIndex, 20 * 256);
            colIndex++;
        }
        
        return sheetIndex;
    }
    
    @Override
    public void setSheetProtection(XSSFWorkbook workbook, int sheetIndex, 
                                  String password, List<String> allowedOperations) {
        XSSFSheet sheet = workbook.getSheetAt(sheetIndex);
        
        if (password != null && !password.trim().isEmpty()) {
            sheet.protectSheet(password);
            
            // 设置允许的操作
            if (allowedOperations != null) {
                for (String operation : allowedOperations) {
                    switch (operation.toLowerCase()) {
                        case "select_locked_cells":
                            sheet.lockSelectLockedCells(false);
                            break;
                        case "select_unlocked_cells":
                            sheet.lockSelectUnlockedCells(false);
                            break;
                        case "format_cells":
                            sheet.lockFormatCells(false);
                            break;
                        case "format_columns":
                            sheet.lockFormatColumns(false);
                            break;
                        case "format_rows":
                            sheet.lockFormatRows(false);
                            break;
                        case "insert_columns":
                            sheet.lockInsertColumns(false);
                            break;
                        case "insert_rows":
                            sheet.lockInsertRows(false);
                            break;
                        case "insert_hyperlinks":
                            sheet.lockInsertHyperlinks(false);
                            break;
                        case "delete_columns":
                            sheet.lockDeleteColumns(false);
                            break;
                        case "delete_rows":
                            sheet.lockDeleteRows(false);
                            break;
                        case "sort":
                            sheet.lockSort(false);
                            break;
                        case "auto_filter":
                            sheet.lockAutoFilter(false);
                            break;
                        case "pivot_tables":
                            sheet.lockPivotTables(false);
                            break;
                        case "objects":
                            sheet.lockObjects(false);
                            break;
                        case "scenarios":
                            sheet.lockScenarios(false);
                            break;
                    }
                }
            }
        }
    }
    
    @Override
    public void freezePanes(XSSFWorkbook workbook, int sheetIndex, int colSplit, int rowSplit) {
        XSSFSheet sheet = workbook.getSheetAt(sheetIndex);
        sheet.createFreezePane(colSplit, rowSplit);
    }
    
    @Override
    public void addConditionalFormatting(XSSFWorkbook workbook, int sheetIndex, 
                                        List<Map<String, Object>> columns, 
                                        int startRow, int endRow) {
        XSSFSheet sheet = workbook.getSheetAt(sheetIndex);
        SheetConditionalFormatting sheetCF = sheet.getSheetConditionalFormatting();
        
        for (int colIndex = 0; colIndex < columns.size(); colIndex++) {
            Map<String, Object> column = columns.get(colIndex);
            String isNullable = (String) column.get("IS_NULLABLE");
            
            // 为必填字段添加条件格式
            if ("NO".equals(isNullable)) {
                CellRangeAddress[] regions = {new CellRangeAddress(startRow, endRow, colIndex, colIndex)};
                
                // 空值高亮为红色
                ConditionalFormattingRule rule = sheetCF.createConditionalFormattingRule("ISBLANK($A$1)");
                PatternFormatting fill = rule.createPatternFormatting();
                fill.setFillBackgroundColor(IndexedColors.RED.index);
                fill.setFillPattern(PatternFormatting.SOLID_FOREGROUND);
                
                sheetCF.addConditionalFormatting(regions, rule);
            }
        }
    }
    
    @Override
    public byte[] generateTemplate(Map<String, List<Map<String, Object>>> tableMetadata, 
                                  Map<String, Map<String, Map<String, Object>>> validationRules, 
                                  HeaderStyle headerStyle, 
                                  ExampleDataType exampleDataType, 
                                  boolean includeInstructions, 
                                  boolean includeDictionary) {
        log.info("开始生成Excel模板 - 表数量: {}, 表头样式: {}, 示例数据类型: {}, 包含说明: {}, 包含字典: {}", 
                tableMetadata.size(), headerStyle, exampleDataType, includeInstructions, includeDictionary);
        
        if (tableMetadata == null || tableMetadata.isEmpty()) {
            log.error("表元数据为空，无法生成模板");
            throw new IllegalArgumentException("表元数据不能为空");
        }
        
        XSSFWorkbook workbook = createWorkbook();
        log.debug("创建工作簿成功");
        
        try {
            // 创建表格Sheet
            log.debug("开始创建表格Sheet，共 {} 个表", tableMetadata.size());
            for (Map.Entry<String, List<Map<String, Object>>> entry : tableMetadata.entrySet()) {
                String tableName = entry.getKey();
                List<Map<String, Object>> columns = entry.getValue();
                
                log.debug("创建表 {} 的Sheet，包含 {} 个字段", tableName, columns.size());
                int sheetIndex = createTableSheet(workbook, tableName, columns, headerStyle, exampleDataType);
                log.debug("表 {} 的Sheet创建完成，索引: {}", tableName, sheetIndex);
                
                // 应用数据验证
                Map<String, Map<String, Object>> tableValidationRules = validationRules.get(tableName);
                if (tableValidationRules != null && !tableValidationRules.isEmpty()) {
                    log.debug("为表 {} 应用数据验证规则，规则数量: {}", tableName, tableValidationRules.size());
                    applyDataValidation(workbook, sheetIndex, columns, tableValidationRules, 2, 1000);
                    log.debug("表 {} 的数据验证规则应用完成", tableName);
                } else {
                    log.debug("表 {} 没有数据验证规则", tableName);
                }
                
                // 添加条件格式
                log.debug("为表 {} 添加条件格式", tableName);
                addConditionalFormatting(workbook, sheetIndex, columns, 2, 1000);
                log.debug("表 {} 的条件格式添加完成", tableName);
            }
            
            // 创建说明Sheet
            if (includeInstructions) {
                log.debug("创建说明Sheet");
                createInstructionSheet(workbook, new HashMap<>());
                log.debug("说明Sheet创建完成");
            }
            
            // 创建字典Sheet
            if (includeDictionary) {
                log.debug("提取字典数据");
                Map<String, List<String>> dictionaries = extractDictionaries(validationRules);
                if (!dictionaries.isEmpty()) {
                    log.debug("创建字典Sheet，字典数量: {}", dictionaries.size());
                    createDictionarySheet(workbook, dictionaries);
                    log.debug("字典Sheet创建完成");
                } else {
                    log.debug("没有字典数据，跳过字典Sheet创建");
                }
            }
            
            log.debug("开始转换工作簿为字节数组");
            byte[] result = workbookToBytes(workbook);
            log.info("Excel模板生成完成，文件大小: {} 字节", result.length);
            return result;
        } catch (Exception e) {
            log.error("生成Excel模板时发生错误: {}", e.getMessage(), e);
            throw new RuntimeException("生成Excel模板失败: " + e.getMessage(), e);
        } finally {
            try {
                workbook.close();
                log.debug("工作簿已关闭");
            } catch (IOException e) {
                log.warn("关闭工作簿时发生异常: {}", e.getMessage());
            }
        }
    }
    
    @Override
    public byte[] workbookToBytes(XSSFWorkbook workbook) {
        log.debug("开始将工作簿转换为字节数组");
        try (ByteArrayOutputStream outputStream = new ByteArrayOutputStream()) {
            workbook.write(outputStream);
            byte[] result = outputStream.toByteArray();
            log.debug("工作簿转换完成，字节数组大小: {} 字节", result.length);
            return result;
        } catch (IOException e) {
            log.error("转换工作簿为字节数组失败: {}", e.getMessage(), e);
            throw new RuntimeException("转换工作簿为字节数组失败", e);
        }
    }
    
    @Override
    public String generateExampleData(Map<String, Object> columnMetadata, ExampleDataType exampleDataType) {
        if (exampleDataType == ExampleDataType.NONE) {
            return "";
        }
        
        String columnName = (String) columnMetadata.get("COLUMN_NAME");
        String dataType = (String) columnMetadata.get("DATA_TYPE");
        
        // 根据列名匹配示例数据
        for (Map.Entry<String, Map<String, String>> entry : EXAMPLE_DATA_MAP.entrySet()) {
            Map<String, String> examples = entry.getValue();
            if (examples.containsKey(columnName.toLowerCase())) {
                return examples.get(columnName.toLowerCase());
            }
        }
        
        // 根据数据类型生成示例
        return generateExampleByDataType(dataType, exampleDataType);
    }
    
    @Override
    public int calculateOptimalColumnWidth(Map<String, Object> columnMetadata) {
        String columnName = (String) columnMetadata.get("COLUMN_NAME");
        String comment = (String) columnMetadata.get("COLUMN_COMMENT");
        Object characterMaximumLength = columnMetadata.get("CHARACTER_MAXIMUM_LENGTH");
        
        // 优先使用预定义宽度
        if (COLUMN_WIDTH_MAP.containsKey(columnName.toLowerCase())) {
            return COLUMN_WIDTH_MAP.get(columnName.toLowerCase());
        }
        
        // 根据注释长度计算
        int commentLength = comment != null ? comment.length() : 0;
        int nameLength = columnName.length();
        int headerWidth = Math.max(commentLength, nameLength);
        
        // 根据字段最大长度计算
        int dataWidth = 15; // 默认宽度
        if (characterMaximumLength != null) {
            try {
                int maxLength = Integer.parseInt(characterMaximumLength.toString());
                dataWidth = Math.min(maxLength, 50); // 最大不超过50
            } catch (NumberFormatException e) {
                // 忽略转换异常
            }
        }
        
        return Math.max(headerWidth, dataWidth) + 2; // 额外增加2个字符的边距
    }
    
    @Override
    public Map<String, CellStyle> createStyleMap(XSSFWorkbook workbook, HeaderStyle headerStyle) {
        Map<String, CellStyle> styleMap = new HashMap<>();
        
        // 创建字体
        Font titleFont = workbook.createFont();
        titleFont.setBold(true);
        titleFont.setFontHeightInPoints((short) 16);
        titleFont.setColor(IndexedColors.WHITE.index);
        
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerFont.setFontHeightInPoints((short) 12);
        
        Font dataFont = workbook.createFont();
        dataFont.setFontHeightInPoints((short) 10);
        
        // 标题样式
        CellStyle titleStyle = workbook.createCellStyle();
        titleStyle.setFont(titleFont);
        titleStyle.setAlignment(HorizontalAlignment.CENTER);
        titleStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        titleStyle.setFillForegroundColor(IndexedColors.DARK_BLUE.index);
        titleStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        setBorders(titleStyle);
        styleMap.put("title", titleStyle);
        
        // 根据样式类型创建表头样式
        createHeaderStyles(workbook, styleMap, headerFont, headerStyle);
        
        // 数据样式
        CellStyle dataStyle = workbook.createCellStyle();
        dataStyle.setFont(dataFont);
        dataStyle.setAlignment(HorizontalAlignment.LEFT);
        dataStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        setBorders(dataStyle);
        styleMap.put("data", dataStyle);
        
        return styleMap;
    }
    
    // 私有辅助方法
    
    private int getExampleRowCount(ExampleDataType exampleDataType) {
        switch (exampleDataType) {
            case SIMPLE:
                return 1;
            case DETAILED:
                return 3;
            case REALISTIC:
                return 5;
            default:
                return 0;
        }
    }
    
    private DataValidationConstraint createValidationConstraint(DataValidationHelper helper, Map<String, Object> rules) {
        log.debug("创建验证约束，规则: {}", rules);
        String ruleType = (String) rules.get("type");
        
        if (ruleType == null) {
            log.warn("验证规则类型为空，跳过创建约束");
            return null;
        }
        
        log.debug("处理验证规则类型: {}", ruleType);
        
        switch (ruleType) {
            case "ENUM":
                List<String> enumValues = (List<String>) rules.get("values");
                if (enumValues == null || enumValues.isEmpty()) {
                    log.warn("ENUM类型验证规则的值列表为空，跳过创建约束");
                    return null;
                }
                log.debug("创建ENUM约束，选项数量: {}", enumValues.size());
                return helper.createExplicitListConstraint(enumValues.toArray(new String[0]));
                
            case "LENGTH":
                Integer maxLength = (Integer) rules.get("maxLength");
                if (maxLength == null || maxLength <= 0) {
                    log.warn("LENGTH类型验证规则的最大长度无效: {}", maxLength);
                    return null;
                }
                log.debug("创建LENGTH约束，最大长度: {}", maxLength);
                return helper.createTextLengthConstraint(DataValidationConstraint.OperatorType.LESS_OR_EQUAL, "0", maxLength.toString());
                
            case "NUMERIC_RANGE":
                Double minValue = (Double) rules.get("minValue");
                Double maxValue = (Double) rules.get("maxValue");
                if (minValue == null && maxValue == null) {
                    log.warn("NUMERIC_RANGE类型验证规则的最小值和最大值都为空，跳过创建约束");
                    return null;
                }
                String minStr = minValue != null ? minValue.toString() : "0";
                String maxStr = maxValue != null ? maxValue.toString() : "999999";
                log.debug("创建NUMERIC_RANGE约束，范围: {} - {}", minStr, maxStr);
                return helper.createDecimalConstraint(DataValidationConstraint.OperatorType.BETWEEN, minStr, maxStr);
                
            case "DATE_FORMAT":
                log.debug("创建DATE_FORMAT约束，日期范围: 1900-01-01 到 2100-12-31");
                return helper.createDateConstraint(DataValidationConstraint.OperatorType.BETWEEN, 
                    "1900-01-01", "2100-12-31", "yyyy-mm-dd");
                
            default:
                log.warn("未知的验证规则类型: {}", ruleType);
                return null;
        }
    }
    
    private String getValidationErrorMessage(Map<String, Object> rules) {
        String ruleType = (String) rules.get("type");
        
        switch (ruleType) {
            case "REQUIRED":
                return "此字段为必填项，不能为空";
            case "ENUM":
                return "请从下拉列表中选择有效值";
            case "LENGTH":
                Integer maxLength = (Integer) rules.get("maxLength");
                return "输入长度不能超过" + maxLength + "个字符";
            case "NUMERIC_RANGE":
                Double minValue = (Double) rules.get("minValue");
                Double maxValue = (Double) rules.get("maxValue");
                return String.format("数值必须在%s到%s之间", minValue, maxValue);
            case "DATE_FORMAT":
                return "请输入有效的日期格式（yyyy-MM-dd）";
            default:
                return "输入值不符合要求";
        }
    }
    
    private String generateExampleByDataType(String dataType, ExampleDataType exampleDataType) {
        if (dataType == null) {
            return "";
        }
        
        String lowerDataType = dataType.toLowerCase();
        
        if (lowerDataType.contains("varchar") || lowerDataType.contains("text")) {
            return exampleDataType == ExampleDataType.REALISTIC ? "真实示例文本" : "示例文本";
        } else if (lowerDataType.contains("int") || lowerDataType.contains("bigint")) {
            return exampleDataType == ExampleDataType.REALISTIC ? "12345" : "1";
        } else if (lowerDataType.contains("decimal") || lowerDataType.contains("float") || lowerDataType.contains("double")) {
            return exampleDataType == ExampleDataType.REALISTIC ? "123.45" : "1.0";
        } else if (lowerDataType.contains("date")) {
            return LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        } else if (lowerDataType.contains("datetime") || lowerDataType.contains("timestamp")) {
            return LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        } else if (lowerDataType.contains("bit") || lowerDataType.contains("boolean")) {
            return "1";
        }
        
        return "";
    }
    
    private Map<String, List<String>> extractDictionaries(Map<String, Map<String, Map<String, Object>>> validationRules) {
        Map<String, List<String>> dictionaries = new HashMap<>();
        
        for (Map<String, Map<String, Object>> tableRules : validationRules.values()) {
            for (Map.Entry<String, Map<String, Object>> entry : tableRules.entrySet()) {
                String columnName = entry.getKey();
                Map<String, Object> rules = entry.getValue();
                
                if ("ENUM".equals(rules.get("type"))) {
                    List<String> values = (List<String>) rules.get("values");
                    if (values != null && !values.isEmpty()) {
                        dictionaries.put(columnName, values);
                    }
                }
            }
        }
        
        return dictionaries;
    }
    
    private void createHeaderStyles(XSSFWorkbook workbook, Map<String, CellStyle> styleMap, Font headerFont, HeaderStyle headerStyle) {
        switch (headerStyle) {
            case PROFESSIONAL:
                createProfessionalHeaderStyles(workbook, styleMap, headerFont);
                break;
            case COLORFUL:
                createColorfulHeaderStyles(workbook, styleMap, headerFont);
                break;
            default:
                createBasicHeaderStyles(workbook, styleMap, headerFont);
                break;
        }
    }
    
    private void createBasicHeaderStyles(XSSFWorkbook workbook, Map<String, CellStyle> styleMap, Font headerFont) {
        // 第一行表头样式
        CellStyle header1Style = workbook.createCellStyle();
        header1Style.setFont(headerFont);
        header1Style.setAlignment(HorizontalAlignment.CENTER);
        header1Style.setVerticalAlignment(VerticalAlignment.CENTER);
        header1Style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.index);
        header1Style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        setBorders(header1Style);
        styleMap.put("header1", header1Style);
        
        // 第二行表头样式
        CellStyle header2Style = workbook.createCellStyle();
        header2Style.setFont(headerFont);
        header2Style.setAlignment(HorizontalAlignment.CENTER);
        header2Style.setVerticalAlignment(VerticalAlignment.CENTER);
        header2Style.setFillForegroundColor(IndexedColors.GREY_40_PERCENT.index);
        header2Style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        setBorders(header2Style);
        styleMap.put("header2", header2Style);
    }
    
    private void createProfessionalHeaderStyles(XSSFWorkbook workbook, Map<String, CellStyle> styleMap, Font headerFont) {
        // 第一行表头样式
        CellStyle header1Style = workbook.createCellStyle();
        header1Style.setFont(headerFont);
        header1Style.setAlignment(HorizontalAlignment.CENTER);
        header1Style.setVerticalAlignment(VerticalAlignment.CENTER);
        header1Style.setFillForegroundColor(IndexedColors.DARK_BLUE.index);
        header1Style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        
        Font whiteFont = workbook.createFont();
        whiteFont.setBold(true);
        whiteFont.setFontHeightInPoints((short) 12);
        whiteFont.setColor(IndexedColors.WHITE.index);
        header1Style.setFont(whiteFont);
        setBorders(header1Style);
        styleMap.put("header1", header1Style);
        
        // 第二行表头样式
        CellStyle header2Style = workbook.createCellStyle();
        header2Style.setFont(headerFont);
        header2Style.setAlignment(HorizontalAlignment.CENTER);
        header2Style.setVerticalAlignment(VerticalAlignment.CENTER);
        header2Style.setFillForegroundColor(IndexedColors.LIGHT_BLUE.index);
        header2Style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        setBorders(header2Style);
        styleMap.put("header2", header2Style);
    }
    
    private void createColorfulHeaderStyles(XSSFWorkbook workbook, Map<String, CellStyle> styleMap, Font headerFont) {
        // 第一行表头样式
        CellStyle header1Style = workbook.createCellStyle();
        header1Style.setFont(headerFont);
        header1Style.setAlignment(HorizontalAlignment.CENTER);
        header1Style.setVerticalAlignment(VerticalAlignment.CENTER);
        header1Style.setFillForegroundColor(IndexedColors.LIGHT_GREEN.index);
        header1Style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        setBorders(header1Style);
        styleMap.put("header1", header1Style);
        
        // 第二行表头样式
        CellStyle header2Style = workbook.createCellStyle();
        header2Style.setFont(headerFont);
        header2Style.setAlignment(HorizontalAlignment.CENTER);
        header2Style.setVerticalAlignment(VerticalAlignment.CENTER);
        header2Style.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.index);
        header2Style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        setBorders(header2Style);
        styleMap.put("header2", header2Style);
    }
    
    private void setBorders(CellStyle style) {
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        style.setTopBorderColor(IndexedColors.BLACK.index);
        style.setBottomBorderColor(IndexedColors.BLACK.index);
        style.setLeftBorderColor(IndexedColors.BLACK.index);
        style.setRightBorderColor(IndexedColors.BLACK.index);
    }
}