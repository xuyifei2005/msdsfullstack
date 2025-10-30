# MSDS Word文档测试指南

本目录包含MSDS系统中Word文档处理功能的完整测试套件，包括前端组件测试和后端集成测试。

## 📁 测试文件结构

```
tests/
├── README.md                          # 本文档
├── setupTests.jsx                      # 测试环境配置
├── vitest.config.ts                    # Vitest配置文件
├── msds.preview.test.tsx               # MSDS预览功能测试
├── msds.word.upload.test.tsx           # Word文档上传功能测试
└── results/                            # 测试结果输出目录
    ├── test-results.json
    └── test-results.html
```

## 🧪 测试覆盖范围

### 前端测试 (React/TypeScript)

#### 1. Word文档上传测试 (`msds.word.upload.test.tsx`)
- ✅ 组件渲染验证
- ✅ DOC格式文件上传支持
- ✅ DOCX格式文件上传支持
- ✅ 特殊字符和编码处理
- ✅ 文件大小限制验证 (50MB)
- ✅ 文件类型验证
- ✅ 上传进度显示
- ✅ 解析结果展示
- ✅ 错误处理和用户反馈
- ✅ 多次上传支持
- ✅ 空文件处理

#### 2. MSDS预览测试 (`msds.preview.test.tsx`)
- ✅ 预览页面渲染
- ✅ 章节和字段显示
- ✅ 结构化数据处理
- ✅ 状态标签显示

### 后端测试 (Java/Spring Boot)

#### 1. 单元测试 (`MsdsWordDocumentParsingTest.java`)
- ✅ DOC格式文档解析
- ✅ DOCX格式文档解析
- ✅ 基本字段提取 (产品名称、CAS号、企业信息等)
- ✅ 表格结构解析
- ✅ 特殊字符和编码处理
- ✅ 无效文件处理
- ✅ 空文件处理
- ✅ 数据校验规则验证
- ✅ 文件名信息提取
- ✅ 性能基准测试

#### 2. 集成测试 (`MsdsWordDocumentIntegrationTest.java`)
- ✅ 完整导入流程测试
- ✅ 数据库存储验证
- ✅ 批量导入处理
- ✅ 错误恢复机制
- ✅ 数据一致性验证
- ✅ 事务处理测试

## 🗂️ 测试数据文件

测试使用以下数据文件 (位于 `test_msds_files/` 目录):

- `toluene_test.doc` - 甲苯MSDS文档 (DOC格式)
- `acetone_test.docx` - 丙酮MSDS文档 (DOCX格式，包含表格)
- `ethanol_special_chars_test.doc` - 乙醇MSDS文档 (包含特殊字符)
- `benzene_test.txt` - 苯MSDS文档 (TXT格式，用于对比测试)

## 🚀 运行测试

### 快速开始

```bash
# 安装依赖
npm install

# 运行所有Word文档相关测试
npm run test:word

# 运行特定测试
npm run test:word:upload    # 只测试上传功能
npm run test:word:preview   # 只测试预览功能

# 生成覆盖率报告
npm run test:word:coverage

# 监听模式 (开发时使用)
npm run test:word:watch
```

### 使用测试脚本

```bash
# 使用自定义测试脚本
node scripts/run-word-tests.js [命令]

# 可用命令:
# all          - 运行所有测试
# word         - 只运行Word文档相关测试
# upload       - 只运行上传功能测试
# preview      - 只运行预览功能测试
# coverage     - 运行测试并生成覆盖率报告
# watch        - 监听模式运行测试
# ci           - CI模式运行测试
```

### 使用Vitest UI

```bash
# 启动Vitest UI界面
npm run test:vitest:ui
```

## 📊 测试报告

测试完成后，报告文件将生成在以下位置:

- `tests/results/test-results.json` - JSON格式测试结果
- `tests/results/test-results.html` - HTML格式测试报告
- `coverage/` - 代码覆盖率报告 (如果启用)

## 🔧 配置说明

### Vitest配置 (`vitest.config.ts`)

- **测试环境**: jsdom (模拟浏览器环境)
- **覆盖率目标**: 80% (分支、函数、行、语句)
- **超时设置**: 10秒
- **并发**: 最多4个线程
- **报告器**: verbose, json, html

### 测试环境设置 (`setupTests.jsx`)

- 配置 `@testing-library/jest-dom` 匹配器
- 设置全局测试环境变量
- 配置Mock和Polyfill

## 🐛 故障排除

### 常见问题

1. **测试文件未找到**
   ```bash
   # 确保测试数据文件存在
   ls ../../../test_msds_files/
   ```

2. **依赖安装失败**
   ```bash
   # 清理缓存并重新安装
   npm cache clean --force
   npm install
   ```

3. **测试超时**
   - 检查网络连接
   - 增加测试超时时间 (在 `vitest.config.ts` 中)

4. **覆盖率不足**
   - 查看覆盖率报告，识别未测试的代码路径
   - 添加更多测试用例覆盖边界情况

### 调试技巧

```bash
# 运行单个测试文件
npx vitest tests/msds.word.upload.test.tsx

# 启用详细输出
npx vitest --reporter=verbose

# 调试模式
npx vitest --inspect-brk
```

## 📝 编写新测试

### 测试文件命名规范

- 单元测试: `*.test.{ts,tsx}`
- 集成测试: `*.integration.test.{ts,tsx}`
- E2E测试: `*.e2e.test.{ts,tsx}`

### 测试结构示例

```typescript
import { describe, it, expect, beforeEach, vi } from 'vitest';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';

describe('功能模块测试', () => {
  beforeEach(() => {
    // 测试前置设置
    vi.clearAllMocks();
  });

  it('应该正确处理正常情况', async () => {
    // 准备测试数据
    const testData = { /* ... */ };
    
    // 执行测试
    render(<Component {...testData} />);
    
    // 验证结果
    expect(screen.getByText('预期文本')).toBeInTheDocument();
  });

  it('应该正确处理错误情况', async () => {
    // 错误情况测试
  });
});
```

## 🔄 持续集成

### CI/CD配置建议

```yaml
# .github/workflows/test.yml 示例
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm ci
      - run: npm run test:word:ci
      - uses: codecov/codecov-action@v3
        with:
          file: ./coverage/lcov.info
```

## 📚 相关文档

- [Vitest 官方文档](https://vitest.dev/)
- [Testing Library 文档](https://testing-library.com/)
- [Jest DOM 匹配器](https://github.com/testing-library/jest-dom)
- [Ant Design 测试指南](https://ant.design/docs/react/getting-started#Test)

## 🤝 贡献指南

1. 新增功能时，必须添加对应的测试用例
2. 确保测试覆盖率不低于80%
3. 遵循现有的测试命名和结构规范
4. 提交前运行完整测试套件
5. 更新相关文档

---

**注意**: 本测试套件专门针对MSDS Word文档处理功能设计，确保系统能够可靠地处理各种格式和内容的Word文档。