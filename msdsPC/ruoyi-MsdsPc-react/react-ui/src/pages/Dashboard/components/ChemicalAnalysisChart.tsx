import React from 'react';
import { Card, Row, Col, Statistic } from 'antd';
import { Column, Pie } from '@ant-design/plots';
import {
  ExperimentOutlined,
  AlertOutlined,
  SafetyCertificateOutlined,
  BankOutlined,
} from '@ant-design/icons';

interface ChemicalStatsProps {
  data: {
    totalChemicals: number;
    dangerousCount: number;
    casCount: number;
    supplierCount: number;
  };
}

const ChemicalAnalysisChart: React.FC<ChemicalStatsProps> = ({ data }) => {
  // 模拟危险级别分布数据
  const dangerLevelData = [
    { level: '高危', count: Math.floor(data.dangerousCount * 0.3), color: '#ff4d4f' },
    { level: '中危', count: Math.floor(data.dangerousCount * 0.5), color: '#faad14' },
    { level: '低危', count: Math.floor(data.dangerousCount * 0.2), color: '#52c41a' },
  ];

  // 饼图配置
  const pieConfig = {
    data: dangerLevelData,
    angleField: 'count',
    colorField: 'level',
    radius: 0.8,
    innerRadius: 0.4,
    color: dangerLevelData.map(item => item.color),
    label: {
      type: 'inner',
      offset: '-50%',
      content: '{percentage}',
      style: {
        textAlign: 'center',
        fontSize: 14,
        fontWeight: 'bold',
      },
    },
    legend: {
      position: 'bottom' as const,
    },
    interactions: [
      {
        type: 'element-active',
      },
    ],
    statistic: {
      title: {
        style: {
          whiteSpace: 'pre-wrap',
          overflow: 'hidden',
          textOverflow: 'ellipsis',
        },
        content: '危险品',
      },
      content: {
        style: {
          whiteSpace: 'pre-wrap',
          overflow: 'hidden',
          textOverflow: 'ellipsis',
          fontSize: '24px',
          fontWeight: 'bold',
        },
        content: data.dangerousCount.toString(),
      },
    },
  };

  // 模拟化学品分类数据
  const categoryData = [
    { category: '有机物', count: Math.floor(data.totalChemicals * 0.4) },
    { category: '无机物', count: Math.floor(data.totalChemicals * 0.3) },
    { category: '聚合物', count: Math.floor(data.totalChemicals * 0.2) },
    { category: '其他', count: Math.floor(data.totalChemicals * 0.1) },
  ];

  // 柱状图配置
  const columnConfig = {
    data: categoryData,
    xField: 'category',
    yField: 'count',
    color: '#1890ff',
    columnWidthRatio: 0.6,
    xAxis: {
      label: {
        style: {
          fontSize: 12,
        },
      },
    },
    yAxis: {
      label: {
        formatter: (val: number) => {
          if (val >= 1000) {
            return `${(val / 1000).toFixed(1)}k`;
          }
          return val.toString();
        },
      },
    },
    tooltip: {
      formatter: (datum: any) => ({
        name: '数量',
        value: datum.count.toLocaleString(),
      }),
    },
  };

  return (
    <Card title="化学品数据分析" style={{ height: '100%' }}>
      <Row gutter={[16, 16]}>
        {/* 统计数据 */}
        <Col span={24}>
          <Row gutter={16}>
            <Col span={6}>
              <Statistic
                title="化学品总数"
                value={data.totalChemicals}
                prefix={<ExperimentOutlined style={{ color: '#1890ff' }} />}
                valueStyle={{ fontSize: 16, color: '#1890ff' }}
              />
            </Col>
            <Col span={6}>
              <Statistic
                title="危险品数量"
                value={data.dangerousCount}
                prefix={<AlertOutlined style={{ color: '#ff4d4f' }} />}
                valueStyle={{ fontSize: 16, color: '#ff4d4f' }}
              />
            </Col>
            <Col span={6}>
              <Statistic
                title="CAS号数量"
                value={data.casCount}
                prefix={<SafetyCertificateOutlined style={{ color: '#52c41a' }} />}
                valueStyle={{ fontSize: 16, color: '#52c41a' }}
              />
            </Col>
            <Col span={6}>
              <Statistic
                title="供应商数量"
                value={data.supplierCount}
                prefix={<BankOutlined style={{ color: '#722ed1' }} />}
                valueStyle={{ fontSize: 16, color: '#722ed1' }}
              />
            </Col>
          </Row>
        </Col>

        {/* 危险级别分布 */}
        <Col span={12}>
          <div style={{ textAlign: 'center', marginBottom: 8 }}>
            <h4 style={{ margin: 0, fontSize: 14, color: '#666' }}>危险级别分布</h4>
          </div>
          <div style={{ height: 180 }}>
            <Pie {...pieConfig} />
          </div>
        </Col>

        {/* 化学品分类统计 */}
        <Col span={12}>
          <div style={{ textAlign: 'center', marginBottom: 8 }}>
            <h4 style={{ margin: 0, fontSize: 14, color: '#666' }}>分类统计</h4>
          </div>
          <div style={{ height: 180 }}>
            <Column {...columnConfig} />
          </div>
        </Col>
      </Row>
    </Card>
  );
};

export default ChemicalAnalysisChart;