---
name: "msds-completion"
description: "Completes missing sections in MSDS XML files according to GB/T 16483-2008 standard. Invoke when user needs to fill in missing MSDS data or process MSDS completion tasks."
---

# MSDS补全助手

## 概述

MSDS补全助手用于补全化学品安全技术说明书（MSDS）XML文件中的缺失字段，确保符合GB/T 16483-2008标准要求。

## 适用场景

- 当需要补全MSDS XML文件的16个标准部分时
- 当需要验证MSDS文件完整性时
- 当需要批量处理MSDS文件补全任务时
- 当需要根据CAS号或其他标识符查找和补充化学数据时

## MSDS文件结构

MSDS XML文件必须包含以下16个部分：

### 1. 第一部分：化学品及企业标识 (basic_info)
- cas_number: CAS号
- msds_code: MSDS编码
- product_name: 中文名称
- product_alias: 别名
- product_english_name: 英文名称
- company_name: 企业名称
- company_address: 企业地址
- contact_phone: 联系电话
- emergency_phone: 应急电话
- email: 电子邮箱
- fax_number: 传真号码

### 2. 第二部分：危险性概述 (hazard_info)
- hazard_category: 危险性类别
- exposure_routes: 暴露途径
- health_hazards: 健康危害
- environmental_hazards: 环境危害
- fire_explosion_hazards: 火灾爆炸危害

### 3. 第三部分：成分/组成信息 (component_info)
- components: 成分列表
  - component_name: 成分名称
  - component_content: 含量
  - cas_number: CAS号

### 4. 第四部分：急救措施 (first_aid)
- skin_contact: 皮肤接触
- eye_contact: 眼睛接触
- inhalation: 吸入
- ingestion: 食入

### 5. 第五部分：消防措施 (fire_fighting)
- hazard_characteristics: 危险特性
- fire_risk_classification: 火灾风险分类
- harmful_combustion_products: 有害燃烧产物
- suitable_extinguishing_media: 适用灭火剂
- extinguishing_precautions: 灭火注意事项

### 6. 第六部分：泄漏应急处理 (leak_response)
- emergency_procedures: 应急处理程序
- environmental_precautions: 环境预防措施
- cleaning_methods: 清理方法

### 7. 第七部分：操作处置与储存 (handling_storage)
- handling_precautions: 操作注意事项
- storage_precautions: 储存注意事项

### 8. 第八部分：接触控制/个体防护 (exposure_control)
- china_mac: 中国MAC
- former_soviet_mac: 前苏联MAC
- tlvtn: TLV-TN
- tlvvn: TLV-VN
- contact_limits: 接触限值
- monitoring_method: 监测方法
- engineering_controls: 工程控制
- respiratory_protection: 呼吸系统防护
- eye_protection: 眼睛防护
- body_protection: 身体防护
- hand_protection: 手部防护
- other_protection: 其他防护

### 9. 第九部分：理化特性 (physical_chemical)
- pH: pH值
- melting_point: 熔点
- boiling_point: 沸点
- flash_point: 闪点
- relative_density: 相对密度
- relative_vapor_density: 相对蒸气密度
- solubility: 溶解度
- molecular_formula: 分子式
- molecular_weight: 分子量
- main_components: 主要成分
- saturated_vapor_pressure: 饱和蒸气压
- log_kow: 辛醇-水分配系数
- critical_temperature: 临界温度
- ignition_temperature: 引燃温度
- autoignition_temperature: 自燃温度
- flammability: 易燃性
- appearance: 外观
- main_uses: 主要用途
- other_properties: 其他性质
- heat_of_combustion: 燃烧热
- critical_pressure: 临界压力
- explosive_upper_limit: 爆炸上限
- explosive_lower_limit: 爆炸下限

### 10. 第十部分：稳定性和反应活性 (stability_reactivity)
- stability: 稳定性
- incompatible_substances: 不相容物质
- conditions_to_avoid: 应避免的条件
- polymerization_hazard: 聚合危害
- decomposition_products: 分解产物

### 11. 第十一部分：毒理学信息 (toxicological)
- acute_toxicity: 急性毒性
- subacute_chronic_toxicity: 亚急性和慢性毒性
- rtecs: RTECS号
- irritation: 刺激性
- sensitization: 致敏性
- mutagenicity: 致突变性
- teratogenicity: 致畸性
- carcinogenicity: 致癌性

### 12. 第十二部分：生态学资料 (ecological)
- ecological_toxicity: 生态毒性
- biodegradability: 生物降解性
- non_biodegradability: 非生物降解性
- bioaccumulation: 生物富集
- other_harmful_effects: 其他有害效应

### 13. 第十三部分：废弃处置 (disposal)
- waste_properties: 废物性质
- disposal_method: 处置方法
- disposal_precautions: 处置注意事项

### 14. 第十四部分：运输信息 (transportation)
- dangerous_goods_number: 危险货物编号
- un_number: UN编号
- imdg_page: IMDG页码
- packaging_mark: 包装标志
- packing_group: 包装组
- packaging_method: 包装方法
- transportation_precautions: 运输注意事项

### 15. 第十五部分：法规信息 (regulatory)
- regulatory_info: 法规信息（包括国内法规、国际法规、GHS分类、Hazard Statements、Precautionary Statements）

### 16. 第十六部分：其他信息 (other_info)
- compilation_standard: 编制标准
- revision_notes: 修订说明
- abbreviations: 缩略语
- references: 参考文献
- other_notes: 其他说明

## 补全流程

### 1. 分析现有文件
- 读取XML文件，检查16个部分的完整性
- 识别缺失的字段和部分
- 记录需要补全的内容

### 2. 数据收集
- 根据CAS号、中文名、英文名等标识符搜索相关化学数据
- 参考权威数据库（如NIST、PubChem、ECHA等）
- 查阅相关法规和标准

### 3. 数据验证
- 确保数据来源可靠
- 验证数据的准确性和一致性
- 检查是否符合GB/T 16483-2008标准

### 4. 文件更新
- 使用SearchReplace工具更新XML文件
- 确保XML结构正确
- 保持原有格式和编码

### 5. 质量检查
- 验证更新后的文件结构完整性
- 检查必填字段是否已补全
- 确认数据格式正确

## 常用数据来源

### 国内法规
- 危险化学品安全管理条例
- 危险化学品目录（2015版）
- 民用爆炸物品安全管理条例

### 国际法规
- 联合国关于危险货物运输的建议书（TDG）
- 国际海事组织国际海运危险货物规则（IMDG Code）
- 国际民用航空组织危险物品安全航空运输技术细则（ICAO TI/IATA DGR）

### 化学数据库
- NIST Chemistry WebBook
- PubChem
- ECHA（欧洲化学品管理局）
- ChemSpider

## 批量处理策略

1. **分批处理**：每批处理100个文件，避免系统资源消耗过大
2. **优先级排序**：优先处理重要化学品或常用化学品
3. **进度跟踪**：维护补全清单，记录已完成和待处理文件
4. **质量抽样**：每批完成后进行抽样检查，确保补全质量

## 验收标准

- 所有16个部分必须存在
- 关键字段（cas_number、product_name、product_english_name、product_alias）必须填写
- 数据必须符合GB/T 16483-2008标准要求
- XML结构必须正确，无语法错误
- 数据来源可靠，准确性高

## 注意事项

1. **数据准确性**：确保所有补全数据来自可靠来源
2. **标准合规**：严格遵循GB/T 16483-2008标准
3. **格式一致性**：保持XML文件格式的一致性
4. **安全第一**：对于危险化学品的处理信息必须准确无误
5. **持续更新**：定期更新法规信息和化学数据

## 示例

### 补全缺失的毒理学信息

```xml
<toxicological>
  <acute_toxicity>属中等毒类。LD50：1500mg/kg（小鼠经口）；LC50：无资料。</acute_toxicity>
  <subacute_chronic_toxicity>长期接触可引起中枢神经系统损害。</subacute_chronic_toxicity>
  <rtecs>无资料</rtecs>
  <irritation>对眼睛、皮肤、粘膜和上呼吸道有刺激性。</irritation>
  <sensitization>无资料</sensitization>
  <mutagenicity>无资料</mutagenicity>
  <teratogenicity>无资料</teratogenicity>
  <carcinogenicity>无资料</carcinogenicity>
</toxicological>
```

### 补全运输信息

```xml
<transportation>
  <dangerous_goods_number>11046</dangerous_goods_number>
  <un_number>UN 0226</un_number>
  <imdg_page>第1.1类爆炸品</imdg_page>
  <packaging_mark>第1.1类爆炸品</packaging_mark>
  <packing_group>不适用</packing_group>
  <packaging_method>包装类别：不适用。专用爆炸品包装箱。</packaging_method>
  <transportation_precautions>运输时运输车辆应配备相应品种和数量的消防器材及泄漏应急处理设备。</transportation_precautions>
</transportation>
```

## 工具使用

- **Read工具**：读取XML文件内容
- **SearchReplace工具**：更新XML文件中的特定字段
- **Write工具**：创建或重写整个XML文件
- **WebSearch工具**：搜索化学数据和法规信息
- **Grep工具**：在文件中搜索特定内容

## 错误处理

1. **文件不存在**：跳过该文件，记录到错误日志
2. **XML解析错误**：检查XML格式，修复语法错误
3. **数据缺失**：标记为"无资料"，继续处理其他字段
4. **数据冲突**：优先使用权威数据源，记录冲突信息

## 进度报告

定期生成进度报告，包括：
- 已完成文件数量
- 待处理文件数量
- 完成率
- 遇到的问题和解决方案
- 质量检查结果
