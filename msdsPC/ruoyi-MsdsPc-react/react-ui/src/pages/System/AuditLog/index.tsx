import React, { useRef, useState } from 'react';
import { PageContainer, ProColumns, ProTable, ActionType } from '@ant-design/pro-components';
import { Button, Modal, Space, Tag, Descriptions, message } from 'antd';
import { ExportOutlined, DeleteOutlined, EyeOutlined, RedoOutlined } from '@ant-design/icons';
import type { API } from '@/types/msds';
import { getAuditLogList, exportAuditLog, removeAuditLog, getAuditLog as getAuditLogInfo } from '@/services/system/auditlog';

const { confirm } = Modal;

const AuditLogPage: React.FC = () => {
  const actionRef = useRef<ActionType>();
  const [detailOpen, setDetailOpen] = useState(false);
  const [detailData, setDetailData] = useState<API.System.MsdsAuditLog | null>(null);

  const handleExport = async (params?: any) => {
    try {
      await exportAuditLog(params);
      message.success('导出成功');
    } catch (e) {
      message.error('导出失败，请重试');
    }
  };

  const handleRemove = async (rows: API.System.MsdsAuditLog[]) => {
    if (!rows || rows.length === 0) return;
    confirm({
      title: '确认删除所选日志吗？',
      content: '删除后将无法恢复，请谨慎操作。',
      onOk: async () => {
        const ids = rows.map((r) => r.logId!).filter(Boolean);
        const hide = message.loading('正在删除');
        try {
          await removeAuditLog(ids);
          message.success('删除成功');
          actionRef.current?.reload();
        } catch (e) {
          message.error('删除失败，请重试');
        } finally {
          hide();
        }
      },
    });
  };

  const openDetail = async (record: API.System.MsdsAuditLog) => {
    try {
      const res = await getAuditLogInfo(record.logId!);
      if (res.code === 200) {
        setDetailData(res.data);
        setDetailOpen(true);
      }
    } catch (e) {
      message.error('获取详情失败');
    }
  };

  const columns: ProColumns<API.System.MsdsAuditLog>[] = [
    { title: '日志ID', dataIndex: 'logId', valueType: 'text', width: 100, search: false },
    { title: 'MSDS ID', dataIndex: 'msdsId', valueType: 'text', width: 100 },
    {
      title: '操作类型', dataIndex: 'operationType', valueType: 'select',
      valueEnum: {
        CREATE: { text: '创建', status: 'Processing' },
        UPDATE: { text: '更新', status: 'Warning' },
        DELETE: { text: '删除', status: 'Error' },
        EXPORT: { text: '导出', status: 'Default' },
        IMPORT: { text: '导入', status: 'Default' },
        VIEW: { text: '查看', status: 'Default' },
      },
      render: (_, record) => {
        const map: Record<string, string> = {
          CREATE: 'green', UPDATE: 'orange', DELETE: 'red', EXPORT: 'blue', IMPORT: 'purple', VIEW: 'default',
        };
        const color = map[record.operationType || 'VIEW'] || 'default';
        return <Tag color={color}>{record.operationType || '-'}</Tag>;
      },
    },
    { title: '操作描述', dataIndex: 'operationDesc', valueType: 'text', ellipsis: true, width: 220 },
    { title: '操作人', dataIndex: 'operator', valueType: 'text', width: 120 },
    { title: 'IP地址', dataIndex: 'ipAddress', valueType: 'text', width: 130 },
    { title: '操作结果', dataIndex: 'operationResult', valueType: 'select',
      valueEnum: { SUCCESS: { text: '成功', status: 'Success' }, FAIL: { text: '失败', status: 'Error' } },
      render: (_, r) => <Tag color={r.operationResult === 'SUCCESS' ? 'green' : 'red'}>{r.operationResult || '-'}</Tag>,
    },
    { title: '操作时间', dataIndex: 'operationTime', valueType: 'dateTime', width: 180 },
    {
      title: '操作', valueType: 'option', width: 120, fixed: 'right',
      render: (_, record) => (
        <Space>
          <Button size="small" type="link" icon={<EyeOutlined />} onClick={() => openDetail(record)}>详情</Button>
        </Space>
      ),
    },
  ];

  return (
    <PageContainer>
      <ProTable<API.System.MsdsAuditLog>
        rowKey="logId"
        actionRef={actionRef}
        columns={columns}
        request={async (params) => {
          const { current, pageSize, ...rest } = params as any;
          const res = await getAuditLogList({ pageNum: current, pageSize, ...rest });
          return {
            data: res.rows || [],
            success: res.code === 200,
            total: res.total || 0,
          };
        }}
        pagination={{ showSizeChanger: true }}
        search={{ labelWidth: 100 }}
        toolBarRender={(action, { selectedRows = [] }) => [
          <Button key="export" icon={<ExportOutlined />} onClick={() => handleExport(action?.getSearchParams?.())}>导出</Button>,
          <Button key="remove" danger icon={<DeleteOutlined />} disabled={selectedRows.length === 0} onClick={() => handleRemove(selectedRows as any)}>删除</Button>,
          <Button key="refresh" icon={<RedoOutlined />} onClick={() => action?.reload?.()}>刷新</Button>,
        ]}
        rowSelection={{}}
        scroll={{ x: 1200 }}
      />

      <Modal
        title="审计日志详情"
        open={detailOpen}
        onCancel={() => setDetailOpen(false)}
        footer={null}
        width={800}
      >
        {detailData && (
          <Descriptions bordered column={2} size="small">
            <Descriptions.Item label="日志ID">{detailData.logId}</Descriptions.Item>
            <Descriptions.Item label="MSDS ID">{detailData.msdsId}</Descriptions.Item>
            <Descriptions.Item label="操作类型">{detailData.operationType}</Descriptions.Item>
            <Descriptions.Item label="操作结果">{detailData.operationResult}</Descriptions.Item>
            <Descriptions.Item label="操作人">{detailData.operator}</Descriptions.Item>
            <Descriptions.Item label="操作时间">{detailData.operationTime}</Descriptions.Item>
            <Descriptions.Item label="IP地址">{detailData.ipAddress}</Descriptions.Item>
            <Descriptions.Item label="UserAgent" span={2}>{detailData.userAgent}</Descriptions.Item>
            <Descriptions.Item label="操作描述" span={2}>{detailData.operationDesc}</Descriptions.Item>
            <Descriptions.Item label="错误信息" span={2}>{detailData.errorMessage || '-'}</Descriptions.Item>
            <Descriptions.Item label="变更前数据" span={2}><pre style={{ whiteSpace: 'pre-wrap' }}>{detailData.beforeData || '-'}</pre></Descriptions.Item>
            <Descriptions.Item label="变更后数据" span={2}><pre style={{ whiteSpace: 'pre-wrap' }}>{detailData.afterData || '-'}</pre></Descriptions.Item>
            <Descriptions.Item label="备注" span={2}>{detailData.remark || '-'}</Descriptions.Item>
          </Descriptions>
        )}
      </Modal>
    </PageContainer>
  );
};

export default AuditLogPage;