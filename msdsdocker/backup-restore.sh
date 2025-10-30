#!/bin/bash
###############################################################################
# MSDS系统数据库备份和恢复脚本
# 支持完整备份、增量备份、自动备份和手动恢复
###############################################################################

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 配置
BACKUP_DIR="/opt/msds-backup"
MYSQL_CONTAINER="msdsmysql-prod"
ENV_FILE=".env.prod"
RETENTION_DAYS=30  # 保留天数

# 加载环境变量
if [ -f "$ENV_FILE" ]; then
    source $ENV_FILE
else
    echo -e "${RED}错误: 未找到环境变量文件 $ENV_FILE${NC}"
    exit 1
fi

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

# 创建备份目录
create_backup_dir() {
    mkdir -p $BACKUP_DIR/{daily,weekly,monthly}
    log_info "备份目录已创建"
}

# 完整备份
full_backup() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_type=${1:-daily}
    local backup_file="$BACKUP_DIR/$backup_type/mysql_full_backup_${timestamp}.sql"
    
    log_info "开始完整备份 (类型: $backup_type)..."
    
    # 检查容器是否运行
    if ! docker ps | grep -q $MYSQL_CONTAINER; then
        log_error "MySQL容器未运行"
        exit 1
    fi
    
    # 执行备份
    docker exec $MYSQL_CONTAINER mysqldump \
        -u root \
        -p${MYSQL_ROOT_PASSWORD} \
        --all-databases \
        --single-transaction \
        --quick \
        --lock-tables=false \
        --routines \
        --triggers \
        --events \
        --master-data=2 \
        --flush-logs \
        > ${backup_file}
    
    if [ $? -eq 0 ]; then
        # 压缩备份
        gzip ${backup_file}
        backup_file="${backup_file}.gz"
        
        # 计算MD5校验和
        md5sum ${backup_file} > ${backup_file}.md5
        
        local size=$(du -h ${backup_file} | cut -f1)
        log_info "✓ 备份完成: ${backup_file} (${size})"
        
        # 清理旧备份
        cleanup_old_backups $backup_type
    else
        log_error "备份失败"
        exit 1
    fi
}

# 增量备份（基于binlog）
incremental_backup() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_file="$BACKUP_DIR/incremental/binlog_backup_${timestamp}.tar.gz"
    
    log_info "开始增量备份..."
    
    mkdir -p $BACKUP_DIR/incremental
    
    # 刷新binlog
    docker exec $MYSQL_CONTAINER mysql \
        -u root \
        -p${MYSQL_ROOT_PASSWORD} \
        -e "FLUSH LOGS;"
    
    # 复制binlog文件
    docker exec $MYSQL_CONTAINER bash -c \
        "cd /var/lib/mysql && tar czf /tmp/binlog_${timestamp}.tar.gz mysql-bin.*"
    
    docker cp $MYSQL_CONTAINER:/tmp/binlog_${timestamp}.tar.gz $backup_file
    
    docker exec $MYSQL_CONTAINER rm /tmp/binlog_${timestamp}.tar.gz
    
    log_info "✓ 增量备份完成: ${backup_file}"
}

# 单个数据库备份
database_backup() {
    local db_name=$1
    
    if [ -z "$db_name" ]; then
        log_error "请指定数据库名称"
        exit 1
    fi
    
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_file="$BACKUP_DIR/database/${db_name}_${timestamp}.sql"
    
    log_info "开始备份数据库: $db_name..."
    
    mkdir -p $BACKUP_DIR/database
    
    docker exec $MYSQL_CONTAINER mysqldump \
        -u root \
        -p${MYSQL_ROOT_PASSWORD} \
        --single-transaction \
        --quick \
        --lock-tables=false \
        --routines \
        --triggers \
        $db_name > ${backup_file}
    
    if [ $? -eq 0 ]; then
        gzip ${backup_file}
        log_info "✓ 数据库备份完成: ${backup_file}.gz"
    else
        log_error "数据库备份失败"
        exit 1
    fi
}

# 恢复数据库
restore_backup() {
    local backup_file=$1
    
    if [ -z "$backup_file" ]; then
        log_error "请指定备份文件"
        echo "用法: $0 restore <备份文件路径>"
        exit 1
    fi
    
    if [ ! -f "$backup_file" ]; then
        log_error "备份文件不存在: $backup_file"
        exit 1
    fi
    
    log_warn "==================== 警告 ===================="
    log_warn "此操作将恢复数据库，现有数据可能被覆盖！"
    log_warn "============================================="
    read -p "确认要继续吗? (输入 YES 继续): " confirm
    
    if [ "$confirm" != "YES" ]; then
        log_info "操作已取消"
        exit 0
    fi
    
    log_info "开始恢复数据库..."
    
    # 检查是否为压缩文件
    if [[ $backup_file == *.gz ]]; then
        log_info "解压备份文件..."
        gunzip -c $backup_file | docker exec -i $MYSQL_CONTAINER mysql \
            -u root \
            -p${MYSQL_ROOT_PASSWORD}
    else
        docker exec -i $MYSQL_CONTAINER mysql \
            -u root \
            -p${MYSQL_ROOT_PASSWORD} < $backup_file
    fi
    
    if [ $? -eq 0 ]; then
        log_info "✓ 数据库恢复完成"
        log_info "建议重启应用服务: docker-compose restart msdsbackend"
    else
        log_error "数据库恢复失败"
        exit 1
    fi
}

# 清理旧备份
cleanup_old_backups() {
    local backup_type=$1
    local days=$RETENTION_DAYS
    
    # 不同类型使用不同的保留策略
    case $backup_type in
        daily)
            days=7
            ;;
        weekly)
            days=30
            ;;
        monthly)
            days=365
            ;;
    esac
    
    log_info "清理 $days 天前的 $backup_type 备份..."
    
    find $BACKUP_DIR/$backup_type -name "*.sql.gz" -mtime +$days -delete
    find $BACKUP_DIR/$backup_type -name "*.md5" -mtime +$days -delete
    
    log_info "✓ 清理完成"
}

# 列出备份
list_backups() {
    echo ""
    echo -e "${BLUE}=============== 可用备份列表 ===============${NC}"
    echo ""
    
    for backup_type in daily weekly monthly database incremental; do
        if [ -d "$BACKUP_DIR/$backup_type" ]; then
            local count=$(find $BACKUP_DIR/$backup_type -name "*.sql.gz" -o -name "*.tar.gz" | wc -l)
            if [ $count -gt 0 ]; then
                echo -e "${GREEN}[$backup_type 备份]${NC} (共 $count 个)"
                find $BACKUP_DIR/$backup_type -type f \( -name "*.sql.gz" -o -name "*.tar.gz" \) -printf "%T@ %p\n" | \
                    sort -rn | \
                    head -10 | \
                    awk '{print $2}' | \
                    while read file; do
                        local size=$(du -h "$file" | cut -f1)
                        local date=$(date -r "$file" '+%Y-%m-%d %H:%M:%S')
                        echo "  • $file ($size, $date)"
                    done
                echo ""
            fi
        fi
    done
}

# 验证备份完整性
verify_backup() {
    local backup_file=$1
    
    if [ -z "$backup_file" ]; then
        log_error "请指定备份文件"
        exit 1
    fi
    
    if [ ! -f "$backup_file" ]; then
        log_error "备份文件不存在: $backup_file"
        exit 1
    fi
    
    log_info "验证备份完整性: $backup_file"
    
    # 检查MD5校验和
    if [ -f "${backup_file}.md5" ]; then
        md5sum -c ${backup_file}.md5
        if [ $? -eq 0 ]; then
            log_info "✓ MD5校验通过"
        else
            log_error "MD5校验失败，备份文件可能已损坏"
            exit 1
        fi
    else
        log_warn "未找到MD5校验文件"
    fi
    
    # 测试解压
    if [[ $backup_file == *.gz ]]; then
        gunzip -t $backup_file
        if [ $? -eq 0 ]; then
            log_info "✓ 压缩文件完整性验证通过"
        else
            log_error "压缩文件验证失败"
            exit 1
        fi
    fi
    
    log_info "✓ 备份文件验证完成"
}

# 自动备份（用于cron）
auto_backup() {
    local day_of_week=$(date +%u)  # 1-7 (周一到周日)
    local day_of_month=$(date +%d)
    
    # 每月1号执行月备份
    if [ "$day_of_month" == "01" ]; then
        full_backup "monthly"
    # 每周日执行周备份
    elif [ "$day_of_week" == "7" ]; then
        full_backup "weekly"
    # 其他天执行日备份
    else
        full_backup "daily"
    fi
    
    # 发送备份报告（可选）
    send_backup_report
}

# 发送备份报告
send_backup_report() {
    local report_file="/tmp/backup_report_$(date +%Y%m%d).txt"
    
    {
        echo "MSDS系统备份报告"
        echo "日期: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "================================"
        echo ""
        echo "备份统计:"
        for backup_type in daily weekly monthly; do
            if [ -d "$BACKUP_DIR/$backup_type" ]; then
                local count=$(find $BACKUP_DIR/$backup_type -name "*.sql.gz" | wc -l)
                local size=$(du -sh $BACKUP_DIR/$backup_type 2>/dev/null | cut -f1)
                echo "  $backup_type: $count 个备份, 总大小: $size"
            fi
        done
        echo ""
        echo "最新备份:"
        find $BACKUP_DIR -type f -name "*.sql.gz" -printf "%T@ %p\n" | \
            sort -rn | \
            head -5 | \
            awk '{print $2}' | \
            while read file; do
                local size=$(du -h "$file" | cut -f1)
                local date=$(date -r "$file" '+%Y-%m-%d %H:%M:%S')
                echo "  • $(basename $file) ($size, $date)"
            done
    } > $report_file
    
    # 这里可以添加邮件或其他通知方式
    # cat $report_file | mail -s "MSDS备份报告" admin@example.com
    
    log_info "备份报告已生成: $report_file"
}

# 显示帮助信息
show_help() {
    cat << EOF
MSDS系统数据库备份和恢复工具

用法:
  $0 <命令> [选项]

命令:
  full [类型]           - 执行完整备份 (类型: daily|weekly|monthly, 默认: daily)
  incremental          - 执行增量备份 (基于binlog)
  database <数据库名>   - 备份指定数据库
  restore <备份文件>    - 恢复数据库
  list                 - 列出所有备份
  verify <备份文件>     - 验证备份完整性
  auto                 - 自动备份（用于定时任务）
  cleanup [天数]       - 清理指定天数前的备份 (默认: $RETENTION_DAYS)
  help                 - 显示此帮助信息

示例:
  # 执行每日完整备份
  $0 full daily

  # 备份单个数据库
  $0 database msds_prod

  # 恢复数据库
  $0 restore /opt/msds-backup/daily/mysql_full_backup_20240101_120000.sql.gz

  # 列出所有备份
  $0 list

  # 验证备份
  $0 verify /opt/msds-backup/daily/mysql_full_backup_20240101_120000.sql.gz

配置自动备份 (crontab):
  # 每天凌晨2点自动备份
  0 2 * * * /opt/msds/backup-restore.sh auto >> /var/log/msds-backup.log 2>&1

EOF
}

# 主函数
main() {
    create_backup_dir
    
    case "$1" in
        full)
            full_backup ${2:-daily}
            ;;
        incremental)
            incremental_backup
            ;;
        database)
            database_backup $2
            ;;
        restore)
            restore_backup $2
            ;;
        list)
            list_backups
            ;;
        verify)
            verify_backup $2
            ;;
        auto)
            auto_backup
            ;;
        cleanup)
            cleanup_old_backups ${2:-daily}
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            log_error "未知命令: $1"
            show_help
            exit 1
            ;;
    esac
}

# 执行主函数
main "$@"

