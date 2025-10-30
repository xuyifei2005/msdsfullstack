package com.ruoyi.system.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

/**
 * MSDS理化特性表对象 msds_physical_chemical
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public class MsdsPhysicalChemical extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 关联MSDS主表ID */
    @Excel(name = "关联MSDS主表ID")
    @NotNull(message = "关联MSDS主表ID不能为空")
    private Long msdsId;

    /** 外观与性状 */
    @Excel(name = "外观与性状")
    private String appearance;

    /** 气味 */
    @Excel(name = "气味")
    private String odor;

    /** 气味阈值 */
    @Excel(name = "气味阈值")
    private String odorThreshold;

    /** 熔点(℃) */
    @Excel(name = "熔点(℃)")
    private String meltingPoint;

    /** 沸点(℃) */
    @Excel(name = "沸点(℃)")
    private String boilingPoint;

    /** 相对密度(水=1) */
    @Excel(name = "相对密度(水=1)")
    private String relativeDensity;

    /** 蒸气密度(空气=1) */
    @Excel(name = "蒸气密度(空气=1)")
    private String vaporDensity;

    /** 蒸气压(kPa) */
    @Excel(name = "蒸气压(kPa)")
    private String vaporPressure;

    /** 蒸气压测定温度(℃) */
    @Excel(name = "蒸气压测定温度(℃)")
    private String vaporPressureTemp;

    /** 溶解性 */
    @Excel(name = "溶解性")
    private String solubility;

    /** 水中溶解度 */
    @Excel(name = "水中溶解度")
    private String waterSolubility;

    /** pH值 */
    @Excel(name = "pH值")
    private String phValue;

    /** pH值浓度条件 */
    @Excel(name = "pH值浓度条件")
    private String phConcentration;

    /** 闪点(℃) */
    @Excel(name = "闪点(℃)")
    private String flashPoint;

    /** 引燃温度(℃) */
    @Excel(name = "引燃温度(℃)")
    private String ignitionTemperature;

    /** 爆炸下限(%) */
    @Excel(name = "爆炸下限(%)")
    private String explosiveLimitLower;

    /** 爆炸上限(%) */
    @Excel(name = "爆炸上限(%)")
    private String explosiveLimitUpper;

    /** 粘度 */
    @Excel(name = "粘度")
    private String viscosity;

    /** 分配系数(正辛醇/水) */
    @Excel(name = "分配系数(正辛醇/水)")
    private String partitionCoefficient;

    /** 分解温度(℃) */
    @Excel(name = "分解温度(℃)")
    private String decompositionTemperature;

    /** 分子式 */
    @Excel(name = "分子式")
    private String molecularFormula;

    /** 主要成分 */
    @Excel(name = "主要成分")
    private String mainComponents;

    /** 临界温度(℃) */
    @Excel(name = "临界温度(℃)")
    private String criticalTemperature;

    /** 自燃温度 */
    @Excel(name = "自燃温度")
    private String autoignitionTemperature;

    /** 燃烧性 */
    @Excel(name = "燃烧性")
    private String flammability;

    /** 分子量 */
    @Excel(name = "分子量")
    private String molecularWeight;

    /** 燃烧热(kJ/mol) */
    @Excel(name = "燃烧热(kJ/mol)")
    private String heatOfCombustion;

    /** 临界压力(MPa) */
    @Excel(name = "临界压力(MPa)")
    private String criticalPressure;

    /** 主要用途 */
    @Excel(name = "主要用途")
    private String mainUsage;

    /** 其它理化性质 */
    @Excel(name = "其它理化性质")
    private String otherProperties;

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

    public void setAppearance(String appearance)
    {
        this.appearance = appearance;
    }

    public String getAppearance()
    {
        return appearance;
    }

    public void setOdor(String odor)
    {
        this.odor = odor;
    }

    public String getOdor()
    {
        return odor;
    }

    public void setOdorThreshold(String odorThreshold)
    {
        this.odorThreshold = odorThreshold;
    }

    public String getOdorThreshold()
    {
        return odorThreshold;
    }

    public void setMeltingPoint(String meltingPoint)
    {
        this.meltingPoint = meltingPoint;
    }

    public String getMeltingPoint()
    {
        return meltingPoint;
    }

    public void setBoilingPoint(String boilingPoint)
    {
        this.boilingPoint = boilingPoint;
    }

    public String getBoilingPoint()
    {
        return boilingPoint;
    }

    public void setRelativeDensity(String relativeDensity)
    {
        this.relativeDensity = relativeDensity;
    }

    public String getRelativeDensity()
    {
        return relativeDensity;
    }

    public void setVaporDensity(String vaporDensity)
    {
        this.vaporDensity = vaporDensity;
    }

    public String getVaporDensity()
    {
        return vaporDensity;
    }

    public void setVaporPressure(String vaporPressure)
    {
        this.vaporPressure = vaporPressure;
    }

    public String getVaporPressure()
    {
        return vaporPressure;
    }

    public void setVaporPressureTemp(String vaporPressureTemp)
    {
        this.vaporPressureTemp = vaporPressureTemp;
    }

    public String getVaporPressureTemp()
    {
        return vaporPressureTemp;
    }

    public void setSolubility(String solubility)
    {
        this.solubility = solubility;
    }

    public String getSolubility()
    {
        return solubility;
    }

    public void setWaterSolubility(String waterSolubility)
    {
        this.waterSolubility = waterSolubility;
    }

    public String getWaterSolubility()
    {
        return waterSolubility;
    }

    public void setPhValue(String phValue)
    {
        this.phValue = phValue;
    }

    public String getPhValue()
    {
        return phValue;
    }

    public void setPhConcentration(String phConcentration)
    {
        this.phConcentration = phConcentration;
    }

    public String getPhConcentration()
    {
        return phConcentration;
    }

    public void setFlashPoint(String flashPoint)
    {
        this.flashPoint = flashPoint;
    }

    public String getFlashPoint()
    {
        return flashPoint;
    }

    public void setIgnitionTemperature(String ignitionTemperature)
    {
        this.ignitionTemperature = ignitionTemperature;
    }

    public String getIgnitionTemperature()
    {
        return ignitionTemperature;
    }

    public void setExplosiveLimitLower(String explosiveLimitLower)
    {
        this.explosiveLimitLower = explosiveLimitLower;
    }

    public String getExplosiveLimitLower()
    {
        return explosiveLimitLower;
    }

    public void setExplosiveLimitUpper(String explosiveLimitUpper)
    {
        this.explosiveLimitUpper = explosiveLimitUpper;
    }

    public String getExplosiveLimitUpper()
    {
        return explosiveLimitUpper;
    }

    public void setViscosity(String viscosity)
    {
        this.viscosity = viscosity;
    }

    public String getViscosity()
    {
        return viscosity;
    }

    public void setPartitionCoefficient(String partitionCoefficient)
    {
        this.partitionCoefficient = partitionCoefficient;
    }

    public String getPartitionCoefficient()
    {
        return partitionCoefficient;
    }

    public void setDecompositionTemperature(String decompositionTemperature)
    {
        this.decompositionTemperature = decompositionTemperature;
    }

    public String getDecompositionTemperature()
    {
        return decompositionTemperature;
    }

    public void setMolecularFormula(String molecularFormula)
    {
        this.molecularFormula = molecularFormula;
    }

    public String getMolecularFormula()
    {
        return molecularFormula;
    }

    public void setMainComponents(String mainComponents)
    {
        this.mainComponents = mainComponents;
    }

    public String getMainComponents()
    {
        return mainComponents;
    }

    public void setCriticalTemperature(String criticalTemperature)
    {
        this.criticalTemperature = criticalTemperature;
    }

    public String getCriticalTemperature()
    {
        return criticalTemperature;
    }

    public void setAutoignitionTemperature(String autoignitionTemperature)
    {
        this.autoignitionTemperature = autoignitionTemperature;
    }

    public String getAutoignitionTemperature()
    {
        return autoignitionTemperature;
    }

    public void setFlammability(String flammability)
    {
        this.flammability = flammability;
    }

    public String getFlammability()
    {
        return flammability;
    }

    public void setMolecularWeight(String molecularWeight)
    {
        this.molecularWeight = molecularWeight;
    }

    public String getMolecularWeight()
    {
        return molecularWeight;
    }

    public void setHeatOfCombustion(String heatOfCombustion)
    {
        this.heatOfCombustion = heatOfCombustion;
    }

    public String getHeatOfCombustion()
    {
        return heatOfCombustion;
    }

    public void setCriticalPressure(String criticalPressure)
    {
        this.criticalPressure = criticalPressure;
    }

    public String getCriticalPressure()
    {
        return criticalPressure;
    }

    public void setMainUsage(String mainUsage)
    {
        this.mainUsage = mainUsage;
    }

    public String getMainUsage()
    {
        return mainUsage;
    }

    public void setOtherProperties(String otherProperties)
    {
        this.otherProperties = otherProperties;
    }

    public String getOtherProperties()
    {
        return otherProperties;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("msdsId", getMsdsId())
            .append("appearance", getAppearance())
            .append("odor", getOdor())
            .append("odorThreshold", getOdorThreshold())
            .append("meltingPoint", getMeltingPoint())
            .append("boilingPoint", getBoilingPoint())
            .append("relativeDensity", getRelativeDensity())
            .append("vaporDensity", getVaporDensity())
            .append("vaporPressure", getVaporPressure())
            .append("vaporPressureTemp", getVaporPressureTemp())
            .append("solubility", getSolubility())
            .append("waterSolubility", getWaterSolubility())
            .append("phValue", getPhValue())
            .append("phConcentration", getPhConcentration())
            .append("flashPoint", getFlashPoint())
            .append("ignitionTemperature", getIgnitionTemperature())
            .append("explosiveLimitLower", getExplosiveLimitLower())
            .append("explosiveLimitUpper", getExplosiveLimitUpper())
            .append("viscosity", getViscosity())
            .append("partitionCoefficient", getPartitionCoefficient())
            .append("decompositionTemperature", getDecompositionTemperature())
            .append("molecularFormula", getMolecularFormula())
            .append("mainComponents", getMainComponents())
            .append("criticalTemperature", getCriticalTemperature())
            .append("autoignitionTemperature", getAutoignitionTemperature())
            .append("flammability", getFlammability())
            .append("molecularWeight", getMolecularWeight())
            .append("heatOfCombustion", getHeatOfCombustion())
            .append("criticalPressure", getCriticalPressure())
            .append("mainUsage", getMainUsage())
            .append("otherProperties", getOtherProperties())
            .append("createTime", getCreateTime())
            .append("updateTime", getUpdateTime())
            .toString();
    }
} 