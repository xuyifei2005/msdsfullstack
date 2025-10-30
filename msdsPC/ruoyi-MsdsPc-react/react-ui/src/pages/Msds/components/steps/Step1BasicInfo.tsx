import React, { forwardRef, useImperativeHandle, useEffect } from 'react';
import { 
  Form, 
  Input, 
  Card, 
  Row, 
  Col, 
  Space, 
  DatePicker,
  Select,
  Tooltip,
  Alert
} from 'antd';
import { 
  InfoCircleOutlined,
  CheckCircleOutlined,
  ExclamationCircleOutlined
} from '@ant-design/icons';
import type { API } from '@/types/msds';
import dayjs from 'dayjs';

const { TextArea } = Input;
const { Option } = Select;

interface Step1BasicInfoProps {
  data?: API.Msds.MsdsMain;
  onChange?: (data: API.Msds.MsdsMain) => void;
}

const Step1BasicInfo = forwardRef<any, Step1BasicInfoProps>(({ data, onChange }, ref) => {
  const [form] = Form.useForm();

  useImperativeHandle(ref, () => ({
    validateFields: () => form.validateFields(),
    getFieldsValue: () => form.getFieldsValue(),
    setFieldsValue: (values: any) => form.setFieldsValue(values)
  }));

  useEffect(() => {
    console.log('🔍 [Step1BasicInfo] 接收到data prop:', data);
    if (data) {
      const formData = {
        ...data,
        revisionDate: data.revisionDate ? dayjs(data.revisionDate) : undefined,
        effectiveDate: data.effectiveDate ? dayjs(data.effectiveDate) : undefined,
        approvalDate: data.approvalDate ? dayjs(data.approvalDate) : undefined
      };
      console.log('📝 [Step1BasicInfo] 设置表单值:', formData);
      form.setFieldsValue(formData);
      console.log('✅ [Step1BasicInfo] 表单值已设置');
    } else {
      console.log('⚪ [Step1BasicInfo] data为空，不设置表单值');
    }
  }, [data, form]);

  // 表单值变化时触发onChange
  const handleValuesChange = (changedValues: any, allValues: any) => {
    if (onChange) {
      const formattedValues = {
        ...allValues,
        revisionDate: allValues.revisionDate?.format('YYYY-MM-DD'),
        effectiveDate: allValues.effectiveDate?.format('YYYY-MM-DD'),
        approvalDate: allValues.approvalDate?.format('YYYY-MM-DD')
      };
      onChange(formattedValues);
    }
  };

  // 状态选项
  const statusOptions = [
    { label: '草稿', value: 'draft', color: 'default' },
    { label: '待审核', value: 'pending', color: 'processing' },
    { label: '已批准', value: 'approved', color: 'success' },
    { label: '已归档', value: 'archived', color: 'error' }
  ];

  return (
    <Form
      form={form}
      layout="vertical"
      onValuesChange={handleValuesChange}
      autoComplete="off"
    >
      <Alert
        message="第1节：化学品及企业标识"
        description="请填写化学品的基本信息和企业标识信息。标有 * 的字段为必填项。"
        type="info"
        showIcon
        style={{ marginBottom: 24 }}
      />

      {/* 化学品基本信息 */}
      <Card title="🧪 化学品基本信息" size="small" style={{ marginBottom: 16 }}>
        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              label={
                <Space>
                  化学品中文名
                  <Tooltip title="化学品的标准中文名称">
                    <InfoCircleOutlined />
                  </Tooltip>
                </Space>
              }
              name="productName"
              rules={[
                { required: true, message: '请输入化学品中文名' },
                { max: 255, message: '化学品中文名不能超过255个字符' }
              ]}
            >
              <Input placeholder="请输入化学品中文名" />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              label={
                <Space>
                  化学品英文名
                  <Tooltip title="化学品的标准英文名称">
                    <InfoCircleOutlined />
                  </Tooltip>
                </Space>
              }
              name="productEnglishName"
              rules={[{ max: 255, message: '化学品英文名不能超过255个字符' }]}
            >
              <Input placeholder="请输入化学品英文名" />
            </Form.Item>
          </Col>
        </Row>

        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              label={
                <Space>
                  CAS登记号
                  <Tooltip title="Chemical Abstracts Service登记号">
                    <InfoCircleOutlined />
                  </Tooltip>
                </Space>
              }
              name="casNumber"
              rules={[
                { pattern: /^\d{2,7}-\d{2}-\d$/, message: '请输入正确的CAS号格式（如：64-17-5）' }
              ]}
            >
              <Input placeholder="请输入CAS号（如：64-17-5）" />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              label={
                <Space>
                  MSDS编号
                  <Tooltip title="企业内部MSDS编号">
                    <InfoCircleOutlined />
                  </Tooltip>
                </Space>
              }
              name="msdsCode"
              rules={[{ max: 50, message: 'MSDS编号不能超过50个字符' }]}
            >
              <Input placeholder="请输入MSDS编号" />
            </Form.Item>
          </Col>
        </Row>

        <Form.Item
          label={
            <Space>
              化学品别名
              <Tooltip title="化学品的其他名称或商品名">
                <InfoCircleOutlined />
              </Tooltip>
            </Space>
          }
          name="productAlias"
          rules={[{ max: 255, message: '化学品别名不能超过255个字符' }]}
        >
          <TextArea 
            placeholder="请输入化学品别名，多个别名用逗号分隔" 
            rows={2}
          />
        </Form.Item>

        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              label="推荐用途"
              name="recommendedUsage"
            >
              <TextArea 
                placeholder="请输入产品推荐用途" 
                rows={3}
              />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              label="限制用途"
              name="restrictedUsage"
            >
              <TextArea 
                placeholder="请输入产品限制用途" 
                rows={3}
              />
            </Form.Item>
          </Col>
        </Row>
      </Card>

      {/* 企业信息 */}
      <Card title="🏢 企业信息" size="small" style={{ marginBottom: 16 }}>
        <Row gutter={16}>
          <Col span={12}>
            <Form.Item
              label="企业名称"
              name="companyName"
              rules={[
                { required: true, message: '请输入企业名称' },
                { max: 255, message: '企业名称不能超过255个字符' }
              ]}
            >
              <Input placeholder="请输入企业名称" />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              label="联系电话"
              name="contactPhone"
              rules={[
                { required: true, message: '请输入联系电话' },
                { max: 50, message: '联系电话不能超过50个字符' }
              ]}
            >
              <Input placeholder="请输入联系电话" />
            </Form.Item>
          </Col>
        </Row>

        <Form.Item
          label="企业地址"
          name="companyAddress"
        >
          <TextArea 
            placeholder="请输入企业详细地址" 
            rows={2}
          />
        </Form.Item>

        <Row gutter={16}>
          <Col span={8}>
            <Form.Item
              label="邮编"
              name="zipCode"
              rules={[
                { pattern: /^\d{6}$/, message: '请输入6位数字邮编' }
              ]}
            >
              <Input placeholder="请输入邮编" />
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item
              label="传真号码"
              name="faxNumber"
              rules={[{ max: 50, message: '传真号码不能超过50个字符' }]}
            >
              <Input placeholder="请输入传真号码" />
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item
              label="电子邮件"
              name="email"
              rules={[
                { type: 'email', message: '请输入有效的电子邮件地址' },
                { max: 100, message: '电子邮件地址不能超过100个字符' }
              ]}
            >
              <Input placeholder="请输入电子邮件地址" />
            </Form.Item>
          </Col>
        </Row>

        <Form.Item
          label={
            <Space>
              企业应急电话
              <Tooltip title="24小时应急联系电话">
                <InfoCircleOutlined />
              </Tooltip>
            </Space>
          }
          name="emergencyPhone"
          rules={[{ max: 50, message: '企业应急电话不能超过50个字符' }]}
        >
          <Input placeholder="请输入企业应急电话" />
        </Form.Item>
      </Card>

      {/* 版本信息 */}
      <Card title="📋 版本信息" size="small" style={{ marginBottom: 16 }}>
        <Row gutter={16}>
          <Col span={8}>
            <Form.Item
              label="MSDS版本号"
              name="version"
              rules={[{ max: 20, message: 'MSDS版本号不能超过20个字符' }]}
            >
              <Input placeholder="如：V1.0" />
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item
              label="修订日期"
              name="revisionDate"
            >
              <DatePicker 
                style={{ width: '100%' }}
                placeholder="选择修订日期"
              />
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item
              label="生效日期"
              name="effectiveDate"
            >
              <DatePicker 
                style={{ width: '100%' }}
                placeholder="选择生效日期"
              />
            </Form.Item>
          </Col>
        </Row>

        <Row gutter={16}>
          <Col span={8}>
            <Form.Item
              label="状态"
              name="status"
              initialValue="draft"
            >
              <Select placeholder="请选择状态">
                {statusOptions.map(option => (
                  <Option key={option.value} value={option.value}>
                    {option.label}
                  </Option>
                ))}
              </Select>
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item
              label="审批人"
              name="approver"
              rules={[{ max: 50, message: '审批人不能超过50个字符' }]}
            >
              <Input placeholder="请输入审批人" />
            </Form.Item>
          </Col>
          <Col span={8}>
            <Form.Item
              label="审批日期"
              name="approvalDate"
            >
              <DatePicker 
                style={{ width: '100%' }}
                placeholder="选择审批日期"
              />
            </Form.Item>
          </Col>
        </Row>

        <Form.Item
          label="备注"
          name="remark"
        >
          <TextArea 
            placeholder="请输入备注信息" 
            rows={3}
          />
        </Form.Item>
      </Card>

      {/* 填写提示 */}
      <Alert
        message="填写提示"
        description={
          <ul style={{ margin: 0, paddingLeft: 20 }}>
            <li>CAS号格式：数字-数字-数字（如：64-17-5）</li>
            <li>企业应急电话应为24小时有效联系方式</li>
            <li>版本号建议使用V1.0、V1.1等格式</li>
            <li>状态变更需要相应的审批流程</li>
          </ul>
        }
        type="info"
        showIcon
        style={{ marginTop: 16 }}
      />
    </Form>
  );
});

Step1BasicInfo.displayName = 'Step1BasicInfo';

export default Step1BasicInfo; 