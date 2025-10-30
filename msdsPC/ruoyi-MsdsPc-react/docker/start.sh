#!/bin/sh
# MSDS实验室管理系统 - 后端启动脚本
# 版本: v1.0
# 更新日期: 2025-01-27

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# 环境变量默认值
JAVA_OPTS="${JAVA_OPTS:--Xms512m -Xmx2g -XX:+UseG1GC -XX:+UseStringDeduplication}"
SPRING_PROFILES_ACTIVE="${SPRING_PROFILES_ACTIVE:-prod}"
SERVER_PORT="${SERVER_PORT:-8080}"

# 数据库连接配置
DB_HOST="${DB_HOST:-msdsmysql}"
DB_PORT="${DB_PORT:-3306}"
DB_NAME="${DB_NAME:-msds_dev}"
DB_USERNAME="${DB_USERNAME:-msds_user}"
DB_PASSWORD="${DB_PASSWORD:-msds_dev_password}"

# Redis配置
REDIS_HOST="${REDIS_HOST:-msdsredis}"
REDIS_PORT="${REDIS_PORT:-6379}"
REDIS_PASSWORD="${REDIS_PASSWORD:-}"

log_info "=== MSDS实验室管理系统启动 ==="
log_info "Java版本: $(java -version 2>&1 | head -n 1)"
log_info "环境配置: ${SPRING_PROFILES_ACTIVE}"
log_info "服务端口: ${SERVER_PORT}"
log_info "数据库: ${DB_HOST}:${DB_PORT}/${DB_NAME}"
log_info "Redis: ${REDIS_HOST}:${REDIS_PORT}"

# 等待数据库就绪
log_info "等待数据库连接..."
timeout=60
while [ $timeout -gt 0 ]; do
    if nc -z ${DB_HOST} ${DB_PORT} 2>/dev/null; then
        log_info "数据库连接成功"
        break
    fi
    log_warn "等待数据库启动... (剩余 ${timeout}s)"
    sleep 2
    timeout=$((timeout-2))
done

if [ $timeout -le 0 ]; then
    log_error "数据库连接超时"
    exit 1
fi

# 等待Redis就绪
log_info "等待Redis连接..."
timeout=30
while [ $timeout -gt 0 ]; do
    if nc -z ${REDIS_HOST} ${REDIS_PORT} 2>/dev/null; then
        log_info "Redis连接成功"
        break
    fi
    log_warn "等待Redis启动... (剩余 ${timeout}s)"
    sleep 2
    timeout=$((timeout-2))
done

if [ $timeout -le 0 ]; then
    log_error "Redis连接超时"
    exit 1
fi

# 创建必要目录
mkdir -p /app/logs /app/uploadPath /app/temp

# 设置JVM参数
JAVA_OPTS="${JAVA_OPTS} -Djava.security.egd=file:/dev/./urandom"
JAVA_OPTS="${JAVA_OPTS} -Dspring.profiles.active=${SPRING_PROFILES_ACTIVE}"
JAVA_OPTS="${JAVA_OPTS} -Dserver.port=${SERVER_PORT}"
JAVA_OPTS="${JAVA_OPTS} -Dfile.encoding=UTF-8"
JAVA_OPTS="${JAVA_OPTS} -Duser.timezone=Asia/Shanghai"

# 数据库连接参数
JAVA_OPTS="${JAVA_OPTS} -Dspring.datasource.url=jdbc:mysql://${DB_HOST}:${DB_PORT}/${DB_NAME}?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true"
JAVA_OPTS="${JAVA_OPTS} -Dspring.datasource.username=${DB_USERNAME}"
JAVA_OPTS="${JAVA_OPTS} -Dspring.datasource.password=${DB_PASSWORD}"

# Redis连接参数
JAVA_OPTS="${JAVA_OPTS} -Dspring.redis.host=${REDIS_HOST}"
JAVA_OPTS="${JAVA_OPTS} -Dspring.redis.port=${REDIS_PORT}"
if [ -n "${REDIS_PASSWORD}" ]; then
    JAVA_OPTS="${JAVA_OPTS} -Dspring.redis.password=${REDIS_PASSWORD}"
fi

# 启动应用
log_info "启动MSDS后端应用..."
log_info "JVM参数: ${JAVA_OPTS}"

exec java ${JAVA_OPTS} -jar /app/app.jar