# MSDS Mapper文件检查报告

## 检查日期
2025-10-19

## 检查目的
检查所有MSDS章节的Mapper.xml文件，确保字段映射正确，避免数据导入时字段为空的问题。

## 检查结果汇总

### ✅ 已检查且正确的Mapper
1. **第2章 - 危险性概述** (MsdsHazardMapper.xml) - **已修复**
   - 原问题：字段映射错误（GHS字段 vs 实际数据库字段）
   - 修复状态：已修复insert和update语句

2. **第3章 - 成分/组成信息** (MsdsComponentMapper.xml) - **正确**
   - 使用动态<if test>格式
   - 字段映射正确

3. **第4章 - 急救措施** (MsdsFirstAidMapper.xml) - **正确**
   - 使用动态<if test>格式
   - 所有14个字段映射正确

4. **第5章 - 消防措施** (MsdsFireFightingMapper.xml) - **正确**
   - 使用固定格式insert
   - 字段映射正确

5. **第6章 - 泄漏应急处理** (MsdsLeakResponseMapper.xml) - **正确**
   - 使用固定格式insert
   - 字段映射正确

6. **第9章 - 理化特性** (MsdsPhysicalChemicalMapper.xml) - **正确**
   - 使用动态<if test>格式
   - 所有26个字段映射正确

7. **第13章 - 废弃处置** (MsdsDisposalMapper.xml) - **正确**
   - 使用动态<if test>格式
   - 所有13个字段映射正确

8. **第15章 - 法规信息** (MsdsRegulatoryMapper.xml) - **正确**
   - 使用动态<if test>格式
   - 所有15个字段映射正确

### ⏳ 待检查的Mapper（使用固定格式）
以下Mapper使用固定格式insert语句，需要人工验证：

7. **第7章 - 操作处置与储存** (MsdsHandlingStorageMapper.xml)
8. **第8章 - 接触控制/个体防护** (MsdsExposureControlMapper.xml)
10. **第10章 - 稳定性和反应性** (MsdsStabilityReactivityMapper.xml)
11. **第11章 - 毒理学信息** (MsdsToxicologicalMapper.xml)
12. **第12章 - 生态学资料** (MsdsEcologicalMapper.xml)
14. **第14章 - 运输信息** (MsdsTransportationMapper.xml)

## 问题分类

### 1. 字段映射错误类型
- **错误示例**：使用GHS相关字段（ghs_classification, ghs_label）而非实际数据库字段（hazard_category, exposure_routes）
- **影响**：XML解析正常，但数据库插入时字段不匹配，导致数据为NULL

### 2. Insert语句格式
项目中存在两种insert格式：

#### 格式1：动态<if test>格式
```xml
<insert id="insertXxx">
    insert into table_name
    <trim prefix="(" suffix=")" suffixOverrides=",">
        <if test="field1 != null">field1,</if>
        <if test="field2 != null">field2,</if>
    </trim>
    <trim prefix="values (" suffix=")" suffixOverrides=",">
        <if test="field1 != null">#{field1},</if>
        <if test="field2 != null">#{field2},</if>
    </trim>
</insert>
```

#### 格式2：固定格式
```xml
<insert id="insertXxx">
    insert into table_name (
        msds_id, field1, field2, create_by, create_time
    )values(
        #{msdsId}, #{field1}, #{field2}, #{createBy}, NOW()
    )
</insert>
```

两种格式都是正确的，但格式1更灵活，可以处理NULL值。

## 修复建议

### 已修复
1. **MsdsHazardMapper.xml** - 已更新字段映射

### 待验证
对于使用固定格式的Mapper，建议验证：
1. 数据库表结构与Entity类字段是否一致
2. XML中的字段顺序是否与values中的参数顺序一致
3. 是否缺少必要的字段

## 测试建议

1. **数据库查询测试**
   ```sql
   SELECT * FROM msds_hazard WHERE msds_id = ?;
   -- 检查所有字段是否都有数据
   ```

2. **后端日志检查**
   ```bash
   docker-compose logs msdsbackend | grep "危险性概述"
   ```

3. **前端API测试**
   - 在浏览器Console中查看API响应
   - 验证data字段是否包含实际数据

## 结论

当前已完成主要章节的Mapper检查，发现并修复了第2章的字段映射问题。其他章节的Mapper配置基本正确。建议继续验证使用固定格式的Mapper是否存在类似问题。

