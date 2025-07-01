import React, { useState, useRef } from 'react';
import { useIntl, FormattedMessage, useAccess } from '@umijs/max';
import { Button, message, Modal, Space, Tag, Tooltip } from 'antd';
import { ActionType, FooterToolbar, PageContainer, ProColumns, ProTable } from '@ant-design/pro-components';
import { PlusOutlined, DeleteOutlined, ExclamationCircleOutlined, EditOutlined, EyeOutlined, ExportOutlined, UploadOutlined } from '@ant-design/icons';
import { 
  getMsdsMainList, 
  removeMsdsMain, 
  addMsdsMain, 
  updateMsdsMain, 
  exportMsdsMain,
  getMsdsMain 
} from '@/services/msds';
import MsdsForm from './components/MsdsForm';
import MsdsDetail from './components/MsdsDetail';
import ImportModal from './components/ImportModal';

const { confirm } = Modal;

/**
 * MSDS主信息管理页面
 * 
 * @author ruoyi
 * @datetime 2024-12-26
 */

/**
 * 添加MSDS
 */
const handleAdd = async (fields: API.Msds.MsdsMain) => {
  const hide = message.loading('正在添加');
  try {
    await addMsdsMain({ ...fields });
    hide();
    message.success('添加成功');
    return true;
  } catch (error) {
    hide();
    message.error('添加失败请重试！');
    return false;
  }
};

/**
 * 更新MSDS
 */
const handleUpdate = async (fields: API.Msds.MsdsMain) => {
  const hide = message.loading('正在更新');
  try {
    await updateMsdsMain(fields);
    hide();
    message.success('更新成功');
    return true;
  } catch (error) {
    hide();
    message.error('更新失败请重试！');
    return false;
  }
};

/**
 * 删除MSDS
 */
const handleRemove = async (selectedRows: API.Msds.MsdsMain[]) => {
  const hide = message.loading('正在删除');
  if (!selectedRows) return true;
  try {
    await removeMsdsMain(selectedRows.map((row) => row.id).join(','));
    hide();
    message.success('删除成功，即将刷新');
    return true;
  } catch (error) {
    hide();
    message.error('删除失败，请重试');
    return false;
  }
};

/**
 * 删除单个MSDS
 */
const handleRemoveOne = async (selectedRow: API.Msds.MsdsMain) => {
  const hide = message.loading('正在删除');
  if (!selectedRow) return true;
  try {
    const params = [selectedRow.id];
    await removeMsdsMain(params.join(','));
    hide();
    message.success('删除成功，即将刷新');
    return true;
  } catch (error) {
    hide();
    message.error('删除失败，请重试');
    return false;
  }
};

/**
 * 导出数据
 */
const handleExport = async () => {
  const hide = message.loading('正在导出');
  try {
    await exportMsdsMain();
    hide();
    message.success('导出成功');
    return true;
  } catch (error) {
    hide();
    message.error('导出失败，请重试');
    return false;
  }
};

const MsdsMainList: React.FC = () => {
  const [messageApi, contextHolder] = message.useMessage();

  const [modalVisible, setModalVisible] = useState<boolean>(false);
  const [detailModalVisible, setDetailModalVisible] = useState<boolean>(false);
  const [importModalVisible, setImportModalVisible] = useState<boolean>(false);
  
  const actionRef = useRef<ActionType>();
  const [currentRow, setCurrentRow] = useState<API.Msds.MsdsMain>();
  const [selectedRows, setSelectedRows] = useState<API.Msds.MsdsMain[]>([]);

  const access = useAccess();

  /** 国际化配置 */
  const intl = useIntl();

  /** 查看详情 */
  const handleDetail = async (record: API.Msds.MsdsMain) => {
    try {
      const response = await getMsdsMain(record.id!);
      if (response.code === 200) {
        setCurrentRow(response.data);
        setDetailModalVisible(true);
      }
    } catch (error) {
      message.error('获取详情失败');
    }
  };

  /** 表格列定义 */
  const columns: ProColumns<API.Msds.MsdsMain>[] = [
    {
      title: 'ID',
      dataIndex: 'id',
      valueType: 'text',
      hideInSearch: true,
      width: 80,
    },
    {
      title: '化学品中文名',
      dataIndex: 'productName',
      valueType: 'text',
      render: (dom, entity) => {
        return (
          <a
            onClick={() => {
              setCurrentRow(entity);
              handleDetail(entity);
            }}
          >
            {dom}
          </a>
        );
      },
    },
    {
      title: '化学品别名',
      dataIndex: 'productAlias',
      valueType: 'text',
      hideInSearch: true,
    },
    {
      title: '化学品英文名',
      dataIndex: 'productEnglishName',
      valueType: 'text',
      hideInSearch: true,
    },
    {
      title: '企业名称',
      dataIndex: 'companyName',
      valueType: 'text',
    },
    {
      title: '联系电话',
      dataIndex: 'contactPhone',
      valueType: 'text',
      hideInSearch: true,
    },
    {
      title: '电子邮件',
      dataIndex: 'email',
      valueType: 'text',
      hideInSearch: true,
    },
    {
      title: '版本号',
      dataIndex: 'version',
      valueType: 'text',
      hideInSearch: true,
    },
    {
      title: '状态',
      dataIndex: 'isActive',
      valueType: 'select',
      valueEnum: {
        1: { text: '有效', status: 'Success' },
        0: { text: '无效', status: 'Error' },
      },
      render: (_, record) => (
        <Tag color={record.isActive === 1 ? 'green' : 'red'}>
          {record.isActive === 1 ? '有效' : '无效'}
        </Tag>
      ),
    },
    {
      title: '创建时间',
      dataIndex: 'createTime',
      valueType: 'dateTime',
      hideInSearch: true,
      width: 180,
    },
    {
      title: '操作',
      dataIndex: 'option',
      valueType: 'option',
      render: (_, record) => [
        <Tooltip key="detail" title="查看详情">
          <Button
            type="link"
            size="small"
            icon={<EyeOutlined />}
            onClick={() => handleDetail(record)}
          />
        </Tooltip>,
        <Tooltip key="edit" title="编辑">
          <Button
            type="link"
            size="small"
            icon={<EditOutlined />}
            onClick={() => {
              setCurrentRow(record);
              setModalVisible(true);
            }}
          />
        </Tooltip>,
        <Tooltip key="delete" title="删除">
          <Button
            type="link"
            size="small"
            danger
            icon={<DeleteOutlined />}
            onClick={() => {
              confirm({
                title: '确认删除',
                icon: <ExclamationCircleOutlined />,
                content: `确定删除化学品"${record.productName}"吗？`,
                okText: '确认',
                cancelText: '取消',
                onOk: async () => {
                  await handleRemoveOne(record);
                  actionRef.current?.reloadAndRest?.();
                },
              });
            }}
          />
        </Tooltip>,
      ],
    },
  ];

  return (
    <PageContainer>
      {contextHolder}
      <ProTable<API.Msds.MsdsMain, API.Msds.MsdsMainListParams>
        headerTitle="MSDS主信息管理"
        actionRef={actionRef}
        rowKey="id"
        search={{
          labelWidth: 120,
        }}
        toolBarRender={() => [
          <Button
            type="primary"
            key="primary"
            onClick={() => {
              setCurrentRow(undefined);
              setModalVisible(true);
            }}
          >
            <PlusOutlined /> 新建
          </Button>,
          <Button
            key="import"
            onClick={() => setImportModalVisible(true)}
          >
            <UploadOutlined /> 导入
          </Button>,
          <Button
            key="export"
            onClick={handleExport}
          >
            <ExportOutlined /> 导出
          </Button>,
        ]}
        request={async (params, sort, filter) => {
          const { current, pageSize, ...searchParams } = params;
          const response = await getMsdsMainList({
            pageNum: current,
            pageSize,
            ...searchParams,
          });
          
          return {
            data: response.rows || [],
            success: response.code === 200,
            total: response.total || 0,
          };
        }}
        columns={columns}
        rowSelection={{
          onChange: (_, selectedRows) => {
            setSelectedRows(selectedRows);
          },
        }}
      />
      
      {selectedRows?.length > 0 && (
        <FooterToolbar
          extra={
            <div>
              已选择{' '}
              <a style={{ fontWeight: 600 }}>{selectedRows.length}</a>{' '}
              项 &nbsp;&nbsp;
            </div>
          }
        >
          <Button
            onClick={async () => {
              await handleRemove(selectedRows);
              setSelectedRows([]);
              actionRef.current?.reloadAndRest?.();
            }}
          >
            批量删除
          </Button>
        </FooterToolbar>
      )}

      <MsdsForm
        open={modalVisible}
        onOpenChange={setModalVisible}
        onFinish={async (value) => {
          const success = currentRow?.id
            ? await handleUpdate({ ...currentRow, ...value })
            : await handleAdd(value);
          if (success) {
            setModalVisible(false);
            setCurrentRow(undefined);
            if (actionRef.current) {
              actionRef.current.reload();
            }
          }
          return success;
        }}
        values={currentRow}
        title={currentRow?.id ? '编辑MSDS' : '新增MSDS'}
      />

      {/* 详情弹窗 */}
      <Modal
        title="MSDS详情"
        open={detailModalVisible}
        onCancel={() => setDetailModalVisible(false)}
        footer={[
          <Button key="close" onClick={() => setDetailModalVisible(false)}>
            关闭
          </Button>,
        ]}
        width={800}
      >
        {currentRow && (
          <div style={{ padding: '16px 0' }}>
            <div style={{ marginBottom: 16 }}>
              <strong>化学品中文名：</strong>{currentRow.productName}
            </div>
            {currentRow.productAlias && (
              <div style={{ marginBottom: 16 }}>
                <strong>化学品别名：</strong>{currentRow.productAlias}
              </div>
            )}
            {currentRow.productEnglishName && (
              <div style={{ marginBottom: 16 }}>
                <strong>化学品英文名：</strong>{currentRow.productEnglishName}
              </div>
            )}
            <div style={{ marginBottom: 16 }}>
              <strong>企业名称：</strong>{currentRow.companyName}
            </div>
            {currentRow.companyAddress && (
              <div style={{ marginBottom: 16 }}>
                <strong>企业地址：</strong>{currentRow.companyAddress}
              </div>
            )}
            <div style={{ marginBottom: 16 }}>
              <strong>联系电话：</strong>{currentRow.contactPhone}
            </div>
            {currentRow.email && (
              <div style={{ marginBottom: 16 }}>
                <strong>电子邮件：</strong>{currentRow.email}
              </div>
            )}
            {currentRow.emergencyPhone && (
              <div style={{ marginBottom: 16 }}>
                <strong>企业应急电话：</strong>{currentRow.emergencyPhone}
              </div>
            )}
            {currentRow.recommendedUsage && (
              <div style={{ marginBottom: 16 }}>
                <strong>产品推荐用途：</strong>{currentRow.recommendedUsage}
              </div>
            )}
            {currentRow.restrictedUsage && (
              <div style={{ marginBottom: 16 }}>
                <strong>产品限制用途：</strong>{currentRow.restrictedUsage}
              </div>
            )}
            {currentRow.version && (
              <div style={{ marginBottom: 16 }}>
                <strong>版本号：</strong>{currentRow.version}
              </div>
            )}
            <div style={{ marginBottom: 16 }}>
              <strong>状态：</strong>
              <Tag color={currentRow.isActive === 1 ? 'green' : 'red'}>
                {currentRow.isActive === 1 ? '有效' : '无效'}
              </Tag>
            </div>
            {currentRow.remark && (
              <div style={{ marginBottom: 16 }}>
                <strong>备注：</strong>{currentRow.remark}
              </div>
            )}
            <div style={{ marginBottom: 16 }}>
              <strong>创建时间：</strong>{currentRow.createTime}
            </div>
            {currentRow.updateTime && (
              <div style={{ marginBottom: 16 }}>
                <strong>更新时间：</strong>{currentRow.updateTime}
              </div>
            )}
          </div>
        )}
      </Modal>

      {/* 导入弹窗 */}
      <ImportModal
        open={importModalVisible}
        onOpenChange={setImportModalVisible}
        onSuccess={() => {
          actionRef.current?.reload();
        }}
      />
    </PageContainer>
  );
};

export default MsdsMainList; 