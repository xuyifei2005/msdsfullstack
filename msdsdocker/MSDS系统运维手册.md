# MSDS实验室管理系统运维手册

## 版本信息
- **版本**: v1.0
- **更新日期**: 2025-01-27
- **维护者**: MSDS运维团队

## 1. 系统概述

### 1.1 系统架构
MSDS实验室管理系统采用微服务架构，基于Docker容器化部署：

- **前端**: React + Ant Design (端口8000)
- **后端**: Spring Boot + Java (端口18080)
- **数据库**: MySQL 8.0 (端口3306)
- **缓存**: Redis (端口16379)
- **反向代理**: Nginx (端口180)
- **监控系统**: Prometheus + Grafana + cAdvisor

### 1.2 容器服务列表

| 容器名称 | 镜像 | 端口映射 | 状态检查 |
|----------|------|----------|----------|
| msdsfrontend | msdsfrontend | 8000:8000, 2223:22 | http://localhost:8000 |
| msdsbackend | msdsbackend | 18080:8080, 5005:5005, 2222:22 | http://localhost:18080/captchaImage |
| msdsmysql | msdsmysql | 3306:3306 | docker exec -it msdsmysql mysql -u msds_user -p |
| msdsredis | msdsredis | 16379:6379 | docker exec -it msdsredis redis-cli ping |
| msdsnginx | nginx:latest | 180:80, 11443:443 | http://localhost:180 |
| msds-prometheus | prom/prometheus:latest | 9090:9090 | http://localhost:9090 |
| msds-grafana | grafana/grafana:latest | 13000:3000 | http://localhost:13000 |
| msds-cadvisor | gcr.io/cadvisor/cadvisor:latest | 18081:8080 | http://localhost:18081 |

## 2. 部署操作

### 2.1 环境要求
- **操作系统**: Windows 10/11, Linux, macOS
- **Docker**: 20.10+
- **Docker Compose**: 2.0+
- **内存**: 最少8GB，推荐16GB
- **磁盘空间**: 最少20GB可用空间

### 2.2 快速部署

#### 2.2.1 启动主系统
```bash
# 进入Docker配置目录
cd msdsdocker

# 启动MSDS主系统
docker-compose up -d

# 检查容器状态
docker-compose ps
```

#### 2.2.2 启动监控系统
```bash
# 启动监控系统
docker-compose -f docker-compose.monitoring-simple.yml up -d

# 检查监控容器状态
docker ps --filter "name=msds"
```

### 2.3 生产环境部署
```bash
# 使用生产环境配置
docker-compose -f docker-compose.local-prod.yml up -d
```

## 3. 系统监控

### 3.1 访问地址

| 服务 | 访问地址 | 默认凭据 |
|------|----------|----------|
| MSDS前端 | http://localhost:8000 | - |
| MSDS后端API | http://localhost:18080 | - |
| Nginx代理 | http://localhost:180 | - |
| Prometheus | http://localhost:9090 | - |
| Grafana | http://localhost:13000 | admin/admin |
| cAdvisor | http://localhost:18081 | - |

### 3.2 关键指标监控

#### 3.2.1 性能指标
- **API响应时间**: < 500ms
- **前端加载时间**: < 3s
- **数据库连接**: 正常
- **缓存命中率**: > 80%

#### 3.2.2 资源使用
- **CPU使用率**: < 80%
- **内存使用率**: < 85%
- **磁盘使用率**: < 90%
- **网络带宽**: 监控异常流量

### 3.3 健康检查命令
```bash
# 检查所有容器状态
docker ps --filter "name=msds"

# 检查容器资源使用
docker stats --no-stream $(docker ps --filter "name=msds" --format "{{.Names}}")

# 检查数据库连接
docker exec -it msdsmysql mysql -u msds_user -pmsds_dev_password -e "SELECT 1"

# 检查Redis连接
docker exec -it msdsredis redis-cli ping

# 检查API健康状态
curl -f http://localhost:18080/captchaImage

# 检查前端服务
curl -f http://localhost:8000
```

## 4. 日常运维

### 4.1 启动/停止服务

#### 4.1.1 启动服务
```bash
# 启动所有服务
docker-compose up -d

# 启动特定服务
docker-compose up -d msdsbackend

# 启动监控系统
docker-compose -f docker-compose.monitoring-simple.yml up -d
```

#### 4.1.2 停止服务
```bash
# 停止所有服务
docker-compose down

# 停止特定服务
docker-compose stop msdsbackend

# 停止监控系统
docker-compose -f docker-compose.monitoring-simple.yml down
```

### 4.2 日志管理

#### 4.2.1 查看日志
```bash
# 查看所有服务日志
docker-compose logs -f

# 查看特定服务日志
docker-compose logs -f msdsbackend

# 查看最近N行日志
docker logs msdsbackend --tail 50

# 实时跟踪日志
docker logs -f msdsbackend
```

#### 4.2.2 日志轮转
```bash
# 清理旧日志（谨慎操作）
docker system prune -f

# 限制日志大小（在docker-compose.yml中配置）
logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
```

### 4.3 数据备份

#### 4.3.1 数据库备份
```bash
# 创建数据库备份
docker exec msdsmysql mysqldump -u msds_user -pmsds_dev_password msds_dev > backup_$(date +%Y%m%d_%H%M%S).sql

# 恢复数据库
docker exec -i msdsmysql mysql -u msds_user -pmsds_dev_password msds_dev < backup_20250127_120000.sql
```

#### 4.3.2 Redis备份
```bash
# 创建Redis备份
docker exec msdsredis redis-cli BGSAVE

# 复制备份文件
docker cp msdsredis:/data/dump.rdb ./redis_backup_$(date +%Y%m%d_%H%M%S).rdb
```

### 4.4 容器管理

#### 4.4.1 重启容器
```bash
# 重启特定容器
docker restart msdsbackend

# 重启所有MSDS容器
docker restart $(docker ps --filter "name=msds" --format "{{.Names}}")
```

#### 4.4.2 进入容器
```bash
# 进入后端容器
docker exec -it msdsbackend /bin/bash

# 进入数据库容器
docker exec -it msdsmysql /bin/bash

# 进入前端容器
docker exec -it msdsfrontend /bin/bash
```

## 5. 故障排除

### 5.1 常见问题

#### 5.1.1 容器启动失败
**问题**: 容器无法启动
**排查步骤**:
1. 检查端口占用: `netstat -an | findstr :8080`
2. 查看容器日志: `docker logs msdsbackend`
3. 检查镜像是否存在: `docker images`
4. 检查Docker服务状态

#### 5.1.2 数据库连接失败
**问题**: 应用无法连接数据库
**排查步骤**:
1. 检查MySQL容器状态: `docker ps | grep msdsmysql`
2. 测试数据库连接: `docker exec -it msdsmysql mysql -u msds_user -p`
3. 检查网络连接: `docker network ls`
4. 验证数据库配置

#### 5.1.3 前端页面无法访问
**问题**: 前端页面加载失败
**排查步骤**:
1. 检查前端容器状态: `docker ps | grep msdsfrontend`
2. 查看Nginx配置: `docker exec -it msdsnginx nginx -t`
3. 检查端口映射: `docker port msdsfrontend`
4. 验证API连接

### 5.2 性能问题

#### 5.2.1 响应时间慢
**排查步骤**:
1. 检查系统资源使用: `docker stats`
2. 分析数据库查询: 查看慢查询日志
3. 检查Redis缓存命中率
4. 监控网络延迟

#### 5.2.2 内存使用过高
**排查步骤**:
1. 识别高内存使用容器: `docker stats --no-stream`
2. 检查应用内存泄漏
3. 调整JVM参数（后端）
4. 优化数据库查询

## 6. 安全管理

### 6.1 访问控制
- 定期更新密码
- 使用强密码策略
- 限制SSH访问
- 配置防火墙规则

### 6.2 数据安全
- 定期备份数据
- 加密敏感数据
- 监控异常访问
- 实施访问审计

### 6.3 容器安全
- 定期更新镜像
- 扫描安全漏洞
- 限制容器权限
- 监控容器行为

## 7. 升级维护

### 7.1 系统升级

#### 7.1.1 应用升级
```bash
# 1. 备份当前数据
./backup-restore.sh backup

# 2. 拉取新镜像
docker-compose pull

# 3. 停止服务
docker-compose down

# 4. 启动新版本
docker-compose up -d

# 5. 验证升级结果
docker-compose ps
```

#### 7.1.2 数据库升级
```bash
# 1. 备份数据库
docker exec msdsmysql mysqldump -u msds_user -pmsds_dev_password msds_dev > pre_upgrade_backup.sql

# 2. 停止应用服务
docker-compose stop msdsbackend msdsfrontend

# 3. 升级数据库
docker-compose up -d msdsmysql

# 4. 执行升级脚本
docker exec -i msdsmysql mysql -u msds_user -pmsds_dev_password msds_dev < upgrade_script.sql

# 5. 重启应用服务
docker-compose up -d
```

### 7.2 定期维护

#### 7.2.1 每日检查
- [ ] 检查所有容器运行状态
- [ ] 查看系统资源使用情况
- [ ] 检查应用日志错误
- [ ] 验证备份任务执行

#### 7.2.2 每周维护
- [ ] 清理Docker系统缓存
- [ ] 更新系统补丁
- [ ] 检查磁盘空间使用
- [ ] 分析性能指标趋势

#### 7.2.3 每月维护
- [ ] 更新Docker镜像
- [ ] 检查安全漏洞
- [ ] 优化数据库性能
- [ ] 更新监控配置

## 8. 联系信息

### 8.1 技术支持
- **运维团队**: msds-ops@company.com
- **开发团队**: msds-dev@company.com
- **紧急联系**: +86-xxx-xxxx-xxxx

### 8.2 相关文档
- [部署指南](./快速部署指南.md)
- [API文档](../aboutproject/接口文档/InterfaceApi.md)
- [技术架构](../aboutproject/TechnicalManual/Technical_Architecture.md)

---

**注意**: 本手册应根据实际部署环境和需求进行调整，定期更新以保持准确性。