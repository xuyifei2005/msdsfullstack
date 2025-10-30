import React, { useState, useEffect, forwardRef, useImperativeHandle } from 'react';
import { message } from 'antd';
import * as toxicologyApi from '@/services/msds/toxicology';
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
  Tooltip,
  Tag,
  Alert,
  Table,
  Button,
  Divider
} from 'antd';
import { 
  InfoCircleOutlined, 
  ExperimentOutlined, 
  WarningOutlined, 
  EyeOutlined,
  PlusOutlined,
  DeleteOutlined
} from '@ant-design/icons';

const { TextArea } = Input;
const { Option } = Select;
const { Title, Text } = Typography;

export interface Step11ToxicologicalProps {
  data?: any;
  onChange?: (data: any) => void;
}

const Step11Toxicological = forwardRef<any, Step11ToxicologicalProps>(
  ({ data = {}, onChange }, ref) => {
    const [form] = Form.useForm();
    const [formData, setFormData] = useState(data);
    const [toxicityData, setToxicityData] = useState(data.toxicityData || []);

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
      const newData = { ...formData, ...allFields, toxicityData };
      setFormData(newData);
      onChange?.(newData);
    };

    // 毒性等级选项
    const toxicityLevels = [
      { value: 'non_toxic', label: '无毒', color: 'green' },
      { value: 'low_toxic', label: '低毒', color: 'blue' },
      { value: 'moderate_toxic', label: '中等毒', color: 'orange' },
      { value: 'high_toxic', label: '高毒', color: 'red' },
      { value: 'extreme_toxic', label: '剧毒', color: 'purple' }
    ];

    // 接触途径选项
    const exposureRoutes = [
      { value: 'oral', label: '经口' },
      { value: 'dermal', label: '经皮' },
      { value: 'inhalation', label: '吸入' },
      { value: 'injection', label: '注射' },
      { value: 'ocular', label: '眼接触' }
    ];

    // 试验动物选项
    const testAnimals = [
      '大鼠', '小鼠', '兔', '豚鼠', '犬', '猴', '鱼类', '其他'
    ];

    // 刺激性等级选项
    const irritationLevels = [
      { value: 'none', label: '无刺激性', color: 'green' },
      { value: 'mild', label: '轻度刺激', color: 'blue' },
      { value: 'moderate', label: '中度刺激', color: 'orange' },
      { value: 'severe', label: '强烈刺激', color: 'red' }
    ];

    // 致癌性分类选项
    const carcinogenicityClasses = [
      { value: 'group1', label: '第1类 - 对人致癌', color: 'red' },
      { value: 'group2a', label: '第2A类 - 可能对人致癌', color: 'orange' },
      { value: 'group2b', label: '第2B类 - 可能对人致癌', color: 'yellow' },
      { value: 'group3', label: '第3类 - 对人致癌性不明确', color: 'blue' },
      { value: 'group4', label: '第4类 - 对人可能不致癌', color: 'green' }
    ];

    // 添加毒性数据
    const addToxicityData = () => {
      const newData = {
        id: Date.now(),
        route: '',
        animal: '',
        value: '',
        unit: '',
        description: ''
      };
      setToxicityData([...toxicityData, newData]);
    };

    // 删除毒性数据
    const removeToxicityData = (id: number) => {
      setToxicityData(toxicityData.filter(item => item.id !== id));
    };

    // 更新毒性数据
    const updateToxicityData = (id: number, field: string, value: any) => {
      setToxicityData(toxicityData.map(item => 
        item.id === id ? { ...item, [field]: value } : item
      ));
    };

    // 毒性数据表格列定义
    const toxicityColumns = [
      {
        title: '接触途径',
        dataIndex: 'route',
        width: 120,
        render: (text: string, record: any) => (
          <Select
            value={text}
            onChange={(value) => updateToxicityData(record.id, 'route', value)}
            style={{ width: '100%' }}
            placeholder="选择途径"
          >
            {exposureRoutes.map(route => (
              <Option key={route.value} value={route.value}>
                {route.label}
              </Option>
            ))}
          </Select>
        )
      },
      {
        title: '试验动物',
        dataIndex: 'animal',
        width: 100,
        render: (text: string, record: any) => (
          <Select
            value={text}
            onChange={(value) => updateToxicityData(record.id, 'animal', value)}
            style={{ width: '100%' }}
            placeholder="选择动物"
          >
            {testAnimals.map(animal => (
              <Option key={animal} value={animal}>
                {animal}
              </Option>
            ))}
          </Select>
        )
      },
      {
        title: 'LD50/LC50',
        dataIndex: 'value',
        width: 120,
        render: (text: string, record: any) => (
          <Input
            value={text}
            onChange={(e) => updateToxicityData(record.id, 'value', e.target.value)}
            placeholder="数值"
          />
        )
      },
      {
        title: '单位',
        dataIndex: 'unit',
        width: 100,
        render: (text: string, record: any) => (
          <Select
            value={text}
            onChange={(value) => updateToxicityData(record.id, 'unit', value)}
            style={{ width: '100%' }}
            placeholder="单位"
          >
            <Option value="mg/kg">mg/kg</Option>
            <Option value="g/kg">g/kg</Option>
            <Option value="mg/L">mg/L</Option>
            <Option value="mg/m³">mg/m³</Option>
            <Option value="ppm">ppm</Option>
          </Select>
        )
      },
      {
        title: '说明',
        dataIndex: 'description',
        render: (text: string, record: any) => (
          <Input
            value={text}
            onChange={(e) => updateToxicityData(record.id, 'description', e.target.value)}
            placeholder="试验条件说明"
          />
        )
      },
      {
        title: '操作',
        width: 80,
        render: (text: string, record: any) => (
          <Button
            type="text"
            danger
            icon={<DeleteOutlined />}
            onClick={() => removeToxicityData(record.id)}
          />
        )
      }
    ];

    return (
      <div style={{ padding: '24px', backgroundColor: '#f8f9fa' }}>
        <Card>
          <div style={{ marginBottom: '24px' }}>
            <Title level={4} style={{ color: '#1890ff', marginBottom: '8px' }}>
              <ExperimentOutlined style={{ marginRight: '8px' }} />
              第11节：毒理学资料
            </Title>
            <Text type="secondary">
              包含急性毒性、皮肤刺激性、眼刺激性、致敏性、致癌性、生殖毒性等毒理学数据
            </Text>
          </div>

          <Form
            form={form}
            layout="vertical"
            onValuesChange={handleFieldChange}
            initialValues={formData}
          >
            {/* 急性毒性 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                <WarningOutlined style={{ marginRight: '8px' }} />
                急性毒性
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label="急性毒性等级"
                    name="acuteToxicityLevel"
                  >
                    <Select placeholder="选择毒性等级">
                      {toxicityLevels.map(level => (
                        <Option key={level.value} value={level.value}>
                          <Tag color={level.color}>{level.label}</Tag>
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="主要毒性表现"
                    name="acuteToxicitySymptoms"
                  >
                    <Input placeholder="如：中枢神经系统抑制" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="致死剂量范围"
                    name="lethalDoseRange"
                  >
                    <Input placeholder="如：5-50 mg/kg" />
                  </Form.Item>
                </Col>
              </Row>

              <div style={{ marginBottom: '16px' }}>
                <Space>
                  <Text strong>毒性数据表</Text>
                  <Button
                    type="dashed"
                    icon={<PlusOutlined />}
                    onClick={addToxicityData}
                  >
                    添加数据
                  </Button>
                </Space>
              </div>

              <Table
                columns={toxicityColumns}
                dataSource={toxicityData}
                rowKey="id"
                pagination={false}
                size="small"
                scroll={{ x: 800 }}
              />

              <Form.Item
                label="急性毒性说明"
                name="acuteToxicityDescription"
                style={{ marginTop: '16px' }}
              >
                <TextArea
                  rows={3}
                  placeholder="请描述急性毒性的详细信息，包括中毒症状、作用机制等"
                />
              </Form.Item>
            </Card>

            {/* 皮肤和眼刺激性 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                <EyeOutlined style={{ marginRight: '8px' }} />
                皮肤和眼刺激性
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label="皮肤刺激性"
                    name="skinIrritation"
                  >
                    <Select placeholder="选择刺激性等级">
                      {irritationLevels.map(level => (
                        <Option key={level.value} value={level.value}>
                          <Tag color={level.color}>{level.label}</Tag>
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="眼刺激性"
                    name="eyeIrritation"
                  >
                    <Select placeholder="选择刺激性等级">
                      {irritationLevels.map(level => (
                        <Option key={level.value} value={level.value}>
                          <Tag color={level.color}>{level.label}</Tag>
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="皮肤腐蚀性"
                    name="skinCorrosion"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="是" unCheckedChildren="否" />
                  </Form.Item>
                </Col>
              </Row>

              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label="皮肤刺激试验结果"
                    name="skinIrritationTest"
                  >
                    <TextArea
                      rows={2}
                      placeholder="请描述皮肤刺激试验的具体结果"
                    />
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="眼刺激试验结果"
                    name="eyeIrritationTest"
                  >
                    <TextArea
                      rows={2}
                      placeholder="请描述眼刺激试验的具体结果"
                    />
                  </Form.Item>
                </Col>
              </Row>
            </Card>

            {/* 致敏性 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                致敏性
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label="皮肤致敏性"
                    name="skinSensitization"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="是" unCheckedChildren="否" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="呼吸道致敏性"
                    name="respiratorySensitization"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="是" unCheckedChildren="否" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="致敏强度"
                    name="sensitizationStrength"
                  >
                    <Select placeholder="选择致敏强度">
                      <Option value="weak">弱致敏</Option>
                      <Option value="moderate">中等致敏</Option>
                      <Option value="strong">强致敏</Option>
                      <Option value="extreme">极强致敏</Option>
                    </Select>
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="致敏试验结果"
                name="sensitizationTest"
              >
                <TextArea
                  rows={3}
                  placeholder="请描述致敏试验的具体结果和致敏机制"
                />
              </Form.Item>
            </Card>

            {/* 致癌性、致突变性、生殖毒性 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                致癌性、致突变性、生殖毒性
              </Title>
              
              <Alert
                message="重要提示"
                description="以下信息涉及长期健康影响，请根据权威机构的评估结果填写。"
                type="info"
                showIcon
                style={{ marginBottom: '16px' }}
              />

              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label="致癌性"
                    name="carcinogenicity"
                  >
                    <Select placeholder="选择致癌性分类">
                      {carcinogenicityClasses.map(cls => (
                        <Option key={cls.value} value={cls.value}>
                          <Tag color={cls.color}>{cls.label}</Tag>
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="致突变性"
                    name="mutagenicity"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="是" unCheckedChildren="否" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="生殖毒性"
                    name="reproductiveToxicity"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="是" unCheckedChildren="否" />
                  </Form.Item>
                </Col>
              </Row>

              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label="致癌性评估机构"
                    name="carcinogenicityAgency"
                  >
                    <Select
                      mode="multiple"
                      placeholder="选择评估机构"
                    >
                      <Option value="iarc">IARC (国际癌症研究机构)</Option>
                      <Option value="ntp">NTP (美国国家毒理学计划)</Option>
                      <Option value="osha">OSHA (美国职业安全健康署)</Option>
                      <Option value="acgih">ACGIH (美国政府工业卫生学家会议)</Option>
                      <Option value="china">中国卫生部</Option>
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="致癌性证据等级"
                    name="carcinogenicityEvidence"
                  >
                    <Select placeholder="选择证据等级">
                      <Option value="sufficient">充分证据</Option>
                      <Option value="limited">有限证据</Option>
                      <Option value="inadequate">证据不足</Option>
                      <Option value="no_evidence">无证据</Option>
                    </Select>
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="致癌性详细说明"
                name="carcinogenicityDescription"
              >
                <TextArea
                  rows={3}
                  placeholder="请详细描述致癌性评估结果、研究依据等"
                />
              </Form.Item>
            </Card>

            {/* 其他毒理学信息 */}
            <Card size="small">
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                其他毒理学信息
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label="神经毒性"
                    name="neurotoxicity"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="是" unCheckedChildren="否" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="免疫毒性"
                    name="immunotoxicity"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="是" unCheckedChildren="否" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="内分泌干扰"
                    name="endocrineDisruption"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="是" unCheckedChildren="否" />
                  </Form.Item>
                </Col>
              </Row>

              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label="NOAEL (无可见有害作用剂量)"
                    name="noael"
                  >
                    <Input placeholder="如：10 mg/kg/day" />
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="LOAEL (最低可见有害作用剂量)"
                    name="loael"
                  >
                    <Input placeholder="如：50 mg/kg/day" />
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="慢性毒性"
                name="chronicToxicity"
              >
                <TextArea
                  rows={3}
                  placeholder="请描述长期或重复接触的毒性效应"
                />
              </Form.Item>

              <Form.Item
                label="毒代动力学"
                name="toxicokinetics"
              >
                <TextArea
                  rows={3}
                  placeholder="请描述吸收、分布、代谢、排泄等毒代动力学信息"
                />
              </Form.Item>

              <Form.Item
                label="其他毒理学资料"
                name="otherToxicologicalData"
              >
                <TextArea
                  rows={4}
                  placeholder="请提供其他相关的毒理学研究资料和参考文献"
                />
              </Form.Item>
            </Card>
          </Form>
        </Card>
      </div>
    );
  }
);

Step11Toxicological.displayName = 'Step11Toxicological';

export default Step11Toxicological;