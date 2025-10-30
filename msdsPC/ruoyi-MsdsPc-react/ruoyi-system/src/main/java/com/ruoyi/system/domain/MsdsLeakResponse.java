package com.ruoyi.system.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

/**
 * 泄漏应急处理对象 msds_leak_response
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public class MsdsLeakResponse extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 关联MSDS主表ID */
    @Excel(name = "关联MSDS主表ID")
    @NotNull(message = "关联MSDS主表ID不能为空")
    private Long msdsId;

    /** 个人防护措施 */
    @Excel(name = "个人防护措施")
    private String personalPrecautions;

    /** 环境保护措施 */
    @Excel(name = "环境保护措施")
    private String environmentalPrecautions;

    /** 泄漏化学品的收容、清除方法 */
    @Excel(name = "泄漏化学品的收容、清除方法")
    private String containmentCleanup;

    /** 应急处理程序 */
    @Excel(name = "应急处理程序")
    private String emergencyProcedures;

    /** 消除方法 */
    @Excel(name = "消除方法")
    private String eliminationMethods;

    /** 清理时使用的器材 */
    @Excel(name = "清理时使用的器材")
    private String equipmentMaterials;

    /** 防止发生次生危害的预防措施 */
    @Excel(name = "防止发生次生危害的预防措施")
    private String preventSecondaryHazards;

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

    public void setPersonalPrecautions(String personalPrecautions) 
    {
        this.personalPrecautions = personalPrecautions;
    }

    public String getPersonalPrecautions() 
    {
        return personalPrecautions;
    }

    public void setEnvironmentalPrecautions(String environmentalPrecautions) 
    {
        this.environmentalPrecautions = environmentalPrecautions;
    }

    public String getEnvironmentalPrecautions() 
    {
        return environmentalPrecautions;
    }

    public void setContainmentCleanup(String containmentCleanup) 
    {
        this.containmentCleanup = containmentCleanup;
    }

    public String getContainmentCleanup() 
    {
        return containmentCleanup;
    }

    public void setEmergencyProcedures(String emergencyProcedures) 
    {
        this.emergencyProcedures = emergencyProcedures;
    }

    public String getEmergencyProcedures() 
    {
        return emergencyProcedures;
    }

    public void setEliminationMethods(String eliminationMethods) 
    {
        this.eliminationMethods = eliminationMethods;
    }

    public String getEliminationMethods() 
    {
        return eliminationMethods;
    }

    public void setEquipmentMaterials(String equipmentMaterials) 
    {
        this.equipmentMaterials = equipmentMaterials;
    }

    public String getEquipmentMaterials() 
    {
        return equipmentMaterials;
    }

    public void setPreventSecondaryHazards(String preventSecondaryHazards) 
    {
        this.preventSecondaryHazards = preventSecondaryHazards;
    }

    public String getPreventSecondaryHazards() 
    {
        return preventSecondaryHazards;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("msdsId", getMsdsId())
            .append("personalPrecautions", getPersonalPrecautions())
            .append("environmentalPrecautions", getEnvironmentalPrecautions())
            .append("containmentCleanup", getContainmentCleanup())
            .append("emergencyProcedures", getEmergencyProcedures())
            .append("eliminationMethods", getEliminationMethods())
            .append("equipmentMaterials", getEquipmentMaterials())
            .append("preventSecondaryHazards", getPreventSecondaryHazards())
            .append("createTime", getCreateTime())
            .append("updateTime", getUpdateTime())
            .append("createBy", getCreateBy())
            .append("updateBy", getUpdateBy())
            .toString();
    }
} 