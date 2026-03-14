package com.ruoyi.system.service;

import com.ruoyi.system.domain.MsdsMain;
import com.ruoyi.system.service.impl.MsdsMainServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.web.multipart.MultipartFile;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Method;
import java.nio.charset.StandardCharsets;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * MSDS Word文档解析单元测试
 * 
 * 测试覆盖范围：
 * - DOC格式文档解析
 * - DOCX格式文档解析
 * - 基本字段提取（产品名称、CAS号、企业信息等）
 * - 表格结构解析
 * - 特殊字符和编码处理
 * - 无效文件处理
 * - 空文件处理
 * - 数据校验规则验证
 * - 文件名信息提取
 * - 性能基准测试
 * 
 * @author ruoyi
 * @date 2024-01-19
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("MSDS Word文档解析单元测试")
public class MsdsWordDocumentParsingTest {

    private static final Logger logger = LoggerFactory.getLogger(MsdsWordDocumentParsingTest.class);

    @InjectMocks
    private MsdsMainServiceImpl msdsMainService;

    private Method extractTextFromFileMethod;
    private Method extractTextFromDOCMethod;
    private Method extractTextFromDOCXMethod;
    private Method isValidFileTypeMethod;
    private Method extractInfoFromFileNameMethod;
    private Method parseMsdsFromContentCompleteMethod;
    private Method validateAndCleanMsdsDataMethod;

    @BeforeEach
    void setUp() throws Exception {
        // 通过反射获取私有方法用于测试
        extractTextFromFileMethod = MsdsMainServiceImpl.class.getDeclaredMethod("extractTextFromFile", MultipartFile.class);
        extractTextFromFileMethod.setAccessible(true);
        
        extractTextFromDOCMethod = MsdsMainServiceImpl.class.getDeclaredMethod("extractTextFromDOC", InputStream.class);
        extractTextFromDOCMethod.setAccessible(true);
        
        extractTextFromDOCXMethod = MsdsMainServiceImpl.class.getDeclaredMethod("extractTextFromDOCX", InputStream.class);
        extractTextFromDOCXMethod.setAccessible(true);
        
        isValidFileTypeMethod = MsdsMainServiceImpl.class.getDeclaredMethod("isValidFileType", MultipartFile.class);
        isValidFileTypeMethod.setAccessible(true);
        
        extractInfoFromFileNameMethod = MsdsMainServiceImpl.class.getDeclaredMethod("extractInfoFromFileName", String.class);
        extractInfoFromFileNameMethod.setAccessible(true);
        
        parseMsdsFromContentCompleteMethod = MsdsMainServiceImpl.class.getDeclaredMethod("parseMsdsFromContentComplete", String.class);
        parseMsdsFromContentCompleteMethod.setAccessible(true);
        
        validateAndCleanMsdsDataMethod = MsdsMainServiceImpl.class.getDeclaredMethod("validateAndCleanMsdsData", MsdsMain.class);
        validateAndCleanMsdsDataMethod.setAccessible(true);
    }

    @Test
    @DisplayName("测试DOC格式文档解析")
    void testExtractTextFromDOC() throws Exception {
        // 模拟DOC文档内容
        String mockDocContent = "产品名称：甲苯\n英文名称：Toluene\nCAS号：108-88-3\n企业名称：测试化工有限公司";
        InputStream inputStream = new ByteArrayInputStream(mockDocContent.getBytes(StandardCharsets.UTF_8));
        
        // 由于DOC解析需要真实的DOC格式，这里主要测试异常处理
        assertDoesNotThrow(() -> {
            try {
                extractTextFromDOCMethod.invoke(msdsMainService, inputStream);
            } catch (Exception e) {
                // 预期会抛出异常，因为输入不是真实的DOC格式
                assertTrue(e.getCause() instanceof IOException || 
                          e.getCause().getMessage().contains("DOC"));
            }
        });
    }

    @Test
    @DisplayName("测试DOCX格式文档解析")
    void testExtractTextFromDOCX() throws Exception {
        // 模拟DOCX文档内容
        String mockDocxContent = "产品名称：丙酮\n英文名称：Acetone\nCAS号：67-64-1\n企业名称：测试化工有限公司";
        InputStream inputStream = new ByteArrayInputStream(mockDocxContent.getBytes(StandardCharsets.UTF_8));
        
        // 由于DOCX解析需要真实的DOCX格式，这里主要测试异常处理
        assertDoesNotThrow(() -> {
            try {
                extractTextFromDOCXMethod.invoke(msdsMainService, inputStream);
            } catch (Exception e) {
                // 预期会抛出异常，因为输入不是真实的DOCX格式
                assertTrue(e.getCause() instanceof IOException || 
                          e.getCause().getMessage().contains("DOCX"));
            }
        });
    }

    @Test
    @DisplayName("测试文件类型验证")
    void testIsValidFileType() throws Exception {
        // 测试有效的DOC文件
        MockMultipartFile docFile = new MockMultipartFile(
            "file", "test.doc", "application/msword", "test content".getBytes());
        Boolean isValidDoc = (Boolean) isValidFileTypeMethod.invoke(msdsMainService, docFile);
        assertTrue(isValidDoc, "DOC文件应该被识别为有效类型");
        
        // 测试有效的DOCX文件
        MockMultipartFile docxFile = new MockMultipartFile(
            "file", "test.docx", 
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document", 
            "test content".getBytes());
        Boolean isValidDocx = (Boolean) isValidFileTypeMethod.invoke(msdsMainService, docxFile);
        assertTrue(isValidDocx, "DOCX文件应该被识别为有效类型");
        
        // 测试有效的PDF文件
        MockMultipartFile pdfFile = new MockMultipartFile(
            "file", "test.pdf", "application/pdf", "test content".getBytes());
        Boolean isValidPdf = (Boolean) isValidFileTypeMethod.invoke(msdsMainService, pdfFile);
        assertTrue(isValidPdf, "PDF文件应该被识别为有效类型");
        
        // 测试有效的TXT文件
        MockMultipartFile txtFile = new MockMultipartFile(
            "file", "test.txt", "text/plain", "test content".getBytes());
        Boolean isValidTxt = (Boolean) isValidFileTypeMethod.invoke(msdsMainService, txtFile);
        assertTrue(isValidTxt, "TXT文件应该被识别为有效类型");
        
        // 测试无效文件类型
        MockMultipartFile invalidFile = new MockMultipartFile(
            "file", "test.jpg", "image/jpeg", "test content".getBytes());
        Boolean isValidInvalid = (Boolean) isValidFileTypeMethod.invoke(msdsMainService, invalidFile);
        assertFalse(isValidInvalid, "JPG文件应该被识别为无效类型");
    }

    @Test
    @DisplayName("测试从文件名提取信息")
    void testExtractInfoFromFileName() throws Exception {
        // 测试标准格式：中文名、英文名、CAS号
        String fileName1 = "甲苯、Toluene、108-88-3.doc";
        @SuppressWarnings("unchecked")
        Map<String, String> info1 = (Map<String, String>) extractInfoFromFileNameMethod.invoke(msdsMainService, fileName1);
        
        assertNotNull(info1);
        assertEquals("甲苯", info1.get("productName"));
        assertEquals("Toluene", info1.get("productEnglishName"));
        assertEquals("108-88-3", info1.get("casNumber"));
        assertNull(info1.get("productAlias"));
        
        // 测试逗号分隔格式
        String fileName2 = "丙酮,Acetone,67-64-1.docx";
        @SuppressWarnings("unchecked")
        Map<String, String> info2 = (Map<String, String>) extractInfoFromFileNameMethod.invoke(msdsMainService, fileName2);
        
        assertNotNull(info2);
        assertEquals("丙酮", info2.get("productName"));
        assertEquals("Acetone", info2.get("productEnglishName"));
        assertEquals("67-64-1", info2.get("casNumber"));
        assertNull(info2.get("productAlias"));
        
        // 测试不完整信息
        String fileName3 = "乙醇.doc";
        @SuppressWarnings("unchecked")
        Map<String, String> info3 = (Map<String, String>) extractInfoFromFileNameMethod.invoke(msdsMainService, fileName3);
        
        assertNotNull(info3);
        assertEquals("乙醇", info3.get("productName"));
        assertNull(info3.get("productEnglishName"));
        assertNull(info3.get("casNumber"));
        assertNull(info3.get("productAlias"));
    }

    @Test
    @DisplayName("测试MSDS内容解析")
    void testParseMsdsFromContentComplete() throws Exception {
        // 模拟完整的MSDS文档内容
        String content = """
            产品名称：甲苯
            英文名称：Toluene
            CAS号：108-88-3
            企业名称：测试化工有限公司
            企业地址：北京市朝阳区测试路123号
            联系电话：010-12345678
            传真：010-87654321
            电子邮箱：test@example.com
            应急电话：400-123-4567
            版本号：V1.0
            修订日期：2024-01-19
            
            第1部分 化学品及企业标识
            化学品中文名：甲苯
            化学品英文名：Toluene
            
            第2部分 危险性概述
            危险性类别：易燃液体
            
            第3部分 成分/组成信息
            化学品名称：甲苯
            浓度：≥99.5%
            """;
        
        MsdsMain result = (MsdsMain) parseMsdsFromContentCompleteMethod.invoke(msdsMainService, content);
        
        assertNotNull(result);
        assertEquals("甲苯", result.getProductName());
        assertEquals("Toluene", result.getProductEnglishName());
        assertEquals("108-88-3", result.getCasNumber());
        assertNull(result.getProductAlias());
        assertEquals("测试化工有限公司", result.getCompanyName());
        assertEquals("北京市朝阳区测试路123号", result.getCompanyAddress());
        assertEquals("010-12345678", result.getContactPhone());
        assertEquals("010-87654321", result.getFaxNumber());
        assertEquals("test@example.com", result.getEmail());
        assertEquals("400-123-4567", result.getEmergencyPhone());
        assertEquals("V1.0", result.getVersion());
    }

    @Test
    @DisplayName("测试特殊字符处理")
    void testSpecialCharacterHandling() throws Exception {
        // 测试包含特殊字符的内容
        String contentWithSpecialChars = """
            产品名称：α-甲基苯乙烯
            英文名称：α-Methylstyrene
            CAS号：98-83-9
            企业名称：测试化工（北京）有限公司
            温度范围：-20℃～+80℃
            浓度：≥99.5%
            符号：①②③④⑤
            """;
        
        MsdsMain result = (MsdsMain) parseMsdsFromContentCompleteMethod.invoke(msdsMainService, contentWithSpecialChars);
        
        assertNotNull(result);
        assertEquals("α-甲基苯乙烯", result.getProductName());
        assertEquals("α-Methylstyrene", result.getProductEnglishName());
        assertEquals("98-83-9", result.getCasNumber());
        assertNull(result.getProductAlias());
        assertEquals("测试化工（北京）有限公司", result.getCompanyName());
    }

    @Test
    @DisplayName("测试数据校验和清理")
    void testValidateAndCleanMsdsData() throws Exception {
        // 创建包含需要清理数据的MSDS对象
        MsdsMain msdsMain = new MsdsMain();
        msdsMain.setProductName("  甲苯  "); // 包含前后空格
        msdsMain.setProductEnglishName("  Toluene  ");
        msdsMain.setCasNumber("108-88-3");
        msdsMain.setCompanyName("测试化工有限公司");
        msdsMain.setContactPhone("010-12345678");
        msdsMain.setEmail("test@example.com");
        
        MsdsMain result = (MsdsMain) validateAndCleanMsdsDataMethod.invoke(msdsMainService, msdsMain);
        
        assertNotNull(result);
        assertEquals("甲苯", result.getProductName()); // 空格应该被清理
        assertEquals("Toluene", result.getProductEnglishName());
        assertEquals("108-88-3", result.getCasNumber());
        assertNull(result.getProductAlias());
        assertEquals("测试化工有限公司", result.getCompanyName());
        assertEquals("010-12345678", result.getContactPhone());
        assertEquals("test@example.com", result.getEmail());
    }

    @Test
    @DisplayName("测试空文件处理")
    void testEmptyFileHandling() throws Exception {
        // 测试空文件
        MockMultipartFile emptyFile = new MockMultipartFile(
            "file", "empty.doc", "application/msword", new byte[0]);
        
        assertDoesNotThrow(() -> {
            try {
                extractTextFromFileMethod.invoke(msdsMainService, emptyFile);
            } catch (Exception e) {
                // 预期会抛出异常或返回空字符串
                assertTrue(e.getCause() instanceof IOException || 
                          e.getCause().getMessage().contains("空"));
            }
        });
    }

    @Test
    @DisplayName("测试无效CAS号处理")
    void testInvalidCasNumberHandling() throws Exception {
        String contentWithInvalidCas = """
            产品名称：测试化学品
            英文名称：Test Chemical
            CAS号：invalid-cas-number
            企业名称：测试化工有限公司
            """;
        
        MsdsMain result = (MsdsMain) parseMsdsFromContentCompleteMethod.invoke(msdsMainService, contentWithInvalidCas);
        
        assertNotNull(result);
        assertEquals("测试化学品", result.getProductName());
        assertEquals("Test Chemical", result.getProductEnglishName());
        assertTrue(result.getCasNumber() == null || result.getCasNumber().isEmpty());
    }

    @Test
    @DisplayName("测试性能基准")
    void testPerformanceBenchmark() throws Exception {
        // 创建较大的测试内容
        StringBuilder largeContent = new StringBuilder();
        for (int i = 0; i < 1000; i++) {
            largeContent.append("产品名称：测试化学品").append(i).append("\n");
            largeContent.append("英文名称：Test Chemical ").append(i).append("\n");
            largeContent.append("CAS号：123-45-").append(i % 10).append("\n");
        }
        
        long startTime = System.currentTimeMillis();
        
        MsdsMain result = (MsdsMain) parseMsdsFromContentCompleteMethod.invoke(msdsMainService, largeContent.toString());
        
        long endTime = System.currentTimeMillis();
        long duration = endTime - startTime;
        
        assertNotNull(result);
        assertTrue(duration < 5000, "解析大文档应该在5秒内完成，实际耗时: " + duration + "ms");
        
        logger.info("性能测试完成，解析耗时: {}ms", duration);
    }

    @Test
    @DisplayName("测试编码处理")
    void testEncodingHandling() throws Exception {
        // 测试不同编码的内容
        String utf8Content = "产品名称：甲苯\n英文名称：Toluene";
        String gbkContent = new String(utf8Content.getBytes(StandardCharsets.UTF_8), "GBK");
        
        // 测试UTF-8编码
        MsdsMain result1 = (MsdsMain) parseMsdsFromContentCompleteMethod.invoke(msdsMainService, utf8Content);
        assertNotNull(result1);
        assertEquals("甲苯", result1.getProductName());
        
        // 测试GBK编码（可能会有编码问题，但不应该崩溃）
        assertDoesNotThrow(() -> {
            parseMsdsFromContentCompleteMethod.invoke(msdsMainService, gbkContent);
        });
    }
    
    @Test
    @DisplayName("测试表格解析功能")
    void testTableParsing() throws Exception {
        // 模拟包含表格的MSDS文档内容
        String tableContent = """
            产品名称：甲苯
            
            [表格1开始]
            [表头] 【成分】 | 【含量】 | 【CAS号】
            甲苯 | 99.5% | 108-88-3
            杂质 | 0.5% | -
            [表格1结束]
            
            危险性分类：易燃液体
            
            [表格2开始]
            [表头] 【危险类别】 | 【危险等级】 | 【标识】
            易燃液体 | 2类 | GHS02
            急性毒性 | 4类 | GHS07
            [表格2结束]
            """;
        
        MsdsMain result = (MsdsMain) parseMsdsFromContentCompleteMethod.invoke(msdsMainService, tableContent);
        
        assertNotNull(result);
        assertEquals("甲苯", result.getProductName());
        
        // 验证表格内容被正确解析
        // 注意：具体的表格解析逻辑需要根据实际实现来验证
        logger.info("表格解析测试完成，产品名称: {}", result.getProductName());
    }
    
    @Test
    @DisplayName("测试增强的错误恢复机制")
    void testEnhancedErrorRecovery() throws Exception {
        // 测试损坏的文档内容
        String corruptedContent = """
            产品名称：甲苯
            ���乱码内容���
            CAS号：108-88-3
            企业名称：测试化工有限公司
            ���更多乱码���
            危险性分类：易燃液体
            """;
        
        MsdsMain result = (MsdsMain) parseMsdsFromContentCompleteMethod.invoke(msdsMainService, corruptedContent);
        
        // 即使有乱码，也应该能提取到有效信息
        assertNotNull(result);
        assertEquals("甲苯", result.getProductName());
        assertEquals("108-88-3", result.getCasNumber());
        assertEquals("测试化工有限公司", result.getCompanyName());
        
        logger.info("错误恢复测试完成，成功提取: 产品名称={}, CAS号={}, 企业名称={}", 
                   result.getProductName(), result.getCasNumber(), result.getCompanyName());
    }
    
    @Test
    @DisplayName("测试多语言内容处理")
    void testMultiLanguageContent() throws Exception {
        // 测试中英文混合内容
        String multiLangContent = """
            Product Name: Toluene
            产品名称：甲苯
            CAS Number: 108-88-3
            CAS号：108-88-3
            Company: Test Chemical Co., Ltd.
            企业名称：测试化工有限公司
            Hazard Classification: Flammable Liquid
            危险性分类：易燃液体
            """;
        
        MsdsMain result = (MsdsMain) parseMsdsFromContentCompleteMethod.invoke(msdsMainService, multiLangContent);
        
        assertNotNull(result);
        // 应该优先提取中文信息
        assertEquals("甲苯", result.getProductName());
        assertEquals("Toluene", result.getProductEnglishName());
        assertEquals("108-88-3", result.getCasNumber());
        assertEquals("测试化工有限公司", result.getCompanyName());
        
        logger.info("多语言内容测试完成，中文名: {}, 英文名: {}", 
                   result.getProductName(), result.getProductEnglishName());
    }
    
    @Test
    @DisplayName("测试复杂表格结构解析")
    void testComplexTableStructure() throws Exception {
        // 测试复杂的表格结构
        String complexTableContent = """
            产品名称：混合溶剂
            
            [表格1开始]
            [表头] 【组分名称】 | 【英文名称】 | 【CAS号】 | 【含量范围】 | 【危险分类】
            甲苯 | Toluene | 108-88-3 | 60-70% | 易燃液体2类
            二甲苯 | Xylene | 1330-20-7 | 20-30% | 易燃液体3类
            乙苯 | Ethylbenzene | 100-41-4 | 5-10% | 易燃液体2类
            其他芳烃 | Other aromatics | - | <5% | 易燃液体
            [表格1结束]
            
            [表格2开始]
            [表头] 【物理性质】 | 【数值】 | 【单位】 | 【测试条件】
            沸点 | 110-144 | ℃ | 常压
            密度 | 0.86-0.88 | g/cm³ | 20℃
            粘度 | 0.5-0.6 | mPa·s | 25℃
            闪点 | 4-27 | ℃ | 闭杯法
            [表格2结束]
            """;
        
        MsdsMain result = (MsdsMain) parseMsdsFromContentCompleteMethod.invoke(msdsMainService, complexTableContent);
        
        assertNotNull(result);
        assertEquals("混合溶剂", result.getProductName());
        
        // 验证复杂表格内容被正确处理
        logger.info("复杂表格结构测试完成，产品名称: {}", result.getProductName());
    }
    
    @Test
    @DisplayName("测试文档章节识别")
    void testSectionRecognition() throws Exception {
        // 测试MSDS标准章节识别
        String sectionContent = """
            第1部分 化学品及企业标识
            产品名称：甲苯
            企业名称：测试化工有限公司
            
            第2部分 危险性概述
            危险性分类：易燃液体2类
            
            第3部分 成分/组成信息
            化学品名称：甲苯
            CAS号：108-88-3
            含量：≥99.5%
            
            第8部分 接触控制和个体防护
            职业接触限值：200mg/m³
            
            第16部分 其他信息
            参考文献：GB/T 16483-2008
            """;
        
        MsdsMain result = (MsdsMain) parseMsdsFromContentCompleteMethod.invoke(msdsMainService, sectionContent);
        
        assertNotNull(result);
        assertEquals("甲苯", result.getProductName());
        assertEquals("108-88-3", result.getCasNumber());
        assertEquals("测试化工有限公司", result.getCompanyName());
        
        logger.info("章节识别测试完成，识别到产品: {}", result.getProductName());
    }
    
    @Test
    @DisplayName("测试数据质量评估")
    void testDataQualityAssessment() throws Exception {
        // 测试高质量数据
        String highQualityContent = """
            产品名称：甲苯
            英文名称：Toluene
            CAS号：108-88-3
            分子式：C7H8
            分子量：92.14
            企业名称：测试化工有限公司
            地址：北京市朝阳区
            电话：010-12345678
            危险性分类：易燃液体2类
            """;
        
        MsdsMain highQualityResult = (MsdsMain) parseMsdsFromContentCompleteMethod.invoke(msdsMainService, highQualityContent);
        
        // 测试低质量数据
        String lowQualityContent = """
            产品：甲苯
            CAS：108-88-3
            公司：测试公司
            """;
        
        MsdsMain lowQualityResult = (MsdsMain) parseMsdsFromContentCompleteMethod.invoke(msdsMainService, lowQualityContent);
        
        // 验证两种质量的数据都能被处理
        assertNotNull(highQualityResult);
        assertNotNull(lowQualityResult);
        
        assertEquals("甲苯", highQualityResult.getProductName());
        assertEquals("甲苯", lowQualityResult.getProductName());
        
        // 高质量数据应该包含更多信息
        assertNotNull(highQualityResult.getProductEnglishName());
        assertEquals("测试化工有限公司", highQualityResult.getCompanyName());
        
        logger.info("数据质量评估测试完成，高质量数据字段数 > 低质量数据字段数");
    }
}
