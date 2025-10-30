package com.ruoyi.system.service;

import java.util.List;
import java.util.Map;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.system.domain.MsdsMain;

/**
 * MSDS主信息 服务层
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public interface IMsdsMainService
{
    /**
     * 查询MSDS主信息
     * 
     * @param id MSDS主键
     * @return MSDS主信息
     */
    public MsdsMain selectMsdsMainById(Long id);

    /**
     * 查询MSDS主信息列表
     * 
     * @param msdsMain MSDS主信息
     * @return MSDS主信息集合
     */
    public List<MsdsMain> selectMsdsMainList(MsdsMain msdsMain);

    /**
     * 根据化学品名称查询MSDS信息
     * 
     * @param productName 化学品名称
     * @return MSDS主信息
     */
    public MsdsMain selectMsdsMainByProductName(String productName);

    /**
     * 新增MSDS主信息
     * 
     * @param msdsMain MSDS主信息
     * @return 结果
     */
    public int insertMsdsMain(MsdsMain msdsMain);

    /**
     * 修改MSDS主信息
     * 
     * @param msdsMain MSDS主信息
     * @return 结果
     */
    public int updateMsdsMain(MsdsMain msdsMain);

    /**
     * 根据ID数组查询MSDS主信息列表
     * 
     * @param ids MSDS主键集合
     * @return MSDS主信息集合
     */
    public List<MsdsMain> selectMsdsMainByIds(Long[] ids);

    /**
     * 批量删除MSDS主信息
     * 
     * @param ids 需要删除的MSDS主键集合
     * @return 结果
     */
    public int deleteMsdsMainByIds(Long[] ids);

    /**
     * 删除MSDS主信息
     * 
     * @param id MSDS主键
     * @return 结果
     */
    public int deleteMsdsMainById(Long id);

    /**
     * 根据企业名称查询MSDS列表
     * 
     * @param companyName 企业名称
     * @return MSDS主信息集合
     */
    public List<MsdsMain> selectMsdsMainByCompany(String companyName);

    /**
     * 统计有效的MSDS数量
     * 
     * @return 数量
     */
    public int countActiveMsds();

    /**
     * 校验化学品名称是否唯一
     * 
     * @param msdsMain MSDS信息
     * @return 结果
     */
    public boolean checkProductNameUnique(MsdsMain msdsMain);

    /**
     * 启用/停用MSDS
     * 
     * @param msdsMain MSDS信息
     * @return 结果
     */
    public int changeStatus(MsdsMain msdsMain);

    /**
     * 导入MSDS文档
     * 
     * @param file 上传的文件
     * @param overwriteDuplicates 是否覆盖重复数据
     * @param createBy 创建人
     * @return 导入结果
     */
    public Map<String, Object> importMsdsDocument(MultipartFile file, boolean overwriteDuplicates, String createBy) throws Exception;

    /**
     * 批量导入MSDS文档
     * 
     * @param files 上传的文件数组
     * @param overwriteDuplicates 是否覆盖重复数据
     * @param createBy 创建人
     * @return 导入结果
     */
    public Map<String, Object> importMsdsDocuments(MultipartFile[] files, boolean overwriteDuplicates, String createBy) throws Exception;

    /**
     * 下载MSDS导入模板
     * 
     * @param response 响应对象
     */
    public void downloadImportTemplate(HttpServletResponse response);

    /**
     * 下载MSDS导入模板
     * 
     * @param response 响应对象
     * @param templateType 模板类型（basic/detailed/full）
     */
    public void downloadImportTemplate(HttpServletResponse response, String templateType);

    /**
     * 下载MSDS导入模板
     * 
     * @param response 响应对象
     * @param templateType 模板类型（basic/detailed/full）
     * @param scope 范围：all（全部表）或 current（当前表）
     * @param tableName 当scope为current时，指定的表名
     */
    public void downloadImportTemplate(HttpServletResponse response, String templateType, String scope, String tableName);

    /**
     * 导入XML格式的MSDS文档
     * 
     * @param file XML文件
     * @param overwriteDuplicates 是否覆盖重复数据
     * @param createBy 创建人
     * @return 导入结果
     */
    public Map<String, Object> importMsdsXml(MultipartFile file, boolean overwriteDuplicates, String createBy) throws Exception;

    /**
     * 下载MSDS XML格式导入模板
     * 
     * @param response 响应对象
     */
    public void downloadXmlTemplate(HttpServletResponse response);

    /**
     * 导出MSDS为PDF格式
     * 
     * @param response 响应对象
     * @param id MSDS主信息ID
     */
    public void exportMsdsToPdf(HttpServletResponse response, Long id);

    /**
     * 批量导出MSDS为PDF格式
     * 
     * @param response 响应对象
     * @param ids MSDS主信息ID数组
     */
    public void batchExportMsdsToPdf(HttpServletResponse response, Long[] ids);

    /**
     * 获取MSDS统计信息
     * 
     * @return 统计信息
     */
    public Map<String, Object> getMsdsStatistics();

    /**
     * 获取化学品使用情况统计
     * 
     * @param days 统计天数
     * @return 使用情况统计
     */
    public Map<String, Object> getUsageStatistics(int days);

    /**
     * 获取风险等级分布统计
     * 
     * @return 风险等级分布
     */
    public Map<String, Object> getRiskDistribution();

    /**
     * 按文件路径导入MSDS文档
     * 
     * @param filePath 文件路径
     * @param overwriteDuplicates 是否覆盖重复数据
     * @param createBy 创建人
     * @return 导入结果
     */
    public Map<String, Object> importMsdsDocumentByPath(String filePath, boolean overwriteDuplicates, String createBy) throws Exception;
    /**
     * 预览MSDS文档（仅解析不入库）
     *
     * @param files 上传的文件数组（支持pdf/doc/docx）
     * @return 预览结果，包含 previewList
     */
    public Map<String, Object> previewMsdsDocuments(MultipartFile[] files) throws Exception;

    /**
     * 导入CSV格式的MSDS数据
     * 
     * @param file CSV文件
     * @param overwriteDuplicates 是否覆盖重复数据
     * @param createBy 创建人
     * @return 导入结果
     * @throws Exception 异常
     */
    public Map<String, Object> importMsdsCsv(MultipartFile file, boolean overwriteDuplicates, String createBy) throws Exception;
}