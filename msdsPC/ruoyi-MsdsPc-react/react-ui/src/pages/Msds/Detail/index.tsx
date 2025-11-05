import React, { useState, useEffect } from 'react';
import { useParams, history } from '@umijs/max';
import {
  Card,
  Button,
  Row,
  Col,
  Descriptions,
  Table,
  Tabs,
  Tag,
  Space,
  Typography,
  Statistic,
  FloatButton,
  message,
  Modal,
  Timeline,
  Breadcrumb,
} from 'antd';
import {
  DownloadOutlined,
  PrinterOutlined,
  StarOutlined,
  ShareAltOutlined,
  FireOutlined,
  ExclamationCircleOutlined,
  SafetyOutlined,
  ExperimentOutlined,
  InfoCircleOutlined,
  HistoryOutlined,
  EyeOutlined,
  HomeOutlined,
  SearchOutlined,
} from '@ant-design/icons';
import { getMsdsDetail } from '@/services/msds/api';
import './index.less';

const { Title, Text, Paragraph } = Typography;
const { TabPane } = Tabs;

interface MsdsDetailData {
  msdsId: number;
  chemicalNameCn: string;
  chemicalNameEn: string;
  casNumber: string;
  molecularFormula: string;
  molecularWeight: string;
  einecs: string;
  unNumber: string;
  supplier: string;
  productNumber: string;
  version: string;
  updateTime: string;
  language: string;
  pageCount: number;
  fileSize: string;
  viewCount: number;
  downloadCount: number;
  favoriteCount: number;
  // 更多字段...
}

const MsdsDetail: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const [loading, setLoading] = useState(false);
  const [detail, setDetail] = useState<MsdsDetailData | null>(null);
  const [activeTab, setActiveTab] = useState('basic');
  const [isFavorite, setIsFavorite] = useState(false);

  useEffect(() => {
    if (id) {
      loadDetail();
    }
  }, [id]);

  const loadDetail = async () => {
    setLoading(true);
    try {
      const response = await getMsdsDetail(Number(id));
      if (response.code === 200) {
        setDetail(response.data);
      }
    } catch (error) {
      message.error('加载详情失败');
    } finally {
      setLoading(false);
    }
  };

  const handleDownload = () => {
    message.success('开始下载MSDS文档');
    // 实现下载逻辑
  };

  const handlePrint = () => {
    window.print();
  };

  const handleFavorite = () => {
    setIsFavorite(!isFavorite);
    message.success(isFavorite ? '已取消收藏' : '收藏成功');
  };

  const handleShare = () => {
    if (navigator.share) {
      navigator.share({
        title: detail?.chemicalNameCn || 'MSDS详情',
        text: `查看${detail?.chemicalNameCn}的安全数据表`,
        url: window.location.href,
      });
    } else {
      navigator.clipboard.writeText(window.location.href);
      message.success('链接已复制到剪贴板');
    }
  };

  // 模拟数据（实际应从API获取）
  const mockDetail: MsdsDetailData = {
    msdsId: Number(id),
    chemicalNameCn: '乙醇',
    chemicalNameEn: 'Ethanol / Ethyl Alcohol',
    casNumber: '64-17-5',
    molecularFormula: 'C₂H₆O',
    molecularWeight: '46.07',
    einecs: '200-578-6',
    unNumber: '1170',
    supplier: 'Sigma-Aldrich',
    productNumber: 'E7023',
    version: '3.2',
    updateTime: '2024-01-10',
    language: '中文',
    pageCount: 16,
    fileSize: '2.3 MB',
    viewCount: 1234,
    downloadCount: 456,
    favoriteCount: 89,
  };

  const displayDetail = detail || mockDetail;

  // 成分组成数据
  const compositionData = [
    {
      key: '1',
      name: '乙醇',
      content: '≥99.5%',
      casNumber: '64-17-5',
      hazardClass: '易燃液体2',
      hazardLevel: 'danger',
    },
    {
      key: '2',
      name: '水',
      content: '≤0.5%',
      casNumber: '7732-18-5',
      hazardClass: '无危险',
      hazardLevel: 'safe',
    },
  ];

  const compositionColumns = [
    { title: '成分名称', dataIndex: 'name', key: 'name' },
    { title: '含量', dataIndex: 'content', key: 'content' },
    { title: 'CAS号', dataIndex: 'casNumber', key: 'casNumber' },
    {
      title: '危险性分类',
      dataIndex: 'hazardClass',
      key: 'hazardClass',
      render: (text: string, record: any) => (
        <Tag color={record.hazardLevel === 'danger' ? 'red' : 'default'}>
          {text}
        </Tag>
      ),
    },
  ];

  // 相关文档
  const relatedDocs = [
    { name: '甲醇 MSDS', cas: '67-56-1', id: 2 },
    { name: '异丙醇 MSDS', cas: '67-63-0', id: 3 },
    { name: '丙酮 MSDS', cas: '67-64-1', id: 4 },
  ];

  return (
    <div className="msds-detail-page">
      {/* 头部区域 */}
      <div className="detail-header">
        <div className="header-content">
          {/* 面包屑 */}
          <Breadcrumb className="breadcrumb print-hidden">
            <Breadcrumb.Item>
              <HomeOutlined />
              <span onClick={() => history.push('/')}>首页</span>
            </Breadcrumb.Item>
            <Breadcrumb.Item>
              <SearchOutlined />
              <span onClick={() => history.push('/msds/search')}>智能搜索</span>
            </Breadcrumb.Item>
            <Breadcrumb.Item>{displayDetail.chemicalNameCn}详情</Breadcrumb.Item>
          </Breadcrumb>

          <Row gutter={[32, 32]} className="header-main">
            {/* 基本信息 */}
            <Col xs={24} lg={16}>
              <div className="basic-info-section">
                {/* 分子结构图 */}
                <div className="molecular-structure">
                  <div className="molecular-content">
                    <div className="formula">{displayDetail.molecularFormula}</div>
                    <div className="formula-label">分子式</div>
                  </div>
                </div>

                {/* 化学品信息 */}
                <div className="chemical-info">
                  <Title level={1} className="chemical-name">
                    {displayDetail.chemicalNameCn}
                  </Title>
                  <Title level={3} className="chemical-name-en">
                    {displayDetail.chemicalNameEn}
                  </Title>

                  <Row gutter={[16, 16]} className="key-info">
                    <Col span={12}>
                      <Text className="label">CAS号：</Text>
                      <Text className="value">{displayDetail.casNumber}</Text>
                    </Col>
                    <Col span={12}>
                      <Text className="label">分子量：</Text>
                      <Text className="value">{displayDetail.molecularWeight} g/mol</Text>
                    </Col>
                    <Col span={12}>
                      <Text className="label">EINECS号：</Text>
                      <Text className="value">{displayDetail.einecs}</Text>
                    </Col>
                    <Col span={12}>
                      <Text className="label">UN号：</Text>
                      <Text className="value">{displayDetail.unNumber}</Text>
                    </Col>
                  </Row>

                  {/* 危险性标识 */}
                  <div className="hazard-badge">
                    <div className="hazard-symbol">
                      <FireOutlined className="hazard-icon" />
                    </div>
                    <div className="hazard-text">
                      <div className="hazard-title">易燃液体</div>
                      <div className="hazard-code">类别2 - H225</div>
                    </div>
                  </div>
                </div>
              </div>
            </Col>

            {/* 快速操作 */}
            <Col xs={24} lg={8}>
              <Card className="quick-actions-card" bordered={false}>
                <Title level={4} style={{ color: 'white', marginBottom: 24 }}>
                  快速操作
                </Title>
                <Space direction="vertical" style={{ width: '100%' }} size="middle">
                  <Button
                    type="primary"
                    size="large"
                    block
                    icon={<DownloadOutlined />}
                    onClick={handleDownload}
                    className="action-btn primary"
                  >
                    下载MSDS
                  </Button>
                  <Button
                    size="large"
                    block
                    icon={<PrinterOutlined />}
                    onClick={handlePrint}
                    className="action-btn secondary"
                  >
                    打印文档
                  </Button>
                  <Button
                    size="large"
                    block
                    icon={<StarOutlined />}
                    onClick={handleFavorite}
                    className="action-btn outline"
                  >
                    {isFavorite ? '已收藏' : '收藏'}
                  </Button>
                  <Button
                    size="large"
                    block
                    icon={<ShareAltOutlined />}
                    onClick={handleShare}
                    className="action-btn outline"
                  >
                    分享
                  </Button>
                </Space>

                {/* 二维码 */}
                <div className="qr-section">
                  <Text style={{ color: 'white', fontSize: 12 }}>扫码查看移动版</Text>
                  <div className="qr-code" />
                </div>
              </Card>
            </Col>
          </Row>
        </div>
      </div>

      {/* 导航标签 */}
      <div className="sticky-nav print-hidden">
        <Tabs
          activeKey={activeTab}
          onChange={setActiveTab}
          items={[
            { key: 'basic', label: '基本信息' },
            { key: 'hazard', label: '危险性信息' },
            { key: 'physical', label: '理化性质' },
            { key: 'safety', label: '安全措施' },
            { key: 'handling', label: '操作处置' },
            { key: 'transport', label: '运输信息' },
            { key: 'regulatory', label: '法规信息' },
            { key: 'versions', label: '版本历史' },
          ]}
        />
      </div>

      {/* 主内容区域 */}
      <div className="detail-content">
        <Row gutter={[24, 24]}>
          {/* 主要内容 */}
          <Col xs={24} lg={18}>
            {/* 基本信息 */}
            {activeTab === 'basic' && (
              <div className="content-section">
                <Card title={<><InfoCircleOutlined /> 基本信息</>} className="info-card">
                  <Row gutter={[24, 24]}>
                    <Col span={12}>
                      <Title level={5}>化学标识</Title>
                      <Descriptions column={1} size="small">
                        <Descriptions.Item label="中文名">乙醇</Descriptions.Item>
                        <Descriptions.Item label="英文名">Ethanol</Descriptions.Item>
                        <Descriptions.Item label="别名">乙基醇、酒精</Descriptions.Item>
                        <Descriptions.Item label="分子式">C₂H₆O</Descriptions.Item>
                        <Descriptions.Item label="分子量">46.07</Descriptions.Item>
                      </Descriptions>
                    </Col>
                    <Col span={12}>
                      <Title level={5}>登记信息</Title>
                      <Descriptions column={1} size="small">
                        <Descriptions.Item label="CAS号">64-17-5</Descriptions.Item>
                        <Descriptions.Item label="EINECS号">200-578-6</Descriptions.Item>
                        <Descriptions.Item label="RTECS号">KQ6300000</Descriptions.Item>
                        <Descriptions.Item label="UN号">1170</Descriptions.Item>
                        <Descriptions.Item label="危险货物编号">32061</Descriptions.Item>
                      </Descriptions>
                    </Col>
                  </Row>
                </Card>

                <Card title={<><ExperimentOutlined /> 成分/组成信息</>} className="info-card">
                  <Table
                    dataSource={compositionData}
                    columns={compositionColumns}
                    pagination={false}
                    size="small"
                  />
                </Card>
              </div>
            )}

            {/* 危险性信息 */}
            {activeTab === 'hazard' && (
              <div className="content-section">
                <Card title={<><ExclamationCircleOutlined /> 危险性概述</>} className="info-card">
                  <div className="hazard-classification">
                    <Title level={5}>GHS危险性分类</Title>
                    <div className="hazard-item danger">
                      <FireOutlined className="hazard-icon-large" />
                      <div>
                        <div className="hazard-title">易燃液体</div>
                        <div className="hazard-category">类别2</div>
                      </div>
                    </div>
                  </div>

                  <div className="label-elements">
                    <Title level={5}>标签要素</Title>
                    <Row gutter={16}>
                      <Col span={8}>
                        <div className="element-box">
                          <Text type="secondary">信号词</Text>
                          <Tag color="orange" style={{ marginTop: 8, fontSize: 14 }}>
                            危险
                          </Tag>
                        </div>
                      </Col>
                      <Col span={8}>
                        <div className="element-box">
                          <Text type="secondary">危险性说明</Text>
                          <Tag color="red" style={{ marginTop: 8 }}>
                            H225: 高度易燃液体和蒸气
                          </Tag>
                        </div>
                      </Col>
                      <Col span={8}>
                        <div className="element-box">
                          <Text type="secondary">防范说明</Text>
                          <Tag color="blue" style={{ marginTop: 8 }}>
                            P210: 远离热源/火花/明火
                          </Tag>
                        </div>
                      </Col>
                    </Row>
                  </div>

                  <div className="health-hazard">
                    <Title level={5}>健康危害</Title>
                    <div className="warning-box">
                      <Paragraph>
                        本品为中枢神经系统抑制剂。首先引起兴奋，随后抑制。急性中毒：急性中毒多发生于口服。
                        一般可分为兴奋、催眠、麻醉、窒息四阶段。患者进入第三或第四阶段，出现意识丧失、瞳孔扩大、
                        呼吸不规律、休克、心力衰竭及呼吸停止。
                      </Paragraph>
                    </div>
                  </div>
                </Card>
              </div>
            )}

            {/* 理化性质 */}
            {activeTab === 'physical' && (
              <div className="content-section">
                <Card title={<><ExperimentOutlined /> 理化特性</>} className="info-card">
                  <Row gutter={[24, 24]}>
                    <Col span={12}>
                      <Title level={5}>物理性质</Title>
                      <Descriptions column={1} size="small">
                        <Descriptions.Item label="外观">无色透明液体</Descriptions.Item>
                        <Descriptions.Item label="气味">特殊香味</Descriptions.Item>
                        <Descriptions.Item label="熔点">-114.1°C</Descriptions.Item>
                        <Descriptions.Item label="沸点">78.3°C</Descriptions.Item>
                        <Descriptions.Item label="相对密度">0.789 (20°C)</Descriptions.Item>
                        <Descriptions.Item label="相对蒸气密度">1.59 (空气=1)</Descriptions.Item>
                      </Descriptions>
                    </Col>
                    <Col span={12}>
                      <Title level={5}>化学性质</Title>
                      <Descriptions column={1} size="small">
                        <Descriptions.Item label="饱和蒸气压">5.33 kPa (19°C)</Descriptions.Item>
                        <Descriptions.Item label="燃烧热">1365.5 kJ/mol</Descriptions.Item>
                        <Descriptions.Item label="临界温度">243.1°C</Descriptions.Item>
                        <Descriptions.Item label="临界压力">6.38 MPa</Descriptions.Item>
                        <Descriptions.Item label="辛醇/水分配系数">-0.31</Descriptions.Item>
                        <Descriptions.Item label="闪点">13°C (闭杯)</Descriptions.Item>
                      </Descriptions>
                    </Col>
                  </Row>

                  <div className="explosion-limits">
                    <Title level={5}>爆炸特性</Title>
                    <Row gutter={16} className="explosion-stats">
                      <Col span={8}>
                        <Statistic title="爆炸下限" value="3.3%" valueStyle={{ color: '#ff4d4f' }} />
                      </Col>
                      <Col span={8}>
                        <Statistic title="爆炸上限" value="19%" valueStyle={{ color: '#ff4d4f' }} />
                      </Col>
                      <Col span={8}>
                        <Statistic title="引燃温度" value="425°C" valueStyle={{ color: '#ff4d4f' }} />
                      </Col>
                    </Row>
                  </div>
                </Card>
              </div>
            )}

            {/* 安全措施 */}
            {activeTab === 'safety' && (
              <div className="content-section">
                <Card title={<><SafetyOutlined /> 急救措施</>} className="info-card">
                  <Row gutter={[16, 16]}>
                    <Col span={12}>
                      <div className="first-aid-item">
                        <Title level={5} style={{ color: '#1890ff' }}>
                          🫁 吸入
                        </Title>
                        <Paragraph>
                          迅速脱离现场至空气新鲜处。保持呼吸道通畅。如呼吸困难，给输氧。
                          如呼吸停止，立即进行人工呼吸。就医。
                        </Paragraph>
                      </div>
                      <div className="first-aid-item">
                        <Title level={5} style={{ color: '#52c41a' }}>
                          👁️ 眼睛接触
                        </Title>
                        <Paragraph>
                          立即提起眼睑，用大量流动清水或生理盐水彻底冲洗至少15分钟。就医。
                        </Paragraph>
                      </div>
                    </Col>
                    <Col span={12}>
                      <div className="first-aid-item">
                        <Title level={5} style={{ color: '#faad14' }}>
                          ✋ 皮肤接触
                        </Title>
                        <Paragraph>脱去污染的衣着，用流动清水冲洗。</Paragraph>
                      </div>
                      <div className="first-aid-item">
                        <Title level={5} style={{ color: '#ff4d4f' }}>
                          👄 食入
                        </Title>
                        <Paragraph>饮足量温水，催吐。洗胃，导泻。就医。</Paragraph>
                      </div>
                    </Col>
                  </Row>
                </Card>

                <Card title="🧯 消防措施" className="info-card">
                  <Row gutter={[24, 24]}>
                    <Col span={12}>
                      <Title level={5}>灭火方法</Title>
                      <Space direction="vertical">
                        <Tag color="success" icon="✓">
                          抗溶性泡沫、干粉、二氧化碳、砂土
                        </Tag>
                        <Tag color="error" icon="✗">
                          禁用水流冲击
                        </Tag>
                      </Space>
                    </Col>
                    <Col span={12}>
                      <Title level={5}>特别危险性</Title>
                      <div className="warning-box">
                        <Paragraph>
                          易燃，其蒸气与空气可形成爆炸性混合物，遇明火、高热能引起燃烧爆炸。
                          与氧化剂接触发生化学反应或引起燃烧。
                        </Paragraph>
                      </div>
                    </Col>
                  </Row>
                </Card>
              </div>
            )}

            {/* 版本历史 */}
            {activeTab === 'versions' && (
              <div className="content-section">
                <Card title={<><HistoryOutlined /> 版本历史</>} className="info-card">
                  <Timeline>
                    <Timeline.Item color="green">
                      <div className="version-item">
                        <div className="version-header">
                          <Title level={5}>版本 3.2</Title>
                          <Tag color="success">当前版本</Tag>
                        </div>
                        <Text type="secondary">2024-01-10 14:30</Text>
                        <Paragraph style={{ marginTop: 8 }}>
                          更新了GHS分类信息，补充了最新的法规要求，修正了理化性质数据。
                        </Paragraph>
                        <Space size="small">
                          <Text type="secondary">👤 张三</Text>
                          <Text type="secondary">🏢 安全部</Text>
                          <Button type="link" size="small">
                            查看详情
                          </Button>
                        </Space>
                      </div>
                    </Timeline.Item>
                    <Timeline.Item>
                      <div className="version-item">
                        <div className="version-header">
                          <Title level={5}>版本 3.1</Title>
                          <Tag>历史版本</Tag>
                        </div>
                        <Text type="secondary">2023-12-15 09:15</Text>
                        <Paragraph style={{ marginTop: 8 }}>
                          更新了供应商信息，修正了急救措施描述。
                        </Paragraph>
                        <Space size="small">
                          <Text type="secondary">👤 李四</Text>
                          <Text type="secondary">🏢 技术部</Text>
                          <Button type="link" size="small">
                            查看详情
                          </Button>
                          <Button type="link" size="small">
                            下载
                          </Button>
                        </Space>
                      </div>
                    </Timeline.Item>
                    <Timeline.Item>
                      <div className="version-item">
                        <div className="version-header">
                          <Title level={5}>版本 3.0</Title>
                          <Tag>历史版本</Tag>
                        </div>
                        <Text type="secondary">2023-11-20 16:45</Text>
                        <Paragraph style={{ marginTop: 8 }}>
                          初始版本，建立了完整的MSDS文档结构。
                        </Paragraph>
                        <Space size="small">
                          <Text type="secondary">👤 王五</Text>
                          <Text type="secondary">🏢 安全部</Text>
                          <Button type="link" size="small">
                            查看详情
                          </Button>
                          <Button type="link" size="small">
                            下载
                          </Button>
                        </Space>
                      </div>
                    </Timeline.Item>
                  </Timeline>
                </Card>
              </div>
            )}
          </Col>

          {/* 右侧边栏 */}
          <Col xs={24} lg={6}>
            <div className="sidebar-sticky">
              <Card title="文档信息" size="small" className="info-sidebar">
                <Descriptions column={1} size="small">
                  <Descriptions.Item label="供应商">
                    {displayDetail.supplier}
                  </Descriptions.Item>
                  <Descriptions.Item label="产品编号">
                    {displayDetail.productNumber}
                  </Descriptions.Item>
                  <Descriptions.Item label="版本">{displayDetail.version}</Descriptions.Item>
                  <Descriptions.Item label="更新日期">
                    {displayDetail.updateTime}
                  </Descriptions.Item>
                  <Descriptions.Item label="语言">{displayDetail.language}</Descriptions.Item>
                  <Descriptions.Item label="页数">
                    {displayDetail.pageCount}页
                  </Descriptions.Item>
                  <Descriptions.Item label="文件大小">
                    {displayDetail.fileSize}
                  </Descriptions.Item>
                </Descriptions>

                <div className="stats-section">
                  <Title level={5}>使用统计</Title>
                  <Space direction="vertical" style={{ width: '100%' }}>
                    <div className="stat-item">
                      <EyeOutlined /> 查看次数
                      <Text strong style={{ float: 'right' }}>
                        {displayDetail.viewCount}
                      </Text>
                    </div>
                    <div className="stat-item">
                      <DownloadOutlined /> 下载次数
                      <Text strong style={{ float: 'right' }}>
                        {displayDetail.downloadCount}
                      </Text>
                    </div>
                    <div className="stat-item">
                      <StarOutlined /> 收藏次数
                      <Text strong style={{ float: 'right' }}>
                        {displayDetail.favoriteCount}
                      </Text>
                    </div>
                  </Space>
                </div>

                <div className="related-docs">
                  <Title level={5}>相关文档</Title>
                  <Space direction="vertical" style={{ width: '100%' }}>
                    {relatedDocs.map((doc) => (
                      <div
                        key={doc.id}
                        className="related-doc-item"
                        onClick={() => history.push(`/msds/detail/${doc.id}`)}
                      >
                        <Text className="doc-name">{doc.name}</Text>
                        <Text type="secondary" className="doc-cas">
                          CAS: {doc.cas}
                        </Text>
                      </div>
                    ))}
                  </Space>
                </div>
              </Card>
            </div>
          </Col>
        </Row>
      </div>

      {/* 浮动操作按钮 */}
      <FloatButton.Group
        trigger="click"
        type="primary"
        icon={<ExclamationCircleOutlined />}
        className="print-hidden"
      >
        <FloatButton icon={<PrinterOutlined />} tooltip="打印" onClick={handlePrint} />
        <FloatButton icon={<DownloadOutlined />} tooltip="下载PDF" onClick={handleDownload} />
        <FloatButton icon={<ShareAltOutlined />} tooltip="分享" onClick={handleShare} />
        <FloatButton icon={<StarOutlined />} tooltip="收藏" onClick={handleFavorite} />
      </FloatButton.Group>
    </div>
  );
};

export default MsdsDetail;

