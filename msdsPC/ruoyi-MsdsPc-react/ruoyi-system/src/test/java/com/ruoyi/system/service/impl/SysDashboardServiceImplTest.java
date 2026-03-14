package com.ruoyi.system.service.impl;

import com.ruoyi.common.core.redis.RedisCache;
import com.ruoyi.system.mapper.SysDashboardMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.Map;
import java.util.concurrent.TimeUnit;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

public class SysDashboardServiceImplTest {

    @Mock
    private SysDashboardMapper dashboardMapper;

    @Mock
    private RedisCache redisCache;

    @InjectMocks
    private SysDashboardServiceImpl dashboardService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void getDocumentStats_shouldCacheForFiveMinutes() {
        when(redisCache.getCacheObject("dashboard:document:stats")).thenReturn(null);
        when(dashboardMapper.countTotalDocuments()).thenReturn(100);
        when(dashboardMapper.countValidDocuments()).thenReturn(80);
        when(dashboardMapper.countPendingDocuments()).thenReturn(15);
        when(dashboardMapper.countExpiredDocuments()).thenReturn(5);

        Map<String, Object> stats = dashboardService.getDocumentStats();

        assertEquals(100, stats.get("total"));
        assertEquals(80, stats.get("valid"));
        assertEquals(15, stats.get("pending"));
        assertEquals(5, stats.get("expired"));
        verify(redisCache, times(1)).setCacheObject(eq("dashboard:document:stats"), any(Map.class), eq(5), eq(TimeUnit.MINUTES));
    }

    @Test
    void getAccessStats_shouldCacheForOneMinute() {
        when(redisCache.getCacheObject("dashboard:access:stats")).thenReturn(null);
        when(dashboardMapper.countTodayViews()).thenReturn(11);
        when(dashboardMapper.countMonthViews()).thenReturn(22);
        when(dashboardMapper.countTotalViews()).thenReturn(33);
        when(dashboardMapper.countActiveUsers()).thenReturn(4);

        Map<String, Object> stats = dashboardService.getAccessStats();

        assertEquals(11, stats.get("todayViews"));
        assertEquals(22, stats.get("monthViews"));
        assertEquals(33, stats.get("totalViews"));
        assertEquals(4, stats.get("activeUsers"));
        verify(redisCache, times(1)).setCacheObject(eq("dashboard:access:stats"), any(Map.class), eq(1), eq(TimeUnit.MINUTES));
    }
}
