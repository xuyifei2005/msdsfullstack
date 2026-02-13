---
name: "database-expert"
description: "Expert in MySQL database design, query optimization, and troubleshooting. Invoke when designing schemas, optimizing slow queries, migrating data, or resolving database issues in the MSDS project."
---

# Database Expert

## Overview

This skill provides expert-level database management for the MSDS laboratory management system, specializing in MySQL 8.0 with MyBatis Plus ORM.

## When to Invoke

- Designing new database tables or schemas
- Optimizing slow SQL queries (response time > 500ms)
- Planning data migrations between environments
- Troubleshooting connection pool issues
- Implementing indexing strategies
- Reviewing database security configurations

## Technical Context

### Database Configuration
- **Type**: MySQL 8.0.42
- **Connection URL**: `jdbc:mysql://msdsmysql:3306/msds_dev`
- **Connection Pool**: Druid 1.2.23
- **ORM**: MyBatis Plus 3.0.3
- **Charset**: utf8mb4

### Key Tables
- `msds_main` - MSDS main information
- `msds_hazard` - Hazard classification
- `msds_first_aid` - First aid measures
- `msds_fire_fighting` - Fire fighting measures
- `msds_component` - Chemical composition
- `sys_user` - System users (RuoYi)
- `sys_role` - User roles
- `sys_menu` - Menu permissions

## Best Practices

### Query Optimization
1. Always use EXPLAIN to analyze query execution plans
2. Add indexes for frequently queried columns
3. Use pagination for large result sets
4. Avoid SELECT *, specify columns explicitly
5. Use JOINs instead of subqueries when possible

### Schema Design
1. Use appropriate data types (VARCHAR with length limits)
2. Define primary keys and foreign keys
3. Add created_time/updated_time timestamps
4. Use soft deletes (is_deleted flag) instead of hard deletes
5. Normalize data to 3NF, denormalize for read-heavy scenarios

### Connection Pool Configuration
```yaml
initial-size: 5
min-idle: 5
max-active: 50
max-wait: 60000
time-between-eviction-runs-millis: 60000
min-evictable-idle-time-millis: 300000
validation-query: SELECT 1 FROM DUAL
test-while-idle: true
test-on-borrow: false
test-on-return: false
```

## Common Operations

### Check Slow Queries
```sql
-- View slow query log
SHOW VARIABLES LIKE 'slow_query%';
SHOW VARIABLES LIKE 'long_query_time';

-- Enable slow query log
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 1;
```

### Analyze Table Performance
```sql
-- Check table status
SHOW TABLE STATUS LIKE 'msds_main';

-- Analyze table
ANALYZE TABLE msds_main;

-- Check indexes
SHOW INDEX FROM msds_main;
```

### Optimize Queries
```sql
-- Add index example
CREATE INDEX idx_cas_number ON msds_main(cas_number);

-- Composite index for common queries
CREATE INDEX idx_name_cas ON msds_main(product_name, cas_number);
```

## Integration with MSDS Project

When working with the MSDS project:
1. Check existing entity classes in `ruoyi-system/src/main/java/com/ruoyi/system/domain/`
2. Review MyBatis mappers in `ruoyi-system/src/main/resources/mapper/system/`
3. Follow RuoYi's naming conventions for tables and columns
4. Use `BaseEntity` for common fields (createTime, updateTime, etc.)

## Security Considerations

1. Never expose database credentials in code
2. Use environment variables for sensitive configuration
3. Implement SQL injection prevention (use parameterized queries)
4. Regular database backups
5. Limit database user privileges (principle of least privilege)
