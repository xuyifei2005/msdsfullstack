import React, { useState, useEffect } from 'react';
import { Card, List, Avatar, Tag, Spin, message, Select } from 'antd';
import {
  FireOutlined,
  EyeOutlined,
  DownloadOutlined,
  ClockCircleOutlined,
} from '@ant-design/icons';
import { getHotDocumentsData } from '@/services/dashboard';

const { Option } = Select;

interface HotDocument {
  id: string;
  name: string;
  category: string;
  views: number;
  downloads: number;
  updateTime: string;
  dangerLevel: 'high' | 'medium' | 'low';
  casNumber: string;
}

const HotDocumentsRank: React.FC = () => {
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState<HotDocument[]>([]);
  const [sortBy, setSortBy] = useState<'views' | 'downloads'>('views');

  useEffect(() => {
    fetchHotDocuments();
  }, [sortBy]);

  const fetchHotDocuments = async () => {
    try {
      setLoading(true);
      const response = await getHotDocumentsData({ sortBy });
      if (response.code === 200 && response.data) {
        setData(response.data as HotDocument[]);
      } else {
        message.error('获取热门文档数据失败');
      }
    } catch (error) {
      message.error('网络错误，请稍后重试');
      console.error('Hot documents data fetch error:', error);
    } finally {
      setLoading(false);
    }
  };

  const getDangerLevelColor = (level: string) => {
    switch (level) {
      case 'high':
        return '#ff4d4f';
      case 'medium':
        return '#faad14';
      case 'low':
        return '#52c41a';
      default:
        return '#d9d9d9';
    }
  };

  const getDangerLevelText = (level: string) => {
    switch (level) {
      case 'high':
        return '高危';
      case 'medium':
        return '中危';
      case 'low':
        return '低危';
      default:
        return '未知';
    }
  };

  const getRankIcon = (index: number) => {
    if (index === 0) return '🥇';
    if (index === 1) return '🥈';
    if (index === 2) return '🥉';
    return `${index + 1}`;
  };

  const extra = (
    <Select
      value={sortBy}
      onChange={setSortBy}
      style={{ width: 100 }}
      size="small"
    >
      <Option value="views">按访问</Option>
      <Option value="downloads">按下载</Option>
    </Select>
  );

  return (
    <Card
      title={
        <span>
          <FireOutlined style={{ marginRight: 8 }} />
          热门文档排行
        </span>
      }
      extra={extra}
      style={{ height: '100%' }}
      styles={{ body: { padding: '12px 16px' } }}
    >
      {loading ? (
        <div style={{ textAlign: 'center', padding: '60px 0' }}>
          <Spin size="large" />
        </div>
      ) : (
        <List
          dataSource={data}
          renderItem={(item, index) => (
            <List.Item
              style={{
                padding: '12px 0',
                borderBottom: index === data.length - 1 ? 'none' : '1px solid #f0f0f0',
              }}
            >
              <List.Item.Meta
                avatar={
                  <Avatar
                    size="small"
                    style={{
                      backgroundColor: index < 3 ? '#faad14' : '#d9d9d9',
                      color: index < 3 ? '#fff' : '#666',
                      fontSize: 12,
                      fontWeight: 'bold',
                    }}
                  >
                    {getRankIcon(index)}
                  </Avatar>
                }
                title={
                  <div>
                    <div
                      style={{
                        fontSize: 13,
                        fontWeight: 500,
                        marginBottom: 4,
                        overflow: 'hidden',
                        textOverflow: 'ellipsis',
                        whiteSpace: 'nowrap',
                      }}
                      title={item.name}
                    >
                      {item.name}
                    </div>
                    <div style={{ fontSize: 11, color: '#999' }}>
                      CAS: {item.casNumber}
                    </div>
                  </div>
                }
                description={
                  <div style={{ fontSize: 11 }}>
                    <div style={{ marginBottom: 4 }}>
                      <Tag
                        color={getDangerLevelColor(item.dangerLevel)}
                        style={{ fontSize: 10, padding: '1px 4px', lineHeight: '14px' }}
                      >
                        {getDangerLevelText(item.dangerLevel)}
                      </Tag>
                      <Tag
                        color="blue"
                        style={{ fontSize: 10, padding: '1px 4px', lineHeight: '14px' }}
                      >
                        {item.category}
                      </Tag>
                    </div>
                    <div style={{ display: 'flex', gap: 12, color: '#666' }}>
                      <span>
                        <EyeOutlined style={{ marginRight: 2 }} />
                        {item.views > 1000 ? `${(item.views / 1000).toFixed(1)}k` : item.views}
                      </span>
                      <span>
                        <DownloadOutlined style={{ marginRight: 2 }} />
                        {item.downloads > 1000 ? `${(item.downloads / 1000).toFixed(1)}k` : item.downloads}
                      </span>
                    </div>
                    <div style={{ marginTop: 2, color: '#999' }}>
                      <ClockCircleOutlined style={{ marginRight: 2 }} />
                      {item.updateTime}
                    </div>
                  </div>
                }
              />
            </List.Item>
          )}
        />
      )}
    </Card>
  );
};

export default HotDocumentsRank;