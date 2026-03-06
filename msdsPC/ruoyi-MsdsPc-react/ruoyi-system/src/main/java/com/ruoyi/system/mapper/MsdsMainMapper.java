package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.MsdsMain;

/**
 * MSDS主信息 数据层
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public interface MsdsMainMapper
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
     * 根据CAS号查询MSDS信息
     * 
     * @param casNumber CAS号
     * @return MSDS主信息
     */
    public MsdsMain selectMsdsMainByCasNumber(String casNumber);

    /**
     * 根据MSDS编号查询MSDS信息
     *
     * @param msdsCode MSDS编号
     * @return MSDS主信息
     */
    public MsdsMain selectMsdsMainByMsdsCode(String msdsCode);

    /**
     * 检查化学品名称是否唯一
     * 
     * @param productName 化学品名称
     * @return MSDS主信息
     */
    public MsdsMain checkProductNameUnique(String productName);

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
     * 删除MSDS主信息
     * 
     * @param id MSDS主键
     * @return 结果
     */
    public int deleteMsdsMainById(Long id);

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
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteMsdsMainByIds(Long[] ids);

    /**
     * 删除全部MSDS主信息
     *
     * @return 结果
     */
    public int deleteAllMsdsMain();

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
}
