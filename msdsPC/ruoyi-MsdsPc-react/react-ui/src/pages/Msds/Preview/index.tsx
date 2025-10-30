import React from 'react';
import { PageContainer } from '@ant-design/pro-components';
import { Alert, Typography, Table, Tag, Space, Layout, Menu, Card, Descriptions, Badge } from 'antd';
import { useLocation } from '@umijs/max';
import type { MsdsPreviewItem, MsdsSection, MsdsSectionField, MsdsFieldStatus } from '@/services/msds';

const { Paragraph, Text } = Typography;
const { Sider, Content } = Layout;

type PreviewItem = MsdsPreviewItem;

/**
 * MSDS 预览页面（壳组件）
 * - 目标：承载 16 章节预览与状态标识的 UI 容器
 * - 当前：支持从导入弹窗跳转并接收 previewList 进行基础展示
 */

const MsdsPreviewPage: React.FC = () => {
  const location = useLocation() as any;
  const previewList: PreviewItem[] = (location?.state?.previewList as PreviewItem[]) || [];
  const [selectedIndex, setSelectedIndex] = React.useState<number>(0);
  // 可选：后端已提供按文件的章节数据映射（按 fileName 作为key）
  const previewSectionsMap: Record<string, MsdsSection[]> | undefined = location?.state?.previewSectionsMap;

  React.useEffect(() => {
    // 预览数据变更时重置选中项，避免越界
    setSelectedIndex(0);
  }, [previewList]);

  const statusColor = (s: MsdsFieldStatus) => (s === 'success' ? 'green' : s === 'warning' ? 'orange' : 'red');
  const statusText = (s: MsdsFieldStatus) => (s === 'success' ? '命中' : s === 'warning' ? '不确定/缺失' : '错误/必填缺失');

  const summaryOfSection = (section: MsdsSection) => {
    const stats = section.fields?.reduce(
      (acc, field) => {
        if (field.status === 'success') acc.ok++;
        else if (field.status === 'warning') acc.warn++;
        else if (field.status === 'error') acc.err++;
        return acc;
      },
      { ok: 0, warn: 0, err: 0 }
    ) || { ok: 0, warn: 0, err: 0 };
    return stats;
  };

  const buildSectionsFromPreview = (item: MsdsPreviewItem): MsdsSection[] => {
    // 构建完整的16章节结构化数据
    const sections: MsdsSection[] = [
      {
        id: 1,
        title: '1 化学品及企业标识',
        fields: [
          { key: 'productName', label: '化学品中文名', value: item.productName, status: item.productName ? 'success' : 'error', hint: item.productName ? '' : '必填字段缺失' },
          { key: 'productEnglishName', label: '化学品英文名', value: item.productEnglishName, status: item.productEnglishName ? 'success' : 'warning', hint: '建议填写' },
          { key: 'casNumber', label: 'CAS号', value: item.casNumber, status: item.casNumber ? 'success' : 'error', hint: item.casNumber ? '' : '必填字段缺失' },
          { key: 'companyName', label: '企业名称', value: item.companyName, status: item.companyName ? 'success' : 'warning', hint: '建议填写' },
          { key: 'version', label: '版本号', value: item.version, status: item.version ? 'success' : 'warning', hint: '建议填写' },
          { key: 'fileName', label: '文件名', value: item.fileName, status: 'success' },
        ],
      },
      {
        id: 2,
        title: '2 危险性概述',
        fields: [
          { key: 'emergencyOverview', label: '紧急情况概述', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'physicalState', label: '物理状态', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'warningWord', label: '警示词', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'hazardCategory', label: '危险性类别', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'healthHazards', label: '健康危害', value: undefined, status: 'warning', hint: '待解析' },
        ],
      },
      {
        id: 3,
        title: '3 成分/组成信息',
        fields: [
          { key: 'componentName', label: '主要成分名称', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'componentContent', label: '成分含量', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'molecularFormula', label: '分子式', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'molecularWeight', label: '分子量', value: undefined, status: 'warning', hint: '待解析' },
        ],
      },
      {
        id: 4,
        title: '4 急救措施',
        fields: [
          { key: 'skinContact', label: '皮肤接触', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'eyeContact', label: '眼睛接触', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'inhalation', label: '吸入', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'ingestion', label: '食入', value: undefined, status: 'warning', hint: '待解析' },
        ],
      },
      {
        id: 5,
        title: '5 消防措施',
        fields: [
          { key: 'extinguishingMedia', label: '灭火介质', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'fireHazards', label: '火灾危险性', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'fireProtection', label: '消防人员防护', value: undefined, status: 'warning', hint: '待解析' },
        ],
      },
      {
        id: 6,
        title: '6 泄漏应急处理',
        fields: [
          { key: 'personalPrecautions', label: '个人防护措施', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'environmentalPrecautions', label: '环境保护措施', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'cleanupMethods', label: '清理方法', value: undefined, status: 'warning', hint: '待解析' },
        ],
      },
      {
        id: 7,
        title: '7 操作处置与储存',
        fields: [
          { key: 'handlingPrecautions', label: '操作注意事项', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'storageConditions', label: '储存条件', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'incompatibleMaterials', label: '禁配物', value: undefined, status: 'warning', hint: '待解析' },
        ],
      },
      {
        id: 8,
        title: '8 接触控制/个体防护',
        fields: [
          { key: 'exposureLimits', label: '职业接触限值', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'engineeringControls', label: '工程控制', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'personalProtection', label: '个体防护设备', value: undefined, status: 'warning', hint: '待解析' },
        ],
      },
      {
        id: 9,
        title: '9 理化特性',
        fields: [
          { key: 'appearance', label: '外观与性状', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'meltingPoint', label: '熔点', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'boilingPoint', label: '沸点', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'density', label: '密度', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'solubility', label: '溶解性', value: undefined, status: 'warning', hint: '待解析' },
        ],
      },
      {
        id: 10,
        title: '10 稳定性和反应性',
        fields: [
          { key: 'stability', label: '稳定性', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'reactivity', label: '反应性', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'incompatibility', label: '应避免的条件', value: undefined, status: 'warning', hint: '待解析' },
        ],
      },
      {
        id: 11,
        title: '11 毒理学信息',
        fields: [
          { key: 'acuteToxicity', label: '急性毒性', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'chronicToxicity', label: '慢性毒性', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'carcinogenicity', label: '致癌性', value: undefined, status: 'warning', hint: '待解析' },
        ],
      },
      {
        id: 12,
        title: '12 生态学信息',
        fields: [
          { key: 'ecotoxicity', label: '生态毒性', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'biodegradability', label: '生物降解性', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'bioaccumulation', label: '生物富集性', value: undefined, status: 'warning', hint: '待解析' },
        ],
      },
      {
        id: 13,
        title: '13 废弃处置',
        fields: [
          { key: 'wasteDisposal', label: '废物处置方法', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'containerDisposal', label: '包装物处置', value: undefined, status: 'warning', hint: '待解析' },
        ],
      },
      {
        id: 14,
        title: '14 运输信息',
        fields: [
          { key: 'unNumber', label: 'UN编号', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'properShippingName', label: '运输正式名称', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'transportHazardClass', label: '运输危险性类别', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'packingGroup', label: '包装类别', value: undefined, status: 'warning', hint: '待解析' },
        ],
      },
      {
        id: 15,
        title: '15 法规信息',
        fields: [
          { key: 'regulations', label: '法规信息', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'chemicalInventory', label: '化学品清单', value: undefined, status: 'warning', hint: '待解析' },
        ],
      },
      {
        id: 16,
        title: '16 其他信息',
        fields: [
          { key: 'references', label: '参考文献', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'revisionInfo', label: '修订信息', value: undefined, status: 'warning', hint: '待解析' },
          { key: 'disclaimer', label: '免责声明', value: undefined, status: 'warning', hint: '待解析' },
        ],
      },
    ];
    return sections;
  };

  const getSections = (item?: MsdsPreviewItem): MsdsSection[] => {
    if (!item) return [];
    if (previewSectionsMap && item.fileName && previewSectionsMap[item.fileName]) {
      return previewSectionsMap[item.fileName];
    }
    return buildSectionsFromPreview(item);
  };



  const scrollToSection = (id: number) => {
    const el = document.getElementById(`sec-${id}`);
    if (el) {
      el.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
  };

  const columns = [
    { title: '文件名', dataIndex: 'fileName', key: 'fileName', width: 260 },
    { title: '中文名', dataIndex: 'productName', key: 'productName', width: 160 },
    { title: '英文名', dataIndex: 'productEnglishName', key: 'productEnglishName', width: 180 },
    { title: 'CAS号', dataIndex: 'casNumber', key: 'casNumber', width: 140 },
    { title: '企业名称', dataIndex: 'companyName', key: 'companyName', width: 200 },
    { title: '版本', dataIndex: 'version', key: 'version', width: 120 },
    {
      title: '状态',
      dataIndex: 'status',
      key: 'status',
      width: 120,
      render: (v: PreviewItem['status']) => {
        const color = v === 'success' ? 'green' : v === 'warning' ? 'orange' : 'red';
        const text = v === 'success' ? '成功' : v === 'warning' ? '警告' : '错误';
        return <Tag color={color}>{text}</Tag>;
      },
    },
  ];

  // 左侧章节标题（用于兜底菜单）
  const sectionTitles = [
    '1 基本信息', '2 危险性概述', '3 成分/组成', '4 急救措施',
    '5 消防措施', '6 泄漏应急', '7 操作与储存', '8 接触控制/个体防护',
    '9 理化特性', '10 稳定性与反应性', '11 毒理学信息', '12 生态学信息',
    '13 废弃处置', '14 运输信息', '15 法规信息', '16 其他信息',
  ];

  const currentSections = getSections(previewList[selectedIndex]);

  return (
    <PageContainer header={{ title: 'MSDS 预览' }}>
      <Space direction="vertical" style={{ width: '100%' }} size="middle">
        <Alert
          type="info"
          showIcon
          message="页面建设中"
          description={
            <Paragraph>
              <Text>本页面用于展示“解析结果”的 16 章节结构化预览，并提供字段状态高亮、重新解析、导出等能力。</Text>
              <br />
              <Text>当前支持从“导入弹窗”跳转进行基础核对。</Text>
            </Paragraph>
          }
        />

        {previewList.length > 0 && (
          <Alert
            type="success"
            showIcon
            message={`已接收预览数据：${previewList.length} 条`}
          />
        )}

        {previewList.length > 0 && (
          <Table
            dataSource={previewList}
            columns={columns}
            rowKey={(r, i) => `${r.fileName}-${i}`}
            size="small"
            scroll={{ x: 1000 }}
            pagination={{ pageSize: 10, showSizeChanger: true }}
            onRow={(record, index) => ({ onClick: () => setSelectedIndex(index ?? 0) })}
          />
        )}

        {previewList.length > 0 && (
          <Space direction="vertical" style={{ width: '100%' }} size="small">
            <Space>
              <Tag color={statusColor('success')}>命中</Tag>
              <Tag color={statusColor('warning')}>不确定/缺失</Tag>
              <Tag color={statusColor('error')}>错误/必填缺失</Tag>
              <Text type="secondary">当前展示第 {selectedIndex + 1} 个文件（{previewList[selectedIndex]?.fileName}）的 16 章节</Text>
            </Space>

            {/* 主体布局：左侧章节导航 + 右侧章节内容 */}
            <Layout style={{ background: 'transparent' }}>
              <Sider
                width={220}
                theme="light"
                style={{
                  background: '#fff',
                  border: '1px solid #f0f0f0',
                  borderRadius: 8,
                  padding: 8,
                  position: 'sticky',
                  top: 80,
                  alignSelf: 'flex-start',
                  height: 'calc(100vh - 140px)',
                  overflow: 'auto',
                }}
              >
                <Menu
                  mode="inline"
                  style={{ borderRight: 0 }}
                  selectedKeys={[]}
                  items={(currentSections.length > 0 ? currentSections : sectionTitles.map((t, idx) => ({ id: idx + 1, title: t, fields: [] as MsdsSectionField[] }))).map((sec) => {
                    const { err, warn, ok } = summaryOfSection(sec);
                    return {
                      key: `${sec.id}`,
                      label: (
                        <Space>
                          <span>{sec.title}</span>
                          {err > 0 && <Badge color="red" text={err} />}
                          {warn > 0 && <Badge color="orange" text={warn} />}
                          {ok > 0 && <Badge color="green" text={ok} />}
                        </Space>
                      ),
                      onClick: () => scrollToSection(sec.id),
                    };
                  })}
                />
              </Sider>

              <Content style={{ paddingLeft: 16 }}>
                <Space direction="vertical" style={{ width: '100%' }} size="large">
                  {currentSections.map((sec) => {
                    const { err, warn, ok } = summaryOfSection(sec);
                    return (
                      <Card
                        key={sec.id}
                        id={`sec-${sec.id}`}
                        title={
                          <Space>
                            <span>{sec.title}</span>
                            <Space size="small">
                              {ok > 0 && <Badge color="green" text={`${ok} 已填写`} />}
                              {warn > 0 && <Badge color="orange" text={`${warn} 待完善`} />}
                              {err > 0 && <Badge color="red" text={`${err} 缺失`} />}
                            </Space>
                          </Space>
                        }
                        size="small"
                        bordered
                        style={{
                          borderLeft: `4px solid ${
                            err > 0 ? '#ff4d4f' : warn > 0 ? '#faad14' : '#52c41a'
                          }`
                        }}
                      >
                        {sec.fields && sec.fields.length > 0 ? (
                          <div style={{ display: 'grid', gap: '12px' }}>
                            {sec.fields.map((f) => (
                              <div
                                key={f.key}
                                style={{
                                  padding: '12px',
                                  border: '1px solid #f0f0f0',
                                  borderRadius: '6px',
                                  backgroundColor: f.status === 'error' ? '#fff2f0' : f.status === 'warning' ? '#fffbe6' : '#f6ffed'
                                }}
                              >
                                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '8px' }}>
                                  <Text strong style={{ color: '#262626' }}>{f.label}</Text>
                                  <div style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
                                    <div
                                      style={{
                                        width: '16px',
                                        height: '16px',
                                        borderRadius: '50%',
                                        backgroundColor: statusColor(f.status),
                                        display: 'flex',
                                        alignItems: 'center',
                                        justifyContent: 'center',
                                        color: 'white',
                                        fontSize: '10px',
                                        fontWeight: 'bold'
                                      }}
                                    >
                                      {f.status === 'success' && '✓'}
                                      {f.status === 'warning' && '!'}
                                      {f.status === 'error' && '✗'}
                                    </div>
                                    <Tag color={statusColor(f.status)} size="small">{statusText(f.status)}</Tag>
                                  </div>
                                </div>
                                <div style={{ marginBottom: f.hint ? '8px' : '0' }}>
                                  {f.value ? (
                                    <Text style={{ color: '#262626', fontSize: '14px' }}>{f.value}</Text>
                                  ) : (
                                    <Text type="secondary" italic style={{ fontSize: '14px' }}>未填写</Text>
                                  )}
                                </div>
                                {f.hint && (
                                  <div
                                    style={{
                                      padding: '6px 8px',
                                      backgroundColor: f.status === 'error' ? '#ffebe6' : f.status === 'warning' ? '#fff7e6' : '#e6f7ff',
                                      borderRadius: '4px',
                                      fontSize: '12px',
                                      color: f.status === 'error' ? '#d4380d' : f.status === 'warning' ? '#d48806' : '#096dd9'
                                    }}
                                  >
                                    {f.hint}
                                  </div>
                                )}
                              </div>
                            ))}
                          </div>
                        ) : (
                          <Paragraph type="secondary">暂无字段</Paragraph>
                        )}
                      </Card>
                    );
                  })}
                </Space>
              </Content>
            </Layout>
          </Space>
        )}
      </Space>
    </PageContainer>
  );
};

export default MsdsPreviewPage;