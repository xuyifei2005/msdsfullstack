package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.MsdsUserFavorite;
import com.ruoyi.system.mapper.MsdsUserFavoriteMapper;
import com.ruoyi.system.service.IMsdsUserFavoriteService;

/**
 * MSDS 用户收藏 Service 实现
 *
 * @author ruoyi
 * @date 2026-11-19
 */
@Service
public class MsdsUserFavoriteServiceImpl implements IMsdsUserFavoriteService
{
    @Autowired
    private MsdsUserFavoriteMapper favoriteMapper;

    @Override
    public List<MsdsUserFavorite> selectUserFavoriteList(MsdsUserFavorite msdsUserFavorite)
    {
        return favoriteMapper.selectMsdsUserFavoriteList(msdsUserFavorite);
    }

    @Override
    public boolean isFavorited(Long userId, Long msdsId)
    {
        if (userId == null || msdsId == null)
        {
            return false;
        }
        return favoriteMapper.selectByUserAndMsds(userId, msdsId) != null;
    }

    /**
     * 收藏文档
     *
     * <p>幂等处理：唯一键 uk_user_msds 保证同一用户对同一文档只有一条记录，
     * 重复收藏时更新原有记录而非插入新行。</p>
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int addFavorite(MsdsUserFavorite msdsUserFavorite)
    {
        if (msdsUserFavorite.getUserId() == null || msdsUserFavorite.getMsdsId() == null)
        {
            return 0;
        }

        MsdsUserFavorite existing = favoriteMapper.selectByUserAndMsds(
                msdsUserFavorite.getUserId(), msdsUserFavorite.getMsdsId());
        if (existing != null)
        {
            msdsUserFavorite.setFavoriteId(existing.getFavoriteId());
            msdsUserFavorite.setUpdateTime(new java.util.Date());
            return favoriteMapper.updateMsdsUserFavorite(msdsUserFavorite);
        }

        if (StringUtils.isEmpty(msdsUserFavorite.getFolderName()))
        {
            msdsUserFavorite.setFolderName("默认收藏夹");
        }
        if (msdsUserFavorite.getCreateTime() == null)
        {
            msdsUserFavorite.setCreateTime(new java.util.Date());
        }
        return favoriteMapper.insertMsdsUserFavorite(msdsUserFavorite);
    }

    @Override
    public int removeFavorite(Long userId, Long msdsId)
    {
        if (userId == null || msdsId == null)
        {
            return 0;
        }
        return favoriteMapper.deleteByUserAndMsds(userId, msdsId);
    }

    @Override
    public int deleteFavorites(Long[] favoriteIds)
    {
        return favoriteMapper.deleteMsdsUserFavoriteByFavoriteIds(favoriteIds);
    }
}
