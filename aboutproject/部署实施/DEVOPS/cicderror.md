Run appleboy/ssh-action@master
Run echo "$GITHUB_ACTION_PATH" >> $GITHUB_PATH
Run entrypoint.sh
Binary drone-ssh-1.8.2-linux-amd64 already exists, skipping download
======= CLI Version Information =======
Drone SSH version 1.8.2
=======================================
🚀 启动测试服务...
▶️  启动基础服务（MySQL/Redis）...
time="2026-01-20T10:03:27+08:00" level=warning msg="The \"JAVA_OPTS\" variable is not set. Defaulting to a blank string."
time="2026-01-20T10:03:27+08:00" level=warning msg="/opt/msds/msdsdocker/docker-compose.prod.yml: `version` is obsolete"
 Container msdsmysql  Created
 Container msdsredis  Created
 Container msdsredis  Starting
 Container msdsmysql  Starting
 Container msdsredis  Started
 Container msdsmysql  Started
⏳ 等待服务启动...
🗄️  等待 MySQL 就绪...
Warning: n: [Warning] Using a password on the command line interface can be insecure.
mysqld is alive
✅ MySQL 已就绪
Warning: n: [Warning] Using a password on the command line interface can be insecure.
mysqld is alive
🗄️  校验并初始化 msds_dev 数据库（如需要）...
Warning: arning] Using a password on the command line interface can be insecure.
Warning: arning] Using a password on the command line interface can be insecure.
Warning: arning] Using a password on the command line interface can be insecure.
Warning: arning] Using a password on the command line interface can be insecure.
msds_dev 表数量: 1, sys_menu: 0
📥 发现 00-msds_complete_database.sql，开始导入...
Warning: arning] Using a password on the command line interface can be insecure.
ERROR 1064 (42000) at line 641: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'references TEXT COMMENT '参考文献',
    form_fill_time DATE COMMENT '填表æ' at line 4
✅ 导入完成
▶️  启动后端服务...
time="2026-01-20T10:03:40+08:00" level=warning msg="The \"JAVA_OPTS\" variable is not set. Defaulting to a blank string."
time="2026-01-20T10:03:40+08:00" level=warning msg="/opt/msds/msdsdocker/docker-compose.prod.yml: `version` is obsolete"
 Container msdsredis  Running
 Container msdsmysql  Running
 Container msdsdbinit  Creating
 Container msdsdbinit  Created
 Container msdsbackend  Recreate
 Container msdsbackend  Recreated
 Container msdsdbinit  Starting
 Container msdsdbinit  Started
 Container msdsredis  Waiting
 Container msdsdbinit  Waiting
 Container msdsmysql  Waiting
 Container msdsredis  Healthy
 Container msdsdbinit  Exited
 Container msdsmysql  Healthy
 Container msdsbackend  Starting
 Container msdsbackend  Started
🏥 等待后端健康...
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
OCI runtime exec failed: exec failed: cannot exec in a stopped container: unknown
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 1 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 2 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 1 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 1 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
curl: (7) Failed to connect to localhost port 8080 after 0 ms: Couldn't connect to server
❌ 后端未就绪，输出后端日志
[12.422s][info   ][gc,task     ] GC(13) Using 1 workers of 1 for marking
[12.487s][info   ][gc,marking  ] GC(13) Concurrent Mark From Roots 64.403ms
[12.487s][info   ][gc,marking  ] GC(13) Concurrent Preclean
[12.487s][info   ][gc,marking  ] GC(13) Concurrent Preclean 0.131ms
[12.487s][info   ][gc,start    ] GC(13) Pause Remark
[12.494s][info   ][gc          ] GC(13) Pause Remark 59M->59M(512M) 7.036ms
[12.494s][info   ][gc,cpu      ] GC(13) User=0.01s Sys=0.00s Real=0.00s
[12.494s][info   ][gc,marking  ] GC(13) Concurrent Mark 71.747ms
[12.494s][info   ][gc,marking  ] GC(13) Concurrent Rebuild Remembered Sets
[12.518s][info   ][gc,marking  ] GC(13) Concurrent Rebuild Remembered Sets 23.907ms
[12.519s][info   ][gc,start    ] GC(13) Pause Cleanup
[12.519s][info   ][gc          ] GC(13) Pause Cleanup 59M->59M(512M) 0.167ms
[12.519s][info   ][gc,cpu      ] GC(13) User=0.00s Sys=0.00s Real=0.00s
[12.519s][info   ][gc,marking  ] GC(13) Concurrent Cleanup for Next Mark
[12.521s][info   ][gc,marking  ] GC(13) Concurrent Cleanup for Next Mark 2.010ms
[12.521s][info   ][gc          ] GC(13) Concurrent Mark Cycle 121.248ms
10:09:24.982 [main] ERROR o.s.b.SpringApplication - [reportFailure,859] - Application run failed
org.springframework.beans.factory.UnsatisfiedDependencyException: Error creating bean with name 'captchaController': Unsatisfied dependency expressed through field 'configService': Error creating bean with name 'sysConfigServiceImpl': Invocation of init method failed
	at org.springframework.beans.factory.annotation.AutowiredAnnotationBeanPostProcessor$AutowiredFieldElement.resolveFieldValue(AutowiredAnnotationBeanPostProcessor.java:787)
	at org.springframework.beans.factory.annotation.AutowiredAnnotationBeanPostProcessor$AutowiredFieldElement.inject(AutowiredAnnotationBeanPostProcessor.java:767)
	at org.springframework.beans.factory.annotation.InjectionMetadata.inject(InjectionMetadata.java:145)
	at org.springframework.beans.factory.annotation.AutowiredAnnotationBeanPostProcessor.postProcessProperties(AutowiredAnnotationBeanPostProcessor.java:508)
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.populateBean(AbstractAutowireCapableBeanFactory.java:1421)
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.doCreateBean(AbstractAutowireCapableBeanFactory.java:599)
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.createBean(AbstractAutowireCapableBeanFactory.java:522)
	at org.springframework.beans.factory.support.AbstractBeanFactory.lambda$doGetBean$0(AbstractBeanFactory.java:337)
	at org.springframework.beans.factory.support.DefaultSingletonBeanRegistry.getSingleton(DefaultSingletonBeanRegistry.java:234)
	at org.springframework.beans.factory.support.AbstractBeanFactory.doGetBean(AbstractBeanFactory.java:335)
	at org.springframework.beans.factory.support.AbstractBeanFactory.getBean(AbstractBeanFactory.java:200)
	at org.springframework.beans.factory.support.DefaultListableBeanFactory.preInstantiateSingletons(DefaultListableBeanFactory.java:975)
	at org.springframework.context.support.AbstractApplicationContext.finishBeanFactoryInitialization(AbstractApplicationContext.java:962)
	at org.springframework.context.support.AbstractApplicationContext.refresh(AbstractApplicationContext.java:624)
	at org.springframework.boot.web.servlet.context.ServletWebServerApplicationContext.refresh(ServletWebServerApplicationContext.java:146)
	at org.springframework.boot.SpringApplication.refresh(SpringApplication.java:754)
	at org.springframework.boot.SpringApplication.refreshContext(SpringApplication.java:456)
	at org.springframework.boot.SpringApplication.run(SpringApplication.java:335)
	at org.springframework.boot.SpringApplication.run(SpringApplication.java:1363)
	at org.springframework.boot.SpringApplication.run(SpringApplication.java:1352)
	at com.ruoyi.RuoYiApplication.main(RuoYiApplication.java:18)
	at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(Unknown Source)
	at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(Unknown Source)
	at java.base/java.lang.reflect.Method.invoke(Unknown Source)
	at org.springframework.boot.loader.launch.Launcher.launch(Launcher.java:91)
	at org.springframework.boot.loader.launch.Launcher.launch(Launcher.java:53)
	at org.springframework.boot.loader.launch.JarLauncher.main(JarLauncher.java:58)
Caused by: org.springframework.beans.factory.BeanCreationException: Error creating bean with name 'sysConfigServiceImpl': Invocation of init method failed
	at org.springframework.beans.factory.annotation.InitDestroyAnnotationBeanPostProcessor.postProcessBeforeInitialization(InitDestroyAnnotationBeanPostProcessor.java:222)
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.applyBeanPostProcessorsBeforeInitialization(AbstractAutowireCapableBeanFactory.java:422)
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.initializeBean(AbstractAutowireCapableBeanFactory.java:1780)
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.doCreateBean(AbstractAutowireCapableBeanFactory.java:600)
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.createBean(AbstractAutowireCapableBeanFactory.java:522)
	at org.springframework.beans.factory.support.AbstractBeanFactory.lambda$doGetBean$0(AbstractBeanFactory.java:337)
	at org.springframework.beans.factory.support.DefaultSingletonBeanRegistry.getSingleton(DefaultSingletonBeanRegistry.java:234)
	at org.springframework.beans.factory.support.AbstractBeanFactory.doGetBean(AbstractBeanFactory.java:335)
	at org.springframework.beans.factory.support.AbstractBeanFactory.getBean(AbstractBeanFactory.java:200)
	at org.springframework.beans.factory.config.DependencyDescriptor.resolveCandidate(DependencyDescriptor.java:254)
	at org.springframework.beans.factory.support.DefaultListableBeanFactory.doResolveDependency(DefaultListableBeanFactory.java:1443)
	at org.springframework.beans.factory.support.DefaultListableBeanFactory.resolveDependency(DefaultListableBeanFactory.java:1353)
	at org.springframework.beans.factory.annotation.AutowiredAnnotationBeanPostProcessor$AutowiredFieldElement.resolveFieldValue(AutowiredAnnotationBeanPostProcessor.java:784)
	... 27 common frames omitted
Caused by: org.springframework.jdbc.BadSqlGrammarException: 
### Error querying database.  Cause: java.sql.SQLSyntaxErrorException: Table 'msds_dev.sys_config' doesn't exist
### The error may exist in URL [jar:nested:/app/app.jar/!BOOT-INF/lib/ruoyi-system-3.8.8.jar!/mapper/system/SysConfigMapper.xml]
### The error may involve com.ruoyi.system.mapper.SysConfigMapper.selectConfigList-Inline
### The error occurred while setting parameters
### SQL: select config_id, config_name, config_key, config_value, config_type, create_by, create_time, update_by, update_time, remark    from sys_config
### Cause: java.sql.SQLSyntaxErrorException: Table 'msds_dev.sys_config' doesn't exist
; bad SQL grammar []
	at org.springframework.jdbc.support.SQLErrorCodeSQLExceptionTranslator.doTranslate(SQLErrorCodeSQLExceptionTranslator.java:246)
	at org.springframework.jdbc.support.AbstractFallbackSQLExceptionTranslator.translate(AbstractFallbackSQLExceptionTranslator.java:107)
	at org.mybatis.spring.MyBatisExceptionTranslator.translateExceptionIfPossible(MyBatisExceptionTranslator.java:92)
	at org.mybatis.spring.SqlSessionTemplate$SqlSessionInterceptor.invoke(SqlSessionTemplate.java:439)
	at jdk.proxy2/jdk.proxy2.$Proxy109.selectList(Unknown Source)
	at org.mybatis.spring.SqlSessionTemplate.selectList(SqlSessionTemplate.java:224)
	at org.apache.ibatis.binding.MapperMethod.executeForMany(MapperMethod.java:147)
	at org.apache.ibatis.binding.MapperMethod.execute(MapperMethod.java:80)
	at org.apache.ibatis.binding.MapperProxy$PlainMethodInvoker.invoke(MapperProxy.java:141)
	at org.apache.ibatis.binding.MapperProxy.invoke(MapperProxy.java:86)
	at jdk.proxy2/jdk.proxy2.$Proxy110.selectConfigList(Unknown Source)
	at com.ruoyi.system.service.impl.SysConfigServiceImpl.loadingConfigCache(SysConfigServiceImpl.java:177)
	at com.ruoyi.system.service.impl.SysConfigServiceImpl.init(SysConfigServiceImpl.java:40)
	at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(Unknown Source)
	at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(Unknown Source)
	at java.base/java.lang.reflect.Method.invoke(Unknown Source)
	at org.springframework.beans.factory.annotation.InitDestroyAnnotationBeanPostProcessor$LifecycleMethod.invoke(InitDestroyAnnotationBeanPostProcessor.java:457)
	at org.springframework.beans.factory.annotation.InitDestroyAnnotationBeanPostProcessor$LifecycleMetadata.invokeInitMethods(InitDestroyAnnotationBeanPostProcessor.java:401)
	at org.springframework.beans.factory.annotation.InitDestroyAnnotationBeanPostProcessor.postProcessBeforeInitialization(InitDestroyAnnotationBeanPostProcessor.java:219)
	... 39 common frames omitted
Caused by: java.sql.SQLSyntaxErrorException: Table 'msds_dev.sys_config' doesn't exist
	at com.mysql.cj.jdbc.exceptions.SQLError.createSQLException(SQLError.java:121)
	at com.mysql.cj.jdbc.exceptions.SQLExceptionsMapping.translateException(SQLExceptionsMapping.java:122)
	at com.mysql.cj.jdbc.ClientPreparedStatement.executeInternal(ClientPreparedStatement.java:912)
	at com.mysql.cj.jdbc.ClientPreparedStatement.execute(ClientPreparedStatement.java:354)
	at com.alibaba.druid.pool.DruidPooledPreparedStatement.execute(DruidPooledPreparedStatement.java:483)
	at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(Unknown Source)
	at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(Unknown Source)
	at java.base/java.lang.reflect.Method.invoke(Unknown Source)
	at org.apache.ibatis.logging.jdbc.PreparedStatementLogger.invoke(PreparedStatementLogger.java:58)
	at jdk.proxy3/jdk.proxy3.$Proxy112.execute(Unknown Source)
	at org.apache.ibatis.executor.statement.PreparedStatementHandler.query(PreparedStatementHandler.java:65)
	at org.apache.ibatis.executor.statement.RoutingStatementHandler.query(RoutingStatementHandler.java:80)
	at org.apache.ibatis.executor.SimpleExecutor.doQuery(SimpleExecutor.java:65)
	at org.apache.ibatis.executor.BaseExecutor.queryFromDatabase(BaseExecutor.java:336)
	at org.apache.ibatis.executor.BaseExecutor.query(BaseExecutor.java:158)
	at org.apache.ibatis.executor.CachingExecutor.query(CachingExecutor.java:110)
	at org.apache.ibatis.executor.CachingExecutor.query(CachingExecutor.java:90)
	at org.apache.ibatis.session.defaults.DefaultSqlSession.selectList(DefaultSqlSession.java:154)
	at org.apache.ibatis.session.defaults.DefaultSqlSession.selectList(DefaultSqlSession.java:147)
	at org.apache.ibatis.session.defaults.DefaultSqlSession.selectList(DefaultSqlSession.java:142)
	at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(Unknown Source)
	at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(Unknown Source)
	at java.base/java.lang.reflect.Method.invoke(Unknown Source)
	at org.mybatis.spring.SqlSessionTemplate$SqlSessionInterceptor.invoke(SqlSessionTemplate.java:425)
	... 55 common frames omitted
[13.354s][info   ][gc,heap,exit] Heap
[13.354s][info   ][gc,heap,exit]  garbage-first heap   total 524288K, used 63505K [0x0000000080000000, 0x0000000100000000)
[13.354s][info   ][gc,heap,exit]   region size 1024K, 42 young (43008K), 12 survivors (12288K)
[13.354s][info   ][gc,heap,exit]  Metaspace       used 61359K, committed 61824K, reserved 1114112K
[13.354s][info   ][gc,heap,exit]   class space    used 7771K, committed 8000K, reserved 1048576K
Warning: [0.006s][warning][gc] -XX:+PrintGCDetails is deprecated. Will use -Xlog:gc* instead.
[0.020s][info   ][gc] Using G1
[0.025s][info   ][gc,init] Version: 17.0.17+10 (release)
[0.025s][info   ][gc,init] CPUs: 2 total, 2 available
[0.025s][info   ][gc,init] Memory: 3563M
[0.025s][info   ][gc,init] Large Page Support: Disabled
[0.025s][info   ][gc,init] NUMA Support: Disabled
[0.025s][info   ][gc,init] Compressed Oops: Enabled (32-bit)
[0.025s][info   ][gc,init] Heap Region Size: 1M
[0.025s][info   ][gc,init] Heap Min Capacity: 512M
[0.025s][info   ][gc,init] Heap Initial Capacity: 512M
[0.025s][info   ][gc,init] Heap Max Capacity: 2G
[0.025s][info   ][gc,init] Pre-touch: Disabled
[0.025s][info   ][gc,init] Parallel Workers: 2
[0.025s][info   ][gc,init] Concurrent Workers: 1
[0.025s][info   ][gc,init] Concurrent Refinement Workers: 2
[0.025s][info   ][gc,init] Periodic GC: Disabled
[0.087s][info   ][gc,metaspace] CDS archive(s) mapped at: [0x00007f72c3000000-0x00007f72c3a62000-0x00007f72c3a62000), size 10887168, SharedBaseAddress: 0x00007f72c3000000, ArchiveRelocationMode: 1.
[0.087s][info   ][gc,metaspace] Compressed class space mapped at: 0x00007f72c4000000-0x00007f7304000000, reserved size: 1073741824
[0.087s][info   ][gc,metaspace] Narrow klass base: 0x00007f72c3000000, Narrow klass shift: 0, Narrow klass range: 0x100000000
[0.722s][info   ][gc,start    ] GC(0) Pause Young (Normal) (G1 Evacuation Pause)
[0.722s][info   ][gc,task     ] GC(0) Using 2 workers of 2 for evacuation
[0.728s][info   ][gc,phases   ] GC(0)   Pre Evacuate Collection Set: 0.2ms
[0.728s][info   ][gc,phases   ] GC(0)   Merge Heap Roots: 0.1ms
[0.728s][info   ][gc,phases   ] GC(0)   Evacuate Collection Set: 4.9ms
[0.728s][info   ][gc,phases   ] GC(0)   Post Evacuate Collection Set: 0.4ms
[0.728s][info   ][gc,phases   ] GC(0)   Other: 0.3ms
[0.728s][info   ][gc,heap     ] GC(0) Eden regions: 25->0(21)
[0.728s][info   ][gc,heap     ] GC(0) Survivor regions: 0->4(4)
[0.728s][info   ][gc,heap     ] GC(0) Old regions: 0->0
[0.728s][info   ][gc,heap     ] GC(0) Archive regions: 2->2
[0.728s][info   ][gc,heap     ] GC(0) Humongous regions: 0->0
[0.728s][info   ][gc,metaspace] GC(0) Metaspace: 1759K(1984K)->1759K(1984K) NonClass: 1570K(1664K)->1570K(1664K) Class: 189K(320K)->189K(320K)
[0.728s][info   ][gc          ] GC(0) Pause Young (Normal) (G1 Evacuation Pause) 25M->4M(514M) 6.039ms
[0.728s][info   ][gc,cpu      ] GC(0) User=0.00s Sys=0.00s Real=0.01s
Standard Commons Logging discovery in action with spring-jcl: please remove commons-logging.jar from classpath in order to avoid potential conflicts
[1.276s][info   ][gc,start    ] GC(1) Pause Young (Normal) (G1 Evacuation Pause)
[1.276s][info   ][gc,task     ] GC(1) Using 2 workers of 2 for evacuation
[1.283s][info   ][gc,phases   ] GC(1)   Pre Evacuate Collection Set: 0.2ms
[1.283s][info   ][gc,phases   ] GC(1)   Merge Heap Roots: 0.1ms
[1.283s][info   ][gc,phases   ] GC(1)   Evacuate Collection Set: 6.6ms
[1.283s][info   ][gc,phases   ] GC(1)   Post Evacuate Collection Set: 0.4ms
[1.283s][info   ][gc,phases   ] GC(1)   Other: 0.1ms
[1.283s][info   ][gc,heap     ] GC(1) Eden regions: 21->0(29)
[1.283s][info   ][gc,heap     ] GC(1) Survivor regions: 4->2(4)
[1.283s][info   ][gc,heap     ] GC(1) Old regions: 0->4
[1.283s][info   ][gc,heap     ] GC(1) Archive regions: 2->2
[1.283s][info   ][gc,heap     ] GC(1) Humongous regions: 0->0
[1.283s][info   ][gc,metaspace] GC(1) Metaspace: 4235K(4480K)->4235K(4480K) NonClass: 3745K(3904K)->3745K(3904K) Class: 490K(576K)->490K(576K)
[1.283s][info   ][gc          ] GC(1) Pause Young (Normal) (G1 Evacuation Pause) 25M->5M(514M) 7.451ms
[1.283s][info   ][gc,cpu      ] GC(1) User=0.02s Sys=0.00s Real=0.01s
[1.651s][info   ][gc,start    ] GC(2) Pause Young (Normal) (G1 Evacuation Pause)
[1.651s][info   ][gc,task     ] GC(2) Using 2 workers of 2 for evacuation
[1.657s][info   ][gc,phases   ] GC(2)   Pre Evacuate Collection Set: 0.3ms
[1.657s][info   ][gc,phases   ] GC(2)   Merge Heap Roots: 0.1ms
[1.657s][info   ][gc,phases   ] GC(2)   Evacuate Collection Set: 5.0ms
[1.657s][info   ][gc,phases   ] GC(2)   Post Evacuate Collection Set: 0.5ms
[1.657s][info   ][gc,phases   ] GC(2)   Other: 0.1ms
[1.657s][info   ][gc,heap     ] GC(2) Eden regions: 29->0(115)
[1.657s][info   ][gc,heap     ] GC(2) Survivor regions: 2->3(4)
[1.657s][info   ][gc,heap     ] GC(2) Old regions: 4->4
[1.657s][info   ][gc,heap     ] GC(2) Archive regions: 2->2
[1.657s][info   ][gc,heap     ] GC(2) Humongous regions: 0->0
[1.657s][info   ][gc,metaspace] GC(2) Metaspace: 6263K(6528K)->6263K(6528K) NonClass: 5453K(5568K)->5453K(5568K) Class: 810K(960K)->810K(960K)
[1.657s][info   ][gc          ] GC(2) Pause Young (Normal) (G1 Evacuation Pause) 34M->7M(514M) 6.077ms
[1.657s][info   ][gc,cpu      ] GC(2) User=0.01s Sys=0.00s Real=0.01s
Application Version: 3.8.8
Spring Boot Version: 3.3.0
////////////////////////////////////////////////////////////////////
//                          _ooOoo_                               //
//                         o8888888o                              //
//                         88" . "88                              //
//                         (| ^_^ |)                              //
//                         O\  =  /O                              //
//                      ____/`---'\____                           //
//                    .'  \\|     |//  `.                         //
//                   /  \\|||  :  |||//  \                        //
//                  /  _||||| -:- |||||-  \                       //
//                  |   | \\\  -  /// |   |                       //
//                  | \_|  ''\---/''  |   |                       //
//                  \  .-\__  `-`  ___/-. /                       //
//                ___`. .'  /--.--\  `. . ___                     //
//              ."" '<  `.___\_<|>_/___.'  >'"".                  //
//            | | :  `- \`.;`\ _ /`;.`/ - ` : | |                 //
//            \  \ `-.   \_ __\ /__ _/   .-` /  /                 //
//      ========`-.____`-.___\_____/___.-`____.-'========         //
//                           `=---='                              //
//      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        //
//             佛祖保佑       永不宕机      永无BUG               //
////////////////////////////////////////////////////////////////////
10:09:29.574 [main] INFO  c.r.RuoYiApplication - [logStarting,50] - Starting RuoYiApplication using Java 17.0.17 with PID 7 (/app/app.jar started by *** in /app)
10:09:29.577 [main] DEBUG c.r.RuoYiApplication - [logStarting,51] - Running with Spring Boot v3.3.0, Spring v6.1.8
10:09:29.578 [main] INFO  c.r.RuoYiApplication - [logStartupProfileInfo,660] - The following 2 profiles are active: "prod", "druid-prod"
10:09:29.662 [background-preinit] INFO  o.h.v.i.util.Version - [<clinit>,21] - HV000001: Hibernate Validator 8.0.1.Final
[3.097s][info   ][gc,start    ] GC(3) Pause Young (Normal) (G1 Evacuation Pause)
[3.097s][info   ][gc,task     ] GC(3) Using 2 workers of 2 for evacuation
[3.108s][info   ][gc,phases   ] GC(3)   Pre Evacuate Collection Set: 0.2ms
[3.108s][info   ][gc,phases   ] GC(3)   Merge Heap Roots: 0.1ms
[3.108s][info   ][gc,phases   ] GC(3)   Evacuate Collection Set: 9.3ms
[3.108s][info   ][gc,phases   ] GC(3)   Post Evacuate Collection Set: 0.8ms
[3.108s][info   ][gc,phases   ] GC(3)   Other: 0.2ms
[3.108s][info   ][gc,heap     ] GC(3) Eden regions: 115->0(143)
[3.108s][info   ][gc,heap     ] GC(3) Survivor regions: 3->6(15)
[3.108s][info   ][gc,heap     ] GC(3) Old regions: 4->4
[3.108s][info   ][gc,heap     ] GC(3) Archive regions: 2->2
[3.108s][info   ][gc,heap     ] GC(3) Humongous regions: 0->0
[3.108s][info   ][gc,metaspace] GC(3) Metaspace: 15522K(15808K)->15522K(15808K) NonClass: 13331K(13504K)->13331K(13504K) Class: 2191K(2304K)->2191K(2304K)
[3.108s][info   ][gc          ] GC(3) Pause Young (Normal) (G1 Evacuation Pause) 122M->9M(514M) 10.580ms
[3.108s][info   ][gc,cpu      ] GC(3) User=0.01s Sys=0.01s Real=0.01s
[3.807s][info   ][gc,start    ] GC(4) Pause Young (Concurrent Start) (Metadata GC Threshold)
[3.807s][info   ][gc,task     ] GC(4) Using 2 workers of 2 for evacuation
[3.828s][info   ][gc,phases   ] GC(4)   Pre Evacuate Collection Set: 0.2ms
[3.828s][info   ][gc,phases   ] GC(4)   Merge Heap Roots: 0.1ms
[3.828s][info   ][gc,phases   ] GC(4)   Evacuate Collection Set: 12.4ms
[3.828s][info   ][gc,phases   ] GC(4)   Post Evacuate Collection Set: 7.7ms
[3.828s][info   ][gc,phases   ] GC(4)   Other: 0.2ms
[3.828s][info   ][gc,heap     ] GC(4) Eden regions: 80->0(124)
[3.828s][info   ][gc,heap     ] GC(4) Survivor regions: 6->9(19)
[3.828s][info   ][gc,heap     ] GC(4) Old regions: 4->4
[3.828s][info   ][gc,heap     ] GC(4) Archive regions: 2->2
[3.828s][info   ][gc,heap     ] GC(4) Humongous regions: 0->0
[3.828s][info   ][gc,metaspace] GC(4) Metaspace: 21261K(21504K)->21261K(21504K) NonClass: 18375K(18496K)->18375K(18496K) Class: 2885K(3008K)->2885K(3008K)
[3.828s][info   ][gc          ] GC(4) Pause Young (Concurrent Start) (Metadata GC Threshold) 89M->12M(514M) 20.726ms
[3.828s][info   ][gc,cpu      ] GC(4) User=0.04s Sys=0.00s Real=0.02s
[3.828s][info   ][gc          ] GC(5) Concurrent Mark Cycle
[3.828s][info   ][gc,marking  ] GC(5) Concurrent Clear Claimed Marks
[3.828s][info   ][gc,marking  ] GC(5) Concurrent Clear Claimed Marks 0.036ms
[3.828s][info   ][gc,marking  ] GC(5) Concurrent Scan Root Regions
[3.845s][info   ][gc,marking  ] GC(5) Concurrent Scan Root Regions 16.667ms
[3.845s][info   ][gc,marking  ] GC(5) Concurrent Mark
[3.845s][info   ][gc,marking  ] GC(5) Concurrent Mark From Roots
[3.845s][info   ][gc,task     ] GC(5) Using 1 workers of 1 for marking
[3.853s][info   ][gc,marking  ] GC(5) Concurrent Mark From Roots 7.787ms
[3.853s][info   ][gc,marking  ] GC(5) Concurrent Preclean
[3.853s][info   ][gc,marking  ] GC(5) Concurrent Preclean 0.057ms
[3.853s][info   ][gc,start    ] GC(5) Pause Remark
[3.859s][info   ][gc          ] GC(5) Pause Remark 13M->13M(512M) 6.569ms
[3.860s][info   ][gc,cpu      ] GC(5) User=0.01s Sys=0.00s Real=0.00s
[3.860s][info   ][gc,marking  ] GC(5) Concurrent Mark 14.599ms
2026/01/20 02:09:33 Process exited with status 1
[3.860s][info   ][gc,marking  ] GC(5) Concurrent Rebuild Remembered Sets
[3.862s][info   ][gc,marking  ] GC(5) Concurrent Rebuild Remembered Sets 2.936ms
[3.863s][info   ][gc,start    ] GC(5) Pause Cleanup
[3.863s][info   ][gc          ] GC(5) Pause Cleanup 13M->13M(512M) 0.114ms
[3.863s][info   ][gc,cpu      ] GC(5) User=0.00s Sys=0.00s Real=0.00s
[3.863s][info   ][gc,marking  ] GC(5) Concurrent Cleanup for Next Mark
[3.866s][info   ][gc,marking  ] GC(5) Concurrent Cleanup for Next Mark 2.792ms
[3.866s][info   ][gc          ] GC(5) Concurrent Mark Cycle 37.510ms
[5.850s][info   ][gc,start    ] GC(6) Pause Young (Prepare Mixed) (G1 Evacuation Pause)
[5.850s][info   ][gc,task     ] GC(6) Using 2 workers of 2 for evacuation
[5.876s][info   ][gc,phases   ] GC(6)   Pre Evacuate Collection Set: 0.5ms
[5.876s][info   ][gc,phases   ] GC(6)   Merge Heap Roots: 0.1ms
[5.876s][info   ][gc,phases   ] GC(6)   Evacuate Collection Set: 23.5ms
[5.876s][info   ][gc,phases   ] GC(6)   Post Evacuate Collection Set: 1.4ms
[5.876s][info   ][gc,phases   ] GC(6)   Other: 0.1ms
[5.876s][info   ][gc,heap     ] GC(6) Eden regions: 142->0(10)
[5.876s][info   ][gc,heap     ] GC(6) Survivor regions: 9->15(19)
[5.876s][info   ][gc,heap     ] GC(6) Old regions: 4->4
[5.876s][info   ][gc,heap     ] GC(6) Archive regions: 2->2
[5.876s][info   ][gc,heap     ] GC(6) Humongous regions: 0->0
[5.876s][info   ][gc,metaspace] GC(6) Metaspace: 30609K(31040K)->30609K(31040K) NonClass: 26635K(26880K)->26635K(26880K) Class: 3973K(4160K)->3973K(4160K)
[5.876s][info   ][gc          ] GC(6) Pause Young (Prepare Mixed) (G1 Evacuation Pause) 154M->19M(512M) 25.657ms
[5.876s][info   ][gc,cpu      ] GC(6) User=0.04s Sys=0.00s Real=0.03s
[5.966s][info   ][gc,start    ] GC(7) Pause Young (Mixed) (G1 Evacuation Pause)
[5.966s][info   ][gc,task     ] GC(7) Using 2 workers of 2 for evacuation
[5.995s][info   ][gc,phases   ] GC(7)   Pre Evacuate Collection Set: 0.1ms
[5.995s][info   ][gc,phases   ] GC(7)   Merge Heap Roots: 0.1ms
[5.995s][info   ][gc,phases   ] GC(7)   Evacuate Collection Set: 27.6ms
[5.995s][info   ][gc,phases   ] GC(7)   Post Evacuate Collection Set: 1.1ms
[5.995s][info   ][gc,phases   ] GC(7)   Other: 0.1ms
[5.995s][info   ][gc,heap     ] GC(7) Eden regions: 10->0(168)
[5.995s][info   ][gc,heap     ] GC(7) Survivor regions: 15->1(4)
[5.995s][info   ][gc,heap     ] GC(7) Old regions: 4->18
[5.995s][info   ][gc,heap     ] GC(7) Archive regions: 2->2
[5.995s][info   ][gc,heap     ] GC(7) Humongous regions: 0->0
[5.995s][info   ][gc,metaspace] GC(7) Metaspace: 31175K(31552K)->31175K(31552K) NonClass: 27127K(27328K)->27127K(27328K) Class: 4048K(4224K)->4048K(4224K)
[5.995s][info   ][gc          ] GC(7) Pause Young (Mixed) (G1 Evacuation Pause) 29M->19M(512M) 29.100ms
[5.995s][info   ][gc,cpu      ] GC(7) User=0.03s Sys=0.01s Real=0.03s
Error: Process completed with exit code 1.
0s
