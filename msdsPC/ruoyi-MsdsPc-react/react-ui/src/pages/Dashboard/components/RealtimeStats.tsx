import React, { useState, useEffect } from 'react';
import { Space, Badge, Typography, Tooltip } from 'antd';
import {
  ClockCircleOutlined,
  UserOutlined,
  EyeOutlined,
  WifiOutlined,
} from '@ant-design/icons';
import dayjs from 'dayjs';
import { getRealtimeStats } from '@/services/dashboard';

const { Text } = Typography;

interface RealtimeData {
  onlineUsers: number;
  currentViews: number;
  systemStatus: 'normal' | 'warning' | 'error';
  lastUpdateTime: string;
}

const RealtimeStats: React.FC = () => {
  const [currentTime, setCurrentTime] = useState(dayjs());
  const [realtimeData, setRealtimeData] = useState<RealtimeData>({
    onlineUsers: 0,
    currentViews: 0,
    systemStatus: 'normal',
    lastUpdateTime: dayjs().format('YYYY-MM-DD HH:mm:ss'),
  });

  useEffect(() => {
    // 更新当前时间
    const timeInterval = setInterval(() => {
      setCurrentTime(dayjs());
    }, 1000);

    // 获取实时数据
    fetchRealtimeData();
    const dataInterval = setInterval(() => {
      fetchRealtimeData();
    }, 10000); // 每10秒更新一次实时数据

    return () => {
      clearInterval(timeInterval);
      clearInterval(dataInterval);
    };
  }, []);

  const fetchRealtimeData = async () => {
    try {
      const response = await getRealtimeStats();
      if (response.code === 200) {
        setRealtimeData(response.data);
      }
    } catch (error) {
      console.error('Realtime stats fetch error:', error);
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'normal':
        return '#52c41a';
      case 'warning':
        return '#faad14';
      case 'error':
        return '#ff4d4f';
      default:
        return '#d9d9d9';
    }
  };

  const getStatusText = (status: string) => {
    switch (status) {
      case 'normal':
        return '正常';
      case 'warning':
        return '警告';
      case 'error':
        return '异常';
      default:
        return '未知';
    }
  };

  return (
    <Space size="large">
      {/* 当前时间 */}
      <Space size="small">
        <ClockCircleOutlined style={{ color: '#1890ff' }} />
        <Text style={{ fontSize: 14, fontWeight: 500 }}>
          {currentTime.format('YYYY-MM-DD HH:mm:ss')}
        </Text>
      </Space>

      {/* 在线用户 */}
      <Tooltip title="当前在线用户数">
        <Space size="small">
          <UserOutlined style={{ color: '#52c41a' }} />
          <Badge
            count={realtimeData.onlineUsers}
            style={{
              backgroundColor: '#52c41a',
              fontSize: 12,
              height: 18,
              lineHeight: '18px',
              minWidth: 18,
            }}
          />
        </Space>
      </Tooltip>

      {/* 当前访问 */}
      <Tooltip title="当前正在访问的用户数">
        <Space size="small">
          <EyeOutlined style={{ color: '#722ed1' }} />
          <Badge
            count={realtimeData.currentViews}
            style={{
              backgroundColor: '#722ed1',
              fontSize: 12,
              height: 18,
              lineHeight: '18px',
              minWidth: 18,
            }}
          />
        </Space>
      </Tooltip>

      {/* 系统状态 */}
      <Tooltip title={`系统状态: ${getStatusText(realtimeData.systemStatus)}`}>
        <Space size="small">
          <WifiOutlined style={{ color: getStatusColor(realtimeData.systemStatus) }} />
          <Badge
            status={
              realtimeData.systemStatus === 'normal'
                ? 'success'
                : realtimeData.systemStatus === 'warning'
                ? 'warning'
                : 'error'
            }
            text={
              <Text style={{ fontSize: 12, color: '#666' }}>
                {getStatusText(realtimeData.systemStatus)}
              </Text>
            }
          />
        </Space>
      </Tooltip>

      {/* 数据更新时间 */}
      <Tooltip title={`数据更新时间: ${realtimeData.lastUpdateTime}`}>
        <Text style={{ fontSize: 12, color: '#999' }}>
          数据已更新
        </Text>
      </Tooltip>
    </Space>
  );
};

export default RealtimeStats; 