import React, { useState, useEffect } from 'react';
import { Card, Tabs, Descriptions, Table, Progress, Tag, Space, Button, message } from 'antd';
import { EditOutlined, CheckCircleOutlined, ExclamationCircleOutlined } from '@ant-design/icons';
import type { API } from '@/types/msds';
import { getMsdsDetail } from '@/services/msds';
import { getToxicologyByMsdsId } from '@/services/msds/toxicology';
import { getHazardByMsdsId } from '@/services/msds/hazard';
import { getComponentByMsdsId } from '@/services/msds/component';
import { getFirstAidByMsdsId } from '@/services/msds/firstAid';
import { getFireFightingByMsdsId } from '@/services/msds/fireFighting';
import { getLeakResponseByMsdsId } from '@/services/msds/leakResponse';
import { getHandlingByMsdsId } from '@/services/msds/handling';
import { getExposureByMsdsId } from '@/services/msds/exposure';
import { getPhysicalChemicalByMsdsId } from '@/services/msds/physicalChemical';
import { getStabilityReactivityByMsdsId } from '@/services/msds/stabilityReactivity';
import { getEcologyByMsdsId } from '@/services/msds/ecology';
import { getDisposalByMsdsId } from '@/services/msds/disposal';
import { getTransportByMsdsId } from '@/services/msds/transport';
import { getRegulatoryByMsdsId } from '@/services/msds/regulatory';

interface MsdsDetailProps {
  msdsId: number;
  onEdit?: (msdsId: number, section?: string) => void;
}

const MsdsDetail: React.FC<MsdsDetailProps> = ({ msdsId, onEdit }) => {
  const [loading, setLoading] = useState(false);
  const [msdsData, setMsdsData] = useState<API.Msds.MsdsDetail | any>({});
  const [activeTab, setActiveTab] = useState('1');

  useEffect(() => {
    fetchMsdsDetail();
  }, [msdsId]);

  const fetchMsdsDetail = async () => {
    setLoading(true);
    try {
      // 并行加载所有章节数据
      const [
        msdsResponse, 
        toxicologyResponse, 
        hazardResponse,
        componentResponse,
        firstAidResponse,
        fireFightingResponse,
        leakResponseResponse,
        handlingResponse,
        exposureResponse,
        physicalChemicalResponse,
        stabilityReactivityResponse,
        ecologyResponse,
        disposalResponse,
        transportResponse,
        regulatoryResponse
      ] = await Promise.all([
        getMsdsDetail(msdsId),
        getToxicologyByMsdsId(msdsId),
        getHazardByMsdsId(msdsId),
        getComponentByMsdsId(msdsId),
        getFirstAidByMsdsId(msdsId),
        getFireFightingByMsdsId(msdsId),
        getLeakResponseByMsdsId(msdsId),
        getHandlingByMsdsId(msdsId),
        getExposureByMsdsId(msdsId),
        getPhysicalChemicalByMsdsId(msdsId),
        getStabilityReactivityByMsdsId(msdsId),
        getEcologyByMsdsId(msdsId),
        getDisposalByMsdsId(msdsId),
        getTransportByMsdsId(msdsId),
        getRegulatoryByMsdsId(msdsId)
      ]);
      
      if (msdsResponse.code === 200) {
        const msdsData = msdsResponse.data;
        
        // 将所有章节数据添加到MSDS数据中
        if (toxicologyResponse.code === 200 && toxicologyResponse.data) {
          msdsData.toxicological = toxicologyResponse.data;
        }
        if (hazardResponse.code === 200 && hazardResponse.data) {
          msdsData.hazard = hazardResponse.data;
        }
        if (componentResponse.code === 200 && componentResponse.data) {
          msdsData.components = componentResponse.data;
        }
        if (firstAidResponse.code === 200 && firstAidResponse.data) {
          msdsData.firstAid = firstAidResponse.data;
        }
        if (fireFightingResponse.code === 200 && fireFightingResponse.data) {
          msdsData.fireFighting = fireFightingResponse.data;
        }
        if (leakResponseResponse.code === 200 && leakResponseResponse.data) {
          msdsData.leakResponse = leakResponseResponse.data;
        }
        if (handlingResponse.code === 200 && handlingResponse.data) {
          msdsData.handlingStorage = handlingResponse.data;
        }
        if (exposureResponse.code === 200 && exposureResponse.data) {
          msdsData.exposureControl = exposureResponse.data;
        }
        if (physicalChemicalResponse.code === 200 && physicalChemicalResponse.data) {
          msdsData.physicalChemical = physicalChemicalResponse.data;
        }
        if (stabilityReactivityResponse.code === 200 && stabilityReactivityResponse.data) {
          msdsData.stabilityReactivity = stabilityReactivityResponse.data;
        }
        if (ecologyResponse.code === 200 && ecologyResponse.data) {
          msdsData.ecological = ecologyResponse.data;
        }
        if (disposalResponse.code === 200 && disposalResponse.data) {
          msdsData.disposal = disposalResponse.data;
        }
        if (transportResponse.code === 200 && transportResponse.data) {
          msdsData.transportation = transportResponse.data;
        }
        if (regulatoryResponse.code === 200 && regulatoryResponse.data) {
          msdsData.regulatory = regulatoryResponse.data;
        }
        
        setMsdsData(msdsData);
      } else {
        message.error('获取MSDS详情失败');
      }
    } catch (error) {
      console.error('加载MSDS详情失败:', error);
      message.error('获取MSDS详情失败');
    } finally {
      setLoading(false);
    }
  };

  // 计算数据完整度
  const calculateCompleteness = (data: any, requiredFields: string[]) => {
    if (!data) return 0;
    const filledFields = requiredFields.filter(field => data[field] && data[field].trim() !== '');
    return Math.round((filledFields.length / requiredFields.length) * 100);
  };

  // 渲染状态标签
  const renderStatusTag = (status: string) => {
    const statusMap = {
      draft: { color: 'default', text: '草稿' },
      pending: { color: 'processing', text: '待审' },
      approved: { color: 'success', text: '已审批' },
      archived: { color: 'error', text: '已归档' }
    };
    const config = statusMap[status as keyof typeof statusMap] || statusMap.draft;
    return <Tag color={config.color}>{config.text}</Tag>;
  };

  // 渲染编辑按钮
  const renderEditButton = (section: string) => (
    <Button 
      type="link" 
      icon={<EditOutlined />} 
      onClick={() => onEdit?.(msdsId, section)}
    >
      编辑
    </Button>
  );

  // Tab配置
  const tabItems = [
    {
      key: '1',
      label: '1. 化学品及企业标识',
      children: (
        <Card 
          title="化学品及企业标识" 
          extra={renderEditButton('main')}
          loading={loading}
        >
          <Space direction="vertical" size="middle" style={{ width: '100%' }}>
            {/* 基础信息卡片 */}
            <Card size="small" title="基础信息">
              <Descriptions column={2} bordered>
                <Descriptions.Item label="CAS号">{msdsData.casNumber || '-'}</Descriptions.Item>
                <Descriptions.Item label="MSDS编号">{msdsData.msdsCode || '-'}</Descriptions.Item>
                <Descriptions.Item label="化学品中文名">{msdsData.productName || '-'}</Descriptions.Item>
                <Descriptions.Item label="化学品英文名">{msdsData.productEnglishName || '-'}</Descriptions.Item>
                <Descriptions.Item label="化学品别名" span={2}>{msdsData.productAlias || '-'}</Descriptions.Item>
                <Descriptions.Item label="推荐用途" span={2}>{msdsData.recommendedUsage || '-'}</Descriptions.Item>
                <Descriptions.Item label="限制用途" span={2}>{msdsData.restrictedUsage || '-'}</Descriptions.Item>
              </Descriptions>
            </Card>

            {/* 企业信息卡片 */}
            <Card size="small" title="企业信息">
              <Descriptions column={2} bordered>
                <Descriptions.Item label="企业名称">{msdsData.companyName || '-'}</Descriptions.Item>
                <Descriptions.Item label="联系电话">{msdsData.contactPhone || '-'}</Descriptions.Item>
                <Descriptions.Item label="企业地址" span={2}>{msdsData.companyAddress || '-'}</Descriptions.Item>
                <Descriptions.Item label="邮编">{msdsData.zipCode || '-'}</Descriptions.Item>
                <Descriptions.Item label="传真号码">{msdsData.faxNumber || '-'}</Descriptions.Item>
                <Descriptions.Item label="电子邮件">{msdsData.email || '-'}</Descriptions.Item>
                <Descriptions.Item label="应急电话">{msdsData.emergencyPhone || '-'}</Descriptions.Item>
              </Descriptions>
            </Card>

            {/* 版本信息卡片 */}
            <Card size="small" title="版本信息">
              <Descriptions column={2} bordered>
                <Descriptions.Item label="版本号">{msdsData.version || '-'}</Descriptions.Item>
                <Descriptions.Item label="修订日期">{msdsData.revisionDate || '-'}</Descriptions.Item>
                <Descriptions.Item label="生效日期">{msdsData.effectiveDate || '-'}</Descriptions.Item>
                <Descriptions.Item label="状态">{renderStatusTag(msdsData.status)}</Descriptions.Item>
                <Descriptions.Item label="审批人">{msdsData.approver || '-'}</Descriptions.Item>
                <Descriptions.Item label="审批日期">{msdsData.approvalDate || '-'}</Descriptions.Item>
              </Descriptions>
            </Card>
          </Space>
        </Card>
      )
    },
    {
      key: '2',
      label: '2. 危险性概述',
      children: (
        <Card 
          title="危险性概述" 
          extra={renderEditButton('hazard')}
          loading={loading}
        >
          <Descriptions column={1} bordered>
            <Descriptions.Item label="紧急情况概述">
              {msdsData.hazard?.emergencyOverview || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="物理状态">
              {msdsData.hazard?.physicalState || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="气味">
              {msdsData.hazard?.odor || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="颜色">
              {msdsData.hazard?.color || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="警示词">
              {msdsData.hazard?.warningWord && (
                <Tag color={msdsData.hazard.warningWord === 'danger' ? 'red' : 'orange'}>
                  {msdsData.hazard.warningWord === 'danger' ? '危险' : '警告'}
                </Tag>
              )}
            </Descriptions.Item>
            <Descriptions.Item label="危险性类别">
              {msdsData.hazard?.hazardCategory || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="侵入途径">
              {msdsData.hazard?.exposureRoutes || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="健康危害">
              {msdsData.hazard?.healthHazards || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="环境危害">
              {msdsData.hazard?.environmentalHazards || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="燃爆危险">
              {msdsData.hazard?.fireExplosionHazards || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="预防措施">
              {msdsData.hazard?.preventionMeasures || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="响应措施">
              {msdsData.hazard?.responseMeasures || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="储存措施">
              {msdsData.hazard?.storageMeasures || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="废弃处置措施">
              {msdsData.hazard?.disposalMeasures || '-'}
            </Descriptions.Item>
          </Descriptions>
        </Card>
      )
    },
    {
      key: '3',
      label: '3. 成分/组成信息',
      children: (
        <Card 
          title="成分/组成信息" 
          extra={renderEditButton('component')}
          loading={loading}
        >
          <Table
            dataSource={msdsData.components || []}
            rowKey="id"
            pagination={false}
            columns={[
              {
                title: '成分名称',
                dataIndex: 'componentName',
                key: 'componentName',
              },
              {
                title: '成分英文名',
                dataIndex: 'componentEnglishName',
                key: 'componentEnglishName',
              },
              {
                title: 'CAS号',
                dataIndex: 'casNumber',
                key: 'casNumber',
              },
              {
                title: '含量',
                dataIndex: 'componentContent',
                key: 'componentContent',
              },
              {
                title: '分子式',
                dataIndex: 'molecularFormula',
                key: 'molecularFormula',
              },
              {
                title: '分子量',
                dataIndex: 'molecularWeight',
                key: 'molecularWeight',
              },
              {
                title: '危险成分',
                dataIndex: 'isHazardous',
                key: 'isHazardous',
                render: (isHazardous: boolean) => (
                  <Tag color={isHazardous ? 'red' : 'green'}>
                    {isHazardous ? '是' : '否'}
                  </Tag>
                )
              },
            ]}
          />
        </Card>
      )
    },
    {
      key: '4',
      label: '4. 急救措施',
      children: (
        <Card 
          title="急救措施" 
          extra={renderEditButton('firstAid')}
          loading={loading}
        >
          <Descriptions column={1} bordered>
            <Descriptions.Item label="皮肤接触处理措施">
              {console.log('急救措施完整数据:', msdsData.firstAid)}
              {console.log('皮肤接触数据:', msdsData.firstAid?.skinContact)}
              {msdsData.firstAid?.skinContact || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="眼睛接触处理措施">
              {msdsData.firstAid?.eyeContact || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="吸入处理措施">
              {msdsData.firstAid?.inhalation || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="食入处理措施">
              {msdsData.firstAid?.ingestion || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="一般注意事项">
              {msdsData.firstAid?.generalNotes || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="可能出现的症状和健康影响">
              {msdsData.firstAid?.symptomsEffects || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="需要立即就医的情况">
              {msdsData.firstAid?.immediateMedicalAttention || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="解毒剂及治疗方法">
              {msdsData.firstAid?.antidoteTreatment || '-'}
            </Descriptions.Item>
          </Descriptions>
        </Card>
      )
    },
    {
      key: '5',
      label: '5. 消防措施',
      children: (
        <Card 
          title="消防措施" 
          extra={renderEditButton('fireFighting')}
          loading={loading}
        >
          <Descriptions column={1} bordered>
            <Descriptions.Item label="危险特性">
              {msdsData.fireFighting?.hazardCharacteristics || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="有害燃烧产物">
              {msdsData.fireFighting?.harmfulCombustionProducts || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="适宜的灭火介质">
              {msdsData.fireFighting?.suitableExtinguishingMedia || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="不适宜的灭火介质">
              {msdsData.fireFighting?.unsuitableExtinguishingMedia || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="消防设备和防护装备">
              {msdsData.fireFighting?.fireFightingEquipment || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="特殊消防程序">
              {msdsData.fireFighting?.fireFightingProcedures || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="闪点">
              {msdsData.fireFighting?.flashPoint || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="自燃温度">
              {msdsData.fireFighting?.autoignitionTemperature || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="燃烧性/爆炸极限">
              {msdsData.fireFighting?.flammabilityLimits || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="建规火险分级">
              {msdsData.fireFighting?.fireRiskClassification || '-'}
            </Descriptions.Item>
          </Descriptions>
        </Card>
      )
    },
    {
      key: '6',
      label: '6. 泄漏应急处理',
      children: (
        <Card 
          title="泄漏应急处理" 
          extra={renderEditButton('leakResponse')}
          loading={loading}
        >
          <Descriptions column={1} bordered>
            <Descriptions.Item label="个人防护措施">
              {msdsData.leakResponse?.personalPrecautions || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="环境保护措施">
              {msdsData.leakResponse?.environmentalPrecautions || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="泄漏化学品的收容、清除方法">
              {msdsData.leakResponse?.containmentCleanup || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="应急处理程序">
              {msdsData.leakResponse?.emergencyProcedures || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="消除方法">
              {msdsData.leakResponse?.eliminationMethods || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="清理时使用的器材">
              {msdsData.leakResponse?.equipmentMaterials || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="防止发生次生危害的预防措施">
              {msdsData.leakResponse?.preventSecondaryHazards || '-'}
            </Descriptions.Item>
          </Descriptions>
        </Card>
      )
    },
    {
      key: '7',
      label: '7. 操作处置与储存',
      children: (
        <Card 
          title="操作处置与储存" 
          extra={renderEditButton('handlingStorage')}
          loading={loading}
        >
          <Space direction="vertical" size="middle" style={{ width: '100%' }}>
            {/* 操作注意事项 */}
            <Card size="small" title="操作注意事项">
              <Descriptions column={1} bordered>
                <Descriptions.Item label="操作注意事项">
                  {msdsData.handlingStorage?.handlingPrecautions || '-'}
                </Descriptions.Item>
              </Descriptions>
            </Card>

            {/* 储存相关信息 */}
            <Card size="small" title="储存相关信息">
              <Descriptions column={2} bordered>
                <Descriptions.Item label="储存注意事项" span={2}>
                  {msdsData.handlingStorage?.storagePrecautions || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="最佳储存温度">
                  {msdsData.handlingStorage?.optimalTemperature || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="储存温度范围">
                  {msdsData.handlingStorage?.temperatureRange || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="湿度要求">
                  {msdsData.handlingStorage?.humidityRequirements || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="保质期">
                  {msdsData.handlingStorage?.shelfLife || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="储存容器要求" span={2}>
                  {msdsData.handlingStorage?.storageContainer || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="不相容的物质" span={2}>
                  {msdsData.handlingStorage?.incompatibleMaterials || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="储存区域要求" span={2}>
                  {msdsData.handlingStorage?.storageAreaRequirements || '-'}
                </Descriptions.Item>
              </Descriptions>
            </Card>
          </Space>
        </Card>
      )
    },
    {
      key: '8',
      label: '8. 接触控制/个体防护',
      children: (
        <Card 
          title="接触控制/个体防护" 
          extra={renderEditButton('exposureControl')}
          loading={loading}
        >
          <Space direction="vertical" size="middle" style={{ width: '100%' }}>
            {/* 接触限值 */}
            <Card size="small" title="职业接触限值">
              <Descriptions column={2} bordered>
                <Descriptions.Item label="职业接触限值" span={2}>
                  {msdsData.exposureControl?.occupationalExposureLimit || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="中国MAC(mg/m³)">
                  {msdsData.exposureControl?.chinaMac || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="美国TLV-TWA(mg/m³)">
                  {msdsData.exposureControl?.usaTlvTwa || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="美国TLV-STEL(mg/m³)">
                  {msdsData.exposureControl?.usaTlvStel || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="前苏联MAC(mg/m³)">
                  {msdsData.exposureControl?.formerSovietMac || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="TLV-TN(mg/m³)">
                  {msdsData.exposureControl?.tlvTn || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="TLV-WN(mg/m³)">
                  {msdsData.exposureControl?.tlvWn || '-'}
                </Descriptions.Item>
              </Descriptions>
            </Card>

            {/* 监测和工程控制 */}
            <Card size="small" title="监测和工程控制">
              <Descriptions column={1} bordered>
                <Descriptions.Item label="监测方法">
                  {msdsData.exposureControl?.monitoringMethod || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="工程控制措施">
                  {msdsData.exposureControl?.engineeringControls || '-'}
                </Descriptions.Item>
              </Descriptions>
            </Card>

            {/* 个体防护装备 */}
            <Card size="small" title="个体防护装备">
              <Descriptions column={2} bordered>
                <Descriptions.Item label="呼吸系统防护">
                  {msdsData.exposureControl?.respiratoryProtection || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="眼睛防护">
                  {msdsData.exposureControl?.eyeProtection || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="身体防护">
                  {msdsData.exposureControl?.bodyProtection || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="手部防护">
                  {msdsData.exposureControl?.handProtection || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="其他防护措施" span={2}>
                  {msdsData.exposureControl?.otherProtection || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="卫生措施" span={2}>
                  {msdsData.exposureControl?.hygieneMeasures || '-'}
                </Descriptions.Item>
              </Descriptions>
            </Card>
          </Space>
        </Card>
      )
    },
    {
      key: '9',
      label: '9. 理化特性',
      children: (
        <Card 
          title="理化特性" 
          extra={renderEditButton('physicalChemical')}
          loading={loading}
        >
          <Space direction="vertical" size="middle" style={{ width: '100%' }}>
            {/* 基本物理性质 */}
            <Card size="small" title="基本物理性质">
              <Descriptions column={2} bordered>
                <Descriptions.Item label="外观与性状">{msdsData.physicalChemical?.appearance || '-'}</Descriptions.Item>
                <Descriptions.Item label="气味">{msdsData.physicalChemical?.odor || '-'}</Descriptions.Item>
                <Descriptions.Item label="气味阈值">{msdsData.physicalChemical?.odorThreshold || '-'}</Descriptions.Item>
                <Descriptions.Item label="颜色">{msdsData.physicalChemical?.color || '-'}</Descriptions.Item>
              </Descriptions>
            </Card>

            {/* 温度相关性质 */}
            <Card size="small" title="温度相关性质">
              <Descriptions column={2} bordered>
                <Descriptions.Item label="熔点(℃)">{msdsData.physicalChemical?.meltingPoint || '-'}</Descriptions.Item>
                <Descriptions.Item label="沸点(℃)">{msdsData.physicalChemical?.boilingPoint || '-'}</Descriptions.Item>
                <Descriptions.Item label="闪点(℃)">{msdsData.physicalChemical?.flashPoint || '-'}</Descriptions.Item>
                <Descriptions.Item label="引燃温度(℃)">{msdsData.physicalChemical?.ignitionTemperature || '-'}</Descriptions.Item>
                <Descriptions.Item label="自燃温度">{msdsData.physicalChemical?.autoignitionTemperature || '-'}</Descriptions.Item>
                <Descriptions.Item label="分解温度(℃)">{msdsData.physicalChemical?.decompositionTemperature || '-'}</Descriptions.Item>
                <Descriptions.Item label="临界温度(℃)">{msdsData.physicalChemical?.criticalTemperature || '-'}</Descriptions.Item>
              </Descriptions>
            </Card>

            {/* 密度和压力性质 */}
            <Card size="small" title="密度和压力性质">
              <Descriptions column={2} bordered>
                <Descriptions.Item label="相对密度(水=1)">{msdsData.physicalChemical?.relativeDensity || '-'}</Descriptions.Item>
                <Descriptions.Item label="蒸气密度(空气=1)">{msdsData.physicalChemical?.vaporDensity || '-'}</Descriptions.Item>
                <Descriptions.Item label="蒸气压(kPa)">{msdsData.physicalChemical?.vaporPressure || '-'}</Descriptions.Item>
                <Descriptions.Item label="临界压力(MPa)">{msdsData.physicalChemical?.criticalPressure || '-'}</Descriptions.Item>
              </Descriptions>
            </Card>

            {/* 溶解性和其他性质 */}
            <Card size="small" title="溶解性和其他性质">
              <Descriptions column={2} bordered>
                <Descriptions.Item label="溶解性">{msdsData.physicalChemical?.solubility || '-'}</Descriptions.Item>
                <Descriptions.Item label="水中溶解度">{msdsData.physicalChemical?.waterSolubility || '-'}</Descriptions.Item>
                <Descriptions.Item label="pH值">{msdsData.physicalChemical?.phValue || '-'}</Descriptions.Item>
                <Descriptions.Item label="粘度">{msdsData.physicalChemical?.viscosity || '-'}</Descriptions.Item>
                <Descriptions.Item label="分配系数(正辛醇/水)">{msdsData.physicalChemical?.partitionCoefficient || '-'}</Descriptions.Item>
                <Descriptions.Item label="燃烧性">{msdsData.physicalChemical?.flammability || '-'}</Descriptions.Item>
                <Descriptions.Item label="爆炸下限(%)">{msdsData.physicalChemical?.explosiveLimitLower || '-'}</Descriptions.Item>
                <Descriptions.Item label="爆炸上限(%)">{msdsData.physicalChemical?.explosiveLimitUpper || '-'}</Descriptions.Item>
              </Descriptions>
            </Card>

            {/* 分子信息 */}
            <Card size="small" title="分子信息">
              <Descriptions column={2} bordered>
                <Descriptions.Item label="分子式">{msdsData.physicalChemical?.molecularFormula || '-'}</Descriptions.Item>
                <Descriptions.Item label="分子量">{msdsData.physicalChemical?.molecularWeight || '-'}</Descriptions.Item>
                <Descriptions.Item label="主要成分" span={2}>{msdsData.physicalChemical?.mainComponents || '-'}</Descriptions.Item>
                <Descriptions.Item label="主要用途" span={2}>{msdsData.physicalChemical?.mainUsage || '-'}</Descriptions.Item>
                <Descriptions.Item label="其它理化性质" span={2}>{msdsData.physicalChemical?.otherProperties || '-'}</Descriptions.Item>
              </Descriptions>
            </Card>
          </Space>
        </Card>
      )
    },
    {
      key: '10',
      label: '10. 稳定性和反应性',
      children: (
        <Card 
          title="稳定性和反应性" 
          extra={renderEditButton('stabilityReactivity')}
          loading={loading}
        >
          <Descriptions column={1} bordered>
            <Descriptions.Item label="稳定性">
              {msdsData.stabilityReactivity?.stability || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="反应性">
              {msdsData.stabilityReactivity?.reactivity || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="禁配物">
              {msdsData.stabilityReactivity?.incompatibleSubstances || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="避免接触的条件">
              {msdsData.stabilityReactivity?.conditionsToAvoid || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="可能的危险反应">
              {msdsData.stabilityReactivity?.hazardousReactions || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="聚合危害">
              {msdsData.stabilityReactivity?.polymerizationHazard || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="聚合反应条件">
              {msdsData.stabilityReactivity?.polymerizationConditions || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="分解产物">
              {msdsData.stabilityReactivity?.decompositionProducts || '-'}
            </Descriptions.Item>
            <Descriptions.Item label="分解条件">
              {msdsData.stabilityReactivity?.decompositionConditions || '-'}
            </Descriptions.Item>
          </Descriptions>
        </Card>
      )
    },
    {
      key: '11',
      label: '11. 毒理学信息',
      children: (
        <Card 
          title="毒理学信息" 
          extra={renderEditButton('toxicological')}
          loading={loading}
        >
          <Space direction="vertical" size="middle" style={{ width: '100%' }}>
            {/* 急性毒性 */}
            <Card size="small" title="急性毒性">
              <Descriptions column={2} bordered>
                <Descriptions.Item label="急性毒性" span={2}>
                  {msdsData.toxicological?.acuteToxicity || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="LD50(经口,大鼠)">
                  {msdsData.toxicological?.ld50Oral || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="LD50(经皮,兔)">
                  {msdsData.toxicological?.ld50Dermal || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="LC50(吸入,大鼠)" span={2}>
                  {msdsData.toxicological?.lc50Inhalation || '-'}
                </Descriptions.Item>
              </Descriptions>
            </Card>

            {/* 慢性毒性和刺激性 */}
            <Card size="small" title="慢性毒性和刺激性">
              <Descriptions column={2} bordered>
                <Descriptions.Item label="亚急性和慢性毒性" span={2}>
                  {msdsData.toxicological?.subacuteChronic || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="皮肤刺激性">
                  {msdsData.toxicological?.skinIrritation || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="眼睛刺激性">
                  {msdsData.toxicological?.eyeIrritation || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="呼吸道刺激性">
                  {msdsData.toxicological?.respiratoryIrritation || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="致敏性">
                  {msdsData.toxicological?.sensitization || '-'}
                </Descriptions.Item>
              </Descriptions>
            </Card>

            {/* 特殊毒性 */}
            <Card size="small" title="特殊毒性">
              <Descriptions column={2} bordered>
                <Descriptions.Item label="致突变性">
                  {msdsData.toxicological?.mutagenicity || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="致畸性">
                  {msdsData.toxicological?.teratogenicity || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="生殖毒性">
                  {msdsData.toxicological?.reproductiveToxicity || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="致癌性">
                  {msdsData.toxicological?.carcinogenicity || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="致癌物分类">
                  {msdsData.toxicological?.carcinogenClassification || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="特定目标器官毒性">
                  {msdsData.toxicological?.specificTargetOrgan || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="吸入危害">
                  {msdsData.toxicological?.aspirationHazard || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="RTECS编号">
                  {msdsData.toxicological?.rtecs || '-'}
                </Descriptions.Item>
              </Descriptions>
            </Card>

            {/* 其他毒理学资料 */}
            <Card size="small" title="其他毒理学资料">
              <Descriptions column={1} bordered>
                <Descriptions.Item label="其他毒理学资料">
                  {msdsData.toxicological?.otherToxicity || '-'}
                </Descriptions.Item>
              </Descriptions>
            </Card>
          </Space>
        </Card>
      )
    },
    {
      key: '12',
      label: '12. 生态学资料',
      children: (
        <Card 
          title="生态学资料" 
          extra={renderEditButton('ecological')}
          loading={loading}
        >
          <Space direction="vertical" size="middle" style={{ width: '100%' }}>
            {/* 生态毒性 */}
            <Card size="small" title="生态毒性">
              <Descriptions column={2} bordered>
                <Descriptions.Item label="生态毒性" span={2}>
                  {msdsData.ecological?.ecologicalToxicity || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="鱼类毒性">
                  {msdsData.ecological?.fishToxicity || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="无脊椎动物毒性">
                  {msdsData.ecological?.invertebrateToxicity || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="藻类毒性">
                  {msdsData.ecological?.algaeToxicity || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="细菌毒性">
                  {msdsData.ecological?.bacteriaToxicity || '-'}
                </Descriptions.Item>
              </Descriptions>
            </Card>

            {/* 生物降解性 */}
            <Card size="small" title="生物降解性">
              <Descriptions column={2} bordered>
                <Descriptions.Item label="生物降解性" span={2}>
                  {msdsData.ecological?.biodegradability || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="生物降解速率">
                  {msdsData.ecological?.biodegradationRate || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="非生物降解性">
                  {msdsData.ecological?.nonBiodegradability || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="光降解">
                  {msdsData.ecological?.photodegradation || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="水解">
                  {msdsData.ecological?.hydrolysis || '-'}
                </Descriptions.Item>
              </Descriptions>
            </Card>

            {/* 生物富集和环境影响 */}
            <Card size="small" title="生物富集和环境影响">
              <Descriptions column={2} bordered>
                <Descriptions.Item label="生物富集或生物积累性" span={2}>
                  {msdsData.ecological?.bioaccumulation || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="生物富集因子">
                  {msdsData.ecological?.bioconcentrationFactor || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="土壤中迁移性">
                  {msdsData.ecological?.mobilityInSoil || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="其它有害作用" span={2}>
                  {msdsData.ecological?.otherEnvironmentalEffects || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="臭氧消耗潜能值">
                  {msdsData.ecological?.ozoneDepletionPotential || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="全球变暖潜能值">
                  {msdsData.ecological?.globalWarmingPotential || '-'}
                </Descriptions.Item>
              </Descriptions>
            </Card>
          </Space>
        </Card>
      )
    },
    {
      key: '13',
      label: '13. 废弃处置',
      children: (
        <Card 
          title="废弃处置" 
          extra={renderEditButton('disposal')}
          loading={loading}
        >
          <Space direction="vertical" size="middle" style={{ width: '100%' }}>
            {/* 废弃物性质和处置方法 */}
            <Card size="small" title="废弃物处置">
              <Descriptions column={2} bordered>
                <Descriptions.Item label="废弃物性质" span={2}>
                  {msdsData.disposal?.wasteProperties || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="废弃处置方法" span={2}>
                  {msdsData.disposal?.disposalMethod || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="推荐的处置方法">
                  {msdsData.disposal?.recommendedDisposal || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="禁止的处置方法">
                  {msdsData.disposal?.prohibitedDisposal || '-'}
                </Descriptions.Item>
              </Descriptions>
            </Card>

            {/* 注意事项和法规 */}
            <Card size="small" title="注意事项和法规">
              <Descriptions column={1} bordered>
                <Descriptions.Item label="废弃注意事项">
                  {msdsData.disposal?.disposalPrecautions || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="废弃处置相关法规">
                  {msdsData.disposal?.disposalRegulations || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="包装容器的处置">
                  {msdsData.disposal?.containerDisposal || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="中和处理方法">
                  {msdsData.disposal?.neutralizationMethod || '-'}
                </Descriptions.Item>
              </Descriptions>
            </Card>
          </Space>
        </Card>
      )
    },
    {
      key: '14',
      label: '14. 运输信息',
      children: (
        <Card 
          title="运输信息" 
          extra={renderEditButton('transportation')}
          loading={loading}
        >
          <Space direction="vertical" size="middle" style={{ width: '100%' }}>
            {/* 基本运输信息 */}
            <Card size="small" title="基本运输信息">
              <Descriptions column={2} bordered>
                <Descriptions.Item label="危险货物编号">
                  {msdsData.transportation?.dangerousGoodsNumber || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="UN编号">
                  {msdsData.transportation?.unNumber || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="正确运输名称" span={2}>
                  {msdsData.transportation?.properShippingName || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="运输危险类别">
                  {msdsData.transportation?.transportHazardClass || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="包装类别">
                  {msdsData.transportation?.packingGroup || '-'}
                </Descriptions.Item>
              </Descriptions>
            </Card>

            {/* 包装信息 */}
            <Card size="small" title="包装信息">
              <Descriptions column={1} bordered>
                <Descriptions.Item label="包装标志">
                  {msdsData.transportation?.packagingMarks || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="包装方法">
                  {msdsData.transportation?.packagingMethod || '-'}
                </Descriptions.Item>
              </Descriptions>
            </Card>

            {/* 运输要求 */}
            <Card size="small" title="运输要求">
              <Descriptions column={2} bordered>
                <Descriptions.Item label="海洋污染物">
                  <Tag color={msdsData.transportation?.marinePollutant ? 'red' : 'green'}>
                    {msdsData.transportation?.marinePollutant ? '是' : '否'}
                  </Tag>
                </Descriptions.Item>
                <Descriptions.Item label="应急响应指南编号">
                  {msdsData.transportation?.emergencyResponseGuide || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="散装运输要求" span={2}>
                  {msdsData.transportation?.transportInBulk || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="运输注意事项" span={2}>
                  {msdsData.transportation?.transportationPrecautions || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="IMDG规则页码">
                  {msdsData.transportation?.imdgRulePage || '-'}
                </Descriptions.Item>
              </Descriptions>
            </Card>
          </Space>
        </Card>
      )
    },
    {
      key: '15',
      label: '15. 法规信息',
      children: (
        <Card 
          title="法规信息" 
          extra={renderEditButton('regulatory')}
          loading={loading}
        >
          <Space direction="vertical" size="middle" style={{ width: '100%' }}>
            {/* 国内法规 */}
            <Card size="small" title="国内法规">
              <Descriptions column={2} bordered>
                <Descriptions.Item label="法规信息综述" span={2}>
                  {msdsData.regulatory?.regulatoryInfo || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="国内法规" span={2}>
                  {msdsData.regulatory?.domesticRegulations || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="中国危险化学品目录">
                  <Tag color={msdsData.regulatory?.chinaDangerousChemicals ? 'red' : 'green'}>
                    {msdsData.regulatory?.chinaDangerousChemicals ? '在列' : '不在列'}
                  </Tag>
                </Descriptions.Item>
                <Descriptions.Item label="中国管制化学品">
                  <Tag color={msdsData.regulatory?.chinaControlledChemicals ? 'orange' : 'green'}>
                    {msdsData.regulatory?.chinaControlledChemicals ? '是' : '否'}
                  </Tag>
                </Descriptions.Item>
              </Descriptions>
            </Card>

            {/* 国际法规 */}
            <Card size="small" title="国际法规">
              <Descriptions column={2} bordered>
                <Descriptions.Item label="国际法规" span={2}>
                  {msdsData.regulatory?.internationalRegulations || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="REACH注册情况" span={2}>
                  {msdsData.regulatory?.reachRegistration || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="TSCA清单">
                  <Tag color={msdsData.regulatory?.tscaInventory ? 'blue' : 'default'}>
                    {msdsData.regulatory?.tscaInventory ? '在列' : '不在列'}
                  </Tag>
                </Descriptions.Item>
                <Descriptions.Item label="EINECS号">
                  {msdsData.regulatory?.einecsNumber || '-'}
                </Descriptions.Item>
              </Descriptions>
            </Card>

            {/* 特殊规定 */}
            <Card size="small" title="特殊规定">
              <Descriptions column={1} bordered>
                <Descriptions.Item label="禁用/限用情况">
                  {msdsData.regulatory?.prohibitedRestricted || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="特殊规定">
                  {msdsData.regulatory?.specialProvisions || '-'}
                </Descriptions.Item>
              </Descriptions>
            </Card>
          </Space>
        </Card>
      )
    },
    {
      key: '16',
      label: '16. 其他信息',
      children: (
        <Card 
          title="其他信息" 
          extra={renderEditButton('otherInfo')}
          loading={loading}
        >
          <Space direction="vertical" size="middle" style={{ width: '100%' }}>
            {/* 编制信息 */}
            <Card size="small" title="编制信息">
              <Descriptions column={2} bordered>
                <Descriptions.Item label="填表时间">
                  {msdsData.otherInfo?.formFillTime || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="填表部门">
                  {msdsData.otherInfo?.formFillDepartment || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="填表人">
                  {msdsData.otherInfo?.formFillPerson || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="数据审核单位">
                  {msdsData.otherInfo?.dataAuditUnit || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="数据审核人">
                  {msdsData.otherInfo?.dataAuditPerson || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="技术审查人">
                  {msdsData.otherInfo?.technicalReviewPerson || '-'}
                </Descriptions.Item>
              </Descriptions>
            </Card>

            {/* 参考信息 */}
            <Card size="small" title="参考信息">
              <Descriptions column={1} bordered>
                <Descriptions.Item label="参考文献">
                  {msdsData.otherInfo?.references || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="数据来源">
                  {msdsData.otherInfo?.dataSources || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="修改说明">
                  {msdsData.otherInfo?.modificationNotes || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="培训要求">
                  {msdsData.otherInfo?.trainingRequirements || '-'}
                </Descriptions.Item>
              </Descriptions>
            </Card>

            {/* 其他说明 */}
            <Card size="small" title="其他说明">
              <Descriptions column={1} bordered>
                <Descriptions.Item label="其他信息">
                  {msdsData.otherInfo?.additionalInformation || '-'}
                </Descriptions.Item>
                <Descriptions.Item label="免责声明">
                  {msdsData.otherInfo?.disclaimer || '-'}
                </Descriptions.Item>
              </Descriptions>
            </Card>
          </Space>
        </Card>
      )
    },
  ];

  return (
    <div>
      {/* 数据完整性进度条 */}
      <Card style={{ marginBottom: 16 }}>
        <Space direction="vertical" style={{ width: '100%' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <span>数据完整度</span>
            <span>85%</span>
          </div>
          <Progress 
            percent={85} 
            status="active"
            strokeColor={{
              '0%': '#108ee9',
              '100%': '#87d068',
            }}
          />
          <div style={{ fontSize: '12px', color: '#666' }}>
            <CheckCircleOutlined style={{ color: '#52c41a', marginRight: 4 }} />
            12个章节数据完整
            <ExclamationCircleOutlined style={{ color: '#faad14', marginLeft: 12, marginRight: 4 }} />
            4个章节数据不完整
          </div>
        </Space>
      </Card>

      {/* Tab页面 */}
      <Tabs
        activeKey={activeTab}
        onChange={setActiveTab}
        items={tabItems}
        tabPosition="left"
        style={{ minHeight: 400 }}
      />
    </div>
  );
};

export default MsdsDetail;
