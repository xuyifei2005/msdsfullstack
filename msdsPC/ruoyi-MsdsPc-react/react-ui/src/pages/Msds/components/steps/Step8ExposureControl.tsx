import React, { useState, useEffect, forwardRef, useImperativeHandle } from 'react';
import { message } from 'antd';
import * as exposureApi from '@/services/msds/exposure';
import {
  Form,
  Input,
  Select,
  Card,
  Row,
  Col,
  InputNumber,
  Switch,
  Space,
  Typography,
  Divider,
  Tag,
  Tooltip
} from 'antd';
import { InfoCircleOutlined, SafetyOutlined, EyeOutlined } from '@ant-design/icons';

const { TextArea } = Input;
const { Option } = Select;
const { Title, Text } = Typography;

export interface Step8ExposureControlProps {
  data?: any;
  onChange?: (data: any) => void;
}

const Step8ExposureControl = forwardRef<any, Step8ExposureControlProps>(
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

    // 职业接触限值单位选项
    const limitUnits = [
      { value: 'mg/m³', label: 'mg/m³' },
      { value: 'ppm', label: 'ppm' },
      { value: 'ppb', label: 'ppb' },
      { value: 'mg/kg', label: 'mg/kg' },
      { value: 'μg/m³', label: 'μg/m³' }
    ];

    // 防护等级选项
    const protectionLevels = [
      { value: 'A', label: 'A级 - 最高防护' },
      { value: 'B', label: 'B级 - 呼吸防护' },
      { value: 'C', label: 'C级 - 空气净化' },
      { value: 'D', label: 'D级 - 工作制服' }
    ];

    // 监测方法选项
    const monitoringMethods = [
      '个人采样',
      '定点采样',
      '连续监测',
      '便携式检测',
      '实验室分析',
      '生物监测'
    ];

    return (
      <div style={{ padding: '24px', backgroundColor: '#f8f9fa' }}>
        <Card>
          <div style={{ marginBottom: '24px' }}>
            <Title level={4} style={{ color: '#1890ff', marginBottom: '8px' }}>
              <SafetyOutlined style={{ marginRight: '8px' }} />
              第8节：接触控制/个体防护
            </Title>
            <Text type="secondary">
              包含职业接触限值、监测方法、工程控制措施、个体防护装备等信息
            </Text>
          </div>

          <Form
            form={form}
            layout="vertical"
            onValuesChange={handleFieldChange}
            initialValues={formData}
          >
            {/* 职业接触限值 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                <EyeOutlined style={{ marginRight: '8px' }} />
                职业接触限值
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label={
                      <Space>
                        时间加权平均浓度(TWA)
                        <Tooltip title="8小时工作日的时间加权平均浓度">
                          <InfoCircleOutlined style={{ color: '#1890ff' }} />
                        </Tooltip>
                      </Space>
                    }
                    name="twaValue"
                  >
                    <InputNumber
                      style={{ width: '100%' }}
                      placeholder="请输入数值"
                      min={0}
                      precision={3}
                    />
                  </Form.Item>
                </Col>
                <Col span={4}>
                  <Form.Item label="单位" name="twaUnit">
                    <Select placeholder="选择单位">
                      {limitUnits.map(unit => (
                        <Option key={unit.value} value={unit.value}>
                          {unit.label}
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={6}>
                  <Form.Item
                    label={
                      <Space>
                        短时间接触浓度(STEL)
                        <Tooltip title="15分钟短时间接触浓度限值">
                          <InfoCircleOutlined style={{ color: '#1890ff' }} />
                        </Tooltip>
                      </Space>
                    }
                    name="stelValue"
                  >
                    <InputNumber
                      style={{ width: '100%' }}
                      placeholder="请输入数值"
                      min={0}
                      precision={3}
                    />
                  </Form.Item>
                </Col>
                <Col span={6}>
                  <Form.Item label="单位" name="stelUnit">
                    <Select placeholder="选择单位">
                      {limitUnits.map(unit => (
                        <Option key={unit.value} value={unit.value}>
                          {unit.label}
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
              </Row>

              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label={
                      <Space>
                        最高容许浓度(MAC)
                        <Tooltip title="工作场所有害因素最高容许浓度">
                          <InfoCircleOutlined style={{ color: '#1890ff' }} />
                        </Tooltip>
                      </Space>
                    }
                    name="macValue"
                  >
                    <InputNumber
                      style={{ width: '100%' }}
                      placeholder="请输入数值"
                      min={0}
                      precision={3}
                    />
                  </Form.Item>
                </Col>
                <Col span={4}>
                  <Form.Item label="单位" name="macUnit">
                    <Select placeholder="选择单位">
                      {limitUnits.map(unit => (
                        <Option key={unit.value} value={unit.value}>
                          {unit.label}
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="生物限值"
                    name="biologicalLimit"
                  >
                    <Input placeholder="请输入生物限值及单位" />
                  </Form.Item>
                </Col>
              </Row>
            </Card>

            {/* 监测方法 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                监测方法
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label="监测方法"
                    name="monitoringMethods"
                  >
                    <Select
                      mode="multiple"
                      placeholder="选择监测方法"
                      style={{ width: '100%' }}
                    >
                      {monitoringMethods.map(method => (
                        <Option key={method} value={method}>
                          {method}
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="监测频率"
                    name="monitoringFrequency"
                  >
                    <Input placeholder="如：每日、每周、每月等" />
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="监测方法详细说明"
                name="monitoringDescription"
              >
                <TextArea
                  rows={3}
                  placeholder="请详细描述监测方法、检测仪器、采样要求等"
                />
              </Form.Item>
            </Card>

            {/* 工程控制 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                工程控制
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label="通风系统"
                    name="ventilationSystem"
                  >
                    <Select placeholder="选择通风系统类型">
                      <Option value="natural">自然通风</Option>
                      <Option value="mechanical">机械通风</Option>
                      <Option value="local_exhaust">局部排风</Option>
                      <Option value="dilution">稀释通风</Option>
                      <Option value="combination">组合通风</Option>
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="通风量要求"
                    name="ventilationRate"
                  >
                    <Input placeholder="如：≥10次/小时" />
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="工程控制措施"
                name="engineeringControls"
              >
                <TextArea
                  rows={4}
                  placeholder="请描述密闭操作、局部排风、通风系统、自动化控制等工程控制措施"
                />
              </Form.Item>
            </Card>

            {/* 个体防护 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                个体防护装备
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label="防护等级"
                    name="protectionLevel"
                  >
                    <Select placeholder="选择防护等级">
                      {protectionLevels.map(level => (
                        <Option key={level.value} value={level.value}>
                          {level.label}
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="呼吸系统防护"
                    name="respiratoryProtection"
                  >
                    <Input placeholder="如：过滤式防毒面具、供气式呼吸器等" />
                  </Form.Item>
                </Col>
              </Row>

              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label="眼睛防护"
                    name="eyeProtection"
                  >
                    <Input placeholder="如：化学安全防护眼镜、面罩等" />
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="身体防护"
                    name="bodyProtection"
                  >
                    <Input placeholder="如：防化服、防渗透工作服等" />
                  </Form.Item>
                </Col>
              </Row>

              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label="手部防护"
                    name="handProtection"
                  >
                    <Input placeholder="如：防化学品手套、丁腈手套等" />
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="足部防护"
                    name="footProtection"
                  >
                    <Input placeholder="如：防化学品靴、防滑鞋等" />
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="其他防护要求"
                name="otherProtection"
              >
                <TextArea
                  rows={3}
                  placeholder="请描述其他特殊防护要求、防护装备使用注意事项等"
                />
              </Form.Item>
            </Card>

            {/* 特殊防护措施 */}
            <Card size="small">
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                特殊防护措施
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label="应急淋浴"
                    name="emergencyShower"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="必需" unCheckedChildren="不需要" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="洗眼器"
                    name="eyeWash"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="必需" unCheckedChildren="不需要" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="防爆设备"
                    name="explosionProof"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="必需" unCheckedChildren="不需要" />
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="工作场所禁止事项"
                name="workplaceRestrictions"
              >
                <TextArea
                  rows={3}
                  placeholder="请描述工作场所禁止的行为，如：禁止吸烟、饮食、接触明火等"
                />
              </Form.Item>

              <Form.Item
                label="特殊作业要求"
                name="specialRequirements"
              >
                <TextArea
                  rows={3}
                  placeholder="请描述特殊作业环境的要求，如：密闭空间作业、高温作业等的特殊防护要求"
                />
              </Form.Item>
            </Card>
          </Form>
        </Card>
      </div>
    );
  }
);

Step8ExposureControl.displayName = 'Step8ExposureControl';

export default Step8ExposureControl;