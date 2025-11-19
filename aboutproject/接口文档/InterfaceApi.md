# MSDS管理系统接口文档

## 文档说明

本文档详细描述了MSDS（Material Safety Data Sheet）管理系统的所有API接口，包括请求参数、响应格式、错误处理和使用示例。

### 基础信息

- **API版本**: v1.0
- **基础URL**: `http://localhost:8080`
- **数据格式**: JSON
- **字符编码**: UTF-8
- **认证方式**: JWT Token

### 通用响应格式

#### 成功响应
```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {}
}
```

#### 分页响应
```json
{
  "code": 200,
  "msg": "查询成功",
  "total": 100,
  "rows": []
}
```

#### 错误响应
```json
{
  "code": 500,
  "msg": "操作失败",
  "data": null
}
```

### 错误码说明

| 错误码 | 说明 | 描述 |
| --- | --- | --- |
| 200 | 成功 | 请求处理成功 |
| 400 | 请求错误 | 请求参数有误 |
| 401 | 未授权 | 用户未登录或token无效 |
| 403 | 禁止访问 | 用户权限不足 |
| 404 | 资源不存在 | 请求的资源不存在 |
| 500 | 服务器错误 | 服务器内部错误 |

### 权限说明

- `system:msds:list` - 查看MSDS列表权限
- `system:msds:query` - 查看MSDS详情权限
- `system:msds:add` - 新增MSDS权限
- `system:msds:edit` - 修改MSDS权限
- `system:msds:remove` - 删除MSDS权限
- `system:msds:export` - 导出MSDS权限
- `system:msds:import` - 导入MSDS权限

### 分页参数说明

| 参数名 | 类型 | 默认值 | 描述 |
| --- | --- | --- | --- |
| `pageNum` | `integer` | 1 | 当前页码，从1开始 |
| `pageSize` | `integer` | 10 | 每页记录数，最大100 |

---

## 1. MSDS主信息管理 (`/system/msds`)

### 数据模型

#### MsdsMain 对象
```json
{
  "id": 1,
  "productName": "硫酸",
  "productNameEn": "Sulfuric acid",
  "casNo": "7664-93-9",
  "molecularFormula": "H2SO4",
  "molecularWeight": "98.08",
  "manufacturer": "某化工有限公司",
  "supplierName": "某供应商",
  "supplierPhone": "400-123-4567",
  "emergencyPhone": "400-999-8888",
  "recommendedUse": "工业用酸",
  "restrictedUse": "禁止食用",
  "version": "1.0",
  "revisionDate": "2024-01-01",
  "status": "1",
  "createTime": "2024-01-01 10:00:00",
  "updateTime": "2024-01-01 10:00:00"
}
```

### 1.1 获取MSDS主信息列表

- **URL**: `/system/msds/list`
- **Method**: `GET`
- **权限**: `system:msds:list`
- **描述**: 获取MSDS主信息列表，支持分页和条件查询。

#### 请求参数

| 参数名 | 类型 | 是否必填 | 默认值 | 描述 | 示例 |
| --- | --- | --- | --- | --- | --- |
| `pageNum` | `integer` | 否 | 1 | 当前页码 | 1 |
| `pageSize` | `integer` | 否 | 10 | 每页数量 | 20 |
| `productName` | `string` | 否 | - | 化学品名称（模糊查询） | "硫酸" |
| `casNo` | `string` | 否 | - | CAS号（精确查询） | "7664-93-9" |
| `manufacturer` | `string` | 否 | - | 生产厂商（模糊查询） | "某化工" |
| `status` | `string` | 否 | - | 状态（0-停用，1-正常） | "1" |
| `startDate` | `string` | 否 | - | 创建开始日期 | "2024-01-01" |
| `endDate` | `string` | 否 | - | 创建结束日期 | "2024-12-31" |

#### 请求示例
```bash
GET /system/msds/list?pageNum=1&pageSize=10&productName=硫酸&status=1
```

#### 响应示例
```json
{
  "code": 200,
  "msg": "查询成功",
  "total": 50,
  "rows": [
    {
      "id": 1,
      "productName": "硫酸",
      "productNameEn": "Sulfuric acid",
      "casNo": "7664-93-9",
      "molecularFormula": "H2SO4",
      "manufacturer": "某化工有限公司",
      "status": "1",
      "createTime": "2024-01-01 10:00:00"
    }
  ]
}
```

### 1.2 导出MSDS主信息列表

- **URL**: `/system/msds/export`
- **Method**: `POST`
- **权限**: `system:msds:export`
- **描述**: 将MSDS主信息列表导出为Excel文件。

#### 请求参数
请求参数与 `1.1 获取MSDS主信息列表` 相同。

#### 请求示例
```bash
POST /system/msds/export
Content-Type: application/json

{
  "productName": "硫酸",
  "status": "1"
}
```

#### 响应
- **Content-Type**: `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet`
- **Content-Disposition**: `attachment; filename="msds_export_20240101.xlsx"`

### 1.3 根据ID获取MSDS详细信息

- **URL**: `/system/msds/{id}`
- **Method**: `GET`
- **权限**: `system:msds:query`
- **描述**: 根据MSDS的ID获取详细信息。

#### 路径参数

| 参数名 | 类型 | 描述 | 示例 |
| --- | --- | --- | --- |
| `id` | `long` | MSDS主键ID | 1 |

#### 请求示例
```bash
GET /system/msds/1
```

#### 响应示例
```json
{
  "code": 200,
  "msg": "查询成功",
  "data": {
    "id": 1,
    "productName": "硫酸",
    "productNameEn": "Sulfuric acid",
    "casNo": "7664-93-9",
    "molecularFormula": "H2SO4",
    "molecularWeight": "98.08",
    "manufacturer": "某化工有限公司",
    "supplierName": "某供应商",
    "supplierPhone": "400-123-4567",
    "emergencyPhone": "400-999-8888",
    "recommendedUse": "工业用酸",
    "restrictedUse": "禁止食用",
    "version": "1.0",
    "revisionDate": "2024-01-01",
    "status": "1",
    "createTime": "2024-01-01 10:00:00",
    "updateTime": "2024-01-01 10:00:00"
  }
}
```

### 1.4 新增MSDS主信息

- **URL**: `/system/msds`
- **Method**: `POST`
- **权限**: `system:msds:add`
- **描述**: 新增一条MSDS主信息。

#### 请求体

| 字段名 | 类型 | 是否必填 | 描述 | 示例 |
| --- | --- | --- | --- | --- |
| `productName` | `string` | 是 | 化学品名称 | "硫酸" |
| `productNameEn` | `string` | 否 | 化学品英文名称 | "Sulfuric acid" |
| `casNo` | `string` | 是 | CAS号 | "7664-93-9" |
| `molecularFormula` | `string` | 否 | 分子式 | "H2SO4" |
| `molecularWeight` | `string` | 否 | 分子量 | "98.08" |
| `manufacturer` | `string` | 是 | 生产厂商 | "某化工有限公司" |
| `supplierName` | `string` | 否 | 供应商名称 | "某供应商" |
| `supplierPhone` | `string` | 否 | 供应商电话 | "400-123-4567" |
| `emergencyPhone` | `string` | 否 | 应急电话 | "400-999-8888" |
| `recommendedUse` | `string` | 否 | 推荐用途 | "工业用酸" |
| `restrictedUse` | `string` | 否 | 限制用途 | "禁止食用" |
| `version` | `string` | 否 | 版本号 | "1.0" |
| `revisionDate` | `string` | 否 | 修订日期 | "2024-01-01" |

#### 请求示例
```bash
POST /system/msds
Content-Type: application/json

{
  "productName": "硫酸",
  "productNameEn": "Sulfuric acid",
  "casNo": "7664-93-9",
  "molecularFormula": "H2SO4",
  "molecularWeight": "98.08",
  "manufacturer": "某化工有限公司",
  "supplierName": "某供应商",
  "supplierPhone": "400-123-4567",
  "emergencyPhone": "400-999-8888",
  "recommendedUse": "工业用酸",
  "restrictedUse": "禁止食用",
  "version": "1.0",
  "revisionDate": "2024-01-01"
}
```

#### 响应示例
```json
{
  "code": 200,
  "msg": "新增成功",
  "data": {
    "id": 1
  }
}
```

### 1.5 修改MSDS主信息

- **URL**: `/system/msds`
- **Method**: `PUT`
- **权限**: `system:msds:edit`
- **描述**: 修改一条MSDS主信息。

#### 请求体
请求体与新增接口相同，但必须包含 `id` 字段。

#### 请求示例
```bash
PUT /system/msds
Content-Type: application/json

{
  "id": 1,
  "productName": "硫酸（修改）",
  "productNameEn": "Sulfuric acid",
  "casNo": "7664-93-9",
  "molecularFormula": "H2SO4",
  "molecularWeight": "98.08",
  "manufacturer": "某化工有限公司",
  "version": "1.1"
}
```

#### 响应示例
```json
{
  "code": 200,
  "msg": "修改成功",
  "data": null
}
```

### 1.6 删除MSDS主信息

- **URL**: `/system/msds/{ids}`
- **Method**: `DELETE`
- **权限**: `system:msds:remove`
- **描述**: 删除一条或多条MSDS主信息。

#### 路径参数

| 参数名 | 类型 | 描述 | 示例 |
| --- | --- | --- | --- |
| `ids` | `string` | MSDS主键ID，多个用逗号分隔 | "1,2,3" |

#### 请求示例
```bash
DELETE /system/msds/1,2,3
```

#### 响应示例
```json
{
  "code": 200,
  "msg": "删除成功",
  "data": null
}
```

### 1.7 导入MSDS文档

- **URL**: `/system/msds/import`
- **Method**: `POST`
- **权限**: `system:msds:import`
- **描述**: 批量导入MSDS文档。

#### 请求参数

| 参数名 | 类型 | 是否必填 | 描述 |
| --- | --- | --- | --- |
| `files` | `MultipartFile[]` | 是 | 要导入的Excel文件 |
| `overwriteDuplicates` | `boolean` | 否 | 是否覆盖重复数据（默认false） |

#### 请求示例
```bash
POST /system/msds/import
Content-Type: multipart/form-data

--boundary
Content-Disposition: form-data; name="files"; filename="msds_import.xlsx"
Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet

[Excel文件内容]
--boundary
Content-Disposition: form-data; name="overwriteDuplicates"

true
--boundary--
```

#### 响应示例
```json
{
  "code": 200,
  "msg": "导入成功",
  "data": {
    "total": 100,
    "success": 95,
    "failed": 5,
    "errors": [
      {
        "row": 10,
        "message": "CAS号格式不正确"
      }
    ]
  }
}
```

### 1.8 下载MSDS导入模板

- **URL**: `/system/msds/export/template`
- **Method**: `GET`
- **描述**: 下载MSDS导入模板

#### 请求示例
```bash
GET /system/msds/export/template
```

#### 响应
- **Content-Type**: `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet`
- **Content-Disposition**: `attachment; filename="msds_import_template.xlsx"`

---

## 2. MSDS成分/组成信息管理 (`/system/component`)

### 数据模型

#### MsdsComponent 对象
```json
{
  "id": 1,
  "msdsId": 1,
  "componentName": "硫酸",
  "casNo": "7664-93-9",
  "concentration": "98%",
  "concentrationRange": "95-99%",
  "hazardClassification": "腐蚀性物质",
  "hazardStatement": "造成严重皮肤灼伤和眼损伤",
  "precautionaryStatement": "穿戴防护手套/防护服/防护眼镜",
  "createTime": "2024-01-01 10:00:00",
  "updateTime": "2024-01-01 10:00:00"
}
```

### 2.1 查询成分/组成信息列表

- **URL**: `/system/component/list`
- **Method**: `GET`
- **权限**: `system:component:list`
- **描述**: 查询成分/组成信息列表，支持分页和条件查询。

#### 请求参数

| 参数名 | 类型 | 是否必填 | 默认值 | 描述 | 示例 |
| --- | --- | --- | --- | --- | --- |
| `pageNum` | `integer` | 否 | 1 | 当前页码 | 1 |
| `pageSize` | `integer` | 否 | 10 | 每页数量 | 20 |
| `msdsId` | `long` | 否 | - | MSDS主表ID | 1 |
| `componentName` | `string` | 否 | - | 成分名称（模糊查询） | "硫酸" |
| `casNo` | `string` | 否 | - | CAS号（精确查询） | "7664-93-9" |

#### 请求示例
```bash
GET /system/component/list?pageNum=1&pageSize=10&msdsId=1
```

#### 响应示例
```json
{
  "code": 200,
  "msg": "查询成功",
  "total": 5,
  "rows": [
    {
      "id": 1,
      "msdsId": 1,
      "componentName": "硫酸",
      "casNo": "7664-93-9",
      "concentration": "98%",
      "hazardClassification": "腐蚀性物质",
      "createTime": "2024-01-01 10:00:00"
    }
  ]
}
```

### 2.2 导出成分/组成信息列表

- **URL**: `/system/component/export`
- **Method**: `POST`
- **权限**: `system:component:export`
- **描述**: 将成分/组成信息列表导出为Excel文件。

#### 请求参数
请求参数与 `2.1 查询成分/组成信息列表` 相同。

### 2.3 获取成分/组成信息详细信息

- **URL**: `/system/component/{id}`
- **Method**: `GET`
- **权限**: `system:component:query`
- **描述**: 根据ID获取成分/组成信息详细信息。

#### 路径参数

| 参数名 | 类型 | 描述 | 示例 |
| --- | --- | --- | --- |
| `id` | `long` | 成分/组成信息ID | 1 |

### 2.4 根据MSDS主表ID获取成分/组成信息

- **URL**: `/system/component/msds/{msdsId}`
- **Method**: `GET`
- **权限**: `system:component:query`
- **描述**: 根据MSDS主表ID获取所有相关的成分/组成信息。

#### 路径参数

| 参数名 | 类型 | 描述 | 示例 |
| --- | --- | --- | --- |
| `msdsId` | `long` | MSDS主表ID | 1 |

#### 请求示例
```bash
GET /system/component/msds/1
```

#### 响应示例
```json
{
  "code": 200,
  "msg": "查询成功",
  "data": [
    {
      "id": 1,
      "msdsId": 1,
      "componentName": "硫酸",
      "casNo": "7664-93-9",
      "concentration": "98%",
      "concentrationRange": "95-99%",
      "hazardClassification": "腐蚀性物质",
      "hazardStatement": "造成严重皮肤灼伤和眼损伤",
      "precautionaryStatement": "穿戴防护手套/防护服/防护眼镜"
    }
  ]
}
```

### 2.5 新增成分/组成信息

- **URL**: `/system/component`
- **Method**: `POST`
- **权限**: `system:component:add`
- **描述**: 新增一条成分/组成信息。

#### 请求体

| 字段名 | 类型 | 是否必填 | 描述 | 示例 |
| --- | --- | --- | --- | --- |
| `msdsId` | `long` | 是 | MSDS主表ID | 1 |
| `componentName` | `string` | 是 | 成分名称 | "硫酸" |
| `casNo` | `string` | 否 | CAS号 | "7664-93-9" |
| `concentration` | `string` | 否 | 浓度 | "98%" |
| `concentrationRange` | `string` | 否 | 浓度范围 | "95-99%" |
| `hazardClassification` | `string` | 否 | 危险性分类 | "腐蚀性物质" |
| `hazardStatement` | `string` | 否 | 危险性说明 | "造成严重皮肤灼伤和眼损伤" |
| `precautionaryStatement` | `string` | 否 | 预防措施说明 | "穿戴防护手套/防护服/防护眼镜" |

### 2.6 修改成分/组成信息

- **URL**: `/system/component`
- **Method**: `PUT`
- **权限**: `system:component:edit`
- **描述**: 修改一条成分/组成信息。

### 2.7 删除成分/组成信息

- **URL**: `/system/component/{ids}`
- **Method**: `DELETE`
- **权限**: `system:component:remove`
- **描述**: 删除一条或多条成分/组成信息。

### 2.8 根据MSDS主表ID删除成分/组成信息

- **URL**: `/system/component/msds/{msdsId}`
- **Method**: `DELETE`
- **权限**: `system:component:remove`
- **描述**: 根据MSDS主表ID删除所有相关的成分/组成信息。

---

## 3. MSDS危险性概述管理 (`/system/hazard`)

### 数据模型

#### MsdsHazard 对象
```json
{
  "id": 1,
  "msdsId": 1,
  "ghsClassification": "腐蚀性物质类别1",
  "hazardStatement": "H314: 造成严重皮肤灼伤和眼损伤",
  "precautionaryStatement": "P280: 戴防护手套/穿防护服/戴防护眼镜/戴防护面具",
  "signalWord": "危险",
  "hazardPictogram": "GHS05",
  "physicalHazards": "无特殊物理危险",
  "healthHazards": "腐蚀性，可造成严重皮肤灼伤",
  "environmentalHazards": "对水生环境有害",
  "specificTargetOrgan": "皮肤、眼睛、呼吸系统",
  "createTime": "2024-01-01 10:00:00",
  "updateTime": "2024-01-01 10:00:00"
}
```

### 3.1 查询危险性概述列表

- **URL**: `/system/hazard/list`
- **Method**: `GET`
- **权限**: `system:hazard:list`
- **描述**: 查询危险性概述列表，支持分页和条件查询。

### 3.2 导出危险性概述列表

- **URL**: `/system/hazard/export`
- **Method**: `POST`
- **权限**: `system:hazard:export`
- **描述**: 将危险性概述列表导出为Excel文件。

### 3.3 获取危险性概述详细信息

- **URL**: `/system/hazard/{id}`
- **Method**: `GET`
- **权限**: `system:hazard:query`
- **描述**: 根据ID获取危险性概述详细信息。

### 3.4 根据MSDS主表ID获取危险性概述

- **URL**: `/system/hazard/msds/{msdsId}`
- **Method**: `GET`
- **权限**: `system:hazard:query`
- **描述**: 根据MSDS主表ID获取危险性概述信息。

### 3.5 新增危险性概述

- **URL**: `/system/hazard`
- **Method**: `POST`
- **权限**: `system:hazard:add`
- **描述**: 新增一条危险性概述信息。

### 3.6 修改危险性概述

- **URL**: `/system/hazard`
- **Method**: `PUT`
- **权限**: `system:hazard:edit`
- **描述**: 修改一条危险性概述信息。

### 3.7 删除危险性概述

- **URL**: `/system/hazard/{ids}`
- **Method**: `DELETE`
- **权限**: `system:hazard:remove`
- **描述**: 删除一条或多条危险性概述信息。

### 3.8 根据MSDS主表ID删除危险性概述

- **URL**: `/system/hazard/msds/{msdsId}`
- **Method**: `DELETE`
- **权限**: `system:hazard:remove`
- **描述**: 根据MSDS主表ID删除危险性概述信息。

---

## 4. MSDS急救措施管理 (`/system/firstAid`)

### 数据模型

#### MsdsFirstAid 对象
```json
{
  "id": 1,
  "msdsId": 1,
  "inhalationFirstAid": "立即将患者移至新鲜空气处，保持呼吸道通畅",
  "skinContactFirstAid": "立即脱去污染的衣着，用大量流动清水冲洗",
  "eyeContactFirstAid": "立即提起眼睑，用大量流动清水或生理盐水彻底冲洗",
  "ingestionFirstAid": "用水漱口，给饮牛奶或蛋清",
  "mostImportantSymptoms": "灼伤、呼吸困难、眼部刺激",
  "immediateAttention": "如有不适感，立即就医",
  "specialTreatment": "无特殊治疗方法",
  "antidoteInfo": "无特效解毒剂",
  "createTime": "2024-01-01 10:00:00",
  "updateTime": "2024-01-01 10:00:00"
}
```

### 4.1 查询急救措施列表

- **URL**: `/system/firstAid/list`
- **Method**: `GET`
- **权限**: `system:firstAid:list`
- **描述**: 查询急救措施列表，支持分页和条件查询。

### 4.2 导出急救措施列表

- **URL**: `/system/firstAid/export`
- **Method**: `POST`
- **权限**: `system:firstAid:export`
- **描述**: 将急救措施列表导出为Excel文件。

### 4.3 获取急救措施详细信息

- **URL**: `/system/firstAid/{id}`
- **Method**: `GET`
- **权限**: `system:firstAid:query`
- **描述**: 根据ID获取急救措施详细信息。

### 4.4 根据MSDS主表ID获取急救措施

- **URL**: `/system/firstAid/msds/{msdsId}`
- **Method**: `GET`
- **权限**: `system:firstAid:query`
- **描述**: 根据MSDS主表ID获取急救措施信息。

### 4.5 新增急救措施

- **URL**: `/system/firstAid`
- **Method**: `POST`
- **权限**: `system:firstAid:add`
- **描述**: 新增一条急救措施信息。

### 4.6 修改急救措施

- **URL**: `/system/firstAid`
- **Method**: `PUT`
- **权限**: `system:firstAid:edit`
- **描述**: 修改一条急救措施信息。

### 4.7 删除急救措施

- **URL**: `/system/firstAid/{ids}`
- **Method**: `DELETE`
- **权限**: `system:firstAid:remove`
- **描述**: 删除一条或多条急救措施信息。

### 4.8 根据MSDS主表ID删除急救措施

- **URL**: `/system/firstAid/msds/{msdsId}`
- **Method**: `DELETE`
- **权限**: `system:firstAid:remove`
- **描述**: 根据MSDS主表ID删除急救措施信息。

---

## 5. MSDS消防措施管理 (`/system/fireFighting`)

### 数据模型

#### MsdsFireFighting 对象
```json
{
  "id": 1,
  "msdsId": 1,
  "suitableExtinguishingMedia": "雾状水、泡沫、干粉、二氧化碳",
  "unsuitableExtinguishingMedia": "直流水",
  "specificHazards": "受热分解产生有毒的硫氧化物气体",
  "specialProtectiveEquipment": "消防人员须佩戴防毒面具、穿全身消防服",
  "specialFireFightingProcedures": "从上风向灭火，尽可能将容器从火场移至空旷处",
  "combustionProducts": "硫氧化物",
  "autoIgnitionTemperature": "不适用",
  "flashPoint": "不适用",
  "explosiveLimits": "不适用",
  "createTime": "2024-01-01 10:00:00",
  "updateTime": "2024-01-01 10:00:00"
}
```

---

## 6. MSDS泄漏应急处理管理 (`/system/spillage`)

### 数据模型

#### MsdsSpillage 对象
```json
{
  "id": 1,
  "msdsId": 1,
  "personalPrecautions": "建议应急处理人员戴防毒面具，穿防酸碱工作服",
  "environmentalPrecautions": "收集泄漏物，避免排入下水道、地表水和地下水",
  "containmentMethods": "用砂土、干燥石灰或苏打灰混合吸收",
  "cleanupMethods": "收集于干燥、洁净、有盖的容器中",
  "emergencyProcedures": "迅速撤离泄漏污染区人员至安全区",
  "preventSecondaryHazards": "防止泄漏物进入下水道、地表水和地下水",
  "createTime": "2024-01-01 10:00:00",
  "updateTime": "2024-01-01 10:00:00"
}
```

---

## 7. MSDS操作处置与储存管理 (`/system/handlingStorage`)

### 数据模型

#### MsdsHandlingStorage 对象
```json
{
  "id": 1,
  "msdsId": 1,
  "handlingPrecautions": "密闭操作，注意通风。操作人员必须经过专门培训",
  "storagePrecautions": "储存于阴凉、通风的库房。远离火种、热源",
  "incompatibleMaterials": "碱类、金属粉末、易燃或可燃物",
  "storageTemperature": "常温",
  "storageHumidity": "干燥",
  "ventilationRequirements": "良好通风",
  "containerRequirements": "密闭容器",
  "specialRequirements": "远离不相容物质",
  "createTime": "2024-01-01 10:00:00",
  "updateTime": "2024-01-01 10:00:00"
}
```

---

## 8. MSDS接触控制/个体防护管理 (`/system/exposureControl`)

### 数据模型

#### MsdsExposureControl 对象
```json
{
  "id": 1,
  "msdsId": 1,
  "occupationalExposureLimit": "TWA: 1 mg/m³",
  "engineeringControls": "密闭操作，局部排风",
  "respiratoryProtection": "空气中浓度超标时，佩戴自吸过滤式防毒面具",
  "handProtection": "戴橡胶耐酸碱手套",
  "eyeProtection": "戴化学安全防护眼镜",
  "skinProtection": "穿橡胶耐酸碱服",
  "hygieneMeasures": "工作完毕，淋浴更衣。保持良好的卫生习惯",
  "createTime": "2024-01-01 10:00:00",
  "updateTime": "2024-01-01 10:00:00"
}
```

---

## 9. MSDS理化特性管理 (`/system/physicalChemical`)

### 数据模型

#### MsdsPhysicalChemical 对象
```json
{
  "id": 1,
  "msdsId": 1,
  "appearance": "无色透明油状液体",
  "odor": "无气味",
  "ph": "<1",
  "meltingPoint": "10.31°C",
  "boilingPoint": "337°C",
  "flashPoint": "不适用",
  "evaporationRate": "<1",
  "flammability": "不燃",
  "explosiveLimits": "不适用",
  "vaporPressure": "<1 mmHg",
  "vaporDensity": ">1",
  "density": "1.84 g/cm³",
  "solubility": "与水混溶",
  "partitionCoefficient": "不适用",
  "autoIgnitionTemperature": "不适用",
  "decompositionTemperature": ">300°C",
  "viscosity": "26.7 cP",
  "createTime": "2024-01-01 10:00:00",
  "updateTime": "2024-01-01 10:00:00"
}
```

---

## 10. MSDS稳定性和反应性管理 (`/system/stabilityReactivity`)

### 数据模型

#### MsdsStabilityReactivity 对象
```json
{
  "id": 1,
  "msdsId": 1,
  "stability": "稳定",
  "reactivity": "与碱类、金属粉末剧烈反应",
  "incompatibleMaterials": "碱类、金属粉末、易燃或可燃物",
  "hazardousDecomposition": "硫氧化物",
  "conditionsToAvoid": "受热、接触不相容物质",
  "hazardousPolymerization": "不会发生",
  "createTime": "2024-01-01 10:00:00",
  "updateTime": "2024-01-01 10:00:00"
}
```

---

## 11. MSDS毒理学资料管理 (`/system/toxicological`)

### 数据模型

#### MsdsToxicological 对象
```json
{
  "id": 1,
  "msdsId": 1,
  "acuteToxicity": "LD50 (大鼠经口): 2140 mg/kg",
  "skinCorrosion": "引起严重皮肤灼伤",
  "eyeDamage": "引起严重眼损伤",
  "respiratorySensitization": "无数据",
  "skinSensitization": "无数据",
  "carcinogenicity": "无数据",
  "reproductiveToxicity": "无数据",
  "specificTargetOrgan": "皮肤、眼睛、呼吸系统",
  "aspirationHazard": "无数据",
  "createTime": "2024-01-01 10:00:00",
  "updateTime": "2024-01-01 10:00:00"
}
```

---

## 12. MSDS生态学资料管理 (`/system/ecological`)

### 数据模型

#### MsdsEcological 对象
```json
{
  "id": 1,
  "msdsId": 1,
  "ecotoxicity": "对水生生物有害",
  "persistence": "易生物降解",
  "bioaccumulation": "不易生物富集",
  "mobility": "在土壤中移动性强",
  "otherAdverseEffects": "无其他已知不良环境影响",
  "createTime": "2024-01-01 10:00:00",
  "updateTime": "2024-01-01 10:00:00"
}
```

---

## 13. MSDS废弃处置管理 (`/system/disposal`)

### 数据模型

#### MsdsDisposal 对象
```json
{
  "id": 1,
  "msdsId": 1,
  "wasteDisposalMethod": "建议用焚烧法处置",
  "containerDisposalMethod": "容器可能是危险的空容器",
  "precautionsForDisposal": "处置前应参阅国家和地方有关法规",
  "regulatoryRequirements": "按照国家和地方法规要求处置",
  "createTime": "2024-01-01 10:00:00",
  "updateTime": "2024-01-01 10:00:00"
}
```

---

## 14. MSDS运输信息管理 (`/system/transportation`)

### 数据模型

#### MsdsTransportation 对象
```json
{
  "id": 1,
  "msdsId": 1,
  "unNumber": "UN1830",
  "properShippingName": "硫酸",
  "hazardClass": "8",
  "packingGroup": "II",
  "marineTransport": "IMDG Code适用",
  "airTransport": "ICAO/IATA适用",
  "landTransport": "ADR/RID适用",
  "specialPrecautions": "运输时运输车辆应配备相应品种和数量的消防器材",
  "createTime": "2024-01-01 10:00:00",
  "updateTime": "2024-01-01 10:00:00"
}
```

---

## 15. MSDS法规信息管理 (`/system/regulatory`)

### 数据模型

#### MsdsRegulatory 对象
```json
{
  "id": 1,
  "msdsId": 1,
  "regulatoryInformation": "危险化学品安全管理条例",
  "inventoryStatus": "列入《危险化学品目录》",
  "restrictionsOnUse": "按照危险化学品管理",
  "otherRegulations": "工作场所有害因素职业接触限值",
  "createTime": "2024-01-01 10:00:00",
  "updateTime": "2024-01-01 10:00:00"
}
```

---

## 16. MSDS其他信息管理 (`/system/otherInfo`)

### 数据模型

#### MsdsOtherInfo 对象
```json
{
  "id": 1,
  "msdsId": 1,
  "preparationDate": "2024-01-01",
  "revisionDate": "2024-01-01",
  "revisionNumber": "1.0",
  "preparationInformation": "本SDS由技术部门编制",
  "disclaimerInformation": "本SDS的信息仅供参考",
  "referenceInformation": "参考相关法规和标准",
  "abbreviations": "CAS: Chemical Abstracts Service",
  "keyLiterature": "危险化学品安全技术说明书编写指南",
  "createTime": "2024-01-01 10:00:00",
  "updateTime": "2024-01-01 10:00:00"
}
```

---

## 17. MSDS标签信息管理 (`/system/label`)

### 数据模型

#### MsdsLabel 对象
```json
{
  "id": 1,
  "msdsId": 1,
  "productIdentifier": "硫酸",
  "supplierIdentification": "某化工有限公司",
  "hazardPictogram": "GHS05",
  "signalWord": "危险",
  "hazardStatement": "H314: 造成严重皮肤灼伤和眼损伤",
  "precautionaryStatement": "P280: 戴防护手套/穿防护服/戴防护眼镜",
  "supplementalInformation": "仅供工业使用",
  "createTime": "2024-01-01 10:00:00",
  "updateTime": "2024-01-01 10:00:00"
}
```

---

## 18. MSDS供应商信息管理 (`/system/supplier`)

### 数据模型

#### MsdsSupplier 对象
```json
{
  "id": 1,
  "msdsId": 1,
  "supplierName": "某化工有限公司",
  "supplierAddress": "某省某市某区某街道123号",
  "supplierPhone": "400-123-4567",
  "supplierFax": "021-12345678",
  "supplierEmail": "info@example.com",
  "emergencyPhone": "400-999-8888",
  "contactPerson": "张三",
  "contactPhone": "13800138000",
  "createTime": "2024-01-01 10:00:00",
  "updateTime": "2024-01-01 10:00:00"
}
```

---

## 19. MSDS统计报表管理 (`/system/report`)

### 19.1 获取综合统计信息

- **URL**: `/system/report/overview`
- **Method**: `GET`
- **权限**: `system:report:query`
- **描述**: 获取MSDS综合统计信息，包括总数、分类统计等。

#### 响应示例
```json
{
  "code": 200,
  "msg": "查询成功",
  "data": {
    "totalMsds": 1500,
    "activeMsds": 1450,
    "expiredMsds": 50,
    "categoryStats": {
      "腐蚀性物质": 300,
      "易燃液体": 250,
      "有毒物质": 200
    },
    "monthlyTrend": [
      {"month": "2024-01", "count": 100},
      {"month": "2024-02", "count": 120}
    ]
  }
}
```

### 19.2 获取数据趋势

- **URL**: `/system/report/trend`
- **Method**: `GET`
- **权限**: `system:report:query`
- **描述**: 获取MSDS数据趋势信息，支持时间范围查询。

#### 请求参数

| 参数名 | 类型 | 是否必填 | 描述 | 示例 |
| --- | --- | --- | --- | --- |
| `startDate` | `string` | 否 | 开始日期 | "2024-01-01" |
| `endDate` | `string` | 否 | 结束日期 | "2024-12-31" |
| `granularity` | `string` | 否 | 时间粒度（day/week/month） | "month" |

### 19.3 获取企业分布统计

- **URL**: `/system/report/companyDistribution`
- **Method**: `GET`
- **权限**: `system:report:query`
- **描述**: 获取企业分布统计信息。

### 19.4 获取化学品分类统计

- **URL**: `/system/report/categoryDistribution`
- **Method**: `GET`
- **权限**: `system:report:query`
- **描述**: 获取化学品分类统计信息。

### 19.5 获取操作活跃度统计

- **URL**: `/system/report/activityStats`
- **Method**: `GET`
- **权限**: `system:report:query`
- **描述**: 获取操作活跃度统计信息。

### 19.6 获取风险评估报告

- **URL**: `/system/report/riskAssessment`
- **Method**: `GET`
- **权限**: `system:report:query`
- **描述**: 获取风险评估报告。

---

## 20. MSDS操作审计日志管理 (`/system/auditLog`)

### 数据模型

#### MsdsAuditLog 对象
```json
{
  "id": 1,
  "msdsId": 1,
  "operationType": "CREATE",
  "operationDescription": "新增MSDS主信息",
  "operatorId": 1,
  "operatorName": "张三",
  "operationTime": "2024-01-01 10:00:00",
  "ipAddress": "192.168.1.100",
  "userAgent": "Mozilla/5.0...",
  "beforeData": null,
  "afterData": "{\"productName\":\"硫酸\"}",
  "result": "SUCCESS",
  "errorMessage": null,
  "createTime": "2024-01-01 10:00:00"
}
```

### 20.1 查询操作审计日志列表

- **URL**: `/system/auditLog/list`
- **Method**: `GET`
- **权限**: `system:auditLog:list`
- **描述**: 查询操作审计日志列表，支持分页和条件查询。

#### 请求参数

| 参数名 | 类型 | 是否必填 | 描述 | 示例 |
| --- | --- | --- | --- | --- |
| `pageNum` | `integer` | 否 | 当前页码 | 1 |
| `pageSize` | `integer` | 否 | 每页数量 | 20 |
| `msdsId` | `long` | 否 | MSDS主表ID | 1 |
| `operationType` | `string` | 否 | 操作类型 | "CREATE" |
| `operatorName` | `string` | 否 | 操作人员 | "张三" |
| `startDate` | `string` | 否 | 开始日期 | "2024-01-01" |
| `endDate` | `string` | 否 | 结束日期 | "2024-12-31" |
| `result` | `string` | 否 | 操作结果 | "SUCCESS" |

#### 响应示例
```json
{
  "code": 200,
  "msg": "查询成功",
  "total": 1000,
  "rows": [
    {
      "id": 1,
      "msdsId": 1,
      "operationType": "CREATE",
      "operationDescription": "新增MSDS主信息",
      "operatorName": "张三",
      "operationTime": "2024-01-01 10:00:00",
      "result": "SUCCESS"
    }
  ]
}
```

### 20.2 导出操作审计日志

- **URL**: `/system/auditLog/export`
- **Method**: `POST`
- **权限**: `system:auditLog:export`
- **描述**: 导出操作审计日志数据为Excel文件。

### 20.3 获取操作审计日志详细信息

- **URL**: `/system/auditLog/{logId}`
- **Method**: `GET`
- **权限**: `system:auditLog:query`
- **描述**: 根据日志ID获取操作审计日志详细信息。

### 20.4 新增操作审计日志

- **URL**: `/system/auditLog`
- **Method**: `POST`
- **权限**: `system:auditLog:add`
- **描述**: 新增一条操作审计日志（通常由系统自动记录）。

### 20.5 修改操作审计日志

- **URL**: `/system/auditLog`
- **Method**: `PUT`
- **权限**: `system:auditLog:edit`
- **描述**: 修改一条操作审计日志。

### 20.6 删除操作审计日志

- **URL**: `/system/auditLog/{logIds}`
- **Method**: `DELETE`
- **权限**: `system:auditLog:remove`
- **描述**: 删除一条或多条操作审计日志。

### 20.7 根据MSDS ID查询操作日志

- **URL**: `/system/auditLog/msds/{msdsId}`
- **Method**: `GET`
- **权限**: `system:auditLog:query`
- **描述**: 根据MSDS ID查询相关的操作日志。

### 20.8 获取审计统计信息

- **URL**: `/system/auditLog/statistics`
- **Method**: `GET`
- **权限**: `system:auditLog:query`
- **描述**: 获取审计统计信息。

### 20.9 获取操作类型分布统计

- **URL**: `/system/auditLog/operationTypes`
- **Method**: `GET`
- **权限**: `system:auditLog:query`
- **描述**: 获取操作类型分布统计。

### 20.10 获取操作人员活跃度统计

- **URL**: `/system/auditLog/operators`
- **Method**: `GET`
- **权限**: `system:auditLog:query`
- **描述**: 获取操作人员活跃度统计。

---

## 附录

### A. 常见错误处理

#### A.1 参数验证错误
```json
{
  "code": 400,
  "msg": "参数验证失败",
  "data": {
    "errors": [
      {
        "field
