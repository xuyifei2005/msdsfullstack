package com.ruoyi.system.service.impl;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import java.util.*;
import java.util.Date;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.ruoyi.system.domain.MsdsHazard;
import com.ruoyi.system.mapper.MsdsHazardMapper;

/**
 * MSDS危险性概述服务层单元测试
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
@ExtendWith(MockitoExtension.class)
class MsdsHazardServiceImplTest {

    @Mock
    private MsdsHazardMapper msdsHazardMapper;
    
    @InjectMocks
    private MsdsHazardServiceImpl msdsHazardService;
    
    private MsdsHazard testMsdsHazard;
    
    @BeforeEach
    void setUp() {
        testMsdsHazard = new MsdsHazard();
        testMsdsHazard.setId(1L);
        testMsdsHazard.setMsdsId(1L);
        testMsdsHazard.setHazardCategory("易燃液体，类别2");
        testMsdsHazard.setWarningWord("危险");
        testMsdsHazard.setHazardDescription("H225: 高度易燃液体和蒸气");
        testMsdsHazard.setPreventionMeasures("P210: 远离热源、火花、明火和热表面");
        testMsdsHazard.setHealthHazards("无其他已知危险");
        testMsdsHazard.setCreateBy("admin");
        testMsdsHazard.setCreateTime(new Date());
    }
    
    @Test
    void testSelectMsdsHazardById() {
        // Given
        Long id = 1L;
        when(msdsHazardMapper.selectMsdsHazardById(id)).thenReturn(testMsdsHazard);
        
        // When
        MsdsHazard result = msdsHazardService.selectMsdsHazardById(id);
        
        // Then
        assertNotNull(result);
        assertEquals(testMsdsHazard.getId(), result.getId());
        assertEquals(testMsdsHazard.getHazardCategory(), result.getHazardCategory());
        verify(msdsHazardMapper, times(1)).selectMsdsHazardById(id);
    }
    
    @Test
    void testSelectMsdsHazardByIdNotFound() {
        // Given
        Long id = 999L;
        when(msdsHazardMapper.selectMsdsHazardById(id)).thenReturn(null);
        
        // When
        MsdsHazard result = msdsHazardService.selectMsdsHazardById(id);
        
        // Then
        assertNull(result);
        verify(msdsHazardMapper, times(1)).selectMsdsHazardById(id);
    }
    
    @Test
    void testSelectMsdsHazardList() {
        // Given
        MsdsHazard queryParam = new MsdsHazard();
        queryParam.setMsdsId(1L);
        List<MsdsHazard> expectedList = Arrays.asList(testMsdsHazard);
        when(msdsHazardMapper.selectMsdsHazardList(queryParam)).thenReturn(expectedList);
        
        // When
        List<MsdsHazard> result = msdsHazardService.selectMsdsHazardList(queryParam);
        
        // Then
        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals(testMsdsHazard.getMsdsId(), result.get(0).getMsdsId());
        verify(msdsHazardMapper, times(1)).selectMsdsHazardList(queryParam);
    }
    
    @Test
    void testSelectMsdsHazardByMsdsId() {
        // Given
        Long msdsId = 1L;
        when(msdsHazardMapper.selectMsdsHazardByMsdsId(msdsId)).thenReturn(testMsdsHazard);
        
        // When
        MsdsHazard result = msdsHazardService.selectMsdsHazardByMsdsId(msdsId);
        
        // Then
        assertNotNull(result);
        assertEquals(msdsId, result.getMsdsId());
        verify(msdsHazardMapper, times(1)).selectMsdsHazardByMsdsId(msdsId);
    }
    
    @Test
    void testInsertMsdsHazard() {
        // Given
        when(msdsHazardMapper.insertMsdsHazard(testMsdsHazard)).thenReturn(1);
        
        // When
        int result = msdsHazardService.insertMsdsHazard(testMsdsHazard);
        
        // Then
        assertEquals(1, result);
        verify(msdsHazardMapper, times(1)).insertMsdsHazard(testMsdsHazard);
    }
    
    @Test
    void testUpdateMsdsHazard() {
        // Given
        when(msdsHazardMapper.updateMsdsHazard(testMsdsHazard)).thenReturn(1);
        
        // When
        int result = msdsHazardService.updateMsdsHazard(testMsdsHazard);
        
        // Then
        assertEquals(1, result);
        verify(msdsHazardMapper, times(1)).updateMsdsHazard(testMsdsHazard);
    }
    
    @Test
    void testDeleteMsdsHazardByIds() {
        // Given
        Long[] ids = {1L, 2L};
        when(msdsHazardMapper.deleteMsdsHazardByIds(ids)).thenReturn(2);
        
        // When
        int result = msdsHazardService.deleteMsdsHazardByIds(ids);
        
        // Then
        assertEquals(2, result);
        verify(msdsHazardMapper, times(1)).deleteMsdsHazardByIds(ids);
    }
    
    @Test
    void testDeleteMsdsHazardById() {
        // Given
        Long id = 1L;
        when(msdsHazardMapper.deleteMsdsHazardById(id)).thenReturn(1);
        
        // When
        int result = msdsHazardService.deleteMsdsHazardById(id);
        
        // Then
        assertEquals(1, result);
        verify(msdsHazardMapper, times(1)).deleteMsdsHazardById(id);
    }
    
    @Test
    void testDeleteMsdsHazardByMsdsId() {
        // Given
        Long msdsId = 1L;
        when(msdsHazardMapper.deleteMsdsHazardByMsdsId(msdsId)).thenReturn(1);
        
        // When
        int result = msdsHazardService.deleteMsdsHazardByMsdsId(msdsId);
        
        // Then
        assertEquals(1, result);
        verify(msdsHazardMapper, times(1)).deleteMsdsHazardByMsdsId(msdsId);
    }
    
    @Test
    void testInsertMsdsHazardWithNullMsdsId() {
        // Given
        MsdsHazard hazardWithNullMsdsId = new MsdsHazard();
        hazardWithNullMsdsId.setHazardCategory("测试分类");
        
        // When & Then
        assertThrows(IllegalArgumentException.class, () -> {
            msdsHazardService.insertMsdsHazard(hazardWithNullMsdsId);
        });
    }
    
    @Test
    void testUpdateMsdsHazardWithNullId() {
        // Given
        MsdsHazard hazardWithNullId = new MsdsHazard();
        hazardWithNullId.setMsdsId(1L);
        hazardWithNullId.setHazardCategory("测试分类");
        
        // When & Then
        assertThrows(IllegalArgumentException.class, () -> {
            msdsHazardService.updateMsdsHazard(hazardWithNullId);
        });
    }
    


}