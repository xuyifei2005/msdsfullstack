package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.MsdsUserFavorite;

/**
 * MSDS 用户收藏 Service 接口
 *
 * @author ruoyi
 * @date 2026-11-19
 */
public interface IMsdsUserFavoriteService
{
    /**
     * 查询用户的收藏列表
     *
     * @param msdsUserFavorite 查询条件
     * @return 收藏列表
     */
    public List<MsdsUserFavorite> selectUserFavoriteList(MsdsUserFavorite msdsUserFavorite);

    /**
     * 判断用户是否已收藏某文档
     *
     * @param userId 用户ID
     * @param msdsId MSDS文档ID
     * @return 是否已收藏
     */
    public boolean isFavorited(Long userId, Long msdsId);

    /**
     * 收藏文档（幂等：已收藏则直接返回成功）
     *
     * @param msdsUserFavorite 收藏信息
     * @return 结果
     */
    public int addFavorite(MsdsUserFavorite msdsUserFavorite);

    /**
     * 取消收藏
     *
     * @param userId 用户ID
     * @param msdsId MSDS文档ID
     * @return 结果
     */
    public int removeFavorite(Long userId, Long msdsId);

    /**
     * 批量删除收藏
     *
     * @param favoriteIds 收藏主键集合
     * @return 结果
     */
    public int deleteFavorites(Long[] favoriteIds);
}
