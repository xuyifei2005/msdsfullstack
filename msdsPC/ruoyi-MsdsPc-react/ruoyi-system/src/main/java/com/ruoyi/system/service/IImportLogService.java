package com.ruoyi.system.service;

import com.ruoyi.system.domain.ImportLog;
import com.ruoyi.system.enums.ImportErrorCode;

import java.util.List;
import java.util.Map;

/**
 * 导入日志Service接口
 * 
 * @author ruoyi
 * @date 2024-01-20
 */
public interface IImportLogService {
    
    /**
     * 查询导入日志
     *
     * @param logId 导入日志主键
     * @return 导入日志
     */
    public ImportLog selectImportLogByLogId(Long logId);

    /**
     * 查询导入日志列表
     *
     * @param importLog 导入日志
     * @return 导入日志集合
     */
    public List<ImportLog> selectImportLogList(ImportLog importLog);

    /**
     * 新增导入日志
     *
     * @param importLog 导入日志
     * @return 结果
     */
    public int insertImportLog(ImportLog importLog);

    /**
     * 修改导入日志
     *
     * @param importLog 导入日志
     * @return 结果
     */
    public int updateImportLog(ImportLog importLog);

    /**
     * 批量删除导入日志
     *
     * @param logIds 需要删除的导入日志主键集合
     * @return 结果
     */
    public int deleteImportLogByLogIds(Long[] logIds);

    /**
     * 删除导入日志信息
     *
     * @param logId 导入日志主键
     * @return 结果
     */
    public int deleteImportLogByLogId(Long logId);
    
    /**
     * 根据批次号查询导入日志
     *
     * @param batchNo 批次号
     * @return 导入日志
     */
    public ImportLog selectImportLogByBatchNo(String batchNo);
    
    /**
     * 创建导入日志
     *
     * @param fileName 文件名
     * @param fileSize 文件大小
     * @param fileType 文件类型
     * @param importType 导入类型
     * @param userId 用户ID
     * @param userName 用户名
     * @param clientIp 客户端IP
     * @return 导入日志
     */
    public ImportLog createImportLog(String fileName, Long fileSize, String fileType, 
                                   String importType, Long userId, String userName, String clientIp);
    
    /**
     * 开始导入处理
     *
     * @param batchNo 批次号
     * @param totalRows 总行数
     * @return 结果
     */
    public int startImportProcessing(String batchNo, Integer totalRows);
    
    /**
     * 更新导入进度
     *
     * @param batchNo 批次号
     * @param successRows 成功行数
     * @param failedRows 失败行数
     * @param warningRows 警告行数
     * @param skippedRows 跳过行数
     * @return 结果
     */
    public int updateImportProgress(String batchNo, Integer successRows, Integer failedRows, 
                                  Integer warningRows, Integer skippedRows);
    
    /**
     * 完成导入处理
     *
     * @param batchNo 批次号
     * @param status 最终状态
     * @param errorMessage 错误信息
     * @param errorCode 错误码
     * @param validationResult 校验结果
     * @return 结果
     */
    public int finishImportProcessing(String batchNo, String status, String errorMessage, 
                                    String errorCode, String validationResult);
    
    /**
     * 记录导入错误
     *
     * @param batchNo 批次号
     * @param errorCode 错误码枚举
     * @param errorMessage 错误信息
     * @param errorDetails 错误详情
     * @return 结果
     */
    public int recordImportError(String batchNo, ImportErrorCode errorCode, String errorMessage, String errorDetails);
    
    /**
     * 获取导入统计信息
     *
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 统计信息
     */
    public Map<String, Object> getImportStatistics(String startDate, String endDate);
    
    /**
     * 获取用户导入历史
     *
     * @param userId 用户ID
     * @param limit 限制数量
     * @return 导入历史
     */
    public List<ImportLog> getUserImportHistory(Long userId, Integer limit);
    
    /**
     * 获取导入错误统计
     *
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 错误统计
     */
    public Map<String, Integer> getImportErrorStatistics(String startDate, String endDate);
    
    /**
     * 清理过期日志
     *
     * @param retentionDays 保留天数
     * @return 清理数量
     */
    public int cleanExpiredLogs(Integer retentionDays);
    
    /**
     * 生成批次号
     *
     * @return 批次号
     */
    public String generateBatchNo();
    
    /**
     * 检查导入状态
     *
     * @param batchNo 批次号
     * @return 导入状态信息
     */
    public Map<String, Object> checkImportStatus(String batchNo);
    
    /**
     * 获取导入进度
     *
     * @param batchNo 批次号
     * @return 进度信息
     */
    public Map<String, Object> getImportProgress(String batchNo);
    
    /**
     * 取消导入
     *
     * @param batchNo 批次号
     * @param reason 取消原因
     * @return 结果
     */
    public int cancelImport(String batchNo, String reason);
    
    /**
     * 重试导入
     *
     * @param batchNo 原批次号
     * @return 新的导入日志
     */
    public ImportLog retryImport(String batchNo);
    
    /**
     * 导出导入日志
     *
     * @param importLog 查询条件
     * @return 导入日志列表
     */
    public List<ImportLog> exportImportLogs(ImportLog importLog);
    
    /**
     * 获取导入性能统计
     *
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 性能统计
     */
    public Map<String, Object> getImportPerformanceStatistics(String startDate, String endDate);
    
    /**
     * 获取热门导入类型
     *
     * @param limit 限制数量
     * @return 热门导入类型
     */
    public List<Map<String, Object>> getPopularImportTypes(Integer limit);
    
    /**
     * 获取导入趋势数据
     *
     * @param days 天数
     * @return 趋势数据
     */
    public List<Map<String, Object>> getImportTrendData(Integer days);
}