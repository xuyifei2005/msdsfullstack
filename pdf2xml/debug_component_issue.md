# 第三章成分/组成信息显示问题调试指南

## 问题现状
- ✅ 数据库中 `msds_component` 表有数据（msds_id=157）
- ✅ 前端代码已修复字段名问题（component → components）
- ❌ 前端页面仍显示"暂无数据"

## 调试步骤

### 1. 检查浏览器Console日志
打开浏览器开发者工具（F12），查看Console标签页，寻找以下日志：
```
Component API Response: {...}
Components data set: [...]
Component API failed: {...}
```

### 2. 检查Network请求
在开发者工具的Network标签页中：
1. 刷新页面
2. 查找请求：`/api/system/msds/component/msds/157`
3. 检查请求状态和响应内容

**期望的响应格式：**
```json
{
  "code": 200,
  "msg": "查询成功",
  "data": [
    {
      "id": 57,
      "msdsId": 157,
      "componentName": "硫丹; (1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯",
      "componentContent": "100%",
      "casNumber": "115-29-7",
      ...
    }
  ]
}
```

### 3. 可能的问题和解决方案

#### 问题A：认证失败（401错误）
**现象：** Network中显示401 Unauthorized
**原因：** 用户未登录或token过期
**解决：**
1. 重新登录系统
2. 检查localStorage中的token：
   ```javascript
   console.log('Access Token:', localStorage.getItem('access_token'));
   console.log('Refresh Token:', localStorage.getItem('refresh_token'));
   ```

#### 问题B：API路径错误
**现象：** 404 Not Found
**原因：** 后端Controller路径不匹配
**检查：**
- 前端调用：`/api/system/msds/component/msds/157`
- 后端路径：`/system/msds/component/msds/{msdsId}`

#### 问题C：数据格式不匹配
**现象：** API返回成功但前端不显示
**原因：** 数据结构与前端期望不符
**检查：**
```javascript
// 在Console中执行
console.log('msdsData:', window.__MSDS_DATA__);
console.log('components:', window.__MSDS_DATA__?.components);
```

#### 问题D：前端缓存问题
**现象：** 修改代码后页面未更新
**解决：**
1. 硬刷新：Ctrl+Shift+R
2. 清除缓存：F12 → Application → Storage → Clear storage
3. 无痕模式测试

### 4. 手动测试API

在浏览器Console中执行：
```javascript
// 测试API调用
fetch('/api/system/msds/component/msds/157', {
  headers: {
    'Authorization': 'Bearer ' + localStorage.getItem('access_token'),
    'Content-Type': 'application/json'
  }
})
.then(response => response.json())
.then(data => console.log('API Response:', data))
.catch(error => console.error('API Error:', error));
```

### 5. 检查后端日志

```bash
# 查看后端日志
docker-compose logs msdsbackend | grep -i component
```

### 6. 数据库验证

```sql
-- 确认数据存在
SELECT * FROM msds_component WHERE msds_id = 157;

-- 检查数据完整性
SELECT 
  id, msds_id, component_name, component_content, cas_number,
  create_time, update_time
FROM msds_component 
WHERE msds_id = 157;
```

## 快速修复建议

### 如果确认是认证问题：
1. 重新登录系统
2. 检查token是否有效

### 如果确认是API问题：
1. 检查后端Controller路径
2. 验证数据库连接
3. 查看后端日志

### 如果确认是前端问题：
1. 清除浏览器缓存
2. 检查Console错误
3. 验证数据结构

## 下一步行动

请按照上述步骤逐一检查，并告诉我：
1. Console中是否有错误信息？
2. Network中API请求的状态码是什么？
3. API返回的数据格式是什么？

根据这些信息，我们可以精确定位问题所在。
