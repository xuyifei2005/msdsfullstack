# MSDS系统CI/CD使用指南

> **现代化自动部署 - 让部署像喝水一样简单** 🚀

---

## 📖 目录

1. [系统概述](#系统概述)
2. [快速开始](#快速开始)
3. [日常使用](#日常使用)
4. [高级功能](#高级功能)
5. [故障排查](#故障排查)
6. [最佳实践](#最佳实践)

---

## 🎯 系统概述

### 什么是CI/CD？

**CI (Continuous Integration)** - 持续集成
- 自动运行测试
- 自动构建代码
- 及早发现问题

**CD (Continuous Deployment)** - 持续部署
- 自动部署到服务器
- 零停机更新
- 快速回滚

### 自动化流程

```
代码提交 → 自动测试 → 自动构建 → 自动部署 → 健康检查
   ↓          ↓          ↓          ↓         ↓
 30秒       2分钟      3分钟      1分钟     30秒
```

**总耗时**: ~7分钟（完全自动，无需人工干预）

---

## 🚀 快速开始

### 前置条件检查

确保以下配置已完成：

- ✅ GitHub仓库已创建
- ✅ GitHub Secrets已配置（参考[GitHub_Secrets配置指南.md](./GitHub_Secrets配置指南.md)）
- ✅ 服务器Docker环境已就绪
- ✅ 阿里云镜像仓库已开通

### 第一次部署

#### 1. 配置GitHub Secrets

```bash
# 必需的Secrets（在GitHub仓库设置中添加）
ALIYUN_REGISTRY_USERNAME    # 阿里云镜像仓库用户名
ALIYUN_REGISTRY_PASSWORD    # 阿里云镜像仓库密码
PRODUCTION_HOST             # 生产服务器IP (39.107.211.72)
PRODUCTION_USER             # SSH用户名
PRODUCTION_SSH_KEY          # SSH私钥
```

详细配置步骤见：[GitHub_Secrets配置指南.md](./GitHub_Secrets配置指南.md)

#### 2. 推送代码触发部署

```bash
# 确保在main分支
git checkout main

# 提交代码
git add .
git commit -m "feat: 启用CI/CD自动部署"

# 推送到GitHub（自动触发部署）
git push origin main
```

#### 3. 观察部署进度

1. 访问GitHub Actions页面
   ```
   https://github.com/你的用户名/msdsfullstack/actions
   ```

2. 点击最新的workflow run查看实时日志

3. 等待约7分钟，部署完成

#### 4. 验证部署结果

```bash
# 访问系统
https://flymsds.cn

# 健康检查
curl https://flymsds.cn/health
```

---

## 💼 日常使用

### 功能开发流程

```bash
# 1. 创建功能分支
git checkout -b feature/new-feature

# 2. 开发功能
# ... 编写代码 ...

# 3. 提交到功能分支
git add .
git commit -m "feat: 添加新功能"
git push origin feature/new-feature

# 4. 创建Pull Request
# 在GitHub上创建PR，会自动运行测试

# 5. 代码审查通过后，合并到main
# 合并后自动触发生产环境部署
```

### 部署到不同环境

#### 生产环境（main分支）

```bash
git checkout main
git merge feature/new-feature
git push origin main
# ✅ 自动部署到生产环境 (https://flymsds.cn)
```

#### 测试环境（develop分支）

```bash
git checkout develop
git merge feature/new-feature
git push origin develop
# ✅ 自动部署到测试环境
```

### 查看部署状态

#### 方式一：GitHub网页

1. 进入Actions页面
   ```
   GitHub仓库 → Actions
   ```

2. 查看workflow运行状态
   - 🟢 绿色勾：成功
   - 🔴 红叉：失败
   - 🟡 黄圈：运行中

3. 点击具体的run查看详细日志

#### 方式二：GitHub CLI

```bash
# 安装GitHub CLI
scoop install gh  # Windows
brew install gh   # Mac

# 登录
gh auth login

# 查看workflow运行状态
gh run list

# 查看最新run的详细信息
gh run view

# 实时查看日志
gh run watch
```

#### 方式三：命令行查询

```bash
# 使用curl查询（需要GitHub token）
curl -H "Authorization: token YOUR_GITHUB_TOKEN" \
  https://api.github.com/repos/你的用户名/msdsfullstack/actions/runs
```

---

## 🎨 高级功能

### 1. 手动触发部署

#### 在GitHub网页上

```
Actions → 选择workflow → Run workflow → 选择分支 → Run
```

#### 使用GitHub CLI

```bash
# 触发main分支部署
gh workflow run deploy.yml --ref main

# 触发develop分支部署
gh workflow run deploy.yml --ref develop
```

### 2. 回滚到指定版本

#### 方式一：Git Revert（推荐）

```bash
# 1. 找到要回滚的commit
git log --oneline

# 2. Revert指定commit
git revert <commit-hash>

# 3. 推送（自动触发重新部署）
git push origin main
```

#### 方式二：手动回滚

```bash
# SSH登录服务器
ssh root@39.107.211.72

# 切换到项目目录
cd /opt/msds/msdsdocker

# 拉取指定版本镜像
docker pull registry.cn-beijing.aliyuncs.com/msds/backend:v1.0.0
docker pull registry.cn-beijing.aliyuncs.com/msds/frontend:v1.0.0

# 修改.env.prod
nano .env.prod
# 设置: BACKEND_TAG=v1.0.0
# 设置: FRONTEND_TAG=v1.0.0

# 重新部署
docker-compose -f docker-compose.prod.yml up -d
```

#### 方式三：重新运行之前的成功部署

```
GitHub Actions → 找到成功的run → Re-run all jobs
```

### 3. 部署特定镜像版本

```bash
# SSH到服务器
ssh root@39.107.211.72
cd /opt/msds/msdsdocker

# 编辑环境变量
nano .env.prod

# 修改镜像标签
BACKEND_TAG=main-abc1234  # 使用Git commit SHA
FRONTEND_TAG=main-abc1234

# 重新部署
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d
```

### 4. 查看构建产物

所有构建产物保存7天：

```
GitHub Actions → 选择workflow run → Artifacts
```

可下载的产物：
- `frontend-dist`: 前端构建产物
- `backend-jar`: 后端JAR文件

### 5. 跳过CI/CD

如果某次提交不想触发CI/CD：

```bash
git commit -m "docs: 更新文档 [skip ci]"
git push
```

关键词：`[skip ci]`, `[ci skip]`, `[no ci]`, `[skip actions]`

---

## 🔍 故障排查

### 问题1：构建失败

#### 前端构建失败

```bash
# 查看Actions日志定位错误
# 常见原因：
1. 依赖安装失败 → 检查package.json
2. TypeScript编译错误 → 本地运行 npm run build:prod
3. 测试失败 → 修复测试用例

# 本地复现错误
cd msdsPC/ruoyi-MsdsPc-react/react-ui
npm ci
npm run build:prod
```

#### 后端构建失败

```bash
# 常见原因：
1. Maven依赖下载失败 → 检查pom.xml
2. 编译错误 → 本地运行 mvn clean package
3. 单元测试失败 → 修复测试用例

# 本地复现错误
cd msdsPC/ruoyi-MsdsPc-react
mvn clean package -Pprod
```

### 问题2：Docker镜像推送失败

```bash
# 检查阿里云凭据
docker login registry.cn-beijing.aliyuncs.com \
  -u <用户名> -p <密码>

# 手动推送测试
docker tag msdsbackend:prod registry.cn-beijing.aliyuncs.com/msds/backend:test
docker push registry.cn-beijing.aliyuncs.com/msds/backend:test

# 检查镜像仓库配额
# 登录阿里云控制台 → 容器镜像服务 → 查看配额
```

### 问题3：部署到服务器失败

```bash
# SSH连接测试
ssh -i ~/.ssh/msds_deploy root@39.107.211.72

# 检查服务器状态
cd /opt/msds/msdsdocker
docker-compose -f docker-compose.prod.yml ps

# 查看部署日志
docker-compose -f docker-compose.prod.yml logs -f

# 手动执行部署脚本
./deploy.sh
```

### 问题4：健康检查失败

```bash
# 检查后端服务状态
docker logs msdsbackend-prod

# 检查前端服务状态
docker logs msdsnginx-prod

# 检查网络连接
curl http://localhost:8080/actuator/health
curl http://localhost/health

# 检查端口占用
netstat -tulpn | grep :8080
netstat -tulpn | grep :443
```

### 查看详细日志

```bash
# GitHub Actions日志
gh run view --log

# 服务器应用日志
ssh root@39.107.211.72
cd /opt/msds/msdsdocker
docker-compose logs -f --tail=100 msdsbackend
docker-compose logs -f --tail=100 msdsnginx

# 查看构建日志
docker logs msdsbackend-prod
```

---

## 💡 最佳实践

### 1. 分支管理策略

```
main (生产)
  ↑
develop (测试)
  ↑
feature/* (功能开发)
hotfix/* (紧急修复)
```

**规则**：
- `main`: 只接受来自`develop`或`hotfix`的合并
- `develop`: 功能测试通过后合并到此分支
- `feature/*`: 从`develop`创建，开发完成后合并回`develop`
- `hotfix/*`: 从`main`创建，修复后同时合并到`main`和`develop`

### 2. Commit规范

使用语义化提交信息：

```bash
feat: 新功能
fix: 修复bug
docs: 文档更新
style: 代码格式调整
refactor: 重构
test: 测试相关
chore: 构建/工具相关

# 示例
git commit -m "feat: 添加MSDS文档导出功能"
git commit -m "fix: 修复登录验证码不显示问题"
git commit -m "docs: 更新部署文档"
```

### 3. 部署时机

**推荐部署时间**：
- 🌙 夜间部署（凌晨2-4点）：用户访问量最低
- 🎯 重大更新提前通知用户
- ⚡ 紧急修复可随时部署

**避免部署时间**：
- ❌ 工作时间（9:00-18:00）
- ❌ 周五下午（无法及时处理问题）
- ❌ 节假日前（问题处理困难）

### 4. 监控与告警

```bash
# 配置部署完成通知（钉钉机器人）
# 在GitHub Secrets中添加：
DINGTALK_WEBHOOK=https://oapi.dingtalk.com/robot/send?access_token=xxx

# 配置健康检查告警
# crontab -e
*/5 * * * * curl -f https://flymsds.cn/health || \
  curl -X POST $DINGTALK_WEBHOOK \
    -H 'Content-Type: application/json' \
    -d '{"msgtype": "text", "text": {"content": "⚠️ MSDS系统健康检查失败！"}}'
```

### 5. 安全checklist

部署前检查：

- [ ] 所有密码已修改为强密码
- [ ] SSH密钥权限正确（600）
- [ ] 防火墙规则已配置
- [ ] HTTPS证书有效
- [ ] 数据库已备份
- [ ] 敏感信息未提交到Git

### 6. 性能优化

```yaml
# 在workflow中启用缓存
- name: 缓存Node modules
  uses: actions/cache@v3
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}

- name: 缓存Maven依赖
  uses: actions/cache@v3
  with:
    path: ~/.m2/repository
    key: ${{ runner.os }}-maven-${{ hashFiles('**/pom.xml') }}
```

### 7. 文档维护

**及时更新以下文档**：
- ✅ [快速部署指南.md](./快速部署指南.md) - 部署步骤
- ✅ [CICD使用指南.md](./CICD使用指南.md) - 本文档
- ✅ [GitHub_Secrets配置指南.md](./GitHub_Secrets配置指南.md) - 密钥配置
- ✅ Changelog - 版本变更记录

---

## 📊 部署指标

### 关键指标

| 指标 | 目标 | 当前 |
|-----|------|------|
| 部署频率 | 每天1-2次 | - |
| 部署时长 | <10分钟 | ~7分钟 |
| 部署成功率 | >95% | - |
| 回滚时间 | <5分钟 | ~3分钟 |
| 故障恢复时间 | <30分钟 | - |

### 统计方法

```bash
# 使用GitHub API获取部署统计
curl -H "Authorization: token YOUR_TOKEN" \
  "https://api.github.com/repos/你的用户名/msdsfullstack/actions/runs" \
  | jq '.workflow_runs[] | {created: .created_at, status: .conclusion}'
```

---

## 🎓 扩展阅读

### 官方文档
- [GitHub Actions文档](https://docs.github.com/actions)
- [Docker文档](https://docs.docker.com/)
- [阿里云容器镜像服务](https://help.aliyun.com/product/60716.html)

### 推荐工具
- [GitHub CLI](https://cli.github.com/) - 命令行操作GitHub
- [act](https://github.com/nektos/act) - 本地运行GitHub Actions
- [lazydocker](https://github.com/jesseduffield/lazydocker) - Docker管理工具

---

## 📞 获取帮助

遇到问题？

1. **查看本文档** - 大部分问题都有解决方案
2. **查看GitHub Actions日志** - 详细的错误信息
3. **查看服务器日志** - 运行时错误
4. **参考相关文档** - [快速部署指南.md](./快速部署指南.md)

---

## 🎉 总结

通过CI/CD自动化部署，您可以：

- ✅ **节省时间** - 从15分钟手动部署到7分钟自动部署
- ✅ **减少错误** - 自动化流程避免人为失误
- ✅ **快速迭代** - 随时部署新功能
- ✅ **安全可靠** - 自动测试和健康检查
- ✅ **易于回滚** - 快速恢复到稳定版本

**Happy Deploying! 🚀**

