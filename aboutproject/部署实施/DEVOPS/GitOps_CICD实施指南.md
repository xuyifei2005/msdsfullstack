# MSDS系统GitOps + CI/CD实施指南

> **现代化的自动化部署方案 - 代码即基础设施**

---

## 📊 两种部署方案对比

### 方案对比表

| 特性 | 传统脚本部署 | GitOps + CI/CD |
|-----|-------------|----------------|
| **部署触发** | 手动执行脚本 | Git Push自动触发 |
| **版本控制** | 部分配置在Git | 所有配置在Git |
| **回滚方式** | 手动恢复备份 | Git Revert |
| **审计追踪** | 部署日志 | Git历史记录 |
| **多环境管理** | 多个脚本 | 分支/目录管理 |
| **部署一致性** | 依赖人工 | 自动化保证 |
| **学习曲线** | 低 | 中等 |
| **适用场景** | 小型项目、快速上线 | 中大型项目、团队协作 |

### 当前方案（传统脚本部署）

```
开发者 → 本地构建 → SCP上传 → SSH登录 → 执行脚本 → 部署完成
         ↓
      手动操作
```

**优点**:
- ✅ 简单直接，快速上线
- ✅ 学习成本低
- ✅ 适合单人或小团队

**缺点**:
- ⚠️ 依赖手动操作
- ⚠️ 容易出错
- ⚠️ 难以追溯变更历史

### GitOps + CI/CD方案

```
开发者 → Git Push → CI构建 → 镜像仓库 → GitOps同步 → 自动部署
         ↓          ↓          ↓           ↓
      自动触发    自动测试    版本管理    声明式配置
```

**优点**:
- ✅ 全自动化
- ✅ 版本可追溯
- ✅ 易于回滚
- ✅ 团队协作友好

**缺点**:
- ⚠️ 需要搭建CI/CD基础设施
- ⚠️ 学习成本较高
- ⚠️ 初期投入较大

---

## 🎯 GitOps + CI/CD完整实施方案

### 架构图

```
┌─────────────────────────────────────────────────────────────┐
│                   GitOps + CI/CD 工作流                       │
└─────────────────────────────────────────────────────────────┘

开发阶段
├── 开发者修改代码
├── Git Commit & Push
└── 触发CI流水线

CI阶段（GitHub Actions / GitLab CI）
├── 1. 代码检出
├── 2. 运行测试
├── 3. 构建前端（npm build）
├── 4. 构建后端（mvn package）
├── 5. 构建Docker镜像
├── 6. 推送到镜像仓库
└── 7. 更新部署配置

CD阶段（ArgoCD / Flux）
├── 1. 监控Git仓库变化
├── 2. 检测到新镜像版本
├── 3. 拉取新配置
├── 4. 更新Kubernetes/Docker部署
└── 5. 健康检查

生产环境
└── 应用自动更新完成
```

---

## 🛠️ 实施步骤

### 步骤1: 选择CI/CD工具

推荐三种方案：

#### 方案A: GitHub Actions（推荐 - 免费易用）
- ✅ 与GitHub无缝集成
- ✅ 免费额度充足
- ✅ 配置简单

#### 方案B: GitLab CI/CD
- ✅ 功能强大
- ✅ 私有部署选项
- ✅ 集成度高

#### 方案C: Jenkins（传统企业级）
- ✅ 插件丰富
- ✅ 高度可定制
- ⚠️ 配置复杂

### 步骤2: 创建GitHub Actions工作流

创建 `.github/workflows/deploy.yml`:

```yaml
name: MSDS系统CI/CD流水线

on:
  push:
    branches:
      - main
      - develop
  pull_request:
    branches:
      - main

env:
  REGISTRY: registry.cn-beijing.aliyuncs.com
  IMAGE_NAME: msds/backend
  FRONTEND_IMAGE: msds/frontend

jobs:
  # ==================== 前端构建 ====================
  build-frontend:
    name: 构建前端应用
    runs-on: ubuntu-latest
    
    steps:
      - name: 检出代码
        uses: actions/checkout@v3
      
      - name: 设置Node.js环境
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'npm'
          cache-dependency-path: msdsPC/ruoyi-MsdsPc-react/react-ui/package-lock.json
      
      - name: 安装依赖
        working-directory: msdsPC/ruoyi-MsdsPc-react/react-ui
        run: npm ci
      
      - name: 运行测试
        working-directory: msdsPC/ruoyi-MsdsPc-react/react-ui
        run: npm run test -- --passWithNoTests
      
      - name: 构建生产版本
        working-directory: msdsPC/ruoyi-MsdsPc-react/react-ui
        run: npm run build:prod
      
      - name: 上传构建产物
        uses: actions/upload-artifact@v3
        with:
          name: frontend-dist
          path: msdsPC/ruoyi-MsdsPc-react/react-ui/dist
          retention-days: 7

  # ==================== 后端构建 ====================
  build-backend:
    name: 构建后端应用
    runs-on: ubuntu-latest
    
    steps:
      - name: 检出代码
        uses: actions/checkout@v3
      
      - name: 设置Java环境
        uses: actions/setup-java@v3
        with:
          java-version: '17'
          distribution: 'temurin'
          cache: 'maven'
      
      - name: Maven构建
        working-directory: msdsPC/ruoyi-MsdsPc-react
        run: mvn clean package -Pprod -DskipTests
      
      - name: 上传JAR文件
        uses: actions/upload-artifact@v3
        with:
          name: backend-jar
          path: msdsPC/ruoyi-MsdsPc-react/ruoyi-admin/target/*.jar
          retention-days: 7

  # ==================== 构建Docker镜像 ====================
  build-docker:
    name: 构建并推送Docker镜像
    needs: [build-frontend, build-backend]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
      - name: 检出代码
        uses: actions/checkout@v3
      
      - name: 下载前端构建产物
        uses: actions/download-artifact@v3
        with:
          name: frontend-dist
          path: msdsPC/ruoyi-MsdsPc-react/react-ui/dist
      
      - name: 下载后端JAR文件
        uses: actions/download-artifact@v3
        with:
          name: backend-jar
          path: msdsPC/ruoyi-MsdsPc-react/ruoyi-admin/target
      
      - name: 设置Docker Buildx
        uses: docker/setup-buildx-action@v2
      
      - name: 登录阿里云容器镜像服务
        uses: docker/login-action@v2
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ secrets.ALIYUN_REGISTRY_USERNAME }}
          password: ${{ secrets.ALIYUN_REGISTRY_PASSWORD }}
      
      - name: 提取元数据（标签、注释）
        id: meta
        uses: docker/metadata-action@v4
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=ref,event=branch
            type=sha,prefix={{branch}}-
            type=semver,pattern={{version}}
            type=raw,value=latest,enable={{is_default_branch}}
      
      - name: 构建并推送后端镜像
        uses: docker/build-push-action@v4
        with:
          context: msdsPC/ruoyi-MsdsPc-react
          file: msdsPC/ruoyi-MsdsPc-react/Dockerfile.prod
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
      
      - name: 构建并推送前端镜像
        uses: docker/build-push-action@v4
        with:
          context: msdsPC/ruoyi-MsdsPc-react/react-ui
          file: msdsPC/ruoyi-MsdsPc-react/react-ui/Dockerfile.nginx
          push: true
          tags: ${{ env.REGISTRY }}/${{ env.FRONTEND_IMAGE }}:latest
          cache-from: type=gha
          cache-to: type=gha,mode=max

  # ==================== 部署到生产环境 ====================
  deploy-production:
    name: 部署到生产环境
    needs: build-docker
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    environment:
      name: production
      url: https://flymsds.cn
    
    steps:
      - name: 检出代码
        uses: actions/checkout@v3
      
      - name: 部署到服务器
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.PRODUCTION_HOST }}
          username: ${{ secrets.PRODUCTION_USER }}
          key: ${{ secrets.PRODUCTION_SSH_KEY }}
          script: |
            cd /opt/msds/msdsdocker
            
            # 拉取最新代码
            git pull origin main
            
            # 拉取最新镜像
            docker-compose -f docker-compose.prod.yml pull
            
            # 备份数据库
            ./backup-restore.sh full
            
            # 重新部署
            docker-compose -f docker-compose.prod.yml up -d
            
            # 清理旧镜像
            docker image prune -f
      
      - name: 健康检查
        run: |
          sleep 30
          curl -f https://flymsds.cn/health || exit 1
      
      - name: 发送部署通知
        if: always()
        uses: 8398a7/action-slack@v3
        with:
          status: ${{ job.status }}
          text: '部署到生产环境: ${{ job.status }}'
          webhook_url: ${{ secrets.SLACK_WEBHOOK }}

  # ==================== 部署到测试环境 ====================
  deploy-staging:
    name: 部署到测试环境
    needs: build-docker
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/develop'
    environment:
      name: staging
    
    steps:
      - name: 部署到测试服务器
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.STAGING_HOST }}
          username: ${{ secrets.STAGING_USER }}
          key: ${{ secrets.STAGING_SSH_KEY }}
          script: |
            cd /opt/msds-staging
            docker-compose pull
            docker-compose up -d
```

### 步骤3: 配置GitHub Secrets

在GitHub仓库设置中添加以下Secrets：

```bash
# 阿里云镜像仓库
ALIYUN_REGISTRY_USERNAME=your_username
ALIYUN_REGISTRY_PASSWORD=your_password

# 生产服务器SSH
PRODUCTION_HOST=39.107.211.72
PRODUCTION_USER=root
PRODUCTION_SSH_KEY=your_private_key

# 测试服务器（可选）
STAGING_HOST=staging_server_ip
STAGING_USER=root
STAGING_SSH_KEY=staging_private_key

# 通知（可选）
SLACK_WEBHOOK=your_slack_webhook_url
```

### 步骤4: 创建前端Nginx Dockerfile

创建 `msdsPC/ruoyi-MsdsPc-react/react-ui/Dockerfile.nginx`:

```dockerfile
FROM nginx:alpine

# 复制构建产物
COPY dist /usr/share/nginx/html

# 复制Nginx配置
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

### 步骤5: 修改docker-compose使用镜像仓库

修改 `docker-compose.prod.yml`:

```yaml
services:
  msdsbackend:
    # 使用镜像仓库而不是本地构建
    image: registry.cn-beijing.aliyuncs.com/msds/backend:latest
    # 移除 build 配置
    pull_policy: always
    # ... 其他配置保持不变

  msdsfrontend:
    image: registry.cn-beijing.aliyuncs.com/msds/frontend:latest
    pull_policy: always
    # ... 其他配置保持不变
```

### 步骤6: 设置GitOps（使用ArgoCD - 可选高级功能）

如果要实现完全的GitOps，可以使用ArgoCD：

#### 安装ArgoCD

```bash
# 在Kubernetes集群中安装ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 访问ArgoCD UI
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

#### 创建ArgoCD应用配置

创建 `argocd/msds-app.yaml`:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: msds-production
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/your-org/msdsfullstack
    targetRevision: main
    path: msdsdocker
  destination:
    server: https://kubernetes.default.svc
    namespace: msds-prod
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

---

## 📝 使用流程

### 日常开发流程

```bash
# 1. 创建功能分支
git checkout -b feature/new-function

# 2. 开发并提交代码
git add .
git commit -m "feat: 添加新功能"

# 3. 推送到远程（触发CI构建和测试）
git push origin feature/new-function

# 4. 创建Pull Request
# 在GitHub上创建PR，自动运行测试

# 5. 合并到main分支（触发自动部署）
# PR审核通过后合并，自动部署到生产环境
```

### 查看部署状态

```bash
# 1. 在GitHub Actions页面查看流水线状态
# https://github.com/your-org/msdsfullstack/actions

# 2. 查看部署日志
# 点击具体的workflow run查看详细日志

# 3. 验证部署
curl https://flymsds.cn/health
```

### 回滚部署

```bash
# 方式1: Git Revert（推荐）
git revert <commit-hash>
git push origin main
# 自动触发回滚部署

# 方式2: 手动回滚到指定版本
# 在GitHub Actions中重新运行之前的成功部署
```

---

## 🔄 迁移指南：从脚本部署到GitOps

### 第一阶段：添加CI/CD（不改变部署方式）

**目标**: 保持现有部署脚本，添加自动化测试和构建

1. ✅ 添加GitHub Actions配置（只做构建和测试）
2. ✅ 每次Push自动运行测试
3. ✅ 保持使用现有部署脚本

**实施**:
```yaml
# .github/workflows/ci.yml - 仅CI，不包含CD
name: CI Pipeline
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Tests
        run: npm test
```

### 第二阶段：容器化部署

**目标**: 使用Docker镜像仓库，但仍手动部署

1. ✅ 构建Docker镜像并推送到仓库
2. ✅ 修改部署脚本使用镜像仓库
3. ✅ 保持手动执行部署脚本

### 第三阶段：自动化部署

**目标**: 实现自动部署

1. ✅ 添加自动部署步骤到CI/CD
2. ✅ main分支自动部署到生产环境
3. ✅ develop分支自动部署到测试环境

### 第四阶段：完整GitOps（可选）

**目标**: 实现声明式基础设施

1. ✅ 引入ArgoCD或Flux
2. ✅ 所有配置存储在Git
3. ✅ 自动同步和自愈

---

## 💡 推荐实施路径

### 路径A: 渐进式迁移（推荐）

```
当前状态 → 添加CI测试 → 容器化 → 自动部署 → GitOps
(1周)      (1周)        (2周)     (1周)      (2周)
```

**适合**: 已有生产系统，需要平滑过渡

### 路径B: 快速迁移

```
当前状态 → 直接实施GitHub Actions完整流水线
(立即)      (1-2周)
```

**适合**: 新项目或愿意承担风险

### 路径C: 保持现状

```
继续使用脚本部署，定期手动更新
```

**适合**: 小型项目，更新频率低

---

## 🎯 我的建议

根据您的项目情况，我建议：

### 短期（1-2周）- 快速上线

✅ **使用我刚才创建的传统脚本部署方案**
- 优点：快速上线，风险低
- 适合：首次部署，验证系统

### 中期（1-2个月）- 添加CI/CD

✅ **实施GitHub Actions CI/CD流水线**
- 添加自动化测试
- 添加自动化构建
- 添加自动化部署

### 长期（3-6个月）- 完整GitOps

✅ **引入ArgoCD实现GitOps**
- 声明式配置
- 自动同步
- 多环境管理

---

## 📦 快速启动包

我为您准备了两套方案，您可以根据需求选择：

### 方案1: 传统部署（已完成）✅

位置: `msdsdocker/deploy.sh`

**适用**: 立即上线，快速部署

### 方案2: GitOps + CI/CD（本文档）📋

需要创建:
- `.github/workflows/deploy.yml`
- 配置GitHub Secrets
- 设置镜像仓库

**适用**: 长期维护，团队协作

---

## 🤔 如何选择？

| 场景 | 推荐方案 |
|-----|---------|
| 需要立即上线 | 传统脚本部署 ✅ |
| 团队规模 > 3人 | GitOps + CI/CD |
| 需要频繁更新 | GitOps + CI/CD |
| 多环境部署 | GitOps + CI/CD |
| 学习新技术 | GitOps + CI/CD |
| 时间紧迫 | 传统脚本部署 ✅ |

---

## 📞 下一步行动

### 如果选择传统部署（推荐当前阶段）

```bash
# 继续使用我创建的部署脚本
cd /opt/msds/msdsdocker
./deploy.sh
```

### 如果选择GitOps + CI/CD

我可以帮您：

1. 创建完整的GitHub Actions配置
2. 设置阿里云镜像仓库
3. 配置自动化部署流水线
4. 编写详细的操作文档

**请告诉我您希望采用哪种方案？**

---

**建议**: 先用传统脚本部署快速上线，系统稳定后再逐步迁移到GitOps + CI/CD。

