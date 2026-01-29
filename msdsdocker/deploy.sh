#!/bin/bash
###############################################################################
# MSDS系统生产环境自动化部署脚本
# 服务器: 39.107.211.72
# 域名: flymsds.cn
# 版本: 1.0.0
###############################################################################

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目配置
PROJECT_NAME="MSDS管理系统"
PROJECT_DIR="/opt/msds"
BACKUP_DIR="/opt/msds-backup"
COMPOSE_FILE="docker-compose.prod.yml"
ENV_FILE=".env.prod"

# 日志函数
log_info() {
    echo -e "${GREEN}[INFO]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_step() {
    echo -e "${BLUE}[STEP]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# 显示Banner
show_banner() {
    clear
    echo -e "${GREEN}"
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║                                                        ║"
    echo "║          MSDS系统生产环境部署脚本 v1.0.0               ║"
    echo "║                                                        ║"
    echo "║          服务器: 39.107.211.72                         ║"
    echo "║          域名: flymsds.cn                              ║"
    echo "║                                                        ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# 检查系统要求
check_requirements() {
    log_step "检查系统要求..."
    
    # 检查是否为root用户
    if [[ $EUID -ne 0 ]]; then
        log_error "此脚本需要root权限运行"
        exit 1
    fi
    
    # 检查Docker
    if ! command -v docker &> /dev/null; then
        log_error "Docker未安装，请先安装Docker"
        exit 1
    fi
    log_info "✓ Docker已安装: $(docker --version)"
    
    # 检查Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        log_error "Docker Compose未安装，请先安装Docker Compose"
        exit 1
    fi
    log_info "✓ Docker Compose已安装: $(docker-compose --version)"
    
    # 检查磁盘空间（至少需要10GB）
    available_space=$(df / | tail -1 | awk '{print $4}')
    if [ $available_space -lt 10485760 ]; then
        log_warn "磁盘空间不足10GB，当前可用: $(df -h / | tail -1 | awk '{print $4}')"
    else
        log_info "✓ 磁盘空间充足: $(df -h / | tail -1 | awk '{print $4}')"
    fi
    
    log_info "系统要求检查完成"
}

# 创建必要目录
create_directories() {
    log_step "创建项目目录结构..."
    
    mkdir -p $PROJECT_DIR
    mkdir -p $BACKUP_DIR
    mkdir -p $PROJECT_DIR/nginx/ssl
    mkdir -p $PROJECT_DIR/nginx/html
    mkdir -p $PROJECT_DIR/nginx/logs
    mkdir -p $PROJECT_DIR/mysql/conf.d
    
    log_info "目录创建完成"
}

# 检查环境变量配置
check_env_config() {
    log_step "检查环境变量配置..."
    
    if [ ! -f "$ENV_FILE" ]; then
        log_error "未找到环境变量配置文件: $ENV_FILE"
        log_info "请从 env.prod.example 复制并修改配置"
        exit 1
    fi
    
    # 检查是否还在使用默认密码
    if grep -q "CHANGE_ME" "$ENV_FILE"; then
        log_error "请修改 $ENV_FILE 中的默认密码！"
        exit 1
    fi
    
    log_info "环境变量配置检查通过"
}

# 检查SSL证书
check_ssl_certificates() {
    log_step "检查SSL证书..."
    
    if [ ! -f "./nginx/ssl/flymsds.cn.pem" ] || [ ! -f "./nginx/ssl/flymsds.cn.key" ]; then
        log_warn "未找到SSL证书文件"
        log_warn "请将证书文件放置到: ./nginx/ssl/"
        log_warn "  - flymsds.cn.pem"
        log_warn "  - flymsds.cn.key"
        
        read -p "是否继续部署（将使用HTTP）? [y/N] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        log_info "✓ SSL证书文件已就绪"
    fi
}

# 备份数据库
backup_database() {
    log_step "备份生产数据库..."
    
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_file="$BACKUP_DIR/mysql_backup_${timestamp}.sql"
    
    # 检查是否有运行中的MySQL容器
    if docker ps | grep -q msdsmysql-prod; then
        log_info "开始备份数据库..."
        
        # 从环境变量文件读取密码
        source $ENV_FILE
        
        docker exec msdsmysql-prod mysqldump \
            -u root \
            -p${MYSQL_ROOT_PASSWORD} \
            --all-databases \
            --single-transaction \
            --quick \
            --lock-tables=false \
            > ${backup_file}
        
        if [ $? -eq 0 ]; then
            # 压缩备份文件
            gzip ${backup_file}
            log_info "数据库备份完成: ${backup_file}.gz"
            
            # 删除30天前的备份
            find $BACKUP_DIR -name "mysql_backup_*.sql.gz" -mtime +30 -delete
            log_info "已清理30天前的旧备份"
        else
            log_error "数据库备份失败"
            exit 1
        fi
    else
        log_warn "未找到运行中的MySQL容器，跳过备份"
    fi
}

# 拉取最新代码
pull_latest_code() {
    log_step "拉取最新代码..."
    
    if [ -d ".git" ]; then
        git pull origin main
        log_info "代码更新完成"
    else
        log_warn "非Git仓库，跳过代码拉取"
    fi
}

# 构建前端
build_frontend() {
    log_step "构建前端应用..."
    
    cd ../msdsPC/ruoyi-MsdsPc-react/react-ui
    
    # 安装依赖
    log_info "安装前端依赖..."
    npm install --production
    
    # 执行构建
    log_info "执行生产环境构建..."
    npm run build:prod
    
    # 复制构建产物到Nginx目录
    log_info "复制构建产物..."
    rm -rf ../../../msdsdocker/nginx/html/*
    cp -r dist/* ../../../msdsdocker/nginx/html/
    
    cd - > /dev/null
    
    log_info "前端构建完成"
}

# 构建后端
build_backend() {
    log_step "构建后端应用..."
    
    cd ../msdsPC/ruoyi-MsdsPc-react
    
    # 执行Maven打包
    log_info "执行Maven打包..."
    mvn clean package -Pprod -DskipTests
    
    if [ $? -eq 0 ]; then
        log_info "后端构建完成"
    else
        log_error "后端构建失败"
        exit 1
    fi
    
    cd - > /dev/null
}

# 停止旧容器
stop_old_containers() {
    log_step "停止旧容器..."
    
    if docker-compose -f $COMPOSE_FILE ps | grep -q "Up"; then
        docker-compose -f $COMPOSE_FILE down
        log_info "旧容器已停止"
    else
        log_info "没有运行中的容器"
    fi
}

# 启动新容器
start_new_containers() {
    log_step "启动新容器..."
    
    # 使用环境变量文件启动
    docker-compose -f $COMPOSE_FILE --env-file $ENV_FILE up -d --build
    
    log_info "容器启动完成"
}

# 健康检查
health_check() {
    log_step "执行健康检查..."
    
    local max_retries=30
    local retry=0
    
    while [ $retry -lt $max_retries ]; do
        # 检查后端健康状态
        if docker exec msdsbackend-prod curl -f http://localhost:8080/actuator/health > /dev/null 2>&1; then
            log_info "✓ 后端服务健康检查通过"
            break
        fi
        
        retry=$((retry + 1))
        log_warn "等待服务启动... ($retry/$max_retries)"
        sleep 10
    done
    
    if [ $retry -eq $max_retries ]; then
        log_error "后端服务健康检查失败"
        log_error "查看日志: docker logs msdsbackend-prod"
        exit 1
    fi
    
    # 检查Nginx
    if docker exec msdsnginx-prod wget --quiet --tries=1 --spider http://localhost/ > /dev/null 2>&1; then
        log_info "✓ Nginx服务健康检查通过"
    else
        log_warn "Nginx服务健康检查失败"
    fi
    
    # 检查MySQL
    if docker exec msdsmysql-prod mysqladmin ping -h localhost --silent > /dev/null 2>&1; then
        log_info "✓ MySQL服务健康检查通过"
    else
        log_warn "MySQL服务健康检查失败"
    fi
    
    # 检查Redis
    if docker exec msdsredis-prod sh -lc 'if [ -n "$MSDS_REDIS_PASSWORD" ]; then redis-cli -a "$MSDS_REDIS_PASSWORD" ping; else redis-cli ping; fi' > /dev/null 2>&1; then
        log_info "✓ Redis服务健康检查通过"
    else
        log_warn "Redis服务健康检查失败"
    fi
}

# 清理资源
cleanup() {
    log_step "清理未使用的Docker资源..."
    
    docker system prune -f
    
    log_info "清理完成"
}

# 显示部署信息
show_deployment_info() {
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                        ║${NC}"
    echo -e "${GREEN}║              🎉 部署成功！系统已启动                    ║${NC}"
    echo -e "${GREEN}║                                                        ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}访问地址:${NC}"
    echo -e "  • HTTPS: ${GREEN}https://flymsds.cn${NC}"
    echo -e "  • HTTP:  ${GREEN}http://39.107.211.72${NC}"
    echo ""
    echo -e "${BLUE}服务状态:${NC}"
    docker-compose -f $COMPOSE_FILE ps
    echo ""
    echo -e "${BLUE}常用命令:${NC}"
    echo -e "  • 查看日志:   ${YELLOW}docker-compose -f $COMPOSE_FILE logs -f [服务名]${NC}"
    echo -e "  • 重启服务:   ${YELLOW}docker-compose -f $COMPOSE_FILE restart [服务名]${NC}"
    echo -e "  • 停止服务:   ${YELLOW}docker-compose -f $COMPOSE_FILE down${NC}"
    echo -e "  • 查看状态:   ${YELLOW}docker-compose -f $COMPOSE_FILE ps${NC}"
    echo ""
}

# 主函数
main() {
    show_banner
    
    log_info "开始部署 $PROJECT_NAME..."
    
    check_requirements
    create_directories
    check_env_config
    check_ssl_certificates
    
    # 生产环境需要备份
    read -p "是否备份现有数据库? [Y/n] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        backup_database
    fi
    
    # 询问是否重新构建
    read -p "是否重新构建前后端? [Y/n] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        build_frontend
        build_backend
    fi
    
    stop_old_containers
    start_new_containers
    health_check
    cleanup
    
    show_deployment_info
    
    log_info "部署流程完成！"
}

# 执行主函数
main "$@"
