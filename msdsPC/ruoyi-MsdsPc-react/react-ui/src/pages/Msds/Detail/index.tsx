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
import {
  getMsdsStatistics,
  recordMsdsAccess,
  exportMsdsPdf,
  getFavoriteStatus,
  addFavorite,
  removeFavorite,
  type MsdsStatistics,
} from '@/services/msds';
import { resolveBlob } from '@/utils/downloadfile';
import styles from './index.less';

const { TabPane } = Tabs;

const MsdsDetail: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const [loading, setLoading] = useState(true);
  const [msdsData, setMsdsData] = useState<API.Msds.MsdsMain | null>(null);
  const [activeTab, setActiveTab] = useState('basic');
  // 真实计数（来自后端统计数据，非写死值）
  const [statistics, setStatistics] = useState<MsdsStatistics>({
    viewCount: 0,
    downloadCount: 0,
    favoriteCount: 0,
    shareCount: 0,
  });
  const [downloading, setDownloading] = useState(false);
  const [favorited, setFavorited] = useState(false);

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

  /**
   * 加载真实计数，并在首次进入详情页时记录一次查看
   */
  useEffect(() => {
    const msdsId = Number(id);
    if (!msdsId) {
      return;
    }

    // 先读取已有计数
    getMsdsStatistics(msdsId)
      .then((res) => {
        if (res?.code === 200 && res.data) {
          setStatistics(res.data);
        }
      })
      .catch(() => {
        // 统计读取失败不阻断详情展示，计数保持为 0
      });

    // 本次查看行为计入真实统计
    recordMsdsAccess(msdsId, 'view')
      .then((res) => {
        if (res?.code === 200 && res.data) {
          setStatistics(res.data);
        }
      })
      .catch(() => {
        // 忽略计数写入失败
      });

    // 读取当前用户的收藏状态
    getFavoriteStatus(msdsId)
      .then((res) => {
        if (res?.code === 200 && res.data) {
          setFavorited(Boolean(res.data.favorited));
        }
      })
      .catch(() => {
        // 收藏状态读取失败保持未收藏
      });
  }, [id]);

  /**
   * 真实下载：由后端生成 PDF 文件并累加下载次数
   */
  const handleDownload = async () => {
    const msdsId = Number(id);
    if (!msdsId) {
      return;
    }
    try {
      setDownloading(true);
      const res: any = await exportMsdsPdf(msdsId);
      resolveBlob(res, 'application/pdf');
      // 下载次数由后端统计写入，此处同步刷新本地展示
      const statRes = await getMsdsStatistics(msdsId);
      if (statRes?.code === 200 && statRes.data) {
        setStatistics(statRes.data);
      }
      message.success('MSDS PDF 已开始下载');
    } catch (error: any) {
      message.error(`下载失败：${error?.message || '请稍后重试'}`);
    } finally {
      setDownloading(false);
    }
  };

  const handlePrint = () => {
    window.print();
  };

  /**
   * 收藏 / 取消收藏：真实落库到 msds_user_favorite，并联动收藏计数
   */
  const handleFavorite = async () => {
    const msdsId = Number(id);
    if (!msdsId) {
      return;
    }
    try {
      if (favorited) {
        const res = await removeFavorite(msdsId);
        if (res?.code === 200) {
          setFavorited(false);
          if (res.data?.statistics) {
            setStatistics(res.data.statistics);
          }
          message.success('已取消收藏');
        } else {
          message.error(res?.msg || '取消收藏失败，请稍后重试');
        }
        return;
      }

      const res = await addFavorite(msdsId, {
        msdsName: msdsData?.productName,
        casNumber: msdsData?.casNumber,
      });
      if (res?.code === 200) {
        setFavorited(true);
        if (res.data?.statistics) {
          setStatistics(res.data.statistics);
        }
        message.success('已收藏');
      } else {
        message.error(res?.msg || '收藏失败，请稍后重试');
      }
    } catch (error: any) {
      message.error(`收藏失败：${error?.message || '请稍后重试'}`);
    }
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
    approved: '已审批',
    pending: '待审',
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

                {/* 危险性标识：仅展示文档中真实存在的危险性字段，无数据时不渲染假标签 */}
                <div className={styles.hazardTags}>
                  {msdsData.flashPoint ? (
                    <Tag icon={<FireOutlined />} color="red">
                      闪点 {msdsData.flashPoint}
                    </Tag>
                  ) : null}
                  {msdsData.unNumber ? (
                    <Tag color="orange">UN号 {msdsData.unNumber}</Tag>
                  ) : null}
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
                  loading={downloading}
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
                  type={favorited ? 'default' : undefined}
                  onClick={handleFavorite}
                >
                  {favorited ? '取消收藏' : '收藏'}
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
                  {statusTextMap[msdsData.status || ''] || '待审'}
                </Tag>
              </Descriptions.Item>
              <Descriptions.Item label="有效性">
                <Tag color={msdsData.isActive === 1 ? 'green' : 'red'}>
                  {msdsData.isActive === 1 ? '有效' : '无效'}
                </Tag>
              </Descriptions.Item>
            </Descriptions>
          </Card>

          {/* 使用统计：全部来自后端真实统计数据 */}
          <Card title="使用统计" bordered={false} className={styles.sidePanelCard}>
            <Space direction="vertical" style={{ width: '100%' }}>
              <Statistic
                title="查看次数"
                value={statistics.viewCount ?? 0}
                prefix={<EyeOutlined />}
              />
              <Statistic
                title="下载次数"
                value={statistics.downloadCount ?? 0}
                prefix={<DownloadOutlined />}
              />
              <Statistic
                title="收藏次数"
                value={statistics.favoriteCount ?? 0}
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
