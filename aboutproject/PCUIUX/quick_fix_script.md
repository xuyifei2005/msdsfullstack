# 登录页面快速修复脚本

## 问题
登录页面空白，控制台报React懒加载错误

## 快速修复步骤

### 步骤1：停止并删除容器
```powershell
docker stop msdsfrontend
docker rm msdsfrontend
```

### 步骤2：清理本地缓存
```powershell
cd msdsPC\ruoyi-MsdsPc-react\react-ui
Remove-Item -Recurse -Force .umi,src\.umi,node_modules\.cache,dist -ErrorAction SilentlyContinue
```

### 步骤3：重新构建并启动容器
```powershell
cd ..\..\..\..\msdsdocker
docker-compose up -d --build msdsfrontend
```

### 步骤4：等待编译完成
```powershell
Start-Sleep -Seconds 120
```

### 步骤5：访问页面
打开浏览器访问：`http://localhost:8000/user/login`

## 如果仍然失败

### 检查日志
```powershell
docker logs -f msdsfrontend
```

查找任何编译错误

### 检查文件权限
```powershell
docker exec msdsfrontend ls -la /app/src/pages/User/Login/
```

### 重新克隆代码（最后手段）
```powershell
# 备份当前修改
git stash

# 重置到最后一次工作的提交
git reset --hard HEAD~10

# 查找可以工作的提交
git log --oneline

# 逐个测试
git checkout <commit-hash>
```

## 当前文件状态

- `index.tsx` - 已恢复到基础版本（无自定义样式）
- `index.less` - 已删除
- 使用Ant Design Pro的标准LoginForm组件

## 重要提示

当前问题与登录页面优化代码无关，是UmiJS路由系统的底层问题。建议：

1. 先解决页面加载问题
2. 确保基本登录功能正常
3. 然后再逐步添加样式优化

---

**创建时间**: 2025-11-04 09:30  
**紧急程度**: 高  
**需要协助**: 可能需要系统管理员检查Docker配置

