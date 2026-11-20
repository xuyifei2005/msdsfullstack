import React from 'react';
import { Button, Empty, Skeleton, Space, Tooltip } from 'antd';
import {
  InfoCircleOutlined,
  ReloadOutlined,
  SafetyCertificateOutlined,
} from '@ant-design/icons';
import { useEmotionCss } from '@ant-design/use-emotion-css';

/**
 * MSDS 监管分类标签栏
 *
 * - 默认「全部」，切换后按真实法规名录匹配的分类过滤列表
 * - 分类、数量、细分类全部来自后端真实数据，不内置任何假分类
 * - 桌面端 / 手机端共用：窄屏自动收紧卡片并支持横向滑动
 */
export type RegulatoryCategoryTabsProps = {
  categories: API.Msds.RegulatoryCategory[];
  value: string;
  subValue?: string;
  loading?: boolean;
  error?: string;
  onChange: (categoryCode: string, subCategory?: string) => void;
  onRefresh: () => void;
};

const FALLBACK_COLOR: Record<string, string> = {
  ALL: '#1677ff',
  PRECURSOR: '#722ed1',
  EXPLOSIVE: '#fa541c',
  TOXIC: '#f5222d',
  UNCLASSIFIED: '#8c8c8c',
};

const lighten = (color: string) =>
  /^#[0-9a-fA-F]{6}$/.test(color) ? `${color}12` : '#f0f5ff';

const RegulatoryCategoryTabs: React.FC<RegulatoryCategoryTabsProps> = ({
  categories,
  value,
  subValue,
  loading = false,
  error,
  onChange,
  onRefresh,
}) => {
  const className = useEmotionCss(() => ({
    background: '#ffffff',
    borderRadius: 14,
    border: '1px solid rgba(24, 144, 255, 0.12)',
    boxShadow: '0 2px 12px rgba(15, 23, 42, 0.05)',
    padding: '14px 18px 12px',
    marginBottom: 16,

    '.rcat-header': {
      display: 'flex',
      justifyContent: 'space-between',
      alignItems: 'center',
      gap: 12,
      flexWrap: 'wrap',
      marginBottom: 12,
    },
    '.rcat-title': {
      display: 'inline-flex',
      alignItems: 'center',
      gap: 8,
      fontSize: 15,
      fontWeight: 700,
      color: '#1e293b',
    },
    '.rcat-title-icon': { color: '#1677ff', fontSize: 17 },
    '.rcat-actions': { display: 'inline-flex', gap: 4 },

    '.rcat-tabs': {
      display: 'flex',
      gap: 10,
      overflowX: 'auto',
      overflowY: 'hidden',
      paddingBottom: 6,
      scrollbarWidth: 'thin',
      WebkitOverflowScrolling: 'touch',
      '&::-webkit-scrollbar': { height: 4 },
      '&::-webkit-scrollbar-thumb': { background: '#e2e8f0', borderRadius: 4 },
    },
    '.rcat-tab': {
      position: 'relative',
      display: 'inline-flex',
      alignItems: 'center',
      gap: 8,
      flex: '0 0 auto',
      minWidth: 104,
      padding: '10px 16px 12px',
      border: '1px solid #e5e7eb',
      borderRadius: 10,
      background: '#ffffff',
      color: '#64748b',
      fontSize: 14,
      fontWeight: 500,
      whiteSpace: 'nowrap',
      cursor: 'pointer',
      transition: 'all .18s ease',
      '&:hover': { borderColor: '#93c5fd', color: '#1677ff' },
      '&:focus-visible': { outline: '2px solid #93c5fd', outlineOffset: 2 },
    },
    '.rcat-tab-active': { fontWeight: 700 },
    '.rcat-dot': { width: 8, height: 8, borderRadius: '50%', flex: '0 0 auto' },
    '.rcat-label': { lineHeight: 1.2 },
    '.rcat-count': {
      fontSize: 12,
      fontWeight: 700,
      lineHeight: '18px',
      minWidth: 22,
      padding: '0 6px',
      borderRadius: 999,
      background: '#f1f5f9',
      color: '#64748b',
      textAlign: 'center',
    },
    '.rcat-indicator': {
      position: 'absolute',
      left: '22%',
      right: '22%',
      bottom: -1,
      height: 3,
      borderRadius: 3,
    },

    '.rcat-subrow': {
      display: 'flex',
      alignItems: 'center',
      gap: 10,
      flexWrap: 'wrap',
      marginTop: 10,
    },
    '.rcat-sublabel': { fontSize: 12, color: '#94a3b8', flex: '0 0 auto' },
    '.rcat-subtabs': {
      display: 'flex',
      gap: 8,
      overflowX: 'auto',
      WebkitOverflowScrolling: 'touch',
      scrollbarWidth: 'none',
      '&::-webkit-scrollbar': { display: 'none' },
    },
    '.rcat-subtab': {
      flex: '0 0 auto',
      padding: '4px 12px',
      border: '1px solid #e5e7eb',
      borderRadius: 999,
      background: '#f8fafc',
      color: '#64748b',
      fontSize: 12,
      whiteSpace: 'nowrap',
      cursor: 'pointer',
      transition: 'all .18s ease',
      '&:hover': { borderColor: '#93c5fd', color: '#1677ff' },
    },
    '.rcat-foot': { marginTop: 10, fontSize: 12, color: '#94a3b8', lineHeight: 1.6 },

    '@media (max-width: 768px)': {
      padding: '12px 12px 10px',
      borderRadius: 12,
      marginBottom: 12,
      '.rcat-header': { gap: 8, marginBottom: 10 },
      '.rcat-title': { fontSize: 14 },
      '.rcat-tabs': { gap: 8 },
      '.rcat-tab': { minWidth: 88, gap: 6, padding: '8px 12px 10px', fontSize: 13 },
      '.rcat-count': { fontSize: 11, minWidth: 20, padding: '0 5px' },
      '.rcat-foot': { fontSize: 11 },
      '.rcat-subtab': { padding: '4px 10px' },
    },
  }));

  const currentCode = value || 'ALL';
  const current = categories.find((item) => item.categoryCode === currentCode);
  const subList = (current?.subCategories || '')
    .split(',')
    .map((item) => item.trim())
    .filter(Boolean);
  const sourceDocs = categories
    .map((item) => item.sourceDocument)
    .filter((item): item is string => !!item)
    .filter((item, idx, arr) => arr.indexOf(item) === idx);

  const tooltipTitle = (cat: API.Msds.RegulatoryCategory) => (
    <div style={{ maxWidth: 280, fontSize: 12, lineHeight: 1.7 }}>
      <div style={{ fontWeight: 600, marginBottom: 4 }}>{cat.categoryName}</div>
      <div>{cat.description || '—'}</div>
      {cat.sourceDocument && <div style={{ marginTop: 4 }}>依据：{cat.sourceDocument}</div>}
      {typeof cat.catalogCount === 'number' && <div>名录条目：{cat.catalogCount} 条</div>}
      <div>当前筛选结果：{cat.count ?? 0} 篇 MSDS</div>
    </div>
  );

  return (
    <div className={className}>
      <div className="rcat-header">
        <Space size={8} align="center" wrap>
          <span className="rcat-title">
            <SafetyCertificateOutlined className="rcat-title-icon" />
            监管分类
          </span>
          <Tooltip
            title={
              <div style={{ fontSize: 12, lineHeight: 1.8 }}>
                分类依据现行法规名录按 CAS 号自动匹配：
                {sourceDocs.length > 0 ? (
                  <ul style={{ paddingLeft: 18, margin: '4px 0 0' }}>
                    {sourceDocs.map((doc) => (
                      <li key={doc}>{doc}</li>
                    ))}
                  </ul>
                ) : (
                  <div>（分类数据加载中）</div>
                )}
              </div>
            }
          >
            <InfoCircleOutlined style={{ color: '#94a3b8', cursor: 'help' }} />
          </Tooltip>
        </Space>
        <div className="rcat-actions">
          <Button
            type="text"
            size="small"
            onClick={() => onChange('ALL', undefined)}
            disabled={currentCode === 'ALL' && !subValue}
          >
            重置分类
          </Button>
          <Tooltip title="刷新分类数量">
            <Button
              type="text"
              size="small"
              icon={<ReloadOutlined />}
              onClick={onRefresh}
              loading={loading}
            />
          </Tooltip>
        </div>
      </div>

      {loading && categories.length === 0 ? (
        <Skeleton active paragraph={false} title={{ width: '100%' }} />
      ) : error ? (
        <div style={{ color: '#ff4d4f', fontSize: 13, padding: '8px 0' }}>
          分类数据加载失败：{error}
          <Button type="link" size="small" onClick={onRefresh}>
            重试
          </Button>
        </div>
      ) : categories.length === 0 ? (
        <Empty image={Empty.PRESENTED_IMAGE_SIMPLE} description="暂无分类数据" />
      ) : (
        <>
          <div className="rcat-tabs" role="tablist" aria-label="MSDS监管分类">
            {categories.map((cat) => {
              const selected = cat.categoryCode === currentCode;
              const color = cat.color || FALLBACK_COLOR[cat.categoryCode] || '#1677ff';
              return (
                <Tooltip key={cat.categoryCode} title={tooltipTitle(cat)}>
                  <button
                    type="button"
                    role="tab"
                    aria-selected={selected}
                    className={`rcat-tab ${selected ? 'rcat-tab-active' : ''}`}
                    style={{
                      borderColor: selected ? color : undefined,
                      color: selected ? color : undefined,
                      background: selected ? lighten(color) : undefined,
                    }}
                    onClick={() => onChange(cat.categoryCode, undefined)}
                  >
                    <span className="rcat-dot" style={{ background: color }} />
                    <span className="rcat-label">{cat.shortName}</span>
                    <span
                      className="rcat-count"
                      style={selected ? { background: color, color: '#ffffff' } : undefined}
                    >
                      {cat.count ?? 0}
                    </span>
                    {selected && (
                      <span className="rcat-indicator" style={{ background: color }} />
                    )}
                  </button>
                </Tooltip>
              );
            })}
          </div>

          {subList.length > 0 && (
            <div className="rcat-subrow">
              <span className="rcat-sublabel">{current?.shortName}细分</span>
              <div className="rcat-subtabs">
                <button
                  type="button"
                  className="rcat-subtab"
                  style={
                    !subValue
                      ? {
                          borderColor: current?.color,
                          color: current?.color,
                          background: lighten(current?.color || '#1677ff'),
                          fontWeight: 600,
                        }
                      : undefined
                  }
                  onClick={() => onChange(currentCode, undefined)}
                >
                  全部
                </button>
                {subList.map((sub) => (
                  <button
                    type="button"
                    key={sub}
                    className="rcat-subtab"
                    style={
                      subValue === sub
                        ? {
                            borderColor: current?.color,
                            color: current?.color,
                            background: lighten(current?.color || '#1677ff'),
                            fontWeight: 600,
                          }
                        : undefined
                    }
                    onClick={() => onChange(currentCode, sub)}
                  >
                    {sub}
                  </button>
                ))}
              </div>
            </div>
          )}

          <div className="rcat-foot">
            标签数量随上方搜索条件实时统计；分类由法规名录按 CAS 号/品名精确匹配生成，仅用于检索筛选，具体管理要求以官方名录为准。
          </div>
        </>
      )}
    </div>
  );
};

export default RegulatoryCategoryTabs;
