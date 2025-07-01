package com.ruoyi.system.domain;

import java.util.Date;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.annotation.Excel.ColumnType;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * MSDS主信息表 msds_main
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
public class MsdsMain extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** MSDS唯一标识 */
    @Excel(name = "MSDS编号", cellType = ColumnType.NUMERIC)
    private Long id;

    /** 化学品中文名 */
    @Excel(name = "化学品中文名")
    private String productName;

    /** 化学品别名 */
    @Excel(name = "化学品别名")
    private String productAlias;

    /** 化学品英文名 */
    @Excel(name = "化学品英文名")
    private String productEnglishName;

    /** 企业名称 */
    @Excel(name = "企业名称")
    private String companyName;

    /** 企业地址 */
    @Excel(name = "企业地址")
    private String companyAddress;

    /** 邮编 */
    @Excel(name = "邮编")
    private String zipCode;

    /** 传真号码 */
    @Excel(name = "传真号码")
    private String faxNumber;

    /** 联系电话 */
    @Excel(name = "联系电话")
    private String contactPhone;

    /** 电子邮件地址 */
    @Excel(name = "电子邮件地址")
    private String email;

    /** 企业应急电话 */
    @Excel(name = "企业应急电话")
    private String emergencyPhone;

    /** 产品推荐用途 */
    @Excel(name = "产品推荐用途")
    private String recommendedUsage;

    /** 产品限制用途 */
    @Excel(name = "产品限制用途")
    private String restrictedUsage;

    /** MSDS版本号 */
    @Excel(name = "MSDS版本号")
    private String version;

    /** 是否有效(1:有效,0:无效) */
    @Excel(name = "是否有效", readConverterExp = "1=有效,0=无效")
    private Integer isActive;

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    @NotBlank(message = "化学品中文名不能为空")
    @Size(min = 0, max = 255, message = "化学品中文名不能超过255个字符")
    public String getProductName()
    {
        return productName;
    }

    public void setProductName(String productName)
    {
        this.productName = productName;
    }

    @Size(min = 0, max = 255, message = "化学品别名不能超过255个字符")
    public String getProductAlias()
    {
        return productAlias;
    }

    public void setProductAlias(String productAlias)
    {
        this.productAlias = productAlias;
    }

    @Size(min = 0, max = 255, message = "化学品英文名不能超过255个字符")
    public String getProductEnglishName()
    {
        return productEnglishName;
    }

    public void setProductEnglishName(String productEnglishName)
    {
        this.productEnglishName = productEnglishName;
    }

    @NotBlank(message = "企业名称不能为空")
    @Size(min = 0, max = 255, message = "企业名称不能超过255个字符")
    public String getCompanyName()
    {
        return companyName;
    }

    public void setCompanyName(String companyName)
    {
        this.companyName = companyName;
    }

    public String getCompanyAddress()
    {
        return companyAddress;
    }

    public void setCompanyAddress(String companyAddress)
    {
        this.companyAddress = companyAddress;
    }

    @Size(min = 0, max = 10, message = "邮编不能超过10个字符")
    public String getZipCode()
    {
        return zipCode;
    }

    public void setZipCode(String zipCode)
    {
        this.zipCode = zipCode;
    }

    @Size(min = 0, max = 50, message = "传真号码不能超过50个字符")
    public String getFaxNumber()
    {
        return faxNumber;
    }

    public void setFaxNumber(String faxNumber)
    {
        this.faxNumber = faxNumber;
    }

    @NotBlank(message = "联系电话不能为空")
    @Size(min = 0, max = 50, message = "联系电话不能超过50个字符")
    public String getContactPhone()
    {
        return contactPhone;
    }

    public void setContactPhone(String contactPhone)
    {
        this.contactPhone = contactPhone;
    }

    @Size(min = 0, max = 100, message = "电子邮件地址不能超过100个字符")
    public String getEmail()
    {
        return email;
    }

    public void setEmail(String email)
    {
        this.email = email;
    }

    @Size(min = 0, max = 50, message = "企业应急电话不能超过50个字符")
    public String getEmergencyPhone()
    {
        return emergencyPhone;
    }

    public void setEmergencyPhone(String emergencyPhone)
    {
        this.emergencyPhone = emergencyPhone;
    }

    public String getRecommendedUsage()
    {
        return recommendedUsage;
    }

    public void setRecommendedUsage(String recommendedUsage)
    {
        this.recommendedUsage = recommendedUsage;
    }

    public String getRestrictedUsage()
    {
        return restrictedUsage;
    }

    public void setRestrictedUsage(String restrictedUsage)
    {
        this.restrictedUsage = restrictedUsage;
    }

    @Size(min = 0, max = 20, message = "MSDS版本号不能超过20个字符")
    public String getVersion()
    {
        return version;
    }

    public void setVersion(String version)
    {
        this.version = version;
    }

    public Integer getIsActive()
    {
        return isActive;
    }

    public void setIsActive(Integer isActive)
    {
        this.isActive = isActive;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("productName", getProductName())
            .append("productAlias", getProductAlias())
            .append("productEnglishName", getProductEnglishName())
            .append("companyName", getCompanyName())
            .append("companyAddress", getCompanyAddress())
            .append("zipCode", getZipCode())
            .append("faxNumber", getFaxNumber())
            .append("contactPhone", getContactPhone())
            .append("email", getEmail())
            .append("emergencyPhone", getEmergencyPhone())
            .append("recommendedUsage", getRecommendedUsage())
            .append("restrictedUsage", getRestrictedUsage())
            .append("version", getVersion())
            .append("isActive", getIsActive())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
} 