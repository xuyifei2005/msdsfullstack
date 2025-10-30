# 项目接口文档

## 1. MSDS主信息 (`/system/msds`)

### 1.1 获取MSDS主信息列表

- **URL**: `/system/msds/list`
- **Method**: `GET`
- **权限**: `system:msds:list`
- **描述**: 获取MSDS主信息列表，支持分页。
- **请求参数**:

| 参数名 | 类型 | 是否必填 | 描述 |
| --- | --- | --- | --- |
| `pageNum` | `integer` | 否 | 当前页码 |
| `pageSize` | `integer` | 否 | 每页数量 |
| `productName` | `string` | 否 | 化学品名称 |
| `casNo` | `string` | 否 | CAS号 |

- **响应**: `TableDataInfo` 对象，包含 `total` 和 `rows` (MSDS主信息列表)。

### 1.2 导出MSDS主信息列表

- **URL**: `/system/msds/export`
- **Method**: `POST`
- **权限**: `system:msds:export`
- **描述**: 将MSDS主信息列表导出为Excel文件。
- **请求参数**: 同 `1.1 获取MSDS主信息列表`。
- **响应**: Excel文件。

## 2. 生态学资料 (`/system/ecological`)

### 2.1 查询生态学资料列表

- **URL**: `/system/ecological/list`
- **Method**: `GET`
- **权限**: `system:ecological:list`
- **描述**: 查询生态学资料列表，支持分页。
- **请求参数**:

| 参数名 | 类型 | 是否必填 | 描述 |
| --- | --- | --- | --- |
| `pageNum` | `integer` | 否 | 当前页码 |
| `pageSize` | `integer` | 否 | 每页数量 |

- **响应**: `TableDataInfo` 对象，包含 `total` 和 `rows` (生态学资料列表)。

### 2.2 获取生态学资料详细信息

- **URL**: `/system/ecological/{id}`
- **Method**: `GET`
- **权限**: `system:ecological:query`
- **描述**: 根据ID获取生态学资料详细信息。
- **路径参数**:

| 参数名 | 类型 | 描述 |
| --- | --- | --- |
| `id` | `long` | 生态学资料ID |

- **响应**: `AjaxResult` 对象，`data` 中包含 `MsdsEcological` 对象。

### 2.3 根据MSDS主表ID获取生态学资料

- **URL**: `/system/ecological/msds/{msdsId}`
- **Method**: `GET`
- **权限**: `system:ecological:query`
- **描述**: 根据MSDS主表ID获取生态学资料。
- **路径参数**:

| 参数名 | 类型 | 描述 |
| --- | --- | --- |
| `msdsId` | `long` | MSDS主表ID |

- **响应**: `AjaxResult` 对象，`data` 中包含 `MsdsEcological` 对象。

### 2.4 新增生态学资料

- **URL**: `/system/ecological`
- **Method**: `POST`
- **权限**: `system:ecological:add`
- **描述**: 新增一条生态学资料。
- **请求体**: `MsdsEcological` 对象 (JSON格式)。
- **响应**: `AjaxResult` 对象。

## 7. 毒理学资料 (`/system/toxicological`)

### 7.1 查询毒理学资料列表

- **URL**: `/system/toxicological/list`
- **Method**: `GET`
- **权限**: `system:toxicological:list`
- **描述**: 查询毒理学资料列表，支持分页。
- **请求参数**:

| 参数名 | 类型 | 是否必填 | 描述 |
| --- | --- | --- | --- |
| `pageNum` | `integer` | 否 | 当前页码 |
| `pageSize` | `integer` | 否 | 每页数量 |

- **响应**: `TableDataInfo` 对象，包含 `total` 和 `rows` (毒理学资料列表)。

### 7.2 获取毒理学资料详细信息

- **URL**: `/system/toxicological/{id}`
- **Method**: `GET`
- **权限**: `system:toxicological:query`
- **描述**: 根据ID获取毒理学资料详细信息。
- **路径参数**:

| 参数名 | 类型 | 描述 |
| --- | --- | --- |
| `id` | `long` | 毒理学资料ID |

- **响应**: `AjaxResult` 对象，`data` 中包含 `MsdsToxicological` 对象。

### 7.3 根据MSDS主表ID获取毒理学资料信息

- **URL**: `/system/toxicological/msds/{msdsId}`
- **Method**: `GET`
- **权限**: `system:toxicological:query`
- **描述**: 根据MSDS主表ID获取毒理学资料信息。
- **路径参数**:

| 参数名 | 类型 | 描述 |
| --- | --- | --- |
| `msdsId` | `long` | MSDS主表ID |

- **响应**: `AjaxResult` 对象，`data` 中包含 `MsdsToxicological` 对象。

### 7.4 新增毒理学资料

- **URL**: `/system/toxicological`
- **Method**: `POST`
- **权限**: `system:toxicological:add`
- **描述**: 新增一条毒理学资料。
- **请求体**: `MsdsToxicological` 对象 (JSON格式)。
- **响应**: `AjaxResult` 对象。

### 7.5 修改毒理学资料

- **URL**: `/system/toxicological`
- **Method**: `PUT`
- **权限**: `system:toxicological:edit`
- **描述**: 修改一条毒理学资料。
- **请求体**: `MsdsToxicological` 对象 (JSON格式)。
- **响应**: `AjaxResult` 对象。

### 7.6 删除毒理学资料

- **URL**: `/system/toxicological/{ids}`
- **Method**: `DELETE`
- **权限**: `system:toxicological:remove`
- **描述**: 删除一条或多条毒理学资料。
- **路径参数**:

| 参数名 | 类型 | 描述 |
| --- | --- | --- |
| `ids` | `long[]` | 毒理学资料ID数组 |

- **响应**: `AjaxResult` 对象。

## 6. 泄漏应急处理 (`/system/leakResponse`)

### 6.1 查询泄漏应急处理列表

- **URL**: `/system/leakResponse/list`
- **Method**: `GET`
- **权限**: `system:leakResponse:list`
- **描述**: 查询泄漏应急处理列表，支持分页。
- **请求参数**:

| 参数名 | 类型 | 是否必填 | 描述 |
| --- | --- | --- | --- |
| `pageNum` | `integer` | 否 | 当前页码 |
| `pageSize` | `integer` | 否 | 每页数量 |

- **响应**: `TableDataInfo` 对象，包含 `total` 和 `rows` (泄漏应急处理列表)。

### 6.2 获取泄漏应急处理详细信息

- **URL**: `/system/leakResponse/{id}`
- **Method**: `GET`
- **权限**: `system:leakResponse:query`
- **描述**: 根据ID获取泄漏应急处理详细信息。
- **路径参数**:

| 参数名 | 类型 | 描述 |
| --- | --- | --- |
| `id` | `long` | 泄漏应急处理ID |

- **响应**: `AjaxResult` 对象，`data` 中包含 `MsdsLeakResponse` 对象。

### 6.3 根据MSDS主表ID获取泄漏应急处理

- **URL**: `/system/leakResponse/msds/{msdsId}`
- **Method**: `GET`
- **权限**: `system:leakResponse:query`
- **描述**: 根据MSDS主表ID获取泄漏应急处理。
- **路径参数**:

| 参数名 | 类型 | 描述 |
| --- | --- | --- |
| `msdsId` | `long` | MSDS主表ID |

- **响应**: `AjaxResult` 对象，`data` 中包含 `MsdsLeakResponse` 对象。

### 6.4 新增泄漏应急处理

- **URL**: `/system/leakResponse`
- **Method**: `POST`
- **权限**: `system:leakResponse:add`
- **描述**: 新增一条泄漏应急处理。
- **请求体**: `MsdsLeakResponse` 对象 (JSON格式)。
- **响应**: `AjaxResult` 对象。

### 6.5 修改泄漏应急处理

- **URL**: `/system/leakResponse`
- **Method**: `PUT`
- **权限**: `system:leakResponse:edit`
- **描述**: 修改一条泄漏应急处理。
- **请求体**: `MsdsLeakResponse` 对象 (JSON格式)。
- **响应**: `AjaxResult` 对象。

### 6.6 删除泄漏应急处理

- **URL**: `/system/leakResponse/{ids}`
- **Method**: `DELETE`
- **权限**: `system:leakResponse:remove`
- **描述**: 删除一条或多条泄漏应急处理。
- **路径参数**:

| 参数名 | 类型 | 描述 |
| --- | --- | --- |
| `ids` | `long[]` | 泄漏应急处理ID数组 |

- **响应**: `AjaxResult` 对象。

## 5. 操作处置与储存 (`/system/handling`)

### 5.1 查询操作处置与储存列表

- **URL**: `/system/handling/list`
- **Method**: `GET`
- **权限**: `system:handling:list`
- **描述**: 查询操作处置与储存列表，支持分页。
- **请求参数**:

| 参数名 | 类型 | 是否必填 | 描述 |
| --- | --- | --- | --- |
| `pageNum` | `integer` | 否 | 当前页码 |
| `pageSize` | `integer` | 否 | 每页数量 |

- **响应**: `TableDataInfo` 对象，包含 `total` 和 `rows` (操作处置与储存列表)。

### 5.2 获取操作处置与储存详细信息

- **URL**: `/system/handling/{id}`
- **Method**: `GET`
- **权限**: `system:handling:query`
- **描述**: 根据ID获取操作处置与储存详细信息。
- **路径参数**:

| 参数名 | 类型 | 描述 |
| --- | --- | --- |
| `id` | `long` | 操作处置与储存ID |

- **响应**: `AjaxResult` 对象，`data` 中包含 `MsdsHandlingStorage` 对象。

### 5.3 根据MSDS主表ID获取操作处置与储存信息

- **URL**: `/system/handling/msds/{msdsId}`
- **Method**: `GET`
- **权限**: `system:handling:query`
- **描述**: 根据MSDS主表ID获取操作处置与储存信息。
- **路径参数**:

| 参数名 | 类型 | 描述 |
| --- | --- | --- |
| `msdsId` | `long` | MSDS主表ID |

- **响应**: `AjaxResult` 对象，`data` 中包含 `MsdsHandlingStorage` 对象。

### 5.4 新增操作处置与储存

- **URL**: `/system/handling`
- **Method**: `POST`
- **权限**: `system:handling:add`
- **描述**: 新增一条操作处置与储存。
- **请求体**: `MsdsHandlingStorage` 对象 (JSON格式)。
- **响应**: `AjaxResult` 对象。

### 5.5 修改操作处置与储存

- **URL**: `/system/handling`
- **Method**: `PUT`
- **权限**: `system:handling:edit`
- **描述**: 修改一条操作处置与储存。
- **请求体**: `MsdsHandlingStorage` 对象 (JSON格式)。
- **响应**: `AjaxResult` 对象。

### 5.6 删除操作处置与储存

- **URL**: `/system/handling/{ids}`
- **Method**: `DELETE`
- **权限**: `system:handling:remove`
- **描述**: 删除一条或多条操作处置与储存。
- **路径参数**:

| 参数名 | 类型 | 描述 |
| --- | --- | --- |
| `ids` | `long[]` | 操作处置与储存ID数组 |

- **响应**: `AjaxResult` 对象。

## 4. 消防措施 (`/system/fireFighting`)

### 4.1 查询消防措施列表

- **URL**: `/system/fireFighting/list`
- **Method**: `GET`
- **权限**: `system:fireFighting:list`
- **描述**: 查询消防措施列表，支持分页。
- **请求参数**:

| 参数名 | 类型 | 是否必填 | 描述 |
| --- | --- | --- | --- |
| `pageNum` | `integer` | 否 | 当前页码 |
| `pageSize` | `integer` | 否 | 每页数量 |

- **响应**: `TableDataInfo` 对象，包含 `total` 和 `rows` (消防措施列表)。

### 4.2 获取消防措施详细信息

- **URL**: `/system/fireFighting/{id}`
- **Method**: `GET`
- **权限**: `system:fireFighting:query`
- **描述**: 根据ID获取消防措施详细信息。
- **路径参数**:

| 参数名 | 类型 | 描述 |
| --- | --- | --- |
| `id` | `long` | 消防措施ID |

- **响应**: `AjaxResult` 对象，`data` 中包含 `MsdsFireFighting` 对象。

### 4.3 根据MSDS主表ID获取消防措施

- **URL**: `/system/fireFighting/msds/{msdsId}`
- **Method**: `GET`
- **权限**: `system:fireFighting:query`
- **描述**: 根据MSDS主表ID获取消防措施。
- **路径参数**:

| 参数名 | 类型 | 描述 |
| --- | --- | --- |
| `msdsId` | `long` | MSDS主表ID |

- **响应**: `AjaxResult` 对象，`data` 中包含 `MsdsFireFighting` 对象。

### 4.4 新增消防措施

- **URL**: `/system/fireFighting`
- **Method**: `POST`
- **权限**: `system:fireFighting:add`
- **描述**: 新增一条消防措施。
- **请求体**: `MsdsFireFighting` 对象 (JSON格式)。
- **响应**: `AjaxResult` 对象。

### 4.5 修改消防措施

- **URL**: `/system/fireFighting`
- **Method**: `PUT`
- **权限**: `system:fireFighting:edit`
- **描述**: 修改一条消防措施。
- **请求体**: `MsdsFireFighting` 对象 (JSON格式)。
- **响应**: `AjaxResult` 对象。

### 4.6 删除消防措施

- **URL**: `/system/fireFighting/{ids}`
- **Method**: `DELETE`
- **权限**: `system:fireFighting:remove`
- **描述**: 删除一条或多条消防措施。
- **路径参数**:

| 参数名 | 类型 | 描述 |
| --- | --- | --- |
| `ids` | `long[]` | 消防措施ID数组 |

- **响应**: `AjaxResult` 对象。

## 3. 接触控制/个体防护 (`/system/exposure`)

### 3.1 查询接触控制/个体防护列表

- **URL**: `/system/exposure/list`
- **Method**: `GET`
- **权限**: `system:exposure:list`
- **描述**: 查询接触控制/个体防护列表，支持分页。
- **请求参数**:

| 参数名 | 类型 | 是否必填 | 描述 |
| --- | --- | --- | --- |
| `pageNum` | `integer` | 否 | 当前页码 |
| `pageSize` | `integer` | 否 | 每页数量 |

- **响应**: `TableDataInfo` 对象，包含 `total` 和 `rows` (接触控制/个体防护列表)。

### 3.2 获取接触控制/个体防护详细信息

- **URL**: `/system/exposure/{id}`
- **Method**: `GET`
- **权限**: `system:exposure:query`
- **描述**: 根据ID获取接触控制/个体防护详细信息。
- **路径参数**:

| 参数名 | 类型 | 描述 |
| --- | --- | --- |
| `id` | `long` | 接触控制/个体防护ID |

- **响应**: `AjaxResult` 对象，`data` 中包含 `MsdsExposureControl` 对象。

### 3.3 根据MSDS主表ID获取接触控制/个体防护信息

- **URL**: `/system/exposure/msds/{msdsId}`
- **Method**: `GET`
- **权限**: `system:exposure:query`
- **描述**: 根据MSDS主表ID获取接触控制/个体防护信息。
- **路径参数**:

| 参数名 | 类型 | 描述 |
| --- | --- | --- |
| `msdsId` | `long` | MSDS主表ID |

- **响应**: `AjaxResult` 对象，`data` 中包含 `MsdsExposureControl` 对象。

### 3.4 新增接触控制/个体防护

- **URL**: `/system/exposure`
- **Method**: `POST`
- **权限**: `system:exposure:add`
- **描述**: 新增一条接触控制/个体防护。
- **请求体**: `MsdsExposureControl` 对象 (JSON格式)。
- **响应**: `AjaxResult` 对象。

### 3.5 修改接触控制/个体防护

- **URL**: `/system/exposure`
- **Method**: `PUT`
- **权限**: `system:exposure:edit`
- **描述**: 修改一条接触控制/个体防护。
- **请求体**: `MsdsExposureControl` 对象 (JSON格式)。
- **响应**: `AjaxResult` 对象。

### 3.6 删除接触控制/个体防护

- **URL**: `/system/exposure/{ids}`
- **Method**: `DELETE`
- **权限**: `system:exposure:remove`
- **描述**: 删除一条或多条接触控制/个体防护。
- **路径参数**:

| 参数名 | 类型 | 描述 |
| --- | --- | --- |
| `ids` | `long[]` | 接触控制/个体防护ID数组 |

- **响应**: `AjaxResult` 对象。


### 2.5 修改生态学资料

- **URL**: `/system/ecological`
- **Method**: `PUT`
- **权限**: `system:ecological:edit`
- **描述**: 修改一条生态学资料。
- **请求体**: `MsdsEcological` 对象 (JSON格式)。
- **响应**: `AjaxResult` 对象。

### 2.6 删除生态学资料

- **URL**: `/system/ecological/{ids}`
- **Method**: `DELETE`
- **权限**: `system:ecological:remove`
- **描述**: 删除一条或多条生态学资料。
- **路径参数**:

| 参数名 | 类型 | 描述 |
| --- | --- | --- |
| `ids` | `long[]` | 生态学资料ID数组 |

- **响应**: `AjaxResult` 对象。


### 1.3 根据ID获取MSDS详细信息

- **URL**: `/system/msds/{id}`
- **Method**: `GET`
- **权限**: `system:msds:query`
- **描述**: 根据MSDS的ID获取详细信息。
- **路径参数**:

| 参数名 | 类型 | 描述 |
| --- | --- | --- |
| `id` | `long` | MSDS主键ID |

- **响应**: `AjaxResult` 对象，`data` 中包含 `MsdsMain` 对象。

### 1.4 新增MSDS主信息

- **URL**: `/system/msds`
- **Method**: `POST`
- **权限**: `system:msds:add`
- **描述**: 新增一条MSDS主信息。
- **请求体**: `MsdsMain` 对象 (JSON格式)。
- **响应**: `AjaxResult` 对象。

### 1.5 修改MSDS主信息

- **URL**: `/system/msds`
- **Method**: `PUT`
- **权限**: `system:msds:edit`
- **描述**: 修改一条MSDS主信息。
- **请求体**: `MsdsMain` 对象 (JSON格式)。
- **响应**: `AjaxResult` 对象。

### 1.6 删除MSDS主信息

- **URL**: `/system/msds/{ids}`
- **Method**: `DELETE`
- **权限**: `system:msds:remove`
- **描述**: 删除一条或多条MSDS主信息。
- **路径参数**:

| 参数名 | 类型 | 描述 |
| --- | --- | --- |
| `ids` | `long[]` | MSDS主键ID数组 |

- **响应**: `AjaxResult` 对象。

### 1.7 导入MSDS文档

- **URL**: `/system/msds/import`
- **Method**: `POST`
- **权限**: `system:msds:import`
- **描述**: 导入MSDS文档。
- **请求参数**:

| 参数名 | 类型 | 是否必填 | 描述 |
| --- | --- | --- | --- |
| `files` | `MultipartFile[]` | 是 | 要导入的文件数组 |
| `overwriteDuplicates` | `boolean` | 否 | 是否覆盖重复数据 (默认 `false`) |

- **响应**: `AjaxResult` 对象，`data` 中包含导入结果信息。

### 1.8 下载MSDS导入模板

- **URL**: `/system/msds/importTemplate`
- **Method**: `POST`
- **描述**: 下载用于导入MSDS数据的Excel模板文件。
- **响应**: Excel文件。
