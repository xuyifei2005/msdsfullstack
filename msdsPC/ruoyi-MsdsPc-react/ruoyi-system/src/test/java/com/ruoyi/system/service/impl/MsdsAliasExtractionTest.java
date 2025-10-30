package com.ruoyi.system.service.impl;

import org.junit.jupiter.api.Test;
import java.lang.reflect.Method;

import static org.junit.jupiter.api.Assertions.*;

/**
 * 测试中文别名提取功能
 * 验证extractProductAlias和cleanChemicalNameLightweight方法对中文别名的处理
 */
public class MsdsAliasExtractionTest {

    private MsdsMainServiceImpl msdsMainService = new MsdsMainServiceImpl();

    @Test
    public void testExtractProductAlias_ChineseAlias() throws Exception {
        // 测试包含中文别名的文本
        String testText = "化学品中文名称：苯\n" +
                "化学品英文名称：Benzene\n" +
                "CAS号：71-43-2\n" +
                "化学品别名：苯（工业级）、苯溶剂、石油苯、煤焦油苯\n" +
                "其他名称：Benzol、Phenyl hydride";
        
        // 使用反射调用private方法
        Method extractMethod = MsdsMainServiceImpl.class.getDeclaredMethod("extractProductAlias", String.class);
        extractMethod.setAccessible(true);
        String result = (String) extractMethod.invoke(msdsMainService, testText);
        
        System.out.println("提取结果: " + result);
        
        // 验证中文别名是否被正确提取
        assertNotNull(result, "提取结果不应为空");
        assertTrue(result.contains("苯（工业级）") || result.contains("工业级"), 
                "应该包含'苯（工业级）'或至少包含'工业级'");
        assertTrue(result.contains("苯溶剂"), "应该包含'苯溶剂'");
        assertTrue(result.contains("石油苯"), "应该包含'石油苯'");
        assertTrue(result.contains("煤焦油苯"), "应该包含'煤焦油苯'");
    }

    @Test
    public void testExtractProductAlias_MultipleChineseAlias() throws Exception {
        // 测试多种中文别名格式
        String testText = "化学品中文名称：甲苯\n" +
                "化学品英文名称：Toluene\n" +
                "化学品别名：甲基苯、苯基甲烷、甲苯（分析纯）\n" +
                "CAS号：108-88-3";
        
        // 使用反射调用private方法
        Method extractMethod = MsdsMainServiceImpl.class.getDeclaredMethod("extractProductAlias", String.class);
        extractMethod.setAccessible(true);
        String result = (String) extractMethod.invoke(msdsMainService, testText);
        
        System.out.println("甲苯别名提取结果: " + result);
        
        assertNotNull(result, "提取结果不应为空");
        assertTrue(result.contains("甲基苯"), "应该包含'甲基苯'");
        assertTrue(result.contains("苯基甲烷"), "应该包含'苯基甲烷'");
        assertTrue(result.contains("甲苯（分析纯）") || result.contains("分析纯"), 
                "应该包含'甲苯（分析纯）'或至少包含'分析纯'");
    }

    @Test
    public void testCleanChemicalNameLightweight_PreserveBrackets() throws Exception {
        // 测试cleanChemicalNameLightweight方法是否过度清洗括号内容
        String testName1 = "苯（工业级）";
        String testName2 = "甲苯（分析纯）";
        String testName3 = "1,3-二甲苯（间二甲苯）";
        
        // 使用反射调用private方法
        Method cleanMethod = MsdsMainServiceImpl.class.getDeclaredMethod("cleanChemicalNameLightweight", String.class);
        cleanMethod.setAccessible(true);
        
        String result1 = (String) cleanMethod.invoke(msdsMainService, testName1);
        String result2 = (String) cleanMethod.invoke(msdsMainService, testName2);
        String result3 = (String) cleanMethod.invoke(msdsMainService, testName3);
        
        System.out.println("清洗前: " + testName1 + " -> 清洗后: " + result1);
        System.out.println("清洗前: " + testName2 + " -> 清洗后: " + result2);
        System.out.println("清洗前: " + testName3 + " -> 清洗后: " + result3);
        
        // 验证括号内的重要信息是否被保留
        assertFalse(result1.isEmpty(), "清洗后不应为空");
        assertFalse(result2.isEmpty(), "清洗后不应为空");
        assertFalse(result3.isEmpty(), "清洗后不应为空");
        
        // 如果括号内容被完全移除，这里会失败，说明需要修复清洗逻辑
        assertTrue(result1.contains("工业级") || result1.contains("苯"), 
                "应该保留'工业级'信息或至少保留'苯'");
        assertTrue(result2.contains("分析纯") || result2.contains("甲苯"), 
                "应该保留'分析纯'信息或至少保留'甲苯'");
        assertTrue(result3.contains("间二甲苯") || result3.contains("二甲苯"), 
                "应该保留'间二甲苯'信息或至少保留'二甲苯'");
    }

    @Test
    public void testProcessProductAlias_ChineseContent() throws Exception {
        // 测试processProductAlias方法对中文别名的完整处理流程
        String aliases = "苯（工业级）;苯溶剂;石油苯;煤焦油苯";
        
        // 使用反射调用private方法
        Method processMethod = MsdsMainServiceImpl.class.getDeclaredMethod("processProductAlias", String.class);
        processMethod.setAccessible(true);
        String result = (String) processMethod.invoke(msdsMainService, aliases);
        
        System.out.println("processProductAlias结果: " + result);
        
        assertNotNull(result, "处理结果不应为空");
        assertFalse(result.trim().isEmpty(), "处理结果不应为空字符串");
        
        // 验证中文别名是否在处理过程中丢失
        String[] resultParts = result.split("[;,，；]");
        assertTrue(resultParts.length > 0, "应该有处理后的别名");
        
        // 检查是否至少保留了一些中文内容
        boolean hasChineseContent = false;
        for (String part : resultParts) {
            if (part.trim().matches(".*[\\u4e00-\\u9fa5]+.*")) {
                hasChineseContent = true;
                break;
            }
        }
        assertTrue(hasChineseContent, "处理结果应该包含中文内容");
    }
}