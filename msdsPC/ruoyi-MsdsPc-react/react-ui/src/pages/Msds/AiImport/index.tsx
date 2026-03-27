import React, { useState } from 'react';
import { PageContainer, ProCard, ProForm, ProFormText, ProFormTextArea } from '@ant-design/pro-components';
import { Upload, Button, message, Spin, Alert, Tag, Divider, Row, Col } from 'antd';
import { InboxOutlined, SaveOutlined, ClearOutlined, FilePdfOutlined } from '@ant-design/icons';
import { parseMsds } from '@/services/msds/ai';
import { addMsdsMain } from '@/services/msds';
import type { UploadProps } from 'antd';

const { Dragger } = Upload;

type AiImportFormValues = {
  chemicalNameCn: string;
  chemicalNameEn?: string;
  casNo?: string;
  formula?: string;
  supplierName?: string;
  emergencyPhone?: string;
  hazardCategories?: string;
  hazardStatements?: string;
  precautionaryStatements?: string;
};

const splitLines = (value?: string) =>
  value
    ?.split('\n')
    .map((item) => item.trim())
    .filter(Boolean) || [];

const AiImport: React.FC = () => {
  const [fileUrl, setFileUrl] = useState<string | null>(null);
  const [loading, setLoading] = useState<boolean>(false);
  const [parseResult, setParseResult] = useState<API.Msds.MsdsParseVo | null>(null);
  const [form] = ProForm.useForm();

  const handleUpload: UploadProps['customRequest'] = async (options) => {
    const { file, onSuccess, onError } = options;
    setLoading(true);
    setParseResult(null);

    if (fileUrl) {
      URL.revokeObjectURL(fileUrl);
    }
    const url = URL.createObjectURL(file as File);
    setFileUrl(url);

    try {
      const res = await parseMsds(file as File);
      if (res.code === 200 && res.data) {
        setParseResult(res.data);
        
        // 预处理数组数据为换行分隔的字符串，方便 TextArea 显示
        const formData = {
          ...res.data,
          hazardCategories: res.data.hazardCategories?.join('\n'),
          hazardStatements: res.data.hazardStatements?.join('\n'),
          precautionaryStatements: res.data.precautionaryStatements?.join('\n'),
          supplierName: res.data.supplierName || '待补充',
        };
        
        form.setFieldsValue(formData);
        message.success('AI 解析成功！请校对右侧信息');
        if (onSuccess) onSuccess("ok");
      } else {
        message.error(res.msg || '解析失败');
        if (onError) onError(new Error(res.msg));
      }
    } catch (error: any) {
      message.error('请求失败');
      if (onError) onError(error);
    } finally {
      setLoading(false);
    }
  };

  const handleFinish = async (values: AiImportFormValues) => {
    const hazardCategories = splitLines(values.hazardCategories);
    const hazardStatements = splitLines(values.hazardStatements);
    const precautionaryStatements = splitLines(values.precautionaryStatements);

    const remarkLines = [
      hazardCategories.length ? `GHS分类: ${hazardCategories.join('；')}` : '',
      hazardStatements.length ? `危险说明: ${hazardStatements.join('；')}` : '',
      precautionaryStatements.length ? `防范说明: ${precautionaryStatements.join('；')}` : '',
      parseResult?.rawTextSummary ? `原文摘要: ${parseResult.rawTextSummary}` : '',
    ].filter(Boolean);

    const payload: API.Msds.MsdsMain = {
      productName: values.chemicalNameCn.trim(),
      productEnglishName: values.chemicalNameEn?.trim(),
      casNumber: values.casNo?.trim(),
      formula: values.formula?.trim(),
      companyName: values.supplierName?.trim() || '待补充',
      contactPhone: values.emergencyPhone?.trim() || '待补充',
      emergencyPhone: values.emergencyPhone?.trim(),
      status: 'draft',
      isActive: 1,
      remark: remarkLines.join('\n'),
    };

    await addMsdsMain(payload);
    message.success('保存成功');

    if (fileUrl) URL.revokeObjectURL(fileUrl);
    setFileUrl(null);
    setParseResult(null);
    form.resetFields();
    return true;
  };

  const handleClear = () => {
    if (fileUrl) URL.revokeObjectURL(fileUrl);
    setFileUrl(null);
    setParseResult(null);
    form.resetFields();
  };

  return (
    <PageContainer 
      title="AI 智能解析录入 (Beta)"
      content="上传 MSDS PDF 文件，系统将自动提取关键信息，请人工核对后入库。"
    >
      <ProCard ghost gutter={16} split="vertical">
        {/* 左侧：文件上传与预览 */}
        <ProCard colSpan={12} title="原始文件" headerBordered style={{ height: '800px', overflow: 'hidden' }}>
          {!fileUrl ? (
            <div style={{ padding: '50px 0' }}>
              <Dragger 
                customRequest={handleUpload} 
                showUploadList={false} 
                accept=".pdf"
                height={400}
              >
                <p className="ant-upload-drag-icon">
                  <InboxOutlined />
                </p>
                <p className="ant-upload-text">点击或拖拽 PDF 文件到此区域上传</p>
                <p className="ant-upload-hint">
                  支持标准文本型 PDF 格式<br/>
                  AI 将自动提取化学品名称、CAS号、GHS分类等关键信息
                </p>
              </Dragger>
            </div>
          ) : (
            <div style={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
              <div style={{ marginBottom: 16, display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <Tag icon={<FilePdfOutlined />} color="blue">当前预览模式</Tag>
                <Button 
                  icon={<ClearOutlined />} 
                  onClick={handleClear}
                  danger
                >
                  重新上传
                </Button>
              </div>
              <iframe 
                src={fileUrl} 
                width="100%" 
                height="100%" 
                style={{ border: '1px solid #f0f0f0', flex: 1, borderRadius: '4px' }}
                title="PDF Preview"
              />
            </div>
          )}
        </ProCard>

        {/* 右侧：AI 解析结果校对 */}
        <ProCard colSpan={12} title="AI 解析结果校对" headerBordered style={{ height: '800px', overflowY: 'auto' }}>
          <Spin spinning={loading} tip="AI 正在全力解析中 (约需 3-5 秒)...">
            {parseResult && (
              <Alert 
                message={`解析完成，置信度: ${parseResult.confidence || 0}%`}
                description="请仔细核对左侧文档，确认无误后点击底部保存按钮。"
                type="info"
                showIcon
                style={{ marginBottom: 24 }}
              />
            )}
            
            <ProForm
              form={form}
              onFinish={handleFinish}
              submitter={{
                render: (props, dom) => [
                  <Button type="primary" key="submit" onClick={() => props.form?.submit()} icon={<SaveOutlined />}>
                    确认入库
                  </Button>,
                  <Button key="reset" onClick={() => form.resetFields()}>
                    重置表单
                  </Button>
                ],
              }}
              layout="vertical"
            >
              <Divider orientation="left">基础信息</Divider>
              <Row gutter={16}>
                <Col span={12}>
                  <ProFormText name="chemicalNameCn" label="化学品中文名" rules={[{ required: true }]} />
                </Col>
                <Col span={12}>
                  <ProFormText name="chemicalNameEn" label="化学品英文名" />
                </Col>
              </Row>
              
              <Row gutter={16}>
                <Col span={12}>
                  <ProFormText name="casNo" label="CAS 号" rules={[{ required: true }]} />
                </Col>
                <Col span={12}>
                  <ProFormText name="formula" label="分子式" />
                </Col>
              </Row>

              <Divider orientation="left">厂商信息</Divider>
              <Row gutter={16}>
                <Col span={12}>
                  <ProFormText name="supplierName" label="供应商" rules={[{ required: true, message: '请输入企业名称' }]} />
                </Col>
                <Col span={12}>
                  <ProFormText name="emergencyPhone" label="应急电话" rules={[{ required: true, message: '请输入联系电话' }]} />
                </Col>
              </Row>

              <Divider orientation="left">GHS 危险性信息</Divider>
              <ProFormTextArea 
                name="hazardCategories" 
                label="GHS 危险性分类" 
                fieldProps={{ rows: 3 }}
                placeholder="AI解析结果将显示在此处，多项以换行分隔"
                tooltip="AI自动提取的分类，请核对"
              />

              <ProFormTextArea 
                name="hazardStatements" 
                label="危险性说明 (H-Statement)" 
                fieldProps={{ rows: 3 }}
                tooltip="H码及说明"
              />

              <ProFormTextArea 
                name="precautionaryStatements" 
                label="防范说明 (P-Statement)" 
                fieldProps={{ rows: 3 }}
                tooltip="P码及说明"
              />
              
              {parseResult?.rawTextSummary && (
                <>
                  <Divider orientation="left">原文摘要</Divider>
                  <div style={{ background: '#f5f5f5', padding: '12px', borderRadius: '4px', fontSize: '12px', color: '#666' }}>
                    {parseResult.rawTextSummary}
                  </div>
                </>
              )}
            </ProForm>
          </Spin>
        </ProCard>
      </ProCard>
    </PageContainer>
  );
};

export default AiImport;
