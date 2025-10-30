package com.ruoyi.system.service;

import com.ruoyi.system.service.impl.MsdsMainServiceImpl;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.beans.factory.annotation.Autowired;

import java.io.ByteArrayInputStream;
import java.nio.charset.StandardCharsets;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

/**
 * MSDS主服务实现类测试
 * 测试CSV导入功能的错误处理和数据验证机制
 */
@SpringBootTest
@ActiveProfiles("test")
@Transactional
public class MsdsMainServiceImplTest {

    @Autowired
    private IMsdsMainService msdsMainService;

    private String validCsvContent;
    private String invalidCsvContent;
    private String partialValidCsvContent;

    @BeforeEach
    void setUp() {
        // 有效的CSV内容
        validCsvContent = "化学品中文名,化学品英文名,CAS号,MSDS编号,企业名称,企业地址,联系电话,电子邮件\n" +
                "苯,Benzene,71-43-2,MSDS001,测试企业,测试地址,010-12345678,test@example.com\n" +
                "甲苯,Toluene,108-88-3,MSDS002,测试企业2,测试地址2,010-87654321,test2@example.com";

        // 无效的CSV内容（缺少必需字段）
        invalidCsvContent = "化学品英文名,CAS号,MSDS编号\n" +
                "Benzene,71-43-2,MSDS001\n" +
                "Toluene,108-88-3,MSDS002";

        // 部分有效的CSV内容（包含无效CAS号）
        partialValidCsvContent = "化学品中文名,化学品英文名,CAS号,MSDS编号\n" +
                "苯,Benzene,71-43-2,MSDS001\n" +
                "甲苯,Toluene,invalid-cas,MSDS002\n" +
                "乙醇,Ethanol,64-17-5,MSDS003";
    }

    /**
     * 测试有效CSV文件导入
     */
    @Test
    void testImportValidCsv() throws Exception {
        MockMultipartFile file = new MockMultipartFile(
                "file",
                "test_valid.csv",
                "text/csv",
                validCsvContent.getBytes(StandardCharsets.UTF_8)
        );

        Map<String, Object> result = msdsMainService.importMsdsCsv(file, false, "testUser");

        assertNotNull(result);
        assertTrue((Boolean) result.get("success"));
        assertEquals(2, result.get("successCount"));
        assertEquals(0, result.get("failureCount"));
        assertNotNull(result.get("message"));
    }

    /**
     * 测试无效CSV文件导入（缺少必需字段）
     */
    @Test
    void testImportInvalidCsv() {
        MockMultipartFile file = new MockMultipartFile(
                "file",
                "test_invalid.csv",
                "text/csv",
                invalidCsvContent.getBytes(StandardCharsets.UTF_8)
        );

        Exception exception = assertThrows(Exception.class, () -> {
            msdsMainService.importMsdsCsv(file, false, "testUser");
        });

        assertTrue(exception.getMessage().contains("化学品中文名"));
    }

    /**
     * 测试部分有效CSV文件导入（包含数据验证警告）
     */
    @Test
    void testImportPartialValidCsv() throws Exception {
        MockMultipartFile file = new MockMultipartFile(
                "file",
                "test_partial_valid.csv",
                "text/csv",
                partialValidCsvContent.getBytes(StandardCharsets.UTF_8)
        );

        Map<String, Object> result = msdsMainService.importMsdsCsv(file, false, "testUser");

        assertNotNull(result);
        // 应该有成功导入的记录，但可能有警告
        assertTrue((Integer) result.get("successCount") > 0);
        assertNotNull(result.get("message"));
    }

    /**
     * 测试空文件导入
     */
    @Test
    void testImportEmptyFile() {
        MockMultipartFile file = new MockMultipartFile(
                "file",
                "test_empty.csv",
                "text/csv",
                "".getBytes(StandardCharsets.UTF_8)
        );

        Exception exception = assertThrows(Exception.class, () -> {
            msdsMainService.importMsdsCsv(file, false, "testUser");
        });

        assertTrue(exception.getMessage().contains("文件为空") || 
                  exception.getMessage().contains("无有效数据"));
    }

    /**
     * 测试文件格式验证
     */
    @Test
    void testFileFormatValidation() {
        // 测试非CSV文件
        MockMultipartFile file = new MockMultipartFile(
                "file",
                "test.txt",
                "text/plain",
                "This is not a CSV file".getBytes(StandardCharsets.UTF_8)
        );

        Exception exception = assertThrows(Exception.class, () -> {
            msdsMainService.importMsdsCsv(file, false, "testUser");
        });

        assertTrue(exception.getMessage().contains("文件格式") || 
                  exception.getMessage().contains("CSV"));
    }

    /**
     * 测试重复数据处理
     */
    @Test
    void testDuplicateDataHandling() throws Exception {
        MockMultipartFile file = new MockMultipartFile(
                "file",
                "test_duplicate.csv",
                "text/csv",
                validCsvContent.getBytes(StandardCharsets.UTF_8)
        );

        // 第一次导入
        Map<String, Object> result1 = msdsMainService.importMsdsCsv(file, false, "testUser");
        assertNotNull(result1);
        assertTrue((Boolean) result1.get("success"));

        // 第二次导入相同数据（不覆盖）
        Map<String, Object> result2 = msdsMainService.importMsdsCsv(file, false, "testUser");
        assertNotNull(result2);
        // 应该检测到重复数据
        assertTrue(result2.get("message").toString().contains("重复") || 
                  (Integer) result2.get("skipCount") > 0);
    }

    /**
     * 测试大文件处理性能
     */
    @Test
    void testLargeFileProcessing() throws Exception {
        StringBuilder largeContent = new StringBuilder();
        largeContent.append("化学品中文名,化学品英文名,CAS号,MSDS编号\n");
        
        // 生成1000行测试数据
        for (int i = 1; i <= 1000; i++) {
            largeContent.append(String.format("化学品%d,Chemical%d,71-43-%d,MSDS%04d\n", i, i, i, i));
        }

        MockMultipartFile file = new MockMultipartFile(
                "file",
                "test_large.csv",
                "text/csv",
                largeContent.toString().getBytes(StandardCharsets.UTF_8)
        );

        long startTime = System.currentTimeMillis();
        Map<String, Object> result = msdsMainService.importMsdsCsv(file, false, "testUser");
        long endTime = System.currentTimeMillis();

        assertNotNull(result);
        assertTrue((Boolean) result.get("success"));
        assertEquals(1000, result.get("successCount"));
        
        // 性能检查：处理1000条记录应该在合理时间内完成（例如30秒）
        assertTrue((endTime - startTime) < 30000, "大文件处理时间过长: " + (endTime - startTime) + "ms");
    }
}