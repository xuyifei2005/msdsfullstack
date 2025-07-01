
# 前端页面初始化：
从错误日志来看，主要有几个问题：

1. 依赖版本冲突：
```
WARN While resolving: dva-loading@3.0.25
WARN Found: dva-core@2.0.4
```

2. 权限问题：
```
EPERM: operation not permitted, rmdir
```

3. 模块缺失：
```
Error: Cannot find module '...is-extglob\index.js'
```

建议按以下步骤解决：

1. 首先，以管理员身份打开 PowerShell，然后执行：
```bash
# 进入项目目录
cd D:\tdqqsysfullstack\tdqqBS\tdqqbsruoyireact\ruoyi-react\react-ui

# 删除 node_modules 目录（使用管理员权限）
Remove-Item -Recurse -Force node_modules
Remove-Item package-lock.json
```

2. 清理 npm 缓存：
```bash
npm cache clean --force
```

3. 设置淘宝镜像（加快下载速度）：
```bash
npm config set registry https://registry.npmmirror.com
```

4. 安装依赖：
```bash
# 先安装核心依赖
npm install umi@latest @umijs/max@latest --save-dev

# 然后安装其他依赖
npm install
```

如果还是不行，可以尝试使用 cnpm：
```bash
# 安装 cnpm
npm install -g cnpm --registry=https://registry.npmmirror.com

# 使用 cnpm 安装依赖
cnpm install
```

如果以上方法都不行，还可以：

1. 降级 Node.js 版本到 v16（因为项目推荐 v16）：
```bash
# 可以使用 nvm 工具来管理 Node.js 版本
nvm install 16
nvm use 16
```

2. 然后重新执行安装：
```bash
npm install
```

---





