import React, { useState, useRef } from 'react';
import { useIntl, FormattedMessage, useAccess } from '@umijs/max';
import { Button, message, Modal, Space, Tag, Tooltip, Dropdown } from 'antd';
import { ActionType, FooterToolbar, PageContainer, ProColumns, ProTable } from '@ant-design/pro-components';
import { PlusOutlined, DeleteOutlined, ExclamationCircleOutlined, EditOutlined, EyeOutlined, ExportOutlined, UploadOutlined, FormOutlined, DownloadOutlined } from '@ant-design/icons';
import { useEmotionCss } from '@ant-design/use-emotion-css';
import {
  getMsdsMainList,
  removeMsdsMain,
  addMsdsMain,
  updateMsdsMain,
  exportMsdsMain,
  getMsdsMain,
  downloadImportTemplate
} from '@/services/msds';
import MsdsForm from './components/MsdsForm';
import MsdsDetail from './components/MsdsDetail';
import ImportModal from './components/ImportModal';
import MsdsStepForm from './components/MsdsStepForm';

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

/**
 * 下载导入模板
 */
const handleDownloadTemplate = async (templateType: 'basic' | 'detailed' | 'full' = 'full') => {
  const hide = message.loading('正在下载模板');
  try {
    await downloadImportTemplate(templateType);
    hide();
    message.success('模板下载成功');
  } catch (error) {
    hide();
    message.error('模板下载失败，请重试');
  }
};

const MsdsMainList: React.FC = () => {
  const [messageApi, contextHolder] = message.useMessage();

  const [modalVisible, setModalVisible] = useState<boolean>(false);
  const [detailModalVisible, setDetailModalVisible] = useState<boolean>(false);
  const [importModalVisible, setImportModalVisible] = useState<boolean>(false);
  const [stepFormVisible, setStepFormVisible] = useState<boolean>(false);

  const actionRef = useRef<ActionType>();
  const [currentRow, setCurrentRow] = useState<API.Msds.MsdsMain>();
  const [selectedRows, setSelectedRows] = useState<API.Msds.MsdsMain[]>([]);

  const access = useAccess();

  /** 国际化配置 */
  const intl = useIntl();

  // 自定义容器样式
  const containerClassName = useEmotionCss(() => {
    return {
      background: 'linear-gradient(180deg, #f8fafc 0%, #e0f2fe 100%)',
      minHeight: '100vh',
      position: 'relative',
      '&::before': {
        content: '""',
        position: 'fixed',
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        background: 'radial-gradient(circle at 20% 20%, rgba(24, 144, 255, 0.05) 0%, transparent 50%), radial-gradient(circle at 80% 80%, rgba(67, 205, 128, 0.04) 0%, transparent 50%)',
        pointerEvents: 'none',
        zIndex: -1,
      },
    };
  });

  // ProTable自定义样式
  const tableClassName = useEmotionCss(() => {
    return {
      background: '#ffffff',
      borderRadius: '16px',
      border: '1px solid rgba(24, 144, 255, 0.1)',
      boxShadow: '0 2px 12px rgba(0, 0, 0, 0.05)',
      overflow: 'hidden',
      '.ant-pro-card': {
        background: 'transparent',
        boxShadow: 'none',
      },
      '.ant-pro-table-list-toolbar-title': {
        color: '#1e293b',
        fontWeight: 700,
        fontSize: '20px',
      },
      '.ant-pro-table-search': {
        background: 'linear-gradient(180deg, #fafbfc 0%, #f8fafc 100%)',
        margin: '16px',
        padding: '20px',
        borderRadius: '12px',
        border: '1px solid rgba(24, 144, 255, 0.08)',
      },
    };
  });

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
      title: 'CAS号',
      dataIndex: 'casNumber',
      valueType: 'text',
      width: 120,
      copyable: true,
      ellipsis: true,
      tip: 'CAS登记号，点击可复制',
    },
    {
      title: 'MSDS编号',
      dataIndex: 'msdsCode',
      valueType: 'text',
      width: 120,
      copyable: true,
      ellipsis: true,
    },
    {
      title: '化学品中文名',
      dataIndex: 'productName',
      valueType: 'text',
      width: 200,
      ellipsis: true,
      render: (dom, entity) => {
        return (
          <a
            onClick={() => {
              setCurrentRow(entity);
              handleDetail(entity);
            }}
            style={{
              color: '#1890ff',
              fontWeight: 500,
              cursor: 'pointer',
              textDecoration: 'none',
            }}
            onMouseEnter={(e) => {
              e.target.style.color = '#40a9ff';
              e.target.style.textDecoration = 'underline';
            }}
            onMouseLeave={(e) => {
              e.target.style.color = '#1890ff';
              e.target.style.textDecoration = 'none';
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
      width: 150,
      ellipsis: true,
      hideInTable: true, // 默认隐藏，可通过列设置显示
    },
    {
      title: '化学品英文名',
      dataIndex: 'productEnglishName',
      valueType: 'text',
      hideInSearch: true,
      width: 200,
      ellipsis: true,
      hideInTable: true, // 默认隐藏，可通过列设置显示
    },
    {
      title: '企业名称',
      dataIndex: 'companyName',
      valueType: 'text',
      width: 180,
      ellipsis: true,
    },
    {
      title: '推荐用途',
      dataIndex: 'recommendedUsage',
      valueType: 'text',
      hideInSearch: true,
      width: 150,
      ellipsis: true,
      hideInTable: true, // 默认隐藏
      render: (text) => text ? <Tooltip title={text}>{text}</Tooltip> : '-',
    },
    {
      title: '联系电话',
      dataIndex: 'contactPhone',
      valueType: 'text',
      hideInSearch: true,
      width: 120,
      hideInTable: true, // 默认隐藏
    },
    {
      title: '电子邮件',
      dataIndex: 'email',
      valueType: 'text',
      hideInSearch: true,
      width: 180,
      hideInTable: true, // 默认隐藏
    },
    {
      title: '版本号',
      dataIndex: 'version',
      valueType: 'text',
      hideInSearch: true,
      width: 80,
    },
    {
      title: '修订日期',
      dataIndex: 'revisionDate',
      valueType: 'date',
      hideInSearch: true,
      width: 110,
      hideInTable: true, // 默认隐藏
    },
    {
      title: '生效日期',
      dataIndex: 'effectiveDate',
      valueType: 'date',
      hideInSearch: true,
      width: 110,
      hideInTable: true, // 默认隐藏
    },
    {
      title: '状态',
      dataIndex: 'status',
      valueType: 'select',
      width: 100,
      valueEnum: {
        draft: { text: '草稿', status: 'Default' },
        pending: { text: '待审核', status: 'Processing' },
        approved: { text: '已批准', status: 'Success' },
        archived: { text: '已归档', status: 'Warning' },
      },
      render: (_, record) => {
        const statusConfig = {
          draft: { color: 'default', text: '草稿' },
          pending: { color: 'processing', text: '待审核' },
          approved: { color: 'success', text: '已批准' },
          archived: { color: 'warning', text: '已归档' },
        };
        const config = statusConfig[record.status as keyof typeof statusConfig] || statusConfig.draft;
        return <Tag color={config.color}>{config.text}</Tag>;
      },
    },
    {
      title: '有效性',
      dataIndex: 'isActive',
      valueType: 'select',
      width: 80,
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
      title: '审批人',
      dataIndex: 'approver',
      valueType: 'text',
      hideInSearch: true,
      width: 100,
      hideInTable: true, // 默认隐藏
    },
    {
      title: '审批日期',
      dataIndex: 'approvalDate',
      valueType: 'date',
      hideInSearch: true,
      width: 110,
      hideInTable: true, // 默认隐藏
    },
    {
      title: '创建人',
      dataIndex: 'createdBy',
      valueType: 'text',
      hideInSearch: true,
      width: 100,
      hideInTable: true, // 默认隐藏
    },
    {
      title: '创建时间',
      dataIndex: 'createTime',
      valueType: 'dateTime',
      hideInSearch: true,
      width: 160,
    },
    {
      title: '更新时间',
      dataIndex: 'updateTime',
      valueType: 'dateTime',
      hideInSearch: true,
      width: 160,
      hideInTable: true, // 默认隐藏
    },
    {
      title: '操作',
      dataIndex: 'option',
      valueType: 'option',
      width: 160,
      fixed: 'right',
      render: (_, record) => [
        <Tooltip key="detail" title="查看详情">
          <Button
            type="link"
            size="small"
            icon={<EyeOutlined />}
            onClick={() => handleDetail(record)}
          />
        </Tooltip>,
        <Tooltip key="edit" title="快速编辑">
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
        <Tooltip key="stepEdit" title="16节编辑">
          <Button
            type="link"
            size="small"
            icon={<FormOutlined />}
            style={{ color: '#1890ff' }}
            onClick={() => {
              console.log('🔍 [MsdsList] 点击16节编辑按钮，record:', record);
              console.log('🔍 [MsdsList] record.id:', record.id);
              setCurrentRow(record);
              setStepFormVisible(true);
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
    <div className={containerClassName}>
      <PageContainer>
        {contextHolder}
        <ProTable<API.Msds.MsdsMain, API.Msds.MsdsMainListParams>
          className={tableClassName}
          headerTitle="MSDS主信息管理"
          actionRef={actionRef}
          rowKey="id"
          search={{
            labelWidth: 120,
            collapsed: false,
            collapseRender: (collapsed) => (collapsed ? '展开' : '收起'),
            searchText: '搜索',
            resetText: '重置',
            optionRender: ({ searchText, resetText }, { form }) => [
              <Button
                key="search"
                type="primary"
                onClick={() => {
                  form?.submit();
                }}
              >
                {searchText}
              </Button>,
              <Button
                key="reset"
                onClick={() => {
                  form?.resetFields();
                  form?.submit();
                }}
              >
                {resetText}
              </Button>,
            ],
          }}
          toolBarRender={() => [
            <Button
              type="primary"
              key="primary"
              onClick={() => {
                setCurrentRow(undefined);
                setModalVisible(true);
              }}
              style={{
                background: 'linear-gradient(135deg, #1890ff 0%, #40a9ff 100%)',
                border: 'none',
                borderRadius: '8px',
                fontWeight: 600,
              }}
            >
              <PlusOutlined /> 新建
            </Button>,
            <Button
              type="primary"
              key="import"
              style={{
                background: 'linear-gradient(135deg, #43cd80 0%, #6ee7b7 100%)',
                border: 'none',
                borderRadius: '8px',
                fontWeight: 600,
              }}
              onClick={() => setImportModalVisible(true)}
            >
              <UploadOutlined /> 批量导入
            </Button>,
            <Dropdown
              key="template"
              menu={{
                items: [
                  {
                    key: 'basic',
                    label: '基础模板',
                    onClick: () => handleDownloadTemplate('basic'),
                  },
                  {
                    key: 'detailed',
                    label: '详细模板',
                    onClick: () => handleDownloadTemplate('detailed'),
                  },
                  {
                    key: 'full',
                    label: '完整模板（多Sheet）',
                    onClick: () => handleDownloadTemplate('full'),
                  },
                ],
              }}
            >
              <Button style={{
                background: '#ffffff',
                border: '1px solid rgba(24, 144, 255, 0.2)',
                borderRadius: '8px',
                color: '#1e293b',
                fontWeight: 600,
              }}>
                <DownloadOutlined /> 下载模板
              </Button>
            </Dropdown>,
            <Button
              key="export"
              onClick={handleExport}
              style={{
                background: '#ffffff',
                border: '1px solid rgba(24, 144, 255, 0.2)',
                borderRadius: '8px',
                color: '#1e293b',
                fontWeight: 600,
              }}
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
        options={{
          reload: true,
          density: true,
          setting: {
            listsHeight: 400,
            draggable: true,
            checkable: true,
            showListItemOption: true,
            checkedReset: false,
          },
        }}
        pagination={{
          defaultPageSize: 10,
          showSizeChanger: true,
          showQuickJumper: true,
          showTotal: (total, range) => `第 ${range[0]}-${range[1]} 项 / 共 ${total} 项`,
          pageSizeOptions: ['10', '20', '50', '100'],
        }}
        scroll={{ x: 1800 }}
        size="small"
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
          <Button key="close" onClick={() => setDetailModalVisible(false)} style={{
            background: '#ffffff',
            border: '1px solid rgba(24, 144, 255, 0.2)',
            borderRadius: '8px',
            color: '#1e293b',
            fontWeight: 600,
          }}>
            关闭
          </Button>,
          <Button
            key="edit"
            type="primary"
            onClick={() => {
              setDetailModalVisible(false);
              setModalVisible(true);
            }}
            style={{
              background: 'linear-gradient(135deg, #1890ff 0%, #40a9ff 100%)',
              border: 'none',
              borderRadius: '8px',
              fontWeight: 600,
            }}
          >
            编辑
          </Button>,
        ]}
        width={1200}
        style={{ top: 20 }}
        bodyStyle={{ padding: '12px' }}
      >
        {currentRow && (
          <MsdsDetail
            msdsId={currentRow.id!}
            onEdit={(msdsId, section) => {
              setDetailModalVisible(false);
              setModalVisible(true);
            }}
          />
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

      {/* 16节分步编辑表单 */}
      {stepFormVisible && (
        <>
          {console.log('🔍 [MsdsList] 渲染MsdsStepForm, currentRow:', currentRow)}
          {console.log('🔍 [MsdsList] 传递msdsId:', currentRow?.id)}
        </>
      )}
      <MsdsStepForm
        open={stepFormVisible}
        onClose={() => {
          setStepFormVisible(false);
          setCurrentRow(undefined);
        }}
        msdsId={currentRow?.id}
        onSave={async (data) => {
          try {
            // TODO: 调用保存API
            message.success('保存成功');
            actionRef.current?.reload();
            return true;
          } catch (error) {
            message.error('保存失败');
            return false;
          }
        }}
      />
    </PageContainer>
    </div>
  );
};

export default MsdsMainList;