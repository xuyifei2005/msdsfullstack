package com.ruoyi.system.service;

import com.ruoyi.system.service.impl.MsdsMainServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockMultipartFile;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.nio.charset.StandardCharsets;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

public class MsdsMainServiceImplTest {

    private MsdsMainServiceImpl msdsMainService;
    private Method parseCSVLineMethod;
    private Method validateAndParseHeadersMethod;
    private Method validateCsvFileMethod;

    @BeforeEach
    void setUp() throws Exception {
        msdsMainService = new MsdsMainServiceImpl();
        parseCSVLineMethod = MsdsMainServiceImpl.class.getDeclaredMethod("parseCSVLine", String.class);
        parseCSVLineMethod.setAccessible(true);
        validateAndParseHeadersMethod = MsdsMainServiceImpl.class.getDeclaredMethod("validateAndParseHeaders", String[].class);
        validateAndParseHeadersMethod.setAccessible(true);
        validateCsvFileMethod = MsdsMainServiceImpl.class.getDeclaredMethod("validateCsvFile", org.springframework.web.multipart.MultipartFile.class);
        validateCsvFileMethod.setAccessible(true);
    }

    @Test
    void testValidateAndParseHeaders_valid() throws Exception {
        String headerLine = "化学品中文名,化学品英文名,CAS号,MSDS编号,企业名称";
        String[] headers = (String[]) parseCSVLineMethod.invoke(msdsMainService, headerLine);

        @SuppressWarnings("unchecked")
        Map<String, Integer> headerMap = (Map<String, Integer>) validateAndParseHeadersMethod.invoke(msdsMainService, (Object) headers);

        assertNotNull(headerMap);
        assertTrue(headerMap.containsKey("化学品中文名"));
        assertTrue(headerMap.containsKey("CAS号"));
        assertTrue(headerMap.containsKey("MSDS编号"));
    }

    @Test
    void testValidateAndParseHeaders_missingRequired() throws Exception {
        String headerLine = "化学品英文名,CAS号";
        String[] headers = (String[]) parseCSVLineMethod.invoke(msdsMainService, headerLine);

        Exception ex = assertThrows(Exception.class, () -> {
            try {
                validateAndParseHeadersMethod.invoke(msdsMainService, (Object) headers);
            } catch (InvocationTargetException e) {
                throw (Exception) e.getTargetException();
            }
        });

        assertTrue(ex.getMessage().contains("化学品中文名") || ex.getMessage().contains("MSDS编号"));
    }

    @Test
    void testValidateCsvFile_rejectsEmpty() {
        MockMultipartFile file = new MockMultipartFile(
                "file",
                "empty.csv",
                "text/csv",
                "".getBytes(StandardCharsets.UTF_8)
        );

        Exception ex = assertThrows(Exception.class, () -> {
            try {
                validateCsvFileMethod.invoke(msdsMainService, file);
            } catch (InvocationTargetException e) {
                throw (Exception) e.getTargetException();
            }
        });

        assertTrue(ex.getMessage().contains("不能为空"));
    }

    @Test
    void testValidateCsvFile_rejectsWrongExt() {
        MockMultipartFile file = new MockMultipartFile(
                "file",
                "data.txt",
                "text/plain",
                "a,b,c".getBytes(StandardCharsets.UTF_8)
        );

        Exception ex = assertThrows(Exception.class, () -> {
            try {
                validateCsvFileMethod.invoke(msdsMainService, file);
            } catch (InvocationTargetException e) {
                throw (Exception) e.getTargetException();
            }
        });

        assertTrue(ex.getMessage().contains("CSV") || ex.getMessage().contains("格式"));
    }
}

