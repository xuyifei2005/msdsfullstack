package com.ruoyi.system.service.impl;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.system.domain.vo.MsdsParseVo;
import com.ruoyi.system.service.IMsdsParserService;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * MSDS 解析服务实现
 */
@Service
public class MsdsParserServiceImpl implements IMsdsParserService {

    private static final Logger log = LoggerFactory.getLogger(MsdsParserServiceImpl.class);

    @Override
    public MsdsParseVo parseMsdsFile(MultipartFile file) {
        String filename = file.getOriginalFilename();
        if (filename == null || !filename.toLowerCase().endsWith(".pdf")) {
            throw new ServiceException("当前仅支持 PDF 格式文件的智能解析");
        }

        try (InputStream inputStream = file.getInputStream();
             PDDocument document = PDDocument.load(inputStream)) {
             
            if (document.isEncrypted()) {
                throw new ServiceException("无法解析加密的 PDF 文件");
            }

            PDFTextStripper stripper = new PDFTextStripper();
            stripper.setSortByPosition(true); // 尽量按视觉顺序排序
            String text = stripper.getText(document);
            
            // 限制处理文本长度，避免过长
            String content = text;
            if (text.length() > 5000) {
                content = text.substring(0, 5000);
            }
            
            return mockAiParsing(content);

        } catch (IOException e) {
            log.error("PDF解析失败", e);
            throw new ServiceException("PDF解析失败: " + e.getMessage());
        }
    }

    /**
     * 模拟 AI 解析过程 (MVP阶段使用正则提取)
     * 后续对接 LLM API
     */
    private MsdsParseVo mockAiParsing(String text) {
        MsdsParseVo vo = new MsdsParseVo();
        
        // 生成摘要
        vo.setRawTextSummary(text.substring(0, Math.min(text.length(), 200)) + "...");
        
        // 1. 简单的正则提取 CAS号
        // 匹配格式如: 64-17-5
        Pattern casPattern = Pattern.compile("\\b\\d{2,7}-\\d{2}-\\d\\b");
        Matcher casMatcher = casPattern.matcher(text);
        if (casMatcher.find()) {
            vo.setCasNo(casMatcher.group());
        }

        // 2. 尝试提取中文名
        // 常见格式: "化学品中文名: 乙醇" 或 "化学品中文名称：乙醇"
        Pattern nameCnPattern = Pattern.compile("化学品中文名[称]?[：:]?\\s*([\\u4e00-\\u9fa5]+)");
        Matcher nameCnMatcher = nameCnPattern.matcher(text);
        if (nameCnMatcher.find()) {
            vo.setChemicalNameCn(nameCnMatcher.group(1).trim());
        } else {
            // 如果没匹配到，尝试取第一行非空行作为名称 (假设第一行是大标题)
            String[] lines = text.split("\n");
            for (String line : lines) {
                if (line.trim().length() > 1 && line.trim().length() < 20) {
                    vo.setChemicalNameCn(line.trim());
                    break;
                }
            }
        }

        // 3. 尝试提取英文名
        Pattern nameEnPattern = Pattern.compile("化学品英文名[称]?[：:]?\\s*([a-zA-Z0-9\\s\\-]+)");
        Matcher nameEnMatcher = nameEnPattern.matcher(text);
        if (nameEnMatcher.find()) {
            vo.setChemicalNameEn(nameEnMatcher.group(1).trim());
        }

        // 4. 提取 GHS 分类 (模拟)
        List<String> categories = new ArrayList<>();
        if (text.contains("易燃液体")) categories.add("易燃液体");
        if (text.contains("急性毒性")) categories.add("急性毒性");
        if (text.contains("皮肤腐蚀")) categories.add("皮肤腐蚀/刺激");
        if (text.contains("眼刺激")) categories.add("严重眼损伤/眼刺激");
        vo.setHazardCategories(categories);

        // 5. 危险性说明 (H-Statement)
        List<String> hStatements = new ArrayList<>();
        Pattern hPattern = Pattern.compile("(H\\d{3}[^\\n]*)");
        Matcher hMatcher = hPattern.matcher(text);
        while (hMatcher.find()) {
            hStatements.add(hMatcher.group(1).trim());
        }
        vo.setHazardStatements(hStatements);
        
        // 6. 应急电话
        Pattern phonePattern = Pattern.compile("应急电话[：:]?\\s*([0-9\\-]+)");
        Matcher phoneMatcher = phonePattern.matcher(text);
        if (phoneMatcher.find()) {
            vo.setEmergencyPhone(phoneMatcher.group(1));
        }

        // 模拟置信度
        vo.setConfidence(85);

        return vo;
    }
}
