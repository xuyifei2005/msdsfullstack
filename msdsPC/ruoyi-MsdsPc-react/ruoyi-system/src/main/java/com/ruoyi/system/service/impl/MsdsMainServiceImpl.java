package com.ruoyi.system.service.impl;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.apache.poi.hwpf.HWPFDocument;
import org.apache.poi.hwpf.extractor.WordExtractor;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.extractor.XWPFWordExtractor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.ruoyi.common.annotation.DataSource;
import com.ruoyi.common.core.text.Convert;
import com.ruoyi.common.enums.DataSourceType;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.file.MimeTypeUtils;
import com.ruoyi.system.domain.MsdsMain;
import com.ruoyi.system.mapper.MsdsMainMapper;
import com.ruoyi.system.service.IMsdsMainService;

/**
 * MSDS主信息 服务层实现
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
@Service
public class MsdsMainServiceImpl implements IMsdsMainService
{
    private static final Logger logger = LoggerFactory.getLogger(MsdsMainServiceImpl.class);
    
    @Autowired
    private MsdsMainMapper msdsMainMapper;

    /**
     * 查询MSDS主信息
     * 
     * @param id MSDS主键
     * @return MSDS主信息
     */
    @Override
    public MsdsMain selectMsdsMainById(Long id)
    {
        return msdsMainMapper.selectMsdsMainById(id);
    }

    /**
     * 查询MSDS主信息列表
     * 
     * @param msdsMain MSDS主信息
     * @return MSDS主信息
     */
    @Override
    public List<MsdsMain> selectMsdsMainList(MsdsMain msdsMain)
    {
        return msdsMainMapper.selectMsdsMainList(msdsMain);
    }

    /**
     * 根据化学品名称查询MSDS信息
     * 
     * @param productName 化学品名称
     * @return MSDS主信息
     */
    @Override
    public MsdsMain selectMsdsMainByProductName(String productName)
    {
        return msdsMainMapper.selectMsdsMainByProductName(productName);
    }

    /**
     * 新增MSDS主信息
     * 
     * @param msdsMain MSDS主信息
     * @return 结果
     */
    @Override
    public int insertMsdsMain(MsdsMain msdsMain)
    {
        // 设置默认值
        if (msdsMain.getIsActive() == null)
        {
            msdsMain.setIsActive(1);
        }
        return msdsMainMapper.insertMsdsMain(msdsMain);
    }

    /**
     * 修改MSDS主信息
     * 
     * @param msdsMain MSDS主信息
     * @return 结果
     */
    @Override
    public int updateMsdsMain(MsdsMain msdsMain)
    {
        return msdsMainMapper.updateMsdsMain(msdsMain);
    }

    /**
     * 批量删除MSDS主信息
     * 
     * @param ids 需要删除的MSDS主键
     * @return 结果
     */
    @Override
    public int deleteMsdsMainByIds(Long[] ids)
    {
        return msdsMainMapper.deleteMsdsMainByIds(ids);
    }

    /**
     * 删除MSDS主信息信息
     * 
     * @param id MSDS主键
     * @return 结果
     */
    @Override
    public int deleteMsdsMainById(Long id)
    {
        return msdsMainMapper.deleteMsdsMainById(id);
    }

    /**
     * 根据企业名称查询MSDS列表
     * 
     * @param companyName 企业名称
     * @return MSDS主信息集合
     */
    @Override
    public List<MsdsMain> selectMsdsMainByCompany(String companyName)
    {
        return msdsMainMapper.selectMsdsMainByCompany(companyName);
    }

    /**
     * 统计有效的MSDS数量
     * 
     * @return 数量
     */
    @Override
    public int countActiveMsds()
    {
        return msdsMainMapper.countActiveMsds();
    }

    /**
     * 校验化学品名称是否唯一
     * 
     * @param msdsMain MSDS信息
     * @return 结果
     */
    @Override
    public boolean checkProductNameUnique(MsdsMain msdsMain)
    {
        Long msdsId = StringUtils.isNull(msdsMain.getId()) ? -1L : msdsMain.getId();
        MsdsMain info = msdsMainMapper.checkProductNameUnique(msdsMain.getProductName());
        if (StringUtils.isNotNull(info) && info.getId().longValue() != msdsId.longValue())
        {
            return false;
        }
        return true;
    }

    /**
     * 启用/停用MSDS
     * 
     * @param msdsMain MSDS信息
     * @return 结果
     */
    @Override
    public int changeStatus(MsdsMain msdsMain)
    {
        return msdsMainMapper.updateMsdsMain(msdsMain);
    }

    /**
     * 导入MSDS文档
     * 
     * @param file 上传的文件
     * @param overwriteDuplicates 是否覆盖重复数据
     * @param createBy 创建人
     * @return 导入结果
     */
    @Override
    public Map<String, Object> importMsdsDocument(MultipartFile file, boolean overwriteDuplicates, String createBy) throws Exception
    {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, String>> duplicates = new ArrayList<>();
        int successCount = 0;
        int failureCount = 0;
        List<String> errorMessages = new ArrayList<>();

        try
        {
            // 验证文件格式
            if (!isValidFileType(file))
            {
                errorMessages.add(file.getOriginalFilename() + ": 不支持的文件格式");
                failureCount++;
                result.put("successCount", successCount);
                result.put("failureCount", failureCount);
                result.put("duplicates", duplicates);
                result.put("errorMessages", errorMessages);
                return result;
            }

            // 提取文档内容
            String content = extractTextFromFile(file);
            if (StringUtils.isEmpty(content))
            {
                errorMessages.add(file.getOriginalFilename() + ": 无法提取文档内容");
                failureCount++;
                result.put("successCount", successCount);
                result.put("failureCount", failureCount);
                result.put("duplicates", duplicates);
                result.put("errorMessages", errorMessages);
                return result;
            }
            
            // 调试：记录提取的内容片段
            logger.info("文件 {} 提取的内容前500字符：{}", file.getOriginalFilename(), 
                       content.length() > 500 ? content.substring(0, 500) + "..." : content);

            // 解析MSDS信息
            MsdsMain msdsMain = parseMsdsFromContent(content);
            if (msdsMain == null)
            {
                errorMessages.add(file.getOriginalFilename() + ": 无法解析文档内容");
                failureCount++;
                result.put("successCount", successCount);
                result.put("failureCount", failureCount);
                result.put("duplicates", duplicates);
                result.put("errorMessages", errorMessages);
                return result;
            }

            // 验证必要字段 - 放宽验证条件
            boolean hasValidData = false;
            StringBuilder missingFields = new StringBuilder();
            
            // 检查是否有化学品名称
            if (StringUtils.isNotEmpty(msdsMain.getProductName())) {
                hasValidData = true;
            } else {
                // 尝试使用文件名作为产品名称
                String fileName = file.getOriginalFilename();
                if (StringUtils.isNotEmpty(fileName)) {
                    // 移除文件扩展名
                    String productNameFromFile = fileName.replaceAll("\\.(pdf|doc|docx)$", "");
                    // 简化文件名
                    productNameFromFile = productNameFromFile.replaceAll("[、，,；;]+.*$", "");
                    if (productNameFromFile.length() > 3) {
                        msdsMain.setProductName(productNameFromFile);
                        hasValidData = true;
                    }
                }
            }
            
            // 检查企业名称，如果没有则设置默认值
            if (StringUtils.isEmpty(msdsMain.getCompanyName())) {
                msdsMain.setCompanyName("未知企业");
                missingFields.append("企业名称 ");
            }
            
            // 检查联系电话，如果没有则设置默认值
            if (StringUtils.isEmpty(msdsMain.getContactPhone())) {
                msdsMain.setContactPhone("未提供");
                missingFields.append("联系电话 ");
            }
            
            if (!hasValidData) {
                errorMessages.add(file.getOriginalFilename() + ": 无法解析出有效的MSDS信息（缺少化学品名称）");
                failureCount++;
                result.put("successCount", successCount);
                result.put("failureCount", failureCount);
                result.put("duplicates", duplicates);
                result.put("errorMessages", errorMessages);
                return result;
            }
            
            // 记录缺失的字段（仅作为警告，不影响导入）
            if (missingFields.length() > 0) {
                logger.warn("文件 {} 缺少以下字段：{}", file.getOriginalFilename(), missingFields.toString());
            }

            // 检查重复数据
            MsdsMain existingMsds = msdsMainMapper.selectMsdsMainByProductName(msdsMain.getProductName());
            if (existingMsds != null && !overwriteDuplicates)
            {
                Map<String, String> duplicate = new HashMap<>();
                duplicate.put("fileName", file.getOriginalFilename());
                duplicate.put("chemicalName", msdsMain.getProductName());
                duplicate.put("casNumber", msdsMain.getProductAlias() != null ? msdsMain.getProductAlias() : "");
                duplicates.add(duplicate);
                result.put("successCount", successCount);
                result.put("failureCount", failureCount);
                result.put("duplicates", duplicates);
                result.put("errorMessages", errorMessages);
                return result;
            }

            // 设置创建信息
            msdsMain.setCreateBy(createBy);
            msdsMain.setIsActive(1);

            // 保存或更新数据
            if (existingMsds != null && overwriteDuplicates)
            {
                msdsMain.setId(existingMsds.getId());
                msdsMain.setUpdateBy(createBy);
                msdsMainMapper.updateMsdsMain(msdsMain);
            }
            else
            {
                msdsMainMapper.insertMsdsMain(msdsMain);
            }

            successCount++;
        }
        catch (Exception e)
        {
            errorMessages.add(file.getOriginalFilename() + ": " + e.getMessage());
            failureCount++;
        }

        result.put("successCount", successCount);
        result.put("failureCount", failureCount);
        result.put("duplicates", duplicates);
        result.put("errorMessages", errorMessages);

        return result;
    }

    /**
     * 批量导入MSDS文档
     * 
     * @param files 上传的文件数组
     * @param overwriteDuplicates 是否覆盖重复数据
     * @param createBy 创建人
     * @return 导入结果
     */
    @Override
    public Map<String, Object> importMsdsDocuments(MultipartFile[] files, boolean overwriteDuplicates, String createBy) throws Exception
    {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, String>> duplicates = new ArrayList<>();
        int successCount = 0;
        int failureCount = 0;
        List<String> errorMessages = new ArrayList<>();

        for (MultipartFile file : files)
        {
            try
            {
                Map<String, Object> singleResult = importMsdsDocument(file, overwriteDuplicates, createBy);
                
                successCount += (Integer) singleResult.get("successCount");
                failureCount += (Integer) singleResult.get("failureCount");
                
                @SuppressWarnings("unchecked")
                List<Map<String, String>> singleDuplicates = (List<Map<String, String>>) singleResult.get("duplicates");
                if (singleDuplicates != null && !singleDuplicates.isEmpty())
                {
                    duplicates.addAll(singleDuplicates);
                }
                
                @SuppressWarnings("unchecked")
                List<String> singleErrorMessages = (List<String>) singleResult.get("errorMessages");
                if (singleErrorMessages != null && !singleErrorMessages.isEmpty())
                {
                    errorMessages.addAll(singleErrorMessages);
                }
            }
            catch (Exception e)
            {
                errorMessages.add(file.getOriginalFilename() + ": " + e.getMessage());
                failureCount++;
            }
        }

        result.put("successCount", successCount);
        result.put("failureCount", failureCount);
        result.put("duplicates", duplicates);
        result.put("errorMessages", errorMessages);

        return result;
    }

    /**
     * 下载MSDS导入模板
     * 
     * @param response HTTP响应对象
     */
    @Override
    public void downloadImportTemplate(HttpServletResponse response)
    {
        try
        {
            // 这里可以生成一个示例DOCX模板文件
            response.setContentType("application/vnd.openxmlformats-officedocument.wordprocessingml.document");
            response.setHeader("Content-Disposition", "attachment; filename=MSDS_Import_Template.docx");
            
            // 创建一个包含MSDS 15个部分格式的模板
            String templateContent = generateMsdsTemplate();
            response.getWriter().write(templateContent);
        }
        catch (Exception e)
        {
            throw new RuntimeException("模板下载失败", e);
        }
    }

    /**
     * 验证文件类型
     * 
     * @param file 上传文件
     * @return 是否有效
     */
    private boolean isValidFileType(MultipartFile file)
    {
        String fileName = file.getOriginalFilename();
        if (StringUtils.isEmpty(fileName))
        {
            return false;
        }
        
        String extension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
        return extension.equals(".pdf") || extension.equals(".doc") || extension.equals(".docx");
    }

    /**
     * 从文件中提取文本内容
     * 
     * @param file 上传文件
     * @return 文本内容
     * @throws Exception 处理异常
     */
    private String extractTextFromFile(MultipartFile file) throws Exception
    {
        String fileName = file.getOriginalFilename();
        String extension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
        
        try (InputStream inputStream = file.getInputStream())
        {
            switch (extension)
            {
                case ".pdf":
                    return extractTextFromPDF(inputStream);
                case ".doc":
                    return extractTextFromDOC(inputStream);
                case ".docx":
                    return extractTextFromDOCX(inputStream);
                default:
                    throw new IllegalArgumentException("不支持的文件格式: " + extension);
            }
        }
    }

    /**
     * 从PDF文件提取文本
     * 
     * @param inputStream 输入流
     * @return 文本内容
     * @throws IOException IO异常
     */
    private String extractTextFromPDF(InputStream inputStream) throws IOException
    {
        try (PDDocument document = PDDocument.load(inputStream))
        {
            PDFTextStripper stripper = new PDFTextStripper();
            return stripper.getText(document);
        }
    }

    /**
     * 从DOC文件提取文本
     * 
     * @param inputStream 输入流
     * @return 文本内容
     * @throws IOException IO异常
     */
    private String extractTextFromDOC(InputStream inputStream) throws IOException
    {
        try (HWPFDocument document = new HWPFDocument(inputStream);
             WordExtractor extractor = new WordExtractor(document))
        {
            return extractor.getText();
        }
    }

    /**
     * 从DOCX文件提取文本
     * 
     * @param inputStream 输入流
     * @return 文本内容
     * @throws IOException IO异常
     */
    private String extractTextFromDOCX(InputStream inputStream) throws IOException
    {
        try (XWPFDocument document = new XWPFDocument(inputStream);
             XWPFWordExtractor extractor = new XWPFWordExtractor(document))
        {
            return extractor.getText();
        }
    }

    /**
     * 从文档内容解析MSDS信息
     * 
     * @param content 文档内容
     * @return MSDS信息
     */
    private MsdsMain parseMsdsFromContent(String content)
    {
        if (StringUtils.isEmpty(content)) {
            return null;
        }

        MsdsMain msdsMain = new MsdsMain();
        
        // 清理内容，统一格式
        String cleanContent = preprocessContent(content);
        
        // 解析第一部分：化学品及企业标识
        // 化学品名称 - 支持多种格式
        String productName = extractProductName(cleanContent);
        String productEnglishName = extractProductEnglishName(cleanContent);
        String companyName = extractCompanyName(cleanContent);
        String companyAddress = extractCompanyAddress(cleanContent);
        String contactPhone = extractContactPhone(cleanContent);
        String email = extractEmail(cleanContent);
        String emergencyPhone = extractEmergencyPhone(cleanContent);
        String version = extractVersion(cleanContent);
        
        // CAS号
        String casNumber = extractCasNumber(cleanContent);
        
        // 设置解析出的信息
        msdsMain.setProductName(cleanText(productName));
        msdsMain.setProductEnglishName(cleanText(productEnglishName));
        msdsMain.setProductAlias(cleanText(casNumber)); // 临时将CAS号存在别名字段
        msdsMain.setCompanyName(cleanText(companyName));
        msdsMain.setCompanyAddress(cleanText(companyAddress));
        msdsMain.setContactPhone(cleanText(contactPhone));
        msdsMain.setEmail(cleanText(email));
        msdsMain.setEmergencyPhone(cleanText(emergencyPhone));
        msdsMain.setVersion(cleanText(version));
        
        return msdsMain;
    }

    /**
     * 预处理文档内容
     * 
     * @param content 原始内容
     * @return 清理后的内容
     */
    private String preprocessContent(String content) {
        if (StringUtils.isEmpty(content)) {
            return "";
        }
        
        // 移除多余的空白字符，统一换行符
        String cleaned = content.replaceAll("\\r\\n|\\r", "\n");
        // 移除多余空格
        cleaned = cleaned.replaceAll("[ \\t]+", " ");
        // 移除多余的换行
        cleaned = cleaned.replaceAll("\\n\\s*\\n", "\n");
        
        return cleaned;
    }

    /**
     * 提取化学品中文名称
     */
    private String extractProductName(String content) {
        String[] patterns = {
            "(?:化学品中文名称?|产品名称|中文名称|商品名|化学品名称)\\s*[：:：]?\\s*([^\\n\\r]+)",
            "(?:名称|Name)\\s*[：:：]\\s*([^\\n\\r，,；;]+)",
            "第一部分[^\\n]*\\n[^\\n]*名称[^：:：]*[：:：]\\s*([^\\n\\r]+)",
            "1\\s*化学品及企业标识[^\\n]*\\n[^\\n]*名称[^：:：]*[：:：]\\s*([^\\n\\r]+)"
        };
        
        for (String pattern : patterns) {
            String result = extractValue(content, pattern);
            if (StringUtils.isNotEmpty(result)) {
                return result;
            }
        }
        
        // 尝试从文件名中提取化学品名称
        return extractFromTitle(content);
    }

    /**
     * 提取化学品英文名称
     */
    private String extractProductEnglishName(String content) {
        String[] patterns = {
            "(?:化学品英文名称?|英文名称?|English\\s*Name)\\s*[：:：]?\\s*([^\\n\\r]+)",
            "(?:英文名|英文|English)\\s*[：:：]\\s*([^\\n\\r，,；;]+)",
            "Product\\s*name\\s*[：:：]\\s*([^\\n\\r]+)"
        };
        
        return extractMultiplePatterns(content, patterns);
    }

    /**
     * 提取企业名称
     */
    private String extractCompanyName(String content) {
        String[] patterns = {
            "(?:企业名称|公司名称|供应商|生产企业|制造商|Company)\\s*[：:：]?\\s*([^\\n\\r]+)",
            "(?:生产厂家|厂家|Manufacturer)\\s*[：:：]\\s*([^\\n\\r]+)",
            "Supplier\\s*[：:：]\\s*([^\\n\\r]+)"
        };
        
        return extractMultiplePatterns(content, patterns);
    }

    /**
     * 提取企业地址
     */
    private String extractCompanyAddress(String content) {
        String[] patterns = {
            "(?:企业地址|公司地址|地址|Address)\\s*[：:：]?\\s*([^\\n\\r]+)",
            "(?:生产地址|厂址)\\s*[：:：]\\s*([^\\n\\r]+)"
        };
        
        return extractMultiplePatterns(content, patterns);
    }

    /**
     * 提取联系电话
     */
    private String extractContactPhone(String content) {
        String[] patterns = {
            "(?:联系电话|电话|电话号码|Tel|Phone)\\s*[：:：]?\\s*([^\\n\\r]+)",
            "(?:电话|Tel)\\s*[：:：]\\s*([\\d\\-\\+\\(\\)\\s]+)",
            "联系方式\\s*[：:：]\\s*([^\\n\\r]+)"
        };
        
        return extractMultiplePatterns(content, patterns);
    }

    /**
     * 提取电子邮件
     */
    private String extractEmail(String content) {
        String[] patterns = {
            "(?:电子邮件|邮箱|电子邮箱|Email|E-mail)\\s*[：:：]?\\s*([^\\n\\r]+)",
            "([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,})"
        };
        
        return extractMultiplePatterns(content, patterns);
    }

    /**
     * 提取应急电话
     */
    private String extractEmergencyPhone(String content) {
        String[] patterns = {
            "(?:应急电话|紧急联系电话|Emergency|应急联系电话)\\s*[：:：]?\\s*([^\\n\\r]+)",
            "(?:急救电话|紧急电话)\\s*[：:：]\\s*([\\d\\-\\+\\(\\)\\s]+)"
        };
        
        return extractMultiplePatterns(content, patterns);
    }

    /**
     * 提取版本号
     */
    private String extractVersion(String content) {
        String[] patterns = {
            "(?:版本号|版本|Version)\\s*[：:：]?\\s*([^\\n\\r]+)",
            "V\\s*([\\d\\.]+)",
            "版本\\s*[：:：]\\s*([^\\n\\r]+)"
        };
        
        return extractMultiplePatterns(content, patterns);
    }

    /**
     * 提取CAS号
     */
    private String extractCasNumber(String content) {
        String[] patterns = {
            "CAS\\s*[号#]?\\s*[：:：]?\\s*([0-9\\-]+)",
            "CAS\\s*No\\.?\\s*[：:：]?\\s*([0-9\\-]+)",
            "CAS\\s*Registry\\s*Number\\s*[：:：]?\\s*([0-9\\-]+)",
            "([0-9]{1,7}-[0-9]{2}-[0-9]{1})"  // 标准CAS号格式
        };
        
        return extractMultiplePatterns(content, patterns);
    }

    /**
     * 从标题中提取化学品名称
     */
    private String extractFromTitle(String content) {
        // 从内容的前几行提取可能的化学品名称
        String[] lines = content.split("\\n");
        for (int i = 0; i < Math.min(5, lines.length); i++) {
            String line = lines[i].trim();
            if (line.length() > 3 && line.length() < 200 && 
                !line.contains("MSDS") && !line.contains("安全技术说明书") && 
                !line.contains("Material Safety Data Sheet")) {
                return line;
            }
        }
        return null;
    }

    /**
     * 使用多个正则表达式提取值
     */
    private String extractMultiplePatterns(String content, String[] patterns) {
        for (String pattern : patterns) {
            String result = extractValue(content, pattern);
            if (StringUtils.isNotEmpty(result)) {
                return result;
            }
        }
        return null;
    }

    /**
     * 使用正则表达式提取值
     * 
     * @param content 内容
     * @param pattern 正则模式
     * @return 提取的值
     */
    private String extractValue(String content, String pattern)
    {
        Pattern p = Pattern.compile(pattern, Pattern.CASE_INSENSITIVE | Pattern.MULTILINE);
        Matcher m = p.matcher(content);
        if (m.find())
        {
            return m.group(1).trim();
        }
        return null;
    }

    /**
     * 清理文本
     * 
     * @param text 原始文本
     * @return 清理后的文本
     */
    private String cleanText(String text)
    {
        if (StringUtils.isEmpty(text))
        {
            return null;
        }
        return text.replaceAll("\\s+", " ").trim();
    }

    /**
     * 生成MSDS模板内容
     * 
     * @return 模板内容
     */
    private String generateMsdsTemplate()
    {
        StringBuilder template = new StringBuilder();
        template.append("MSDS导入模板\n\n");
        template.append("第一部分：化学品及企业标识\n");
        template.append("化学品中文名称：[请填写]\n");
        template.append("化学品英文名称：[请填写]\n");
        template.append("CAS号：[请填写]\n");
        template.append("企业名称：[请填写]\n");
        template.append("企业地址：[请填写]\n");
        template.append("联系电话：[请填写]\n");
        template.append("电子邮件：[请填写]\n");
        template.append("应急电话：[请填写]\n");
        template.append("版本号：[请填写]\n\n");
        
        template.append("第二部分：危险性概述\n");
        template.append("[请按照MSDS标准格式填写后续14个部分的内容]\n\n");
        
        template.append("注意：请确保文档格式正确，以便系统能够准确解析MSDS信息。");
        
        return template.toString();
    }
} 