import React, { useEffect } from 'react';
import { Form, Input, Radio, Switch, message } from 'antd';
import { ModalForm, ProFormText, ProFormTextArea, ProFormRadio } from '@ant-design/pro-components';

export type MsdsFormProps = {
  open: boolean;
  onOpenChange: (visible: boolean) => void;
  onFinish: (values: API.Msds.MsdsMain) => Promise<boolean>;
  values?: Partial<API.Msds.MsdsMain>;
  title?: string;
};

const { TextArea } = Input;

const MsdsForm: React.FC<MsdsFormProps> = (props) => {
  const { open, onOpenChange, onFinish, values, title = '新增MSDS' } = props;
  const [form] = Form.useForm();

  useEffect(() => {
    if (open && values) {
      form.setFieldsValue(values);
    } else if (open) {
      form.resetFields();
    }
  }, [open, values, form]);

  const handleFinish = async (formValues: API.Msds.MsdsMain) => {
    try {
      const success = await onFinish({ ...values, ...formValues });
      if (success) {
        form.resetFields();
        onOpenChange(false);
        return true;
      }
      return false;
    } catch (error) {
      message.error('操作失败，请重试！');
      return false;
    }
  };

  return (
    <ModalForm
      title={title}
      width={800}
      open={open}
      onOpenChange={onOpenChange}
      form={form}
      onFinish={handleFinish}
      modalProps={{
        destroyOnClose: true,
        onCancel: () => {
          form.resetFields();
          onOpenChange(false);
        },
      }}
    >
      <ProFormText
        name="productName"
        label="化学品中文名"
        placeholder="请输入化学品中文名"
        rules={[
          { required: true, message: '化学品中文名不能为空' },
          { max: 255, message: '化学品中文名不能超过255个字符' },
        ]}
      />

      <ProFormText
        name="productAlias"
        label="化学品别名"
        placeholder="请输入化学品别名"
        rules={[{ max: 255, message: '化学品别名不能超过255个字符' }]}
      />

      <ProFormText
        name="productEnglishName"
        label="化学品英文名"
        placeholder="请输入化学品英文名"
        rules={[{ max: 255, message: '化学品英文名不能超过255个字符' }]}
      />

      <ProFormText
        name="companyName"
        label="企业名称"
        placeholder="请输入企业名称"
        rules={[
          { required: true, message: '企业名称不能为空' },
          { max: 255, message: '企业名称不能超过255个字符' },
        ]}
      />

      <ProFormTextArea
        name="companyAddress"
        label="企业地址"
        placeholder="请输入企业地址"
        fieldProps={{
          rows: 3,
        }}
      />

      <ProFormText
        name="zipCode"
        label="邮编"
        placeholder="请输入邮编"
        rules={[{ max: 10, message: '邮编不能超过10个字符' }]}
      />

      <ProFormText
        name="contactPhone"
        label="联系电话"
        placeholder="请输入联系电话"
        rules={[
          { required: true, message: '联系电话不能为空' },
          { max: 50, message: '联系电话不能超过50个字符' },
        ]}
      />

      <ProFormText
        name="faxNumber"
        label="传真号码"
        placeholder="请输入传真号码"
        rules={[{ max: 50, message: '传真号码不能超过50个字符' }]}
      />

      <ProFormText
        name="email"
        label="电子邮件地址"
        placeholder="请输入电子邮件地址"
        rules={[
          { type: 'email', message: '请输入有效的电子邮件地址' },
          { max: 100, message: '电子邮件地址不能超过100个字符' },
        ]}
      />

      <ProFormText
        name="emergencyPhone"
        label="企业应急电话"
        placeholder="请输入企业应急电话"
        rules={[{ max: 50, message: '企业应急电话不能超过50个字符' }]}
      />

      <ProFormTextArea
        name="recommendedUsage"
        label="产品推荐用途"
        placeholder="请输入产品推荐用途"
        fieldProps={{
          rows: 3,
        }}
      />

      <ProFormTextArea
        name="restrictedUsage"
        label="产品限制用途"
        placeholder="请输入产品限制用途"
        fieldProps={{
          rows: 3,
        }}
      />

      <ProFormText
        name="version"
        label="MSDS版本号"
        placeholder="请输入MSDS版本号"
        rules={[{ max: 20, message: 'MSDS版本号不能超过20个字符' }]}
      />

      <ProFormRadio.Group
        name="isActive"
        label="状态"
        initialValue={1}
        options={[
          { label: '有效', value: 1 },
          { label: '无效', value: 0 },
        ]}
      />

      <ProFormTextArea
        name="remark"
        label="备注"
        placeholder="请输入备注信息"
        fieldProps={{
          rows: 3,
        }}
      />
    </ModalForm>
  );
};

export default MsdsForm; 