package com.ruoyi.web.controller.system;

import java.util.List;
import java.util.Map;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.ip.IpUtils;
import com.ruoyi.system.service.IMsdsDocumentStatisticsService;

/**
 * MSDS 文档统计计数 Controller
 *
 * <p>提供真实计数的读取与累加入口，使「查看 / 下载 / 收藏」次数
 * 来自真实使用行为。</p>
 *
 * @author ruoyi
 * @date 2026-11-19
 */
@RestController
@RequestMapping("/system/msds/statistics")
public class MsdsDocumentStatisticsController extends BaseController
{
    @Autowired
    private IMsdsDocumentStatisticsService statisticsService;

    /**
     * 获取指定文档的统计计数
     */
    @PreAuthorize("@ss.hasAnyPermi('system:msds:list,system:msds:query,system:msds:search')")
    @GetMapping("/{msdsId}")
    public AjaxResult getStatistics(@PathVariable("msdsId") Long msdsId)
    {
        return success(statisticsService.getStatistics(msdsId));
    }

    /**
     * 记录一次访问（查看 / 下载 / 收藏）并累加对应计数
     *
     * @param action 计数类型：view / download / favorite / share
     */
    @PreAuthorize("@ss.hasAnyPermi('system:msds:list,system:msds:query,system:msds:search')")
    @PostMapping("/{msdsId}/access")
    public AjaxResult recordAccess(@PathVariable("msdsId") Long msdsId,
                                   @RequestParam(value = "action", required = false, defaultValue = "view") String action,
                                   HttpServletRequest request)
    {
        String ipAddress = IpUtils.getIpAddr(request);
        String userAgent = request.getHeader("User-Agent");
        Long userId = null;
        String userName = null;
        try
        {
            userId = SecurityUtils.getUserId();
            userName = SecurityUtils.getUsername();
        }
        catch (Exception e)
        {
            // 未登录场景（如接口开放访问）允许匿名计数
            logger.warn("未获取到登录用户信息，按匿名方式记录访问: " + e.getMessage());
        }

        int affected = statisticsService.recordAccess(msdsId, action, userId, userName, ipAddress, userAgent);
        Map<String, Object> statistics = statisticsService.getStatistics(msdsId);
        return success(statistics);
    }

    /**
     * 查询文档的访问明细
     */
    @PreAuthorize("@ss.hasAnyPermi('system:msds:list,system:msds:query,system:msds:search')")
    @GetMapping("/{msdsId}/logs")
    public AjaxResult listAccessLogs(@PathVariable("msdsId") Long msdsId,
                                      @RequestParam(value = "limit", required = false, defaultValue = "20") Integer limit)
    {
        List<Map<String, Object>> logs = statisticsService.listAccessLogs(msdsId, limit);
        return success(logs);
    }
}
