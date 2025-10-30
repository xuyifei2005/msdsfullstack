package com.ruoyi.system.service;

import com.ruoyi.system.service.impl.MsdsMainServiceImpl;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

import static org.junit.jupiter.api.Assertions.*;

/**
 * 简单的文本编码处理测试
 * 不依赖Spring容器和Mockito
 */
public class SimpleTextEncodingTest {
    
    private MsdsMainServiceImpl msdsMainService;
    
    @BeforeEach
    void setUp() {
        msdsMainService = new MsdsMainServiceImpl();
        // logger是static final字段，会自动初始化，无需手动设置
    }
    
    @Test
    public void testHandleTextEncodingMethod() {
        try {
            // 测试文本
            String testText = "测试文本：1,2,3,4,7,7-六氯双环[2,2,1]庚烯-(2)-双羟甲基-5,6-亚硫酸酯；硫丹";
            
            System.out.println("DEBUG: 开始测试handleTextEncoding方法");
            System.out.println("DEBUG: msdsMainService = " + msdsMainService);
            System.out.println("DEBUG: testText = " + testText);
            
            // 通过反射调用私有方法
            Method handleTextEncodingMethod = MsdsMainServiceImpl.class.getDeclaredMethod("handleTextEncoding", String.class);
            handleTextEncodingMethod.setAccessible(true);
            
            System.out.println("DEBUG: 准备调用handleTextEncoding方法");
            String result = (String) handleTextEncodingMethod.invoke(msdsMainService, testText);
            System.out.println("DEBUG: handleTextEncoding调用成功");
            System.out.println("DEBUG: result = " + result);
            
            assertNotNull(result, "处理结果不应为空");
            assertTrue(result.contains("六氯双环"), "应保留中文字符");
            
        } catch (Exception e) {
            e.printStackTrace();
            fail("测试失败: " + e.getClass().getSimpleName() + ": " + e.getMessage());
        }
    }
    
    @Test
    public void testHandleTextEncodingWithNull() {
        try {
            // 通过反射调用私有方法
            Method handleTextEncodingMethod = MsdsMainServiceImpl.class.getDeclaredMethod("handleTextEncoding", String.class);
            handleTextEncodingMethod.setAccessible(true);
            
            // 测试null输入
            String result = (String) handleTextEncodingMethod.invoke(msdsMainService, (String) null);
            assertNull(result, "null输入应返回null");
            
        } catch (Exception e) {
            e.printStackTrace();
            fail("null测试失败: " + e.getClass().getSimpleName() + ": " + e.getMessage());
        }
    }
    
    @Test
    public void testHandleTextEncodingWithEmpty() {
        try {
            // 通过反射调用私有方法
            Method handleTextEncodingMethod = MsdsMainServiceImpl.class.getDeclaredMethod("handleTextEncoding", String.class);
            handleTextEncodingMethod.setAccessible(true);
            
            // 测试空字符串输入
            String result = (String) handleTextEncodingMethod.invoke(msdsMainService, "");
            assertEquals("", result, "空字符串输入应返回空字符串");
            
        } catch (Exception e) {
            e.printStackTrace();
            fail("空字符串测试失败: " + e.getClass().getSimpleName() + ": " + e.getMessage());
        }
    }
}