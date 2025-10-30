package com.ruoyi.system.service;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 * MSDS模板Excel写出器接口
 * 
 * @author ruoyi
 */
public interface IMsdsTemplateXlsxWriter
{
    /**
     * 表头样式类型
     */
    enum HeaderStyle {
        BASIC("基础样式"),
        PROFESSIONAL("专业样式"),
        COLORFUL("彩色样式");
        
        private final String description;
        
        HeaderStyle(String description) {
            this.description = description;
        }
        
        public String getDescription() {
            return description;
        }
    }
    
    /**
     * 示例数据类型
     */
    enum ExampleDataType {
        NONE("无示例"),
        SIMPLE("简单示例"),
        DETAILED("详细示例"),
        REALISTIC("真实示例");
        
        private final String description;
        
        ExampleDataType(String description) {
            this.description = description;
        }
        
        public String getDescription() {
            return description;
        }
    }
    
    /**
     * 创建新的工作簿
     * 
     * @return XSSFWorkbook实例
     */
    XSSFWorkbook createWorkbook();
    
    /**
     * 创建表格Sheet
     * 
     * @param workbook 工作簿
     * @param tableName 表名
     * @param columns 列信息列表
     * @param headerStyle 表头样式
     * @param exampleDataType 示例数据类型
     * @return Sheet索引
     */
    int createTableSheet(XSSFWorkbook workbook, String tableName, 
                        List<Map<String, Object>> columns, 
                        HeaderStyle headerStyle, 
                        ExampleDataType exampleDataType);
    
    /**
     * 创建双行列头
     * 
     * @param workbook 工作簿
     * @param sheetIndex Sheet索引
     * @param columns 列信息列表
     * @param headerStyle 表头样式
     */
    void createDoubleRowHeader(XSSFWorkbook workbook, int sheetIndex, 
                              List<Map<String, Object>> columns, 
                              HeaderStyle headerStyle);
    
    /**
     * 添加示例数据行
     * 
     * @param workbook 工作簿
     * @param sheetIndex Sheet索引
     * @param columns 列信息列表
     * @param exampleDataType 示例数据类型
     * @param startRow 起始行号
     */
    void addExampleRows(XSSFWorkbook workbook, int sheetIndex, 
                       List<Map<String, Object>> columns, 
                       ExampleDataType exampleDataType, 
                       int startRow);
    
    /**
     * 设置列宽度
     * 
     * @param workbook 工作簿
     * @param sheetIndex Sheet索引
     * @param columns 列信息列表
     */
    void setColumnWidths(XSSFWorkbook workbook, int sheetIndex, 
                        List<Map<String, Object>> columns);
    
    /**
     * 应用数据验证规则
     * 
     * @param workbook 工作簿
     * @param sheetIndex Sheet索引
     * @param columns 列信息列表
     * @param validationRules 验证规则映射
     * @param startRow 起始行号
     * @param endRow 结束行号
     */
    void applyDataValidation(XSSFWorkbook workbook, int sheetIndex, 
                           List<Map<String, Object>> columns, 
                           Map<String, Map<String, Object>> validationRules, 
                           int startRow, int endRow);
    
    /**
     * 创建说明Sheet
     * 
     * @param workbook 工作簿
     * @param instructions 说明内容
     * @return Sheet索引
     */
    int createInstructionSheet(XSSFWorkbook workbook, Map<String, Object> instructions);
    
    /**
     * 创建字典Sheet
     * 
     * @param workbook 工作簿
     * @param dictionaries 字典数据
     * @return Sheet索引
     */
    int createDictionarySheet(XSSFWorkbook workbook, Map<String, List<String>> dictionaries);
    
    /**
     * 设置Sheet保护
     * 
     * @param workbook 工作簿
     * @param sheetIndex Sheet索引
     * @param password 保护密码
     * @param allowedOperations 允许的操作列表
     */
    void setSheetProtection(XSSFWorkbook workbook, int sheetIndex, 
                           String password, List<String> allowedOperations);
    
    /**
     * 冻结窗格
     * 
     * @param workbook 工作簿
     * @param sheetIndex Sheet索引
     * @param colSplit 列分割位置
     * @param rowSplit 行分割位置
     */
    void freezePanes(XSSFWorkbook workbook, int sheetIndex, int colSplit, int rowSplit);
    
    /**
     * 添加条件格式
     * 
     * @param workbook 工作簿
     * @param sheetIndex Sheet索引
     * @param columns 列信息列表
     * @param startRow 起始行号
     * @param endRow 结束行号
     */
    void addConditionalFormatting(XSSFWorkbook workbook, int sheetIndex, 
                                 List<Map<String, Object>> columns, 
                                 int startRow, int endRow);
    
    /**
     * 生成完整的Excel模板
     * 
     * @param tableMetadata 表元数据映射
     * @param validationRules 验证规则映射
     * @param headerStyle 表头样式
     * @param exampleDataType 示例数据类型
     * @param includeInstructions 是否包含说明
     * @param includeDictionary 是否包含字典
     * @return Excel文件字节数组
     */
    byte[] generateTemplate(Map<String, List<Map<String, Object>>> tableMetadata, 
                           Map<String, Map<String, Map<String, Object>>> validationRules, 
                           HeaderStyle headerStyle, 
                           ExampleDataType exampleDataType, 
                           boolean includeInstructions, 
                           boolean includeDictionary);
    
    /**
     * 将工作簿转换为字节数组
     * 
     * @param workbook 工作簿
     * @return 字节数组
     */
    byte[] workbookToBytes(XSSFWorkbook workbook);
    
    /**
     * 生成示例数据
     * 
     * @param columnMetadata 列元数据
     * @param exampleDataType 示例数据类型
     * @return 示例值
     */
    String generateExampleData(Map<String, Object> columnMetadata, ExampleDataType exampleDataType);
    
    /**
     * 计算最优列宽
     * 
     * @param columnMetadata 列元数据
     * @return 列宽（字符数）
     */
    int calculateOptimalColumnWidth(Map<String, Object> columnMetadata);
    
    /**
     * 创建样式映射
     * 
     * @param workbook 工作簿
     * @param headerStyle 表头样式
     * @return 样式映射
     */
    Map<String, org.apache.poi.ss.usermodel.CellStyle> createStyleMap(XSSFWorkbook workbook, HeaderStyle headerStyle);
}