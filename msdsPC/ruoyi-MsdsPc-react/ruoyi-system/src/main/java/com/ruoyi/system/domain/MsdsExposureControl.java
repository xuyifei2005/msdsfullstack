package com.ruoyi.system.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import jakarta.validation.constraints.NotNull;

/**
 * 接触控制/个体防护对象 msds_exposure_control
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public class MsdsExposureControl extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 关联MSDS主表ID */
    @Excel(name = "关联MSDS主表ID")
    @NotNull(message = "关联MSDS主表ID不能为空")
    private Long msdsId;

    /** 职业接触限值 */
    @Excel(name = "职业接触限值")
    private String occupationalExposureLimit;

    /** 中国MAC值(mg/m³) */
    @Excel(name = "中国MAC值(mg/m³)")
    private String chinaMac;

    /** 美国TLV-TWA值(mg/m³) */
    @Excel(name = "美国TLV-TWA值(mg/m³)")
    private String usaTlvTwa;

    /** 美国TLV-STEL值(mg/m³) */
    @Excel(name = "美国TLV-STEL值(mg/m³)")
    private String usaTlvStel;

    /** 前苏联MAC值(mg/m³) */
    @Excel(name = "前苏联MAC值(mg/m³)")
    private String formerSovietMac;

    /** TLV-TN值(mg/m³) */
    @Excel(name = "TLV-TN值(mg/m³)")
    private String tlvTn;

    /** TLV-WN值(mg/m³) */
    @Excel(name = "TLV-WN值(mg/m³)")
    private String tlvWn;

    /** 监测方法 */
    @Excel(name = "监测方法")
    private String monitoringMethod;

    /** 工程控制措施 */
    @Excel(name = "工程控制措施")
    private String engineeringControls;

    /** 呼吸系统防护 */
    @Excel(name = "呼吸系统防护")
    private String respiratoryProtection;

    /** 眼睛防护 */
    @Excel(name = "眼睛防护")
    private String eyeProtection;

    /** 身体防护 */
    @Excel(name = "身体防护")
    private String bodyProtection;

    /** 手部防护 */
    @Excel(name = "手部防护")
    private String handProtection;

    /** 其他防护措施 */
    @Excel(name = "其他防护措施")
    private String otherProtection;

    /** 卫生措施 */
    @Excel(name = "卫生措施")
    private String hygieneMeasures;

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

    public void setOccupationalExposureLimit(String occupationalExposureLimit) 
    {
        this.occupationalExposureLimit = occupationalExposureLimit;
    }

    public String getOccupationalExposureLimit() 
    {
        return occupationalExposureLimit;
    }

    public void setChinaMac(String chinaMac) 
    {
        this.chinaMac = chinaMac;
    }

    public String getChinaMac() 
    {
        return chinaMac;
    }

    public void setUsaTlvTwa(String usaTlvTwa) 
    {
        this.usaTlvTwa = usaTlvTwa;
    }

    public String getUsaTlvTwa() 
    {
        return usaTlvTwa;
    }

    public void setUsaTlvStel(String usaTlvStel) 
    {
        this.usaTlvStel = usaTlvStel;
    }

    public String getUsaTlvStel() 
    {
        return usaTlvStel;
    }

    public void setFormerSovietMac(String formerSovietMac) 
    {
        this.formerSovietMac = formerSovietMac;
    }

    public String getFormerSovietMac() 
    {
        return formerSovietMac;
    }

    public void setTlvTn(String tlvTn) 
    {
        this.tlvTn = tlvTn;
    }

    public String getTlvTn() 
    {
        return tlvTn;
    }

    public void setTlvWn(String tlvWn) 
    {
        this.tlvWn = tlvWn;
    }

    public String getTlvWn() 
    {
        return tlvWn;
    }

    public void setMonitoringMethod(String monitoringMethod) 
    {
        this.monitoringMethod = monitoringMethod;
    }

    public String getMonitoringMethod() 
    {
        return monitoringMethod;
    }

    public void setEngineeringControls(String engineeringControls) 
    {
        this.engineeringControls = engineeringControls;
    }

    public String getEngineeringControls() 
    {
        return engineeringControls;
    }

    public void setRespiratoryProtection(String respiratoryProtection) 
    {
        this.respiratoryProtection = respiratoryProtection;
    }

    public String getRespiratoryProtection() 
    {
        return respiratoryProtection;
    }

    public void setEyeProtection(String eyeProtection) 
    {
        this.eyeProtection = eyeProtection;
    }

    public String getEyeProtection() 
    {
        return eyeProtection;
    }

    public void setBodyProtection(String bodyProtection) 
    {
        this.bodyProtection = bodyProtection;
    }

    public String getBodyProtection() 
    {
        return bodyProtection;
    }

    public void setHandProtection(String handProtection) 
    {
        this.handProtection = handProtection;
    }

    public String getHandProtection() 
    {
        return handProtection;
    }

    public void setOtherProtection(String otherProtection) 
    {
        this.otherProtection = otherProtection;
    }

    public String getOtherProtection() 
    {
        return otherProtection;
    }

    public void setHygieneMeasures(String hygieneMeasures) 
    {
        this.hygieneMeasures = hygieneMeasures;
    }

    public String getHygieneMeasures() 
    {
        return hygieneMeasures;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("msdsId", getMsdsId())
            .append("occupationalExposureLimit", getOccupationalExposureLimit())
            .append("chinaMac", getChinaMac())
            .append("usaTlvTwa", getUsaTlvTwa())
            .append("usaTlvStel", getUsaTlvStel())
            .append("formerSovietMac", getFormerSovietMac())
            .append("tlvTn", getTlvTn())
            .append("tlvWn", getTlvWn())
            .append("monitoringMethod", getMonitoringMethod())
            .append("engineeringControls", getEngineeringControls())
            .append("respiratoryProtection", getRespiratoryProtection())
            .append("eyeProtection", getEyeProtection())
            .append("bodyProtection", getBodyProtection())
            .append("handProtection", getHandProtection())
            .append("otherProtection", getOtherProtection())
            .append("hygieneMeasures", getHygieneMeasures())
            .append("createTime", getCreateTime())
            .append("updateTime", getUpdateTime())
            .append("createBy", getCreateBy())
            .append("updateBy", getUpdateBy())
            .toString();
    }
} 