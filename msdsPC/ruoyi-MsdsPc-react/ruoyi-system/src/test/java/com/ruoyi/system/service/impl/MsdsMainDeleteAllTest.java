package com.ruoyi.system.service.impl;

import com.ruoyi.common.core.redis.RedisCache;
import com.ruoyi.system.mapper.MsdsMainMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

public class MsdsMainDeleteAllTest {

    @Mock
    private MsdsMainMapper msdsMainMapper;

    @Mock
    private RedisCache redisCache;

    @InjectMocks
    private MsdsMainServiceImpl msdsMainService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void deleteAllMsdsMain_shouldClearDashboardCache() {
        when(msdsMainMapper.deleteAllMsdsMain()).thenReturn(12);

        int deleted = msdsMainService.deleteAllMsdsMain();

        assertEquals(12, deleted);
        verify(redisCache, times(1)).deleteObject("dashboard:document:stats");
        verify(redisCache, times(1)).deleteObject("dashboard:chemical:stats");
    }
}

