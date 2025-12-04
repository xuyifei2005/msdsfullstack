import React, { useRef } from 'react';
import type { ProColumns, ActionType } from '@ant-design/pro-components';
import { ProTable } from '@ant-design/pro-components';
import { listFeedback } from '@/services/msds/feedback';

const FeedbackList: React.FC = () => {
  const actionRef = useRef<ActionType>();

  const columns: ProColumns<any>[] = [
    {
      title: '用户名',
      dataIndex: 'userName',
    },
    {
      title: '反馈类型',
      dataIndex: 'feedbackType',
    },
    {
      title: '反馈内容',
      dataIndex: 'content',
      hideInSearch: true,
      width: 300,
      ellipsis: true,
    },
    {
      title: '联系方式',
      dataIndex: 'contactInfo',
      hideInSearch: true,
    },
    {
      title: '图片',
      dataIndex: 'images',
      hideInSearch: true,
    },
    {
      title: '状态',
      dataIndex: 'status',
    },
    {
      title: '提交时间',
      dataIndex: 'createTime',
      hideInForm: true,
      hideInSearch: true,
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
      request={async (params) => {
        console.log('DEBUG: Requesting feedback list with params:', params);
        try {
          const msg = await listFeedback(params);
          console.log('DEBUG: API Response:', msg);
          
          // 严格的数据适配，防止 undefined 报错
          const list = (msg && msg.rows && Array.isArray(msg.rows)) ? msg.rows : [];
          const total = (msg && msg.total) ? msg.total : 0;
          
          return {
            data: list,
            success: true,
            total: total,
          };
        } catch (error) {
          console.error('DEBUG: Request failed:', error);
          return {
            data: [],
            success: true,
            total: 0,
          };
        }
      }}
      columns={columns}
    />
  );
};

export default FeedbackList;
