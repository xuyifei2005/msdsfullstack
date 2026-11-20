import React, { useRef, useState } from 'react';
import type { ProColumns, ActionType, ProFormColumnsType } from '@ant-design/pro-components';
import { ProTable, BetaSchemaForm } from '@ant-design/pro-components';
import { message, Tag, Popconfirm, Button, Form } from 'antd';
import { DeleteOutlined, EditOutlined, ClearOutlined } from '@ant-design/icons';
import {
  listSearchSuggestions,
  addSearchSuggestion,
  updateSearchSuggestion,
  removeSearchSuggestions,
  SUGGESTION_TYPE_OPTIONS,
  type SearchSuggestionItem,
} from '@/services/msds/suggestion';

/**
 * 新增 / 编辑词条的表单字段
 *
 * <p>使用 ProSchema v2 写法：字段名用 dataIndex，控件用 valueType，
 * 控件属性用 fieldProps（旧版 component / componentProps 已废弃）。</p>
 */
const suggestionFormColumns: ProFormColumnsType<SearchSuggestionItem>[] = [
  {
    dataIndex: 'keyword',
    title: '关键词',
    valueType: 'text',
    formItemProps: { rules: [{ required: true, message: '请输入关键词' }] },
  },
  {
    dataIndex: 'keywordType',
    title: '类型',
    valueType: 'select',
    fieldProps: { options: SUGGESTION_TYPE_OPTIONS, allowClear: true },
  },
  {
    dataIndex: 'relatedCas',
    title: '关联CAS',
    valueType: 'text',
  },
  {
    dataIndex: 'sortOrder',
    title: '排序',
    valueType: 'digit',
    fieldProps: { min: 0, style: { width: 100 } },
  },
  {
    dataIndex: 'isActive',
    title: '状态',
    valueType: 'select',
    fieldProps: {
      options: [
        { label: '启用', value: 1 },
        { label: '停用', value: 0 },
      ],
      allowClear: true,
    },
  },
];

/**
 * 热门搜索词条管理
 *
 * <p>维护 msds_search_suggestion 中的运营策展词条。
 * 检索页「热门搜索」= 真实搜索历史聚合 + 本页维护的策展词条（按关键词去重合并）。</p>
 */
const SuggestionList: React.FC = () => {
  const actionRef = useRef<ActionType>();
  const [editing, setEditing] = useState<SearchSuggestionItem | null>(null);
  const [form] = Form.useForm();

  const typeLabel = (value?: string) =>
    SUGGESTION_TYPE_OPTIONS.find((item) => item.value === value)?.label || value || '-';

  const handleAdd = async (fields: any) => {
    const hide = message.loading('正在添加');
    try {
      await addSearchSuggestion({
        keyword: fields.keyword,
        keywordType: fields.keywordType || 'hot',
        relatedCas: fields.relatedCas,
        searchCount: Number(fields.searchCount ?? 0),
        clickCount: 0,
        sortOrder: Number(fields.sortOrder ?? 0),
        isActive: fields.isActive === undefined ? 1 : Number(fields.isActive),
        remark: fields.remark,
      });
      hide();
      message.success('添加成功');
      actionRef.current?.reload();
      return true;
    } catch (error) {
      hide();
      message.error('添加失败，请重试');
      return false;
    }
  };

  const handleUpdate = async (fields: any) => {
    const hide = message.loading('正在保存');
    try {
      await updateSearchSuggestion({
        suggestionId: editing?.suggestionId,
        keyword: fields.keyword,
        keywordType: fields.keywordType || 'hot',
        relatedCas: fields.relatedCas,
        searchCount: Number(fields.searchCount ?? 0),
        sortOrder: Number(fields.sortOrder ?? 0),
        isActive: fields.isActive === undefined ? 1 : Number(fields.isActive),
        remark: fields.remark,
      });
      hide();
      message.success('保存成功');
      setEditing(null);
      form.setFieldsValue({});
      actionRef.current?.reload();
      return true;
    } catch (error) {
      hide();
      message.error('保存失败，请重试');
      return false;
    }
  };

  const handleRemove = async (selectedRows: any[]) => {
    if (!selectedRows || selectedRows.length === 0) {
      message.warning('请先选择要删除的词条');
      return false;
    }
    const hide = message.loading('正在删除');
    try {
      await removeSearchSuggestions(selectedRows.map((row) => row.suggestionId));
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

  const columns: ProColumns<SearchSuggestionItem>[] = [
    {
      title: '关键词',
      dataIndex: 'keyword',
      width: 180,
      formItemProps: {
        rules: [{ required: true, message: '此项为必填项' }],
      },
    },
    {
      title: '词条类型',
      dataIndex: 'keywordType',
      width: 120,
      valueType: 'select',
      valueEnum: Object.fromEntries(
        SUGGESTION_TYPE_OPTIONS.map((item) => [item.value, { text: item.label }]),
      ),
      render: (_, record) => <Tag color="blue">{typeLabel(record.keywordType)}</Tag>,
    },
    {
      title: '关联CAS',
      dataIndex: 'relatedCas',
      width: 140,
      hideInSearch: true,
    },
    {
      title: '搜索次数',
      dataIndex: 'searchCount',
      width: 100,
      hideInSearch: true,
      render: (_, record) => record.searchCount ?? 0,
    },
    {
      title: '点击次数',
      dataIndex: 'clickCount',
      width: 100,
      hideInSearch: true,
      render: (_, record) => record.clickCount ?? 0,
    },
    {
      title: '排序',
      dataIndex: 'sortOrder',
      width: 80,
      hideInSearch: true,
      render: (_, record) => record.sortOrder ?? 0,
    },
    {
      title: '状态',
      dataIndex: 'isActive',
      width: 90,
      valueType: 'select',
      valueEnum: {
        1: { text: '启用', status: 'Success' },
        0: { text: '停用', status: 'Default' },
      },
      render: (_, record) =>
        record.isActive === 1 ? (
          <Tag color="green">启用</Tag>
        ) : (
          <Tag color="default">停用</Tag>
        ),
    },
    {
      title: '备注',
      dataIndex: 'remark',
      hideInSearch: true,
    },
    {
      title: '创建时间',
      dataIndex: 'createTime',
      hideInSearch: true,
      width: 170,
    },
    {
      title: '操作',
      valueType: 'option',
      width: 140,
      render: (_, record) => [
        <EditOutlined
          key="edit"
          style={{ marginRight: 8 }}
          onClick={() => {
            setEditing(record);
            form.setFieldsValue({
              keyword: record.keyword,
              keywordType: record.keywordType,
              relatedCas: record.relatedCas,
              searchCount: record.searchCount ?? 0,
              sortOrder: record.sortOrder ?? 0,
              isActive: record.isActive ?? 1,
              remark: record.remark,
            });
          }}
        />,
        <Popconfirm
          key="delete"
          title="确认删除该词条？"
          onConfirm={async () => {
            await removeSearchSuggestions(record.suggestionId as number);
            message.success('删除成功');
            actionRef.current?.reload();
          }}
        >
          <DeleteOutlined />
        </Popconfirm>,
      ],
    },
  ];

  return (
    <div style={{ padding: 16 }}>
      <ProTable
        actionRef={actionRef}
        rowKey="suggestionId"
        columns={columns}
        request={async (params) => {
          const res = await listSearchSuggestions({
            keyword: params.keyword,
            keywordType: params.keywordType,
            isActive: params.isActive,
          });
          return {
            data: res?.rows || [],
            success: res?.code === 200,
            total: res?.total || 0,
          };
        }}
        headerTitle="热门搜索词条维护"
        toolBarRender={() => [
          <BetaSchemaForm<SearchSuggestionItem>
            key="form"
            form={form}
            columns={suggestionFormColumns}
            onFinish={async (values) => {
              const ok = editing ? await handleUpdate(values) : await handleAdd(values);
              if (ok) {
                form.resetFields();
                setEditing(null);
              }
              return ok;
            }}
            submitter={{
              searchConfig: {
                submitText: editing ? '保存' : '新增',
                resetText: '取消',
              },
              onReset: () => {
                setEditing(null);
                form.resetFields();
              },
            }}
            layout="inline"
          />,
          <Button
            key="clear"
            icon={<ClearOutlined />}
            onClick={() => {
              setEditing(null);
              form.resetFields();
            }}
          >
            清空表单
          </Button>,
        ]}
        rowSelection={{}}
        options={{
          fullScreen: false,
          reload: true,
          setting: true,
          density: true,
        }}
        pagination={{ defaultPageSize: 10, showSizeChanger: true }}
      />
    </div>
  );
};

export default SuggestionList;
