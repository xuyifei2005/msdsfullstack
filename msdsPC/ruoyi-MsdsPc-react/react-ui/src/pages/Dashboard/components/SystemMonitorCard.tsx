import React from 'react';
import { Card, Row, Col, Progress, Statistic } from 'antd';
import { Gauge } from '@ant-design/plots';
import {
  DatabaseOutlined,
  DesktopOutlined,
  HddOutlined,
  CloudServerOutlined,
} from '@ant-design/icons';

interface SystemStatsProps {
  data: {
    onlineUsers: number;
    cpuUsage: number;
    memoryUsage: number;
    diskUsage: number;
  };
}

const SystemMonitorCard: React.FC<SystemStatsProps> = ({ data }) => {
  // 根据使用率获取颜色
  const getStatusColor = (usage: number) => {
    if (usage >= 90) return '#ff4d4f';
    if (usage >= 70) return '#faad14';
    return '#52c41a';
  };

  // CPU使用率仪表盘配置
  const cpuGaugeConfig = {
    percent: data.cpuUsage / 100,
    innerRadius: 0.75,
    range: {
      color: ['#30BF78', '#FAAD14', '#F4664A'],
    },
    statistic: {
      content: {
        style: {
          fontSize: '24px',
          lineHeight: '24px',
          fontWeight: 'bold',
          color: getStatusColor(data.cpuUsage),
        },
        formatter: () => `${data.cpuUsage}%`,
      },
    },
  };

  return (
    <Card title="系统监控" style={{ height: '100%' }}>
      <Row gutter={[16, 16]}>
        {/* 在线用户统计 */}
        <Col span={12}>
          <div style={{ textAlign: 'center', marginBottom: 16 }}>
            <Statistic
              title="在线用户"
              value={data.onlineUsers}
              prefix={<CloudServerOutlined style={{ color: '#1890ff' }} />}
              valueStyle={{ fontSize: 20, fontWeight: 'bold', color: '#1890ff' }}
            />
          </div>
        </Col>

        {/* CPU使用率仪表盘 */}
        <Col span={12}>
          <div style={{ textAlign: 'center' }}>
            <div style={{ fontSize: 14, marginBottom: 8, color: '#666' }}>CPU使用率</div>
            <div style={{ height: 80 }}>
              <Gauge {...cpuGaugeConfig} />
            </div>
          </div>
        </Col>

        {/* 内存使用率 */}
        <Col span={24}>
          <div style={{ marginBottom: 16 }}>
            <Row justify="space-between" align="middle" style={{ marginBottom: 8 }}>
              <Col>
                <span>
                  <DesktopOutlined style={{ color: '#722ed1', marginRight: 8 }} />
                  内存使用率
                </span>
              </Col>
              <Col>
                <strong style={{ color: getStatusColor(data.memoryUsage) }}>
                  {data.memoryUsage}%
                </strong>
              </Col>
            </Row>
            <Progress
              percent={data.memoryUsage}
              strokeColor={getStatusColor(data.memoryUsage)}
              showInfo={false}
              size={8}
            />
          </div>
        </Col>

        {/* 磁盘使用率 */}
        <Col span={24}>
          <div>
            <Row justify="space-between" align="middle" style={{ marginBottom: 8 }}>
              <Col>
                <span>
                  <HddOutlined style={{ color: '#13c2c2', marginRight: 8 }} />
                  磁盘使用率
                </span>
              </Col>
              <Col>
                <strong style={{ color: getStatusColor(data.diskUsage) }}>
                  {data.diskUsage}%
                </strong>
              </Col>
            </Row>
            <Progress
              percent={data.diskUsage}
              strokeColor={getStatusColor(data.diskUsage)}
              showInfo={false}
              size={8}
            />
          </div>
        </Col>

        {/* 系统状态指示器 */}
        <Col span={24}>
          <div style={{ marginTop: 16, padding: '12px 16px', backgroundColor: '#f5f5f5', borderRadius: 6 }}>
            <Row gutter={16}>
              <Col span={8}>
                <div style={{ textAlign: 'center' }}>
                  <div style={{ 
                    width: 8, 
                    height: 8, 
                    borderRadius: '50%', 
                    backgroundColor: '#52c41a',
                    margin: '0 auto 4px',
                  }} />
                  <div style={{ fontSize: 12, color: '#666' }}>数据库</div>
                </div>
              </Col>
              <Col span={8}>
                <div style={{ textAlign: 'center' }}>
                  <div style={{ 
                    width: 8, 
                    height: 8, 
                    borderRadius: '50%', 
                    backgroundColor: '#52c41a',
                    margin: '0 auto 4px',
                  }} />
                  <div style={{ fontSize: 12, color: '#666' }}>缓存</div>
                </div>
              </Col>
              <Col span={8}>
                <div style={{ textAlign: 'center' }}>
                  <div style={{ 
                    width: 8, 
                    height: 8, 
                    borderRadius: '50%', 
                    backgroundColor: data.cpuUsage > 80 ? '#faad14' : '#52c41a',
                    margin: '0 auto 4px',
                  }} />
                  <div style={{ fontSize: 12, color: '#666' }}>服务</div>
                </div>
              </Col>
            </Row>
          </div>
        </Col>
      </Row>
    </Card>
  );
};

export default SystemMonitorCard;