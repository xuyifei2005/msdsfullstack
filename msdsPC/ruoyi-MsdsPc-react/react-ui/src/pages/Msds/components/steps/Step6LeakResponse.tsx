import React, { forwardRef, useImperativeHandle, useEffect } from 'react';
import { message } from 'antd';
import * as leakResponseApi from '@/services/msds/leakResponse';
import { 
  Form, 
  Input, 
  Card, 
  Row, 
  Col, 
  Space, 
  Select,
  Tooltip,
  Alert
} from 'antd';
import { 
  InfoCircleOutlined,
  WarningOutlined
} from '@ant-design/icons';
import type { API } from '@/types/msds';

const { TextArea } = Input;
const { Option } = Select;

interface Step6LeakResponseProps {
  data?: API.Msds.MsdsLeakResponse;
  onChange?: (data: API.Msds.MsdsLeakResponse) => void;
}

const Step6LeakResponse = forwardRef<any, Step6LeakResponseProps>(({ data, onChange }, ref) => {
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

  // 清理器材选项
  const equipmentOptions = [
    '吸收棉', '沙土', '蛭石', '活性炭', '中和剂', '收集容器', 
    '铲子', '扫帚', '防渗膜', '围堰材料', '泵', '真空吸收装置'
  ];

  return (
    <Form
      form={form}
      layout="vertical"
      onValuesChange={handleValuesChange}
      autoComplete="off"
    >
      <Alert
        message="第6节：泄漏应急处理"
        description="请详细填写泄漏应急处理措施，包括个人防护、环境保护和清理方法等。"
        type="warning"
        showIcon
        icon={<WarningOutlined />}
        style={{ marginBottom: 24 }}
      />

      {/* 防护措施 */}
      <Card title="🛡️ 防护措施" size="small" style={{ marginBottom: 16 }}>
        <Form.Item
          label={
            <Space>
              个人防护措施
              <Tooltip title="处理泄漏时必须采取的个人防护措施">
                <InfoCircleOutlined />
              </Tooltip>
            </Space>
          }
          name="personalPrecautions"
          rules={[{ required: true, message: '请输入个人防护措施' }]}
        >
          <TextArea 
            placeholder="请详细描述处理泄漏时的个人防护要求，如防护服、呼吸器、手套等" 
            rows={4}
          />
        </Form.Item>

        <Form.Item
          label={
            <Space>
              环境保护措施
              <Tooltip title="防止泄漏物质对环境造成污染的措施">
                <InfoCircleOutlined />
              </Tooltip>
            </Space>
          }
          name="environmentalPrecautions"
          rules={[{ required: true, message: '请输入环境保护措施' }]}
        >
          <TextArea 
            placeholder="请描述防止污染土壤、水体、大气的措施" 
            rows={4}
          />
        </Form.Item>
      </Card>

      {/* 收容清除方法 */}
      <Card title="🧹 收容清除方法" size="small" style={{ marginBottom: 16 }}>
        <Form.Item
          label={
            <Space>
              泄漏化学品的收容、清除方法
              <Tooltip title="具体的收容和清理步骤">
                <InfoCircleOutlined />
              </Tooltip>
            </Space>
          }
          name="containmentCleanup"
          rules={[{ required: true, message: '请输入收容、清除方法' }]}
        >
          <TextArea 
            placeholder="请详细描述收容和清除泄漏物的具体方法和步骤" 
            rows={5}
          />
        </Form.Item>

        <Form.Item
          label="消除方法"
          name="eliminationMethods"
          rules={[{ required: true, message: '请输入消除方法' }]}
        >
          <TextArea 
            placeholder="请描述彻底消除污染的方法" 
            rows={3}
          />
        </Form.Item>

        <Form.Item
          label={
            <Space>
              清理时使用的器材
              <Tooltip title="清理泄漏时需要的工具和材料">
                <InfoCircleOutlined />
              </Tooltip>
            </Space>
          }
          name="equipmentMaterials"
        >
          <Select 
            mode="multiple"
            placeholder="请选择清理器材（可多选）"
            allowClear
          >
            {equipmentOptions.map(equipment => (
              <Option key={equipment} value={equipment}>{equipment}</Option>
            ))}
          </Select>
        </Form.Item>
      </Card>

      {/* 应急处理 */}
      <Card title="🚨 应急处理" size="small" style={{ marginBottom: 16 }}>
        <Form.Item
          label={
            <Space>
              应急处理程序
              <Tooltip title="发生泄漏时的应急响应程序">
                <InfoCircleOutlined />
              </Tooltip>
            </Space>
          }
          name="emergencyProcedures"
          rules={[{ required: true, message: '请输入应急处理程序' }]}
        >
          <TextArea 
            placeholder="请描述发现泄漏后的应急响应程序和步骤" 
            rows={4}
          />
        </Form.Item>

        <Form.Item
          label={
            <Space>
              防止发生次生危害的预防措施
              <Tooltip title="防止泄漏引发火灾、爆炸等次生事故的措施">
                <InfoCircleOutlined />
              </Tooltip>
            </Space>
          }
          name="preventSecondaryHazards"
        >
          <TextArea 
            placeholder="请描述防止次生危害的预防措施，如防火、防爆、防中毒等" 
            rows={3}
          />
        </Form.Item>
      </Card>

      {/* 填写提示 */}
      <Alert
        message="填写提示"
        description={
          <ul style={{ margin: 0, paddingLeft: 20 }}>
            <li>个人防护措施要具体到防护用品的级别和规格</li>
            <li>环境保护措施要考虑不同环境介质的特点</li>
            <li>收容清除方法要按照泄漏量的大小分别描述</li>
            <li>应急程序要包括报警、疏散、处置等环节</li>
            <li>次生危害预防要考虑化学品的特殊性质</li>
          </ul>
        }
        type="info"
        showIcon
        style={{ marginTop: 16 }}
      />
    </Form>
  );
});

Step6LeakResponse.displayName = 'Step6LeakResponse';

export default Step6LeakResponse;