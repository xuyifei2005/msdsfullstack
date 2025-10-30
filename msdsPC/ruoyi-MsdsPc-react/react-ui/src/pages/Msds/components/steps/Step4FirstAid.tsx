import React, { forwardRef, useImperativeHandle, useEffect } from 'react';
import { message } from 'antd';
import * as firstAidApi from '@/services/msds/firstAid';
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
  Radio,
  Checkbox,
  Tag
} from 'antd';
import { 
  InfoCircleOutlined,
  MedicineBoxOutlined,
  WarningOutlined,
  EyeOutlined,
  HeartOutlined
} from '@ant-design/icons';
import type { API } from '@/types/msds';

const { TextArea } = Input;
const { Option } = Select;
const { Group: CheckboxGroup } = Checkbox;

interface Step4FirstAidProps {
  data?: API.Msds.MsdsFirstAid;
  onChange?: (data: API.Msds.MsdsFirstAid) => void;
}

const Step4FirstAid = forwardRef<any, Step4FirstAidProps>(({ data, onChange }, ref) => {
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

  // 接触途径选项
  const exposureRoutes = [
    { value: 'inhalation', label: '吸入', icon: '👃', color: 'blue' },
    { value: 'skin', label: '皮肤接触', icon: '✋', color: 'orange' },
    { value: 'eye', label: '眼接触', icon: '👁', color: 'red' },
    { value: 'ingestion', label: '误食', icon: '👄', color: 'purple' }
  ];

  // 紧急程度选项
  const urgencyLevels = [
    { value: 'immediate', label: '立即', color: 'red' },
    { value: 'urgent', label: '紧急', color: 'orange' },
    { value: 'normal', label: '一般', color: 'blue' }
  ];

  // 医疗设备选项
  const medicalEquipment = [
    '氧气', '生理盐水', '活性炭', '催吐剂', '解毒剂', 
    '眼冲洗器', '洗眼站', '紧急淋浴器', '担架', '急救包'
  ];

  // 禁忌事项选项
  const contraindications = [
    '禁止催吐', '禁止洗胃', '禁止给水', '禁止给食物', 
    '禁止口对口人工呼吸', '禁止使用肾上腺素', '禁止用油类物质'
  ];

  return (
    <Form
      form={form}
      layout="vertical"
      onValuesChange={handleValuesChange}
      autoComplete="off"
    >
      <Alert
        message="第4节：急救措施"
        description="请详细填写各种接触途径的急救措施，包括现场急救、医疗处置和注意事项等。急救措施应具体、可操作。"
        type="warning"
        showIcon
        icon={<MedicineBoxOutlined />}
        style={{ marginBottom: 24 }}
      />

      {/* 综合急救信息 */}
      <Card title="🚨 综合急救信息" size="small" style={{ marginBottom: 16 }}>
        <Form.Item
          label={
            <Space>
              急救概述
              <Tooltip title="简要描述主要的急救要点">
                <InfoCircleOutlined />
              </Tooltip>
            </Space>
          }
          name="firstAidOverview"
          rules={[{ required: true, message: '请输入急救概述' }]}
        >
          <TextArea 
            placeholder="请简要描述遇到意外时的主要急救要点和注意事项" 
            rows={3}
          />
        </Form.Item>

        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              label="紧急程度"
              name="urgencyLevel"
              rules={[{ required: true, message: '请选择紧急程度' }]}
            >
              <Radio.Group>
                {urgencyLevels.map(level => (
                  <Radio key={level.value} value={level.value}>
                    <Tag color={level.color}>{level.label}</Tag>
                  </Radio>
                ))}
              </Radio.Group>
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              label="需要立即就医"
              name="requireImmediateMedicalAttention"
              valuePropName="checked"
            >
              <Checkbox>所有接触情况都需要立即就医</Checkbox>
            </Form.Item>
          </Col>
        </Row>
      </Card>

      {/* 吸入急救措施 */}
      <Card title="👃 吸入急救措施" size="small" style={{ marginBottom: 16 }}>
        <Form.Item
          label={
            <Space>
              吸入急救措施
              <Tooltip title="吸入有害物质后的急救处理方法">
                <InfoCircleOutlined />
              </Tooltip>
            </Space>
          }
          name="inhalationFirstAid"
          rules={[{ required: true, message: '请输入吸入急救措施' }]}
        >
          <TextArea 
            placeholder="请详细描述吸入有害物质后的急救处理步骤，如转移到空气新鲜处、人工呼吸等" 
            rows={4}
          />
        </Form.Item>

        <Form.Item
          label="吸入注意事项"
          name="inhalationPrecautions"
        >
          <TextArea 
            placeholder="请说明吸入急救时的注意事项和禁忌" 
            rows={2}
          />
        </Form.Item>
      </Card>

      {/* 皮肤接触急救措施 */}
      <Card title="✋ 皮肤接触急救措施" size="small" style={{ marginBottom: 16 }}>
        <Form.Item
          label={
            <Space>
              皮肤接触急救措施
              <Tooltip title="皮肤接触有害物质后的急救处理方法">
                <InfoCircleOutlined />
              </Tooltip>
            </Space>
          }
          name="skinContactFirstAid"
          rules={[{ required: true, message: '请输入皮肤接触急救措施' }]}
        >
          <TextArea 
            placeholder="请详细描述皮肤接触有害物质后的急救处理步骤，如脱去污染衣物、用水冲洗等" 
            rows={4}
          />
        </Form.Item>

        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              label="冲洗时间"
              name="skinWashingTime"
            >
              <Input placeholder="如：至少15分钟" addonAfter="分钟" />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              label="冲洗水温"
              name="washingWaterTemperature"
            >
              <Select placeholder="选择水温">
                <Option value="cold">冷水</Option>
                <Option value="room_temperature">常温水</Option>
                <Option value="warm">温水</Option>
                <Option value="avoid_hot">避免热水</Option>
              </Select>
            </Form.Item>
          </Col>
        </Row>

        <Form.Item
          label="皮肤接触注意事项"
          name="skinContactPrecautions"
        >
          <TextArea 
            placeholder="请说明皮肤接触急救时的注意事项" 
            rows={2}
          />
        </Form.Item>
      </Card>

      {/* 眼接触急救措施 */}
      <Card title="👁 眼接触急救措施" size="small" style={{ marginBottom: 16 }}>
        <Form.Item
          label={
            <Space>
              眼接触急救措施
              <Tooltip title="眼部接触有害物质后的急救处理方法">
                <InfoCircleOutlined />
              </Tooltip>
            </Space>
          }
          name="eyeContactFirstAid"
          rules={[{ required: true, message: '请输入眼接触急救措施' }]}
        >
          <TextArea 
            placeholder="请详细描述眼部接触有害物质后的急救处理步骤，如提起眼睑、用水冲洗等" 
            rows={4}
          />
        </Form.Item>

        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              label="冲洗时间"
              name="eyeWashingTime"
            >
              <Input placeholder="如：至少15分钟" addonAfter="分钟" />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              label="需要摘除隐形眼镜"
              name="removeContactLenses"
              valuePropName="checked"
            >
              <Checkbox>如果佩戴隐形眼镜，需要摘除</Checkbox>
            </Form.Item>
          </Col>
        </Row>

        <Form.Item
          label="眼接触注意事项"
          name="eyeContactPrecautions"
        >
          <TextArea 
            placeholder="请说明眼接触急救时的注意事项" 
            rows={2}
          />
        </Form.Item>
      </Card>

      {/* 误食急救措施 */}
      <Card title="👄 误食急救措施" size="small" style={{ marginBottom: 16 }}>
        <Form.Item
          label={
            <Space>
              误食急救措施
              <Tooltip title="误食有害物质后的急救处理方法">
                <InfoCircleOutlined />
              </Tooltip>
            </Space>
          }
          name="ingestionFirstAid"
          rules={[{ required: true, message: '请输入误食急救措施' }]}
        >
          <TextArea 
            placeholder="请详细描述误食有害物质后的急救处理步骤，如漱口、喝水、催吐或禁止催吐等" 
            rows={4}
          />
        </Form.Item>

        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              label="是否可催吐"
              name="canIndiceVomiting"
            >
              <Radio.Group>
                <Radio value={true}>可以催吐</Radio>
                <Radio value={false}>禁止催吐</Radio>
              </Radio.Group>
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              label="可给予的液体"
              name="allowedFluids"
            >
              <Select mode="multiple" placeholder="选择可给予的液体" allowClear>
                <Option value="water">清水</Option>
                <Option value="milk">牛奶</Option>
                <Option value="saline">生理盐水</Option>
                <Option value="none">不给任何液体</Option>
              </Select>
            </Form.Item>
          </Col>
        </Row>

        <Form.Item
          label="误食注意事项"
          name="ingestionPrecautions"
        >
          <TextArea 
            placeholder="请说明误食急救时的注意事项和禁忌" 
            rows={2}
          />
        </Form.Item>
      </Card>

      {/* 医疗处置建议 */}
      <Card title="🏥 医疗处置建议" size="small" style={{ marginBottom: 16 }}>
        <Form.Item
          label={
            <Space>
              医疗处置要点
              <Tooltip title="医护人员进行医疗处置时的重要信息">
                <InfoCircleOutlined />
              </Tooltip>
            </Space>
          }
          name="medicalTreatment"
          rules={[{ required: true, message: '请输入医疗处置要点' }]}
        >
          <TextArea 
            placeholder="请提供给医护人员的专业医疗处置建议，如特殊解毒剂、对症治疗方法等" 
            rows={4}
          />
        </Form.Item>

        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              label="特殊解毒剂"
              name="specificAntidote"
            >
              <Input placeholder="如有特殊解毒剂，请填写" />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              label="禁用药物"
              name="contraindications"
            >
              <Select mode="multiple" placeholder="选择禁忌事项" allowClear>
                {contraindications.map(item => (
                  <Option key={item} value={item}>{item}</Option>
                ))}
              </Select>
            </Form.Item>
          </Col>
        </Row>

        <Form.Item
          label="所需医疗设备"
          name="requiredMedicalEquipment"
        >
          <Select mode="multiple" placeholder="选择所需医疗设备" allowClear>
            {medicalEquipment.map(equipment => (
              <Option key={equipment} value={equipment}>{equipment}</Option>
            ))}
          </Select>
        </Form.Item>

        <Form.Item
          label="医护人员防护要求"
          name="medicalPersonnelProtection"
        >
          <TextArea 
            placeholder="请说明医护人员在处置过程中的自身防护要求" 
            rows={3}
          />
        </Form.Item>
      </Card>

      {/* 填写提示 */}
      <Alert
        message="填写提示"
        description={
          <ul style={{ margin: 0, paddingLeft: 20 }}>
            <li>急救措施应具体明确，避免模糊不清的描述</li>
            <li>区分不同接触途径的急救方法，避免混淆</li>
            <li>明确指出禁忌事项，防止不当操作加重伤害</li>
            <li>提供的医疗信息应准确可靠，有科学依据</li>
            <li>考虑现场实际条件，提供可操作的急救方案</li>
          </ul>
        }
        type="info"
        showIcon
        style={{ marginTop: 16 }}
      />
    </Form>
  );
});

Step4FirstAid.displayName = 'Step4FirstAid';

export default Step4FirstAid;