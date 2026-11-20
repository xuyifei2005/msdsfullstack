package com.ruoyi.web.controller.system;

import java.util.List;
import java.util.Map;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
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
import com.ruoyi.system.domain.MsdsUserFavorite;
import com.ruoyi.system.service.IMsdsDocumentStatisticsService;
import com.ruoyi.system.service.IMsdsUserFavoriteService;

/**
 * MSDS 用户收藏 Controller
 *
 * <p>按用户维度记录收藏（msds_user_favorite），同时联动全局收藏计数
 * （msds_document_statistics.favorite_count）。</p>
 *
 * @author ruoyi
 * @date 2026-11-19
 */
@RestController
@RequestMapping("/system/msds/favorite")
public class MsdsUserFavoriteController extends BaseController
{
    @Autowired
    private IMsdsUserFavoriteService favoriteService;

    @Autowired
    private IMsdsDocumentStatisticsService statisticsService;

    /**
     * 查询当前用户的收藏列表
     */
    @PreAuthorize("@ss.hasAnyPermi('system:msds:list,system:msds:query,system:msds:search')")
    @GetMapping("/list")
    public AjaxResult list()
    {
        MsdsUserFavorite query = new MsdsUserFavorite();
        query.setUserId(SecurityUtils.getUserId());
        List<MsdsUserFavorite> list = favoriteService.selectUserFavoriteList(query);
        return success(list);
    }

    /**
     * 查询当前用户是否已收藏某文档
     */
    @PreAuthorize("@ss.hasAnyPermi('system:msds:list,system:msds:query,system:msds:search')")
    @GetMapping("/{msdsId}/status")
    public AjaxResult status(@PathVariable("msdsId") Long msdsId)
    {
        boolean favorited = favoriteService.isFavorited(SecurityUtils.getUserId(), msdsId);
        Map<String, Object> data = new java.util.HashMap<>();
        data.put("favorited", favorited);
        return success(data);
    }

    /**
     * 收藏文档
     *
     * @param msdsName 文档名称
     * @param casNumber CAS号
     * @param folderName 收藏夹名称
     * @param tags 标签（逗号分隔）
     * @param note 备注
     */
    @PreAuthorize("@ss.hasAnyPermi('system:msds:list,system:msds:query,system:msds:search')")
    @PostMapping("/{msdsId}")
    public AjaxResult add(@PathVariable("msdsId") Long msdsId,
                          @RequestParam(value = "msdsName", required = false) String msdsName,
                          @RequestParam(value = "casNumber", required = false) String casNumber,
                          @RequestParam(value = "folderName", required = false) String folderName,
                          @RequestParam(value = "tags", required = false) String tags,
                          @RequestParam(value = "note", required = false) String note,
                          HttpServletRequest request)
    {
        Long userId = SecurityUtils.getUserId();
        if (favoriteService.isFavorited(userId, msdsId))
        {
            // 已收藏：幂等返回，不重复累加计数
            Map<String, Object> data = new java.util.HashMap<>();
            data.put("favorited", true);
            data.put("statistics", statisticsService.getStatistics(msdsId));
            return success(data);
        }

        MsdsUserFavorite favorite = new MsdsUserFavorite();
        favorite.setUserId(userId);
        favorite.setUserName(SecurityUtils.getUsername());
        favorite.setMsdsId(msdsId);
        favorite.setMsdsName(msdsName);
        favorite.setCasNumber(casNumber);
        favorite.setFolderName(folderName);
        favorite.setTags(tags);
        favorite.setNote(note);
        favorite.setCreateBy(SecurityUtils.getUsername());
        favorite.setCreateTime(new java.util.Date());

        int affected = favoriteService.addFavorite(favorite);
        if (affected > 0)
        {
            statisticsService.recordAccess(msdsId, "favorite", userId, SecurityUtils.getUsername(),
                    IpUtils.getIpAddr(request), request.getHeader("User-Agent"));
        }

        Map<String, Object> data = new java.util.HashMap<>();
        data.put("favorited", true);
        data.put("statistics", statisticsService.getStatistics(msdsId));
        return success(data);
    }

    /**
     * 取消收藏
     */
    @PreAuthorize("@ss.hasAnyPermi('system:msds:list,system:msds:query,system:msds:search')")
    @DeleteMapping("/{msdsId}")
    public AjaxResult remove(@PathVariable("msdsId") Long msdsId)
    {
        int affected = favoriteService.removeFavorite(SecurityUtils.getUserId(), msdsId);
        if (affected > 0)
        {
            // 取消收藏时同步回退全局收藏计数
            statisticsService.decrementStatistics(msdsId, "favorite");
        }
        Map<String, Object> data = new java.util.HashMap<>();
        data.put("favorited", false);
        data.put("statistics", statisticsService.getStatistics(msdsId));
        return success(data);
    }
}
