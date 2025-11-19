# node -v
v18.20.8

# java -version

openjdk version "17.0.15" 2025-04-15
OpenJDK Runtime Environment Temurin-17.0.15+6 (build 17.0.15+6)
OpenJDK 64-Bit Server VM Temurin-17.0.15+6 (build 17.0.15+6, mixed mode, sharing)

### 后台数据库容器：

sh-5.1# mysql -V
mysql  Ver 8.0.42 for Linux on x86_64 (MySQL Community Server - GPL)

#####开始更换编译环境：

你的聚合项目要求 Java 17（根 POM 里 <java.version>17</java.version>），并使用 Spring Boot 3.3.0。Spring Boot 3 最低需要 Java 17，且配合 Surefire/插件时，

Maven 3.8.6+ 更稳妥。


## 后台编译：
mvn clean install





---
## 容器运行：
docker exec  -it msdsbackend bash
docker logs msdsbackend -f



## 手动启动项目[现在项目自动启动]
mvn spring-boot:run





