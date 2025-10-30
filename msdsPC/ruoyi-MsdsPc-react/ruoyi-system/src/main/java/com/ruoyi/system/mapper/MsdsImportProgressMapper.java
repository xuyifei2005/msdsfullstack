package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.MsdsImportProgress;
import java.util.List;

/**
 * MSDS导入进度Mapper接口
 * 
 * @author ruoyi
 * @date 2024-01-15
 */
public interface MsdsImportProgressMapper {
    
    /**
     * 查询MSDS导入进度
     * 
     * @param progressId MSDS导入进度主键
     * @return MSDS导入进度
     */
    public MsdsImportProgress selectMsdsImportProgressByProgressId(Long progressId);
    
    /**
     * 根据任务ID查询MSDS导入进度
     * 
     * @param taskId 任务ID
     * @return MSDS导入进度
     */
    public MsdsImportProgress selectMsdsImportProgressByTaskId(String taskId);
    
    /**
     * 查询MSDS导入进度列表
     * 
     * @param msdsImportProgress MSDS导入进度
     * @return MSDS导入进度集合
     */
    public List<MsdsImportProgress> selectMsdsImportProgressList(MsdsImportProgress msdsImportProgress);
    
    /**
     * 查询用户的导入进度列表
     * 
     * @param userId 用户ID
     * @return MSDS导入进度集合
     */
    public List<MsdsImportProgress> selectMsdsImportProgressByUserId(Long userId);
    
    /**
     * 查询正在进行的导入任务
     * 
     * @return MSDS导入进度集合
     */
    public List<MsdsImportProgress> selectProcessingTasks();
    
    /**
     * 查询超时的导入任务
     * 
     * @param timeoutMinutes 超时分钟数
     * @return MSDS导入进度集合
     */
    public List<MsdsImportProgress> selectTimeoutTasks(Integer timeoutMinutes);
    
    /**
     * 新增MSDS导入进度
     * 
     * @param msdsImportProgress MSDS导入进度
     * @return 结果
     */
    public int insertMsdsImportProgress(MsdsImportProgress msdsImportProgress);
    
    /**
     * 修改MSDS导入进度
     * 
     * @param msdsImportProgress MSDS导入进度
     * @return 结果
     */
    public int updateMsdsImportProgress(MsdsImportProgress msdsImportProgress);
    
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
    public int updateTaskProgress(String taskId, Integer processedRecords, 
                                 Integer successRecords, Integer failedRecords, 
                                 Integer progressPercent);
    
    /**
     * 更新任务状态
     * 
     * @param taskId 任务ID
     * @param status 状态
     * @param errorMessage 错误信息（可选）
     * @return 结果
     */
    public int updateTaskStatus(String taskId, Integer status, String errorMessage);
    
    /**
     * 完成任务
     * 
     * @param taskId 任务ID
     * @param status 最终状态
     * @param errorMessage 错误信息（可选）
     * @return 结果
     */
    public int completeTask(String taskId, Integer status, String errorMessage);
    
    /**
     * 删除MSDS导入进度
     * 
     * @param progressId MSDS导入进度主键
     * @return 结果
     */
    public int deleteMsdsImportProgressByProgressId(Long progressId);
    
    /**
     * 批量删除MSDS导入进度
     * 
     * @param progressIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteMsdsImportProgressByProgressIds(Long[] progressIds);
    
    /**
     * 根据任务ID删除MSDS导入进度
     * 
     * @param taskId 任务ID
     * @return 结果
     */
    public int deleteMsdsImportProgressByTaskId(String taskId);
    
    /**
     * 清理过期的导入进度记录
     * 
     * @param days 保留天数
     * @return 结果
     */
    public int cleanExpiredProgress(Integer days);
    
    /**
     * 统计用户的导入任务数量
     * 
     * @param userId 用户ID
     * @param status 状态（可选）
     * @return 任务数量
     */
    public int countUserTasks(Long userId, Integer status);
    
    /**
     * 统计系统导入任务数量
     * 
     * @param status 状态（可选）
     * @return 任务数量
     */
    public int countSystemTasks(Integer status);
}