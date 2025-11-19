# Windows PowerShell 部署说明

> **Windows服务器使用PowerShell脚本进行部署**

---

## ✅ 问题已修复

您之前遇到的PowerShell脚本语法错误已经全部修复：

- ✅ 修复正则表达式语法问题
- ✅ 修复字符编码问题
- ✅ 修复字符串闭合问题
- ✅ 优化环境变量读取逻辑

---

## 🚀 快速使用

### 前置条件

1. **Windows系统**（Windows Server 2016+ 或 Windows 10+）
2. **Docker Desktop已安装**
3. **PowerShell 5.1+**（Windows自带）

### 执行部署

```powershell
# 1. 打开PowerShell（管理员模式）
# 右键点击PowerShell图标 -> 以管理员身份运行

# 2. 进入项目目录
cd D:\XUYIFEI\XUPROJECTS\msdsfullstack\msdsdocker

# 3. 设置执行策略（首次需要）
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 4. 执行部署脚本
.\deploy.ps1
```

---

## 📋 部署步骤说明

### 第一步：检查环境

脚本会自动检查：
- Docker是否安装
- Docker Compose是否安装
- 环境变量配置是否正确
- SSL证书是否存在

### 第二步：交互式选择

脚本会询问：
```powershell
是否备份现有数据库? [Y/n]
# 输入 Y 或直接回车：备份
# 输入 n：跳过备份

是否重新构建前后端? [Y/n]
# 输入 Y 或直接回车：重新构建
# 输入 n：跳过构建
```

### 第三步：自动部署

脚本会自动执行：
1. 停止旧容器
2. 启动新容器
3. 执行健康检查
4. 显示部署结果

---

## 🎯 命令参数

### 跳过备份

```powershell
.\deploy.ps1 -SkipBackup
```

### 跳过构建

```powershell
.\deploy.ps1 -SkipBuild
```

### 强制执行（跳过所有确认）

```powershell
.\deploy.ps1 -Force
```

### 组合使用

```powershell
# 跳过备份和构建，强制执行
.\deploy.ps1 -SkipBackup -SkipBuild -Force
```

---

## 🔧 常见问题

### 问题1: 执行策略限制

**错误信息**:
```
无法加载文件 deploy.ps1，因为在此系统上禁止运行脚本
```

**解决方法**:
```powershell
# 临时允许
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

# 或永久允许（仅当前用户）
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 问题2: 编码问题导致中文乱码

**解决方法**:
```powershell
# 设置PowerShell输出编码
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001
```

### 问题3: 权限不足

**错误信息**:
```
拒绝访问
```

**解决方法**:
以管理员身份运行PowerShell

### 问题4: Docker命令失败

**检查Docker状态**:
```powershell
# 检查Docker服务是否运行
Get-Service -Name *docker*

# 检查Docker版本
docker --version
docker-compose --version
```

---

## 📊 脚本执行流程

```
开始
 ↓
显示Banner
 ↓
检查系统要求
 ├─ Docker ✓
 ├─ Docker Compose ✓
 └─ 环境配置 ✓
 ↓
检查SSL证书
 ↓
询问是否备份
 ├─ Y → 备份数据库
 └─ n → 跳过
 ↓
询问是否构建
 ├─ Y → 构建前端和后端
 └─ n → 跳过
 ↓
停止旧容器
 ↓
启动新容器
 ↓
健康检查
 ├─ 后端 ✓
 ├─ Nginx ✓
 └─ MySQL ✓
 ↓
显示部署结果
 ↓
完成
```

---

## 🛡️ 安全建议

### 1. 保护环境变量文件

```powershell
# 设置文件为只读
Set-ItemProperty -Path .env.prod -Name IsReadOnly -Value $true

# 或限制访问权限
icacls .env.prod /inheritance:r /grant:r "$env:USERNAME:(R)"
```

### 2. 定期备份

```powershell
# 设置计划任务每天备份
$action = New-ScheduledTaskAction -Execute 'PowerShell.exe' `
    -Argument '-File "D:\XUYIFEI\XUPROJECTS\msdsfullstack\msdsdocker\backup-database.ps1"'
    
$trigger = New-ScheduledTaskTrigger -Daily -At 2am

Register-ScheduledTask -TaskName "MSDS数据库备份" `
    -Action $action -Trigger $trigger `
    -Description "每日自动备份MSDS数据库"
```

---

## 📝 与Linux脚本的对比

| 特性 | PowerShell (deploy.ps1) | Bash (deploy.sh) |
|-----|------------------------|------------------|
| 操作系统 | Windows | Linux |
| 语法风格 | .NET风格 | Shell风格 |
| 错误处理 | try-catch | set -e |
| 颜色输出 | Write-Host -ForegroundColor | echo with colors |
| 参数 | param() | getopts |
| 功能 | 完全相同 | 完全相同 |

---

## 🎯 下一步

部署成功后：

1. ✅ 访问系统：https://flymsds.cn
2. ✅ 修改默认密码
3. ✅ 配置定时备份
4. ✅ 测试所有功能

---

## 📞 获取帮助

```powershell
# 查看脚本帮助
Get-Help .\deploy.ps1

# 查看容器日志
docker logs -f msdsbackend-prod

# 查看容器状态
docker-compose -f docker-compose.prod.yml ps

# 重启服务
docker-compose -f docker-compose.prod.yml restart
```

---

## ✨ 最佳实践

### 1. 部署前检查

```powershell
# 检查磁盘空间
Get-PSDrive C | Select-Object Used,Free

# 检查Docker资源
docker system df

# 测试环境配置
docker-compose -f docker-compose.prod.yml config
```

### 2. 部署后验证

```powershell
# 等待30秒让服务完全启动
Start-Sleep -Seconds 30

# 测试健康检查端点
Invoke-WebRequest https://flymsds.cn/health

# 查看所有容器状态
docker ps

# 查看最近的日志
docker-compose -f docker-compose.prod.yml logs --tail=100
```

### 3. 故障回滚

```powershell
# 如果部署失败，快速回滚
docker-compose -f docker-compose.prod.yml down
docker-compose -f docker-compose.prod.yml up -d

# 恢复数据库备份（如果需要）
# 使用 backup-restore.sh 脚本
```

---

**文档版本**: 1.0.1  
**最后更新**: 2024-10-25  
**修复内容**: 修复PowerShell脚本语法错误和编码问题

