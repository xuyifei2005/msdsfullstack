package com.ruoyi.system.service;

import java.util.List;
import java.util.Map;

/**
 * MSDS 文档统计计数 Service 接口
 *
 * <p>把「查看 / 下载 / 收藏」等真实行为落库到
 * msds_document_statistics 与 msds_document_access_log，
 * 使页面上的计数来自真实使用数据而非写死值。</p>
 *
 * @author ruoyi
 * @date 2026-11-19
 */
public interface IMsdsDocumentStatisticsService
{
    /**
     * 获取文档的统计计数
     *
     * @param msdsId MSDS文档ID
     * @return 计数映射（viewCount / downloadCount / favoriteCount / shareCount）
     */
    public Map<String, Object> getStatistics(Long msdsId);

    /**
     * 记录一次文档访问并累加对应计数
     *
     * @param msdsId     MSDS文档ID
     * @param action     计数类型：view / download / favorite / share
     * @param userId     用户ID
     * @param userName   用户名
     * @param ipAddress  IP地址
     * @param userAgent  浏览器标识
     * @return 影响行数
     */
    public int recordAccess(Long msdsId, String action, Long userId, String userName,
                            String ipAddress, String userAgent);

    /**
     * 回退某类计数（取消收藏等撤销场景）
     *
     * @param msdsId MSDS文档ID
     * @param action 计数类型：view / download / favorite / share
     * @return 影响行数
     */
    public int decrementStatistics(Long msdsId, String action);

    /**
     * 查询文档的访问明细
     *
     * @param msdsId MSDS文档ID
     * @param limit  数量限制
     * @return 访问明细列表
     */
    public List<Map<String, Object>> listAccessLogs(Long msdsId, Integer limit);
}
