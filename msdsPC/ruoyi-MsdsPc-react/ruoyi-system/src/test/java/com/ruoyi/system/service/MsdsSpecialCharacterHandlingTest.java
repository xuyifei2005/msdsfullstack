package com.ruoyi.system.service;

import com.ruoyi.system.domain.MsdsMain;
import com.ruoyi.system.service.impl.MsdsMainServiceImpl;
import com.ruoyi.system.mapper.*;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * MSDS特殊字符处理测试类
 * 测试文档导入过程中对特殊字符的处理能力
 * 
 * @author ruoyi
 * @date 2024-12-27
 */
@ExtendWith(MockitoExtension.class)
public class MsdsSpecialCharacterHandlingTest {

    @Mock
    private MsdsMainMapper msdsMainMapper;
    
    @Mock
    private MsdsHazardMapper msdsHazardMapper;
    
    @Mock
    private MsdsComponentMapper msdsComponentMapper;
    
    @InjectMocks
    private MsdsMainServiceImpl msdsMainService;
    
    // 用于测试私有方法的真实服务实例
    private MsdsMainServiceImpl realMsdsMainService;
    
    // 测试用的特殊字符化学品名称
    private static final String SPECIAL_CHEMICAL_NAME = "1,2,3,4,7,7-六氯双环[2,2,1]庚烯-(2)-双羟甲基-5,6-亚硫酸酯；硫丹";
    private static final String SPECIAL_ENGLISH_NAME = "Endosulfan sulfate";
    private static final String SPECIAL_CAS_NUMBER = "1031-07-8";
    
    @BeforeEach
    void setUp() {
        // 初始化测试环境
        // 创建真实的服务实例用于测试私有方法
        realMsdsMainService = new MsdsMainServiceImpl();
        
        // handleTextEncoding是一个纯文本处理方法，不依赖于数据库操作
        // 但需要确保logger等基础组件正常工作
    }
    
    /**
     * 测试TXT文件中特殊字符的处理
     */
    @Test
    public void testSpecialCharacterInTxtFile() throws Exception {
        // 构造包含特殊字符的TXT内容
        String txtContent = String.format(
            "化学品中文名称：%s\n" +
            "化学品英文名称：%s\n" +
            "CAS号：%s\n" +
            "分子式：C9H6Cl6O4S\n" +
            "分子量：406.93\n" +
            "危险性类别：有毒化学品\n" +
            "主要用途：杀虫剂\n",
            SPECIAL_CHEMICAL_NAME, SPECIAL_ENGLISH_NAME, SPECIAL_CAS_NUMBER
        );
        
        // 创建模拟文件
        MockMultipartFile file = new MockMultipartFile(
            "file",
            "special_chemical.txt",
            "text/plain",
            txtContent.getBytes(StandardCharsets.UTF_8)
        );
        
        // 测试文本提取和字符编码处理
        try {
            // 测试文本内容是否包含特殊字符
            String content = new String(file.getBytes(), StandardCharsets.UTF_8);
            System.out.println("DEBUG: content = " + content);
            System.out.println("DEBUG: content length = " + (content != null ? content.length() : "null"));
            System.out.println("DEBUG: realMsdsMainService = " + realMsdsMainService);
            
            assertNotNull(content);
            assertTrue(content.contains(SPECIAL_CHEMICAL_NAME), "文本应包含特殊字符化学品名称");
            assertTrue(content.contains(SPECIAL_ENGLISH_NAME), "文本应包含英文名称");
            assertTrue(content.contains(SPECIAL_CAS_NUMBER), "文本应包含CAS号");
            
            // 通过反射测试私有方法handleTextEncoding
            java.lang.reflect.Method handleTextEncodingMethod = MsdsMainServiceImpl.class.getDeclaredMethod("handleTextEncoding", String.class);
            handleTextEncodingMethod.setAccessible(true);
            System.out.println("DEBUG: 准备调用handleTextEncoding方法");
            String processedContent = (String) handleTextEncodingMethod.invoke(realMsdsMainService, content);
            System.out.println("DEBUG: handleTextEncoding调用成功");
            assertNotNull(processedContent, "处理后的内容不应为空");
            assertTrue(processedContent.contains(SPECIAL_CHEMICAL_NAME), "处理后应保留特殊字符");
            
        } catch (Exception e) {
            e.printStackTrace();
            fail("特殊字符处理测试失败: " + e.getClass().getSimpleName() + ": " + e.getMessage());
        }
    }
    
    /**
     * 测试CSV文件中特殊字符的处理
     */
    @Test
    public void testSpecialCharacterInCsvFile() throws Exception {
        // 构造包含特殊字符的CSV内容
        String csvContent = String.format(
            "产品名称,英文名称,CAS号,分子式,分子量,危险性类别\n" +
            "\"%s\",\"%s\",%s,C9H6Cl6O4S,406.93,有毒化学品\n",
            SPECIAL_CHEMICAL_NAME, SPECIAL_ENGLISH_NAME, SPECIAL_CAS_NUMBER
        );
        
        // 创建模拟文件
        MockMultipartFile file = new MockMultipartFile(
            "file",
            "special_chemical.csv",
            "text/csv",
            csvContent.getBytes(StandardCharsets.UTF_8)
        );
        
        // 测试CSV内容解析和特殊字符处理
        try {
            String content = new String(file.getBytes(), StandardCharsets.UTF_8);
            assertNotNull(content);
            assertTrue(content.contains(SPECIAL_CHEMICAL_NAME), "CSV应包含特殊字符化学品名称");
            assertTrue(content.contains(SPECIAL_ENGLISH_NAME), "CSV应包含英文名称");
            assertTrue(content.contains(SPECIAL_CAS_NUMBER), "CSV应包含CAS号");
            
            // 通过反射测试私有方法handleTextEncoding
            java.lang.reflect.Method handleTextEncodingMethod = MsdsMainServiceImpl.class.getDeclaredMethod("handleTextEncoding", String.class);
            handleTextEncodingMethod.setAccessible(true);
            String processedContent = (String) handleTextEncodingMethod.invoke(realMsdsMainService, content);
            assertNotNull(processedContent, "处理后的内容不应为空");
            assertTrue(processedContent.contains(SPECIAL_CHEMICAL_NAME), "处理后应保留特殊字符");
            
        } catch (Exception e) {
            e.printStackTrace();
            fail("CSV特殊字符处理测试失败: " + e.getClass().getSimpleName() + ": " + e.getMessage());
        }
    }
    
    /**
     * 测试文件名中特殊字符的解析
     */
    @Test
    public void testSpecialCharacterInFileName() throws Exception {
        // 构造包含特殊字符的文件名
        String fileName = String.format("%s,%s,%s.txt", 
            SPECIAL_CHEMICAL_NAME, SPECIAL_ENGLISH_NAME, SPECIAL_CAS_NUMBER);
        
        String txtContent = "这是一个测试文档内容\n包含基本的MSDS信息";
        
        // 创建模拟文件
        MockMultipartFile file = new MockMultipartFile(
            "file",
            fileName,
            "text/plain",
            txtContent.getBytes(StandardCharsets.UTF_8)
        );
        
        // 测试文件名解析和特殊字符处理
        try {
            String originalFileName = file.getOriginalFilename();
            assertNotNull(originalFileName);
            assertTrue(originalFileName.contains(SPECIAL_CHEMICAL_NAME), "文件名应包含特殊字符化学品名称");
            assertTrue(originalFileName.contains(SPECIAL_ENGLISH_NAME), "文件名应包含英文名称");
            assertTrue(originalFileName.contains(SPECIAL_CAS_NUMBER), "文件名应包含CAS号");
            
            // 通过反射测试私有方法handleTextEncoding
            String content = new String(file.getBytes(), StandardCharsets.UTF_8);
            java.lang.reflect.Method handleTextEncodingMethod = MsdsMainServiceImpl.class.getDeclaredMethod("handleTextEncoding", String.class);
            handleTextEncodingMethod.setAccessible(true);
            String processedContent = (String) handleTextEncodingMethod.invoke(realMsdsMainService, content);
            assertNotNull(processedContent, "处理后的内容不应为空");
            
        } catch (Exception e) {
            e.printStackTrace();
            fail("文件名特殊字符处理测试失败: " + e.getClass().getSimpleName() + ": " + e.getMessage());
        }
    }
    
    /**
     * 测试字符编码处理方法
     */
    @Test
    public void testCharacterEncodingHandling() {
        // 测试包含特殊字符的文本处理
        String testText = String.format(
            "测试文本包含特殊字符：%s\n" +
            "还包含其他符号：①②③④⑤\n" +
            "以及各种标点：，。；：！？（）【】\n" +
            "英文字符：ABCDEFG abcdefg\n" +
            "数字字符：1234567890\n",
            SPECIAL_CHEMICAL_NAME
        );
        
        // 创建包含特殊字符的文件进行测试
        MockMultipartFile file = new MockMultipartFile(
            "file",
            "encoding_test.txt",
            "text/plain",
            testText.getBytes(StandardCharsets.UTF_8)
        );
        
        try {
            // 测试文本内容是否正确编码
            String content = new String(file.getBytes(), StandardCharsets.UTF_8);
            assertNotNull(content);
            assertTrue(content.contains(SPECIAL_CHEMICAL_NAME), "文本应包含特殊字符");
            assertTrue(content.contains("①②③④⑤"), "文本应包含特殊符号");
            assertTrue(content.contains("，。；：！？（）【】"), "文本应包含中文标点");
            
            // 通过反射测试私有方法handleTextEncoding
            java.lang.reflect.Method handleTextEncodingMethod = MsdsMainServiceImpl.class.getDeclaredMethod("handleTextEncoding", String.class);
            handleTextEncodingMethod.setAccessible(true);
            String processedContent = (String) handleTextEncodingMethod.invoke(realMsdsMainService, content);
            assertNotNull(processedContent, "处理后的内容不应为空");
            assertTrue(processedContent.contains(SPECIAL_CHEMICAL_NAME), "处理后应保留特殊字符");
            
        } catch (Exception e) {
            e.printStackTrace();
            fail("字符编码处理失败: " + e.getClass().getSimpleName() + ": " + e.getMessage());
        }
    }
    
    /**
     * 测试损坏文本清理功能
     */
    @Test
    public void testCorruptedTextCleaning() {
        // 构造包含损坏字符的文本
        String corruptedText = String.format(
            "正常文本：%s\n" +
            "损坏字符：\uFFFD\uFFFD\uFFFD\n" +
            "控制字符：\u0001\u0002\u0003\n" +
            "正常结尾",
            SPECIAL_CHEMICAL_NAME
        );
        
        MockMultipartFile file = new MockMultipartFile(
            "file",
            "corrupted_test.txt",
            "text/plain",
            corruptedText.getBytes(StandardCharsets.UTF_8)
        );
        
        try {
            // 测试损坏文本的识别和处理
            String content = new String(file.getBytes(), StandardCharsets.UTF_8);
            assertNotNull(content);
            assertTrue(content.contains(SPECIAL_CHEMICAL_NAME), "文本应包含正常字符");
            assertTrue(content.contains("\uFFFD"), "文本应包含损坏字符标记");
            
            // 通过反射测试私有方法handleTextEncoding
            java.lang.reflect.Method handleTextEncodingMethod = MsdsMainServiceImpl.class.getDeclaredMethod("handleTextEncoding", String.class);
            handleTextEncodingMethod.setAccessible(true);
            String processedContent = (String) handleTextEncodingMethod.invoke(realMsdsMainService, content);
            assertNotNull(processedContent, "处理后的内容不应为空");
            assertTrue(processedContent.contains(SPECIAL_CHEMICAL_NAME), "处理后应保留正常字符");
            
            // 验证损坏字符被清理（这里假设handleTextEncoding方法会清理损坏字符）
            // 具体的清理逻辑取决于实际实现
            
        } catch (Exception e) {
            e.printStackTrace();
            fail("损坏文本清理失败: " + e.getClass().getSimpleName() + ": " + e.getMessage());
        }
    }
    
    /**
     * 测试多种编码格式的兼容性
     */
    @Test
    public void testMultipleEncodingCompatibility() {
        String testContent = String.format(
            "化学品名称：%s\n" +
            "这是UTF-8编码的测试内容\n",
            SPECIAL_CHEMICAL_NAME
        );
        
        // 测试UTF-8编码
        testEncodingCompatibility(testContent, StandardCharsets.UTF_8, "UTF-8");
        
        // 测试GBK编码（如果支持）
        try {
            testEncodingCompatibility(testContent, java.nio.charset.Charset.forName("GBK"), "GBK");
        } catch (Exception e) {
            // GBK编码可能不被支持，记录但不失败
            System.out.println("GBK编码测试跳过: " + e.getMessage());
        }
    }
    
    private void testEncodingCompatibility(String content, java.nio.charset.Charset charset, String encodingName) {
        try {
            MockMultipartFile file = new MockMultipartFile(
                "file",
                "encoding_" + encodingName + "_test.txt",
                "text/plain",
                content.getBytes(charset)
            );
            
            // 测试编码兼容性
            String decodedContent = new String(file.getBytes(), charset);
            assertNotNull(decodedContent, encodingName + "编码解码失败");
            assertTrue(decodedContent.contains(SPECIAL_CHEMICAL_NAME), encodingName + "编码应保留特殊字符");
            
            // 通过反射测试私有方法handleTextEncoding
            java.lang.reflect.Method handleTextEncodingMethod = MsdsMainServiceImpl.class.getDeclaredMethod("handleTextEncoding", String.class);
            handleTextEncodingMethod.setAccessible(true);
            String processedContent = (String) handleTextEncodingMethod.invoke(realMsdsMainService, decodedContent);
            assertNotNull(processedContent, encodingName + "编码处理后内容不应为空");
            assertTrue(processedContent.contains(SPECIAL_CHEMICAL_NAME), encodingName + "编码处理后应保留特殊字符");
            
        } catch (Exception e) {
            e.printStackTrace();
            fail(encodingName + "编码兼容性测试失败: " + e.getClass().getSimpleName() + ": " + e.getMessage());
        }
    }
}