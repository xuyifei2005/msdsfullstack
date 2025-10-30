package com.ruoyi.system.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.mapper.MsdsAuditLogMapper;
import com.ruoyi.system.domain.MsdsAuditLog;
import com.ruoyi.system.service.IMsdsAuditLogService;

/**
 * MSDS操作审计日志Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
@Service
public class MsdsAuditLogServiceImpl implements IMsdsAuditLogService 
{
    @Autowired
    private MsdsAuditLogMapper msdsAuditLogMapper;

    /**
     * 查询MSDS操作审计日志
     * 
     * @param logId MSDS操作审计日志主键
     * @return MSDS操作审计日志
     */
    @Override
    public MsdsAuditLog selectMsdsAuditLogByLogId(Long logId)
    {
        return msdsAuditLogMapper.selectMsdsAuditLogByLogId(logId);
    }

    /**
     * 查询MSDS操作审计日志列表
     * 
     * @param msdsAuditLog MSDS操作审计日志
     * @return MSDS操作审计日志
     */
    @Override
    public List<MsdsAuditLog> selectMsdsAuditLogList(MsdsAuditLog msdsAuditLog)
    {
        return msdsAuditLogMapper.selectMsdsAuditLogList(msdsAuditLog);
    }

    /**
     * 新增MSDS操作审计日志
     * 
     * @param msdsAuditLog MSDS操作审计日志
     * @return 结果
     */
    @Override
    public int insertMsdsAuditLog(MsdsAuditLog msdsAuditLog)
    {
        if (msdsAuditLog.getOperationTime() == null)
        {
            msdsAuditLog.setOperationTime(new Date());
        }
        return msdsAuditLogMapper.insertMsdsAuditLog(msdsAuditLog);
    }

    /**
     * 修改MSDS操作审计日志
     * 
     * @param msdsAuditLog MSDS操作审计日志
     * @return 结果
     */
    @Override
    public int updateMsdsAuditLog(MsdsAuditLog msdsAuditLog)
    {
        return msdsAuditLogMapper.updateMsdsAuditLog(msdsAuditLog);
    }

    /**
     * 批量删除MSDS操作审计日志
     * 
     * @param logIds 需要删除的MSDS操作审计日志主键
     * @return 结果
     */
    @Override
    public int deleteMsdsAuditLogByLogIds(Long[] logIds)
    {
        return msdsAuditLogMapper.deleteMsdsAuditLogByLogIds(logIds);
    }

    /**
     * 删除MSDS操作审计日志信息
     * 
     * @param logId MSDS操作审计日志主键
     * @return 结果
     */
    @Override
    public int deleteMsdsAuditLogByLogId(Long logId)
    {
        return msdsAuditLogMapper.deleteMsdsAuditLogByLogId(logId);
    }

    /**
     * 记录MSDS操作日志
     * 
     * @param msdsId MSDS主信息ID
     * @param operationType 操作类型
     * @param operationDesc 操作描述
     * @param beforeData 操作前数据
     * @param afterData 操作后数据
     * @param operator 操作人员
     * @param operatorId 操作人员ID
     * @param ipAddress IP地址
     * @param userAgent 用户代理
     */
    @Override
    public void recordAuditLog(Long msdsId, String operationType, String operationDesc, 
                              String beforeData, String afterData, String operator, 
                              Long operatorId, String ipAddress, String userAgent)
    {
        MsdsAuditLog auditLog = new MsdsAuditLog();
        auditLog.setMsdsId(msdsId);
        auditLog.setOperationType(operationType);
        auditLog.setOperationDesc(operationDesc);
        auditLog.setBeforeData(beforeData);
        auditLog.setAfterData(afterData);
        auditLog.setOperator(operator);
        auditLog.setOperatorId(operatorId);
        auditLog.setIpAddress(ipAddress);
        auditLog.setUserAgent(userAgent);
        auditLog.setOperationTime(new Date());
        auditLog.setOperationResult("SUCCESS");
        
        insertMsdsAuditLog(auditLog);
    }

    /**
     * 记录操作成功日志
     * 
     * @param msdsId MSDS主信息ID
     * @param operationType 操作类型
     * @param operationDesc 操作描述
     * @param operator 操作人员
     * @param operatorId 操作人员ID
     * @param ipAddress IP地址
     */
    @Override
    public void recordSuccessLog(Long msdsId, String operationType, String operationDesc, 
                                String operator, Long operatorId, String ipAddress)
    {
        MsdsAuditLog auditLog = new MsdsAuditLog();
        auditLog.setMsdsId(msdsId);
        auditLog.setOperationType(operationType);
        auditLog.setOperationDesc(operationDesc);
        auditLog.setOperator(operator);
        auditLog.setOperatorId(operatorId);
        auditLog.setIpAddress(ipAddress);
        auditLog.setOperationTime(new Date());
        auditLog.setOperationResult("SUCCESS");
        
        insertMsdsAuditLog(auditLog);
    }

    /**
     * 记录操作失败日志
     * 
     * @param msdsId MSDS主信息ID
     * @param operationType 操作类型
     * @param operationDesc 操作描述
     * @param errorMessage 错误信息
     * @param operator 操作人员
     * @param operatorId 操作人员ID
     * @param ipAddress IP地址
     */
    @Override
    public void recordFailureLog(Long msdsId, String operationType, String operationDesc, 
                                 String errorMessage, String operator, Long operatorId, String ipAddress)
    {
        MsdsAuditLog auditLog = new MsdsAuditLog();
        auditLog.setMsdsId(msdsId);
        auditLog.setOperationType(operationType);
        auditLog.setOperationDesc(operationDesc);
        auditLog.setOperator(operator);
        auditLog.setOperatorId(operatorId);
        auditLog.setIpAddress(ipAddress);
        auditLog.setOperationTime(new Date());
        auditLog.setOperationResult("FAILED");
        auditLog.setErrorMessage(errorMessage);
        
        insertMsdsAuditLog(auditLog);
    }

    /**
     * 根据MSDS ID查询操作日志
     * 
     * @param msdsId MSDS主信息ID
     * @return 操作日志集合
     */
    @Override
    public List<MsdsAuditLog> selectMsdsAuditLogByMsdsId(Long msdsId)
    {
        return msdsAuditLogMapper.selectMsdsAuditLogByMsdsId(msdsId);
    }

    /**
     * 获取操作统计信息
     * 
     * @return 统计信息
     */
    @Override
    public Map<String, Object> getAuditStatistics()
    {
        Map<String, Object> statistics = new HashMap<>();
        
        // 查询所有审计日志
        MsdsAuditLog queryParam = new MsdsAuditLog();
        List<MsdsAuditLog> allLogs = msdsAuditLogMapper.selectMsdsAuditLogList(queryParam);
        
        // 基础统计
        statistics.put("totalLogs", allLogs.size());
        statistics.put("successLogs", allLogs.stream().filter(log -> "SUCCESS".equals(log.getOperationResult())).count());
        statistics.put("failedLogs", allLogs.stream().filter(log -> "FAILED".equals(log.getOperationResult())).count());
        
        // 今日操作统计
        Date today = new Date();
        long todayLogs = allLogs.stream()
            .filter(log -> log.getOperationTime() != null && 
                          isSameDay(log.getOperationTime(), today))
            .count();
        statistics.put("todayLogs", todayLogs);
        
        return statistics;
    }

    /**
     * 获取操作类型分布统计
     * 
     * @return 操作类型分布
     */
    @Override
    public Map<String, Object> getOperationTypeStatistics()
    {
        Map<String, Object> statistics = new HashMap<>();
        
        try {
            List<Map<String, Object>> typeStats = msdsAuditLogMapper.getOperationTypeStatistics();
            statistics.put("operationTypes", typeStats);
        } catch (Exception e) {
            // 如果数据库方法未实现，使用基础统计
            MsdsAuditLog queryParam = new MsdsAuditLog();
            List<MsdsAuditLog> allLogs = msdsAuditLogMapper.selectMsdsAuditLogList(queryParam);
            
            Map<String, Long> typeCount = allLogs.stream()
                .filter(log -> StringUtils.isNotEmpty(log.getOperationType()))
                .collect(java.util.stream.Collectors.groupingBy(
                    MsdsAuditLog::getOperationType,
                    java.util.stream.Collectors.counting()));
            
            statistics.put("operationTypes", typeCount);
        }
        
        return statistics;
    }

    /**
     * 获取操作人员活跃度统计
     * 
     * @param days 统计天数
     * @return 操作人员统计
     */
    @Override
    public Map<String, Object> getOperatorStatistics(int days)
    {
        Map<String, Object> statistics = new HashMap<>();
        
        try {
            List<Map<String, Object>> operatorStats = msdsAuditLogMapper.getOperatorStatistics(days);
            statistics.put("operators", operatorStats);
        } catch (Exception e) {
            // 如果数据库方法未实现，使用基础统计
            Date startDate = new Date(System.currentTimeMillis() - days * 24 * 60 * 60 * 1000L);
            
            MsdsAuditLog queryParam = new MsdsAuditLog();
            List<MsdsAuditLog> recentLogs = msdsAuditLogMapper.selectMsdsAuditLogList(queryParam)
                .stream()
                .filter(log -> log.getOperationTime() != null && log.getOperationTime().after(startDate))
                .collect(java.util.stream.Collectors.toList());
            
            Map<String, Long> operatorCount = recentLogs.stream()
                .filter(log -> StringUtils.isNotEmpty(log.getOperator()))
                .collect(java.util.stream.Collectors.groupingBy(
                    MsdsAuditLog::getOperator,
                    java.util.stream.Collectors.counting()));
            
            statistics.put("operators", operatorCount);
        }
        
        statistics.put("days", days);
        return statistics;
    }

    /**
     * 判断两个日期是否为同一天
     */
    private boolean isSameDay(Date date1, Date date2) {
        if (date1 == null || date2 == null) {
            return false;
        }
        
        java.util.Calendar cal1 = java.util.Calendar.getInstance();
        cal1.setTime(date1);
        java.util.Calendar cal2 = java.util.Calendar.getInstance();
        cal2.setTime(date2);
        
        return cal1.get(java.util.Calendar.YEAR) == cal2.get(java.util.Calendar.YEAR) &&
               cal1.get(java.util.Calendar.DAY_OF_YEAR) == cal2.get(java.util.Calendar.DAY_OF_YEAR);
    }
}