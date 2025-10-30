package com.ruoyi.system.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import jakarta.validation.constraints.NotNull;

/**
 * 稳定性和反应性对象 msds_stability_reactivity
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public class MsdsStabilityReactivity extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 关联MSDS主表ID */
    @Excel(name = "关联MSDS主表ID")
    @NotNull(message = "关联MSDS主表ID不能为空")
    private Long msdsId;

    /** 稳定性 */
    @Excel(name = "稳定性")
    private String stability;

    /** 反应性 */
    @Excel(name = "反应性")
    private String reactivity;

    /** 禁配物 */
    @Excel(name = "禁配物")
    private String incompatibleSubstances;

    /** 避免接触的条件 */
    @Excel(name = "避免接触的条件")
    private String conditionsToAvoid;

    /** 可能的危险反应 */
    @Excel(name = "可能的危险反应")
    private String hazardousReactions;

    /** 聚合危害 */
    @Excel(name = "聚合危害")
    private String polymerizationHazard;

    /** 聚合反应条件 */
    @Excel(name = "聚合反应条件")
    private String polymerizationConditions;

    /** 分解产物 */
    @Excel(name = "分解产物")
    private String decompositionProducts;

    /** 分解条件 */
    @Excel(name = "分解条件")
    private String decompositionConditions;

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

    public void setStability(String stability) 
    {
        this.stability = stability;
    }

    public String getStability() 
    {
        return stability;
    }

    public void setReactivity(String reactivity) 
    {
        this.reactivity = reactivity;
    }

    public String getReactivity() 
    {
        return reactivity;
    }

    public void setIncompatibleSubstances(String incompatibleSubstances) 
    {
        this.incompatibleSubstances = incompatibleSubstances;
    }

    public String getIncompatibleSubstances() 
    {
        return incompatibleSubstances;
    }

    public void setConditionsToAvoid(String conditionsToAvoid) 
    {
        this.conditionsToAvoid = conditionsToAvoid;
    }

    public String getConditionsToAvoid() 
    {
        return conditionsToAvoid;
    }

    public void setHazardousReactions(String hazardousReactions) 
    {
        this.hazardousReactions = hazardousReactions;
    }

    public String getHazardousReactions() 
    {
        return hazardousReactions;
    }

    public void setPolymerizationHazard(String polymerizationHazard) 
    {
        this.polymerizationHazard = polymerizationHazard;
    }

    public String getPolymerizationHazard() 
    {
        return polymerizationHazard;
    }

    public void setPolymerizationConditions(String polymerizationConditions) 
    {
        this.polymerizationConditions = polymerizationConditions;
    }

    public String getPolymerizationConditions() 
    {
        return polymerizationConditions;
    }

    public void setDecompositionProducts(String decompositionProducts) 
    {
        this.decompositionProducts = decompositionProducts;
    }

    public String getDecompositionProducts() 
    {
        return decompositionProducts;
    }

    public void setDecompositionConditions(String decompositionConditions) 
    {
        this.decompositionConditions = decompositionConditions;
    }

    public String getDecompositionConditions() 
    {
        return decompositionConditions;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("msdsId", getMsdsId())
            .append("stability", getStability())
            .append("reactivity", getReactivity())
            .append("incompatibleSubstances", getIncompatibleSubstances())
            .append("conditionsToAvoid", getConditionsToAvoid())
            .append("hazardousReactions", getHazardousReactions())
            .append("polymerizationHazard", getPolymerizationHazard())
            .append("polymerizationConditions", getPolymerizationConditions())
            .append("decompositionProducts", getDecompositionProducts())
            .append("decompositionConditions", getDecompositionConditions())
            .append("createTime", getCreateTime())
            .append("updateTime", getUpdateTime())
            .append("createBy", getCreateBy())
            .append("updateBy", getUpdateBy())
            .toString();
    }
} 