import React, { useState, useEffect } from 'react';
import { Card, Select, DatePicker, Spin, message } from 'antd';
import { Line } from '@ant-design/plots';
import { EyeOutlined } from '@ant-design/icons';
import dayjs from 'dayjs';
import { getAccessTrendData } from '@/services/dashboard';

const { RangePicker } = DatePicker;
const { Option } = Select;

interface AccessTrendData {
  date: string;
  visits: number;
  uniqueVisitors: number;
  pageViews: number;
}

const AccessTrendChart: React.FC = () => {
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState<AccessTrendData[]>([]);
  const [timeRange, setTimeRange] = useState<'7d' | '30d' | '90d' | 'custom'>('30d');
  const [customRange, setCustomRange] = useState<[dayjs.Dayjs, dayjs.Dayjs] | null>(null);
  const [metricType, setMetricType] = useState<'visits' | 'uniqueVisitors' | 'pageViews'>('visits');

  useEffect(() => {
    fetchAccessTrendData();
  }, [timeRange, customRange, metricType]);

  const fetchAccessTrendData = async () => {
    try {
      setLoading(true);
      let startDate, endDate;
      
      if (timeRange === 'custom' && customRange) {
        startDate = customRange[0].format('YYYY-MM-DD');
        endDate = customRange[1].format('YYYY-MM-DD');
      } else {
        const days = timeRange === '7d' ? 7 : timeRange === '30d' ? 30 : 90;
        endDate = dayjs().format('YYYY-MM-DD');
        startDate = dayjs().subtract(days, 'day').format('YYYY-MM-DD');
      }

      const response = await getAccessTrendData({
        startDate,
        endDate,
        metricType,
      });

      if (response.code === 200) {
        setData(response.data);
      } else {
        message.error('获取访问趋势数据失败');
      }
    } catch (error) {
      message.error('网络错误，请稍后重试');
      console.error('Access trend data fetch error:', error);
    } finally {
      setLoading(false);
    }
  };

  const getMetricLabel = () => {
    switch (metricType) {
      case 'visits':
        return '访问次数';
      case 'uniqueVisitors':
        return '独立访客';
      case 'pageViews':
        return '页面浏览量';
      default:
        return '访问次数';
    }
  };

  const getMetricValue = (item: AccessTrendData) => {
    switch (metricType) {
      case 'visits':
        return item.visits;
      case 'uniqueVisitors':
        return item.uniqueVisitors;
      case 'pageViews':
        return item.pageViews;
      default:
        return item.visits;
    }
  };

  // 处理图表数据
  const chartData = data.map(item => ({
    date: item.date,
    value: getMetricValue(item),
    type: getMetricLabel(),
  }));

  const config = {
    data: chartData,
    xField: 'date',
    yField: 'value',
    smooth: true,
    color: '#1890ff',
    point: {
      size: 4,
      shape: 'circle',
      style: {
        fill: '#1890ff',
        stroke: '#fff',
        lineWidth: 2,
      },
    },
    area: {
      style: {
        fill: 'l(270) 0:#1890ff1a 1:#1890ff05',
      },
    },
    xAxis: {
      type: 'time',
      tickCount: 7,
      label: {
        formatter: (val: string) => dayjs(val).format('MM-DD'),
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
        name: getMetricLabel(),
        value: datum.value.toLocaleString(),
      }),
    },
    interactions: [
      {
        type: 'marker-active',
      },
    ],
  };

  const extra = (
    <div style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
      <Select
        value={metricType}
        onChange={setMetricType}
        style={{ width: 120 }}
        size="small"
      >
        <Option value="visits">访问次数</Option>
        <Option value="uniqueVisitors">独立访客</Option>
        <Option value="pageViews">页面浏览量</Option>
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
        <Option value="custom">自定义</Option>
      </Select>
      
      {timeRange === 'custom' && (
        <RangePicker
          size="small"
          value={customRange}
          onChange={setCustomRange}
          format="YYYY-MM-DD"
          allowClear
        />
      )}
    </div>
  );

  return (
    <Card
      title={
        <span>
          <EyeOutlined style={{ marginRight: 8 }} />
          访问趋势分析
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
        <div style={{ height: 300 }}>
          <Line {...config} />
        </div>
      )}
    </Card>
  );
};

export default AccessTrendChart; 