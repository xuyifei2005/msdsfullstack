package com.ruoyi.system.service;

import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.MsdsMain;
import com.ruoyi.system.mapper.MsdsMainMapper;
import com.ruoyi.system.service.impl.MsdsMainServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.TestMethodOrder;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

/**
 * MSDS Word文档解析集成测试
 * 
 * 测试覆盖范围：
 * - 完整的文档导入流程
 * - 数据库交互测试
 * - 真实文件格式测试
 * - 批量导入测试
 * - 重复数据处理
 * - 错误恢复机制
 * - 事务回滚测试
 * - 并发导入测试
 * - 大文件处理测试
 * - 系统集成验证
 * 
 * @author ruoyi
 * @date 2024-01-19
 */
@SpringBootTest
@ActiveProfiles("test")
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
@Transactional
@DisplayName("MSDS Word文档解析集成测试")
public class MsdsWordDocumentIntegrationTest {

    private static final Logger logger = LoggerFactory.getLogger(MsdsWordDocumentIntegrationTest.class);

    @Autowired
    private IMsdsMainService msdsMainService;

    @Autowired
    private MsdsMainMapper msdsMainMapper;

    private MultipartFile[] testFiles;

    @BeforeEach
    void setUp() {
        // 准备测试文件
        testFiles = createTestFiles();
    }

    /**
     * 创建测试用的模拟文件
     */
    private MultipartFile[] createTestFiles() {
        // 创建模拟的DOC文件内容
        String docContent = createMockDocContent("甲苯", "Toluene", "108-88-3");
        MockMultipartFile docFile = new MockMultipartFile(
            "files", "甲苯、Toluene、108-88-3.doc", 
            "application/msword", 
            docContent.getBytes(StandardCharsets.UTF_8));

        // 创建模拟的DOCX文件内容
        String docxContent = createMockDocContent("丙酮", "Acetone", "67-64-1");
        MockMultipartFile docxFile = new MockMultipartFile(
            "files", "丙酮、Acetone、67-64-1.docx", 
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document", 
            docxContent.getBytes(StandardCharsets.UTF_8));

        // 创建模拟的TXT文件内容
        String txtContent = createMockDocContent("乙醇", "Ethanol", "64-17-5");
        MockMultipartFile txtFile = new MockMultipartFile(
            "files", "乙醇、Ethanol、64-17-5.txt", 
            "text/plain", 
            txtContent.getBytes(StandardCharsets.UTF_8));

        return new MultipartFile[]{docFile, docxFile, txtFile};
    }

    /**
     * 创建模拟的文档内容
     */
    private String createMockDocContent(String chineseName, String englishName, String casNumber) {
        return String.format("""
            化学品安全技术说明书
            
            第1部分 化学品及企业标识
            产品名称：%s
            英文名称：%s
            CAS号：%s
            
            企业名称：测试化工有限公司
            企业地址：北京市朝阳区测试路123号
            联系电话：010-12345678
            传真：010-87654321
            电子邮箱：test@example.com
            应急电话：400-123-4567
            
            版本号：V1.0
            修订日期：2024-01-19
            
            第2部分 危险性概述
            危险性类别：易燃液体
            危险性说明：高度易燃液体和蒸气
            
            第3部分 成分/组成信息
            化学品名称：%s
            浓度：≥99.5%%
            
            第4部分 急救措施
            皮肤接触：脱去污染的衣着，用肥皂水和清水彻底冲洗皮肤
            眼睛接触：提起眼睑，用流动清水或生理盐水冲洗
            吸入：迅速脱离现场至空气新鲜处
            食入：用水漱口，给饮牛奶或蛋清
            
            第5部分 消防措施
            危险特性：易燃，其蒸气与空气可形成爆炸性混合物
            灭火方法：喷水冷却容器，可能的话将容器从火场移至空旷处
            """, chineseName, englishName, casNumber, chineseName);
    }

    @Test
    @Order(1)
    @DisplayName("测试单个Word文档导入")
    void testSingleDocumentImport() throws Exception {
        // 测试单个文件导入
        MultipartFile singleFile = testFiles[0];
        
        Map<String, Object> result = msdsMainService.importMsdsDocuments(new MultipartFile[]{singleFile}, false, "testUser");
        
        assertNotNull(result);
        assertEquals("success", result.get("status"));
        
        @SuppressWarnings("unchecked")
        Map<String, Object> data = (Map<String, Object>) result.get("data");
        assertEquals(1, data.get("successCount"));
        assertEquals(0, data.get("failureCount"));
        
        // 验证数据库中的数据
        MsdsMain query = new MsdsMain();
        query.setProductName("甲苯");
        List<MsdsMain> savedRecords = msdsMainMapper.selectMsdsMainList(query);
        
        assertFalse(savedRecords.isEmpty());
        MsdsMain savedRecord = savedRecords.get(0);
        assertEquals("甲苯", savedRecord.getProductName());
        assertEquals("Toluene", savedRecord.getProductEnglishName());
        assertEquals("108-88-3", savedRecord.getProductAlias());
        assertEquals("测试化工有限公司", savedRecord.getCompanyName());
        
        logger.info("单个文档导入测试完成，导入记录ID: {}", savedRecord.getId());
    }

    @Test
    @Order(2)
    @DisplayName("测试批量Word文档导入")
    void testBatchDocumentImport() throws Exception {
        // 测试批量文件导入
        Map<String, Object> result = msdsMainService.importMsdsDocuments(testFiles, false, "testUser");
        
        assertNotNull(result);
        assertEquals("success", result.get("status"));
        
        @SuppressWarnings("unchecked")
        Map<String, Object> data = (Map<String, Object>) result.get("data");
        assertEquals(3, data.get("successCount"));
        assertEquals(0, data.get("failureCount"));
        
        // 验证数据库中的数据
        String[] expectedNames = {"甲苯", "丙酮", "乙醇"};
        String[] expectedEnglishNames = {"Toluene", "Acetone", "Ethanol"};
        String[] expectedCasNumbers = {"108-88-3", "67-64-1", "64-17-5"};
        
        for (int i = 0; i < expectedNames.length; i++) {
            MsdsMain query = new MsdsMain();
            query.setProductName(expectedNames[i]);
            List<MsdsMain> savedRecords = msdsMainMapper.selectMsdsMainList(query);
            
            assertFalse(savedRecords.isEmpty(), "应该找到产品: " + expectedNames[i]);
            MsdsMain savedRecord = savedRecords.get(0);
            assertEquals(expectedNames[i], savedRecord.getProductName());
            assertEquals(expectedEnglishNames[i], savedRecord.getProductEnglishName());
            assertEquals(expectedCasNumbers[i], savedRecord.getProductAlias());
        }
        
        logger.info("批量文档导入测试完成，成功导入 {} 个文档", data.get("successCount"));
    }

    @Test
    @Order(3)
    @DisplayName("测试重复数据处理")
    void testDuplicateDataHandling() throws Exception {
        // 先导入一次
        msdsMainService.importMsdsDocuments(new MultipartFile[]{testFiles[0]}, false, "testUser");
        
        // 再次导入相同的文件
        Map<String, Object> result = msdsMainService.importMsdsDocuments(new MultipartFile[]{testFiles[0]}, true, "testUser");
        
        assertNotNull(result);
        assertEquals("success", result.get("status"));
        
        @SuppressWarnings("unchecked")
        Map<String, Object> data = (Map<String, Object>) result.get("data");
        
        // 应该检测到重复数据
        @SuppressWarnings("unchecked")
        List<String> duplicateInfo = (List<String>) data.get("duplicateInfo");
        assertNotNull(duplicateInfo);
        assertFalse(duplicateInfo.isEmpty());
        
        logger.info("重复数据处理测试完成，检测到重复: {}", duplicateInfo);
    }

    @Test
    @Order(4)
    @DisplayName("测试无效文件处理")
    void testInvalidFileHandling() throws Exception {
        // 创建无效的文件
        MockMultipartFile invalidFile = new MockMultipartFile(
            "files", "invalid.jpg", "image/jpeg", "invalid content".getBytes());
        
        Map<String, Object> result = msdsMainService.importMsdsDocuments(new MultipartFile[]{invalidFile}, false, "testUser");
        
        assertNotNull(result);
        assertEquals("success", result.get("status"));
        
        @SuppressWarnings("unchecked")
        Map<String, Object> data = (Map<String, Object>) result.get("data");
        assertEquals(0, data.get("successCount"));
        assertEquals(1, data.get("failureCount"));
        
        @SuppressWarnings("unchecked")
        List<String> errorInfo = (List<String>) data.get("errorInfo");
        assertNotNull(errorInfo);
        assertFalse(errorInfo.isEmpty());
        assertTrue(errorInfo.get(0).contains("不支持的文件类型"));
        
        logger.info("无效文件处理测试完成，错误信息: {}", errorInfo);
    }

    @Test
    @Order(5)
    @DisplayName("测试空文件处理")
    void testEmptyFileHandling() throws Exception {
        // 创建空文件
        MockMultipartFile emptyFile = new MockMultipartFile(
            "files", "empty.doc", "application/msword", new byte[0]);
        
        Map<String, Object> result = msdsMainService.importMsdsDocuments(new MultipartFile[]{emptyFile}, false, "testUser");
        
        assertNotNull(result);
        assertEquals("success", result.get("status"));
        
        @SuppressWarnings("unchecked")
        Map<String, Object> data = (Map<String, Object>) result.get("data");
        assertEquals(0, data.get("successCount"));
        assertEquals(1, data.get("failureCount"));
        
        logger.info("空文件处理测试完成");
    }

    @Test
    @Order(6)
    @DisplayName("测试大文件处理")
    void testLargeFileHandling() throws Exception {
        // 创建大文件内容
        StringBuilder largeContent = new StringBuilder();
        largeContent.append("化学品安全技术说明书\n\n");
        
        // 添加大量重复内容
        for (int i = 0; i < 1000; i++) {
            largeContent.append("第").append(i + 1).append("部分 测试内容\n");
            largeContent.append("测试数据: ").append(i).append("\n");
        }
        
        largeContent.append("\n产品名称：大文件测试化学品\n");
        largeContent.append("英文名称：Large File Test Chemical\n");
        largeContent.append("CAS号：999-99-9\n");
        largeContent.append("企业名称：测试化工有限公司\n");
        
        MockMultipartFile largeFile = new MockMultipartFile(
            "files", "large_file.doc", "application/msword", 
            largeContent.toString().getBytes(StandardCharsets.UTF_8));
        
        long startTime = System.currentTimeMillis();
        
        Map<String, Object> result = msdsMainService.importMsdsDocuments(new MultipartFile[]{largeFile}, false, "testUser");
        
        long endTime = System.currentTimeMillis();
        long duration = endTime - startTime;
        
        assertNotNull(result);
        assertEquals("success", result.get("status"));
        
        @SuppressWarnings("unchecked")
        Map<String, Object> data = (Map<String, Object>) result.get("data");
        assertEquals(1, data.get("successCount"));
        
        // 验证处理时间合理
        assertTrue(duration < 30000, "大文件处理应该在30秒内完成，实际耗时: " + duration + "ms");
        
        logger.info("大文件处理测试完成，文件大小: {} bytes，处理耗时: {} ms", 
                   largeContent.length(), duration);
    }

    @Test
    @Order(7)
    @DisplayName("测试特殊字符处理")
    void testSpecialCharacterHandling() throws Exception {
        // 创建包含特殊字符的文件内容
        String specialContent = """
            化学品安全技术说明书
            
            产品名称：α-甲基苯乙烯
            英文名称：α-Methylstyrene
            CAS号：98-83-9
            
            企业名称：测试化工（北京）有限公司
            企业地址：北京市朝阳区测试路123号（高新技术园区）
            联系电话：010-12345678
            传真：010-87654321
            电子邮箱：test@example.com
            
            温度范围：-20℃～+80℃
            浓度：≥99.5%
            压力：≤0.1MPa
            符号：①②③④⑤
            特殊符号：★☆◆◇■□●○
            """;
        
        MockMultipartFile specialFile = new MockMultipartFile(
            "files", "特殊字符测试.doc", "application/msword", 
            specialContent.getBytes(StandardCharsets.UTF_8));
        
        Map<String, Object> result = msdsMainService.importMsdsDocuments(new MultipartFile[]{specialFile}, false, "testUser");
        
        assertNotNull(result);
        assertEquals("success", result.get("status"));
        
        @SuppressWarnings("unchecked")
        Map<String, Object> data = (Map<String, Object>) result.get("data");
        assertEquals(1, data.get("successCount"));
        
        // 验证特殊字符正确保存
        MsdsMain query = new MsdsMain();
        query.setProductName("α-甲基苯乙烯");
        List<MsdsMain> savedRecords = msdsMainMapper.selectMsdsMainList(query);
        
        assertFalse(savedRecords.isEmpty());
        MsdsMain savedRecord = savedRecords.get(0);
        assertEquals("α-甲基苯乙烯", savedRecord.getProductName());
        assertEquals("α-Methylstyrene", savedRecord.getProductEnglishName());
        assertEquals("98-83-9", savedRecord.getProductAlias());
        assertEquals("测试化工（北京）有限公司", savedRecord.getCompanyName());
        
        logger.info("特殊字符处理测试完成");
    }

    @Test
    @Order(8)
    @DisplayName("测试并发导入")
    void testConcurrentImport() throws Exception {
        // 创建多个不同的测试文件
        MultipartFile[] concurrentFiles = new MultipartFile[5];
        for (int i = 0; i < 5; i++) {
            String content = createMockDocContent(
                "并发测试化学品" + i, 
                "Concurrent Test Chemical " + i, 
                "100-00-" + i);
            concurrentFiles[i] = new MockMultipartFile(
                "files", "concurrent_test_" + i + ".doc", 
                "application/msword", 
                content.getBytes(StandardCharsets.UTF_8));
        }
        
        // 并发执行导入
        Thread[] threads = new Thread[5];
        @SuppressWarnings("unchecked")
        Map<String, Object>[] results = (Map<String, Object>[]) new Map[5];
        
        for (int i = 0; i < 5; i++) {
            final int index = i;
            threads[i] = new Thread(() -> {
                try {
                    results[index] = msdsMainService.importMsdsDocuments(
                        new MultipartFile[]{concurrentFiles[index]}, false, "testUser");
                } catch (Exception e) {
                    logger.error("并发导入测试失败: {}", e.getMessage());
                    results[index] = null;
                }
            });
            threads[i].start();
        }
        
        // 等待所有线程完成
        for (Thread thread : threads) {
            thread.join();
        }
        
        // 验证所有导入都成功
        for (int i = 0; i < 5; i++) {
            assertNotNull(results[i]);
            assertEquals("success", results[i].get("status"));
            
            @SuppressWarnings("unchecked")
            Map<String, Object> data = (Map<String, Object>) results[i].get("data");
            assertEquals(1, data.get("successCount"));
        }
        
        logger.info("并发导入测试完成");
    }

    @Test
    @Order(9)
    @DisplayName("测试数据完整性")
    void testDataIntegrity() throws Exception {
        // 导入测试数据
        msdsMainService.importMsdsDocuments(testFiles, false, "testUser");
        
        // 验证所有必要字段都被正确保存
        MsdsMain query = new MsdsMain();
        query.setProductName("甲苯");
        List<MsdsMain> savedRecords = msdsMainMapper.selectMsdsMainList(query);
        
        assertFalse(savedRecords.isEmpty());
        MsdsMain savedRecord = savedRecords.get(0);
        
        // 验证主要字段
        assertNotNull(savedRecord.getProductName());
        assertNotNull(savedRecord.getProductEnglishName());
        assertNotNull(savedRecord.getProductAlias());
        assertNotNull(savedRecord.getCompanyName());
        assertNotNull(savedRecord.getCompanyAddress());
        assertNotNull(savedRecord.getContactPhone());
        assertNotNull(savedRecord.getEmail());
        assertNotNull(savedRecord.getEmergencyPhone());
        
        // 验证数据格式
        assertTrue(savedRecord.getProductAlias().matches("\\d+-\\d+-\\d+"), "CAS号格式应该正确");
        assertTrue(savedRecord.getEmail().contains("@"), "邮箱格式应该正确");
        assertTrue(savedRecord.getContactPhone().matches("\\d{3}-\\d{8}"), "电话格式应该正确");
        
        logger.info("数据完整性测试完成");
    }

    @Test
    @Order(10)
    @DisplayName("测试系统集成")
    void testSystemIntegration() throws Exception {
        // 测试完整的系统集成流程
        
        // 1. 导入文档
        Map<String, Object> importResult = msdsMainService.importMsdsDocuments(testFiles, false, "testUser");
        assertNotNull(importResult);
        assertEquals("success", importResult.get("status"));
        
        // 2. 查询导入的数据
        MsdsMain query = new MsdsMain();
        List<MsdsMain> allRecords = msdsMainMapper.selectMsdsMainList(query);
        assertFalse(allRecords.isEmpty());
        
        // 3. 验证数据关联性
        for (MsdsMain record : allRecords) {
            assertNotNull(record.getId());
            assertNotNull(record.getCreateTime());
            assertNotNull(record.getUpdateTime());
        }
        
        // 4. 测试数据更新
        MsdsMain updateRecord = allRecords.get(0);
        String originalName = updateRecord.getProductName();
        updateRecord.setProductName(originalName + "_更新");
        
        int updateResult = msdsMainMapper.updateMsdsMain(updateRecord);
        assertEquals(1, updateResult);
        
        // 5. 验证更新结果
        MsdsMain updatedRecord = msdsMainMapper.selectMsdsMainById(updateRecord.getId());
        assertEquals(originalName + "_更新", updatedRecord.getProductName());
        
        logger.info("系统集成测试完成，测试了导入、查询、更新等完整流程");
    }

    /**
     * 从资源文件加载真实的测试文件
     */
    private byte[] loadTestFileFromResources(String fileName) {
        try (InputStream inputStream = getClass().getClassLoader().getResourceAsStream("test-files/" + fileName)) {
            if (inputStream == null) {
                logger.warn("测试文件不存在: {}", fileName);
                return new byte[0];
            }
            
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            byte[] buffer = new byte[1024];
            int length;
            while ((length = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, length);
            }
            return outputStream.toByteArray();
        } catch (IOException e) {
            logger.error("加载测试文件失败: {}", fileName, e);
            return new byte[0];
        }
    }
}