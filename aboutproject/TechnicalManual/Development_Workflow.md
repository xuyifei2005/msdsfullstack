# MSDS项目开发工作流指南

## 概述

本文档定义了MSDS实验室管理系统从需求到部署的完整开发工作流，确保开发过程标准化、可追溯、高质量。

## 工作流概览

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   需求分析   │ -> │   技术设计   │ -> │   编码实现   │ -> │   测试验证   │ -> │   部署上线   │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
       │                  │                  │                  │                  │
       ▼                  ▼                  ▼                  ▼                  ▼
  requirements-    architecture-    msds-fullstack-  testing-         deployment-
  analyst          designer         developer        validation-      executor
                                                         expert
```

## 阶段一：需求分析

### 1.1 输入
- 业务需求描述
- 用户反馈
- 系统问题报告
- 竞品分析

### 1.2 活动
```bash
# 使用 requirements-analyst 分解需求
# 示例：创建新功能的需求分析
```

### 1.3 输出
- **产品需求文档 (PRD)**
  - 功能描述
  - 用户故事
  - 验收标准
  - 优先级
- **用户故事地图**
- **UI/UX原型** (如需要)

### 1.4 检查清单
- [ ] 需求明确、可测试
- [ ] 验收标准定义清晰
- [ ] 相关方已评审
- [ ] 技术可行性已评估

## 阶段二：技术设计

### 2.1 输入
- PRD文档
- 现有系统架构
- 技术约束

### 2.2 活动
```bash
# 使用 architecture-designer 设计技术方案
# 包括：
# - 数据库设计
# - API设计
# - 模块划分
# - 接口定义
```

### 2.3 输出
- **技术设计文档**
  - 架构图
  - 数据库ER图
  - API接口定义
  - 模块交互图
- **任务分解清单**
- **时间估算**

### 2.4 检查清单
- [ ] 架构符合项目规范
- [ ] 数据库设计已评审
- [ ] API设计符合RESTful规范
- [ ] 安全考虑已纳入设计
- [ ] 性能影响已评估

## 阶段三：编码实现

### 3.1 输入
- 技术设计文档
- 任务分解清单

### 3.2 开发环境准备
```bash
# 1. 确保Docker环境运行
docker-compose -f msdsdocker/docker-compose.yml ps

# 2. 创建功能分支
git checkout -b feature/功能名称

# 3. 启动开发容器
docker-compose -f msdsdocker/docker-compose.yml up -d
```

### 3.3 编码规范

#### 后端开发 (Spring Boot)
```java
// 包命名规范
package com.ruoyi.msds.module.service.impl;

// 类命名规范 - 大驼峰
public class MsdsChemicalServiceImpl implements IMsdsChemicalService {
    
    // 方法命名规范 - 小驼峰
    // 查询方法以 get/select/query 开头
    // 新增方法以 add/insert/create 开头
    // 更新方法以 update/modify 开头
    // 删除方法以 delete/remove 开头
    
    @Override
    public MsdsChemical getByCasNumber(String casNumber) {
        // 实现逻辑
    }
}
```

#### 前端开发 (React)
```typescript
// 组件命名 - 大驼峰
// 文件命名 - 大驼峰.tsx

// 接口命名规范
interface MsdsChemicalProps {
  casNumber: string;
  onUpdate: (data: MsdsChemical) => void;
}

// Hook命名规范 - use前缀
const useMsdsSearch = () => {
  // 实现逻辑
};
```

### 3.4 代码审查
```bash
# 提交前自检
npm run lint        # 前端代码检查
mvn checkstyle:check # 后端代码检查

# 提交代码
git add .
git commit -m "feat(msds): 添加化学品搜索功能

- 实现按CAS号搜索
- 添加分页功能
- 优化查询性能

Closes #123"
```

### 3.5 检查清单
- [ ] 代码符合项目规范
- [ ] 单元测试已编写 (覆盖率≥70%)
- [ ] 代码注释完整
- [ ] 无安全漏洞
- [ ] 性能已优化

## 阶段四：测试验证

### 4.1 测试层次

```
┌─────────────────────────────────────┐
│         端到端测试 (E2E)             │  10%
│     验证完整业务流程                │
├─────────────────────────────────────┤
│         集成测试                     │  30%
│     验证模块间交互                  │
├─────────────────────────────────────┤
│         单元测试                     │  60%
│     验证单个函数/组件               │
└─────────────────────────────────────┘
```

### 4.2 测试活动

#### 单元测试
```bash
# 后端单元测试
mvn test

# 前端单元测试
npm test
```

#### 集成测试
```bash
# API测试
# 使用 api-debug-tester 验证接口

# 数据库测试
# 使用 database-expert 验证数据操作
```

#### 性能测试
```bash
# 使用 performance-optimizer 进行性能测试
# 目标：API响应 < 500ms
```

### 4.3 检查清单
- [ ] 单元测试覆盖率≥70%
- [ ] 集成测试通过
- [ ] 性能测试达标
- [ ] 安全测试通过
- [ ] 回归测试完成

## 阶段五：部署上线

### 5.1 部署环境

| 环境 | 用途 | 部署频率 |
|------|------|----------|
| 开发环境 | 日常开发 | 按需 |
| 测试环境 | 功能测试 | 每日 |
| 预生产环境 | 上线前验证 | 每次发布 |
| 生产环境 | 正式服务 | 按计划 |

### 5.2 部署流程

#### 开发环境部署
```bash
# 1. 构建Docker镜像
docker-compose -f msdsdocker/docker-compose.yml build

# 2. 启动服务
docker-compose -f msdsdocker/docker-compose.yml up -d

# 3. 查看日志
docker-compose -f msdsdocker/docker-compose.yml logs -f
```

#### 生产环境部署
```bash
# 1. 使用CI/CD流水线
# GitHub Actions自动触发

# 2. 手动部署（备用方案）
./deploy-scripts/deploy-production.sh
```

### 5.3 部署检查清单
- [ ] 数据库迁移脚本已执行
- [ ] 配置文件已更新
- [ ] 健康检查通过
- [ ] 监控告警已配置
- [ ] 回滚方案已准备

## 工作流工具链

### 推荐的Agent组合

| 阶段 | 主要Agent | 辅助Agent |
|------|----------|----------|
| 需求分析 | requirements-analyst | content-strategist |
| 技术设计 | architecture-designer | database-expert |
| 编码实现 | msds-fullstack-developer | code-generator-optimizer |
| 测试验证 | testing-validation-expert | api-debug-tester |
| 部署上线 | deployment-executor | devops-monitor |
| 性能优化 | performance-optimizer | system-tuning-master |
| 安全审查 | security-architect | compliance-validator |

### MCP工具使用

```json
{
  "development": {
    "mysql": "数据库操作和查询",
    "redis": "缓存管理和Session查看",
    "docker": "容器管理和日志查看",
    "github": "代码提交和PR管理"
  },
  "monitoring": {
    "devops-monitor": "服务健康检查",
    "performance-optimizer": "性能监控"
  },
  "project-management": {
    "clickup": "任务跟踪和进度管理"
  }
}
```

## 质量保证

### 代码质量门禁

```yaml
# 提交前检查
pre-commit:
  - eslint --fix
  - prettier --write
  - mvn checkstyle:check
  - mvn test
  - mvn jacoco:check (coverage >= 70%)

# PR合并前检查
pre-merge:
  - code-review (至少1人)
  - ci-build-success
  - test-coverage >= 70%
  - no-security-issues
```

### 文档要求

每个功能必须包含：
- [ ] 技术设计文档
- [ ] API文档 (OpenAPI注解)
- [ ] 代码注释 (JavaDoc/TSDoc)
- [ ] 更新日志

## 故障处理

### 开发环境问题
```bash
# 容器启动失败
docker-compose down
docker-compose up -d --build

# 数据库连接问题
docker-compose restart msdsmysql
# 检查连接配置
```

### 代码问题
```bash
# 使用 debugging-expert 定位问题
# 使用 troubleshooting-expert 解决复杂问题
```

### 部署问题
```bash
# 查看服务日志
docker-compose logs -f [service-name]

# 回滚到上一个版本
./deploy-scripts/rollback.sh
```

## 持续改进

### 定期回顾
- **每周**: 开发进度回顾
- **每月**: 工作流优化讨论
- **每季度**: 工具和流程评估

### 度量指标
- 需求交付周期
- 代码缺陷率
- 测试覆盖率
- 部署频率
- 平均恢复时间 (MTTR)

---

**文档维护**: MSDS开发团队  
**最后更新**: 2024-01-30  
**版本**: 1.0.0
