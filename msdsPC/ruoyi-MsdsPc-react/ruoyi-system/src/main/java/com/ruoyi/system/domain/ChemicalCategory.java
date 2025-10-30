package com.ruoyi.system.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/**
 * 化学品分类对象 chemical_category
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
public class ChemicalCategory extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 分类ID */
    private Long id;

    /** 分类代码 */
    @Excel(name = "分类代码")
    @NotBlank(message = "分类代码不能为空")
    @Size(max = 20, message = "分类代码不能超过20个字符")
    private String categoryCode;

    /** 分类名称 */
    @Excel(name = "分类名称")
    @NotBlank(message = "分类名称不能为空")
    @Size(max = 100, message = "分类名称不能超过100个字符")
    private String categoryName;

    /** 父分类ID */
    @Excel(name = "父分类ID")
    private Long parentId;

    /** 分类描述 */
    @Excel(name = "分类描述")
    private String description;

    /** 是否有效 */
    @Excel(name = "是否有效", readConverterExp = "1=有效,0=无效")
    private Integer isActive;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }

    public void setCategoryCode(String categoryCode) 
    {
        this.categoryCode = categoryCode;
    }

    public String getCategoryCode() 
    {
        return categoryCode;
    }

    public void setCategoryName(String categoryName) 
    {
        this.categoryName = categoryName;
    }

    public String getCategoryName() 
    {
        return categoryName;
    }

    public void setParentId(Long parentId) 
    {
        this.parentId = parentId;
    }

    public Long getParentId() 
    {
        return parentId;
    }

    public void setDescription(String description) 
    {
        this.description = description;
    }

    public String getDescription() 
    {
        return description;
    }

    public void setIsActive(Integer isActive) 
    {
        this.isActive = isActive;
    }

    public Integer getIsActive() 
    {
        return isActive;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("categoryCode", getCategoryCode())
            .append("categoryName", getCategoryName())
            .append("parentId", getParentId())
            .append("description", getDescription())
            .append("isActive", getIsActive())
            .append("createTime", getCreateTime())
            .toString();
    }
}