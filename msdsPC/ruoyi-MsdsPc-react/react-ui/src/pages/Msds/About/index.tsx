import React, { useRef } from 'react';
import type { ProColumns, ActionType } from '@ant-design/pro-components';
import { ProTable } from '@ant-design/pro-components';
import { Button, message } from 'antd';
import { PlusOutlined } from '@ant-design/icons';
import { listAbout, addAbout, updateAbout, removeAbout } from '@/services/msds/about';
import { BetaSchemaForm } from '@ant-design/pro-components';

const AboutList: React.FC = () => {
  const actionRef = useRef<ActionType>();

  const handleAdd = async (fields: any) => {
    const hide = message.loading('正在添加');
    try {
      await addAbout({ ...fields });
      hide();
      message.success('添加成功');
      actionRef.current?.reload();
      return true;
    } catch (error) {
      hide();
      message.error('添加失败请重试！');
      return false;
    }
  };

  const handleUpdate = async (fields: any) => {
    const hide = message.loading('正在更新');
    try {
      await updateAbout({ ...fields });
      hide();
      message.success('更新成功');
      actionRef.current?.reload();
      return true;
    } catch (error) {
      hide();
      message.error('更新失败请重试！');
      return false;
    }
  };

  const columns: ProColumns<any>[] = [
    {
      title: '标题',
      dataIndex: 'title',
      valueType: 'text',
      formItemProps: {
        rules: [{ required: true, message: '此项为必填项' }],
      },
    },
    {
      title: '类型',
      dataIndex: 'type',
      valueType: 'text',
      hideInSearch: true,
      readonly: true, // Type usually shouldn't change for system pages
    },
    {
        title: '内容',
        dataIndex: 'content',
        valueType: 'textarea',
        hideInTable: true,
        hideInSearch: true,
        formItemProps: {
            rules: [{ required: true, message: '此项为必填项' }],
        },
        fieldProps: {
            rows: 10
        }
    },
    {
      title: '状态',
      dataIndex: 'status',
      valueEnum: {
        '0': { text: '正常', status: 'Success' },
        '1': { text: '停用', status: 'Error' },
      },
    },
    {
      title: '最后更新时间',
      dataIndex: 'updateTime',
      valueType: 'dateTime',
      hideInForm: true,
      hideInSearch: true,
    },
    {
      title: '操作',
      dataIndex: 'option',
      valueType: 'option',
      render: (_, record) => [
        <BetaSchemaForm
          key="edit"
          title="编辑内容"
          trigger={<a>编辑</a>}
          layoutType="ModalForm"
          onFinish={async (values) => {
            return handleUpdate({ ...values, id: record.id });
          }}
          columns={columns as any}
          initialValues={record}
          width={800}
        />,
      ],
    },
  ];

  return (
    <ProTable<any>
      headerTitle="关于我们管理"
      actionRef={actionRef}
      rowKey="id"
      search={false}
      toolBarRender={() => [
          // Usually About Us pages are fixed, so no Add button needed by default unless for dynamic pages
        // <BetaSchemaForm
        //   key="add"
        //   title="新建页面"
        //   trigger={
        //     <Button type="primary">
        //       <PlusOutlined /> 新建
        //     </Button>
        //   }
        //   layoutType="ModalForm"
        //   onFinish={async (values) => {
        //     return handleAdd(values);
        //   }}
        //   columns={columns as any}
        // />,
      ]}
      request={(params) =>
        listAbout({ ...params, pageNum: params.current, pageSize: params.pageSize }).then((res) => ({
          data: res.rows,
          total: res.total,
          success: true,
        }))
      }
      columns={columns}
    />
  );
};

export default AboutList;
