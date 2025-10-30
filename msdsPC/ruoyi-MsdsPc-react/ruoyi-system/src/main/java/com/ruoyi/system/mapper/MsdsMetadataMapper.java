package com.ruoyi.system.mapper;

import java.util.List;
import java.util.Map;

/**
 * MSDS元数据查询Mapper接口
 * 
 * @author ruoyi
 */
public interface MsdsMetadataMapper
{
    /**
     * 获取表基本信息
     * 
     * @param tableName 表名
     * @return 表信息
     */
    Map<String, Object> getTableInfo(String tableName);
    
    /**
     * 获取表的列信息
     * 
     * @param tableName 表名
     * @return 列信息列表
     */
    List<Map<String, Object>> getTableColumns(String tableName);
    
    /**
     * 获取表的约束信息
     * 
     * @param tableName 表名
     * @return 约束信息列表
     */
    List<Map<String, Object>> getTableConstraints(String tableName);
    
    /**
     * 获取表的索引信息
     * 
     * @param tableName 表名
     * @return 索引信息列表
     */
    List<Map<String, Object>> getTableIndexes(String tableName);
    
    /**
     * 获取表的外键信息
     * 
     * @param tableName 表名
     * @return 外键信息列表
     */
    List<Map<String, Object>> getTableForeignKeys(String tableName);
    
    /**
     * 检查表是否存在
     * 
     * @param tableName 表名
     * @return 是否存在
     */
    boolean tableExists(String tableName);
    
    /**
     * 获取数据库中所有表名
     * 
     * @return 表名列表
     */
    List<String> getAllTableNames();
    
    /**
     * 获取表的主键列信息
     * 
     * @param tableName 表名
     * @return 主键列信息
     */
    List<Map<String, Object>> getTablePrimaryKeys(String tableName);
    
    /**
     * 获取表的唯一约束信息
     * 
     * @param tableName 表名
     * @return 唯一约束信息
     */
    List<Map<String, Object>> getTableUniqueConstraints(String tableName);
    
    /**
     * 获取表的检查约束信息
     * 
     * @param tableName 表名
     * @return 检查约束信息
     */
    List<Map<String, Object>> getTableCheckConstraints(String tableName);
}