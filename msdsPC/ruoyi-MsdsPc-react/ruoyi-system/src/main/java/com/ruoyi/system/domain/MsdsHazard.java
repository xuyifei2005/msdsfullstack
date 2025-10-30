package com.ruoyi.system.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * MSDS危险性概述对象 msds_hazard
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public class MsdsHazard extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 关联MSDS主表ID */
    @Excel(name = "关联MSDS主表ID")
    private Long msdsId;

    /** 紧急情况概述 */
    @Excel(name = "紧急情况概述")
    private String emergencyOverview;

    /** 物理状态 */
    @Excel(name = "物理状态")
    private String physicalState;

    /** 气味 */
    @Excel(name = "气味")
    private String odor;

    /** 颜色 */
    @Excel(name = "颜色")
    private String color;

    /** 警示词(danger:危险,warning:警告) */
    @Excel(name = "警示词", readConverterExp = "d=anger:危险,warning:警告")
    private String warningWord;

    /** 危险性类别 */
    @Excel(name = "危险性类别")
    private String hazardCategory;

    /** 侵入途径 */
    @Excel(name = "侵入途径")
    private String exposureRoutes;

    /** 健康危害 */
    @Excel(name = "健康危害")
    private String healthHazards;

    /** 环境危害 */
    @Excel(name = "环境危害")
    private String environmentalHazards;

    /** 燃爆危险 */
    @Excel(name = "燃爆危险")
    private String fireExplosionHazards;

    /** 危险性说明 */
    @Excel(name = "危险性说明")
    private String hazardDescription;

    /** 预防措施 */
    @Excel(name = "预防措施")
    private String preventionMeasures;

    /** 响应措施 */
    @Excel(name = "响应措施")
    private String responseMeasures;

    /** 储存措施 */
    @Excel(name = "储存措施")
    private String storageMeasures;

    /** 废弃处置措施 */
    @Excel(name = "废弃处置措施")
    private String disposalMeasures;

    /** GHS分类 */
    @Excel(name = "GHS分类")
    private String ghsClassification;

    /** GHS标签 */
    @Excel(name = "GHS标签")
    private String ghsLabel;

    /** GHS象形图 */
    @Excel(name = "GHS象形图")
    private String ghsPictogram;

    /** 信号词 */
    @Excel(name = "信号词")
    private String signalWord;

    /** 危险性说明 */
    @Excel(name = "危险性说明")
    private String hazardStatement;

    /** 防范说明 */
    @Excel(name = "防范说明")
    private String precautionaryStatement;

    /** 物理危险 */
    @Excel(name = "物理危险")
    private String physicalHazard;

    /** 健康危险 */
    @Excel(name = "健康危险")
    private String healthHazard;

    /** 环境危险 */
    @Excel(name = "环境危险")
    private String environmentalHazard;

    /** 其他危险 */
    @Excel(name = "其他危险")
    private String otherHazard;

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

    public void setEmergencyOverview(String emergencyOverview) 
    {
        this.emergencyOverview = emergencyOverview;
    }

    public String getEmergencyOverview() 
    {
        return emergencyOverview;
    }

    public void setPhysicalState(String physicalState) 
    {
        this.physicalState = physicalState;
    }

    public String getPhysicalState() 
    {
        return physicalState;
    }

    public void setOdor(String odor) 
    {
        this.odor = odor;
    }

    public String getOdor() 
    {
        return odor;
    }

    public void setColor(String color) 
    {
        this.color = color;
    }

    public String getColor() 
    {
        return color;
    }

    public void setWarningWord(String warningWord) 
    {
        this.warningWord = warningWord;
    }

    public String getWarningWord() 
    {
        return warningWord;
    }

    public void setHazardCategory(String hazardCategory) 
    {
        this.hazardCategory = hazardCategory;
    }

    public String getHazardCategory() 
    {
        return hazardCategory;
    }

    public void setExposureRoutes(String exposureRoutes) 
    {
        this.exposureRoutes = exposureRoutes;
    }

    public String getExposureRoutes() 
    {
        return exposureRoutes;
    }

    public void setHealthHazards(String healthHazards) 
    {
        this.healthHazards = healthHazards;
    }

    public String getHealthHazards() 
    {
        return healthHazards;
    }

    public void setEnvironmentalHazards(String environmentalHazards) 
    {
        this.environmentalHazards = environmentalHazards;
    }

    public String getEnvironmentalHazards() 
    {
        return environmentalHazards;
    }

    public void setFireExplosionHazards(String fireExplosionHazards) 
    {
        this.fireExplosionHazards = fireExplosionHazards;
    }

    public String getFireExplosionHazards() 
    {
        return fireExplosionHazards;
    }

    public void setHazardDescription(String hazardDescription) 
    {
        this.hazardDescription = hazardDescription;
    }

    public String getHazardDescription() 
    {
        return hazardDescription;
    }

    public void setPreventionMeasures(String preventionMeasures) 
    {
        this.preventionMeasures = preventionMeasures;
    }

    public String getPreventionMeasures() 
    {
        return preventionMeasures;
    }

    public void setResponseMeasures(String responseMeasures) 
    {
        this.responseMeasures = responseMeasures;
    }

    public String getResponseMeasures() 
    {
        return responseMeasures;
    }

    public void setStorageMeasures(String storageMeasures) 
    {
        this.storageMeasures = storageMeasures;
    }

    public String getStorageMeasures() 
    {
        return storageMeasures;
    }

    public void setDisposalMeasures(String disposalMeasures) 
    {
        this.disposalMeasures = disposalMeasures;
    }

    public String getDisposalMeasures() 
    {
        return disposalMeasures;
    }

    public void setGhsClassification(String ghsClassification) 
    {
        this.ghsClassification = ghsClassification;
    }

    public String getGhsClassification() 
    {
        return ghsClassification;
    }

    public void setGhsLabel(String ghsLabel) 
    {
        this.ghsLabel = ghsLabel;
    }

    public String getGhsLabel() 
    {
        return ghsLabel;
    }

    public void setGhsPictogram(String ghsPictogram) 
    {
        this.ghsPictogram = ghsPictogram;
    }

    public String getGhsPictogram() 
    {
        return ghsPictogram;
    }

    public void setSignalWord(String signalWord) 
    {
        this.signalWord = signalWord;
    }

    public String getSignalWord() 
    {
        return signalWord;
    }

    public void setHazardStatement(String hazardStatement) 
    {
        this.hazardStatement = hazardStatement;
    }

    public String getHazardStatement() 
    {
        return hazardStatement;
    }

    public void setPrecautionaryStatement(String precautionaryStatement) 
    {
        this.precautionaryStatement = precautionaryStatement;
    }

    public String getPrecautionaryStatement() 
    {
        return precautionaryStatement;
    }

    public void setPhysicalHazard(String physicalHazard) 
    {
        this.physicalHazard = physicalHazard;
    }

    public String getPhysicalHazard() 
    {
        return physicalHazard;
    }

    public void setHealthHazard(String healthHazard) 
    {
        this.healthHazard = healthHazard;
    }

    public String getHealthHazard() 
    {
        return healthHazard;
    }

    public void setEnvironmentalHazard(String environmentalHazard) 
    {
        this.environmentalHazard = environmentalHazard;
    }

    public String getEnvironmentalHazard() 
    {
        return environmentalHazard;
    }

    public void setOtherHazard(String otherHazard) 
    {
        this.otherHazard = otherHazard;
    }

    public String getOtherHazard() 
    {
        return otherHazard;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("msdsId", getMsdsId())
            .append("emergencyOverview", getEmergencyOverview())
            .append("physicalState", getPhysicalState())
            .append("odor", getOdor())
            .append("color", getColor())
            .append("warningWord", getWarningWord())
            .append("hazardCategory", getHazardCategory())
            .append("exposureRoutes", getExposureRoutes())
            .append("healthHazards", getHealthHazards())
            .append("environmentalHazards", getEnvironmentalHazards())
            .append("fireExplosionHazards", getFireExplosionHazards())
            .append("hazardDescription", getHazardDescription())
            .append("preventionMeasures", getPreventionMeasures())
            .append("responseMeasures", getResponseMeasures())
            .append("storageMeasures", getStorageMeasures())
            .append("disposalMeasures", getDisposalMeasures())
            .append("ghsClassification", getGhsClassification())
            .append("ghsLabel", getGhsLabel())
            .append("ghsPictogram", getGhsPictogram())
            .append("signalWord", getSignalWord())
            .append("hazardStatement", getHazardStatement())
            .append("precautionaryStatement", getPrecautionaryStatement())
            .append("physicalHazard", getPhysicalHazard())
            .append("healthHazard", getHealthHazard())
            .append("environmentalHazard", getEnvironmentalHazard())
            .append("otherHazard", getOtherHazard())
            .toString();
    }
}