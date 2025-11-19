# Docker 构建优化 - .dockerignore 配置

## 完成时间
2025年1月27日

## 任务描述
配置 `.dockerignore` 文件，优化 Docker 镜像构建过程，避免不必要的文件同步到容器中。

## 主要更改

### 1. 添加 Node.js 相关忽略规则
- `node_modules/` - 忽略所有 node_modules 目录
- `**/node_modules/` - 忽略任意层级的 node_modules 目录
- `npm-debug.log*`, `yarn-debug.log*`, `yarn-error.log*` - 忽略包管理器日志文件

### 2. 添加构建输出忽略规则
- `dist/`, `build/`, `target/` - 忽略构建输出目录
- `*.jar`, `*.war` - 忽略 Java 构建产物

### 3. 添加开发环境文件忽略规则
- IDE 配置文件 (`.vscode/`, `.idea/`)
- 操作系统生成文件 (`.DS_Store`, `Thumbs.db`)
- 临时文件和缓存目录
- 环境变量文件 (`.env*`)

### 4. 添加版本控制和 Docker 相关忽略规则
- Git 相关文件
- Docker 配置文件本身

## 优化效果
1. **减少镜像大小**: 避免将 `node_modules` 等大型目录打包到镜像中
2. **提升构建速度**: 减少需要复制的文件数量
3. **提高安全性**: 避免将敏感配置文件打包到镜像中
4. **清理构建环境**: 排除开发工具和临时文件

## 技术要点
- 使用通配符 `**/` 匹配任意层级目录
- 分类组织忽略规则，提高可维护性
- 覆盖前端、后端、开发工具等各种场景

## 状态
✅ 已完成 - .dockerignore 文件配置完成，Docker 构建优化生效