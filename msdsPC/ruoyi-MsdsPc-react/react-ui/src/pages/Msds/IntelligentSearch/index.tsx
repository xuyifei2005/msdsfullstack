import React, { useState, useCallback, useMemo } from 'react';
import {
  Card,
  Input,
  Button,
  Drawer,
  List,
  Row,
  Col,
  Tag,
  Select,
  Checkbox,
  Radio,
  Space,
  Empty,
  Spin,
  message,
  Badge,
  AutoComplete,
} from 'antd';
import {
  SearchOutlined,
  FireOutlined,
  ExperimentOutlined,
  SafetyOutlined,
  AlertOutlined,
  ClockCircleOutlined,
  EyeOutlined,
  FilterOutlined,
} from '@ant-design/icons';
import { PageContainer } from '@ant-design/pro-components';
import { useRequest, history } from '@umijs/max';
import type {
  SearchSuggestion,
  SearchHistory,
  HotSearch,
  IntelligentSearchParams,
} from '@/services/msds/search';
import {
  intelligentSearch,
  getSearchSuggestions,
  getHotSearches,
  getUserSearchHistory,
  clearSearchHistory,
  deleteSearchHistory,
  updateSuggestionStat,
  getHazardFacet,
} from '@/services/msds/search';
import { getMsdsList } from '@/services/msds';
import styles from './index.less';

const { Search } = Input;
const { Option } = Select;

/**
 * 危险性分类筛选项
 * value 为后端检索关键字，与 msds_hazard 的危险性类别/火灾爆炸危害/健康危害字段做模糊匹配
 */
const HAZARD_OPTIONS = [
  { value: '易燃', label: '易燃液体', color: 'red' },
  { value: '毒', label: '有毒', color: 'purple' },
  { value: '腐蚀', label: '腐蚀性', color: 'orange' },
  { value: '氧化', label: '氧化性', color: 'blue' },
];

// 快速筛选标签：与危险性分类共用同一套关键字
const QUICK_FILTERS = [
  { key: '易燃', icon: <FireOutlined />, label: '易燃物质', color: 'red' },
  { key: '毒', icon: <ExperimentOutlined />, label: '有毒物质', color: 'purple' },
  { key: '腐蚀', icon: <AlertOutlined />, label: '腐蚀性物质', color: 'orange' },
  { key: '氧化', icon: <SafetyOutlined />, label: '氧化性物质', color: 'blue' },
];

// 文档状态映射（取自后端真实 status 字段）
const STATUS_META: Record<string, { label: string; color: string }> = {
  approved: { label: '已审批', color: 'green' },
  pending: { label: '待审核', color: 'orange' },
  draft: { label: '草稿', color: 'default' },
  archived: { label: '已归档', color: 'gray' },
};

const formatDate = (date: Date) =>
  `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(
    2,
    '0',
  )} 00:00:00`;

/** 更新时间筛选 -> 后端 updateTimeFrom / updateTimeTo */
const buildTimeRange = (range: string) => {
  const days = range === 'week' ? 7 : range === 'month' ? 30 : range === 'year' ? 365 : 0;
  if (!days) {
    return {};
  }
  const now = new Date();
  const from = new Date(now.getTime() - days * 24 * 60 * 60 * 1000);
  return { from: formatDate(from), to: formatDate(now) };
};

const IntelligentSearch: React.FC = () => {
  const [keyword, setKeyword] = useState<string>('');
  const [searchType, setSearchType] = useState<string>('general');
  const [suggestions, setSuggestions] = useState<SearchSuggestion[]>([]);
  const [showSuggestions, setShowSuggestions] = useState(false);
  const [historyVisible, setHistoryVisible] = useState(false);
  const [fallbackResults, setFallbackResults] = useState<any>(null);

  // 高级筛选状态
  const [filters, setFilters] = useState({
    hazardCategory: [] as string[],
    updateTime: 'all',
    supplier: '',
    sortBy: 'relevance',
  });

  // 危险性分类真实数量（来自后端统计，不写死）
  const { data: hazardFacet = [] } = useRequest(
    () => getHazardFacet(),
    {
      onSuccess: (res) => {
        if (res?.code === 200 && Array.isArray(res.data)) {
          return res.data;
        }
        return [];
      },
      defaultData: [],
    }
  );

  const hazardCountMap = useMemo(() => {
    const map: Record<string, number> = {};
    hazardFacet.forEach((item) => {
      map[item.keyword] = Number(item.docCount ?? 0);
    });
    return map;
  }, [hazardFacet]);

  // 获取热门搜索
  const { data: hotSearches, loading: hotLoading } = useRequest(
    () => getHotSearches(10),
    {
      onSuccess: (res) => {
        if (res?.code === 200) {
          return res.data;
        }
      },
    }
  );

  // 获取搜索历史
  const { data: searchHistory = [], loading: historyLoading, refresh: refreshHistory } = useRequest(
    () => getUserSearchHistory(10),
    {
      onSuccess: (res) => {
        if (res?.code === 200 && Array.isArray(res.data)) {
          return res.data as SearchHistory[];
        }
        return [];
      },
      defaultData: [],
    }
  );

  // 执行搜索
  const {
    data: searchResults,
    loading: searching,
    run: performSearch,
  } = useRequest(
    (params: IntelligentSearchParams) => intelligentSearch(params),
    {
      manual: true,
      onSuccess: async (res: any, paramsList: any) => {
        const code = Number(res?.code);
        const rows = Array.isArray(res?.rows) ? res.rows : null;
        const params = Array.isArray(paramsList) ? paramsList[0] : paramsList;

        if (code === 200 || code === 0) {
          setFallbackResults(null);
          const totalCount = Number(res?.total ?? rows?.length ?? 0);
          if (totalCount === 0 && params?.searchType === 'formula') {
            message.info('当前知识库尚未录入分子式数据，请改用化学品名称或 CAS 号检索');
          } else {
            message.success(`找到 ${totalCount} 个相关文档`);
          }
          return;
        }

        if (code === 401 || code === 403) {
          message.warning('登录状态已失效，请重新登录后重试');
          return;
        }

        // 智能检索不可用时回退到基础检索，并透出后端真实原因
        const reason = res?.msg || `检索服务返回异常(${code})`;
        const fallback = await getMsdsList({
          productName: params?.keyword,
          supplier: params?.supplier,
          pageNum: 1,
          pageSize: 20,
        });
        if (fallback && Array.isArray((fallback as any).rows)) {
          setFallbackResults(fallback);
          message.warning(`智能检索不可用（${reason}），已切换为基础检索结果`);
        } else {
          message.warning(reason);
        }
      },
      onError: async (error: any, paramsList: any) => {
        const errorMessage =
          error?.info?.errorMessage ||
          error?.data?.msg ||
          error?.response?.data?.msg ||
          error?.message ||
          '未知错误';
        const params = Array.isArray(paramsList) ? paramsList[0] : paramsList;
        const fallback = await getMsdsList({
          productName: params?.keyword,
          supplier: params?.supplier,
          pageNum: 1,
          pageSize: 20,
        });
        if (fallback && Array.isArray((fallback as any).rows)) {
          setFallbackResults(fallback);
          message.warning(`智能检索请求失败（${errorMessage}），已回退基础检索`);
          return;
        }
        message.error(`搜索失败：${errorMessage}`);
      },
    }
  );

  // 获取搜索建议
  const fetchSuggestions = useCallback(async (value: string) => {
    if (!value || value.length < 2) {
      setSuggestions([]);
      setShowSuggestions(false);
      return;
    }

    try {
      const res = await getSearchSuggestions(value, 10);
      if (res?.code === 200 && res.data) {
        setSuggestions(res.data);
        setShowSuggestions(true);
      }
    } catch (error) {
      console.error('获取搜索建议失败', error);
    }
  }, []);

  // 处理搜索
  const handleSearch = useCallback(
    (value: string) => {
      if (!value.trim()) {
        message.warning('请输入搜索关键词');
        return;
      }

      const searchParams: IntelligentSearchParams = {
        keyword: value,
        searchType,
        sortBy: filters.sortBy as any,
      };

      if (filters.hazardCategory.length > 0) {
        searchParams.hazardKeyword = filters.hazardCategory.join(',');
      }

      if (filters.supplier) {
        searchParams.supplier = filters.supplier;
      }

      const { from, to } = buildTimeRange(filters.updateTime);
      if (from && to) {
        searchParams.updateTimeFrom = from;
        searchParams.updateTimeTo = to;
      }

      performSearch(searchParams);
      setFallbackResults(null);
      setShowSuggestions(false);
    },
    [searchType, filters, performSearch],
  );

  // 点击快速筛选：切换危险性分类并立即按当前关键词重新检索
  const handleQuickFilter = useCallback(
    (filterKey: string) => {
      const nextFilters = {
        ...filters,
        hazardCategory: filters.hazardCategory.includes(filterKey)
          ? filters.hazardCategory.filter((k) => k !== filterKey)
          : [...filters.hazardCategory, filterKey],
      };
      setFilters(nextFilters);
      if (keyword.trim()) {
        const searchParams: IntelligentSearchParams = {
          keyword,
          searchType,
          sortBy: nextFilters.sortBy as any,
        };
        if (nextFilters.hazardCategory.length > 0) {
          searchParams.hazardKeyword = nextFilters.hazardCategory.join(',');
        }
        if (nextFilters.supplier) {
          searchParams.supplier = nextFilters.supplier;
        }
        const { from, to } = buildTimeRange(nextFilters.updateTime);
        if (from && to) {
          searchParams.updateTimeFrom = from;
          searchParams.updateTimeTo = to;
        }
        performSearch(searchParams);
        setFallbackResults(null);
      }
    },
    [filters, keyword, searchType, performSearch],
  );

  // 点击热门搜索
  const handleHotSearchClick = useCallback(
    (hotKeyword: string) => {
      setKeyword(hotKeyword);
      handleSearch(hotKeyword);
      updateSuggestionStat(hotKeyword, true);
    },
    [handleSearch]
  );

  // 点击搜索建议
  const handleSuggestionClick = useCallback(
    (suggestion: SearchSuggestion) => {
      const searchKeyword = suggestion.name;
      setKeyword(searchKeyword);
      handleSearch(searchKeyword);
      updateSuggestionStat(searchKeyword, true);
    },
    [handleSearch]
  );

  // 清除搜索历史
  const handleClearHistory = useCallback(async () => {
    try {
      const res = await clearSearchHistory();
      if (res?.code === 200) {
        message.success('搜索历史已清除');
        await refreshHistory();
      }
    } catch (error) {
      message.error('清除失败');
    }
  }, [refreshHistory]);

  const handleDeleteHistoryItem = useCallback(
    async (searchId?: number) => {
      if (!searchId) {
        return;
      }
      try {
        const res = await deleteSearchHistory([searchId]);
        if (res?.code === 200) {
          message.success('已删除');
          await refreshHistory();
        } else {
          message.warning(res?.msg || '删除失败');
        }
      } catch (error) {
        message.error('删除失败');
      }
    },
    [refreshHistory],
  );

  const handleOpenHistory = useCallback(async () => {
    setHistoryVisible(true);
    await refreshHistory();
  }, [refreshHistory]);

  const handleHistorySearch = useCallback(
    (historyItem: SearchHistory) => {
      const historyKeyword = historyItem.searchKeyword?.trim();
      if (!historyKeyword) {
        return;
      }
      setKeyword(historyKeyword);
      handleSearch(historyKeyword);
      setHistoryVisible(false);
    },
    [handleSearch],
  );

  // 查看文档详情
  const handleViewDetail = useCallback((msdsId: number) => {
    history.push(`/msds/detail/${msdsId}`);
  }, []);

  const displayedResults = fallbackResults || searchResults;
  const isFormulaMode = searchType === 'formula';

  return (
    <PageContainer
      header={{
        title: <span className={styles.pageTitle}>AI智能搜索</span>,
        subTitle: <span className={styles.pageSubTitle}>基于人工智能的MSDS文档智能检索系统</span>,
        extra: [
          <Button key="history" icon={<ClockCircleOutlined />} onClick={handleOpenHistory}>
            搜索历史
          </Button>,
        ],
      }}
      className={styles.searchContainer}
    >
      {/* 搜索英雄区域 */}
      <Card className={styles.searchHero} bordered={false}>
        <div className={styles.searchHeroContent}>
          <div className={styles.searchTitle}>
            <h1>智能搜索MSDS文档</h1>
            <p>支持自然语言查询、语义搜索、多维度筛选</p>
          </div>

          {/* 主搜索框 */}
          <div className={styles.mainSearchBox}>
            <AutoComplete
              value={keyword}
              onChange={(value) => {
                setKeyword(value);
                fetchSuggestions(value);
              }}
              options={suggestions.map((item) => ({
                value: item.name,
                label: (
                  <div
                    onClick={() => handleSuggestionClick(item)}
                    style={{ padding: '8px 0' }}
                  >
                    <div><strong>{item.name}</strong></div>
                    <div style={{ fontSize: '12px', color: '#999' }}>
                      {item.casNumber && `CAS: ${item.casNumber}`}
                      {item.englishName && ` | ${item.englishName}`}
                    </div>
                  </div>
                ),
              }))}
              style={{ width: '100%' }}
            >
              <Search
                placeholder="输入化学品名称、CAS号、分子式，或描述您要查找的内容..."
                enterButton={
                  <Button type="primary" icon={<SearchOutlined />} size="large">
                    搜索
                  </Button>
                }
                size="large"
                onSearch={handleSearch}
                loading={searching}
              />
            </AutoComplete>

            {/* 搜索类型选择 */}
            <div style={{ marginTop: 16 }}>
              <Radio.Group
                value={searchType}
                onChange={(e) => setSearchType(e.target.value)}
                buttonStyle="solid"
              >
                <Radio.Button value="general">普通搜索</Radio.Button>
                <Radio.Button value="semantic">语义搜索</Radio.Button>
                <Radio.Button value="cas">CAS号</Radio.Button>
                <Radio.Button value="formula">分子式</Radio.Button>
              </Radio.Group>
            </div>
          </div>

          {/* 快速筛选标签 */}
          <div className={styles.quickFilters}>
            <Space size="middle" wrap>
              {QUICK_FILTERS.map((filter) => (
                <Tag
                  key={filter.key}
                  icon={filter.icon}
                  color={filters.hazardCategory.includes(filter.key) ? filter.color : 'default'}
                  style={{ cursor: 'pointer', padding: '4px 12px', fontSize: '14px' }}
                  onClick={() => handleQuickFilter(filter.key)}
                >
                  {filter.label}
                </Tag>
              ))}
            </Space>
          </div>
        </div>
      </Card>

      <Row gutter={[24, 24]} style={{ marginTop: 24 }}>
        {/* 左侧筛选器 */}
        <Col xs={24} lg={6}>
          <Card title={<><FilterOutlined /> 高级筛选</>} bordered={false}>
            {/* 危险性分类 */}
            <div className={styles.filterSection}>
              <h4>危险性分类</h4>
              <Checkbox.Group
                value={filters.hazardCategory}
                onChange={(values) =>
                  setFilters({ ...filters, hazardCategory: values as string[] })
                }
              >
                <Space direction="vertical">
                  {HAZARD_OPTIONS.map((option) => (
                    <Checkbox key={option.value} value={option.value}>
                      {option.label}{' '}
                      <Badge count={hazardCountMap[option.value] ?? 0} showZero />
                    </Checkbox>
                  ))}
                </Space>
              </Checkbox.Group>
            </div>

            {/* 更新时间 */}
            <div className={styles.filterSection}>
              <h4>更新时间</h4>
              <Radio.Group
                value={filters.updateTime}
                onChange={(e) => setFilters({ ...filters, updateTime: e.target.value })}
              >
                <Space direction="vertical">
                  <Radio value="all">全部</Radio>
                  <Radio value="week">最近一周</Radio>
                  <Radio value="month">最近一月</Radio>
                  <Radio value="year">最近一年</Radio>
                </Space>
              </Radio.Group>
            </div>

            {/* 供应商 */}
            <div className={styles.filterSection}>
              <h4>供应商</h4>
              <Input
                placeholder="搜索供应商..."
                value={filters.supplier}
                onChange={(e) => setFilters({ ...filters, supplier: e.target.value })}
                suffix={<SearchOutlined />}
              />
            </div>

            {/* 重置和应用按钮 */}
            <div style={{ marginTop: 24 }}>
              <Space>
                <Button
                  onClick={() =>
                    setFilters({
                      hazardCategory: [],
                      updateTime: 'all',
                      supplier: '',
                      sortBy: 'relevance',
                    })
                  }
                >
                  重置
                </Button>
                <Button type="primary" onClick={() => handleSearch(keyword)}>
                  应用
                </Button>
              </Space>
            </div>
          </Card>

          {/* 热门搜索 */}
          <Card
            title={<><FireOutlined /> 热门搜索</>}
            bordered={false}
            style={{ marginTop: 16 }}
            loading={hotLoading}
          >
            {hotSearches && hotSearches.length > 0 ? (
              <Space direction="vertical" style={{ width: '100%' }}>
                {hotSearches.map((item: HotSearch, index: number) => (
                  <div
                    key={item.suggestionId}
                    className={styles.hotSearchItem}
                    onClick={() => handleHotSearchClick(item.keyword)}
                  >
                    <Badge count={index + 1} style={{ backgroundColor: index < 3 ? '#ff4d4f' : '#d9d9d9' }} />
                    <span style={{ marginLeft: 12 }}>{item.keyword}</span>
                    <span style={{ marginLeft: 'auto', color: '#999', fontSize: '12px' }}>
                      {item.searchCount}
                    </span>
                  </div>
                ))}
              </Space>
            ) : (
              <div style={{ color: '#999', fontSize: '13px' }}>暂无热门搜索记录</div>
            )}
          </Card>
        </Col>

        {/* 右侧搜索结果 */}
        <Col xs={24} lg={18}>
          {/* 结果头部 */}
          {displayedResults && (
            <div className={styles.resultHeader}>
              <div>
                <h2>搜索结果</h2>
                <p>
                  找到 <span className={styles.resultCount}>{displayedResults.total}</span> 个相关MSDS文档
                </p>
              </div>
              <div>
                <span style={{ marginRight: 8 }}>排序：</span>
                <Select
                  value={filters.sortBy}
                  onChange={(value) => setFilters({ ...filters, sortBy: value })}
                  style={{ width: 120 }}
                >
                  <Option value="relevance">相关性</Option>
                  <Option value="updated">更新时间</Option>
                  <Option value="name">名称A-Z</Option>
                  <Option value="views">查看次数</Option>
                </Select>
              </div>
            </div>
          )}

          {/* 搜索结果列表 */}
          <Spin spinning={searching}>
            {displayedResults && displayedResults.rows && displayedResults.rows.length > 0 ? (
              <Space direction="vertical" size="middle" style={{ width: '100%' }}>
                {displayedResults.rows.map((item: API.Msds.MsdsMain) => {
                  const statusMeta = STATUS_META[item.status || ''] || { label: item.status || '未知', color: 'default' };
                  return (
                    <Card key={item.id} className={styles.resultCard} hoverable>
                      <Row>
                        <Col flex="auto">
                          <div className={styles.resultTitle}>
                            <h3>{item.productName}</h3>
                            {item.productEnglishName && (
                              <span className={styles.englishName}>({item.productEnglishName})</span>
                            )}
                            <Space style={{ marginLeft: 16 }}>
                              <Tag color={statusMeta.color}>{statusMeta.label}</Tag>
                            </Space>
                          </div>
                          <div className={styles.resultMeta}>
                            <span><strong>CAS号：</strong>{item.casNumber || 'N/A'}</span>
                            <span><strong>供应商：</strong>{item.companyName || 'N/A'}</span>
                            <span><strong>更新时间：</strong>{item.updateTime || item.createTime || 'N/A'}</span>
                          </div>
                          <div className={styles.resultStats}>
                            <Space>
                              <span><EyeOutlined /> 查看 {item.viewCount ?? 0} 次</span>
                              <span>下载 {item.downloadCount ?? 0} 次</span>
                              <span>收藏 {item.favoriteCount ?? 0} 次</span>
                            </Space>
                          </div>
                        </Col>
                        <Col>
                          <Space direction="vertical">
                            <Button
                              type="primary"
                              icon={<EyeOutlined />}
                              onClick={() => handleViewDetail(item.id!)}
                            >
                              查看详情
                            </Button>
                          </Space>
                        </Col>
                      </Row>
                    </Card>
                  );
                })}
              </Space>
            ) : (
              !searching && (
                <Empty
                  description={
                    isFormulaMode
                      ? '当前知识库尚未录入分子式数据，请改用化学品名称或 CAS 号检索'
                      : '暂无搜索结果'
                  }
                  image={Empty.PRESENTED_IMAGE_SIMPLE}
                  style={{ marginTop: 60 }}
                />
              )
            )}
          </Spin>
        </Col>
      </Row>

      <Drawer
        title="搜索历史"
        placement="right"
        width={420}
        open={historyVisible}
        onClose={() => setHistoryVisible(false)}
        extra={
          <Button danger type="text" onClick={handleClearHistory}>
            清空历史
          </Button>
        }
      >
        <List
          loading={historyLoading}
          dataSource={searchHistory}
          locale={{ emptyText: '暂无搜索历史' }}
          className={styles.historyList}
          renderItem={(item) => (
            <List.Item
              key={item.searchId}
              actions={[
                <Button
                  key={`search-${item.searchId}`}
                  type="link"
                  onClick={() => handleHistorySearch(item)}
                >
                  搜索
                </Button>,
                <Button
                  key={`delete-${item.searchId}`}
                  type="link"
                  danger
                  onClick={() => handleDeleteHistoryItem(item.searchId)}
                >
                  删除
                </Button>,
              ]}
            >
              <div className={styles.historyItem}>
                <div className={styles.historyKeyword}>{item.searchKeyword || '未命名关键词'}</div>
                <div className={styles.historyMeta}>
                  <span>{item.searchType || 'general'}</span>
                  <span>{item.resultCount ?? 0} 条结果</span>
                  <span>{item.searchTime || ''}</span>
                </div>
              </div>
            </List.Item>
          )}
        />
      </Drawer>
    </PageContainer>
  );
};

export default IntelligentSearch;
