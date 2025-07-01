import React, { useState } from 'react';
import { Modal, Upload, Button, message, Alert, Typography, Space, Card, Progress, List } from 'antd';
import { InboxOutlined, DownloadOutlined, FileTextOutlined, CheckCircleOutlined, ExclamationCircleOutlined } from '@ant-design/icons';
import { importMsdsDocument, downloadImportTemplate } from '@/services/msds';
import type { UploadFile, UploadProps } from 'antd';

const { Dragger } = Upload;
const { Text } = Typography;

export type ImportModalProps = {
  open: boolean;
  onOpenChange: (visible: boolean) => void;
  onSuccess: () => void;
};

interface DuplicateItem {
  fileName: string;
  chemicalName: string;
  casNumber: string;
}

const ImportModal: React.FC<ImportModalProps> = ({ open, onOpenChange, onSuccess }) => {
  const [uploading, setUploading] = useState(false);
  const [progress, setProgress] = useState(0);
  const [fileList, setFileList] = useState<UploadFile[]>([]);
  const [importResult, setImportResult] = useState<any>(null);
  const [duplicates, setDuplicates] = useState<DuplicateItem[]>([]);
  const [showDuplicateConfirm, setShowDuplicateConfirm] = useState(false);

  // 重置状态
  const resetState = () => {
    setFileList([]);
    setImportResult(null);
    setDuplicates([]);
    setShowDuplicateConfirm(false);
    setProgress(0);
    setUploading(false);
  };

  // 处理模态框关闭
  const handleCancel = () => {
    if (!uploading) {
      resetState();
      onOpenChange(false);
    }
  };

  // 处理文件变化
  const handleChange: UploadProps['onChange'] = (info) => {
    setFileList(info.fileList);
  };

  // 文件上传前验证
  const beforeUpload = (file: UploadFile) => {
    const isValidType = ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'].includes(file.type || '');
    const isValidExt = /\.(pdf|doc|docx)$/i.test(file.name || '');
    
    if (!isValidType && !isValidExt) {
      message.error(`${file.name} 不是有效的文件格式，请上传PDF、DOC或DOCX文件`);
      return false;
    }

    const isLt10M = (file.size || 0) / 1024 / 1024 < 10;
    if (!isLt10M) {
      message.error(`${file.name} 文件大小不能超过10MB`);
      return false;
    }

    return false; // 阻止自动上传
  };

  // 执行导入
  const handleImport = async (overwriteDuplicates = false) => {
    if (fileList.length === 0) {
      message.warning('请选择要导入的文件');
      return;
    }

    try {
      setUploading(true);
      setProgress(0);

      const formData = new FormData();
      fileList.forEach((file) => {
        if (file.originFileObj) {
          formData.append('file', file.originFileObj);
        }
      });
      formData.append('overwriteDuplicates', overwriteDuplicates.toString());

      // 模拟进度
      const progressInterval = setInterval(() => {
        setProgress((prev) => {
          const nextProgress = prev + Math.random() * 30;
          return nextProgress > 90 ? 90 : nextProgress;
        });
      }, 500);

      const result = await importMsdsDocument(formData);

      clearInterval(progressInterval);
      setProgress(100);

      if (result.code === 200) {
        const data = result.data;
        setImportResult(data);

        if (data.duplicates && data.duplicates.length > 0 && !overwriteDuplicates) {
          setDuplicates(data.duplicates);
          setShowDuplicateConfirm(true);
        } else {
          message.success(`导入完成！成功：${data.successCount}，失败：${data.failureCount}`);
          if (data.successCount > 0) {
            onSuccess();
            setTimeout(() => {
              handleCancel();
            }, 2000);
          }
        }
      } else {
        message.error(result.msg || '导入失败');
      }
    } catch (error: any) {
      message.error(error.message || '导入失败，请重试');
    } finally {
      setUploading(false);
    }
  };

  // 处理重复数据确认
  const handleDuplicateConfirm = (overwrite: boolean) => {
    setShowDuplicateConfirm(false);
    if (overwrite) {
      handleImport(true);
    } else {
      message.info('已跳过重复数据');
      if (importResult?.successCount > 0) {
        onSuccess();
        setTimeout(() => {
          handleCancel();
        }, 2000);
      }
    }
  };

  // 下载模板
  const handleDownloadTemplate = async () => {
    try {
      await downloadImportTemplate();
      message.success('模板下载成功');
    } catch (error) {
      message.error('模板下载失败');
    }
  };

  return (
    <Modal
      title="导入MSDS文档"
      open={open}
      onCancel={handleCancel}
      width={700}
      footer={null}
      maskClosable={!uploading}
      closable={!uploading}
    >
      <Space direction="vertical" style={{ width: '100%' }} size="large">
        {/* 导入说明 */}
        <Alert
          message="导入说明"
          description={
            <div>
              <p>支持上传PDF、DOC、DOCX格式的MSDS文档，系统将自动解析文档内容并提取关键信息。</p>
              <p>每个文件大小不超过10MB，支持批量上传。</p>
            </div>
          }
          type="info"
          showIcon
        />

        {/* 模板下载 */}
        <Card size="small">
          <Space>
            <Text>如需了解标准格式，请下载导入模板：</Text>
            <Button 
              size="small" 
              icon={<DownloadOutlined />} 
              onClick={handleDownloadTemplate}
            >
              下载模板
            </Button>
          </Space>
        </Card>

        {/* 文件上传区域 */}
        <Dragger
          name="file"
          multiple={true}
          fileList={fileList}
          onChange={handleChange}
          beforeUpload={beforeUpload}
          disabled={uploading}
          style={{ padding: '20px' }}
        >
          <p className="ant-upload-drag-icon">
            <InboxOutlined style={{ fontSize: '48px', color: '#1890ff' }} />
          </p>
          <p className="ant-upload-text">点击或拖拽文件到此区域上传</p>
          <p className="ant-upload-hint">
            支持PDF、DOC、DOCX格式，单个文件不超过10MB
          </p>
        </Dragger>

        {/* 上传进度 */}
        {uploading && (
          <Card>
            <Text>正在导入...</Text>
            <Progress 
              percent={Math.round(progress)} 
              status={progress === 100 ? 'success' : 'active'}
              style={{ marginTop: 8 }}
            />
          </Card>
        )}

        {/* 导入结果 */}
        {importResult && !showDuplicateConfirm && (
          <Card title="导入结果" size="small">
            <Space direction="vertical" style={{ width: '100%' }}>
              <div>
                <CheckCircleOutlined style={{ color: '#52c41a', marginRight: 8 }} />
                成功导入：{importResult.successCount} 条
              </div>
              {importResult.failureCount > 0 && (
                <div>
                  <ExclamationCircleOutlined style={{ color: '#faad14', marginRight: 8 }} />
                  导入失败：{importResult.failureCount} 条
                </div>
              )}
              
              {/* 错误信息详情 */}
              {importResult.errorMessages && importResult.errorMessages.length > 0 && (
                <Card size="small" title="错误详情" type="inner">
                  <List
                    size="small"
                    dataSource={importResult.errorMessages}
                    renderItem={(errorMsg) => (
                      <List.Item>
                        <Text type="danger" style={{ fontSize: '12px' }}>
                          {errorMsg}
                        </Text>
                      </List.Item>
                    )}
                  />
                </Card>
              )}
              
              {/* 导入建议 */}
              {importResult.failureCount > 0 && (
                <Alert
                  message="导入建议"
                  description={
                    <div>
                      <p>• 请检查文档格式是否为标准MSDS格式</p>
                      <p>• 确保文档包含化学品名称、企业名称等基本信息</p>
                      <p>• 可下载模板参考标准格式</p>
                    </div>
                  }
                  type="info"
                  showIcon
                  style={{ marginTop: 8 }}
                />
              )}
            </Space>
          </Card>
        )}

        {/* 重复数据确认 */}
        {showDuplicateConfirm && (
          <Card title="发现重复数据" size="small">
            <Space direction="vertical" style={{ width: '100%' }}>
              <Alert
                message={`发现 ${duplicates.length} 条重复数据`}
                description="以下化学品已存在于系统中，您可以选择覆盖已有数据或跳过重复项。"
                type="warning"
                showIcon
              />
              
              <List
                size="small"
                dataSource={duplicates}
                renderItem={(item) => (
                  <List.Item>
                    <Space>
                      <FileTextOutlined />
                      <Text>{item.fileName}</Text>
                      <Text type="secondary">-</Text>
                      <Text strong>{item.chemicalName}</Text>
                      {item.casNumber && (
                        <>
                          <Text type="secondary">CAS:</Text>
                          <Text>{item.casNumber}</Text>
                        </>
                      )}
                    </Space>
                  </List.Item>
                )}
              />

              <Space>
                <Button 
                  type="primary" 
                  danger
                  onClick={() => handleDuplicateConfirm(true)}
                >
                  覆盖已有数据
                </Button>
                <Button onClick={() => handleDuplicateConfirm(false)}>
                  跳过重复项
                </Button>
              </Space>
            </Space>
          </Card>
        )}

        {/* 操作按钮 */}
        {!showDuplicateConfirm && (
          <Space style={{ width: '100%', justifyContent: 'flex-end' }}>
            <Button onClick={handleCancel} disabled={uploading}>
              取消
            </Button>
            <Button 
              type="primary" 
              onClick={() => handleImport(false)}
              loading={uploading}
              disabled={fileList.length === 0}
            >
              开始导入
            </Button>
          </Space>
        )}
      </Space>
    </Modal>
  );
};

export default ImportModal;
