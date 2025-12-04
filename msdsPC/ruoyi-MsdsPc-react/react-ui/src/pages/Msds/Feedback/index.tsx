import React, { useRef } from 'react';
import type { ProColumns, ActionType } from '@ant-design/pro-components';
import { ProTable } from '@ant-design/pro-components';
import { listFeedback } from '@/services/msds/feedback';
import { Image, Tag, Alert } from 'antd';

const FeedbackList: React.FC = () => {
  const actionRef = useRef<ActionType>();

  const columns: ProColumns<any>[] = [
    {
      title: 'ID',
      dataIndex: 'id',
      width: 60,
      hideInSearch: true,
    },
    {
      title: '用户名',
      dataIndex: 'userName',
      render: (dom, entity) => entity.userName || '-',
    },
    {
      title: '反馈类型',
      dataIndex: 'feedbackType',
      render: (dom, entity) => (
        <Tag color="blue">{entity.feedbackType || '其他'}</Tag>
      ),
    },
    {
      title: '反馈内容',
      dataIndex: 'content',
      width: 300,
      ellipsis: true,
      copyable: true,
    },
    {
      title: '联系方式',
      dataIndex: 'contactInfo',
      hideInSearch: true,
      render: (dom, entity) => entity.contactInfo || '-',
    },
    {
      title: '图片',
      dataIndex: 'images',
      hideInSearch: true,
      width: 100,
      render: (_, entity) => {
        if (!entity.images) return '-';
        // 支持多张图片，逗号分隔
        const imgs = entity.images.split(',').filter((url: string) => url && url.trim());
        if (imgs.length === 0) return '-';
        
        return (
            <Image.PreviewGroup>
                {imgs.map((url: string, index: number) => (
                    <Image
                        key={index}
                        width={50}
                        height={50}
                        src={url}
                        style={{ objectFit: 'cover', marginRight: 4 }}
                    />
                ))}
            </Image.PreviewGroup>
        );
      },
    },
    {
      title: '提交时间',
      dataIndex: 'createTime',
      valueType: 'dateTime',
      hideInSearch: true,
    },
  ];

  return (
    <div>
        <Alert 
            message="页面已更新 - v2.0 (如果看到此消息，说明热更新已生效)" 
            type="success" 
            showIcon 
            closable 
            style={{ marginBottom: 12 }} 
        />
        <ProTable<any>
        headerTitle="意见反馈列表"
        actionRef={actionRef}
        rowKey="id"
        search={{
            labelWidth: 100,
        }}
        toolBarRender={() => []}
        request={async (params) => {
            try {
            console.log('Fetching feedback list...', params);
            const msg = await listFeedback(params);
            console.log('Feedback list response:', msg);
            
            // 极其防御性的数据适配
            let dataSource = [];
            let total = 0;

            if (msg) {
                if (Array.isArray(msg.rows)) {
                    dataSource = msg.rows;
                    total = msg.total || msg.rows.length;
                } else if (Array.isArray(msg)) {
                    // 兼容直接返回数组的情况
                    dataSource = msg;
                    total = msg.length;
                }
            }

            return {
                data: dataSource,
                success: true,
                total: total,
            };
            } catch (error) {
            console.error('Failed to fetch feedback list:', error);
            // 发生错误时返回空列表，避免页面崩溃
            return {
                data: [],
                success: true,
                total: 0,
            };
            }
        }}
        columns={columns}
        pagination={{
            pageSize: 10,
        }}
        />
    </div>
  );
};

export default FeedbackList;
