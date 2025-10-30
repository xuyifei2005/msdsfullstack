#!/bin/bash

# MSDS实验室管理系统自动化部署脚本
# 版本: v1.0
# 更新日期: 2025-01-27
# 用途: 生产环境自动化部署

set -e  # 遇到错误立即退出

# ==================== 配置变量 ====================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DOCKER_DIR="$PROJECT_ROOT/msdsdocker"
BACKUP_DIR="$PROJECT_ROOT/backups"
LOG_FILE="$PROJECT_ROOT/logs/deploy.log"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ==================== 日志函数 ====================
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}" | tee -a "$LOG_FILE"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}" | tee -a "$LOG_FILE"
    exit 1
}

info() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] INFO: $1${NC}" | tee -a "$LOG_FILE"
}

# ==================== 环境检查 ====================
check_environment() {
    log "开始环境检查..."
    
    # 检查Docker
    if ! command -v docker &> /dev/null; then
        error "Docker未安装，请先安装Docker"
    fi
    
    # 检查Docker Compose
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        error "Docker Compose未安装，请先安装Docker Compose"
    fi
    
    # 检查必要文件
    if [ ! -f "$DOCKER_DIR/docker-compose.prod.yml" ]; then
        error "生产环境配置文件不存在: $DOCKER_DIR/docker-compose.prod.yml"
    fi
    
    if [ ! -f "$DOCKER_DIR/.env.prod" ]; then
        error "环境变量文件不存在: $DOCKER_DIR/.env.prod"
    fi
    
    log "环境检查完成"
}

# ==================== 数据库备份 ====================
backup_database() {
    log "开始数据库备份..."
    
    # 创建备份目录
    mkdir -p "$BACKUP_DIR"
    
    # 备份文件名
    BACKUP_FILE="$BACKUP_DIR/msds_backup_$(date +%Y%m%d_%H%M%S).sql"
    
    # 执行备份
    if docker exec msdsmysql-prod mysqldump -u root -p"${MYSQL_ROOT_PASSWORD}" msds_prod > "$BACKUP_FILE" 2>/dev/null; then
        log "数据库备份成功: $BACKUP_FILE"
        
        # 压缩备份文件
        gzip "$BACKUP_FILE"
        log "备份文件已压缩: $BACKUP_FILE.gz"
        
        # 清理7天前的备份
        find "$BACKUP_DIR" -name "*.sql.gz" -mtime +7 -delete
        log "已清理7天前的备份文件"
    else
        warn "数据库备份失败，继续部署..."
    fi
}

# ==================== 拉取最新镜像 ====================
pull_images() {
    log "开始拉取最新镜像..."
    
    cd "$DOCKER_DIR"
    
    # 设置环境变量
    export $(cat .env.prod | grep -v '^#' | xargs)
    
    # 拉取镜像
    docker-compose -f docker-compose.prod.yml pull
    
    log "镜像拉取完成"
}

# ==================== 蓝绿部署 ====================
blue_green_deploy() {
    log "开始蓝绿部署..."
    
    cd "$DOCKER_DIR"
    
    # 设置环境变量
    export $(cat .env.prod | grep -v '^#' | xargs)
    
    # 启动新版本（绿色环境）
    log "启动新版本服务..."
    docker-compose -f docker-compose.prod.yml up -d --no-deps msdsbackend msdsfrontend
    
    # 等待服务启动
    log "等待服务启动..."
    sleep 30
    
    # 健康检查
    if health_check; then
        log "新版本健康检查通过"
        
        # 更新Nginx配置指向新版本
        log "更新负载均衡配置..."
        docker-compose -f docker-compose.prod.yml restart msdsnginx
        
        # 等待Nginx重启
        sleep 10
        
        # 再次健康检查
        if health_check; then
            log "部署成功！"
            
            # 清理旧镜像
            docker image prune -f
            log "已清理无用镜像"
        else
            error "部署后健康检查失败，请检查服务状态"
        fi
    else
        error "新版本健康检查失败，部署中止"
    fi
}

# ==================== 健康检查 ====================
health_check() {
    log "开始健康检查..."
    
    local max_attempts=10
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        info "健康检查尝试 $attempt/$max_attempts"
        
        # 检查后端服务
        if curl -f -s http://localhost:8080/actuator/health > /dev/null; then
            log "后端服务健康检查通过"
            
            # 检查前端服务
            if curl -f -s http://localhost:3000 > /dev/null; then
                log "前端服务健康检查通过"
                return 0
            else
                warn "前端服务健康检查失败"
            fi
        else
            warn "后端服务健康检查失败"
        fi
        
        sleep 10
        ((attempt++))
    done
    
    error "健康检查失败"
    return 1
}

# ==================== 回滚操作 ====================
rollback() {
    log "开始回滚操作..."
    
    cd "$DOCKER_DIR"
    
    # 停止当前服务
    docker-compose -f docker-compose.prod.yml down
    
    # 恢复到上一个版本的镜像
    # 这里需要根据实际的镜像标签策略来实现
    warn "回滚功能需要根据具体的镜像版本管理策略来实现"
    
    log "回滚完成"
}

# ==================== 监控检查 ====================
check_monitoring() {
    log "检查监控服务..."
    
    # 检查Prometheus
    if curl -f -s http://localhost:9090/-/healthy > /dev/null; then
        log "Prometheus服务正常"
    else
        warn "Prometheus服务异常"
    fi
    
    # 检查Grafana
    if curl -f -s http://localhost:3001/api/health > /dev/null; then
        log "Grafana服务正常"
    else
        warn "Grafana服务异常"
    fi
}

# ==================== 部署后验证 ====================
post_deploy_verification() {
    log "开始部署后验证..."
    
    # 检查容器状态
    log "检查容器状态..."
    docker-compose -f "$DOCKER_DIR/docker-compose.prod.yml" ps
    
    # 检查服务日志
    log "检查服务日志..."
    docker-compose -f "$DOCKER_DIR/docker-compose.prod.yml" logs --tail=50 msdsbackend
    
    # 检查数据库连接
    log "检查数据库连接..."
    if docker exec msdsmysql-prod mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "SELECT 1" > /dev/null 2>&1; then
        log "数据库连接正常"
    else
        error "数据库连接失败"
    fi
    
    # 检查Redis连接
    log "检查Redis连接..."
    if docker exec msdsredis-prod redis-cli -a "${REDIS_PASSWORD}" ping > /dev/null 2>&1; then
        log "Redis连接正常"
    else
        error "Redis连接失败"
    fi
    
    # 检查监控服务
    check_monitoring
    
    log "部署后验证完成"
}

# ==================== 主函数 ====================
main() {
    log "开始MSDS系统自动化部署..."
    
    # 创建日志目录
    mkdir -p "$(dirname "$LOG_FILE")"
    
    # 解析命令行参数
    case "${1:-deploy}" in
        "deploy")
            check_environment
            backup_database
            pull_images
            blue_green_deploy
            post_deploy_verification
            log "部署完成！"
            ;;
        "rollback")
            rollback
            ;;
        "health")
            health_check
            ;;
        "backup")
            backup_database
            ;;
        *)
            echo "用法: $0 {deploy|rollback|health|backup}"
            echo "  deploy  - 执行完整部署流程"
            echo "  rollback - 回滚到上一个版本"
            echo "  health  - 执行健康检查"
            echo "  backup  - 仅执行数据库备份"
            exit 1
            ;;
    esac
}

# 执行主函数
main "$@"