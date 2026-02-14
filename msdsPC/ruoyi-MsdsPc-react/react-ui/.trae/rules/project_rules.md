# 安全智库 - 项目规则文档

**版本**: v1.0  
**创建日期**: 2025-01-21  
**最后更新**: 2025-01-21  
**架构师**: 高级系统架构师

---

## 📋 项目概述

### 项目简介
安全智库是一个基于Ant Design Pro的企业级Web应用，专门用于管理化学品安全技术说明书(Material Safety Data Sheet)。系统采用前后端分离架构，提供完整的MSDS数据录入、查询、管理和导出功能。

### 技术架构
- **前端框架**: React 18.3.0 + TypeScript 5.6.2
- **UI组件库**: Ant Design 5.21.1 + Ant Design Pro Components 2.7.19
- **构建工具**: UmiJS 4.x (Max版本)
- **状态管理**: UmiJS内置Model + React Hooks
- **表单处理**: React Hook Form 7.61.1 + Yup 1.6.1
- **样式方案**: Less + Ant Design主题系统
- **国际化**: UmiJS内置i18n方案
- **代码规范**: ESLint + Prettier + Husky


## 前端开发环境：
你现在在前端docker容器中进行开发

---

## 🏗️ 代码架构规范

### 目录结构规范
```
src/
├── components/          # 全局通用组件
│   ├── DictTag/         # 字典标签组件
│   ├── Footer/          # 页脚组件
│   ├── HeaderDropdown/  # 头部下拉组件
│   ├── IconSelector/    # 图标选择器
│   └── RightContent/    # 右侧内容区
├── pages/               # 页面组件
│   ├── Dashboard/       # 仪表板
│   ├── Msds/           # MSDS管理核心模块
│   ├── System/         # 系统管理
│   ├── Monitor/        # 系统监控
│   ├── Tool/           # 工具模块
│   └── User/           # 用户模块
├── services/           # API服务层
│   ├── msds/           # MSDS相关API
│   ├── system/         # 系统管理API
│   └── typings.d.ts    # API类型定义
├── hooks/              # 自定义Hooks
├── utils/              # 工具函数
├── types/              # TypeScript类型定义
├── locales/            # 国际化文件
└── enums/              # 枚举定义
```

### 组件开发规范

#### 1. 组件命名规范
- **页面组件**: 使用PascalCase，如`MsdsMainList`
- **通用组件**: 使用PascalCase，如`DictTag`
- **组件文件**: 使用index.tsx作为入口文件
- **样式文件**: 使用index.less或style.less

#### 2. 组件结构规范
```typescript
// 标准组件结构
import React, { useState, useRef } from 'react';
import { useIntl, FormattedMessage, useAccess } from '@umijs/max';
import { Button, message } from 'antd';
import { ProTable, ActionType } from '@ant-design/pro-components';

/**
 * 组件功能描述
 * 
 * @author 开发者姓名
 * @datetime 创建日期
 */

interface ComponentProps {
  // 组件属性定义
}

const ComponentName: React.FC<ComponentProps> = (props) => {
  // 状态定义
  const [loading, setLoading] = useState<boolean>(false);
  
  // Hooks使用
  const intl = useIntl();
  const access = useAccess();
  
  // 事件处理函数
  const handleAction = async () => {
    // 实现逻辑
  };
  
  // 渲染逻辑
  return (
    <div>
      {/* 组件内容 */}
    </div>
  );
};

export default ComponentName;
```

#### 3. API服务规范
```typescript
// API服务标准结构
import { request } from '@umijs/max';

// 查询列表
export async function getEntityList(params?: API.EntityListParams) {
  return request<API.EntityPageResult>('/api/path/list', {
    method: 'GET',
    headers: {
      'Content-Type': 'application/json;charset=UTF-8',
    },
    params,
  });
}

// 查询详情
export function getEntity(id: number) {
  return request<API.EntityInfoResult>(`/api/path/${id}`, {
    method: 'GET',
  });
}

// 新增
export async function addEntity(params: API.Entity) {
  return request<API.Result>('/api/path', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json;charset=UTF-8',
    },
    data: params,
  });
}

// 修改
export async function updateEntity(params: API.Entity) {
  return request<API.Result>('/api/path', {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json;charset=UTF-8',
    },
    data: params,
  });
}

// 删除
export async function removeEntity(ids: string) {
  return request<API.Result>(`/api/path/${ids}`, {
    method: 'DELETE',
  });
}
```

---

## 🎯 MSDS业务规范

### 核心业务模块

#### 1. MSDS主信息管理
- **功能**: 化学品基础信息的CRUD操作
- **关键字段**: CAS号、MSDS编号、化学品名称、别名、企业信息
- **特殊要求**: CAS号唯一性校验、数据完整性验证

#### 2. MSDS 16节详细信息
- **第1节**: 化学品及企业标识
- **第2节**: 危险性概述
- **第3节**: 成分/组成信息
- **第4节**: 急救措施
- **第5节**: 消防措施
- **第6节**: 泄漏应急处理
- **第7节**: 操作处置与储存
- **第8节**: 接触控制/个体防护
- **第9节**: 理化特性
- **第10节**: 稳定性和反应活性
- **第11节**: 毒理学信息
- **第12节**: 生态学信息
- **第13节**: 废弃处置
- **第14节**: 运输信息
- **第15节**: 法规信息
- **第16节**: 其他信息

#### 3. 数据验证规则
```typescript
// MSDS数据验证规则
const msdsValidationRules = {
  casNumber: {
    required: true,
    pattern: /^\d{1,7}-\d{2}-\d$/,
    message: 'CAS号格式不正确'
  },
  msdsCode: {
    required: true,
    maxLength: 50,
    message: 'MSDS编号不能超过50个字符'
  },
  productName: {
    required: true,
    maxLength: 200,
    message: '化学品名称不能超过200个字符'
  }
};
```

---

## 📝 开发规范

### 1. 代码质量规范

#### TypeScript规范
- **严格模式**: 启用strict模式，确保类型安全
- **类型定义**: 所有API接口必须有完整的TypeScript类型定义
- **组件Props**: 所有组件Props必须定义接口
- **避免any**: 禁止使用any类型，使用具体类型或unknown

#### 命名规范
- **变量**: 使用camelCase，如`userName`
- **常量**: 使用UPPER_SNAKE_CASE，如`API_BASE_URL`
- **函数**: 使用camelCase，动词开头，如`handleSubmit`
- **类型/接口**: 使用PascalCase，如`UserInfo`
- **枚举**: 使用PascalCase，如`UserStatus`

#### 注释规范
```typescript
/**
 * 函数功能描述
 * 
 * @param param1 参数1描述
 * @param param2 参数2描述
 * @returns 返回值描述
 * @author 开发者姓名
 * @datetime 创建日期
 */
function exampleFunction(param1: string, param2: number): boolean {
  // 实现逻辑
  return true;
}
```

### 2. 性能优化规范

#### React性能优化
- **组件懒加载**: 使用React.lazy()进行路由级别的代码分割
- **状态优化**: 合理使用useState、useMemo、useCallback
- **列表渲染**: 大列表使用虚拟滚动或分页
- **图片优化**: 使用适当的图片格式和尺寸

#### 网络请求优化
- **请求缓存**: 合理使用缓存策略
- **防抖节流**: 搜索等高频操作使用防抖
- **错误处理**: 统一的错误处理机制

### 3. 安全规范

#### 数据安全
- **输入验证**: 所有用户输入必须进行验证
- **XSS防护**: 使用dangerouslySetInnerHTML时必须进行安全处理
- **权限控制**: 基于角色的访问控制(RBAC)

#### API安全
- **Token管理**: JWT token的安全存储和刷新
- **请求签名**: 重要API请求进行签名验证
- **HTTPS**: 生产环境必须使用HTTPS

---

## 🧪 测试规范

### 1. 单元测试
- **测试框架**: Jest + React Testing Library
- **覆盖率要求**: 核心业务逻辑覆盖率不低于80%
- **测试文件**: 与源文件同目录，使用`.test.tsx`后缀

### 2. 集成测试
- **E2E测试**: 使用Playwright进行端到端测试
- **API测试**: 关键API接口的集成测试

### 3. 测试用例规范
```typescript
// 测试用例示例
describe('MsdsMainList Component', () => {
  it('should render correctly', () => {
    // 测试组件正常渲染
  });
  
  it('should handle add operation', async () => {
    // 测试添加操作
  });
  
  it('should handle delete operation', async () => {
    // 测试删除操作
  });
});
```

---

## 🚀 部署规范

### 1. 构建配置
- **环境变量**: 使用.env文件管理不同环境配置
- **代码分割**: 合理配置chunk分割策略
- **资源优化**: 启用gzip压缩、资源缓存

### 2. 部署流程
1. **代码检查**: ESLint + TypeScript检查
2. **单元测试**: 运行所有测试用例
3. **构建打包**: 生成生产环境代码
4. **部署验证**: 部署后功能验证

### 3. 监控规范
- **错误监控**: 集成错误监控系统
- **性能监控**: 监控页面加载性能
- **用户行为**: 关键操作的用户行为分析

---

## 📚 文档规范

### 1. 代码文档
- **README**: 项目说明、安装运行指南
- **API文档**: 接口文档的维护和更新
- **组件文档**: 重要组件的使用说明

### 2. 变更记录
- **版本管理**: 使用语义化版本号
- **变更日志**: 详细记录每次变更内容
- **发布说明**: 重要版本的发布说明

---

## 🔧 工具配置

### 1. 开发工具
- **IDE**: 推荐使用VS Code
- **插件**: ESLint、Prettier、TypeScript、React相关插件
- **调试**: React DevTools、Redux DevTools

### 2. 代码质量工具
- **ESLint**: 代码规范检查
- **Prettier**: 代码格式化
- **Husky**: Git hooks管理
- **lint-staged**: 提交前代码检查

### 3. 构建工具
- **UmiJS**: 基于Webpack的构建工具
- **TypeScript**: 类型检查和编译
- **Less**: CSS预处理器

---

## 📋 项目检查清单

### 开发阶段
- [ ] 代码符合TypeScript严格模式要求
- [ ] 组件有完整的Props类型定义
- [ ] API服务有完整的类型定义
- [ ] 关键功能有单元测试覆盖
- [ ] 代码通过ESLint检查
- [ ] 代码格式符合Prettier规范

### 提交阶段
- [ ] 提交信息符合规范
- [ ] 代码通过pre-commit检查
- [ ] 相关文档已更新
- [ ] 测试用例已更新

### 发布阶段
- [ ] 所有测试用例通过
- [ ] 构建无错误和警告
- [ ] 性能指标符合要求
- [ ] 安全检查通过
- [ ] 部署文档已更新

---

## 🎯 持续改进

### 1. 代码审查
- **Pull Request**: 所有代码变更必须经过代码审查
- **审查标准**: 功能正确性、代码质量、性能影响
- **反馈机制**: 及时的审查反馈和改进建议

### 2. 技术债务管理
- **定期评估**: 定期评估和清理技术债务
- **重构计划**: 制定合理的重构计划
- **文档更新**: 及时更新相关文档

### 3. 团队协作
- **知识分享**: 定期的技术分享和讨论
- **最佳实践**: 总结和推广最佳实践
- **工具改进**: 持续改进开发工具和流程

---

**文档维护**: 本文档应随项目发展持续更新，确保规范的时效性和准确性。

**最后更新**: 2025-01-21
**下次审查**: 2025-04-21