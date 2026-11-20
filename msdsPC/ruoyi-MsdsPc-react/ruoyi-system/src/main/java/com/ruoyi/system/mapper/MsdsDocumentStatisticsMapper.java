package com.ruoyi.system.mapper;

import java.util.Map;
import org.apache.ibatis.annotations.Param;

/**
 * MSDS 文档统计计数 Mapper 接口
 *
 * <p>负责 msds_document_statistics（查看/下载/收藏计数）与
 * msds_document_access_log（访问明细）的真实写入与读取。</p>
 *
 * @author ruoyi
 * @date 2026-11-19
 */
public interface MsdsDocumentStatisticsMapper
{
    /**
     * 查询指定文档的统计计数
     *
     * @param msdsId MSDS文档ID
     * @return 计数映射（无记录时各项为0）
     */
    public Map<String, Object> selectStatisticsByMsdsId(@Param("msdsId") Long msdsId);

    /**
     * 以 UPSERT 方式累加某类计数
     *
     * <p>不存在统计行时自动插入，存在时按 action 累加对应字段，
     * 并同步更新 last_xxx_time，确保计数始终来自真实行为。</p>
     *
     * @param msdsId   MSDS文档ID
     * @param action   计数类型：view / download / favorite
     * @return 影响行数
     */
    public int incrementStatistics(@Param("msdsId") Long msdsId, @Param("action") String action);

    /**
     * 回退某类计数（取消收藏等撤销场景）
     *
     * @param msdsId MSDS文档ID
     * @param action 计数类型：view / download / favorite / share
     * @return 影响行数
     */
    public int decrementStatistics(@Param("msdsId") Long msdsId, @Param("action") String action);

    /**
     * 记录一条访问明细
     *
     * @param msdsId    MSDS文档ID
     * @param userId    用户ID
     * @param userName  用户名
     * @param accessType 访问类型：view / download / preview / print
     * @param ipAddress IP地址
     * @param userAgent 浏览器标识
     * @return 影响行数
     */
    public int insertAccessLog(@Param("msdsId") Long msdsId,
                               @Param("userId") Long userId,
                               @Param("userName") String userName,
                               @Param("accessType") String accessType,
                               @Param("ipAddress") String ipAddress,
                               @Param("userAgent") String userAgent);

    /**
     * 查询文档的访问明细（按时间倒序）
     *
     * @param msdsId MSDS文档ID
     * @param limit  数量限制
     * @return 访问明细列表
     */
    public java.util.List<Map<String, Object>> selectAccessLogsByMsdsId(@Param("msdsId") Long msdsId,
                                                                          @Param("limit") Integer limit);
}
