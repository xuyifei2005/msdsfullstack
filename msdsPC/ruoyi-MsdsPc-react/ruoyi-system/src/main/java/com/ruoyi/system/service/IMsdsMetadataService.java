package com.ruoyi.system.service;

import java.util.List;
import java.util.Map;

/**
 * MSDS元数据抽取服务接口
 * 
 * @author ruoyi
 */
public interface IMsdsMetadataService
{
    /**
     * 获取指定表的完整元数据信息
     * 
     * @param tableName 表名
     * @return 表元数据信息
     */
    Map<String, Object> getTableMetadata(String tableName);
    
    /**
     * 获取指定表的列信息
     * 
     * @param tableName 表名
     * @return 列信息列表
     */
    List<Map<String, Object>> getTableColumns(String tableName);
    
    /**
     * 获取指定表的约束信息
     * 
     * @param tableName 表名
     * @return 约束信息列表
     */
    List<Map<String, Object>> getTableConstraints(String tableName);
    
    /**
     * 获取指定表的索引信息
     * 
     * @param tableName 表名
     * @return 索引信息列表
     */
    List<Map<String, Object>> getTableIndexes(String tableName);
    
    /**
     * 获取指定表的外键信息
     * 
     * @param tableName 表名
     * @return 外键信息列表
     */
    List<Map<String, Object>> getTableForeignKeys(String tableName);
    
    /**
     * 获取指定表的唯一约束信息
     * 
     * @param tableName 表名
     * @return 唯一约束信息列表
     */
    List<Map<String, Object>> getTableUniqueConstraints(String tableName);
    
    /**
     * 获取数据库中所有MSDS相关表的列表
     * 
     * @return MSDS表列表
     */
    List<String> getMsdsTables();
    
    /**
     * 获取指定范围的表元数据
     * 
     * @param scope 范围：main(主表), exposure(暴露控制), physical(物理化学), all(全部)
     * @return 表元数据映射
     */
    Map<String, Map<String, Object>> getTablesMetadata(String scope);
    
    /**
     * 获取表的字典类型映射
     * 
     * @param tableName 表名
     * @return 字段名到字典类型的映射
     */
    Map<String, String> getTableDictTypes(String tableName);
    
    /**
     * 获取表的枚举值映射
     * 
     * @param tableName 表名
     * @return 字段名到枚举值列表的映射
     */
    Map<String, List<String>> getTableEnumValues(String tableName);
}