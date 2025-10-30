package com.ruoyi.system.service.impl;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import java.util.*;
import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.math.BigDecimal;
import java.util.Date;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.mock.web.MockMultipartFile;
import org.mockito.ArgumentCaptor;
import java.nio.charset.StandardCharsets;

import com.ruoyi.system.domain.*;
import com.ruoyi.system.mapper.*;
import com.ruoyi.system.service.IMsdsExportService;

/**
 * MSDS主信息服务层单元测试
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
@ExtendWith(MockitoExtension.class)
class MsdsMainServiceImplTest {

    @Mock
    private MsdsMainMapper msdsMainMapper;
    
    @Mock
    private MsdsHazardMapper msdsHazardMapper;
    
    @Mock
    private MsdsComponentMapper msdsComponentMapper;
    
    @Mock
    private MsdsFirstAidMapper msdsFirstAidMapper;
    
    @Mock
    private MsdsFireFightingMapper msdsFireFightingMapper;
    
    @Mock
    private MsdsLeakResponseMapper msdsLeakResponseMapper;
    
    @Mock
    private MsdsHandlingStorageMapper msdsHandlingStorageMapper;
    
    @Mock
    private MsdsExposureControlMapper msdsExposureControlMapper;
    
    @Mock
    private MsdsPhysicalChemicalMapper msdsPhysicalChemicalMapper;
    
    @Mock
    private MsdsStabilityReactivityMapper msdsStabilityReactivityMapper;
    
    @Mock
    private MsdsToxicologicalMapper msdsToxicologicalMapper;
    
    @Mock
    private MsdsEcologicalMapper msdsEcologicalMapper;
    
    @Mock
    private MsdsDisposalMapper msdsDisposalMapper;
    
    @Mock
    private MsdsTransportationMapper msdsTransportationMapper;
    
    @Mock
    private MsdsRegulatoryMapper msdsRegulatoryMapper;
    
    @Mock
    private MsdsOtherInfoMapper msdsOtherInfoMapper;
    
    @Mock
    private IMsdsExportService msdsExportService;
    
    @InjectMocks
    private MsdsMainServiceImpl msdsMainService;
    
    private MsdsMain testMsdsMain;
    
    @BeforeEach
    void setUp() {
        testMsdsMain = new MsdsMain();
        testMsdsMain.setId(1L);
        testMsdsMain.setProductName("测试化学品");
        testMsdsMain.setProductEnglishName("Test Chemical");
        testMsdsMain.setCasNumber("123-45-6");
        testMsdsMain.setCompanyName("测试公司");
        testMsdsMain.setCompanyAddress("测试地址");
        testMsdsMain.setContactPhone("123-456-7890");
        testMsdsMain.setEmail("test@example.com");
        testMsdsMain.setEmergencyPhone("911");
        testMsdsMain.setVersion("1.0");
        testMsdsMain.setMsdsCode("MSDS001");
        testMsdsMain.setCreateTime(new Date());
    }
    
    @Test
    void testSelectMsdsMainById() {
        // Given
        Long id = 1L;
        when(msdsMainMapper.selectMsdsMainById(id)).thenReturn(testMsdsMain);
        
        // When
        MsdsMain result = msdsMainService.selectMsdsMainById(id);
        
        // Then
        assertNotNull(result);
        assertEquals(testMsdsMain.getId(), result.getId());
        assertEquals(testMsdsMain.getProductName(), result.getProductName());
        verify(msdsMainMapper, times(1)).selectMsdsMainById(id);
    }
    
    @Test
    void testSelectMsdsMainByIdNotFound() {
        // Given
        Long id = 999L;
        when(msdsMainMapper.selectMsdsMainById(id)).thenReturn(null);
        
        // When
        MsdsMain result = msdsMainService.selectMsdsMainById(id);
        
        // Then
        assertNull(result);
        verify(msdsMainMapper, times(1)).selectMsdsMainById(id);
    }
    
    @Test
    void testSelectMsdsMainList() {
        // Given
        MsdsMain queryParam = new MsdsMain();
        queryParam.setProductName("测试");
        List<MsdsMain> expectedList = Arrays.asList(testMsdsMain);
        when(msdsMainMapper.selectMsdsMainList(queryParam)).thenReturn(expectedList);
        
        // When
        List<MsdsMain> result = msdsMainService.selectMsdsMainList(queryParam);
        
        // Then
        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals(testMsdsMain.getProductName(), result.get(0).getProductName());
        verify(msdsMainMapper, times(1)).selectMsdsMainList(queryParam);
    }
    
    @Test
    void testSelectMsdsMainByProductName() {
        // Given
        String productName = "测试化学品";
        when(msdsMainMapper.selectMsdsMainByProductName(productName)).thenReturn(testMsdsMain);
        
        // When
        MsdsMain result = msdsMainService.selectMsdsMainByProductName(productName);
        
        // Then
        assertNotNull(result);
        assertEquals(productName, result.getProductName());
        verify(msdsMainMapper, times(1)).selectMsdsMainByProductName(productName);
    }
    
    @Test
    void testInsertMsdsMain() {
        // Given
        when(msdsMainMapper.insertMsdsMain(testMsdsMain)).thenReturn(1);
        
        // When
        int result = msdsMainService.insertMsdsMain(testMsdsMain);
        
        // Then
        assertEquals(1, result);
        assertNotNull(testMsdsMain.getMsdsCode());
        verify(msdsMainMapper, times(1)).insertMsdsMain(testMsdsMain);
    }
    
    @Test
    void testUpdateMsdsMain() {
        // Given
        when(msdsMainMapper.updateMsdsMain(testMsdsMain)).thenReturn(1);
        
        // When
        int result = msdsMainService.updateMsdsMain(testMsdsMain);
        
        // Then
        assertEquals(1, result);
        verify(msdsMainMapper, times(1)).updateMsdsMain(testMsdsMain);
    }
    
    @Test
    void testDeleteMsdsMainByIds() {
        // Given
        Long[] ids = {1L, 2L};
        when(msdsMainMapper.deleteMsdsMainByIds(ids)).thenReturn(2);
        
        // When
        int result = msdsMainService.deleteMsdsMainByIds(ids);
        
        // Then
        assertEquals(2, result);
        verify(msdsMainMapper, times(1)).deleteMsdsMainByIds(ids);
    }
    
    @Test
    void testDeleteMsdsMainById() {
        // Given
        Long id = 1L;
        when(msdsMainMapper.deleteMsdsMainById(id)).thenReturn(1);
        
        // When
        int result = msdsMainService.deleteMsdsMainById(id);
        
        // Then
        assertEquals(1, result);
        verify(msdsMainMapper, times(1)).deleteMsdsMainById(id);
    }
    
    @Test
    void testSelectMsdsMainByCompany() {
        // Given
        String companyName = "测试公司";
        List<MsdsMain> expectedList = Arrays.asList(testMsdsMain);
        when(msdsMainMapper.selectMsdsMainByCompany(companyName)).thenReturn(expectedList);
        
        // When
        List<MsdsMain> result = msdsMainService.selectMsdsMainByCompany(companyName);
        
        // Then
        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals(companyName, result.get(0).getCompanyName());
        verify(msdsMainMapper, times(1)).selectMsdsMainByCompany(companyName);
    }
    
    @Test
    void testCountActiveMsds() {
        // Given
        when(msdsMainMapper.countActiveMsds()).thenReturn(10);
        
        // When
        int result = msdsMainService.countActiveMsds();
        
        // Then
        assertEquals(10, result);
        verify(msdsMainMapper, times(1)).countActiveMsds();
    }
    
    @Test
    void testCheckProductNameUniqueForNew() {
        // Given
        MsdsMain newMsds = new MsdsMain();
        newMsds.setProductName("新化学品");
        when(msdsMainMapper.checkProductNameUnique("新化学品")).thenReturn(null);
        
        // When
        boolean result = msdsMainService.checkProductNameUnique(newMsds);
        
        // Then
        assertTrue(result);
        verify(msdsMainMapper, times(1)).checkProductNameUnique("新化学品");
    }
    
    @Test
    void testCheckProductNameUniqueForExisting() {
        // Given
        MsdsMain existingMsds = new MsdsMain();
        existingMsds.setId(1L);
        existingMsds.setProductName("测试化学品");
        
        MsdsMain foundMsds = new MsdsMain();
        foundMsds.setId(1L);
        foundMsds.setProductName("测试化学品");
        
        when(msdsMainMapper.checkProductNameUnique("测试化学品")).thenReturn(foundMsds);
        
        // When
        boolean result = msdsMainService.checkProductNameUnique(existingMsds);
        
        // Then
        assertTrue(result);
        verify(msdsMainMapper, times(1)).checkProductNameUnique("测试化学品");
    }
    
    @Test
    void testCheckProductNameUniqueForDuplicate() {
        // Given
        MsdsMain newMsds = new MsdsMain();
        newMsds.setProductName("测试化学品");
        
        MsdsMain foundMsds = new MsdsMain();
        foundMsds.setId(2L);
        foundMsds.setProductName("测试化学品");
        
        when(msdsMainMapper.checkProductNameUnique("测试化学品")).thenReturn(foundMsds);
        
        // When
        boolean result = msdsMainService.checkProductNameUnique(newMsds);
        
        // Then
        assertFalse(result);
        verify(msdsMainMapper, times(1)).checkProductNameUnique("测试化学品");
    }
    
    @Test
    void testChangeStatus() {
        // Given
        when(msdsMainMapper.updateMsdsMain(testMsdsMain)).thenReturn(1);
        
        // When
        int result = msdsMainService.changeStatus(testMsdsMain);
        
        // Then
        assertEquals(1, result);
        verify(msdsMainMapper, times(1)).updateMsdsMain(testMsdsMain);
    }
    
    @Test
    void testGetMsdsStatistics() {
        // Given
        List<MsdsMain> mockMsdsList = new ArrayList<>();
        
        // 创建测试数据
        MsdsMain activeMsds1 = new MsdsMain();
        activeMsds1.setIsActive(1);
        activeMsds1.setCompanyName("Company A");
        
        MsdsMain activeMsds2 = new MsdsMain();
        activeMsds2.setIsActive(1);
        activeMsds2.setCompanyName("Company B");
        
        MsdsMain inactiveMsds = new MsdsMain();
        inactiveMsds.setIsActive(0);
        inactiveMsds.setCompanyName("Company A");
        
        mockMsdsList.add(activeMsds1);
        mockMsdsList.add(activeMsds2);
        mockMsdsList.add(inactiveMsds);
        
        when(msdsMainMapper.selectMsdsMainList(any(MsdsMain.class))).thenReturn(mockMsdsList);
        
        // When
        Map<String, Object> result = msdsMainService.getMsdsStatistics();
        
        // Then
        assertNotNull(result);
        assertEquals(3, result.get("totalCount"));
        assertEquals(2L, result.get("activeCount"));
        assertEquals(1L, result.get("inactiveCount"));
        assertNotNull(result.get("companyStatistics"));
        
        @SuppressWarnings("unchecked")
        Map<String, Long> companyStats = (Map<String, Long>) result.get("companyStatistics");
        assertEquals(2L, companyStats.get("Company A"));
        assertEquals(1L, companyStats.get("Company B"));
        
        verify(msdsMainMapper, times(1)).selectMsdsMainList(any(MsdsMain.class));
    }
    
    @Test
    void testGetUsageStatistics() {
        // Given
        int days = 30;
        List<MsdsMain> mockMsdsList = new ArrayList<>();
        
        // 创建一些测试数据
        MsdsMain recentMsds1 = new MsdsMain();
        recentMsds1.setCreateTime(new Date(System.currentTimeMillis() - 10 * 24 * 60 * 60 * 1000L)); // 10天前
        
        MsdsMain recentMsds2 = new MsdsMain();
        recentMsds2.setCreateTime(new Date(System.currentTimeMillis() - 20 * 24 * 60 * 60 * 1000L)); // 20天前
        
        MsdsMain oldMsds = new MsdsMain();
        oldMsds.setCreateTime(new Date(System.currentTimeMillis() - 40 * 24 * 60 * 60 * 1000L)); // 40天前
        
        mockMsdsList.add(recentMsds1);
        mockMsdsList.add(recentMsds2);
        mockMsdsList.add(oldMsds);
        
        when(msdsMainMapper.selectMsdsMainList(any(MsdsMain.class))).thenReturn(mockMsdsList);
        
        // When
        Map<String, Object> result = msdsMainService.getUsageStatistics(days);
        
        // Then
        assertNotNull(result);
        assertEquals(2, result.get("recentCount")); // 应该有2个最近30天内创建的记录
        assertEquals(days, result.get("days"));
        assertNotNull(result.get("startDate"));
        
        verify(msdsMainMapper, times(1)).selectMsdsMainList(any(MsdsMain.class));
    }
    
    @Test
    void testGetRiskDistribution() {
        // When
        Map<String, Object> result = msdsMainService.getRiskDistribution();
        
        // Then
        assertNotNull(result);
        assertTrue(result.containsKey("high"));
        assertTrue(result.containsKey("medium"));
        assertTrue(result.containsKey("low"));
        assertEquals(15, result.get("high"));
        assertEquals(45, result.get("medium"));
        assertEquals(40, result.get("low"));
    }
    
    @Test
    void testImportMsdsCsv_AliasHeaderCandidates() throws Exception {
        // 准备候选列名与对应的别名值（覆盖中文顿号、分号、斜杠、空格、逗号等场景）
        String[][] cases = new String[][]{
            {"化学品别名", "别名A"},
            {"中文别名", "别名甲、别名乙"},
            {"别名", "含/斜杠的别名"},
            {"Alias", "Alias-1 Alias_2"},
            {"别 名", "空格列名别名"},
            {"中文别名(化学品)", "包含；分号的别名"},
            {"中文别名", "含,逗号的别名"}
        };

        for (String[] c : cases) {
            String aliasHeader = c[0];
            String aliasValue = c[1];

            // 构建CSV内容（若别名包含逗号，需要用引号包裹）
            String headerLine = String.format("化学品中文名,CAS号,MSDS编号,%s", aliasHeader);
            String aliasField = aliasValue.contains(",") ? ("\"" + aliasValue + "\"") : aliasValue;
            String dataLine = String.format("乙醇,64-17-5,MSDS001,%s", aliasField);
            String csv = headerLine + "\n" + dataLine;

            MockMultipartFile file = new MockMultipartFile(
                "file", "test.csv", "text/csv", csv.getBytes(StandardCharsets.UTF_8)
            );

            // 重置并打桩Mock
            reset(msdsMainMapper);
            when(msdsMainMapper.selectMsdsMainByProductName("乙醇")).thenReturn(null);
            ArgumentCaptor<MsdsMain> captor = ArgumentCaptor.forClass(MsdsMain.class);
            when(msdsMainMapper.insertMsdsMain(captor.capture())).thenAnswer(invocation -> {
                MsdsMain arg = invocation.getArgument(0);
                arg.setId(100L); // 模拟生成ID，供后续子表保存使用
                return 1;
            });

            // 执行导入
            Map<String, Object> result = msdsMainService.importMsdsCsv(file, false, "tester");

            // 断言导入成功
            assertNotNull(result);
            assertTrue((Boolean) result.get("success"));
            assertEquals(1, result.get("successCount"));
            assertEquals(0, result.get("failureCount"));
            assertEquals(0, result.get("duplicateCount"));

            // 校验插入的MsdsMain对象中productAlias准确映射
            MsdsMain inserted = captor.getValue();
            assertNotNull(inserted);
            assertEquals("乙醇", inserted.getProductName());
            assertEquals("64-17-5", inserted.getCasNumber());
            assertEquals(aliasValue, inserted.getProductAlias());
        }
    }
}