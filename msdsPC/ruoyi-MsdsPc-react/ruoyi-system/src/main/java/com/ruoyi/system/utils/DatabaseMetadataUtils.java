package com.ruoyi.system.utils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.sql.DataSource;
import java.sql.*;
import java.util.*;

/**
 * 数据库元数据获取工具类
 * 用于动态获取数据库表结构信息，支持模板生成器
 * 
 * @author ruoyi
 */
@Component
public class DatabaseMetadataUtils {
    
    private static final Logger log = LoggerFactory.getLogger(DatabaseMetadataUtils.class);
    
    @Autowired
    private DataSource dataSource;
    
    /**
     * 表列信息
     */
    public static class ColumnInfo {
        private String columnName;        // 列名
        private String columnType;        // 列类型
        private String dataType;          // 数据类型
        private int columnSize;           // 列大小
        private int decimalDigits;        // 小数位数
        private boolean nullable;         // 是否可空
        private String defaultValue;     // 默认值
        private String remarks;           // 注释
        private boolean primaryKey;      // 是否主键
        private boolean autoIncrement;   // 是否自增
        
        // Getters and Setters
        public String getColumnName() { return columnName; }
        public void setColumnName(String columnName) { this.columnName = columnName; }
        
        public String getColumnType() { return columnType; }
        public void setColumnType(String columnType) { this.columnType = columnType; }
        
        public String getDataType() { return dataType; }
        public void setDataType(String dataType) { this.dataType = dataType; }
        
        public int getColumnSize() { return columnSize; }
        public void setColumnSize(int columnSize) { this.columnSize = columnSize; }
        
        public int getDecimalDigits() { return decimalDigits; }
        public void setDecimalDigits(int decimalDigits) { this.decimalDigits = decimalDigits; }
        
        public boolean isNullable() { return nullable; }
        public void setNullable(boolean nullable) { this.nullable = nullable; }
        
        public String getDefaultValue() { return defaultValue; }
        public void setDefaultValue(String defaultValue) { this.defaultValue = defaultValue; }
        
        public String getRemarks() { return remarks; }
        public void setRemarks(String remarks) { this.remarks = remarks; }
        
        public boolean isPrimaryKey() { return primaryKey; }
        public void setPrimaryKey(boolean primaryKey) { this.primaryKey = primaryKey; }
        
        public boolean isAutoIncrement() { return autoIncrement; }
        public void setAutoIncrement(boolean autoIncrement) { this.autoIncrement = autoIncrement; }
    }
    
    /**
     * 表信息
     */
    public static class TableInfo {
        private String tableName;         // 表名
        private String tableComment;      // 表注释
        private String tableType;         // 表类型
        private List<ColumnInfo> columns; // 列信息列表
        
        public TableInfo() {
            this.columns = new ArrayList<>();
        }
        
        // Getters and Setters
        public String getTableName() { return tableName; }
        public void setTableName(String tableName) { this.tableName = tableName; }
        
        public String getTableComment() { return tableComment; }
        public void setTableComment(String tableComment) { this.tableComment = tableComment; }
        
        public String getTableType() { return tableType; }
        public void setTableType(String tableType) { this.tableType = tableType; }
        
        public List<ColumnInfo> getColumns() { return columns; }
        public void setColumns(List<ColumnInfo> columns) { this.columns = columns; }
    }
    
    /**
     * 获取所有MSDS相关表的元数据信息
     * 
     * @return MSDS表信息列表
     */
    public List<TableInfo> getMsdsTablesMetadata() {
        List<TableInfo> tables = new ArrayList<>();
        
        try (Connection connection = dataSource.getConnection()) {
            DatabaseMetaData metaData = connection.getMetaData();
            String catalog = connection.getCatalog();
            
            // 获取所有以msds_开头的表
            try (ResultSet tableResultSet = metaData.getTables(catalog, null, "msds_%", new String[]{"TABLE"})) {
                while (tableResultSet.next()) {
                    TableInfo tableInfo = new TableInfo();
                    tableInfo.setTableName(tableResultSet.getString("TABLE_NAME"));
                    tableInfo.setTableComment(tableResultSet.getString("REMARKS"));
                    tableInfo.setTableType(tableResultSet.getString("TABLE_TYPE"));
                    
                    // 获取表的列信息
                    List<ColumnInfo> columns = getTableColumns(metaData, catalog, tableInfo.getTableName());
                    tableInfo.setColumns(columns);
                    
                    tables.add(tableInfo);
                    log.debug("获取表元数据: {} ({}列)", tableInfo.getTableName(), columns.size());
                }
            }
            
        } catch (SQLException e) {
            log.error("获取数据库元数据失败", e);
            throw new RuntimeException("获取数据库元数据失败: " + e.getMessage(), e);
        }
        
        log.info("成功获取{}个MSDS表的元数据信息", tables.size());
        return tables;
    }
    
    /**
     * 获取指定表的元数据信息
     * 
     * @param tableName 表名
     * @return 表信息
     */
    public TableInfo getTableMetadata(String tableName) {
        try (Connection connection = dataSource.getConnection()) {
            DatabaseMetaData metaData = connection.getMetaData();
            String catalog = connection.getCatalog();
            
            try (ResultSet tableResultSet = metaData.getTables(catalog, null, tableName, new String[]{"TABLE"})) {
                if (tableResultSet.next()) {
                    TableInfo tableInfo = new TableInfo();
                    tableInfo.setTableName(tableResultSet.getString("TABLE_NAME"));
                    tableInfo.setTableComment(tableResultSet.getString("REMARKS"));
                    tableInfo.setTableType(tableResultSet.getString("TABLE_TYPE"));
                    
                    // 获取表的列信息
                    List<ColumnInfo> columns = getTableColumns(metaData, catalog, tableName);
                    tableInfo.setColumns(columns);
                    
                    log.debug("获取表元数据: {} ({}列)", tableName, columns.size());
                    return tableInfo;
                }
            }
            
        } catch (SQLException e) {
            log.error("获取表{}元数据失败", tableName, e);
            throw new RuntimeException("获取表元数据失败: " + e.getMessage(), e);
        }
        
        return null;
    }
    
    /**
     * 获取表的列信息
     * 
     * @param metaData 数据库元数据
     * @param catalog 数据库目录
     * @param tableName 表名
     * @return 列信息列表
     */
    private List<ColumnInfo> getTableColumns(DatabaseMetaData metaData, String catalog, String tableName) throws SQLException {
        List<ColumnInfo> columns = new ArrayList<>();
        Set<String> primaryKeys = getPrimaryKeys(metaData, catalog, tableName);
        
        try (ResultSet columnResultSet = metaData.getColumns(catalog, null, tableName, null)) {
            while (columnResultSet.next()) {
                ColumnInfo columnInfo = new ColumnInfo();
                
                String columnName = columnResultSet.getString("COLUMN_NAME");
                columnInfo.setColumnName(columnName);
                columnInfo.setColumnType(columnResultSet.getString("TYPE_NAME"));
                columnInfo.setDataType(getJavaDataType(columnResultSet.getInt("DATA_TYPE")));
                columnInfo.setColumnSize(columnResultSet.getInt("COLUMN_SIZE"));
                columnInfo.setDecimalDigits(columnResultSet.getInt("DECIMAL_DIGITS"));
                columnInfo.setNullable(columnResultSet.getInt("NULLABLE") == DatabaseMetaData.columnNullable);
                columnInfo.setDefaultValue(columnResultSet.getString("COLUMN_DEF"));
                columnInfo.setRemarks(columnResultSet.getString("REMARKS"));
                columnInfo.setPrimaryKey(primaryKeys.contains(columnName));
                columnInfo.setAutoIncrement("YES".equals(columnResultSet.getString("IS_AUTOINCREMENT")));
                
                columns.add(columnInfo);
            }
        }
        
        return columns;
    }
    
    /**
     * 获取表的主键列
     * 
     * @param metaData 数据库元数据
     * @param catalog 数据库目录
     * @param tableName 表名
     * @return 主键列名集合
     */
    private Set<String> getPrimaryKeys(DatabaseMetaData metaData, String catalog, String tableName) throws SQLException {
        Set<String> primaryKeys = new HashSet<>();
        
        try (ResultSet primaryKeyResultSet = metaData.getPrimaryKeys(catalog, null, tableName)) {
            while (primaryKeyResultSet.next()) {
                primaryKeys.add(primaryKeyResultSet.getString("COLUMN_NAME"));
            }
        }
        
        return primaryKeys;
    }
    
    /**
     * 将SQL数据类型转换为Java数据类型
     * 
     * @param sqlType SQL数据类型
     * @return Java数据类型字符串
     */
    private String getJavaDataType(int sqlType) {
        switch (sqlType) {
            case Types.BIGINT:
                return "Long";
            case Types.INTEGER:
            case Types.SMALLINT:
            case Types.TINYINT:
                return "Integer";
            case Types.DECIMAL:
            case Types.NUMERIC:
                return "BigDecimal";
            case Types.DOUBLE:
            case Types.FLOAT:
            case Types.REAL:
                return "Double";
            case Types.VARCHAR:
            case Types.CHAR:
            case Types.LONGVARCHAR:
            case Types.NVARCHAR:
            case Types.NCHAR:
            case Types.LONGNVARCHAR:
            case Types.CLOB:
            case Types.NCLOB:
                return "String";
            case Types.DATE:
                return "Date";
            case Types.TIME:
                return "Time";
            case Types.TIMESTAMP:
                return "Date";
            case Types.BOOLEAN:
            case Types.BIT:
                return "Boolean";
            case Types.BLOB:
            case Types.BINARY:
            case Types.VARBINARY:
            case Types.LONGVARBINARY:
                return "byte[]";
            default:
                return "String";
        }
    }
    
    /**
     * 获取表的中文显示名称
     * 优先使用表注释，如果没有注释则使用表名
     * 
     * @param tableInfo 表信息
     * @return 表的显示名称
     */
    public String getTableDisplayName(TableInfo tableInfo) {
        if (tableInfo.getTableComment() != null && !tableInfo.getTableComment().trim().isEmpty()) {
            return tableInfo.getTableComment();
        }
        return tableInfo.getTableName();
    }
    
    /**
     * 获取列的中文显示名称
     * 优先使用列注释，如果没有注释则使用列名
     * 
     * @param columnInfo 列信息
     * @return 列的显示名称
     */
    public String getColumnDisplayName(ColumnInfo columnInfo) {
        if (columnInfo.getRemarks() != null && !columnInfo.getRemarks().trim().isEmpty()) {
            return columnInfo.getRemarks();
        }
        return columnInfo.getColumnName();
    }
    
    /**
     * 检查列是否为必填字段
     * 
     * @param columnInfo 列信息
     * @return 是否必填
     */
    public boolean isRequiredField(ColumnInfo columnInfo) {
        // 主键且非自增，或者非空且无默认值的字段为必填
        return (columnInfo.isPrimaryKey() && !columnInfo.isAutoIncrement()) 
            || (!columnInfo.isNullable() && (columnInfo.getDefaultValue() == null || columnInfo.getDefaultValue().trim().isEmpty()));
    }
}