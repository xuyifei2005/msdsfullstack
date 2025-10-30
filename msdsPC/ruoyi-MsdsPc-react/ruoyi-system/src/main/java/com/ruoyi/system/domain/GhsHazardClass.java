package com.ruoyi.system.domain;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/**
 * GHS危险性分类标准对象 ghs_hazard_class
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
public class GhsHazardClass extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 危险类别代码 */
    @Excel(name = "危险类别代码")
    @NotBlank(message = "危险类别代码不能为空")
    @Size(max = 20, message = "危险类别代码不能超过20个字符")
    private String classCode;

    /** 危险类别名称 */
    @Excel(name = "危险类别名称")
    @NotBlank(message = "危险类别名称不能为空")
    @Size(max = 100, message = "危险类别名称不能超过100个字符")
    private String className;

    /** 危险类别 */
    @Excel(name = "危险类别")
    @Size(max = 50, message = "危险类别不能超过50个字符")
    private String category;

    /** 象形图代码 */
    @Excel(name = "象形图代码")
    @Size(max = 50, message = "象形图代码不能超过50个字符")
    private String pictogram;

    /** 警示词 */
    @Excel(name = "警示词")
    @Size(max = 20, message = "警示词不能超过20个字符")
    private String signalWord;

    /** 描述 */
    @Excel(name = "描述")
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

    public void setClassCode(String classCode) 
    {
        this.classCode = classCode;
    }

    public String getClassCode() 
    {
        return classCode;
    }

    public void setClassName(String className) 
    {
        this.className = className;
    }

    public String getClassName() 
    {
        return className;
    }

    public void setCategory(String category) 
    {
        this.category = category;
    }

    public String getCategory() 
    {
        return category;
    }

    public void setPictogram(String pictogram) 
    {
        this.pictogram = pictogram;
    }

    public String getPictogram() 
    {
        return pictogram;
    }

    public void setSignalWord(String signalWord) 
    {
        this.signalWord = signalWord;
    }

    public String getSignalWord() 
    {
        return signalWord;
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
            .append("classCode", getClassCode())
            .append("className", getClassName())
            .append("category", getCategory())
            .append("pictogram", getPictogram())
            .append("signalWord", getSignalWord())
            .append("description", getDescription())
            .append("isActive", getIsActive())
            .append("createTime", getCreateTime())
            .toString();
    }
}