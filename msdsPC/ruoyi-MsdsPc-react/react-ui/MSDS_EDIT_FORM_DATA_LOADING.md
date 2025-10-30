# MSDS编辑表单数据加载功能实现说明

## 功能概述

在MSDS编辑向导的16章详情编辑页面中，当编辑已有的MSDS数据时，系统会自动从数据库加载对应的数据，并填充到各个步骤的表单中。用户可以在原有数据的基础上进行修改，而不是从空白表单开始。

## 实现方案

### 1. 数据加载流程

当打开MSDS编辑向导并传入 `msdsId` 时：

1. **触发数据加载**: `useEffect` 监听 `open` 和 `msdsId` 的变化
2. **并行查询所有章节**: 使用 `Promise.all` 同时查询16个章节的数据
3. **数据组装**: 将各章节数据按照步骤配置的key进行组装
4. **状态初始化**: 根据已有数据自动标记步骤状态为"已完成"
5. **表单填充**: 各步骤组件通过 `data` prop 接收数据并自动填充表单

### 2. 核心代码修改

#### 文件: `MsdsStepForm.tsx`

**新增API导入**:
```typescript
import { 
  getMsdsDetail,
  getHazardByMsdsId,
  getComponentByMsdsId,
  getFirstAidByMsdsId,
  getFireFightingByMsdsId,
  getLeakResponseByMsdsId,
  getHandlingByMsdsId,
  getExposureByMsdsId,
  getPhysicalChemicalByMsdsId,
  getStabilityReactivityByMsdsId,
  getToxicologyByMsdsId,
  getEcologyByMsdsId,
  getDisposalByMsdsId,
  getTransportByMsdsId,
  getRegulatoryByMsdsId,
  getOtherInfoByMsdsId
} from '@/services/msds';
```

**实现数据加载函数**:
```typescript
const loadMsdsData = async () => {
  if (!msdsId) return;
  
  setLoading(true);
  try {
    // 并行加载所有16个章节的数据
    const [
      mainResponse,          // 第1章：基本信息
      hazardResponse,        // 第2章：危险性概述
      componentResponse,     // 第3章：成分信息
      firstAidResponse,      // 第4章：急救措施
      fireFightingResponse,  // 第5章：消防措施
      leakResponseResponse,  // 第6章：泄漏应急
      handlingResponse,      // 第7章：操作储存
      exposureResponse,      // 第8章：接触控制
      physicalChemicalResponse,    // 第9章：理化特性
      stabilityReactivityResponse, // 第10章：稳定性反应
      toxicologyResponse,    // 第11章：毒理学资料
      ecologyResponse,       // 第12章：生态学资料
      disposalResponse,      // 第13章：废弃处置
      transportResponse,     // 第14章：运输信息
      regulatoryResponse,    // 第15章：法规信息
      otherInfoResponse      // 第16章：其他信息
    ] = await Promise.all([...]);

    // 组装完整数据并设置到formData
    // 初始化步骤状态
  }
};
```

### 3. 数据流转

```
用户点击编辑按钮
    ↓
传入 msdsId 打开编辑向导
    ↓
loadMsdsData() 被调用
    ↓
并行查询16个章节的API
    ↓
组装数据到 formData 状态
    ↓
通过 props 传递给各步骤组件
    ↓
各步骤组件的 useEffect 监听 data 变化
    ↓
调用 form.setFieldsValue() 填充表单
    ↓
用户看到预填充的表单数据
```

### 4. 步骤组件数据接收

每个步骤组件都实现了相同的模式：

```typescript
const Step1BasicInfo = forwardRef<any, Step1BasicInfoProps>(({ data, onChange }, ref) => {
  const [form] = Form.useForm();

  // 当 data prop 变化时，自动填充表单
  useEffect(() => {
    if (data) {
      // 处理日期格式等特殊字段
      const formData = {
        ...data,
        revisionDate: data.revisionDate ? dayjs(data.revisionDate) : undefined
      };
      form.setFieldsValue(formData);
    }
  }, [data, form]);

  return (
    <Form form={form} onValuesChange={handleValuesChange}>
      {/* 表单字段 */}
    </Form>
  );
});
```

### 5. 步骤状态管理

- **wait**: 等待编辑（灰色）
- **process**: 正在编辑（蓝色）
- **finish**: 已完成（绿色✓）
- **error**: 有错误（红色⚠️）

已有数据的步骤会自动标记为 `finish` 状态，用户可以清楚地看到哪些章节已有数据。

### 6. 章节数据映射

| 步骤 | 章节名称 | 数据key | API函数 |
|------|----------|---------|---------|
| 1 | 化学品及企业标识 | basic | getMsdsDetail |
| 2 | 危险性概述 | hazard | getHazardByMsdsId |
| 3 | 成分信息 | component | getComponentByMsdsId |
| 4 | 急救措施 | firstAid | getFirstAidByMsdsId |
| 5 | 消防措施 | fireFighting | getFireFightingByMsdsId |
| 6 | 泄漏应急 | leakResponse | getLeakResponseByMsdsId |
| 7 | 操作储存 | handlingStorage | getHandlingByMsdsId |
| 8 | 接触控制 | exposureControl | getExposureByMsdsId |
| 9 | 理化特性 | physicalChemical | getPhysicalChemicalByMsdsId |
| 10 | 稳定性反应 | stabilityReactivity | getStabilityReactivityByMsdsId |
| 11 | 毒理学资料 | toxicological | getToxicologyByMsdsId |
| 12 | 生态学资料 | ecological | getEcologyByMsdsId |
| 13 | 废弃处置 | disposal | getDisposalByMsdsId |
| 14 | 运输信息 | transportation | getTransportByMsdsId |
| 15 | 法规信息 | regulatory | getRegulatoryByMsdsId |
| 16 | 其他信息 | otherInfo | getOtherInfoByMsdsId |

## 使用方式

### 新增MSDS
```typescript
<MsdsStepForm 
  open={true}
  onClose={() => setOpen(false)}
  // 不传 msdsId，表单为空白状态
/>
```

### 编辑已有MSDS
```typescript
<MsdsStepForm 
  open={true}
  onClose={() => setOpen(false)}
  msdsId={12345}  // 传入要编辑的MSDS ID
  initialStep={0} // 可选：指定打开时的起始步骤
/>
```

## 性能优化

1. **并行加载**: 使用 `Promise.all` 同时查询所有章节，减少总加载时间
2. **按需渲染**: 只渲染当前步骤的表单组件
3. **自动保存**: 用户修改数据时自动触发保存，避免数据丢失
4. **状态缓存**: formData 保存在组件状态中，切换步骤时不需要重新加载

## 错误处理

1. **加载失败提示**: 如果任何API调用失败，显示错误提示
2. **部分数据加载**: 即使某些章节数据加载失败，也会加载成功的章节
3. **验证保护**: 步骤切换前进行表单验证，防止无效数据
4. **空数据处理**: 没有数据的章节显示空表单，可以正常填写

## 用户体验改进

1. **加载状态显示**: 数据加载时显示loading状态
2. **完成度进度条**: 顶部显示整体数据完成度
3. **步骤状态图标**: 已完成的步骤显示绿色勾号
4. **自动保存提示**: 保存时显示"自动保存中..."
5. **数据加载成功提示**: 加载完成后显示"数据加载成功"

## 注意事项

1. **数据一致性**: 确保所有API返回的数据格式符合表单字段定义
2. **日期字段处理**: 日期字段需要转换为dayjs对象才能正确显示
3. **数组字段处理**: 如化学品别名等数组字段需要特殊处理
4. **必填字段验证**: 即使是编辑模式，也要进行必填字段验证
5. **权限控制**: 确保用户有权限编辑该MSDS数据

## 测试建议

1. **测试编辑已有数据**: 打开已有MSDS，验证所有16章数据正确加载
2. **测试新增数据**: 不传msdsId，验证表单为空白状态
3. **测试部分数据**: 只有部分章节有数据时的显示
4. **测试数据修改**: 修改数据后自动保存是否正常
5. **测试步骤切换**: 在不同步骤间切换，数据是否保持

## 未来优化方向

1. **懒加载**: 只在用户进入某个步骤时才加载该步骤的数据
2. **离线编辑**: 支持离线模式，数据保存到本地存储
3. **版本对比**: 显示修改前后的数据对比
4. **批量编辑**: 支持批量编辑多个MSDS
5. **模板功能**: 从模板创建新的MSDS
