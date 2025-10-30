import React, { useState, useEffect } from 'react';
import { PageContainer } from '@ant-design/pro-components';
import { 
  Row, 
  Col, 
  Card, 
  Statistic, 
  Spin, 
  message, 
  DatePicker, 
  Space, 
  Divider, 
  Select,
  Alert 
} from 'antd';
import {
  FileTextOutlined,
  CheckCircleOutlined,
  CloseCircleOutlined,
  CalendarOutlined,
  PieChartOutlined,
  TeamOutlined,
  RiseOutlined,
  InfoCircleOutlined,
} from '@ant-design/icons';
import { Pie, Column } from '@ant-design/plots';
import dayjs from 'dayjs';
import { 
  getAuditStatistics, 
  getOperationTypeStatistics, 
  getOperatorStatistics 
} from '@/services/system/auditlog';

const { RangePicker } = DatePicker;
const { Option } = Select;

interface AuditStatisticsData {
  totalLogs: number;
  successLogs: number;
  failedLogs: number;
  todayLogs: number;
}

interface OperationTypeStats {
  operationTypes: Array<{
    operationType: string;
    count: number;
  }> | Record<string, number>;
}

interface OperatorStats {
  operators: Array<{
    operator: string;
    count: number;
  }> | Record<string, number>;
  days: number;
}

const AuditStatisticsPage: React.FC = () => {
  const [loading, setLoading] = useState(true);
  const [auditStats, setAuditStats] = useState<AuditStatisticsData | null>(null);
  const [operationTypeStats, setOperationTypeStats] = useState<OperationTypeStats | null>(null);
  const [operatorStats, setOperatorStats] = useState<OperatorStats | null>(null);
  const [operatorDays, setOperatorDays] = useState(30);

  // 加载统计数据
  const loadStatistics = async () => {
    setLoading(true);
    try {
      const [auditResponse, operationTypeResponse, operatorResponse] = await Promise.all([
        getAuditStatistics(),
        getOperationTypeStatistics(),
        getOperatorStatistics(operatorDays),
      ]);

      if (auditResponse.code === 200) {
        setAuditStats(auditResponse.data);
      }

      if (operationTypeResponse.code === 200) {
        setOperationTypeStats(operationTypeResponse.data);
      }

      if (operatorResponse.code === 200) {
        setOperatorStats(operatorResponse.data);
      }
    } catch (error) {
      message.error('加载统计数据失败');
      console.error('统计数据加载错误:', error);
    } finally {
      setLoading(false);
    }
  };

  // 操作人员统计天数变化
  const handleOperatorDaysChange = async (days: number) => {
    setOperatorDays(days);
    try {
      const response = await getOperatorStatistics(days);
      if (response.code === 200) {
        setOperatorStats(response.data);
      }
    } catch (error) {
      message.error('加载操作人员统计失败');
    }
  };

  useEffect(() => {
    loadStatistics();
  }, []);

  // 转换操作类型数据为图表格式
  const getOperationTypePieData = () => {
    if (!operationTypeStats?.operationTypes) return [];
    
    const typeData = operationTypeStats.operationTypes;
    
    if (Array.isArray(typeData)) {
      return typeData.map(item => ({
        type: item.operationType || '未知',
        value: item.count || 0,
      }));
    } else {
      return Object.entries(typeData).map(([type, count]) => ({
        type: type || '未知',
        value: count as number,
      }));
    }
  };

  // 转换操作人员数据为图表格式
  const getOperatorColumnData = () => {
    if (!operatorStats?.operators) return [];
    
    const operatorData = operatorStats.operators;
    
    if (Array.isArray(operatorData)) {
      return operatorData
        .sort((a, b) => (b.count || 0) - (a.count || 0))
        .slice(0, 10) // 只显示前10名
        .map(item => ({
          operator: item.operator || '未知用户',
          count: item.count || 0,
        }));
    } else {
      return Object.entries(operatorData)
        .sort(([, a], [, b]) => (b as number) - (a as number))
        .slice(0, 10)
        .map(([operator, count]) => ({
          operator: operator || '未知用户',
          count: count as number,
        }));
    }
  };

  // 操作类型饼图配置
  const pieConfig = {
    data: getOperationTypePieData(),
    angleField: 'value',
    colorField: 'type',
    radius: 0.8,
    label: {
      type: 'outer',
      content: '{name}: {percentage}',
    },
    interactions: [
      {
        type: 'element-active',
      },
    ],
    legend: {
      position: 'bottom' as const,
    },
  };

  // 操作人员柱状图配置
  const columnConfig = {
    data: getOperatorColumnData(),
    xField: 'operator',
    yField: 'count',
    label: {
      position: 'middle' as const,
      style: {
        fill: '#FFFFFF',
        opacity: 0.6,
      },
    },
    xAxis: {
      label: {
        autoHide: true,
        autoRotate: false,
      },
    },
    meta: {
      operator: {
        alias: '操作人员',
      },
      count: {
        alias: '操作次数',
      },
    },
  };

  return (
    <PageContainer
      title="审计统计分析"
      content="MSDS系统操作审计统计与分析"
      extra={[
        <Space key="extra">
          <DatePicker.RangePicker
            defaultValue={[dayjs().subtract(30, 'day'), dayjs()]}
            onChange={() => {
              // 可以在这里添加日期范围筛选逻辑
              message.info('日期范围筛选功能开发中');
            }}
          />
        </Space>
      ]}
    >
      <Spin spinning={loading}>
        {/* 综合统计卡片 */}
        <Row gutter={[16, 16]} style={{ marginBottom: 24 }}>
          <Col xs={24} sm={12} md={6}>
            <Card>
              <Statistic
                title="总操作数"
                value={auditStats?.totalLogs || 0}
                prefix={<FileTextOutlined />}
                valueStyle={{ color: '#1890ff' }}
              />
            </Card>
          </Col>
          <Col xs={24} sm={12} md={6}>
            <Card>
              <Statistic
                title="成功操作"
                value={auditStats?.successLogs || 0}
                prefix={<CheckCircleOutlined />}
                valueStyle={{ color: '#52c41a' }}
              />
            </Card>
          </Col>
          <Col xs={24} sm={12} md={6}>
            <Card>
              <Statistic
                title="失败操作"
                value={auditStats?.failedLogs || 0}
                prefix={<CloseCircleOutlined />}
                valueStyle={{ color: '#ff4d4f' }}
              />
            </Card>
          </Col>
          <Col xs={24} sm={12} md={6}>
            <Card>
              <Statistic
                title="今日操作"
                value={auditStats?.todayLogs || 0}
                prefix={<CalendarOutlined />}
                valueStyle={{ color: '#722ed1' }}
              />
            </Card>
          </Col>
        </Row>

        {/* 成功率指标 */}
        <Row gutter={[16, 16]} style={{ marginBottom: 24 }}>
          <Col span={24}>
            <Alert
              message={
                <div>
                  <RiseOutlined style={{ marginRight: 8 }} />
                  操作成功率: {
                    auditStats && auditStats.totalLogs > 0 
                      ? `${((auditStats.successLogs / auditStats.totalLogs) * 100).toFixed(2)}%`
                      : '0%'
                  }
                  {auditStats && auditStats.totalLogs > 0 && (
                    <span style={{ marginLeft: 16, color: '#666' }}>
                      （总计 {auditStats.totalLogs} 次操作，成功 {auditStats.successLogs} 次，失败 {auditStats.failedLogs} 次）
                    </span>
                  )}
                </div>
              }
              type="info"
              showIcon
              icon={<InfoCircleOutlined />}
            />
          </Col>
        </Row>

        {/* 图表展示 */}
        <Row gutter={[16, 16]}>
          {/* 操作类型分布 */}
          <Col xs={24} lg={12}>
            <Card
              title={
                <Space>
                  <PieChartOutlined />
                  操作类型分布
                </Space>
              }
              extra={
                <span style={{ fontSize: '12px', color: '#666' }}>
                  各类型操作占比分析
                </span>
              }
            >
              {getOperationTypePieData().length > 0 ? (
                <Pie {...pieConfig} height={400} />
              ) : (
                <div style={{ textAlign: 'center', padding: '60px 0', color: '#999' }}>
                  暂无操作类型数据
                </div>
              )}
            </Card>
          </Col>

          {/* 操作人员活跃度 */}
          <Col xs={24} lg={12}>
            <Card
              title={
                <Space>
                  <TeamOutlined />
                  操作人员活跃度
                </Space>
              }
              extra={
                <Space>
                  <span style={{ fontSize: '12px', color: '#666' }}>统计周期:</span>
                  <Select
                    value={operatorDays}
                    onChange={handleOperatorDaysChange}
                    size="small"
                    style={{ width: 80 }}
                  >
                    <Option value={7}>7天</Option>
                    <Option value={15}>15天</Option>
                    <Option value={30}>30天</Option>
                    <Option value={60}>60天</Option>
                    <Option value={90}>90天</Option>
                  </Select>
                </Space>
              }
            >
              {getOperatorColumnData().length > 0 ? (
                <Column {...columnConfig} height={400} />
              ) : (
                <div style={{ textAlign: 'center', padding: '60px 0', color: '#999' }}>
                  暂无操作人员数据
                </div>
              )}
            </Card>
          </Col>
        </Row>

        <Divider />

        {/* 数据概要说明 */}
        <Row>
          <Col span={24}>
            <Card size="small">
              <div style={{ fontSize: '12px', color: '#666', lineHeight: '20px' }}>
                <strong>统计说明：</strong>
                <br />
                • 总操作数：系统中所有MSDS相关操作的总计数量
                <br />
                • 成功/失败操作：根据操作结果状态进行分类统计
                <br />
                • 今日操作：当天发生的所有操作数量
                <br />
                • 操作类型分布：展示各种操作类型（如创建、更新、删除、查看等）的占比情况
                <br />
                • 操作人员活跃度：统计指定时间段内各操作人员的活跃程度，显示前10名最活跃用户
              </div>
            </Card>
          </Col>
        </Row>
      </Spin>
    </PageContainer>
  );
};

export default AuditStatisticsPage;