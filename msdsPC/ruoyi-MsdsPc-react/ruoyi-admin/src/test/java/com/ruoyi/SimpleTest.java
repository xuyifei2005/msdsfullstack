package com.ruoyi;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 * 简单测试类，用于验证测试环境配置
 */
public class SimpleTest {

    @Test
    public void testBasicAssertion() {
        assertTrue(true, "基本断言测试");
        assertEquals(2, 1 + 1, "数学运算测试");
    }

    @Test
    public void testStringOperations() {
        String expected = "Hello World";
        String actual = "Hello" + " " + "World";
        assertEquals(expected, actual, "字符串操作测试");
    }

    @Test
    public void testNotNull() {
        String value = "test";
        assertNotNull(value, "非空测试");
    }
}