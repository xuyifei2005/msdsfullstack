import React, { useRef } from 'react';
import type { ProColumns, ActionType } from '@ant-design/pro-components';
import { ProTable } from '@ant-design/pro-components';
import { message, Modal } from 'antd';
import { listFeedback, updateFeedback, removeFeedback } from '@/services/msds/feedback';
import { BetaSchemaForm } from '@ant-design/pro-components';

const FeedbackList: React.FC = () => {
  const actionRef = useRef<ActionType>();

  const handleReply = async (fields: any) => {
    const hide = message.loading('正在回复');
    try {
      await updateFeedback({ ...fields });
      hide();
      message.success('回复成功');
      actionRef.current?.reload();
      return true;
    } catch (error) {
      hide();
      message.error('回复失败请重试！');
      return false;
    }
  };

  const handleRemove = async (selectedRows: any[]) => {
    const hide = message.loading('正在删除');
    if (!selectedRows) return true;
    try {
      await removeFeedback(selectedRows.map((row) => row.id).join(','));
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
      title: '用户名',
      dataIndex: 'userName',
      valueType: 'text',
    },
    {
      title: '反馈内容',
      dataIndex: 'content',
      valueType: 'textarea',
      hideInSearch: true,
      width: 300,
    },
    {
      title: '联系方式',
      dataIndex: 'contactInfo',
      valueType: 'text',
      hideInSearch: true,
    },
    {
      title: '状态',
      dataIndex: 'status',
      valueEnum: {
        '0': { text: '未处理', status: 'Processing' },
        '1': { text: '已处理', status: 'Success' },
      },
    },
    {
      title: '提交时间',
      dataIndex: 'createTime',
      valueType: 'dateTime',
      hideInForm: true,
      hideInSearch: true,
    },
    {
      title: '回复内容',
      dataIndex: 'replyContent',
      valueType: 'textarea',
      hideInSearch: true,
    },
    {
      title: '回复时间',
      dataIndex: 'replyTime',
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
          key="reply"
          title="回复反馈"
          trigger={<a>回复</a>}
          layoutType="ModalForm"
          onFinish={async (values) => {
            return handleReply({ ...values, id: record.id });
          }}
          initialValues={record}
        >
             <BetaSchemaForm.Item
                name="content"
                label="反馈内容"
                readonly
             />
             <BetaSchemaForm.Item
                name="replyContent"
                label="回复内容"
                valueType="textarea"
                rules={[{ required: true, message: '请输入回复内容' }]}
             />
        </BetaSchemaForm>,
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
      headerTitle="意见反馈列表"
      actionRef={actionRef}
      rowKey="id"
      search={{
        labelWidth: 120,
      }}
      request={(params) =>
        listFeedback({ ...params, pageNum: params.current, pageSize: params.pageSize }).then((res) => ({
          data: res.rows,
          total: res.total,
          success: true,
        }))
      }
      columns={columns}
    />
  );
};

export default FeedbackList;
