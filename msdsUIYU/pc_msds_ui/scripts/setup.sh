#!/bin/bash

# MSDS管理系统 - 项目初始化脚本
# 用于快速搭建开发环境

set -e

echo "🚀 开始初始化MSDS管理系统开发环境..."

# 检查Node.js版本
check_node_version() {
    echo "📋 检查Node.js版本..."
    if ! command -v node &> /dev/null; then
        echo "❌ Node.js未安装，请先安装Node.js >= 18.0.0"
        exit 1
    fi
    
    NODE_VERSION=$(node -v | cut -d'v' -f2)
    REQUIRED_VERSION="18.0.0"
    
    if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$NODE_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
        echo "❌ Node.js版本过低，当前版本: $NODE_VERSION，要求版本 >= $REQUIRED_VERSION"
        exit 1
    fi
    
    echo "✅ Node.js版本检查通过: $NODE_VERSION"
}

# 检查Docker
check_docker() {
    echo "📋 检查Docker环境..."
    if ! command -v docker &> /dev/null; then
        echo "❌ Docker未安装，请先安装Docker"
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        echo "❌ Docker Compose未安装，请先安装Docker Compose"
        exit 1
    fi
    
    echo "✅ Docker环境检查通过"
}

# 创建项目目录结构
create_directories() {
    echo "📁 创建项目目录结构..."
    
    # 客户端目录
    mkdir -p src/client/main
    mkdir -p src/client/renderer/{components,pages,hooks,services,stores,types,utils}
    mkdir -p src/client/renderer/components/{common,layouts}
    mkdir -p src/client/shared/{constants,types,utils}
    
    # 服务端目录
    mkdir -p src/server/{api,services,models,utils,config}
    mkdir -p src/server/api/{routes,controllers,middlewares}
    mkdir -p src/server/services/{auth,msds,user,search,file}
    mkdir -p src/server/models/{prisma,types}
    
    # 其他目录
    mkdir -p config/{development,production,test}
    mkdir -p scripts/{build,deploy,db}
    mkdir -p tests/{unit,integration,e2e}
    mkdir -p logs
    mkdir -p uploads/temp
    
    echo "✅ 目录结构创建完成"
}

# 安装根目录依赖
install_root_dependencies() {
    echo "📦 安装根目录依赖..."
    npm install --legacy-peer-deps
    echo "✅ 根目录依赖安装完成"
}

# 初始化客户端项目
init_client() {
    echo "⚡ 初始化Electron客户端..."
    
    cd src/client
    
    # 创建package.json
    cat > package.json << EOF
{
  "name": "msds-client",
  "version": "1.0.0",
  "description": "MSDS管理系统客户端",
  "main": "dist/main/main.js",
  "scripts": {
    "dev": "concurrently \"npm run dev:main\" \"npm run dev:renderer\"",
    "dev:main": "tsc && electron ./dist/main/main.js",
    "dev:renderer": "vite",
    "build": "npm run build:main && npm run build:renderer",
    "build:main": "tsc",
    "build:renderer": "vite build",
    "package": "electron-builder",
    "test": "jest",
    "lint": "eslint . --ext .ts,.tsx"
  },
  "dependencies": {
    "electron": "^28.0.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.8.0",
    "antd": "^5.12.0",
    "zustand": "^4.4.0",
    "@tanstack/react-query": "^5.8.0",
    "axios": "^1.6.0",
    "react-pdf": "^7.5.0",
    "pdf-lib": "^1.17.0",
    "lucide-react": "^0.294.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "@vitejs/plugin-react": "^4.1.0",
    "electron-builder": "^24.6.0",
    "vite": "^5.0.0",
    "typescript": "^5.3.0",
    "tailwindcss": "^3.3.0",
    "autoprefixer": "^10.4.0",
    "postcss": "^8.4.0",
    "concurrently": "^8.2.0"
  }
}
EOF
    
    npm install --legacy-peer-deps
    cd ../..
    echo "✅ 客户端初始化完成"
}

# 初始化服务端项目
init_server() {
    echo "🖥️ 初始化Node.js服务端..."
    
    cd src/server
    
    # 创建package.json
    cat > package.json << EOF
{
  "name": "msds-server",
  "version": "1.0.0",
  "description": "MSDS管理系统服务端",
  "main": "dist/app.js",
  "scripts": {
    "dev": "nodemon --exec ts-node src/app.ts",
    "build": "tsc",
    "start": "node dist/app.js",
    "test": "jest",
    "lint": "eslint . --ext .ts",
    "migrate": "prisma migrate dev",
    "seed": "ts-node prisma/seed.ts",
    "db:reset": "prisma migrate reset --force",
    "db:studio": "prisma studio"
  },
  "dependencies": {
    "fastify": "^4.24.0",
    "@fastify/cors": "^8.4.0",
    "@fastify/multipart": "^8.0.0",
    "@fastify/jwt": "^7.2.0",
    "@prisma/client": "^5.7.0",
    "@elastic/elasticsearch": "^8.11.0",
    "redis": "^4.6.0",
    "bcryptjs": "^2.4.0",
    "joi": "^17.11.0",
    "pdf-parse": "^1.1.0",
    "sharp": "^0.32.0",
    "winston": "^3.11.0"
  },
  "devDependencies": {
    "prisma": "^5.7.0",
    "@types/bcryptjs": "^2.4.0",
    "@types/pdf-parse": "^1.1.0",
    "nodemon": "^3.0.0",
    "ts-node": "^10.9.0",
    "typescript": "^5.3.0"
  }
}
EOF
    
    npm install --legacy-peer-deps
    cd ../..
    echo "✅ 服务端初始化完成"
}

# 创建环境变量文件
create_env_files() {
    echo "⚙️ 创建环境变量配置..."
    
    # 创建开发环境配置
    cat > .env.development << EOF
# 开发环境配置
NODE_ENV=development
API_PORT=3000
API_HOST=localhost

# 数据库配置
DATABASE_URL="postgresql://msds_user:msds_dev_password@localhost:5432/msds_dev"
REDIS_URL="redis://:msds_redis_password@localhost:6379"
ELASTICSEARCH_URL="http://localhost:9200"

# MinIO配置
MINIO_ENDPOINT="localhost"
MINIO_PORT=9000
MINIO_ACCESS_KEY="msds_minio_user"
MINIO_SECRET_KEY="msds_minio_password"

# JWT配置
JWT_SECRET="dev-jwt-secret-key"
JWT_EXPIRES_IN="7d"

# 开发调试
DEV_DISABLE_AUTH=false
API_DEBUG=true
DB_DEBUG=true
EOF
    
    # 复制为默认环境变量文件
    cp .env.development .env
    
    echo "✅ 环境变量配置创建完成"
}

# 初始化Git仓库
init_git() {
    echo "🔧 初始化Git仓库..."
    
    if [ ! -d ".git" ]; then
        git init
        
        # 创建.gitignore
        cat > .gitignore << EOF
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Build outputs
dist/
build/
*.tsbuildinfo

# Environment variables
.env
.env.local
.env.development
.env.test
.env.production

# Logs
logs/
*.log

# Runtime data
pids/
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/

# Dependency directories
node_modules/
jspm_packages/

# Uploads and temp files
uploads/
temp/
tmp/

# Database
*.db
*.sqlite

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Electron
app/dist/
release/

# Docker
.dockerignore
docker-compose.override.yml

# Prisma
prisma/migrations/
EOF
        
        git add .
        git commit -m "feat: 初始化MSDS管理系统项目结构"
        
        echo "✅ Git仓库初始化完成"
    else
        echo "⚠️ Git仓库已存在，跳过初始化"
    fi
}

# 启动开发环境
start_dev_environment() {
    echo "🐳 启动开发环境..."
    
    # 启动Docker服务
    if [ -f "docker-compose.dev.yml" ]; then
        docker-compose -f docker-compose.dev.yml up -d
        echo "✅ Docker服务启动完成"
        
        # 等待数据库启动
        echo "⏳ 等待数据库启动..."
        sleep 10
        
        # 运行数据库迁移
        echo "🗃️ 运行数据库迁移..."
        cd src/server
        npx prisma migrate dev --name init || echo "⚠️ 数据库迁移失败，请稍后手动运行"
        cd ../..
    else
        echo "⚠️ docker-compose.dev.yml文件不存在，请先创建Docker配置"
    fi
}

# 显示完成信息
show_completion_info() {
    echo ""
    echo "🎉 MSDS管理系统初始化完成！"
    echo ""
    echo "📖 使用说明："
    echo "1. 启动开发环境："
    echo "   npm run docker:dev    # 启动数据库等服务"
    echo "   npm run dev          # 启动前后端开发服务器"
    echo ""
    echo "2. 访问地址："
    echo "   - 客户端应用: 自动启动桌面应用"
    echo "   - API服务: http://localhost:3000"
    echo "   - Elasticsearch: http://localhost:9200"
    echo "   - Kibana: http://localhost:5601"
    echo "   - MinIO控制台: http://localhost:9001"
    echo ""
    echo "3. 数据库管理："
    echo "   cd src/server && npm run db:studio    # 打开Prisma Studio"
    echo ""
    echo "4. 查看日志："
    echo "   docker-compose logs -f               # 查看所有服务日志"
    echo ""
    echo "📚 更多信息请查看 README.md 文件"
    echo ""
    echo "🚀 现在可以开始开发了！"
}

# 主函数
main() {
    check_node_version
    check_docker
    create_directories
    install_root_dependencies
    init_client
    init_server
    create_env_files
    init_git
    start_dev_environment
    show_completion_info
}

# 运行主函数
main "$@" 