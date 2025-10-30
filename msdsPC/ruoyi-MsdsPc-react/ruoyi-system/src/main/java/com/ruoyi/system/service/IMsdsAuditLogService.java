package com.ruoyi.system.service;

import java.util.List;
import java.util.Map;
import com.ruoyi.system.domain.MsdsAuditLog;

/**
 * MSDS操作审计日志Service接口
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public interface IMsdsAuditLogService 
{
    /**
     * 查询MSDS操作审计日志
     * 
     * @param logId MSDS操作审计日志主键
     * @return MSDS操作审计日志
     */
    public MsdsAuditLog selectMsdsAuditLogByLogId(Long logId);

    /**
     * 查询MSDS操作审计日志列表
     * 
     * @param msdsAuditLog MSDS操作审计日志
     * @return MSDS操作审计日志集合
     */
    public List<MsdsAuditLog> selectMsdsAuditLogList(MsdsAuditLog msdsAuditLog);

    /**
     * 新增MSDS操作审计日志
     * 
     * @param msdsAuditLog MSDS操作审计日志
     * @return 结果
     */
    public int insertMsdsAuditLog(MsdsAuditLog msdsAuditLog);

    /**
     * 修改MSDS操作审计日志
     * 
     * @param msdsAuditLog MSDS操作审计日志
     * @return 结果
     */
    public int updateMsdsAuditLog(MsdsAuditLog msdsAuditLog);

    /**
     * 批量删除MSDS操作审计日志
     * 
     * @param logIds 需要删除的MSDS操作审计日志主键集合
     * @return 结果
     */
    public int deleteMsdsAuditLogByLogIds(Long[] logIds);

    /**
     * 删除MSDS操作审计日志信息
     * 
     * @param logId MSDS操作审计日志主键
     * @return 结果
     */
    public int deleteMsdsAuditLogByLogId(Long logId);

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
    public void recordAuditLog(Long msdsId, String operationType, String operationDesc, 
                              String beforeData, String afterData, String operator, 
                              Long operatorId, String ipAddress, String userAgent);

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
    public void recordSuccessLog(Long msdsId, String operationType, String operationDesc, 
                                String operator, Long operatorId, String ipAddress);

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
    public void recordFailureLog(Long msdsId, String operationType, String operationDesc, 
                                 String errorMessage, String operator, Long operatorId, String ipAddress);

    /**
     * 根据MSDS ID查询操作日志
     * 
     * @param msdsId MSDS主信息ID
     * @return 操作日志集合
     */
    public List<MsdsAuditLog> selectMsdsAuditLogByMsdsId(Long msdsId);

    /**
     * 获取操作统计信息
     * 
     * @return 统计信息
     */
    public Map<String, Object> getAuditStatistics();

    /**
     * 获取操作类型分布统计
     * 
     * @return 操作类型分布
     */
    public Map<String, Object> getOperationTypeStatistics();

    /**
     * 获取操作人员活跃度统计
     * 
     * @param days 统计天数
     * @return 操作人员统计
     */
    public Map<String, Object> getOperatorStatistics(int days);
}