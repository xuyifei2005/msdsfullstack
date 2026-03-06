import React, { useState, useEffect } from 'react';
import {
  Card,
  Descriptions,
  Tag,
  Button,
  Space,
  Tabs,
  Table,
  Timeline,
  Row,
  Col,
  Statistic,
  QRCode,
  message,
  Spin,
  Alert,
} from 'antd';
import {
  DownloadOutlined,
  PrinterOutlined,
  StarOutlined,
  ShareAltOutlined,
  EyeOutlined,
  FireOutlined,
  ExperimentOutlined,
  SafetyOutlined,
  HistoryOutlined,
  ArrowLeftOutlined,
} from '@ant-design/icons';
import { PageContainer } from '@ant-design/pro-components';
import { useParams, history } from '@umijs/max';
import { getMsdsMain } from '@/services/msds';
import styles from './index.less';

const { TabPane } = Tabs;

const MsdsDetail: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const [loading, setLoading] = useState(true);
  const [msdsData, setMsdsData] = useState<API.Msds.MsdsMain | null>(null);
  const [activeTab, setActiveTab] = useState('basic');

  useEffect(() => {
    if (id) {
      fetchMsdsDetail();
    }
  }, [id]);

  const fetchMsdsDetail = async () => {
    try {
      setLoading(true);
      const response = await getMsdsMain(Number(id));
      if (response.code === 200) {
        setMsdsData(response.data);
      } else {
        message.error('获取MSDS详情失败');
      }
    } catch (error) {
      message.error('获取MSDS详情失败：' + error.message);
    } finally {
      setLoading(false);
    }
  };

  const handleDownload = () => {
    message.info('下载功能开发中...');
  };

  const handlePrint = () => {
    window.print();
  };

  const handleFavorite = () => {
    message.success('收藏成功');
  };

  const handleShare = () => {
    if (navigator.share) {
      navigator.share({
        title: msdsData?.productName || 'MSDS文档',
        text: `查看${msdsData?.productName}的安全数据表`,
        url: window.location.href,
      });
    } else {
      navigator.clipboard.writeText(window.location.href).then(() => {
        message.success('链接已复制到剪贴板');
      });
    }
  };

  const statusTextMap: Record<string, string> = {
    approved: '已批准',
    pending: '待审核',
    draft: '草稿',
    archived: '已归档',
  };

  const statusColorMap: Record<string, string> = {
    approved: 'green',
    pending: 'orange',
    draft: 'blue',
    archived: 'default',
  };

  if (loading) {
    return (
      <PageContainer>
        <div style={{ textAlign: 'center', padding: '100px 0' }}>
          <Spin size="large" tip="加载中..." />
        </div>
      </PageContainer>
    );
  }

  if (!msdsData) {
    return (
      <PageContainer>
        <Alert
          message="未找到MSDS文档"
          description="请检查文档ID是否正确"
          type="warning"
          showIcon
        />
      </PageContainer>
    );
  }

  return (
    <PageContainer
      header={{
        title: null,
        breadcrumb: {
          items: [
            { title: '首页', path: '/' },
            { title: '智能搜索', path: '/msds/search' },
            { title: msdsData.productName || '详情' },
          ],
        },
      }}
      className={styles.detailContainer}
    >
      {/* 头部信息卡片 */}
      <Card className={styles.headerCard} bordered={false}>
        <Row gutter={24}>
          <Col xs={24} lg={16}>
            <div className={styles.chemicalInfo}>
              {/* 分子结构图占位 */}
              <div className={styles.molecularStructure}>
                <div className={styles.formulaDisplay}>
                  <div className={styles.formula}>{msdsData.molecularFormula || 'N/A'}</div>
                  <div className={styles.formulaLabel}>分子式</div>
                </div>
              </div>

              {/* 化学品基本信息 */}
              <div className={styles.basicInfo}>
                <h1>{msdsData.productName}</h1>
                <h2>{msdsData.productEnglishName || ''}</h2>

                <div className={styles.identifiers}>
                  <div>
                    <span>CAS号：</span>
                    <strong>{msdsData.casNumber || 'N/A'}</strong>
                  </div>
                  <div>
                    <span>分子量：</span>
                    <strong>{msdsData.molecularWeight || 'N/A'}</strong>
                  </div>
                  <div>
                    <span>UN号：</span>
                    <strong>{msdsData.unNumber || 'N/A'}</strong>
                  </div>
                </div>

                {/* 危险性标识 */}
                <div className={styles.hazardTags}>
                  <Tag icon={<FireOutlined />} color="red">
                    易燃液体
                  </Tag>
                  {/* 根据实际数据添加更多标签 */}
                </div>
              </div>
            </div>
          </Col>

          <Col xs={24} lg={8}>
            <Card className={styles.actionCard} bordered={false}>
              <h3>快速操作</h3>
              <Space direction="vertical" style={{ width: '100%' }}>
                <Button
                  type="primary"
                  size="large"
                  block
                  icon={<DownloadOutlined />}
                  onClick={handleDownload}
                >
                  下载MSDS
                </Button>
                <Button
                  size="large"
                  block
                  icon={<PrinterOutlined />}
                  onClick={handlePrint}
                >
                  打印文档
                </Button>
                <Button
                  size="large"
                  block
                  icon={<StarOutlined />}
                  onClick={handleFavorite}
                >
                  收藏
                </Button>
                <Button
                  size="large"
                  block
                  icon={<ShareAltOutlined />}
                  onClick={handleShare}
                >
                  分享
                </Button>
              </Space>

              {/* 二维码 */}
              <div style={{ textAlign: 'center', marginTop: 24 }}>
                <div style={{ fontSize: 14, marginBottom: 8 }}>扫码查看移动版</div>
                <QRCode value={window.location.href} size={120} />
              </div>
            </Card>
          </Col>
        </Row>
      </Card>

      {/* 详细信息标签页 */}
      <Row gutter={24} style={{ marginTop: 24 }}>
        <Col xs={24} lg={18}>
          <Card bordered={false} className={styles.detailContentCard}>
            <Tabs activeKey={activeTab} onChange={setActiveTab} size="large">
              <TabPane tab="基本信息" key="basic">
                <Descriptions bordered column={2} className={styles.detailDescriptions}>
                  <Descriptions.Item label="中文名">
                    {msdsData.productName}
                  </Descriptions.Item>
                  <Descriptions.Item label="英文名">
                    {msdsData.productEnglishName || 'N/A'}
                  </Descriptions.Item>
                  <Descriptions.Item label="别名">
                    {msdsData.productAlias || 'N/A'}
                  </Descriptions.Item>
                  <Descriptions.Item label="分子式">
                    {msdsData.molecularFormula || 'N/A'}
                  </Descriptions.Item>
                  <Descriptions.Item label="分子量">
                    {msdsData.molecularWeight || 'N/A'}
                  </Descriptions.Item>
                  <Descriptions.Item label="CAS号">
                    {msdsData.casNumber}
                  </Descriptions.Item>
                  <Descriptions.Item label="EINECS号">
                    {msdsData.einecsNumber || 'N/A'}
                  </Descriptions.Item>
                  <Descriptions.Item label="RTECS号">
                    {msdsData.rtecsNumber || 'N/A'}
                  </Descriptions.Item>
                  <Descriptions.Item label="UN号">
                    {msdsData.unNumber || 'N/A'}
                  </Descriptions.Item>
                  <Descriptions.Item label="危险货物编号">
                    {msdsData.dangerousGoodsCode || 'N/A'}
                  </Descriptions.Item>
                </Descriptions>
              </TabPane>

              <TabPane tab="危险性信息" key="hazard">
                <Alert
                  message="健康危害"
                  description="本品为中枢神经系统抑制剂。详细危害信息请查看完整MSDS文档。"
                  type="warning"
                  showIcon
                  style={{ marginBottom: 16 }}
                />
                {/* 这里可以添加更多危险性信息 */}
              </TabPane>

              <TabPane tab="理化性质" key="physical">
                <Descriptions bordered column={2} className={styles.detailDescriptions}>
                  <Descriptions.Item label="外观">
                    {msdsData.appearance || 'N/A'}
                  </Descriptions.Item>
                  <Descriptions.Item label="熔点">
                    {msdsData.meltingPoint || 'N/A'}
                  </Descriptions.Item>
                  <Descriptions.Item label="沸点">
                    {msdsData.boilingPoint || 'N/A'}
                  </Descriptions.Item>
                  <Descriptions.Item label="闪点">
                    {msdsData.flashPoint || 'N/A'}
                  </Descriptions.Item>
                  <Descriptions.Item label="相对密度">
                    {msdsData.relativeDensity || 'N/A'}
                  </Descriptions.Item>
                  <Descriptions.Item label="溶解性">
                    {msdsData.solubility || 'N/A'}
                  </Descriptions.Item>
                </Descriptions>
              </TabPane>

              <TabPane tab="版本历史" key="versions">
                <Timeline>
                  <Timeline.Item color="green">
                    <p>
                      <strong>版本 {msdsData.version || '1.0'}</strong>
                      <Tag color="green" style={{ marginLeft: 8 }}>
                        当前版本
                      </Tag>
                    </p>
                    <p>更新时间：{msdsData.updateTime || msdsData.createTime}</p>
                    <p>更新者：{msdsData.updateBy || msdsData.createBy || '系统'}</p>
                  </Timeline.Item>
                </Timeline>
              </TabPane>
            </Tabs>
          </Card>
        </Col>

        <Col xs={24} lg={6}>
          {/* 文档信息 */}
          <Card title="文档信息" bordered={false} style={{ marginBottom: 16 }} className={styles.sidePanelCard}>
            <Descriptions column={1} size="small" className={styles.detailDescriptions}>
              <Descriptions.Item label="供应商">
                {msdsData.companyName || 'N/A'}
              </Descriptions.Item>
              <Descriptions.Item label="版本">
                {msdsData.version || '1.0'}
              </Descriptions.Item>
              <Descriptions.Item label="更新日期">
                {msdsData.updateTime?.split(' ')[0] || msdsData.createTime?.split(' ')[0]}
              </Descriptions.Item>
              <Descriptions.Item label="状态">
                <Tag color={statusColorMap[msdsData.status || ''] || 'orange'}>
                  {statusTextMap[msdsData.status || ''] || '待审核'}
                </Tag>
              </Descriptions.Item>
              <Descriptions.Item label="有效性">
                <Tag color={msdsData.isActive === 1 ? 'green' : 'red'}>
                  {msdsData.isActive === 1 ? '有效' : '无效'}
                </Tag>
              </Descriptions.Item>
            </Descriptions>
          </Card>

          {/* 使用统计 */}
          <Card title="使用统计" bordered={false} className={styles.sidePanelCard}>
            <Space direction="vertical" style={{ width: '100%' }}>
              <Statistic
                title="查看次数"
                value={1234}
                prefix={<EyeOutlined />}
              />
              <Statistic
                title="下载次数"
                value={456}
                prefix={<DownloadOutlined />}
              />
              <Statistic
                title="收藏次数"
                value={89}
                prefix={<StarOutlined />}
              />
            </Space>
          </Card>
        </Col>
      </Row>

      {/* 返回按钮 */}
      <div style={{ marginTop: 24, textAlign: 'center' }}>
        <Button
          icon={<ArrowLeftOutlined />}
          onClick={() => history.back()}
          size="large"
        >
          返回搜索结果
        </Button>
      </div>
    </PageContainer>
  );
};

export default MsdsDetail;
