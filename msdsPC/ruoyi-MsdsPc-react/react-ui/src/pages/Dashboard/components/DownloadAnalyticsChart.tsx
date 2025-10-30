import React, { useState, useEffect } from 'react';
import { Card, Row, Col, Statistic, Select, Spin, message } from 'antd';
import { Line, Column } from '@ant-design/plots';
import {
  DownloadOutlined,
  RiseOutlined,
} from '@ant-design/icons';
import { getDownloadAnalyticsData } from '@/services/dashboard';

const { Option } = Select;

interface DownloadData {
  date: string;
  downloads: number;
  fileType: string;
  documentId: string;
  documentName: string;
}

const DownloadAnalyticsChart: React.FC = () => {
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState<DownloadData[]>([]);
  const [chartType, setChartType] = useState<'trend' | 'type'>('trend');
  const [timeRange, setTimeRange] = useState<'7d' | '30d' | '90d'>('30d');

  useEffect(() => {
    fetchDownloadData();
  }, [timeRange]);

  const fetchDownloadData = async () => {
    try {
      setLoading(true);
      const response = await getDownloadAnalyticsData({ timeRange });
      if (response.code === 200) {
        setData((response.data as DownloadData[]) || []);
      } else {
        message.error('获取下载数据失败');
      }
    } catch (error) {
      message.error('网络错误，请稍后重试');
      console.error('Download data fetch error:', error);
    } finally {
      setLoading(false);
    }
  };

  // 计算统计数据
  const getTotalDownloads = () => {
    return data.reduce((sum, item) => sum + item.downloads, 0);
  };

  const getAvgDailyDownloads = () => {
    const dateMap = new Map();
    data.forEach(item => {
      if (dateMap.has(item.date)) {
        dateMap.set(item.date, dateMap.get(item.date) + item.downloads);
      } else {
        dateMap.set(item.date, item.downloads);
      }
    });
    const totalDays = dateMap.size;
    return totalDays > 0 ? Math.round(getTotalDownloads() / totalDays) : 0;
  };

  const getMostPopularType = () => {
    const typeMap = new Map();
    data.forEach(item => {
      if (typeMap.has(item.fileType)) {
        typeMap.set(item.fileType, typeMap.get(item.fileType) + item.downloads);
      } else {
        typeMap.set(item.fileType, item.downloads);
      }
    });
    let maxType = '';
    let maxCount = 0;
    typeMap.forEach((count, type) => {
      if (count > maxCount) {
        maxCount = count;
        maxType = type;
      }
    });
    return maxType || 'PDF';
  };

  // 处理趋势图数据
  const getTrendData = () => {
    const trendMap = new Map();
    data.forEach(item => {
      if (trendMap.has(item.date)) {
        trendMap.set(item.date, trendMap.get(item.date) + item.downloads);
      } else {
        trendMap.set(item.date, item.downloads);
      }
    });

    const result: any[] = [];
    trendMap.forEach((downloads, date) => {
      result.push({ date, downloads });
    });

    return result.sort((a, b) => a.date.localeCompare(b.date));
  };

  // 处理文件类型统计数据
  const getTypeData = () => {
    const typeMap = new Map();
    data.forEach(item => {
      if (typeMap.has(item.fileType)) {
        typeMap.set(item.fileType, typeMap.get(item.fileType) + item.downloads);
      } else {
        typeMap.set(item.fileType, item.downloads);
      }
    });

    const result: any[] = [];
    typeMap.forEach((downloads, fileType) => {
      result.push({ fileType, downloads });
    });

    return result.sort((a, b) => b.downloads - a.downloads);
  };

  // 趋势图配置
  const lineConfig = {
    data: getTrendData(),
    xField: 'date',
    yField: 'downloads',
    smooth: true,
    color: '#52c41a',
    point: {
      size: 4,
      shape: 'circle',
      style: {
        fill: '#52c41a',
        stroke: '#fff',
        lineWidth: 2,
      },
    },
    tooltip: {
      formatter: (datum: any) => ({
        name: '下载次数',
        value: datum.downloads.toLocaleString(),
      }),
    },
  };

  // 柱状图配置
  const columnConfig = {
    data: getTypeData(),
    xField: 'fileType',
    yField: 'downloads',
    color: '#722ed1',
    columnWidthRatio: 0.6,
    tooltip: {
      formatter: (datum: any) => ({
        name: '下载次数',
        value: datum.downloads.toLocaleString(),
      }),
    },
  };

  const extra = (
    <div style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
      <Select
        value={chartType}
        onChange={setChartType}
        style={{ width: 120 }}
        size="small"
      >
        <Option value="trend">下载趋势</Option>
        <Option value="type">文件类型</Option>
      </Select>
      
      <Select
        value={timeRange}
        onChange={setTimeRange}
        style={{ width: 100 }}
        size="small"
      >
        <Option value="7d">近7天</Option>
        <Option value="30d">近30天</Option>
        <Option value="90d">近90天</Option>
      </Select>
    </div>
  );

  return (
    <Card
      title={
        <span>
          <DownloadOutlined style={{ marginRight: 8 }} />
          下载分析统计
        </span>
      }
      extra={extra}
      style={{ height: '100%' }}
    >
      {loading ? (
        <div style={{ textAlign: 'center', padding: '60px 0' }}>
          <Spin size="large" />
        </div>
      ) : (
        <>
          {/* 统计概览 */}
          <Row gutter={16} style={{ marginBottom: 24 }}>
            <Col span={6}>
              <Statistic
                title="总下载量"
                value={getTotalDownloads()}
                prefix={<DownloadOutlined style={{ color: '#52c41a' }} />}
                valueStyle={{ color: '#52c41a' }}
              />
            </Col>
            <Col span={6}>
              <Statistic
                title="日均下载"
                value={getAvgDailyDownloads()}
                prefix={<RiseOutlined style={{ color: '#1890ff' }} />}
                valueStyle={{ color: '#1890ff' }}
              />
            </Col>
            <Col span={6}>
              <Statistic
                title="热门格式"
                value={getMostPopularType()}
                valueStyle={{ color: '#722ed1' }}
              />
            </Col>
            <Col span={6}>
              <Statistic
                title="文档数量"
                value={new Set(data.map(item => item.documentId)).size}
                valueStyle={{ color: '#fa8c16' }}
              />
            </Col>
          </Row>

          {/* 图表区域 */}
          <div style={{ height: 300 }}>
            {chartType === 'trend' ? (
              <Line {...lineConfig} />
            ) : (
              <Column {...columnConfig} />
            )}
          </div>
        </>
      )}
    </Card>
  );
};

export default DownloadAnalyticsChart;