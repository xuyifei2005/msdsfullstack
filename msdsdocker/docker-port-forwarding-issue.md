# Docker端口转发问题解决方案

## 问题描述

MSDS系统的Docker容器在内部网络中正常运行，但无法通过localhost端口访问服务。

## 诊断结果

### 容器状态
- ✅ 所有MSDS容器正常运行
- ✅ 前端服务在容器内部正常响应（HTTP 200）
- ✅ Nginx代理在容器内部正常工作
- ✅ 端口映射配置正确

### 问题根因
- ❌ Docker Desktop服务（com.docker.service）已停止
- ❌ 端口转发功能失效

## 解决方案

### 方案1：重启Docker Desktop（推荐）
1. 关闭Docker Desktop应用程序
2. 以管理员身份重新启动Docker Desktop
3. 等待Docker Desktop完全启动
4. 验证服务访问

### 方案2：通过服务管理器启动
1. 按Win+R，输入`services.msc`
2. 找到"Docker Desktop Service"
3. 右键选择"启动"
4. 等待服务启动完成

### 方案3：命令行重启（需要管理员权限）
```powershell
# 以管理员身份运行PowerShell
Restart-Service -Name "com.docker.service" -Force
```

## 验证步骤

启动Docker服务后，执行以下验证：

```powershell
# 1. 检查Docker服务状态
Get-Service -Name "*docker*"

# 2. 测试前端访问
Invoke-WebRequest -Uri "http://localhost:8000" -UseBasicParsing

# 3. 测试后端访问（等待编译完成）
Invoke-WebRequest -Uri "http://localhost:18080/health" -UseBasicParsing

# 4. 测试Nginx代理
Invoke-WebRequest -Uri "http://localhost:180/health" -UseBasicParsing
```

## 当前服务状态

### 容器内部网络（正常）
- 前端：http://172.19.0.6:8000 ✅
- 后端：http://172.19.0.4:8080 🔄（编译中）
- Nginx：http://172.19.0.5:80 ✅

### 主机端口映射（需要修复）
- 前端：http://localhost:8000 ❌
- 后端：http://localhost:18080 ❌
- Nginx：http://localhost:180 ❌

## 预防措施

1. **定期检查Docker服务状态**
   ```powershell
   Get-Service -Name "*docker*" | Where-Object {$_.Status -ne "Running"}
   ```

2. **设置Docker服务自动启动**
   - 在服务管理器中将Docker服务设置为"自动"启动

3. **监控容器健康状态**
   ```bash
   docker ps --format "table {{.Names}}\t{{.Status}}"
   ```

## 性能优化建议

在解决端口转发问题后，建议执行以下优化：

1. **配置域名和SSL证书**
2. **优化MySQL数据库配置**
3. **实施系统监控和告警**

## 联系支持

如果问题持续存在，请提供以下信息：
- Docker Desktop版本
- Windows版本
- 错误日志
- 网络诊断报告

---
*文档生成时间：$(Get-Date)*
*问题状态：待解决*