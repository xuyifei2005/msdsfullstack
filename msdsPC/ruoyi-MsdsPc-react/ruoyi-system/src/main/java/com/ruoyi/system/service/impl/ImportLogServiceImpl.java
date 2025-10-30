package com.ruoyi.system.service.impl;

import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.ip.IpUtils;
import com.ruoyi.system.domain.ImportLog;
import com.ruoyi.system.enums.ImportErrorCode;
import com.ruoyi.system.mapper.ImportLogMapper;
import com.ruoyi.system.service.IImportLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 导入日志Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-01-20
 */
@Service
public class ImportLogServiceImpl implements IImportLogService {
    
    @Autowired
    private ImportLogMapper importLogMapper;
    
    /**
     * 查询导入日志
     *
     * @param logId 导入日志主键
     * @return 导入日志
     */
    @Override
    public ImportLog selectImportLogByLogId(Long logId) {
        return importLogMapper.selectImportLogByLogId(logId);
    }

    /**
     * 查询导入日志列表
     *
     * @param importLog 导入日志
     * @return 导入日志
     */
    @Override
    public List<ImportLog> selectImportLogList(ImportLog importLog) {
        return importLogMapper.selectImportLogList(importLog);
    }

    /**
     * 新增导入日志
     *
     * @param importLog 导入日志
     * @return 结果
     */
    @Override
    public int insertImportLog(ImportLog importLog) {
        importLog.setCreateTime(DateUtils.getNowDate());
        return importLogMapper.insertImportLog(importLog);
    }

    /**
     * 修改导入日志
     *
     * @param importLog 导入日志
     * @return 结果
     */
    @Override
    public int updateImportLog(ImportLog importLog) {
        importLog.setUpdateTime(DateUtils.getNowDate());
        return importLogMapper.updateImportLog(importLog);
    }

    /**
     * 批量删除导入日志
     *
     * @param logIds 需要删除的导入日志主键
     * @return 结果
     */
    @Override
    public int deleteImportLogByLogIds(Long[] logIds) {
        return importLogMapper.deleteImportLogByLogIds(logIds);
    }

    /**
     * 删除导入日志信息
     *
     * @param logId 导入日志主键
     * @return 结果
     */
    @Override
    public int deleteImportLogByLogId(Long logId) {
        return importLogMapper.deleteImportLogByLogId(logId);
    }
    
    /**
     * 根据批次号查询导入日志
     */
    @Override
    public ImportLog selectImportLogByBatchNo(String batchNo) {
        return importLogMapper.selectImportLogByBatchNo(batchNo);
    }
    
    /**
     * 创建导入日志
     */
    @Override
    public ImportLog createImportLog(String fileName, Long fileSize, String fileType, 
                                   String importType, Long userId, String userName, String clientIp) {
        ImportLog importLog = new ImportLog();
        importLog.setBatchNo(generateBatchNo());
        importLog.setFileName(fileName);
        importLog.setFileSize(fileSize);
        importLog.setFileType(fileType);
        importLog.setImportType(importType);
        importLog.setStatus("PENDING");
        importLog.setUserId(userId);
        importLog.setUserName(userName);
        importLog.setClientIp(clientIp);
        importLog.setCreateBy(userName);
        importLog.setCreateTime(DateUtils.getNowDate());
        
        insertImportLog(importLog);
        return importLog;
    }
    
    /**
     * 开始导入处理
     */
    @Override
    public int startImportProcessing(String batchNo, Integer totalRows) {
        ImportLog importLog = new ImportLog();
        importLog.setBatchNo(batchNo);
        importLog.setStatus("PROCESSING");
        importLog.setTotalRows(totalRows);
        importLog.setStartTime(DateUtils.getNowDate());
        importLog.setUpdateTime(DateUtils.getNowDate());
        
        return importLogMapper.updateImportLogByBatchNo(importLog);
    }
    
    /**
     * 更新导入进度
     */
    @Override
    public int updateImportProgress(String batchNo, Integer successRows, Integer failedRows, 
                                  Integer warningRows, Integer skippedRows) {
        ImportLog importLog = new ImportLog();
        importLog.setBatchNo(batchNo);
        importLog.setSuccessRows(successRows);
        importLog.setFailedRows(failedRows);
        importLog.setWarningRows(warningRows);
        importLog.setSkippedRows(skippedRows);
        importLog.setUpdateTime(DateUtils.getNowDate());
        
        return importLogMapper.updateImportLogByBatchNo(importLog);
    }
    
    /**
     * 完成导入处理
     */
    @Override
    public int finishImportProcessing(String batchNo, String status, String errorMessage, 
                                    String errorCode, String validationResult) {
        ImportLog currentLog = selectImportLogByBatchNo(batchNo);
        if (currentLog == null) {
            return 0;
        }
        
        ImportLog importLog = new ImportLog();
        importLog.setBatchNo(batchNo);
        importLog.setStatus(status);
        importLog.setErrorMessage(errorMessage);
        importLog.setErrorCode(errorCode);
        importLog.setValidationResult(validationResult);
        importLog.setEndTime(DateUtils.getNowDate());
        importLog.setUpdateTime(DateUtils.getNowDate());
        
        // 计算处理耗时
        if (currentLog.getStartTime() != null) {
            long processingTime = importLog.getEndTime().getTime() - currentLog.getStartTime().getTime();
            importLog.setProcessingTime(processingTime);
        }
        
        return importLogMapper.updateImportLogByBatchNo(importLog);
    }
    
    /**
     * 记录导入错误
     */
    @Override
    public int recordImportError(String batchNo, ImportErrorCode errorCode, String errorMessage, String errorDetails) {
        ImportLog importLog = new ImportLog();
        importLog.setBatchNo(batchNo);
        importLog.setStatus("FAILED");
        importLog.setErrorCode(errorCode.getCode());
        importLog.setErrorMessage(errorMessage != null ? errorMessage : errorCode.getMessage());
        importLog.setErrorDetails(errorDetails);
        importLog.setEndTime(DateUtils.getNowDate());
        importLog.setUpdateTime(DateUtils.getNowDate());
        
        return importLogMapper.updateImportLogByBatchNo(importLog);
    }
    
    /**
     * 获取导入统计信息
     */
    @Override
    public Map<String, Object> getImportStatistics(String startDate, String endDate) {
        return importLogMapper.getImportStatistics(startDate, endDate);
    }
    
    /**
     * 获取用户导入历史
     */
    @Override
    public List<ImportLog> getUserImportHistory(Long userId, Integer limit) {
        return importLogMapper.getUserImportHistory(userId, limit);
    }
    
    /**
     * 获取导入错误统计
     */
    @Override
    public Map<String, Integer> getImportErrorStatistics(String startDate, String endDate) {
        return importLogMapper.getImportErrorStatistics(startDate, endDate);
    }
    
    /**
     * 清理过期日志
     */
    @Override
    public int cleanExpiredLogs(Integer retentionDays) {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DAY_OF_MONTH, -retentionDays);
        Date expiredDate = calendar.getTime();
        
        return importLogMapper.deleteExpiredLogs(expiredDate);
    }
    
    /**
     * 生成批次号
     */
    @Override
    public String generateBatchNo() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String timestamp = sdf.format(new Date());
        String randomSuffix = String.format("%04d", new Random().nextInt(10000));
        return "IMP" + timestamp + randomSuffix;
    }
    
    /**
     * 检查导入状态
     */
    @Override
    public Map<String, Object> checkImportStatus(String batchNo) {
        ImportLog importLog = selectImportLogByBatchNo(batchNo);
        Map<String, Object> result = new HashMap<>();
        
        if (importLog != null) {
            result.put("batchNo", importLog.getBatchNo());
            result.put("status", importLog.getStatus());
            result.put("fileName", importLog.getFileName());
            result.put("totalRows", importLog.getTotalRows());
            result.put("successRows", importLog.getSuccessRows());
            result.put("failedRows", importLog.getFailedRows());
            result.put("warningRows", importLog.getWarningRows());
            result.put("skippedRows", importLog.getSkippedRows());
            result.put("startTime", importLog.getStartTime());
            result.put("endTime", importLog.getEndTime());
            result.put("processingTime", importLog.getProcessingTime());
            result.put("errorMessage", importLog.getErrorMessage());
            result.put("errorCode", importLog.getErrorCode());
        } else {
            result.put("status", "NOT_FOUND");
            result.put("message", "未找到指定批次的导入记录");
        }
        
        return result;
    }
    
    /**
     * 获取导入进度
     */
    @Override
    public Map<String, Object> getImportProgress(String batchNo) {
        ImportLog importLog = selectImportLogByBatchNo(batchNo);
        Map<String, Object> result = new HashMap<>();
        
        if (importLog != null) {
            Integer totalRows = importLog.getTotalRows() != null ? importLog.getTotalRows() : 0;
            Integer processedRows = 0;
            
            if (importLog.getSuccessRows() != null) processedRows += importLog.getSuccessRows();
            if (importLog.getFailedRows() != null) processedRows += importLog.getFailedRows();
            if (importLog.getSkippedRows() != null) processedRows += importLog.getSkippedRows();
            
            double progress = totalRows > 0 ? (double) processedRows / totalRows * 100 : 0;
            
            result.put("batchNo", batchNo);
            result.put("status", importLog.getStatus());
            result.put("totalRows", totalRows);
            result.put("processedRows", processedRows);
            result.put("successRows", importLog.getSuccessRows());
            result.put("failedRows", importLog.getFailedRows());
            result.put("warningRows", importLog.getWarningRows());
            result.put("skippedRows", importLog.getSkippedRows());
            result.put("progress", Math.round(progress * 100.0) / 100.0);
            result.put("startTime", importLog.getStartTime());
            
            // 计算预估剩余时间
            if ("PROCESSING".equals(importLog.getStatus()) && importLog.getStartTime() != null && processedRows > 0) {
                long elapsedTime = System.currentTimeMillis() - importLog.getStartTime().getTime();
                long avgTimePerRow = elapsedTime / processedRows;
                long remainingRows = totalRows - processedRows;
                long estimatedRemainingTime = avgTimePerRow * remainingRows;
                result.put("estimatedRemainingTime", estimatedRemainingTime);
            }
        } else {
            result.put("status", "NOT_FOUND");
            result.put("message", "未找到指定批次的导入记录");
        }
        
        return result;
    }
    
    /**
     * 取消导入
     */
    @Override
    public int cancelImport(String batchNo, String reason) {
        ImportLog importLog = new ImportLog();
        importLog.setBatchNo(batchNo);
        importLog.setStatus("CANCELLED");
        importLog.setErrorMessage("导入已取消: " + reason);
        importLog.setEndTime(DateUtils.getNowDate());
        importLog.setUpdateTime(DateUtils.getNowDate());
        
        return importLogMapper.updateImportLogByBatchNo(importLog);
    }
    
    /**
     * 重试导入
     */
    @Override
    public ImportLog retryImport(String batchNo) {
        ImportLog originalLog = selectImportLogByBatchNo(batchNo);
        if (originalLog == null) {
            return null;
        }
        
        // 创建新的导入日志
        ImportLog retryLog = new ImportLog();
        retryLog.setBatchNo(generateBatchNo());
        retryLog.setFileName(originalLog.getFileName());
        retryLog.setFileSize(originalLog.getFileSize());
        retryLog.setFileType(originalLog.getFileType());
        retryLog.setImportType(originalLog.getImportType());
        retryLog.setStatus("PENDING");
        retryLog.setUserId(originalLog.getUserId());
        retryLog.setUserName(originalLog.getUserName());
        retryLog.setClientIp(originalLog.getClientIp());
        retryLog.setRemarks("重试导入，原批次号: " + batchNo);
        retryLog.setCreateBy(originalLog.getUserName());
        retryLog.setCreateTime(DateUtils.getNowDate());
        
        insertImportLog(retryLog);
        return retryLog;
    }
    
    /**
     * 导出导入日志
     */
    @Override
    public List<ImportLog> exportImportLogs(ImportLog importLog) {
        return importLogMapper.selectImportLogList(importLog);
    }
    
    /**
     * 获取导入性能统计
     */
    @Override
    public Map<String, Object> getImportPerformanceStatistics(String startDate, String endDate) {
        return importLogMapper.getImportPerformanceStatistics(startDate, endDate);
    }
    
    /**
     * 获取热门导入类型
     */
    @Override
    public List<Map<String, Object>> getPopularImportTypes(Integer limit) {
        return importLogMapper.getPopularImportTypes(limit);
    }
    
    /**
     * 获取导入趋势数据
     */
    @Override
    public List<Map<String, Object>> getImportTrendData(Integer days) {
        return importLogMapper.getImportTrendData(days);
    }
}