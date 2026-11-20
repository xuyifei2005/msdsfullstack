#!/bin/sh
# MSDS 后端开发环境启动脚本（挂载到 msdsbackend 容器内执行）
#
# 为什么需要这个脚本：
#   /app 挂载的是 Windows 目录，Docker Desktop 的跨系统文件 IO 很慢，
#   mvn -DskipTests package 在挂载盘上完整编译一次需要 40 分钟以上。
#   旧版 command 每次容器启动都会重新编译，导致后端长时间不可用，
#   前端 umi 代理请求后端超时，登录页直接报 504。
#
# 新逻辑：
#   已存在 ruoyi-admin/target/ruoyi-admin.jar 且没有比它更新的源码/配置文件
#   -> 直接复用该 jar，跳过 Maven 编译，秒级启动；
#   否则照旧执行 mvn -DskipTests package。
#
# 需要强制重新编译时，二选一：
#   docker compose exec msdsbackend rm -f /app/ruoyi-admin/target/ruoyi-admin.jar
#   或启动前设置环境变量 FORCE_BUILD=1

echo 'Starting development environment setup...'
/usr/sbin/sshd
echo 'SSH service started successfully'
echo '*msdsbackend* Development environment ready!'

cd /app

JAR='ruoyi-admin/target/ruoyi-admin.jar'
SRC_DIRS='ruoyi-admin ruoyi-common ruoyi-framework ruoyi-generator ruoyi-quartz ruoyi-system'

# 返回 0 表示需要重新编译（jar 不存在 / 被强制 / 有更新的源码）
need_build() {
  if [ -n "$FORCE_BUILD" ]; then
    echo 'FORCE_BUILD is set - rebuilding'
    return 0
  fi
  if [ ! -f "$JAR" ]; then
    echo "$JAR not found"
    return 0
  fi
  changed=$(find $SRC_DIRS -type d -name target -prune -o -type f \
    \( -name '*.java' -o -name '*.yml' -o -name '*.yaml' -o -name '*.xml' -o -name '*.properties' \) \
    -newer "$JAR" -print -quit 2>/dev/null)
  if [ -n "$changed" ]; then
    echo "Changed source detected: $changed"
    return 0
  fi
  return 1
}

if need_build; then
  echo 'Starting Maven build...'
  mvn -DskipTests package || { echo 'Maven build FAILED!'; exit 1; }
  echo 'Maven build completed'
else
  echo "No source change since last build - skipping Maven build, reusing $JAR"
fi

echo 'Starting application...'
java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005 -jar "$JAR" && tail -f /dev/null
