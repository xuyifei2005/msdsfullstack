package com.ruoyi.system.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.SystemLogMapper;
import com.ruoyi.system.domain.SystemLog;
import com.ruoyi.system.service.ISystemLogService;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.ip.IpUtils;
import com.ruoyi.common.utils.ServletUtils;

/**
 * 系统操作日志Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
@Service
public class SystemLogServiceImpl implements ISystemLogService 
{
    @Autowired
    private SystemLogMapper systemLogMapper;

    /**
     * 查询系统操作日志
     * 
     * @param id 系统操作日志主键
     * @return 系统操作日志
     */
    @Override
    public SystemLog selectSystemLogById(Long id)
    {
        return systemLogMapper.selectSystemLogById(id);
    }

    /**
     * 根据表名和记录ID查询系统操作日志
     * 
     * @param tableName 表名
     * @param recordId 记录ID
     * @return 系统操作日志集合
     */
    @Override
    public List<SystemLog> selectSystemLogByTableAndRecord(String tableName, Long recordId)
    {
        return systemLogMapper.selectSystemLogByTableAndRecord(tableName, recordId);
    }

    /**
     * 查询系统操作日志列表
     * 
     * @param systemLog 系统操作日志
     * @return 系统操作日志集合
     */
    @Override
    public List<SystemLog> selectSystemLogList(SystemLog systemLog)
    {
        return systemLogMapper.selectSystemLogList(systemLog);
    }

    /**
     * 根据操作类型查询系统操作日志列表
     * 
     * @param operationType 操作类型
     * @return 系统操作日志集合
     */
    @Override
    public List<SystemLog> selectSystemLogByOperationType(String operationType)
    {
        return systemLogMapper.selectSystemLogByOperationType(operationType);
    }

    /**
     * 根据操作人查询系统操作日志列表
     * 
     * @param operator 操作人
     * @return 系统操作日志集合
     */
    @Override
    public List<SystemLog> selectSystemLogByOperator(String operator)
    {
        return systemLogMapper.selectSystemLogByOperator(operator);
    }

    /**
     * 根据时间范围查询系统操作日志列表
     * 
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 系统操作日志集合
     */
    @Override
    public List<SystemLog> selectSystemLogByTimeRange(Date startTime, Date endTime)
    {
        return systemLogMapper.selectSystemLogByTimeRange(startTime, endTime);
    }

    /**
     * 根据IP地址查询系统操作日志列表
     * 
     * @param ipAddress IP地址
     * @return 系统操作日志集合
     */
    @Override
    public List<SystemLog> selectSystemLogByIpAddress(String ipAddress)
    {
        return systemLogMapper.selectSystemLogByIpAddress(ipAddress);
    }

    /**
     * 新增系统操作日志
     * 
     * @param systemLog 系统操作日志
     * @return 结果
     */
    @Override
    public int insertSystemLog(SystemLog systemLog)
    {
        return systemLogMapper.insertSystemLog(systemLog);
    }

    /**
     * 批量新增系统操作日志
     * 
     * @param systemLogList 系统操作日志列表
     * @return 结果
     */
    @Override
    public int batchInsertSystemLog(List<SystemLog> systemLogList)
    {
        return systemLogMapper.batchInsertSystemLog(systemLogList);
    }

    /**
     * 修改系统操作日志
     * 
     * @param systemLog 系统操作日志
     * @return 结果
     */
    @Override
    public int updateSystemLog(SystemLog systemLog)
    {
        return systemLogMapper.updateSystemLog(systemLog);
    }

    /**
     * 批量删除系统操作日志
     * 
     * @param ids 需要删除的系统操作日志主键集合
     * @return 结果
     */
    @Override
    public int deleteSystemLogByIds(Long[] ids)
    {
        return systemLogMapper.deleteSystemLogByIds(ids);
    }

    /**
     * 删除系统操作日志信息
     * 
     * @param id 系统操作日志主键
     * @return 结果
     */
    @Override
    public int deleteSystemLogById(Long id)
    {
        return systemLogMapper.deleteSystemLogById(id);
    }

    /**
     * 根据时间范围批量删除系统操作日志
     * 
     * @param beforeTime 删除此时间之前的日志
     * @return 结果
     */
    @Override
    public int deleteSystemLogByTimeRange(Date beforeTime)
    {
        return systemLogMapper.deleteSystemLogBeforeTime(beforeTime);
    }

    /**
     * 统计日志数量
     * 
     * @param systemLog 查询条件
     * @return 日志数量
     */
    @Override
    public long countSystemLog(SystemLog systemLog)
    {
        return systemLogMapper.countSystemLog(systemLog);
    }

    /**
     * 获取操作统计信息
     * 
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 统计信息
     */
    @Override
    public Map<String, Object> getOperationStatistics(Date startTime, Date endTime)
    {
        // 由于Mapper中没有getOperationStatistics方法，我们需要手动实现统计逻辑
        Map<String, Object> statistics = new HashMap<>();
        
        // 查询时间范围内的日志
        List<SystemLog> logs = systemLogMapper.selectSystemLogByTimeRange(startTime, endTime);
        
        // 统计操作类型分布
        Map<String, Long> operationTypeCount = logs.stream()
            .collect(Collectors.groupingBy(SystemLog::getOperationType, Collectors.counting()));
        
        // 统计操作人分布
        Map<String, Long> operatorCount = logs.stream()
            .collect(Collectors.groupingBy(SystemLog::getOperator, Collectors.counting()));
        
        // 统计总数
        long totalCount = logs.size();
        
        statistics.put("totalCount", totalCount);
        statistics.put("operationTypeCount", operationTypeCount);
        statistics.put("operatorCount", operatorCount);
        
        return statistics;
    }

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
    @Override
    public int logDataChange(String tableName, Long recordId, String operationType, 
                           String oldValues, String newValues, String operator)
    {
        SystemLog systemLog = new SystemLog();
        systemLog.setTableName(tableName);
        systemLog.setRecordId(recordId);
        systemLog.setOperationType(operationType);
        systemLog.setOldValues(oldValues);
        systemLog.setNewValues(newValues);
        systemLog.setOperator(operator != null ? operator : SecurityUtils.getUsername());
        systemLog.setOperationTime(new Date());
        
        // 获取IP地址和User-Agent
        try {
            systemLog.setIpAddress(IpUtils.getIpAddr(ServletUtils.getRequest()));
            systemLog.setUserAgent(ServletUtils.getRequest().getHeader("User-Agent"));
        } catch (Exception e) {
            // 如果获取失败，设置默认值
            systemLog.setIpAddress("unknown");
            systemLog.setUserAgent("unknown");
        }
        
        return systemLogMapper.insertSystemLog(systemLog);
    }
}