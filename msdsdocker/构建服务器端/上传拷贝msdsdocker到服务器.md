
### 上传docker文件一键部署！
scp -r D:\XUYIFEI\XUPROJECTS\msdsfullstack\msdsdocker  root@39.107.211.72:/opt/msds/msdsfullstack/



# 停止并重新启动容器
docker-compose -f docker-compose.prod.yml restart msdsbackend

# 或者重新创建容器
docker-compose -f docker-compose.prod.yml up -d --force-recreate msdsbackend

# 查看日志确认启动成功
docker-compose -f docker-compose.prod.yml logs -f msdsbackend






# 停止并重新创建容器
docker-compose -f docker-compose.prod.yml up -d --force-recreate msdsbackend

# 查看日志确认启动成功
docker-compose -f docker-compose.prod.yml logs -f msdsbackend






# 重启所有服务
docker-compose -f docker-compose.prod.yml restart

# 或者重新创建容器
docker-compose -f docker-compose.prod.yml up -d --force-recreate

# 查看日志确认启动成功
docker-compose -f docker-compose.prod.yml logs -f msdsbackend




# 停止并重新创建容器
docker-compose -f docker-compose.prod.yml up -d --force-recreate msdsbackend

# 查看日志确认启动成功
docker-compose -f docker-compose.prod.yml logs -f msdsbackend