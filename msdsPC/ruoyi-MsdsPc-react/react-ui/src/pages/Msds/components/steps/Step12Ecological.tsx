import React, { forwardRef, useImperativeHandle, useEffect } from 'react';
import { message } from 'antd';
import * as ecologyApi from '@/services/msds/ecology';
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
  EnvironmentOutlined
} from '@ant-design/icons';
import type { API } from '@/types/msds';

const { TextArea } = Input;
const { Option } = Select;

interface Step12EcologicalProps {
  data?: API.Msds.MsdsEcological;
  onChange?: (data: API.Msds.MsdsEcological) => void;
}

const Step12Ecological = forwardRef<any, Step12EcologicalProps>(({ data, onChange }, ref) => {
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

  // 生物降解性选项
  const biodegradabilityOptions = [
    '易生物降解', '可生物降解', '不易生物降解', '难生物降解', '不可生物降解'
  ];

  // 迁移性选项
  const mobilityOptions = [
    '高迁移性', '中等迁移性', '低迁移性', '不迁移'
  ];

  return (
    <Form
      form={form}
      layout="vertical"
      onValuesChange={handleValuesChange}
      autoComplete="off"
    >
      <Alert
        message="第12节：生态学资料"
        description="请详细填写化学品对生态环境的影响信息，包括生态毒性、生物降解性、生物富集性等。"
        type="info"
        showIcon
        icon={<EnvironmentOutlined />}
        style={{ marginBottom: 24 }}
      />

      {/* 生态毒性 */}
      <Card title="🐟 生态毒性" size="small" style={{ marginBottom: 16 }}>
        <Form.Item
          label={
            <Space>
              生态毒性概述
              <Tooltip title="对生态系统的总体毒性评价">
                <InfoCircleOutlined />
              </Tooltip>
            </Space>
          }
          name="ecologicalToxicity"
          rules={[{ required: true, message: '请输入生态毒性概述' }]}
        >
          <TextArea 
            placeholder="请概述对生态系统的毒性影响" 
            rows={3}
          />
        </Form.Item>

        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              label={
                <Space>
                  鱼类毒性
                  <Tooltip title="对鱼类的急性或慢性毒性数据">
                    <InfoCircleOutlined />
                  </Tooltip>
                </Space>
              }
              name="fishToxicity"
            >
              <TextArea 
                placeholder="请输入鱼类毒性数据，如LC50值等" 
                rows={3}
              />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              label={
                <Space>
                  无脊椎动物毒性
                  <Tooltip title="对无脊椎动物的毒性数据">
                    <InfoCircleOutlined />
                  </Tooltip>
                </Space>
              }
              name="invertebrateToxicity"
            >
              <TextArea 
                placeholder="请输入无脊椎动物毒性数据" 
                rows={3}
              />
            </Form.Item>
          </Col>
        </Row>

        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              label="藻类毒性"
              name="algaeToxicity"
            >
              <TextArea 
                placeholder="请输入藻类毒性数据" 
                rows={3}
              />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              label="细菌毒性"
              name="bacteriaToxicity"
            >
              <TextArea 
                placeholder="请输入细菌毒性数据" 
                rows={3}
              />
            </Form.Item>
          </Col>
        </Row>
      </Card>

      {/* 生物降解性 */}
      <Card title="♻️ 生物降解性" size="small" style={{ marginBottom: 16 }}>
        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              label={
                <Space>
                  生物降解性
                  <Tooltip title="物质被微生物分解的能力">
                    <InfoCircleOutlined />
                  </Tooltip>
                </Space>
              }
              name="biodegradability"
              rules={[{ required: true, message: '请选择生物降解性' }]}
            >
              <Select placeholder="请选择生物降解性" allowClear>
                {biodegradabilityOptions.map(option => (
                  <Option key={option} value={option}>{option}</Option>
                ))}
              </Select>
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              label="生物降解速率"
              name="biodegradationRate"
            >
              <Input placeholder="请输入生物降解速率，如：50% in 28 days" />
            </Form.Item>
          </Col>
        </Row>

        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              label="非生物降解性"
              name="nonBiodegradability"
            >
              <TextArea 
                placeholder="请描述非生物降解过程" 
                rows={3}
              />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              label="光降解"
              name="photodegradation"
            >
              <TextArea 
                placeholder="请描述光降解特性" 
                rows={3}
              />
            </Form.Item>
          </Col>
        </Row>

        <Form.Item
          label="水解"
          name="hydrolysis"
        >
          <TextArea 
            placeholder="请描述水解特性和条件" 
            rows={2}
          />
        </Form.Item>
      </Card>

      {/* 生物富集性 */}
      <Card title="📈 生物富集性" size="small" style={{ marginBottom: 16 }}>
        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              label={
                <Space>
                  生物富集或生物积累性
                  <Tooltip title="物质在生物体内积累的倾向">
                    <InfoCircleOutlined />
                  </Tooltip>
                </Space>
              }
              name="bioaccumulation"
            >
              <TextArea 
                placeholder="请描述生物富集或生物积累性" 
                rows={3}
              />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              label={
                <Space>
                  生物富集因子 (BCF)
                  <Tooltip title="生物富集因子，表示物质在生物体内的富集程度">
                    <InfoCircleOutlined />
                  </Tooltip>
                </Space>
              }
              name="bioconcentrationFactor"
            >
              <Input placeholder="请输入BCF值" />
            </Form.Item>
          </Col>
        </Row>
      </Card>

      {/* 环境迁移性 */}
      <Card title="🌍 环境迁移性" size="small" style={{ marginBottom: 16 }}>
        <Form.Item
          label={
            <Space>
              土壤中迁移性
              <Tooltip title="物质在土壤中的迁移能力">
                <InfoCircleOutlined />
              </Tooltip>
            </Space>
          }
          name="mobilityInSoil"
        >
          <Select placeholder="请选择土壤中迁移性" allowClear>
            {mobilityOptions.map(option => (
              <Option key={option} value={option}>{option}</Option>
            ))}
          </Select>
        </Form.Item>
      </Card>

      {/* 其他环境效应 */}
      <Card title="🌱 其他环境效应" size="small" style={{ marginBottom: 16 }}>
        <Form.Item
          label="其它有害作用"
          name="otherEnvironmentalEffects"
        >
          <TextArea 
            placeholder="请描述其他对环境的有害作用" 
            rows={3}
          />
        </Form.Item>

        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              label={
                <Space>
                  臭氧消耗潜能值 (ODP)
                  <Tooltip title="对臭氧层的破坏潜力">
                    <InfoCircleOutlined />
                  </Tooltip>
                </Space>
              }
              name="ozoneDepletionPotential"
            >
              <InputNumber 
                style={{ width: '100%' }}
                placeholder="请输入ODP值"
                min={0}
                step={0.01}
              />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              label={
                <Space>
                  全球变暖潜能值 (GWP)
                  <Tooltip title="对全球变暖的贡献潜力">
                    <InfoCircleOutlined />
                  </Tooltip>
                </Space>
              }
              name="globalWarmingPotential"
            >
              <InputNumber 
                style={{ width: '100%' }}
                placeholder="请输入GWP值"
                min={0}
                step={1}
              />
            </Form.Item>
          </Col>
        </Row>
      </Card>

      {/* 填写提示 */}
      <Alert
        message="填写提示"
        description={
          <ul style={{ margin: 0, paddingLeft: 20 }}>
            <li>生态毒性数据应包括具体的毒性值和试验条件</li>
            <li>生物降解性要区分好氧和厌氧条件</li>
            <li>BCF值通常以数值形式给出，如BCF = 100</li>
            <li>土壤迁移性与分配系数(Koc)相关</li>
            <li>ODP和GWP值通常以CO₂为基准(GWP)或CFC-11为基准(ODP)</li>
          </ul>
        }
        type="info"
        showIcon
        style={{ marginTop: 16 }}
      />
    </Form>
  );
});

Step12Ecological.displayName = 'Step12Ecological';

export default Step12Ecological;