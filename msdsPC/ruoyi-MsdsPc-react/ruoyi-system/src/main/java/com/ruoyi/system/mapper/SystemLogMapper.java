package com.ruoyi.system.mapper;

import java.util.List;
import java.util.Date;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.system.domain.SystemLog;

/**
 * 系统操作日志Mapper接口
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
public interface SystemLogMapper 
{
    /**
     * 查询系统操作日志
     * 
     * @param id 系统操作日志主键
     * @return 系统操作日志
     */
    public SystemLog selectSystemLogById(Long id);

    /**
     * 根据表名和记录ID查询操作日志
     * 
     * @param tableName 表名
     * @param recordId 记录ID
     * @return 系统操作日志集合
     */
    public List<SystemLog> selectSystemLogByTableAndRecord(@Param("tableName") String tableName, @Param("recordId") Long recordId);

    /**
     * 查询系统操作日志列表
     * 
     * @param systemLog 系统操作日志
     * @return 系统操作日志集合
     */
    public List<SystemLog> selectSystemLogList(SystemLog systemLog);

    /**
     * 根据操作类型查询日志
     * 
     * @param operationType 操作类型
     * @return 系统操作日志集合
     */
    public List<SystemLog> selectSystemLogByOperationType(String operationType);

    /**
     * 根据操作人查询日志
     * 
     * @param operator 操作人
     * @return 系统操作日志集合
     */
    public List<SystemLog> selectSystemLogByOperator(String operator);

    /**
     * 根据时间范围查询日志
     * 
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 系统操作日志集合
     */
    public List<SystemLog> selectSystemLogByTimeRange(@Param("startTime") Date startTime, @Param("endTime") Date endTime);

    /**
     * 根据IP地址查询日志
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
     * 修改系统操作日志
     * 
     * @param systemLog 系统操作日志
     * @return 结果
     */
    public int updateSystemLog(SystemLog systemLog);

    /**
     * 删除系统操作日志
     * 
     * @param id 系统操作日志主键
     * @return 结果
     */
    public int deleteSystemLogById(Long id);

    /**
     * 批量删除系统操作日志
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteSystemLogByIds(Long[] ids);

    /**
     * 根据时间范围批量删除日志
     * 
     * @param beforeTime 时间点
     * @return 结果
     */
    public int deleteSystemLogBeforeTime(Date beforeTime);

    /**
     * 统计操作日志数量
     * 
     * @param systemLog 查询条件
     * @return 数量
     */
    public int countSystemLog(SystemLog systemLog);

    /**
     * 批量新增系统操作日志
     * 
     * @param systemLogList 系统操作日志集合
     * @return 结果
     */
    public int batchInsertSystemLog(List<SystemLog> systemLogList);
}