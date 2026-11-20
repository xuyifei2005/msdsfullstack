package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.MsdsUserFavorite;
import org.apache.ibatis.annotations.Param;

/**
 * MSDS 用户收藏 Mapper 接口
 *
 * @author ruoyi
 * @date 2026-11-19
 */
public interface MsdsUserFavoriteMapper
{
    /**
     * 查询收藏记录
     *
     * @param favoriteId 收藏主键
     * @return 收藏记录
     */
    public MsdsUserFavorite selectMsdsUserFavoriteByFavoriteId(Long favoriteId);

    /**
     * 查询收藏列表
     *
     * @param msdsUserFavorite 收藏条件
     * @return 收藏集合
     */
    public List<MsdsUserFavorite> selectMsdsUserFavoriteList(MsdsUserFavorite msdsUserFavorite);

    /**
     * 查询用户对某文档的收藏记录
     *
     * @param userId 用户ID
     * @param msdsId MSDS文档ID
     * @return 收藏记录（不存在返回 null）
     */
    public MsdsUserFavorite selectByUserAndMsds(@Param("userId") Long userId,
                                                @Param("msdsId") Long msdsId);

    /**
     * 新增收藏
     *
     * @param msdsUserFavorite 收藏
     * @return 结果
     */
    public int insertMsdsUserFavorite(MsdsUserFavorite msdsUserFavorite);

    /**
     * 修改收藏
     *
     * @param msdsUserFavorite 收藏
     * @return 结果
     */
    public int updateMsdsUserFavorite(MsdsUserFavorite msdsUserFavorite);

    /**
     * 删除收藏（按用户与文档）
     *
     * @param userId 用户ID
     * @param msdsId MSDS文档ID
     * @return 结果
     */
    public int deleteByUserAndMsds(@Param("userId") Long userId, @Param("msdsId") Long msdsId);

    /**
     * 批量删除收藏
     *
     * @param favoriteIds 收藏主键集合
     * @return 结果
     */
    public int deleteMsdsUserFavoriteByFavoriteIds(Long[] favoriteIds);
}
