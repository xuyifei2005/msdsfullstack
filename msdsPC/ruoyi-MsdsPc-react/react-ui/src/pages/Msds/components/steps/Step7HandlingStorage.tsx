import React, { forwardRef, useImperativeHandle, useEffect } from 'react';
import { message } from 'antd';
import * as handlingApi from '@/services/msds/handling';
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
  Switch,
  Checkbox,
  Tag
} from 'antd';
import { 
  InfoCircleOutlined,
  SettingOutlined,
  WarningOutlined,
  SafetyOutlined,
  ContainerOutlined
} from '@ant-design/icons';
import type { API } from '@/types/msds';

const { TextArea } = Input;
const { Option } = Select;
const { Group: CheckboxGroup } = Checkbox;

interface Step7HandlingStorageProps {
  data?: API.Msds.MsdsHandlingStorage;
  onChange?: (data: API.Msds.MsdsHandlingStorage) => void;
}

const Step7HandlingStorage = forwardRef<any, Step7HandlingStorageProps>(({ data, onChange }, ref) => {
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

  // 容器材质选项
  const containerMaterialOptions = [
    '聚乙烯', '聚丙烯', '玻璃', '不锈钢', '碳钢', '铝', '陶瓷', '橡胶内衬'
  ];

  // 不相容材料选项
  const incompatibleMaterialOptions = [
    '铜', '铝', '铁', '锌', '橡胶', '某些塑料', '某些金属', '氧化性材料', '还原性材料'
  ];

  // 储存类别选项
  const storageClassOptions = [
    { value: 'A', label: 'A类 - 非危险品' },
    { value: 'B', label: 'B类 - 易燃液体' },
    { value: 'C', label: 'C类 - 易燃固体' },
    { value: 'D', label: 'D类 - 氧化性物质' },
    { value: 'E', label: 'E类 - 有毒物质' },
    { value: 'F', label: 'F类 - 腐蚀性物质' }
  ];

  // 通风要求选项
  const ventilationRequirements = [
    '自然通风', '机械通风', '防爆通风', '化学通风柜', '局部排风', '全面通风'
  ];

  // 安全设施选项
  const safetyFacilities = [
    '洗眼器', '紧急淋浴器', '消防设施', '泄漏收集系统', 
    '防静电设施', '接地设施', '监测设备', '报警系统'
  ];

  return (
    <Form
      form={form}
      layout="vertical"
      onValuesChange={handleValuesChange}
      autoComplete="off"
    >
      <Alert
        message="第7节：操作处置与储存"
        description="请详细填写化学品的安全操作要求和储存条件，包括操作注意事项、储存要求、包装要求等。"
        type="info"
        showIcon
        icon={<SettingOutlined />}
        style={{ marginBottom: 24 }}
      />

      {/* 操作处置预防措施 */}
      <Card title="⚙️ 操作处置预防措施" size="small" style={{ marginBottom: 16 }}>
        <Form.Item
          label={
            <Space>
              安全操作要求
              <Tooltip title="操作时必须遵守的安全要求">
                <InfoCircleOutlined />
              </Tooltip>
            </Space>
          }
          name="safeHandlingRequirements"
          rules={[{ required: true, message: '请输入安全操作要求' }]}
        >
          <TextArea 
            placeholder="请详细描述安全操作的基本要求，如避免接触、使用适当工具等" 
            rows={4}
          />
        </Form.Item>

        <Form.Item
          label={
            <Space>
              操作注意事项
              <Tooltip title="操作过程中需要特别注意的事项">
                <InfoCircleOutlined />
              </Tooltip>
            </Space>
          }
          name="handlingPrecautions"
          rules={[{ required: true, message: '请输入操作注意事项' }]}
        >
          <TextArea 
            placeholder="请列出操作过程中的注意事项，如避免产生静电、防止溅出等" 
            rows={4}
          />
        </Form.Item>

        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              label="避免接触的条件"
              name="avoidConditions"
            >
              <Select mode="multiple" placeholder="选择应避免的条件" allowClear>
                <Option value="heat">热源</Option>
                <Option value="spark">火花</Option>
                <Option value="flame">明火</Option>
                <Option value="static">静电</Option>
                <Option value="shock">撞击</Option>
                <Option value="friction">摩擦</Option>
                <Option value="sunlight">阳光直射</Option>
                <Option value="moisture">潮湿</Option>
              </Select>
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              label="需要接地"
              name="needGrounding"
              valuePropName="checked"
            >
              <Switch />
            </Form.Item>
          </Col>
        </Row>

        <Form.Item
          label="个人防护要求"
          name="personalProtectionRequirements"
        >
          <TextArea 
            placeholder="请描述操作时必须的个人防护装备和要求" 
            rows={3}
          />
        </Form.Item>
      </Card>

      {/* 储存条件 */}
      <Card title="📦 储存条件" size="small" style={{ marginBottom: 16 }}>
        <Row gutter={16}>
          <Col span={8}>
            <Form.Item
              label={
                <Space>
                  储存温度
                  <Tooltip title="适宜的储存温度范围">
                    <InfoCircleOutlined />
                  </Tooltip>
                </Space>
              }
              name="storageTemperature"
            >
              <Input placeholder="如：5-25℃" addonAfter="℃" />
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item
              label="相对湿度"
              name="relativeHumidity"
            >
              <Input placeholder="如：≤65%" addonAfter="%" />
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item
              label="储存类别"
              name="storageClass"
            >
              <Select placeholder="选择储存类别">
                {storageClassOptions.map(option => (
                  <Option key={option.value} value={option.value}>
                    {option.label}
                  </Option>
                ))}
              </Select>
            </Form.Item>
          </Col>
        </Row>

        <Form.Item
          label={
            <Space>
              储存要求
              <Tooltip title="储存时必须满足的环境和设施要求">
                <InfoCircleOutlined />
              </Tooltip>
            </Space>
          }
          name="storageRequirements"
          rules={[{ required: true, message: '请输入储存要求' }]}
        >
          <TextArea 
            placeholder="请详细描述储存的环境要求，如阴凉、干燥、通风良好等" 
            rows={4}
          />
        </Form.Item>

        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              label="通风要求"
              name="ventilationRequirements"
            >
              <Select mode="multiple" placeholder="选择通风要求" allowClear>
                {ventilationRequirements.map(req => (
                  <Option key={req} value={req}>{req}</Option>
                ))}
              </Select>
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              label="需要隔离储存"
              name="requireIsolatedStorage"
              valuePropName="checked"
            >
              <Switch />
            </Form.Item>
          </Col>
        </Row>

        <Form.Item
          label="安全设施要求"
          name="safetyFacilities"
        >
          <CheckboxGroup
            options={safetyFacilities.map(facility => ({ label: facility, value: facility }))}
          />
        </Form.Item>
      </Card>

      {/* 包装要求 */}
      <Card title="📋 包装要求" size="small" style={{ marginBottom: 16 }}>
        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              label={
                <Space>
                  适宜的包装材料
                  <Tooltip title="推荐使用的包装材料">
                    <InfoCircleOutlined />
                  </Tooltip>
                </Space>
              }
              name="suitablePackagingMaterials"
              rules={[{ required: true, message: '请选择适宜的包装材料' }]}
            >
              <Select mode="multiple" placeholder="选择适宜的包装材料" allowClear>
                {containerMaterialOptions.map(material => (
                  <Option key={material} value={material}>{material}</Option>
                ))}
              </Select>
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              label="不相容的包装材料"
              name="incompatiblePackagingMaterials"
            >
              <Select mode="multiple" placeholder="选择不相容的材料" allowClear>
                {incompatibleMaterialOptions.map(material => (
                  <Option key={material} value={material}>{material}</Option>
                ))}
              </Select>
            </Form.Item>
          </Col>
        </Row>

        <Form.Item
          label="包装要求"
          name="packagingRequirements"
        >
          <TextArea 
            placeholder="请描述包装的具体要求，如密封性、耐腐蚀性、防渗漏等" 
            rows={3}
          />
        </Form.Item>

        <Row gutter={16}>
          <Col span={8}>
            <Form.Item
              label="最大包装容量"
              name="maxPackagingCapacity"
            >
              <InputNumber
                style={{ width: '100%' }}
                placeholder="最大容量"
                min={0}
                precision={1}
                addonAfter="L"
              />
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item
              label="需要特殊标识"
              name="requireSpecialLabeling"
              valuePropName="checked"
            >
              <Switch />
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item
              label="需要儿童安全盖"
              name="requireChildResistantClosure"
              valuePropName="checked"
            >
              <Switch />
            </Form.Item>
          </Col>
        </Row>
      </Card>

      {/* 禁配要求 */}
      <Card title="🚫 禁配要求" size="small" style={{ marginBottom: 16 }}>
        <Form.Item
          label={
            <Space>
              禁配物质
              <Tooltip title="不能与之一起储存的物质">
                <InfoCircleOutlined />
              </Tooltip>
            </Space>
          }
          name="incompatibleSubstances"
          rules={[{ required: true, message: '请输入禁配物质' }]}
        >
          <TextArea 
            placeholder="请列出不能与本产品一起储存的物质，如氧化剂、酸类、碱类等" 
            rows={4}
          />
        </Form.Item>

        <Form.Item
          label="分离距离要求"
          name="separationDistanceRequirements"
        >
          <TextArea 
            placeholder="请说明与禁配物质的最小分离距离要求" 
            rows={2}
          />
        </Form.Item>

        <Form.Item
          label="混合危险性"
          name="mixingHazards"
        >
          <TextArea 
            placeholder="请描述与禁配物质混合可能产生的危险" 
            rows={3}
          />
        </Form.Item>
      </Card>

      {/* 填写提示 */}
      <Alert
        message="填写提示"
        description={
          <ul style={{ margin: 0, paddingLeft: 20 }}>
            <li>操作要求应具体明确，考虑实际工作环境</li>
            <li>储存条件要涵盖温度、湿度、通风、光照等因素</li>
            <li>包装材料选择要考虑化学相容性</li>
            <li>禁配要求要明确具体，避免意外混合</li>
            <li>安全设施配置要符合相关法规要求</li>
          </ul>
        }
        type="info"
        showIcon
        style={{ marginTop: 16 }}
      />
    </Form>
  );
});

Step7HandlingStorage.displayName = 'Step7HandlingStorage';

export default Step7HandlingStorage;