# Maven构建JDK版本错误处理

## 错误时间
2025年1月27日

## 错误描述
在执行 `mvn clean install` 命令时，Maven构建失败，错误信息显示：
```
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-compiler-plugin:3.13.0:compile (default-compile) on project ruoyi-common: Fatal error compiling: 无效的目标发行版: 17
```

## 错误原因
1. 项目配置要求JDK 17，但系统环境中可能：
   - 未安装JDK 17
   - 安装了JDK 17但未正确配置JAVA_HOME
   - 当前使用的JDK版本低于17

## 解决方案
1. 检查并安装JDK 17
   ```powershell
   # 检查当前Java版本
   java -version
   
   # 如果版本不是17，需要：
   # 1. 下载并安装JDK 17
   # 2. 设置JAVA_HOME环境变量指向JDK 17安装目录
   # 3. 将%JAVA_HOME%\bin添加到PATH环境变量
   ```

2. 验证JDK配置
   ```powershell
   # 验证JAVA_HOME设置
   echo %JAVA_HOME%
   
   # 验证Java版本
   java -version
   javac -version
   ```

3. 如果需要在同一系统中管理多个JDK版本，建议：
   - 使用SDKMAN（Linux/Mac）或Chocolatey（Windows）等版本管理工具
   - 配置Maven toolchains.xml

## 预防措施
1. 在项目文档中明确说明JDK版本要求
2. 使用Maven Enforcer Plugin强制检查JDK版本
3. 在CI/CD流程中添加JDK版本检查

## 相关配置参考
1. pom.xml中的Java版本配置：
   ```xml
   <properties>
       <java.version>17</java.version>
       <maven.compiler.source>17</maven.compiler.source>
       <maven.compiler.target>17</maven.compiler.target>
   </properties>
   ```

2. Maven Enforcer Plugin配置：
   ```xml
   <plugin>
       <groupId>org.apache.maven.plugins</groupId>
       <artifactId>maven-enforcer-plugin</artifactId>
       <version>3.0.0</version>
       <executions>
           <execution>
               <id>enforce-java</id>
               <goals>
                   <goal>enforce</goal>
               </goals>
               <configuration>
                   <rules>
                       <requireJavaVersion>
                           <version>17</version>
                       </requireJavaVersion>
                   </rules>
               </configuration>
           </execution>
       </executions>
   </plugin>
   ```

## 状态
✅ 已记录解决方案