import React, { useState, useEffect } from 'react';
import { PageContainer } from '@ant-design/pro-components';
import { Row, Col, Card, Statistic, Spin, message, Button, Result, DatePicker, Dropdown, Space } from 'antd';
import {
  FileTextOutlined,
  EyeOutlined,
  DownloadOutlined,
  UserOutlined,
  SafetyCertificateOutlined,
  AlertOutlined,
} from '@ant-design/icons';
import { useModel, history } from '@umijs/max';
import DocumentStatsCard from './components/DocumentStatsCard';
import AccessTrendChart from './components/AccessTrendChart';
import UserActivityChart from './components/UserActivityChart';
import ChemicalAnalysisChart from './components/ChemicalAnalysisChart';
import SystemMonitorCard from './components/SystemMonitorCard';
import DownloadAnalyticsChart from './components/DownloadAnalyticsChart';
import HotDocumentsRank from './components/HotDocumentsRank';
import RealtimeStats from './components/RealtimeStats';
import { getDashboardOverview, exportDashboardReport } from '@/services/dashboard';
import { getAccessToken } from '@/access';
import dayjs from 'dayjs';

interface DashboardOverview {
  documentStats: {
    total: number;
    valid: number;
    pending: number;
    expired: number;
  };
  accessStats: {
    todayViews: number;
    monthViews: number;
    totalViews: number;
    activeUsers: number;
  };
  downloadStats: {
    todayDownloads: number;
    monthDownloads: number;
    totalDownloads: number;
  };
  systemStats: {
    onlineUsers: number;
    cpuUsage: number;
    memoryUsage: number;
    diskUsage: number;
  };
  chemicalStats: {
    totalChemicals: number;
    dangerousCount: number;
    casCount: number;
    supplierCount: number;
  };
}

const Dashboard: React.FC = () => {
  const [loading, setLoading] = useState(true);
  const [overview, setOverview] = useState<DashboardOverview | null>(null);
  const { initialState } = useModel('@@initialState');
  const [dateRange, setDateRange] = useState([
    dayjs().subtract(30, 'day'),
    dayjs()
  ]);

  // 检查用户是否已登录
  const isLoggedIn = () => {
    const token = getAccessToken();
    return token && token.length > 0 && initialState?.currentUser;
  };

  useEffect(() => {
    // 如果用户未登录，重定向到登录页面
    if (!isLoggedIn()) {
      message.warning('请先登录后访问仪表板');
      history.push('/user/login');
      return;
    }

    fetchDashboardData();
    // 设置定时刷新，每30秒更新一次关键数据
    const interval = setInterval(() => {
      fetchDashboardData(false);
    }, 30000);

    return () => clearInterval(interval);
  }, [initialState?.currentUser]);

  const fetchDashboardData = async (showLoading = true) => {
    try {
      if (showLoading) setLoading(true);
      const response = await getDashboardOverview();
      if (response.code === 200) {
        setOverview(response.data);
      } else if (response.code === 401) {
        message.error('登录已过期，请重新登录');
        history.push('/user/login');
      } else {
        message.error(response.msg || '获取仪表板数据失败');
      }
    } catch (error: any) {
      console.error('Dashboard data fetch error:', error);
      if (error?.response?.status === 401) {
        message.error('登录已过期，请重新登录');
        history.push('/user/login');
      } else {
        message.error('网络错误，请稍后重试');
      }
    } finally {
      if (showLoading) setLoading(false);
    }
  };

  // 导出报告
  const handleExportReport = async (format: 'pdf' | 'excel') => {
    try {
      await exportDashboardReport({
        format,
        dateRange: [
          dateRange[0].format('YYYY-MM-DD'),
          dateRange[1].format('YYYY-MM-DD')
        ]
      });
      message.success(`${format.toUpperCase()}报告导出成功`);
    } catch (error) {
      message.error(`导出失败: ${error}`);
    }
  };

  const exportMenu = {
    items: [
      {
        key: 'pdf',
        label: '导出PDF报告',
        onClick: () => handleExportReport('pdf')
      },
      {
        key: 'excel',
        label: '导出Excel报告',
        onClick: () => handleExportReport('excel')
      }
    ]
  };

  // 如果用户未登录，显示登录提示
  if (!isLoggedIn()) {
    return (
      <PageContainer>
        <Result
          status="403"
          title="需要登录"
          subTitle="请先登录后访问仪表板页面"
          extra={
            <Button type="primary" onClick={() => history.push('/user/login')}>
              前往登录
            </Button>
          }
        />
      </PageContainer>
    );
  }

  if (loading || !overview) {
    return (
      <PageContainer>
        <div style={{ textAlign: 'center', padding: '100px 0' }}>
          <Spin size="large" />
        </div>
      </PageContainer>
    );
  }

  return (
    <PageContainer
      title="数据仪表板"
      subTitle="MSDS管理系统数据概览"
      extra={
        <Space size="middle">
          <RealtimeStats />
          <DatePicker.RangePicker
            value={dateRange}
            onChange={(dates) => setDateRange(dates)}
            format="YYYY-MM-DD"
          />
          <Dropdown menu={exportMenu}>
            <Button type="primary" icon={<DownloadOutlined />}>
              导出报告
            </Button>
          </Dropdown>
        </Space>
      }
    >
      {/* 顶部统计卡片区域 */}
      <Row gutter={[16, 16]} style={{ marginBottom: 24 }}>
        <Col xs={24} sm={12} lg={6}>
          <Card>
            <Statistic
              title="文档总数"
              value={overview.documentStats.total}
              prefix={<FileTextOutlined />}
              valueStyle={{ color: '#1890ff' }}
            />
          </Card>
        </Col>
        <Col xs={24} sm={12} lg={6}>
          <Card>
            <Statistic
              title="今日访问"
              value={overview.accessStats.todayViews}
              prefix={<EyeOutlined />}
              valueStyle={{ color: '#52c41a' }}
            />
          </Card>
        </Col>
        <Col xs={24} sm={12} lg={6}>
          <Card>
            <Statistic
              title="今日下载"
              value={overview.downloadStats.todayDownloads}
              prefix={<DownloadOutlined />}
              valueStyle={{ color: '#722ed1' }}
            />
          </Card>
        </Col>
        <Col xs={24} sm={12} lg={6}>
          <Card>
            <Statistic
              title="在线用户"
              value={overview.systemStats.onlineUsers}
              prefix={<UserOutlined />}
              valueStyle={{ color: '#eb2f96' }}
            />
          </Card>
        </Col>
      </Row>

      {/* 主要统计图表区域 */}
      <Row gutter={[16, 16]} style={{ marginBottom: 24 }}>
        {/* 文档统计卡片 */}
        <Col xs={24} lg={12}>
          <DocumentStatsCard data={overview.documentStats} />
        </Col>
        
        {/* 系统监控卡片 */}
        <Col xs={24} lg={12}>
          <SystemMonitorCard data={overview.systemStats} />
        </Col>
      </Row>

      <Row gutter={[16, 16]} style={{ marginBottom: 24 }}>
        {/* 访问趋势图表 */}
        <Col xs={24} lg={16}>
          <AccessTrendChart />
        </Col>
        
        {/* 热门文档排行 */}
        <Col xs={24} lg={8}>
          <HotDocumentsRank />
        </Col>
      </Row>

      <Row gutter={[16, 16]} style={{ marginBottom: 24 }}>
        {/* 用户活动图表 */}
        <Col xs={24} lg={12}>
          <UserActivityChart />
        </Col>
        
        {/* 化学品分析图表 */}
        <Col xs={24} lg={12}>
          <ChemicalAnalysisChart data={overview.chemicalStats} />
        </Col>
      </Row>

      <Row gutter={[16, 16]}>
        {/* 下载分析图表 */}
        <Col xs={24}>
          <DownloadAnalyticsChart />
        </Col>
      </Row>
    </PageContainer>
  );
};

export default Dashboard;