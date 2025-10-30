package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.MsdsAuditLog;

/**
 * MSDS操作审计日志Mapper接口
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public interface MsdsAuditLogMapper 
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
     * 删除MSDS操作审计日志
     * 
     * @param logId MSDS操作审计日志主键
     * @return 结果
     */
    public int deleteMsdsAuditLogByLogId(Long logId);

    /**
     * 批量删除MSDS操作审计日志
     * 
     * @param logIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteMsdsAuditLogByLogIds(Long[] logIds);

    /**
     * 根据MSDS ID查询操作日志
     * 
     * @param msdsId MSDS主信息ID
     * @return 操作日志集合
     */
    public List<MsdsAuditLog> selectMsdsAuditLogByMsdsId(Long msdsId);

    /**
     * 查询指定时间范围内的操作日志
     * 
     * @param msdsAuditLog 查询条件
     * @return 操作日志集合
     */
    public List<MsdsAuditLog> selectMsdsAuditLogByDateRange(MsdsAuditLog msdsAuditLog);

    /**
     * 统计操作类型分布
     * 
     * @return 操作类型统计
     */
    public List<java.util.Map<String, Object>> getOperationTypeStatistics();

    /**
     * 统计操作人员活跃度
     * 
     * @param days 统计天数
     * @return 操作人员统计
     */
    public List<java.util.Map<String, Object>> getOperatorStatistics(int days);
}