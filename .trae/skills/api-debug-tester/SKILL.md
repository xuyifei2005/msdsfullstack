---
name: "api-debug-tester"
description: "Debugs and tests REST APIs, validates request/response formats, troubleshoots authentication issues. Invoke when API returns errors, testing endpoints, or validating Spring Boot API integrations in the MSDS project."
---

# API Debug & Tester

## Overview

This skill specializes in debugging and testing REST APIs for the MSDS laboratory management system, focusing on Spring Boot backend with JWT authentication.

## When to Invoke

- API endpoints return 4xx/5xx errors
- JWT authentication failures (401/403 errors)
- Request/response format mismatches
- CORS issues between frontend and backend
- Performance testing API endpoints
- Validating API documentation (OpenAPI/Swagger)
- Testing file upload/download endpoints

## Technical Context

### Backend Stack
- **Framework**: Spring Boot 3.3.0
- **Security**: Spring Security 6.x + JWT
- **Documentation**: Springdoc OpenAPI 2.5.0
- **Base URL**: `http://localhost:18080` (local) or `http://msdsbackend:8080` (docker)

### Authentication Flow
1. POST `/login` - Get JWT token
2. Include token in header: `Authorization: Bearer <token>`
3. Token expires after configured time (default: 30 minutes)
4. Refresh token mechanism available

### Common API Patterns
- RESTful API design
- Response wrapper: `AjaxResult` (RuoYi standard)
- Pagination: `TableDataInfo`
- Error handling: Global exception handler

## API Testing Tools

### Using cURL
```bash
# Login
curl -X POST http://localhost:18080/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'

# Authenticated request
curl -X GET http://localhost:18080/api/msds/main/list \
  -H "Authorization: Bearer <token>"
```

### Using HTTPie
```bash
# Login
http POST :18080/login username=admin password=admin123

# Get MSDS list
http GET :18080/api/msds/main/list "Authorization:Bearer <token>"
```

## Common Issues & Solutions

### 401 Unauthorized
**Causes:**
- Missing or expired JWT token
- Incorrect token format
- Token not included in header

**Solutions:**
1. Check if token is present in request header
2. Verify token hasn't expired
3. Ensure correct format: `Bearer <token>`
4. Check token refresh logic

### 403 Forbidden
**Causes:**
- User lacks required permissions
- Role-based access control (RBAC) restriction
- Method-level security (@PreAuthorize)

**Solutions:**
1. Verify user has required role
2. Check menu permissions in database
3. Review @PreAuthorize annotations
4. Check Spring Security configuration

### CORS Issues
**Configuration in MSDS:**
```java
@Configuration
public class CorsConfig {
    @Bean
    public CorsFilter corsFilter() {
        CorsConfiguration config = new CorsConfiguration();
        config.setAllowCredentials(true);
        config.addAllowedOriginPattern("*");
        config.addAllowedHeader("*");
        config.addAllowedMethod("*");
        // ...
    }
}
```

### Request/Response Format Issues
**Standard Response Format:**
```json
{
  "code": 200,
  "msg": "操作成功",
  "data": { ... }
}
```

**Pagination Response:**
```json
{
  "code": 200,
  "msg": "查询成功",
  "data": {
    "total": 100,
    "rows": [ ... ]
  }
}
```

## API Endpoints Reference

### MSDS Module
- `GET /api/msds/main/list` - List MSDS records
- `GET /api/msds/main/{id}` - Get MSDS detail
- `POST /api/msds/main` - Create MSDS
- `PUT /api/msds/main` - Update MSDS
- `DELETE /api/msds/main/{id}` - Delete MSDS
- `GET /api/msds/main/search` - Search MSDS

### System Module
- `POST /login` - User login
- `POST /logout` - User logout
- `GET /captchaImage` - Get captcha
- `GET /getInfo` - Get user info
- `GET /getRouters` - Get menu routers

## Testing Best Practices

1. **Always test with valid authentication**
2. **Test edge cases**: empty input, special characters, large payloads
3. **Verify response codes and messages**
4. **Check data persistence** in database
5. **Test concurrent access** when applicable
6. **Validate file uploads** with different formats and sizes

## Performance Testing

### Load Testing with Apache Bench
```bash
# Test login endpoint
ab -n 1000 -c 10 -T "application/json" \
   -p login.json http://localhost:18080/login

# Test authenticated endpoint
ab -n 1000 -c 10 -H "Authorization: Bearer <token>" \
   http://localhost:18080/api/msds/main/list
```

### Key Metrics
- Response time < 500ms (API)
- Throughput > 100 req/sec
- Error rate < 0.1%

## Debugging Tips

1. **Enable debug logging** in `application.yml`:
   ```yaml
   logging:
     level:
       com.ruoyi: debug
       org.springframework.web: debug
   ```

2. **Check application logs**:
   ```bash
   docker logs msdsbackend -f
   ```

3. **Use Spring Boot Actuator** (if enabled):
   - `/actuator/health` - Health check
   - `/actuator/metrics` - Application metrics

4. **Verify database connectivity**:
   - Check connection pool status
   - Verify SQL execution in logs
