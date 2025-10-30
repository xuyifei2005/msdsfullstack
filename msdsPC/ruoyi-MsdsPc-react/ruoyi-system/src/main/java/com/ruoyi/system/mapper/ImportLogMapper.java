package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.ImportLog;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 导入日志Mapper接口
 * 
 * @author ruoyi
 * @date 2024-01-20
 */
public interface ImportLogMapper {
    
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
     * 删除导入日志
     *
     * @param logId 导入日志主键
     * @return 结果
     */
    public int deleteImportLogByLogId(Long logId);

    /**
     * 批量删除导入日志
     *
     * @param logIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteImportLogByLogIds(Long[] logIds);
    
    /**
     * 根据批次号查询导入日志
     *
     * @param batchNo 批次号
     * @return 导入日志
     */
    public ImportLog selectImportLogByBatchNo(@Param("batchNo") String batchNo);
    
    /**
     * 根据批次号更新导入日志
     *
     * @param importLog 导入日志
     * @return 结果
     */
    public int updateImportLogByBatchNo(ImportLog importLog);
    
    /**
     * 获取导入统计信息
     *
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 统计信息
     */
    public Map<String, Object> getImportStatistics(@Param("startDate") String startDate, 
                                                   @Param("endDate") String endDate);
    
    /**
     * 获取用户导入历史
     *
     * @param userId 用户ID
     * @param limit 限制数量
     * @return 导入历史
     */
    public List<ImportLog> getUserImportHistory(@Param("userId") Long userId, 
                                               @Param("limit") Integer limit);
    
    /**
     * 获取导入错误统计
     *
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 错误统计
     */
    public Map<String, Integer> getImportErrorStatistics(@Param("startDate") String startDate, 
                                                         @Param("endDate") String endDate);
    
    /**
     * 删除过期日志
     *
     * @param expiredDate 过期日期
     * @return 删除数量
     */
    public int deleteExpiredLogs(@Param("expiredDate") Date expiredDate);
    
    /**
     * 获取导入性能统计
     *
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 性能统计
     */
    public Map<String, Object> getImportPerformanceStatistics(@Param("startDate") String startDate, 
                                                              @Param("endDate") String endDate);
    
    /**
     * 获取热门导入类型
     *
     * @param limit 限制数量
     * @return 热门导入类型
     */
    public List<Map<String, Object>> getPopularImportTypes(@Param("limit") Integer limit);
    
    /**
     * 获取导入趋势数据
     *
     * @param days 天数
     * @return 趋势数据
     */
    public List<Map<String, Object>> getImportTrendData(@Param("days") Integer days);
}