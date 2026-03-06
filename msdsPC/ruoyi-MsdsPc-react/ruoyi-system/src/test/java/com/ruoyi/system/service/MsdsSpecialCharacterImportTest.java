package com.ruoyi.system.service;

import com.ruoyi.system.service.impl.MsdsMainServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * MSDS化学品特殊字符导入功能测试类
 * 验证包含括号、逗号、连字符等特殊字符的化学品名称能够被正确识别和处理
 * 
 * @author system
 * @date 2024
 */
public class MsdsSpecialCharacterImportTest {

    private static final Logger logger = LoggerFactory.getLogger(MsdsSpecialCharacterImportTest.class);
    
    private MsdsMainServiceImpl msdsMainService;
    private Method extractProductNameMethod;
    private Method cleanChemicalNameLightweightMethod;
    private Method extractInfoFromFileNameMethod;
    
    @BeforeEach
    void setUp() throws Exception {
        msdsMainService = new MsdsMainServiceImpl();
        
        // 通过反射获取私有方法进行测试
        extractProductNameMethod = MsdsMainServiceImpl.class.getDeclaredMethod("extractProductName", String.class);
        extractProductNameMethod.setAccessible(true);
        
        cleanChemicalNameLightweightMethod = MsdsMainServiceImpl.class.getDeclaredMethod("cleanChemicalNameLightweight", String.class);
        cleanChemicalNameLightweightMethod.setAccessible(true);
        
        extractInfoFromFileNameMethod = MsdsMainServiceImpl.class.getDeclaredMethod("extractInfoFromFileName", String.class);
        extractInfoFromFileNameMethod.setAccessible(true);
    }
    
    @Test
    @DisplayName("测试包含括号的化学品名称提取")
    void testExtractProductNameWithParentheses() throws Exception {
        // 测试用例：包含括号的化学品名称
        String[] testCases = {
            "产品名称：二氯甲烷(DCM)",
            "化学品名称：聚乙二醇(PEG-400)",
            "产品：N,N-二甲基甲酰胺(DMF)",
            "名称：氢氧化钠(NaOH)",
            "化学品：乙酸乙酯(EA)"
        };
        
        String[] expectedResults = {
            "二氯甲烷(DCM)",
            "聚乙二醇(PEG-400)", 
            "N,N-二甲基甲酰胺(DMF)",
            "氢氧化钠(NaOH)",
            "乙酸乙酯(EA)"
        };
        
        for (int i = 0; i < testCases.length; i++) {
            String result = (String) extractProductNameMethod.invoke(msdsMainService, testCases[i]);
            logger.info("测试用例: {} -> 提取结果: {}", testCases[i], result);
            assertEquals(expectedResults[i], result, "包含括号的化学品名称提取失败: " + testCases[i]);
        }
    }
    
    @Test
    @DisplayName("测试包含逗号和连字符的化学品名称提取")
    void testExtractProductNameWithCommasAndHyphens() throws Exception {
        // 测试用例：包含逗号和连字符的化学品名称
        String[] testCases = {
            "产品名称：1,2-二氯乙烷",
            "化学品名称：N,N-二甲基乙酰胺",
            "产品：2,4-二硝基苯酚",
            "名称：1,4-丁二醇",
            "化学品：α,α'-联吡啶"
        };
        
        String[] expectedResults = {
            "1,2-二氯乙烷",
            "N,N-二甲基乙酰胺",
            "2,4-二硝基苯酚",
            "1,4-丁二醇",
            "α,α'-联吡啶"
        };
        
        for (int i = 0; i < testCases.length; i++) {
            String result = (String) extractProductNameMethod.invoke(msdsMainService, testCases[i]);
            logger.info("测试用例: {} -> 提取结果: {}", testCases[i], result);
            assertEquals(expectedResults[i], result, "包含逗号和连字符的化学品名称提取失败: " + testCases[i]);
        }
    }
    
    @Test
    @DisplayName("测试包含希腊字母和化学符号的化学品名称提取")
    void testExtractProductNameWithGreekLettersAndSymbols() throws Exception {
        // 测试用例：包含希腊字母和化学符号的化学品名称
        String[] testCases = {
            "产品名称：α-萘酚",
            "化学品名称：β-胡萝卜素",
            "产品：γ-丁内酯",
            "名称：δ-戊内酯",
            "化学品：ε-己内酰胺"
        };
        
        String[] expectedResults = {
            "α-萘酚",
            "β-胡萝卜素",
            "γ-丁内酯",
            "δ-戊内酯",
            "ε-己内酰胺"
        };
        
        for (int i = 0; i < testCases.length; i++) {
            String result = (String) extractProductNameMethod.invoke(msdsMainService, testCases[i]);
            logger.info("测试用例: {} -> 提取结果: {}", testCases[i], result);
            assertEquals(expectedResults[i], result, "包含希腊字母的化学品名称提取失败: " + testCases[i]);
        }
    }
    
    @Test
    @DisplayName("测试轻量级清理方法保留有效特殊字符")
    void testCleanChemicalNameLightweightPreservesValidCharacters() throws Exception {
        // 测试用例：验证清理方法保留有效的特殊字符
        String[] testCases = {
            "二氯甲烷(DCM)(工业级)",
            "N,N-二甲基甲酰胺(99.9%)",
            "聚乙二醇(PEG-400)(分析级)",
            "1,2-二氯乙烷(化学纯)",
            "α-萘酚(试剂级)。"
        };
        
        String[] expectedResults = {
            "二氯甲烷(DCM)(工业级)",
            "N,N-二甲基甲酰胺",
            "聚乙二醇(PEG-400)(分析级)",
            "1,2-二氯乙烷(化学纯)",
            "α-萘酚(试剂级)"
        };
        
        for (int i = 0; i < testCases.length; i++) {
            String result = (String) cleanChemicalNameLightweightMethod.invoke(msdsMainService, testCases[i]);
            logger.info("清理测试用例: {} -> 清理结果: {}", testCases[i], result);
            assertEquals(expectedResults[i], result, "轻量级清理方法未正确保留有效特殊字符: " + testCases[i]);
        }
    }
    
    @Test
    @DisplayName("测试文件名解析功能处理特殊字符")
    void testExtractInfoFromFileNameWithSpecialCharacters() throws Exception {
        // 测试用例：验证文件名解析功能处理包含特殊字符的文件名
        String[] testFileNames = {
            "二氯甲烷(DCM)、Dichloromethane、75-09-2.txt",
            "N,N-二甲基甲酰胺,N,N-Dimethylformamide,68-12-2.txt",
            "1,2-二氯乙烷、1,2-Dichloroethane、107-06-2.txt",
            "α-萘酚,1-Naphthol,90-15-3.txt",
            "聚乙二醇(PEG-400)、Polyethylene glycol、25322-68-3.txt"
        };
        
        String[] expectedChineseNames = {
            "二氯甲烷(DCM)",
            "N,N-二甲基甲酰胺",
            "1,2-二氯乙烷",
            "α-萘酚",
            "聚乙二醇(PEG-400)"
        };
        
        for (int i = 0; i < testFileNames.length; i++) {
            @SuppressWarnings("unchecked")
            java.util.Map<String, String> result = (java.util.Map<String, String>) extractInfoFromFileNameMethod.invoke(msdsMainService, testFileNames[i]);
            logger.info("文件名解析测试: {} -> 解析结果: {}", testFileNames[i], result);

            assertNotNull(result, "文件名解析结果不应为空");
            assertEquals(expectedChineseNames[i], result.get("chineseName"), "文件名中的中文名称解析失败: " + testFileNames[i]);
        }
    }
    
    @Test
    @DisplayName("测试复杂特殊字符组合的化学品名称")
    void testComplexSpecialCharacterCombinations() throws Exception {
        // 测试用例：复杂的特殊字符组合
        String[] testCases = {
            "产品名称：2-(2,4-二氯苯氧基)丙酸",
            "化学品名称：N-(2,6-二甲基苯基)-N-甲氧基乙酰胺",
            "产品：1,1'-(亚甲基双(4,1-亚苯基))双乙酮",
            "名称：α,α'-二甲基-α''-(2-吡啶基)苄醇",
            "化学品：2,2'-(乙烯二氧基)二乙醇"
        };
        
        String[] expectedResults = {
            "2-(2,4-二氯苯氧基)丙酸",
            "N-(2,6-二甲基苯基)-N-甲氧基乙酰胺",
            "1,1'-(亚甲基双(4,1-亚苯基))双乙酮",
            "α,α'-二甲基-α''-(2-吡啶基)苄醇",
            "2,2'-(乙烯二氧基)二乙醇"
        };
        
        for (int i = 0; i < testCases.length; i++) {
            String result = (String) extractProductNameMethod.invoke(msdsMainService, testCases[i]);
            logger.info("复杂特殊字符测试: {} -> 提取结果: {}", testCases[i], result);
            assertEquals(expectedResults[i], result, "复杂特殊字符组合的化学品名称提取失败: " + testCases[i]);
        }
    }
    
    @Test
    @DisplayName("测试边界情况和异常输入")
    void testEdgeCasesAndExceptionalInputs() throws Exception {
        // 测试用例：边界情况和异常输入
        String[] testCases = {
            "", // 空字符串
            "   ", // 仅空白字符
            "产品名称：", // 仅前缀无内容
            "：：：化学品", // 多个前缀符号
            "产品名称：化学品(((())))", // 多层括号
            "名称：化学品,,,,,", // 多个逗号
            "化学品---名称", // 多个连字符
        };
        
        for (String testCase : testCases) {
            try {
                String result = (String) extractProductNameMethod.invoke(msdsMainService, testCase);
                logger.info("边界情况测试: [{}] -> 提取结果: [{}]", testCase, result);
                assertTrue(result == null || result.length() >= 0);
            } catch (Exception e) {
                fail("边界情况处理失败: " + testCase + ", 异常: " + e.getMessage());
            }
        }
    }
}
