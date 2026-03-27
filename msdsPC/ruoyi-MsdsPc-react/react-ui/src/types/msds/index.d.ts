declare namespace API {
  namespace Msds {
    /** MSDS主信息类型 */
    type MsdsMain = {
      id?: number;
      casNumber?: string;           // CAS登记号
      msdsCode?: string;           // MSDS编号
      productName: string;         // 化学品中文名
      productAlias?: string;       // 化学品别名
      productEnglishName?: string; // 化学品英文名
      categoryId?: number;         // 化学品分类ID
      companyName: string;         // 企业名称
      companyAddress?: string;     // 企业地址
      zipCode?: string;           // 邮编
      faxNumber?: string;         // 传真号码
      contactPhone: string;       // 联系电话
      email?: string;             // 电子邮件地址
      emergencyPhone?: string;    // 企业应急电话
      recommendedUsage?: string;  // 产品推荐用途
      restrictedUsage?: string;   // 产品限制用途
      version?: string;           // MSDS版本号
      revisionDate?: string;      // 修订日期
      effectiveDate?: string;     // 生效日期
      status?: string;            // 状态：draft/pending/approved/archived
      approver?: string;          // 审批人
      approvalDate?: string;      // 审批日期
      isActive?: number;          // 是否有效(1:有效,0:无效)
      createTime?: string;        // 创建时间
      updateTime?: string;        // 更新时间
      createdBy?: string;         // 创建人
      updatedBy?: string;         // 更新人
      remark?: string;            // 备注
    };

    /** MSDS列表查询参数 */
    type MsdsMainListParams = {
      current?: number;           // 当前页码
      pageNum?: number;           // 页码 (兼容旧版本)
      pageSize?: number;
      productName?: string;       // 化学品名称搜索
      casNumber?: string;         // CAS号搜索
      msdsCode?: string;          // MSDS编号搜索
      companyName?: string;       // 企业名称搜索
      status?: string;            // 状态筛选
      isActive?: number;          // 有效性筛选
      categoryId?: number;        // 分类筛选
      startDate?: string;         // 开始日期
      endDate?: string;           // 结束日期
    };

    /** MSDS分页结果 */
    type MsdsMainPageResult = {
      code: number;
      msg: string;
      total: number;
      rows: MsdsMain[];
    };

    /** MSDS详情结果 */
    type MsdsMainInfoResult = {
      code: number;
      msg: string;
      data: MsdsMain;
    };

    /** MSDS状态枚举 */
    type MsdsStatus = 'draft' | 'pending' | 'approved' | 'archived';
    
    /** MSDS状态选项 */
    type MsdsStatusOption = {
      label: string;
      value: MsdsStatus;
      color: string;
    };

    /** MSDS危险性概述类型 */
    type MsdsHazard = {
      id?: number;
      msdsId: number;
      emergencyOverview?: string;      // 紧急情况概述
      physicalState?: string;          // 物理状态
      odor?: string;                   // 气味
      color?: string;                  // 颜色
      warningWord?: 'danger' | 'warning'; // 警示词
      hazardCategory?: string;         // 危险性类别
      exposureRoutes?: string;         // 侵入途径
      healthHazards?: string;          // 健康危害
      environmentalHazards?: string;   // 环境危害
      fireExplosionHazards?: string;   // 燃爆危险
      hazardDescription?: string;      // 危险性说明
      preventionMeasures?: string;     // 预防措施
      responseMeasures?: string;       // 响应措施
      storageMeasures?: string;        // 储存措施
      disposalMeasures?: string;       // 废弃处置措施
    };

    /** MSDS成分/组成信息类型 */
    type MsdsComponent = {
      id?: number;
      msdsId: number;
      componentName: string;           // 成分名称
      componentEnglishName?: string;   // 成分英文名
      componentContent?: string;       // 成分含量/浓度
      contentMin?: number;             // 含量下限(%)
      contentMax?: number;             // 含量上限(%)
      casNumber?: string;              // CAS登记号
      ecNumber?: string;               // EC号
      molecularFormula?: string;       // 分子式
      molecularWeight?: number;        // 分子量
      isHazardous?: number;            // 是否为危险成分(1:是,0:否)
      hazardLevel?: string;            // 危险等级
      componentFunction?: string;      // 成分功能
    };

    /** MSDS急救措施类型 */
    type MsdsFirstAid = {
      id?: number;
      msdsId: number;
      skinContact?: string;            // 皮肤接触处理措施
      eyeContact?: string;             // 眼睛接触处理措施
      inhalation?: string;             // 吸入处理措施
      ingestion?: string;              // 食入处理措施
      generalNotes?: string;           // 一般注意事项
      symptomsEffects?: string;        // 可能出现的症状和健康影响
      immediateMedicalAttention?: string; // 需要立即就医的情况
      antidoteTreatment?: string;      // 解毒剂及治疗方法
    };

    /** MSDS消防措施类型 */
    type MsdsFireFighting = {
      id?: number;
      msdsId: number;
      hazardCharacteristics?: string;     // 危险特性
      harmfulCombustionProducts?: string; // 有害燃烧产物
      suitableExtinguishingMedia?: string; // 适宜的灭火介质
      unsuitableExtinguishingMedia?: string; // 不适宜的灭火介质
      fireFightingEquipment?: string;     // 消防设备和防护装备
      fireFightingProcedures?: string;    // 特殊消防程序
      flashPoint?: string;                // 闪点
      autoignitionTemperature?: string;   // 自燃温度
      flammabilityLimits?: string;        // 燃烧性/爆炸极限
      fireRiskClassification?: string;    // 建规火险分级
    };

    /** MSDS泄漏应急处理类型 */
    type MsdsLeakResponse = {
      id?: number;
      msdsId: number;
      personalPrecautions?: string;        // 个人防护措施
      environmentalPrecautions?: string;   // 环境保护措施
      containmentCleanup?: string;         // 泄漏化学品的收容、清除方法
      emergencyProcedures?: string;        // 应急处理程序
      eliminationMethods?: string;         // 消除方法
      equipmentMaterials?: string;         // 清理时使用的器材
      preventSecondaryHazards?: string;    // 防止发生次生危害的预防措施
    };

    /** MSDS操作处置与储存类型 */
    type MsdsHandlingStorage = {
      id?: number;
      msdsId: number;
      handlingPrecautions?: string;        // 操作注意事项
      storagePrecautions?: string;         // 储存注意事项
      optimalTemperature?: string;         // 最佳储存温度
      temperatureRange?: string;           // 储存温度范围
      humidityRequirements?: string;       // 湿度要求
      storageContainer?: string;           // 储存容器要求
      incompatibleMaterials?: string;      // 不相容的物质
      storageAreaRequirements?: string;    // 储存区域要求
      shelfLife?: string;                  // 保质期
    };

    /** MSDS接触控制/个体防护类型 */
    type MsdsExposureControl = {
      id?: number;
      msdsId: number;
      occupationalExposureLimit?: string; // 职业接触限值
      chinaMac?: string;                   // 中国MAC值(mg/m³)
      usaTlvTwa?: string;                  // 美国TLV-TWA值(mg/m³)
      usaTlvStel?: string;                 // 美国TLV-STEL值(mg/m³)
      formerSovietMac?: string;            // 前苏联MAC值(mg/m³)
      tlvTn?: string;                      // TLV-TN值(mg/m³)
      tlvWn?: string;                      // TLV-WN值(mg/m³)
      monitoringMethod?: string;           // 监测方法
      engineeringControls?: string;        // 工程控制措施
      respiratoryProtection?: string;      // 呼吸系统防护
      eyeProtection?: string;              // 眼睛防护
      bodyProtection?: string;             // 身体防护
      handProtection?: string;             // 手部防护
      otherProtection?: string;            // 其他防护措施
      hygieneMeasures?: string;            // 卫生措施
    };

    /** MSDS理化特性类型 */
    type MsdsPhysicalChemical = {
      id?: number;
      msdsId: number;
      appearance?: string;                 // 外观与性状
      odor?: string;                       // 气味
      odorThreshold?: string;              // 气味阈值
      meltingPoint?: string;               // 熔点(℃)
      boilingPoint?: string;               // 沸点(℃)
      relativeDensity?: string;            // 相对密度(水=1)
      vaporDensity?: string;               // 蒸气密度(空气=1)
      vaporPressure?: string;              // 蒸气压(kPa)
      vaporPressureTemp?: string;          // 蒸气压测定温度(℃)
      solubility?: string;                 // 溶解性
      waterSolubility?: string;            // 水中溶解度
      phValue?: string;                    // pH值
      phConcentration?: string;            // pH值浓度条件
      flashPoint?: string;                 // 闪点(℃)
      ignitionTemperature?: string;        // 引燃温度(℃)
      explosiveLimitLower?: string;        // 爆炸下限(%)
      explosiveLimitUpper?: string;        // 爆炸上限(%)
      viscosity?: string;                  // 粘度
      partitionCoefficient?: string;       // 分配系数(正辛醇/水)
      decompositionTemperature?: string;   // 分解温度(℃)
      molecularFormula?: string;           // 分子式
      mainComponents?: string;             // 主要成分
      criticalTemperature?: string;        // 临界温度(℃)
      autoignitionTemperature?: string;    // 自燃温度
      flammability?: string;               // 燃烧性
      molecularWeight?: string;            // 分子量
      heatOfCombustion?: string;           // 燃烧热(kJ/mol)
      criticalPressure?: string;           // 临界压力(MPa)
      mainUsage?: string;                  // 主要用途
      otherProperties?: string;            // 其它理化性质
    };

    /** MSDS稳定性和反应性类型 */
    type MsdsStabilityReactivity = {
      id?: number;
      msdsId: number;
      stability?: string;                  // 稳定性
      reactivity?: string;                 // 反应性
      incompatibleSubstances?: string;     // 禁配物
      conditionsToAvoid?: string;          // 避免接触的条件
      hazardousReactions?: string;         // 可能的危险反应
      polymerizationHazard?: string;       // 聚合危害
      polymerizationConditions?: string;   // 聚合反应条件
      decompositionProducts?: string;      // 分解产物
      decompositionConditions?: string;    // 分解条件
    };

    /** MSDS毒理学资料类型 */
    type MsdsToxicological = {
      id?: number;
      msdsId: number;
      acuteToxicity?: string;              // 急性毒性
      ld50Oral?: string;                   // LD50(经口,大鼠)
      ld50Dermal?: string;                 // LD50(经皮,兔)
      lc50Inhalation?: string;             // LC50(吸入,大鼠)
      subacuteChronic?: string;            // 亚急性和慢性毒性
      skinIrritation?: string;             // 皮肤刺激性
      eyeIrritation?: string;              // 眼睛刺激性
      respiratoryIrritation?: string;      // 呼吸道刺激性
      sensitization?: string;              // 致敏性
      mutagenicity?: string;               // 致突变性
      teratogenicity?: string;             // 致畸性
      reproductiveToxicity?: string;       // 生殖毒性
      carcinogenicity?: string;            // 致癌性
      carcinogenClassification?: string;   // 致癌物分类
      specificTargetOrgan?: string;        // 特定目标器官毒性
      aspirationHazard?: string;           // 吸入危害
      otherToxicity?: string;              // 其他毒理学资料
      rtecs?: string;                      // RTECS编号
    };

    /** MSDS运输信息类型 */
    type MsdsTransportation = {
      id?: number;
      msdsId: number;
      dangerousGoodsNumber?: string;       // 危险货物编号
      unNumber?: string;                   // UN编号
      properShippingName?: string;         // 正确运输名称
      transportHazardClass?: string;       // 运输危险类别
      packingGroup?: string;               // 包装类别
      packagingMarks?: string;             // 包装标志
      packagingMethod?: string;            // 包装方法
      marinePollutant?: number;            // 海洋污染物(1:是,0:否)
      transportInBulk?: string;            // 散装运输要求
      transportationPrecautions?: string;  // 运输注意事项
      emergencyResponseGuide?: string;     // 应急响应指南编号
      imdgRulePage?: string;               // IMDG规则页码
    };

    /** MSDS生态学资料类型 */
    type MsdsEcological = {
      id?: number;
      msdsId: number;
      ecologicalToxicity?: string;         // 生态毒性
      fishToxicity?: string;               // 鱼类毒性
      invertebrateToxicity?: string;       // 无脊椎动物毒性
      algaeToxicity?: string;              // 藻类毒性
      bacteriaToxicity?: string;           // 细菌毒性
      biodegradability?: string;           // 生物降解性
      biodegradationRate?: string;         // 生物降解速率
      nonBiodegradability?: string;        // 非生物降解性
      photodegradation?: string;           // 光降解
      hydrolysis?: string;                 // 水解
      bioaccumulation?: string;            // 生物富集或生物积累性
      bioconcentrationFactor?: string;     // 生物富集因子
      mobilityInSoil?: string;             // 土壤中迁移性
      otherEnvironmentalEffects?: string;  // 其它有害作用
      ozoneDepletionPotential?: string;    // 臭氧消耗潜能值
      globalWarmingPotential?: string;     // 全球变暖潜能值
    };

    /** MSDS废弃处置类型 */
    type MsdsDisposal = {
      id?: number;
      msdsId: number;
      wasteProperties?: string;            // 废弃物性质
      disposalMethod?: string;             // 废弃处置方法
      disposalPrecautions?: string;        // 废弃注意事项
      disposalRegulations?: string;        // 废弃处置相关法规
      containerDisposal?: string;          // 包装容器的处置
      recommendedDisposal?: string;        // 推荐的处置方法
      prohibitedDisposal?: string;         // 禁止的处置方法
      neutralizationMethod?: string;       // 中和处理方法
    };

    /** MSDS法规信息类型 */
    type MsdsRegulatory = {
      id?: number;
      msdsId: number;
      regulatoryInfo?: string;             // 法规信息综述
      domesticRegulations?: string;        // 国内法规
      internationalRegulations?: string;   // 国际法规
      chinaDangerousChemicals?: number;    // 中国危险化学品目录(1:是,0:否)
      chinaControlledChemicals?: number;   // 中国管制化学品(1:是,0:否)
      reachRegistration?: string;          // REACH注册情况
      tscaInventory?: number;              // TSCA清单(1:在列,0:不在列)
      einecsNumber?: string;               // EINECS号
      prohibitedRestricted?: string;       // 禁用/限用情况
      specialProvisions?: string;          // 特殊规定
    };

    /** MSDS其他信息类型 */
    type MsdsOtherInfo = {
      id?: number;
      msdsId: number;
      references?: string;                 // 参考文献
      dataSources?: string;                // 数据来源
      formFillTime?: string;               // 填表时间
      formFillDepartment?: string;         // 填表部门
      formFillPerson?: string;             // 填表人
      dataAuditUnit?: string;              // 数据审核单位
      dataAuditPerson?: string;            // 数据审核人
      technicalReviewPerson?: string;      // 技术审查人
      modificationNotes?: string;          // 修改说明
      trainingRequirements?: string;       // 培训要求
      additionalInformation?: string;      // 其他信息
      disclaimer?: string;                 // 免责声明
    };

    /** MSDS完整详情类型 */
    type MsdsDetail = {
      main: MsdsMain;
      hazard?: MsdsHazard;
      components?: MsdsComponent[];
      firstAid?: MsdsFirstAid;
      fireFighting?: MsdsFireFighting;
      leakResponse?: MsdsLeakResponse;
      handlingStorage?: MsdsHandlingStorage;
      exposureControl?: MsdsExposureControl;
      physicalChemical?: MsdsPhysicalChemical;
      stabilityReactivity?: MsdsStabilityReactivity;
      toxicological?: MsdsToxicological;
      ecological?: MsdsEcological;
      disposal?: MsdsDisposal;
      transportation?: MsdsTransportation;
      regulatory?: MsdsRegulatory;
      otherInfo?: MsdsOtherInfo;
    };

    /** AI 解析结果 VO */
    type MsdsParseVo = {
      chemicalNameCn?: string;
      chemicalNameEn?: string;
      casNo?: string;
      supplierName?: string;
      emergencyPhone?: string;
      formula?: string;
      hazardCategories?: string[];
      hazardStatements?: string[];
      precautionaryStatements?: string[];
      confidence?: number;
      rawTextSummary?: string;
    };
  }
} 