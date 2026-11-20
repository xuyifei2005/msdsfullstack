import React, { useRef } from 'react';
import type { ProColumns, ActionType } from '@ant-design/pro-components';
import { ProTable } from '@ant-design/pro-components';
import { message, Button, Tag } from 'antd';
import { HistoryOutlined } from '@ant-design/icons';
import { useNavigate } from '@umijs/max';
import { getUserFavorites, removeFavorite, type UserFavorite } from '@/services/msds';

/**
 * 我的收藏
 *
 * <p>展示当前用户收藏的 MSDS 文档（数据来自 msds_user_favorite），支持跳转到详情与取消收藏。</p>
 */
const FavoriteList: React.FC = () => {
  const actionRef = useRef<ActionType>();
  const navigate = useNavigate();

  const columns: ProColumns<UserFavorite>[] = [
    {
      title: '化学品名称',
      dataIndex: 'msdsName',
      width: 240,
      render: (_, record) => record.msdsName || '-',
    },
    {
      title: 'CAS号',
      dataIndex: 'casNumber',
      width: 150,
      render: (_, record) => record.casNumber || '-',
    },
    {
      title: '收藏夹',
      dataIndex: 'folderName',
      width: 140,
      render: (_, record) => record.folderName || '默认收藏夹',
    },
    {
      title: '标签',
      dataIndex: 'tags',
      hideInSearch: true,
      render: (_, record) => {
        if (!record.tags) {
          return '-';
        }
        return (
          <span>
            {String(record.tags)
              .split(',')
              .filter(Boolean)
              .map((tag) => (
                <Tag key={tag} style={{ marginRight: 4 }}>
                  {tag}
                </Tag>
              ))}
          </span>
        );
      },
    },
    {
      title: '备注',
      dataIndex: 'note',
      hideInSearch: true,
      ellipsis: true,
    },
    {
      title: '收藏时间',
      dataIndex: 'createTime',
      width: 180,
      hideInSearch: true,
    },
    {
      title: '操作',
      valueType: 'option',
      width: 160,
      render: (_, record) => [
        <a
          key="detail"
          onClick={() => navigate(`/msds/detail/${record.msdsId}`)}
        >
          查看详情
        </a>,
        <a
          key="remove"
          style={{ marginLeft: 8, color: '#ff4d4f' }}
          onClick={async () => {
            try {
              await removeFavorite(record.msdsId);
              message.success('已取消收藏');
              actionRef.current?.reload();
            } catch (e) {
              message.error('取消收藏失败，请重试');
            }
          }}
        >
          取消收藏
        </a>,
      ],
    },
  ];

  return (
    <div style={{ padding: 16 }}>
      <ProTable
        actionRef={actionRef}
        rowKey="favoriteId"
        columns={columns}
        request={async () => {
          const res = await getUserFavorites();
          const rows = res?.data || [];
          return {
            data: rows,
            success: res?.code === 200,
            total: rows.length,
          };
        }}
        headerTitle="我的收藏"
        toolBarRender={() => [
          <Button
            key="refresh"
            icon={<HistoryOutlined />}
            onClick={() => actionRef.current?.reload()}
          >
            刷新
          </Button>,
        ]}
        options={{
          fullScreen: false,
          reload: true,
          setting: true,
          density: true,
        }}
        search={false}
        pagination={{ defaultPageSize: 10, showSizeChanger: true }}
        locale={{ emptyText: '暂无收藏记录，可在文档详情页点击「收藏」添加' }}
      />
    </div>
  );
};

export default FavoriteList;
