package com.ruoyi.system.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.MsdsDocumentStatisticsMapper;
import com.ruoyi.system.service.IMsdsDocumentStatisticsService;

/**
 * MSDS 文档统计计数 Service 实现
 *
 * @author ruoyi
 * @date 2026-11-19
 */
@Service
public class MsdsDocumentStatisticsServiceImpl implements IMsdsDocumentStatisticsService
{
    private static final Logger log = LoggerFactory.getLogger(MsdsDocumentStatisticsServiceImpl.class);

    /** 允许累计的计数类型 */
    private static final String ACTION_VIEW = "view";
    private static final String ACTION_DOWNLOAD = "download";
    private static final String ACTION_FAVORITE = "favorite";
    private static final String ACTION_SHARE = "share";

    @Autowired
    private MsdsDocumentStatisticsMapper statisticsMapper;

    /**
     * 获取文档的统计计数
     *
     * <p>无统计记录时返回各项为 0 的空映射，而不是 null。</p>
     */
    @Override
    public Map<String, Object> getStatistics(Long msdsId)
    {
        Map<String, Object> result = new HashMap<>();
        result.put("viewCount", 0);
        result.put("downloadCount", 0);
        result.put("favoriteCount", 0);
        result.put("shareCount", 0);

        if (msdsId == null)
        {
            return result;
        }

        Map<String, Object> row = statisticsMapper.selectStatisticsByMsdsId(msdsId);
        if (row != null)
        {
            for (Map.Entry<String, Object> entry : row.entrySet())
            {
                result.put(entry.getKey(), entry.getValue());
            }
        }
        return result;
    }

    /**
     * 记录一次文档访问并累加对应计数
     *
     * <p>统计写入失败不影响主业务流程（例如 PDF 导出本身已成功），
     * 仅记录日志，避免计数问题阻断功能。</p>
     */
    @Override
    public int recordAccess(Long msdsId, String action, Long userId, String userName,
                            String ipAddress, String userAgent)
    {
        if (msdsId == null || action == null || action.isEmpty())
        {
            return 0;
        }

        String normalized = action.trim().toLowerCase();
        if (!ACTION_VIEW.equals(normalized)
                && !ACTION_DOWNLOAD.equals(normalized)
                && !ACTION_FAVORITE.equals(normalized)
                && !ACTION_SHARE.equals(normalized))
        {
            return 0;
        }

        int affected = 0;
        try
        {
            affected = statisticsMapper.incrementStatistics(msdsId, normalized);
        }
        catch (Exception e)
        {
            log.error("累加MSDS统计计数失败, msdsId={}, action={}", msdsId, normalized, e);
        }

        try
        {
            statisticsMapper.insertAccessLog(msdsId, userId, userName, normalized, ipAddress, userAgent);
        }
        catch (Exception e)
        {
            log.error("记录MSDS访问明细失败, msdsId={}, action={}", msdsId, normalized, e);
        }

        return affected;
    }

    /**
     * 回退某类计数（取消收藏等撤销场景）
     */
    @Override
    public int decrementStatistics(Long msdsId, String action)
    {
        if (msdsId == null || action == null || action.isEmpty())
        {
            return 0;
        }

        String normalized = action.trim().toLowerCase();
        if (!ACTION_VIEW.equals(normalized)
                && !ACTION_DOWNLOAD.equals(normalized)
                && !ACTION_FAVORITE.equals(normalized)
                && !ACTION_SHARE.equals(normalized))
        {
            return 0;
        }

        try
        {
            return statisticsMapper.decrementStatistics(msdsId, normalized);
        }
        catch (Exception e)
        {
            log.error("回退MSDS统计计数失败, msdsId={}, action={}", msdsId, normalized, e);
            return 0;
        }
    }

    @Override
    public List<Map<String, Object>> listAccessLogs(Long msdsId, Integer limit)
    {
        if (msdsId == null)
        {
            return new java.util.ArrayList<>();
        }
        if (limit == null || limit <= 0)
        {
            limit = 20;
        }
        return statisticsMapper.selectAccessLogsByMsdsId(msdsId, limit);
    }
}
