import React, { useState, useEffect, forwardRef, useImperativeHandle } from 'react';
import { message } from 'antd';
import * as physicalChemicalApi from '@/services/msds/physicalChemical';
import {
  Form,
  Input,
  Select,
  Card,
  Row,
  Col,
  InputNumber,
  Space,
  Typography,
  Tooltip,
  Tag,
  Divider
} from 'antd';
import { InfoCircleOutlined, ExperimentOutlined, FireOutlined, DropboxOutlined } from '@ant-design/icons';

const { TextArea } = Input;
const { Option } = Select;
const { Title, Text } = Typography;

export interface Step9PhysicalChemicalProps {
  data?: any;
  onChange?: (data: any) => void;
}

const Step9PhysicalChemical = forwardRef<any, Step9PhysicalChemicalProps>(
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

    // 物理状态选项
    const physicalStates = [
      { value: 'solid', label: '固体', color: 'blue' },
      { value: 'liquid', label: '液体', color: 'cyan' },
      { value: 'gas', label: '气体', color: 'green' },
      { value: 'powder', label: '粉末', color: 'orange' },
      { value: 'paste', label: '膏状', color: 'purple' },
      { value: 'gel', label: '凝胶', color: 'magenta' }
    ];

    // 溶解性选项
    const solubilityOptions = [
      '易溶于水',
      '溶于水',
      '微溶于水',
      '难溶于水',
      '不溶于水',
      '易溶于醇',
      '溶于醇',
      '溶于有机溶剂',
      '溶于酸',
      '溶于碱'
    ];

    // 颜色选项
    const colorOptions = [
      '无色',
      '白色',
      '黄色',
      '红色',
      '蓝色',
      '绿色',
      '黑色',
      '棕色',
      '灰色',
      '透明',
      '半透明',
      '不透明'
    ];

    // 气味选项
    const odorOptions = [
      '无臭',
      '刺激性气味',
      '芳香味',
      '酸味',
      '苦味',
      '甜味',
      '腐臭味',
      '氨味',
      '醚味',
      '汽油味'
    ];

    return (
      <div style={{ padding: '24px', backgroundColor: '#f8f9fa' }}>
        <Card>
          <div style={{ marginBottom: '24px' }}>
            <Title level={4} style={{ color: '#1890ff', marginBottom: '8px' }}>
              <ExperimentOutlined style={{ marginRight: '8px' }} />
              第9节：理化特性
            </Title>
            <Text type="secondary">
              包含外观、物理状态、熔点、沸点、密度、溶解性、闪点等理化性质信息
            </Text>
          </div>

          <Form
            form={form}
            layout="vertical"
            onValuesChange={handleFieldChange}
            initialValues={formData}
          >
            {/* 外观性状 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                <DropboxOutlined style={{ marginRight: '8px' }} />
                外观性状
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label="物理状态"
                    name="physicalState"
                  >
                    <Select placeholder="选择物理状态">
                      {physicalStates.map(state => (
                        <Option key={state.value} value={state.value}>
                          <Tag color={state.color}>{state.label}</Tag>
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="颜色"
                    name="color"
                  >
                    <Select
                      mode="tags"
                      placeholder="选择或输入颜色"
                      style={{ width: '100%' }}
                    >
                      {colorOptions.map(color => (
                        <Option key={color} value={color}>
                          {color}
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="气味"
                    name="odor"
                  >
                    <Select
                      mode="tags"
                      placeholder="选择或输入气味"
                      style={{ width: '100%' }}
                    >
                      {odorOptions.map(odor => (
                        <Option key={odor} value={odor}>
                          {odor}
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="外观描述"
                name="appearance"
              >
                <TextArea
                  rows={2}
                  placeholder="请详细描述化学品的外观特征，如：透明液体、白色结晶粉末等"
                />
              </Form.Item>
            </Card>

            {/* 物理参数 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                物理参数
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label={
                      <Space>
                        熔点 (°C)
                        <Tooltip title="固体物质熔化时的温度">
                          <InfoCircleOutlined style={{ color: '#1890ff' }} />
                        </Tooltip>
                      </Space>
                    }
                    name="meltingPoint"
                  >
                    <InputNumber
                      style={{ width: '100%' }}
                      placeholder="请输入熔点"
                      precision={2}
                    />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label={
                      <Space>
                        沸点 (°C)
                        <Tooltip title="液体沸腾时的温度">
                          <InfoCircleOutlined style={{ color: '#1890ff' }} />
                        </Tooltip>
                      </Space>
                    }
                    name="boilingPoint"
                  >
                    <InputNumber
                      style={{ width: '100%' }}
                      placeholder="请输入沸点"
                      precision={2}
                    />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label={
                      <Space>
                        密度 (g/cm³)
                        <Tooltip title="单位体积的质量">
                          <InfoCircleOutlined style={{ color: '#1890ff' }} />
                        </Tooltip>
                      </Space>
                    }
                    name="density"
                  >
                    <InputNumber
                      style={{ width: '100%' }}
                      placeholder="请输入密度"
                      min={0}
                      precision={4}
                    />
                  </Form.Item>
                </Col>
              </Row>

              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label={
                      <Space>
                        相对密度 (水=1)
                        <Tooltip title="相对于水的密度比值">
                          <InfoCircleOutlined style={{ color: '#1890ff' }} />
                        </Tooltip>
                      </Space>
                    }
                    name="relativeDensity"
                  >
                    <InputNumber
                      style={{ width: '100%' }}
                      placeholder="请输入相对密度"
                      min={0}
                      precision={4}
                    />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label={
                      <Space>
                        相对蒸气密度 (空气=1)
                        <Tooltip title="相对于空气的蒸气密度比值">
                          <InfoCircleOutlined style={{ color: '#1890ff' }} />
                        </Tooltip>
                      </Space>
                    }
                    name="relativeVaporDensity"
                  >
                    <InputNumber
                      style={{ width: '100%' }}
                      placeholder="请输入相对蒸气密度"
                      min={0}
                      precision={4}
                    />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label={
                      <Space>
                        pH值
                        <Tooltip title="酸碱度指标">
                          <InfoCircleOutlined style={{ color: '#1890ff' }} />
                        </Tooltip>
                      </Space>
                    }
                    name="phValue"
                  >
                    <InputNumber
                      style={{ width: '100%' }}
                      placeholder="请输入pH值"
                      min={0}
                      max={14}
                      precision={2}
                    />
                  </Form.Item>
                </Col>
              </Row>
            </Card>

            {/* 燃烧爆炸特性 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                <FireOutlined style={{ marginRight: '8px' }} />
                燃烧爆炸特性
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label={
                      <Space>
                        闪点 (°C)
                        <Tooltip title="可燃液体能挥发出足够的蒸气并在所用试验条件下能产生闪燃的最低温度">
                          <InfoCircleOutlined style={{ color: '#1890ff' }} />
                        </Tooltip>
                      </Space>
                    }
                    name="flashPoint"
                  >
                    <InputNumber
                      style={{ width: '100%' }}
                      placeholder="请输入闪点"
                      precision={2}
                    />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label={
                      <Space>
                        自燃温度 (°C)
                        <Tooltip title="可燃物质在空气中无外界火源作用下发生自燃的最低温度">
                          <InfoCircleOutlined style={{ color: '#1890ff' }} />
                        </Tooltip>
                      </Space>
                    }
                    name="autoIgnitionTemp"
                  >
                    <InputNumber
                      style={{ width: '100%' }}
                      placeholder="请输入自燃温度"
                      precision={2}
                    />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="燃烧性"
                    name="flammability"
                  >
                    <Select placeholder="选择燃烧性">
                      <Option value="non_flammable">不燃</Option>
                      <Option value="hardly_flammable">难燃</Option>
                      <Option value="flammable">可燃</Option>
                      <Option value="easily_flammable">易燃</Option>
                      <Option value="extremely_flammable">极易燃</Option>
                    </Select>
                  </Form.Item>
                </Col>
              </Row>

              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label={
                      <Space>
                        爆炸极限 (%)
                        <Tooltip title="可燃气体或蒸气与空气混合能发生爆炸的浓度范围">
                          <InfoCircleOutlined style={{ color: '#1890ff' }} />
                        </Tooltip>
                      </Space>
                    }
                    name="explosionLimit"
                  >
                    <Input placeholder="如：2.1% ~ 9.5%" />
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label={
                      <Space>
                        最小点火能 (mJ)
                        <Tooltip title="点燃可燃混合物所需的最小能量">
                          <InfoCircleOutlined style={{ color: '#1890ff' }} />
                        </Tooltip>
                      </Space>
                    }
                    name="minIgnitionEnergy"
                  >
                    <InputNumber
                      style={{ width: '100%' }}
                      placeholder="请输入最小点火能"
                      min={0}
                      precision={3}
                    />
                  </Form.Item>
                </Col>
              </Row>
            </Card>

            {/* 溶解性 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                溶解性
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label="在水中的溶解性"
                    name="waterSolubility"
                  >
                    <Select
                      mode="tags"
                      placeholder="选择或输入溶解性"
                      style={{ width: '100%' }}
                    >
                      {solubilityOptions.map(option => (
                        <Option key={option} value={option}>
                          {option}
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="溶解度 (g/100g水)"
                    name="solubilityValue"
                  >
                    <InputNumber
                      style={{ width: '100%' }}
                      placeholder="请输入溶解度数值"
                      min={0}
                      precision={4}
                    />
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="在其他溶剂中的溶解性"
                name="otherSolubility"
              >
                <TextArea
                  rows={3}
                  placeholder="请描述在醇类、醚类、酮类等有机溶剂中的溶解性"
                />
              </Form.Item>
            </Card>

            {/* 其他物理化学性质 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                其他物理化学性质
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label={
                      <Space>
                        蒸气压 (kPa)
                        <Tooltip title="密闭容器中液体蒸发与凝结达到平衡时的压力">
                          <InfoCircleOutlined style={{ color: '#1890ff' }} />
                        </Tooltip>
                      </Space>
                    }
                    name="vaporPressure"
                  >
                    <InputNumber
                      style={{ width: '100%' }}
                      placeholder="请输入蒸气压"
                      min={0}
                      precision={4}
                    />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="测定温度 (°C)"
                    name="vaporPressureTemp"
                  >
                    <InputNumber
                      style={{ width: '100%' }}
                      placeholder="蒸气压测定温度"
                      precision={2}
                    />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label={
                      <Space>
                        粘度 (mPa·s)
                        <Tooltip title="液体的粘稠程度">
                          <InfoCircleOutlined style={{ color: '#1890ff' }} />
                        </Tooltip>
                      </Space>
                    }
                    name="viscosity"
                  >
                    <InputNumber
                      style={{ width: '100%' }}
                      placeholder="请输入粘度"
                      min={0}
                      precision={4}
                    />
                  </Form.Item>
                </Col>
              </Row>

              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label={
                      <Space>
                        折射率
                        <Tooltip title="光在真空中的传播速度与光在该物质中的传播速度的比值">
                          <InfoCircleOutlined style={{ color: '#1890ff' }} />
                        </Tooltip>
                      </Space>
                    }
                    name="refractiveIndex"
                  >
                    <InputNumber
                      style={{ width: '100%' }}
                      placeholder="请输入折射率"
                      min={1}
                      precision={4}
                    />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="导电性"
                    name="conductivity"
                  >
                    <Select placeholder="选择导电性">
                      <Option value="conductor">导体</Option>
                      <Option value="semiconductor">半导体</Option>
                      <Option value="insulator">绝缘体</Option>
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="磁性"
                    name="magnetism"
                  >
                    <Select placeholder="选择磁性">
                      <Option value="diamagnetic">抗磁性</Option>
                      <Option value="paramagnetic">顺磁性</Option>
                      <Option value="ferromagnetic">铁磁性</Option>
                      <Option value="non_magnetic">非磁性</Option>
                    </Select>
                  </Form.Item>
                </Col>
              </Row>
            </Card>

            {/* 补充信息 */}
            <Card size="small">
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                补充信息
              </Title>
              
              <Form.Item
                label="其他理化性质"
                name="otherProperties"
              >
                <TextArea
                  rows={4}
                  placeholder="请描述其他重要的理化性质，如：热稳定性、光稳定性、吸湿性、腐蚀性等"
                />
              </Form.Item>

              <Form.Item
                label="测试条件说明"
                name="testConditions"
              >
                <TextArea
                  rows={3}
                  placeholder="请说明各项理化参数的测试条件，如：温度、压力、湿度等"
                />
              </Form.Item>
            </Card>
          </Form>
        </Card>
      </div>
    );
  }
);

Step9PhysicalChemical.displayName = 'Step9PhysicalChemical';

export default Step9PhysicalChemical;