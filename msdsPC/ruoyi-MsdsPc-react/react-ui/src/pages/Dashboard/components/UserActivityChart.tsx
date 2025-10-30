import React, { useState, useEffect } from 'react';
import { Card, Select, Spin, message } from 'antd';
import { Area, Heatmap } from '@ant-design/plots';
import { UserOutlined } from '@ant-design/icons';
import { getUserActivityData } from '@/services/dashboard';

const { Option } = Select;

interface UserActivityData {
  date: string;
  hour: number;
  count: number;
  type: string;
}

const UserActivityChart: React.FC = () => {
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState<UserActivityData[]>([]);
  const [chartType, setChartType] = useState<'trend' | 'heatmap'>('trend');

  useEffect(() => {
    fetchUserActivityData();
  }, []);

  const fetchUserActivityData = async () => {
    try {
      setLoading(true);
      const response = await getUserActivityData();
      if (response.code === 200) {
        setData(response.data);
      } else {
        message.error('获取用户活动数据失败');
      }
    } catch (error) {
      message.error('网络错误，请稍后重试');
      console.error('User activity data fetch error:', error);
    } finally {
      setLoading(false);
    }
  };

  // 处理趋势图数据
  const getTrendData = () => {
    const trendMap = new Map();
    data.forEach(item => {
      const key = `${item.date}-${item.type}`;
      if (trendMap.has(key)) {
        trendMap.set(key, trendMap.get(key) + item.count);
      } else {
        trendMap.set(key, item.count);
      }
    });

    const result: any[] = [];
    trendMap.forEach((count, key) => {
      const [date, type] = key.split('-');
      result.push({ date, type, count });
    });

    return result;
  };

  // 处理热力图数据
  const getHeatmapData = () => {
    const heatmapMap = new Map();
    data.forEach(item => {
      const key = `${item.date}-${item.hour}`;
      if (heatmapMap.has(key)) {
        heatmapMap.set(key, heatmapMap.get(key) + item.count);
      } else {
        heatmapMap.set(key, item.count);
      }
    });

    const result: any[] = [];
    heatmapMap.forEach((count, key) => {
      const [date, hour] = key.split('-');
      result.push({ 
        date, 
        hour: `${hour}:00`, 
        count,
        week: new Date(date).getDay(),
      });
    });

    return result;
  };

  // 面积图配置
  const areaConfig = {
    data: getTrendData(),
    xField: 'date',
    yField: 'count',
    seriesField: 'type',
    color: ['#1890ff', '#52c41a', '#faad14'],
    smooth: true,
    areaStyle: { fillOpacity: 0.6 },
    legend: {
      position: 'top' as const,
    },
    slider: {
      start: 0.7,
      end: 1.0,
    },
    tooltip: {
      formatter: (datum: any) => ({
        name: datum.type,
        value: datum.count.toLocaleString(),
      }),
    },
  };

  // 热力图配置
  const heatmapConfig = {
    data: getHeatmapData(),
    xField: 'hour',
    yField: 'date',
    colorField: 'count',
    color: ['#ffffff', '#1890ff'],
    shape: 'square',
    label: {
      style: {
        fill: '#fff',
        fontSize: 10,
      },
    },
    tooltip: {
      formatter: (datum: any) => ({
        name: '活跃度',
        value: datum.count.toLocaleString(),
      }),
    },
    xAxis: {
      label: {
        style: {
          fontSize: 10,
        },
      },
    },
    yAxis: {
      label: {
        style: {
          fontSize: 10,
        },
      },
    },
  };

  const extra = (
    <Select
      value={chartType}
      onChange={setChartType}
      style={{ width: 120 }}
      size="small"
    >
      <Option value="trend">活跃趋势</Option>
      <Option value="heatmap">活跃热力图</Option>
    </Select>
  );

  return (
    <Card
      title={
        <span>
          <UserOutlined style={{ marginRight: 8 }} />
          用户活动分析
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
          {chartType === 'trend' ? (
            <Area {...areaConfig} />
          ) : (
            <Heatmap {...heatmapConfig} />
          )}
        </div>
      )}
    </Card>
  );
};

export default UserActivityChart; 