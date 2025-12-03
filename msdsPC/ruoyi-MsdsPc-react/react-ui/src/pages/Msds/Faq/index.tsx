import React, { useRef } from 'react';
import type { ProColumns, ActionType } from '@ant-design/pro-components';
import { ProTable } from '@ant-design/pro-components';
import { Button, message, Modal } from 'antd';
import { PlusOutlined, DeleteOutlined, EditOutlined } from '@ant-design/icons';
import { listFaq, addFaq, updateFaq, removeFaq } from '@/services/msds/faq';
import { BetaSchemaForm } from '@ant-design/pro-components';

const FaqList: React.FC = () => {
  const actionRef = useRef<ActionType>();

  const handleAdd = async (fields: any) => {
    const hide = message.loading('正在添加');
    try {
      await addFaq({ ...fields });
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
    const hide = message.loading('正在配置');
    try {
      await updateFaq({ ...fields });
      hide();
      message.success('配置成功');
      actionRef.current?.reload();
      return true;
    } catch (error) {
      hide();
      message.error('配置失败请重试！');
      return false;
    }
  };

  const handleRemove = async (selectedRows: any[]) => {
    const hide = message.loading('正在删除');
    if (!selectedRows) return true;
    try {
      await removeFaq(selectedRows.map((row) => row.id).join(','));
      hide();
      message.success('删除成功');
      actionRef.current?.reload();
      return true;
    } catch (error) {
      hide();
      message.error('删除失败，请重试');
      return false;
    }
  };

  const columns: ProColumns<any>[] = [
    {
      title: '问题',
      dataIndex: 'question',
      valueType: 'textarea',
      formItemProps: {
        rules: [{ required: true, message: '此项为必填项' }],
      },
    },
    {
      title: '回答',
      dataIndex: 'answer',
      valueType: 'textarea',
      hideInSearch: true,
      formItemProps: {
        rules: [{ required: true, message: '此项为必填项' }],
      },
    },
    {
      title: '分类',
      dataIndex: 'category',
      valueType: 'text',
    },
    {
      title: '排序',
      dataIndex: 'sortOrder',
      valueType: 'digit',
      hideInSearch: true,
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
      title: '创建时间',
      dataIndex: 'createTime',
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
          title="编辑常见问题"
          trigger={<a>编辑</a>}
          layoutType="ModalForm"
          onFinish={async (values) => {
            return handleUpdate({ ...values, id: record.id });
          }}
          columns={columns as any}
          initialValues={record}
        />,
        <a
          key="delete"
          onClick={() => {
            Modal.confirm({
              title: '确定删除吗？',
              onOk: async () => {
                await handleRemove([record]);
              },
            });
          }}
        >
          删除
        </a>,
      ],
    },
  ];

  return (
    <ProTable<any>
      headerTitle="常见问题列表"
      actionRef={actionRef}
      rowKey="id"
      search={{
        labelWidth: 120,
      }}
      toolBarRender={() => [
        <BetaSchemaForm
          key="add"
          title="新建常见问题"
          trigger={
            <Button type="primary">
              <PlusOutlined /> 新建
            </Button>
          }
          layoutType="ModalForm"
          onFinish={async (values) => {
            return handleAdd(values);
          }}
          columns={columns as any}
        />,
      ]}
      request={(params) =>
        listFaq({ ...params, pageNum: params.current, pageSize: params.pageSize }).then((res) => ({
          data: res.rows,
          total: res.total,
          success: true,
        }))
      }
      columns={columns}
    />
  );
};

export default FaqList;
