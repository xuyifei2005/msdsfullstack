# MSDS化学品安全数据表管理系统 - 项目开发规则

**版本**: v1.0  
**创建日期**: 2025-01-21  
**最后更新**: 2025-01-21  
**维护者**: 高级系统架构师

---
# msds_backend
你现在是docker项目后台程序处理。


## 📋 项目概述

### 项目简介
MSDS化学品安全数据表管理系统是一个基于若依(RuoYi-React)框架开发的企业级化学品安全管理平台。系统采用前后端分离架构，实现对危险化学品MSDS信息的集中、高效、安全管理。

### 技术架构
- **前端**: React 18 + Ant Design Pro 6 + TypeScript 5 + UmiJS 4
- **后端**: Spring Boot 3.3.0 + Spring Security + MyBatis + MySQL 8
- **开发工具**: Maven 3.8.7 + Node.js 18+ + JDK 17/21
- **部署**: Docker + Linux

### 项目结构
```
/app/
├── react-ui/                 # 前端React项目
├── ruoyi-admin/              # 后端管理模块
├── ruoyi-common/             # 公共模块
├── ruoyi-framework/          # 框架核心
├── ruoyi-generator/          # 代码生成器
├── ruoyi-quartz/             # 定时任务
├── ruoyi-system/             # 系统模块
├── sql/                      # 数据库脚本
└── pom.xml                   # Maven主配置
```

---

## 🎯 开发原则与规范

### 1. 基本软件设计原则

#### DRY (Don't Repeat Yourself)
- 避免重复代码，提取公共组件和工具类
- 统一的API响应格式和错误处理
- 复用已有的业务逻辑和数据模型

#### KISS (Keep It Simple, Stupid)
- 保持代码简洁明了，避免过度设计
- 优先使用框架提供的标准功能
- 避免不必要的复杂抽象

#### SOLID原则
- **单一职责原则**: 每个类和方法只负责一个功能
- **开闭原则**: 对扩展开放，对修改关闭
- **里氏替换原则**: 子类可以替换父类
- **接口隔离原则**: 使用多个专门的接口
- **依赖倒置原则**: 依赖抽象而不是具体实现

### 2. 代码质量要求

#### 测试要求
- 所有代码都要经过测试，确保没有bug
- 单元测试覆盖率不低于70%
- 集成测试覆盖核心业务流程
- 使用Jest进行前端测试，JUnit进行后端测试

#### 性能优化
- 所有代码都要经过优化，确保性能最优
- 数据库查询优化，避免N+1问题
- 前端组件懒加载和虚拟滚动
- 合理使用缓存机制

#### 代码注释
- 所有代码都要经过注释，确保可读性
- 类和方法必须有完整的JavaDoc/JSDoc注释
- 复杂业务逻辑必须有详细说明
- 注释要与代码保持同步更新

#### 代码格式化
- 所有代码都要经过格式化，确保风格统一
- 使用ESLint + Prettier进行前端代码格式化
- 使用Checkstyle进行后端代码格式化
- 统一的缩进、命名和换行规范

#### 版本控制
- 所有代码都要经过版本控制，确保历史记录
- 使用Git进行版本管理
- 提交信息要清晰明确，遵循约定式提交规范
- 重要功能开发使用分支管理

#### 自动化测试
- 所有代码都要经过自动化测试，确保稳定性
- 配置CI/CD流水线
- 代码提交前自动运行测试
- 部署前进行完整的回归测试

---

## 🏗️ 架构设计规范

### 1. 后端架构规范

#### 分层架构
```
Controller层 -> Service层 -> Mapper层 -> Database
```

#### 包结构规范
```java
com.ruoyi.system
├── controller/          # 控制器层
├── service/            # 服务接口层
│   └── impl/           # 服务实现层
├── mapper/             # 数据访问层
├── domain/             # 实体类
└── dto/                # 数据传输对象
```

#### 命名规范
- **Controller**: `XxxController`
- **Service接口**: `IXxxService`
- **Service实现**: `XxxServiceImpl`
- **Mapper接口**: `XxxMapper`
- **实体类**: `Xxx`
- **DTO**: `XxxDto`

#### API设计规范
- 遵循RESTful API设计原则
- 统一的响应格式：`AjaxResult`
- 统一的异常处理机制
- 完整的权限控制注解

### 2. 前端架构规范

#### 目录结构
```typescript
src/
├── components/         # 公共组件
├── pages/             # 页面组件
│   └── Msds/          # MSDS模块
│       ├── index.tsx  # 列表页
│       └── components/ # 模块组件
├── services/          # API服务层
├── types/             # TypeScript类型定义
├── utils/             # 工具函数
└── locales/           # 国际化配置
```

#### 组件设计规范
- 使用函数式组件和Hooks
- 组件职责单一，可复用性强
- 使用TypeScript进行类型约束
- 遵循Ant Design Pro组件规范

#### 状态管理
- 使用React内置状态管理
- 复杂状态使用useReducer
- 全局状态使用Context API
- 服务端状态使用React Query

---

## 📝 编码规范

### 1. Java编码规范

#### 类和方法设计
```java
/**
 * MSDS主信息服务实现类
 * 
 * @author ruoyi
 * @date 2024-12-26
 */
@Service
public class MsdsMainServiceImpl implements IMsdsMainService {
    
    @Autowired
    private MsdsMainMapper msdsMainMapper;
    
    /**
     * 查询MSDS主信息列表
     * 
     * @param msdsMain 查询条件
     * @return MSDS主信息列表
     */
    @Override
    public List<MsdsMain> selectMsdsMainList(MsdsMain msdsMain) {
        return msdsMainMapper.selectMsdsMainList(msdsMain);
    }
}
```

#### 异常处理
- 使用统一的异常处理机制
- 自定义业务异常类
- 记录详细的错误日志
- 返回用户友好的错误信息

### 2. TypeScript编码规范

#### 类型定义
```typescript
// API命名空间
declare namespace API {
  namespace Msds {
    /** MSDS主信息 */
    interface MsdsMain {
      id?: number;
      casNumber?: string;
      msdsCode?: string;
      productName: string;
      // ... 其他字段
    }
    
    /** 查询参数 */
    interface MsdsMainListParams {
      pageNum?: number;
      pageSize?: number;
      productName?: string;
      // ... 其他查询条件
    }
  }
}
```

#### 组件设计
```typescript
interface MsdsFormProps {
  visible: boolean;
  onCancel: () => void;
  onSubmit: (values: API.Msds.MsdsMain) => Promise<boolean>;
  initialValues?: Partial<API.Msds.MsdsMain>;
}

const MsdsForm: React.FC<MsdsFormProps> = ({
  visible,
  onCancel,
  onSubmit,
  initialValues
}) => {
  // 组件实现
};
```

---

## 🔧 开发工具配置

### 1. 开发环境要求

#### 后端环境
- **JDK**: 17+ (推荐21)
- **Maven**: 3.8.7+
- **MySQL**: 8.0+
- **Redis**: 6.0+ (可选)

#### 前端环境
- **Node.js**: 18.0+
- **npm**: 9.0+
- **TypeScript**: 5.0+

### 2. IDE配置

#### VS Code配置
```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "typescript.preferences.importModuleSpecifier": "relative"
}
```

#### IDEA配置
- 安装Lombok插件
- 配置代码格式化规则
- 启用自动导入优化

---

## 🚀 部署与运维规范

### 1. 构建部署

#### 后端构建
```bash
# 编译打包
mvn clean package -Dmaven.test.skip=true

# 运行应用
java -jar ruoyi-admin.jar
```

#### 前端构建
```bash
# 安装依赖
npm install

# 开发环境
npm run dev

# 生产构建
npm run build
```

### 2. 环境配置

#### 开发环境
- 后端端口：8080
- 前端端口：8000
- 数据库：本地MySQL

#### 生产环境
- 使用Docker容器化部署
- 配置负载均衡和反向代理
- 数据库集群和备份策略

---

## 📊 项目管理规范

### 1. 进度管理

#### 开发阶段划分
1. **需求分析阶段** (已完成)
2. **架构设计阶段** (已完成)
3. **核心功能开发** (进行中)
4. **系统集成测试** (待开始)
5. **部署上线** (待开始)

#### 进度记录要求
- 每次完成一个特性或修复一个错误，随时更新进度记录
- 更新到文件夹`react-ui/AboutProject/ProjectOk`下
- 以时间+功能命名格式：`YYYYMMDD-功能描述.md`

### 2. 文档管理

#### 文档结构
```
AboutProject/
├── InterfaceApi/           # 接口文档
├── ProgressPlan/           # 进度计划
├── ProjectOk/              # 项目实现记录
├── TechnicalManual/        # 技术说明书
├── doc/                    # 项目文档
└── msdsdatabases/          # 数据库文档
```

#### 文档更新规范
- 重要功能完成后及时更新技术文档
- API变更后及时更新接口文档
- 数据库结构变更后更新数据库文档

---

## 🔍 代码审查规范

### 1. 审查要点

#### 功能性审查
- 功能是否按需求正确实现
- 边界条件和异常情况处理
- 性能是否满足要求

#### 代码质量审查
- 代码结构是否清晰
- 命名是否规范
- 注释是否完整
- 是否遵循设计原则

### 2. 审查流程
1. 开发者自测
2. 同行代码审查
3. 技术负责人审查
4. 合并到主分支

---

## 🛡️ 安全规范

### 1. 数据安全
- 敏感数据加密存储
- SQL注入防护
- XSS攻击防护
- CSRF攻击防护

### 2. 访问控制
- 基于角色的权限控制(RBAC)
- JWT令牌认证
- 接口权限验证
- 数据权限控制

### 3. 日志审计
- 记录关键操作日志
- 登录日志记录
- 异常日志监控
- 定期日志分析

---

## 📈 性能优化规范

### 1. 数据库优化
- 合理设计索引
- 避免N+1查询问题
- 使用分页查询
- 定期分析慢查询

### 2. 前端优化
- 组件懒加载
- 图片懒加载
- 虚拟滚动
- 代码分割

### 3. 缓存策略
- Redis缓存热点数据
- 浏览器缓存静态资源
- CDN加速
- 数据库查询缓存

---

## 🔧 故障排查规范

### 1. 问题分类
- **P0**: 系统崩溃，影响所有用户
- **P1**: 核心功能异常，影响大部分用户
- **P2**: 部分功能异常，影响少数用户
- **P3**: 优化建议，不影响正常使用

### 2. 排查流程
1. 问题复现
2. 日志分析
3. 代码审查
4. 环境检查
5. 修复验证
6. 总结归档

### 3. 思维链推理进行代码Debug
当遇到复杂问题时，使用系统性的思维链推理方法：

#### 问题分析链
1. **现象描述**: 详细记录问题表现
2. **环境分析**: 检查运行环境和配置
3. **代码追踪**: 从入口点开始逐步追踪
4. **数据验证**: 检查数据流和状态变化
5. **假设验证**: 提出假设并逐一验证
6. **根因定位**: 找到问题的根本原因
7. **解决方案**: 制定修复方案
8. **验证测试**: 确认问题已解决

#### Debug最佳实践
- 使用断点调试而不是print调试
- 保持调试日志的完整性
- 记录每次修改的依赖影响
- 从整体架构角度审视修改点

---

## 📋 变更管理规范

### 1. 变更原则
- 每处的修改需要从整体上审视相关依赖
- 所有涉及到的地方都要同步修改，不可漏改、漏删
- 也不可多改、多删，保持修改的精确性
- 重要变更需要经过评审

### 2. 变更流程
1. **变更申请**: 提交变更需求和影响分析
2. **影响评估**: 分析变更对系统的影响范围
3. **方案设计**: 制定详细的变更方案
4. **代码审查**: 对变更代码进行审查
5. **测试验证**: 进行充分的测试
6. **部署实施**: 按计划实施变更
7. **效果验证**: 验证变更效果
8. **文档更新**: 更新相关文档

### 3. 回滚策略
- 制定回滚计划
- 保留变更前的备份
- 快速回滚机制
- 回滚后的验证

---

## 📚 学习与成长

### 1. 技术栈学习路径

#### 后端技术
- Spring Boot官方文档
- MyBatis官方文档
- MySQL性能优化
- Redis使用最佳实践

#### 前端技术
- React官方文档
- TypeScript官方文档
- Ant Design Pro文档
- UmiJS官方文档

### 2. 代码质量提升
- 定期进行代码重构
- 学习设计模式
- 关注性能优化
- 参与开源项目

---

## 📞 联系与支持

### 技术支持
- 项目负责人：高级系统架构师
- 技术文档：`/app/react-ui/AboutProject/`
- 问题反馈：通过项目管理工具提交

### 相关资源
- 若依官方文档：http://doc.ruoyi.vip/
- React官方文档：https://react.dev/
- Ant Design Pro：https://pro.ant.design/
- Spring Boot官方文档：https://spring.io/projects/spring-boot

---

**文档版本**: v1.0  
**最后更新**: 2025-01-21  
**下次审查**: 2025-02-21

---

*本文档是MSDS化学品安全数据表管理系统的核心开发规范，所有团队成员都应严格遵守。如有疑问或建议，请及时反馈。*