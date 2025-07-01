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

            // 解析MSDS信息
            MsdsMain msdsMain = parseMsdsFromContent(content);
            if (msdsMain == null || StringUtils.isEmpty(msdsMain.getProductName()))
            {
                errorMessages.add(file.getOriginalFilename() + ": 无法解析出有效的MSDS信息");
                failureCount++;
                result.put("successCount", successCount);
                result.put("failureCount", failureCount);
                result.put("duplicates", duplicates);
                result.put("errorMessages", errorMessages);
                return result;
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
        MsdsMain msdsMain = new MsdsMain();
        
        // 解析第一部分：化学品及企业标识
        String productName = extractValue(content, "(?:化学品中文名称?|产品名称)\\s*[：:：]?\\s*([^\\n\\r]+)");
        String productEnglishName = extractValue(content, "(?:化学品英文名称?|英文名称?)\\s*[：:：]?\\s*([^\\n\\r]+)");
        String companyName = extractValue(content, "(?:企业名称|公司名称|供应商)\\s*[：:：]?\\s*([^\\n\\r]+)");
        String companyAddress = extractValue(content, "(?:企业地址|公司地址|地址)\\s*[：:：]?\\s*([^\\n\\r]+)");
        String contactPhone = extractValue(content, "(?:联系电话|电话|电话号码)\\s*[：:：]?\\s*([^\\n\\r]+)");
        String email = extractValue(content, "(?:电子邮件|邮箱|电子邮箱)\\s*[：:：]?\\s*([^\\n\\r]+)");
        String emergencyPhone = extractValue(content, "(?:应急电话|紧急联系电话)\\s*[：:：]?\\s*([^\\n\\r]+)");
        String version = extractValue(content, "(?:版本号|版本)\\s*[：:：]?\\s*([^\\n\\r]+)");
        
        // CAS号可能在别名字段中
        String casNumber = extractValue(content, "CAS\\s*[号#]?\\s*[：:：]?\\s*([0-9\\-]+)");
        
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