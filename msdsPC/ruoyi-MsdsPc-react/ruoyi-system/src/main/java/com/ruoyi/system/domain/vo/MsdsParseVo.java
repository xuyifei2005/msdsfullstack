package com.ruoyi.system.domain.vo;

import java.util.List;
import java.io.Serializable;

/**
 * MSDS AI 解析结果 VO
 */
public class MsdsParseVo implements Serializable {
    private static final long serialVersionUID = 1L;

    /** 化学品中文名 */
    private String chemicalNameCn;

    /** 化学品英文名 */
    private String chemicalNameEn;

    /** CAS号 */
    private String casNo;

    /** 供应商名称 */
    private String supplierName;

    /** 应急电话 */
    private String emergencyPhone;

    /** 分子式 */
    private String formula;

    /** GHS 危险性分类列表 */
    private List<String> hazardCategories;

    /** 危险性说明 (H-Statement) */
    private List<String> hazardStatements;

    /** 防范说明 (P-Statement) */
    private List<String> precautionaryStatements;

    /** 解析置信度 (0-100) */
    private Integer confidence;

    /** 原始文本摘要 */
    private String rawTextSummary;

    public String getChemicalNameCn() {
        return chemicalNameCn;
    }

    public void setChemicalNameCn(String chemicalNameCn) {
        this.chemicalNameCn = chemicalNameCn;
    }

    public String getChemicalNameEn() {
        return chemicalNameEn;
    }

    public void setChemicalNameEn(String chemicalNameEn) {
        this.chemicalNameEn = chemicalNameEn;
    }

    public String getCasNo() {
        return casNo;
    }

    public void setCasNo(String casNo) {
        this.casNo = casNo;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public String getEmergencyPhone() {
        return emergencyPhone;
    }

    public void setEmergencyPhone(String emergencyPhone) {
        this.emergencyPhone = emergencyPhone;
    }

    public String getFormula() {
        return formula;
    }

    public void setFormula(String formula) {
        this.formula = formula;
    }

    public List<String> getHazardCategories() {
        return hazardCategories;
    }

    public void setHazardCategories(List<String> hazardCategories) {
        this.hazardCategories = hazardCategories;
    }

    public List<String> getHazardStatements() {
        return hazardStatements;
    }

    public void setHazardStatements(List<String> hazardStatements) {
        this.hazardStatements = hazardStatements;
    }

    public List<String> getPrecautionaryStatements() {
        return precautionaryStatements;
    }

    public void setPrecautionaryStatements(List<String> precautionaryStatements) {
        this.precautionaryStatements = precautionaryStatements;
    }

    public Integer getConfidence() {
        return confidence;
    }

    public void setConfidence(Integer confidence) {
        this.confidence = confidence;
    }

    public String getRawTextSummary() {
        return rawTextSummary;
    }

    public void setRawTextSummary(String rawTextSummary) {
        this.rawTextSummary = rawTextSummary;
    }
}
