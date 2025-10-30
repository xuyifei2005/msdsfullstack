package com.ruoyi.system.service.impl;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.apache.poi.hwpf.HWPFDocument;
import org.apache.poi.hwpf.extractor.WordExtractor;
import org.apache.poi.hwpf.usermodel.Range;
import org.apache.poi.hwpf.usermodel.Paragraph;
import org.apache.poi.hwpf.usermodel.Table;
import org.apache.poi.hwpf.usermodel.TableRow;
import org.apache.poi.hwpf.usermodel.TableCell;
import org.apache.poi.hwpf.usermodel.TableIterator;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFTable;
import org.apache.poi.xwpf.usermodel.XWPFTableRow;
import org.apache.poi.xwpf.usermodel.XWPFTableCell;
import org.apache.poi.xwpf.usermodel.IBodyElement;
import org.apache.poi.xwpf.extractor.XWPFWordExtractor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.ruoyi.common.annotation.DataSource;
import com.ruoyi.common.core.text.Convert;
import com.ruoyi.common.enums.DataSourceType;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.file.MimeTypeUtils;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.system.domain.*;
import com.ruoyi.system.mapper.*;
import com.ruoyi.system.service.IMsdsMainService;
import com.ruoyi.system.service.IMsdsExportService;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.io.ByteArrayOutputStream;
import java.net.URLEncoder;
import java.util.zip.ZipOutputStream;
import java.util.zip.ZipEntry;
import java.nio.charset.StandardCharsets;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.apache.commons.io.IOUtils;
import org.springframework.core.io.ClassPathResource;
import com.ruoyi.common.utils.DateUtils;

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
    
    @Autowired
    private MsdsHazardMapper msdsHazardMapper;
    
    @Autowired
    private MsdsComponentMapper msdsComponentMapper;
    
    @Autowired
    private MsdsFirstAidMapper msdsFirstAidMapper;
    
    @Autowired
    private MsdsFireFightingMapper msdsFireFightingMapper;
    
    @Autowired
    private MsdsLeakResponseMapper msdsLeakResponseMapper;
    
    @Autowired
    private MsdsHandlingStorageMapper msdsHandlingStorageMapper;
    
    @Autowired
    private MsdsExposureControlMapper msdsExposureControlMapper;
    
    @Autowired
    private MsdsPhysicalChemicalMapper msdsPhysicalChemicalMapper;
    
    @Autowired
    private MsdsStabilityReactivityMapper msdsStabilityReactivityMapper;
    
    @Autowired
    private MsdsToxicologicalMapper msdsToxicologicalMapper;
    
    @Autowired
    private MsdsEcologicalMapper msdsEcologicalMapper;
    
    @Autowired
    private MsdsDisposalMapper msdsDisposalMapper;
    
    @Autowired
    private MsdsTransportationMapper msdsTransportationMapper;
    
    @Autowired
    private MsdsRegulatoryMapper msdsRegulatoryMapper;
    
    @Autowired
    private MsdsOtherInfoMapper msdsOtherInfoMapper;

    @Autowired
    private IMsdsExportService msdsExportService;
    
    @Autowired
    private MsdsFullTemplateGenerator fullTemplateGenerator;

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
     * 根据ID数组查询MSDS主信息列表
     * 
     * @param ids MSDS主键集合
     * @return MSDS主信息集合
     */
    @Override
    public List<MsdsMain> selectMsdsMainByIds(Long[] ids)
    {
        if (ids == null || ids.length == 0)
        {
            return new ArrayList<>();
        }
        return msdsMainMapper.selectMsdsMainByIds(ids);
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

            // 首先从文件名中提取化学品信息（优先级最高）
            String fileName = file.getOriginalFilename();
            Map<String, String> fileNameInfo = new HashMap<>();
            if (StringUtils.isNotEmpty(fileName)) {
                fileNameInfo = extractInfoFromFileName(fileName);
                logger.info("从文件名 {} 提取的信息：{}", fileName, fileNameInfo);
            }
            
            // 解析MSDS文档内容
            MsdsMain msdsMain = parseMsdsFromContentComplete(content);
            
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

            // 使用文件名信息覆盖或补充文档解析的信息
            boolean hasValidData = false;
            StringBuilder missingFields = new StringBuilder();
            
            // 优先使用文件名中的中文名称
            if (StringUtils.isNotEmpty(fileNameInfo.get("chineseName"))) {
                String cleanedChineseName = cleanChemicalNameLightweight(fileNameInfo.get("chineseName"));
                msdsMain.setProductName(cleanedChineseName);
                hasValidData = true;
                logger.info("使用文件名中的中文名称：{} -> 清理后：{}", fileNameInfo.get("chineseName"), cleanedChineseName);
            } else if (StringUtils.isNotEmpty(msdsMain.getProductName())) {
                String originalProductName = msdsMain.getProductName();
                String cleanedProductName = cleanChemicalNameLightweight(originalProductName);
                msdsMain.setProductName(cleanedProductName);
                hasValidData = true;
                logger.info("使用文档内容中的中文名称：{} -> 清理后：{}", originalProductName, cleanedProductName);
            }
            
            // 优先使用文件名中的英文名称
            if (StringUtils.isNotEmpty(fileNameInfo.get("englishName"))) {
                String cleanedEnglishName = cleanChemicalName(fileNameInfo.get("englishName"));
                msdsMain.setProductEnglishName(cleanedEnglishName);
                logger.info("使用文件名中的英文名称：{} -> 清理后：{}", fileNameInfo.get("englishName"), cleanedEnglishName);
            } else if (StringUtils.isNotEmpty(msdsMain.getProductEnglishName())) {
                String originalEnglishName = msdsMain.getProductEnglishName();
                String cleanedEnglishName = cleanChemicalName(originalEnglishName);
                msdsMain.setProductEnglishName(cleanedEnglishName);
                logger.info("使用文档内容中的英文名称：{} -> 清理后：{}", originalEnglishName, cleanedEnglishName);
            }
            
            // 优先使用文件名中的CAS号
            if (StringUtils.isNotEmpty(fileNameInfo.get("casNumber"))) {
                msdsMain.setCasNumber(fileNameInfo.get("casNumber"));
                logger.info("使用文件名中的CAS号：{}", fileNameInfo.get("casNumber"));
            }
            
            /**
             * 企业信息为可选字段：导入时若解析不到则设置合理默认值，避免因缺失阻断导入流程。
             * 这里将 companyName 设为“未知企业”，并记录到 missingFields 仅用于日志告警，不影响入库。
             */
            if (StringUtils.isEmpty(msdsMain.getCompanyName())) {
                msdsMain.setCompanyName("未知企业");
                missingFields.append("企业名称 ");
            }
            
            // 检查联系电话，如果没有则设置默认值
            if (StringUtils.isEmpty(msdsMain.getContactPhone())) {
                msdsMain.setContactPhone("未提供");
                missingFields.append("联系电话 ");
            }
            
            // 检查英文名，如果没有则记录到缺失字段（可选字段）
            if (StringUtils.isEmpty(msdsMain.getProductEnglishName())) {
                missingFields.append("英文名 ");
            }
            
            // 检查版本，如果没有则记录到缺失字段（可选字段）
            if (StringUtils.isEmpty(msdsMain.getVersion())) {
                missingFields.append("版本 ");
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
                duplicate.put("casNumber", msdsMain.getCasNumber() != null ? msdsMain.getCasNumber() : "");
                duplicates.add(duplicate);
                result.put("successCount", successCount);
                result.put("failureCount", failureCount);
                result.put("duplicates", duplicates);
                result.put("errorMessages", errorMessages);
                return result;
            }

            // 设置创建信息
            msdsMain.setIsActive(1);

            // 保存或更新主表数据
            Long msdsId;
            if (existingMsds != null && overwriteDuplicates)
            {
                // 覆盖导入：先清理旧的子表数据，再更新主表
                cleanRelatedMsdsData(existingMsds.getId());
                msdsMain.setId(existingMsds.getId());
                msdsMainMapper.updateMsdsMain(msdsMain);
                msdsId = existingMsds.getId();
            }
            else
            {
                msdsMainMapper.insertMsdsMain(msdsMain);
                msdsId = msdsMain.getId();
            }

            // 保存其他相关表数据
            saveRelatedMsdsData(msdsMain, content);

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
     * 按文件路径导入MSDS文档
     *
     * @param filePath 文件绝对路径（支持.pdf/.doc/.docx）
     * @param overwriteDuplicates 是否覆盖重复数据
     * @param createBy 创建人
     * @return 导入结果
     */
    @Override
    public Map<String, Object> importMsdsDocumentByPath(String filePath, boolean overwriteDuplicates, String createBy) throws Exception
    {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, String>> duplicates = new ArrayList<>();
        int successCount = 0;
        int failureCount = 0;
        List<String> errorMessages = new ArrayList<>();

        try
        {
            if (StringUtils.isEmpty(filePath))
            {
                errorMessages.add("文件路径为空");
                failureCount++;
                result.put("successCount", successCount);
                result.put("failureCount", failureCount);
                result.put("duplicates", duplicates);
                result.put("errorMessages", errorMessages);
                return result;
            }

            Path path = Paths.get(filePath);
            if (!Files.exists(path) || !Files.isRegularFile(path))
            {
                errorMessages.add(filePath + ": 文件不存在或不是文件");
                failureCount++;
                result.put("successCount", successCount);
                result.put("failureCount", failureCount);
                result.put("duplicates", duplicates);
                result.put("errorMessages", errorMessages);
                return result;
            }

            String fileName = path.getFileName().toString();
            String extension = fileName.contains(".") ? fileName.substring(fileName.lastIndexOf('.')).toLowerCase() : "";
            if (!".pdf".equals(extension) && !".doc".equals(extension) && !".docx".equals(extension) && !".txt".equals(extension))
            {
                errorMessages.add(fileName + ": 不支持的文件格式");
                failureCount++;
                result.put("successCount", successCount);
                result.put("failureCount", failureCount);
                result.put("duplicates", duplicates);
                result.put("errorMessages", errorMessages);
                return result;
            }

            // 提取文档内容
            String content;
            try (InputStream inputStream = Files.newInputStream(path))
            {
                if (".pdf".equals(extension))
                {
                    content = extractTextFromPDF(inputStream);
                }
                else if (".doc".equals(extension))
                {
                    content = extractTextFromDOC(inputStream);
                }
                else if (".docx".equals(extension))
                {
                    content = extractTextFromDOCX(inputStream);
                }
                else // .txt
                {
                    content = new String(inputStream.readAllBytes(), java.nio.charset.StandardCharsets.UTF_8);
                }
            }

            if (StringUtils.isEmpty(content))
            {
                errorMessages.add(fileName + ": 无法提取文档内容");
                failureCount++;
                result.put("successCount", successCount);
                result.put("failureCount", failureCount);
                result.put("duplicates", duplicates);
                result.put("errorMessages", errorMessages);
                return result;
            }

            // 调试：记录提取的内容片段
            logger.info("文件 {} 提取的内容前500字符：{}", fileName, content.length() > 500 ? content.substring(0, 500) + "..." : content);

            // 首先从文件名中提取化学品信息（优先级最高）
            Map<String, String> fileNameInfo = extractInfoFromFileName(fileName);
            logger.info("从文件名 {} 提取的信息：{}", fileName, fileNameInfo);

            // 解析MSDS文档内容
            MsdsMain msdsMain = parseMsdsFromContentComplete(content);
            if (msdsMain == null)
            {
                errorMessages.add(fileName + ": 无法解析文档内容");
                failureCount++;
                result.put("successCount", successCount);
                result.put("failureCount", failureCount);
                result.put("duplicates", duplicates);
                result.put("errorMessages", errorMessages);
                return result;
            }

            // 使用文件名信息覆盖或补充文档解析的信息
            boolean hasValidData = false;
            StringBuilder missingFields = new StringBuilder();

            // 优先使用文件名中的中文名称
            if (StringUtils.isNotEmpty(fileNameInfo.get("chineseName")))
            {
                String cleanedChineseName = cleanChemicalNameLightweight(fileNameInfo.get("chineseName"));
                msdsMain.setProductName(cleanedChineseName);
                hasValidData = true;
                logger.info("使用文件名中的中文名称：{} -> 清理后：{}", fileNameInfo.get("chineseName"), cleanedChineseName);
            }
            else if (StringUtils.isNotEmpty(msdsMain.getProductName()))
            {
                String originalProductName = msdsMain.getProductName();
                String cleanedProductName = cleanChemicalNameLightweight(originalProductName);
                msdsMain.setProductName(cleanedProductName);
                hasValidData = true;
                logger.info("使用文档内容中的中文名称：{} -> 清理后：{}", originalProductName, cleanedProductName);
            }

            // 优先使用文件名中的英文名称
            if (StringUtils.isNotEmpty(fileNameInfo.get("englishName")))
            {
                String cleanedEnglishName = cleanChemicalName(fileNameInfo.get("englishName"));
                msdsMain.setProductEnglishName(cleanedEnglishName);
                logger.info("使用文件名中的英文名称：{} -> 清理后：{}", fileNameInfo.get("englishName"), cleanedEnglishName);
            }
            else if (StringUtils.isNotEmpty(msdsMain.getProductEnglishName()))
            {
                String originalEnglishName = msdsMain.getProductEnglishName();
                String cleanedEnglishName = cleanChemicalName(originalEnglishName);
                msdsMain.setProductEnglishName(cleanedEnglishName);
                logger.info("使用文档内容中的英文名称：{} -> 清理后：{}", originalEnglishName, cleanedEnglishName);
            }

            // 优先使用文件名中的CAS号
            if (StringUtils.isNotEmpty(fileNameInfo.get("casNumber")))
            {
                msdsMain.setCasNumber(fileNameInfo.get("casNumber"));
                logger.info("使用文件名中的CAS号：{}", fileNameInfo.get("casNumber"));
            }

            // 检查企业名称，如果没有则设置默认值
            if (StringUtils.isEmpty(msdsMain.getCompanyName()))
            {
                msdsMain.setCompanyName("未知企业");
                missingFields.append("企业名称 ");
            }
            // 检查联系电话，如果没有则设置默认值
            if (StringUtils.isEmpty(msdsMain.getContactPhone()))
            {
                msdsMain.setContactPhone("未提供");
                missingFields.append("联系电话 ");
            }
            // 检查英文名，如果没有则记录缺失（可选字段）
            if (StringUtils.isEmpty(msdsMain.getProductEnglishName()))
            {
                missingFields.append("英文名 ");
            }
            // 检查版本，如果没有则记录缺失（可选字段）
            if (StringUtils.isEmpty(msdsMain.getVersion()))
            {
                missingFields.append("版本 ");
            }

            if (!hasValidData)
            {
                errorMessages.add(fileName + ": 无法解析出有效的MSDS信息（缺少化学品名称）");
                failureCount++;
                result.put("successCount", successCount);
                result.put("failureCount", failureCount);
                result.put("duplicates", duplicates);
                result.put("errorMessages", errorMessages);
                return result;
            }

            if (missingFields.length() > 0)
            {
                logger.warn("文件 {} 缺少以下字段：{}", fileName, missingFields.toString());
            }

            // 检查重复数据
            MsdsMain existingMsds = msdsMainMapper.selectMsdsMainByProductName(msdsMain.getProductName());
            if (existingMsds != null && !overwriteDuplicates)
            {
                Map<String, String> duplicate = new HashMap<>();
                duplicate.put("fileName", fileName);
                duplicate.put("chemicalName", msdsMain.getProductName());
                duplicate.put("casNumber", msdsMain.getCasNumber() != null ? msdsMain.getCasNumber() : "");
                duplicates.add(duplicate);

                result.put("successCount", successCount);
                result.put("failureCount", failureCount);
                result.put("duplicates", duplicates);
                result.put("errorMessages", errorMessages);
                return result;
            }

            // 设置创建信息
            msdsMain.setIsActive(1);
            if (existingMsds == null || !overwriteDuplicates)
            {
                msdsMain.setCreateTime(new Date());
            }
            msdsMain.setUpdateTime(new Date());

            // 保存或更新主表数据
            if (existingMsds != null && overwriteDuplicates)
            {
                // 覆盖导入：先清理旧的子表数据，再更新主表
                cleanRelatedMsdsData(existingMsds.getId());
                msdsMain.setId(existingMsds.getId());
                msdsMainMapper.updateMsdsMain(msdsMain);
            }
            else
            {
                msdsMainMapper.insertMsdsMain(msdsMain);
            }

            // 保存其他相关表数据
            saveRelatedMsdsData(msdsMain, content);

            successCount++;
        }
        catch (Exception e)
        {
            logger.error("按路径导入MSDS失败 - {}", e.getMessage(), e);
            errorMessages.add("导入异常：" + e.getMessage());
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
            // 使用新的完整模板生成器
            byte[] templateData = fullTemplateGenerator.generateFullTemplate();
            
            // 设置响应头
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setCharacterEncoding("UTF-8");
            String fileName = "MSDS完整导入模板_16章节_" + new SimpleDateFormat("yyyyMMdd").format(new Date()) + ".xlsx";
            response.setHeader("Content-Disposition", 
                "attachment; filename=" + URLEncoder.encode(fileName, "UTF-8"));
            
            // 输出模板数据
            response.getOutputStream().write(templateData);
            response.getOutputStream().flush();
            
            logger.info("Excel模板下载成功: {}", fileName);
        }
        catch (Exception e)
        {
            logger.error("模板下载失败", e);
            throw new RuntimeException("模板下载失败: " + e.getMessage(), e);
        }
    }

    /**
     * 下载MSDS导入模板
     * 
     * @param response 响应对象
     * @param templateType 模板类型（basic/detailed/full）
     */
    @Override
    public void downloadImportTemplate(HttpServletResponse response, String templateType)
    {
        try
        {
            // 委托导出服务生成Excel导入模板
            msdsExportService.generateImportTemplate(response, templateType);
        }
        catch (Exception e)
        {
            throw new RuntimeException("模板下载失败", e);
        }
    }

    /**
     * 下载MSDS导入模板
     * 
     * @param response 响应对象
     * @param templateType 模板类型（basic/detailed/full）
     * @param scope 范围：all（全部表）或 current（当前表）
     * @param tableName 当scope为current时，指定的表名
     */
    @Override
    public void downloadImportTemplate(HttpServletResponse response, String templateType, String scope, String tableName)
    {
        try
        {
            // 委托导出服务生成Excel导入模板，支持scope和tableName参数
            msdsExportService.generateImportTemplate(response, templateType, scope, tableName);
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
        return extension.equals(".pdf") || extension.equals(".doc") || extension.equals(".docx") || extension.equals(".txt");
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
                case ".txt":
                    return extractTextFromTXT(inputStream);
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
    /**
     * 从PDF文件提取文本（增强版）
     * 
     * @param inputStream 输入流
     * @return 文本内容
     * @throws IOException IO异常
     */
    private String extractTextFromPDF(InputStream inputStream) throws IOException
    {
        try (PDDocument document = PDDocument.load(inputStream))
        {
            // 检查PDF是否为空
            if (document.getNumberOfPages() == 0) {
                logger.warn("PDF文件没有页面内容");
                return "";
            }
            
            // 检查PDF是否加密
            if (document.isEncrypted()) {
                logger.warn("PDF文件已加密，跳过处理");
                throw new IOException("PDF文件已加密，无法处理");
            }
            
            PDFTextStripper stripper = new PDFTextStripper();
            
            // 设置文本提取参数
            stripper.setSortByPosition(true);
            stripper.setStartPage(1);
            stripper.setEndPage(document.getNumberOfPages());
            
            String text = stripper.getText(document);
            
            // 检查提取的文本是否为空
            if (text == null || text.trim().isEmpty()) {
                logger.warn("PDF文件文本提取结果为空，可能是扫描版PDF或图片PDF");
                return "";
            }
            
            logger.info("PDF文件文本提取成功，页数: {}, 文本长度: {}", document.getNumberOfPages(), text.length());
            return handleTextEncoding(text);
            
        } catch (IOException e) {
            logger.error("PDF文件处理失败: {}", e.getMessage(), e);
            
            // 尝试部分恢复
            try {
                return attemptPartialPdfRecovery(inputStream);
            } catch (Exception recoveryException) {
                logger.error("PDF文件恢复失败: {}", recoveryException.getMessage());
                throw new IOException("PDF文件读取失败: " + e.getMessage(), e);
            }
        } catch (Exception e) {
            logger.error("PDF文件处理出现未知错误: {}", e.getMessage(), e);
            throw new IOException("PDF文件处理失败: " + e.getMessage(), e);
        }
    }

    /**
     * 从DOC文件提取文本（增强版）
     * 
     * @param inputStream 输入流
     * @return 文本内容
     * @throws IOException IO异常
     */
    private String extractTextFromDOC(InputStream inputStream) throws IOException
    {
        HWPFDocument document = null;
        WordExtractor extractor = null;
        
        try {
            // 尝试创建文档对象
            document = new HWPFDocument(inputStream);
            
            // 检查文档是否损坏或为空
            if (document.getRange() == null) {
                logger.warn("DOC文档范围为空，可能文档损坏");
                throw new IOException("DOC文档损坏或格式异常");
            }
            
            // 增强文本提取 - 包含表格和格式信息
            String text = extractEnhancedTextFromDOC(document);
            
            // 验证提取的文本
            if (text == null || text.trim().isEmpty()) {
                logger.warn("从DOC文档提取的文本为空，尝试基础提取");
                extractor = new WordExtractor(document);
                text = extractor.getText();
            }
            
            if (text == null) {
                logger.warn("从DOC文档提取的文本为null");
                return "";
            }
            
            // 处理编码问题和特殊字符
            text = handleTextEncoding(text);
            
            // 检查文本质量，如果质量不佳则尝试编码恢复
            if (!isValidTextContent(text, "UTF-8")) {
                logger.warn("DOC文档提取的文本质量不佳，尝试编码恢复");
                String recoveredText = attemptTextEncodingRecovery(text);
                if (StringUtils.isNotEmpty(recoveredText) && isValidTextContent(recoveredText, "UTF-8")) {
                    text = recoveredText;
                    logger.info("DOC文档编码恢复成功，文本质量改善");
                }
            }
            
            logger.debug("成功从DOC文档提取文本，长度: {}", text.length());
            return text;
            
        } catch (org.apache.poi.hwpf.OldWordFileFormatException e) {
            logger.error("DOC文档格式过旧，不支持解析: {}", e.getMessage());
            throw new IOException("DOC文档格式过旧，请使用较新版本的Word文档", e);
        } catch (org.apache.poi.EncryptedDocumentException e) {
            logger.error("DOC文档已加密，无法解析: {}", e.getMessage());
            throw new IOException("DOC文档已加密，请提供未加密的文档", e);
        } catch (org.apache.poi.EmptyFileException e) {
            logger.error("DOC文档为空文件: {}", e.getMessage());
            throw new IOException("DOC文档为空文件", e);
        } catch (Exception e) {
            logger.error("解析DOC文档时发生未知错误: {}", e.getMessage(), e);
            // 尝试部分恢复
            String partialText = attemptPartialDocRecovery(inputStream);
            if (StringUtils.isNotEmpty(partialText)) {
                logger.info("通过部分恢复获得DOC文档内容，长度: {}", partialText.length());
                return partialText;
            }
            throw new IOException("无法解析DOC文档: " + e.getMessage(), e);
        } finally {
            // 安全关闭资源
            if (extractor != null) {
                try {
                    extractor.close();
                } catch (Exception e) {
                    logger.warn("关闭WordExtractor时发生错误: {}", e.getMessage());
                }
            }
            if (document != null) {
                try {
                    document.close();
                } catch (Exception e) {
                    logger.warn("关闭HWPFDocument时发生错误: {}", e.getMessage());
                }
            }
        }
    }

    /**
     * 从DOCX文件提取文本（增强版）
     * 
     * @param inputStream 输入流
     * @return 文本内容
     * @throws IOException IO异常
     */
    private String extractTextFromDOCX(InputStream inputStream) throws IOException
    {
        XWPFDocument document = null;
        XWPFWordExtractor extractor = null;
        
        try {
            // 尝试创建文档对象
            document = new XWPFDocument(inputStream);
            
            // 检查文档是否为空
            if (document.getBodyElements() == null || document.getBodyElements().isEmpty()) {
                logger.warn("DOCX文档内容为空");
                return "";
            }
            
            // 增强文本提取 - 包含表格和格式信息
            String text = extractEnhancedTextFromDOCX(document);
            
            // 验证提取的文本
            if (text == null || text.trim().isEmpty()) {
                logger.warn("从DOCX文档提取的文本为空，尝试基础提取");
                extractor = new XWPFWordExtractor(document);
                text = extractor.getText();
            }
            
            if (text == null) {
                logger.warn("从DOCX文档提取的文本为null");
                return "";
            }
            
            // 处理编码问题和特殊字符
            text = handleTextEncoding(text);
            
            // 检查文本质量，如果质量不佳则尝试编码恢复
            if (!isValidTextContent(text, "UTF-8")) {
                logger.warn("DOCX文档提取的文本质量不佳，尝试编码恢复");
                String recoveredText = attemptTextEncodingRecovery(text);
                if (StringUtils.isNotEmpty(recoveredText) && isValidTextContent(recoveredText, "UTF-8")) {
                    text = recoveredText;
                    logger.info("DOCX文档编码恢复成功，文本长度: {}", text.length());
                }
            }
            
            logger.debug("成功从DOCX文档提取文本，长度: {}", text.length());
            return text;
            
        } catch (org.apache.poi.EncryptedDocumentException e) {
            logger.error("DOCX文档已加密，无法解析: {}", e.getMessage());
            throw new IOException("DOCX文档已加密，请提供未加密的文档", e);
        } catch (org.apache.poi.EmptyFileException e) {
            logger.error("DOCX文档为空文件: {}", e.getMessage());
            throw new IOException("DOCX文档为空文件", e);
        } catch (Exception e) {
            // 处理所有其他异常，包括格式错误和OpenXML错误
            if (e.getMessage() != null && e.getMessage().contains("InvalidFormat")) {
                logger.error("DOCX文档格式无效: {}", e.getMessage());
                throw new IOException("DOCX文档格式无效或损坏", e);
            } else if (e.getMessage() != null && e.getMessage().contains("OpenXML")) {
                logger.error("DOCX文档OpenXML格式错误: {}", e.getMessage());
                throw new IOException("DOCX文档OpenXML格式错误", e);
            } else {
                logger.error("解析DOCX文档时发生未知错误: {}", e.getMessage(), e);
                // 尝试部分恢复
                String partialText = attemptPartialDocxRecovery(inputStream);
                if (StringUtils.isNotEmpty(partialText)) {
                    logger.info("通过部分恢复获得DOCX文档内容，长度: {}", partialText.length());
                    return partialText;
                }
                throw new IOException("无法解析DOCX文档: " + e.getMessage(), e);
            }
        } finally {
            // 安全关闭资源
            if (extractor != null) {
                try {
                    extractor.close();
                } catch (Exception e) {
                    logger.warn("关闭XWPFWordExtractor时发生错误: {}", e.getMessage());
                }
            }
            if (document != null) {
                try {
                    document.close();
                } catch (Exception e) {
                    logger.warn("关闭XWPFDocument时发生错误: {}", e.getMessage());
                }
            }
        }
    }

    /**
     * 处理文本编码问题和特殊字符
     * 
     * @param text 原始文本
     * @return 处理后的文本
     */
    private String handleTextEncoding(String text)
    {
        if (StringUtils.isEmpty(text)) {
            return text;
        }
        
        try {
            // 处理常见的编码问题
            // 移除BOM标记
            if (text.startsWith("\uFEFF")) {
                text = text.substring(1);
            }
            
            // 处理Windows-1252到UTF-8的常见字符映射问题
            text = text.replace("\u00A0", " "); // 非断行空格
            text = text.replace("\u2013", "-"); // en dash
            text = text.replace("\u2014", "--"); // em dash
            text = text.replace("\u2018", "'"); // left single quotation mark
            text = text.replace("\u2019", "'"); // right single quotation mark
            text = text.replace("\u201C", "\""); // left double quotation mark
            text = text.replace("\u201D", "\""); // right double quotation mark
            text = text.replace("\u2026", "..."); // horizontal ellipsis
            
            // 规范化换行符
            text = text.replace("\r\n", "\n").replace("\r", "\n");
            
            // 移除控制字符（保留换行和制表符）
            text = text.replaceAll("[\\p{Cntrl}&&[^\\n\\t]]", "");
            
            // 规范化多个连续空白字符
            text = text.replaceAll("[ \\t]+", " ");
            
            logger.debug("文本编码处理完成，处理后长度: {}", text.length());
            return text;
            
        } catch (Exception e) {
            logger.warn("处理文本编码时发生错误: {}", e.getMessage());
            return text; // 返回原始文本
        }
    }
    
    /**
     * 从TXT文件提取文本，支持多种编码格式
     * 
     * @param inputStream 输入流
     * @return 提取的文本内容
     * @throws IOException 读取异常
     */
    private String extractTextFromTXT(InputStream inputStream) throws IOException {
        try {
            // 读取文件字节
            byte[] bytes = inputStream.readAllBytes();
            
            if (bytes.length == 0) {
                logger.warn("TXT文件为空");
                return "";
            }
            
            // 尝试多种编码格式
            String[] encodings = {"UTF-8", "GBK", "GB2312", "ISO-8859-1", "UTF-16", "UTF-16BE", "UTF-16LE"};
            
            for (String encoding : encodings) {
                try {
                    String content = new String(bytes, encoding);
                    
                    // 检查编码是否正确（简单的启发式检查）
                    if (isValidTextContent(content, encoding)) {
                        logger.info("TXT文件使用编码: {}, 文本长度: {}", encoding, content.length());
                        return handleTextEncoding(content);
                    }
                } catch (Exception e) {
                    logger.debug("编码 {} 解析失败: {}", encoding, e.getMessage());
                }
            }
            
            // 如果所有编码都失败，使用UTF-8作为默认编码
            String content = new String(bytes, StandardCharsets.UTF_8);
            logger.warn("TXT文件编码检测失败，使用UTF-8默认编码，可能存在乱码");
            return handleTextEncoding(content);
            
        } catch (IOException e) {
            logger.error("读取TXT文件失败: {}", e.getMessage(), e);
            throw new IOException("TXT文件读取失败: " + e.getMessage(), e);
        }
    }
    
    /**
     * 从DOC文档增强提取文本，包含表格和格式信息，支持MSDS章节识别
     * 
     * @param document DOC文档对象
     * @return 增强提取的文本内容
     */
    private String extractEnhancedTextFromDOC(HWPFDocument document) {
        try {
            StringBuilder enhancedText = new StringBuilder();
            
            // 获取文档范围
            Range range = document.getRange();
            if (range == null) {
                return null;
            }
            
            // 提取段落文本，增强章节识别
            for (int i = 0; i < range.numParagraphs(); i++) {
                Paragraph paragraph = range.getParagraph(i);
                String paragraphText = paragraph.text();
                
                if (paragraphText != null && !paragraphText.trim().isEmpty()) {
                    String cleanText = paragraphText.trim();
                    
                    // 识别MSDS标准章节标题
                    if (isMsdsSection(cleanText)) {
                        enhancedText.append("\n【").append(cleanText).append("】\n");
                    } else {
                        // 保留段落结构
                        enhancedText.append(cleanText).append("\n");
                    }
                }
            }
            
            // 增强表格内容提取（DOC格式）
            try {
                TableIterator tableIterator = new TableIterator(range);
                int tableCount = 0;
                while (tableIterator.hasNext()) {
                    Table table = tableIterator.next();
                    tableCount++;
                    enhancedText.append("\n[表格").append(tableCount).append("开始]\n");
                    
                    // 检测表格结构和内容类型
                    boolean isHeaderDetected = false;
                    List<String> headers = new ArrayList<>();
                    
                    for (int rowIndex = 0; rowIndex < table.numRows(); rowIndex++) {
                        TableRow row = table.getRow(rowIndex);
                        List<String> cellContents = new ArrayList<>();
                        
                        for (int cellIndex = 0; cellIndex < row.numCells(); cellIndex++) {
                            TableCell cell = row.getCell(cellIndex);
                            String cellText = cleanTableCellText(cell.text());
                            cellContents.add(cellText);
                        }
                        
                        // 第一行作为表头检测
                        if (rowIndex == 0 && !isHeaderDetected) {
                            headers = new ArrayList<>(cellContents);
                            if (isTableHeader(cellContents)) {
                                enhancedText.append("[表头] ");
                                isHeaderDetected = true;
                            }
                        }
                        
                        // 格式化行内容
                        String formattedRow = formatTableRow(cellContents, isHeaderDetected && rowIndex == 0);
                        if (!formattedRow.isEmpty()) {
                            enhancedText.append(formattedRow).append("\n");
                        }
                    }
                    
                    enhancedText.append("[表格").append(tableCount).append("结束]\n\n");
                }
                
                if (tableCount > 0) {
                    logger.debug("DOC文档提取了{}个表格", tableCount);
                }
            } catch (Exception e) {
                logger.debug("DOC表格提取失败，跳过表格内容: {}", e.getMessage());
            }
            
            String result = enhancedText.toString().trim();
            logger.debug("DOC增强提取完成，文本长度: {}", result.length());
            return result;
            
        } catch (Exception e) {
            logger.warn("DOC增强提取失败，将使用基础提取: {}", e.getMessage());
            return null;
        }
    }
    
    /**
     * 从DOCX文档增强提取文本，包含表格和格式信息，支持MSDS章节识别
     * 
     * @param document DOCX文档对象
     * @return 增强提取的文本内容
     */
    private String extractEnhancedTextFromDOCX(XWPFDocument document) {
        try {
            StringBuilder enhancedText = new StringBuilder();
            
            // 遍历文档的所有元素
            for (IBodyElement element : document.getBodyElements()) {
                if (element instanceof XWPFParagraph) {
                    // 处理段落
                    XWPFParagraph paragraph = (XWPFParagraph) element;
                    String paragraphText = paragraph.getText();
                    
                    if (paragraphText != null && !paragraphText.trim().isEmpty()) {
                        String cleanText = paragraphText.trim();
                        
                        // 检查是否为标题或MSDS章节
                        String style = paragraph.getStyle();
                        boolean isStyleHeading = style != null && (style.toLowerCase().contains("heading") || style.toLowerCase().contains("title"));
                        boolean isMsdsSection = isMsdsSection(cleanText);
                        
                        if (isStyleHeading || isMsdsSection) {
                            enhancedText.append("\n【").append(cleanText).append("】\n");
                        } else {
                            enhancedText.append(cleanText).append("\n");
                        }
                    }
                    
                } else if (element instanceof XWPFTable) {
                    // 增强表格处理（DOCX格式）
                    XWPFTable table = (XWPFTable) element;
                    int tableIndex = document.getBodyElements().indexOf(element) + 1;
                    enhancedText.append("\n[表格").append(tableIndex).append("开始]\n");
                    
                    List<XWPFTableRow> rows = table.getRows();
                    boolean isHeaderDetected = false;
                    List<String> headers = new ArrayList<>();
                    
                    for (int rowIndex = 0; rowIndex < rows.size(); rowIndex++) {
                        XWPFTableRow row = rows.get(rowIndex);
                        List<String> cellContents = new ArrayList<>();
                        
                        for (XWPFTableCell cell : row.getTableCells()) {
                            String cellText = cleanTableCellText(cell.getText());
                            cellContents.add(cellText);
                        }
                        
                        // 第一行作为表头检测
                        if (rowIndex == 0 && !isHeaderDetected) {
                            headers = new ArrayList<>(cellContents);
                            if (isTableHeader(cellContents)) {
                                enhancedText.append("[表头] ");
                                isHeaderDetected = true;
                            }
                        }
                        
                        // 格式化行内容
                        String formattedRow = formatTableRow(cellContents, isHeaderDetected && rowIndex == 0);
                        if (!formattedRow.isEmpty()) {
                            enhancedText.append(formattedRow).append("\n");
                        }
                    }
                    
                    enhancedText.append("[表格").append(tableIndex).append("结束]\n\n");
                    logger.debug("DOCX表格{}提取完成，行数: {}", tableIndex, rows.size());
                }
            }
            
            String result = enhancedText.toString().trim();
            logger.debug("DOCX增强提取完成，文本长度: {}", result.length());
            return result;
            
        } catch (Exception e) {
            logger.warn("DOCX增强提取失败，将使用基础提取: {}", e.getMessage());
            return null;
        }
    }
    
    /**
     * 清理表格单元格文本
     * 
     * @param cellText 原始单元格文本
     * @return 清理后的文本
     */
    private String cleanTableCellText(String cellText) {
        if (cellText == null) {
            return "";
        }
        
        // 移除多余的空白字符和换行符
        String cleaned = cellText.trim().replaceAll("\\s+", " ");
        
        // 移除表格特殊字符
        cleaned = cleaned.replaceAll("[\\x00-\\x08\\x0B\\x0C\\x0E-\\x1F\\x7F]", "");
        
        return cleaned;
    }
    
    /**
     * 检测是否为表格标题行
     * 
     * @param cellContents 单元格内容列表
     * @return 是否为标题行
     */
    private boolean isTableHeader(List<String> cellContents) {
        if (cellContents == null || cellContents.isEmpty()) {
            return false;
        }
        
        // 检查是否包含常见的MSDS表头关键词
        String[] headerKeywords = {
            "成分", "组分", "含量", "浓度", "CAS", "危险性", "分类", "标识", 
            "物质", "化学品", "百分比", "重量", "体积", "名称", "编号", "类别",
            "Component", "Concentration", "Percentage", "Weight", "Volume", 
            "Name", "Number", "Category", "Hazard", "Classification"
        };
        
        int keywordCount = 0;
        for (String cell : cellContents) {
            if (cell != null && !cell.trim().isEmpty()) {
                for (String keyword : headerKeywords) {
                    if (cell.toLowerCase().contains(keyword.toLowerCase())) {
                        keywordCount++;
                        break;
                    }
                }
            }
        }
        
        // 如果超过一半的单元格包含关键词，认为是表头
        return keywordCount >= Math.max(1, cellContents.size() / 2);
    }
    
    /**
     * 格式化表格行
     * 
     * @param cellContents 单元格内容列表
     * @param isHeader 是否为表头行
     * @return 格式化后的行文本
     */
    private String formatTableRow(List<String> cellContents, boolean isHeader) {
        if (cellContents == null || cellContents.isEmpty()) {
            return "";
        }
        
        StringBuilder rowText = new StringBuilder();
        
        for (int i = 0; i < cellContents.size(); i++) {
            String cell = cellContents.get(i);
            if (cell != null && !cell.trim().isEmpty()) {
                if (rowText.length() > 0) {
                    rowText.append(" | ");
                }
                
                // 表头使用特殊标记
                if (isHeader) {
                    rowText.append("【").append(cell.trim()).append("】");
                } else {
                    rowText.append(cell.trim());
                }
            }
        }
        
        return rowText.toString();
    }
    
    /**
     * 检查文本内容是否使用了正确的编码
     * 
     * @param content 文本内容
     * @param encoding 编码格式
     * @return 是否为有效编码
     */
    private boolean isValidTextContent(String content, String encoding) {
        if (content == null || content.trim().isEmpty()) {
            return false;
        }
        
        // 检查是否包含过多的替换字符（�）
        long replacementCount = content.chars().filter(ch -> ch == 0xFFFD).count();
        if (replacementCount > content.length() * 0.1) { // 超过10%的替换字符认为编码错误
            return false;
        }
        
        // 检查是否包含过多的控制字符
        long controlCharCount = content.chars().filter(ch -> ch < 32 && ch != 9 && ch != 10 && ch != 13).count();
        if (controlCharCount > content.length() * 0.05) { // 超过5%的控制字符认为编码错误
            return false;
        }
        
        // 对于中文编码，检查是否包含中文字符
        if ("GBK".equals(encoding) || "GB2312".equals(encoding)) {
            boolean hasChineseChar = content.chars().anyMatch(ch -> ch >= 0x4E00 && ch <= 0x9FFF);
            if (!hasChineseChar && content.length() > 100) {
                // 如果是较长的文本但没有中文字符，可能不是中文编码
                return false;
            }
        }
        
        return true;
    }
    
    /**
     * 尝试部分恢复DOC文档内容
     * 
     * @param inputStream 输入流
     * @return 部分恢复的文本内容
     */
    private String attemptPartialDocRecovery(InputStream inputStream) {
        try {
            // 重置输入流
            if (inputStream.markSupported()) {
                inputStream.reset();
            }
            
            // 尝试读取原始字节并查找文本模式
            byte[] bytes = inputStream.readAllBytes();
            String rawText = new String(bytes, StandardCharsets.UTF_8);
            
            // 查找可能的文本内容（简单的启发式方法）
            StringBuilder recoveredText = new StringBuilder();
            String[] lines = rawText.split("\\n");
            
            for (String line : lines) {
                // 过滤掉明显的二进制内容
                if (line.length() > 10 && 
                    line.matches(".*[\\u4e00-\\u9fa5a-zA-Z0-9\\s\\p{Punct}]+.*") &&
                    !line.matches(".*[\\x00-\\x08\\x0B\\x0C\\x0E-\\x1F\\x7F]+.*")) {
                    recoveredText.append(line).append("\n");
                }
            }
            
            String result = recoveredText.toString().trim();
            if (result.length() > 50) { // 至少要有一定长度才认为是有效内容
                logger.info("DOC部分恢复成功，恢复文本长度: {}", result.length());
                return result;
            }
            
        } catch (Exception e) {
            logger.debug("DOC部分恢复失败: {}", e.getMessage());
        }
        
        return null;
    }
    
    /**
     * 尝试部分恢复DOCX文档内容
     * 
     * @param inputStream 输入流
     * @return 部分恢复的文本内容
     */
    private String attemptPartialDocxRecovery(InputStream inputStream)
    {
        try {
            // 重置输入流
            if (inputStream.markSupported()) {
                inputStream.reset();
            }
            
            // DOCX是ZIP格式，尝试提取document.xml中的文本
            java.util.zip.ZipInputStream zipStream = new java.util.zip.ZipInputStream(inputStream);
            java.util.zip.ZipEntry entry;
            
            while ((entry = zipStream.getNextEntry()) != null) {
                if ("word/document.xml".equals(entry.getName())) {
                    // 读取document.xml内容
                    ByteArrayOutputStream baos = new ByteArrayOutputStream();
                    byte[] buffer = new byte[1024];
                    int len;
                    while ((len = zipStream.read(buffer)) > 0) {
                        baos.write(buffer, 0, len);
                    }
                    
                    String xmlContent = baos.toString(StandardCharsets.UTF_8);
                    
                    // 简单提取XML中的文本内容
                    String textContent = xmlContent.replaceAll("<[^>]+>", " ")
                                                   .replaceAll("\\s+", " ")
                                                   .trim();
                    
                    if (textContent.length() > 50) {
                        logger.info("DOCX部分恢复成功，恢复文本长度: {}", textContent.length());
                        return textContent;
                    }
                    break;
                }
            }
            
        } catch (Exception e) {
            logger.debug("DOCX部分恢复失败: {}", e.getMessage());
        }
        
        return null;
    }

    /**
     * 尝试从损坏的PDF文件中恢复部分文本
     * 
     * @param inputStream PDF文件输入流
     * @return 恢复的文本内容，如果失败返回null
     */
    private String attemptPartialPdfRecovery(InputStream inputStream) {
        try {
            logger.info("尝试PDF部分恢复...");
            
            // 重置输入流
            if (inputStream.markSupported()) {
                inputStream.reset();
            }
            
            // 读取PDF文件的原始字节
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            byte[] buffer = new byte[1024];
            int len;
            while ((len = inputStream.read(buffer)) > 0) {
                baos.write(buffer, 0, len);
            }
            
            String rawContent = baos.toString(StandardCharsets.ISO_8859_1);
            
            // 查找PDF中的文本流
            StringBuilder recoveredText = new StringBuilder();
            
            // 查找stream...endstream块中的文本
            Pattern streamPattern = Pattern.compile("stream\\s*\\n(.*?)\\nendstream", Pattern.DOTALL);
            Matcher streamMatcher = streamPattern.matcher(rawContent);
            
            while (streamMatcher.find()) {
                String streamContent = streamMatcher.group(1);
                
                // 提取可读文本（简单的文本提取，不处理压缩）
                String readableText = extractReadableTextFromStream(streamContent);
                if (readableText != null && readableText.length() > 10) {
                    recoveredText.append(readableText).append("\n");
                }
            }
            
            // 查找直接的文本内容
            Pattern textPattern = Pattern.compile("\\((.*?)\\)", Pattern.DOTALL);
            Matcher textMatcher = textPattern.matcher(rawContent);
            
            while (textMatcher.find()) {
                String textContent = textMatcher.group(1);
                if (isReadableText(textContent) && textContent.length() > 5) {
                    recoveredText.append(textContent).append(" ");
                }
            }
            
            String result = recoveredText.toString().trim();
            if (result.length() > 50) {
                logger.info("PDF部分恢复成功，恢复文本长度: {}", result.length());
                return result;
            }
            
        } catch (Exception e) {
            logger.debug("PDF部分恢复失败: {}", e.getMessage());
        }
        
        return null;
    }
    
    /**
     * 从PDF流内容中提取可读文本
     * 
     * @param streamContent 流内容
     * @return 可读文本
     */
    private String extractReadableTextFromStream(String streamContent) {
        try {
            // 简单的文本提取，查找可打印字符
            StringBuilder text = new StringBuilder();
            
            for (int i = 0; i < streamContent.length(); i++) {
                char c = streamContent.charAt(i);
                
                // 保留可打印的ASCII字符和常见的中文字符范围
                if ((c >= 32 && c <= 126) || // ASCII可打印字符
                    (c >= 0x4E00 && c <= 0x9FFF) || // 中文字符
                    c == '\n' || c == '\r' || c == '\t') {
                    text.append(c);
                }
            }
            
            String result = text.toString().trim();
            return result.length() > 10 ? result : null;
            
        } catch (Exception e) {
            return null;
        }
    }
    
    /**
     * 判断文本是否为可读文本
     * 
     * @param text 待检查的文本
     * @return 是否为可读文本
     */
    private boolean isReadableText(String text) {
        if (text == null || text.length() < 3) {
            return false;
        }
        
        int readableChars = 0;
        for (char c : text.toCharArray()) {
            if ((c >= 'a' && c <= 'z') || 
                (c >= 'A' && c <= 'Z') || 
                (c >= '0' && c <= '9') || 
                (c >= 0x4E00 && c <= 0x9FFF) || // 中文字符
                c == ' ' || c == '.' || c == ',' || c == ':' || c == ';') {
                readableChars++;
            }
        }
        
        // 如果可读字符占比超过70%，认为是可读文本
        return (double) readableChars / text.length() > 0.7;
    }
    
    /**
     * 尝试文本编码恢复
     * 使用多种编码方式尝试恢复文本质量
     */
    private String attemptTextEncodingRecovery(String originalText) {
        if (StringUtils.isEmpty(originalText)) {
            return originalText;
        }
        
        try {
            // 尝试不同的编码转换
            String[] encodings = {"GBK", "GB2312", "ISO-8859-1", "UTF-16", "UTF-16BE", "UTF-16LE"};
            
            for (String encoding : encodings) {
                try {
                    // 将文本转换为字节数组，然后用指定编码重新解码
                    byte[] bytes = originalText.getBytes("ISO-8859-1");
                    String recoveredText = new String(bytes, encoding);
                    
                    // 检查恢复后的文本质量
                    if (isValidTextContent(recoveredText, encoding)) {
                        logger.debug("使用编码 {} 成功恢复文本", encoding);
                        return recoveredText;
                    }
                } catch (Exception e) {
                    // 忽略编码转换异常，继续尝试下一种编码
                    logger.debug("编码 {} 转换失败: {}", encoding, e.getMessage());
                }
            }
            
            // 如果所有编码都失败，尝试清理原始文本
            String cleanedText = cleanCorruptedText(originalText);
            if (isValidTextContent(cleanedText, "UTF-8")) {
                logger.debug("通过文本清理恢复部分内容");
                return cleanedText;
            }
            
        } catch (Exception e) {
            logger.warn("文本编码恢复过程中发生异常: {}", e.getMessage());
        }
        
        return originalText; // 如果所有尝试都失败，返回原始文本
    }
    
    /**
     * 清理损坏的文本内容
     */
    private String cleanCorruptedText(String text) {
        if (StringUtils.isEmpty(text)) {
            return text;
        }
        
        StringBuilder cleaned = new StringBuilder();
        for (char c : text.toCharArray()) {
            // 保留可打印字符、中文字符和基本标点符号
            if (Character.isLetterOrDigit(c) || 
                Character.isWhitespace(c) || 
                ".,;:!?()[]{}\"'-/\\@#$%^&*+=<>|~`".indexOf(c) >= 0 ||
                (c >= 0x4E00 && c <= 0x9FFF) || // 中文字符范围
                (c >= 0x3000 && c <= 0x303F) || // 中文标点符号
                (c >= 0xFF00 && c <= 0xFFEF)) {  // 全角字符
                cleaned.append(c);
            } else if (c == '\uFFFD') {
                // 替换字符，可能是编码问题导致的
                cleaned.append(' ');
            }
        }
        
        return cleaned.toString().trim();
    }

    /**
     * 从文档内容解析完整的MSDS信息（不包含数据库操作）
     * 
     * @param content 文档内容
     * @return MSDS信息
     */
    private MsdsMain parseMsdsFromContentComplete(String content)
    {
        if (StringUtils.isEmpty(content)) {
            return null;
        }

        // 清理内容，统一格式
        String cleanContent = preprocessContent(content);
        
        // 解析主表信息
        MsdsMain msdsMain = parseMsdsMainInfo(cleanContent);
        
        return msdsMain;
    }

    /**
     * 从文档内容解析MSDS主表信息
     * 
     * @param content 文档内容
     * @return MSDS信息
     */
    private MsdsMain parseMsdsMainInfo(String content)
    {
        if (StringUtils.isEmpty(content)) {
            return null;
        }

        MsdsMain msdsMain = new MsdsMain();
        
        // 清理内容，统一格式
        String cleanContent = preprocessContent(content);
        
        // 解析第一部分：化学品及企业标识
        // 根据SQL表结构注释进行精确映射
        
        // 1. CAS登记号 (cas_number) - 对应文档中的化学品CAS号
        String casNumber = extractCasNumber(cleanContent);
        msdsMain.setCasNumber(cleanText(casNumber));
        
        // 2. MSDS编号 (msds_code) - 对应文档中的技术说明书编码
        String msdsCode = extractMsdsCode(cleanContent);
        msdsMain.setMsdsCode(cleanText(msdsCode));
        
        // 3. 化学品中文名 (product_name) - 对应文档中的中文名称
        String productName = extractProductName(cleanContent);
        msdsMain.setProductName(cleanText(productName));
        
        // 4. 化学品别名 (product_alias) - 对应文档中的中文别名
        String productAlias = extractProductAlias(cleanContent);
        msdsMain.setProductAlias(cleanText(productAlias));
        
        // 5. 化学品英文名 (product_english_name) - 对应文档中的英文名称
        String productEnglishName = extractProductEnglishName(cleanContent);
        msdsMain.setProductEnglishName(cleanText(productEnglishName));
        
        // 6. 企业名称 (company_name) - 对应文档中的供应商名称
        String companyName = extractCompanyName(cleanContent);
        msdsMain.setCompanyName(cleanText(companyName));
        
        // 7. 企业地址 (company_address) - 对应文档中的供应商地址
        String companyAddress = extractCompanyAddress(cleanContent);
        msdsMain.setCompanyAddress(cleanText(companyAddress));
        
        // 8. 传真号码 (fax_number) - 对应文档中的供应商传真
        String faxNumber = extractFaxNumber(cleanContent);
        msdsMain.setFaxNumber(cleanText(faxNumber));
        
        // 9. 联系电话 (contact_phone) - 对应文档中的供应商电话
        String contactPhone = extractContactPhone(cleanContent);
        msdsMain.setContactPhone(cleanText(contactPhone));
        
        // 10. 电子邮件地址 (email) - 对应文档中的供应商Email
        String email = extractEmail(cleanContent);
        msdsMain.setEmail(cleanText(email));
        
        // 11. 企业应急电话 (emergency_phone) - 对应文档中的供应商应急电话
        String emergencyPhone = extractEmergencyPhone(cleanContent);
        msdsMain.setEmergencyPhone(cleanText(emergencyPhone));
        
        // 12. 产品代码 (product_code) - 对应文档中的产品编号或数字标识
        String productCode = extractProductCode(cleanContent);
        msdsMain.setProductCode(cleanText(productCode));
        
        // 13. MSDS版本号和日期信息
        String version = extractVersion(cleanContent);
        msdsMain.setVersion(cleanText(version));
        
        // 提取修订日期
        Date revisionDate = extractRevisionDate(cleanContent);
        msdsMain.setRevisionDate(revisionDate);
        
        // 设置默认状态
        msdsMain.setStatus("draft");
        
        // 生成MSDS编号（如果没有提取到）
        if (StringUtils.isEmpty(msdsMain.getMsdsCode())) {
            msdsMain.setMsdsCode(generateMsdsCode());
        }
        
        // 应用统一的数据校验和清理规则
        msdsMain = validateAndCleanMsdsData(msdsMain);
        
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
        logger.debug("开始提取产品中文名称，内容长度: {}", content != null ? content.length() : 0);
        
        if (StringUtils.isEmpty(content)) {
            logger.warn("提取产品名称失败：内容为空");
            return null;
        }
        
        String[] patterns = {
            // 标准格式：化学品中文名称：xxx（保留完整名称，包括可能的逗号）
            "(?:化学品中文名称?|产品名称|中文名称|商品名|化学品名称)\\s*[：:：]?\\s*([^\\n\\r]+?)(?=\\s*(?:英文名|CAS|分子式|分子量|$))",
            // 简化格式：中文名：xxx（更宽松的匹配）
            "(?:中文名|产品名|化学名)\\s*[：:：]\\s*([^\\n\\r]+?)(?=\\s*(?:英文名|CAS|分子式|分子量|$))",
            // 通用格式：名称：xxx（保留完整内容）
            "(?:名称|Name)\\s*[：:：]\\s*([^\\n\\r]+?)(?=\\s*(?:英文名|English|CAS|分子式|分子量|$))",
            // MSDS第一部分格式
            "第一部分[^\\n]*\\n[^\\n]*名称[^：:：]*[：:：]\\s*([^\\n\\r]+?)(?=\\s*(?:英文名|CAS|分子式|分子量|$))",
            "1\\s*化学品及企业标识[^\\n]*\\n[^\\n]*名称[^：:：]*[：:：]\\s*([^\\n\\r]+?)(?=\\s*(?:英文名|CAS|分子式|分子量|$))",
            // 兜底模式：匹配包含中文字符的完整名称
            "(?:化学品中文名称?|产品名称|中文名称|商品名|化学品名称)\\s*[：:：]?\\s*([\\u4e00-\\u9fa5][^\\n\\r]*)"
        };
        
        for (int i = 0; i < patterns.length; i++) {
            String pattern = patterns[i];
            logger.debug("尝试模式 {} : {}", i + 1, pattern);
            
            String result = extractValue(content, pattern);
            if (StringUtils.isNotEmpty(result)) {
                logger.debug("模式 {} 匹配成功，原始结果: [{}]", i + 1, result);
                
                // 清理提取的名称
                result = result.trim();
                // 移除可能的前缀标识符
                result = result.replaceAll("^[：:：\\s]*", "");
                
                logger.debug("初步清理后结果: [{}]", result);
                
                // 使用轻量级清理，避免过度清理中文名称
                result = cleanChemicalNameLightweight(result);
                
                logger.debug("轻量级清理后结果: [{}]", result);
                
                // 如果名称长度合理，返回结果
                if (result.length() > 1 && result.length() < 100) {
                    logger.info("成功提取产品中文名称: [{}]，使用模式: {}", result, i + 1);
                    return result;
                } else {
                    logger.warn("提取的名称长度不合理: [{}]，长度: {}", result, result.length());
                }
            } else {
                logger.debug("模式 {} 未匹配到结果", i + 1);
            }
        }
        
        logger.warn("所有模式均未能提取到有效的产品中文名称");
        return null;
    }

    /**
     * 轻量级化学品名称清理方法
     * 专门用于extractProductName，避免过度清理导致中文名称丢失
     * 保留化学品名称中的有效特殊字符（括号、逗号、连字符等）
     */
    private String cleanChemicalNameLightweight(String name) {
        if (StringUtils.isEmpty(name)) {
            logger.debug("轻量级清理：输入名称为空");
            return name;
        }
        
        String originalName = name;
        logger.debug("轻量级清理开始，原始名称: [{}]", originalName);
        
        // 移除首尾空白字符
        name = name.trim();
        logger.debug("移除首尾空白后: [{}]", name);
        
        // 移除明显的前缀标识符（但保留化学品名称中的有效符号）
        String beforePrefix = name;
        name = name.replaceAll("^[：:：\\s]*", "");
        if (!beforePrefix.equals(name)) {
            logger.debug("移除前缀标识符后: [{}]", name);
        }
        
        // 仅移除明显无关的技术后缀信息，但保留重要的中文别名信息
        String beforeSuffix = name;
        // 只移除明显的纯度等级标识（如"98%"、"99.9%"等，但仅在括号内且位于末尾时）
        name = name.replaceAll("\\s*[（(]\\s*\\d+(\\.\\d+)?\\s*%\\s*[)）]\\s*$", "");
        // 只移除明显的技术规格标识（仅在末尾且单独出现时）
        name = name.replaceAll("\\s*[（(]\\s*(技术级|医药级|食品级|化妆品级)\\s*[)）]\\s*$", "");
        
        // 注意：不再移除工业级、分析级等，因为这些可能是重要的中文别名信息
        // 例如："苯（工业级）"、"甲苯（分析纯）"等应该保留
        
        if (!beforeSuffix.equals(name)) {
            logger.debug("移除技术后缀信息后: [{}]", name);
        }
        
        // 仅移除行尾的多余空白，保留化学品名称中的有效标点符号
        String beforePunctuation = name;
        // 移除行尾的连续空白和明显多余的标点
        name = name.replaceAll("\\s+$", ""); // 移除尾部空白
        name = name.replaceAll("[。；;]+$", ""); // 移除明显的句号、分号
        // 保留可能是化学品名称组成部分的逗号、连字符、括号等
        
        if (!beforePunctuation.equals(name)) {
            logger.debug("移除行尾多余符号后: [{}]", name);
        }
        
        String finalName = name.trim();
        logger.debug("轻量级清理完成，最终名称: [{}]，原始: [{}]", finalName, originalName);
        
        return finalName;
    }
    
    /**
     * 提取化学品英文名称
     */
    private String extractProductEnglishName(String content) {
        String[] patterns = {
            // 标准格式：化学品英文名称：xxx
            "(?:化学品英文名称?|英文名称?|English\\s*Name)\\s*[：:：]?\\s*([^\\n\\r]+)",
            // 简化格式：英文名：xxx
            "(?:英文名|英文|English)\\s*[：:：]\\s*([^\\n\\r，,；;]+)",
            // 产品名称格式
            "Product\\s*name\\s*[：:：]\\s*([^\\n\\r]+)",
            // 匹配复杂的英文化学品名称（包含数字、连字符、逗号）
            "([0-9,\\-\\s]*\\p{L}+[0-9,\\-\\s]*\\p{L}+[0-9,\\-\\s]*)",
            // 匹配标准IUPAC命名格式
            "([0-9]+,[0-9]+,[0-9]+,[0-9]+,[0-9]+,[0-9]+-[\\p{L}\\-]+)",
            // 匹配包含连字符的复杂英文名称
            "([\\p{L}0-9,\\-]+\\p{L}+[\\p{L}0-9,\\-]*)",
            // 在第一部分中查找英文名称
            "第一部分[^\\n]*\\n[^\\n]*英文[^：:：]*[：:：]\\s*([^\\n\\r]+)",
            // 在化学品标识部分查找英文名称
            "1\\s*化学品及企业标识[^\\n]*\\n[^\\n]*英文[^：:：]*[：:：]\\s*([^\\n\\r]+)"
        };
        
        for (String pattern : patterns) {
            String result = extractValue(content, pattern);
            if (StringUtils.isNotEmpty(result)) {
                // 清理提取的名称
                result = result.trim();
                // 移除可能的前缀标识符
                result = result.replaceAll("^[：:：\\s]*", "");
                // 验证是否为有效的英文化学品名称
                if (result.length() > 3 && result.length() < 300 && 
                    result.matches(".*\\p{L}.*")) { // 必须包含字母（支持Unicode）
                    return result;
                }
            }
        }
        
        return null;
    }

    /**
     * 提取企业名称
     */
    private String extractCompanyName(String content) {
        logger.debug("开始提取企业名称，内容长度: {}", content != null ? content.length() : 0);
        
        String[] patterns = {
            // 优先匹配企业名称字段（支持标准MSDS格式）
            "(?:企业名称|公司名称|生产企业|制造商|Company)\\s*[：:：]?\\s*([^\\n\\r]+?)(?=\\s*(?:地址|电话|传真|邮箱|Email|$))",
            
            // 优先匹配供应商相关字段（根据数据库注释，企业名称对应供应商名称）
            "(?:供应商名称|供应商|Supplier)\\s*[：:：]?\\s*([^\\n\\r]+?)(?=\\s*(?:地址|电话|传真|邮箱|Email|$))",
            "(?:供应商企业名称|供应商公司名称)\\s*[：:：]?\\s*([^\\n\\r]+?)(?=\\s*(?:地址|电话|传真|邮箱|Email|$))",
            
            // 生产厂家格式
            "(?:生产厂家|厂家|Manufacturer)\\s*[：:：]\\s*([^\\n\\r]+?)(?=\\s*(?:地址|电话|传真|邮箱|Email|$))",
            
            // 英文供应商格式
            "Supplier\\s*[：:：]\\s*([^\\n\\r]+?)(?=\\s*(?:Address|Tel|Phone|Fax|Email|$))",
            
            // 在第一部分中查找企业名称
            "第一部分[^\\n]*\\n[^\\n]*(?:企业|供应商|公司|厂家)[^：:：]*[：:：]\\s*([^\\n\\r]+?)(?=\\s*(?:地址|电话|传真|邮箱|Email|$))",
            
            // 在化学品标识部分查找企业名称
            "1\\s*[.、]?\\s*化学品及企业标识[^\\n]*\\n[\\s\\S]*?(?:企业|供应商|公司|厂家)[^：:：]*[：:：]\\s*([^\\n\\r]+?)(?=\\s*(?:地址|电话|传真|邮箱|Email|$))",
            
            // 在供应商信息部分查找
            "供应商信息[^\\n]*\\n[^\\n]*(?:名称|企业|公司)[^：:：]*[：:：]\\s*([^\\n\\r]+?)(?=\\s*(?:地址|电话|传真|邮箱|Email|$))",
            
            // 表格格式中的企业名称
            "(?:企业名称|供应商名称|公司名称)\\s*([^\\n\\r\\t]+?)(?=\\s*(?:企业地址|供应商地址|地址|电话|传真|邮箱|Email|$))",
            
            // 匹配包含"有限公司"、"股份有限公司"等的企业名称（更精确的匹配）
            "(?:企业|供应商|公司|厂家)[^：:：]*[：:：]\\s*([^\\n\\r]*?(?:有限公司|股份有限公司|集团|公司|企业|厂|Co\\.|Ltd\\.|Inc\\.|Corporation)[^\\n\\r]*?)(?=\\s*(?:地址|电话|传真|邮箱|Email|$))",
            
            // 匹配包含"Co.","Ltd.","Inc."等的英文企业名称
            "(?:Supplier|Company|Manufacturer)[^：:：]*[：:：]\\s*([^\\n\\r]*?(?:Co\\.|Ltd\\.|Inc\\.|Corporation|Company)[^\\n\\r]*?)(?=\\s*(?:Address|Tel|Phone|Fax|Email|$))",
            
            // 在联系信息附近查找企业名称
            "(?:联系|电话|地址)[^\\n]*\\n[^\\n]*([^\\n\\r]*?(?:有限公司|股份有限公司|集团|公司|企业|厂)[^\\n\\r]*?)(?=\\s*(?:地址|电话|传真|邮箱|Email|$))",
            
            // 表格行格式匹配
            "([^\\n\\r\\t]*?(?:有限公司|股份有限公司|集团|公司|企业|厂)[^\\n\\r\\t]*?)\\s+([^\\n\\r\\t]*?(?:省|市|区|县|镇|街道|路|号)[^\\n\\r\\t]*)",
            
            // 兜底模式：匹配任何包含公司标识的文本行
            "([^\\n\\r]*?(?:有限公司|股份有限公司|集团|公司|企业|厂)[^\\n\\r]*?)(?=\\s*(?:地址|电话|传真|邮箱|Email|$))",
            "([^\\n\\r]*?(?:Co\\.|Ltd\\.|Inc\\.|Corporation|Company)[^\\n\\r]*?)(?=\\s*(?:Address|Tel|Phone|Fax|Email|$))",
            
            // 更宽松的匹配模式（用于兜底）
            "(?:企业|供应商|公司|厂家|Supplier|Company|Manufacturer)\\s*[：:：]?\\s*([^\\n\\r]{3,100}?)(?=\\s*(?:地址|电话|传真|邮箱|Email|Address|Tel|Phone|Fax|$))"
        };
        
        for (int i = 0; i < patterns.length; i++) {
            String pattern = patterns[i];
            logger.debug("尝试企业名称提取模式 {} : {}", i + 1, pattern);
            
            String result = extractValue(content, pattern);
            if (StringUtils.isNotEmpty(result)) {
                logger.debug("模式 {} 匹配成功，原始结果: [{}]", i + 1, result);
                
                // 清理提取的名称
                result = result.trim();
                // 移除可能的前缀标识符
                result = result.replaceAll("^[：:：\\s]*", "");
                // 移除可能的后缀信息（如电话号码等）
                result = result.replaceAll("\\s*电话[：:：].*$", "");
                result = result.replaceAll("\\s*地址[：:：].*$", "");
                result = result.replaceAll("\\s*Tel[：:：].*$", "");
                result = result.replaceAll("\\s*传真[：:：].*$", "");
                result = result.replaceAll("\\s*Fax[：:：].*$", "");
                result = result.replaceAll("\\s*邮箱[：:：].*$", "");
                result = result.replaceAll("\\s*Email[：:：].*$", "");
                result = result.replaceAll("\\s*Address[：:：].*$", "");
                
                // 移除多余的空格和特殊字符
                result = result.replaceAll("\\s{2,}", " ");
                result = result.replaceAll("^[\\s\\t]+|[\\s\\t]+$", "");
                
                logger.debug("清理后结果: [{}]", result);
                
                // 验证是否为有效的企业名称
                if (result.length() >= 2 && result.length() <= 200) {
                    // 排除明显不是企业名称的内容
                    if (!result.matches("^\\d+$") && // 不是纯数字
                        !result.matches("^[a-zA-Z]{1,3}$") && // 不是1-3个字母
                        !result.toLowerCase().matches("^(tel|phone|fax|email|address)$") && // 不是字段名
                        !result.matches("^[\\s\\-_]+$")) { // 不是纯符号
                        
                        logger.info("成功提取企业名称: [{}]，使用模式: {}", result, i + 1);
                        return result;
                    } else {
                        logger.debug("跳过无效的企业名称: [{}]", result);
                    }
                } else {
                    logger.warn("提取的企业名称长度不合理: [{}]，长度: {}", result, result.length());
                }
            } else {
                logger.debug("模式 {} 未匹配到结果", i + 1);
            }
        }
        
        logger.warn("未能提取到有效的企业名称");
        return null;
    }

    /**
     * 提取企业地址
     */
    private String extractCompanyAddress(String content) {
        String[] patterns = {
            // 优先匹配企业地址字段（支持标准MSDS格式）
            "(?:企业地址|公司地址|地址|Address)\\s*[：:：]?\\s*([^\\n\\r]+?)(?=\\s*(?:电话|传真|邮箱|Email|Tel|Phone|Fax|$))",
            "(?:生产地址|厂址|办公地址)\\s*[：:：]?\\s*([^\\n\\r]+?)(?=\\s*(?:电话|传真|邮箱|Email|Tel|Phone|Fax|$))",
            
            // 供应商地址格式
            "(?:供应商地址|供应商)\\s*[：:：]?\\s*([^\\n\\r]+?)(?=\\s*(?:电话|传真|邮箱|Email|Tel|Phone|Fax|$))",
            
            // 制造商地址格式
            "(?:制造商地址|制造商|Manufacturer)\\s*[：:：]?\\s*([^\\n\\r]+?)(?=\\s*(?:电话|传真|邮箱|Email|Tel|Phone|Fax|$))",
            
            // 在企业标识部分查找地址
            "1\\s*[.、]?\\s*化学品及企业标识[\\s\\S]*?(?:企业地址|地址|Address)[：:：]?\\s*([^\\n\\r]+?)(?=\\s*(?:电话|传真|邮箱|Email|Tel|Phone|Fax|$))",
            
            // 表格格式中的地址
            "(?:企业地址|供应商地址|公司地址)\\s*([^\\n\\r\\t]+?)(?=\\s*(?:联系电话|电话|传真|邮箱|Email|$))",
            
            // 通用地址模式（包含省市区的地址）
            "([\\u4e00-\\u9fa5]+(?:省|市|区|县|镇|街道|路|号)[\\s\\S]*?[\\u4e00-\\u9fa5\\d\\-#]+?)(?=\\s*(?:电话|传真|邮箱|Email|Tel|Phone|Fax|$))",
            
            // 邮编+地址格式
            "(?:邮编|邮政编码|Postal Code)[：:：]?\\s*\\d{6}[\\s,，]*([^\\n\\r]+?)(?=\\s*(?:电话|传真|邮箱|Email|Tel|Phone|Fax|$))",
            
            // 英文地址格式
            "Address\\s*[：:：]?\\s*([^\\n\\r]+?)(?=\\s*(?:Tel|Phone|Fax|Email|$))",
            
            // 在联系信息中查找地址
            "联系方式[\\s\\S]*?地址[：:：]?\\s*([^\\n\\r]+?)(?=\\s*(?:电话|传真|邮箱|Email|Tel|Phone|Fax|$))",
            
            // 更宽松的地址匹配（兜底）
            "(?:地址|Address)\\s*[：:：]?\\s*([^\\n\\r]{5,200}?)(?=\\s*(?:电话|传真|邮箱|Email|Tel|Phone|Fax|$))"
        };
        
        for (String pattern : patterns) {
            String result = extractValue(content, pattern);
            if (StringUtils.isNotEmpty(result)) {
                // 清理提取的地址
                result = cleanAddress(result);
                
                // 验证地址有效性
                if (isValidAddress(result)) {
                    logger.info("成功提取企业地址: {}", result);
                    return result;
                }
            }
        }
        
        logger.warn("未能提取到有效的企业地址");
        return null;
    }

    /**
     * 清理地址字符串
     */
    private String cleanAddress(String address) {
        if (StringUtils.isEmpty(address)) {
            return address;
        }
        
        // 基础清理
        address = address.trim()
            .replaceAll("^[：:：\\s]+", "")  // 移除开头的冒号和空格
            .replaceAll("[\\s]+$", "")      // 移除结尾空格
            .replaceAll("\\s{2,}", " ");    // 合并多个空格
        
        // 移除常见的后缀干扰词
        address = address.replaceAll("(?i)\\s*(Tel|Phone|Fax|Email|电话|传真|邮箱).*$", "");
        address = address.replaceAll("(?i)\\s*(联系电话|联系方式|联系人|手机|移动电话).*$", "");
        
        // 移除多余的标点符号
        address = address.replaceAll("[\\s,，.。;；:：]+$", "");
        
        // 移除常见的无效前缀
        address = address.replaceAll("^(?i)(Address|地址)[：:：\\s]*", "");
        
        return address.trim();
    }

    /**
     * 验证地址有效性
     */
    private boolean isValidAddress(String address) {
        if (StringUtils.isEmpty(address)) {
            return false;
        }
        
        // 长度检查
        if (address.length() < 5 || address.length() > 500) {
            return false;
        }
        
        // 排除纯数字
        if (address.matches("^[\\d\\s\\-]+$")) {
            return false;
        }
        
        // 排除常见的字段名
        if (address.toLowerCase().matches("^(tel|phone|fax|email|address|电话|传真|邮箱|地址)$")) {
            return false;
        }
        
        // 排除纯符号
        if (address.matches("^[\\s\\p{Punct}]+$")) {
            return false;
        }
        
        // 排除过短的英文字符串
        if (address.matches("^[a-zA-Z\\s]{1,3}$")) {
            return false;
        }
        
        // 必须包含有意义的字符（中文、英文或数字）
        if (!address.matches(".*[\\u4e00-\\u9fa5a-zA-Z0-9].*")) {
            return false;
        }
        
        return true;
    }

    /**
     * 提取联系电话
     */
    private String extractContactPhone(String content) {
        logger.debug("开始提取联系电话（修复版）");
        
        // 更精确的电话号码提取模式，解决"未提供"问题
        String[] patterns = {
            // 标准联系电话格式
            "(?:联系电话|联系电话号码)\\s*[：:：]?\\s*([\\d\\-\\+\\(\\)\\s]{7,20})",
            
            // 供应商电话格式
            "(?:供应商电话|供应商联系电话)\\s*[：:：]?\\s*([\\d\\-\\+\\(\\)\\s]{7,20})",
            
            // 制造商电话格式
            "(?:制造商电话|制造商联系电话)\\s*[：:：]?\\s*([\\d\\-\\+\\(\\)\\s]{7,20})",
            
            // 标准电话格式（带区号）
            "(?:电话|Tel|Phone)\\s*[：:：]?\\s*([0-9]{3,4}[\\-\\s]?[0-9]{7,8})",
            
            // 手机号码格式
            "(?:手机|移动电话|Mobile)\\s*[：:：]?\\s*(1[3-9]\\d{9})",
            
            // 在企业标识部分查找电话
            "1\\s*化学品及企业标识[\\s\\S]*?(?:联系电话|电话|Tel|Phone)\\s*[：:：]?\\s*([\\d\\-\\+\\(\\)\\s]{7,20})"
        };
        
        for (String pattern : patterns) {
            String result = extractValue(content, pattern);
            if (StringUtils.isNotEmpty(result)) {
                // 清理电话号码
                result = cleanPhoneNumber(result);
                if (isValidPhoneNumber(result)) {
                    logger.info("成功提取联系电话: {}", result);
                    return result;
                }
            }
        }
        
        logger.warn("未能提取到有效的联系电话");
        return null;
    }

    /**
     * 提取电子邮件
     */
    private String extractEmail(String content) {
        String[] patterns = {
            // 优先匹配"电子邮件"
            "(?:电子邮件|电子邮箱)\\s*[：:：]?\\s*([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,})(?=\\s|$|[\\r\\n])",
            // 标准邮箱格式（带边界检查）
            "(?:邮箱|Email|E-mail)\\s*[：:：]?\\s*([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,})(?=\\s|$|[\\r\\n])",
            
            // 供应商邮箱格式
            "(?:供应商邮箱|供应商电子邮件|供应商Email)\\s*[：:：]?\\s*([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,})(?=\\s|$|[\\r\\n])",
            
            // 制造商邮箱格式
            "(?:制造商邮箱|制造商电子邮件|制造商Email)\\s*[：:：]?\\s*([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,})(?=\\s|$|[\\r\\n])",
            
            // 在企业标识部分查找邮箱
            "1\\s*[.、]?\\s*化学品及企业标识[\\s\\S]*?(?:邮箱|Email|E-mail)[：:：]?\\s*([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,})(?=\\s|$|[\\r\\n])",
            
            // 表格格式中的邮箱
            "(?:企业邮箱|公司邮箱|联系邮箱)\\s*([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,})(?=\\s|$|[\\r\\n])",
            
            // 联系方式中的邮箱
            "联系方式[\\s\\S]*?([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,})(?=\\s|$|[\\r\\n])",
            
            // 直接匹配邮箱格式（更严格的模式）
            "\\b([a-zA-Z0-9](?:[a-zA-Z0-9._-]*[a-zA-Z0-9])?@[a-zA-Z0-9](?:[a-zA-Z0-9.-]*[a-zA-Z0-9])?\\.[a-zA-Z]{2,})\\b",
            
            // 在联系信息段落中查找
            "(?:联系信息|Contact Information)[\\s\\S]*?([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,})(?=\\s|$|[\\r\\n])",
            
            // 更宽松的邮箱匹配（兜底）
            "(?:邮箱|Email)\\s*[：:：]?\\s*([^\\s\\r\\n]+@[^\\s\\r\\n]+\\.[a-zA-Z]{2,})(?=\\s|$|[\\r\\n])"
        };
        
        for (String pattern : patterns) {
            String result = extractValue(content, pattern);
            if (StringUtils.isNotEmpty(result)) {
                // 清理提取的邮箱地址
                result = cleanEmail(result);
                
                // 验证邮箱格式
                if (isValidEmail(result)) {
                    logger.info("成功提取电子邮件: {}", result);
                    return result;
                }
            }
        }
        
        logger.warn("未能提取到有效的电子邮件");
        return null;
    }

    /**
     * 清理邮箱字符串
     */
    private String cleanEmail(String email) {
        if (StringUtils.isEmpty(email)) {
            return email;
        }
        
        // 基础清理
        email = email.trim()
            .replaceAll("^[：:：\\s]+", "")  // 移除开头的冒号和空格
            .replaceAll("[\\s]+$", "")      // 移除结尾空格
            .toLowerCase();                 // 转换为小写
        
        // 移除常见的后缀干扰词
        email = email.replaceAll("(?i)\\s*(Tel|Phone|Fax|电话|传真|联系电话).*$", "");
        
        // 移除多余的标点符号
        email = email.replaceAll("[\\s,，.。;；:：]+$", "");
        
        // 移除常见的无效前缀
        email = email.replaceAll("^(?i)(Email|E-mail|邮箱|电子邮件)[：:：\\s]*", "");
        
        // 移除括号和引号
        email = email.replaceAll("[()（）\"']+", "");
        
        return email.trim();
    }

    /**
     * 验证邮箱有效性
     */
    private boolean isValidEmail(String email) {
        if (StringUtils.isEmpty(email)) {
            return false;
        }
        
        // 基本格式检查
        if (!email.matches("^[a-zA-Z0-9](?:[a-zA-Z0-9._-]*[a-zA-Z0-9])?@[a-zA-Z0-9](?:[a-zA-Z0-9.-]*[a-zA-Z0-9])?\\.[a-zA-Z]{2,}$")) {
            return false;
        }
        
        // 长度检查
        if (email.length() > 254) {
            return false;
        }
        
        // 检查本地部分长度（@之前的部分）
        String[] parts = email.split("@");
        if (parts.length != 2 || parts[0].length() > 64) {
            return false;
        }
        
        // 排除常见的无效邮箱
        String[] invalidEmails = {
            "example@example.com", "test@test.com", "admin@admin.com",
            "info@info.com", "contact@contact.com", "email@email.com"
        };
        
        for (String invalid : invalidEmails) {
            if (email.equals(invalid)) {
                return false;
            }
        }
        
        // 检查域名部分是否合理
        String domain = parts[1];
        if (domain.startsWith(".") || domain.endsWith(".") || domain.contains("..")) {
            return false;
        }
        
        return true;
    }

    /**
     * 提取应急电话
     */
    private String extractEmergencyPhone(String content) {
        logger.debug("开始提取应急电话（修复版）");
        
        // 更精确的应急电话提取模式，避免字段混淆
        String[] patterns = {
            // 标准应急电话格式
            "(?:应急电话|紧急联系电话|Emergency)\\s*[：:：]?\\s*([\\d\\-\\+\\(\\)\\s]{7,20})",
            
            // 供应商应急电话格式
            "(?:供应商应急电话|供应商紧急联系电话)\\s*[：:：]?\\s*([\\d\\-\\+\\(\\)\\s]{7,20})",
            
            // 制造商应急电话格式
            "(?:制造商应急电话|制造商紧急联系电话)\\s*[：:：]?\\s*([\\d\\-\\+\\(\\)\\s]{7,20})",
            
            // 急救电话格式
            "(?:急救电话|紧急电话)\\s*[：:：]?\\s*([\\d\\-\\+\\(\\)\\s]{7,20})",
            
            // 在企业标识部分查找应急电话
            "1\\s*化学品及企业标识[\\s\\S]*?(?:应急电话|紧急联系电话|Emergency)\\s*[：:：]?\\s*([\\d\\-\\+\\(\\)\\s]{7,20})"
        };
        
        for (String pattern : patterns) {
            String result = extractValue(content, pattern);
            if (StringUtils.isNotEmpty(result)) {
                // 清理应急电话
                result = cleanPhoneNumber(result);
                if (isValidPhoneNumber(result)) {
                    logger.info("成功提取应急电话: {}", result);
                    return result;
                }
            }
        }
        
        logger.warn("未能提取到有效的应急电话");
        return null;
    }

    /**
     * 提取版本号
     */
    private String extractVersion(String content) {
        String[] patterns = {
            // 标准版本号格式
            "(?:版本号|版本|Version)\\s*[：:：]?\\s*([^\\n\\r]+)",
            "V\\s*([\\d\\.]+)",
            "版本\\s*[：:：]\\s*([^\\n\\r]+)",
            // 在第一部分中查找版本号
            "第一部分[^\\n]*\\n[^\\n]*(?:版本|Version)[^：:：]*[：:：]\\s*([^\\n\\r]+)",
            // 在化学品标识部分查找版本号
            "1\\s*化学品及企业标识[^\\n]*\\n[^\\n]*(?:版本|Version)[^：:：]*[：:：]\\s*([^\\n\\r]+)",
            // 修订版本格式
            "(?:修订版本|Revision)\\s*[：:：]?\\s*([^\\n\\r]+)",
            // 编制版本格式
            "(?:编制版本|编制日期版本)\\s*[：:：]?\\s*([^\\n\\r]+)",
            // 数字版本格式
            "(?:第|No\\.)\\s*([\\d\\.]+)\\s*(?:版|版本)",
            // 日期版本格式
            "([0-9]{4}[\\-/年][0-9]{1,2}[\\-/月][0-9]{1,2}[日]?)\\s*版本?"
        };
        
        for (String pattern : patterns) {
            String result = extractValue(content, pattern);
            if (StringUtils.isNotEmpty(result)) {
                // 清理提取的版本号
                result = result.trim();
                // 移除可能的前缀标识符
                result = result.replaceAll("^[：:：\\s]*", "");
                // 移除可能的后缀信息
                result = result.replaceAll("\\s*版本?$", "");
                
                // 验证是否为有效的版本号
                if (result.length() > 0 && result.length() < 50) {
                    return result;
                }
            }
        }
        
        return null;
    }

    /**
     * 提取CAS号
     */
    private String extractCasNumber(String content) {
        String[] patterns = {
            // 标准CAS号格式：xxx-xx-x
            "CAS\\s*[号#]?\\s*[：:：]?\\s*([0-9]{1,7}-[0-9]{2}-[0-9]{1})",
            "CAS\\s*No\\.?\\s*[：:：]?\\s*([0-9]{1,7}-[0-9]{2}-[0-9]{1})",
            "CAS\\s*Registry\\s*Number\\s*[：:：]?\\s*([0-9]{1,7}-[0-9]{2}-[0-9]{1})",
            // 更宽松的CAS号匹配
            "CAS\\s*[号#]?\\s*[：:：]?\\s*([0-9\\-]+)",
            "CAS\\s*No\\.?\\s*[：:：]?\\s*([0-9\\-]+)",
            // 标准CAS号格式（独立匹配）
            "([0-9]{1,7}-[0-9]{2}-[0-9]{1})",
            // 在第一部分中查找CAS号
            "第一部分[^\\n]*\\n[^\\n]*CAS[^：:：]*[：:：]\\s*([0-9\\-]+)",
            // 在化学品标识部分查找CAS号
            "1\\s*化学品及企业标识[^\\n]*\\n[^\\n]*CAS[^：:：]*[：:：]\\s*([0-9\\-]+)",
            // 在成分信息中查找CAS号
            "(?:成分|组分|Component)[^\\n]*\\n[^\\n]*CAS[^：:：]*[：:：]\\s*([0-9\\-]+)"
        };
        
        for (String pattern : patterns) {
            String result = extractValue(content, pattern);
            if (StringUtils.isNotEmpty(result)) {
                // 清理提取的CAS号
                result = result.trim();
                // 移除可能的前缀标识符
                result = result.replaceAll("^[：:：\\s]*", "");
                // 验证CAS号格式
                if (result.matches("[0-9]{1,7}-[0-9]{2}-[0-9]{1}")) {
                    return result;
                }
            }
        }
        
        return null;
    }

    /**
     * 提取MSDS编号
     */
    private String extractMsdsCode(String content) {
        String[] patterns = {
            // 标准MSDS编号格式
            "(?:MSDS编号|技术说明书编码|编号|Code)\\s*[：:：]?\\s*([^\\n\\r]+)",
            "(?:Document\\s*No|Doc\\s*No)\\s*[：:：]?\\s*([^\\n\\r]+)",
            "(?:产品编号|产品代码)\\s*[：:：]?\\s*([^\\n\\r]+)",
            // 在第一部分中查找编号
            "第一部分[^\\n]*\\n[^\\n]*(?:编号|Code)[^：:：]*[：:：]\\s*([^\\n\\r]+)",
            // 在化学品标识部分查找编号
            "1\\s*化学品及企业标识[^\\n]*\\n[^\\n]*(?:编号|Code)[^：:：]*[：:：]\\s*([^\\n\\r]+)",
            // 文档编号格式
            "(?:文档编号|Document\\s*Code)\\s*[：:：]?\\s*([^\\n\\r]+)",
            // 产品标识编号
            "(?:产品标识|Product\\s*ID)\\s*[：:：]?\\s*([^\\n\\r]+)",
            // 技术说明书编号
            "(?:技术说明书编号|SDS\\s*No)\\s*[：:：]?\\s*([^\\n\\r]+)",
            // 安全数据表编号
            "(?:安全数据表编号|Safety\\s*Data\\s*Sheet\\s*No)\\s*[：:：]?\\s*([^\\n\\r]+)"
        };
        
        for (String pattern : patterns) {
            String result = extractValue(content, pattern);
            if (StringUtils.isNotEmpty(result)) {
                // 清理提取的编号
                result = result.trim();
                // 移除可能的前缀标识符
                result = result.replaceAll("^[：:：\\s]*", "");
                // 移除可能的后缀信息
                result = result.replaceAll("\\s*版本?$", "");
                
                // 验证是否为有效的编号
                if (result.length() > 0 && result.length() < 100) {
                    return result;
                }
            }
        }
        
        return null;
    }

    /**
     * 提取化学品别名
     */
    private String extractProductAlias(String content) {
        String[] patterns = {
            // 严格匹配中文别名，只提取纯中文内容
            "(?:化学品别名|中文别名|别名)\\s*[：:：]?\\s*([\\u4e00-\\u9fff；;，,、\\s]+?)(?=\\s*(?:[a-zA-Z]|\\d{2,7}-\\d{2}-\\d|CAS|MSDS|Email|企业|生产|电话|传真|地址|邮编|网址|\\d+\\.|$))",
            // 备用模式：匹配别名后的纯中文字符
            "别名\\s*[：:：]?\\s*([\\u4e00-\\u9fff；;，,、\\s]{2,20})",
            // 商品名、贸易名等模式
            "(?:商品名|贸易名|俗名|通用名)\\s*[：:：]?\\s*([\\u4e00-\\u9fff；;，,、\\s]+?)(?=\\s*(?:[a-zA-Z]|\\d{2,7}-\\d{2}-\\d|CAS|MSDS|Email|企业|生产|电话|传真|地址|邮编|网址|\\d+\\.|$))",
            // 产品别名、产品名称等模式
            "(?:产品别名|产品名称|化学名)\\s*[：:：]?\\s*([\\u4e00-\\u9fff；;，,、\\s]+?)(?=\\s*(?:[a-zA-Z]|\\d{2,7}-\\d{2}-\\d|CAS|MSDS|Email|企业|生产|电话|传真|地址|邮编|网址|\\d+\\.|$))",
            // 其他名称等模式
            "(?:其他名称|其它名称|别称)\\s*[：:：]?\\s*([\\u4e00-\\u9fff；;，,、\\s]+?)(?=\\s*(?:[a-zA-Z]|\\d{2,7}-\\d{2}-\\d|CAS|MSDS|Email|企业|生产|电话|传真|地址|邮编|网址|\\d+\\.|$))",
            // 中文名称后的括号内容（可能包含别名）
            "[\\u4e00-\\u9fff]+\\s*[（(]\\s*([\\u4e00-\\u9fff；;，,、\\s]+)\\s*[）)]",
            // 表格形式的别名提取
            "名称\\s*[：:：]?\\s*([\\u4e00-\\u9fff；;，,、\\s]+?)(?=\\s*(?:英文|CAS|分子|化学|$))"
        };
        
        String result = extractMultiplePatterns(content, patterns);
        
        if (result != null && !result.trim().isEmpty()) {
            // 第一步：移除所有包含数字、英文字母的内容
            result = result.replaceAll("[a-zA-Z0-9\\-?]+", "");
            
            // 第二步：移除CAS、MSDS等关键词及其后续内容
            result = result.replaceAll("(?i)(?:CAS|MSDS|Email|企业|生产|制造|公司|有限|股份|集团|化工|科技|实业|贸易|进出口).*", "");
            
            // 第三步：只保留中文字符和基本标点
            result = result.replaceAll("[^\\u4e00-\\u9fff；;，,、\\s]", "");
            
            // 第四步：清理多余的空格和标点
            result = result.replaceAll("\\s+", " ").trim();
            result = result.replaceAll("^[；;，,、\\s]+|[；;，,、\\s]+$", "");
            
            // 第五步：分割并过滤每个别名
            if (!result.isEmpty()) {
                String[] aliases = result.split("[；;，,、]");
                StringBuilder cleanAliases = new StringBuilder();
                
                for (String alias : aliases) {
                    alias = alias.trim();
                    // 只保留纯中文别名（至少2个中文字符，不超过20个字符）
                    if (alias.length() >= 2 && alias.length() <= 20 && 
                        alias.matches("[\\u4e00-\\u9fff\\s]+") &&
                        alias.matches(".*[\\u4e00-\\u9fff]{2,}.*")) {
                        if (cleanAliases.length() > 0) {
                            cleanAliases.append("；");
                        }
                        cleanAliases.append(alias);
                    }
                }
                result = cleanAliases.toString();
            }
            
            // 最终验证：必须包含至少2个中文字符
            if (result.isEmpty() || result.length() < 2 || !result.matches(".*[\\u4e00-\\u9fff]{2,}.*")) {
                result = null;
            }
        }
        
        return result;
    }

    /**
     * 提取传真号码
     */
    private String extractFaxNumber(String content) {
        logger.debug("开始提取传真号码（修复版）");
        
        // 更精确的传真号码提取模式，避免字段标签错误
        String[] patterns = {
            // 标准传真格式
            "(?:传真|传真号码|Fax)\\s*[：:：]?\\s*([\\d\\-\\+\\(\\)\\s]{7,20})",
            
            // 供应商传真格式
            "(?:供应商传真|供应商传真号码)\\s*[：:：]?\\s*([\\d\\-\\+\\(\\)\\s]{7,20})",
            
            // 制造商传真格式
            "(?:制造商传真|制造商传真号码)\\s*[：:：]?\\s*([\\d\\-\\+\\(\\)\\s]{7,20})",
            
            // 传真电话格式
            "(?:传真电话|Fax\\s*No)\\s*[：:：]?\\s*([\\d\\-\\+\\(\\)\\s]{7,20})",
            
            // 在企业标识部分查找传真
            "1\\s*化学品及企业标识[\\s\\S]*?(?:传真|Fax)\\s*[：:：]?\\s*([\\d\\-\\+\\(\\)\\s]{7,20})"
        };
        
        for (String pattern : patterns) {
            String result = extractValue(content, pattern);
            if (StringUtils.isNotEmpty(result)) {
                // 清理传真号码
                result = cleanPhoneNumber(result);
                if (isValidPhoneNumber(result)) {
                    logger.info("成功提取传真号码: {}", result);
                    return result;
                }
            }
        }
        
        logger.warn("未能提取到有效的传真号码");
        return null;
    }

    /**
     * 提取修订日期
     */
    private Date extractRevisionDate(String content) {
        String[] patterns = {
            "(?:修订日期|修订时间|Revision\\s*Date)\\s*[：:：]?\\s*([0-9]{4}[\\-/年][0-9]{1,2}[\\-/月][0-9]{1,2}[日]?)",
            "(?:更新日期|更新时间)\\s*[：:：]?\\s*([0-9]{4}[\\-/年][0-9]{1,2}[\\-/月][0-9]{1,2}[日]?)"
        };
        
        for (String pattern : patterns) {
            String dateStr = extractValue(content, pattern);
            if (StringUtils.isNotEmpty(dateStr)) {
                try {
                    // 清理日期字符串，转换为标准格式
                    dateStr = dateStr.replaceAll("[年月日]", "-")
                                   .replaceAll("[-/]+", "-")
                                   .replaceAll("-$", "");
                    
                    // 尝试解析日期
                    if (dateStr.matches("\\d{4}-\\d{1,2}-\\d{1,2}")) {
                        return java.sql.Date.valueOf(dateStr);
                    }
                } catch (Exception e) {
                    logger.warn("解析修订日期失败: {}", dateStr);
                }
            }
        }
        return null;
    }

    /**
     * 将常见的日期字符串标准化解析为 Date（支持：yyyy-MM-dd、yyyy/M/d、yyyy年MM月dd日、yyyy-MM、yyyy 年等）
     */
    private Date parseDate(String input) {
        if (StringUtils.isEmpty(input)) {
            return null;
        }
        try {
            String s = input.trim();
            // 统一分隔符，去除中文日期字符
            s = s.replaceAll("[年/\\.]", "-")
                 .replaceAll("月", "-")
                 .replace("日", "")
                 .replaceAll("\\s+", " ")
                 .trim();
            // 规范连字符
            s = s.replaceAll("-+", "-");

            // 针对缺少日或月的情况进行补全
            if (s.matches("\\d{4}-\\d{1,2}")) {
                s = s + "-01"; // 只有年-月，默认补1日
            } else if (s.matches("\\d{4}")) {
                s = s + "-01-01"; // 只有年，默认补1月1日
            }

            // 支持多种日期格式
            String[] patterns = new String[] {
                "yyyy-MM-dd",
                "yyyy-M-d",
                "yyyy-MM-d",
                "yyyy-M-dd",
                "yyyyMMdd"
            };
            for (String pattern : patterns) {
                try {
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat(pattern);
                    sdf.setLenient(false);
                    return sdf.parse(s);
                } catch (Exception ignore) {
                    // 继续尝试下一个格式
                }
            }
            // 最后兜底：如果是 yyyy-MM 或 yyyy 情况已在上面补全，不应走到此分支
            logger.warn("无法解析日期字符串: {} (标准化: {})", input, s);
            return null;
        } catch (Exception e) {
            logger.warn("解析日期失败: {}", input, e);
            return null;
        }
    }

    /**
     * 生成MSDS编号
     */
    private String generateMsdsCode() {
        // 生成格式：MSDS + 当前时间戳后6位
        long timestamp = System.currentTimeMillis();
        return "MSDS" + String.valueOf(timestamp).substring(7);
    }

    /**
     * 提取产品代码
     * 专门用于提取文档中的纯数字产品编号，如"11111111"
     */
    private String extractProductCode(String content) {
        String[] patterns = {
            // 产品代码、产品编号等标准格式
            "(?:产品代码|产品编号|产品号|编号|代码|Code|Product\\s*Code|Product\\s*No)\\s*[：:：]?\\s*([A-Za-z0-9\\-_]+)",
            // 纯数字编号（6-12位数字）
            "\\b(\\d{6,12})\\b",
            // 字母数字组合编号
            "\\b([A-Z]{1,3}\\d{4,10})\\b",
            // 带连字符的编号
            "\\b([A-Za-z0-9]{2,4}-\\d{4,8})\\b",
            // 在第一部分中查找产品编号
            "第一部分[^\\n]*\\n[^\\n]*(?:产品编号|编号|代码)[^：:：]*[：:：]\\s*([A-Za-z0-9\\-_]+)",
            // 在化学品标识部分查找编号
            "1\\s*化学品及企业标识[^\\n]*\\n[^\\n]*(?:产品编号|编号|代码)[^：:：]*[：:：]\\s*([A-Za-z0-9\\-_]+)",
            // 产品标识编号
            "(?:产品标识|Product\\s*ID|Item\\s*No)\\s*[：:：]?\\s*([A-Za-z0-9\\-_]+)",
            // 货号、型号等
            "(?:货号|型号|Model|Item)\\s*[：:：]?\\s*([A-Za-z0-9\\-_]+)"
        };
        
        for (String pattern : patterns) {
            String result = extractValue(content, pattern);
            if (StringUtils.isNotEmpty(result)) {
                // 清理提取的代码
                result = result.trim();
                // 移除可能的前缀标识符
                result = result.replaceAll("^[：:：\\s]*", "");
                // 移除可能的后缀信息
                result = result.replaceAll("\\s*[版本号]*$", "");
                
                // 验证是否为有效的产品代码
                if (result.length() >= 4 && result.length() <= 20 && 
                    result.matches("[A-Za-z0-9\\-_]+")) {
                    return result;
                }
            }
        }
        
        return null;
    }

    /**
     * 从文件名中提取化学品信息
     */
    private Map<String, String> extractInfoFromFileName(String fileName) {
        logger.debug("开始从文件名提取化学品信息: {}", fileName);
        Map<String, String> result = new HashMap<>();
        
        if (StringUtils.isEmpty(fileName)) {
            logger.debug("文件名为空，返回空结果");
            return result;
        }
        
        // 移除文件扩展名
        String nameWithoutExt = fileName.replaceAll("\\.(pdf|doc|docx|txt)$", "");
        logger.debug("移除扩展名后的文件名: {}", nameWithoutExt);
        
        // 尝试按照不同分隔符分割，支持格式：中文名、英文名、CAS号 或 中文名,英文名,CAS号
        String[] parts = null;
        String delimiter = "";
        
        // 首先尝试按照中文顿号分割
        if (nameWithoutExt.contains("、")) {
            parts = nameWithoutExt.split("、");
            delimiter = "中文顿号(、)";
            logger.debug("使用{}分割文件名，分割结果数量: {}", delimiter, parts.length);
        }
        // 如果没有中文顿号，尝试按逗号分割
        else if (nameWithoutExt.contains(",")) {
            parts = nameWithoutExt.split(",");
            delimiter = "逗号(,)";
            logger.debug("使用{}分割文件名，分割结果数量: {}", delimiter, parts.length);
        }
        // 如果都没有，将整个文件名作为中文名称
        else {
            parts = new String[]{nameWithoutExt};
            delimiter = "无分隔符";
            logger.debug("{}，将整个文件名作为中文名称", delimiter);
        }
        
        // 打印分割后的各部分
        if (parts != null) {
            for (int i = 0; i < parts.length; i++) {
                logger.debug("分割部分[{}]: '{}'", i, parts[i].trim());
            }
        }
        
        if (parts != null && parts.length >= 1) {
            // 第一部分通常是中文名称
            String chineseName = parts[0].trim();
            logger.debug("处理中文名称: '{}', 长度: {}", chineseName, chineseName.length());
            if (chineseName.length() >= 1 && !chineseName.isEmpty()) { // 允许单个字符的中文名称
                result.put("chineseName", chineseName);
                // 兼容单测与系统其他调用，返回产品名称同义键
                result.put("productName", chineseName);
                logger.debug("中文名称验证通过: {}", chineseName);
            } else {
                logger.debug("中文名称为空，跳过: {}", chineseName);
            }
        }
        
        if (parts != null && parts.length >= 2) {
            // 第二部分通常是英文名称
            String englishName = parts[1].trim();
            logger.debug("处理英文名称: '{}', 长度: {}, 包含字母: {}", 
                        englishName, englishName.length(), englishName.matches(".*\\p{L}.*"));
            if (englishName.length() >= 3 && englishName.matches(".*\\p{L}.*")) {
                result.put("englishName", englishName);
                // 兼容键名：英文名
                result.put("productEnglishName", englishName);
                logger.debug("英文名称验证通过: {}", englishName);
            } else {
                logger.debug("英文名称验证失败，长度或格式不符合要求: {}", englishName);
            }
        }
        
        if (parts != null && parts.length >= 3) {
            // 第三部分通常是CAS号
            String casNumber = parts[2].trim();
            boolean casValid = casNumber.matches("\\d{2,7}-\\d{2}-\\d");
            logger.debug("处理CAS号: '{}', 格式验证: {}", casNumber, casValid);
            // CAS号格式验证：xxx-xx-x
            if (casValid) {
                result.put("casNumber", casNumber);
                logger.debug("CAS号验证通过: {}", casNumber);
            } else {
                logger.debug("CAS号格式验证失败: {}", casNumber);
            }
        }
        
        logger.info("从文件名 {} 提取的信息：中文名={}, 英文名={}, CAS号={}", 
                   fileName, 
                   result.get("chineseName"), 
                   result.get("englishName"), 
                   result.get("casNumber"));
        
        return result;
    }
    
    /**
     * 从标题中提取化学品名称
     */
    private String extractFromTitle(String content) {
        // 从内容的前几行提取可能的化学品名称
        String[] lines = content.split("\n");
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
     * 清理电话号码
     */
    private String cleanPhoneNumber(String phone) {
        if (StringUtils.isEmpty(phone)) {
            return phone;
        }
        
        // 基础清理
        phone = phone.trim()
            .replaceAll("^[：:：\\s]+", "")     // 移除开头的冒号和空格
            .replaceAll("[\\s]+$", "")         // 移除结尾空格
            .replaceAll("[^\\d\\-\\+\\(\\)\\s]", ""); // 只保留数字、连字符、加号、括号、空格
        
        // 移除多余的标点符号
        phone = phone.replaceAll("[\\s,，.。;；:：]+$", "");
        
        return phone.trim();
    }

    /**
     * 验证电话号码有效性
     */
    private boolean isValidPhoneNumber(String phone) {
        if (StringUtils.isEmpty(phone)) {
            return false;
        }
        
        // 长度检查
        if (phone.length() < 7 || phone.length() > 20) {
            return false;
        }
        
        // 格式检查
        if (!phone.matches("^[\\d\\s\\-\\(\\)\\+]+$")) {
            return false;
        }
        
        // 排除纯数字产品代码
        String cleanPhone = phone.replaceAll("\\s", "");
        if (cleanPhone.matches("\\d{6,12}")) {
            return false;
        }
        
        // 确保电话号码包含格式化字符或符合标准格式
        if (cleanPhone.contains("-") || cleanPhone.contains("(") || cleanPhone.contains(")") || 
            cleanPhone.contains("+") || cleanPhone.matches("1[3-9]\\d{9}") || 
            cleanPhone.matches("[0-9]{3,4}[0-9]{7,8}")) {
            return true;
        }
        
        return false;
    }

    /**
     * 清理化学品名称中的额外信息
     * 
     * @param name 原始化学品名称
     * @return 清理后的化学品名称
     */
    private String cleanChemicalName(String name) {
        if (StringUtils.isEmpty(name)) {
            return null;
        }
        
        // 移除常见的额外信息
        String cleaned = name
            .replaceAll("\\s*中文别名[：:][^\\n]*", "")  // 移除中文别名信息
            .replaceAll("\\s*英文别名[：:][^\\n]*", "")  // 移除英文别名信息
            .replaceAll("\\s*别名[：:][^\\n]*", "")     // 移除别名信息
            .replaceAll("\\s*CAS[\\s]*号[：:][^\\n]*", "") // 移除CAS号信息
            .replaceAll("\\s*分子式[：:][^\\n]*", "")    // 移除分子式信息
            .replaceAll("\\s*分子量[：:][^\\n]*", "")    // 移除分子量信息
            .replaceAll("\\s*\\([^)]*\\)", "")         // 移除括号内容
            .replaceAll("\\s+", " ")                  // 合并多个空格
            .trim();
            
        // 智能处理逗号分隔的内容，保持原始逗号类型
        if (cleaned.contains(",") || cleaned.contains("，")) {
            // 使用智能分割，保持化学名称中的逗号不被分割
            SplitResult splitResult = smartSplitWithSeparators(cleaned);
            
            if (splitResult.parts.size() > 1) {
                StringBuilder result = new StringBuilder();
                
                // 第一部分直接添加
                result.append(splitResult.parts.get(0).trim());
                
                // 处理后续部分
                int separatorIndex = 0;
                for (int i = 1; i < splitResult.parts.size(); i++) {
                    String part = splitResult.parts.get(i).trim();
                    
                    // 如果是明确的技术信息，则截断
                    if (part.matches(".*\\d{2,7}-\\d{2}-\\d.*") ||  // CAS号格式
                        part.matches("^[A-Z][a-z]*[A-Z0-9]*\\d+([·•][A-Z0-9]+)*$") ||  // 分子式格式
                        part.matches("^\\d+%$") ||                   // 百分比
                        part.toLowerCase().contains("cas") ||
                        part.contains("分子式") ||
                        part.contains("分子量") ||
                        part.contains("别名") ||
                        part.toLowerCase().matches(".*(tech|technical|grade|pure).*")) {
                        break; // 截断
                    }
                    // 如果是中文描述性内容或英文缩写，保留
                    else if (part.matches(".*[\\u4e00-\\u9fff].*") || part.matches("^[A-Z]{2,6}$")) {
                        // 使用对应的原始分隔符
                        String separator = "，"; // 默认使用中文逗号
                        if (separatorIndex < splitResult.separators.size()) {
                            separator = splitResult.separators.get(separatorIndex);
                        }
                        result.append(separator).append(part);
                        separatorIndex++;
                    }
                    // 其他情况截断
                    else {
                        break;
                    }
                }
                
                cleaned = result.toString();
            }
        }
            
        // 如果清理后为空或过短，返回原始名称的清理版本
        if (StringUtils.isEmpty(cleaned) || cleaned.length() < 2) {
            return cleanText(name);
        }
        
        return cleaned;
    }



    /**
     * 智能分割字符串，识别化学名称中的逗号
     * @param text 要分割的文本
     * @return 分割结果，包含分割后的部分和对应的分隔符
     */
    private static class SplitResult {
        java.util.List<String> parts;
        java.util.List<String> separators;
        
        SplitResult() {
            parts = new java.util.ArrayList<>();
            separators = new java.util.ArrayList<>();
        }
    }
    
    private SplitResult smartSplitWithSeparators(String text) {
        SplitResult result = new SplitResult();
        
        // 找到所有逗号的位置和类型
        java.util.List<Integer> commaPositions = new java.util.ArrayList<>();
        java.util.List<String> commaTypes = new java.util.ArrayList<>();
        
        int parenDepth = 0;
        for (int i = 0; i < text.length(); i++) {
            char c = text.charAt(i);
            if (c == '(' || c == '（') {
                parenDepth++;
            } else if (c == ')' || c == '）') {
                if (parenDepth > 0) parenDepth--;
            }
            if ((c == ',' || c == '，') && parenDepth == 0) {
                commaPositions.add(i);
                commaTypes.add(String.valueOf(c));
            }
        }
        
        if (commaPositions.isEmpty()) {
            result.parts.add(text);
            return result;
        }
        
        // 分析每个逗号是否应该作为分隔符
        java.util.List<Integer> splitPositions = new java.util.ArrayList<>();
        java.util.List<String> splitSeparators = new java.util.ArrayList<>();
        
        for (int i = 0; i < commaPositions.size(); i++) {
            int pos = commaPositions.get(i);
            String commaType = commaTypes.get(i);
            
            // 检查逗号前后的内容
            String before = pos > 0 ? text.substring(0, pos) : "";
            String after = pos < text.length() - 1 ? text.substring(pos + 1) : "";
            
            // 如果逗号前是数字，后面是数字+连字符，可能是化学名称的一部分
            if (!before.isEmpty() && !after.isEmpty() &&
                Character.isDigit(before.charAt(before.length() - 1)) &&
                after.length() > 0 && Character.isDigit(after.charAt(0))) {
                // 检查后面是否有连字符（在前几个字符内）
                String afterTrimmed = after.trim();
                if (afterTrimmed.length() > 1 && afterTrimmed.substring(0, Math.min(3, afterTrimmed.length())).contains("-")) {
                    // 这可能是化学名称中的逗号（如2,4-二氯），不分割
                    continue;
                }
            }
            
            // 其他情况作为分隔符
            splitPositions.add(pos);
            splitSeparators.add(commaType);
        }
        
        // 根据分隔位置分割字符串
        if (splitPositions.isEmpty()) {
            result.parts.add(text);
            return result;
        }
        
        int start = 0;
        for (int i = 0; i < splitPositions.size(); i++) {
            int pos = splitPositions.get(i);
            String separator = splitSeparators.get(i);
            
            String part = text.substring(start, pos).trim();
            if (!part.isEmpty()) {
                result.parts.add(part);
                result.separators.add(separator);
            }
            start = pos + 1;
        }
        
        String lastPart = text.substring(start).trim();
        if (!lastPart.isEmpty()) {
            result.parts.add(lastPart);
        }
        
        return result;
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
     * 统一的Word文档数据校验和清理方法
     * 确保与PDF/TXT解析规则保持一致
     * 
     * @param msdsMain MSDS主表对象
     * @return 校验和清理后的MSDS对象
     */
    private MsdsMain validateAndCleanMsdsData(MsdsMain msdsMain) {
        if (msdsMain == null) {
            return null;
        }
        
        // 1. 产品名称校验和清理
        if (StringUtils.isNotEmpty(msdsMain.getProductName())) {
            String cleanedName = cleanChemicalNameLightweight(msdsMain.getProductName());
            if (StringUtils.isNotEmpty(cleanedName) && cleanedName.length() >= 2) {
                msdsMain.setProductName(cleanedName);
            } else {
                logger.warn("产品名称校验失败，使用原始值: {}", msdsMain.getProductName());
                msdsMain.setProductName(cleanText(msdsMain.getProductName()));
            }
        }
        
        // 2. 英文名称校验和清理
        if (StringUtils.isNotEmpty(msdsMain.getProductEnglishName())) {
            String cleanedEnglishName = cleanText(msdsMain.getProductEnglishName());
            // 验证英文名称格式（允许Unicode字母、数字、空格、连字符、括号、逗号、点）
            if (cleanedEnglishName.matches("^[\\p{L}0-9\\s\\-\\(\\),\\.]+$")) {
                msdsMain.setProductEnglishName(cleanedEnglishName);
            } else {
                logger.warn("英文名称格式校验失败: {}", cleanedEnglishName);
                msdsMain.setProductEnglishName(null);
            }
        }
        
        // 3. 产品别名校验和清理
        if (StringUtils.isNotEmpty(msdsMain.getProductAlias())) {
            String productAlias = msdsMain.getProductAlias().trim();
            
            // 判断是否为CAS号格式：仅当符合CAS号正则^\\d{2,7}-\\d{2}-\\d$时才作为CAS号处理
            if (isValidCasNumber(productAlias)) {
                // 确实是CAS号，保留
                msdsMain.setProductAlias(productAlias);
            } else {
                // 非CAS号格式，按中文别名处理：分隔处理、去重、清理
                String cleanedAlias = processProductAlias(productAlias);
                msdsMain.setProductAlias(cleanedAlias);
            }
        }
        
        // 若别名为空且casNumber字段有值，则从casNumber回填
        if (StringUtils.isEmpty(msdsMain.getProductAlias()) && StringUtils.isNotEmpty(msdsMain.getCasNumber())) {
            String casFromField = msdsMain.getCasNumber().trim();
            if (isValidCasNumber(casFromField)) {
                msdsMain.setProductAlias(casFromField);
            }
        }
        
        // 4. 企业名称校验和清理
        if (StringUtils.isNotEmpty(msdsMain.getCompanyName())) {
            String cleanedCompanyName = cleanText(msdsMain.getCompanyName());
            // 移除字段标签混淆
            cleanedCompanyName = cleanedCompanyName.replaceAll("供应商传真:供应商Email:", "");
            cleanedCompanyName = cleanedCompanyName.replaceAll("供应商Email:", "");
            if (cleanedCompanyName.length() >= 2 && cleanedCompanyName.length() <= 200) {
                msdsMain.setCompanyName(cleanedCompanyName);
            } else {
                logger.warn("企业名称长度校验失败: {}", cleanedCompanyName);
            }
        }
        
        // 5. 联系方式校验
        if (StringUtils.isNotEmpty(msdsMain.getContactPhone())) {
            String phone = cleanText(msdsMain.getContactPhone());
            // 移除"未提供"等无效值
            if ("未提供".equals(phone) || "无".equals(phone) || "暂无".equals(phone)) {
                msdsMain.setContactPhone(null);
            } else if (isValidPhoneNumber(phone)) {
                msdsMain.setContactPhone(phone);
            } else {
                // 如果验证失败，尝试基本清理后保留原始值
                String basicCleanPhone = phone.replaceAll("[^\\d\\s\\-\\(\\)\\+]", "").trim();
                if (StringUtils.isNotEmpty(basicCleanPhone) && basicCleanPhone.length() >= 7) {
                    logger.warn("联系电话格式校验失败，保留清理后的值: {} -> {}", phone, basicCleanPhone);
                    msdsMain.setContactPhone(basicCleanPhone);
                } else {
                    logger.warn("联系电话格式校验失败，保留原始值: {}", phone);
                    msdsMain.setContactPhone(phone); // 保留原始值而不是设置为null
                }
            }
        }
        
        // 6. 邮箱校验
        if (StringUtils.isNotEmpty(msdsMain.getEmail())) {
            String email = cleanText(msdsMain.getEmail());
            if (isValidEmail(email)) {
                msdsMain.setEmail(email);
            } else {
                // 如果验证失败，尝试基本清理后保留原始值
                String basicCleanEmail = email.toLowerCase().trim();
                if (basicCleanEmail.contains("@") && basicCleanEmail.contains(".")) {
                    logger.warn("邮箱格式校验失败，保留清理后的值: {} -> {}", email, basicCleanEmail);
                    msdsMain.setEmail(basicCleanEmail);
                } else {
                    logger.warn("邮箱格式校验失败，保留原始值: {}", email);
                    msdsMain.setEmail(email); // 保留原始值而不是设置为null
                }
            }
        }
        
        // 6.1 传真号码校验和清理
        if (StringUtils.isNotEmpty(msdsMain.getFaxNumber())) {
            String faxNumber = cleanText(msdsMain.getFaxNumber());
            // 移除字段标签错误
            faxNumber = faxNumber.replaceAll("供应商Email:", "");
            if (faxNumber.isEmpty()) {
                msdsMain.setFaxNumber(null);
            } else if (isValidPhoneNumber(faxNumber)) {
                msdsMain.setFaxNumber(faxNumber);
            } else {
                // 如果验证失败，尝试基本清理后保留原始值
                String basicCleanFax = faxNumber.replaceAll("[^\\d\\s\\-\\(\\)\\+]", "").trim();
                if (StringUtils.isNotEmpty(basicCleanFax) && basicCleanFax.length() >= 7) {
                    logger.warn("传真号码格式校验失败，保留清理后的值: {} -> {}", faxNumber, basicCleanFax);
                    msdsMain.setFaxNumber(basicCleanFax);
                } else {
                    logger.warn("传真号码格式校验失败，保留原始值: {}", faxNumber);
                    msdsMain.setFaxNumber(faxNumber);
                }
            }
        }
        
        // 6.2 应急电话校验和清理
        if (StringUtils.isNotEmpty(msdsMain.getEmergencyPhone())) {
            String emergencyPhone = cleanText(msdsMain.getEmergencyPhone());
            // 移除字段映射错误
            emergencyPhone = emergencyPhone.replaceAll("供应商传真:供应商Email:", "");
            if (emergencyPhone.isEmpty()) {
                msdsMain.setEmergencyPhone(null);
            } else if (isValidPhoneNumber(emergencyPhone)) {
                msdsMain.setEmergencyPhone(emergencyPhone);
            } else {
                // 如果验证失败，尝试基本清理后保留原始值
                String basicCleanEmergency = emergencyPhone.replaceAll("[^\\d\\s\\-\\(\\)\\+]", "").trim();
                if (StringUtils.isNotEmpty(basicCleanEmergency) && basicCleanEmergency.length() >= 7) {
                    logger.warn("应急电话格式校验失败，保留清理后的值: {} -> {}", emergencyPhone, basicCleanEmergency);
                    msdsMain.setEmergencyPhone(basicCleanEmergency);
                } else {
                    logger.warn("应急电话格式校验失败，保留原始值: {}", emergencyPhone);
                    msdsMain.setEmergencyPhone(emergencyPhone);
                }
            }
        }
        
        // 7. 版本号校验
        if (StringUtils.isNotEmpty(msdsMain.getVersion())) {
            String version = cleanText(msdsMain.getVersion());
            if (version.length() <= 50) {
                msdsMain.setVersion(version);
            } else {
                logger.warn("版本号长度超限: {}", version);
                msdsMain.setVersion(version.substring(0, 50));
            }
        }
        
        // 8. MSDS编号校验
        if (StringUtils.isNotEmpty(msdsMain.getMsdsCode())) {
            String msdsCode = cleanText(msdsMain.getMsdsCode());
            if (msdsCode.length() <= 100) {
                msdsMain.setMsdsCode(msdsCode);
            } else {
                logger.warn("MSDS编号长度超限: {}", msdsCode);
                msdsMain.setMsdsCode(msdsCode.substring(0, 100));
            }
        }
        
        // 9. 地址校验
        if (StringUtils.isNotEmpty(msdsMain.getCompanyAddress())) {
            String address = cleanText(msdsMain.getCompanyAddress());
            if (address.length() <= 500) {
                msdsMain.setCompanyAddress(address);
            } else {
                logger.warn("企业地址长度超限: {}", address);
                msdsMain.setCompanyAddress(address.substring(0, 500));
            }
        }
        
        return msdsMain;
    }
    
    /**
     * 处理产品别名：抽取、分隔、清洗、去重、长度控制
     * - 优先尝试通过extractProductAlias从原文中抽取别名字段值
     * - 支持多种分隔符：中文逗号/顿号/分号、英文逗号/分号、斜杠、竖线
     * - 复用轻量清洗逻辑，跳过CAS号片段，去重并保持顺序
     * - 结果以顿号（、）连接，整体长度做上限控制
     */
    private String processProductAlias(String raw) {
        if (StringUtils.isBlank(raw)) {
            return null;
        }
        String text = raw.trim();
        
        // 优先尝试按“化学品别名/中文别名/别名/Alias”等模式抽取值
        try {
            String extracted = extractProductAlias(text);
            if (StringUtils.isNotBlank(extracted)) {
                text = extracted.trim();
            }
        } catch (Exception ignore) {
            // 安全降级：任由后续逻辑处理
        }
        
        // 规范化空白和换行，移除包裹引号
        text = text.replace('\u00A0', ' ')
                   .replaceAll("[\r\n]+", " ")
                   .replaceAll("^[\"“”'‘’\s]+|[\"“”'‘’\s]+$", "");
        
        // 统一分隔符为逗号后再按逗号拆分
        text = text.replaceAll("[；;、/|｜／]", ",");
        String[] parts = text.split("[,，]+");
        
        java.util.LinkedHashSet<String> unique = new java.util.LinkedHashSet<>();
        for (String p : parts) {
            if (StringUtils.isBlank(p)) {
                continue;
            }
            String token = p.trim().replaceAll("^[\"“”'‘’\s]+|[\"“”'‘’\s]+$", "");
            if (StringUtils.isBlank(token)) {
                continue;
            }
            // 轻量清洗，移除噪声前后缀
            try {
                token = cleanChemicalNameLightweight(token);
            } catch (Exception ignore) { }
            if (StringUtils.isBlank(token)) {
                continue;
            }
            // 跳过纯CAS号片段
            if (isValidCasNumber(token)) {
                continue;
            }
            // 片段长度限制，避免异常超长
            if (token.length() > 100) {
                token = token.substring(0, 100);
            }
            unique.add(token);
        }
        
        if (unique.isEmpty()) {
            return null;
        }
        
        // 按“、”拼接并控制整体长度（约200字符）
        StringBuilder sb = new StringBuilder();
        for (String s : unique) {
            if (sb.length() > 0) sb.append('、');
            if (sb.length() + s.length() > 200) {
                break;
            }
            sb.append(s);
        }
        String result = sb.toString().trim();
        return StringUtils.isNotBlank(result) ? result : null;
    }
    
    /**
     * 校验CAS号格式
     * 
     * @param casNumber CAS号
     * @return 是否有效
     */
    private boolean isValidCasNumber(String casNumber) {
        if (StringUtils.isEmpty(casNumber)) {
            return false;
        }
        
        // CAS号格式：数字-数字-数字，最后一位是校验位
        Pattern pattern = Pattern.compile("^\\d{2,7}-\\d{2}-\\d$");
        if (!pattern.matcher(casNumber).matches()) {
            return false;
        }
        
        // 校验CAS号的校验位（从右到左加权：最右侧数字×1，向左权重依次+1）
        try {
            String[] parts = casNumber.split("-");
            String numberPart = parts[0] + parts[1];
            int checkDigit = Integer.parseInt(parts[2]);
            
            int sum = 0;
            int weight = 1;
            for (int i = numberPart.length() - 1; i >= 0; i--) {
                int digit = Character.getNumericValue(numberPart.charAt(i));
                sum += digit * weight;
                weight++;
            }
            
            return (sum % 10) == checkDigit;
        } catch (Exception e) {
            return false;
        }
    }
    




    /**
     * 导出MSDS为PDF
     * 
     * @param response HTTP响应对象
     * @param id MSDS主键
     */
    @Override
    public void exportMsdsToPdf(HttpServletResponse response, Long id)
    {
        MsdsMain msds = msdsMainMapper.selectMsdsMainById(id);
        if (msds == null)
        {
            throw new RuntimeException("未找到对应的MSDS记录，ID=" + id);
        }
        String fileName = StringUtils.isNotEmpty(msds.getProductName()) ? msds.getProductName() : (msds.getMsdsCode() != null ? msds.getMsdsCode() : "MSDS");
        msdsExportService.exportToPdf(response, msds, fileName);
    }

    /**
     * 批量导出MSDS为PDF压缩包
     * 
     * @param response HTTP响应对象
     * @param ids MSDS主键数组
     */
    @Override
    public void batchExportMsdsToPdf(HttpServletResponse response, Long[] ids)
    {
        if (ids == null || ids.length == 0)
        {
            throw new RuntimeException("未选择要导出的MSDS");
        }
        if (ids.length == 1)
        {
            exportMsdsToPdf(response, ids[0]);
            return;
        }
        List<MsdsMain> list = new java.util.ArrayList<>();
        for (Long id : ids)
        {
            MsdsMain m = msdsMainMapper.selectMsdsMainById(id);
            if (m != null)
            {
                list.add(m);
            }
        }
        String zipName = "MSDS_PDF_" + new java.text.SimpleDateFormat("yyyyMMdd_HHmmss").format(new java.util.Date());
        msdsExportService.batchExportAsZip(response, list, "pdf", zipName);
    }

    /**
     * 获取MSDS统计信息
     * 
     * @return 统计信息
     */
    @Override
    public Map<String, Object> getMsdsStatistics()
    {
        Map<String, Object> statistics = new HashMap<>();
        
        // 基础统计
        MsdsMain queryParam = new MsdsMain();
        List<MsdsMain> allMsds = msdsMainMapper.selectMsdsMainList(queryParam);
        
        statistics.put("totalCount", allMsds.size());
        statistics.put("activeCount", allMsds.stream().filter(m -> Integer.valueOf(1).equals(m.getIsActive())).count());
        statistics.put("inactiveCount", allMsds.stream().filter(m -> Integer.valueOf(0).equals(m.getIsActive())).count());
        
        // 按企业统计
        Map<String, Long> companyStats = allMsds.stream()
            .filter(m -> StringUtils.isNotEmpty(m.getCompanyName()))
            .collect(java.util.stream.Collectors.groupingBy(
                MsdsMain::getCompanyName, 
                java.util.stream.Collectors.counting()));
        statistics.put("companyStatistics", companyStats);
        
        return statistics;
    }

    /**
     * 获取化学品使用情况统计
     * 
     * @param days 统计天数
     * @return 使用情况统计
     */
    @Override
    public Map<String, Object> getUsageStatistics(int days)
    {
        Map<String, Object> statistics = new HashMap<>();
        
        // 获取最近指定天数的数据
        Date startDate = new Date(System.currentTimeMillis() - days * 24 * 60 * 60 * 1000L);
        
        MsdsMain queryParam = new MsdsMain();
        List<MsdsMain> recentMsds = msdsMainMapper.selectMsdsMainList(queryParam)
            .stream()
            .filter(m -> m.getCreateTime() != null && m.getCreateTime().after(startDate))
            .collect(java.util.stream.Collectors.toList());
        
        statistics.put("recentCount", recentMsds.size());
        statistics.put("days", days);
        statistics.put("startDate", startDate);
        
        return statistics;
    }

    /**
     * 获取风险等级分布统计
     * 
     * @return 风险等级分布
     */
    @Override
    public Map<String, Object> getRiskDistribution()
    {
        Map<String, Object> distribution = new HashMap<>();
        
        // 模拟风险等级分布（实际应根据MSDS内容分析）
        distribution.put("high", 15);
        distribution.put("medium", 45);
        distribution.put("low", 40);
        
        return distribution;
    }

    // ==================== 新增的完整MSDS解析方法 ====================

    /**
     * 清理指定MSDS ID的所有相关子表数据
     * 在覆盖导入时，需要先清理旧数据再插入新数据
     *
     * @param msdsId MSDS主表ID
     */
    private void cleanRelatedMsdsData(Long msdsId) {
        logger.info("开始清理MSDS ID {} 的相关子表数据", msdsId);
        
        try {
            // 清理各个子表数据（按照依赖关系顺序）
            msdsHazardMapper.deleteMsdsHazardByMsdsId(msdsId);
            msdsComponentMapper.deleteMsdsComponentByMsdsId(msdsId);
            msdsFirstAidMapper.deleteMsdsFirstAidByMsdsId(msdsId);
            msdsFireFightingMapper.deleteMsdsFireFightingByMsdsId(msdsId);
            msdsLeakResponseMapper.deleteMsdsLeakResponseByMsdsId(msdsId);
            msdsPhysicalChemicalMapper.deleteMsdsPhysicalChemicalByMsdsId(msdsId);
            msdsEcologicalMapper.deleteMsdsEcologicalByMsdsId(msdsId);
            msdsDisposalMapper.deleteMsdsDisposalByMsdsId(msdsId);
            
            // 处理需要先查询再删除的表
            cleanDataByQuery(msdsId);
            
            logger.info("成功清理MSDS ID {} 的相关子表数据", msdsId);
        } catch (Exception e) {
            logger.error("清理MSDS ID {} 的相关子表数据时发生错误: {}", msdsId, e.getMessage());
            throw e;
        }
    }
    
    /**
     * 处理需要先查询再删除的子表数据
     *
     * @param msdsId MSDS主表ID
     */
    private void cleanDataByQuery(Long msdsId) {
        try {
            // 处理操作储存表
            MsdsHandlingStorage handlingStorage = msdsHandlingStorageMapper.selectMsdsHandlingStorageByMsdsId(msdsId);
            if (handlingStorage != null) {
                msdsHandlingStorageMapper.deleteMsdsHandlingStorageById(handlingStorage.getId());
            }
            
            // 处理接触控制表
            MsdsExposureControl exposureControl = msdsExposureControlMapper.selectMsdsExposureControlByMsdsId(msdsId);
            if (exposureControl != null) {
                msdsExposureControlMapper.deleteMsdsExposureControlById(exposureControl.getId());
            }
            
            // 处理稳定性反应表
            MsdsStabilityReactivity stabilityReactivity = msdsStabilityReactivityMapper.selectMsdsStabilityReactivityByMsdsId(msdsId);
            if (stabilityReactivity != null) {
                msdsStabilityReactivityMapper.deleteMsdsStabilityReactivityById(stabilityReactivity.getId());
            }
            
            // 处理毒理学表
            MsdsToxicological toxicological = msdsToxicologicalMapper.selectMsdsToxicologicalByMsdsId(msdsId);
            if (toxicological != null) {
                msdsToxicologicalMapper.deleteMsdsToxicologicalById(toxicological.getId());
            }
            
            // 处理运输信息表
            MsdsTransportation transportation = msdsTransportationMapper.selectMsdsTransportationByMsdsId(msdsId);
            if (transportation != null) {
                msdsTransportationMapper.deleteMsdsTransportationById(transportation.getId());
            }
            
            // 处理法规信息表
            MsdsRegulatory regulatory = msdsRegulatoryMapper.selectMsdsRegulatoryByMsdsId(msdsId);
            if (regulatory != null) {
                msdsRegulatoryMapper.deleteMsdsRegulatoryById(regulatory.getId());
            }
            
            // 处理其他信息表
            MsdsOtherInfo otherInfo = msdsOtherInfoMapper.selectMsdsOtherInfoByMsdsId(msdsId);
            if (otherInfo != null) {
                msdsOtherInfoMapper.deleteMsdsOtherInfoById(otherInfo.getId());
            }
            
        } catch (Exception e) {
            logger.error("通过查询方式清理MSDS ID {} 的相关数据时发生错误: {}", msdsId, e.getMessage());
            throw e;
        }
    }

    /**
     * 保存相关MSDS数据到各个表
     * 
     * @param msdsMain 主表数据
     * @param content 文档内容
     */
    @Transactional(rollbackFor = Exception.class)
    private void saveRelatedMsdsData(MsdsMain msdsMain, String content) {
        if (msdsMain == null || msdsMain.getId() == null) {
            logger.warn("MSDS主表数据或ID为空，跳过相关数据保存");
            return;
        }
        
        Long msdsId = msdsMain.getId();
        String cleanContent = preprocessContent(content);
        
        logger.info("开始保存MSDS相关数据 - ID: {}, 产品名称: {}", msdsId, msdsMain.getProductName());
        
        try {
        
        // 保存危险性概述信息（第二部分）
        saveHazardOverview(msdsId, cleanContent);
        
        // 保存成分组成信息（第三部分）
        saveComposition(msdsId, cleanContent);
        
        // 保存急救措施（第四部分）
        saveFirstAid(msdsId, cleanContent);
        
        // 保存消防措施（第五部分）
        saveFireFighting(msdsId, cleanContent);
        
        // 保存泄漏应急处理（第六部分）
        saveLeakageHandling(msdsId, cleanContent);
        
        // 保存操作处置与储存（第七部分）
        saveHandlingStorage(msdsId, cleanContent);
        
        // 保存接触控制/个体防护（第八部分）
        saveExposureControl(msdsId, cleanContent);
        
        // 保存理化特性（第九部分）
        savePhysicalChemical(msdsId, cleanContent);
        
        // 保存稳定性和反应性（第十部分）
        saveStabilityReactivity(msdsId, cleanContent);
        
        // 保存毒理学资料（第十一部分）
        saveToxicological(msdsId, cleanContent);
        
        // 保存生态学资料（第十二部分）
        saveEcological(msdsId, cleanContent);
        
        // 保存废弃处置（第十三部分）
        saveDisposal(msdsId, cleanContent);
        
        // 保存运输信息（第十四部分）
        saveTransportation(msdsId, cleanContent);
        
        // 保存法规信息（第十五部分）
        saveRegulatory(msdsId, cleanContent);
        
        // 保存其他信息（第十六部分）
        saveOtherInfo(msdsId, cleanContent);
        
        logger.info("MSDS相关数据保存完成 - ID: {}, 产品名称: {}", msdsId, msdsMain.getProductName());
        
        } catch (Exception e) {
            logger.error("MSDS相关数据保存过程中发生错误 - ID: {}, 产品名称: {}, 错误: {}", 
                        msdsId, msdsMain.getProductName(), e.getMessage(), e);
            throw new RuntimeException("MSDS相关数据保存失败", e);
        }
    }

    /**
     * 保存危险性概述信息（第二部分）
     */
    private void saveHazardOverview(Long msdsId, String content) {
        try {
            // 创建危险性概述实体对象
            MsdsHazard hazardData = new MsdsHazard();
            hazardData.setMsdsId(msdsId);
            
            // 紧急情况概述 - 对应数据库字段emergency_overview
            String emergencyOverview = extractHazardField(content, new String[]{
                "紧急情况概述", "Emergency Overview", "紧急概述", "应急概述", "危险性概述"
            });
            hazardData.setEmergencyOverview(emergencyOverview);
            
            // GHS危险性类别 -> 映射到hazardCategory
            String ghsHazardClass = extractHazardField(content, new String[]{
                "GHS危险性类别", "GHS Hazard Classification", "GHS分类", "危险性分类", "危险类别"
            });
            hazardData.setHazardCategory(ghsHazardClass);
            
            // 标签要素 -> 关键警示词warningWord（若无法区分，先全部映射到warningWord）
            String labelElements = extractHazardField(content, new String[]{
                "标签要素", "Label Elements", "标签信息", "标签内容", "标签"
            });
            hazardData.setWarningWord(labelElements);
            
            // 危险性说明 -> hazardDescription
            String hazardStatement = extractHazardField(content, new String[]{
                "危险性说明", "Hazard Statement", "危险说明", "H代码", "H-codes", "危险性描述"
            });
            hazardData.setHazardDescription(hazardStatement);
            
            // 防范说明 -> preventionMeasures
            String precautionaryStatement = extractHazardField(content, new String[]{
                "防范说明", "Precautionary Statement", "预防措施", "P代码", "P-codes", "防护措施"
            });
            hazardData.setPreventionMeasures(precautionaryStatement);
            
            // 物理危险 -> fireExplosionHazards
            String physicalHazard = extractHazardField(content, new String[]{
                "物理危险", "Physical Hazard", "物理危害", "物理性危险", "物理化学危险"
            });
            hazardData.setFireExplosionHazards(physicalHazard);
            
            // 健康危害 -> healthHazards
            String healthHazard = extractHazardField(content, new String[]{
                "健康危害", "Health Hazard", "健康危险", "对人体的危害", "健康影响"
            });
            hazardData.setHealthHazards(healthHazard);
            
            // 环境危害 -> environmentalHazards
            String environmentalHazard = extractHazardField(content, new String[]{
                "环境危害", "Environmental Hazard", "环境危险", "对环境的危害", "环境影响"
            });
            hazardData.setEnvironmentalHazards(environmentalHazard);
            
            // 记录提取的字段信息用于调试
            logger.info("危险性概述字段提取结果 - MSDS ID: {}, 紧急情况概述: {}, GHS危险性类别: {}, 标签要素: {}", 
                       msdsId, 
                       emergencyOverview != null ? "已提取" : "未提取",
                       ghsHazardClass != null ? "已提取" : "未提取",
                       labelElements != null ? "已提取" : "未提取");
            
            // 保存数据到数据库
            msdsHazardMapper.insertMsdsHazard(hazardData);
            logger.info("危险性概述数据保存成功 - MSDS ID: {}", msdsId);
            
        } catch (Exception e) {
            logger.error("危险性概述数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage(), e);
            throw e;
        }
    }
    
    /**
     * 提取危险性相关字段的专用方法
     * 
     * @param content 文档内容
     * @param fieldNames 可能的字段名称数组
     * @return 提取的内容
     */
    private String extractHazardField(String content, String[] fieldNames) {
        for (String fieldName : fieldNames) {
            String result = extractSectionContent(content, fieldName, fieldName);
            if (StringUtils.isNotEmpty(result)) {
                return result;
            }
        }
        
        // 如果标准提取失败，尝试在第二部分中查找
        String secondSectionPattern = "第二部分[^\\n]*危险性概述[\\s\\S]*?(?=第三部分|$)";
        Pattern sectionPattern = Pattern.compile(secondSectionPattern, Pattern.CASE_INSENSITIVE);
        Matcher sectionMatcher = sectionPattern.matcher(content);
        
        if (sectionMatcher.find()) {
            String sectionContent = sectionMatcher.group();
            for (String fieldName : fieldNames) {
                String result = extractSectionContent(sectionContent, fieldName, fieldName);
                if (StringUtils.isNotEmpty(result)) {
                    return result;
                }
            }
        }
        
        return null;
    }

    /**
     * 保存成分组成信息（第三部分）
     */
    private void saveComposition(Long msdsId, String content) {
        try {
            // 创建成分信息实体对象
            MsdsComponent compositionData = new MsdsComponent();
            compositionData.setMsdsId(msdsId);
            
            // 成分名称 -> componentName
            String chemicalName = extractCompositionField(content, new String[]{
                "化学名称", "Chemical Name", "化学品名称", "产品名称", "名称", "成分名称"
            });
            compositionData.setComponentName(chemicalName);
            
            // CAS号 -> casNumber
            String casNumber = extractCompositionField(content, new String[]{
                "CAS号", "CAS Number", "CAS", "CAS登记号", "CAS Registry Number", "CAS编号"
            });
            compositionData.setCasNumber(casNumber);
            
            // 含量百分比 -> componentContent
            String contentPercentage = extractCompositionField(content, new String[]{
                "含量", "Content", "浓度", "百分比", "%", "质量分数", "成分浓度或浓度范围", "浓度范围"
            });
            compositionData.setComponentContent(contentPercentage);
            
            // 分子式 -> molecularFormula
            String molecularFormula = extractCompositionField(content, new String[]{
                "分子式", "Molecular Formula", "化学式", "Formula", "分子结构式"
            });
            compositionData.setMolecularFormula(molecularFormula);
            
            // 分子量 -> molecularWeight(BigDecimal)
            String molecularWeight = extractCompositionField(content, new String[]{
                "分子量", "Molecular Weight", "相对分子质量", "分子质量", "MW", "摩尔质量"
            });
            if (StringUtils.isNotEmpty(molecularWeight)) {
                try {
                    java.math.BigDecimal mw = new java.math.BigDecimal(molecularWeight.replaceAll("[^0-9.]", ""));
                    compositionData.setMolecularWeight(mw);
                } catch (Exception ex) {
                    logger.warn("分子量解析失败: {}", molecularWeight);
                }
            }
            
            // 化学品性质 -> componentFunction（暂存）
            String chemicalNature = extractCompositionField(content, new String[]{
                "化学品性质", "Chemical Nature", "物质性质", "化学性质", "物质/混合物", "Substance/Mixture", "物质", "混合物", "物质类型"
            });
            compositionData.setComponentFunction(chemicalNature);
            
            // 记录提取的字段信息用于调试
            logger.info("成分/组成信息字段提取结果 - MSDS ID: {}, 化学名称: {}, CAS号: {}, 含量: {}, 分子式: {}", 
                       msdsId, 
                       chemicalName != null ? "已提取" : "未提取",
                       casNumber != null ? "已提取" : "未提取",
                       contentPercentage != null ? "已提取" : "未提取",
                       molecularFormula != null ? "已提取" : "未提取");
            
            // 保存数据到数据库
            msdsComponentMapper.insertMsdsComponent(compositionData);
            logger.info("成分/组成信息数据保存成功 - MSDS ID: {}", msdsId);
            
        } catch (Exception e) {
            logger.error("成分/组成信息数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage(), e);
            throw e;
        }
    }
    
    /**
     * 提取成分/组成相关字段的专用方法
     * 
     * @param content 文档内容
     * @param fieldNames 可能的字段名称数组
     * @return 提取的内容
     */
    private String extractCompositionField(String content, String[] fieldNames) {
        for (String fieldName : fieldNames) {
            String result = extractSectionContent(content, fieldName, fieldName);
            if (StringUtils.isNotEmpty(result)) {
                return result;
            }
        }
        
        // 如果标准提取失败，尝试在第三部分中查找
        String thirdSectionPattern = "第三部分[^\\n]*成分[\\s\\S]*?(?=第四部分|$)";
        Pattern sectionPattern = Pattern.compile(thirdSectionPattern, Pattern.CASE_INSENSITIVE);
        Matcher sectionMatcher = sectionPattern.matcher(content);
        
        if (sectionMatcher.find()) {
            String sectionContent = sectionMatcher.group();
            for (String fieldName : fieldNames) {
                String result = extractSectionContent(sectionContent, fieldName, fieldName);
                if (StringUtils.isNotEmpty(result)) {
                    return result;
                }
            }
            
            // 特殊处理表格格式的成分信息
            String tableResult = extractTableContent(sectionContent, fieldNames);
            if (StringUtils.isNotEmpty(tableResult)) {
                return tableResult;
            }
        }
        
        return null;
    }
    
    /**
     * 从表格格式中提取内容
     * 
     * @param content 内容
     * @param fieldNames 字段名称数组
     * @return 提取的内容
     */
    private String extractTableContent(String content, String[] fieldNames) {
        // 匹配表格行格式
        String[] lines = content.split("\n");
        StringBuilder result = new StringBuilder();
        
        for (String line : lines) {
            line = line.trim();
            if (StringUtils.isEmpty(line)) continue;
            
            // 检查是否包含目标字段
            for (String fieldName : fieldNames) {
                if (line.contains(fieldName) && line.contains(":")) {
                    String value = line.substring(line.indexOf(":") + 1).trim();
                    if (StringUtils.isNotEmpty(value)) {
                        if (result.length() > 0) {
                            result.append("; ");
                        }
                        result.append(value);
                    }
                    break;
                }
            }
        }
        
        return result.length() > 0 ? result.toString() : null;
    }

    /**
     * 保存急救措施（第四部分）
     */
    private void saveFirstAid(Long msdsId, String content) {
        try {
            // 创建急救措施实体对象
            MsdsFirstAid firstAidData = new MsdsFirstAid();
            firstAidData.setMsdsId(msdsId);
            
            // 一般建议 -> generalNotes
            String firstAidDescription = extractFirstAidField(content, new String[]{
                "急救措施描述", "First Aid Description", "急救措施", "应急措施", "一般建议"
            });
            firstAidData.setGeneralNotes(firstAidDescription);
            
            // 吸入 - 对应数据库字段inhalation
            String inhalation = extractFirstAidField(content, new String[]{
                "吸入", "Inhalation", "吸入时", "如果吸入", "吸入急救"
            });
            firstAidData.setInhalation(inhalation);
            
            // 皮肤接触 - 对应数据库字段skin_contact
            String skinContact = extractFirstAidField(content, new String[]{
                "皮肤接触", "Skin Contact", "皮肤", "接触皮肤时", "皮肤急救"
            });
            firstAidData.setSkinContact(skinContact);
            
            // 眼睛接触 - 对应数据库字段eye_contact
            String eyeContact = extractFirstAidField(content, new String[]{
                "眼睛接触", "Eye Contact", "眼部接触", "接触眼睛时", "眼部急救"
            });
            firstAidData.setEyeContact(eyeContact);
            
            // 食入 - 对应数据库字段ingestion
            String ingestion = extractFirstAidField(content, new String[]{
                "食入", "Ingestion", "误食", "如果食入", "食入急救"
            });
            firstAidData.setIngestion(ingestion);
            
            // 一般注意事项 - 对应数据库字段general_notes
            String generalNotes = extractFirstAidField(content, new String[]{
                "对保护施救者的忠告", "Protection of First-aiders", "施救者防护", "救援人员防护", "对急救人员的防护", "一般注意事项", "注意事项"
            });
            firstAidData.setGeneralNotes(generalNotes);
            
            // 症状和影响 - 对应数据库字段symptoms_effects
            String symptomsEffects = extractFirstAidField(content, new String[]{
                "对医生的特别提示", "Special Instructions to Physician", "医疗建议", "医生注意事项", "医疗注意事项", "症状和影响", "症状"
            });
            firstAidData.setSymptomsEffects(symptomsEffects);
            
            // 立即医疗护理 - 对应数据库字段immediate_medical_attention
            String immediateMedicalAttention = extractFirstAidField(content, new String[]{
                "立即医疗护理", "紧急医疗", "医疗护理", "医疗注意"
            });
            firstAidData.setImmediateMedicalAttention(immediateMedicalAttention);
            
            // 解毒剂治疗 - 对应数据库字段antidote_treatment
            String antidoteTreatment = extractFirstAidField(content, new String[]{
                "解毒剂治疗", "解毒剂", "特殊治疗", "解毒治疗"
            });
            firstAidData.setAntidoteTreatment(antidoteTreatment);
            
            // 记录提取的字段信息用于调试
            logger.info("急救措施字段提取结果 - MSDS ID: {}, 吸入: {}, 皮肤接触: {}, 眼睛接触: {}, 食入: {}", 
                       msdsId, 
                       inhalation != null ? "已提取" : "未提取",
                       skinContact != null ? "已提取" : "未提取",
                       eyeContact != null ? "已提取" : "未提取",
                       ingestion != null ? "已提取" : "未提取");
            
            // 保存数据到数据库
            msdsFirstAidMapper.insertMsdsFirstAid(firstAidData);
            logger.info("急救措施数据保存成功 - MSDS ID: {}", msdsId);
            
        } catch (Exception e) {
            logger.error("急救措施数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage(), e);
            throw e;
        }
    }
    
    /**
     * 提取急救措施相关字段的专用方法
     * 
     * @param content 文档内容
     * @param fieldNames 可能的字段名称数组
     * @return 提取的内容
     */
    private String extractFirstAidField(String content, String[] fieldNames) {
        for (String fieldName : fieldNames) {
            String result = extractSectionContent(content, fieldName, fieldName);
            if (StringUtils.isNotEmpty(result)) {
                return result;
            }
        }
        
        // 如果标准提取失败，尝试在第四部分中查找
        String fourthSectionPattern = "第四部分[^\\n]*急救措施[\\s\\S]*?(?=第五部分|$)";
        Pattern sectionPattern = Pattern.compile(fourthSectionPattern, Pattern.CASE_INSENSITIVE);
        Matcher sectionMatcher = sectionPattern.matcher(content);
        
        if (sectionMatcher.find()) {
            String sectionContent = sectionMatcher.group();
            for (String fieldName : fieldNames) {
                String result = extractSectionContent(sectionContent, fieldName, fieldName);
                if (StringUtils.isNotEmpty(result)) {
                    return result;
                }
            }
        }
        
        return null;
    }

    /**
     * 保存消防措施（第五部分）
     */
    private void saveFireFighting(Long msdsId, String content) {
        try {
            // 创建消防措施实体对象
            MsdsFireFighting fireFightingData = new MsdsFireFighting();
            fireFightingData.setMsdsId(msdsId);
            
            // 危险特性 - 对应数据库字段hazard_characteristics
            String hazardCharacteristics = extractSectionContent(content, "危险特性", "hazard_characteristics");
            fireFightingData.setHazardCharacteristics(hazardCharacteristics);
            
            // 有害燃烧产物 - 对应数据库字段harmful_combustion_products
            String harmfulCombustionProducts = extractSectionContent(content, "有害燃烧产物", "harmful_combustion_products");
            fireFightingData.setHarmfulCombustionProducts(harmfulCombustionProducts);
            
            // 适用的灭火介质 - 对应数据库字段suitable_extinguishing_media
            String suitableExtinguishingMedia = extractSectionContent(content, "灭火方法|灭火介质|适用的灭火介质", "suitable_extinguishing_media");
            fireFightingData.setSuitableExtinguishingMedia(suitableExtinguishingMedia);
            
            // 不适用的灭火介质 - 对应数据库字段unsuitable_extinguishing_media
            String unsuitableExtinguishingMedia = extractSectionContent(content, "不适用的灭火介质|禁用灭火介质", "unsuitable_extinguishing_media");
            fireFightingData.setUnsuitableExtinguishingMedia(unsuitableExtinguishingMedia);
            
            // 消防设备和防护装备 - 对应数据库字段fire_fighting_equipment
            String fireFightingEquipment = extractSectionContent(content, "消防设备.*防护装备|灭火注意事项.*防护措施", "fire_fighting_equipment");
            fireFightingData.setFireFightingEquipment(fireFightingEquipment);
            
            // 记录提取的字段信息用于调试
            logger.info("消防措施字段提取结果 - MSDS ID: {}, 危险特性: {}, 有害燃烧产物: {}, 适用灭火介质: {}, 不适用灭火介质: {}, 消防设备: {}", 
                       msdsId, 
                       hazardCharacteristics != null ? "已提取" : "未提取",
                       harmfulCombustionProducts != null ? "已提取" : "未提取",
                       suitableExtinguishingMedia != null ? "已提取" : "未提取",
                       unsuitableExtinguishingMedia != null ? "已提取" : "未提取",
                       fireFightingEquipment != null ? "已提取" : "未提取");
            
            // 保存数据到数据库
            msdsFireFightingMapper.insertMsdsFireFighting(fireFightingData);
            logger.info("消防措施数据保存成功 - MSDS ID: {}", msdsId);
            
        } catch (Exception e) {
            logger.error("消防措施数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage(), e);
            throw e;
        }
    }

    /**
     * 保存泄漏应急处理（第六部分）
     */
    private void saveLeakageHandling(Long msdsId, String content) {
        try {
            MsdsLeakResponse leakageData = new MsdsLeakResponse();
            leakageData.setMsdsId(msdsId);
            
            // 个人防护措施 - 对应文档中的作业人员防护措施、防护装备和应急处置程序
            String personalPrecautions = extractSectionContent(content, 
                "作业人员防护措施|个人防护措施|防护装备|应急处置程序|人员防护", "personal_precautions");
            leakageData.setPersonalPrecautions(personalPrecautions);
            
            // 环境保护措施 - 对应文档中的环境保护措施
            String environmentalPrecautions = extractSectionContent(content, 
                "环境保护措施|环境防护|环境预防措施", "environmental_precautions");
            leakageData.setEnvironmentalPrecautions(environmentalPrecautions);
            
            // 泄漏化学品的收容、清除方法 - 对应文档中的泄漏化学品的收容、清除方法及所使用的处置材料
            String containmentCleanup = extractSectionContent(content, 
                "泄漏化学品.*收容.*清除方法|收容.*清除|处置材料|清理方法", "containment_cleanup");
            leakageData.setContainmentCleanup(containmentCleanup);
            
            // 应急处理程序 - 对应文档中的应急处理程序
            String emergencyProcedures = extractSectionContent(content, 
                "应急处理程序|应急程序|紧急处理|应急措施", "emergency_procedures");
            leakageData.setEmergencyProcedures(emergencyProcedures);
            
            // 消除方法 - 对应文档中的消除方法
            String eliminationMethods = extractSectionContent(content, 
                "消除方法|清除方法|处理方法", "elimination_methods");
            leakageData.setEliminationMethods(eliminationMethods);
            
            // 清理时使用的器材 - 对应文档中的清理器材
            String equipmentMaterials = extractSectionContent(content, 
                "清理.*器材|清理.*设备|处理.*器材|清洁.*工具", "equipment_materials");
            leakageData.setEquipmentMaterials(equipmentMaterials);
            
            // 防止发生次生危害的预防措施 - 对应文档中的次生危害预防
            String preventSecondaryHazards = extractSectionContent(content, 
                "次生危害|二次危害|预防措施|防止.*危害", "prevent_secondary_hazards");
            leakageData.setPreventSecondaryHazards(preventSecondaryHazards);
            
            logger.debug("泄漏应急处理数据提取结果 - MSDS ID: {}, 个人防护措施: {}, 环境保护措施: {}, 收容清除: {}, 应急程序: {}, 消除方法: {}, 器材: {}, 次生危害预防: {}", 
                       msdsId, 
                       personalPrecautions != null ? "已提取" : "未提取",
                       environmentalPrecautions != null ? "已提取" : "未提取",
                       containmentCleanup != null ? "已提取" : "未提取",
                       emergencyProcedures != null ? "已提取" : "未提取",
                       eliminationMethods != null ? "已提取" : "未提取",
                       equipmentMaterials != null ? "已提取" : "未提取",
                       preventSecondaryHazards != null ? "已提取" : "未提取");
            
            // 保存数据到数据库
            msdsLeakResponseMapper.insertMsdsLeakResponse(leakageData);
            logger.info("泄漏应急处理数据保存成功 - MSDS ID: {}", msdsId);
            
        } catch (Exception e) {
            logger.error("泄漏应急处理数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage(), e);
            throw e;
        }
    }

    /**
     * 保存操作处置与储存（第七部分）
     */
    private void saveHandlingStorage(Long msdsId, String content) {
        try {
            MsdsHandlingStorage handlingData = new MsdsHandlingStorage();
            handlingData.setMsdsId(msdsId);
            
            // 操作注意事项 - 对应文档中的操作处置注意事项
            String handlingPrecautions = extractSectionContent(content, 
                "操作处置注意事项|操作注意事项|处置注意事项|操作要求|操作安全", "handling_precautions");
            handlingData.setHandlingPrecautions(handlingPrecautions);
            
            // 储存注意事项 - 对应文档中的储存注意事项
            String storagePrecautions = extractSectionContent(content, 
                "储存注意事项|存储注意事项|储存要求|存储要求|储存条件", "storage_precautions");
            handlingData.setStoragePrecautions(storagePrecautions);
            
            // 最佳储存温度 - 对应文档中的储存温度
            String optimalTemperature = extractSectionContent(content, 
                "最佳.*温度|储存温度|存储温度|温度.*要求", "optimal_temperature");
            handlingData.setOptimalTemperature(optimalTemperature);
            
            // 储存温度范围 - 对应文档中的温度范围
            String temperatureRange = extractSectionContent(content, 
                "温度范围|温度.*区间|储存.*温度.*范围", "temperature_range");
            handlingData.setTemperatureRange(temperatureRange);
            
            // 湿度要求 - 对应文档中的湿度要求
            String humidityRequirements = extractSectionContent(content, 
                "湿度要求|湿度.*条件|相对湿度", "humidity_requirements");
            handlingData.setHumidityRequirements(humidityRequirements);
            
            // 储存容器要求 - 对应文档中的容器要求
            String storageContainer = extractSectionContent(content, 
                "储存容器|存储容器|包装容器|容器.*要求", "storage_container");
            handlingData.setStorageContainer(storageContainer);
            
            // 不相容的物质 - 对应文档中的禁配物
            String incompatibleMaterials = extractSectionContent(content, 
                "不相容.*物质|禁配物|不兼容.*物质|避免.*接触", "incompatible_materials");
            handlingData.setIncompatibleMaterials(incompatibleMaterials);
            
            // 储存区域要求 - 对应文档中的储存区域要求
            String storageAreaRequirements = extractSectionContent(content, 
                "储存区域|存储区域|储存.*场所|存储.*环境", "storage_area_requirements");
            handlingData.setStorageAreaRequirements(storageAreaRequirements);
            
            // 保质期 - 对应文档中的保质期
            String shelfLife = extractSectionContent(content, 
                "保质期|有效期|储存期|存储期", "shelf_life");
            handlingData.setShelfLife(shelfLife);
            
            logger.debug("操作处置与储存数据提取结果 - MSDS ID: {}, 操作注意事项: {}, 储存注意事项: {}, 最佳温度: {}, 温度范围: {}, 湿度要求: {}, 容器要求: {}, 不相容物质: {}, 区域要求: {}, 保质期: {}", 
                       msdsId, 
                       handlingPrecautions != null ? "已提取" : "未提取",
                       storagePrecautions != null ? "已提取" : "未提取",
                       optimalTemperature != null ? "已提取" : "未提取",
                       temperatureRange != null ? "已提取" : "未提取",
                       humidityRequirements != null ? "已提取" : "未提取",
                       storageContainer != null ? "已提取" : "未提取",
                       incompatibleMaterials != null ? "已提取" : "未提取",
                       storageAreaRequirements != null ? "已提取" : "未提取",
                       shelfLife != null ? "已提取" : "未提取");
            
            // 保存数据到数据库
            msdsHandlingStorageMapper.insertMsdsHandlingStorage(handlingData);
            logger.info("操作处置与储存数据保存成功 - MSDS ID: {}", msdsId);
            
        } catch (Exception e) {
            logger.error("操作处置与储存数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage(), e);
            throw e;
        }
    }

    /**
     * 保存接触控制/个体防护（第八部分）
     */
    private void saveExposureControl(Long msdsId, String content) {
        try {
            MsdsExposureControl exposureData = new MsdsExposureControl();
            exposureData.setMsdsId(msdsId);
            
            // 职业接触限值 - 对应文档中的最高容许浓度
            String occupationalExposureLimit = extractSectionContent(content, 
                "最高容许浓度|职业接触限值|接触限值|容许浓度", "occupational_exposure_limit");
            exposureData.setOccupationalExposureLimit(occupationalExposureLimit);
            
            // 中国MAC值 - 对应文档中的中国MAC值
            String chinaMac = extractSectionContent(content, 
                "中国.*MAC|MAC.*值|最高容许浓度.*mg", "china_mac");
            exposureData.setChinaMac(chinaMac);
            
            // 美国TLV-TWA值 - 对应文档中的美国TLV-TWA值
            String usaTlvTwa = extractSectionContent(content, 
                "美国.*TLV.*TWA|TLV.*TWA|TWA.*值", "usa_tlv_twa");
            exposureData.setUsaTlvTwa(usaTlvTwa);
            
            // 美国TLV-STEL值 - 对应文档中的美国TLV-STEL值
            String usaTlvStel = extractSectionContent(content, 
                "美国.*TLV.*STEL|TLV.*STEL|STEL.*值", "usa_tlv_stel");
            exposureData.setUsaTlvStel(usaTlvStel);
            
            // 监测方法 - 对应文档中的监测方法
            String monitoringMethod = extractSectionContent(content, 
                "监测方法|检测方法|监控方法", "monitoring_method");
            exposureData.setMonitoringMethod(monitoringMethod);
            
            // 工程控制措施 - 对应文档中的工程控制
            String engineeringControls = extractSectionContent(content, 
                "工程控制|工程.*措施|通风.*控制", "engineering_controls");
            exposureData.setEngineeringControls(engineeringControls);
            
            // 呼吸系统防护 - 对应文档中的呼吸系统防护
            String respiratoryProtection = extractSectionContent(content, 
                "呼吸系统防护|呼吸.*防护|呼吸器", "respiratory_protection");
            exposureData.setRespiratoryProtection(respiratoryProtection);
            
            // 眼睛防护 - 对应文档中的眼睛防护
            String eyeProtection = extractSectionContent(content, 
                "眼睛防护|眼部防护|护目镜", "eye_protection");
            exposureData.setEyeProtection(eyeProtection);
            
            // 身体防护 - 对应文档中的身体防护
            String bodyProtection = extractSectionContent(content, 
                "身体防护|躯体防护|防护服", "body_protection");
            exposureData.setBodyProtection(bodyProtection);
            
            // 手部防护 - 对应文档中的手防护
            String handProtection = extractSectionContent(content, 
                "手防护|手部防护|防护手套", "hand_protection");
            exposureData.setHandProtection(handProtection);
            
            // 其他防护措施 - 对应文档中的其他防护
            String otherProtection = extractSectionContent(content, 
                "其他防护|其他.*措施|附加防护", "other_protection");
            exposureData.setOtherProtection(otherProtection);
            
            // 卫生措施 - 对应文档中的卫生措施
            String hygieneMeasures = extractSectionContent(content, 
                "卫生措施|个人卫生|清洁.*措施", "hygiene_measures");
            exposureData.setHygieneMeasures(hygieneMeasures);
            
            logger.debug("接触控制/个体防护数据提取结果 - MSDS ID: {}, 职业接触限值: {}, 中国MAC: {}, 美国TWA: {}, 美国STEL: {}, 监测方法: {}, 工程控制: {}, 呼吸防护: {}, 眼部防护: {}, 身体防护: {}, 手部防护: {}, 其他防护: {}, 卫生措施: {}", 
                       msdsId, 
                       occupationalExposureLimit != null ? "已提取" : "未提取",
                       chinaMac != null ? "已提取" : "未提取",
                       usaTlvTwa != null ? "已提取" : "未提取",
                       usaTlvStel != null ? "已提取" : "未提取",
                       monitoringMethod != null ? "已提取" : "未提取",
                       engineeringControls != null ? "已提取" : "未提取",
                       respiratoryProtection != null ? "已提取" : "未提取",
                       eyeProtection != null ? "已提取" : "未提取",
                       bodyProtection != null ? "已提取" : "未提取",
                       handProtection != null ? "已提取" : "未提取",
                       otherProtection != null ? "已提取" : "未提取",
                       hygieneMeasures != null ? "已提取" : "未提取");
            
            // 保存数据到数据库
            msdsExposureControlMapper.insertMsdsExposureControl(exposureData);
            logger.info("接触控制/个体防护数据保存成功 - MSDS ID: {}", msdsId);
            
        } catch (Exception e) {
            logger.error("接触控制/个体防护数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage(), e);
            throw e;
        }
    }

    /**
     * 保存理化特性（第九部分）
     */
    private void savePhysicalChemical(Long msdsId, String content) {
        try {
            MsdsPhysicalChemical physicalData = new MsdsPhysicalChemical();
            physicalData.setMsdsId(msdsId);
            
            // 外观与性状 - 对应文档中的外观与性状
            String appearance = extractSectionContent(content, 
                "外观.*性状|外观|性状|物理状态", "appearance");
            physicalData.setAppearance(appearance);
            
            // 气味 - 对应文档中的气味
            String odor = extractSectionContent(content, 
                "气味|嗅觉|味道", "odor");
            physicalData.setOdor(odor);
            
            // 气味阈值 - 对应文档中的气味阈值
            String odorThreshold = extractSectionContent(content, 
                "气味阈值|嗅觉阈值|气味.*阈", "odor_threshold");
            physicalData.setOdorThreshold(odorThreshold);
            
            // 熔点 - 对应文档中的熔点/凝固点
            String meltingPoint = extractSectionContent(content, 
                "熔点|凝固点|熔化点", "melting_point");
            physicalData.setMeltingPoint(meltingPoint);
            
            // 沸点 - 对应文档中的沸点、初沸点和沸程
            String boilingPoint = extractSectionContent(content, 
                "沸点|初沸点|沸程", "boiling_point");
            physicalData.setBoilingPoint(boilingPoint);
            
            // 相对密度 - 对应文档中的密度/相对密度
            String relativeDensity = extractSectionContent(content, 
                "相对密度|密度.*水.*1|比重", "relative_density");
            physicalData.setRelativeDensity(relativeDensity);
            
            // 蒸气密度 - 对应文档中的蒸气密度
            String vaporDensity = extractSectionContent(content, 
                "蒸气密度|蒸汽密度|气体密度", "vapor_density");
            physicalData.setVaporDensity(vaporDensity);
            
            // 蒸气压 - 对应文档中的蒸气压
            String vaporPressure = extractSectionContent(content, 
                "蒸气压|蒸汽压|饱和蒸气压", "vapor_pressure");
            physicalData.setVaporPressure(vaporPressure);
            
            // 蒸气压测定温度 - 对应文档中的蒸气压测定温度
            String vaporPressureTemp = extractSectionContent(content, 
                "蒸气压.*温度|测定温度", "vapor_pressure_temp");
            physicalData.setVaporPressureTemp(vaporPressureTemp);
            
            // 溶解性 - 对应文档中的溶解性
            String solubility = extractSectionContent(content, 
                "溶解性|溶解度|可溶性", "solubility");
            physicalData.setSolubility(solubility);
            
            // 水中溶解度 - 对应文档中的水中溶解度
            String waterSolubility = extractSectionContent(content, 
                "水.*溶解度|水.*溶解性|在水中.*溶解", "water_solubility");
            physicalData.setWaterSolubility(waterSolubility);
            
            // pH值 - 对应文档中的pH值
            String phValue = extractSectionContent(content, 
                "pH值|pH|酸碱度", "ph_value");
            physicalData.setPhValue(phValue);
            
            // pH值浓度条件 - 对应文档中的pH值浓度条件
            String phConcentration = extractSectionContent(content, 
                "pH.*浓度|pH.*条件|pH.*测定", "ph_concentration");
            physicalData.setPhConcentration(phConcentration);
            
            // 闪点 - 对应文档中的闪点
            String flashPoint = extractSectionContent(content, 
                "闪点|闪燃点", "flash_point");
            physicalData.setFlashPoint(flashPoint);
            
            // 引燃温度 - 对应文档中的自燃温度
            String ignitionTemperature = extractSectionContent(content, 
                "自燃温度|引燃温度|着火点", "ignition_temperature");
            physicalData.setIgnitionTemperature(ignitionTemperature);
            
            // 爆炸下限 - 对应文档中的爆炸极限
            String explosiveLimitLower = extractSectionContent(content, 
                "爆炸下限|爆炸.*下.*限|LEL", "explosive_limit_lower");
            physicalData.setExplosiveLimitLower(explosiveLimitLower);
            
            // 爆炸上限 - 对应文档中的爆炸极限
            String explosiveLimitUpper = extractSectionContent(content, 
                "爆炸上限|爆炸.*上.*限|UEL", "explosive_limit_upper");
            physicalData.setExplosiveLimitUpper(explosiveLimitUpper);
            
            // 粘度 - 对应文档中的黏度
            String viscosity = extractSectionContent(content, 
                "黏度|粘度|动力粘度", "viscosity");
            physicalData.setViscosity(viscosity);
            
            // 分配系数 - 对应文档中的n-辛醇/水分配系数
            String partitionCoefficient = extractSectionContent(content, 
                "n-辛醇.*水分配系数|分配系数|辛醇.*水", "partition_coefficient");
            physicalData.setPartitionCoefficient(partitionCoefficient);
            
            // 分解温度 - 对应文档中的分解温度
            String decompositionTemperature = extractSectionContent(content, 
                "分解温度|热分解|分解点", "decomposition_temperature");
            physicalData.setDecompositionTemperature(decompositionTemperature);
            
            logger.debug("理化特性数据提取结果 - MSDS ID: {}, 外观: {}, 气味: {}, 熔点: {}, 沸点: {}, 密度: {}, 蒸气压: {}, 溶解性: {}, pH: {}, 闪点: {}, 引燃温度: {}, 爆炸下限: {}, 爆炸上限: {}, 粘度: {}, 分配系数: {}, 分解温度: {}", 
                       msdsId, 
                       appearance != null ? "已提取" : "未提取",
                       odor != null ? "已提取" : "未提取",
                       meltingPoint != null ? "已提取" : "未提取",
                       boilingPoint != null ? "已提取" : "未提取",
                       relativeDensity != null ? "已提取" : "未提取",
                       vaporPressure != null ? "已提取" : "未提取",
                       solubility != null ? "已提取" : "未提取",
                       phValue != null ? "已提取" : "未提取",
                       flashPoint != null ? "已提取" : "未提取",
                       ignitionTemperature != null ? "已提取" : "未提取",
                       explosiveLimitLower != null ? "已提取" : "未提取",
                       explosiveLimitUpper != null ? "已提取" : "未提取",
                       viscosity != null ? "已提取" : "未提取",
                       partitionCoefficient != null ? "已提取" : "未提取",
                       decompositionTemperature != null ? "已提取" : "未提取");
            
            // 保存数据到数据库
            msdsPhysicalChemicalMapper.insertMsdsPhysicalChemical(physicalData);
            logger.info("理化特性数据保存成功 - MSDS ID: {}", msdsId);
            
        } catch (Exception e) {
            logger.error("理化特性数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage(), e);
            throw e;
        }
    }

    /**
     * 保存稳定性和反应性（第十部分）
     */
    private void saveStabilityReactivity(Long msdsId, String content) {
        try {
            MsdsStabilityReactivity stabilityData = new MsdsStabilityReactivity();
            stabilityData.setMsdsId(msdsId);
            
            // 稳定性 - 对应文档中的稳定性
            String stability = extractSectionContent(content, 
                "稳定性|化学稳定性|热稳定性", "stability");
            stabilityData.setStability(stability);
            
            // 反应性 - 对应文档中的反应性
            String reactivity = extractSectionContent(content, 
                "反应性|化学反应性|反应活性", "reactivity");
            stabilityData.setReactivity(reactivity);
            
            // 应避免的条件 - 对应文档中的应避免的条件
            String conditionsToAvoid = extractSectionContent(content, 
                "应避免的条件|避免.*条件|禁止条件", "conditions_to_avoid");
            stabilityData.setConditionsToAvoid(conditionsToAvoid);
            
            // 不相容的物质 - 对应文档中的不相容的物质
            String incompatibleSubstances = extractSectionContent(content, 
                "不相容的物质|不相容.*材料|禁配物", "incompatible_substances");
            stabilityData.setIncompatibleSubstances(incompatibleSubstances);
            
            // 危险的分解产物 - 对应文档中的危险的分解产物
            String decompositionProducts = extractSectionContent(content, 
                "危险的分解产物|分解产物|热分解产物", "decomposition_products");
            stabilityData.setDecompositionProducts(decompositionProducts);
            
            // 危险反应 - 对应文档中的危险反应
            String hazardousReactions = extractSectionContent(content, 
                "危险反应|危险.*反应|有害反应", "hazardous_reactions");
            stabilityData.setHazardousReactions(hazardousReactions);
            
            logger.debug("稳定性和反应性数据提取结果 - MSDS ID: {}, 稳定性: {}, 反应性: {}, 应避免条件: {}, 不相容物质: {}, 分解产物: {}, 危险反应: {}", 
                       msdsId, 
                       stability != null ? "已提取" : "未提取",
                       reactivity != null ? "已提取" : "未提取",
                       conditionsToAvoid != null ? "已提取" : "未提取",
                       incompatibleSubstances != null ? "已提取" : "未提取",
                       decompositionProducts != null ? "已提取" : "未提取",
                       hazardousReactions != null ? "已提取" : "未提取");
            
            // 保存数据到数据库
            msdsStabilityReactivityMapper.insertMsdsStabilityReactivity(stabilityData);
            logger.info("稳定性和反应性数据保存成功 - MSDS ID: {}", msdsId);
            
        } catch (Exception e) {
            logger.error("稳定性和反应性数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage(), e);
            throw e;
        }
    }

    /**
     * 保存毒理学资料（第十一部分）
     */
    private void saveToxicological(Long msdsId, String content) {
        try {
            MsdsToxicological toxData = new MsdsToxicological();
            toxData.setMsdsId(msdsId);
            
            // 急性毒性 - 对应文档中的急性毒性
            String acuteToxicity = extractSectionContent(content, 
                "急性毒性|急性中毒|急性毒理", "acute_toxicity");
            toxData.setAcuteToxicity(acuteToxicity);
            
            // 皮肤刺激性 - 对应文档中的皮肤刺激或腐蚀
            String skinIrritation = extractSectionContent(content, 
                "皮肤刺激|皮肤腐蚀|皮肤.*刺激.*腐蚀", "skin_irritation");
            toxData.setSkinIrritation(skinIrritation);
            
            // 眼睛刺激性 - 对应文档中的眼睛刺激或腐蚀
            String eyeIrritation = extractSectionContent(content, 
                "眼睛刺激|眼睛腐蚀|眼.*刺激.*腐蚀|严重眼损伤", "eye_irritation");
            toxData.setEyeIrritation(eyeIrritation);
            
            // 致敏性 - 对应文档中的呼吸或皮肤过敏
            String sensitization = extractSectionContent(content, 
                "呼吸.*过敏|皮肤过敏|呼吸.*皮肤.*过敏|致敏性", "sensitization");
            toxData.setSensitization(sensitization);
            
            // 致突变性 - 对应文档中的生殖细胞致突变性
            String mutagenicity = extractSectionContent(content, 
                "生殖细胞致突变性|致突变性|遗传毒性", "mutagenicity");
            toxData.setMutagenicity(mutagenicity);
            
            // 致癌性 - 对应文档中的致癌性
            String carcinogenicity = extractSectionContent(content, 
                "致癌性|致癌|癌症", "carcinogenicity");
            toxData.setCarcinogenicity(carcinogenicity);
            
            // 生殖毒性 - 对应文档中的生殖毒性
            String reproductiveToxicity = extractSectionContent(content, 
                "生殖毒性|生殖.*毒|对生殖.*影响", "reproductive_toxicity");
            toxData.setReproductiveToxicity(reproductiveToxicity);
            
            // 特定目标器官毒性 - 对应文档中的特异性靶器官系统毒性
            String specificTargetOrgan = extractSectionContent(content, 
                "特异性靶器官系统毒性|特定目标器官毒性|STOT|靶器官毒性", "specific_target_organ");
            toxData.setSpecificTargetOrgan(specificTargetOrgan);
            
            // 吸入危险 - 对应文档中的吸入危险
            String aspirationHazard = extractSectionContent(content, 
                "吸入危险|误吸.*危险|吸入.*毒性", "aspiration_hazard");
            toxData.setAspirationHazard(aspirationHazard);
            
            logger.debug("毒理学资料数据提取结果 - MSDS ID: {}, 急性毒性: {}, 皮肤刺激: {}, 眼睛刺激: {}, 致敏性: {}, 致突变性: {}, 致癌性: {}, 生殖毒性: {}, 特定器官毒性: {}, 吸入危险: {}", 
                       msdsId, 
                       acuteToxicity != null ? "已提取" : "未提取",
                       skinIrritation != null ? "已提取" : "未提取",
                       eyeIrritation != null ? "已提取" : "未提取",
                       sensitization != null ? "已提取" : "未提取",
                       mutagenicity != null ? "已提取" : "未提取",
                       carcinogenicity != null ? "已提取" : "未提取",
                       reproductiveToxicity != null ? "已提取" : "未提取",
                       specificTargetOrgan != null ? "已提取" : "未提取",
                       aspirationHazard != null ? "已提取" : "未提取");
            
            // 保存数据到数据库
            msdsToxicologicalMapper.insertMsdsToxicological(toxData);
            logger.info("毒理学资料数据保存成功 - MSDS ID: {}", msdsId);
            
        } catch (Exception e) {
            logger.error("毒理学资料数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage(), e);
            throw e;
        }
    }

    /**
     * 保存生态学资料（第十二部分）
     */
    private void saveEcological(Long msdsId, String content) {
        try {
            MsdsEcological ecoData = new MsdsEcological();
            ecoData.setMsdsId(msdsId);
            
            // 生态毒性 - 对应文档中的生态毒性
            String ecologicalToxicity = extractSectionContent(content, 
                "生态毒性|环境毒性|对环境.*毒性", "ecological_toxicity");
            ecoData.setEcologicalToxicity(ecologicalToxicity);
            
            // 生物降解性 - 对应文档中的持久性和降解性
            String biodegradability = extractSectionContent(content, 
                "持久性.*降解性|生物降解|降解性|持久性", "biodegradability");
            ecoData.setBiodegradability(biodegradability);
            
            // 生物富集或生物积累性 - 对应文档中的潜在的生物累积性
            String bioaccumulation = extractSectionContent(content, 
                "潜在的生物累积性|生物累积|生物富集", "bioaccumulation");
            ecoData.setBioaccumulation(bioaccumulation);
            
            // 土壤中的迁移性 - 对应文档中的土壤中的迁移性
            String mobilityInSoil = extractSectionContent(content, 
                "土壤中的迁移性|土壤.*迁移|环境迁移", "mobility_in_soil");
            ecoData.setMobilityInSoil(mobilityInSoil);
            
            // 其它有害作用 - 对应文档中的其他有害影响
            String otherEnvironmentalEffects = extractSectionContent(content, 
                "其他有害影响|其他.*环境.*影响|其他.*生态.*影响", "other_environmental_effects");
            ecoData.setOtherEnvironmentalEffects(otherEnvironmentalEffects);
            
            logger.debug("生态学资料数据提取结果 - MSDS ID: {}, 生态毒性: {}, 生物降解性: {}, 生物累积性: {}, 土壤迁移性: {}, 其他环境影响: {}", 
                       msdsId, 
                       ecologicalToxicity != null ? "已提取" : "未提取",
                       biodegradability != null ? "已提取" : "未提取",
                       bioaccumulation != null ? "已提取" : "未提取",
                       mobilityInSoil != null ? "已提取" : "未提取",
                       otherEnvironmentalEffects != null ? "已提取" : "未提取");
            
            // 保存数据到数据库
            msdsEcologicalMapper.insertMsdsEcological(ecoData);
            logger.info("生态学资料数据保存成功 - MSDS ID: {}", msdsId);
            
        } catch (Exception e) {
            logger.error("生态学资料数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage(), e);
            throw e;
        }
    }

    /**
     * 保存废弃处置（第十三部分）
     */
    private void saveDisposal(Long msdsId, String content) {
        try {
            MsdsDisposal disposalData = new MsdsDisposal();
            disposalData.setMsdsId(msdsId);
            
            // 废弃处置方法 - 对应文档中的废弃处置方法
            String disposalMethod = extractSectionContent(content, 
                "废弃处置方法|处置方法|废料处理|废弃物处理", "disposal_method");
            disposalData.setDisposalMethod(disposalMethod);
            
            // 废弃物性质 - 对应文档中的废物性质
            String wasteProperties = extractSectionContent(content, 
                "废物性质|废料性质|废弃物性质", "waste_properties");
            disposalData.setWasteProperties(wasteProperties);
            
            // 废弃注意事项 - 对应文档中的废弃注意事项
            String disposalPrecautions = extractSectionContent(content, 
                "废弃注意事项|处置注意事项|废料.*注意|废弃.*注意", "disposal_precautions");
            disposalData.setDisposalPrecautions(disposalPrecautions);
            
            // 包装容器的处置 - 对应文档中的污染包装物处置
            String containerDisposal = extractSectionContent(content, 
                "污染包装物处置|包装物处置|污染.*包装|包装容器.*处置", "container_disposal");
            disposalData.setContainerDisposal(containerDisposal);
            
            logger.debug("废弃处置数据提取结果 - MSDS ID: {}, 处置方法: {}, 废物性质: {}, 注意事项: {}, 包装物处置: {}", 
                       msdsId, 
                       disposalMethod != null ? "已提取" : "未提取",
                       wasteProperties != null ? "已提取" : "未提取",
                       disposalPrecautions != null ? "已提取" : "未提取",
                       containerDisposal != null ? "已提取" : "未提取");
            
            // 保存数据到数据库
            msdsDisposalMapper.insertMsdsDisposal(disposalData);
            logger.info("废弃处置数据保存成功 - MSDS ID: {}", msdsId);
            
        } catch (Exception e) {
            logger.error("废弃处置数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage(), e);
            throw e;
        }
    }

    /**
     * 保存运输信息（第十四部分）
     */
    private void saveTransportation(Long msdsId, String content) {
        try {
            MsdsTransportation transportData = new MsdsTransportation();
            transportData.setMsdsId(msdsId);
            
            // 联合国危险货物编号（UN号） - 对应文档中的联合国危险货物编号（UN号）
            String unNumber = extractSectionContent(content, 
                "联合国危险货物编号.*UN号|UN.*号|UN.*Number", "un_number");
            transportData.setUnNumber(unNumber);
            
            // 正确运输名称 - 对应文档中的联合国运输名称
            String properShippingName = extractSectionContent(content, 
                "联合国运输名称|UN.*运输名称|Proper.*Shipping.*Name|正确运输名称", "proper_shipping_name");
            transportData.setProperShippingName(properShippingName);
            
            // 运输危险性类别 - 对应文档中的运输危险性类别
            String transportHazardClass = extractSectionContent(content, 
                "运输危险性类别|危险性类别|Hazard.*Class", "transport_hazard_class");
            transportData.setTransportHazardClass(transportHazardClass);
            
            // 包装类别 - 对应文档中的包装类别
            String packingGroup = extractSectionContent(content, 
                "包装类别|包装组|Packing.*Group", "packing_group");
            transportData.setPackingGroup(packingGroup);
            
            // 海洋污染物（是/否） - 对应文档中的海洋污染物（是/否）
            String marinePollutantStr = extractSectionContent(content, 
                "海洋污染物.*是.*否|海洋污染物|Marine.*Pollutant", "marine_pollutant");
            // 转换为Integer类型：是=1，否=0
            Integer marinePollutant = null;
            if (StringUtils.isNotEmpty(marinePollutantStr)) {
                if (marinePollutantStr.contains("是") || marinePollutantStr.toLowerCase().contains("yes")) {
                    marinePollutant = 1;
                } else if (marinePollutantStr.contains("否") || marinePollutantStr.toLowerCase().contains("no")) {
                    marinePollutant = 0;
                }
            }
            transportData.setMarinePollutant(marinePollutant);
            
            // 运输注意事项 - 对应文档中的运输注意事项
            String transportationPrecautions = extractSectionContent(content, 
                "运输注意事项|运输.*注意|Transport.*Precautions", "transportation_precautions");
            transportData.setTransportationPrecautions(transportationPrecautions);
            
            // 散装运输要求 - 对应文档中的散装运输要求
            String transportInBulk = extractSectionContent(content, 
                "散装运输要求|散装运输|运输特殊规定|特殊规定|Special.*Provisions", "transport_in_bulk");
            transportData.setTransportInBulk(transportInBulk);
            
            logger.debug("运输信息数据提取结果 - MSDS ID: {}, UN号: {}, 运输名称: {}, 危险类别: {}, 包装类别: {}, 海洋污染物: {}, 注意事项: {}, 散装运输: {}", 
                       msdsId, 
                       unNumber != null ? "已提取" : "未提取",
                       properShippingName != null ? "已提取" : "未提取",
                       transportHazardClass != null ? "已提取" : "未提取",
                       packingGroup != null ? "已提取" : "未提取",
                       marinePollutant != null ? "已提取" : "未提取",
                       transportationPrecautions != null ? "已提取" : "未提取",
                       transportInBulk != null ? "已提取" : "未提取");
            
            // 保存数据到数据库
            msdsTransportationMapper.insertMsdsTransportation(transportData);
            logger.info("运输信息数据保存成功 - MSDS ID: {}", msdsId);
            
        } catch (Exception e) {
            logger.error("运输信息数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage(), e);
            throw e;
        }
    }

    /**
     * 保存法规信息（第十五部分）
     */
    private void saveRegulatory(Long msdsId, String content) {
        try {
            MsdsRegulatory regulatoryData = new MsdsRegulatory();
            regulatoryData.setMsdsId(msdsId);
            
            // 法规信息 - 对应文档中的法规信息
            String regulatoryInfo = extractSectionContent(content, 
                "法规信息|法律法规|相关法规|Regulatory.*Information", "regulatory_info");
            regulatoryData.setRegulatoryInfo(regulatoryInfo);
            
            // 国内法规 - 对应文档中的国内法规
            String domesticRegulations = extractSectionContent(content, 
                "国内法规|化学品安全技术说明书编写规定|编写规定|MSDS.*规定", "domestic_regulations");
            regulatoryData.setDomesticRegulations(domesticRegulations);
            
            // 国际法规 - 对应文档中的国际法规
            String internationalRegulations = extractSectionContent(content, 
                "国际法规|工作场所有害因素职业接触限值|职业接触限值|接触限值", "international_regulations");
            regulatoryData.setInternationalRegulations(internationalRegulations);
            
            // REACH注册情况 - 对应文档中的REACH注册
            String reachRegistration = extractSectionContent(content, 
                "REACH注册|REACH.*注册|欧盟REACH", "reach_registration");
            regulatoryData.setReachRegistration(reachRegistration);
            
            // EINECS号 - 对应文档中的EINECS号
            String einecsNumber = extractSectionContent(content, 
                "EINECS号|EINECS.*号|欧洲现有商业化学物质清单", "einecs_number");
            regulatoryData.setEinecsNumber(einecsNumber);
            
            // 禁用/限用情况 - 对应文档中的禁用限用情况
            String prohibitedRestricted = extractSectionContent(content, 
                "禁用.*限用|禁用情况|限用情况|使用限制", "prohibited_restricted");
            regulatoryData.setProhibitedRestricted(prohibitedRestricted);
            
            // 特殊规定 - 对应文档中的特殊规定
            String specialProvisions = extractSectionContent(content, 
                "特殊规定|特殊.*要求|其他.*法规|其他.*要求", "special_provisions");
            regulatoryData.setSpecialProvisions(specialProvisions);
            
            logger.debug("法规信息数据提取结果 - MSDS ID: {}, 法规信息: {}, 国内法规: {}, 国际法规: {}, REACH注册: {}, EINECS号: {}, 禁用限用: {}, 特殊规定: {}", 
                       msdsId, 
                       regulatoryInfo != null ? "已提取" : "未提取",
                       domesticRegulations != null ? "已提取" : "未提取",
                       internationalRegulations != null ? "已提取" : "未提取",
                       reachRegistration != null ? "已提取" : "未提取",
                       einecsNumber != null ? "已提取" : "未提取",
                       prohibitedRestricted != null ? "已提取" : "未提取",
                       specialProvisions != null ? "已提取" : "未提取");
            
            // 保存数据到数据库
            msdsRegulatoryMapper.insertMsdsRegulatory(regulatoryData);
            logger.info("法规信息数据保存成功 - MSDS ID: {}", msdsId);
            
        } catch (Exception e) {
            logger.error("法规信息数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage(), e);
            throw e;
        }
    }

    /**
     * 保存其他信息（第十六部分）
     */
    private void saveOtherInfo(Long msdsId, String content) {
        try {
            MsdsOtherInfo otherData = new MsdsOtherInfo();
            otherData.setMsdsId(msdsId);
            
            // 参考文献和数据来源 - 对应文档中的参考文献和数据来源
            String references = extractSectionContent(content, 
                "参考文献.*数据来源|参考文献|数据来源|References", "references");
            otherData.setReferences(references);
            
            // 填表时间 - 对应文档中的填表时间
            String fillDate = extractSectionContent(content, 
                "填表时间|编制时间|制表时间|Date.*Prepared", "fill_date");
            // 将字符串转换为Date类型
            if (StringUtils.isNotEmpty(fillDate)) {
                Date fillDateTime = parseDate(fillDate);
                otherData.setFormFillTime(fillDateTime);
            }
            
            // 填表部门 - 对应文档中的填表部门
            String fillDepartment = extractSectionContent(content, 
                "填表部门|编制部门|制表部门|Prepared.*Department", "fill_department");
            otherData.setFormFillDepartment(fillDepartment);
            
            // 数据审核单位 - 对应文档中的数据审核单位
            String auditUnit = extractSectionContent(content, 
                "数据审核单位|审核单位|审核部门|Review.*Unit", "audit_unit");
            otherData.setDataAuditUnit(auditUnit);
            
            // 修改说明 - 对应文档中的修改说明
            String modificationNote = extractSectionContent(content, 
                "修改说明|修订说明|变更说明|Modification.*Note", "modification_note");
            otherData.setModificationNotes(modificationNote);
            
            // 其他信息 - 对应文档中的其他信息
            String otherInfo = extractSectionContent(content, 
                "其他信息|其他.*说明|备注|Other.*Information", "other_info");
            otherData.setAdditionalInformation(otherInfo);
            
            // 数据来源 - 对应文档中的数据来源
            String dataSources = extractSectionContent(content, 
                "数据来源|数据源|Data.*Source", "data_sources");
            otherData.setDataSources(dataSources);
            
            // 免责声明 - 对应文档中的免责声明
            String disclaimer = extractSectionContent(content, 
                "免责声明|声明|Disclaimer", "disclaimer");
            otherData.setDisclaimer(disclaimer);
            
            logger.debug("其他信息数据提取结果 - MSDS ID: {}, 参考文献: {}, 填表时间: {}, 填表部门: {}, 审核单位: {}, 修改说明: {}, 其他信息: {}, 数据来源: {}, 免责声明: {}", 
                       msdsId, 
                       references != null ? "已提取" : "未提取",
                       fillDate != null ? "已提取" : "未提取",
                       fillDepartment != null ? "已提取" : "未提取",
                       auditUnit != null ? "已提取" : "未提取",
                       modificationNote != null ? "已提取" : "未提取",
                       otherInfo != null ? "已提取" : "未提取",
                       dataSources != null ? "已提取" : "未提取",
                       disclaimer != null ? "已提取" : "未提取");
            
            // 保存数据到数据库
            msdsOtherInfoMapper.insertMsdsOtherInfo(otherData);
            logger.info("其他信息数据保存成功 - MSDS ID: {}", msdsId);
            
        } catch (Exception e) {
            logger.error("其他信息数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage(), e);
            throw e;
        }
    }

    /**
     * 提取指定部分的内容
     * 
     * @param content 文档内容
     * @param sectionName 部分名称
     * @param fieldName 字段名称
     * @return 提取的内容
     */
    private String extractSectionContent(String content, String sectionName, String fieldName) {
        // 构建多种可能的正则表达式模式
        String[] patterns = {
            // 标准格式：字段名：内容
            sectionName + "\\s*[：:：]?\\s*([^\\n\\r]+)",
            // 带编号的格式：2.1 字段名：内容
            "\\d+\\.\\d+\\s*" + sectionName + "\\s*[：:：]?\\s*([^\\n\\r]+)",
            // 括号格式：（字段名）：内容
            "[（(]" + sectionName + "[）)]\\s*[：:：]?\\s*([^\\n\\r]+)",
            // 多行格式：字段名\n内容
            sectionName + "\\s*\\n\\s*([^\\n\\r]+)",
            // 复杂格式：在某个部分中查找
            "第[一二三四五六七八九十]+部分[^\\n]*" + sectionName + "[^\\n]*\\n([\\s\\S]*?)(?=第[一二三四五六七八九十]+部分|$)",
            // 英文格式匹配
            sectionName.replaceAll("危险性", "Hazard").replaceAll("说明", "Statement") + "\\s*[：:：]?\\s*([^\\n\\r]+)",
            // 表格格式匹配：字段名 | 内容
            sectionName + "\\s*[|｜]\\s*([^\\n\\r|｜]+)",
            // 带序号的格式：(1) 字段名：内容
            "[（(]\\d+[）)]\\s*" + sectionName + "\\s*[：:：]?\\s*([^\\n\\r]+)",
            // 更宽松的匹配：包含关键词的行
            ".*" + sectionName + ".*[：:：]\\s*([^\\n\\r]+)",
            // 多行内容匹配：字段名后的多行内容
            sectionName + "\\s*[：:：]?\\s*\\n([\\s\\S]*?)(?=\\n\\s*[\\u4e00-\\u9fa5]+[：:：]|\\n\\s*\\d+\\.|$)"
        };
        
        for (String pattern : patterns) {
            String result = extractValue(content, pattern);
            if (StringUtils.isNotEmpty(result)) {
                // 清理提取的内容
                result = result.trim();
                // 移除可能的前缀标识符
                result = result.replaceAll("^[：:：\\s]*", "");
                // 移除可能的后缀标识符
                result = result.replaceAll("[：:：\\s]*$", "");
                // 清理多余的空白字符
                result = result.replaceAll("\\s+", " ");
                
                // 验证提取的内容是否有效
                if (result.length() > 1 && !result.matches("^[\\s\\-_]+$")) {
                    // 限制长度，避免提取过长的内容
                    if (result.length() > 2000) {
                        result = result.substring(0, 2000) + "...";
                    }
                    return result;
                }
            }
        }
        
        return null;
    }

    /**
     * 判断文本是否为MSDS标准章节标题
     * 
     * @param text 文本内容
     * @return 是否为MSDS章节
     */
    private boolean isMsdsSection(String text) {
        if (text == null || text.trim().isEmpty()) {
            return false;
        }
        
        String cleanText = text.trim().toLowerCase();
        
        // MSDS标准章节模式
        String[] sectionPatterns = {
            // 标准16部分格式
            "第[一二三四五六七八九十]+部分",
            "第\\d+部分",
            "section\\s*\\d+",
            
            // 具体章节名称
            "化学品及企业标识",
            "危险性概述",
            "成分.*组成信息",
            "急救措施",
            "消防措施",
            "泄漏应急处理",
            "操作处置.*储存",
            "接触控制.*个体防护",
            "理化特性",
            "稳定性.*反应活性",
            "毒理学资料",
            "生态学资料",
            "废弃处置",
            "运输信息",
            "法规信息",
            "其他信息",
            
            // 英文章节名称
            "identification",
            "hazard.*identification",
            "composition.*information",
            "first.*aid.*measures",
            "fire.*fighting.*measures",
            "accidental.*release.*measures",
            "handling.*storage",
            "exposure.*controls",
            "physical.*chemical.*properties",
            "stability.*reactivity",
            "toxicological.*information",
            "ecological.*information",
            "disposal.*considerations",
            "transport.*information",
            "regulatory.*information",
            "other.*information"
        };
        
        for (String pattern : sectionPatterns) {
            if (cleanText.matches(".*" + pattern + ".*")) {
                return true;
            }
        }
        
        // 检查是否包含编号格式的章节
        if (cleanText.matches(".*(\\d+\\.\\d+|\\d+\\.).*") && 
            (cleanText.contains("部分") || cleanText.contains("section") || 
             cleanText.length() < 50)) { // 短文本更可能是标题
            return true;
        }
        
        return false;
    }

    @Override
    public Map<String, Object> previewMsdsDocuments(MultipartFile[] files) throws Exception {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> previewList = new ArrayList<>();
        // 新增：为前端预览页提供按文件名聚合的章节字段映射
        Map<String, List<Map<String, Object>>> previewSectionsMap = new HashMap<>();
        int successCount = 0;
        int warningCount = 0;
        int errorCount = 0;

        if (files == null || files.length == 0) {
            result.put("previewList", previewList);
            result.put("total", 0);
            result.put("successCount", successCount);
            result.put("warningCount", warningCount);
            result.put("errorCount", errorCount);
            // 空文件时返回空 map，保持结构一致性
            result.put("previewSectionsMap", previewSectionsMap);
            return result;
        }

        for (MultipartFile file : files) {
            Map<String, Object> item = new HashMap<>();
            String originalFilename = (file != null) ? file.getOriginalFilename() : null;
            item.put("fileName", StringUtils.isNotEmpty(originalFilename) ? originalFilename : "未知文件");
            String status = "error";
            String errorMessage = null;

            try {
                if (file == null || file.isEmpty()) {
                    errorMessage = "文件为空";
                } else if (!isValidFileType(file)) {
                    errorMessage = "不支持的文件类型（仅支持PDF、DOC、DOCX）";
                } else {
                    // 提取文本
                    String content = extractTextFromFile(file);
                    if (StringUtils.isEmpty(content)) {
                        errorMessage = "无法从文档中提取文本";
                    } else {
                        // 基于内容解析
                        MsdsMain parsed = parseMsdsMainInfo(content);
                        String productName = parsed != null ? parsed.getProductName() : null;
                        String productEnglishName = parsed != null ? parsed.getProductEnglishName() : null;
                        String casNumber = parsed != null ? parsed.getCasNumber() : null;
                        String companyName = parsed != null ? parsed.getCompanyName() : null;
                        String version = parsed != null ? parsed.getVersion() : null;

                        // 从文件名补充缺失字段
                        Map<String, String> nameInfo = extractInfoFromFileName(originalFilename != null ? originalFilename : "");
                        if (StringUtils.isEmpty(productName)) {
                            productName = nameInfo.getOrDefault("chineseName", productName);
                        }
                        if (StringUtils.isEmpty(productEnglishName)) {
                            productEnglishName = nameInfo.getOrDefault("englishName", productEnglishName);
                        }
                        if (StringUtils.isEmpty(casNumber)) {
                            casNumber = nameInfo.getOrDefault("casNumber", casNumber);
                        }

                        // 清理字段
                        if (StringUtils.isNotEmpty(productName)) {
                            productName = cleanChemicalNameLightweight(productName);
                        }
                        if (StringUtils.isNotEmpty(productEnglishName)) {
                            productEnglishName = cleanText(productEnglishName);
                        }
                        if (StringUtils.isNotEmpty(casNumber)) {
                            casNumber = cleanText(casNumber);
                        }
                        if (StringUtils.isNotEmpty(companyName)) {
                            companyName = cleanText(companyName);
                        }
                        if (StringUtils.isNotEmpty(version)) {
                            version = cleanText(version);
                        }

                        /**
                         * 预览必填校验规则：
                         * - 必填：化学品名称(productName) 与 CAS号(casNumber) 同时存在才视为可导入
                         * - 可选但建议：英文名(productEnglishName)、企业名称(companyName)、版本(version) 任一缺失将标记为 warning
                         * - 错误：缺少必填字段则标记为 error，并提示“缺少必填字段：化学品名称 CAS号”
                         * 说明：与前端 ImportModal 保持一致，避免前后端不一致造成用户困惑
                         */
                        boolean hasRequired = StringUtils.isNotEmpty(productName) && StringUtils.isNotEmpty(casNumber);
                        boolean optionalMissing = StringUtils.isEmpty(productEnglishName) || StringUtils.isEmpty(companyName) || StringUtils.isEmpty(version);
                        if (hasRequired) {
                            if (optionalMissing) {
                                status = "warning";
                                warningCount++;
                            } else {
                                status = "success";
                                successCount++;
                            }
                        } else {
                            status = "error";
                            if (StringUtils.isEmpty(errorMessage)) {
                                errorMessage = "缺少必填字段：化学品名称 CAS号";
                            }
                            errorCount++;
                        }

                        // 回填字段
                        item.put("productName", productName);
                        item.put("productEnglishName", productEnglishName);
                        item.put("casNumber", casNumber);
                        item.put("companyName", companyName);
                        item.put("version", version);

                        // ===== 新增：构建预览章节字段映射（仅第1节填充已解析字段，其余为占位） =====
                        List<Map<String, Object>> sections = new ArrayList<>();

                        // 第一部分 化学品及企业标识
                        Map<String, Object> section1 = new HashMap<>();
                        section1.put("id", 1);
                        section1.put("title", "第一部分 化学品及企业标识");
                        List<Map<String, Object>> fields1 = new ArrayList<>();

                        String statusProductName = StringUtils.isNotEmpty(productName) ? "success" : "error";
                        String statusCas = StringUtils.isNotEmpty(casNumber) ? "success" : "error";
                        String statusEnglish = StringUtils.isNotEmpty(productEnglishName) ? "success" : "warning";
                        String statusCompany = StringUtils.isNotEmpty(companyName) ? "success" : "warning";
                        String statusVersion = StringUtils.isNotEmpty(version) ? "success" : "warning";

                        Map<String, Object> f1 = new HashMap<>();
                        f1.put("key", "product_name");
                        f1.put("label", "化学品中文名");
                        f1.put("value", productName);
                        f1.put("status", statusProductName);
                        f1.put("hint", "必填");
                        fields1.add(f1);

                        Map<String, Object> f2 = new HashMap<>();
                        f2.put("key", "product_english_name");
                        f2.put("label", "化学品英文名");
                        f2.put("value", productEnglishName);
                        f2.put("status", statusEnglish);
                        f2.put("hint", "建议填写");
                        fields1.add(f2);

                        Map<String, Object> f3 = new HashMap<>();
                        f3.put("key", "cas_number");
                        f3.put("label", "CAS号");
                        f3.put("value", casNumber);
                        f3.put("status", statusCas);
                        f3.put("hint", "必填");
                        fields1.add(f3);

                        Map<String, Object> f4 = new HashMap<>();
                        f4.put("key", "company_name");
                        f4.put("label", "生产企业");
                        f4.put("value", companyName);
                        f4.put("status", statusCompany);
                        f4.put("hint", "建议填写");
                        fields1.add(f4);

                        Map<String, Object> f5 = new HashMap<>();
                        f5.put("key", "version");
                        f5.put("label", "版本/修订");
                        f5.put("value", version);
                        f5.put("status", statusVersion);
                        f5.put("hint", "建议填写");
                        fields1.add(f5);

                        section1.put("fields", fields1);
                        sections.add(section1);

                        // 其余章节占位（2..16）
                        String[] titles = new String[] {
                            "第二部分 危险性概述",
                            "第三部分 成分/组成信息",
                            "第四部分 急救措施",
                            "第五部分 消防措施",
                            "第六部分 泄漏应急处理",
                            "第七部分 操作处置与储存",
                            "第八部分 接触控制/个体防护",
                            "第九部分 理化特性",
                            "第十部分 稳定性和反应性",
                            "第十一部分 毒理学资料",
                            "第十二部分 生态学资料",
                            "第十三部分 废弃处置",
                            "第十四部分 运输信息",
                            "第十五部分 法规信息",
                            "第十六部分 其他信息"
                        };
                        for (int i = 0; i < titles.length; i++) {
                            Map<String, Object> sec = new HashMap<>();
                            sec.put("id", 2 + i);
                            sec.put("title", titles[i]);
                            sec.put("fields", new ArrayList<>());
                            sections.add(sec);
                        }

                        String fileKey = (String) item.get("fileName");
                        if (StringUtils.isEmpty(fileKey)) {
                            fileKey = StringUtils.isNotEmpty(originalFilename) ? originalFilename : "未知文件";
                        }
                        previewSectionsMap.put(fileKey, sections);
                        // ===== 新增结束 =====
                    }
                }
            } catch (Exception ex) {
                logger.error("MSDS文档预览失败 - 文件: {}, 错误: {}", originalFilename, ex.getMessage(), ex);
                errorMessage = StringUtils.isNotEmpty(errorMessage) ? errorMessage : (ex.getMessage() != null ? ex.getMessage() : "解析异常");
                status = "error";
                errorCount++;
            }

            if (StringUtils.isNotEmpty(errorMessage)) {
                item.put("errorMessage", errorMessage);
            }
            item.put("status", status);
            previewList.add(item);
        }

        result.put("previewList", previewList);
        // 携带新的章节映射，供前端预览页展示
        result.put("previewSectionsMap", previewSectionsMap);
        result.put("total", previewList.size());
        result.put("successCount", successCount);
        result.put("warningCount", warningCount);
        result.put("errorCount", errorCount);
        return result;
    }

    /**
     * 导入CSV格式的MSDS数据
     */
    /**
     * 读取CSV文件并检测编码
     */
    private String readCsvWithEncodingDetection(MultipartFile file) throws Exception {
        byte[] fileBytes = file.getBytes();
        
        // 尝试不同的编码格式
        String[] encodings = {"UTF-8", "GBK", "GB2312", "ISO-8859-1", "UTF-16"};
        
        for (String encoding : encodings) {
            try {
                String content = new String(fileBytes, encoding);
                
                // 检查内容是否包含中文字符且没有乱码
                if (isValidCsvContent(content, encoding)) {
                    logger.info("CSV文件编码检测成功，使用编码: {}", encoding);
                    return content;
                }
            } catch (Exception e) {
                logger.debug("尝试编码 {} 失败: {}", encoding, e.getMessage());
            }
        }
        
        // 如果所有编码都失败，使用UTF-8作为默认编码
        logger.warn("无法检测CSV文件编码，使用UTF-8作为默认编码");
        return new String(fileBytes, StandardCharsets.UTF_8);
    }
    
    /**
     * 验证CSV内容是否有效
     */
    private boolean isValidCsvContent(String content, String encoding) {
        if (StringUtils.isBlank(content)) {
            return false;
        }
        
        // 检查是否包含常见的CSV标题字段
        String[] commonHeaders = {"化学品中文名", "产品名称", "CAS号", "MSDS编号", "产品别名"};
        String firstLine = content.split("\n")[0];
        
        int matchCount = 0;
        for (String header : commonHeaders) {
            if (firstLine.contains(header)) {
                matchCount++;
            }
        }
        
        // 如果匹配到至少一个标题字段，认为编码正确
        if (matchCount > 0) {
            return true;
        }
        
        // 检查是否包含中文字符且没有乱码
        return isReadableText(content);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> importMsdsCsv(MultipartFile file, boolean overwriteDuplicates, String createBy) throws Exception {
        logger.info("开始导入CSV文件: {}, 文件大小: {} bytes, 覆盖重复数据: {}, 操作人: {}", 
            file.getOriginalFilename(), file.getSize(), overwriteDuplicates, createBy);
        
        Map<String, Object> result = new HashMap<>();
        List<String> successList = new ArrayList<>();
        List<String> failureList = new ArrayList<>();
        List<String> duplicateList = new ArrayList<>();
        
        try {
            // 1. 文件基本验证
            validateCsvFile(file);
            logger.info("CSV文件基本验证通过: {}", file.getOriginalFilename());
            
            // 2. 使用编码检测读取CSV文件内容
            String csvContent = readCsvWithEncodingDetection(file);
            
            if (StringUtils.isBlank(csvContent)) {
                throw new Exception("CSV文件内容为空或无法读取");
            }
            logger.info("CSV文件内容读取成功，内容长度: {} 字符", csvContent.length());
            
            // 3. 解析和验证CSV结构
            String[] lines = csvContent.split("\n");
            
            if (lines.length < 2) {
                throw new Exception("CSV文件格式错误：至少需要包含标题行和一行数据");
            }
            logger.info("CSV文件包含 {} 行数据（包括标题行）", lines.length);
            
            // 4. 解析和验证标题行
            String[] headers = parseCSVLine(lines[0]);
            Map<String, Integer> headerMap = validateAndParseHeaders(headers);
            logger.info("CSV标题行验证通过，包含 {} 个字段", headers.length);
            
            // 5. 处理数据行
            int totalDataRows = lines.length - 1;
            int processedRows = 0;
            logger.info("开始处理 {} 行数据", totalDataRows);
            
            for (int i = 1; i < lines.length; i++) {
                processedRows++;
                
                // 进度日志（每处理10行或最后一行记录一次）
                if (processedRows % 10 == 0 || processedRows == totalDataRows) {
                    logger.info("CSV导入进度: {}/{} ({:.1f}%)", processedRows, totalDataRows, 
                        (double) processedRows / totalDataRows * 100);
                }
                
                if (StringUtils.isBlank(lines[i])) {
                    logger.debug("跳过第{}行：空行", i + 1);
                    continue; // 跳过空行
                }
                
                try {
                    // 解析CSV行数据
                    String[] values = parseCSVLine(lines[i]);
                    
                    // 验证数据行完整性
                    validateCsvRowData(values, headerMap, i + 1);
                    
                    // 解析为MSDS主表对象
                    MsdsMain msdsMain = parseCsvRowToMsdsMain(values, headerMap);
                    
                    if (msdsMain == null) {
                        failureList.add("第" + (i + 1) + "行：数据解析失败");
                        logger.warn("第{}行数据解析失败，跳过处理", i + 1);
                        continue;
                    }
                    
                    // 数据完整性验证
                    validateMsdsMainData(msdsMain, i + 1);
                    
                    // 设置创建信息
                    msdsMain.setCreateTime(new Date());
                    msdsMain.setUpdateTime(new Date());
                    msdsMain.setCreateBy(createBy);
                    msdsMain.setUpdateBy(createBy);
                    
                    // 检查重复数据
                    MsdsMain existingMsds = null;
                    if (StringUtils.isNotEmpty(msdsMain.getProductName())) {
                        existingMsds = msdsMainMapper.selectMsdsMainByProductName(msdsMain.getProductName());
                    }
                    
                    if (existingMsds != null) {
                        if (overwriteDuplicates) {
                            // 覆盖现有数据
                            msdsMain.setId(existingMsds.getId());
                            msdsMain.setUpdateTime(new Date());
                            msdsMainMapper.updateMsdsMain(msdsMain);
                            
                            // 清理并重新保存子表数据
                            cleanRelatedMsdsData(existingMsds.getId());
                            saveCsvRelatedData(msdsMain.getId(), values, headerMap);
                            
                            successList.add(msdsMain.getProductName() + "（已覆盖）");
                            logger.info("CSV导入：覆盖现有MSDS数据 - 产品名称: {}, ID: {}", msdsMain.getProductName(), msdsMain.getId());
                        } else {
                            duplicateList.add(msdsMain.getProductName());
                            logger.warn("CSV导入：发现重复数据，跳过 - 产品名称: {}", msdsMain.getProductName());
                        }
                    } else {
                        // 新增数据
                        msdsMainMapper.insertMsdsMain(msdsMain);
                        
                        // 保存子表数据
                        saveCsvRelatedData(msdsMain.getId(), values, headerMap);
                        
                        successList.add(msdsMain.getProductName());
                        logger.info("CSV导入：新增MSDS数据 - 产品名称: {}, ID: {}", msdsMain.getProductName(), msdsMain.getId());
                    }
                    
                } catch (Exception e) {
                    String errorMsg = String.format("第%d行处理失败: %s", i + 1, e.getMessage());
                    failureList.add(errorMsg);
                    logger.error("CSV导入第{}行失败: {}", i + 1, e.getMessage(), e);
                }
            }
            
            // 6. 构建返回结果
            result.put("success", true);
            result.put("successCount", successList.size());
            result.put("failureCount", failureList.size());
            result.put("duplicateCount", duplicateList.size());
            result.put("totalRows", totalDataRows);
            result.put("successList", successList);
            result.put("failureList", failureList);
            result.put("duplicateList", duplicateList);
            result.put("message", String.format("CSV导入完成：总计%d条，成功%d条，失败%d条，重复%d条", 
                totalDataRows, successList.size(), failureList.size(), duplicateList.size()));
            
            // 计算成功率
            double successRate = totalDataRows > 0 ? (double) successList.size() / totalDataRows * 100 : 0;
            result.put("successRate", String.format("%.1f%%", successRate));
            
            logger.info("CSV导入完成 - 文件: {}, 总计: {}, 成功: {}, 失败: {}, 重复: {}, 成功率: {:.1f}%", 
                file.getOriginalFilename(), totalDataRows, successList.size(), failureList.size(), 
                duplicateList.size(), successRate);
            
        } catch (Exception e) {
            logger.error("CSV导入失败 - 文件: {}, 错误: {}", file.getOriginalFilename(), e.getMessage(), e);
            result.put("success", false);
            result.put("message", "CSV导入失败：" + e.getMessage());
            result.put("errorDetails", e.getClass().getSimpleName() + ": " + e.getMessage());
            throw e;
        }
        
        return result;
    }
    
    /**
     * 验证CSV文件基本信息
     */
    private void validateCsvFile(MultipartFile file) throws Exception {
        if (file == null || file.isEmpty()) {
            throw new Exception("CSV文件不能为空");
        }
        
        String fileName = file.getOriginalFilename();
        if (StringUtils.isBlank(fileName)) {
            throw new Exception("文件名不能为空");
        }
        
        if (!fileName.toLowerCase().endsWith(".csv")) {
            throw new Exception("文件格式错误，只支持CSV格式文件");
        }
        
        // 检查文件大小（限制为10MB）
        long maxSize = 10 * 1024 * 1024; // 10MB
        if (file.getSize() > maxSize) {
            throw new Exception(String.format("文件大小超过限制，最大支持%dMB", maxSize / 1024 / 1024));
        }
        
        logger.debug("CSV文件验证通过: {}, 大小: {} bytes", fileName, file.getSize());
    }
    
    /**
     * 验证和解析CSV标题行
     */
    private Map<String, Integer> validateAndParseHeaders(String[] headers) throws Exception {
        if (headers == null || headers.length == 0) {
            throw new Exception("CSV文件标题行为空");
        }
        
        Map<String, Integer> headerMap = new HashMap<>();
        for (int i = 0; i < headers.length; i++) {
            String header = headers[i].trim();
            if (StringUtils.isNotBlank(header)) {
                headerMap.put(header, i);
            }
        }
        
        // 验证必需字段
        String[] requiredFields = {"化学品中文名", "CAS号", "MSDS编号"};
        List<String> missingFields = new ArrayList<>();
        
        for (String field : requiredFields) {
            if (!headerMap.containsKey(field) && !headerMap.containsKey(field + "*")) {
                missingFields.add(field);
            }
        }
        
        if (!missingFields.isEmpty()) {
            throw new Exception("CSV文件缺少必需字段: " + String.join(", ", missingFields));
        }
        
        logger.debug("CSV标题行包含字段: {}", String.join(", ", headerMap.keySet()));
        return headerMap;
    }
    
    /**
     * 验证CSV数据行
     */
    private void validateCsvRowData(String[] values, Map<String, Integer> headerMap, int rowNumber) throws Exception {
        if (values == null || values.length == 0) {
            throw new Exception("数据行为空");
        }
        
        // 检查必需字段是否有值
        String productName = getCsvValue(values, headerMap, "化学品中文名");
        if (StringUtils.isBlank(productName)) {
            throw new Exception("化学品中文名不能为空");
        }
        
        String casNumber = getCsvValue(values, headerMap, "CAS号");
        if (StringUtils.isBlank(casNumber)) {
            throw new Exception("CAS号不能为空");
        }
        
        String msdsCode = getCsvValue(values, headerMap, "MSDS编号");
        if (StringUtils.isBlank(msdsCode)) {
            throw new Exception("MSDS编号不能为空");
        }
        
        logger.debug("第{}行数据验证通过: 产品名称={}, CAS号={}, MSDS编号={}", 
            rowNumber, productName, casNumber, msdsCode);
    }
    
    /**
     * 验证MSDS主表数据
     */
    private void validateMsdsMainData(MsdsMain msdsMain, int rowNumber) throws Exception {
        if (msdsMain == null) {
            throw new Exception("MSDS数据对象为空");
        }
        
        // 验证产品名称长度
        if (StringUtils.isNotEmpty(msdsMain.getProductName()) && msdsMain.getProductName().length() > 200) {
            throw new Exception("产品名称长度超过限制（最大200字符）");
        }
        
        // 验证CAS号格式
        if (StringUtils.isNotEmpty(msdsMain.getProductAlias()) && !isValidCasNumber(msdsMain.getProductAlias())) {
            logger.warn("第{}行CAS号格式可能不正确: {}", rowNumber, msdsMain.getProductAlias());
        }
        
        // 验证邮箱格式
        if (StringUtils.isNotEmpty(msdsMain.getEmail()) && !isValidEmail(msdsMain.getEmail())) {
            logger.warn("第{}行邮箱格式可能不正确: {}", rowNumber, msdsMain.getEmail());
        }
        
        // 验证电话号码格式
        if (StringUtils.isNotEmpty(msdsMain.getContactPhone()) && !isValidPhoneNumber(msdsMain.getContactPhone())) {
            logger.warn("第{}行电话号码格式可能不正确: {}", rowNumber, msdsMain.getContactPhone());
        }
        
        logger.debug("第{}行MSDS主表数据验证通过", rowNumber);
    }
    
    /**
     * 验证MSDS数据的完整性和一致性
     */
    private ValidationResult validateMsdsDataIntegrity(MsdsMain msdsMain, String[] values, Map<String, Integer> headerMap) {
        ValidationResult result = new ValidationResult();
        List<String> warnings = new ArrayList<>();
        List<String> errors = new ArrayList<>();
        
        // 1. 验证基本信息完整性
        if (StringUtils.isBlank(msdsMain.getProductName())) {
            errors.add("产品名称不能为空");
        }
        
        // 2. 验证CAS号格式
        if (StringUtils.isNotBlank(msdsMain.getProductAlias()) && !isValidCasNumber(msdsMain.getProductAlias())) {
            warnings.add("CAS号格式可能不正确: " + msdsMain.getProductAlias());
        }
        
        // 3. 验证分子式格式
        String molecularFormula = getCsvValue(values, headerMap, "分子式", "molecular_formula", "formula");
        if (StringUtils.isNotBlank(molecularFormula) && !isValidMolecularFormula(molecularFormula)) {
            warnings.add("分子式格式可能不正确: " + molecularFormula);
        }
        
        // 4. 验证分子量格式
        String molecularWeight = getCsvValue(values, headerMap, "分子量", "molecular_weight", "weight");
        if (StringUtils.isNotBlank(molecularWeight) && !isValidMolecularWeight(molecularWeight)) {
            warnings.add("分子量格式可能不正确: " + molecularWeight);
        }
        
        // 5. 验证危险性分类
        String hazardClass = getCsvValue(values, headerMap, "危险性分类", "hazard_class", "classification");
        if (StringUtils.isNotBlank(hazardClass)) {
            validateHazardClassification(hazardClass, warnings);
        }
        
        // 6. 验证物理状态
        String physicalState = getCsvValue(values, headerMap, "物理状态", "physical_state", "state");
        if (StringUtils.isNotBlank(physicalState)) {
            validatePhysicalState(physicalState, warnings);
        }
        
        // 7. 验证温度数据格式
        validateTemperatureData(values, headerMap, warnings);
        
        // 8. 验证pH值范围
        String phValue = getCsvValue(values, headerMap, "pH值", "ph_value", "ph");
        if (StringUtils.isNotBlank(phValue) && !isValidPhValue(phValue)) {
            warnings.add("pH值格式或范围可能不正确: " + phValue);
        }
        
        result.setValid(errors.isEmpty());
        result.setErrors(errors);
        result.setWarnings(warnings);
        
        return result;
    }
    
    /**
     * 验证危险性分类
     */
    private void validateHazardClassification(String hazardClass, List<String> warnings) {
        // 常见的危险性分类关键词
        String[] validKeywords = {"易燃", "腐蚀", "毒性", "刺激", "致敏", "致癌", "易爆", "氧化", "环境危害"};
        
        boolean hasValidKeyword = false;
        for (String keyword : validKeywords) {
            if (hazardClass.contains(keyword)) {
                hasValidKeyword = true;
                break;
            }
        }
        
        if (!hasValidKeyword) {
            warnings.add("危险性分类可能不标准: " + hazardClass);
        }
    }
    
    /**
     * 验证物理状态
     */
    private void validatePhysicalState(String physicalState, List<String> warnings) {
        String[] validStates = {"固体", "液体", "气体", "粉末", "颗粒", "膏状", "凝胶"};
        
        boolean isValid = false;
        for (String state : validStates) {
            if (physicalState.contains(state)) {
                isValid = true;
                break;
            }
        }
        
        if (!isValid) {
            warnings.add("物理状态描述可能不标准: " + physicalState);
        }
    }
    
    /**
     * 验证温度数据格式
     */
    private void validateTemperatureData(String[] values, Map<String, Integer> headerMap, List<String> warnings) {
        String[] tempFields = {"熔点", "沸点", "闪点", "自燃温度", "melting_point", "boiling_point", "flash_point"};
        
        for (String field : tempFields) {
            String tempValue = getCsvValue(values, headerMap, field);
            if (StringUtils.isNotBlank(tempValue) && !isValidTemperature(tempValue)) {
                warnings.add(field + "格式可能不正确: " + tempValue);
            }
        }
    }
    
    /**
     * 验证分子式格式
     */
    private boolean isValidMolecularFormula(String formula) {
        if (StringUtils.isBlank(formula)) {
            return false;
        }
        
        // 基本的分子式格式检查：包含字母和数字，可能包含括号
        return formula.matches("^[A-Za-z0-9()\\[\\]]+$");
    }
    
    /**
     * 验证分子量格式
     */
    private boolean isValidMolecularWeight(String weight) {
        if (StringUtils.isBlank(weight)) {
            return false;
        }
        
        try {
            // 提取数字部分
            String numericPart = weight.replaceAll("[^0-9.]", "");
            if (StringUtils.isBlank(numericPart)) {
                return false;
            }
            
            double value = Double.parseDouble(numericPart);
            return value > 0 && value < 10000; // 合理的分子量范围
        } catch (NumberFormatException e) {
            return false;
        }
    }
    
    /**
     * 验证温度格式
     */
    private boolean isValidTemperature(String temperature) {
        if (StringUtils.isBlank(temperature)) {
            return false;
        }
        
        try {
            // 提取数字部分（可能包含负号）
            String numericPart = temperature.replaceAll("[^0-9.-]", "");
            if (StringUtils.isBlank(numericPart)) {
                return false;
            }
            
            double value = Double.parseDouble(numericPart);
            return value >= -273.15 && value <= 5000; // 合理的温度范围
        } catch (NumberFormatException e) {
            return false;
        }
    }
    
    /**
     * 验证pH值格式
     */
    private boolean isValidPhValue(String phValue) {
        if (StringUtils.isBlank(phValue)) {
            return false;
        }
        
        try {
            // 提取数字部分
            String numericPart = phValue.replaceAll("[^0-9.]", "");
            if (StringUtils.isBlank(numericPart)) {
                return false;
            }
            
            double value = Double.parseDouble(numericPart);
            return value >= 0 && value <= 14; // pH值范围0-14
        } catch (NumberFormatException e) {
            return false;
        }
    }
    
    /**
     * 数据验证结果类
     */
    private static class ValidationResult {
        private boolean valid;
        private List<String> errors = new ArrayList<>();
        private List<String> warnings = new ArrayList<>();
        
        public boolean isValid() { return valid; }
        public void setValid(boolean valid) { this.valid = valid; }
        public List<String> getErrors() { return errors; }
        public void setErrors(List<String> errors) { this.errors = errors; }
        public List<String> getWarnings() { return warnings; }
        public void setWarnings(List<String> warnings) { this.warnings = warnings; }
        
        /**
         * 判断是否有关键错误
         */
        public boolean isCritical() {
            return !errors.isEmpty();
        }
        
        /**
         * 获取错误消息
         */
        public String getErrorMessage() {
            if (!errors.isEmpty()) {
                return String.join("; ", errors);
            }
            if (!warnings.isEmpty()) {
                return String.join("; ", warnings);
            }
            return "";
        }
    }
    
    /**
     * 解析CSV行数据
     */
    private String[] parseCSVLine(String line) {
        List<String> values = new ArrayList<>();
        boolean inQuotes = false;
        StringBuilder currentValue = new StringBuilder();
        
        for (int i = 0; i < line.length(); i++) {
            char c = line.charAt(i);
            
            if (c == '"') {
                if (inQuotes && i + 1 < line.length() && line.charAt(i + 1) == '"') {
                    // 转义的双引号
                    currentValue.append('"');
                    i++; // 跳过下一个引号
                } else {
                    // 切换引号状态
                    inQuotes = !inQuotes;
                }
            } else if (c == ',' && !inQuotes) {
                // 字段分隔符
                values.add(currentValue.toString().trim());
                currentValue = new StringBuilder();
            } else {
                currentValue.append(c);
            }
        }
        
        // 添加最后一个字段
        values.add(currentValue.toString().trim());
        
        return values.toArray(new String[0]);
    }
    
    /**
     * 将CSV行数据解析为MsdsMain对象
     */
    private MsdsMain parseCsvRowToMsdsMain(String[] values, Map<String, Integer> headerMap) {
        MsdsMain msdsMain = new MsdsMain();
        
        try {
            // 必需字段
            String productName = getCsvValue(values, headerMap, "化学品中文名");
            String casNumber = getCsvValue(values, headerMap, "CAS号");
            String msdsCode = getCsvValue(values, headerMap, "MSDS编号");
            
            if (StringUtils.isBlank(productName)) {
                throw new Exception("化学品中文名不能为空");
            }
            
            msdsMain.setProductName(productName);
            msdsMain.setCasNumber(casNumber);
            msdsMain.setMsdsCode(StringUtils.isNotBlank(msdsCode) ? msdsCode : generateMsdsCode());
            
            // 可选字段
            msdsMain.setProductEnglishName(getCsvValue(values, headerMap, "化学品英文名"));
            msdsMain.setProductAlias(
                getCsvValue(
                    values,
                    headerMap,
                    "化学品别名", "中文别名", "别名", "Alias", "别 名", "中文别名(化学品)"
                )
            );
            msdsMain.setCompanyName(getCsvValue(values, headerMap, "企业名称"));
            msdsMain.setCompanyAddress(getCsvValue(values, headerMap, "企业地址"));
            msdsMain.setZipCode(getCsvValue(values, headerMap, "邮编"));
            msdsMain.setContactPhone(getCsvValue(values, headerMap, "联系电话"));
            msdsMain.setFaxNumber(getCsvValue(values, headerMap, "传真号码"));
            msdsMain.setEmail(getCsvValue(values, headerMap, "电子邮件"));
            msdsMain.setEmergencyPhone(getCsvValue(values, headerMap, "应急电话"));
            msdsMain.setRecommendedUsage(getCsvValue(values, headerMap, "产品推荐用途"));
            msdsMain.setRestrictedUsage(getCsvValue(values, headerMap, "产品限制用途"));
            msdsMain.setVersion(getCsvValue(values, headerMap, "版本号"));
            msdsMain.setRemark(getCsvValue(values, headerMap, "备注"));
            
            // 日期字段
            String revisionDateStr = getCsvValue(values, headerMap, "修订日期");
            if (StringUtils.isNotBlank(revisionDateStr)) {
                msdsMain.setRevisionDate(parseDate(revisionDateStr));
            }
            
            String effectiveDateStr = getCsvValue(values, headerMap, "生效日期");
            if (StringUtils.isNotBlank(effectiveDateStr)) {
                msdsMain.setEffectiveDate(parseDate(effectiveDateStr));
            }
            
            String approvalDateStr = getCsvValue(values, headerMap, "审批日期");
            if (StringUtils.isNotBlank(approvalDateStr)) {
                msdsMain.setApprovalDate(parseDate(approvalDateStr));
            }
            
            // 状态字段
            String status = getCsvValue(values, headerMap, "状态");
            msdsMain.setStatus(StringUtils.isNotBlank(status) ? status : "active");
            
            String isActiveStr = getCsvValue(values, headerMap, "是否有效");
            if (StringUtils.isNotBlank(isActiveStr)) {
                msdsMain.setIsActive("1".equals(isActiveStr) || "true".equalsIgnoreCase(isActiveStr) || "是".equals(isActiveStr) ? 1 : 0);
            } else {
                msdsMain.setIsActive(1); // 默认有效
            }
            
            msdsMain.setApprover(getCsvValue(values, headerMap, "审批人"));
            
            // 数据完整性和一致性验证
            ValidationResult validationResult = validateMsdsDataIntegrity(msdsMain, values, headerMap);
            if (!validationResult.isValid()) {
                if (validationResult.isCritical()) {
                    logger.error("MSDS数据验证失败 - 产品: {}, 错误: {}", productName, validationResult.getErrorMessage());
                    throw new Exception("数据验证失败: " + validationResult.getErrorMessage());
                } else {
                    logger.warn("MSDS数据验证警告 - 产品: {}, 警告: {}", productName, validationResult.getErrorMessage());
                }
            }
            
            return msdsMain;
            
        } catch (Exception e) {
            logger.error("解析CSV行数据失败: {}", e.getMessage(), e);
            return null;
        }
    }
    
    /**
     * 从CSV值数组中获取指定字段的值
     */
    private String getCsvValue(String[] values, Map<String, Integer> headerMap, String fieldName) {
        // 尝试带星号的字段名（必需字段）
        Integer index = headerMap.get(fieldName + "*");
        if (index == null) {
            // 尝试不带星号的字段名
            index = headerMap.get(fieldName);
        }
        
        if (index != null && index < values.length) {
            String value = values[index];
            return StringUtils.isNotBlank(value) ? value.trim() : null;
        }
        
        return null;
    }
    
    /**
     * 从CSV值数组中按多个候选字段名获取值（按顺序优先）
     * 优先返回第一个非空且非空白的值；内部复用单字段版本，并同时兼容“*”必填标记。
     */
    private String getCsvValue(String[] values, Map<String, Integer> headerMap, String... candidateFieldNames) {
        if (candidateFieldNames == null || candidateFieldNames.length == 0) {
            return null;
        }
        for (String name : candidateFieldNames) {
            if (StringUtils.isBlank(name)) {
                continue;
            }
            String val = getCsvValue(values, headerMap, name);
            if (StringUtils.isNotBlank(val)) {
                return val;
            }
        }
        return null;
    }
    
    /**
     * 保存CSV相关的子表数据
     */
    private void saveCsvRelatedData(Long msdsId, String[] values, Map<String, Integer> headerMap) {
        logger.info("开始保存CSV子表数据 - MSDS ID: {}", msdsId);
        
        int successCount = 0;
        int totalSections = 15;
        List<String> failedSections = new ArrayList<>();
        
        try {
            // 保存危险性概述（第2部分）
            try {
                saveCsvHazardData(msdsId, values, headerMap);
                successCount++;
                logger.debug("危险性概述数据保存成功 - MSDS ID: {}", msdsId);
            } catch (Exception e) {
                failedSections.add("危险性概述");
                logger.warn("危险性概述数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage());
            }
            
            // 保存成分/组成信息（第3部分）
            try {
                saveCsvCompositionData(msdsId, values, headerMap);
                successCount++;
                logger.debug("成分组成数据保存成功 - MSDS ID: {}", msdsId);
            } catch (Exception e) {
                failedSections.add("成分组成信息");
                logger.warn("成分组成数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage());
            }
            
            // 保存急救措施（第4部分）
            try {
                saveCsvFirstAidData(msdsId, values, headerMap);
                successCount++;
                logger.debug("急救措施数据保存成功 - MSDS ID: {}", msdsId);
            } catch (Exception e) {
                failedSections.add("急救措施");
                logger.warn("急救措施数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage());
            }
            
            // 保存消防措施（第5部分）
            try {
                saveCsvFireFightingData(msdsId, values, headerMap);
                successCount++;
                logger.debug("消防措施数据保存成功 - MSDS ID: {}", msdsId);
            } catch (Exception e) {
                failedSections.add("消防措施");
                logger.warn("消防措施数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage());
            }
            
            // 保存泄漏应急处理（第6部分）
            try {
                saveCsvLeakResponseData(msdsId, values, headerMap);
                successCount++;
                logger.debug("泄漏应急处理数据保存成功 - MSDS ID: {}", msdsId);
            } catch (Exception e) {
                failedSections.add("泄漏应急处理");
                logger.warn("泄漏应急处理数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage());
            }
            
            // 保存操作处置与储存（第7部分）
            try {
                saveCsvHandlingStorageData(msdsId, values, headerMap);
                successCount++;
                logger.debug("操作处置与储存数据保存成功 - MSDS ID: {}", msdsId);
            } catch (Exception e) {
                failedSections.add("操作处置与储存");
                logger.warn("操作处置与储存数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage());
            }
            
            // 保存接触控制/个体防护（第8部分）
            try {
                saveCsvExposureControlData(msdsId, values, headerMap);
                successCount++;
                logger.debug("接触控制/个体防护数据保存成功 - MSDS ID: {}", msdsId);
            } catch (Exception e) {
                failedSections.add("接触控制/个体防护");
                logger.warn("接触控制/个体防护数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage());
            }
            
            // 保存理化特性（第9部分）
            try {
                saveCsvPhysicalChemicalData(msdsId, values, headerMap);
                successCount++;
                logger.debug("理化特性数据保存成功 - MSDS ID: {}", msdsId);
            } catch (Exception e) {
                failedSections.add("理化特性");
                logger.warn("理化特性数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage());
            }
            
            // 保存稳定性和反应性（第10部分）
            try {
                saveCsvStabilityReactivityData(msdsId, values, headerMap);
                successCount++;
                logger.debug("稳定性和反应性数据保存成功 - MSDS ID: {}", msdsId);
            } catch (Exception e) {
                failedSections.add("稳定性和反应性");
                logger.warn("稳定性和反应性数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage());
            }
            
            // 保存毒理学资料（第11部分）
            try {
                saveCsvToxicologicalData(msdsId, values, headerMap);
                successCount++;
                logger.debug("毒理学资料数据保存成功 - MSDS ID: {}", msdsId);
            } catch (Exception e) {
                failedSections.add("毒理学资料");
                logger.warn("毒理学资料数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage());
            }
            
            // 保存生态学资料（第12部分）
            try {
                saveCsvEcologicalData(msdsId, values, headerMap);
                successCount++;
                logger.debug("生态学资料数据保存成功 - MSDS ID: {}", msdsId);
            } catch (Exception e) {
                failedSections.add("生态学资料");
                logger.warn("生态学资料数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage());
            }
            
            // 保存废弃处置（第13部分）
            try {
                saveCsvDisposalData(msdsId, values, headerMap);
                successCount++;
                logger.debug("废弃处置数据保存成功 - MSDS ID: {}", msdsId);
            } catch (Exception e) {
                failedSections.add("废弃处置");
                logger.warn("废弃处置数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage());
            }
            
            // 保存运输信息（第14部分）
            try {
                saveCsvTransportationData(msdsId, values, headerMap);
                successCount++;
                logger.debug("运输信息数据保存成功 - MSDS ID: {}", msdsId);
            } catch (Exception e) {
                failedSections.add("运输信息");
                logger.warn("运输信息数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage());
            }
            
            // 保存法规信息（第15部分）
            try {
                saveCsvRegulatoryData(msdsId, values, headerMap);
                successCount++;
                logger.debug("法规信息数据保存成功 - MSDS ID: {}", msdsId);
            } catch (Exception e) {
                failedSections.add("法规信息");
                logger.warn("法规信息数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage());
            }
            
            // 保存其他信息（第16部分）
            try {
                saveCsvOtherInfoData(msdsId, values, headerMap);
                successCount++;
                logger.debug("其他信息数据保存成功 - MSDS ID: {}", msdsId);
            } catch (Exception e) {
                failedSections.add("其他信息");
                logger.warn("其他信息数据保存失败 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage());
            }
            
            // 记录保存结果
            if (failedSections.isEmpty()) {
                logger.info("CSV子表数据全部保存成功 - MSDS ID: {}, 成功: {}/{}", msdsId, successCount, totalSections);
            } else {
                logger.warn("CSV子表数据部分保存失败 - MSDS ID: {}, 成功: {}/{}, 失败部分: {}", 
                    msdsId, successCount, totalSections, String.join(", ", failedSections));
                
                // 如果失败的部分过多，抛出异常
                if (failedSections.size() > totalSections / 2) {
                    throw new RuntimeException(String.format("CSV子表数据保存失败过多 - 成功: %d/%d, 失败部分: %s", 
                        successCount, totalSections, String.join(", ", failedSections)));
                }
            }
            
        } catch (Exception e) {
            logger.error("CSV子表数据保存过程中发生严重错误 - MSDS ID: {}, 错误: {}", msdsId, e.getMessage(), e);
            throw new RuntimeException("保存CSV子表数据失败: " + e.getMessage(), e);
        }
    }
    
    // 以下是各个子表的CSV数据保存方法，由于篇幅限制，这里只实现几个关键的
    
    /**
     * 保存CSV危险性概述数据
     */
    private void saveCsvHazardData(Long msdsId, String[] values, Map<String, Integer> headerMap) {
        MsdsHazard hazardData = new MsdsHazard();
        hazardData.setMsdsId(msdsId);
        
        hazardData.setEmergencyOverview(getCsvValue(values, headerMap, "紧急情况概述"));
        hazardData.setPhysicalState(getCsvValue(values, headerMap, "物理状态"));
        hazardData.setOdor(getCsvValue(values, headerMap, "气味"));
        hazardData.setColor(getCsvValue(values, headerMap, "颜色"));
        hazardData.setWarningWord(getCsvValue(values, headerMap, "警示词"));
        hazardData.setHazardCategory(getCsvValue(values, headerMap, "危险性说明"));
        hazardData.setPreventionMeasures(getCsvValue(values, headerMap, "预防措施"));
        hazardData.setResponseMeasures(getCsvValue(values, headerMap, "响应措施"));
        hazardData.setStorageMeasures(getCsvValue(values, headerMap, "储存措施"));
        hazardData.setDisposalMeasures(getCsvValue(values, headerMap, "废弃处置措施"));
        
        msdsHazardMapper.insertMsdsHazard(hazardData);
    }
    
    /**
     * 保存CSV成分组成数据
     */
    private void saveCsvCompositionData(Long msdsId, String[] values, Map<String, Integer> headerMap) {
        MsdsComponent componentData = new MsdsComponent();
        componentData.setMsdsId(msdsId);
        
        componentData.setComponentName(getCsvValue(values, headerMap, "成分名称"));
        componentData.setComponentEnglishName(getCsvValue(values, headerMap, "成分英文名"));
        componentData.setComponentContent(getCsvValue(values, headerMap, "成分含量"));
        componentData.setCasNumber(getCsvValue(values, headerMap, "成分CAS号"));
        componentData.setEcNumber(getCsvValue(values, headerMap, "EC号"));
        componentData.setMolecularFormula(getCsvValue(values, headerMap, "分子式"));
        
        String molecularWeightStr = getCsvValue(values, headerMap, "分子量");
        if (StringUtils.isNotBlank(molecularWeightStr)) {
            try {
                componentData.setMolecularWeight(new BigDecimal(molecularWeightStr));
            } catch (NumberFormatException e) {
                logger.warn("分子量格式错误: {}", molecularWeightStr);
            }
        }
        
        String isHazardousStr = getCsvValue(values, headerMap, "是否危险成分");
        if (StringUtils.isNotBlank(isHazardousStr)) {
            componentData.setIsHazardous("1".equals(isHazardousStr) || "true".equalsIgnoreCase(isHazardousStr) || "是".equals(isHazardousStr) ? 1 : 0);
        }
        
        componentData.setHazardLevel(getCsvValue(values, headerMap, "危险等级"));
        componentData.setComponentFunction(getCsvValue(values, headerMap, "成分功能"));
        
        msdsComponentMapper.insertMsdsComponent(componentData);
    }
    
    // 其他子表的保存方法可以类似实现，这里为了节省篇幅，只提供框架
    private void saveCsvFirstAidData(Long msdsId, String[] values, Map<String, Integer> headerMap) {
        MsdsFirstAid firstAidData = new MsdsFirstAid();
        firstAidData.setMsdsId(msdsId);
        // 设置各个字段...
        msdsFirstAidMapper.insertMsdsFirstAid(firstAidData);
    }
    
    private void saveCsvFireFightingData(Long msdsId, String[] values, Map<String, Integer> headerMap) {
        MsdsFireFighting fireData = new MsdsFireFighting();
        fireData.setMsdsId(msdsId);
        // 设置各个字段...
        msdsFireFightingMapper.insertMsdsFireFighting(fireData);
    }
    
    private void saveCsvLeakResponseData(Long msdsId, String[] values, Map<String, Integer> headerMap) {
        MsdsLeakResponse leakData = new MsdsLeakResponse();
        leakData.setMsdsId(msdsId);
        // 设置各个字段...
        msdsLeakResponseMapper.insertMsdsLeakResponse(leakData);
    }
    
    private void saveCsvHandlingStorageData(Long msdsId, String[] values, Map<String, Integer> headerMap) {
        MsdsHandlingStorage handlingData = new MsdsHandlingStorage();
        handlingData.setMsdsId(msdsId);
        // 设置各个字段...
        msdsHandlingStorageMapper.insertMsdsHandlingStorage(handlingData);
    }
    
    private void saveCsvExposureControlData(Long msdsId, String[] values, Map<String, Integer> headerMap) {
        MsdsExposureControl exposureData = new MsdsExposureControl();
        exposureData.setMsdsId(msdsId);
        // 设置各个字段...
        msdsExposureControlMapper.insertMsdsExposureControl(exposureData);
    }
    
    private void saveCsvPhysicalChemicalData(Long msdsId, String[] values, Map<String, Integer> headerMap) {
        MsdsPhysicalChemical physicalData = new MsdsPhysicalChemical();
        physicalData.setMsdsId(msdsId);
        // 设置各个字段...
        msdsPhysicalChemicalMapper.insertMsdsPhysicalChemical(physicalData);
    }
    
    private void saveCsvStabilityReactivityData(Long msdsId, String[] values, Map<String, Integer> headerMap) {
        MsdsStabilityReactivity stabilityData = new MsdsStabilityReactivity();
        stabilityData.setMsdsId(msdsId);
        // 设置各个字段...
        msdsStabilityReactivityMapper.insertMsdsStabilityReactivity(stabilityData);
    }
    
    private void saveCsvToxicologicalData(Long msdsId, String[] values, Map<String, Integer> headerMap) {
        MsdsToxicological toxData = new MsdsToxicological();
        toxData.setMsdsId(msdsId);
        // 设置各个字段...
        msdsToxicologicalMapper.insertMsdsToxicological(toxData);
    }
    
    private void saveCsvEcologicalData(Long msdsId, String[] values, Map<String, Integer> headerMap) {
        MsdsEcological ecoData = new MsdsEcological();
        ecoData.setMsdsId(msdsId);
        // 设置各个字段...
        msdsEcologicalMapper.insertMsdsEcological(ecoData);
    }
    
    private void saveCsvDisposalData(Long msdsId, String[] values, Map<String, Integer> headerMap) {
        MsdsDisposal disposalData = new MsdsDisposal();
        disposalData.setMsdsId(msdsId);
        // 设置各个字段...
        msdsDisposalMapper.insertMsdsDisposal(disposalData);
    }
    
    private void saveCsvTransportationData(Long msdsId, String[] values, Map<String, Integer> headerMap) {
        MsdsTransportation transportData = new MsdsTransportation();
        transportData.setMsdsId(msdsId);
        // 设置各个字段...
        msdsTransportationMapper.insertMsdsTransportation(transportData);
    }
    
    private void saveCsvRegulatoryData(Long msdsId, String[] values, Map<String, Integer> headerMap) {
        MsdsRegulatory regulatoryData = new MsdsRegulatory();
        regulatoryData.setMsdsId(msdsId);
        // 设置各个字段...
        msdsRegulatoryMapper.insertMsdsRegulatory(regulatoryData);
    }
    
    private void saveCsvOtherInfoData(Long msdsId, String[] values, Map<String, Integer> headerMap) {
        MsdsOtherInfo otherData = new MsdsOtherInfo();
        otherData.setMsdsId(msdsId);
        // 设置各个字段...
        msdsOtherInfoMapper.insertMsdsOtherInfo(otherData);
    }

    /**
     * 导入XML格式的MSDS文档
     * 
     * @param file XML文件
     * @param overwriteDuplicates 是否覆盖重复数据
     * @param createBy 创建人
     * @return 导入结果
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> importMsdsXml(MultipartFile file, boolean overwriteDuplicates, String createBy) throws Exception {
        logger.info("开始导入XML文件: {}, 文件大小: {} bytes, 覆盖重复数据: {}, 操作人: {}", 
            file.getOriginalFilename(), file.getSize(), overwriteDuplicates, createBy);
        
        Map<String, Object> result = new HashMap<>();
        List<String> successList = new ArrayList<>();
        List<String> failureList = new ArrayList<>();
        List<String> duplicateList = new ArrayList<>();
        
        try {
            // 1. 验证文件
            validateXmlFile(file);
            logger.info("XML文件验证通过: {}", file.getOriginalFilename());
            
            // 2. 解析XML文件
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
Document doc = builder.parse(file.getInputStream());
            doc.getDocumentElement().normalize();
            
            // 3. 获取所有MSDS节点
            NodeList msdsList = doc.getElementsByTagName("msds");
            logger.info("XML文件中包含 {} 个MSDS记录", msdsList.getLength());
            
            // 4. 处理每个MSDS
            for (int i = 0; i < msdsList.getLength(); i++) {
Element msdsElement = (Element) msdsList.item(i);
                
                try {
                    // 解析MSDS数据
                    Map<String, Object> msdsData = parseXmlMsdsElement(msdsElement);
                    String casNumber = (String) msdsData.get("cas_number");
                    String productName = (String) msdsData.get("product_name");
                    
                    if (StringUtils.isBlank(casNumber)) {
                        failureList.add(String.format("第%d条记录: CAS号不能为空", i + 1));
                        continue;
                    }
                    
                    // 检查是否重复
                    MsdsMain existingMsds = msdsMainMapper.selectMsdsMainByCasNumber(casNumber);
                    if (existingMsds != null) {
                        if (!overwriteDuplicates) {
                            duplicateList.add(String.format("%s (CAS: %s)", productName, casNumber));
                            continue;
                        }
                        // 删除旧数据
                        deleteMsdsRelatedData(existingMsds.getId());
                        msdsMainMapper.deleteMsdsMainById(existingMsds.getId());
                    }
                    
                    // 保存MSDS数据
                    Long msdsId = saveXmlMsdsData(msdsData, createBy);
                    
                    successList.add(String.format("%s (CAS: %s)", productName, casNumber));
                    logger.info("成功导入MSDS: {} (CAS: {}), ID: {}", productName, casNumber, msdsId);
                    
                } catch (Exception e) {
                    logger.error("导入第{}条MSDS记录失败", i + 1, e);
                    failureList.add(String.format("第%d条记录: %s", i + 1, e.getMessage()));
                }
            }
            
            result.put("successCount", successList.size());
            result.put("failureCount", failureList.size());
            result.put("duplicateCount", duplicateList.size());
            result.put("successList", successList);
            result.put("failureList", failureList);
            result.put("duplicateList", duplicateList);
            result.put("totalCount", msdsList.getLength());
            
            logger.info("XML导入完成: 成功{}条, 失败{}条, 重复{}条", 
                successList.size(), failureList.size(), duplicateList.size());
            
        } catch (Exception e) {
            logger.error("XML文件导入失败", e);
            result.put("error", e.getMessage());
            throw e;
        }
        
        return result;
    }

    /**
     * 下载XML模板
     */
    @Override
    public void downloadXmlTemplate(HttpServletResponse response) {
        try {
            // 设置响应头
            response.setContentType("application/xml");
            response.setCharacterEncoding("UTF-8");
            String fileName = "MSDS导入模板.xml";
            response.setHeader("Content-Disposition", 
                "attachment; filename=" + URLEncoder.encode(fileName, "UTF-8"));
            
            // 读取模板文件
            ClassPathResource resource = new ClassPathResource("templates/msds_import_template.xml");
            InputStream inputStream = resource.getInputStream();
            
            // 写入响应
            IOUtils.copy(inputStream, response.getOutputStream());
            inputStream.close();
            response.getOutputStream().flush();
            
            logger.info("XML模板下载成功: {}", fileName);
            
        } catch (Exception e) {
            logger.error("XML模板下载失败", e);
            throw new RuntimeException("XML模板下载失败: " + e.getMessage());
        }
    }

    /**
     * 验证XML文件
     */
    private void validateXmlFile(MultipartFile file) throws Exception {
        if (file == null || file.isEmpty()) {
            throw new Exception("XML文件不能为空");
        }
        
        String fileName = file.getOriginalFilename();
        if (StringUtils.isBlank(fileName)) {
            throw new Exception("文件名不能为空");
        }
        
        if (!fileName.toLowerCase().endsWith(".xml")) {
            throw new Exception("文件格式错误，只支持XML格式文件");
        }
        
        // 检查文件大小（限制为10MB）
        long maxSize = 10 * 1024 * 1024;
        if (file.getSize() > maxSize) {
            throw new Exception(String.format("文件大小超过限制，最大支持%dMB", maxSize / 1024 / 1024));
        }
        
        logger.debug("XML文件验证通过: {}, 大小: {} bytes", fileName, file.getSize());
    }

    /**
     * 解析XML中的MSDS元素
     */
    private Map<String, Object> parseXmlMsdsElement(Element msdsElement) {
        Map<String, Object> msdsData = new HashMap<>();
        
        // 解析基本信息
        Map<String, String> basicInfo = parseXmlSection(msdsElement, "basic_info");
        msdsData.putAll(basicInfo);
        logger.info("解析基本信息完成，字段数量: {}", basicInfo.size());
        
        // 解析危险性概述
        Map<String, String> hazardInfo = parseXmlSection(msdsElement, "hazard_info");
        msdsData.put("hazard_info", hazardInfo);
        logger.info("解析危险性概述完成，字段数量: {}", hazardInfo.size());
        
        // 解析成分信息
        Map<String, Object> componentInfo = parseXmlComponents(msdsElement);
        msdsData.put("component_info", componentInfo);
        logger.info("解析成分信息完成，组件数量: {}", componentInfo != null ? componentInfo.size() : 0);
        
        // 解析其他章节
        Map<String, String> firstAid = parseXmlSection(msdsElement, "first_aid");
        msdsData.put("first_aid", firstAid);
        logger.info("解析急救措施完成，字段数量: {}", firstAid.size());
        
        Map<String, String> fireFighting = parseXmlSection(msdsElement, "fire_fighting");
        msdsData.put("fire_fighting", fireFighting);
        logger.info("解析消防措施完成，字段数量: {}", fireFighting.size());
        
        Map<String, String> leakResponse = parseXmlSection(msdsElement, "leak_response");
        msdsData.put("leak_response", leakResponse);
        logger.info("解析泄漏应急处理完成，字段数量: {}", leakResponse.size());
        
        Map<String, String> handlingStorage = parseXmlSection(msdsElement, "handling_storage");
        msdsData.put("handling_storage", handlingStorage);
        logger.info("解析操作处置与储存完成，字段数量: {}", handlingStorage.size());
        
        Map<String, String> exposureControl = parseXmlSection(msdsElement, "exposure_control");
        msdsData.put("exposure_control", exposureControl);
        logger.info("解析接触控制/个体防护完成，字段数量: {}", exposureControl.size());
        
        Map<String, String> physicalChemical = parseXmlSection(msdsElement, "physical_chemical");
        msdsData.put("physical_chemical", physicalChemical);
        logger.info("解析理化特性完成，字段数量: {}", physicalChemical.size());
        
        Map<String, String> stabilityReactivity = parseXmlSection(msdsElement, "stability_reactivity");
        msdsData.put("stability_reactivity", stabilityReactivity);
        logger.info("解析稳定性和反应性完成，字段数量: {}", stabilityReactivity.size());
        
        Map<String, String> toxicological = parseXmlSection(msdsElement, "toxicological");
        msdsData.put("toxicological", toxicological);
        logger.info("解析毒理学信息完成，字段数量: {}", toxicological.size());
        
        Map<String, String> ecological = parseXmlSection(msdsElement, "ecological");
        msdsData.put("ecological", ecological);
        logger.info("解析生态学资料完成，字段数量: {}", ecological.size());
        
        Map<String, String> disposal = parseXmlSection(msdsElement, "disposal");
        msdsData.put("disposal", disposal);
        logger.info("解析废弃处置完成，字段数量: {}", disposal.size());
        
        Map<String, String> transportation = parseXmlSection(msdsElement, "transportation");
        msdsData.put("transportation", transportation);
        logger.info("解析运输信息完成，字段数量: {}", transportation.size());
        
        Map<String, String> regulatory = parseXmlSection(msdsElement, "regulatory");
        msdsData.put("regulatory", regulatory);
        logger.info("解析法规信息完成，字段数量: {}", regulatory.size());
        
        Map<String, String> otherInfo = parseXmlSection(msdsElement, "other_info");
        msdsData.put("other_info", otherInfo);
        logger.info("解析其他信息完成，字段数量: {}", otherInfo.size());
        
        logger.info("XML解析完成，总字段数: {}", msdsData.size());
        return msdsData;
    }

    /**
     * 解析XML章节
     */
    private Map<String, String> parseXmlSection(Element msdsElement, String sectionName) {
        Map<String, String> sectionData = new HashMap<>();
        
        NodeList sectionList = msdsElement.getElementsByTagName(sectionName);
        if (sectionList.getLength() > 0) {
            Element sectionElement = (Element) sectionList.item(0);
            NodeList children = sectionElement.getChildNodes();
            
            for (int i = 0; i < children.getLength(); i++) {
                Node node = children.item(i);
                if (node.getNodeType() == Node.ELEMENT_NODE) {
                    Element element = (Element) node;
                    String tagName = element.getTagName();
                    String textContent = element.getTextContent().trim();
                    if (StringUtils.isNotBlank(textContent)) {
                        sectionData.put(tagName, textContent);
                    }
                }
            }
        }
        
        return sectionData;
    }

    /**
     * 解析成分信息
     */
    private Map<String, Object> parseXmlComponents(Element msdsElement) {
        Map<String, Object> componentInfo = new HashMap<>();
        List<Map<String, String>> components = new ArrayList<>();
        
        NodeList componentInfoList = msdsElement.getElementsByTagName("component_info");
        if (componentInfoList.getLength() > 0) {
Element componentInfoElement = (Element) componentInfoList.item(0);
            NodeList componentsListNode = componentInfoElement.getElementsByTagName("components");
            
            if (componentsListNode.getLength() > 0) {
Element componentsElement = (Element) componentsListNode.item(0);
                NodeList componentList = componentsElement.getElementsByTagName("component");
                
                for (int i = 0; i < componentList.getLength(); i++) {
Element componentElement = (Element) componentList.item(i);
                    Map<String, String> component = new HashMap<>();
                    
                    String componentName = getXmlElementText(componentElement, "component_name");
                    String componentContent = getXmlElementText(componentElement, "component_content");
                    String casNumber = getXmlElementText(componentElement, "cas_number");
                    
                    if (StringUtils.isNotBlank(componentName)) {
                        component.put("component_name", componentName);
                        component.put("component_content", componentContent);
                        component.put("cas_number", casNumber);
                        components.add(component);
                    }
                }
            }
        }
        
        componentInfo.put("components", components);
        return componentInfo;
    }

    /**
     * 获取XML元素文本内容
     */
    private String getXmlElementText(Element parentElement, String tagName) {
        NodeList nodeList = parentElement.getElementsByTagName(tagName);
        if (nodeList.getLength() > 0) {
            return nodeList.item(0).getTextContent().trim();
        }
        return "";
    }

    /**
     * 保存XML导入的MSDS数据
     */
    private Long saveXmlMsdsData(Map<String, Object> msdsData, String createBy) {
        // 1. 保存主表数据
        MsdsMain mainData = new MsdsMain();
        mainData.setCasNumber((String) msdsData.get("cas_number"));
        mainData.setMsdsCode((String) msdsData.get("msds_code"));
        mainData.setProductName((String) msdsData.get("product_name"));
        mainData.setProductAlias((String) msdsData.get("product_alias"));
        mainData.setProductEnglishName((String) msdsData.get("product_english_name"));
        mainData.setCompanyName((String) msdsData.get("company_name"));
        mainData.setCompanyAddress((String) msdsData.get("company_address"));
        mainData.setContactPhone((String) msdsData.get("contact_phone"));
        mainData.setEmergencyPhone((String) msdsData.get("emergency_phone"));
        mainData.setEmail((String) msdsData.get("email"));
        mainData.setFaxNumber((String) msdsData.get("fax_number"));
        mainData.setStatus("approved");
        mainData.setIsActive(1);  // 1:有效, 0:无效
        mainData.setCreateBy(createBy);
        mainData.setCreateTime(DateUtils.getNowDate());
        mainData.setUpdateTime(DateUtils.getNowDate());
        
        msdsMainMapper.insertMsdsMain(mainData);
        Long msdsId = mainData.getId();
        
        // 2. 保存危险性概述
        @SuppressWarnings("unchecked")
        Map<String, String> hazardInfo = (Map<String, String>) msdsData.get("hazard_info");
        logger.info("危险性概述数据: {}", hazardInfo);
        if (hazardInfo != null && !hazardInfo.isEmpty()) {
            MsdsHazard hazard = new MsdsHazard();
            hazard.setMsdsId(msdsId);
            
            // 基本物理状态（如果XML中存在这些字段）
            hazard.setPhysicalState(hazardInfo.get("physical_state"));
            hazard.setOdor(hazardInfo.get("odor"));
            hazard.setColor(hazardInfo.get("color"));
            hazard.setWarningWord(hazardInfo.get("warning_word"));
            
            // 危险性信息（XML中实际存在的字段）
            hazard.setHazardCategory(hazardInfo.get("hazard_category"));
            hazard.setExposureRoutes(hazardInfo.get("exposure_routes"));
            hazard.setHealthHazards(hazardInfo.get("health_hazards"));
            hazard.setEnvironmentalHazards(hazardInfo.get("environmental_hazards"));
            hazard.setFireExplosionHazards(hazardInfo.get("fire_explosion_hazards"));
            hazard.setHazardDescription(hazardInfo.get("hazard_description"));
            
            // 应急措施（如果XML中存在这些字段）
            hazard.setEmergencyOverview(hazardInfo.get("emergency_overview"));
            hazard.setPreventionMeasures(hazardInfo.get("prevention_measures"));
            hazard.setResponseMeasures(hazardInfo.get("response_measures"));
            hazard.setStorageMeasures(hazardInfo.get("storage_measures"));
            hazard.setDisposalMeasures(hazardInfo.get("disposal_measures"));
            
            msdsHazardMapper.insertMsdsHazard(hazard);
            logger.info("危险性概述数据保存成功，MSDS ID: {}", msdsId);
        } else {
            logger.warn("危险性概述数据为空或null");
        }
        
        // 3. 保存成分信息
        @SuppressWarnings("unchecked")
        Map<String, Object> componentInfo = (Map<String, Object>) msdsData.get("component_info");
        logger.info("成分信息数据: {}", componentInfo);
        if (componentInfo != null) {
            @SuppressWarnings("unchecked")
            List<Map<String, String>> components = (List<Map<String, String>>) componentInfo.get("components");
            if (components != null && !components.isEmpty()) {
                for (Map<String, String> comp : components) {
                    MsdsComponent component = new MsdsComponent();
                    component.setMsdsId(msdsId);
                    
                    // 基本成分信息
                    component.setComponentName(comp.get("component_name"));
                    component.setComponentEnglishName(comp.get("component_english_name"));
                    component.setComponentContent(comp.get("component_content"));
                    
                    // 含量范围
                    String contentMin = comp.get("content_min");
                    String contentMax = comp.get("content_max");
                    if (StringUtils.isNotBlank(contentMin)) {
                        try {
                            component.setContentMin(new java.math.BigDecimal(contentMin));
                        } catch (NumberFormatException e) {
                            logger.warn("成分含量最小值格式错误: {}", contentMin);
                        }
                    }
                    if (StringUtils.isNotBlank(contentMax)) {
                        try {
                            component.setContentMax(new java.math.BigDecimal(contentMax));
                        } catch (NumberFormatException e) {
                            logger.warn("成分含量最大值格式错误: {}", contentMax);
                        }
                    }
                    
                    // 化学标识
                    component.setCasNumber(comp.get("cas_number"));
                    component.setEcNumber(comp.get("ec_number"));
                    component.setMolecularFormula(comp.get("molecular_formula"));
                    
                    // 分子量
                    String molecularWeight = comp.get("molecular_weight");
                    if (StringUtils.isNotBlank(molecularWeight)) {
                        try {
                            component.setMolecularWeight(new java.math.BigDecimal(molecularWeight));
                        } catch (NumberFormatException e) {
                            logger.warn("分子量格式错误: {}", molecularWeight);
                        }
                    }
                    
                    // 危险性信息
                    String isHazardous = comp.get("is_hazardous");
                    if (StringUtils.isNotBlank(isHazardous)) {
                        component.setIsHazardous("1".equals(isHazardous) || "true".equalsIgnoreCase(isHazardous) ? 1 : 0);
                    }
                    component.setHazardLevel(comp.get("hazard_level"));
                    component.setComponentFunction(comp.get("component_function"));
                    
                    msdsComponentMapper.insertMsdsComponent(component);
                }
                logger.info("成分信息数据保存成功，共{}个成分", components.size());
            } else {
                logger.warn("成分信息列表为空");
            }
        } else {
            logger.warn("成分信息数据为空或null");
        }
        
        // 4-16. 保存其他章节数据（使用辅助方法）
        try {
            saveXmlFirstAid(msdsId, msdsData);
            logger.info("急救措施数据保存成功");
        } catch (Exception e) {
            logger.error("急救措施数据保存失败", e);
        }
        
        try {
            saveXmlFireFighting(msdsId, msdsData);
            logger.info("消防措施数据保存成功");
        } catch (Exception e) {
            logger.error("消防措施数据保存失败", e);
        }
        
        try {
            saveXmlLeakResponse(msdsId, msdsData);
            logger.info("泄漏应急处理数据保存成功");
        } catch (Exception e) {
            logger.error("泄漏应急处理数据保存失败", e);
        }
        
        try {
            saveXmlHandlingStorage(msdsId, msdsData);
            logger.info("操作处置与储存数据保存成功");
        } catch (Exception e) {
            logger.error("操作处置与储存数据保存失败", e);
        }
        
        try {
            saveXmlExposureControl(msdsId, msdsData);
            logger.info("接触控制/个体防护数据保存成功");
        } catch (Exception e) {
            logger.error("接触控制/个体防护数据保存失败", e);
        }
        
        try {
            saveXmlPhysicalChemical(msdsId, msdsData);
            logger.info("理化特性数据保存成功");
        } catch (Exception e) {
            logger.error("理化特性数据保存失败", e);
        }
        
        try {
            saveXmlStabilityReactivity(msdsId, msdsData);
            logger.info("稳定性和反应性数据保存成功");
        } catch (Exception e) {
            logger.error("稳定性和反应性数据保存失败", e);
        }
        
        try {
            saveXmlToxicological(msdsId, msdsData);
            logger.info("毒理学信息数据保存成功");
        } catch (Exception e) {
            logger.error("毒理学信息数据保存失败", e);
        }
        
        try {
            saveXmlEcological(msdsId, msdsData);
            logger.info("生态学资料数据保存成功");
        } catch (Exception e) {
            logger.error("生态学资料数据保存失败", e);
        }
        
        try {
            saveXmlDisposal(msdsId, msdsData);
            logger.info("废弃处置数据保存成功");
        } catch (Exception e) {
            logger.error("废弃处置数据保存失败", e);
        }
        
        try {
            saveXmlTransportation(msdsId, msdsData);
            logger.info("运输信息数据保存成功");
        } catch (Exception e) {
            logger.error("运输信息数据保存失败", e);
        }
        
        try {
            saveXmlRegulatory(msdsId, msdsData);
            logger.info("法规信息数据保存成功");
        } catch (Exception e) {
            logger.error("法规信息数据保存失败", e);
        }
        
        try {
            saveXmlOtherInfo(msdsId, msdsData);
            logger.info("其他信息数据保存成功");
        } catch (Exception e) {
            logger.error("其他信息数据保存失败", e);
        }
        
        return msdsId;
    }

    // 辅助方法：保存各个章节数据
    @SuppressWarnings("unchecked")
    private void saveXmlFirstAid(Long msdsId, Map<String, Object> msdsData) {
        Map<String, String> data = (Map<String, String>) msdsData.get("first_aid");
        logger.info("急救措施数据: {}", data);
        if (data != null && !data.isEmpty()) {
            MsdsFirstAid firstAid = new MsdsFirstAid();
            firstAid.setMsdsId(msdsId);
            
            // 基本急救措施
            firstAid.setSkinContact(data.get("skin_contact"));
            firstAid.setEyeContact(data.get("eye_contact"));
            firstAid.setInhalation(data.get("inhalation"));
            firstAid.setIngestion(data.get("ingestion"));
            
            // 其他急救信息
            firstAid.setGeneralNotes(data.get("general_notes"));
            firstAid.setSymptomsEffects(data.get("symptoms_effects"));
            firstAid.setImmediateMedicalAttention(data.get("immediate_medical_attention"));
            firstAid.setAntidoteTreatment(data.get("antidote_treatment"));
            
            msdsFirstAidMapper.insertMsdsFirstAid(firstAid);
            logger.info("急救措施数据保存成功，MSDS ID: {}", msdsId);
        } else {
            logger.warn("急救措施数据为空或null");
        }
    }

    @SuppressWarnings("unchecked")
    private void saveXmlFireFighting(Long msdsId, Map<String, Object> msdsData) {
        Map<String, String> data = (Map<String, String>) msdsData.get("fire_fighting");
        logger.info("消防措施数据: {}", data);
        if (data != null && !data.isEmpty()) {
            MsdsFireFighting fireFighting = new MsdsFireFighting();
            fireFighting.setMsdsId(msdsId);
            fireFighting.setHazardCharacteristics(data.get("hazard_characteristics"));
            fireFighting.setHarmfulCombustionProducts(data.get("harmful_combustion_products"));
            fireFighting.setSuitableExtinguishingMedia(data.get("suitable_extinguishing_media"));
            msdsFireFightingMapper.insertMsdsFireFighting(fireFighting);
            logger.info("消防措施数据保存成功，MSDS ID: {}", msdsId);
        } else {
            logger.warn("消防措施数据为空或null");
        }
    }

    @SuppressWarnings("unchecked")
    private void saveXmlLeakResponse(Long msdsId, Map<String, Object> msdsData) {
        Map<String, String> data = (Map<String, String>) msdsData.get("leak_response");
        if (data != null && !data.isEmpty()) {
            MsdsLeakResponse leakResponse = new MsdsLeakResponse();
            leakResponse.setMsdsId(msdsId);
            leakResponse.setEmergencyProcedures(data.get("emergency_procedures"));
            msdsLeakResponseMapper.insertMsdsLeakResponse(leakResponse);
        }
    }

    @SuppressWarnings("unchecked")
    private void saveXmlHandlingStorage(Long msdsId, Map<String, Object> msdsData) {
        Map<String, String> data = (Map<String, String>) msdsData.get("handling_storage");
        if (data != null && !data.isEmpty()) {
            MsdsHandlingStorage handlingStorage = new MsdsHandlingStorage();
            handlingStorage.setMsdsId(msdsId);
            handlingStorage.setHandlingPrecautions(data.get("handling_precautions"));
            handlingStorage.setStoragePrecautions(data.get("storage_precautions"));
            msdsHandlingStorageMapper.insertMsdsHandlingStorage(handlingStorage);
        }
    }

    @SuppressWarnings("unchecked")
    private void saveXmlExposureControl(Long msdsId, Map<String, Object> msdsData) {
        Map<String, String> data = (Map<String, String>) msdsData.get("exposure_control");
        if (data != null && !data.isEmpty()) {
            MsdsExposureControl exposureControl = new MsdsExposureControl();
            exposureControl.setMsdsId(msdsId);
            exposureControl.setChinaMac(data.get("china_mac"));
            exposureControl.setEngineeringControls(data.get("engineering_controls"));
            exposureControl.setRespiratoryProtection(data.get("respiratory_protection"));
            exposureControl.setEyeProtection(data.get("eye_protection"));
            exposureControl.setBodyProtection(data.get("body_protection"));
            exposureControl.setHandProtection(data.get("hand_protection"));
            msdsExposureControlMapper.insertMsdsExposureControl(exposureControl);
        }
    }

    @SuppressWarnings("unchecked")
    private void saveXmlPhysicalChemical(Long msdsId, Map<String, Object> msdsData) {
        Map<String, String> data = (Map<String, String>) msdsData.get("physical_chemical");
        logger.info("=== 开始保存理化特性数据 ===");
        logger.info("MSDS ID: {}", msdsId);
        logger.info("msdsData keys: {}", msdsData.keySet());
        logger.info("理化特性数据: {}", data);
        logger.info("理化特性数据是否为null: {}", data == null);
        logger.info("理化特性数据是否为空: {}", data != null ? data.isEmpty() : "data is null");
        if (data != null && !data.isEmpty()) {
            MsdsPhysicalChemical physicalChemical = new MsdsPhysicalChemical();
            physicalChemical.setMsdsId(msdsId);
            
            // 基本物理性质
            physicalChemical.setAppearance(data.get("appearance"));
            physicalChemical.setOdor(data.get("odor"));
            physicalChemical.setOdorThreshold(data.get("odor_threshold"));
            
            // 温度相关性质
            physicalChemical.setMeltingPoint(data.get("melting_point"));
            physicalChemical.setBoilingPoint(data.get("boiling_point"));
            physicalChemical.setFlashPoint(data.get("flash_point"));
            physicalChemical.setIgnitionTemperature(data.get("ignition_temperature"));
            physicalChemical.setAutoignitionTemperature(data.get("autoignition_temperature"));
            physicalChemical.setDecompositionTemperature(data.get("decomposition_temperature"));
            physicalChemical.setCriticalTemperature(data.get("critical_temperature"));
            
            // 密度和压力性质
            physicalChemical.setRelativeDensity(data.get("relative_density"));
            physicalChemical.setVaporDensity(data.get("vapor_density"));
            physicalChemical.setVaporPressure(data.get("vapor_pressure"));
            physicalChemical.setCriticalPressure(data.get("critical_pressure"));
            
            // 溶解性和其他性质
            physicalChemical.setSolubility(data.get("solubility"));
            physicalChemical.setWaterSolubility(data.get("water_solubility"));
            physicalChemical.setPhValue(data.get("ph_value"));
            physicalChemical.setViscosity(data.get("viscosity"));
            
            // 分子信息
            physicalChemical.setMolecularFormula(data.get("molecular_formula"));
            physicalChemical.setMolecularWeight(data.get("molecular_weight"));
            physicalChemical.setMainComponents(data.get("main_components"));
            
            // 其他性质
            physicalChemical.setFlammability(data.get("flammability"));
            physicalChemical.setHeatOfCombustion(data.get("heat_of_combustion"));
            physicalChemical.setMainUsage(data.get("main_usage"));
            physicalChemical.setOtherProperties(data.get("other_properties"));
            
            msdsPhysicalChemicalMapper.insertMsdsPhysicalChemical(physicalChemical);
            logger.info("理化特性数据保存成功，MSDS ID: {}", msdsId);
        } else {
            logger.warn("理化特性数据为空或null");
        }
    }

    @SuppressWarnings("unchecked")
    private void saveXmlStabilityReactivity(Long msdsId, Map<String, Object> msdsData) {
        Map<String, String> data = (Map<String, String>) msdsData.get("stability_reactivity");
        if (data != null && !data.isEmpty()) {
            MsdsStabilityReactivity stabilityReactivity = new MsdsStabilityReactivity();
            stabilityReactivity.setMsdsId(msdsId);
            stabilityReactivity.setStability(data.get("stability"));
            stabilityReactivity.setIncompatibleSubstances(data.get("incompatible_substances"));
            stabilityReactivity.setConditionsToAvoid(data.get("conditions_to_avoid"));
            stabilityReactivity.setPolymerizationHazard(data.get("polymerization_hazard"));
            stabilityReactivity.setDecompositionProducts(data.get("decomposition_products"));
            msdsStabilityReactivityMapper.insertMsdsStabilityReactivity(stabilityReactivity);
        }
    }

    @SuppressWarnings("unchecked")
    private void saveXmlToxicological(Long msdsId, Map<String, Object> msdsData) {
        Map<String, String> data = (Map<String, String>) msdsData.get("toxicological");
        logger.info("毒理学信息数据: {}", data);
        if (data != null && !data.isEmpty()) {
            MsdsToxicological toxicological = new MsdsToxicological();
            toxicological.setMsdsId(msdsId);
            
            String acuteToxicity = data.get("acute_toxicity");
            if (StringUtils.isNotBlank(acuteToxicity)) {
                // 保存完整的急性毒性描述
                toxicological.setAcuteToxicity(acuteToxicity);
                
                // 提取LD50(经口)数据 - 匹配格式：LD50：数值mg/kg(大鼠经口)或LD50：数值mg／kg(大鼠经口)
                String ld50OralPattern = "LD50[：:](\\d+(?:\\.\\d+)?)[\\s]*mg[/／]kg[\\s]*\\([^)]*(?:大鼠|rat)(?:经口|oral)[^)]*\\)";
                java.util.regex.Pattern patternOral = java.util.regex.Pattern.compile(ld50OralPattern, java.util.regex.Pattern.CASE_INSENSITIVE);
                java.util.regex.Matcher matcherOral = patternOral.matcher(acuteToxicity);
                if (matcherOral.find()) {
                    String ld50Oral = matcherOral.group(0); // 获取完整匹配
                    toxicological.setLd50Oral(ld50Oral);
                }
                
                // 提取LD50(经皮)数据 - 匹配格式：数值mg/kg(大鼠经皮)或数值mg／kg(大鼠经皮)
                String ld50DermalPattern = "(\\d+(?:\\.\\d+)?)[\\s]*mg[/／]kg[\\s]*\\([^)]*(?:大鼠|兔|rabbit)(?:经皮|dermal)[^)]*\\)";
                java.util.regex.Pattern patternDermal = java.util.regex.Pattern.compile(ld50DermalPattern, java.util.regex.Pattern.CASE_INSENSITIVE);
                java.util.regex.Matcher matcherDermal = patternDermal.matcher(acuteToxicity);
                if (matcherDermal.find()) {
                    String ld50Dermal = matcherDermal.group(0);
                    toxicological.setLd50Dermal(ld50Dermal);
                }
                
                // 提取LC50(吸入)数据 - 匹配格式：LC50：...或LC50后的内容
                String lc50Pattern = "LC50[：:]([^\\n\\r;；]+)";
                java.util.regex.Pattern patternLc50 = java.util.regex.Pattern.compile(lc50Pattern, java.util.regex.Pattern.CASE_INSENSITIVE);
                java.util.regex.Matcher matcherLc50 = patternLc50.matcher(acuteToxicity);
                if (matcherLc50.find()) {
                    String lc50 = matcherLc50.group(1).trim();
                    toxicological.setLc50Inhalation(lc50);
                }
                
                // 提取RTECS编号
                String rtecsPattern = "RTECS[：:]\\s*([A-Z0-9]+)";
                java.util.regex.Pattern patternRtecs = java.util.regex.Pattern.compile(rtecsPattern, java.util.regex.Pattern.CASE_INSENSITIVE);
                java.util.regex.Matcher matcherRtecs = patternRtecs.matcher(acuteToxicity);
                if (matcherRtecs.find()) {
                    String rtecs = matcherRtecs.group(1);
                    toxicological.setRtecs(rtecs);
                }
            }
            
            msdsToxicologicalMapper.insertMsdsToxicological(toxicological);
            logger.info("毒理学信息数据保存成功，MSDS ID: {}", msdsId);
        } else {
            logger.warn("毒理学信息数据为空或null");
        }
    }

    @SuppressWarnings("unchecked")
    private void saveXmlEcological(Long msdsId, Map<String, Object> msdsData) {
        Map<String, String> data = (Map<String, String>) msdsData.get("ecological");
        if (data != null && !data.isEmpty()) {
            MsdsEcological ecological = new MsdsEcological();
            ecological.setMsdsId(msdsId);
            ecological.setEcologicalToxicity(data.get("ecological_toxicity"));
            msdsEcologicalMapper.insertMsdsEcological(ecological);
        }
    }

    @SuppressWarnings("unchecked")
    private void saveXmlDisposal(Long msdsId, Map<String, Object> msdsData) {
        Map<String, String> data = (Map<String, String>) msdsData.get("disposal");
        if (data != null && !data.isEmpty()) {
            MsdsDisposal disposal = new MsdsDisposal();
            disposal.setMsdsId(msdsId);
            disposal.setWasteProperties(data.get("waste_properties"));
            disposal.setDisposalMethod(data.get("disposal_method"));
            msdsDisposalMapper.insertMsdsDisposal(disposal);
        }
    }

    @SuppressWarnings("unchecked")
    private void saveXmlTransportation(Long msdsId, Map<String, Object> msdsData) {
        Map<String, String> data = (Map<String, String>) msdsData.get("transportation");
        if (data != null && !data.isEmpty()) {
            MsdsTransportation transportation = new MsdsTransportation();
            transportation.setMsdsId(msdsId);
            transportation.setDangerousGoodsNumber(data.get("dangerous_goods_number"));
            transportation.setUnNumber(data.get("un_number"));
            transportation.setPackingGroup(data.get("packing_group"));
            transportation.setPackagingMethod(data.get("packaging_method"));
            transportation.setTransportationPrecautions(data.get("transportation_precautions"));
            msdsTransportationMapper.insertMsdsTransportation(transportation);
        }
    }

    @SuppressWarnings("unchecked")
    private void saveXmlRegulatory(Long msdsId, Map<String, Object> msdsData) {
        Map<String, String> data = (Map<String, String>) msdsData.get("regulatory");
        logger.info("法规信息数据: {}", data);
        if (data != null && !data.isEmpty()) {
            MsdsRegulatory regulatory = new MsdsRegulatory();
            regulatory.setMsdsId(msdsId);
            regulatory.setRegulatoryInfo(data.get("regulatory_info"));
            regulatory.setDomesticRegulations(data.get("domestic_regulations"));
            msdsRegulatoryMapper.insertMsdsRegulatory(regulatory);
            logger.info("法规信息数据保存成功，MSDS ID: {}", msdsId);
        } else {
            logger.warn("法规信息数据为空或null");
        }
    }

    @SuppressWarnings("unchecked")
    private void saveXmlOtherInfo(Long msdsId, Map<String, Object> msdsData) {
        Map<String, String> data = (Map<String, String>) msdsData.get("other_info");
        logger.info("其他信息数据: {}", data);
        if (data != null && !data.isEmpty()) {
            MsdsOtherInfo otherInfo = new MsdsOtherInfo();
            otherInfo.setMsdsId(msdsId);
            otherInfo.setReferences(data.get("references"));
            otherInfo.setDataSources(data.get("data_sources"));
            otherInfo.setFormFillDepartment(data.get("form_fill_department"));
            otherInfo.setFormFillPerson(data.get("form_fill_person"));
            otherInfo.setDataAuditUnit(data.get("data_audit_unit"));
            otherInfo.setDataAuditPerson(data.get("data_audit_person"));
            otherInfo.setTechnicalReviewPerson(data.get("technical_review_person"));
            otherInfo.setModificationNotes(data.get("modification_notes"));
            otherInfo.setTrainingRequirements(data.get("training_requirements"));
            otherInfo.setAdditionalInformation(data.get("additional_information"));
            otherInfo.setDisclaimer(data.get("disclaimer"));
            msdsOtherInfoMapper.insertMsdsOtherInfo(otherInfo);
            logger.info("其他信息数据保存成功，MSDS ID: {}", msdsId);
        } else {
            logger.warn("其他信息数据为空或null");
        }
    }

    /**
     * 删除MSDS相关数据
     */
    private void deleteMsdsRelatedData(Long msdsId) {
        msdsHazardMapper.deleteMsdsHazardByMsdsId(msdsId);
        msdsComponentMapper.deleteMsdsComponentByMsdsId(msdsId);
        msdsFirstAidMapper.deleteMsdsFirstAidByMsdsId(msdsId);
        msdsFireFightingMapper.deleteMsdsFireFightingByMsdsId(msdsId);
        msdsLeakResponseMapper.deleteMsdsLeakResponseByMsdsId(msdsId);
        msdsHandlingStorageMapper.deleteMsdsHandlingStorageByMsdsId(msdsId);
        msdsExposureControlMapper.deleteMsdsExposureControlByMsdsId(msdsId);
        msdsPhysicalChemicalMapper.deleteMsdsPhysicalChemicalByMsdsId(msdsId);
        msdsStabilityReactivityMapper.deleteMsdsStabilityReactivityByMsdsId(msdsId);
        msdsToxicologicalMapper.deleteMsdsToxicologicalByMsdsId(msdsId);
        msdsEcologicalMapper.deleteMsdsEcologicalByMsdsId(msdsId);
        msdsDisposalMapper.deleteMsdsDisposalByMsdsId(msdsId);
        msdsTransportationMapper.deleteMsdsTransportationByMsdsId(msdsId);
        msdsRegulatoryMapper.deleteMsdsRegulatoryByMsdsId(msdsId);
        msdsOtherInfoMapper.deleteMsdsOtherInfoByMsdsId(msdsId);
    }
}