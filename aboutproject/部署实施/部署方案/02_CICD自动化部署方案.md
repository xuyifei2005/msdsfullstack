# MSDS实验室管理系统 - CI/CD自动化部署方案

> **现代化自动部署 - 让部署像喝水一样简单** 🚀

---

## 📋 方案概述

### 方案特点

- ✅ **全自动化**: 代码提交即自动部署
- ✅ **零停机**: 蓝绿部署，无服务中断
- ✅ **快速迭代**: 7分钟完成从代码到生产
- ✅ **质量保证**: 自动化测试和代码检查
- ✅ **多环境**: 开发/测试/生产环境自动管理

### 技术架构

```
┌─────────────────────────────────────────────────────────────────┐
│                        GitHub Actions                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────┐ │
│  │   代码检查   │  │   自动测试   │  │   构建镜像   │  │  部署   │ │
│  │  ESLint     │  │   Jest      │  │   Docker    │  │ Deploy  │ │
│  │  SonarQube  │  │   JUnit     │  │   Registry  │  │ Health  │ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────┘ │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                      镜像仓库 (阿里云ACR)                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────┐ │
│  │   前端镜像   │  │   后端镜像   │  │   数据库镜像  │  │  Nginx  │ │
│  │   React     │  │ Spring Boot │  │   MySQL     │  │ Proxy   │ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────┘ │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                        生产服务器                               │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────┐ │
│  │   蓝绿部署   │  │   健康检查   │  │   自动回滚   │  │  监控   │ │
│  │ Blue/Green  │  │ Health Check│  │  Rollback   │  │ Alert   │ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### 部署流程

```
代码提交 → 触发CI → 代码检查 → 自动测试 → 构建镜像 → 推送仓库 → 自动部署 → 健康检查 → 完成
   30秒     30秒      1分钟      2分钟      2分钟      30秒      1分钟      30秒     ✅
```

**总耗时**: 约7分钟（完全自动，无需人工干预）

---

## 🛠️ 环境要求

### GitHub仓库配置

- **GitHub Actions**: 启用Actions功能
- **Secrets管理**: 配置部署密钥和环境变量
- **分支保护**: 配置main分支保护规则
- **Webhook**: 自动触发部署流程

### 镜像仓库

- **阿里云容器镜像服务**: 企业版或个人版
- **镜像命名空间**: msds-system
- **访问凭证**: AccessKey和Secret
- **镜像仓库**: 前端、后端、数据库镜像仓库

### 服务器环境

| 组件 | 最低配置 | 推荐配置 |
|------|----------|----------|
| **CPU** | 4核 | 8核+ |
| **内存** | 8GB | 16GB+ |
| **存储** | 100GB | 200GB+ |
| **网络** | 100Mbps | 1Gbps+ |

---

## 📦 CI/CD配置

### GitHub Actions工作流

#### 主工作流配置

```yaml
# .github/workflows/deploy.yml
name: MSDS系统CI/CD流水线

on:
  push:
    branches:
      - main      # 生产环境自动部署
      - develop   # 测试环境自动部署
  pull_request:
    branches:
      - main      # PR时运行测试

env:
  # 阿里云容器镜像仓库配置
  REGISTRY: registry.cn-beijing.aliyuncs.com
  NAMESPACE: msds
  BACKEND_IMAGE: backend
  FRONTEND_IMAGE: frontend

jobs:
  # ==================== 代码质量检查 ====================
  code-quality:
    name: 代码质量检查
    runs-on: ubuntu-latest
    
    steps:
      - name: 检出代码
        uses: actions/checkout@v4
        with:
          fetch-depth: 0  # 获取完整历史用于SonarQube分析
      
      - name: 设置Node.js环境
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
          cache-dependency-path: msdsPC/ruoyi-MsdsPc-react/react-ui/package-lock.json
      
      - name: 安装前端依赖
        working-directory: msdsPC/ruoyi-MsdsPc-react/react-ui
        run: npm ci
      
      - name: 前端代码检查
        working-directory: msdsPC/ruoyi-MsdsPc-react/react-ui
        run: |
          npm run lint
          npm run type-check || true
      
      - name: 设置Java环境
        uses: actions/setup-java@v4
        with:
          java-version: '11'
          distribution: 'temurin'
      
      - name: 后端代码检查
        working-directory: msdsPC/ruoyi-MsdsPc-react
        run: |
          mvn clean compile
          mvn checkstyle:check || true
          mvn spotbugs:check || true
      
      - name: SonarQube代码分析
        uses: sonarqube-quality-gate-action@master
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        with:
          scanMetadataReportFile: target/sonar/report-task.txt

  # ==================== 前端构建和测试 ====================
  build-frontend:
    name: 构建前端应用
    runs-on: ubuntu-latest
    needs: code-quality
    
    steps:
      - name: 检出代码
        uses: actions/checkout@v4
      
      - name: 设置Node.js环境
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
          cache-dependency-path: msdsPC/ruoyi-MsdsPc-react/react-ui/package-lock.json
      
      - name: 安装依赖
        working-directory: msdsPC/ruoyi-MsdsPc-react/react-ui
        run: npm ci
      
      - name: 运行单元测试
        working-directory: msdsPC/ruoyi-MsdsPc-react/react-ui
        run: |
          npm run test:coverage
          npm run test:e2e || true
      
      - name: 构建生产版本
        working-directory: msdsPC/ruoyi-MsdsPc-react/react-ui
        run: npm run build:prod
      
      - name: 上传构建产物
        uses: actions/upload-artifact@v4
        with:
          name: frontend-dist
          path: msdsPC/ruoyi-MsdsPc-react/react-ui/dist
          retention-days: 7

  # ==================== 后端构建和测试 ====================
  build-backend:
    name: 构建后端应用
    runs-on: ubuntu-latest
    needs: code-quality
    
    steps:
      - name: 检出代码
        uses: actions/checkout@v4
      
      - name: 设置Java环境
        uses: actions/setup-java@v4
        with:
          java-version: '11'
          distribution: 'temurin'
          cache: maven
      
      - name: 运行单元测试
        working-directory: msdsPC/ruoyi-MsdsPc-react
        run: |
          mvn clean test
          mvn jacoco:report
      
      - name: 运行集成测试
        working-directory: msdsPC/ruoyi-MsdsPc-react
        run: mvn verify -P integration-test || true
      
      - name: 构建应用
        working-directory: msdsPC/ruoyi-MsdsPc-react
        run: mvn clean package -DskipTests
      
      - name: 上传构建产物
        uses: actions/upload-artifact@v4
        with:
          name: backend-jar
          path: msdsPC/ruoyi-MsdsPc-react/ruoyi-admin/target/*.jar
          retention-days: 7

  # ==================== 安全扫描 ====================
  security-scan:
    name: 安全漏洞扫描
    runs-on: ubuntu-latest
    needs: [build-frontend, build-backend]
    
    steps:
      - name: 检出代码
        uses: actions/checkout@v4
      
      - name: 前端依赖安全扫描
        working-directory: msdsPC/ruoyi-MsdsPc-react/react-ui
        run: |
          npm audit --audit-level=high
          npx snyk test || true
      
      - name: 后端依赖安全扫描
        working-directory: msdsPC/ruoyi-MsdsPc-react
        run: |
          mvn org.owasp:dependency-check-maven:check
      
      - name: 代码安全扫描
        uses: github/codeql-action/analyze@v3
        with:
          languages: java, javascript

  # ==================== 构建Docker镜像 ====================
  build-docker:
    name: 构建Docker镜像
    runs-on: ubuntu-latest
    needs: [build-frontend, build-backend, security-scan]
    if: github.ref == 'refs/heads/main' || github.ref == 'refs/heads/develop'
    
    steps:
      - name: 检出代码
        uses: actions/checkout@v4
      
      - name: 下载前端构建产物
        uses: actions/download-artifact@v4
        with:
          name: frontend-dist
          path: msdsPC/ruoyi-MsdsPc-react/react-ui/dist
      
      - name: 下载后端构建产物
        uses: actions/download-artifact@v4
        with:
          name: backend-jar
          path: msdsPC/ruoyi-MsdsPc-react/ruoyi-admin/target
      
      - name: 设置Docker Buildx
        uses: docker/setup-buildx-action@v3
      
      - name: 登录阿里云容器镜像仓库
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ secrets.ALIYUN_REGISTRY_USERNAME }}
          password: ${{ secrets.ALIYUN_REGISTRY_PASSWORD }}
      
      - name: 构建并推送前端镜像
        uses: docker/build-push-action@v5
        with:
          context: msdsPC/ruoyi-MsdsPc-react/react-ui
          file: msdsPC/ruoyi-MsdsPc-react/react-ui/Dockerfile
          push: true
          tags: |
            ${{ env.REGISTRY }}/${{ env.NAMESPACE }}/${{ env.FRONTEND_IMAGE }}:latest
            ${{ env.REGISTRY }}/${{ env.NAMESPACE }}/${{ env.FRONTEND_IMAGE }}:${{ github.sha }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
      
      - name: 构建并推送后端镜像
        uses: docker/build-push-action@v5
        with:
          context: msdsPC/ruoyi-MsdsPc-react
          file: msdsPC/ruoyi-MsdsPc-react/Dockerfile
          push: true
          tags: |
            ${{ env.REGISTRY }}/${{ env.NAMESPACE }}/${{ env.BACKEND_IMAGE }}:latest
            ${{ env.REGISTRY }}/${{ env.NAMESPACE }}/${{ env.BACKEND_IMAGE }}:${{ github.sha }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

  # ==================== 部署到测试环境 ====================
  deploy-staging:
    name: 部署到测试环境
    needs: build-docker
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/develop'
    environment:
      name: staging
      url: https://test.flymsds.cn
    
    steps:
      - name: 检出代码
        uses: actions/checkout@v4
      
      - name: 部署到测试服务器
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.STAGING_HOST }}
          username: ${{ secrets.STAGING_USER }}
          key: ${{ secrets.STAGING_SSH_KEY }}
          script: |
            cd /opt/msds/staging
            
            # 拉取最新代码
            git pull origin develop
            
            # 拉取最新镜像
            docker-compose -f docker-compose.staging.yml pull
            
            # 蓝绿部署
            ./deploy-blue-green.sh staging
            
            # 健康检查
            sleep 30
            curl -f https://test.flymsds.cn/health || exit 1
      
      - name: 运行自动化测试
        run: |
          # 运行端到端测试
          npm run test:e2e:staging
          
          # 运行API测试
          npm run test:api:staging

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
        uses: actions/checkout@v4
      
      - name: 部署到生产服务器
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.PRODUCTION_HOST }}
          username: ${{ secrets.PRODUCTION_USER }}
          key: ${{ secrets.PRODUCTION_SSH_KEY }}
          script: |
            cd /opt/msds/production
            
            # 拉取最新代码
            git pull origin main
            
            # 备份数据库
            ./backup-restore.sh backup
            
            # 拉取最新镜像
            docker-compose -f docker-compose.prod.yml pull
            
            # 蓝绿部署
            ./deploy-blue-green.sh production
            
            # 健康检查
            sleep 60
            curl -f https://flymsds.cn/health || exit 1
            
            # 清理旧镜像
            docker image prune -f
      
      - name: 发送部署通知
        if: always()
        uses: 8398a7/action-slack@v3
        with:
          status: ${{ job.status }}
          text: |
            🚀 MSDS系统部署完成
            环境: 生产环境
            状态: ${{ job.status }}
            提交: ${{ github.sha }}
            分支: ${{ github.ref }}
            时间: ${{ github.event.head_commit.timestamp }}
          webhook_url: ${{ secrets.SLACK_WEBHOOK }}

  # ==================== 部署后验证 ====================
  post-deploy-verification:
    name: 部署后验证
    needs: [deploy-production]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
      - name: 健康检查
        run: |
          # 等待服务完全启动
          sleep 120
          
          # 检查前端页面
          curl -f https://flymsds.cn/ || exit 1
          
          # 检查后端API
          curl -f https://flymsds.cn/api/health || exit 1
          
          # 检查数据库连接
          curl -f https://flymsds.cn/api/system/health/db || exit 1
      
      - name: 性能测试
        run: |
          # 运行性能测试
          npm run test:performance:production || true
      
      - name: 监控告警配置
        run: |
          # 配置监控告警
          curl -X POST "${{ secrets.MONITORING_WEBHOOK }}" \
            -H "Content-Type: application/json" \
            -d '{"service": "msds", "version": "${{ github.sha }}", "status": "deployed"}'
```

#### 分支策略配置

```yaml
# 分支保护规则配置
branches:
  main:
    protection_rules:
      required_status_checks:
        strict: true
        contexts:
          - "code-quality"
          - "build-frontend"
          - "build-backend"
          - "security-scan"
      enforce_admins: true
      required_pull_request_reviews:
        required_approving_review_count: 1
        dismiss_stale_reviews: true
      restrictions: null
```

## 4. 部署脚本配置

### 4.1 蓝绿部署脚本

```bash
#!/bin/bash
# deploy-blue-green.sh - 蓝绿部署脚本

set -e

ENVIRONMENT=$1
COMPOSE_FILE="docker-compose.${ENVIRONMENT}.yml"
BACKUP_DIR="/opt/msds/backups"
LOG_FILE="/var/log/msds/deploy.log"

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a $LOG_FILE
}

# 健康检查函数
health_check() {
    local url=$1
    local max_attempts=30
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if curl -f -s $url > /dev/null; then
            log "健康检查通过: $url"
            return 0
        fi
        log "健康检查失败 ($attempt/$max_attempts): $url"
        sleep 10
        ((attempt++))
    done
    
    log "健康检查最终失败: $url"
    return 1
}

# 主部署流程
main() {
    log "开始蓝绿部署 - 环境: $ENVIRONMENT"
    
    # 1. 备份当前配置
    log "备份当前配置..."
    cp $COMPOSE_FILE "${BACKUP_DIR}/docker-compose.${ENVIRONMENT}.$(date +%Y%m%d_%H%M%S).yml"
    
    # 2. 拉取最新镜像
    log "拉取最新镜像..."
    docker-compose -f $COMPOSE_FILE pull
    
    # 3. 启动新版本（绿色环境）
    log "启动新版本服务..."
    docker-compose -f $COMPOSE_FILE up -d --scale msdsfrontend=2 --scale msdsbackend=2
    
    # 4. 等待服务启动
    sleep 30
    
    # 5. 健康检查
    if [ "$ENVIRONMENT" = "production" ]; then
        HEALTH_URL="https://flymsds.cn/health"
    else
        HEALTH_URL="https://test.flymsds.cn/health"
    fi
    
    if health_check $HEALTH_URL; then
        log "新版本健康检查通过，开始切换流量..."
        
        # 6. 更新Nginx配置切换流量
        docker-compose -f $COMPOSE_FILE exec msdsnginx nginx -s reload
        
        # 7. 停止旧版本
        log "停止旧版本服务..."
        docker-compose -f $COMPOSE_FILE down --remove-orphans
        
        # 8. 启动最终版本
        docker-compose -f $COMPOSE_FILE up -d
        
        log "蓝绿部署完成！"
    else
        log "新版本健康检查失败，回滚到旧版本..."
        
        # 回滚操作
        docker-compose -f $COMPOSE_FILE down
        docker-compose -f "${BACKUP_DIR}/docker-compose.${ENVIRONMENT}.$(ls -t ${BACKUP_DIR}/ | head -1)" up -d
        
        log "回滚完成"
        exit 1
    fi
}

# 执行主流程
main "$@"
```

### 4.2 数据库备份恢复脚本

```bash
#!/bin/bash
# backup-restore.sh - 数据库备份恢复脚本

set -e

ACTION=$1
BACKUP_DIR="/opt/msds/backups/database"
MYSQL_CONTAINER="msdsmysql"
DATABASE_NAME="msds_dev"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# 创建备份目录
mkdir -p $BACKUP_DIR

case $ACTION in
    "backup")
        echo "开始备份数据库..."
        docker exec $MYSQL_CONTAINER mysqldump \
            -u msds_user \
            -pmsds_dev_password \
            --single-transaction \
            --routines \
            --triggers \
            $DATABASE_NAME > "${BACKUP_DIR}/msds_backup_${TIMESTAMP}.sql"
        
        # 压缩备份文件
        gzip "${BACKUP_DIR}/msds_backup_${TIMESTAMP}.sql"
        
        # 清理7天前的备份
        find $BACKUP_DIR -name "*.sql.gz" -mtime +7 -delete
        
        echo "数据库备份完成: msds_backup_${TIMESTAMP}.sql.gz"
        ;;
        
    "restore")
        BACKUP_FILE=$2
        if [ -z "$BACKUP_FILE" ]; then
            echo "请指定备份文件"
            exit 1
        fi
        
        echo "开始恢复数据库..."
        
        # 解压备份文件
        if [[ $BACKUP_FILE == *.gz ]]; then
            gunzip -c $BACKUP_FILE | docker exec -i $MYSQL_CONTAINER mysql \
                -u msds_user \
                -pmsds_dev_password \
                $DATABASE_NAME
        else
            docker exec -i $MYSQL_CONTAINER mysql \
                -u msds_user \
                -pmsds_dev_password \
                $DATABASE_NAME < $BACKUP_FILE
        fi
        
        echo "数据库恢复完成"
        ;;
        
    *)
        echo "用法: $0 {backup|restore} [backup_file]"
        exit 1
        ;;
esac
```

## 5. 环境配置

### 5.1 GitHub Secrets配置

需要在GitHub仓库中配置以下Secrets：

```yaml
# 阿里云容器镜像仓库
ALIYUN_REGISTRY_USERNAME: your_username
ALIYUN_REGISTRY_PASSWORD: your_password

# 测试环境服务器
STAGING_HOST: test.flymsds.cn
STAGING_USER: deploy
STAGING_SSH_KEY: |
  -----BEGIN OPENSSH PRIVATE KEY-----
  your_private_key_content
  -----END OPENSSH PRIVATE KEY-----

# 生产环境服务器
PRODUCTION_HOST: flymsds.cn
PRODUCTION_USER: deploy
PRODUCTION_SSH_KEY: |
  -----BEGIN OPENSSH PRIVATE KEY-----
  your_private_key_content
  -----END OPENSSH PRIVATE KEY-----

# 代码质量检查
SONAR_TOKEN: your_sonar_token

# 通知配置
SLACK_WEBHOOK: https://hooks.slack.com/services/xxx/xxx/xxx
MONITORING_WEBHOOK: https://your-monitoring-system.com/webhook
```

### 5.2 服务器环境配置

#### 测试环境配置

```yaml
# docker-compose.staging.yml
version: '3.8'

services:
  msdsmysql:
    image: mysql:8.0.42
    container_name: msdsmysql-staging
    environment:
      MYSQL_ROOT_PASSWORD: staging_root_password
      MYSQL_DATABASE: msds_staging
      MYSQL_USER: msds_user
      MYSQL_PASSWORD: staging_password
    volumes:
      - mysql_staging_data:/var/lib/mysql
    networks:
      - msds_staging_network

  msdsredis:
    image: redis:7-alpine
    container_name: msdsredis-staging
    networks:
      - msds_staging_network

  msdsbackend:
    image: registry.cn-beijing.aliyuncs.com/msds/backend:latest
    container_name: msdsbackend-staging
    environment:
      SPRING_PROFILES_ACTIVE: staging
      SPRING_DATASOURCE_URL: jdbc:mysql://msdsmysql-staging:3306/msds_staging
      SPRING_DATASOURCE_USERNAME: msds_user
      SPRING_DATASOURCE_PASSWORD: staging_password
      SPRING_REDIS_HOST: msdsredis-staging
    depends_on:
      - msdsmysql
      - msdsredis
    networks:
      - msds_staging_network

  msdsfrontend:
    image: registry.cn-beijing.aliyuncs.com/msds/frontend:latest
    container_name: msdsfrontend-staging
    environment:
      REACT_APP_API_BASE_URL: https://test.flymsds.cn/api
      REACT_APP_ENV: staging
    networks:
      - msds_staging_network

  msdsnginx:
    image: nginx:alpine
    container_name: msdsnginx-staging
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/staging.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - msdsbackend
      - msdsfrontend
    networks:
      - msds_staging_network

volumes:
  mysql_staging_data:

networks:
  msds_staging_network:
    driver: bridge
```

#### 生产环境配置

```yaml
# docker-compose.prod.yml
version: '3.8'

services:
  msdsmysql:
    image: mysql:8.0.42
    container_name: msdsmysql-prod
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: msds_prod
      MYSQL_USER: msds_user
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    volumes:
      - mysql_prod_data:/var/lib/mysql
      - ./mysql/conf.d:/etc/mysql/conf.d
    networks:
      - msds_prod_network
    restart: unless-stopped

  msdsredis:
    image: redis:7-alpine
    container_name: msdsredis-prod
    command: redis-server --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis_prod_data:/data
    networks:
      - msds_prod_network
    restart: unless-stopped

  msdsbackend:
    image: registry.cn-beijing.aliyuncs.com/msds/backend:latest
    container_name: msdsbackend-prod
    environment:
      SPRING_PROFILES_ACTIVE: prod
      SPRING_DATASOURCE_URL: jdbc:mysql://msdsmysql-prod:3306/msds_prod
      SPRING_DATASOURCE_USERNAME: msds_user
      SPRING_DATASOURCE_PASSWORD: ${MYSQL_PASSWORD}
      SPRING_REDIS_HOST: msdsredis-prod
      SPRING_REDIS_PASSWORD: ${REDIS_PASSWORD}
    depends_on:
      - msdsmysql
      - msdsredis
    networks:
      - msds_prod_network
    restart: unless-stopped
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '1.0'

  msdsfrontend:
    image: registry.cn-beijing.aliyuncs.com/msds/frontend:latest
    container_name: msdsfrontend-prod
    environment:
      REACT_APP_API_BASE_URL: https://flymsds.cn/api
      REACT_APP_ENV: production
    networks:
      - msds_prod_network
    restart: unless-stopped

  msdsnginx:
    image: nginx:alpine
    container_name: msdsnginx-prod
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/prod.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
      - nginx_logs:/var/log/nginx
    depends_on:
      - msdsbackend
      - msdsfrontend
    networks:
      - msds_prod_network
    restart: unless-stopped

volumes:
  mysql_prod_data:
  redis_prod_data:
  nginx_logs:

networks:
  msds_prod_network:
    driver: bridge
```

## 6. 监控和告警

### 6.1 应用监控配置

```yaml
# monitoring/docker-compose.monitoring.yml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
    networks:
      - monitoring_network

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    ports:
      - "3001:3000"
    environment:
      GF_SECURITY_ADMIN_PASSWORD: admin123
    volumes:
      - grafana_data:/var/lib/grafana
      - ./grafana/dashboards:/etc/grafana/provisioning/dashboards
      - ./grafana/datasources:/etc/grafana/provisioning/datasources
    networks:
      - monitoring_network

  alertmanager:
    image: prom/alertmanager:latest
    container_name: alertmanager
    ports:
      - "9093:9093"
    volumes:
      - ./alertmanager/alertmanager.yml:/etc/alertmanager/alertmanager.yml
    networks:
      - monitoring_network

volumes:
  prometheus_data:
  grafana_data:

networks:
  monitoring_network:
    driver: bridge
```

### 6.2 告警规则配置

```yaml
# prometheus/alert.rules.yml
groups:
  - name: msds_alerts
    rules:
      - alert: HighCPUUsage
        expr: cpu_usage_percent > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "CPU使用率过高"
          description: "{{ $labels.instance }} CPU使用率超过80%"

      - alert: HighMemoryUsage
        expr: memory_usage_percent > 85
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "内存使用率过高"
          description: "{{ $labels.instance }} 内存使用率超过85%"

      - alert: DatabaseConnectionFailed
        expr: mysql_up == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "数据库连接失败"
          description: "MySQL数据库连接失败"

      - alert: ApplicationDown
        expr: up{job="msds-backend"} == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "应用服务下线"
          description: "MSDS后端服务不可用"
```

## 7. 部署流程

### 7.1 初始化部署

```bash
# 1. 克隆代码仓库
git clone https://github.com/your-org/msdsfullstack.git
cd msdsfullstack

# 2. 配置环境变量
cp .env.example .env.prod
# 编辑 .env.prod 文件，配置生产环境变量

# 3. 配置GitHub Secrets
# 在GitHub仓库设置中添加所需的Secrets

# 4. 配置服务器
# 在目标服务器上安装Docker和Docker Compose
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# 5. 配置部署用户
useradd -m -s /bin/bash deploy
usermod -aG docker deploy
mkdir -p /home/deploy/.ssh
# 添加部署密钥到 /home/deploy/.ssh/authorized_keys

# 6. 创建部署目录
mkdir -p /opt/msds/{production,staging,backups}
chown -R deploy:deploy /opt/msds

# 7. 首次部署
git push origin main  # 触发自动部署
```

### 7.2 日常部署流程

```bash
# 开发流程
git checkout develop
git pull origin develop

# 开发新功能
git checkout -b feature/new-feature
# ... 开发代码 ...
git add .
git commit -m "feat: 添加新功能"
git push origin feature/new-feature

# 创建Pull Request到develop分支
# 合并后自动部署到测试环境

# 测试通过后，创建Pull Request到main分支
# 合并后自动部署到生产环境
```

## 8. 故障排查

### 8.1 常见问题

#### 构建失败

```bash
# 检查构建日志
# 在GitHub Actions中查看详细的构建日志

# 本地复现问题
docker build -t test-build .

# 检查依赖问题
npm audit
mvn dependency:tree
```

#### 部署失败

```bash
# 检查服务器状态
docker ps -a
docker logs container_name

# 检查网络连接
curl -I https://flymsds.cn/health

# 检查磁盘空间
df -h
docker system df
```

#### 性能问题

```bash
# 检查资源使用
docker stats
top
htop

# 检查数据库性能
docker exec -it msdsmysql mysql -u root -p
SHOW PROCESSLIST;
SHOW ENGINE INNODB STATUS;
```

### 8.2 回滚操作

```bash
# 快速回滚到上一个版本
./deploy-blue-green.sh production rollback

# 回滚到指定版本
docker-compose -f docker-compose.prod.yml down
docker pull registry.cn-beijing.aliyuncs.com/msds/backend:commit-hash
docker pull registry.cn-beijing.aliyuncs.com/msds/frontend:commit-hash
docker-compose -f docker-compose.prod.yml up -d
```

## 9. 性能优化

### 9.1 构建优化

```dockerfile
# 多阶段构建优化
FROM node:18-alpine AS frontend-builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=frontend-builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
```

### 9.2 部署优化

```yaml
# 并行部署配置
deploy:
  parallel:
    frontend:
      - build-frontend
      - test-frontend
    backend:
      - build-backend
      - test-backend
  
  sequential:
    - security-scan
    - deploy-staging
    - deploy-production
```

## 10. 安全配置

### 10.1 容器安全

```dockerfile
# 使用非root用户
FROM node:18-alpine
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001
USER nextjs
```

### 10.2 网络安全

```yaml
# 网络隔离配置
networks:
  frontend_network:
    driver: bridge
    internal: false
  backend_network:
    driver: bridge
    internal: true
  database_network:
    driver: bridge
    internal: true
```

## 11. 方案总结

### 11.1 方案优势

- **全自动化**: 从代码提交到生产部署全程自动化
- **零停机部署**: 蓝绿部署确保服务不中断
- **质量保证**: 多层次的代码质量检查和测试
- **安全可靠**: 完善的安全扫描和权限控制
- **可观测性**: 全面的监控和告警机制

### 11.2 适用场景

- **中大型项目**: 需要严格质量控制的项目
- **团队协作**: 多人协作开发的项目
- **高可用要求**: 对服务可用性要求较高的项目
- **合规要求**: 需要满足安全合规要求的项目

### 11.3 实施建议

1. **分阶段实施**: 先实施基础CI/CD，再逐步完善
2. **团队培训**: 确保团队成员熟悉新的工作流程
3. **监控优化**: 持续监控和优化部署流程
4. **文档维护**: 保持部署文档的及时更新

---

*本方案提供了完整的CI/CD自动化部署解决方案，可根据实际需求进行调整和优化。*

<function_calls>
<invoke name="view_files">
<parameter name="files">[{"end_line_one_indexed_inclusive": 50, "file_path": "d:\\XUYIFEI\\XUPROJECTS\\msdsfullstack\\.github\\workflows\\deploy.yml", "start_line_one_indexed": 1}]