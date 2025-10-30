package com.ruoyi.system.service;

import java.util.Date;
import java.util.List;
import java.util.Map;
import com.ruoyi.system.domain.SystemLog;

/**
 * 系统操作日志Service接口
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public interface ISystemLogService 
{
    /**
     * 查询系统操作日志
     * 
     * @param id 系统操作日志主键
     * @return 系统操作日志
     */
    public SystemLog selectSystemLogById(Long id);

    /**
     * 根据表名和记录ID查询系统操作日志
     * 
     * @param tableName 表名
     * @param recordId 记录ID
     * @return 系统操作日志集合
     */
    public List<SystemLog> selectSystemLogByTableAndRecord(String tableName, Long recordId);

    /**
     * 查询系统操作日志列表
     * 
     * @param systemLog 系统操作日志
     * @return 系统操作日志集合
     */
    public List<SystemLog> selectSystemLogList(SystemLog systemLog);

    /**
     * 根据操作类型查询系统操作日志列表
     * 
     * @param operationType 操作类型
     * @return 系统操作日志集合
     */
    public List<SystemLog> selectSystemLogByOperationType(String operationType);

    /**
     * 根据操作人查询系统操作日志列表
     * 
     * @param operator 操作人
     * @return 系统操作日志集合
     */
    public List<SystemLog> selectSystemLogByOperator(String operator);

    /**
     * 根据时间范围查询系统操作日志列表
     * 
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 系统操作日志集合
     */
    public List<SystemLog> selectSystemLogByTimeRange(Date startTime, Date endTime);

    /**
     * 根据IP地址查询系统操作日志列表
     * 
     * @param ipAddress IP地址
     * @return 系统操作日志集合
     */
    public List<SystemLog> selectSystemLogByIpAddress(String ipAddress);

    /**
     * 新增系统操作日志
     * 
     * @param systemLog 系统操作日志
     * @return 结果
     */
    public int insertSystemLog(SystemLog systemLog);

    /**
     * 批量新增系统操作日志
     * 
     * @param systemLogList 系统操作日志列表
     * @return 结果
     */
    public int batchInsertSystemLog(List<SystemLog> systemLogList);

    /**
     * 修改系统操作日志
     * 
     * @param systemLog 系统操作日志
     * @return 结果
     */
    public int updateSystemLog(SystemLog systemLog);

    /**
     * 批量删除系统操作日志
     * 
     * @param ids 需要删除的系统操作日志主键集合
     * @return 结果
     */
    public int deleteSystemLogByIds(Long[] ids);

    /**
     * 删除系统操作日志信息
     * 
     * @param id 系统操作日志主键
     * @return 结果
     */
    public int deleteSystemLogById(Long id);

    /**
     * 根据时间范围批量删除系统操作日志
     * 
     * @param beforeTime 删除此时间之前的日志
     * @return 结果
     */
    public int deleteSystemLogByTimeRange(Date beforeTime);

    /**
     * 统计日志数量
     * 
     * @param systemLog 查询条件
     * @return 日志数量
     */
    public long countSystemLog(SystemLog systemLog);

    /**
     * 获取操作统计信息
     * 
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 统计信息
     */
    public Map<String, Object> getOperationStatistics(Date startTime, Date endTime);

    /**
     * 记录数据变更日志
     * 
     * @param tableName 表名
     * @param recordId 记录ID
     * @param operationType 操作类型
     * @param oldValues 旧值
     * @param newValues 新值
     * @param operator 操作人
     * @return 结果
     */
    public int logDataChange(String tableName, Long recordId, String operationType, 
                           String oldValues, String newValues, String operator);
}