import React, { useState, useEffect, forwardRef, useImperativeHandle } from 'react';
import { message } from 'antd';
import * as regulatoryApi from '@/services/msds/regulatory';
import {
  Form,
  Input,
  Select,
  Card,
  Row,
  Col,
  Switch,
  Space,
  Typography,
  Tooltip,
  Tag,
  Alert,
  List,
  Button,
  Divider
} from 'antd';
import { 
  InfoCircleOutlined, 
  FileTextOutlined, 
  WarningOutlined, 
  GlobalOutlined,
  SafetyOutlined,
  ExclamationCircleOutlined,
  BookOutlined
} from '@ant-design/icons';

const { TextArea } = Input;
const { Option } = Select;
const { Title, Text } = Typography;

export interface Step15RegulatoryProps {
  data?: any;
  onChange?: (data: any) => void;
}

const Step15Regulatory = forwardRef<any, Step15RegulatoryProps>(
  ({ data = {}, onChange }, ref) => {
    const [form] = Form.useForm();
    const [formData, setFormData] = useState(data);

    useImperativeHandle(ref, () => ({
      validateFields: () => form.validateFields(),
      resetFields: () => form.resetFields(),
      getFieldsValue: () => form.getFieldsValue(),
      setFieldsValue: (values: any) => form.setFieldsValue(values)
    }));

    useEffect(() => {
      form.setFieldsValue(formData);
    }, [formData, form]);

    const handleFieldChange = (changedFields: any, allFields: any) => {
      const newData = { ...formData, ...allFields };
      setFormData(newData);
      onChange?.(newData);
    };

    // 中国法规选项
    const chinaRegulations = [
      '《危险化学品安全管理条例》',
      '《危险化学品目录》',
      '《危险化学品登记管理办法》',
      '《危险化学品经营许可证管理办法》',
      '《危险化学品生产企业安全生产许可证实施办法》',
      '《化学品物理危险性鉴定与分类管理办法》',
      '《新化学物质环境管理登记办法》',
      '《职业病防治法》',
      '《安全生产法》',
      '《环境保护法》',
      '《固体废物污染环境防治法》',
      '《大气污染防治法》',
      '《水污染防治法》'
    ];

    // 国际法规选项
    const internationalRegulations = [
      'GHS (全球化学品统一分类和标签制度)',
      'REACH (欧盟化学品注册、评估、许可和限制法规)',
      'CLP (欧盟物质和混合物分类、标签和包装法规)',
      'OSHA HCS (美国职业安全健康署危害沟通标准)',
      'WHMIS (加拿大工作场所危险物质信息系统)',
      'ADR (欧洲危险货物道路运输协定)',
      'IATA DGR (国际航空运输协会危险品规则)',
      'IMDG Code (国际海运危险品规则)',
      'Basel Convention (巴塞尔公约)',
      'Stockholm Convention (斯德哥尔摩公约)',
      'Rotterdam Convention (鹿特丹公约)',
      'Montreal Protocol (蒙特利尔议定书)'
    ];

    // 限制清单选项
    const restrictionLists = [
      '《危险化学品目录》',
      '《重点监管的危险化学品名录》',
      '《特别管控危险化学品目录》',
      '《易制毒化学品管理条例》',
      '《易制爆危险化学品名录》',
      '《剧毒化学品目录》',
      '《中国严格限制进出口的有毒化学品目录》',
      '《中国禁止进出口的有毒化学品目录》',
      '《限制使用农药名录》',
      '《淘汰落后危险化学品安全生产工艺技术设备目录》'
    ];

    // 许可要求选项
    const permitRequirements = [
      '危险化学品生产许可证',
      '危险化学品经营许可证',
      '危险化学品安全使用许可证',
      '危险化学品登记证',
      '新化学物质环境管理登记证',
      '排污许可证',
      '辐射安全许可证',
      '进出口许可证',
      '运输许可证',
      '储存许可证'
    ];

    return (
      <div style={{ padding: '24px', backgroundColor: '#f8f9fa' }}>
        <Card>
          <div style={{ marginBottom: '24px' }}>
            <Title level={4} style={{ color: '#1890ff', marginBottom: '8px' }}>
              <FileTextOutlined style={{ marginRight: '8px' }} />
              第15节：法规信息
            </Title>
            <Text type="secondary">
              包含法规分类、限制清单、许可要求等法规相关信息
            </Text>
          </div>

          <Form
            form={form}
            layout="vertical"
            onValuesChange={handleFieldChange}
            initialValues={formData}
          >
            {/* 中国法规 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                <BookOutlined style={{ marginRight: '8px' }} />
                中国法规
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label="适用的中国法规"
                    name="applicableChinaRegulations"
                  >
                    <Select
                      mode="multiple"
                      placeholder="选择适用的中国法规"
                      style={{ width: '100%' }}
                    >
                      {chinaRegulations.map(regulation => (
                        <Option key={regulation} value={regulation}>
                          {regulation}
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="危险化学品目录序号"
                    name="hazardousChemicalNumber"
                  >
                    <Input placeholder="如：1234" />
                  </Form.Item>
                </Col>
              </Row>

              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label="重点监管危险化学品"
                    name="keyMonitoringChemical"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="是" unCheckedChildren="否" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="易制毒化学品"
                    name="drugPrecursor"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="是" unCheckedChildren="否" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="易制爆化学品"
                    name="explosivePrecursor"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="是" unCheckedChildren="否" />
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="中国法规要求说明"
                name="chinaRegulatoryRequirements"
              >
                <TextArea
                  rows={3}
                  placeholder="请详细说明中国法规的具体要求、合规义务等"
                />
              </Form.Item>
            </Card>

            {/* 国际法规 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                <GlobalOutlined style={{ marginRight: '8px' }} />
                国际法规
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label="适用的国际法规"
                    name="applicableInternationalRegulations"
                  >
                    <Select
                      mode="multiple"
                      placeholder="选择适用的国际法规"
                      style={{ width: '100%' }}
                    >
                      {internationalRegulations.map(regulation => (
                        <Option key={regulation} value={regulation}>
                          {regulation}
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="GHS分类"
                    name="ghsClassification"
                  >
                    <Input placeholder="如：急性毒性类别3" />
                  </Form.Item>
                </Col>
              </Row>

              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label="REACH注册"
                    name="reachRegistration"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="已注册" unCheckedChildren="未注册" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="REACH预注册"
                    name="reachPreregistration"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="已预注册" unCheckedChildren="未预注册" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="REACH限制"
                    name="reachRestriction"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="有限制" unCheckedChildren="无限制" />
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="国际法规要求说明"
                name="internationalRegulatoryRequirements"
              >
                <TextArea
                  rows={3}
                  placeholder="请详细说明国际法规的具体要求、合规义务等"
                />
              </Form.Item>
            </Card>

            {/* 限制清单 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                <WarningOutlined style={{ marginRight: '8px' }} />
                限制清单
              </Title>
              
              <Alert
                message="重要提示"
                description="如果化学品被列入限制清单，可能需要特殊许可或禁止使用。"
                type="warning"
                showIcon
                style={{ marginBottom: '16px' }}
              />

              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label="列入的限制清单"
                    name="restrictionLists"
                  >
                    <Select
                      mode="multiple"
                      placeholder="选择列入的限制清单"
                      style={{ width: '100%' }}
                    >
                      {restrictionLists.map(list => (
                        <Option key={list} value={list}>
                          {list}
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="限制类别"
                    name="restrictionCategory"
                  >
                    <Select
                      mode="multiple"
                      placeholder="选择限制类别"
                    >
                      <Option value="production">生产限制</Option>
                      <Option value="use">使用限制</Option>
                      <Option value="import_export">进出口限制</Option>
                      <Option value="transport">运输限制</Option>
                      <Option value="storage">储存限制</Option>
                      <Option value="disposal">处置限制</Option>
                      <Option value="total_ban">全面禁止</Option>
                    </Select>
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="限制要求说明"
                name="restrictionRequirements"
              >
                <TextArea
                  rows={3}
                  placeholder="请详细说明限制的具体要求、例外情况等"
                />
              </Form.Item>
            </Card>

            {/* 许可要求 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                <SafetyOutlined style={{ marginRight: '8px' }} />
                许可要求
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={12}>
                  <Form.Item
                    label="所需许可证"
                    name="requiredPermits"
                  >
                    <Select
                      mode="multiple"
                      placeholder="选择所需许可证"
                      style={{ width: '100%' }}
                    >
                      {permitRequirements.map(permit => (
                        <Option key={permit} value={permit}>
                          {permit}
                        </Option>
                      ))}
                    </Select>
                  </Form.Item>
                </Col>
                <Col span={12}>
                  <Form.Item
                    label="许可证编号"
                    name="permitNumbers"
                  >
                    <Input placeholder="请输入相关许可证编号" />
                  </Form.Item>
                </Col>
              </Row>

              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label="需要登记"
                    name="registrationRequired"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="是" unCheckedChildren="否" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="需要备案"
                    name="filingRequired"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="是" unCheckedChildren="否" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="需要审批"
                    name="approvalRequired"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="是" unCheckedChildren="否" />
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="许可要求说明"
                name="permitRequirementsDescription"
              >
                <TextArea
                  rows={3}
                  placeholder="请详细说明许可证申请要求、申请流程等"
                />
              </Form.Item>
            </Card>

            {/* 标签和包装要求 */}
            <Card size="small" style={{ marginBottom: '16px' }}>
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                标签和包装要求
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label="GHS标签"
                    name="ghsLabeling"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="需要" unCheckedChildren="不需要" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="中文标签"
                    name="chineseLabeling"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="需要" unCheckedChildren="不需要" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="特殊包装"
                    name="specialPackaging"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="需要" unCheckedChildren="不需要" />
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="标签要求"
                name="labelingRequirements"
              >
                <TextArea
                  rows={2}
                  placeholder="请描述标签的具体要求、必须包含的信息等"
                />
              </Form.Item>

              <Form.Item
                label="包装要求"
                name="packagingRequirements"
              >
                <TextArea
                  rows={2}
                  placeholder="请描述包装的具体要求、材料规格等"
                />
              </Form.Item>
            </Card>

            {/* 其他法规信息 */}
            <Card size="small">
              <Title level={5} style={{ color: '#722ed1', marginBottom: '16px' }}>
                <ExclamationCircleOutlined style={{ marginRight: '8px' }} />
                其他法规信息
              </Title>
              
              <Row gutter={[16, 16]}>
                <Col span={8}>
                  <Form.Item
                    label="职业健康监护"
                    name="occupationalHealthSurveillance"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="需要" unCheckedChildren="不需要" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="环境影响评价"
                    name="environmentalImpactAssessment"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="需要" unCheckedChildren="不需要" />
                  </Form.Item>
                </Col>
                <Col span={8}>
                  <Form.Item
                    label="安全评价"
                    name="safetyAssessment"
                    valuePropName="checked"
                  >
                    <Switch checkedChildren="需要" unCheckedChildren="不需要" />
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                label="地方法规要求"
                name="localRegulations"
              >
                <TextArea
                  rows={3}
                  placeholder="请描述适用的地方法规要求"
                />
              </Form.Item>

              <Form.Item
                label="行业标准"
                name="industryStandards"
              >
                <TextArea
                  rows={3}
                  placeholder="请列出适用的行业标准、企业标准等"
                />
              </Form.Item>

              <Form.Item
                label="合规建议"
                name="complianceRecommendations"
              >
                <TextArea
                  rows={3}
                  placeholder="请提供合规建议、注意事项等"
                />
              </Form.Item>

              <Form.Item
                label="法规更新信息"
                name="regulatoryUpdates"
              >
                <TextArea
                  rows={3}
                  placeholder="请提供最新的法规更新信息、变化趋势等"
                />
              </Form.Item>
            </Card>
          </Form>
        </Card>
      </div>
    );
  }
);

Step15Regulatory.displayName = 'Step15Regulatory';

export default Step15Regulatory;