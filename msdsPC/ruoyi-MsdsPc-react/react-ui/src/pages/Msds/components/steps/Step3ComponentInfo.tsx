import React, { forwardRef, useImperativeHandle, useEffect, useState } from 'react';
import { 
  Form, 
  Input, 
  Card, 
  Row, 
  Col, 
  Space, 
  Select,
  Tooltip,
  Alert,
  InputNumber,
  Table,
  Button,
  Popconfirm,
  Tag,
  Switch,
  message
} from 'antd';
import { 
  InfoCircleOutlined,
  ExperimentOutlined,
  PlusOutlined,
  DeleteOutlined,
  WarningOutlined
} from '@ant-design/icons';
import type { API } from '@/types/msds';
import * as componentApi from '@/services/msds/component';

const { TextArea } = Input;
const { Option } = Select;

interface ComponentItem {
  id: number;
  chemicalName: string;
  casNumber: string;
  concentration: number;
  concentrationRange: string;
  classification: string;
  hazardStatement: string;
  function: string;
}

interface Step3ComponentInfoProps {
  data?: API.Msds.MsdsComponent;
  onChange?: (data: API.Msds.MsdsComponent) => void;
}

const Step3ComponentInfo = forwardRef<any, Step3ComponentInfoProps>(({ data, onChange }, ref) => {
  const [form] = Form.useForm();
  const [components, setComponents] = useState<ComponentItem[]>(data?.components || []);
  const [isHazardous, setIsHazardous] = useState(data?.isHazardous || false);

  useImperativeHandle(ref, () => ({
    validateFields: () => form.validateFields(),
    getFieldsValue: () => {
      const formValues = form.getFieldsValue();
      return { ...formValues, components, isHazardous };
    },
    setFieldsValue: (values: any) => form.setFieldsValue(values)
  }));

  useEffect(() => {
    if (data) {
      form.setFieldsValue(data);
      setComponents(data.components || []);
      setIsHazardous(data.isHazardous || false);
    }
  }, [data, form]);

  // 表单值变化时触发onChange
  const handleValuesChange = (changedValues: any, allValues: any) => {
    if (onChange) {
      onChange({ ...allValues, components, isHazardous });
    }
  };

  // 产品类型选项
  const productTypeOptions = [
    '纯物质', '混合物', '制剂', '合金', '溶液'
  ];

  // 化学品分类选项
  const classificationOptions = [
    '易燃液体', '腐蚀性物质', '氧化性物质', '有毒物质', 
    '刺激性物质', '致敏物质', '致癌物质', '环境危害物质'
  ];

  // 功能选项
  const functionOptions = [
    '主要成分', '溶剂', '稳定剂', '催化剂', '添加剂', 
    '杂质', '分解产物', '副产物', '其他'
  ];

  // 添加组分
  const addComponent = () => {
    const newComponent: ComponentItem = {
      id: Date.now(),
      chemicalName: '',
      casNumber: '',
      concentration: 0,
      concentrationRange: '',
      classification: '',
      hazardStatement: '',
      function: ''
    };
    setComponents([...components, newComponent]);
  };

  // 删除组分
  const removeComponent = (id: number) => {
    const updatedComponents = components.filter(comp => comp.id !== id);
    setComponents(updatedComponents);
    if (onChange) {
      const formValues = form.getFieldsValue();
      onChange({ ...formValues, components: updatedComponents, isHazardous });
    }
  };

  // 更新组分
  const updateComponent = (id: number, field: keyof ComponentItem, value: any) => {
    const updatedComponents = components.map(comp => 
      comp.id === id ? { ...comp, [field]: value } : comp
    );
    setComponents(updatedComponents);
    if (onChange) {
      const formValues = form.getFieldsValue();
      onChange({ ...formValues, components: updatedComponents, isHazardous });
    }
  };

  // 组分表格列定义
  const componentColumns = [
    {
      title: '化学品名称',
      dataIndex: 'chemicalName',
      width: 200,
      render: (text: string, record: ComponentItem) => (
        <Input
          value={text}
          onChange={(e) => updateComponent(record.id, 'chemicalName', e.target.value)}
          placeholder="请输入化学品名称"
        />
      )
    },
    {
      title: 'CAS号',
      dataIndex: 'casNumber',
      width: 150,
      render: (text: string, record: ComponentItem) => (
        <Input
          value={text}
          onChange={(e) => updateComponent(record.id, 'casNumber', e.target.value)}
          placeholder="如：64-17-5"
        />
      )
    },
    {
      title: '含量(%)',
      dataIndex: 'concentration',
      width: 120,
      render: (value: number, record: ComponentItem) => (
        <InputNumber
          value={value}
          onChange={(val) => updateComponent(record.id, 'concentration', val || 0)}
          min={0}
          max={100}
          precision={2}
          style={{ width: '100%' }}
          placeholder="0.00"
        />
      )
    },
    {
      title: '含量范围',
      dataIndex: 'concentrationRange',
      width: 130,
      render: (text: string, record: ComponentItem) => (
        <Input
          value={text}
          onChange={(e) => updateComponent(record.id, 'concentrationRange', e.target.value)}
          placeholder="如：10-20"
        />
      )
    },
    {
      title: '危险性分类',
      dataIndex: 'classification',
      width: 150,
      render: (text: string, record: ComponentItem) => (
        <Select
          value={text}
          onChange={(val) => updateComponent(record.id, 'classification', val)}
          style={{ width: '100%' }}
          placeholder="选择分类"
          allowClear
        >
          {classificationOptions.map(option => (
            <Option key={option} value={option}>{option}</Option>
          ))}
        </Select>
      )
    },
    {
      title: '功能',
      dataIndex: 'function',
      width: 120,
      render: (text: string, record: ComponentItem) => (
        <Select
          value={text}
          onChange={(val) => updateComponent(record.id, 'function', val)}
          style={{ width: '100%' }}
          placeholder="选择功能"
          allowClear
        >
          {functionOptions.map(option => (
            <Option key={option} value={option}>{option}</Option>
          ))}
        </Select>
      )
    },
    {
      title: '操作',
      width: 80,
      render: (_, record: ComponentItem) => (
        <Popconfirm
          title="确定要删除这个组分吗？"
          onConfirm={() => removeComponent(record.id)}
          okText="确定"
          cancelText="取消"
        >
          <Button 
            type="link" 
            danger 
            icon={<DeleteOutlined />}
            size="small"
          />
        </Popconfirm>
      )
    }
  ];

  return (
    <Form
      form={form}
      layout="vertical"
      onValuesChange={handleValuesChange}
      autoComplete="off"
    >
      <Alert
        message="第3节：成分/组成信息"
        description="请详细填写化学品的成分信息。对于纯物质，请填写化学品本身的信息；对于混合物，请列出所有组分及其含量。"
        type="info"
        showIcon
        icon={<ExperimentOutlined />}
        style={{ marginBottom: 24 }}
      />

      {/* 基本成分信息 */}
      <Card title="🧪 基本成分信息" size="small" style={{ marginBottom: 16 }}>
        <Row gutter={16}>
          <Col span={8}>
            <Form.Item
              label={
                <Space>
                  产品类型
                  <Tooltip title="选择产品的基本类型">
                    <InfoCircleOutlined />
                  </Tooltip>
                </Space>
              }
              name="productType"
              rules={[{ required: true, message: '请选择产品类型' }]}
            >
              <Select placeholder="请选择产品类型" allowClear>
                {productTypeOptions.map(type => (
                  <Option key={type} value={type}>{type}</Option>
                ))}
              </Select>
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item
              label={
                <Space>
                  是否含有危险成分
                  <Tooltip title="产品中是否含有被分类为危险的成分">
                    <InfoCircleOutlined />
                  </Tooltip>
                </Space>
              }
              name="isHazardous"
              valuePropName="checked"
            >
              <Switch 
                checked={isHazardous}
                onChange={(checked) => {
                  setIsHazardous(checked);
                  if (onChange) {
                    const formValues = form.getFieldsValue();
                    onChange({ ...formValues, components, isHazardous: checked });
                  }
                }}
              />
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item
              label="分子式"
              name="molecularFormula"
            >
              <Input placeholder="如：C2H5OH" />
            </Form.Item>
          </Col>
        </Row>

        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              label="分子量"
              name="molecularWeight"
            >
              <InputNumber
                style={{ width: '100%' }}
                placeholder="请输入分子量"
                min={0}
                precision={2}
                addonAfter="g/mol"
              />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              label="EINECS编号"
              name="einecsNumber"
            >
              <Input placeholder="欧洲现有商业化学物质清单编号" />
            </Form.Item>
          </Col>
        </Row>

        <Form.Item
          label="成分说明"
          name="componentDescription"
        >
          <TextArea 
            placeholder="请简要说明产品的主要成分组成" 
            rows={3}
          />
        </Form.Item>
      </Card>

      {/* 组分详细信息 */}
      <Card 
        title="📊 组分详细信息" 
        size="small" 
        style={{ marginBottom: 16 }}
        extra={
          <Button 
            type="primary" 
            icon={<PlusOutlined />}
            onClick={addComponent}
            size="small"
          >
            添加组分
          </Button>
        }
      >
        {components.length > 0 ? (
          <Table
            dataSource={components}
            columns={componentColumns}
            rowKey="id"
            pagination={false}
            size="small"
            scroll={{ x: 1000 }}
            style={{ marginBottom: 16 }}
          />
        ) : (
          <Alert
            message="暂无组分信息"
            description="请点击添加组分按钮添加化学品组分信息"
            type="info"
            showIcon
            style={{ marginBottom: 16 }}
          />
        )}

        {isHazardous && (
          <Alert
            message="危险组分提醒"
            description="此产品含有危险成分，请确保在危险性概述中详细说明相关危险性，并在个体防护措施中提供适当的防护建议。"
            type="warning"
            showIcon
            icon={<WarningOutlined />}
          />
        )}
      </Card>

      {/* 商业机密信息 */}
      <Card title="🔒 商业机密信息" size="small" style={{ marginBottom: 16 }}>
        <Form.Item
          label={
            <Space>
              商业机密组分
              <Tooltip title="根据商业机密保护的需要，可以不公开某些组分的具体信息">
                <InfoCircleOutlined />
              </Tooltip>
            </Space>
          }
          name="confidentialComponents"
        >
          <TextArea 
            placeholder="如果有商业机密组分，请在此说明保密的原因和范围" 
            rows={3}
          />
        </Form.Item>

        <Form.Item
          label="非危险组分"
          name="nonHazardousComponents"
        >
          <TextArea 
            placeholder="列出含量小于1%的非危险组分或添加剂" 
            rows={2}
          />
        </Form.Item>
      </Card>

      {/* 填写提示 */}
      <Alert
        message="填写提示"
        description={
          <ul style={{ margin: 0, paddingLeft: 20 }}>
            <li>对于纯物质：填写化学品本身的CAS号、分子式、分子量等信息</li>
            <li>对于混合物：详细列出所有组分，含量≥1%的组分必须列出</li>
            <li>危险组分：无论含量多少都必须列出</li>
            <li>CAS号格式：数字-数字-数字（如：64-17-5）</li>
            <li>含量表示：可用百分比或范围表示（如：10-20%）</li>
          </ul>
        }
        type="info"
        showIcon
        style={{ marginTop: 16 }}
      />
    </Form>
  );
});

Step3ComponentInfo.displayName = 'Step3ComponentInfo';

export default Step3ComponentInfo;