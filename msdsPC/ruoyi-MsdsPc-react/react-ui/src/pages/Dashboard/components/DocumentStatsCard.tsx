import React from 'react';
import { Card, Row, Col, Statistic, Progress } from 'antd';
import { Pie } from '@ant-design/plots';
import {
  FileTextOutlined,
  CheckCircleOutlined,
  ClockCircleOutlined,
  ExclamationCircleOutlined,
} from '@ant-design/icons';

interface DocumentStatsProps {
  data: {
    total: number;
    valid: number;
    pending: number;
    expired: number;
  };
}

const DocumentStatsCard: React.FC<DocumentStatsProps> = ({ data }) => {
  // 计算百分比
  const validPercent = data.total > 0 ? Math.round((data.valid / data.total) * 100) : 0;
  const pendingPercent = data.total > 0 ? Math.round((data.pending / data.total) * 100) : 0;
  const expiredPercent = data.total > 0 ? Math.round((data.expired / data.total) * 100) : 0;

  // 饼图数据
  const pieData = [
    {
      type: '有效文档',
      value: data.valid,
      percent: validPercent,
    },
    {
      type: '待审核',
      value: data.pending,
      percent: pendingPercent,
    },
    {
      type: '已过期',
      value: data.expired,
      percent: expiredPercent,
    },
  ];

  // 饼图配置
  const pieConfig = {
    data: pieData,
    angleField: 'value',
    colorField: 'type',
    radius: 0.8,
    label: {
      type: 'inner',
      offset: '-30%',
      content: ({ percent }: any) => `${(percent * 100).toFixed(0)}%`,
      style: {
        fontSize: 14,
        textAlign: 'center',
      },
    },
    legend: {
      position: 'bottom' as const,
    },
    color: ['#52c41a', '#faad14', '#ff4d4f'],
    interactions: [
      {
        type: 'element-active',
      },
    ],
  };

  return (
    <Card title="文档统计概览" style={{ height: '100%' }}>
      <Row gutter={[16, 16]}>
        <Col span={12}>
          <div style={{ marginBottom: 16 }}>
            <Statistic
              title="文档总数"
              value={data.total}
              prefix={<FileTextOutlined style={{ color: '#1890ff' }} />}
              valueStyle={{ fontSize: 24, fontWeight: 'bold' }}
            />
          </div>
          
          <div style={{ marginBottom: 12 }}>
            <Row justify="space-between" align="middle">
              <Col>
                <span>
                  <CheckCircleOutlined style={{ color: '#52c41a', marginRight: 8 }} />
                  有效文档
                </span>
              </Col>
              <Col>
                <strong>{data.valid}</strong>
              </Col>
            </Row>
            <Progress
              percent={validPercent}
              strokeColor="#52c41a"
              showInfo={false}
              size="small"
            />
          </div>

          <div style={{ marginBottom: 12 }}>
            <Row justify="space-between" align="middle">
              <Col>
                <span>
                  <ClockCircleOutlined style={{ color: '#faad14', marginRight: 8 }} />
                  待审核
                </span>
              </Col>
              <Col>
                <strong>{data.pending}</strong>
              </Col>
            </Row>
            <Progress
              percent={pendingPercent}
              strokeColor="#faad14"
              showInfo={false}
              size="small"
            />
          </div>

          <div style={{ marginBottom: 12 }}>
            <Row justify="space-between" align="middle">
              <Col>
                <span>
                  <ExclamationCircleOutlined style={{ color: '#ff4d4f', marginRight: 8 }} />
                  已过期
                </span>
              </Col>
              <Col>
                <strong>{data.expired}</strong>
              </Col>
            </Row>
            <Progress
              percent={expiredPercent}
              strokeColor="#ff4d4f"
              showInfo={false}
              size="small"
            />
          </div>
        </Col>

        <Col span={12}>
          <div style={{ height: 200 }}>
            <Pie {...pieConfig} />
          </div>
        </Col>
      </Row>
    </Card>
  );
};

export default DocumentStatsCard; 