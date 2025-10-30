import React, { useState, useEffect, forwardRef, useImperativeHandle } from 'react';
import { message } from 'antd';
import * as disposalApi from '@/services/msds/disposal';
import {
  Form,
  Input,
  Select,
  Card,
  Row,
  Col,
  Switch,
  Space,
  Typography,
  Tooltip,
  Tag,
  Alert,
  List,
  Button,
  Divider
} from 'antd';
import { 
  InfoCircleOutlined, 
  DeleteOutlined, 
  WarningOutlined, 
  ReloadOutlined,
  FireOutlined,
  ExclamationCircleOutlined
} from '@ant-design/icons';

const { TextArea } = Input;
const { Option } = Select;
const { Title, Text } = Typography;

export interface Step13DisposalProps {
  data?: any;
  onChange?: (data: any) => void;
}

const Step13Disposal = forwardRef<any, Step13DisposalProps>(
  ({ data = {}, onChange }, ref) => {
    const [form] = Form.useForm();
    const [formData, setFormData] = useState(data);

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
      const newData = { ...formData, ...allFields };
      setFormData(newData);
      onChange?.(newData);
    };

    // 废弃物处理方法选项
    const disposalMethods = [
      { value: 'incineration', label: '焚烧处理', color: 'red', icon: <FireOutlined /> },
      { value: 'landfill', label: '填埋处理', color: 'brown', icon: <DeleteOutlined /> },
      { value: 'recycling', label: '回收利用', color: 'green', icon: <ReloadOutlined /> },
      { value: 'neutralization', label: '中和处理', color: 'blue', icon: <ExclamationCircleOutlined /> },
      { value: 'biological', label: '生物处理', color: 'cyan', icon: <ReloadOutlined /> },
      { value: 'chemical', label: '化学处理', color: 'purple', icon: <ExclamationCircleOutlined /> },
      { value: 'physical', label: '物理处理', color: 'orange', icon: <DeleteOutlined /> }
    ];

    // 废弃物分类选项
    const wasteCategories = [
      '危险废物',
      '一般工业废物',
      '有机废物',
      '无机废物',
      '易燃废物',
      '腐蚀性废物',
      '毒性废物',
      '感染性废物',
      '放射性废物'
    ];

    // 处理设施要求选项
    const facilityRequirements = [
      '有资质的危废处理中心',
      '高温焚烧炉',
      '安全填埋场',
      '化学处理设施',
      '生物处理设施',
      '物理处理设施',
      '中和处理设施',
      '回收利用设施'
    ];

    // 法规要求选项
    const regulatoryRequirements = [
      '《危险废物经营许可证管理办法》',
      '《危险废物转移联单管理办法》',
      '《国家危险废物名录》',
      '《危险废物污染防治技术政策》',
      '《固体废物污染环境防治法》',
      '《环境保护法》',
      '地方环保法规',
      '行业标准'
    ];

    return (
      <div style={{ padding: '24px', backgroundColor: '#f8f9fa' }}>
        <Card>
          <div style={{ marginBottom: '24px' }}>
            <Title level={4} style={{ color: '#1890ff', marginBottom: '8px' }}>
              <DeleteOutlined style={{ marginRight: '8px' }} />
              第13节：废弃处置
            </Title>
            <Text type="secondary">
              包含废弃物处理方法、容器处理、注意事项等废弃处置信息
            </Text>
          </div>

          <Form
            form={form}
            layout="vertical"
            onValuesChange={handleFieldChange}
            initialValues={formData}
          >
            {/* 废弃物分类 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                <WarningOutlined style={{ marginRight: '8px' }} />
                废弃物分类
              </Title>
              
              <Alert
                message="重要提示"
                description="正确的废弃物分类是安全处置的前提，请根据化学品性质进行准确分类。"
                type="warning"
                showIcon
                style={{ marginBottom: '16px' }}
              />

              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label="废弃物类别"
                    name="wasteCategory"
                  >
                    <Select
                      mode="multiple"
                      placeholder="选择废弃物类别"
                      style={{ width: '100%' }}
                    >
                      {wasteCategories.map(category => (
                        <Option key={category} value={category}>
                          {category}
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="危险废物代码"
                    name="hazardousWasteCode"
                  >
                    <Input placeholder="如：HW06" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="危险特性"
                    name="hazardousCharacteristics"
                  >
                    <Select
                      mode="multiple"
                      placeholder="选择危险特性"
                    >
                      <Option value="T">毒性 (T)</Option>
                      <Option value="C">腐蚀性 (C)</Option>
                      <Option value="I">易燃性 (I)</Option>
                      <Option value="R">反应性 (R)</Option>
                      <Option value="In">感染性 (In)</Option>
                    </Select>
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="分类依据"
                name="classificationBasis"
              >
                <TextArea
                  rows={2}
                  placeholder="请说明废弃物分类的依据和标准"
                />
              </Form.Item>
            </Card>

            {/* 处理方法 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                <ReloadOutlined style={{ marginRight: '8px' }} />
                处理方法
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label="推荐处理方法"
                    name="recommendedDisposal"
                  >
                    <Select
                      mode="multiple"
                      placeholder="选择处理方法"
                      style={{ width: '100%' }}
                    >
                      {disposalMethods.map(method => (
                        <Option key={method.value} value={method.value}>
                          <Space>
                            {method.icon}
                            <Tag color={method.color}>{method.label}</Tag>
                          </Space>
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="禁止的处理方法"
                    name="prohibitedDisposal"
                  >
                    <Select
                      mode="multiple"
                      placeholder="选择禁止的方法"
                      style={{ width: '100%' }}
                    >
                      {disposalMethods.map(method => (
                        <Option key={method.value} value={method.value}>
                          <Space>
                            {method.icon}
                            <Tag color={method.color}>{method.label}</Tag>
                          </Space>
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="处理方法详细说明"
                name="disposalMethodDescription"
              >
                <TextArea
                  rows={4}
                  placeholder="请详细描述推荐的处理方法、操作步骤、注意事项等"
                />
              </Form.Item>
            </Card>

            {/* 处理设施要求 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                处理设施要求
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label="处理设施类型"
                    name="facilityType"
                  >
                    <Select
                      mode="multiple"
                      placeholder="选择设施类型"
                      style={{ width: '100%' }}
                    >
                      {facilityRequirements.map(facility => (
                        <Option key={facility} value={facility}>
                          {facility}
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="资质要求"
                    name="qualificationRequirements"
                  >
                    <Input placeholder="如：危险废物经营许可证" />
                  </Form.Item>
                </Col>
              </Row>

              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label="处理温度要求"
                    name="temperatureRequirement"
                  >
                    <Input placeholder="如：>1100°C" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="处理时间要求"
                    name="timeRequirement"
                  >
                    <Input placeholder="如：>2小时" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="其他技术要求"
                    name="otherRequirements"
                  >
                    <Input placeholder="如：烟气处理系统" />
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="设施要求说明"
                name="facilityDescription"
              >
                <TextArea
                  rows={3}
                  placeholder="请详细描述处理设施的技术要求、安全要求等"
                />
              </Form.Item>
            </Card>

            {/* 容器处理 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                容器处理
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label="容器清洗"
                    name="containerCleaning"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="需要" unCheckedChildren="不需要" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="容器回收"
                    name="containerRecycling"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="可回收" unCheckedChildren="不可回收" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="容器处置"
                    name="containerDisposal"
                  >
                    <Select placeholder="选择处置方式">
                      <Option value="same_as_content">与内容物同样处理</Option>
                      <Option value="separate_treatment">单独处理</Option>
                      <Option value="recycling">回收利用</Option>
                      <Option value="landfill">填埋处理</Option>
                    </Select>
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="容器处理说明"
                name="containerDescription"
              >
                <TextArea
                  rows={3}
                  placeholder="请描述容器的清洗方法、处理要求、注意事项等"
                />
              </Form.Item>
            </Card>

            {/* 预处理要求 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                预处理要求
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label="需要预处理"
                    name="pretreatmentRequired"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="是" unCheckedChildren="否" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="中和处理"
                    name="neutralizationRequired"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="需要" unCheckedChildren="不需要" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="稀释处理"
                    name="dilutionRequired"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="需要" unCheckedChildren="不需要" />
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="预处理方法"
                name="pretreatmentMethod"
              >
                <TextArea
                  rows={3}
                  placeholder="请详细描述预处理的具体方法、步骤、注意事项等"
                />
              </Form.Item>
            </Card>

            {/* 法规要求 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                法规要求
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label="适用法规"
                    name="applicableRegulations"
                  >
                    <Select
                      mode="multiple"
                      placeholder="选择适用法规"
                      style={{ width: '100%' }}
                    >
                      {regulatoryRequirements.map(regulation => (
                        <Option key={regulation} value={regulation}>
                          {regulation}
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="转移联单"
                    name="transferManifest"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="需要" unCheckedChildren="不需要" />
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="法规要求说明"
                name="regulatoryDescription"
              >
                <TextArea
                  rows={3}
                  placeholder="请说明相关法规的具体要求、手续办理等"
                />
              </Form.Item>
            </Card>

            {/* 安全注意事项 */}
            <Card size="small">
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                <ExclamationCircleOutlined style={{ marginRight: '8px' }} />
                安全注意事项
              </Title>
              
              <Alert
                message="安全警告"
                description="废弃物处理过程中可能产生有害气体或发生危险反应，必须采取适当的安全防护措施。"
                type="error"
                showIcon
                style={{ marginBottom: '16px' }}
              />

              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label="防护设备"
                    name="protectiveEquipment"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="必需" unCheckedChildren="不需要" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="通风要求"
                    name="ventilationRequired"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="必需" unCheckedChildren="不需要" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="环境监测"
                    name="environmentalMonitoring"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="必需" unCheckedChildren="不需要" />
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="安全防护措施"
                name="safetyPrecautions"
              >
                <TextArea
                  rows={3}
                  placeholder="请详细描述处理过程中的安全防护措施、应急处理等"
                />
              </Form.Item>

              <Form.Item
                label="环境保护措施"
                name="environmentalProtection"
              >
                <TextArea
                  rows={3}
                  placeholder="请描述防止环境污染的措施、监测要求等"
                />
              </Form.Item>

              <Form.Item
                label="其他注意事项"
                name="otherPrecautions"
              >
                <TextArea
                  rows={3}
                  placeholder="请描述其他重要的注意事项、特殊要求等"
                />
              </Form.Item>
            </Card>
          </Form>
        </Card>
      </div>
    );
  }
);

Step13Disposal.displayName = 'Step13Disposal';

export default Step13Disposal;