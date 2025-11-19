# MSDS管理系统接口文档 - 附录

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
        "field": "productName",
        "message": "化学品名称不能为空"
      },
      {
        "field": "casNo",
        "message": "CAS号格式不正确"
      }
    ]
  }
}
```

#### A.2 权限不足错误
```json
{
  "code": 403,
  "msg": "权限不足",
  "data": {
    "requiredPermission": "system:msds:add",
    "userPermissions": ["system:msds:list", "system:msds:query"]
  }
}
```

#### A.3 资源不存在错误
```json
{
  "code": 404,
  "msg": "MSDS记录不存在",
  "data": {
    "requestedId": 999,
    "resourceType": "MsdsMain"
  }
}
```

#### A.4 业务逻辑错误
```json
{
  "code": 500,
  "msg": "操作失败：该MSDS记录正在被其他用户编辑",
  "data": {
    "errorCode": "RESOURCE_LOCKED",
    "lockedBy": "张三",
    "lockTime": "2024-01-01 10:00:00"
  }
}
```

### B. 数据验证规则

#### B.1 MSDS主信息验证规则

| 字段名 | 验证规则 | 错误信息 |
| --- | --- | --- |
| `productName` | 必填，长度1-200字符 | "化学品名称不能为空且长度不能超过200字符" |
| `casNo` | 必填，格式：数字-数字-数字 | "CAS号格式不正确，应为：XXXXX-XX-X" |
| `molecularFormula` | 可选，长度不超过100字符 | "分子式长度不能超过100字符" |
| `manufacturer` | 必填，长度1-200字符 | "生产厂商不能为空且长度不能超过200字符" |
| `supplierPhone` | 可选，手机号或固话格式 | "供应商电话格式不正确" |
| `emergencyPhone` | 可选，手机号或固话格式 | "应急电话格式不正确" |
| `version` | 可选，版本号格式 | "版本号格式不正确" |
| `revisionDate` | 可选，日期格式YYYY-MM-DD | "修订日期格式不正确" |

#### B.2 成分信息验证规则

| 字段名 | 验证规则 | 错误信息 |
| --- | --- | --- |
| `msdsId` | 必填，正整数 | "MSDS主表ID不能为空" |
| `componentName` | 必填，长度1-200字符 | "成分名称不能为空" |
| `concentration` | 可选，百分比格式 | "浓度格式不正确" |
| `concentrationRange` | 可选，范围格式 | "浓度范围格式不正确" |

### C. 接口调用示例

#### C.1 完整的MSDS创建流程

```javascript
// 1. 创建MSDS主信息
const createMsdsMain = async () => {
  const response = await fetch('/system/msds', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    },
    body: JSON.stringify({
      productName: '硫酸',
      productNameEn: 'Sulfuric acid',
      casNo: '7664-93-9',
      molecularFormula: 'H2SO4',
      manufacturer: '某化工有限公司'
    })
  });
  
  const result = await response.json();
  if (result.code === 200) {
    return result.data.id; // 返回新创建的MSDS ID
  }
  throw new Error(result.msg);
};

// 2. 添加成分信息
const addComponent = async (msdsId) => {
  const response = await fetch('/system/component', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    },
    body: JSON.stringify({
      msdsId: msdsId,
      componentName: '硫酸',
      casNo: '7664-93-9',
      concentration: '98%',
      hazardClassification: '腐蚀性物质'
    })
  });
  
  const result = await response.json();
  if (result.code !== 200) {
    throw new Error(result.msg);
  }
};

// 3. 添加危险性概述
const addHazard = async (msdsId) => {
  const response = await fetch('/system/hazard', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    },
    body: JSON.stringify({
      msdsId: msdsId,
      ghsClassification: '腐蚀性物质类别1',
      hazardStatement: 'H314: 造成严重皮肤灼伤和眼损伤',
      signalWord: '危险',
      hazardPictogram: 'GHS05'
    })
  });
  
  const result = await response.json();
  if (result.code !== 200) {
    throw new Error(result.msg);
  }
};

// 完整流程
const createCompleteMsds = async () => {
  try {
    const msdsId = await createMsdsMain();
    await addComponent(msdsId);
    await addHazard(msdsId);
    console.log('MSDS创建成功，ID:', msdsId);
  } catch (error) {
    console.error('MSDS创建失败:', error.message);
  }
};
```

#### C.2 分页查询示例

```javascript
const getMsdsList = async (page = 1, size = 10, filters = {}) => {
  const params = new URLSearchParams({
    pageNum: page,
    pageSize: size,
    ...filters
  });
  
  const response = await fetch(`/system/msds/list?${params}`, {
    method: 'GET',
    headers: {
      'Authorization': 'Bearer ' + token
    }
  });
  
  const result = await response.json();
  if (result.code === 200) {
    return {
      total: result.total,
      data: result.rows,
      currentPage: page,
      pageSize: size
    };
  }
  throw new Error(result.msg);
};

// 使用示例
getMsdsList(1, 20, {
  productName: '硫酸',
  status: '1'
}).then(result => {
  console.log('总记录数:', result.total);
  console.log('当前页数据:', result.data);
});
```

#### C.3 文件导入示例

```javascript
const importMsdsFile = async (file, overwriteDuplicates = false) => {
  const formData = new FormData();
  formData.append('files', file);
  formData.append('overwriteDuplicates', overwriteDuplicates);
  
  const response = await fetch('/system/msds/import', {
    method: 'POST',
    headers: {
      'Authorization': 'Bearer ' + token
    },
    body: formData
  });
  
  const result = await response.json();
  if (result.code === 200) {
    return result.data; // 返回导入结果统计
  }
  throw new Error(result.msg);
};

// 使用示例
const fileInput = document.getElementById('fileInput');
fileInput.addEventListener('change', async (event) => {
  const file = event.target.files[0];
  if (file) {
    try {
      const result = await importMsdsFile(file, true);
      console.log(`导入完成: 总计${result.total}条，成功${result.success}条，失败${result.failed}条`);
      if (result.errors && result.errors.length > 0) {
        console.log('错误详情:', result.errors);
      }
    } catch (error) {
      console.error('导入失败:', error.message);
    }
  }
});
```

### D. 性能优化建议

#### D.1 分页查询优化

1. **合理设置页面大小**：建议每页显示10-50条记录，避免一次性加载过多数据。
2. **使用索引字段排序**：优先使用有索引的字段进行排序，如`id`、`createTime`等。
3. **避免深度分页**：对于大数据量场景，避免查询过深的页面（如第1000页）。

#### D.2 查询条件优化

1. **精确查询优于模糊查询**：优先使用`casNo`等精确字段进行查询。
2. **合理使用日期范围**：避免查询过大的时间范围。
3. **组合查询条件**：使用多个条件组合可以提高查询效率。

#### D.3 批量操作建议

1. **批量删除**：一次删除多条记录时，使用逗号分隔的ID列表。
2. **批量导入**：大量数据导入时，建议分批次进行，每批不超过1000条。
3. **异步处理**：对于耗时操作，建议使用异步处理机制。

### E. 安全注意事项

#### E.1 认证和授权

1. **JWT Token管理**：
   - Token有效期建议设置为2-8小时
   - 实现Token自动刷新机制
   - 退出登录时清除本地Token

2. **权限验证**：
   - 每个接口调用前验证用户权限
   - 实现细粒度的权限控制
   - 记录权限验证失败的审计日志

#### E.2 数据安全

1. **输入验证**：
   - 对所有用户输入进行严格验证
   - 防止SQL注入和XSS攻击
   - 限制文件上传类型和大小

2. **敏感数据处理**：
   - 不在日志中记录敏感信息
   - 对敏感字段进行加密存储
   - 实现数据脱敏功能

#### E.3 接口安全

1. **请求频率限制**：
   - 实现API调用频率限制
   - 防止恶意请求和DDoS攻击
   - 对异常请求进行监控和告警

2. **HTTPS通信**：
   - 生产环境必须使用HTTPS
   - 验证SSL证书有效性
   - 禁用不安全的加密算法

### F. 监控和运维

#### F.1 接口监控

1. **响应时间监控**：
   - 监控各接口的平均响应时间
   - 设置响应时间告警阈值
   - 定期优化慢查询接口

2. **错误率监控**：
   - 监控接口错误率和异常情况
   - 实现自动告警机制
   - 建立错误处理和恢复流程

#### F.2 日志管理

1. **访问日志**：
   - 记录所有API调用信息
   - 包含用户ID、IP地址、请求参数等
   - 定期归档和清理历史日志

2. **错误日志**：
   - 详细记录系统错误和异常
   - 包含错误堆栈和上下文信息
   - 实现日志聚合和分析

#### F.3 数据备份

1. **定期备份**：
   - 每日自动备份数据库
   - 保留至少30天的备份数据
   - 定期测试备份恢复流程

2. **增量备份**：
   - 实现增量备份机制
   - 减少备份时间和存储空间
   - 确保数据一致性

### G. 版本更新说明

#### G.1 版本历史

| 版本号 | 发布日期 | 更新内容 |
| --- | --- | --- |
| v1.0.0 | 2024-01-01 | 初始版本，包含基础MSDS管理功能 |
| v1.1.0 | 2024-02-01 | 新增批量导入导出功能 |
| v1.2.0 | 2024-03-01 | 新增统计报表和审计日志功能 |
| v1.3.0 | 2024-04-01 | 优化查询性能，新增高级搜索 |

#### G.2 兼容性说明

1. **向后兼容**：
   - 新版本保持对旧版本API的兼容
   - 废弃的接口会提前通知并保留至少6个月
   - 提供迁移指南和工具

2. **数据库兼容**：
   - 数据库结构变更会提供升级脚本
   - 确保数据迁移的完整性和一致性
   - 提供回滚方案

### H. 技术支持

#### H.1 联系方式

- **技术支持邮箱**: support@msds-system.com
- **技术支持电话**: 400-123-4567
- **在线文档**: https://docs.msds-system.com
- **问题反馈**: https://github.com/msds-system/issues

#### H.2 常见问题

1. **Q: 如何获取API访问权限？**
   A: 请联系系统管理员分配相应的用户角色和权限。

2. **Q: 导入文件格式有什么要求？**
   A: 支持Excel格式(.xlsx)，请使用提供的模板文件。

3. **Q: 如何处理大量数据的查询？**
   A: 建议使用分页查询，并添加适当的查询条件来缩小结果集。

4. **Q: API调用频率有限制吗？**
   A: 是的，每个用户每分钟最多调用1000次API。

5. **Q: 如何处理并发编辑冲突？**
   A: 系统使用乐观锁机制，当检测到冲突时会返回相应错误信息。

---

**文档版本**: v1.3.0  
**最后更新**: 2024-01-01  
**文档维护**: MSDS系统开发团队