import React, { useState, useEffect, useRef } from 'react';
import { 
  Steps, 
  Card, 
  Button, 
  Space, 
  message, 
  Progress, 
  Affix,
  Drawer,
  Tooltip,
  Badge
} from 'antd';
import { 
  SaveOutlined, 
  ArrowLeftOutlined, 
  ArrowRightOutlined,
  CheckCircleOutlined,
  ExclamationCircleOutlined,
  CloseOutlined
} from '@ant-design/icons';
import type { API } from '@/types/msds';
import { 
  getMsdsDetail,
  getHazardByMsdsId,
  getComponentByMsdsId,
  getFirstAidByMsdsId,
  getFireFightingByMsdsId,
  getLeakResponseByMsdsId,
  getHandlingByMsdsId,
  getExposureByMsdsId,
  getPhysicalChemicalByMsdsId,
  getStabilityReactivityByMsdsId,
  getToxicologyByMsdsId,
  getEcologyByMsdsId,
  getDisposalByMsdsId,
  getTransportByMsdsId,
  getRegulatoryByMsdsId,
  getOtherInfoByMsdsId
} from '@/services/msds';

// 导入各步骤表单组件
import Step1BasicInfo from './steps/Step1BasicInfo';
import Step2HazardOverview from './steps/Step2HazardOverview';
import Step3ComponentInfo from './steps/Step3ComponentInfo';
import Step4FirstAid from './steps/Step4FirstAid';
import Step5FireFighting from './steps/Step5FireFighting';
import Step6LeakResponse from './steps/Step6LeakResponse';
import Step7HandlingStorage from './steps/Step7HandlingStorage';
import Step8ExposureControl from './steps/Step8ExposureControl';
import Step9PhysicalChemical from './steps/Step9PhysicalChemical';
import Step10StabilityReactivity from './steps/Step10StabilityReactivity';
import Step11Toxicological from './steps/Step11Toxicological';
import Step12Ecological from './steps/Step12Ecological';
import Step13Disposal from './steps/Step13Disposal';
import Step14Transportation from './steps/Step14Transportation';
import Step15Regulatory from './steps/Step15Regulatory';
import Step16OtherInfo from './steps/Step16OtherInfo';

export interface MsdsStepFormProps {
  open: boolean;
  onClose: () => void;
  msdsId?: number;
  initialStep?: number;
  onSave?: (data: any) => Promise<boolean>;
}

// 步骤配置
const stepConfig = [
  { key: 'basic', title: '基本信息', description: '化学品及企业标识', icon: '1️⃣' },
  { key: 'hazard', title: '危险性概述', description: '危险性分类与标识', icon: '⚠️' },
  { key: 'component', title: '成分信息', description: '成分/组成信息', icon: '🧪' },
  { key: 'firstAid', title: '急救措施', description: '急救处理方法', icon: '🏥' },
  { key: 'fireFighting', title: '消防措施', description: '灭火方法和防护', icon: '🚒' },
  { key: 'leakResponse', title: '泄漏应急', description: '泄漏应急处理', icon: '🚨' },
  { key: 'handlingStorage', title: '操作储存', description: '操作处置与储存', icon: '📦' },
  { key: 'exposureControl', title: '接触控制', description: '接触控制/个体防护', icon: '🛡️' },
  { key: 'physicalChemical', title: '理化特性', description: '理化特性', icon: '⚗️' },
  { key: 'stabilityReactivity', title: '稳定性反应', description: '稳定性和反应性', icon: '⚡' },
  { key: 'toxicological', title: '毒理学资料', description: '毒理学信息', icon: '☠️' },
  { key: 'ecological', title: '生态学资料', description: '生态学信息', icon: '🌱' },
  { key: 'disposal', title: '废弃处置', description: '废弃处置', icon: '♻️' },
  { key: 'transportation', title: '运输信息', description: '运输信息', icon: '🚛' },
  { key: 'regulatory', title: '法规信息', description: '法规信息', icon: '📋' },
  { key: 'otherInfo', title: '其他信息', description: '其他信息', icon: '📝' }
];

const MsdsStepForm: React.FC<MsdsStepFormProps> = ({
  open,
  onClose,
  msdsId,
  initialStep = 0,
  onSave
}) => {
  const [currentStep, setCurrentStep] = useState(initialStep);
  const [formData, setFormData] = useState<any>({});
  const [stepStatus, setStepStatus] = useState<Record<number, 'wait' | 'process' | 'finish' | 'error'>>({});
  const [stepValidation, setStepValidation] = useState<Record<number, boolean>>({});
  const [loading, setLoading] = useState(false);
  const [autoSaving, setAutoSaving] = useState(false);
  const formRefs = useRef<Record<number, any>>({});

  // 计算总体完成度
  const completionRate = Math.round((Object.values(stepValidation).filter(Boolean).length / stepConfig.length) * 100);

  useEffect(() => {
    if (open && msdsId) {
      loadMsdsData();
    }
  }, [open, msdsId]);

  // 加载MSDS数据
  const loadMsdsData = async () => {
    if (!msdsId) {
      console.log('🔍 [MsdsStepForm] msdsId为空，跳过数据加载');
      return;
    }
    
    console.log('🔍 [MsdsStepForm] 开始加载MSDS数据, msdsId:', msdsId);
    setLoading(true);
    try {
      // 并行加载所有章节数据
      const [
        mainResponse,
        hazardResponse,
        componentResponse,
        firstAidResponse,
        fireFightingResponse,
        leakResponseResponse,
        handlingResponse,
        exposureResponse,
        physicalChemicalResponse,
        stabilityReactivityResponse,
        toxicologyResponse,
        ecologyResponse,
        disposalResponse,
        transportResponse,
        regulatoryResponse,
        otherInfoResponse
      ] = await Promise.all([
        getMsdsDetail(msdsId),
        getHazardByMsdsId(msdsId),
        getComponentByMsdsId(msdsId),
        getFirstAidByMsdsId(msdsId),
        getFireFightingByMsdsId(msdsId),
        getLeakResponseByMsdsId(msdsId),
        getHandlingByMsdsId(msdsId),
        getExposureByMsdsId(msdsId),
        getPhysicalChemicalByMsdsId(msdsId),
        getStabilityReactivityByMsdsId(msdsId),
        getToxicologyByMsdsId(msdsId),
        getEcologyByMsdsId(msdsId),
        getDisposalByMsdsId(msdsId),
        getTransportByMsdsId(msdsId),
        getRegulatoryByMsdsId(msdsId),
        getOtherInfoByMsdsId(msdsId)
      ]);

      // 组装完整的表单数据
      const completeData: any = {};
      
      console.log('🔍 [MsdsStepForm] API响应数据:', {
        main: mainResponse,
        hazard: hazardResponse,
        component: componentResponse,
      });

      if (mainResponse.code === 200 && mainResponse.data) {
        console.log('✅ [MsdsStepForm] 加载基本信息:', mainResponse.data);
        completeData.basic = mainResponse.data;
      } else {
        console.warn('⚠️ [MsdsStepForm] 基本信息加载失败:', mainResponse);
      }

      if (hazardResponse.code === 200 && hazardResponse.data) {
        completeData.hazard = hazardResponse.data;
      }

      if (componentResponse.code === 200 && componentResponse.data) {
        completeData.component = componentResponse.data;
      }

      if (firstAidResponse.code === 200 && firstAidResponse.data) {
        completeData.firstAid = firstAidResponse.data;
      }

      if (fireFightingResponse.code === 200 && fireFightingResponse.data) {
        completeData.fireFighting = fireFightingResponse.data;
      }

      if (leakResponseResponse.code === 200 && leakResponseResponse.data) {
        completeData.leakResponse = leakResponseResponse.data;
      }

      if (handlingResponse.code === 200 && handlingResponse.data) {
        completeData.handlingStorage = handlingResponse.data;
      }

      if (exposureResponse.code === 200 && exposureResponse.data) {
        completeData.exposureControl = exposureResponse.data;
      }

      if (physicalChemicalResponse.code === 200 && physicalChemicalResponse.data) {
        completeData.physicalChemical = physicalChemicalResponse.data;
      }

      if (stabilityReactivityResponse.code === 200 && stabilityReactivityResponse.data) {
        completeData.stabilityReactivity = stabilityReactivityResponse.data;
      }

      if (toxicologyResponse.code === 200 && toxicologyResponse.data) {
        completeData.toxicological = toxicologyResponse.data;
      }

      if (ecologyResponse.code === 200 && ecologyResponse.data) {
        completeData.ecological = ecologyResponse.data;
      }

      if (disposalResponse.code === 200 && disposalResponse.data) {
        completeData.disposal = disposalResponse.data;
      }

      if (transportResponse.code === 200 && transportResponse.data) {
        completeData.transportation = transportResponse.data;
      }

      if (regulatoryResponse.code === 200 && regulatoryResponse.data) {
        completeData.regulatory = regulatoryResponse.data;
      }

      if (otherInfoResponse.code === 200 && otherInfoResponse.data) {
        completeData.otherInfo = otherInfoResponse.data;
      }

      // 设置表单数据
      console.log('📦 [MsdsStepForm] 组装后的完整数据:', completeData);
      setFormData(completeData);

      // 初始化步骤状态 - 已有数据的步骤标记为完成
      const initialStepStatus: Record<number, 'wait' | 'process' | 'finish' | 'error'> = {};
      const initialValidation: Record<number, boolean> = {};

      stepConfig.forEach((step, index) => {
        if (completeData[step.key]) {
          console.log(`✅ [MsdsStepForm] 步骤${index + 1}(${step.key})已有数据`);
          initialStepStatus[index] = 'finish';
          initialValidation[index] = true;
        } else {
          console.log(`⚪ [MsdsStepForm] 步骤${index + 1}(${step.key})无数据`);
        }
      });

      setStepStatus(initialStepStatus);
      setStepValidation(initialValidation);

      console.log('✅ [MsdsStepForm] 数据加载完成，已加载章节数:', Object.keys(completeData).length);
      message.success(`数据加载成功，已加载${Object.keys(completeData).length}个章节`);
    } catch (error) {
      console.error('加载MSDS数据失败:', error);
      message.error('加载数据失败，请稍后重试');
    } finally {
      setLoading(false);
    }
  };

  // 自动保存
  const autoSave = async (stepIndex: number, data: any) => {
    if (!msdsId) return;
    
    setAutoSaving(true);
    try {
      const updatedData = { ...formData, [stepConfig[stepIndex].key]: data };
      setFormData(updatedData);
      
      // TODO: 调用API保存数据
      if (onSave) {
        await onSave(updatedData);
      }
      
      // 更新步骤状态
      setStepStatus(prev => ({ ...prev, [stepIndex]: 'finish' }));
      
    } catch (error) {
      message.error('自动保存失败');
      setStepStatus(prev => ({ ...prev, [stepIndex]: 'error' }));
    } finally {
      setAutoSaving(false);
    }
  };

  // 步骤验证
  const validateStep = (stepIndex: number): boolean => {
    const formRef = formRefs.current[stepIndex];
    if (formRef && formRef.validateFields) {
      try {
        formRef.validateFields();
        setStepValidation(prev => ({ ...prev, [stepIndex]: true }));
        return true;
      } catch (error) {
        setStepValidation(prev => ({ ...prev, [stepIndex]: false }));
        return false;
      }
    }
    return true;
  };

  // 下一步
  const handleNext = async () => {
    const isValid = validateStep(currentStep);
    if (isValid && currentStep < stepConfig.length - 1) {
      setCurrentStep(currentStep + 1);
    }
  };

  // 上一步
  const handlePrev = () => {
    if (currentStep > 0) {
      setCurrentStep(currentStep - 1);
    }
  };

  // 跳转到指定步骤
  const handleStepChange = (step: number) => {
    setCurrentStep(step);
  };

  // 渲染当前步骤的表单组件
  const renderStepContent = () => {
    const stepKey = stepConfig[currentStep].key;
    const stepData = formData[stepKey] || {};
    
    const commonProps = {
      data: stepData,
      onChange: (data: any) => autoSave(currentStep, data),
      ref: (ref: any) => { formRefs.current[currentStep] = ref; }
    };

    switch (stepKey) {
      case 'basic':
        return <Step1BasicInfo {...commonProps} />;
      case 'hazard':
        return <Step2HazardOverview {...commonProps} />;
      case 'component':
        return <Step3ComponentInfo {...commonProps} />;
      case 'firstAid':
        return <Step4FirstAid {...commonProps} />;
      case 'fireFighting':
        return <Step5FireFighting {...commonProps} />;
      case 'leakResponse':
        return <Step6LeakResponse {...commonProps} />;
      case 'handlingStorage':
        return <Step7HandlingStorage {...commonProps} />;
      case 'exposureControl':
        return <Step8ExposureControl {...commonProps} />;
      case 'physicalChemical':
        return <Step9PhysicalChemical {...commonProps} />;
      case 'stabilityReactivity':
        return <Step10StabilityReactivity {...commonProps} />;
      case 'toxicological':
        return <Step11Toxicological {...commonProps} />;
      case 'ecological':
        return <Step12Ecological {...commonProps} />;
      case 'disposal':
        return <Step13Disposal {...commonProps} />;
      case 'transportation':
        return <Step14Transportation {...commonProps} />;
      case 'regulatory':
        return <Step15Regulatory {...commonProps} />;
      case 'otherInfo':
        return <Step16OtherInfo {...commonProps} />;
      default:
        return <div>未知步骤</div>;
    }
  };

  return (
    <Drawer
      title={
        <Space>
          <span>MSDS编辑向导</span>
          <Badge count={`${currentStep + 1}/${stepConfig.length}`} />
          <Progress 
            percent={completionRate} 
            size="small" 
            style={{ width: 100 }}
            format={() => `${completionRate}%`}
          />
        </Space>
      }
      width="90%"
      open={open}
      onClose={onClose}
      maskClosable={false}
      extra={
        <Space>
          {autoSaving && <span style={{ color: '#1890ff' }}>自动保存中...</span>}
          <Button icon={<CloseOutlined />} onClick={onClose}>
            关闭
          </Button>
        </Space>
      }
    >
      <div style={{ display: 'flex', height: '100%' }}>
        {/* 左侧步骤导航 */}
        <div style={{ width: 280, borderRight: '1px solid #f0f0f0', paddingRight: 16 }}>
          <Affix offsetTop={20}>
            <Card size="small" title="编辑进度">
              <Steps
                direction="vertical"
                size="small"
                current={currentStep}
                onChange={handleStepChange}
                items={stepConfig.map((step, index) => ({
                  title: (
                    <Space>
                      <span>{step.icon}</span>
                      <span>{step.title}</span>
                      {stepValidation[index] && <CheckCircleOutlined style={{ color: '#52c41a' }} />}
                      {stepStatus[index] === 'error' && <ExclamationCircleOutlined style={{ color: '#ff4d4f' }} />}
                    </Space>
                  ),
                  description: step.description,
                  status: stepStatus[index] || (index === currentStep ? 'process' : 'wait')
                }))}
              />
            </Card>
          </Affix>
        </div>

        {/* 右侧表单内容 */}
        <div style={{ flex: 1, paddingLeft: 24, display: 'flex', flexDirection: 'column' }}>
          {/* 步骤标题 */}
          <Card 
            size="small" 
            style={{ marginBottom: 16 }}
            title={
              <Space>
                <span style={{ fontSize: '18px' }}>{stepConfig[currentStep].icon}</span>
                <span style={{ fontSize: '16px', fontWeight: 'bold' }}>
                  第{currentStep + 1}节：{stepConfig[currentStep].title}
                </span>
              </Space>
            }
            extra={
              <Space>
                <Tooltip title="上一步">
                  <Button 
                    icon={<ArrowLeftOutlined />}
                    onClick={handlePrev}
                    disabled={currentStep === 0}
                  />
                </Tooltip>
                <Tooltip title="下一步">
                  <Button 
                    type="primary"
                    icon={<ArrowRightOutlined />}
                    onClick={handleNext}
                    disabled={currentStep === stepConfig.length - 1}
                  />
                </Tooltip>
              </Space>
            }
          >
            <div style={{ color: '#666' }}>
              {stepConfig[currentStep].description}
            </div>
          </Card>

          {/* 表单内容区域 */}
          <div style={{ flex: 1, overflow: 'auto' }}>
            {renderStepContent()}
          </div>

          {/* 底部操作栏 */}
          <Affix offsetBottom={0}>
            <Card size="small" style={{ marginTop: 16, borderTop: '1px solid #f0f0f0' }}>
              <Space style={{ width: '100%', justifyContent: 'space-between' }}>
                <Button 
                  icon={<ArrowLeftOutlined />}
                  onClick={handlePrev}
                  disabled={currentStep === 0}
                >
                  上一步
                </Button>
                
                <Space>
                  <span style={{ color: '#666' }}>
                    第 {currentStep + 1} 步，共 {stepConfig.length} 步
                  </span>
                  <Progress 
                    percent={Math.round(((currentStep + 1) / stepConfig.length) * 100)} 
                    size="small" 
                    style={{ width: 100 }}
                  />
                </Space>

                {currentStep === stepConfig.length - 1 ? (
                  <Button 
                    type="primary"
                    icon={<SaveOutlined />}
                    loading={loading}
                    onClick={() => {
                      validateStep(currentStep);
                      message.success('MSDS编辑完成！');
                      onClose();
                    }}
                  >
                    完成编辑
                  </Button>
                ) : (
                  <Button 
                    type="primary"
                    icon={<ArrowRightOutlined />}
                    onClick={handleNext}
                  >
                    下一步
                  </Button>
                )}
              </Space>
            </Card>
          </Affix>
        </div>
      </div>
    </Drawer>
  );
};

export default MsdsStepForm;