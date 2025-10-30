package com.ruoyi.system.service.impl;

import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFRun;

// iText PDF相关导入
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
// import com.itextpdf.layout.element.Cell; // 注释掉以避免与POI的Cell冲突
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.io.font.constants.StandardFonts;
import com.itextpdf.kernel.colors.ColorConstants;

import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;
import jakarta.servlet.http.HttpServletResponse;
import com.ruoyi.system.domain.MsdsMain;
import com.ruoyi.system.service.IMsdsExportService;
import com.ruoyi.system.service.impl.MsdsTemplateGeneratorService;
import com.ruoyi.common.utils.StringUtils;

/**
 * MSDS数据导出Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
@Service
public class MsdsExportServiceImpl implements IMsdsExportService
{
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    
    @Autowired
    private MsdsTemplateGeneratorService templateGeneratorService;

    /**
     * 导出MSDS数据为Excel格式
     */
    @Override
    public void exportToExcel(HttpServletResponse response, List<MsdsMain> msdsList, String fileName)
    {
        try (XSSFWorkbook workbook = new XSSFWorkbook())
        {
            Sheet sheet = workbook.createSheet("MSDS数据");
            
            // 创建标题行
            Row headerRow = sheet.createRow(0);
            String[] headers = {
                "ID", "MSDS编号", "化学品中文名", "化学品英文名", "CAS号", 
                "企业名称", "企业地址", "联系电话", "电子邮件", "版本号", 
                "修订日期", "状态", "创建时间"
            };
            
            // 创建标题样式
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            
            for (int i = 0; i < headers.length; i++)
            {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
                sheet.autoSizeColumn(i);
            }
            
            // 填充数据
            for (int i = 0; i < msdsList.size(); i++)
            {
                Row row = sheet.createRow(i + 1);
                MsdsMain msds = msdsList.get(i);
                
                row.createCell(0).setCellValue(msds.getId() != null ? msds.getId().toString() : "");
                row.createCell(1).setCellValue(StringUtils.nvl(msds.getMsdsCode(), ""));
                row.createCell(2).setCellValue(StringUtils.nvl(msds.getProductName(), ""));
                row.createCell(3).setCellValue(StringUtils.nvl(msds.getProductEnglishName(), ""));
                row.createCell(4).setCellValue(StringUtils.nvl(msds.getCasNumber(), ""));
                row.createCell(5).setCellValue(StringUtils.nvl(msds.getCompanyName(), ""));
                row.createCell(6).setCellValue(StringUtils.nvl(msds.getCompanyAddress(), ""));
                row.createCell(7).setCellValue(StringUtils.nvl(msds.getContactPhone(), ""));
                row.createCell(8).setCellValue(StringUtils.nvl(msds.getEmail(), ""));
                row.createCell(9).setCellValue(StringUtils.nvl(msds.getVersion(), ""));
                row.createCell(10).setCellValue(msds.getRevisionDate() != null ? DATE_FORMAT.format(msds.getRevisionDate()) : "");
                row.createCell(11).setCellValue(StringUtils.nvl(msds.getStatus(), ""));
                row.createCell(12).setCellValue(msds.getCreateTime() != null ? DATE_FORMAT.format(msds.getCreateTime()) : "");
            }
            
            // 自动调整列宽
            for (int i = 0; i < headers.length; i++)
            {
                sheet.autoSizeColumn(i);
            }
            
            // 设置响应头
            setExcelResponseHeaders(response, fileName);
            
            // 写入响应
            workbook.write(response.getOutputStream());
        }
        catch (IOException e)
        {
            throw new RuntimeException("导出Excel失败", e);
        }
    }

    /**
     * 导出MSDS数据为CSV格式
     */
    @Override
    public void exportToCsv(HttpServletResponse response, List<MsdsMain> msdsList, String fileName)
    {
        try
        {
            setCsvResponseHeaders(response, fileName);
            
            try (PrintWriter writer = new PrintWriter(new OutputStreamWriter(response.getOutputStream(), StandardCharsets.UTF_8)))
            {
                // 写入BOM以支持Excel正确显示中文
                response.getOutputStream().write(new byte[]{(byte)0xEF, (byte)0xBB, (byte)0xBF});
                
                // 写入标题行
                writer.println("ID,MSDS编号,化学品中文名,化学品英文名,CAS号,企业名称,企业地址,联系电话,电子邮件,版本号,修订日期,状态,创建时间");
                
                // 写入数据行
                for (MsdsMain msds : msdsList)
                {
                    StringBuilder line = new StringBuilder();
                    line.append(escapeCsvValue(msds.getId() != null ? msds.getId().toString() : "")).append(",");
                    line.append(escapeCsvValue(msds.getMsdsCode())).append(",");
                    line.append(escapeCsvValue(msds.getProductName())).append(",");
                    line.append(escapeCsvValue(msds.getProductEnglishName())).append(",");
                    line.append(escapeCsvValue(msds.getCasNumber())).append(",");
                    line.append(escapeCsvValue(msds.getCompanyName())).append(",");
                    line.append(escapeCsvValue(msds.getCompanyAddress())).append(",");
                    line.append(escapeCsvValue(msds.getContactPhone())).append(",");
                    line.append(escapeCsvValue(msds.getEmail())).append(",");
                    line.append(escapeCsvValue(msds.getVersion())).append(",");
                    line.append(escapeCsvValue(msds.getRevisionDate() != null ? DATE_FORMAT.format(msds.getRevisionDate()) : "")).append(",");
                    line.append(escapeCsvValue(msds.getStatus())).append(",");
                    line.append(escapeCsvValue(msds.getCreateTime() != null ? DATE_FORMAT.format(msds.getCreateTime()) : ""));
                    
                    writer.println(line.toString());
                }
            }
        }
        catch (IOException e)
        {
            throw new RuntimeException("导出CSV失败", e);
        }
    }

    /**
     * 导出MSDS统计报表为Excel格式
     */
    @Override
    public void exportStatisticsToExcel(HttpServletResponse response, Map<String, Object> statisticsData, String fileName)
    {
        try (XSSFWorkbook workbook = new XSSFWorkbook())
        {
            // 创建统计概览sheet
            Sheet overviewSheet = workbook.createSheet("统计概览");
            createStatisticsOverviewSheet(workbook, overviewSheet, statisticsData);
            
            // 创建企业分布sheet
            if (statisticsData.containsKey("companyStatistics"))
            {
                Sheet companySheet = workbook.createSheet("企业分布");
                createCompanyDistributionSheet(workbook, companySheet, 
                    (Map<String, Long>) statisticsData.get("companyStatistics"));
            }
            
            // 设置响应头
            setExcelResponseHeaders(response, fileName);
            
            // 写入响应
            workbook.write(response.getOutputStream());
        }
        catch (IOException e)
        {
            throw new RuntimeException("导出统计报表失败", e);
        }
    }

    /**
     * 导出MSDS详细信息为Word格式
     */
    @Override
    public void exportToWord(HttpServletResponse response, MsdsMain msdsMain, String fileName)
    {
        try (XWPFDocument document = new XWPFDocument())
        {
            // 创建标题
            XWPFParagraph titleParagraph = document.createParagraph();
            titleParagraph.setAlignment(org.apache.poi.xwpf.usermodel.ParagraphAlignment.CENTER);
            XWPFRun titleRun = titleParagraph.createRun();
            titleRun.setText("化学品安全技术说明书 (MSDS)");
            titleRun.setBold(true);
            titleRun.setFontSize(16);
            
            // 添加空行
            document.createParagraph();
            
            // 第一部分：化学品及企业标识
            addSection(document, "第一部分：化学品及企业标识");
            addField(document, "化学品中文名称", msdsMain.getProductName());
            addField(document, "化学品英文名称", msdsMain.getProductEnglishName());
            addField(document, "CAS登记号", msdsMain.getCasNumber());
            addField(document, "MSDS编号", msdsMain.getMsdsCode());
            addField(document, "企业名称", msdsMain.getCompanyName());
            addField(document, "企业地址", msdsMain.getCompanyAddress());
            addField(document, "联系电话", msdsMain.getContactPhone());
            addField(document, "电子邮件", msdsMain.getEmail());
            addField(document, "应急电话", msdsMain.getEmergencyPhone());
            addField(document, "版本号", msdsMain.getVersion());
            addField(document, "修订日期", msdsMain.getRevisionDate() != null ? DATE_FORMAT.format(msdsMain.getRevisionDate()) : "");
            
            // 添加其他部分的占位符
            for (int i = 2; i <= 16; i++)
            {
                document.createParagraph();
                addSection(document, "第" + getChineseNumber(i) + "部分：[待完善]");
                XWPFParagraph contentParagraph = document.createParagraph();
                XWPFRun contentRun = contentParagraph.createRun();
                contentRun.setText("此部分内容需要根据具体的MSDS模块数据进行填充。");
            }
            
            // 设置响应头
            setWordResponseHeaders(response, fileName);
            
            // 写入响应
            document.write(response.getOutputStream());
        }
        catch (IOException e)
        {
            throw new RuntimeException("导出Word文档失败", e);
        }
    }

    /**
     * 导出MSDS详细信息为PDF格式
     */
    @Override
    public void exportToPdf(HttpServletResponse response, MsdsMain msdsMain, String fileName)
    {
        try
        {
            // 设置PDF响应头
            response.setContentType("application/pdf");
            response.setCharacterEncoding("UTF-8");
            String encodedFileName = URLEncoder.encode(fileName, StandardCharsets.UTF_8.toString());
            response.setHeader("Content-Disposition", "attachment; filename=" + encodedFileName + ".pdf");

            // 初始化PDF文档
            PdfWriter writer = new PdfWriter(response.getOutputStream());
            PdfDocument pdf = new PdfDocument(writer);
            Document document = new Document(pdf);

            // 中文字体：使用标准字体
            PdfFont font = PdfFontFactory.createFont(StandardFonts.HELVETICA);
            document.setFont(font);

            // 标题
            Paragraph title = new Paragraph("化学品安全技术说明书 (MSDS)")
                .setBold()
                .setFontSize(16)
                .setTextAlignment(com.itextpdf.layout.properties.TextAlignment.CENTER);
            document.add(title);

            document.add(new Paragraph(" ")); // 空行

            // 基本信息表格
            Table table = new Table(com.itextpdf.layout.properties.UnitValue.createPercentArray(new float[]{25, 75}))
                .useAllAvailableWidth();

            addTableRow(table, "MSDS编号", msdsMain.getMsdsCode());
            addTableRow(table, "化学品中文名", msdsMain.getProductName());
            addTableRow(table, "化学品英文名", msdsMain.getProductEnglishName());
            addTableRow(table, "CAS号", msdsMain.getCasNumber());
            addTableRow(table, "企业名称", msdsMain.getCompanyName());
            addTableRow(table, "企业地址", msdsMain.getCompanyAddress());
            addTableRow(table, "联系电话", msdsMain.getContactPhone());
            addTableRow(table, "电子邮件", msdsMain.getEmail());
            addTableRow(table, "应急电话", msdsMain.getEmergencyPhone());
            addTableRow(table, "版本号", msdsMain.getVersion());
            addTableRow(table, "修订日期", msdsMain.getRevisionDate() != null ? DATE_FORMAT.format(msdsMain.getRevisionDate()) : "");

            document.add(table);

            // 结束
            document.close();
        }
        catch (Exception e)
        {
            throw new RuntimeException("导出PDF失败", e);
        }
    }

    /**
     * 批量导出MSDS为压缩包
     */
    @Override
    public void batchExportAsZip(HttpServletResponse response, List<MsdsMain> msdsList, String format, String fileName)
    {
        try
        {
            setZipResponseHeaders(response, fileName);
            
            try (ZipOutputStream zipOut = new ZipOutputStream(response.getOutputStream()))
            {
                for (int i = 0; i < msdsList.size(); i++)
                {
                    MsdsMain msds = msdsList.get(i);
                    String entryName = String.format("%03d_%s.%s", i + 1, 
                        StringUtils.isNotEmpty(msds.getProductName()) ? msds.getProductName() : "MSDS", format);
                    
                    ZipEntry zipEntry = new ZipEntry(entryName);
                    zipOut.putNextEntry(zipEntry);
                    
                    // 根据格式导出不同类型的文件
                    switch (format.toLowerCase())
                    {
                        case "excel":
                            exportSingleMsdsToExcel(zipOut, msds);
                            break;
                        case "word":
                            exportSingleMsdsToWord(zipOut, msds);
                            break;
                        case "pdf":
                            exportSingleMsdsToPdf(zipOut, msds);
                            break;
                        default:
                            throw new IllegalArgumentException("不支持的导出格式: " + format);
                    }
                    
                    zipOut.closeEntry();
                }
            }
        }
        catch (IOException e)
        {
            throw new RuntimeException("批量导出压缩包失败", e);
        }
    }

    /**
     * 生成MSDS数据导入模板（基于@Excel注解动态生成多Sheet）
     */
    @Override
    public void generateImportTemplate(HttpServletResponse response, String templateType)
    {
        generateImportTemplate(response, templateType, "all", null);
    }
    
    /**
     * 生成MSDS数据导入模板（支持scope参数）
     */
    @Override
    public void generateImportTemplate(HttpServletResponse response, String templateType, String scope, String tableName)
    {
        try
        {
            // 使用新的模板生成器服务
            byte[] templateData = templateGeneratorService.generateTemplate(templateType, scope, tableName);
            
            // 构建文件名
            String fileName = "MSDS导入模板_" + (StringUtils.isNotEmpty(templateType) ? templateType : "basic");
            if (!"all".equals(scope) && StringUtils.isNotEmpty(tableName)) {
                fileName += "_" + tableName;
            }
            fileName += "_" + new SimpleDateFormat("yyyyMMdd").format(new Date());
            setExcelResponseHeaders(response, fileName);
            
            // 输出模板数据
            response.getOutputStream().write(templateData);
            response.getOutputStream().flush();
        }
        catch (IOException e)
        {
            throw new RuntimeException("生成导入模板失败", e);
        }
    }

    /**
     * 导出审计日志报表
     */
    @Override
    public void exportAuditReport(HttpServletResponse response, Map<String, Object> auditData, String fileName)
    {
        // 实现审计日志报表导出逻辑
        throw new RuntimeException("审计日志报表导出功能待实现");
    }

    /**
     * 导出风险评估报告
     */
    @Override
    public void exportRiskAssessmentReport(HttpServletResponse response, Map<String, Object> riskData, String fileName)
    {
        // 实现风险评估报告导出逻辑
        throw new RuntimeException("风险评估报告导出功能待实现");
    }

    // ========== 私有辅助方法 ==========

    /**
     * 设置Excel响应头
     */
    private void setExcelResponseHeaders(HttpServletResponse response, String fileName)
    {
        try
        {
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setCharacterEncoding("UTF-8");
            String encodedFileName = URLEncoder.encode(fileName, StandardCharsets.UTF_8.toString());
            response.setHeader("Content-Disposition", "attachment; filename=" + encodedFileName + ".xlsx");
        }
        catch (Exception e)
        {
            throw new RuntimeException("设置Excel响应头失败", e);
        }
    }

    /**
     * 设置CSV响应头
     */
    private void setCsvResponseHeaders(HttpServletResponse response, String fileName)
    {
        try
        {
            response.setContentType("text/csv");
            response.setCharacterEncoding("UTF-8");
            String encodedFileName = URLEncoder.encode(fileName, StandardCharsets.UTF_8.toString());
            response.setHeader("Content-Disposition", "attachment; filename=" + encodedFileName + ".csv");
        }
        catch (Exception e)
        {
            throw new RuntimeException("设置CSV响应头失败", e);
        }
    }

    /**
     * 设置Word响应头
     */
    private void setWordResponseHeaders(HttpServletResponse response, String fileName)
    {
        try
        {
            response.setContentType("application/vnd.openxmlformats-officedocument.wordprocessingml.document");
            response.setCharacterEncoding("UTF-8");
            String encodedFileName = URLEncoder.encode(fileName, StandardCharsets.UTF_8.toString());
            response.setHeader("Content-Disposition", "attachment; filename=" + encodedFileName + ".docx");
        }
        catch (Exception e)
        {
            throw new RuntimeException("设置Word响应头失败", e);
        }
    }

    /**
     * 设置ZIP响应头
     */
    private void setZipResponseHeaders(HttpServletResponse response, String fileName)
    {
        try
        {
            response.setContentType("application/zip");
            response.setCharacterEncoding("UTF-8");
            String encodedFileName = URLEncoder.encode(fileName, StandardCharsets.UTF_8.toString());
            response.setHeader("Content-Disposition", "attachment; filename=" + encodedFileName + ".zip");
        }
        catch (Exception e)
        {
            throw new RuntimeException("设置ZIP响应头失败", e);
        }
    }

    /**
     * 转义CSV值
     */
    private String escapeCsvValue(String value)
    {
        if (StringUtils.isEmpty(value))
        {
            return "";
        }
        
        // 如果包含逗号、引号或换行符，需要用引号包围并转义内部引号
        if (value.contains(",") || value.contains("\"") || value.contains("\n") || value.contains("\r"))
        {
            return "\"" + value.replace("\"", "\"\"") + "\"";
        }
        
        return value;
    }

    /**
     * 创建统计概览Sheet
     */
    private void createStatisticsOverviewSheet(XSSFWorkbook workbook, Sheet sheet, Map<String, Object> statisticsData)
    {
        // 创建标题
        Row titleRow = sheet.createRow(0);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("MSDS统计概览");
        
        CellStyle titleStyle = workbook.createCellStyle();
        Font titleFont = workbook.createFont();
        titleFont.setBold(true);
        titleFont.setFontHeightInPoints((short) 14);
        titleStyle.setFont(titleFont);
        titleCell.setCellStyle(titleStyle);
        
        // 添加统计数据
        int rowIndex = 2;
        for (Map.Entry<String, Object> entry : statisticsData.entrySet())
        {
            Row row = sheet.createRow(rowIndex++);
            row.createCell(0).setCellValue(entry.getKey());
            row.createCell(1).setCellValue(entry.getValue().toString());
        }
        
        // 自动调整列宽
        sheet.autoSizeColumn(0);
        sheet.autoSizeColumn(1);
    }

    /**
     * 创建企业分布Sheet
     */
    private void createCompanyDistributionSheet(XSSFWorkbook workbook, Sheet sheet, Map<String, Long> companyStats)
    {
        // 创建标题行
        Row headerRow = sheet.createRow(0);
        headerRow.createCell(0).setCellValue("企业名称");
        headerRow.createCell(1).setCellValue("MSDS数量");
        
        // 填充数据
        int rowIndex = 1;
        for (Map.Entry<String, Long> entry : companyStats.entrySet())
        {
            Row row = sheet.createRow(rowIndex++);
            row.createCell(0).setCellValue(entry.getKey());
            row.createCell(1).setCellValue(entry.getValue());
        }
        
        // 自动调整列宽
        sheet.autoSizeColumn(0);
        sheet.autoSizeColumn(1);
    }

    /**
     * 创建说明Sheet
     */
    private void createInstructionSheet(XSSFWorkbook workbook, Sheet sheet, String templateType)
    {
        String[] instructions;
        
        if ("full".equals(templateType))
        {
            instructions = new String[]{
                "MSDS数据导入说明（完整版）",
                "",
                "1. 必填字段说明：",
                "   - MSDS编号*：系统内唯一标识，建议格式：MSDS001",
                "   - 化学品中文名*：化学品的中文名称，不能为空",
                "   - CAS号*：化学品的CAS登记号，格式如：64-17-5",
                "",
                "2. 可选字段说明：",
                "   - 化学品英文名：化学品的英文名称",
                "   - 化学品别名：化学品的其他名称或俗称",
                "   - 企业名称：生产或供应企业名称",
                "   - 企业地址：企业详细地址",
                "   - 邮编：企业所在地邮政编码",
                "   - 联系电话：企业联系电话",
                "   - 传真号码：企业传真号码",
                "   - 电子邮件：企业联系邮箱",
                "   - 应急电话：紧急情况联系电话",
                "   - 产品推荐用途：化学品的推荐使用场景",
                "   - 产品限制用途：化学品的使用限制说明",
                "   - 版本号：MSDS文档版本，如：1.0",
                "   - 修订日期：文档修订日期，格式：yyyy-MM-dd",
                "   - 生效日期：文档生效日期，格式：yyyy-MM-dd",
                "   - 状态：active（有效）、inactive（无效）、draft（草稿）、pending（待审）、approved（已审批）、archived（已归档）",
                "   - 审批人：文档审批人姓名",
                "   - 审批日期：文档审批日期，格式：yyyy-MM-dd",
                "   - 是否有效：1（有效）、0（无效）",
                "   - 备注：其他说明信息",
                "",
                "3. 导入注意事项：",
                "   - 请勿修改表头，否则可能导致导入失败",
                "   - 日期格式统一使用：yyyy-MM-dd（如：2024-01-01）",
                "   - CAS号请填写标准格式（如：64-17-5）",
                "   - 建议一次导入数据不超过1000条",
                "   - 导入前请检查数据完整性和格式正确性",
                "   - 如有疑问，请联系系统管理员",
                "",
                "4. 详细字段说明请参考'字段说明'工作表"
            };
        }
        else
        {
            instructions = new String[]{
                "MSDS数据导入说明",
                "",
                "1. 请按照模板格式填写数据，带*号的字段为必填项",
                "2. 日期格式请使用：yyyy-MM-dd（如：2024-01-01）",
                "3. CAS号请填写标准格式（如：64-17-5）",
                "4. 状态字段可填写：active（有效）、inactive（无效）、draft（草稿）",
                "5. 请勿修改表头，否则可能导入失败",
                "6. 建议一次导入数据不超过1000条",
                "7. 如有疑问，请联系系统管理员"
            };
        }
        
        for (int i = 0; i < instructions.length; i++)
        {
            Row row = sheet.createRow(i);
            Cell cell = row.createCell(0);
            cell.setCellValue(instructions[i]);
            
            if (i == 0)
            {
                CellStyle titleStyle = workbook.createCellStyle();
                Font titleFont = workbook.createFont();
                titleFont.setBold(true);
                titleStyle.setFont(titleFont);
                cell.setCellStyle(titleStyle);
            }
        }
        
        sheet.autoSizeColumn(0);
    }

    /**
     * 创建字段说明Sheet（用于full模板）
     */
    private void createFieldDescriptionSheet(XSSFWorkbook workbook, Sheet sheet)
    {
        // 创建表头
        Row headerRow = sheet.createRow(0);
        String[] headers = {"字段名称", "是否必填", "数据类型", "最大长度", "格式要求", "示例值", "说明"};
        
        // 创建标题样式
        CellStyle headerStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);
        headerStyle.setFillForegroundColor(IndexedColors.LIGHT_BLUE.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        
        for (int i = 0; i < headers.length; i++)
        {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }
        
        // 字段详细信息 - 包含所有16个子表的字段
        String[][] fieldData = {
            // 主表字段
            {"MSDS编号", "是", "文本", "50", "建议格式：MSDS+数字", "MSDS001", "系统内唯一标识，用于区分不同的MSDS文档"},
            {"化学品中文名", "是", "文本", "255", "中文名称", "乙醇", "化学品的中文名称，必须填写"},
            {"化学品英文名", "否", "文本", "255", "英文名称", "Ethanol", "化学品的英文名称，可选填写"},
            {"化学品别名", "否", "文本", "255", "其他名称", "酒精", "化学品的别名、俗称或其他名称"},
            {"CAS号", "是", "文本", "50", "标准CAS格式", "64-17-5", "化学品的CAS登记号，必须符合标准格式"},
            {"企业名称", "否", "文本", "255", "企业全称", "示例化工有限公司", "生产或供应企业的名称"},
            {"企业地址", "否", "文本", "500", "详细地址", "北京市朝阳区示例路123号", "企业的详细地址信息"},
            {"邮编", "否", "文本", "10", "6位数字", "100000", "企业所在地的邮政编码"},
            {"联系电话", "否", "文本", "50", "电话号码格式", "010-12345678", "企业的联系电话"},
            {"传真号码", "否", "文本", "50", "传真号码格式", "010-87654321", "企业的传真号码"},
            {"电子邮件", "否", "文本", "100", "邮箱格式", "example@company.com", "企业的联系邮箱地址"},
            {"应急电话", "否", "文本", "50", "电话号码格式", "400-123-4567", "紧急情况下的联系电话"},
            {"产品推荐用途", "否", "文本", "1000", "用途描述", "工业溶剂、消毒剂", "化学品的推荐使用场景和用途"},
            {"产品限制用途", "否", "文本", "1000", "限制说明", "禁止食用", "化学品的使用限制和禁止事项"},
            {"版本号", "否", "文本", "20", "版本格式", "1.0", "MSDS文档的版本号"},
            {"修订日期", "否", "日期", "-", "yyyy-MM-dd", "2024-01-01", "MSDS文档的修订日期"},
            {"生效日期", "否", "日期", "-", "yyyy-MM-dd", "2024-01-01", "MSDS文档的生效日期"},
            {"状态", "否", "文本", "20", "枚举值", "active", "文档状态：active(有效)、inactive(无效)、draft(草稿)、pending(待审)、approved(已审批)、archived(已归档)"},
            {"审批人", "否", "文本", "50", "人员姓名", "张三", "文档审批人的姓名"},
            {"审批日期", "否", "日期", "-", "yyyy-MM-dd", "2024-01-01", "文档审批的日期"},
            {"是否有效", "否", "数字", "-", "0或1", "1", "标识文档是否有效：1(有效)、0(无效)"},
            {"备注", "否", "文本", "2000", "备注信息", "示例数据", "其他需要说明的信息"},
            
            // 第2部分：危险性概述
            {"危险性类别", "否", "文本", "255", "危险性分类", "易燃液体，类别2", "化学品的危险性分类"},
            {"标签要素", "否", "文本", "1000", "标签信息", "危险，高度易燃液体和蒸气", "GHS标签要素"},
            {"危险性说明", "否", "文本", "2000", "危险描述", "吞咽有害，造成严重眼刺激", "详细的危险性说明"},
            {"防范说明", "否", "文本", "2000", "防范措施", "远离热源、火花、明火和热表面", "安全防范说明"},
            {"物理危险", "否", "文本", "1000", "物理危险描述", "易燃液体和蒸气", "物理危险性描述"},
            {"健康危害", "否", "文本", "1000", "健康危害描述", "吸入、皮肤接触或吞咽有害", "对健康的危害"},
            {"环境危害", "否", "文本", "1000", "环境危害描述", "对水生生物有害", "对环境的危害"},
            
            // 第3部分：成分/组成信息
            {"成分名称", "否", "文本", "255", "成分名称", "乙醇", "主要成分名称"},
            {"成分CAS号", "否", "文本", "50", "CAS格式", "64-17-5", "成分的CAS号"},
            {"成分含量", "否", "文本", "50", "百分比", "95-99%", "成分含量百分比"},
            {"成分分类", "否", "文本", "255", "分类信息", "易燃液体", "成分的危险分类"},
            
            // 第4部分：急救措施
            {"皮肤接触急救", "否", "文本", "1000", "急救措施", "脱去污染的衣着，用肥皂水和清水彻底冲洗皮肤", "皮肤接触时的急救措施"},
            {"眼睛接触急救", "否", "文本", "1000", "急救措施", "提起眼睑，用流动清水或生理盐水冲洗", "眼睛接触时的急救措施"},
            {"吸入急救", "否", "文本", "1000", "急救措施", "迅速脱离现场至空气新鲜处", "吸入时的急救措施"},
            {"食入急救", "否", "文本", "1000", "急救措施", "用水漱口，给饮牛奶或蛋清", "误食时的急救措施"},
            {"急救注意事项", "否", "文本", "1000", "注意事项", "就医时，应将本卡片信息告知医生", "急救时的注意事项"},
            
            // 第5部分：消防措施
            {"灭火方法", "否", "文本", "1000", "灭火方法", "用抗溶性泡沫、干粉、二氧化碳、砂土灭火", "适用的灭火方法"},
            {"灭火注意事项", "否", "文本", "1000", "注意事项", "消防人员须佩戴防毒面具、穿全身消防服", "灭火时的注意事项"},
            {"特别危险性", "否", "文本", "1000", "危险描述", "易燃，其蒸气与空气可形成爆炸性混合物", "火灾时的特别危险性"},
            
            // 第6部分：泄漏应急处理
            {"应急处理", "否", "文本", "1000", "处理方法", "迅速撤离泄漏污染区人员至安全区", "泄漏时的应急处理"},
            {"消除方法", "否", "文本", "1000", "消除方法", "用砂土或其它不燃材料吸附或吸收", "泄漏物的消除方法"},
            {"防护措施", "否", "文本", "1000", "防护要求", "建议应急处理人员戴防毒面具", "处理时的防护措施"},
            
            // 第7部分：操作处置与储存
            {"操作注意事项", "否", "文本", "1000", "操作要求", "密闭操作，全面通风", "操作时的注意事项"},
            {"储存注意事项", "否", "文本", "1000", "储存要求", "储存于阴凉、通风的库房", "储存时的注意事项"},
            
            // 第8部分：接触控制/个体防护
            {"职业接触限值", "否", "文本", "100", "限值数据", "1000mg/m³", "职业接触限值"},
            {"监测方法", "否", "文本", "255", "监测方法", "气相色谱法", "接触监测方法"},
            {"工程控制", "否", "文本", "1000", "控制措施", "生产过程密闭，全面通风", "工程控制措施"},
            {"呼吸系统防护", "否", "文本", "255", "防护用品", "防毒面具", "呼吸系统防护用品"},
            {"眼睛防护", "否", "文本", "255", "防护用品", "安全防护眼镜", "眼睛防护用品"},
            {"身体防护", "否", "文本", "255", "防护用品", "防静电工作服", "身体防护用品"},
            {"手防护", "否", "文本", "255", "防护用品", "防化学品手套", "手部防护用品"},
            {"其他防护", "否", "文本", "1000", "其他要求", "工作现场禁止吸烟、进食和饮水", "其他防护要求"},
            
            // 第9部分：理化特性
            {"外观与性状", "否", "文本", "255", "外观描述", "无色透明液体，有特殊香味", "物质的外观和性状"},
            {"pH值", "否", "文本", "50", "pH值", "7.0", "溶液的pH值"},
            {"熔点", "否", "文本", "50", "温度值", "-114.1℃", "物质的熔点"},
            {"沸点", "否", "文本", "50", "温度值", "78.3℃", "物质的沸点"},
            {"闪点", "否", "文本", "50", "温度值", "13℃", "物质的闪点"},
            {"自燃温度", "否", "文本", "50", "温度值", "363℃", "物质的自燃温度"},
            {"爆炸下限", "否", "文本", "50", "百分比", "3.3%", "爆炸浓度下限"},
            {"爆炸上限", "否", "文本", "50", "百分比", "19%", "爆炸浓度上限"},
            {"相对密度", "否", "文本", "50", "密度值", "0.789", "相对于水的密度"},
            {"相对蒸气密度", "否", "文本", "50", "密度值", "1.59", "相对于空气的蒸气密度"},
            {"饱和蒸气压", "否", "文本", "50", "压力值", "5.33kPa", "饱和蒸气压"},
            {"燃烧热", "否", "文本", "50", "热值", "1365.5kJ/mol", "燃烧热值"},
            {"临界温度", "否", "文本", "50", "温度值", "243.1℃", "临界温度"},
            {"临界压力", "否", "文本", "50", "压力值", "6.38MPa", "临界压力"},
            {"辛醇水分配系数", "否", "文本", "50", "系数值", "-0.31", "辛醇/水分配系数"},
            {"溶解性", "否", "文本", "255", "溶解描述", "与水混溶，可混溶于醚、氯仿、甘油等", "物质的溶解性"},
            {"主要用途", "否", "文本", "1000", "用途描述", "用作化工原料、有机溶剂及燃料", "物质的主要用途"},
            {"其他特性", "否", "文本", "1000", "其他信息", "具有特殊的香甜气味", "其他理化特性"},
            
            // 第10部分：稳定性和反应性
            {"稳定性", "否", "文本", "255", "稳定性描述", "稳定", "物质的稳定性"},
            {"禁配物", "否", "文本", "1000", "禁配物质", "强氧化剂、酸类、碱金属、胺类", "禁止配伍的物质"},
            {"避免接触条件", "否", "文本", "1000", "避免条件", "明火、高热", "应避免的接触条件"},
            {"聚合危害", "否", "文本", "255", "聚合描述", "不聚合", "聚合反应的危害性"},
            {"分解产物", "否", "文本", "1000", "分解产物", "一氧化碳、二氧化碳", "分解时产生的有害物质"},
            
            // 第11部分：毒理学资料
            {"急性毒性", "否", "文本", "1000", "毒性数据", "LD50：7060mg/kg(兔经口)", "急性毒性数据"},
            {"亚急性慢性毒性", "否", "文本", "1000", "毒性描述", "长期接触可导致神经系统损害", "亚急性和慢性毒性"},
            {"刺激性", "否", "文本", "1000", "刺激性描述", "对眼睛和上呼吸道有刺激作用", "对皮肤、眼睛等的刺激性"},
            {"致敏性", "否", "文本", "1000", "致敏描述", "无资料", "致敏性信息"},
            {"致突变性", "否", "文本", "1000", "致突变描述", "无资料", "致突变性信息"},
            {"致畸性", "否", "文本", "1000", "致畸描述", "无资料", "致畸性信息"},
            {"致癌性", "否", "文本", "1000", "致癌描述", "无资料", "致癌性信息"},
            {"其他毒理", "否", "文本", "1000", "其他信息", "无特殊毒理学资料", "其他毒理学信息"},
            
            // 第12部分：生态学资料
            {"生态毒性", "否", "文本", "1000", "毒性数据", "LC50：13000mg/L(鱼类)", "对生物的毒性"},
            {"生物降解性", "否", "文本", "255", "降解描述", "易生物降解", "生物降解性"},
            {"非生物降解性", "否", "文本", "255", "降解描述", "无资料", "非生物降解性"},
            {"生物富集性", "否", "文本", "255", "富集描述", "无资料", "生物富集或生物积累性"},
            {"其他有害作用", "否", "文本", "1000", "其他影响", "无资料", "对环境的其他有害作用"},
            
            // 第13部分：废弃处置
            {"废弃物性质", "否", "文本", "255", "性质描述", "危险废物", "废弃物的性质"},
            {"废弃处置方法", "否", "文本", "1000", "处置方法", "用焚烧法处置", "废弃物的处置方法"},
            {"废弃注意事项", "否", "文本", "1000", "注意事项", "处置前应参阅国家和地方有关法规", "废弃处置时的注意事项"},
            
            // 第14部分：运输信息
            {"危险货物编号", "否", "文本", "50", "编号格式", "32061", "危险货物编号"},
            {"UN编号", "否", "文本", "50", "UN格式", "1170", "联合国危险货物编号"},
            {"包装标志", "否", "文本", "255", "标志描述", "易燃液体", "包装上的危险标志"},
            {"包装类别", "否", "文本", "50", "类别编号", "II", "包装类别"},
            {"包装方法", "否", "文本", "1000", "包装描述", "小开口钢桶；螺纹口玻璃瓶", "包装方法"},
            {"运输注意事项", "否", "文本", "1000", "注意事项", "运输时运输车辆应配备相应品种和数量的消防器材", "运输时的注意事项"},
            
            // 第15部分：法规信息
            {"法规信息", "否", "文本", "2000", "法规内容", "化学危险物品安全管理条例", "相关的法规信息"},
            
            // 第16部分：其他信息
            {"参考文献", "否", "文本", "1000", "文献信息", "化学品安全技术说明书编写指南", "参考文献"},
            {"填表时间", "否", "日期", "-", "yyyy-MM-dd", "2024-01-01", "填表日期"},
            {"填表部门", "否", "文本", "255", "部门名称", "安全环保部", "填表部门"},
            {"数据审核单位", "否", "文本", "255", "单位名称", "技术质量部", "数据审核单位"},
            {"修改说明", "否", "文本", "2000", "修改内容", "首次编制", "修改说明"}
        };
        
        // 填充数据
        for (int i = 0; i < fieldData.length; i++)
        {
            Row row = sheet.createRow(i + 1);
            for (int j = 0; j < fieldData[i].length; j++)
            {
                Cell cell = row.createCell(j);
                cell.setCellValue(fieldData[i][j]);
                
                // 必填字段用红色标识
                if (j == 1 && "是".equals(fieldData[i][j]))
                {
                    CellStyle requiredStyle = workbook.createCellStyle();
                    Font requiredFont = workbook.createFont();
                    requiredFont.setColor(IndexedColors.RED.getIndex());
                    requiredFont.setBold(true);
                    requiredStyle.setFont(requiredFont);
                    cell.setCellStyle(requiredStyle);
                }
            }
        }
        
        // 自动调整列宽
        for (int i = 0; i < headers.length; i++)
        {
            sheet.autoSizeColumn(i);
        }
    }

    /**
     * 导出单个MSDS到Excel
     */
    private void exportSingleMsdsToExcel(OutputStream outputStream, MsdsMain msds) throws IOException
    {
        try (XSSFWorkbook workbook = new XSSFWorkbook())
        {
            Sheet sheet = workbook.createSheet("MSDS详情");
            
            int rowIndex = 0;
            
            // 添加MSDS信息
            addRowToSheet(sheet, rowIndex++, "MSDS编号", msds.getMsdsCode());
            addRowToSheet(sheet, rowIndex++, "化学品中文名", msds.getProductName());
            addRowToSheet(sheet, rowIndex++, "化学品英文名", msds.getProductEnglishName());
            addRowToSheet(sheet, rowIndex++, "CAS号", msds.getCasNumber());
            addRowToSheet(sheet, rowIndex++, "企业名称", msds.getCompanyName());
            addRowToSheet(sheet, rowIndex++, "企业地址", msds.getCompanyAddress());
            addRowToSheet(sheet, rowIndex++, "联系电话", msds.getContactPhone());
            addRowToSheet(sheet, rowIndex++, "电子邮件", msds.getEmail());
            addRowToSheet(sheet, rowIndex++, "版本号", msds.getVersion());
            addRowToSheet(sheet, rowIndex++, "修订日期", msds.getRevisionDate() != null ? DATE_FORMAT.format(msds.getRevisionDate()) : "");
            
            workbook.write(outputStream);
        }
    }

    /**
     * 导出单个MSDS到Word
     */
    private void exportSingleMsdsToWord(OutputStream outputStream, MsdsMain msds) throws IOException
    {
        try (XWPFDocument document = new XWPFDocument())
        {
            // 创建标题
            XWPFParagraph titleParagraph = document.createParagraph();
            titleParagraph.setAlignment(org.apache.poi.xwpf.usermodel.ParagraphAlignment.CENTER);
            XWPFRun titleRun = titleParagraph.createRun();
            titleRun.setText("化学品安全技术说明书");
            titleRun.setBold(true);
            titleRun.setFontSize(16);
            
            // 添加MSDS信息
            addField(document, "MSDS编号", msds.getMsdsCode());
            addField(document, "化学品中文名", msds.getProductName());
            addField(document, "化学品英文名", msds.getProductEnglishName());
            addField(document, "CAS号", msds.getCasNumber());
            addField(document, "企业名称", msds.getCompanyName());
            
            document.write(outputStream);
        }
    }

    /**
     * 添加行到Sheet
     */
    private void addRowToSheet(Sheet sheet, int rowIndex, String label, String value)
    {
        Row row = sheet.createRow(rowIndex);
        row.createCell(0).setCellValue(label);
        row.createCell(1).setCellValue(StringUtils.nvl(value, ""));
    }

    /**
     * 添加Word段落
     */
    private void addSection(XWPFDocument document, String title)
    {
        XWPFParagraph paragraph = document.createParagraph();
        XWPFRun run = paragraph.createRun();
        run.setText(title);
        run.setBold(true);
        run.setFontSize(12);
    }

    /**
     * 添加Word字段
     */
    private void addField(XWPFDocument document, String label, String value)
    {
        XWPFParagraph paragraph = document.createParagraph();
        XWPFRun labelRun = paragraph.createRun();
        labelRun.setText(label + "：");
        labelRun.setBold(true);
        
        XWPFRun valueRun = paragraph.createRun();
        valueRun.setText(StringUtils.nvl(value, ""));
    }

    /**
     * 获取中文数字
     */
    private String getChineseNumber(int number)
    {
        String[] chineseNumbers = {"零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十", "十一", "十二", "十三", "十四", "十五", "十六"};
        return number < chineseNumbers.length ? chineseNumbers[number] : String.valueOf(number);
    }

    /**
     * 向PDF表格添加行
     */
    private void addTableRow(Table table, String label, String value)
    {
        com.itextpdf.layout.element.Cell labelCell = new com.itextpdf.layout.element.Cell().add(new Paragraph(label != null ? label : ""))
            .setBackgroundColor(ColorConstants.LIGHT_GRAY)
            .setBold();
        com.itextpdf.layout.element.Cell valueCell = new com.itextpdf.layout.element.Cell().add(new Paragraph(value != null ? value : ""));
        
        table.addCell(labelCell);
        table.addCell(valueCell);
    }

    /**
     * 导出单个MSDS到PDF流
     */
    private void exportSingleMsdsToPdf(OutputStream outputStream, MsdsMain msds) throws IOException
    {
        try
        {
            PdfWriter writer = new PdfWriter(outputStream);
            PdfDocument pdf = new PdfDocument(writer);
            Document document = new Document(pdf);

            // 中文字体支持
            PdfFont font = PdfFontFactory.createFont(StandardFonts.HELVETICA);
            document.setFont(font);

            // 标题
            Paragraph title = new Paragraph("化学品安全技术说明书 (MSDS)")
                .setBold()
                .setFontSize(16)
                .setTextAlignment(com.itextpdf.layout.properties.TextAlignment.CENTER);
            document.add(title);

            document.add(new Paragraph(" ")); // 空行

            // 基本信息表格
            Table table = new Table(com.itextpdf.layout.properties.UnitValue.createPercentArray(new float[]{25, 75}))
                .useAllAvailableWidth();

            addTableRow(table, "MSDS编号", msds.getMsdsCode());
            addTableRow(table, "化学品中文名", msds.getProductName());
            addTableRow(table, "化学品英文名", msds.getProductEnglishName());
            addTableRow(table, "CAS号", msds.getCasNumber());
            addTableRow(table, "企业名称", msds.getCompanyName());
            addTableRow(table, "企业地址", msds.getCompanyAddress());
            addTableRow(table, "联系电话", msds.getContactPhone());
            addTableRow(table, "电子邮件", msds.getEmail());
            addTableRow(table, "应急电话", msds.getEmergencyPhone());
            addTableRow(table, "版本号", msds.getVersion());
            addTableRow(table, "修订日期", msds.getRevisionDate() != null ? DATE_FORMAT.format(msds.getRevisionDate()) : "");

            document.add(table);
            document.close();
        }
        catch (Exception e)
        {
            throw new IOException("导出PDF失败", e);
        }
    }
}