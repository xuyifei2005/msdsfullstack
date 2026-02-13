---
name: "testing-validation-expert"
description: "Generates comprehensive test cases, simulates abnormal scenarios, validates functional compliance, reduces testing gaps. Invoke when creating test plans, writing unit tests, or ensuring code coverage meets 70% requirement in the MSDS project."
---

# Testing & Validation Expert

## Overview

This skill ensures comprehensive testing coverage for the MSDS laboratory management system, meeting the project's 70% code coverage requirement and ensuring system reliability.

## When to Invoke

- Writing unit tests for new features
- Creating integration test plans
- Generating test cases for edge cases
- Validating compliance with requirements
- Conducting regression testing
- Performance and load testing
- Security testing
- Preparing for code review

## Testing Strategy

### Test Pyramid for MSDS
```
       /\
      /  \     E2E Tests (10%)
     /----\
    /      \   Integration Tests (30%)
   /--------\
  /          \ Unit Tests (60%)
 /____________\
```

### Coverage Requirements
- **Unit Test Coverage**: ≥ 70% (JaCoCo)
- **Integration Test Coverage**: ≥ 50%
- **Critical Path Coverage**: 100%
- **API Endpoint Coverage**: 100%

## Unit Testing (JUnit 5)

### Backend Testing (Spring Boot)

#### Controller Tests
```java
@SpringBootTest
@AutoConfigureMockMvc
public class MsdsMainControllerTest {
    
    @Autowired
    private MockMvc mockMvc;
    
    @MockBean
    private MsdsMainService msdsService;
    
    @Test
    @WithMockUser(username = "admin", roles = {"ADMIN"})
    void testGetMsdsList() throws Exception {
        // Arrange
        List<MsdsMain> mockList = Arrays.asList(
            createMockMsds(1L, "Chemical A"),
            createMockMsds(2L, "Chemical B")
        );
        when(msdsService.selectList(any())).thenReturn(mockList);
        
        // Act & Assert
        mockMvc.perform(get("/api/msds/main/list")
                .param("pageNum", "1")
                .param("pageSize", "10"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.code").value(200))
            .andExpect(jsonPath("$.data.rows").isArray());
    }
    
    @Test
    @WithMockUser(username = "admin", roles = {"ADMIN"})
    void testCreateMsds() throws Exception {
        MsdsMain msds = new MsdsMain();
        msds.setProductName("Test Chemical");
        msds.setCasNumber("123-45-6");
        
        mockMvc.perform(post("/api/msds/main")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(msds)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.code").value(200));
    }
}
```

#### Service Layer Tests
```java
@ExtendWith(MockitoExtension.class)
public class MsdsMainServiceTest {
    
    @Mock
    private MsdsMainMapper msdsMapper;
    
    @InjectMocks
    private MsdsMainServiceImpl msdsService;
    
    @Test
    void testSelectById() {
        // Arrange
        Long id = 1L;
        MsdsMain expected = new MsdsMain();
        expected.setId(id);
        expected.setProductName("Test");
        when(msdsMapper.selectById(id)).thenReturn(expected);
        
        // Act
        MsdsMain result = msdsService.selectById(id);
        
        // Assert
        assertNotNull(result);
        assertEquals("Test", result.getProductName());
        verify(msdsMapper).selectById(id);
    }
    
    @Test
    void testInsertWithInvalidData() {
        // Arrange
        MsdsMain msds = new MsdsMain(); // Missing required fields
        
        // Act & Assert
        assertThrows(IllegalArgumentException.class, () -> {
            msdsService.insert(msds);
        });
    }
}
```

#### Repository Tests
```java
@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
public class MsdsMainRepositoryTest {
    
    @Autowired
    private TestEntityManager entityManager;
    
    @Autowired
    private MsdsMainRepository repository;
    
    @Test
    void testFindByCasNumber() {
        // Arrange
        MsdsMain msds = new MsdsMain();
        msds.setCasNumber("123-45-6");
        msds.setProductName("Test");
        entityManager.persist(msds);
        
        // Act
        Optional<MsdsMain> result = repository.findByCasNumber("123-45-6");
        
        // Assert
        assertTrue(result.isPresent());
        assertEquals("Test", result.get().getProductName());
    }
}
```

### Frontend Testing (React + Jest)

#### Component Tests
```typescript
import { render, screen, fireEvent } from '@testing-library/react';
import { MsdsList } from './MsdsList';

// Mock API calls
jest.mock('@/services/msds', () => ({
  getMsdsList: jest.fn(),
}));

describe('MsdsList Component', () => {
  it('renders loading state', () => {
    render(<MsdsList />);
    expect(screen.getByText('加载中...')).toBeInTheDocument();
  });
  
  it('renders MSDS list correctly', async () => {
    const mockData = [
      { id: 1, productName: 'Chemical A', casNumber: '123-45-6' },
      { id: 2, productName: 'Chemical B', casNumber: '789-01-2' },
    ];
    
    require('@/services/msds').getMsdsList.mockResolvedValue({
      data: { rows: mockData, total: 2 }
    });
    
    render(<MsdsList />);
    
    expect(await screen.findByText('Chemical A')).toBeInTheDocument();
    expect(screen.getByText('Chemical B')).toBeInTheDocument();
  });
  
  it('handles search functionality', async () => {
    render(<MsdsList />);
    
    const searchInput = screen.getByPlaceholderText('请输入化学品名称');
    fireEvent.change(searchInput, { target: { value: 'Test' } });
    fireEvent.click(screen.getByText('搜索'));
    
    expect(require('@/services/msds').getMsdsList).toHaveBeenCalledWith(
      expect.objectContaining({ productName: 'Test' })
    );
  });
});
```

#### Hook Tests
```typescript
import { renderHook, act } from '@testing-library/react-hooks';
import { useMsdsSearch } from './useMsdsSearch';

describe('useMsdsSearch Hook', () => {
  it('should initialize with empty search', () => {
    const { result } = renderHook(() => useMsdsSearch());
    
    expect(result.current.searchParams).toEqual({});
    expect(result.current.loading).toBe(false);
  });
  
  it('should update search params', () => {
    const { result } = renderHook(() => useMsdsSearch());
    
    act(() => {
      result.current.setSearchParams({ casNumber: '123-45-6' });
    });
    
    expect(result.current.searchParams.casNumber).toBe('123-45-6');
  });
});
```

## Integration Testing

### API Integration Tests
```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class MsdsApiIntegrationTest {
    
    @LocalServerPort
    private int port;
    
    @Autowired
    private TestRestTemplate restTemplate;
    
    @Autowired
    private MsdsMainRepository repository;
    
    @BeforeEach
    void setUp() {
        repository.deleteAll();
    }
    
    @Test
    void testFullMsdsLifecycle() {
        // Create
        MsdsMain msds = new MsdsMain();
        msds.setProductName("Integration Test");
        msds.setCasNumber("999-99-9");
        
        ResponseEntity<AjaxResult> createResponse = restTemplate.postForEntity(
            "/api/msds/main", msds, AjaxResult.class);
        assertEquals(HttpStatus.OK, createResponse.getStatusCode());
        
        // Read
        ResponseEntity<AjaxResult> getResponse = restTemplate.getForEntity(
            "/api/msds/main/1", AjaxResult.class);
        assertEquals(HttpStatus.OK, getResponse.getStatusCode());
        
        // Update
        msds.setProductName("Updated Name");
        restTemplate.put("/api/msds/main", msds);
        
        // Delete
        restTemplate.delete("/api/msds/main/1");
        
        // Verify deletion
        ResponseEntity<AjaxResult> verifyResponse = restTemplate.getForEntity(
            "/api/msds/main/1", AjaxResult.class);
        assertNull(verifyResponse.getBody().getData());
    }
}
```

### Database Integration Tests
```java
@Testcontainers
public class DatabaseIntegrationTest {
    
    @Container
    static MySQLContainer<?> mysql = new MySQLContainer<>("mysql:8.0.42")
        .withDatabaseName("msds_test")
        .withUsername("test")
        .withPassword("test");
    
    @DynamicPropertySource
    static void configureProperties(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", mysql::getJdbcUrl);
        registry.add("spring.datasource.username", mysql::getUsername);
        registry.add("spring.datasource.password", mysql::getPassword);
    }
    
    @Test
    void testDatabaseOperations() {
        // Test actual database operations
    }
}
```

## Edge Case Testing

### Boundary Value Analysis
```java
@Test
void testCasNumberBoundaries() {
    // Valid CAS numbers
    assertTrue(validator.isValidCasNumber("0-00-0"));
    assertTrue(validator.isValidCasNumber("9999999-99-5"));
    
    // Invalid CAS numbers
    assertFalse(validator.isValidCasNumber(""));
    assertFalse(validator.isValidCasNumber("123-45-6-7"));
    assertFalse(validator.isValidCasNumber("invalid"));
    assertFalse(validator.isValidCasNumber(null));
}

@Test
void testPaginationBoundaries() {
    // Test with page size 0
    assertThrows(IllegalArgumentException.class, () -> {
        service.selectList(new PageQuery(1, 0));
    });
    
    // Test with very large page size
    PageInfo<MsdsMain> result = service.selectList(new PageQuery(1, 10000));
    assertNotNull(result);
}
```

### Error Handling Tests
```java
@Test
void testDatabaseConnectionFailure() {
    when(dataSource.getConnection()).thenThrow(new SQLException("Connection failed"));
    
    assertThrows(DataAccessException.class, () -> {
        service.selectById(1L);
    });
}

@Test
void testConcurrentModification() throws InterruptedException {
    CountDownLatch latch = new CountDownLatch(2);
    AtomicInteger successCount = new AtomicInteger(0);
    
    Runnable task = () -> {
        try {
            service.update(msds);
            successCount.incrementAndGet();
        } finally {
            latch.countDown();
        }
    };
    
    new Thread(task).start();
    new Thread(task).start();
    
    latch.await();
    assertTrue(successCount.get() >= 1);
}
```

## Performance Testing

### Load Tests
```java
@Test
void testConcurrentUsers() throws InterruptedException {
    int concurrentUsers = 100;
    ExecutorService executor = Executors.newFixedThreadPool(concurrentUsers);
    CountDownLatch latch = new CountDownLatch(concurrentUsers);
    
    long startTime = System.currentTimeMillis();
    
    for (int i = 0; i < concurrentUsers; i++) {
        executor.submit(() -> {
            try {
                mockMvc.perform(get("/api/msds/main/list"))
                    .andExpect(status().isOk());
            } catch (Exception e) {
                fail("Request failed: " + e.getMessage());
            } finally {
                latch.countDown();
            }
        });
    }
    
    latch.await();
    long duration = System.currentTimeMillis() - startTime;
    
    assertTrue(duration < 5000, "Requests took too long: " + duration + "ms");
}
```

## Test Data Management

### Test Data Builders
```java
public class MsdsMainBuilder {
    private MsdsMain msds = new MsdsMain();
    
    public static MsdsMainBuilder aMsds() {
        return new MsdsMainBuilder();
    }
    
    public MsdsMainBuilder withId(Long id) {
        msds.setId(id);
        return this;
    }
    
    public MsdsMainBuilder withName(String name) {
        msds.setProductName(name);
        return this;
    }
    
    public MsdsMainBuilder withCasNumber(String cas) {
        msds.setCasNumber(cas);
        return this;
    }
    
    public MsdsMain build() {
        return msds;
    }
}

// Usage
MsdsMain msds = MsdsMainBuilder.aMsds()
    .withId(1L)
    .withName("Test Chemical")
    .withCasNumber("123-45-6")
    .build();
```

## Compliance Testing

### Security Tests
```java
@Test
void testSqlInjectionPrevention() {
    String maliciousInput = "'; DROP TABLE msds_main; --";
    
    // Should not execute malicious SQL
    List<MsdsMain> result = service.searchByName(maliciousInput);
    assertNotNull(result);
    
    // Verify table still exists
    assertTrue(repository.existsById(1L));
}

@Test
void testXssPrevention() {
    MsdsMain msds = new MsdsMain();
    msds.setProductName("<script>alert('xss')</script>");
    
    service.insert(msds);
    
    MsdsMain saved = service.selectById(msds.getId());
    assertFalse(saved.getProductName().contains("<script>"));
}
```

## Test Automation

### CI/CD Integration
```yaml
# .github/workflows/test.yml
name: Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Set up JDK 17
        uses: actions/setup-java@v2
        with:
          java-version: '17'
          distribution: 'temurin'
      
      - name: Run tests
        run: mvn clean test
      
      - name: Generate coverage report
        run: mvn jacoco:report
      
      - name: Upload coverage
        uses: codecov/codecov-action@v2
        with:
          file: target/site/jacoco/jacoco.xml
```

## Testing Checklist

### Before Commit
- [ ] All unit tests pass
- [ ] Code coverage ≥ 70%
- [ ] No test failures in CI
- [ ] Integration tests pass
- [ ] Edge cases covered

### Before Release
- [ ] Full regression test
- [ ] Performance tests pass
- [ ] Security tests pass
- [ ] Load testing completed
- [ ] User acceptance testing
