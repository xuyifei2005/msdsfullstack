import React, { useState, useEffect } from 'react';
import {
  Card,
  Row,
  Col,
  Statistic,
  DatePicker,
  Button,
  Table,
  Tag,
  Space,
  Segmented,
  Progress,
  Alert,
  message,
} from 'antd';
import {
  DownloadOutlined,
  SettingOutlined,
  ArrowUpOutlined,
  ArrowDownOutlined,
  MinusOutlined,
  FileTextOutlined,
  ExclamationCircleOutlined,
  EyeOutlined,
  UserOutlined,
  BulbOutlined,
  BarChartOutlined,
} from '@ant-design/icons';
import { PageContainer } from '@ant-design/pro-components';
import { Column, Line, Pie } from '@ant-design/plots';
import { useRequest } from '@umijs/max';
import type { RangePickerProps } from 'antd/es/date-picker';
import dayjs from 'dayjs';
import {
  getSummaryStatistics,
  getAccessTrend,
  getCategoryDistribution,
  getHazardDistribution,
  getTopMsdsRanking,
  getMonthlyNewMsds,
  getUserActivityStats,
  exportAnalyticsReport,
} from '@/services/msds/analytics';
import styles from './index.less';

const { RangePicker } = DatePicker;

const DataReport: React.FC = () => {
  const [timeRange, setTimeRange] = useState<number>(7);
  const [dateRange, setDateRange] = useState<[string, string]>([
    dayjs().subtract(6, 'month').format('YYYY-MM-DD'),
    dayjs().format('YYYY-MM-DD'),
  ]);

  // 获取基础统计
  const { data: summaryData, loading: summaryLoading } = useRequest(
    getSummaryStatistics,
    {
      onSuccess: (res) => {
        if (res?.code === 200) {
          return res.data;
        }
      },
    }
  );

  // 获取访问趋势
  const { data: trendData, loading: trendLoading, run: fetchTrend } = useRequest(
    () => getAccessTrend(timeRange),
    {
      refreshDeps: [timeRange],
      onSuccess: (res) => {
        if (res?.code === 200) {
          return res.data;
        }
      },
    }
  );

  // 获取分类分布
  const { data: categoryData, loading: categoryLoading } = useRequest(
    getCategoryDistribution,
    {
      onSuccess: (res) => {
        if (res?.code === 200) {
          return res.data;
        }
      },
    }
  );

  // 获取危险等级分布
  const { data: hazardData, loading: hazardLoading } = useRequest(
    getHazardDistribution,
    {
      onSuccess: (res) => {
        if (res?.code === 200) {
          return res.data;
        }
      },
    }
  );

  // 获取排行榜
  const { data: rankingData, loading: rankingLoading } = useRequest(
    () => getTopMsdsRanking(10),
    {
      onSuccess: (res) => {
        if (res?.code === 200) {
          return res.data;
        }
      },
    }
  );

  // 获取月度新增
  const { data: monthlyData, loading: monthlyLoading } = useRequest(
    () => getMonthlyNewMsds(6),
    {
      onSuccess: (res) => {
        if (res?.code === 200) {
          return res.data;
        }
      },
    }
  );

  // 获取用户活跃度
  const { data: userActivityData, loading: userActivityLoading } = useRequest(
    getUserActivityStats,
    {
      onSuccess: (res) => {
        if (res?.code === 200) {
          return res.data;
        }
      },
    }
  );

  // 导出报告
  const handleExport = async () => {
    try {
      const res = await exportAnalyticsReport(dateRange[0], dateRange[1]);
      if (res.code === 200) {
        message.success('报告导出成功');
        // 实际应该触发文件下载
      }
    } catch (error) {
      message.error('导出失败');
    }
  };

  // 访问趋势图配置
  const trendChartConfig = {
    data: trendData || [],
    xField: 'date',
    yField: 'visits',
    smooth: true,
    color: '#1890ff',
    point: {
      size: 4,
      shape: 'circle',
    },
    label: {
      style: {
        fill: '#aaa',
      },
    },
    lineStyle: {
      lineWidth: 2,
    },
    areaStyle: {
      fill: 'l(270) 0:#ffffff 0.5:#7ec2f3 1:#1890ff',
      fillOpacity: 0.2,
    },
  };

  // 分类分布饼图配置
  const categoryChartConfig = {
    data: categoryData || [],
    angleField: 'value',
    colorField: 'name',
    radius: 0.8,
    innerRadius: 0.6,
    label: {
      type: 'inner',
      offset: '-30%',
      content: '{value}',
      style: {
        textAlign: 'center',
        fontSize: 14,
      },
    },
    interactions: [
      {
        type: 'element-selected',
      },
      {
        type: 'element-active',
      },
    ],
    statistic: {
      title: false,
      content: {
        style: {
          whiteSpace: 'pre-wrap',
          overflow: 'hidden',
          textOverflow: 'ellipsis',
        },
        content: '分类分布',
      },
    },
    legend: false,
  };

  // 危险等级柱状图配置
  const hazardChartConfig = {
    data: hazardData || [],
    xField: 'level',
    yField: 'value',
    seriesField: 'level',
    color: ({ level }: any) => {
      return level === '高危' ? '#ef4444' : level === '中等' ? '#f59e0b' : '#10b981';
    },
    columnStyle: {
      radius: [4, 4, 0, 0],
    },
    legend: false,
  };

  // 月度新增柱状图配置
  const monthlyChartConfig = {
    data: monthlyData || [],
    xField: 'monthLabel',
    yField: 'value',
    color: '#8b5cf6',
    columnStyle: {
      radius: [4, 4, 0, 0],
    },
    legend: false,
  };

  // 排行榜表格列配置
  const rankingColumns = [
    {
      title: '排名',
      dataIndex: 'index',
      key: 'index',
      width: 80,
      render: (_: any, __: any, index: number) => {
        const colors = ['#fbbf24', '#d1d5db', '#fb923c'];
        const color = index < 3 ? colors[index] : '#d1d5db';
        return (
          <div
            style={{
              width: 24,
              height: 24,
              borderRadius: '50%',
              background: color,
              color: index < 3 ? '#fff' : '#666',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontWeight: 'bold',
              fontSize: 12,
            }}
          >
            {index + 1}
          </div>
        );
      },
    },
    {
      title: '化学品名称',
      dataIndex: 'productName',
      key: 'productName',
      render: (text: string, record: RankingItem) => (
        <div>
          <div style={{ fontWeight: 500 }}>{text}</div>
          {record.englishName && (
            <div style={{ fontSize: 12, color: '#999' }}>{record.englishName}</div>
          )}
        </div>
      ),
    },
    {
      title: 'CAS号',
      dataIndex: 'casNumber',
      key: 'casNumber',
      width: 120,
    },
    {
      title: '危险等级',
      dataIndex: 'hazardLevelText',
      key: 'hazardLevelText',
      width: 100,
      render: (text: string, record: RankingItem) => {
        const colorMap = {
          high: 'red',
          medium: 'orange',
          low: 'green',
        };
        return <Tag color={colorMap[record.hazardLevel]}>{text}</Tag>;
      },
    },
    {
      title: '访问次数',
      dataIndex: 'viewCount',
      key: 'viewCount',
      width: 100,
      sorter: (a: RankingItem, b: RankingItem) => a.viewCount - b.viewCount,
    },
    {
      title: '增长率',
      dataIndex: 'growthRate',
      key: 'growthRate',
      width: 100,
      render: (rate: number) => {
        const isPositive = rate > 0;
        const isNegative = rate < 0;
        return (
          <span style={{ color: isPositive ? '#52c41a' : isNegative ? '#ff4d4f' : '#8c8c8c' }}>
            {isPositive ? '+' : ''}
            {rate}%
          </span>
        );
      },
    },
    {
      title: '操作',
      key: 'action',
      width: 150,
      render: (_: any, record: RankingItem) => (
        <Space>
          <Button type="link" size="small">查看</Button>
          <Button type="link" size="small">分析</Button>
        </Space>
      ),
    },
  ];

  return (
    <PageContainer
      header={{
        title: '数据分析报告',
        subTitle: 'MSDS Data Analysis & Reports',
        extra: [
          <Space key="actions">
            <RangePicker
              value={[dayjs(dateRange[0]), dayjs(dateRange[1])]}
              onChange={(dates) => {
                if (dates) {
                  setDateRange([
                    dates[0]?.format('YYYY-MM-DD') || '',
                    dates[1]?.format('YYYY-MM-DD') || '',
                  ]);
                }
              }}
            />
            <Button
              type="primary"
              icon={<DownloadOutlined />}
              onClick={handleExport}
            >
              导出报告
            </Button>
            <Button icon={<SettingOutlined />}>设置</Button>
          </Space>,
        ],
      }}
      className={styles.reportContainer}
    >
      {/* 统计卡片 */}
      <Row gutter={[16, 16]} style={{ marginBottom: 24 }}>
        <Col xs={24} sm={12} lg={6}>
          <Card loading={summaryLoading} hoverable className={styles.statCard}>
            <Statistic
              title="MSDS文档总数"
              value={summaryData?.totalMsds || 0}
              prefix={<FileTextOutlined style={{ color: '#1890ff' }} />}
              suffix={
                <div className={styles.trendUp}>
                  <ArrowUpOutlined />
                  <span>{summaryData?.msdsGrowthRate || '+0%'}</span>
                </div>
              }
              valueStyle={{ color: '#1890ff' }}
            />
            <div style={{ marginTop: 8, fontSize: 12, color: '#999' }}>较上月</div>
          </Card>
        </Col>
        <Col xs={24} sm={12} lg={6}>
          <Card loading={summaryLoading} hoverable className={styles.statCard}>
            <Statistic
              title="高危化学品"
              value={summaryData?.highHazardCount || 0}
              prefix={<ExclamationCircleOutlined style={{ color: '#ff4d4f' }} />}
              suffix={
                <div className={styles.trendDown}>
                  <ArrowDownOutlined />
                  <span>{summaryData?.hazardGrowthRate || '0%'}</span>
                </div>
              }
              valueStyle={{ color: '#ff4d4f' }}
            />
            <div style={{ marginTop: 8, fontSize: 12, color: '#999' }}>较上月</div>
          </Card>
        </Col>
        <Col xs={24} sm={12} lg={6}>
          <Card loading={summaryLoading} hoverable className={styles.statCard}>
            <Statistic
              title="本月访问量"
              value={summaryData?.monthlyVisits || 0}
              prefix={<EyeOutlined style={{ color: '#52c41a' }} />}
              suffix={
                <div className={styles.trendUp}>
                  <ArrowUpOutlined />
                  <span>{summaryData?.visitsGrowthRate || '+0%'}</span>
                </div>
              }
              valueStyle={{ color: '#52c41a' }}
            />
            <div style={{ marginTop: 8, fontSize: 12, color: '#999' }}>较上月</div>
          </Card>
        </Col>
        <Col xs={24} sm={12} lg={6}>
          <Card loading={summaryLoading} hoverable className={styles.statCard}>
            <Statistic
              title="活跃用户"
              value={summaryData?.activeUsers || 0}
              prefix={<UserOutlined style={{ color: '#722ed1' }} />}
              suffix={
                <div className={styles.trendStable}>
                  <MinusOutlined />
                  <span>{summaryData?.usersGrowthRate || '0%'}</span>
                </div>
              }
              valueStyle={{ color: '#722ed1' }}
            />
            <div style={{ marginTop: 8, fontSize: 12, color: '#999' }}>持平</div>
          </Card>
        </Col>
      </Row>

      {/* 智能洞察卡片 */}
      <Alert
        message={
          <div style={{ display: 'flex', alignItems: 'center' }}>
            <BulbOutlined style={{ fontSize: 18, marginRight: 8 }} />
            <span style={{ fontSize: 16, fontWeight: 500 }}>智能洞察</span>
          </div>
        }
        description={
          <div>
            <p style={{ marginBottom: 8, fontSize: 14, opacity: 0.9 }}>
              基于AI分析的关键发现和建议
            </p>
            <ul style={{ listStyle: 'none', padding: 0, margin: 0 }}>
              <li style={{ marginBottom: 8 }}>
                ✓ 有机溶剂类MSDS文档访问量增长显著，建议加强安全培训
              </li>
              <li style={{ marginBottom: 8 }}>
                ⚠️ 发现{summaryData?.highHazardCount || 0}个高危化学品，需要重点关注
              </li>
              <li>
                ℹ️ 新增化学品主要集中在有机化学品领域
              </li>
            </ul>
          </div>
        }
        type="info"
        style={{ marginBottom: 24 }}
        className={styles.insightCard}
      />

      {/* 图表区域 */}
      <Row gutter={[16, 16]} style={{ marginBottom: 24 }}>
        {/* MSDS访问趋势图 */}
        <Col xs={24} lg={12}>
          <Card
            title={
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <span>MSDS访问趋势</span>
                <Segmented
                  options={[
                    { label: '7天', value: 7 },
                    { label: '30天', value: 30 },
                    { label: '90天', value: 90 },
                  ]}
                  value={timeRange}
                  onChange={(value) => setTimeRange(value as number)}
                  size="small"
                />
              </div>
            }
            loading={trendLoading}
          >
            <Line {...trendChartConfig} height={300} />
          </Card>
        </Col>

        {/* 化学品分类分布 */}
        <Col xs={24} lg={12}>
          <Card
            title="化学品分类分布"
            loading={categoryLoading}
            extra={
              <Button
                type="link"
                icon={<BarChartOutlined />}
                onClick={() => message.info('查看详细分类')}
              >
                详情
              </Button>
            }
          >
            <Pie {...categoryChartConfig} height={300} />
            <div className={styles.chartLegend}>
              {categoryData?.map((item: any, index: number) => {
                const colors = ['#3b82f6', '#10b981', '#f59e0b', '#ef4444'];
                return (
                  <div key={index} className={styles.legendItem}>
                    <div
                      className={styles.legendColor}
                      style={{ background: colors[index % colors.length] }}
                    />
                    <span>{item.name}</span>
                  </div>
                );
              })}
            </div>
          </Card>
        </Col>
      </Row>

      {/* 危险等级分析 */}
      <Row gutter={[16, 16]} style={{ marginBottom: 24 }}>
        <Col xs={24} lg={8}>
          <Card title="危险等级分布" loading={hazardLoading}>
            <Column {...hazardChartConfig} height={250} />
          </Card>
        </Col>

        <Col xs={24} lg={8}>
          <Card title="月度新增MSDS" loading={monthlyLoading}>
            <Column {...monthlyChartConfig} height={250} />
          </Card>
        </Col>

        <Col xs={24} lg={8}>
          <Card title="用户活跃度" loading={userActivityLoading}>
            <div style={{ padding: '16px 0' }}>
              <div style={{ marginBottom: 24 }}>
                <div style={{ marginBottom: 8, display: 'flex', justifyContent: 'space-between' }}>
                  <span>日活跃用户</span>
                  <span style={{ fontWeight: 'bold' }}>
                    {userActivityData?.dailyActiveRate || 0}%
                  </span>
                </div>
                <Progress
                  percent={userActivityData?.dailyActiveRate || 0}
                  strokeColor="#1890ff"
                  showInfo={false}
                />
              </div>

              <div style={{ marginBottom: 24 }}>
                <div style={{ marginBottom: 8, display: 'flex', justifyContent: 'space-between' }}>
                  <span>周活跃用户</span>
                  <span style={{ fontWeight: 'bold' }}>
                    {userActivityData?.weeklyActiveRate || 0}%
                  </span>
                </div>
                <Progress
                  percent={userActivityData?.weeklyActiveRate || 0}
                  strokeColor="#52c41a"
                  showInfo={false}
                />
              </div>

              <div style={{ marginBottom: 16 }}>
                <div style={{ marginBottom: 8, display: 'flex', justifyContent: 'space-between' }}>
                  <span>月活跃用户</span>
                  <span style={{ fontWeight: 'bold' }}>
                    {userActivityData?.monthlyActiveRate || 0}%
                  </span>
                </div>
                <Progress
                  percent={userActivityData?.monthlyActiveRate || 0}
                  strokeColor="#722ed1"
                  showInfo={false}
                />
              </div>

              <Alert
                message="用户活跃度保持稳定增长趋势"
                type="info"
                showIcon
                style={{ marginTop: 16 }}
              />
            </div>
          </Card>
        </Col>
      </Row>

      {/* 热门MSDS排行榜 */}
      <Card
        title="热门MSDS排行榜"
        loading={rankingLoading}
        extra={
          <Segmented
            options={['本周', '本月', '本季度']}
            defaultValue="本周"
            size="small"
          />
        }
      >
        <Table
          columns={rankingColumns}
          dataSource={rankingData || []}
          rowKey="id"
          pagination={false}
          size="middle"
        />
      </Card>
    </PageContainer>
  );
};

export default DataReport;

