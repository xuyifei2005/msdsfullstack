package com.ruoyi.system.service.impl;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import java.lang.reflect.Method;
import java.util.Map;

import com.ruoyi.system.mapper.*;
import com.ruoyi.system.domain.MsdsMain;

/**
 * MSDS主服务实现类测试
 * 重点测试中文别名导入功能的修复
 * 使用Mock进行单元测试，不依赖Spring容器
 */
public class MsdsMainServiceImplTest {

    @InjectMocks
    private MsdsMainServiceImpl msdsMainService;

    @Mock
    private MsdsMainMapper msdsMainMapper;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void testFindExistingMsdsForImport_prefersCas() throws Exception {
        Method method = MsdsMainServiceImpl.class.getDeclaredMethod("findExistingMsdsForImport", MsdsMain.class);
        method.setAccessible(true);

        MsdsMain input = new MsdsMain();
        input.setCasNumber("71-43-2");
        input.setMsdsCode("MSDS-0001");
        input.setProductName("苯");

        MsdsMain expected = new MsdsMain();
        expected.setId(1L);

        when(msdsMainMapper.selectMsdsMainByCasAndProductName(input)).thenReturn(expected);
        when(msdsMainMapper.selectMsdsMainByCasNumber("71-43-2")).thenReturn(expected);

        MsdsMain actual = (MsdsMain) method.invoke(msdsMainService, input);
        assertSame(expected, actual);
        verify(msdsMainMapper, times(1)).selectMsdsMainByCasAndProductName(input);
        verify(msdsMainMapper, never()).selectMsdsMainByCasNumber(anyString());
        verify(msdsMainMapper, never()).selectMsdsMainByMsdsCode(anyString());
        verify(msdsMainMapper, never()).selectMsdsMainByProductName(anyString());
    }

    @Test
    void testFindExistingMsdsForImport_usesMsdsCodeWhenNoCas() throws Exception {
        Method method = MsdsMainServiceImpl.class.getDeclaredMethod("findExistingMsdsForImport", MsdsMain.class);
        method.setAccessible(true);

        MsdsMain input = new MsdsMain();
        input.setMsdsCode("MSDS-0002");
        input.setProductName("甲苯");

        MsdsMain expected = new MsdsMain();
        expected.setId(2L);

        when(msdsMainMapper.selectMsdsMainByMsdsCode("MSDS-0002")).thenReturn(expected);

        MsdsMain actual = (MsdsMain) method.invoke(msdsMainService, input);
        assertSame(expected, actual);
        verify(msdsMainMapper, never()).selectMsdsMainByCasNumber(anyString());
        verify(msdsMainMapper, times(1)).selectMsdsMainByMsdsCode("MSDS-0002");
        verify(msdsMainMapper, never()).selectMsdsMainByProductName(anyString());
    }

    /**
     * 测试文件名信息提取功能
     * 验证修复后的字段映射是否正确
     */
    @Test
    public void testExtractInfoFromFileName() throws Exception {
        // 使用反射调用私有方法
        Method method = MsdsMainServiceImpl.class.getDeclaredMethod("extractInfoFromFileName", String.class);
        method.setAccessible(true);

        // 测试用例1：标准格式 - 逗号分隔
        String fileName1 = "苯,Benzene,71-43-2.txt";
        Map<String, String> result1 = (Map<String, String>) method.invoke(msdsMainService, fileName1);
        
        assertNotNull(result1, "结果不应为null");
        assertEquals("苯", result1.get("chineseName"), "中文名称提取错误");
        assertEquals("Benzene", result1.get("englishName"), "英文名称提取错误");
        assertEquals("71-43-2", result1.get("casNumber"), "CAS号提取错误");

        // 测试用例2：标准格式 - 顿号分隔
        String fileName2 = "甲苯、Toluene、108-88-3.pdf";
        Map<String, String> result2 = (Map<String, String>) method.invoke(msdsMainService, fileName2);
        
        assertNotNull(result2, "结果不应为null");
        assertEquals("甲苯", result2.get("chineseName"), "中文名称提取错误");
        assertEquals("Toluene", result2.get("englishName"), "英文名称提取错误");
        assertEquals("108-88-3", result2.get("casNumber"), "CAS号提取错误");

        // 测试用例3：包含别名的复杂格式
        String fileName3 = "二甲苯(邻二甲苯),Xylene,95-47-6.doc";
        Map<String, String> result3 = (Map<String, String>) method.invoke(msdsMainService, fileName3);
        
        assertNotNull(result3, "结果不应为null");
        assertEquals("二甲苯(邻二甲苯)", result3.get("chineseName"), "包含别名的中文名称提取错误");
        assertEquals("Xylene", result3.get("englishName"), "英文名称提取错误");
        assertEquals("95-47-6", result3.get("casNumber"), "CAS号提取错误");
        
        // 测试用例4：只有中文名
        String fileName4 = "乙醇.doc";
        Map<String, String> result4 = (Map<String, String>) method.invoke(msdsMainService, fileName4);
        
        assertNotNull(result4, "结果不应为null");
        assertEquals("乙醇", result4.get("chineseName"), "中文名称提取错误");
        assertNull(result4.get("englishName"), "英文名称应为空");
        assertNull(result4.get("casNumber"), "CAS号应为空");
    }

    /**
     * 测试别名提取功能
     * 验证增强后的正则模式是否能正确提取中文别名
     */
    @Test
    void testExtractProductAlias() throws Exception {
        // 使用反射调用私有方法
        Method method = MsdsMainServiceImpl.class.getDeclaredMethod("extractProductAlias", String.class);
        method.setAccessible(true);

        // 测试用例1：商品名格式
        String content1 = "商品名：工业苯、纯苯";
        String result1 = (String) method.invoke(msdsMainService, content1);
        assertTrue(result1.contains("工业苯") || result1.contains("纯苯"), "商品名格式别名提取失败");

        // 测试用例2：贸易名格式
        String content2 = "贸易名称：分析级甲苯";
        String result2 = (String) method.invoke(msdsMainService, content2);
        assertTrue(result2.contains("分析级甲苯"), "贸易名格式别名提取失败");

        // 测试用例3：产品别名格式
        String content3 = "产品别名：邻二甲苯、1,2-二甲基苯";
        String result3 = (String) method.invoke(msdsMainService, content3);
        assertTrue(result3.contains("邻二甲苯") || result3.contains("1,2-二甲基苯"), "产品别名格式提取失败");

        // 测试用例4：其他名称格式
        String content4 = "其他名称：苯酚、石炭酸";
        String result4 = (String) method.invoke(msdsMainService, content4);
        assertTrue(result4.contains("苯酚") || result4.contains("石炭酸"), "其他名称格式提取失败");

        // 测试用例5：中文名称后括号内容
        String content5 = "中文名称：乙醇（无水乙醇、酒精）";
        String result5 = (String) method.invoke(msdsMainService, content5);
        assertTrue(result5.contains("无水乙醇") || result5.contains("酒精"), "括号内别名提取失败");
    }

    /**
     * 测试别名处理功能
     * 验证别名处理逻辑是否正确分离CAS号
     */
    @Test
    public void testProcessProductAlias() throws Exception {
        // 使用反射调用私有方法
        Method method = MsdsMainServiceImpl.class.getDeclaredMethod("processProductAlias", String.class);
        method.setAccessible(true);
        
        // 测试包含CAS号的别名处理
        String aliasWithCas = "苯;Benzene;71-43-2;C6H6;芳香烃";
        String result = (String) method.invoke(msdsMainService, aliasWithCas);
        
        // 验证CAS号被过滤掉，中文别名被保留
        assertNotNull(result, "处理结果不应为null");
        assertTrue(result.contains("苯"), "应保留中文别名");
        assertTrue(result.contains("Benzene"), "应保留英文别名");
        assertFalse(result.contains("71-43-2"), "应过滤掉CAS号");
        assertTrue(result.contains("C6H6"), "应保留分子式");
        assertTrue(result.contains("芳香烃"), "应保留中文描述");
        
        // 测试纯CAS号列表
        String pureCasList = "71-43-2;108-88-3;7732-18-5";
        String result2 = (String) method.invoke(msdsMainService, pureCasList);
        assertTrue(result2 == null || result2.trim().isEmpty(), "纯CAS号列表应返回空结果");
        
        // 测试混合内容
        String mixedContent = "甲苯;Toluene;108-88-3;甲基苯;methylbenzene";
        String result3 = (String) method.invoke(msdsMainService, mixedContent);
        assertTrue(result3.contains("甲苯"), "应保留中文名称");
        assertTrue(result3.contains("Toluene"), "应保留英文名称");
        assertFalse(result3.contains("108-88-3"), "应过滤掉CAS号");
        assertTrue(result3.contains("甲基苯"), "应保留中文别名");
        assertTrue(result3.contains("methylbenzene"), "应保留英文别名");
    }

    /**
     * 测试CAS号验证功能
     * 确保CAS号验证逻辑正确
     */
    @Test
    void testIsValidCasNumber() throws Exception {
        // 使用反射调用私有方法
        Method method = MsdsMainServiceImpl.class.getDeclaredMethod("isValidCasNumber", String.class);
        method.setAccessible(true);

        // 测试有效的CAS号
        assertTrue((Boolean) method.invoke(msdsMainService, "71-43-2"), "苯的CAS号应该有效");
        assertTrue((Boolean) method.invoke(msdsMainService, "108-88-3"), "甲苯的CAS号应该有效");
        assertTrue((Boolean) method.invoke(msdsMainService, "95-47-6"), "邻二甲苯的CAS号应该有效");
        assertTrue((Boolean) method.invoke(msdsMainService, "108-95-2"), "苯酚的CAS号应该有效");

        // 测试无效的CAS号
        assertFalse((Boolean) method.invoke(msdsMainService, "71-43-3"), "错误校验位的CAS号应该无效");
        assertFalse((Boolean) method.invoke(msdsMainService, "abc-def-g"), "非数字CAS号应该无效");
        assertFalse((Boolean) method.invoke(msdsMainService, "123"), "格式错误的CAS号应该无效");
        assertFalse((Boolean) method.invoke(msdsMainService, ""), "空CAS号应该无效");
        assertFalse((Boolean) method.invoke(msdsMainService, (String) null), "null CAS号应该无效");
    }

    /**
     * 测试轻量级化学品名称清理功能
     * 验证别名清理逻辑是否保留重要信息
     */
    @Test
    void testCleanChemicalNameLightweight() throws Exception {
        // 使用反射调用私有方法
        Method method = MsdsMainServiceImpl.class.getDeclaredMethod("cleanChemicalNameLightweight", String.class);
        method.setAccessible(true);

        // 测试用例1：保留工业级等重要信息
        String name1 = "苯（工业级）";
        String result1 = (String) method.invoke(msdsMainService, name1);
        assertEquals("苯（工业级）", result1, "应保留工业级标识");

        // 测试用例2：保留分析纯等重要信息
        String name2 = "甲苯（分析纯）";
        String result2 = (String) method.invoke(msdsMainService, name2);
        assertEquals("甲苯（分析纯）", result2, "应保留分析纯标识");

        // 测试用例3：移除纯度百分比
        String name3 = "乙醇（99.9%）";
        String result3 = (String) method.invoke(msdsMainService, name3);
        assertEquals("乙醇", result3, "应移除纯度百分比");

        // 测试用例4：移除技术规格
        String name4 = "丙酮（技术级）";
        String result4 = (String) method.invoke(msdsMainService, name4);
        assertEquals("丙酮", result4, "应移除技术级标识");

        // 测试用例5：保留化学品名称中的有效符号
        String name5 = "1,2-二甲基苯";
        String result5 = (String) method.invoke(msdsMainService, name5);
        assertEquals("1,2-二甲基苯", result5, "应保留化学品名称中的有效符号");
    }

    /**
     * 集成测试：完整的文件名到别名处理流程
     */
    @Test
    void testCompleteAliasProcessingFlow() throws Exception {
        // 模拟完整的处理流程
        String fileName = "二甲苯(邻二甲苯),Xylene,95-47-6.txt";
        
        // 1. 提取文件名信息
        Method extractMethod = MsdsMainServiceImpl.class.getDeclaredMethod("extractInfoFromFileName", String.class);
        extractMethod.setAccessible(true);
        Map<String, String> fileInfo = (Map<String, String>) extractMethod.invoke(msdsMainService, fileName);
        
        // 2. 验证提取结果
        assertEquals("二甲苯(邻二甲苯)", fileInfo.get("productName"));
        assertEquals("Xylene", fileInfo.get("productEnglishName"));
        assertEquals("95-47-6", fileInfo.get("casNumber"));
        assertNull(fileInfo.get("productAlias"), "修复后不应将CAS号存入别名字段");
        
        // 3. 模拟从文档内容提取别名
        String documentContent = "产品别名：邻二甲苯、1,2-二甲基苯、邻甲基甲苯";
        Method aliasMethod = MsdsMainServiceImpl.class.getDeclaredMethod("extractProductAlias", String.class);
        aliasMethod.setAccessible(true);
        String extractedAlias = (String) aliasMethod.invoke(msdsMainService, documentContent);
        
        // 4. 处理别名
        Method processMethod = MsdsMainServiceImpl.class.getDeclaredMethod("processProductAlias", String.class);
        processMethod.setAccessible(true);
        String processedAlias = (String) processMethod.invoke(msdsMainService, extractedAlias);
        
        // 5. 验证最终结果
        assertNotNull(processedAlias, "处理后的别名不应为空");
        assertTrue(processedAlias.contains("邻二甲苯") || 
                  processedAlias.contains("1,2-二甲基苯") || 
                  processedAlias.contains("邻甲基甲苯"), 
                  "应包含提取的中文别名");
        assertFalse(processedAlias.contains("95-47-6"), "不应包含CAS号");
    }
}
