import React, { useState, useRef } from 'react';
import { Modal, Upload, Button, message, Alert, Typography, Space, Card, Progress, List, Table, Tabs, Tag, Tooltip, Radio, InputNumber } from 'antd';
import { InboxOutlined, DownloadOutlined, CheckCircleOutlined, EyeOutlined, ExportOutlined } from '@ant-design/icons';
import { importMsdsDocument, importMsdsXml, downloadImportTemplate, previewMsdsDocument, validateExcelFile, countActiveMsds } from '@/services/msds';
import type { MsdsPreviewItem, MsdsSection } from '@/services/msds';
import type { UploadFile, UploadProps } from 'antd';
import { useNavigate } from '@umijs/max';

const { Dragger } = Upload;
const { Text } = Typography;
const { TabPane } = Tabs;

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

type PreviewData = MsdsPreviewItem;

type TemplateType = 'basic' | 'detailed' | 'full';
type TemplateScope = 'all' | 'current';

const ImportModal: React.FC<ImportModalProps> = ({ open, onOpenChange, onSuccess }) => {
  const [uploading, setUploading] = useState(false);
  const [progress, setProgress] = useState(0);
  const [fileList, setFileList] = useState<UploadFile[]>([]);
  const [importResult, setImportResult] = useState<any>(null);
  const [duplicates, setDuplicates] = useState<DuplicateItem[]>([]);
  const [showDuplicateConfirm, setShowDuplicateConfirm] = useState(false);
  const [previewData, setPreviewData] = useState<PreviewData[]>([]);
  const [showPreview, setShowPreview] = useState(false);
  const [previewing, setPreviewing] = useState(false);
  // 可选：后端按文件返回的章节映射（key为 fileName）
  const [previewSectionsMap, setPreviewSectionsMap] = useState<Record<string, MsdsSection[]> | undefined>(undefined);
  const navigate = useNavigate();
  // 模板类型选择
  const [templateType, setTemplateType] = useState<TemplateType>('basic');
  // 模板范围选择
  const [templateScope, setTemplateScope] = useState<TemplateScope>('all');
  // 当前表名（当scope为current时使用）
  const [currentTableName, setCurrentTableName] = useState<string>('msds_main');
  // Excel校验相关状态
  const [validationResult, setValidationResult] = useState<any>(null);
  const [validating, setValidating] = useState(false);
  const [showValidation, setShowValidation] = useState(false);
  const [canceled, setCanceled] = useState(false);
  const cancelRef = useRef(false);
  const [batchSize, setBatchSize] = useState(5);
  const [batchInfo, setBatchInfo] = useState({ current: 0, total: 0 });
  const showUploadList = fileList.length <= 200;

  // 重置状态
  const resetState = () => {
    setFileList([]);
    setImportResult(null);
    setDuplicates([]);
    setShowDuplicateConfirm(false);
    setProgress(0);
    setUploading(false);
    setPreviewData([]);
    setShowPreview(false);
    setPreviewing(false);
    setPreviewSectionsMap(undefined);
    setTemplateType('basic');
    setTemplateScope('all');
    setCurrentTableName('msds_main');
    setValidationResult(null);
    setValidating(false);
    setShowValidation(false);
    setCanceled(false);
    cancelRef.current = false;
    setBatchSize(5);
    setBatchInfo({ current: 0, total: 0 });
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
    const isValidType = [
      'application/pdf', 
      'application/msword', 
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'application/vnd.ms-excel',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'text/xml',
      'application/xml'
    ].includes(file.type || '');
    const isValidExt = /\.(pdf|doc|docx|xls|xlsx|xml)$/i.test(file.name || '');
    
    if (!isValidType && !isValidExt) {
      message.error(`${file.name} 不是有效的文件格式，请上传PDF、DOC、DOCX、XLS、XLSX或XML文件`);
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
      // 大批量导入前确认
      if (fileList.length >= 500) {
        const continueImport = await new Promise<boolean>((resolve) => {
          Modal.confirm({
            title: '批量导入确认',
            content: `您选择了 ${fileList.length} 个文件，批量导入耗时较长，建议分批进行。是否继续？`,
            okText: '继续导入',
            cancelText: '取消',
            onOk: () => resolve(true),
            onCancel: () => resolve(false),
          });
        });
        if (!continueImport) return;
      }

      // 导入前后端可用性检查，避免代理不可达导致界面卡死
      try {
        await countActiveMsds({ timeout: 5000 } as any);
      } catch (e) {
        message.error('后端服务不可达或未启动，请检查 msdsbackend (或本地 18080) 是否运行');
        return;
      }

      setUploading(true);
      setProgress(0);
      setCanceled(false);
      cancelRef.current = false;
      setBatchInfo({ current: 0, total: 0 });

      const formData = new FormData();
      
      // 检查是否包含XML文件
      const hasXmlFile = fileList.some(file => {
        const fileName = file.name || '';
        return /\.xml$/i.test(fileName);
      });

      // 如果包含XML文件，使用XML导入接口（支持批量XML文件）
      if (hasXmlFile) {
        // 检查是否所有文件都是XML，如果混合了其他类型，提示用户分开导入
        const allXml = fileList.every(file => (file.name || '').toLowerCase().endsWith('.xml'));
        if (!allXml) {
           message.warning('请勿混合导入XML和其他格式文件，建议分批导入');
           setUploading(false);
           return;
        }

        // 分批处理配置
        const totalFiles = fileList.length;
        const safeBatchSize = Math.min(Math.max(batchSize || 1, 1), 50);
        const totalBatches = Math.ceil(totalFiles / safeBatchSize);
        
        let successCount = 0;
        let failCount = 0;
        let allResults: any[] = [];
        let hasError = false;
        setBatchInfo({ current: 0, total: totalBatches });

        for (let i = 0; i < totalBatches; i++) {
          if (cancelRef.current) {
            message.warning('已停止导入');
            break;
          }
          const start = i * safeBatchSize;
          const end = Math.min(start + safeBatchSize, totalFiles);
          const currentBatch = fileList.slice(start, end);
          
          const batchBase = Math.round((i / totalBatches) * 100);
          const batchSpan = Math.round(100 / totalBatches);
          setProgress((prev) => Math.max(prev, batchBase));
          setBatchInfo({ current: i + 1, total: totalBatches });
          
          // 构建当前批次的FormData
          const batchFormData = new FormData();
          currentBatch.forEach((file) => {
            if (file.originFileObj) {
              batchFormData.append('file', file.originFileObj);
            }
          });
          batchFormData.append('overwriteDuplicates', overwriteDuplicates.toString());

          try {
            const result = await importMsdsXml(batchFormData, (event: any) => {
              if (!event?.total) return;
              const loadedPercent = Math.round((event.loaded / event.total) * batchSpan * 0.9);
              const nextProgress = Math.min(99, batchBase + loadedPercent);
              setProgress((prev) => Math.max(prev, nextProgress));
            });
            setProgress((prev) => Math.max(prev, batchBase + batchSpan));
            
            if (result.code === 200) {
              // 假设后端返回的数据结构包含成功/失败数量或列表，这里做简单累加
              // 如果后端返回的是单个结果对象，这里可能需要调整。
              // 假设 result.data 包含导入详情
              if (result.data) {
                 allResults.push(result.data);
              }
              successCount += currentBatch.length; // 暂时假设批次内全部成功，除非后端有更细粒度返回
            } else {
              failCount += currentBatch.length;
              hasError = true;
              console.error(`Batch ${i+1} failed:`, result.msg);
            }
          } catch (error) {
            failCount += currentBatch.length;
            hasError = true;
            console.error(`Batch ${i+1} exception:`, error);
          }
          
          // 稍微延迟一下，避免请求太密集，同时让UI有机会刷新
          await new Promise(resolve => setTimeout(resolve, 200));
        }

        setProgress(100);

        if (cancelRef.current) {
          setUploading(false);
          setBatchInfo({ current: 0, total: totalBatches });
          return;
        }

        if (!hasError && failCount === 0) {
          // 合并结果（如果需要显示详细结果，这里需要合并 allResults）
          // 简单起见，取最后一个结果或构造一个综合结果
          setImportResult(allResults.length > 0 ? allResults[allResults.length - 1] : null); 
          message.success(`XML批量导入完成：成功 ${successCount} 个文件`);
          onSuccess?.();
        } else {
          message.warning(`XML批量导入完成：成功 ${successCount} 个，失败 ${failCount} 个`);
          // 如果有部分成功，也可以视为需要刷新列表
          if (successCount > 0) {
             onSuccess?.();
          }
        }
        setBatchInfo({ current: 0, total: totalBatches });
      } else {
        // 普通文件导入（PDF、DOC、DOCX、XLS、XLSX）
        fileList.forEach((file) => {
          if (file.originFileObj) {
            formData.append('file', file.originFileObj);
          }
        });
        formData.append('overwriteDuplicates', overwriteDuplicates.toString());

        const result = await importMsdsDocument(formData, (event: any) => {
          if (!event?.total) return;
          const nextProgress = Math.min(99, Math.round((event.loaded / event.total) * 100));
          setProgress((prev) => Math.max(prev, nextProgress));
        });
        setProgress(100);


        if (result.code === 200) {
          setImportResult(result.data);
          message.success('导入任务已提交');
          onSuccess?.();
        } else {
          message.error(result.msg || '导入失败');
        }
      }
    } catch (error: any) {
      message.error(error.message || '导入失败，请重试');
    } finally {
      setUploading(false);
    }
  };

  // 预览文档
  const handlePreview = async () => {
    if (fileList.length === 0) {
      message.warning('请选择要预览的文件');
      return;
    }

    try {
      setPreviewing(true);
      setProgress(0);

      const formData = new FormData();
      fileList.forEach((file) => {
        if (file.originFileObj) {
          formData.append('file', file.originFileObj);
        }
      });

      // 模拟进度
      const progressInterval = setInterval(() => {
        setProgress((prev) => {
          const nextProgress = prev + Math.random() * 30;
          return nextProgress > 90 ? 90 : nextProgress;
        });
      }, 500);

      const result = await previewMsdsDocument(formData);

      clearInterval(progressInterval);
      setProgress(100);

      if (result.code === 200) {
        const data = result.data;
        setPreviewData(data.previewList || []);
        // 若后端返回章节映射则保存，用于独立页面渲染更细的字段高亮
        setPreviewSectionsMap(data.previewSectionsMap);
        setShowPreview(true);
        message.success('预览生成成功');
      } else {
        message.error(result.msg || '预览失败');
      }
    } catch (error: any) {
      message.error(error.message || '预览失败，请重试');
    } finally {
      setPreviewing(false);
    }
  };

  // 下载模板
  const handleDownloadTemplate = async () => {
    try {
      const scope = templateScope;
      const tableName = templateScope === 'current' ? currentTableName : undefined;
      await downloadImportTemplate(templateType, scope, tableName);
      message.success(`${scope === 'all' ? '全量' : '当前表'}模板下载成功`);
    } catch (error) {
      message.error('模板下载失败');
    }
  };

  // 下载XML模板
  const handleDownloadXmlTemplate = () => {
    try {
      // 直接打开下载链接
      const downloadUrl = '/api/system/msds/importXmlTemplate';
      const link = document.createElement('a');
      link.href = downloadUrl;
      link.download = 'MSDS导入模板.xml';
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      message.success('XML模板下载成功');
    } catch (error) {
      message.error('XML模板下载失败');
    }
  };

  // Excel校验
  const handleValidateExcel = async () => {
    const excelFiles = fileList.filter(file => {
      const fileName = file.name || '';
      return /\.(xls|xlsx)$/i.test(fileName);
    });

    if (excelFiles.length === 0) {
      message.warning('请选择Excel文件进行校验');
      return;
    }

    try {
      setValidating(true);
      setProgress(0);

      const formData = new FormData();
      excelFiles.forEach((file) => {
        if (file.originFileObj) {
          formData.append('file', file.originFileObj);
        }
      });

      // 模拟进度
      const progressInterval = setInterval(() => {
        setProgress((prev) => {
          const nextProgress = prev + Math.random() * 30;
          return nextProgress > 90 ? 90 : nextProgress;
        });
      }, 300);

      const result = await validateExcelFile(formData);

      clearInterval(progressInterval);
      setProgress(100);

      if (result.code === 200) {
        setValidationResult(result.data);
        setShowValidation(true);
        message.success('Excel校验完成');
      } else {
        message.error(result.msg || 'Excel校验失败');
      }
    } catch (error: any) {
      message.error(error.message || 'Excel校验失败，请重试');
    } finally {
      setValidating(false);
    }
  };

  return (
    <Modal
      title="导入MSDS文档"
      open={open}
      onCancel={handleCancel}
      width={showPreview || showValidation ? 1200 : 700}
      footer={null}
      maskClosable={!uploading && !previewing && !validating}
      closable={!uploading && !previewing && !validating}
    >
      <Tabs defaultActiveKey="upload" activeKey={showValidation ? "validation" : showPreview ? "preview" : "upload"}>
        <TabPane tab="文件上传" key="upload">
          <Space direction="vertical" style={{ width: '100%' }} size="large">
        {/* 导入说明 */}
        <Alert
          message="导入说明"
          description={
            <div>
              <p>支持上传 PDF、DOC、DOCX、XLS、XLSX 文件，单个文件不超过 10MB。</p>
              <p>文件名建议包含中文名、英文名、CAS 号</p>
              <p>Excel文件支持校验功能，可检查列头匹配、字段格式等</p>
            </div>
          }
          type="info"
          showIcon
        />

        {/* 模板下载 */}
        <Card size="small">
          <Space direction="vertical" style={{ width: '100%' }} size="middle">
            <div>
              <Text>如需了解标准格式，请选择模板类型并下载：</Text>
            </div>
            
            {/* 模板类型选择 */}
            <div>
              <Text style={{ marginRight: 8 }}>模板类型：</Text>
              <Radio.Group
                value={templateType}
                onChange={(e) => setTemplateType(e.target.value)}
                optionType="button"
                buttonStyle="solid"
                size="small"
              >
                <Radio.Button value="basic">基础</Radio.Button>
                <Radio.Button value="detailed">详细</Radio.Button>
                <Radio.Button value="full">全量多Sheet</Radio.Button>
              </Radio.Group>
            </div>
            
            {/* 下载范围选择 */}
            <div>
              <Text style={{ marginRight: 8 }}>下载范围：</Text>
              <Radio.Group
                value={templateScope}
                onChange={(e) => setTemplateScope(e.target.value)}
                optionType="button"
                buttonStyle="solid"
                size="small"
                style={{ marginRight: 16 }}
              >
                <Radio.Button value="all">全部表</Radio.Button>
                <Radio.Button value="current">当前表</Radio.Button>
              </Radio.Group>
              
              {templateScope === 'current' && (
                <Space>
                  <Text>表名：</Text>
                  <Radio.Group
                    value={currentTableName}
                    onChange={(e) => setCurrentTableName(e.target.value)}
                    size="small"
                  >
                    <Radio.Button value="msds_main">主表</Radio.Button>
                    <Radio.Button value="msds_component">成分表</Radio.Button>
                    <Radio.Button value="msds_hazard">危险性表</Radio.Button>
                  </Radio.Group>
                </Space>
              )}
            </div>
            
            {/* 下载按钮 */}
            <div>
              <Space>
                <Button 
                  size="small" 
                  type="primary"
                  icon={<DownloadOutlined />} 
                  onClick={handleDownloadTemplate}
                >
                  下载{templateScope === 'all' ? '全量' : '当前表'}Excel模板
                </Button>
                <Button 
                  size="small" 
                  icon={<DownloadOutlined />} 
                  onClick={handleDownloadXmlTemplate}
                >
                  下载XML模板
                </Button>
              </Space>
            </div>
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
          showUploadList={showUploadList}
          style={{ padding: '20px' }}
        >
          <p className="ant-upload-drag-icon">
            <InboxOutlined style={{ fontSize: '48px', color: '#1890ff' }} />
          </p>
          <p className="ant-upload-text">点击或拖拽文件到此区域上传</p>
          <p className="ant-upload-hint">
            支持PDF、DOC、DOCX、XLS、XLSX、XML格式，单个文件不超过10MB
          </p>
          <p className="ant-upload-hint" style={{ marginTop: 8, fontSize: '12px', color: '#888' }}>
            💡 推荐使用XML格式批量导入：结构化数据、支持16个章节完整信息
          </p>
        </Dragger>
        {!showUploadList && (
          <Alert
            message={`已选择 ${fileList.length} 个文件，为提升性能已隐藏文件列表`}
            type="info"
            showIcon
          />
        )}

        <Card size="small">
          <Space align="center" wrap>
            <Text>XML 批次大小：</Text>
            <InputNumber
              min={1}
              max={50}
              value={batchSize}
              onChange={(value) => setBatchSize(Number(value || 1))}
              disabled={uploading || previewing || validating}
            />
            <Text type="secondary">建议 5-20</Text>
          </Space>
        </Card>

        {/* 上传/预览/校验进度 */}
        {(uploading || previewing || validating) && (
          <Card>
            <Text>
              {validating ? '正在校验Excel...' : previewing ? '正在预览...' : '正在导入...'}
            </Text>
            {!validating && !previewing && batchInfo.total > 0 && (
              <div style={{ marginTop: 4 }}>
                <Text type="secondary">批次 {batchInfo.current}/{batchInfo.total}</Text>
              </div>
            )}
            <Progress 
              percent={Math.round(progress)} 
              status={progress === 100 ? 'success' : 'active'}
              style={{ marginTop: 8 }}
            />
          </Card>
        )}

        {/* 操作按钮 */}
        <Space style={{ width: '100%', justifyContent: 'flex-end' }}>
          <Button onClick={handleCancel} disabled={uploading || previewing || validating}>
            取消
          </Button>
          {uploading && (
            <Button danger onClick={() => {
              cancelRef.current = true;
              setCanceled(true);
            }}>
              停止导入
            </Button>
          )}
          <Button 
            icon={<CheckCircleOutlined />}
            onClick={handleValidateExcel}
            loading={validating}
            disabled={fileList.length === 0 || uploading || previewing}
          >
            Excel校验
          </Button>
          <Button 
            icon={<EyeOutlined />}
            onClick={handlePreview}
            loading={previewing}
            disabled={fileList.length === 0 || uploading || validating}
          >
            预览
          </Button>
          <Button
            icon={<ExportOutlined />}
            onClick={() => {
              if (!previewData || previewData.length === 0) {
                message.warning('暂无可查看的预览数据，请先生成预览');
                return;
              }
              navigate('/msds/preview', { state: { previewList: previewData, previewSectionsMap } });
              // 关闭当前导入弹窗，避免覆盖新页面
              onOpenChange(false);
            }}
            disabled={previewData.length === 0}
          >
            在独立页面查看
          </Button>
          <Button 
            type="primary" 
            onClick={() => handleImport(false)}
            loading={uploading}
            disabled={fileList.length === 0 || previewing || validating}
          >
            开始导入
          </Button>
        </Space>
          </Space>
        </TabPane>
        
        {/* Excel校验Tab */}
        <TabPane tab="Excel校验" key="validation" disabled={!showValidation}>
          <Space direction="vertical" style={{ width: '100%' }} size="large">
            {validationResult && (
              <>
                <Alert
                  message="校验结果"
                  description={`共校验 ${validationResult.totalRows || 0} 行数据，发现 ${validationResult.errorCount || 0} 个错误`}
                  type={validationResult.isValid ? 'success' : 'warning'}
                  showIcon
                />
                
                {validationResult.errors && validationResult.errors.length > 0 && (
                  <Card title="错误详情" size="small">
                    <List
                      dataSource={validationResult.errors}
                      renderItem={(error: any, index: number) => (
                        <List.Item>
                          <Space direction="vertical" style={{ width: '100%' }}>
                            <Text strong style={{ color: '#ff4d4f' }}>
                              第{error.row}行，第{error.column}列：{error.field}
                            </Text>
                            <Text>{error.message}</Text>
                            {error.suggestion && (
                              <Text type="secondary">建议：{error.suggestion}</Text>
                            )}
                          </Space>
                        </List.Item>
                      )}
                      pagination={{
                        pageSize: 10,
                        showSizeChanger: true,
                        showQuickJumper: true,
                        showTotal: (total, range) => `第 ${range[0]}-${range[1]} 项 / 共 ${total} 项`,
                      }}
                    />
                  </Card>
                )}
                
                {validationResult.columnMapping && (
                  <Card title="列头映射" size="small">
                    <Table
                      dataSource={Object.entries(validationResult.columnMapping).map(([excel, db], index) => ({
                        key: index,
                        excelColumn: excel,
                        dbField: db,
                        status: db ? 'success' : 'error'
                      }))}
                      size="small"
                      pagination={false}
                      columns={[
                        {
                          title: 'Excel列名',
                          dataIndex: 'excelColumn',
                          width: 200,
                        },
                        {
                          title: '数据库字段',
                          dataIndex: 'dbField',
                          width: 200,
                          render: (text, record) => (
                            <span style={{ color: record.status === 'success' ? '#52c41a' : '#ff4d4f' }}>
                              {text || '未匹配'}
                            </span>
                          ),
                        },
                        {
                          title: '状态',
                          dataIndex: 'status',
                          width: 100,
                          render: (status) => (
                            <Tag color={status === 'success' ? 'green' : 'red'}>
                              {status === 'success' ? '已匹配' : '未匹配'}
                            </Tag>
                          ),
                        },
                      ]}
                    />
                  </Card>
                )}
              </>
            )}
          </Space>
        </TabPane>
        
        {/* 预览Tab */}
        <TabPane tab="预览数据" key="preview" disabled={!showPreview}>
          <Space direction="vertical" style={{ width: '100%' }} size="large">
            <Alert
              message="预览结果"
              description={`共解析 ${previewData.length} 个文件，请检查数据是否正确。`}
              type="info"
              showIcon
            />
            
            <Table
              dataSource={previewData}
              rowKey={(record, index) => `${record.fileName}-${index}`}
              size="small"
              scroll={{ x: 800 }}
              pagination={{
                pageSize: 10,
                showSizeChanger: true,
                showQuickJumper: true,
                showTotal: (total, range) => `第 ${range[0]}-${range[1]} 项 / 共 ${total} 项`,
              }}
              columns={[
                {
                  title: '文件名',
                  dataIndex: 'fileName',
                  width: 200,
                  ellipsis: true,
                  render: (text) => (
                    <Tooltip title={text}>
                      <span style={{ color: '#666' }}>{text}</span>
                    </Tooltip>
                  ),
                },
                {
                  title: '化学品中文名',
                  dataIndex: 'productName',
                  width: 200,
                  ellipsis: true,
                  render: (text, record) => {
                    if (!text || text.trim() === '') {
                      return <span style={{ color: '#ff4d4f', fontStyle: 'italic' }}>未解析到</span>;
                    }
                    return (
                      <Tooltip title={text}>
                        <span 
                          style={{ 
                            color: '#1890ff', 
                            fontWeight: 'bold',
                            cursor: 'pointer',
                            textDecoration: 'none'
                          }}
                          onMouseEnter={(e) => {
                            (e.target as HTMLElement).style.color = '#40a9ff';
                            (e.target as HTMLElement).style.textDecoration = 'underline';
                          }}
                          onMouseLeave={(e) => {
                            (e.target as HTMLElement).style.color = '#1890ff';
                            (e.target as HTMLElement).style.textDecoration = 'none';
                          }}
                          onClick={() => {
                            message.info(`查看化学品详情：${text}`);
                          }}
                        >
                          {text}
                        </span>
                      </Tooltip>
                    );
                  },
                },
                {
                  title: '化学品英文名',
                  dataIndex: 'productEnglishName',
                  width: 200,
                  ellipsis: true,
                  render: (text) => {
                    if (!text || text.trim() === '') {
                      return <span style={{ color: '#d9d9d9', fontStyle: 'italic' }}>-</span>;
                    }
                    return (
                      <Tooltip title={text}>
                        <span>{text}</span>
                      </Tooltip>
                    );
                  },
                },
                {
                  title: 'CAS号',
                  dataIndex: 'casNumber',
                  width: 120,
                  render: (text) => {
                    if (!text || text.trim() === '') {
                      return <span style={{ color: '#d9d9d9', fontStyle: 'italic' }}>-</span>;
                    }
                    return <span style={{ fontFamily: 'monospace' }}>{text}</span>;
                  },
                },
                {
                  title: '企业名称',
                  dataIndex: 'companyName',
                  width: 180,
                  ellipsis: true,
                  render: (text) => {
                    if (!text || text.trim() === '') {
                      return <span style={{ color: '#ff4d4f', fontStyle: 'italic' }}>未解析到</span>;
                    }
                    return (
                      <Tooltip title={text}>
                        <span>{text}</span>
                      </Tooltip>
                    );
                  },
                },
                {
                  title: '版本号',
                  dataIndex: 'version',
                  width: 80,
                  render: (text) => {
                    if (!text || text.trim() === '') {
                      return <span style={{ color: '#d9d9d9', fontStyle: 'italic' }}>-</span>;
                    }
                    return <span style={{ fontFamily: 'monospace' }}>{text}</span>;
                  },
                },
                {
                  title: '状态',
                  dataIndex: 'status',
                  width: 120,
                  render: (status, record) => {
                    const statusConfig: any = {
                      success: { color: 'green', text: '解析成功' },
                      warning: { color: 'orange', text: '部分解析' },
                      error: { color: 'red', text: '解析失败' },
                    };
                    const config = statusConfig[status] || statusConfig.error;
                    const hasRequiredFields = record.productName && record.casNumber;
                    const actualStatus = hasRequiredFields ? status : 'error';
                    const actualConfig = statusConfig[actualStatus] || statusConfig.error;
                    return (
                      <Tag color={actualConfig.color}>{actualConfig.text}</Tag>
                    );
                  },
                },
              ]}
            />
          </Space>
        </TabPane>
      </Tabs>
    </Modal>
  );
};

export default ImportModal;
