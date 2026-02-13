# MSDS数据处理工作流指南

## 概述

本文档定义了MSDS（化学品安全技术说明书）数据从PDF导入到系统展示的全流程处理规范，确保数据准确性、完整性和可追溯性。

## 工作流概览

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  PDF文件    │ -> │  格式转换   │ -> │  数据解析   │ -> │  质量检查   │ -> │  数据入库   │
│   导入      │    │  (pdf2xml)  │    │  (XML解析)  │    │  (验证)     │    │  (MySQL)    │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
       │                  │                  │                  │                  │
       ▼                  ▼                  ▼                  ▼                  ▼
  data-cleaning-    msds-completion   data-cleaning-   testing-         database-
  expert            -expert           expert           validation-      expert
                                                         expert
```

## 阶段一：PDF文件导入

### 1.1 支持的文件格式
- **PDF**: 原始MSDS文档
- **TXT**: 纯文本格式
- **XML**: 已转换的XML格式

### 1.2 文件命名规范
```
中文名、英文名、CAS号.pdf
示例：硫酸、Sulfuric acid、7664-93-9.pdf

或

中文名,英文名,CAS号.pdf
示例：硫酸,Sulfuric acid,7664-93-9.pdf
```

### 1.3 文件存放位置
```
pdf2xml/
├── input/              # 待处理的PDF文件
├── output/             # 转换后的XML文件
├── templates/          # 转换模板
└── logs/               # 处理日志
```

### 1.4 使用 data-cleaning-expert 预处理
```python
# 检查文件完整性
# 验证文件名格式
# 检查PDF可读性
```

## 阶段二：格式转换 (pdf2xml)

### 2.1 转换工具配置
```python
# pdf2xml/config.py
class Config:
    # PDF解析引擎
    PDF_ENGINE = 'pdfplumber'  # 或 'PyPDF2', 'pdfminer'
    
    # 输出格式
    OUTPUT_FORMAT = 'xml'
    
    # 编码设置
    ENCODING = 'utf-8'
    
    # 并发处理数
    MAX_WORKERS = 4
```

### 2.2 转换流程
```python
# pdf2xml/pdf_to_xml.py
class PdfToXmlConverter:
    def convert(self, pdf_path: str) -> str:
        """
        将PDF转换为XML格式
        
        Args:
            pdf_path: PDF文件路径
            
        Returns:
            XML文件路径
        """
        # 1. 提取PDF文本
        text = self.extract_text(pdf_path)
        
        # 2. 识别MSDS章节
        sections = self.identify_sections(text)
        
        # 3. 生成XML结构
        xml_content = self.generate_xml(sections)
        
        # 4. 保存XML文件
        return self.save_xml(xml_content, pdf_path)
```

### 2.3 转换后的XML结构
```xml
<?xml version="1.0" encoding="UTF-8"?>
<msds_document>
  <product_info>
    <chinese_name>硫酸</chinese_name>
    <english_name>Sulfuric acid</english_name>
    <cas_number>7664-93-9</cas_number>
  </product_info>
  
  <section_1_identification>
    <product_identifier>硫酸</product_identifier>
    <recommended_use>工业用化学品</recommended_use>
    <supplier>XXX化工有限公司</supplier>
  </section_1_identification>
  
  <section_2_hazard_identification>
    <ghs_classification>皮肤腐蚀/刺激 类别1A</ghs_classification>
    <signal_word>危险</signal_word>
    <hazard_statements>
      <statement>H314: 造成严重皮肤灼伤和眼损伤</statement>
    </hazard_statements>
  </section_2_hazard_identification>
  
  <!-- 其他章节... -->
  
</msds_document>
```

## 阶段三：数据解析

### 3.1 XML解析规则
```java
@Component
public class MsdsXmlParser {
    
    public MsdsMain parseMainInfo(Element root) {
        MsdsMain msds = new MsdsMain();
        
        // 解析产品信息
        Element productInfo = root.element("product_info");
        msds.setProductName(productInfo.elementText("chinese_name"));
        msds.setProductEnglishName(productInfo.elementText("english_name"));
        msds.setCasNumber(productInfo.elementText("cas_number"));
        
        return msds;
    }
    
    public MsdsHazard parseHazardInfo(Element root) {
        MsdsHazard hazard = new MsdsHazard();
        
        Element hazardSection = root.element("section_2_hazard_identification");
        hazard.setGhsClassification(hazardSection.elementText("ghs_classification"));
        hazard.setSignalWord(hazardSection.elementText("signal_word"));
        
        return hazard;
    }
}
```

### 3.2 数据映射表

| XML元素路径 | 数据库字段 | 数据类型 | 必填 |
|------------|-----------|----------|------|
| product_info/chinese_name | product_name | VARCHAR(200) | 是 |
| product_info/english_name | product_english_name | VARCHAR(200) | 否 |
| product_info/cas_number | cas_number | VARCHAR(20) | 是 |
| section_2/gsignal_word | signal_word | VARCHAR(50) | 否 |
| section_3/component | component_name | VARCHAR(200) | 是 |

### 3.3 使用 msds-completion-expert 补全数据
```python
# 自动补全缺失信息
# - 从CAS号查询化学信息
# - 补全物理化学性质
# - 验证GHS分类
```

## 阶段四：质量检查

### 4.1 数据验证规则
```java
@Component
public class MsdsDataValidator {
    
    public ValidationResult validate(MsdsMain msds) {
        ValidationResult result = new ValidationResult();
        
        // 1. 必填字段检查
        if (StringUtils.isBlank(msds.getProductName())) {
            result.addError("productName", "产品名称不能为空");
        }
        
        // 2. CAS号格式验证
        if (!CasNumberValidator.isValid(msds.getCasNumber())) {
            result.addError("casNumber", "CAS号格式不正确");
        }
        
        // 3. 数据一致性检查
        if (msds.getComponents().isEmpty()) {
            result.addWarning("components", "成分信息为空");
        }
        
        // 4. 完整性检查
        checkCompleteness(msds, result);
        
        return result;
    }
}
```

### 4.2 CAS号验证算法
```java
public class CasNumberValidator {
    
    public static boolean isValid(String casNumber) {
        // CAS号格式: NNNNNNN-NN-N
        if (!casNumber.matches("\\d{1,7}-\\d{2}-\\d")) {
            return false;
        }
        
        // 校验位验证
        String[] parts = casNumber.split("-");
        String digits = parts[0] + parts[1];
        int checkDigit = Integer.parseInt(parts[2]);
        
        int sum = 0;
        int weight = digits.length();
        for (char c : digits.toCharArray()) {
            sum += (c - '0') * weight--;
        }
        
        return (sum % 10) == checkDigit;
    }
}
```

### 4.3 质量评分标准
```java
public class QualityScorer {
    
    public int calculateScore(MsdsMain msds) {
        int score = 0;
        int maxScore = 100;
        
        // 基本信息 (30分)
        if (StringUtils.isNotBlank(msds.getProductName())) score += 10;
        if (StringUtils.isNotBlank(msds.getCasNumber())) score += 10;
        if (StringUtils.isNotBlank(msds.getProductEnglishName())) score += 10;
        
        // 安全信息 (40分)
        if (msds.getHazard() != null) score += 15;
        if (msds.getFirstAid() != null) score += 10;
        if (msds.getFireFighting() != null) score += 10;
        if (msds.getLeakResponse() != null) score += 5;
        
        // 技术信息 (30分)
        if (msds.getPhysicalChemical() != null) score += 15;
        if (msds.getComponents() != null && !msds.getComponents().isEmpty()) score += 15;
        
        return score;
    }
}
```

## 阶段五：数据入库

### 5.1 批量导入策略
```java
@Service
public class MsdsBatchImportService {
    
    @Transactional(rollbackFor = Exception.class)
    public BatchImportResult batchImport(List<MsdsMain> msdsList) {
        BatchImportResult result = new BatchImportResult();
        
        // 1. 数据预处理
        List<MsdsMain> validList = new ArrayList<>();
        for (MsdsMain msds : msdsList) {
            ValidationResult validation = validator.validate(msds);
            if (validation.isValid()) {
                validList.add(msds);
            } else {
                result.addFailed(msds, validation.getErrors());
            }
        }
        
        // 2. 批量插入（分批处理，每批100条）
        int batchSize = 100;
        for (int i = 0; i < validList.size(); i += batchSize) {
            List<MsdsMain> batch = validList.subList(i, 
                Math.min(i + batchSize, validList.size()));
            msdsMainMapper.batchInsert(batch);
            result.addSuccessCount(batch.size());
        }
        
        return result;
    }
}
```

### 5.2 数据去重策略
```java
public class DuplicateChecker {
    
    public boolean isDuplicate(MsdsMain msds) {
        // 1. 按CAS号检查
        if (StringUtils.isNotBlank(msds.getCasNumber())) {
            MsdsMain existing = msdsMainMapper.selectByCasNumber(
                msds.getCasNumber());
            if (existing != null) return true;
        }
        
        // 2. 按名称相似度检查
        List<MsdsMain> similarNames = msdsMainMapper.selectBySimilarName(
            msds.getProductName());
        for (MsdsMain existing : similarNames) {
            if (calculateSimilarity(existing.getProductName(), 
                msds.getProductName()) > 0.9) {
                return true;
            }
        }
        
        return false;
    }
}
```

### 5.3 使用 database-expert 优化入库
```sql
-- 创建索引加速查重
CREATE INDEX idx_cas_number ON msds_main(cas_number);
CREATE INDEX idx_product_name ON msds_main(product_name);
CREATE FULLTEXT INDEX idx_fulltext ON msds_main(product_name, product_english_name);
```

## 完整处理脚本

### 批量处理脚本
```python
#!/usr/bin/env python3
# batch_process_msds.py

import os
import sys
from pathlib import Path
from pdf2xml import PdfToXmlConverter
from xml_parser import MsdsXmlParser
from data_validator import MsdsDataValidator
from database_importer import DatabaseImporter

class MsdsBatchProcessor:
    def __init__(self):
        self.converter = PdfToXmlConverter()
        self.parser = MsdsXmlParser()
        self.validator = MsdsDataValidator()
        self.importer = DatabaseImporter()
    
    def process_file(self, pdf_path: str) -> ProcessingResult:
        """处理单个PDF文件"""
        result = ProcessingResult()
        result.file_path = pdf_path
        
        try:
            # 1. PDF转XML
            xml_path = self.converter.convert(pdf_path)
            result.xml_path = xml_path
            
            # 2. 解析XML
            msds_data = self.parser.parse(xml_path)
            result.parsed_data = msds_data
            
            # 3. 验证数据
            validation = self.validator.validate(msds_data)
            result.validation = validation
            
            if validation.is_valid():
                # 4. 导入数据库
                import_result = self.importer.import_data(msds_data)
                result.import_result = import_result
                result.success = True
            else:
                result.success = False
                result.errors = validation.errors
                
        except Exception as e:
            result.success = False
            result.errors.append(str(e))
        
        return result
    
    def process_directory(self, input_dir: str, output_dir: str):
        """批量处理目录中的所有PDF文件"""
        pdf_files = Path(input_dir).glob("*.pdf")
        
        results = []
        for pdf_file in pdf_files:
            print(f"Processing: {pdf_file.name}")
            result = self.process_file(str(pdf_file))
            results.append(result)
            
            # 输出处理结果
            if result.success:
                print(f"  ✓ Success: {result.import_result.record_id}")
            else:
                print(f"  ✗ Failed: {', '.join(result.errors)}")
        
        # 生成处理报告
        self.generate_report(results, output_dir)
    
    def generate_report(self, results: List[ProcessingResult], output_dir: str):
        """生成处理报告"""
        total = len(results)
        success = sum(1 for r in results if r.success)
        failed = total - success
        
        report = f"""
MSDS批量处理报告
================
处理时间: {datetime.now()}
总文件数: {total}
成功: {success}
失败: {failed}
成功率: {success/total*100:.1f}%

失败详情:
"""
        for result in results:
            if not result.success:
                report += f"\n- {os.path.basename(result.file_path)}"
                for error in result.errors:
                    report += f"\n  - {error}"
        
        report_path = os.path.join(output_dir, 
            f"processing_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt")
        with open(report_path, 'w', encoding='utf-8') as f:
            f.write(report)
        
        print(f"\n报告已生成: {report_path}")

# 使用示例
if __name__ == "__main__":
    processor = MsdsBatchProcessor()
    processor.process_directory(
        input_dir="pdf2xml/input",
        output_dir="pdf2xml/output"
    )
```

## 质量监控

### 数据质量仪表板
```sql
-- 数据完整性统计
SELECT 
    '产品名称' as field,
    COUNT(*) as total,
    SUM(CASE WHEN product_name IS NOT NULL AND product_name != '' THEN 1 ELSE 0 END) as filled,
    ROUND(SUM(CASE WHEN product_name IS NOT NULL AND product_name != '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as fill_rate
FROM msds_main

UNION ALL

SELECT 
    'CAS号' as field,
    COUNT(*) as total,
    SUM(CASE WHEN cas_number IS NOT NULL AND cas_number != '' THEN 1 ELSE 0 END) as filled,
    ROUND(SUM(CASE WHEN cas_number IS NOT NULL AND cas_number != '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as fill_rate
FROM msds_main

UNION ALL

-- 其他字段...
;
```

### 数据质量告警
```java
@Component
public class DataQualityMonitor {
    
    @Scheduled(cron = "0 0 9 * * ?") // 每天上午9点检查
    public void checkDataQuality() {
        // 1. 检查低质量数据
        List<MsdsMain> lowQualityData = msdsMainMapper.selectByQualityScore(50);
        if (!lowQualityData.isEmpty()) {
            alertService.sendAlert("数据质量警告", 
                String.format("发现%d条低质量MSDS数据", lowQualityData.size()));
        }
        
        // 2. 检查重复数据
        List<DuplicateGroup> duplicates = duplicateChecker.findDuplicates();
        if (!duplicates.isEmpty()) {
            alertService.sendAlert("重复数据警告",
                String.format("发现%d组重复数据", duplicates.size()));
        }
    }
}
```

## 工具链集成

### 推荐的Agent组合

| 阶段 | 主要Agent | 辅助Agent |
|------|----------|----------|
| PDF导入 | data-cleaning-expert | msds-fullstack-developer |
| 格式转换 | msds-completion-expert | code-generator-optimizer |
| 数据解析 | msds-fullstack-developer | database-expert |
| 质量检查 | testing-validation-expert | data-cleaning-expert |
| 数据入库 | database-expert | performance-optimizer |

### MCP工具使用

```json
{
  "data-processing": {
    "mysql": "数据查询和导入",
    "filesystem": "文件读写和管理",
    "docker": "批量处理容器管理"
  },
  "validation": {
    "testing-validation-expert": "数据质量验证",
    "database-expert": "数据库约束检查"
  }
}
```

## 最佳实践

### 1. 文件管理
- 原始PDF文件永久保存
- 转换后的XML保留3个月
- 处理日志保留1年

### 2. 数据备份
- 每日全量备份
- 实时增量备份
- 定期恢复演练

### 3. 错误处理
- 失败文件移入error目录
- 记录详细错误日志
- 支持断点续传

### 4. 性能优化
- 批量处理（每批100条）
- 并发处理（4个worker）
- 数据库连接池优化

---

**文档维护**: MSDS数据团队  
**最后更新**: 2024-01-30  
**版本**: 1.0.0
