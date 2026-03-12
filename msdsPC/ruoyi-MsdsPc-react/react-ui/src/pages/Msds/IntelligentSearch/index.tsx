import React, { useState, useCallback } from 'react';
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
  DownloadOutlined,
  StarOutlined,
  FilterOutlined,
} from '@ant-design/icons';
import { PageContainer } from '@ant-design/pro-components';
import { useRequest, history } from '@umijs/max';
import type { SearchSuggestion, HotSearch, IntelligentSearchParams } from '@/services/msds/search';
import {
  intelligentSearch,
  getSearchSuggestions,
  getHotSearches,
  getUserSearchHistory,
  clearSearchHistory,
  deleteSearchHistory,
  updateSuggestionStat,
} from '@/services/msds/search';
import { getMsdsList } from '@/services/msds';
import styles from './index.less';

const { Search } = Input;
const { Option } = Select;

// 快速筛选标签配置
const QUICK_FILTERS = [
  { key: 'flammable', icon: <FireOutlined />, label: '易燃物质', color: 'red' },
  { key: 'toxic', icon: <ExperimentOutlined />, label: '有毒物质', color: 'purple' },
  { key: 'corrosive', icon: <AlertOutlined />, label: '腐蚀性物质', color: 'orange' },
  { key: 'oxidizing', icon: <SafetyOutlined />, label: '氧化性物质', color: 'blue' },
  { key: 'common', icon: <ExperimentOutlined />, label: '实验室常用', color: 'green' },
];

const IntelligentSearch: React.FC = () => {
  const [keyword, setKeyword] = useState<string>('');
  const [searchType, setSearchType] = useState<string>('general');
  const [activeFilters, setActiveFilters] = useState<string[]>([]);
  const [suggestions, setSuggestions] = useState<SearchSuggestion[]>([]);
  const [showSuggestions, setShowSuggestions] = useState(false);
  const [historyVisible, setHistoryVisible] = useState(false);
  const [fallbackResults, setFallbackResults] = useState<any>(null);
  
  // 高级筛选状态
  const [filters, setFilters] = useState({
    documentType: [] as string[],
    hazardCategory: [] as string[],
    updateTime: 'all',
    supplier: '',
    sortBy: 'relevance',
  });

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
      onSuccess: async (res, paramsList) => {
        const code = Number(res?.code);
        if (code === 200 || code === 0 || Array.isArray(res?.rows)) {
          setFallbackResults(null);
          const totalCount = res?.total || 0;
          message.success(`找到 ${totalCount} 个相关文档`);
        } else {
          const params = Array.isArray(paramsList) ? paramsList[0] : undefined;
          const fallback = await getMsdsList({
            productName: params?.keyword,
            supplier: params?.supplier,
            pageNum: 1,
            pageSize: 20,
          });
          if (fallback && Array.isArray((fallback as any).rows)) {
            setFallbackResults(fallback);
            message.warning('智能检索异常，已自动切换基础检索结果');
          } else {
            message.warning(res?.msg || '搜索失败');
          }
        }
      },
      onError: async (error: any, paramsList) => {
        const errorMessage =
          error?.info?.errorMessage ||
          error?.data?.msg ||
          error?.response?.data?.msg ||
          error?.message ||
          '未知错误';
        const params = Array.isArray(paramsList) ? paramsList[0] : undefined;
        const fallback = await getMsdsList({
          productName: params?.keyword,
          supplier: params?.supplier,
          pageNum: 1,
          pageSize: 20,
        });
        if (fallback && Array.isArray((fallback as any).rows)) {
          setFallbackResults(fallback);
          message.warning('智能检索请求失败，已自动回退基础检索');
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
  const handleSearch = useCallback((value: string) => {
    if (!value.trim()) {
      message.warning('请输入搜索关键词');
      return;
    }

    const searchParams: IntelligentSearchParams = {
      keyword: value,
      searchType,
      sortBy: filters.sortBy as any,
    };

    if (filters.documentType.length > 0) {
      searchParams.documentType = filters.documentType.join(',');
    }

    if (filters.supplier) {
      searchParams.supplier = filters.supplier;
    }

    performSearch(searchParams);
    setFallbackResults(null);
    setShowSuggestions(false);
  }, [searchType, filters, performSearch]);

  // 点击快速筛选
  const handleQuickFilter = useCallback((filterKey: string) => {
    setActiveFilters((prev) => {
      const newFilters = prev.includes(filterKey)
        ? prev.filter((k) => k !== filterKey)
        : [...prev, filterKey];
      return newFilters;
    });
  }, []);

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
                  color={activeFilters.includes(filter.key) ? filter.color : 'default'}
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
            {/* 文档类型 */}
            <div className={styles.filterSection}>
              <h4>文档类型</h4>
              <Checkbox.Group
                value={filters.documentType}
                onChange={(values) =>
                  setFilters({ ...filters, documentType: values as string[] })
                }
              >
                <Space direction="vertical">
                  <Checkbox value="standard">标准MSDS <Badge count={1234} /></Checkbox>
                  <Checkbox value="simplified">简化MSDS <Badge count={456} /></Checkbox>
                  <Checkbox value="custom">企业自制 <Badge count={78} /></Checkbox>
                </Space>
              </Checkbox.Group>
            </div>

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
                  <Checkbox value="flammable">易燃液体 <Badge count={345} /></Checkbox>
                  <Checkbox value="corrosive">腐蚀性 <Badge count={234} /></Checkbox>
                  <Checkbox value="toxic">有毒 <Badge count={567} /></Checkbox>
                  <Checkbox value="oxidizing">氧化性 <Badge count={123} /></Checkbox>
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
                      documentType: [],
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
            <Space direction="vertical" style={{ width: '100%' }}>
              {hotSearches?.map((item: HotSearch, index: number) => (
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
                {displayedResults.rows.map((item: API.Msds.MsdsMain) => (
                  <Card key={item.id} className={styles.resultCard} hoverable>
                    <Row>
                      <Col flex="auto">
                        <div className={styles.resultTitle}>
                          <h3>{item.productName}</h3>
                          {item.productEnglishName && (
                            <span className={styles.englishName}>({item.productEnglishName})</span>
                          )}
                          <Space style={{ marginLeft: 16 }}>
                            <Tag color="green">有效</Tag>
                            {/* 根据实际数据添加危险性标签 */}
                          </Space>
                        </div>
                        <div className={styles.resultMeta}>
                          <span><strong>CAS号：</strong>{item.casNumber || 'N/A'}</span>
                          <span><strong>供应商：</strong>{item.companyName || 'N/A'}</span>
                          <span><strong>更新时间：</strong>{item.updateTime || item.createTime}</span>
                        </div>
                        <div className={styles.resultStats}>
                          <Space>
                            <span><EyeOutlined /> 查看 156 次</span>
                            <span><DownloadOutlined /> 下载 23 次</span>
                            <span><StarOutlined /> 收藏 12 次</span>
                          </Space>
                        </div>
                      </Col>
                      <Col>
                        <Space direction="vertical">
                          <Button
                            type="primary"
                            icon={<EyeOutlined />}
                            onClick={() => handleViewDetail(item.id)}
                          >
                            查看详情
                          </Button>
                          <Button icon={<DownloadOutlined />}>下载</Button>
                          <Button icon={<StarOutlined />}>收藏</Button>
                        </Space>
                      </Col>
                    </Row>
                  </Card>
                ))}
              </Space>
            ) : (
              !searching && (
                <Empty
                  description="暂无搜索结果"
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

