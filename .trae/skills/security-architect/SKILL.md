---
name: "security-architect"
description: "Designs secure system architectures, implements defense-in-depth strategies, resolves security vulnerabilities. Invoke when designing authentication/authorization, conducting security assessments, or implementing security features for the MSDS project."
---

# Security Architect

## Overview

This skill provides enterprise-grade security architecture for the MSDS laboratory management system, focusing on data protection, access control, and compliance with laboratory safety regulations.

## When to Invoke

- Designing authentication and authorization systems
- Implementing JWT security best practices
- Conducting security vulnerability assessments
- Configuring CORS and CSRF protection
- Setting up data encryption (at rest and in transit)
- Reviewing password policies and user authentication
- Implementing audit logging for sensitive operations
- Configuring API rate limiting and DDoS protection

## Technical Context

### Security Stack
- **Authentication**: JWT (JSON Web Tokens)
- **Authorization**: Spring Security 6.x with RBAC
- **Password Encoding**: BCrypt
- **HTTPS**: SSL/TLS 1.2+
- **Session Management**: Redis-backed sessions

### Security Requirements for MSDS
1. **Data Classification**: Chemical safety data is sensitive
2. **Access Control**: Role-based access to chemical information
3. **Audit Trail**: Track who accessed what chemical data
4. **Compliance**: Laboratory safety regulations compliance

## Authentication Architecture

### JWT Implementation
```java
@Component
public class TokenService {
    // Token expiration: 30 minutes
    private static final long EXPIRATION = 30 * 60 * 1000;
    
    // Refresh token expiration: 7 days
    private static final long REFRESH_EXPIRATION = 7 * 24 * 60 * 60 * 1000;
    
    public String createToken(LoginUser loginUser) {
        // Implementation details
    }
}
```

### Security Configuration
```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) {
        http
            .csrf().disable()
            .sessionManagement()
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            .and()
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/login", "/captchaImage").permitAll()
                .requestMatchers("/api/**").authenticated()
                .anyRequest().authenticated()
            )
            .addFilterBefore(jwtAuthenticationTokenFilter(), 
                UsernamePasswordAuthenticationFilter.class);
        
        return http.build();
    }
}
```

## Authorization Model

### RBAC (Role-Based Access Control)

**Default Roles in RuoYi:**
- `admin` - System administrator (full access)
- `common` - Regular user (limited access)

**Custom Roles for MSDS:**
- `msds_manager` - Manage MSDS documents
- `lab_supervisor` - Access all chemical data
- `lab_technician` - View and update usage records
- `safety_officer` - Access safety-related reports

### Permission Annotations
```java
@RestController
@RequestMapping("/api/msds/main")
public class MsdsMainController {
    
    @PreAuthorize("@ss.hasPermi('msds:main:add')")
    @PostMapping
    public AjaxResult add(@RequestBody MsdsMain msds) {
        // Add MSDS
    }
    
    @PreAuthorize("@ss.hasPermi('msds:main:edit')")
    @PutMapping
    public AjaxResult edit(@RequestBody MsdsMain msds) {
        // Edit MSDS
    }
    
    @PreAuthorize("@ss.hasPermi('msds:main:delete')")
    @DeleteMapping("/{id}")
    public AjaxResult remove(@PathVariable Long id) {
        // Delete MSDS
    }
}
```

## Data Security

### Encryption at Rest
```java
@Component
public class DataEncryptionService {
    
    @Value("${encryption.key}")
    private String encryptionKey;
    
    public String encrypt(String data) {
        // AES encryption for sensitive fields
    }
    
    public String decrypt(String encryptedData) {
        // AES decryption
    }
}
```

### Sensitive Fields in MSDS
- Chemical composition details
- Supplier information
- Storage location details
- Usage records with user associations

### Encryption Strategy
1. **Application-level encryption** for highly sensitive fields
2. **Database-level encryption** (TDE) for entire database
3. **File encryption** for uploaded documents

## API Security

### Rate Limiting
```java
@Component
public class RateLimitingFilter extends OncePerRequestFilter {
    
    private final Map<String, RateLimiter> limiters = new ConcurrentHashMap<>();
    
    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) {
        String clientId = getClientId(request);
        RateLimiter rateLimiter = limiters.computeIfAbsent(clientId,
            k -> RateLimiter.create(10.0)); // 10 requests per second
        
        if (rateLimiter.tryAcquire()) {
            filterChain.doFilter(request, response);
        } else {
            response.setStatus(429); // Too Many Requests
        }
    }
}
```

### Input Validation
```java
public class MsdsMain {
    
    @NotBlank(message = "Product name cannot be empty")
    @Size(max = 200, message = "Product name too long")
    private String productName;
    
    @Pattern(regexp = "^\\d{1,7}-\\d{2}-\\d$", message = "Invalid CAS number format")
    private String casNumber;
    
    @SafeHtml // Prevent XSS
    private String description;
}
```

## Audit Logging

### Security Events to Log
1. User login/logout
2. Failed authentication attempts
3. Permission violations
4. Data modifications (create/update/delete)
5. Bulk operations
6. Administrative actions

### Audit Implementation
```java
@Aspect
@Component
public class AuditLogAspect {
    
    @Around("@annotation(auditLog)")
    public Object around(ProceedingJoinPoint point, AuditLog auditLog) {
        // Log before execution
        logSecurityEvent("ACTION_START", auditLog.value(), getCurrentUser());
        
        try {
            Object result = point.proceed();
            // Log successful execution
            logSecurityEvent("ACTION_SUCCESS", auditLog.value(), getCurrentUser());
            return result;
        } catch (Exception e) {
            // Log failure
            logSecurityEvent("ACTION_FAILURE", auditLog.value(), getCurrentUser());
            throw e;
        }
    }
}
```

## Security Checklist

### Development Phase
- [ ] Input validation on all endpoints
- [ ] Output encoding to prevent XSS
- [ ] Parameterized queries (prevent SQL injection)
- [ ] CSRF protection for state-changing operations
- [ ] Secure session management
- [ ] Proper error handling (no sensitive info leakage)

### Deployment Phase
- [ ] HTTPS enabled with valid SSL certificate
- [ ] Security headers configured (HSTS, CSP, X-Frame-Options)
- [ ] Database credentials secured (environment variables)
- [ ] File upload restrictions (type, size)
- [ ] API rate limiting configured
- [ ] Security monitoring and alerting

### Operational Phase
- [ ] Regular security updates
- [ ] Log monitoring and analysis
- [ ] Periodic vulnerability scans
- [ ] Access review and cleanup
- [ ] Backup and recovery testing
- [ ] Incident response plan

## Compliance Considerations

### Laboratory Safety Regulations
1. **Chemical inventory tracking** - Know what chemicals are where
2. **Access control** - Only authorized personnel access SDS
3. **Audit trails** - Track chemical usage and access
4. **Data retention** - Retain safety data as required by law
5. **Emergency access** - Safety officers can access all data in emergencies

### Data Privacy
- Minimize collection of personal data
- Secure handling of user credentials
- Clear data retention policies
- User consent for data processing
