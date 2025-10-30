package com.ruoyi.system.service.impl;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import java.util.*;
import java.math.BigDecimal;
import java.util.Date;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.ruoyi.system.domain.MsdsComponent;
import com.ruoyi.system.mapper.MsdsComponentMapper;

/**
 * MSDS成分信息服务层单元测试
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
@ExtendWith(MockitoExtension.class)
class MsdsComponentServiceImplTest {

    @Mock
    private MsdsComponentMapper msdsComponentMapper;
    
    @InjectMocks
    private MsdsComponentServiceImpl msdsComponentService;
    
    private MsdsComponent testMsdsComponent;
    
    @BeforeEach
    void setUp() {
        testMsdsComponent = new MsdsComponent();
        testMsdsComponent.setId(1L);
        testMsdsComponent.setMsdsId(1L);
        testMsdsComponent.setComponentName("乙醇");
        testMsdsComponent.setCasNumber("64-17-5");
        testMsdsComponent.setComponentContent("95.0%");
        testMsdsComponent.setContentMin(new BigDecimal("95.0"));
        testMsdsComponent.setHazardLevel("易燃液体，类别2");
        testMsdsComponent.setCreateBy("admin");
        testMsdsComponent.setCreateTime(new Date());
    }
    
    @Test
    void testSelectMsdsComponentById() {
        // Given
        Long id = 1L;
        when(msdsComponentMapper.selectMsdsComponentById(id)).thenReturn(testMsdsComponent);
        
        // When
        MsdsComponent result = msdsComponentService.selectMsdsComponentById(id);
        
        // Then
        assertNotNull(result);
        assertEquals(testMsdsComponent.getId(), result.getId());
        assertEquals(testMsdsComponent.getComponentName(), result.getComponentName());
        verify(msdsComponentMapper, times(1)).selectMsdsComponentById(id);
    }
    
    @Test
    void testSelectMsdsComponentByIdNotFound() {
        // Given
        Long id = 999L;
        when(msdsComponentMapper.selectMsdsComponentById(id)).thenReturn(null);
        
        // When
        MsdsComponent result = msdsComponentService.selectMsdsComponentById(id);
        
        // Then
        assertNull(result);
        verify(msdsComponentMapper, times(1)).selectMsdsComponentById(id);
    }
    
    @Test
    void testSelectMsdsComponentList() {
        // Given
        MsdsComponent queryParam = new MsdsComponent();
        queryParam.setMsdsId(1L);
        List<MsdsComponent> expectedList = Arrays.asList(testMsdsComponent);
        when(msdsComponentMapper.selectMsdsComponentList(queryParam)).thenReturn(expectedList);
        
        // When
        List<MsdsComponent> result = msdsComponentService.selectMsdsComponentList(queryParam);
        
        // Then
        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals(testMsdsComponent.getMsdsId(), result.get(0).getMsdsId());
        verify(msdsComponentMapper, times(1)).selectMsdsComponentList(queryParam);
    }
    
    @Test
    void testSelectMsdsComponentByMsdsId() {
        // Given
        Long msdsId = 1L;
        List<MsdsComponent> expectedList = Arrays.asList(testMsdsComponent);
        when(msdsComponentMapper.selectMsdsComponentByMsdsId(msdsId)).thenReturn(expectedList);
        
        // When
        List<MsdsComponent> result = msdsComponentService.selectMsdsComponentByMsdsId(msdsId);
        
        // Then
        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals(msdsId, result.get(0).getMsdsId());
        verify(msdsComponentMapper, times(1)).selectMsdsComponentByMsdsId(msdsId);
    }
    
    @Test
    void testInsertMsdsComponent() {
        // Given
        when(msdsComponentMapper.insertMsdsComponent(testMsdsComponent)).thenReturn(1);
        
        // When
        int result = msdsComponentService.insertMsdsComponent(testMsdsComponent);
        
        // Then
        assertEquals(1, result);
        verify(msdsComponentMapper, times(1)).insertMsdsComponent(testMsdsComponent);
    }
    
    @Test
    void testUpdateMsdsComponent() {
        // Given
        when(msdsComponentMapper.updateMsdsComponent(testMsdsComponent)).thenReturn(1);
        
        // When
        int result = msdsComponentService.updateMsdsComponent(testMsdsComponent);
        
        // Then
        assertEquals(1, result);
        verify(msdsComponentMapper, times(1)).updateMsdsComponent(testMsdsComponent);
    }
    
    @Test
    void testDeleteMsdsComponentByIds() {
        // Given
        Long[] ids = {1L, 2L};
        when(msdsComponentMapper.deleteMsdsComponentByIds(ids)).thenReturn(2);
        
        // When
        int result = msdsComponentService.deleteMsdsComponentByIds(ids);
        
        // Then
        assertEquals(2, result);
        verify(msdsComponentMapper, times(1)).deleteMsdsComponentByIds(ids);
    }
    
    @Test
    void testDeleteMsdsComponentById() {
        // Given
        Long id = 1L;
        when(msdsComponentMapper.deleteMsdsComponentById(id)).thenReturn(1);
        
        // When
        int result = msdsComponentService.deleteMsdsComponentById(id);
        
        // Then
        assertEquals(1, result);
        verify(msdsComponentMapper, times(1)).deleteMsdsComponentById(id);
    }
    
    @Test
    void testDeleteMsdsComponentByMsdsId() {
        // Given
        Long msdsId = 1L;
        when(msdsComponentMapper.deleteMsdsComponentByMsdsId(msdsId)).thenReturn(1);
        
        // When
        int result = msdsComponentService.deleteMsdsComponentByMsdsId(msdsId);
        
        // Then
        assertEquals(1, result);
        verify(msdsComponentMapper, times(1)).deleteMsdsComponentByMsdsId(msdsId);
    }
    

    

    

    

    

    

    

    

}