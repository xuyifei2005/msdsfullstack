import React, { useState, useEffect, forwardRef, useImperativeHandle } from 'react';
import { message } from 'antd';
import * as transportApi from '@/services/msds/transport';
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
  InputNumber,
  Divider
} from 'antd';
import { 
  InfoCircleOutlined, 
  TruckOutlined, 
  WarningOutlined, 
  GlobalOutlined,
  SafetyOutlined,
  ExclamationCircleOutlined
} from '@ant-design/icons';

const { TextArea } = Input;
const { Option } = Select;
const { Title, Text } = Typography;

export interface Step14TransportationProps {
  data?: any;
  onChange?: (data: any) => void;
}

const Step14Transportation = forwardRef<any, Step14TransportationProps>(
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

    // 危险性类别选项
    const hazardClasses = [
      { value: '1', label: '第1类 - 爆炸品', color: 'red' },
      { value: '2', label: '第2类 - 气体', color: 'orange' },
      { value: '3', label: '第3类 - 易燃液体', color: 'yellow' },
      { value: '4.1', label: '第4.1类 - 易燃固体', color: 'blue' },
      { value: '4.2', label: '第4.2类 - 自燃物质', color: 'green' },
      { value: '4.3', label: '第4.3类 - 遇水放出易燃气体的物质', color: 'cyan' },
      { value: '5.1', label: '第5.1类 - 氧化性物质', color: 'purple' },
      { value: '5.2', label: '第5.2类 - 有机过氧化物', color: 'magenta' },
      { value: '6.1', label: '第6.1类 - 毒性物质', color: 'red' },
      { value: '6.2', label: '第6.2类 - 感染性物质', color: 'orange' },
      { value: '7', label: '第7类 - 放射性物质', color: 'yellow' },
      { value: '8', label: '第8类 - 腐蚀性物质', color: 'blue' },
      { value: '9', label: '第9类 - 杂类危险物质', color: 'green' }
    ];

    // 包装类别选项
    const packingGroups = [
      { value: 'I', label: '包装类别I - 高危险', color: 'red' },
      { value: 'II', label: '包装类别II - 中危险', color: 'orange' },
      { value: 'III', label: '包装类别III - 低危险', color: 'yellow' }
    ];

    // 运输方式选项
    const transportModes = [
      { value: 'road', label: '公路运输', icon: <TruckOutlined /> },
      { value: 'rail', label: '铁路运输', icon: <TruckOutlined /> },
      { value: 'air', label: '航空运输', icon: <GlobalOutlined /> },
      { value: 'sea', label: '海运', icon: <GlobalOutlined /> },
      { value: 'inland_waterway', label: '内河运输', icon: <GlobalOutlined /> }
    ];

    // 包装要求选项
    const packagingRequirements = [
      'UN规格包装',
      '组合包装',
      '大包装',
      '中型散装容器(IBC)',
      '大型包装',
      '散装运输',
      '罐式运输',
      '特殊包装'
    ];

    // 运输限制选项
    const transportRestrictions = [
      '限量运输',
      '例外数量',
      '客运飞机禁运',
      '货运飞机限制',
      '隧道限制',
      '海运限制',
      '特殊规定',
      '温度控制'
    ];

    return (
      <div style={{ padding: '24px', backgroundColor: '#f8f9fa' }}>
        <Card>
          <div style={{ marginBottom: '24px' }}>
            <Title level={4} style={{ color: '#1890ff', marginBottom: '8px' }}>
              <TruckOutlined style={{ marginRight: '8px' }} />
              第14节：运输信息
            </Title>
            <Text type="secondary">
              包含UN编号、运输名称、危险性类别、包装类别、运输注意事项等运输相关信息
            </Text>
          </div>

          <Form
            form={form}
            layout="vertical"
            onValuesChange={handleFieldChange}
            initialValues={formData}
          >
            {/* 基本运输信息 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                <GlobalOutlined style={{ marginRight: '8px' }} />
                基本运输信息
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label={
                      <Space>
                        UN编号
                        <Tooltip title="联合国危险货物编号">
                          <InfoCircleOutlined style={{ color: '#1890ff' }} />
                        </Tooltip>
                      </Space>
                    }
                    name="unNumber"
                  >
                    <Input placeholder="如：UN1230" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="危险性类别"
                    name="hazardClass"
                  >
                    <Select placeholder="选择危险性类别">
                      {hazardClasses.map(cls => (
                        <Option key={cls.value} value={cls.value}>
                          <Tag color={cls.color}>{cls.label}</Tag>
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="包装类别"
                    name="packingGroup"
                  >
                    <Select placeholder="选择包装类别">
                      {packingGroups.map(group => (
                        <Option key={group.value} value={group.value}>
                          <Tag color={group.color}>{group.label}</Tag>
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
              </Row>

              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label="联合国运输名称"
                    name="properShippingName"
                  >
                    <Input placeholder="请输入标准运输名称" />
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="技术名称"
                    name="technicalName"
                  >
                    <Input placeholder="请输入技术名称" />
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="运输危险性描述"
                name="transportHazardDescription"
              >
                <TextArea
                  rows={2}
                  placeholder="请描述运输过程中的主要危险性"
                />
              </Form.Item>
            </Card>

            {/* 运输方式限制 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                <TruckOutlined style={{ marginRight: '8px' }} />
                运输方式限制
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label="允许的运输方式"
                    name="allowedTransportModes"
                  >
                    <Select
                      mode="multiple"
                      placeholder="选择允许的运输方式"
                      style={{ width: '100%' }}
                    >
                      {transportModes.map(mode => (
                        <Option key={mode.value} value={mode.value}>
                          <Space>
                            {mode.icon}
                            {mode.label}
                          </Space>
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="运输限制"
                    name="transportRestrictions"
                  >
                    <Select
                      mode="multiple"
                      placeholder="选择运输限制"
                      style={{ width: '100%' }}
                    >
                      {transportRestrictions.map(restriction => (
                        <Option key={restriction} value={restriction}>
                          {restriction}
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
              </Row>

              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label="客运飞机"
                    name="passengerAircraft"
                  >
                    <Select placeholder="选择限制类型">
                      <Option value="allowed">允许</Option>
                      <Option value="restricted">限制</Option>
                      <Option value="prohibited">禁止</Option>
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="货运飞机"
                    name="cargoAircraft"
                  >
                    <Select placeholder="选择限制类型">
                      <Option value="allowed">允许</Option>
                      <Option value="restricted">限制</Option>
                      <Option value="prohibited">禁止</Option>
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="海运"
                    name="seaTransport"
                  >
                    <Select placeholder="选择限制类型">
                      <Option value="allowed">允许</Option>
                      <Option value="restricted">限制</Option>
                      <Option value="prohibited">禁止</Option>
                    </Select>
                  </Form.Item>
                </Col>
              </Row>
            </Card>

            {/* 包装要求 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                <SafetyOutlined style={{ marginRight: '8px' }} />
                包装要求
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label="包装类型"
                    name="packagingType"
                  >
                    <Select
                      mode="multiple"
                      placeholder="选择包装类型"
                      style={{ width: '100%' }}
                    >
                      {packagingRequirements.map(req => (
                        <Option key={req} value={req}>
                          {req}
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="包装标记"
                    name="packagingMarking"
                  >
                    <Input placeholder="如：UN1230, II, 8" />
                  </Form.Item>
                </Col>
              </Row>

              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label="最大净重 (kg)"
                    name="maxNetWeight"
                  >
                    <InputNumber
                      style={{ width: '100%' }}
                      placeholder="请输入最大净重"
                      min={0}
                      precision={2}
                    />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="最大毛重 (kg)"
                    name="maxGrossWeight"
                  >
                    <InputNumber
                      style={{ width: '100%' }}
                      placeholder="请输入最大毛重"
                      min={0}
                      precision={2}
                    />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="包装指导代码"
                    name="packingInstruction"
                  >
                    <Input placeholder="如：P001" />
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="包装要求说明"
                name="packagingDescription"
              >
                <TextArea
                  rows={3}
                  placeholder="请详细描述包装要求、材料规格、密封要求等"
                />
              </Form.Item>
            </Card>

            {/* 运输注意事项 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                <WarningOutlined style={{ marginRight: '8px' }} />
                运输注意事项
              </Title>
              
              <Alert
                message="重要提示"
                description="运输危险化学品时必须严格遵守相关法规要求，确保运输安全。"
                type="warning"
                showIcon
                style={{ marginBottom: '16px' }}
              />

              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label="温度控制"
                    name="temperatureControl"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="需要" unCheckedChildren="不需要" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="避光运输"
                    name="lightProtection"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="需要" unCheckedChildren="不需要" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="防震要求"
                    name="shockProtection"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="需要" unCheckedChildren="不需要" />
                  </Form.Item>
                </Col>
              </Row>

              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label="运输温度范围 (°C)"
                    name="transportTemperatureRange"
                  >
                    <Input placeholder="如：-10°C ~ +40°C" />
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="运输湿度要求"
                    name="humidityRequirement"
                  >
                    <Input placeholder="如：相对湿度 < 80%" />
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="装卸注意事项"
                name="handlingPrecautions"
              >
                <TextArea
                  rows={3}
                  placeholder="请描述装卸过程中的注意事项、安全要求等"
                />
              </Form.Item>

              <Form.Item
                label="运输过程注意事项"
                name="transportPrecautions"
              >
                <TextArea
                  rows={3}
                  placeholder="请描述运输过程中的注意事项、路线选择、时间限制等"
                />
              </Form.Item>
            </Card>

            {/* 应急处理 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                <ExclamationCircleOutlined style={{ marginRight: '8px' }} />
                运输应急处理
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label="应急响应指南编号"
                    name="emergencyResponseGuide"
                  >
                    <Input placeholder="如：ERG 154" />
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="应急联系电话"
                    name="emergencyPhone"
                  >
                    <Input placeholder="请输入24小时应急电话" />
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="泄漏应急处理"
                name="spillEmergencyResponse"
              >
                <TextArea
                  rows={3}
                  placeholder="请描述运输过程中发生泄漏时的应急处理措施"
                />
              </Form.Item>

              <Form.Item
                label="火灾应急处理"
                name="fireEmergencyResponse"
              >
                <TextArea
                  rows={3}
                  placeholder="请描述运输过程中发生火灾时的应急处理措施"
                />
              </Form.Item>
            </Card>

            {/* 法规符合性 */}
            <Card size="small">
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                法规符合性
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label="ADR (欧洲)"
                    name="adrCompliance"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="符合" unCheckedChildren="不适用" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="IATA (航空)"
                    name="iataCompliance"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="符合" unCheckedChildren="不适用" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="IMDG (海运)"
                    name="imdgCompliance"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="符合" unCheckedChildren="不适用" />
                  </Form.Item>
                </Col>
              </Row>

              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label="中国法规"
                    name="chinaRegulations"
                  >
                    <Select
                      mode="multiple"
                      placeholder="选择适用的中国法规"
                    >
                      <Option value="jt617">JT 617 汽车运输危险货物规则</Option>
                      <Option value="jt618">JT 618 汽车运输、装卸危险货物作业规程</Option>
                      <Option value="gb6944">GB 6944 危险货物分类和品名编号</Option>
                      <Option value="gb190">GB 190 危险货物包装标志</Option>
                      <Option value="other">其他法规</Option>
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="其他国际法规"
                    name="otherInternationalRegulations"
                  >
                    <Input placeholder="如：RID, ADN等" />
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="法规符合性说明"
                name="regulatoryCompliance"
              >
                <TextArea
                  rows={3}
                  placeholder="请说明符合的具体法规条款和要求"
                />
              </Form.Item>

              <Form.Item
                label="其他运输信息"
                name="otherTransportInfo"
              >
                <TextArea
                  rows={3}
                  placeholder="请提供其他重要的运输信息、特殊要求等"
                />
              </Form.Item>
            </Card>
          </Form>
        </Card>
      </div>
    );
  }
);

Step14Transportation.displayName = 'Step14Transportation';

export default Step14Transportation;