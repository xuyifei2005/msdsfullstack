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
     * @param response HTTP响应对象
     */
    public void downloadImportTemplate(HttpServletResponse response);
} 