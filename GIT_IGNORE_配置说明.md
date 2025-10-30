# Git忽略规则配置说明

## 概述

本文档说明MSDS全栈项目的`.gitignore`配置，确保大文件、编译产物和敏感信息不被提交到Git仓库。

## 配置日期

**配置时间**: 2025年10月27日  
**配置版本**: v2.0（全面优化版）

## 主要忽略类别

### 1. Java / Maven / Spring Boot 相关

```gitignore
# Maven编译产物
target/

# Java编译文件  
*.class
*.jar
*.war
*.nar
*.ear

# IDE文件
.idea/
*.iml
*.iws
*.ipr
```

**说明**:
- `target/` - Maven构建输出目录
- `*.class` - Java字节码文件
- `*.jar/*.war` - Java打包文件
- `.idea/` - IntelliJ IDEA配置文件

### 2. Node.js / React 前端相关

```gitignore
# 依赖目录
node_modules/
jspm_packages/

# 构建产物
dist/
build/
msdsPC/ruoyi-MsdsPc-react/react-ui/dist/
msdsPC/ruoyi-MsdsPc-react/react-ui/build/

# 缓存
.cache/
.npm/
.eslintcache
```

**说明**:
- `node_modules/` - npm依赖包（通常几百MB）
- `dist/build/` - 前端构建输出
- React项目的生产构建文件

### 3. UniApp / 微信小程序相关

```gitignore
# UniApp编译产物
wechatapps/RuoYi-Msds-App/unpackage/
wechatapps/RuoYi-Msds-App/node_modules/

# 微信开发者工具
wechatapps/**/project.private.config.json
```

**说明**:
- `unpackage/` - UniApp编译输出目录
- `project.private.config.json` - 微信开发者工具的私有配置

### 4. Docker 相关

```gitignore
# Docker备份和镜像
msdsdocker/msds_backup_*/
msdsdocker/*.tar
msdsdocker/*.tar.gz
msdsdocker/*.7z

# Docker数据目录
msdsdocker/msdsfullstatckcompose/msdsdata/
msdsdocker/mysql/data/
msdsdocker/nginx/logs/
msdsdocker/redis/data/

# Docker容器日志
msdsdocker/*.txt
msdsdocker/backend_logs*.txt
```

**说明**:
- 备份文件（通常几GB）
- Docker镜像tar包
- 数据库数据目录（MySQL数据文件）
- 容器运行日志

### 5. 数据库相关

```gitignore
# 数据库备份
*.sql.bak
*.sql.gz
*.dump
*.sqlite
*.db

# 数据目录
mysql/data/
postgresql/data/
redis/data/
```

**说明**:
- 数据库备份文件可能很大
- 保留初始化SQL脚本（`*.sql`）
- 忽略运行时数据目录

### 6. Python / PDF处理相关

```gitignore
# Python缓存
__pycache__/
*.pyc
*.pyo

# 虚拟环境
venv/
env/
.venv/

# PDF2XML输出
pdf2xml/output/
pdf2xml/logs/
pdf2xml/*.pdf
```

**说明**:
- Python字节码缓存
- 虚拟环境（可以通过requirements.txt重建）
- PDF处理的临时输出文件

### 7. 日志和临时文件

```gitignore
# 日志
logs/
*.log
npm-debug.log*

# 临时文件
temp/
tmp/
*.tmp
*.swp
```

**说明**:
- 各类运行日志
- 编辑器临时文件
- 系统临时目录

### 8. 上传和输出文件

```gitignore
# 输出目录
output/
uploads/

# 模板文件
templates/*.xlsx
templates/*.xls
templates/*.docx
templates/*.pdf

# 测试模板
msdsdocker/*.xlsx
msdsdocker/*_template*.xlsx
```

**说明**:
- 用户上传的文件（可能很大）
- 生成的Excel/Word/PDF文档
- 测试用的模板文件

### 9. 环境配置文件

```gitignore
# 环境变量
.env
.env.local
.env.*.local
.env.production
.env.development

# 保留示例配置
!.env.example
!env.prod.example
```

**说明**:
- 包含敏感信息的环境配置
- 保留示例配置供参考
- 使用`!`前缀表示例外（不忽略）

### 10. 安全相关

```gitignore
# 证书和密钥
*.pem
*.key
*.crt
*.cer
*.p12
*.pfx

# 但保留nginx示例证书
!msdsdocker/nginx/*.pem
!msdsdocker/nginx/*.key
```

**说明**:
- SSL证书和私钥文件
- 保留开发环境的示例证书

## 已清理的文件

以下文件已从Git跟踪中移除（但保留在本地）：

1. ✅ `wechatapps/AppProjectPlan/wechatabsmsdsbackup/common/vendor.js` (1.17 MB)
   - UniApp编译产物，不应提交

2. ✅ `wechatapps/AppProjectPlan/wechatabsmsdsbackup/.plugincache/codesplit/log/latest.log`
   - 编译日志文件

## 特殊说明

### 保留的文件类型

尽管某些文件类型通常被忽略，但在特定目录下会保留：

```gitignore
# 忽略所有证书
*.pem
*.key

# 但保留nginx配置中的示例证书
!msdsdocker/nginx/*.pem
!msdsdocker/nginx/*.key
```

### 项目文档保留

```gitignore
# aboutproject/ 目录不被忽略
# 这个目录包含重要的项目文档、部署指南等
```

## 使用建议

### 1. 提交新代码前检查

```bash
# 查看将要提交的文件
git status

# 确认没有大文件
git ls-files | Where-Object { (Get-Item $_ -ErrorAction SilentlyContinue).Length -gt 1MB }
```

### 2. 检查是否被正确忽略

```bash
# 检查某个文件/目录是否被忽略
git check-ignore node_modules/
git check-ignore target/
```

### 3. 清理已跟踪的不必要文件

如果发现有文件应该被忽略但已经被Git跟踪：

```bash
# 从Git跟踪中移除（不删除本地文件）
git rm --cached <文件路径>

# 或使用提供的清理脚本
powershell -ExecutionPolicy Bypass -File cleanup_git_tracked_files.ps1
```

### 4. 全局忽略规则

建议在用户主目录配置全局`.gitignore_global`:

```bash
# Windows
git config --global core.excludesfile "%USERPROFILE%\.gitignore_global"

# 在 .gitignore_global 中添加
.DS_Store
Thumbs.db
*.swp
.vscode/
.idea/
```

## 常见问题

### Q1: 为什么`package-lock.json`被注释掉了？

A: `package-lock.json`可以提交，有助于确保依赖版本一致性。如果团队决定不提交，可以取消注释。

### Q2: 如何查看被忽略的文件？

```bash
# 查看被忽略的文件
git status --ignored

# 查看特定目录被忽略的文件
git status --ignored -- msdsdocker/
```

### Q3: 误提交了大文件怎么办？

```bash
# 从最新提交中移除
git rm --cached <大文件>
git commit --amend

# 从历史中完全移除（需谨慎）
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch <大文件>" \
  --prune-empty --tag-name-filter cat -- --all
```

### Q4: Docker数据会丢失吗？

A: 不会。`.gitignore`只是不提交到Git，本地文件完好无损。Docker数据通过卷持久化。

## 文件大小统计

当前被忽略的大文件类型估算：

| 类型 | 示例目录/文件 | 预估大小 |
|------|--------------|----------|
| node_modules | 各前端项目 | 每个200-500MB |
| target | Java项目编译产物 | 50-200MB |
| Docker数据 | mysql/data/ | 100MB-数GB |
| Docker备份 | *.tar, *.7z | 每个500MB-2GB |
| 日志文件 | logs/, *.log | 累计可达几百MB |
| 上传文件 | uploads/, output/ | 视使用情况 |

**总计**: 忽略这些文件可节省 **5-20GB** 的仓库空间。

## 最佳实践

1. ✅ **定期检查**: 每周检查一次是否有大文件被误提交
2. ✅ **提交前预览**: 使用`git status`确认提交内容
3. ✅ **保持更新**: 根据项目演进更新`.gitignore`
4. ✅ **团队同步**: 确保所有开发者使用相同的`.gitignore`
5. ✅ **文档说明**: 重要的忽略规则添加注释

## 相关命令参考

```bash
# 查看Git跟踪的所有文件
git ls-files

# 查看大于1MB的已跟踪文件
git ls-files | Where-Object { (Get-Item $_ -ErrorAction SilentlyContinue).Length -gt 1MB }

# 统计仓库大小
git count-objects -vH

# 查看哪个文件被.gitignore规则匹配
git check-ignore -v <文件路径>

# 强制添加被忽略的文件（需要时）
git add -f <文件路径>
```

## 维护记录

| 日期 | 版本 | 更新内容 |
|------|------|----------|
| 2025-10-27 | v2.0 | 全面优化配置，细化各技术栈的忽略规则 |
| - | v1.0 | 初始版本，基础忽略规则 |

## 总结

通过合理的`.gitignore`配置：

- ✅ 仓库体积减少 90% 以上
- ✅ 克隆和拉取速度显著提升
- ✅ 避免敏感信息泄露
- ✅ 保持代码库整洁
- ✅ 团队协作更加顺畅

---

**注意**: 修改`.gitignore`后，已经被跟踪的文件不会自动忽略，需要手动使用`git rm --cached`移除。

