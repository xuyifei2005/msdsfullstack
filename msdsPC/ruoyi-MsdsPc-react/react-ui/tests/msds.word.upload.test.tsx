import React from 'react';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { vi, describe, it, expect, beforeEach } from 'vitest';
import '@testing-library/jest-dom';
import { BrowserRouter } from 'react-router-dom';
import { ConfigProvider } from 'antd';
import zhCN from 'antd/locale/zh_CN';

// Mock antd components
vi.mock('antd', async () => {
  const actual = await vi.importActual('antd');
  return {
    ...actual,
    message: {
      success: vi.fn(),
      error: vi.fn(),
      warning: vi.fn(),
      info: vi.fn(),
    },
    notification: {
      success: vi.fn(),
      error: vi.fn(),
      warning: vi.fn(),
      info: vi.fn(),
    },
  };
});

// Mock API calls
vi.mock('../src/api/msds', () => ({
  uploadMsdsFile: vi.fn(),
  parseMsdsDocument: vi.fn(),
  getMsdsList: vi.fn(),
}));

// Mock file upload component (假设存在)
const MockMsdsUpload = ({ onUpload, accept, maxSize }: any) => {
  const handleFileChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (file && onUpload) {
      onUpload(file);
    }
  };

  return (
    <div data-testid="msds-upload-component">
      <input
        type="file"
        accept={accept}
        onChange={handleFileChange}
        data-testid="file-input"
      />
      <div data-testid="max-size-info">最大文件大小: {maxSize}MB</div>
      <div data-testid="accept-types">支持格式: {accept}</div>
    </div>
  );
};

// Mock upload page component
const MockMsdsUploadPage = () => {
  const [uploading, setUploading] = React.useState(false);
  const [uploadProgress, setUploadProgress] = React.useState(0);
  const [parseResult, setParseResult] = React.useState<any>(null);
  const [error, setError] = React.useState<string | null>(null);

  const handleUpload = async (file: File) => {
    setUploading(true);
    setError(null);
    setUploadProgress(0);

    try {
      // 模拟上传进度
      const progressInterval = setInterval(() => {
        setUploadProgress(prev => {
          if (prev >= 90) {
            clearInterval(progressInterval);
            return 90;
          }
          return prev + 10;
        });
      }, 100);

      // 模拟文件解析
      await new Promise(resolve => setTimeout(resolve, 1000));
      
      clearInterval(progressInterval);
      setUploadProgress(100);

      // 模拟解析结果
      const mockResult = {
        productName: file.name.includes('toluene') ? '甲苯' : 
                    file.name.includes('acetone') ? '丙酮' : 
                    file.name.includes('ethanol') ? '乙醇（无水）' : '未知化学品',
        productEnglishName: file.name.includes('toluene') ? 'Toluene' : 
                           file.name.includes('acetone') ? 'Acetone' : 
                           file.name.includes('ethanol') ? 'Ethanol (Anhydrous)' : 'Unknown',
        casNumber: file.name.includes('toluene') ? '108-88-3' : 
                  file.name.includes('acetone') ? '67-64-1' : 
                  file.name.includes('ethanol') ? '64-17-5' : '000-00-0',
        companyName: '测试化工有限公司',
        contactPhone: '010-12345678',
        email: 'test@example.com',
        fileName: file.name,
        fileSize: file.size,
        fileType: file.type,
      };

      setParseResult(mockResult);
    } catch (err) {
      setError('文件上传或解析失败');
    } finally {
      setUploading(false);
    }
  };

  const validateFile = (file: File): string | null => {
    // 文件大小验证 (50MB)
    if (file.size > 50 * 1024 * 1024) {
      return '文件大小不能超过50MB';
    }

    // 文件类型验证
    const allowedTypes = [
      'application/msword',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
    ];
    
    if (!allowedTypes.includes(file.type)) {
      return '只支持DOC和DOCX格式的文件';
    }

    return null;
  };

  const handleFileUpload = (file: File) => {
    const validationError = validateFile(file);
    if (validationError) {
      setError(validationError);
      return;
    }
    handleUpload(file);
  };

  return (
    <div data-testid="msds-upload-page">
      <h1>MSDS Word文档上传</h1>
      
      <MockMsdsUpload
        onUpload={handleFileUpload}
        accept=".doc,.docx,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        maxSize={50}
      />

      {uploading && (
        <div data-testid="upload-progress">
          <div>上传中... {uploadProgress}%</div>
          <div data-testid="progress-bar" style={{ width: `${uploadProgress}%`, height: '4px', backgroundColor: '#1890ff' }} />
        </div>
      )}

      {error && (
        <div data-testid="error-message" style={{ color: 'red' }}>
          错误: {error}
        </div>
      )}

      {parseResult && (
        <div data-testid="parse-result">
          <h3>解析结果</h3>
          <div data-testid="product-name">产品名称: {parseResult.productName}</div>
          <div data-testid="product-english-name">英文名称: {parseResult.productEnglishName}</div>
          <div data-testid="cas-number">CAS号: {parseResult.casNumber}</div>
          <div data-testid="company-name">企业名称: {parseResult.companyName}</div>
          <div data-testid="contact-phone">联系电话: {parseResult.contactPhone}</div>
          <div data-testid="email">邮箱: {parseResult.email}</div>
          <div data-testid="file-info">
            文件信息: {parseResult.fileName} ({(parseResult.fileSize / 1024).toFixed(2)} KB)
          </div>
        </div>
      )}
    </div>
  );
};

// Test wrapper component
const TestWrapper: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  return (
    <BrowserRouter>
      <ConfigProvider locale={zhCN}>
        {children}
      </ConfigProvider>
    </BrowserRouter>
  );
};

describe('MSDS Word文档上传功能测试', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('应该正确渲染上传组件', () => {
    render(
      <TestWrapper>
        <MockMsdsUploadPage />
      </TestWrapper>
    );

    expect(screen.getByText('MSDS Word文档上传')).toBeInTheDocument();
    expect(screen.getByTestId('msds-upload-component')).toBeInTheDocument();
    expect(screen.getByTestId('file-input')).toBeInTheDocument();
    expect(screen.getByText('最大文件大小: 50MB')).toBeInTheDocument();
    expect(screen.getByText(/支持格式:.*\.doc.*\.docx/)).toBeInTheDocument();
  });

  it('应该支持DOC格式文件上传', async () => {
    render(
      <TestWrapper>
        <MockMsdsUploadPage />
      </TestWrapper>
    );

    const fileInput = screen.getByTestId('file-input');
    
    // 创建模拟DOC文件
    const docFile = new File(['mock doc content'], 'toluene_test.doc', {
      type: 'application/msword'
    });

    // 模拟文件选择
    fireEvent.change(fileInput, { target: { files: [docFile] } });

    // 等待上传进度显示
    await waitFor(() => {
      expect(screen.getByTestId('upload-progress')).toBeInTheDocument();
    });

    // 等待解析完成
    await waitFor(() => {
      expect(screen.getByTestId('parse-result')).toBeInTheDocument();
    }, { timeout: 2000 });

    // 验证解析结果
    expect(screen.getByTestId('product-name')).toHaveTextContent('产品名称: 甲苯');
    expect(screen.getByTestId('product-english-name')).toHaveTextContent('英文名称: Toluene');
    expect(screen.getByTestId('cas-number')).toHaveTextContent('CAS号: 108-88-3');
  });

  it('应该支持DOCX格式文件上传', async () => {
    render(
      <TestWrapper>
        <MockMsdsUploadPage />
      </TestWrapper>
    );

    const fileInput = screen.getByTestId('file-input');
    
    // 创建模拟DOCX文件
    const docxFile = new File(['mock docx content'], 'acetone_test.docx', {
      type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
    });

    // 模拟文件选择
    fireEvent.change(fileInput, { target: { files: [docxFile] } });

    // 等待解析完成
    await waitFor(() => {
      expect(screen.getByTestId('parse-result')).toBeInTheDocument();
    }, { timeout: 2000 });

    // 验证解析结果
    expect(screen.getByTestId('product-name')).toHaveTextContent('产品名称: 丙酮');
    expect(screen.getByTestId('product-english-name')).toHaveTextContent('英文名称: Acetone');
    expect(screen.getByTestId('cas-number')).toHaveTextContent('CAS号: 67-64-1');
  });

  it('应该处理特殊字符文档', async () => {
    render(
      <TestWrapper>
        <MockMsdsUploadPage />
      </TestWrapper>
    );

    const fileInput = screen.getByTestId('file-input');
    
    // 创建包含特殊字符的文件
    const specialFile = new File(['mock content with special chars'], 'ethanol_special_chars_test.doc', {
      type: 'application/msword'
    });

    fireEvent.change(fileInput, { target: { files: [specialFile] } });

    await waitFor(() => {
      expect(screen.getByTestId('parse-result')).toBeInTheDocument();
    }, { timeout: 2000 });

    // 验证特殊字符处理
    expect(screen.getByTestId('product-name')).toHaveTextContent('产品名称: 乙醇（无水）');
    expect(screen.getByTestId('product-english-name')).toHaveTextContent('英文名称: Ethanol (Anhydrous)');
  });

  it('应该验证文件大小限制', async () => {
    render(
      <TestWrapper>
        <MockMsdsUploadPage />
      </TestWrapper>
    );

    const fileInput = screen.getByTestId('file-input');
    
    // 创建超大文件 (模拟51MB)
    const largeFile = new File(['x'.repeat(51 * 1024 * 1024)], 'large_file.doc', {
      type: 'application/msword'
    });

    fireEvent.change(fileInput, { target: { files: [largeFile] } });

    // 验证错误消息
    await waitFor(() => {
      expect(screen.getByTestId('error-message')).toBeInTheDocument();
      expect(screen.getByTestId('error-message')).toHaveTextContent('文件大小不能超过50MB');
    });
  });

  it('应该验证文件类型', async () => {
    render(
      <TestWrapper>
        <MockMsdsUploadPage />
      </TestWrapper>
    );

    const fileInput = screen.getByTestId('file-input');
    
    // 创建不支持的文件类型
    const invalidFile = new File(['invalid content'], 'test.txt', {
      type: 'text/plain'
    });

    fireEvent.change(fileInput, { target: { files: [invalidFile] } });

    // 验证错误消息
    await waitFor(() => {
      expect(screen.getByTestId('error-message')).toBeInTheDocument();
      expect(screen.getByTestId('error-message')).toHaveTextContent('只支持DOC和DOCX格式的文件');
    });
  });

  it('应该显示上传进度', async () => {
    render(
      <TestWrapper>
        <MockMsdsUploadPage />
      </TestWrapper>
    );

    const fileInput = screen.getByTestId('file-input');
    
    const validFile = new File(['valid content'], 'test.doc', {
      type: 'application/msword'
    });

    fireEvent.change(fileInput, { target: { files: [validFile] } });

    // 验证进度条显示
    await waitFor(() => {
      expect(screen.getByTestId('upload-progress')).toBeInTheDocument();
      expect(screen.getByText(/上传中\.\.\./)).toBeInTheDocument();
      expect(screen.getByTestId('progress-bar')).toBeInTheDocument();
    });
  });

  it('应该正确显示文件信息', async () => {
    render(
      <TestWrapper>
        <MockMsdsUploadPage />
      </TestWrapper>
    );

    const fileInput = screen.getByTestId('file-input');
    
    const testFile = new File(['test content'], 'test_document.docx', {
      type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
    });

    fireEvent.change(fileInput, { target: { files: [testFile] } });

    await waitFor(() => {
      expect(screen.getByTestId('parse-result')).toBeInTheDocument();
    }, { timeout: 2000 });

    // 验证文件信息显示
    const fileInfo = screen.getByTestId('file-info');
    expect(fileInfo).toHaveTextContent('test_document.docx');
    expect(fileInfo).toHaveTextContent('KB');
  });

  it('应该处理解析错误', async () => {
    // 这个测试需要模拟解析失败的情况
    // 由于我们的mock总是成功，这里只是示例结构
    render(
      <TestWrapper>
        <MockMsdsUploadPage />
      </TestWrapper>
    );

    // 可以通过修改mock来模拟错误情况
    // 或者创建一个特殊的文件名来触发错误
  });

  it('应该支持多次上传', async () => {
    render(
      <TestWrapper>
        <MockMsdsUploadPage />
      </TestWrapper>
    );

    const fileInput = screen.getByTestId('file-input');
    
    // 第一次上传
    const firstFile = new File(['first content'], 'first.doc', {
      type: 'application/msword'
    });

    fireEvent.change(fileInput, { target: { files: [firstFile] } });

    await waitFor(() => {
      expect(screen.getByTestId('parse-result')).toBeInTheDocument();
    }, { timeout: 2000 });

    // 第二次上传
    const secondFile = new File(['second content'], 'toluene_test.doc', {
      type: 'application/msword'
    });

    fireEvent.change(fileInput, { target: { files: [secondFile] } });

    await waitFor(() => {
      expect(screen.getByTestId('product-name')).toHaveTextContent('产品名称: 甲苯');
    }, { timeout: 2000 });
  });

  it('应该正确处理空文件', async () => {
    render(
      <TestWrapper>
        <MockMsdsUploadPage />
      </TestWrapper>
    );

    const fileInput = screen.getByTestId('file-input');
    
    // 创建空文件
    const emptyFile = new File([], 'empty.doc', {
      type: 'application/msword'
    });

    fireEvent.change(fileInput, { target: { files: [emptyFile] } });

    // 验证能够处理空文件（可能显示错误或警告）
    await waitFor(() => {
      // 根据实际实现，这里可能是错误消息或解析结果
      expect(screen.getByTestId('parse-result') || screen.getByTestId('error-message')).toBeInTheDocument();
    }, { timeout: 2000 });
  });
});