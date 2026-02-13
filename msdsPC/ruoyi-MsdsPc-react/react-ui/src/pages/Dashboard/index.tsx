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
    blue: {
      from: '#1890ff',
      to: '#43cd80',
      light: '#bae7ff',
      glow: 'rgba(24, 144, 255, 0.6)',
      bgStart: 'rgba(24, 144, 255, 0.95)',
      bgEnd: 'rgba(67, 205, 128, 0.85)'
    },
    green: {
      from: '#43cd80',
      to: '#6ee7b7',
      light: '#a7f3d0',
      glow: 'rgba(67, 205, 128, 0.6)',
      bgStart: 'rgba(67, 205, 128, 0.95)',
      bgEnd: 'rgba(110, 231, 183, 0.85)'
    },
    orange: {
      from: '#faad14',
      to: '#ff7a45',
      light: '#ffe58f',
      glow: 'rgba(250, 173, 20, 0.6)',
      bgStart: 'rgba(250, 173, 20, 0.95)',
      bgEnd: 'rgba(255, 122, 69, 0.85)'
    },
    red: {
      from: '#ff4d4f',
      to: '#ff7875',
      light: '#ffccc7',
      glow: 'rgba(255, 77, 79, 0.6)',
      bgStart: 'rgba(255, 77, 79, 0.95)',
      bgEnd: 'rgba(255, 120, 117, 0.85)'
    },
    purple: {
      from: '#a855f7',
      to: '#c774eb',
      light: '#d9b8ff',
      glow: 'rgba(168, 85, 247, 0.6)',
      bgStart: 'rgba(168, 85, 247, 0.95)',
      bgEnd: 'rgba(199, 116, 235, 0.85)'
    },
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
      background: `linear-gradient(135deg, ${colors.bgStart} 0%, ${colors.bgEnd} 100%)`,
      borderRadius: '16px',
      padding: '28px',
      color: 'white',
      transition: 'all 0.4s cubic-bezier(0.4, 0, 0.2, 1)',
      border: '1px solid rgba(255, 255, 255, 0.2)',
      boxShadow: `
        0 8px 32px ${colors.glow},
        0 0 0 1px rgba(255, 255, 255, 0.1) inset
      `,
      cursor: 'pointer',
      height: '100%',
      minHeight: '160px',
      display: 'flex',
      flexDirection: 'column',
      justifyContent: 'center',
      opacity: mounted ? 1 : 0,
      transform: mounted ? 'translateY(0) scale(1)' : 'translateY(30px) scale(0.95)',
      position: 'relative',
      overflow: 'hidden',
      backdropFilter: 'blur(20px)',
      // 顶部渐变光条
      '&:before': {
        content: '""',
        position: 'absolute',
        top: 0,
        left: 0,
        right: 0,
        height: '3px',
        background: `linear-gradient(90deg, ${colors.from}, ${colors.to})`,
        opacity: 0.8,
      },
      // 顶部径向光晕
      '&:after': {
        content: '""',
        position: 'absolute',
        top: '-50%',
        left: '-50%',
        width: '200%',
        height: '200%',
        background: 'conic-gradient(from 0deg at 50% 50%, rgba(255, 255, 255, 0.15) 0deg, transparent 60deg)',
        animation: 'rotate 20s linear infinite',
        pointerEvents: 'none',
      },
      '@keyframes rotate': {
        from: { transform: 'rotate(0deg)' },
        to: { transform: 'rotate(360deg)' },
      },
      '&:hover': {
        boxShadow: `
          0 16px 48px ${colors.glow},
          0 0 0 1px rgba(255, 255, 255, 0.2) inset
        `,
        transform: 'translateY(-8px) scale(1.02)',
        border: '1px solid rgba(255, 255, 255, 0.3)',
      },
      '&:active': {
        transform: 'translateY(-4px) scale(1)',
      },
    };
  });

  const iconClassName = useEmotionCss(() => {
    return {
      fontSize: '72px',
      opacity: 0.4,
      transition: 'all 0.4s cubic-bezier(0.4, 0, 0.2, 1)',
      filter: 'drop-shadow(0 8px 24px rgba(255, 255, 255, 0.5))',
      position: 'relative',
      zIndex: 1,
      '.ant-card:hover &': {
        opacity: 0.6,
        transform: 'scale(1.15) rotate(8deg)',
        filter: 'drop-shadow(0 12px 32px rgba(255, 255, 255, 0.7))',
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
          <div style={{ flex: 1, position: 'relative', zIndex: 1 }}>
            <div style={{
              fontSize: '15px',
              opacity: 0.95,
              marginBottom: '20px',
              fontWeight: 700,
              letterSpacing: '2px',
              textTransform: 'uppercase',
              textShadow: '0 2px 8px rgba(0, 0, 0, 0.3)',
            }}>
              {title}
            </div>
            <div style={{
              fontSize: '52px',
              fontWeight: 'bold',
              marginBottom: '16px',
              lineHeight: '1',
              textShadow: '0 4px 20px rgba(255, 255, 255, 0.6)',
              letterSpacing: '1px',
            }}>
              {displayValue.toLocaleString()}
            </div>
            {trend && (
              <div style={{
                fontSize: '14px',
                opacity: 0.95,
                display: 'flex',
                alignItems: 'center',
                marginTop: '12px',
                fontWeight: 600,
              }}>
                <span style={{
                  display: 'inline-flex',
                  alignItems: 'center',
                  backgroundColor: 'rgba(255, 255, 255, 0.3)',
                  backdropFilter: 'blur(10px)',
                  padding: '8px 16px',
                  borderRadius: '20px',
                  boxShadow: '0 4px 12px rgba(0, 0, 0, 0.15)',
                  border: '1px solid rgba(255, 255, 255, 0.2)',
                  textShadow: '0 1px 2px rgba(0, 0, 0, 0.2)',
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
    <div style={{
      position: 'relative',
      minHeight: '100vh',
    }}>
      {/* 背景装饰元素 */}
      <div style={{
        position: 'fixed',
        inset: 0,
        overflow: 'hidden',
        pointerEvents: 'none',
        zIndex: 0,
      }}>
        <div style={{
          position: 'absolute',
          borderRadius: '50%',
          background: 'linear-gradient(135deg, rgba(24, 144, 255, 0.15), rgba(67, 205, 128, 0.1))',
          boxShadow: '0 0 60px rgba(24, 144, 255, 0.3)',
          top: '100px',
          left: '5%',
          width: '200px',
          height: '200px',
          animation: 'float 10s ease-in-out infinite',
          '@keyframes float': {
            '0%, 100%': { transform: 'translateY(0px) rotate(0deg)' },
            '50%': { transform: 'translateY(-30px) rotate(180deg)' },
          },
        }} />
        <div style={{
          position: 'absolute',
          borderRadius: '50%',
          background: 'linear-gradient(135deg, rgba(67, 205, 128, 0.12), rgba(24, 144, 255, 0.08))',
          boxShadow: '0 0 80px rgba(67, 205, 128, 0.25)',
          top: '20%',
          right: '10%',
          width: '250px',
          height: '250px',
          animation: 'float 12s ease-in-out infinite',
          animationDelay: '-2s',
        }} />
        <div style={{
          position: 'absolute',
          borderRadius: '50%',
          background: 'linear-gradient(135deg, rgba(24, 144, 255, 0.1), rgba(67, 205, 128, 0.08))',
          boxShadow: '0 0 70px rgba(24, 144, 255, 0.25)',
          bottom: '15%',
          left: '8%',
          width: '180px',
          height: '180px',
          animation: 'float 14s ease-in-out infinite',
          animationDelay: '-4s',
        }} />
      </div>

      <PageContainer
        title="数据仪表板"
        subTitle="安全智库数据概览"
        style={{ position: 'relative', zIndex: 1 }}
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
      <Row gutter={[24, 24]} style={{ marginBottom: 32 }} align="stretch">
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
      <Row gutter={[24, 24]} style={{ marginBottom: 32 }}>
        {/* 文档统计卡片 */}
        <Col xs={24} lg={12}>
          <DocumentStatsCard data={overview.documentStats} />
        </Col>
        
        {/* 系统监控卡片 */}
        <Col xs={24} lg={12}>
          <SystemMonitorCard data={overview.systemStats} />
        </Col>
      </Row>

      <Row gutter={[24, 24]} style={{ marginBottom: 32 }}>
        {/* 访问趋势图表 */}
        <Col xs={24} lg={16}>
          <AccessTrendChart />
        </Col>
        
        {/* 热门文档排行 */}
        <Col xs={24} lg={8}>
          <HotDocumentsRank />
        </Col>
      </Row>

      <Row gutter={[24, 24]} style={{ marginBottom: 32 }}>
        {/* 用户活动图表 */}
        <Col xs={24} lg={12}>
          <UserActivityChart />
        </Col>
        
        {/* 化学品分析图表 */}
        <Col xs={24} lg={12}>
          <ChemicalAnalysisChart data={overview.chemicalStats} />
        </Col>
      </Row>

      <Row gutter={[24, 24]}>
        {/* 下载分析图表 */}
        <Col xs={24}>
          <DownloadAnalyticsChart />
        </Col>
      </Row>
    </PageContainer>
    </div>
  );
};

export default Dashboard;