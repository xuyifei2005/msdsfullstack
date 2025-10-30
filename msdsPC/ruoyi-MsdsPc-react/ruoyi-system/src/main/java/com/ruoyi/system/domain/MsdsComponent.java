package com.ruoyi.system.domain;

import java.math.BigDecimal;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * MSDS成分/组成信息对象 msds_component
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public class MsdsComponent extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 关联MSDS主表ID */
    @Excel(name = "关联MSDS主表ID")
    private Long msdsId;

    /** 成分名称 */
    @Excel(name = "成分名称")
    private String componentName;

    /** 成分英文名 */
    @Excel(name = "成分英文名")
    private String componentEnglishName;

    /** 成分含量/浓度 */
    @Excel(name = "成分含量/浓度")
    private String componentContent;

    /** 含量下限(%) */
    @Excel(name = "含量下限", scale = 4)
    private BigDecimal contentMin;

    /** 含量上限(%) */
    @Excel(name = "含量上限", scale = 4)
    private BigDecimal contentMax;

    /** CAS登记号 */
    @Excel(name = "CAS登记号")
    private String casNumber;

    /** EC号 */
    @Excel(name = "EC号")
    private String ecNumber;

    /** 分子式 */
    @Excel(name = "分子式")
    private String molecularFormula;

    /** 分子量 */
    @Excel(name = "分子量", scale = 2)
    private BigDecimal molecularWeight;

    /** 是否为危险成分(1:是,0:否) */
    @Excel(name = "是否为危险成分", readConverterExp = "1=是,0=否")
    private Integer isHazardous;

    /** 危险等级 */
    @Excel(name = "危险等级")
    private String hazardLevel;

    /** 成分功能 */
    @Excel(name = "成分功能")
    private String componentFunction;

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

    public void setComponentName(String componentName) 
    {
        this.componentName = componentName;
    }

    public String getComponentName() 
    {
        return componentName;
    }

    public void setComponentEnglishName(String componentEnglishName) 
    {
        this.componentEnglishName = componentEnglishName;
    }

    public String getComponentEnglishName() 
    {
        return componentEnglishName;
    }

    public void setComponentContent(String componentContent) 
    {
        this.componentContent = componentContent;
    }

    public String getComponentContent() 
    {
        return componentContent;
    }

    public void setContentMin(BigDecimal contentMin) 
    {
        this.contentMin = contentMin;
    }

    public BigDecimal getContentMin() 
    {
        return contentMin;
    }

    public void setContentMax(BigDecimal contentMax) 
    {
        this.contentMax = contentMax;
    }

    public BigDecimal getContentMax() 
    {
        return contentMax;
    }

    public void setCasNumber(String casNumber) 
    {
        this.casNumber = casNumber;
    }

    public String getCasNumber() 
    {
        return casNumber;
    }

    public void setEcNumber(String ecNumber) 
    {
        this.ecNumber = ecNumber;
    }

    public String getEcNumber() 
    {
        return ecNumber;
    }

    public void setMolecularFormula(String molecularFormula) 
    {
        this.molecularFormula = molecularFormula;
    }

    public String getMolecularFormula() 
    {
        return molecularFormula;
    }

    public void setMolecularWeight(BigDecimal molecularWeight) 
    {
        this.molecularWeight = molecularWeight;
    }

    public BigDecimal getMolecularWeight() 
    {
        return molecularWeight;
    }

    public void setIsHazardous(Integer isHazardous) 
    {
        this.isHazardous = isHazardous;
    }

    public Integer getIsHazardous() 
    {
        return isHazardous;
    }

    public void setHazardLevel(String hazardLevel) 
    {
        this.hazardLevel = hazardLevel;
    }

    public String getHazardLevel() 
    {
        return hazardLevel;
    }

    public void setComponentFunction(String componentFunction) 
    {
        this.componentFunction = componentFunction;
    }

    public String getComponentFunction() 
    {
        return componentFunction;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("msdsId", getMsdsId())
            .append("componentName", getComponentName())
            .append("componentEnglishName", getComponentEnglishName())
            .append("componentContent", getComponentContent())
            .append("contentMin", getContentMin())
            .append("contentMax", getContentMax())
            .append("casNumber", getCasNumber())
            .append("ecNumber", getEcNumber())
            .append("molecularFormula", getMolecularFormula())
            .append("molecularWeight", getMolecularWeight())
            .append("isHazardous", getIsHazardous())
            .append("hazardLevel", getHazardLevel())
            .append("componentFunction", getComponentFunction())
            .toString();
    }
} 