import React, { useState, useEffect, forwardRef, useImperativeHandle } from 'react';
import * as otherInfoApi from '@/services/msds/otherInfo';
import {
  Form,
  Input,
  Select,
  Card,
  Row,
  Col,
  DatePicker,
  Space,
  Typography,
  Tag,
  Table,
  Button,
  Divider,
  Upload,
  message
} from 'antd';
import { 
  InfoCircleOutlined, 
  FileTextOutlined, 
  CalendarOutlined, 
  UserOutlined,
  BookOutlined,
  PlusOutlined,
  DeleteOutlined,
  UploadOutlined,
  HistoryOutlined
} from '@ant-design/icons';
import dayjs from 'dayjs';

const { TextArea } = Input;
const { Option } = Select;
const { Title, Text } = Typography;

export interface Step16OtherInfoProps {
  data?: any;
  onChange?: (data: any) => void;
}

const Step16OtherInfo = forwardRef<any, Step16OtherInfoProps>(
  ({ data = {}, onChange }, ref) => {
    const [form] = Form.useForm();
    const [formData, setFormData] = useState(data);
    const [revisionHistory, setRevisionHistory] = useState(data.revisionHistory || []);
    const [references, setReferences] = useState(data.references || []);

    useImperativeHandle(ref, () => ({
      validateFields: () => form.validateFields(),
      resetFields: () => form.resetFields(),
      getFieldsValue: () => form.getFieldsValue(),
      setFieldsValue: (values: any) => form.setFieldsValue(values)
    }));

    useEffect(() => {
      form.setFieldsValue(formData);
    }, [formData, form]);

    const handleFieldChange = (changedFields: any, allFields: any) => {
      const newData = { ...formData, ...allFields, revisionHistory, references };
      setFormData(newData);
      onChange?.(newData);
    };

    // 添加修订记录
    const addRevisionRecord = () => {
      const newRecord = {
        id: Date.now(),
        version: '',
        date: null,
        author: '',
        changes: '',
        reason: ''
      };
      setRevisionHistory([...revisionHistory, newRecord]);
    };

    // 删除修订记录
    const removeRevisionRecord = (id: number) => {
      setRevisionHistory(revisionHistory.filter(item => item.id !== id));
    };

    // 更新修订记录
    const updateRevisionRecord = (id: number, field: string, value: any) => {
      setRevisionHistory(revisionHistory.map(item => 
        item.id === id ? { ...item, [field]: value } : item
      ));
    };

    // 添加参考文献
    const addReference = () => {
      const newReference = {
        id: Date.now(),
        type: '',
        title: '',
        author: '',
        source: '',
        date: '',
        url: ''
      };
      setReferences([...references, newReference]);
    };

    // 删除参考文献
    const removeReference = (id: number) => {
      setReferences(references.filter(item => item.id !== id));
    };

    // 更新参考文献
    const updateReference = (id: number, field: string, value: any) => {
      setReferences(references.map(item => 
        item.id === id ? { ...item, [field]: value } : item
      ));
    };

    // 修订记录表格列定义
    const revisionColumns = [
      {
        title: '版本号',
        dataIndex: 'version',
        width: 100,
        render: (text: string, record: any) => (
          <Input
            value={text}
            onChange={(e) => updateRevisionRecord(record.id, 'version', e.target.value)}
            placeholder="如：1.0"
          />
        )
      },
      {
        title: '修订日期',
        dataIndex: 'date',
        width: 150,
        render: (text: string, record: any) => (
          <DatePicker
            value={text ? dayjs(text) : null}
            onChange={(date) => updateRevisionRecord(record.id, 'date', date?.format('YYYY-MM-DD'))}
            style={{ width: '100%' }}
          />
        )
      },
      {
        title: '修订人',
        dataIndex: 'author',
        width: 120,
        render: (text: string, record: any) => (
          <Input
            value={text}
            onChange={(e) => updateRevisionRecord(record.id, 'author', e.target.value)}
            placeholder="修订人姓名"
          />
        )
      },
      {
        title: '修订内容',
        dataIndex: 'changes',
        render: (text: string, record: any) => (
          <Input
            value={text}
            onChange={(e) => updateRevisionRecord(record.id, 'changes', e.target.value)}
            placeholder="修订内容描述"
          />
        )
      },
      {
        title: '修订原因',
        dataIndex: 'reason',
        width: 150,
        render: (text: string, record: any) => (
          <Select
            value={text}
            onChange={(value) => updateRevisionRecord(record.id, 'reason', value)}
            style={{ width: '100%' }}
            placeholder="选择原因"
          >
            <Option value="法规更新">法规更新</Option>
            <Option value="数据更新">数据更新</Option>
            <Option value="错误修正">错误修正</Option>
            <Option value="格式调整">格式调整</Option>
            <Option value="内容补充">内容补充</Option>
            <Option value="其他">其他</Option>
          </Select>
        )
      },
      {
        title: '操作',
        width: 80,
        render: (text: string, record: any) => (
          <Button
            type="text"
            danger
            icon={<DeleteOutlined />}
            onClick={() => removeRevisionRecord(record.id)}
          />
        )
      }
    ];

    // 参考文献表格列定义
    const referenceColumns = [
      {
        title: '类型',
        dataIndex: 'type',
        width: 100,
        render: (text: string, record: any) => (
          <Select
            value={text}
            onChange={(value) => updateReference(record.id, 'type', value)}
            style={{ width: '100%' }}
            placeholder="类型"
          >
            <Option value="标准">标准</Option>
            <Option value="法规">法规</Option>
            <Option value="文献">文献</Option>
            <Option value="数据库">数据库</Option>
            <Option value="报告">报告</Option>
            <Option value="网站">网站</Option>
          </Select>
        )
      },
      {
        title: '标题',
        dataIndex: 'title',
        render: (text: string, record: any) => (
          <Input
            value={text}
            onChange={(e) => updateReference(record.id, 'title', e.target.value)}
            placeholder="文献标题"
          />
        )
      },
      {
        title: '作者/机构',
        dataIndex: 'author',
        width: 150,
        render: (text: string, record: any) => (
          <Input
            value={text}
            onChange={(e) => updateReference(record.id, 'author', e.target.value)}
            placeholder="作者或机构"
          />
        )
      },
      {
        title: '来源',
        dataIndex: 'source',
        width: 150,
        render: (text: string, record: any) => (
          <Input
            value={text}
            onChange={(e) => updateReference(record.id, 'source', e.target.value)}
            placeholder="出版社或期刊"
          />
        )
      },
      {
        title: '日期',
        dataIndex: 'date',
        width: 100,
        render: (text: string, record: any) => (
          <Input
            value={text}
            onChange={(e) => updateReference(record.id, 'date', e.target.value)}
            placeholder="年份"
          />
        )
      },
      {
        title: '操作',
        width: 80,
        render: (text: string, record: any) => (
          <Button
            type="text"
            danger
            icon={<DeleteOutlined />}
            onClick={() => removeReference(record.id)}
          />
        )
      }
    ];

    return (
      <div style={{ padding: '24px', backgroundColor: '#f8f9fa' }}>
        <Card>
          <div style={{ marginBottom: '24px' }}>
            <Title level={4} style={{ color: '#1890ff', marginBottom: '8px' }}>
              <FileTextOutlined style={{ marginRight: '8px' }} />
              第16节：其他信息
            </Title>
            <Text type="secondary">
              包含参考文献、编制信息、修订记录等其他相关信息
            </Text>
          </div>

          <Form
            form={form}
            layout="vertical"
            onValuesChange={handleFieldChange}
            initialValues={formData}
          >
            {/* 编制信息 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                <UserOutlined style={{ marginRight: '8px' }} />
                编制信息
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label="编制单位"
                    name="preparingOrganization"
                  >
                    <Input placeholder="请输入编制单位名称" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="编制人"
                    name="preparedBy"
                  >
                    <Input placeholder="请输入编制人姓名" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="编制日期"
                    name="preparationDate"
                  >
                    <DatePicker
                      style={{ width: '100%' }}
                      placeholder="选择编制日期"
                    />
                  </Form.Item>
                </Col>
              </Row>

              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label="审核人"
                    name="reviewedBy"
                  >
                    <Input placeholder="请输入审核人姓名" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="批准人"
                    name="approvedBy"
                  >
                    <Input placeholder="请输入批准人姓名" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="版本号"
                    name="version"
                  >
                    <Input placeholder="如：1.0" />
                  </Form.Item>
                </Col>
              </Row>

              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label="联系电话"
                    name="contactPhone"
                  >
                    <Input placeholder="请输入联系电话" />
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="电子邮箱"
                    name="contactEmail"
                  >
                    <Input placeholder="请输入电子邮箱" />
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="编制说明"
                name="preparationNotes"
              >
                <TextArea
                  rows={3}
                  placeholder="请说明编制依据、编制过程、注意事项等"
                />
              </Form.Item>
            </Card>

            {/* 修订记录 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                <HistoryOutlined style={{ marginRight: '8px' }} />
                修订记录
              </Title>
              
              <div style={{ marginBottom: '16px' }}>
                <Button
                  type="dashed"
                  icon={<PlusOutlined />}
                  onClick={addRevisionRecord}
                >
                  添加修订记录
                </Button>
              </div>

              <Table
                columns={revisionColumns}
                dataSource={revisionHistory}
                rowKey="id"
                pagination={false}
                size="small"
                scroll={{ x: 1000 }}
              />
            </Card>

            {/* 参考文献 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                <BookOutlined style={{ marginRight: '8px' }} />
                参考文献
              </Title>
              
              <div style={{ marginBottom: '16px' }}>
                <Button
                  type="dashed"
                  icon={<PlusOutlined />}
                  onClick={addReference}
                >
                  添加参考文献
                </Button>
              </div>

              <Table
                columns={referenceColumns}
                dataSource={references}
                rowKey="id"
                pagination={false}
                size="small"
                scroll={{ x: 1000 }}
              />
            </Card>

            {/* 数据来源 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                数据来源
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label="主要数据来源"
                    name="primaryDataSource"
                  >
                    <Select
                      mode="multiple"
                      placeholder="选择主要数据来源"
                    >
                      <Option value="manufacturer">制造商提供</Option>
                      <Option value="literature">文献资料</Option>
                      <Option value="database">数据库查询</Option>
                      <Option value="testing">试验测定</Option>
                      <Option value="calculation">理论计算</Option>
                      <Option value="estimation">估算方法</Option>
                      <Option value="similar">类似物质</Option>
                      <Option value="expert">专家判断</Option>
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="数据可靠性"
                    name="dataReliability"
                  >
                    <Select placeholder="选择数据可靠性等级">
                      <Option value="high">高可靠性</Option>
                      <Option value="medium">中等可靠性</Option>
                      <Option value="low">低可靠性</Option>
                      <Option value="unknown">可靠性未知</Option>
                    </Select>
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="数据来源说明"
                name="dataSourceDescription"
              >
                <TextArea
                  rows={3}
                  placeholder="请详细说明各项数据的具体来源、获取方法等"
                />
              </Form.Item>
            </Card>

            {/* 免责声明 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                免责声明
              </Title>
              
              <Form.Item
                label="免责声明"
                name="disclaimer"
              >
                <TextArea
                  rows={4}
                  placeholder="请输入免责声明内容"
                  defaultValue="本安全数据表所载资料是基于目前我们所掌握的知识和经验，仅供参考。在法律允许的范围内，我们对本安全数据表所载资料的准确性、完整性和适用性不作任何明示或暗示的保证。用户有责任验证本安全数据表所载资料是否适用于其特定用途。"
                />
              </Form.Item>
            </Card>

            {/* 其他信息 */}
            <Card size="small">
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                其他信息
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label="语言版本"
                    name="languageVersion"
                  >
                    <Select
                      mode="multiple"
                      placeholder="选择语言版本"
                    >
                      <Option value="zh-CN">中文简体</Option>
                      <Option value="zh-TW">中文繁体</Option>
                      <Option value="en">英文</Option>
                      <Option value="ja">日文</Option>
                      <Option value="ko">韩文</Option>
                      <Option value="fr">法文</Option>
                      <Option value="de">德文</Option>
                      <Option value="es">西班牙文</Option>
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="文档格式"
                    name="documentFormat"
                  >
                    <Select
                      mode="multiple"
                      placeholder="选择文档格式"
                    >
                      <Option value="pdf">PDF</Option>
                      <Option value="word">Word</Option>
                      <Option value="html">HTML</Option>
                      <Option value="xml">XML</Option>
                      <Option value="json">JSON</Option>
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="分发范围"
                    name="distributionScope"
                  >
                    <Select placeholder="选择分发范围">
                      <Option value="public">公开</Option>
                      <Option value="internal">内部</Option>
                      <Option value="confidential">机密</Option>
                      <Option value="restricted">限制</Option>
                    </Select>
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="缩略语说明"
                name="abbreviations"
              >
                <TextArea
                  rows={3}
                  placeholder="请解释文档中使用的缩略语和专业术语"
                />
              </Form.Item>

              <Form.Item
                label="培训建议"
                name="trainingRecommendations"
              >
                <TextArea
                  rows={3}
                  placeholder="请提供使用本化学品的培训建议"
                />
              </Form.Item>

              <Form.Item
                label="补充信息"
                name="additionalInformation"
              >
                <TextArea
                  rows={4}
                  placeholder="请提供其他重要的补充信息、注意事项等"
                />
              </Form.Item>
            </Card>
          </Form>
        </Card>
      </div>
    );
  }
);

Step16OtherInfo.displayName = 'Step16OtherInfo';

export default Step16OtherInfo;