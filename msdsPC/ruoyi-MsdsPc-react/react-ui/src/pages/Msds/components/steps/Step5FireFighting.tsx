import React, { forwardRef, useImperativeHandle, useEffect } from 'react';
import { message } from 'antd';
import * as fireFightingApi from '@/services/msds/fireFighting';
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
  InputNumber
} from 'antd';
import { 
  InfoCircleOutlined,
  FireOutlined
} from '@ant-design/icons';
import type { API } from '@/types/msds';

const { TextArea } = Input;
const { Option } = Select;

interface Step5FireFightingProps {
  data?: API.Msds.MsdsFireFighting;
  onChange?: (data: API.Msds.MsdsFireFighting) => void;
}

const Step5FireFighting = forwardRef<any, Step5FireFightingProps>(({ data, onChange }, ref) => {
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

  // 灭火介质选项
  const extinguishingMediaOptions = [
    '水', '泡沫', '干粉', '二氧化碳', '1211灭火剂', '砂土', '惰性气体'
  ];

  // 火险分级选项
  const fireRiskOptions = [
    '甲类', '乙类', '丙类', '丁类', '戊类'
  ];

  return (
    <Form
      form={form}
      layout="vertical"
      onValuesChange={handleValuesChange}
      autoComplete="off"
    >
      <Alert
        message="第5节：消防措施"
        description="请详细填写消防措施信息，包括适宜的灭火介质、消防设备和特殊消防程序等。"
        type="warning"
        showIcon
        icon={<FireOutlined />}
        style={{ marginBottom: 24 }}
      />

      {/* 危险特性 */}
      <Card title="🔥 危险特性" size="small" style={{ marginBottom: 16 }}>
        <Form.Item
          label={
            <Space>
              危险特性
              <Tooltip title="描述化学品的燃烧爆炸危险特性">
                <InfoCircleOutlined />
              </Tooltip>
            </Space>
          }
          name="hazardCharacteristics"
          rules={[{ required: true, message: '请输入危险特性' }]}
        >
          <TextArea 
            placeholder="请描述燃烧爆炸危险特性，如易燃性、爆炸性、氧化性等" 
            rows={4}
          />
        </Form.Item>

        <Form.Item
          label="有害燃烧产物"
          name="harmfulCombustionProducts"
          rules={[{ required: true, message: '请输入有害燃烧产物' }]}
        >
          <TextArea 
            placeholder="请列出燃烧时产生的有害物质" 
            rows={3}
          />
        </Form.Item>
      </Card>

      {/* 灭火方法 */}
      <Card title="🚒 灭火方法" size="small" style={{ marginBottom: 16 }}>
        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              label={
                <Space>
                  适宜的灭火介质
                  <Tooltip title="推荐使用的灭火剂">
                    <InfoCircleOutlined />
                  </Tooltip>
                </Space>
              }
              name="suitableExtinguishingMedia"
              rules={[{ required: true, message: '请选择适宜的灭火介质' }]}
            >
              <Select 
                mode="multiple"
                placeholder="请选择适宜的灭火介质（可多选）"
                allowClear
              >
                {extinguishingMediaOptions.map(media => (
                  <Option key={media} value={media}>{media}</Option>
                ))}
              </Select>
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              label={
                <Space>
                  不适宜的灭火介质
                  <Tooltip title="禁止使用的灭火剂">
                    <InfoCircleOutlined />
                  </Tooltip>
                </Space>
              }
              name="unsuitableExtinguishingMedia"
            >
              <Select 
                mode="multiple"
                placeholder="请选择不适宜的灭火介质（可多选）"
                allowClear
              >
                {extinguishingMediaOptions.map(media => (
                  <Option key={media} value={media}>{media}</Option>
                ))}
              </Select>
            </Form.Item>
          </Col>
        </Row>

        <Form.Item
          label="消防设备和防护装备"
          name="fireFightingEquipment"
          rules={[{ required: true, message: '请输入消防设备和防护装备' }]}
        >
          <TextArea 
            placeholder="请描述消防人员应使用的防护装备和消防设备" 
            rows={3}
          />
        </Form.Item>

        <Form.Item
          label="特殊消防程序"
          name="fireFightingProcedures"
        >
          <TextArea 
            placeholder="请描述特殊的消防程序和注意事项" 
            rows={3}
          />
        </Form.Item>
      </Card>

      {/* 燃烧特性参数 */}
      <Card title="📊 燃烧特性参数" size="small" style={{ marginBottom: 16 }}>
        <Row gutter={16}>
          <Col span={8}>
            <Form.Item
              label={
                <Space>
                  闪点 (℃)
                  <Tooltip title="在规定条件下，可燃液体能放出足量的蒸气并在所用容器内的液体表面上与空气组成可燃混合物的液体的最低温度">
                    <InfoCircleOutlined />
                  </Tooltip>
                </Space>
              }
              name="flashPoint"
            >
              <Input placeholder="请输入闪点" addonAfter="℃" />
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item
              label={
                <Space>
                  自燃温度 (℃)
                  <Tooltip title="在规定条件下，可燃物质产生自燃的最低温度">
                    <InfoCircleOutlined />
                  </Tooltip>
                </Space>
              }
              name="autoignitionTemperature"
            >
              <Input placeholder="请输入自燃温度" addonAfter="℃" />
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item
              label={
                <Space>
                  建规火险分级
                  <Tooltip title="根据《建筑设计防火规范》的火险分级">
                    <InfoCircleOutlined />
                  </Tooltip>
                </Space>
              }
              name="fireRiskClassification"
            >
              <Select placeholder="请选择火险分级" allowClear>
                {fireRiskOptions.map(risk => (
                  <Option key={risk} value={risk}>{risk}</Option>
                ))}
              </Select>
            </Form.Item>
          </Col>
        </Row>

        <Form.Item
          label={
            <Space>
              燃烧性/爆炸极限
              <Tooltip title="可燃气体或蒸气与空气混合能够发生燃烧或爆炸的浓度范围">
                <InfoCircleOutlined />
              </Tooltip>
            </Space>
          }
          name="flammabilityLimits"
        >
          <Input placeholder="请输入燃烧性/爆炸极限，如：LEL: 2.1% UEL: 9.5%" />
        </Form.Item>
      </Card>

      {/* 填写提示 */}
      <Alert
        message="填写提示"
        description={
          <ul style={{ margin: 0, paddingLeft: 20 }}>
            <li>危险特性应详细描述燃烧爆炸的条件和危险性</li>
            <li>灭火介质的选择要考虑化学品的特性</li>
            <li>闪点和自燃温度等参数应准确填写，影响安全评估</li>
            <li>消防设备要具体到型号和使用方法</li>
            <li>爆炸极限格式：LEL（下限）和UEL（上限），单位为%</li>
          </ul>
        }
        type="info"
        showIcon
        style={{ marginTop: 16 }}
      />
    </Form>
  );
});

Step5FireFighting.displayName = 'Step5FireFighting';

export default Step5FireFighting;