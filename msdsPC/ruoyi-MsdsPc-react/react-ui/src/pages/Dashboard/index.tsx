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
  ArrowUpOutlined,
  ArrowDownOutlined,
} from '@ant-design/icons';
import { useEmotionCss } from '@ant-design/use-emotion-css';
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

// 美化的统计卡片组件
const StatCard: React.FC<{
  title: string;
  value: number;
  trend?: { value: number; label: string };
  icon: React.ReactNode;
  color: 'blue' | 'green' | 'orange' | 'red' | 'purple';
  index?: number;
}> = ({ title, value, trend, icon, color, index = 0 }) => {
  const [displayValue, setDisplayValue] = useState(0);
  const [mounted, setMounted] = useState(false);

  const colorMap = {
    blue: { from: '#1890ff', to: '#40a9ff', light: '#bae7ff' },
    green: { from: '#52c41a', to: '#73d13d', light: '#d9f7be' },
    orange: { from: '#faad14', to: '#ffc53d', light: '#ffe58f' },
    red: { from: '#ff4d4f', to: '#ff7875', light: '#ffccc7' },
    purple: { from: '#722ed1', to: '#9254de', light: '#efdbff' },
  };

  // 入场动画
  useEffect(() => {
    const timer = setTimeout(() => {
      setMounted(true);
    }, index * 100);
    return () => clearTimeout(timer);
  }, [index]);

  // 数字滚动动画
  useEffect(() => {
    if (!mounted) return;
    
    const duration = 1500; // 动画时长
    const steps = 60; // 动画步数
    const increment = value / steps;
    let currentStep = 0;

    const timer = setInterval(() => {
      currentStep++;
      if (currentStep <= steps) {
        setDisplayValue(Math.min(Math.floor(increment * currentStep), value));
      } else {
        setDisplayValue(value);
        clearInterval(timer);
      }
    }, duration / steps);

    return () => clearInterval(timer);
  }, [mounted, value]);

  const cardClassName = useEmotionCss(() => {
    const colors = colorMap[color];
    return {
      background: `linear-gradient(135deg, ${colors.from} 0%, ${colors.to} 100%)`,
      borderRadius: '12px',
      padding: '24px',
      color: 'white',
      transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
      border: 'none',
      boxShadow: '0 2px 8px rgba(0, 0, 0, 0.1)',
      cursor: 'pointer',
      height: '100%',
      minHeight: '140px',
      display: 'flex',
      flexDirection: 'column',
      justifyContent: 'center',
      opacity: mounted ? 1 : 0,
      transform: mounted ? 'translateY(0) scale(1)' : 'translateY(20px) scale(0.95)',
      '&:hover': {
        boxShadow: '0 8px 24px rgba(0, 0, 0, 0.15)',
        transform: 'translateY(-4px) scale(1.02)',
      },
      '&:active': {
        transform: 'translateY(-2px) scale(1)',
      },
    };
  });

  const iconClassName = useEmotionCss(() => {
    return {
      fontSize: '56px',
      opacity: 0.25,
      transition: 'all 0.3s ease',
      filter: 'drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1))',
      '.ant-card:hover &': {
        opacity: 0.35,
        transform: 'scale(1.1) rotate(5deg)',
      },
    };
  });

  const cardWrapperStyle = useEmotionCss(() => {
    return {
      width: '100%',
      height: '100%',
      '.ant-card': {
        height: '100%',
      },
      '.ant-card-body': {
        height: '100%',
        padding: 0,
      },
    };
  });

  return (
    <div className={cardWrapperStyle}>
      <Card className={cardClassName} bordered={false}>
        <div style={{ 
          display: 'flex', 
          alignItems: 'center', 
          justifyContent: 'space-between',
          height: '100%',
        }}>
          <div style={{ flex: 1 }}>
            <div style={{ 
              fontSize: '14px', 
              opacity: 0.95, 
              marginBottom: '12px',
              fontWeight: 500,
              letterSpacing: '0.5px',
            }}>
              {title}
            </div>
            <div style={{ 
              fontSize: '36px', 
              fontWeight: 'bold', 
              marginBottom: '8px',
              lineHeight: '1.2',
              textShadow: '0 2px 4px rgba(0, 0, 0, 0.1)',
            }}>
              {displayValue.toLocaleString()}
            </div>
            {trend && (
              <div style={{ 
                fontSize: '13px', 
                opacity: 0.9, 
                display: 'flex', 
                alignItems: 'center',
                marginTop: '4px',
              }}>
                <span style={{ 
                  display: 'inline-flex', 
                  alignItems: 'center',
                  backgroundColor: 'rgba(255, 255, 255, 0.2)',
                  padding: '4px 10px',
                  borderRadius: '12px',
                }}>
                  {trend.value >= 0 ? (
                    <ArrowUpOutlined style={{ marginRight: '4px', fontSize: '12px' }} />
                  ) : (
                    <ArrowDownOutlined style={{ marginRight: '4px', fontSize: '12px' }} />
                  )}
                  {trend.label}
                </span>
              </div>
            )}
          </div>
          <div className={iconClassName}>
            {icon}
          </div>
        </div>
      </Card>
    </div>
  );
};

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
      {/* 顶部统计卡片区域 - 美化版 */}
      <Row gutter={[16, 16]} style={{ marginBottom: 24 }} align="stretch">
        <Col xs={24} sm={12} lg={6} style={{ display: 'flex' }}>
          <StatCard
            title="文档总数"
            value={overview.documentStats.total}
            trend={{
              value: 12,
              label: '较上月增长 12%'
            }}
            icon={<FileTextOutlined />}
            color="blue"
            index={0}
          />
        </Col>
        <Col xs={24} sm={12} lg={6} style={{ display: 'flex' }}>
          <StatCard
            title="今日访问"
            value={overview.accessStats.todayViews}
            trend={{
              value: 3,
              label: '较昨日增长'
            }}
            icon={<EyeOutlined />}
            color="green"
            index={1}
          />
        </Col>
        <Col xs={24} sm={12} lg={6} style={{ display: 'flex' }}>
          <StatCard
            title="今日下载"
            value={overview.downloadStats.todayDownloads}
            trend={{
              value: 0,
              label: '今日下载量'
            }}
            icon={<DownloadOutlined />}
            color="orange"
            index={2}
          />
        </Col>
        <Col xs={24} sm={12} lg={6} style={{ display: 'flex' }}>
          <StatCard
            title="在线用户"
            value={overview.systemStats.onlineUsers}
            trend={{
              value: 2,
              label: '当前在线'
            }}
            icon={<UserOutlined />}
            color="purple"
            index={3}
          />
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