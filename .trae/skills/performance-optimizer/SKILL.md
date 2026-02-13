---
name: "performance-optimizer"
description: "Analyzes system performance bottlenecks, optimizes application response times, tunes database queries, improves memory usage. Invoke when system is slow, optimizing for scale, or enhancing user experience in the MSDS project."
---

# Performance Optimizer

## Overview

This skill specializes in optimizing the performance of the MSDS laboratory management system, covering frontend (React), backend (Spring Boot), and database (MySQL) layers.

## When to Invoke

- API response times exceed 500ms
- Frontend page load times exceed 3 seconds
- Database queries running slowly (> 1 second)
- Memory usage issues (OOM errors)
- High CPU utilization
- Need to optimize for increased user load
- Implementing caching strategies
- Optimizing file uploads/downloads

## Performance Targets

| Component | Target Metric | Acceptable | Critical |
|-----------|--------------|------------|----------|
| API Response | < 200ms | < 500ms | > 1000ms |
| Page Load | < 2s | < 3s | > 5s |
| DB Query | < 100ms | < 500ms | > 1000ms |
| Concurrent Users | 500+ | 1000+ | 2000+ |

## Frontend Optimization (React)

### Bundle Optimization
```javascript
// config/config.ts
export default {
  // Enable code splitting
  codeSplitting: {
    jsStrategy: 'granularChunks',
  },
  
  // Enable tree shaking
  treeShaking: true,
  
  // Compress assets
  compress: true,
};
```

### Lazy Loading
```typescript
// Route-based code splitting
const MsdsDetail = React.lazy(() => import('./pages/Msds/Detail'));
const Analytics = React.lazy(() => import('./pages/Analytics'));

// Component-based lazy loading
const HeavyChart = React.lazy(() => import('./components/HeavyChart'));
```

### State Management Optimization
```typescript
// Use memo for expensive computations
const memoizedData = useMemo(() => {
  return processLargeDataset(rawData);
}, [rawData]);

// Use callback for stable function references
const handleSearch = useCallback((query: string) => {
  performSearch(query);
}, []);

// Prevent unnecessary re-renders
const MemoizedComponent = React.memo(MyComponent);
```

### Image Optimization
```typescript
// Use appropriate image formats
import { Image } from 'antd';

<Image
  src={msds.imageUrl}
  loading="lazy"
  placeholder={<Placeholder />}
  preview={false}
/>
```

## Backend Optimization (Spring Boot)

### JVM Tuning
```bash
# Dockerfile
ENV JAVA_OPTS="-Xms512m -Xmx2g \
  -XX:+UseG1GC \
  -XX:MaxGCPauseMillis=200 \
  -XX:+UseStringDeduplication \
  -XX:+OptimizeStringConcat"
```

### Async Processing
```java
@Service
public class MsdsImportService {
    
    @Async("taskExecutor")
    public CompletableFuture<Void> importLargeDataset(MultipartFile file) {
        // Process file asynchronously
        return CompletableFuture.completedFuture(null);
    }
}

@Configuration
public class AsyncConfig {
    
    @Bean("taskExecutor")
    public Executor taskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(5);
        executor.setMaxPoolSize(10);
        executor.setQueueCapacity(100);
        executor.setThreadNamePrefix("msds-async-");
        executor.initialize();
        return executor;
    }
}
```

### Connection Pool Optimization
```yaml
spring:
  datasource:
    druid:
      initial-size: 10
      min-idle: 10
      max-active: 100
      max-wait: 60000
      time-between-eviction-runs-millis: 60000
      min-evictable-idle-time-millis: 300000
      validation-query: SELECT 1
      test-while-idle: true
      test-on-borrow: false
      test-on-return: false
      pool-prepared-statements: true
      max-pool-prepared-statement-per-connection-size: 20
```

## Database Optimization

### Indexing Strategy
```sql
-- Primary query patterns for MSDS
CREATE INDEX idx_msds_cas ON msds_main(cas_number);
CREATE INDEX idx_msds_name ON msds_main(product_name);
CREATE INDEX idx_msds_status ON msds_main(status, create_time);

-- Composite index for search
CREATE INDEX idx_msds_search ON msds_main(product_name, cas_number, status);

-- Foreign key indexes
CREATE INDEX idx_msds_component_main_id ON msds_component(main_id);
```

### Query Optimization
```java
// Bad: N+1 problem
List<MsdsMain> msdsList = msdsMainMapper.selectList();
for (MsdsMain msds : msdsList) {
    List<MsdsComponent> components = 
        msdsComponentMapper.selectByMainId(msds.getId());
    msds.setComponents(components);
}

// Good: Join query
@Select("SELECT m.*, c.* FROM msds_main m " +
        "LEFT JOIN msds_component c ON m.id = c.main_id " +
        "WHERE m.status = #{status}")
@Results({
    @Result(property = "id", column = "id"),
    @Result(property = "components", column = "id",
            many = @Many(select = "selectComponentsByMainId"))
})
List<MsdsMain> selectWithComponents(@Param("status") Integer status);
```

### Pagination Optimization
```java
// Use PageHelper for MyBatis
PageHelper.startPage(pageNum, pageSize);
List<MsdsMain> list = msdsMainMapper.selectList(params);
PageInfo<MsdsMain> pageInfo = new PageInfo<>(list);

// For large offsets, use cursor-based pagination
@Select("SELECT * FROM msds_main " +
        "WHERE id > #{lastId} " +
        "ORDER BY id " +
        "LIMIT #{pageSize}")
List<MsdsMain> selectByCursor(@Param("lastId") Long lastId, 
                               @Param("pageSize") Integer pageSize);
```

## Caching Strategy

### Redis Caching
```java
@Configuration
public class CacheConfig {
    
    @Bean
    public CacheManager cacheManager(RedisConnectionFactory factory) {
        RedisCacheConfiguration config = RedisCacheConfiguration.defaultCacheConfig()
            .entryTtl(Duration.ofMinutes(30))
            .serializeKeysWith(RedisSerializationContext.SerializationPair
                .fromSerializer(new StringRedisSerializer()))
            .serializeValuesWith(RedisSerializationContext.SerializationPair
                .fromSerializer(new GenericJackson2JsonRedisSerializer()));
        
        return RedisCacheManager.builder(factory)
            .cacheDefaults(config)
            .build();
    }
}

// Usage
@Cacheable(value = "msds", key = "#id")
public MsdsMain getById(Long id) {
    return msdsMainMapper.selectById(id);
}

@CacheEvict(value = "msds", key = "#msds.id")
public int update(MsdsMain msds) {
    return msdsMainMapper.update(msds);
}
```

### Cache Warming
```java
@Component
public class CacheWarmer implements CommandLineRunner {
    
    @Autowired
    private MsdsMainService msdsService;
    
    @Override
    public void run(String... args) {
        // Pre-load frequently accessed data
        List<MsdsMain> hotData = msdsService.selectHotList();
        for (MsdsMain msds : hotData) {
            msdsService.getById(msds.getId());
        }
    }
}
```

## Performance Monitoring

### Application Metrics
```yaml
# application.yml
management:
  endpoints:
    web:
      exposure:
        include: health,metrics,prometheus
  metrics:
    enable:
      jvm: true
      process: true
      system: true
```

### Custom Metrics
```java
@Component
public class PerformanceMetrics {
    
    private final MeterRegistry registry;
    
    public void recordApiLatency(String endpoint, long latencyMs) {
        registry.timer("api.latency", "endpoint", endpoint)
                .record(latencyMs, TimeUnit.MILLISECONDS);
    }
    
    public void recordQueryTime(String queryName, long timeMs) {
        registry.timer("db.query.time", "query", queryName)
                .record(timeMs, TimeUnit.MILLISECONDS);
    }
}
```

## Load Testing

### Using JMeter
```bash
# Test plan configuration
- Thread Group: 100 users
- Ramp-up: 10 seconds
- Loop Count: 10
- HTTP Request: /api/msds/main/list
```

### Using k6
```javascript
// load-test.js
import http from 'k6/http';
import { check } from 'k6';

export let options = {
  stages: [
    { duration: '2m', target: 100 },
    { duration: '5m', target: 100 },
    { duration: '2m', target: 200 },
    { duration: '5m', target: 200 },
    { duration: '2m', target: 0 },
  ],
};

export default function() {
  let response = http.get('http://localhost:18080/api/msds/main/list');
  check(response, {
    'status is 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
  });
}
```

## Performance Checklist

### Code Review Checklist
- [ ] No N+1 query problems
- [ ] Proper use of indexes
- [ ] Efficient data structures
- [ ] Minimized object creation
- [ ] Proper resource cleanup
- [ ] Async processing for heavy operations
- [ ] Caching for frequently accessed data

### Deployment Checklist
- [ ] JVM tuned for workload
- [ ] Database connection pool sized correctly
- [ ] Redis cache configured
- [ ] CDN for static assets
- [ ] Gzip compression enabled
- [ ] Monitoring and alerting in place

### Monitoring Checklist
- [ ] API response times tracked
- [ ] Database query performance monitored
- [ ] Memory usage alerts configured
- [ ] CPU utilization tracked
- [ ] Error rates monitored
- [ ] User experience metrics (Apdex)
