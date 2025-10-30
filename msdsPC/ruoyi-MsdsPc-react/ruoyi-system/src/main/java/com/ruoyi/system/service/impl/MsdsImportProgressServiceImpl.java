package com.ruoyi.system.service.impl;

import java.util.List;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.system.mapper.MsdsImportProgressMapper;
import com.ruoyi.system.domain.MsdsImportProgress;
import com.ruoyi.system.service.IMsdsImportProgressService;

/**
 * MSDS导入进度Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
@Service
public class MsdsImportProgressServiceImpl implements IMsdsImportProgressService 
{
    @Autowired
    private MsdsImportProgressMapper msdsImportProgressMapper;

    /**
     * 查询MSDS导入进度
     * 
     * @param progressId MSDS导入进度主键
     * @return MSDS导入进度
     */
    @Override
    public MsdsImportProgress selectMsdsImportProgressByProgressId(Long progressId)
    {
        return msdsImportProgressMapper.selectMsdsImportProgressByProgressId(progressId);
    }
    
    /**
     * 根据任务ID查询MSDS导入进度
     * 
     * @param taskId 任务ID
     * @return MSDS导入进度
     */
    @Override
    public MsdsImportProgress selectMsdsImportProgressByTaskId(String taskId)
    {
        return msdsImportProgressMapper.selectMsdsImportProgressByTaskId(taskId);
    }
    
    /**
     * 查询用户的导入进度列表
     * 
     * @param userId 用户ID
     * @return MSDS导入进度集合
     */
    @Override
    public List<MsdsImportProgress> selectMsdsImportProgressByUserId(Long userId)
    {
        return msdsImportProgressMapper.selectMsdsImportProgressByUserId(userId);
    }
    
    /**
     * 查询正在处理的任务
     * 
     * @return MSDS导入进度集合
     */
    @Override
    public List<MsdsImportProgress> selectProcessingTasks()
    {
        return msdsImportProgressMapper.selectProcessingTasks();
    }
    
    /**
     * 查询超时的任务
     * 
     * @param timeoutMinutes 超时分钟数
     * @return MSDS导入进度集合
     */
    @Override
    public List<MsdsImportProgress> selectTimeoutTasks(Integer timeoutMinutes)
    {
        return msdsImportProgressMapper.selectTimeoutTasks(timeoutMinutes);
    }

    /**
     * 查询MSDS导入进度列表
     * 
     * @param msdsImportProgress MSDS导入进度
     * @return MSDS导入进度
     */
    @Override
    public List<MsdsImportProgress> selectMsdsImportProgressList(MsdsImportProgress msdsImportProgress)
    {
        return msdsImportProgressMapper.selectMsdsImportProgressList(msdsImportProgress);
    }

    /**
     * 新增MSDS导入进度
     * 
     * @param msdsImportProgress MSDS导入进度
     * @return 结果
     */
    @Override
    public int insertMsdsImportProgress(MsdsImportProgress msdsImportProgress)
    {
        msdsImportProgress.setCreateTime(DateUtils.getNowDate());
        msdsImportProgress.setUpdateTime(DateUtils.getNowDate());
        return msdsImportProgressMapper.insertMsdsImportProgress(msdsImportProgress);
    }

    /**
     * 修改MSDS导入进度
     * 
     * @param msdsImportProgress MSDS导入进度
     * @return 结果
     */
    @Override
    public int updateMsdsImportProgress(MsdsImportProgress msdsImportProgress)
    {
        msdsImportProgress.setUpdateTime(DateUtils.getNowDate());
        return msdsImportProgressMapper.updateMsdsImportProgress(msdsImportProgress);
    }
    
    /**
     * 更新任务进度
     * 
     * @param taskId 任务ID
     * @param processedRecords 已处理记录数
     * @param successRecords 成功记录数
     * @param failedRecords 失败记录数
     * @param progressPercent 进度百分比
     * @return 结果
     */
    @Override
    public int updateTaskProgress(String taskId, Integer processedRecords, 
                                Integer successRecords, Integer failedRecords, 
                                Integer progressPercent)
    {
        return msdsImportProgressMapper.updateTaskProgress(taskId, processedRecords, 
                                                         successRecords, failedRecords, 
                                                         progressPercent);
    }
    
    /**
     * 更新任务状态
     * 
     * @param taskId 任务ID
     * @param status 状态
     * @param errorMessage 错误信息
     * @return 结果
     */
    @Override
    public int updateTaskStatus(String taskId, Integer status, String errorMessage)
    {
        return msdsImportProgressMapper.updateTaskStatus(taskId, status, errorMessage);
    }
    
    /**
     * 完成任务
     * 
     * @param taskId 任务ID
     * @param status 最终状态
     * @param errorMessage 错误信息（可选）
     * @return 结果
     */
    @Override
    public int completeTask(String taskId, Integer status, String errorMessage)
    {
        return msdsImportProgressMapper.completeTask(taskId, status, errorMessage);
    }

    /**
     * 批量删除MSDS导入进度
     * 
     * @param progressIds 需要删除的MSDS导入进度主键
     * @return 结果
     */
    @Override
    public int deleteMsdsImportProgressByProgressIds(Long[] progressIds)
    {
        return msdsImportProgressMapper.deleteMsdsImportProgressByProgressIds(progressIds);
    }

    /**
     * 删除MSDS导入进度信息
     * 
     * @param progressId MSDS导入进度主键
     * @return 结果
     */
    @Override
    public int deleteMsdsImportProgressByProgressId(Long progressId)
    {
        return msdsImportProgressMapper.deleteMsdsImportProgressByProgressId(progressId);
    }
    
    /**
     * 根据任务ID删除MSDS导入进度
     * 
     * @param taskId 任务ID
     * @return 结果
     */
    @Override
    public int deleteMsdsImportProgressByTaskId(String taskId)
    {
        return msdsImportProgressMapper.deleteMsdsImportProgressByTaskId(taskId);
    }
    
    /**
     * 清理过期的进度记录
     * 
     * @param days 保留天数
     * @return 清理的记录数
     */
    @Override
    public int cleanExpiredProgress(Integer days)
    {
        return msdsImportProgressMapper.cleanExpiredProgress(days);
    }
    
    /**
     * 统计用户任务数量
     * 
     * @param userId 用户ID
     * @param status 状态（可选）
     * @return 任务数量
     */
    @Override
    public int countUserTasks(Long userId, Integer status)
    {
        return msdsImportProgressMapper.countUserTasks(userId, status);
    }
    
    /**
     * 统计系统任务数量
     * 
     * @param status 状态（可选）
     * @return 任务数量
     */
    @Override
    public int countSystemTasks(Integer status)
    {
        return msdsImportProgressMapper.countSystemTasks(status);
    }
    
    /**
     * 创建导入任务
     * 
     * @param userId 用户ID
     * @param userName 用户名
     * @param fileName 文件名
     * @param fileSize 文件大小
     * @param ipAddress IP地址
     * @param userAgent 用户代理
     * @return 任务ID
     */
    @Override
    public String createImportTask(Long userId, String userName, String fileName, 
                                 Long fileSize, String ipAddress, String userAgent)
    {
        String taskId = UUID.randomUUID().toString().replace("-", "");
        
        MsdsImportProgress progress = new MsdsImportProgress();
        progress.setTaskId(taskId);
        progress.setUserId(userId);
        progress.setUserName(userName);
        progress.setFileName(fileName);
        progress.setFileSize(fileSize);
        progress.setStatus(MsdsImportProgress.Status.WAITING.getCode());
        progress.setTotalRecords(0);
        progress.setProcessedRecords(0);
        progress.setSuccessRecords(0);
        progress.setFailedRecords(0);
        progress.setProgressPercent(0);
        progress.setIpAddress(ipAddress);
        progress.setUserAgent(userAgent);
        
        insertMsdsImportProgress(progress);
        
        return taskId;
    }
    
    /**
     * 开始任务处理
     * 
     * @param taskId 任务ID
     * @param totalRecords 总记录数
     * @return 结果
     */
    @Override
    public int startTaskProcessing(String taskId, Integer totalRecords)
    {
        MsdsImportProgress progress = selectMsdsImportProgressByTaskId(taskId);
        if (progress == null) {
            return 0;
        }
        
        progress.setStatus(MsdsImportProgress.Status.PROCESSING.getCode());
        progress.setTotalRecords(totalRecords);
        progress.setStartTime(DateUtils.getNowDate());
        
        return updateMsdsImportProgress(progress);
    }
    
    /**
     * 检查用户是否有正在进行的任务
     * 
     * @param userId 用户ID
     * @return 是否有正在进行的任务
     */
    @Override
    public boolean hasProcessingTask(Long userId)
    {
        int count = countUserTasks(userId, MsdsImportProgress.Status.PROCESSING.getCode());
        return count > 0;
    }
    
    /**
     * 取消任务
     * 
     * @param taskId 任务ID
     * @param reason 取消原因
     * @return 结果
     */
    @Override
    public int cancelTask(String taskId, String reason)
    {
        return completeTask(taskId, MsdsImportProgress.Status.CANCELLED.getCode(), reason);
    }
}