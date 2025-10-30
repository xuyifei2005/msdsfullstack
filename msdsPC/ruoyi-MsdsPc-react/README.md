# JFKJMSDS后端项目

## 平台简介

项目链接：https://gitee.com/whiteshader/ruoyi-react

微服务分支：https://gitee.com/whiteshader/ruoyi-react/tree/spring-cloud-v3/

## 系统环境：

### 后端编译环境：

JAVA:java version "17.0.15" 2025-04-15 LTS

- java正在使用的后端版本：
  root@60fe8d5ee65d:/app# java -version
  openjdk version "21.0.7" 2025-04-15
  OpenJDK Runtime Environment (build 21.0.7+6-Ubuntu-0ubuntu124.04)
  OpenJDK 64-Bit Server VM (build 21.0.7+6-Ubuntu-0ubuntu124.04, mixed mode, sharing)
- mvn正在使用的maven版本：
  mvn -v：Apache Maven 3.6.3 //C:\apache-maven-3.6.3   .m2

root@60fe8d5ee65d:/app# mvn -v
Apache Maven 3.8.7  ##正在使用这个编译！
Maven home: /usr/share/maven
Java version: 21.0.7, vendor: Ubuntu, runtime: /usr/lib/jvm/java-21-openjdk-amd64
Default locale: en, platform encoding: UTF-8
OS name: "linux", version: "6nod.6.87.2-microsoft-standard-wsl2", arch: "amd64", family: "unix"

mvn spring-boot:run

---

### 前端编译环境：
node -v：v18.18.0
npm -v：9.8.1


### 数据库：
mysql环境：8 ，使用本地phpstudy创建--->这里我要调整到容器内开发！

---

---

若依(Ruoyi-React)是一套全部开源的快速开发平台，毫无保留给个人及企业免费使用。
* 前端采用React 18、Ant Design Pro 6、TypeScript 5。
* 后端采用JDK17, Spring Boot v3、Spring Security、Redis & Jwt。
* 权限认证使用Jwt，支持多终端认证系统。
* 支持加载动态权限菜单，多方式轻松权限控制。
* 高效率开发，使用代码生成器可以一键生成前后端代码。

## 内置功能

1. 用户管理：用户是系统操作者，该功能主要完成系统用户配置。
2. 部门管理：配置系统组织机构（公司、部门、小组），树结构展现支持数据权限。
3. 岗位管理：配置系统用户所属担任职务。
4. 菜单管理：配置系统菜单，操作权限，按钮权限标识等。
5. 角色管理：角色菜单权限分配、设置角色按机构进行数据范围权限划分。
6. 字典管理：对系统中经常使用的一些较为固定的数据进行维护。
7. 参数管理：对系统动态配置常用参数。
8. 通知公告：系统通知公告信息发布维护。
9. 操作日志：系统正常操作日志记录和查询；系统异常信息日志记录和查询。
10. 登录日志：系统登录日志记录查询包含登录异常。
11. 在线用户：当前系统中活跃用户状态监控。
12. 定时任务：在线（添加、修改、删除)任务调度包含执行结果日志。
13. 代码生成：前后端代码的生成（java、html、xml、sql）支持CRUD下载 。
14. 系统接口：根据业务代码自动生成相关的api接口文档。
15. 服务监控：监视当前系统CPU、内存、磁盘、堆栈等相关信息。
16. 在线构建器：拖动表单元素生成相应的HTML代码。
17. 连接池监视：监视当前系统数据库连接池状态，可进行分析SQL找出系统性能瓶颈。

## 在线体验

- admin/admin123
- ry/123456

演示地址：暂时没有

https://gitee.com/whiteshader/ruoyi-cloud-vben/blob/master/ruoyi-react-demo-2023-04-27.gif

---

## 前端开发注意事项

Node：建议v16或以上

安装依赖请支行：npm i

正常启动请运行: npm run dev

Mock测试模式请运行: npm run start

发布打包请运行: **npm run build**

1. 首先，以管理员身份运行 PowerShell 或命令提示符，这样可以避免权限问题
2. 然后，在项目目录下执行以下命令清理并重新安装：

```bash
# 进入前端项目目录
cd D:\tdqqsysfullstack\tdqqBS\tdqqbsruoyireact\ruoyi-react\react-ui

# 清理 npm 缓存
npm cache clean --force

# 删除现有的 node_modules 和 package-lock.json
rm -rf node_modules
rm -rf package-lock.json

# 重新安装依赖
npm install
```

3. 如果还是有问题，可以尝试：

```bash
# 安装指定版本的 umi
npm install @umijs/max@4.4.11 --save-dev

# 然后再安装其他依赖
npm install
```

4. 如果以上步骤还是不行，可以尝试：

```bash
# 使用 cnpm（淘宝镜像）安装
npm install -g cnpm --registry=https://registry.npmmirror.com
cnpm install
```

如果执行完这些步骤后还有具体的错误，请告诉我错误信息，我会继续帮您解决。

另外，确保您的 Node.js 版本符合项目要求：

- README.md 中提到："Node：建议v16或以上"
- 您当前使用的是 Node.js v18.18.0，版本符合要求

如果需要，我可以提供更详细的每个步骤的操作说明。







---

## 后端开发注意：

项目配置要求使用 JDK 17 进行编译（从 README.md 中也可以看到项目要求使用 JDK17）
如果版本低于 17，您需要：
下载并安装 JDK 17，您可以从以下地址下载：
Oracle JDK: https://www.oracle.com/java/technologies/downloads/#java17
OpenJDK: https://adoptium.net/temurin/releases/?version=17

java -version


## 打包方法：

mvn clean package  //////打包命令通常为

mvn spring-boot:repackage      ///////Spring Boot插件打包：





## 相关技术文档

### 后端说明文档

http://doc.ruoyi.vip/ruoyi-cloud/

### TypeScript

https://www.tslang.cn/docs/home.html

### React Js

https://react.docschina.org/docs/getting-started.html

### Ant Design

https://ant.design/components/overview-cn/

### Ant Design Pro

https://pro.ant.design/zh-CN/docs/overview

### Ant Design Chart

https://charts.ant.design/zh

### Umi Js

https://umijs.org/docs/introduce/introduce

## 部署

http://doc.ruoyi.vip/ruoyi-vue/document/hjbs.html#nginx%E9%85%8D%E7%BD%AE

## 演示图

<table>
    <tr>
        <td><img src="https://oscimg.oschina.net/oscnet/up-9996b274886e8134066ccee096fde2089dd.png"/></td>
        <td><img src="https://oscimg.oschina.net/oscnet/up-66afe06885d34482862536e4f00c87c0475.png"/></td>
    </tr>  
    <tr>
        <td><img src="https://oscimg.oschina.net/oscnet/up-f279ee4e419e9ba80a77fd898ebd8c9ac45.png"/></td>
        <td><img src="https://oscimg.oschina.net/oscnet/up-b56c891e29d1dfd0213b000339effd256db.png"/></td>
    </tr>
    <tr>
        <td><img src="https://oscimg.oschina.net/oscnet/up-26d4a0f56967f4c319d6e95cab9652bdbfe.png"/></td>
        <td><img src="https://oscimg.oschina.net/oscnet/up-125aed48a8214551cb2ce5aa5a1403d78e9.png"/></td>
    </tr>
    <tr>
        <td><img src="https://oscimg.oschina.net/oscnet/up-59bc1efe5d8f109e56305aa86192ff56bb0.png"/></td>
        <td><img src="https://oscimg.oschina.net/oscnet/up-6e081044a6f864c96df9a25aaa26516f7fc.png"/></td>
    </tr>
	<tr>
        <td><img src="https://oscimg.oschina.net/oscnet/up-ed2e67f41c8a56e0db1215645a0d9dd1e52.png"/></td>
        <td><img src="https://oscimg.oschina.net/oscnet/up-2788241f7893ac8fbfd2b84813f60451755.png"/></td>
    </tr>
	<tr>
        <td><img src="https://oscimg.oschina.net/oscnet/up-eda1770f6383e0001439b56c3392012213d.png"/></td>
        <td><img src="https://oscimg.oschina.net/oscnet/up-31c487d7419b16bc79de0d6a6a12789f048.png"/></td>
    </tr>
    <tr>
        <td><img src="https://oscimg.oschina.net/oscnet/up-31c487d7419b16bc79de0d6a6a12789f048.png"/></td>
        <td><img src="https://oscimg.oschina.net/oscnet/up-4d8cd86ba198f0263f90a0bd36c47b0317b.png"/></td>
    </tr>
	<tr>
        <td><img src="https://oscimg.oschina.net/oscnet/up-6d0ba703a00f8b02a0540931c9e67fe816c.png"/></td>
        <td><img src="https://oscimg.oschina.net/oscnet/up-376159966aa67e7e2fdd971bf68fb0a3375.png"/></td>
    </tr>
    <tr>
        <td><img src="https://oscimg.oschina.net/oscnet/up-77b186361c754bd9abc6beac7b2dd371858.png"/></td>
        <td><img src="https://oscimg.oschina.net/oscnet/up-800aba850793feb11e52720153a801cc2e5.png"/></td>
    </tr>
    <tr>
        <td><img src="https://oscimg.oschina.net/oscnet/up-8835cf289be21d9ed81974764670d78d120.png"/></td>
        <td><img src="https://oscimg.oschina.net/oscnet/up-31a968948be45abb0a30bd7b69fd9bee501.png"/></td>
    </tr>
    <tr>
        <td><img src="https://oscimg.oschina.net/oscnet/up-ed8b654a35b70d5b14281c7d5f086658e27.png"/></td>
        <td><img src="https://oscimg.oschina.net/oscnet/up-e7f3e329aa2052d32f64a372f25ad9f5df1.png"/></td>
    </tr>
</table>

## 若依(Ruoyi-React)前后端分离交流群

QQ群： [![加入QQ群](https://img.shields.io/badge/201396349-blue.svg)](https://jq.qq.com/?_wv=1027&k=u58VEEQK) 点击按钮入群。

## 感谢捐赠的伙伴,谢谢你们的支持
