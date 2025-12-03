# MSDS管理系统接口文档

## 1. MSDS主信息 (`/system/msds`)

### 1.1 获取MSDS主信息列表
- **URL**: `/system/msds/list`
- **Method**: `GET`
- **权限**: `system:msds:list`
- **描述**: 获取MSDS主信息列表，支持分页。
- **请求参数**:
  - `pageNum` (integer, optional): 当前页码
  - `pageSize` (integer, optional): 每页数量
  - `productName` (string, optional): 化学品名称
  - `casNo` (string, optional): CAS号
- **响应**: `TableDataInfo` (包含 `total` 和 `rows`)

### 1.2 导出MSDS主信息列表
- **URL**: `/system/msds/export`
- **Method**: `POST`
- **权限**: `system:msds:export`
- **描述**: 导出Excel。

### 1.3 根据ID获取MSDS详细信息
- **URL**: `/system/msds/{id}`
- **Method**: `GET`
- **权限**: `system:msds:query`
- **路径参数**: `id` (long)

### 1.4 新增MSDS主信息
- **URL**: `/system/msds`
- **Method**: `POST`
- **权限**: `system:msds:add`
- **请求体**: `MsdsMain` JSON

### 1.5 修改MSDS主信息
- **URL**: `/system/msds`
- **Method**: `PUT`
- **权限**: `system:msds:edit`
- **请求体**: `MsdsMain` JSON

### 1.6 删除MSDS主信息
- **URL**: `/system/msds/{ids}`
- **Method**: `DELETE`
- **权限**: `system:msds:remove`
- **路径参数**: `ids` (long[])

### 1.7 导入MSDS文档
- **URL**: `/system/msds/import`
- **Method**: `POST`
- **权限**: `system:msds:import`
- **请求参数**:
  - `files` (MultipartFile[]): 文件数组
  - `overwriteDuplicates` (boolean): 是否覆盖

### 1.8 下载导入模板
- **URL**: `/system/msds/importTemplate`
- **Method**: `POST`

## 2. MSDS成分信息 (`/system/msds/component`)

### 2.1 查询成分列表
- **URL**: `/system/msds/component/list`
- **Method**: `GET`
- **权限**: `system:msds:list` (复用)

### 2.2 根据MSDS ID查询成分
- **URL**: `/system/msds/component/msds/{msdsId}`
- **Method**: `GET`
- **权限**: `system:msds:query`

### 2.3 批量新增成分
- **URL**: `/system/msds/component/batch`
- **Method**: `POST`
- **权限**: `system:msds:add`

### 2.4 CAS号验证
- **URL**: `/system/msds/component/validate/cas`
- **Method**: `GET`
- **参数**: `casNo`

## 3. 危险性概述 (`/system/msds/hazard`)

### 3.1 查询危险性信息
- **URL**: `/system/msds/hazard/list`
- **Method**: `GET`
- **权限**: `system:msds:list` (复用)

### 3.2 根据MSDS ID查询危险性
- **URL**: `/system/msds/hazard/msds/{msdsId}`
- **Method**: `GET`
- **权限**: `system:msds:query`

### 3.3 新增/修改危险性
- **URL**: `/system/msds/hazard`
- **Method**: `POST` / `PUT`
- **权限**: `system:msds:add` / `system:msds:edit`

## 4. 急救措施 (`/system/msds/firstaid`)

### 4.1 查询急救措施
- **URL**: `/system/msds/firstaid/list`
- **Method**: `GET`
- **权限**: `system:msds:list` (复用)

### 4.2 根据MSDS ID查询急救措施
- **URL**: `/system/msds/firstaid/msds/{msdsId}`
- **Method**: `GET`

## 5. 消防措施 (`/system/msds/fireFighting`)

### 5.1 查询消防措施
- **URL**: `/system/msds/fireFighting/list`
- **Method**: `GET`
- **权限**: `system:fireFighting:list`

### 5.2 根据MSDS ID查询消防措施
- **URL**: `/system/msds/fireFighting/msds/{msdsId}`
- **Method**: `GET`

## 6. 泄漏应急处理 (`/system/msds/leakResponse`)

### 6.1 查询泄漏应急处理
- **URL**: `/system/msds/leakResponse/list`
- **Method**: `GET`
- **权限**: `system:leakResponse:list`

### 6.2 根据MSDS ID查询泄漏应急处理
- **URL**: `/system/msds/leakResponse/msds/{msdsId}`
- **Method**: `GET`

## 7. 操作处置与储存 (`/system/msds/handling`)

### 7.1 查询操作处置
- **URL**: `/system/msds/handling/list`
- **Method**: `GET`
- **权限**: `system:handling:list`

### 7.2 根据MSDS ID查询操作处置
- **URL**: `/system/msds/handling/msds/{msdsId}`
- **Method**: `GET`

## 8. 接触控制/个体防护 (`/system/msds/exposure`)

### 8.1 查询接触控制
- **URL**: `/system/msds/exposure/list`
- **Method**: `GET`
- **权限**: `system:exposure:list`

### 8.2 根据MSDS ID查询接触控制
- **URL**: `/system/msds/exposure/msds/{msdsId}`
- **Method**: `GET`

## 9. 理化特性 (`/system/msds/physicalchemical`)

### 9.1 查询理化特性
- **URL**: `/system/msds/physicalchemical/list`
- **Method**: `GET`
- **权限**: `system:msds:list` (复用)

### 9.2 根据MSDS ID查询理化特性
- **URL**: `/system/msds/physicalchemical/msds/{msdsId}`
- **Method**: `GET`

## 10. 稳定性和反应性 (`/system/msds/stabilityReactivity`)

### 10.1 查询稳定性
- **URL**: `/system/msds/stabilityReactivity/list`
- **Method**: `GET`
- **权限**: `system:stabilityReactivity:list`

### 10.2 根据MSDS ID查询稳定性
- **URL**: `/system/msds/stabilityReactivity/msds/{msdsId}`
- **Method**: `GET`

## 11. 毒理学资料 (`/system/msds/toxicological`)

### 11.1 查询毒理学资料
- **URL**: `/system/msds/toxicological/list`
- **Method**: `GET`
- **权限**: `system:toxicological:list`

### 11.2 根据MSDS ID查询毒理学资料
- **URL**: `/system/msds/toxicological/msds/{msdsId}`
- **Method**: `GET`

## 12. 生态学资料 (`/system/msds/ecology`)

### 12.1 查询生态学资料
- **URL**: `/system/msds/ecology/list`
- **Method**: `GET`
- **权限**: `system:ecological:list`

### 12.2 根据MSDS ID查询生态学资料
- **URL**: `/system/msds/ecology/msds/{msdsId}`
- **Method**: `GET`

## 13. 废弃处置 (`/system/msds/disposal`)

### 13.1 查询废弃处置
- **URL**: `/system/msds/disposal/list`
- **Method**: `GET`
- **权限**: `system:disposal:list`

### 13.2 根据MSDS ID查询废弃处置
- **URL**: `/system/msds/disposal/msds/{msdsId}`
- **Method**: `GET`

## 14. 运输信息 (`/system/msds/transport`)

### 14.1 查询运输信息
- **URL**: `/system/msds/transport/list`
- **Method**: `GET`
- **权限**: `system:transportation:list`

### 14.2 根据MSDS ID查询运输信息
- **URL**: `/system/msds/transport/msds/{msdsId}`
- **Method**: `GET`

## 15. 法规信息 (`/system/msds/regulatory`)

### 15.1 查询法规信息
- **URL**: `/system/msds/regulatory/list`
- **Method**: `GET`
- **权限**: `system:regulatory:list`

### 15.2 根据MSDS ID查询法规信息
- **URL**: `/system/msds/regulatory/msds/{msdsId}`
- **Method**: `GET`

## 16. 其他信息 (`/system/msds/otherInfo`)

### 16.1 查询其他信息
- **URL**: `/system/msds/otherInfo/list`
- **Method**: `GET`
- **权限**: `system:otherInfo:list`

### 16.2 根据MSDS ID查询其他信息
- **URL**: `/system/msds/otherInfo/msds/{msdsId}`
- **Method**: `GET`

## 17. MSDS搜索 (`/system/msds/search`)

### 17.1 智能搜索
- **URL**: `/system/msds/search/intelligent`
- **Method**: `GET`
- **参数**: `keyword`

### 17.2 高级搜索
- **URL**: `/system/msds/search/advanced`
- **Method**: `POST`
- **请求体**: Search criteria JSON

### 17.3 搜索建议
- **URL**: `/system/msds/search/suggestions`
- **Method**: `GET`

### 17.4 热门搜索
- **URL**: `/system/msds/search/hot`
- **Method**: `GET`

## 18. 导入进度 (`/system/msds/import/progress`)

### 18.1 获取我的导入任务
- **URL**: `/system/msds/import/progress/my`
- **Method**: `GET`

### 18.2 获取任务详情
- **URL**: `/system/msds/import/progress/task/{taskId}`
- **Method**: `GET`

## 19. 报表与统计 (`/system/msds/report`)

### 19.1 总览统计
- **URL**: `/system/msds/report/overview`
- **Method**: `GET`

### 19.2 趋势分析
- **URL**: `/system/msds/report/trend`
- **Method**: `GET`

### 19.3 企业分布
- **URL**: `/system/msds/report/companyDistribution`
- **Method**: `GET`

### 19.4 类别分布
- **URL**: `/system/msds/report/categoryDistribution`
- **Method**: `GET`

---

## 附录

### 1. 通用响应结构
所有接口返回标准的 `AjaxResult` 或 `TableDataInfo` 对象。

```json
// AjaxResult
{
    "code": 200,
    "msg": "操作成功",
    "data": { ... }
}

// TableDataInfo (列表查询)
{
    "total": 100,
    "rows": [ ... ],
    "code": 200,
    "msg": "查询成功"
}
```

### 2. 常见错误码
- `200`: 成功
- `401`: 未认证/Token失效
- `403`: 无权限
- `404`: 资源不存在
- `500`: 系统内部错误

### 3. 认证方式
所有请求需在 Header 中携带 Token：
`Authorization: Bearer {token}`

### 4. 性能优化建议
- 大数据量查询时务必使用分页 (`pageNum`, `pageSize`)。
- 使用 `/search/intelligent` 进行全文检索比数据库 `LIKE` 查询更高效。

### 5. 监控与运维
- 监控端点: `/actuator/prometheus` (需管理员权限)
- 日志级别: 生产环境建议 `INFO`，调试可临时开启 `DEBUG`。
