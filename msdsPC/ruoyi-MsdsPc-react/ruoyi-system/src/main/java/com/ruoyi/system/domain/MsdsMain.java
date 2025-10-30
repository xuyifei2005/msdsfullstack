package com.ruoyi.system.domain;

import java.util.Date;
import java.util.Map;
import java.util.HashMap;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;
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

    /** CAS登记号 */
    @Excel(name = "CAS登记号")
    private String casNumber;

    /** MSDS编号 */
    @Excel(name = "MSDS编号")
    private String msdsCode;

    /** 化学品中文名 */
    @Excel(name = "化学品中文名")
    private String productName;

    /** 化学品别名 */
    @Excel(name = "化学品别名")
    private String productAlias;

    /** 化学品英文名 */
    @Excel(name = "化学品英文名")
    private String productEnglishName;

    /** 化学品分类ID */
    private Integer categoryId;

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

    /** 修订日期 */
    @Excel(name = "修订日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date revisionDate;

    /** 生效日期 */
    @Excel(name = "生效日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date effectiveDate;

    /** 供应商名称 */
    @Excel(name = "供应商名称")
    private String supplierName;

    /** 供应商地址 */
    @Excel(name = "供应商地址")
    private String supplierAddress;

    /** 供应商电话 */
    @Excel(name = "供应商电话")
    private String supplierPhone;

    /** 供应商传真 */
    @Excel(name = "供应商传真")
    private String supplierFax;

    /** 供应商邮箱 */
    @Excel(name = "供应商邮箱")
    private String supplierEmail;

    /** 供应商应急电话 */
    @Excel(name = "供应商应急电话")
    private String supplierEmergencyPhone;

    /** 技术咨询电话 */
    @Excel(name = "技术咨询电话")
    private String technicalPhone;

    /** 产品代码 */
    @Excel(name = "产品代码")
    private String productCode;

    /** 同义名 */
    @Excel(name = "同义名")
    private String synonyms;

    /** 分子式 */
    @Excel(name = "分子式")
    private String molecularFormula;

    /** 分子量 */
    @Excel(name = "分子量")
    private String molecularWeight;

    /** EINECS号 */
    @Excel(name = "EINECS号")
    private String einecsNumber;

    /** RTECS号 */
    @Excel(name = "RTECS号")
    private String rtecsNumber;

    /** UN编号 */
    @Excel(name = "UN编号")
    private String unNumber;

    /** 危险货物编号 */
    @Excel(name = "危险货物编号")
    private String dangerousGoodsNumber;

    /** 状态 */
    @Excel(name = "状态", readConverterExp = "draft=草稿,pending=待审,approved=已审批,archived=已归档")
    private String status;

    /** 审批人 */
    @Excel(name = "审批人")
    private String approver;

    /** 审批日期 */
    @Excel(name = "审批日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date approvalDate;

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

    @Size(min = 0, max = 50, message = "CAS登记号不能超过50个字符")
    public String getCasNumber()
    {
        return casNumber;
    }

    public void setCasNumber(String casNumber)
    {
        this.casNumber = casNumber;
    }

    @Size(min = 0, max = 50, message = "MSDS编号不能超过50个字符")
    public String getMsdsCode()
    {
        return msdsCode;
    }

    public void setMsdsCode(String msdsCode)
    {
        this.msdsCode = msdsCode;
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

    public Integer getCategoryId()
    {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId)
    {
        this.categoryId = categoryId;
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

    public Date getRevisionDate()
    {
        return revisionDate;
    }

    public void setRevisionDate(Date revisionDate)
    {
        this.revisionDate = revisionDate;
    }

    public Date getEffectiveDate()
    {
        return effectiveDate;
    }

    public void setEffectiveDate(Date effectiveDate)
    {
        this.effectiveDate = effectiveDate;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getApprover()
    {
        return approver;
    }

    public void setApprover(String approver)
    {
        this.approver = approver;
    }

    public Date getApprovalDate()
    {
        return approvalDate;
    }

    public void setApprovalDate(Date approvalDate)
    {
        this.approvalDate = approvalDate;
    }

    public Integer getIsActive()
    {
        return isActive;
    }

    public void setIsActive(Integer isActive)
    {
        this.isActive = isActive;
    }





    @Size(min = 0, max = 255, message = "供应商名称不能超过255个字符")
    public String getSupplierName()
    {
        return supplierName;
    }

    public void setSupplierName(String supplierName)
    {
        this.supplierName = supplierName;
    }

    public String getSupplierAddress()
    {
        return supplierAddress;
    }

    public void setSupplierAddress(String supplierAddress)
    {
        this.supplierAddress = supplierAddress;
    }

    @Size(min = 0, max = 50, message = "供应商电话不能超过50个字符")
    public String getSupplierPhone()
    {
        return supplierPhone;
    }

    public void setSupplierPhone(String supplierPhone)
    {
        this.supplierPhone = supplierPhone;
    }

    @Size(min = 0, max = 50, message = "供应商传真不能超过50个字符")
    public String getSupplierFax()
    {
        return supplierFax;
    }

    public void setSupplierFax(String supplierFax)
    {
        this.supplierFax = supplierFax;
    }

    @Size(min = 0, max = 100, message = "供应商邮箱不能超过100个字符")
    public String getSupplierEmail()
    {
        return supplierEmail;
    }

    public void setSupplierEmail(String supplierEmail)
    {
        this.supplierEmail = supplierEmail;
    }

    @Size(min = 0, max = 50, message = "供应商应急电话不能超过50个字符")
    public String getSupplierEmergencyPhone()
    {
        return supplierEmergencyPhone;
    }

    public void setSupplierEmergencyPhone(String supplierEmergencyPhone)
    {
        this.supplierEmergencyPhone = supplierEmergencyPhone;
    }

    @Size(min = 0, max = 50, message = "技术咨询电话不能超过50个字符")
    public String getTechnicalPhone()
    {
        return technicalPhone;
    }

    public void setTechnicalPhone(String technicalPhone)
    {
        this.technicalPhone = technicalPhone;
    }

    @Size(min = 0, max = 50, message = "产品代码不能超过50个字符")
    public String getProductCode()
    {
        return productCode;
    }

    public void setProductCode(String productCode)
    {
        this.productCode = productCode;
    }

    public String getSynonyms()
    {
        return synonyms;
    }

    public void setSynonyms(String synonyms)
    {
        this.synonyms = synonyms;
    }

    @Size(min = 0, max = 100, message = "分子式不能超过100个字符")
    public String getMolecularFormula()
    {
        return molecularFormula;
    }

    public void setMolecularFormula(String molecularFormula)
    {
        this.molecularFormula = molecularFormula;
    }

    @Size(min = 0, max = 50, message = "分子量不能超过50个字符")
    public String getMolecularWeight()
    {
        return molecularWeight;
    }

    public void setMolecularWeight(String molecularWeight)
    {
        this.molecularWeight = molecularWeight;
    }

    @Size(min = 0, max = 50, message = "EINECS号不能超过50个字符")
    public String getEinecsNumber()
    {
        return einecsNumber;
    }

    public void setEinecsNumber(String einecsNumber)
    {
        this.einecsNumber = einecsNumber;
    }

    @Size(min = 0, max = 50, message = "RTECS号不能超过50个字符")
    public String getRtecsNumber()
    {
        return rtecsNumber;
    }

    public void setRtecsNumber(String rtecsNumber)
    {
        this.rtecsNumber = rtecsNumber;
    }

    @Size(min = 0, max = 50, message = "UN编号不能超过50个字符")
    public String getUnNumber()
    {
        return unNumber;
    }

    public void setUnNumber(String unNumber)
    {
        this.unNumber = unNumber;
    }

    @Size(min = 0, max = 50, message = "危险货物编号不能超过50个字符")
    public String getDangerousGoodsNumber()
    {
        return dangerousGoodsNumber;
    }

    public void setDangerousGoodsNumber(String dangerousGoodsNumber)
    {
        this.dangerousGoodsNumber = dangerousGoodsNumber;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("casNumber", getCasNumber())
            .append("msdsCode", getMsdsCode())
            .append("productName", getProductName())
            .append("productAlias", getProductAlias())
            .append("productEnglishName", getProductEnglishName())
            .append("categoryId", getCategoryId())
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
            .append("revisionDate", getRevisionDate())
            .append("effectiveDate", getEffectiveDate())
            .append("status", getStatus())
            .append("approver", getApprover())
            .append("approvalDate", getApprovalDate())
            .append("isActive", getIsActive())
            .append("createTime", getCreateTime())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}