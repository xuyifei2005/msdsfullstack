package com.ruoyi.system.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

/**
 * 法规信息对象 msds_regulatory
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public class MsdsRegulatory extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 关联MSDS主表ID */
    @Excel(name = "关联MSDS主表ID")
    @NotNull(message = "关联MSDS主表ID不能为空")
    private Long msdsId;

    /** 法规信息综述 */
    @Excel(name = "法规信息综述")
    private String regulatoryInfo;

    /** 国内法规 */
    @Excel(name = "国内法规")
    private String domesticRegulations;

    /** 国际法规 */
    @Excel(name = "国际法规")
    private String internationalRegulations;

    /** 中国危险化学品目录(1:是,0:否) */
    @Excel(name = "中国危险化学品目录", readConverterExp = "1=是,0=否")
    private Integer chinaDangerousChemicals;

    /** 中国管制化学品(1:是,0:否) */
    @Excel(name = "中国管制化学品", readConverterExp = "1=是,0=否")
    private Integer chinaControlledChemicals;

    /** REACH注册情况 */
    @Excel(name = "REACH注册情况")
    private String reachRegistration;

    /** TSCA清单(1:在列,0:不在列) */
    @Excel(name = "TSCA清单", readConverterExp = "1=在列,0=不在列")
    private Integer tscaInventory;

    /** EINECS号 */
    @Excel(name = "EINECS号")
    private String einecsNumber;

    /** 禁用/限用情况 */
    @Excel(name = "禁用/限用情况")
    private String prohibitedRestricted;

    /** 特殊规定 */
    @Excel(name = "特殊规定")
    private String specialProvisions;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }

    public void setMsdsId(Long msdsId) 
    {
        this.msdsId = msdsId;
    }

    public Long getMsdsId() 
    {
        return msdsId;
    }

    public void setRegulatoryInfo(String regulatoryInfo) 
    {
        this.regulatoryInfo = regulatoryInfo;
    }

    public String getRegulatoryInfo() 
    {
        return regulatoryInfo;
    }

    public void setDomesticRegulations(String domesticRegulations) 
    {
        this.domesticRegulations = domesticRegulations;
    }

    public String getDomesticRegulations() 
    {
        return domesticRegulations;
    }

    public void setInternationalRegulations(String internationalRegulations) 
    {
        this.internationalRegulations = internationalRegulations;
    }

    public String getInternationalRegulations() 
    {
        return internationalRegulations;
    }

    public void setChinaDangerousChemicals(Integer chinaDangerousChemicals) 
    {
        this.chinaDangerousChemicals = chinaDangerousChemicals;
    }

    public Integer getChinaDangerousChemicals() 
    {
        return chinaDangerousChemicals;
    }

    public void setChinaControlledChemicals(Integer chinaControlledChemicals) 
    {
        this.chinaControlledChemicals = chinaControlledChemicals;
    }

    public Integer getChinaControlledChemicals() 
    {
        return chinaControlledChemicals;
    }

    public void setReachRegistration(String reachRegistration) 
    {
        this.reachRegistration = reachRegistration;
    }

    public String getReachRegistration() 
    {
        return reachRegistration;
    }

    public void setTscaInventory(Integer tscaInventory) 
    {
        this.tscaInventory = tscaInventory;
    }

    public Integer getTscaInventory() 
    {
        return tscaInventory;
    }

    public void setEinecsNumber(String einecsNumber) 
    {
        this.einecsNumber = einecsNumber;
    }

    public String getEinecsNumber() 
    {
        return einecsNumber;
    }

    public void setProhibitedRestricted(String prohibitedRestricted) 
    {
        this.prohibitedRestricted = prohibitedRestricted;
    }

    public String getProhibitedRestricted() 
    {
        return prohibitedRestricted;
    }

    public void setSpecialProvisions(String specialProvisions) 
    {
        this.specialProvisions = specialProvisions;
    }

    public String getSpecialProvisions() 
    {
        return specialProvisions;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("msdsId", getMsdsId())
            .append("regulatoryInfo", getRegulatoryInfo())
            .append("domesticRegulations", getDomesticRegulations())
            .append("internationalRegulations", getInternationalRegulations())
            .append("chinaDangerousChemicals", getChinaDangerousChemicals())
            .append("chinaControlledChemicals", getChinaControlledChemicals())
            .append("reachRegistration", getReachRegistration())
            .append("tscaInventory", getTscaInventory())
            .append("einecsNumber", getEinecsNumber())
            .append("prohibitedRestricted", getProhibitedRestricted())
            .append("specialProvisions", getSpecialProvisions())
            .append("createTime", getCreateTime())
            .append("updateTime", getUpdateTime())
            .append("createBy", getCreateBy())
            .append("updateBy", getUpdateBy())
            .toString();
    }
} 