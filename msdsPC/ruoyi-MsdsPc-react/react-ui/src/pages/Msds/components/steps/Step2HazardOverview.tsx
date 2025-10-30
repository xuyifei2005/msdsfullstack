import React, { forwardRef, useImperativeHandle, useEffect } from 'react';
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
  Tag,
  Radio,
  message
} from 'antd';
import { 
  InfoCircleOutlined,
  WarningOutlined,
  ExclamationCircleOutlined
} from '@ant-design/icons';
import type { API } from '@/types/msds';
import * as hazardApi from '@/services/msds/hazard';

const { TextArea } = Input;
const { Option } = Select;

interface Step2HazardOverviewProps {
  data?: API.Msds.MsdsHazard;
  onChange?: (data: API.Msds.MsdsHazard) => void;
}

const Step2HazardOverview = forwardRef<any, Step2HazardOverviewProps>(({ data, onChange }, ref) => {
  const [form] = Form.useForm();

  useImperativeHandle(ref, () => ({
    validateFields: () => form.validateFields(),
    getFieldsValue: () => form.getFieldsValue(),
    setFieldsValue: (values: any) => form.setFieldsValue(values)
  }));

  useEffect(() => {
    if (data) {
      form.setFieldsValue(data);
    }
  }, [data, form]);

  // 表单值变化时触发onChange
  const handleValuesChange = (changedValues: any, allValues: any) => {
    if (onChange) {
      onChange(allValues);
    }
  };

  // 警示词选项
  const warningWordOptions = [
    { label: '危险', value: 'danger', color: 'red' },
    { label: '警告', value: 'warning', color: 'orange' }
  ];

  // 物理状态选项
  const physicalStateOptions = [
    '固体', '液体', '气体', '粉末', '颗粒', '蒸气', '悬浮液', '乳状液'
  ];

  // 危险性类别选项
  const hazardCategoryOptions = [
    '易燃液体', '易燃固体', '氧化性液体', '氧化性固体', 
    '有机过氧化物', '腐蚀性物质', '急性毒性', '皮肤腐蚀/刺激',
    '严重眼损伤/眼刺激', '呼吸道或皮肤致敏', '生殖细胞致突变性',
    '致癌性', '生殖毒性', '特定目标器官毒性-一次接触',
    '特定目标器官毒性-反复接触', '吸入危险', '对水生环境的危险'
  ];

  return (
    <Form
      form={form}
      layout="vertical"
      onValuesChange={handleValuesChange}
      autoComplete="off"
    >
      <Alert
        message="第2节：危险性概述"
        description="请详细描述化学品的危险性分类、物理化学危险、健康危害和环境危害等信息。"
        type="warning"
        showIcon
        icon={<WarningOutlined />}
        style={{ marginBottom: 24 }}
      />

      {/* 基本危险性信息 */}
      <Card title="⚠️ 基本危险性信息" size="small" style={{ marginBottom: 16 }}>
        <Form.Item
          label={
            <Space>
              紧急情况概述
              <Tooltip title="简要描述紧急情况下的主要危险">
                <InfoCircleOutlined />
              </Tooltip>
            </Space>
          }
          name="emergencyOverview"
          rules={[{ required: true, message: '请输入紧急情况概述' }]}
        >
          <TextArea 
            placeholder="请描述紧急情况下的主要危险，如火灾、爆炸、中毒等风险" 
            rows={3}
          />
        </Form.Item>

        <Row gutter={16}>
          <Col span={8}>
            <Form.Item
              label="物理状态"
              name="physicalState"
              rules={[{ required: true, message: '请选择物理状态' }]}
            >
              <Select placeholder="请选择物理状态" allowClear>
                {physicalStateOptions.map(state => (
                  <Option key={state} value={state}>{state}</Option>
                ))}
              </Select>
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item
              label="气味"
              name="odor"
            >
              <Input placeholder="请描述气味特征" />
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item
              label="颜色"
              name="color"
            >
              <Input placeholder="请描述颜色" />
            </Form.Item>
          </Col>
        </Row>

        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              label={
                <Space>
                  警示词
                  <Tooltip title="根据危险程度选择相应的警示词">
                    <InfoCircleOutlined />
                  </Tooltip>
                </Space>
              }
              name="warningWord"
            >
              <Radio.Group>
                {warningWordOptions.map(option => (
                  <Radio key={option.value} value={option.value}>
                    <Tag color={option.color}>{option.label}</Tag>
                  </Radio>
                ))}
              </Radio.Group>
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              label="危险性类别"
              name="hazardCategory"
              rules={[{ required: true, message: '请选择危险性类别' }]}
            >
              <Select 
                mode="multiple"
                placeholder="请选择危险性类别（可多选）"
                allowClear
              >
                {hazardCategoryOptions.map(category => (
                  <Option key={category} value={category}>{category}</Option>
                ))}
              </Select>
            </Form.Item>
          </Col>
        </Row>
      </Card>

      {/* 侵入途径和危害 */}
      <Card title="🚨 侵入途径和危害" size="small" style={{ marginBottom: 16 }}>
        <Form.Item
          label={
            <Space>
              侵入途径
              <Tooltip title="化学品进入人体的主要途径">
                <InfoCircleOutlined />
              </Tooltip>
            </Space>
          }
          name="exposureRoutes"
          rules={[{ required: true, message: '请输入侵入途径' }]}
        >
          <Select 
            mode="multiple"
            placeholder="请选择侵入途径（可多选）"
            allowClear
          >
            <Option value="吸入">吸入</Option>
            <Option value="食入">食入</Option>
            <Option value="经皮吸收">经皮吸收</Option>
            <Option value="眼接触">眼接触</Option>
            <Option value="皮肤接触">皮肤接触</Option>
          </Select>
        </Form.Item>

        <Form.Item
          label="健康危害"
          name="healthHazards"
          rules={[{ required: true, message: '请输入健康危害' }]}
        >
          <TextArea 
            placeholder="请详细描述对人体健康的危害，包括急性和慢性影响" 
            rows={4}
          />
        </Form.Item>

        <Form.Item
          label="环境危害"
          name="environmentalHazards"
        >
          <TextArea 
            placeholder="请描述对环境的危害，如对水体、土壤、大气的影响" 
            rows={3}
          />
        </Form.Item>

        <Form.Item
          label="燃爆危险"
          name="fireExplosionHazards"
        >
          <TextArea 
            placeholder="请描述燃烧和爆炸危险性" 
            rows={3}
          />
        </Form.Item>
      </Card>

      {/* 防护措施 */}
      <Card title="🛡️ 防护措施" size="small" style={{ marginBottom: 16 }}>
        <Form.Item
          label="预防措施"
          name="preventionMeasures"
          rules={[{ required: true, message: '请输入预防措施' }]}
        >
          <TextArea 
            placeholder="请描述预防接触和意外释放的措施" 
            rows={3}
          />
        </Form.Item>

        <Form.Item
          label="响应措施"
          name="responseMeasures"
          rules={[{ required: true, message: '请输入响应措施' }]}
        >
          <TextArea 
            placeholder="请描述意外接触或释放时的应急响应措施" 
            rows={3}
          />
        </Form.Item>

        <Form.Item
          label="储存措施"
          name="storageMeasures"
        >
          <TextArea 
            placeholder="请描述安全储存的条件和措施" 
            rows={3}
          />
        </Form.Item>

        <Form.Item
          label="废弃处置措施"
          name="disposalMeasures"
        >
          <TextArea 
            placeholder="请描述安全处置和废弃的方法" 
            rows={3}
          />
        </Form.Item>
      </Card>

      {/* 填写提示 */}
      <Alert
        message="填写提示"
        description={
          <ul style={{ margin: 0, paddingLeft: 20 }}>
            <li>紧急情况概述应简洁明了，突出主要危险</li>
            <li>危险性类别应根据GHS标准进行分类</li>
            <li>健康危害要区分急性和慢性影响</li>
            <li>防护措施应具体可操作</li>
          </ul>
        }
        type="info"
        showIcon
        style={{ marginTop: 16 }}
      />
    </Form>
  );
});

Step2HazardOverview.displayName = 'Step2HazardOverview';

export default Step2HazardOverview;