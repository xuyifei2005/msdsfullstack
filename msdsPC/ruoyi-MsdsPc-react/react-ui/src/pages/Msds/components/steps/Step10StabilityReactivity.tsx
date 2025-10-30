import React, { useState, useEffect, forwardRef, useImperativeHandle } from 'react';
import { message } from 'antd';
import * as stabilityReactivityApi from '@/services/msds/stabilityReactivity';
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
  Divider
} from 'antd';
import { 
  InfoCircleOutlined, 
  ExclamationCircleOutlined, 
  FireOutlined, 
  ThunderboltOutlined,
  WarningOutlined 
} from '@ant-design/icons';

const { TextArea } = Input;
const { Option } = Select;
const { Title, Text } = Typography;

export interface Step10StabilityReactivityProps {
  data?: any;
  onChange?: (data: any) => void;
}

const Step10StabilityReactivity = forwardRef<any, Step10StabilityReactivityProps>(
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

    // 稳定性等级选项
    const stabilityLevels = [
      { value: 'stable', label: '稳定', color: 'green' },
      { value: 'relatively_stable', label: '相对稳定', color: 'blue' },
      { value: 'unstable', label: '不稳定', color: 'orange' },
      { value: 'highly_unstable', label: '高度不稳定', color: 'red' }
    ];

    // 反应性等级选项
    const reactivityLevels = [
      { value: 'low', label: '低反应性', color: 'green' },
      { value: 'moderate', label: '中等反应性', color: 'blue' },
      { value: 'high', label: '高反应性', color: 'orange' },
      { value: 'extreme', label: '极高反应性', color: 'red' }
    ];

    // 应避免的条件选项
    const avoidConditions = [
      '高温',
      '低温',
      '明火',
      '火花',
      '静电',
      '强光',
      '紫外线',
      '震动',
      '撞击',
      '摩擦',
      '空气',
      '水分',
      '湿度',
      '氧气',
      '酸性条件',
      '碱性条件'
    ];

    // 常见禁配物选项
    const incompatibleMaterials = [
      '强氧化剂',
      '强还原剂',
      '强酸',
      '强碱',
      '活性金属',
      '卤素',
      '过氧化物',
      '金属粉末',
      '有机过氧化物',
      '氨',
      '胺类',
      '醇类',
      '酮类',
      '醛类',
      '酸酐',
      '酰氯'
    ];

    // 分解产物选项
    const decompositionProducts = [
      '一氧化碳',
      '二氧化碳',
      '氮氧化物',
      '硫氧化物',
      '氯化氢',
      '氟化氢',
      '溴化氢',
      '碘化氢',
      '氨气',
      '硫化氢',
      '氰化氢',
      '光气',
      '甲醛',
      '丙烯醛',
      '有毒气体',
      '腐蚀性气体'
    ];

    return (
      <div style={{ padding: '24px', backgroundColor: '#f8f9fa' }}>
        <Card>
          <div style={{ marginBottom: '24px' }}>
            <Title level={4} style={{ color: '#1890ff', marginBottom: '8px' }}>
              <ThunderboltOutlined style={{ marginRight: '8px' }} />
              第10节：稳定性和反应性
            </Title>
            <Text type="secondary">
              包含化学稳定性、聚合危害、应避免的条件、禁配物、分解产物等信息
            </Text>
          </div>

          <Form
            form={form}
            layout="vertical"
            onValuesChange={handleFieldChange}
            initialValues={formData}
          >
            {/* 稳定性评估 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                <ExclamationCircleOutlined style={{ marginRight: '8px' }} />
                稳定性评估
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label="化学稳定性"
                    name="chemicalStability"
                  >
                    <Select placeholder="选择稳定性等级">
                      {stabilityLevels.map(level => (
                        <Option key={level.value} value={level.value}>
                          <Tag color={level.color}>{level.label}</Tag>
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="反应性"
                    name="reactivity"
                  >
                    <Select placeholder="选择反应性等级">
                      {reactivityLevels.map(level => (
                        <Option key={level.value} value={level.value}>
                          <Tag color={level.color}>{level.label}</Tag>
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label={
                      <Space>
                        危险聚合
                        <Tooltip title="是否可能发生危险的聚合反应">
                          <InfoCircleOutlined style={{ color: '#1890ff' }} />
                        </Tooltip>
                      </Space>
                    }
                    name="hazardousPolymerization"
                    valuePropName="checked"
                  >
                    <Switch 
                      checkedChildren="可能发生" 
                      unCheckedChildren="不会发生"
                      style={{ backgroundColor: formData.hazardousPolymerization ? '#ff4d4f' : '#52c41a' }}
                    />
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="稳定性说明"
                name="stabilityDescription"
              >
                <TextArea
                  rows={3}
                  placeholder="请详细描述化学品的稳定性，包括在正常条件下的稳定性、储存稳定性等"
                />
              </Form.Item>
            </Card>

            {/* 应避免的条件 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                <WarningOutlined style={{ marginRight: '8px' }} />
                应避免的条件
              </Title>
              
              <Alert
                message="重要提示"
                description="以下条件可能导致化学品分解、聚合或产生危险反应，应严格避免。"
                type="warning"
                showIcon
                style={{ marginBottom: '16px' }}
              />

              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label="应避免的条件"
                    name="avoidConditions"
                  >
                    <Select
                      mode="multiple"
                      placeholder="选择应避免的条件"
                      style={{ width: '100%' }}
                    >
                      {avoidConditions.map(condition => (
                        <Option key={condition} value={condition}>
                          {condition}
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="临界温度 (°C)"
                    name="criticalTemperature"
                  >
                    <Input placeholder="如：>50°C时开始分解" />
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="条件详细说明"
                name="conditionsDescription"
              >
                <TextArea
                  rows={3}
                  placeholder="请详细描述应避免的条件及其可能造成的后果"
                />
              </Form.Item>
            </Card>

            {/* 禁配物 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                <FireOutlined style={{ marginRight: '8px' }} />
                禁配物
              </Title>
              
              <Alert
                message="危险警告"
                description="以下物质与本化学品接触可能发生危险反应，严禁混合储存或使用。"
                type="error"
                showIcon
                style={{ marginBottom: '16px' }}
              />

              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label="禁配物类别"
                    name="incompatibleMaterials"
                  >
                    <Select
                      mode="multiple"
                      placeholder="选择禁配物类别"
                      style={{ width: '100%' }}
                    >
                      {incompatibleMaterials.map(material => (
                        <Option key={material} value={material}>
                          {material}
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="反应类型"
                    name="reactionType"
                  >
                    <Select
                      mode="multiple"
                      placeholder="选择可能的反应类型"
                    >
                      <Option value="violent_reaction">剧烈反应</Option>
                      <Option value="fire_explosion">火灾爆炸</Option>
                      <Option value="toxic_gas">产生有毒气体</Option>
                      <Option value="corrosive_reaction">腐蚀反应</Option>
                      <Option value="polymerization">聚合反应</Option>
                      <Option value="decomposition">分解反应</Option>
                    </Select>
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="具体禁配物"
                name="specificIncompatibles"
              >
                <TextArea
                  rows={3}
                  placeholder="请列出具体的禁配物质名称及其可能的反应后果"
                />
              </Form.Item>
            </Card>

            {/* 分解产物 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                分解产物
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label="危险分解产物"
                    name="hazardousDecomposition"
                  >
                    <Select
                      mode="multiple"
                      placeholder="选择可能的分解产物"
                      style={{ width: '100%' }}
                    >
                      {decompositionProducts.map(product => (
                        <Option key={product} value={product}>
                          {product}
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="分解温度 (°C)"
                    name="decompositionTemperature"
                  >
                    <Input placeholder="如：>200°C开始分解" />
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="分解产物说明"
                name="decompositionDescription"
              >
                <TextArea
                  rows={3}
                  placeholder="请详细描述分解条件、分解产物及其危害性"
                />
              </Form.Item>
            </Card>

            {/* 其他反应性信息 */}
            <Card size="small">
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                其他反应性信息
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label="氧化性"
                    name="oxidizing"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="是" unCheckedChildren="否" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="还原性"
                    name="reducing"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="是" unCheckedChildren="否" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="自反应性"
                    name="selfReactive"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="是" unCheckedChildren="否" />
                  </Form.Item>
                </Col>
              </Row>

              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label="遇水反应"
                    name="waterReactive"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="是" unCheckedChildren="否" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="遇酸反应"
                    name="acidReactive"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="是" unCheckedChildren="否" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="光敏性"
                    name="photosensitive"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="是" unCheckedChildren="否" />
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="反应机理"
                name="reactionMechanism"
              >
                <TextArea
                  rows={3}
                  placeholder="请描述主要的反应机理、反应速率、催化条件等"
                />
              </Form.Item>

              <Form.Item
                label="储存兼容性"
                name="storageCompatibility"
              >
                <TextArea
                  rows={3}
                  placeholder="请描述与其他化学品的储存兼容性要求"
                />
              </Form.Item>

              <Form.Item
                label="其他注意事项"
                name="otherPrecautions"
              >
                <TextArea
                  rows={3}
                  placeholder="请描述其他重要的稳定性和反应性注意事项"
                />
              </Form.Item>
            </Card>
          </Form>
        </Card>
      </div>
    );
  }
);

Step10StabilityReactivity.displayName = 'Step10StabilityReactivity';

export default Step10StabilityReactivity;