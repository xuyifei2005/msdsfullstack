package com.ruoyi.common.utils.poi;

import java.io.InputStream;
import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.util.*;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import org.apache.poi.ss.usermodel.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.text.Convert;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.StringUtils;

/**
 * Excel导入校验工具类
 * 提供基于模板的数据校验功能，包含列头匹配、字段校验、错误定位和修复建议
 * 
 * @author ruoyi
 */
@Component
public class ExcelValidationUtil<T> {
    
    private static final Logger log = LoggerFactory.getLogger(ExcelValidationUtil.class);
    
    /**
     * 实体类
     */
    private Class<T> clazz;
    
    /**
     * 校验结果
     */
    private ValidationResult<T> validationResult;
    
    /**
     * 字段映射
     */
    private Map<String, Field> fieldMap;
    
    /**
     * Excel注解映射
     */
    private Map<String, Excel> excelAnnotationMap;
    
    /**
     * 构造函数
     */
    public ExcelValidationUtil() {
    }
    
    /**
     * 构造函数
     */
    public ExcelValidationUtil(Class<T> clazz) {
        this.clazz = clazz;
        this.validationResult = new ValidationResult<>();
        this.fieldMap = new HashMap<>();
        this.excelAnnotationMap = new HashMap<>();
        initFieldMapping();
    }
    
    /**
     * 初始化字段映射
     */
    private void initFieldMapping() {
        Field[] fields = clazz.getDeclaredFields();
        for (Field field : fields) {
            Excel excel = field.getAnnotation(Excel.class);
            if (excel != null) {
                fieldMap.put(excel.name(), field);
                excelAnnotationMap.put(excel.name(), excel);
            }
        }
    }
    
    /**
     * 校验Excel文件
     */
    public ValidationResult<T> validateExcel(InputStream is, String sheetName, int titleNum) {
        try {
            Workbook workbook = WorkbookFactory.create(is);
            Sheet sheet = StringUtils.isNotEmpty(sheetName) ? workbook.getSheet(sheetName) : workbook.getSheetAt(0);
            
            if (sheet == null) {
                validationResult.setSuccess(false);
                validationResult.setMessage("工作表不存在: " + sheetName);
                return validationResult;
            }
            
            // 校验列头
            Row headerRow = sheet.getRow(titleNum - 1);
            if (headerRow == null) {
                validationResult.setSuccess(false);
                validationResult.setMessage("标题行不存在");
                return validationResult;
            }
            
            Map<Integer, String> columnMapping = validateHeaders(headerRow);
            if (columnMapping.isEmpty()) {
                validationResult.setSuccess(false);
                validationResult.setMessage("未找到有效的列头映射");
                return validationResult;
            }
            
            // 校验数据行
            int totalRows = sheet.getLastRowNum() + 1;
            validationResult.setTotalRows(totalRows - titleNum);
            
            for (int i = titleNum; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (isRowEmpty(row)) {
                    continue;
                }
                
                T entity = validateRow(row, columnMapping, i + 1);
                if (entity != null) {
                    validationResult.addValidData(entity);
                    validationResult.setValidRows(validationResult.getValidRows() + 1);
                }
            }
            
            validationResult.setErrorRows(validationResult.getTotalRows() - validationResult.getValidRows());
            validationResult.setSuccess(validationResult.getErrors().isEmpty());
            
            if (validationResult.isSuccess()) {
                validationResult.setMessage("校验成功");
            } else {
                validationResult.setMessage("校验失败，共发现 " + validationResult.getErrors().size() + " 个错误");
            }
            
        } catch (Exception e) {
            log.error("Excel校验异常", e);
            validationResult.setSuccess(false);
            validationResult.setMessage("Excel校验异常: " + e.getMessage());
        }
        
        return validationResult;
    }
    
    /**
     * 校验列头
     */
    private Map<Integer, String> validateHeaders(Row headerRow) {
        Map<Integer, String> columnMapping = new HashMap<>();
        
        for (int i = 0; i < headerRow.getLastCellNum(); i++) {
            Cell cell = headerRow.getCell(i);
            if (cell != null) {
                String headerName = getCellValue(cell).toString().trim();
                if (StringUtils.isNotEmpty(headerName) && fieldMap.containsKey(headerName)) {
                    columnMapping.put(i, headerName);
                }
            }
        }
        
        return columnMapping;
    }
    
    /**
     * 校验数据行
     */
    private T validateRow(Row row, Map<Integer, String> columnMapping, int rowNum) {
        try {
            T entity = clazz.newInstance();
            boolean hasError = false;
            
            for (Map.Entry<Integer, String> entry : columnMapping.entrySet()) {
                int columnIndex = entry.getKey();
                String fieldName = entry.getValue();
                
                Cell cell = row.getCell(columnIndex);
                Object cellValue = getCellValue(cell);
                
                Field field = fieldMap.get(fieldName);
                Excel excel = excelAnnotationMap.get(fieldName);
                
                // 基础校验 - 检查空值
                if (cellValue == null || StringUtils.isEmpty(cellValue.toString())) {
                    // 可以根据业务需要添加必填字段校验逻辑
                    continue;
                }
                
                // 类型转换和校验
                if (cellValue != null && StringUtils.isNotEmpty(cellValue.toString())) {
                    try {
                        Object convertedValue = convertCellValue(cellValue, field.getType(), excel);
                        field.setAccessible(true);
                        field.set(entity, convertedValue);
                    } catch (Exception e) {
                        validationResult.addError(rowNum, columnIndex, "数据格式错误: " + e.getMessage(), "请检查数据格式");
                        hasError = true;
                    }
                }
            }
            
            return hasError ? null : entity;
            
        } catch (Exception e) {
            log.error("校验行数据异常，行号: " + rowNum, e);
            validationResult.addError(rowNum, 0, "行数据处理异常: " + e.getMessage(), "请检查行数据格式");
            return null;
        }
    }
    
    /**
     * 转换单元格值
     */
    private Object convertCellValue(Object cellValue, Class<?> fieldType, Excel excel) throws Exception {
        if (cellValue == null) {
            return null;
        }
        
        String strValue = cellValue.toString().trim();
        if (StringUtils.isEmpty(strValue)) {
            return null;
        }
        
        if (fieldType == String.class) {
            return strValue;
        } else if (fieldType == Integer.class || fieldType == int.class) {
            return Integer.valueOf(strValue);
        } else if (fieldType == Long.class || fieldType == long.class) {
            return Long.valueOf(strValue);
        } else if (fieldType == Double.class || fieldType == double.class) {
            return Double.valueOf(strValue);
        } else if (fieldType == BigDecimal.class) {
            return new BigDecimal(strValue);
        } else if (fieldType == Date.class) {
            return DateUtils.parseDate(strValue);
        } else {
            return strValue;
        }
    }
    
    /**
     * 获取单元格值
     */
    private Object getCellValue(Cell cell) {
        if (cell == null) {
            return null;
        }
        
        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue();
            case NUMERIC:
                if (DateUtil.isCellDateFormatted(cell)) {
                    return cell.getDateCellValue();
                } else {
                    return cell.getNumericCellValue();
                }
            case BOOLEAN:
                return cell.getBooleanCellValue();
            case FORMULA:
                return cell.getCellFormula();
            case BLANK:
                return null;
            default:
                return cell.toString();
        }
    }
    
    /**
     * 判断行是否为空
     */
    private boolean isRowEmpty(Row row) {
        if (row == null) {
            return true;
        }
        
        for (int i = 0; i < row.getPhysicalNumberOfCells(); i++) {
            Cell cell = row.getCell(i);
            if (cell != null && cell.getCellType() != CellType.BLANK) {
                String cellValue = getCellValue(cell).toString().trim();
                if (StringUtils.isNotEmpty(cellValue)) {
                    return false;
                }
            }
        }
        return true;
    }
    
    /**
     * 获取校验结果
     */
    public ValidationResult<T> getValidationResult() {
        return validationResult;
    }
    
    /**
     * 静态方法：校验Excel文件
     */
    public static <T> ValidationResult<T> validateExcel(InputStream is, Class<T> clazz, String sheetName, int titleNum) {
        ExcelValidationUtil<T> validator = new ExcelValidationUtil<>(clazz);
        return validator.validateExcel(is, sheetName, titleNum);
    }
    
    /**
     * 校验结果类
     */
    public static class ValidationResult<T> {
        private boolean success;
        private String message;
        private List<ValidationError> errors;
        private List<T> validData;
        private int totalRows;
        private int validRows;
        private int errorRows;

        public ValidationResult() {
            this.errors = new ArrayList<>();
            this.validData = new ArrayList<>();
        }

        // Getters and Setters
        public boolean isSuccess() {
            return success;
        }

        public void setSuccess(boolean success) {
            this.success = success;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }

        public List<ValidationError> getErrors() {
            return errors;
        }

        public void setErrors(List<ValidationError> errors) {
            this.errors = errors;
        }

        public List<T> getValidData() {
            return validData;
        }

        public void setValidData(List<T> validData) {
            this.validData = validData;
        }

        public int getTotalRows() {
            return totalRows;
        }

        public void setTotalRows(int totalRows) {
            this.totalRows = totalRows;
        }

        public int getValidRows() {
            return validRows;
        }

        public void setValidRows(int validRows) {
            this.validRows = validRows;
        }

        public int getErrorRows() {
            return errorRows;
        }

        public void setErrorRows(int errorRows) {
            this.errorRows = errorRows;
        }

        public void addError(ValidationError error) {
            this.errors.add(error);
        }
        
        public void addError(int rowIndex, int columnIndex, String errorMessage, String suggestion) {
            ValidationError error = new ValidationError();
            error.setRowIndex(rowIndex);
            error.setColumnName("列" + columnIndex);
            error.setErrorMessage(errorMessage);
            error.setErrorType(suggestion);
            this.errors.add(error);
        }

        public void addValidData(T data) {
            this.validData.add(data);
        }
    }
    
    /**
     * 校验错误类
     */
    public static class ValidationError {
        private int rowIndex;
        private String columnName;
        private String errorMessage;
        private String errorType;

        public ValidationError() {
        }

        public ValidationError(int rowIndex, String columnName, String errorMessage, String errorType) {
            this.rowIndex = rowIndex;
            this.columnName = columnName;
            this.errorMessage = errorMessage;
            this.errorType = errorType;
        }

        // Getters and Setters
        public int getRowIndex() {
            return rowIndex;
        }

        public void setRowIndex(int rowIndex) {
            this.rowIndex = rowIndex;
        }

        public String getColumnName() {
            return columnName;
        }

        public void setColumnName(String columnName) {
            this.columnName = columnName;
        }

        public String getErrorMessage() {
            return errorMessage;
        }

        public void setErrorMessage(String errorMessage) {
            this.errorMessage = errorMessage;
        }

        public String getErrorType() {
            return errorType;
        }

        public void setErrorType(String errorType) {
            this.errorType = errorType;
        }

        @Override
        public String toString() {
            return "ValidationError{" +
                    "rowIndex=" + rowIndex +
                    ", columnName='" + columnName + '\'' +
                    ", errorMessage='" + errorMessage + '\'' +
                    ", errorType='" + errorType + '\'' +
                    '}';
        }
    }
}