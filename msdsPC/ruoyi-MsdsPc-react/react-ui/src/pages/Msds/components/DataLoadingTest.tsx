import React, { useState } from 'react';
import { Button, Card, Space, Input, message } from 'antd';
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

/**
 * MSDS数据加载测试组件
 * 用于独立测试16章数据加载功能
 */
const DataLoadingTest: React.FC = () => {
  const [testMsdsId, setTestMsdsId] = useState<string>('164');
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<any>(null);

  const testDataLoading = async () => {
    const msdsId = parseInt(testMsdsId);
    if (!msdsId || isNaN(msdsId)) {
      message.error('请输入有效的MSDS ID');
      return;
    }

    console.log('🧪 [测试] 开始测试数据加载，msdsId:', msdsId);
    setLoading(true);
    setResult(null);

    try {
      // 并行加载所有章节数据
      console.log('🔄 [测试] 发起16个API请求...');
      const startTime = Date.now();

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

      const endTime = Date.now();
      console.log(`⏱️ [测试] API请求完成，耗时: ${endTime - startTime}ms`);

      // 检查各API响应
      const responses = {
        '1-基本信息': mainResponse,
        '2-危险性概述': hazardResponse,
        '3-成分信息': componentResponse,
        '4-急救措施': firstAidResponse,
        '5-消防措施': fireFightingResponse,
        '6-泄漏应急': leakResponseResponse,
        '7-操作储存': handlingResponse,
        '8-接触控制': exposureResponse,
        '9-理化特性': physicalChemicalResponse,
        '10-稳定性反应': stabilityReactivityResponse,
        '11-毒理学资料': toxicologyResponse,
        '12-生态学资料': ecologyResponse,
        '13-废弃处置': disposalResponse,
        '14-运输信息': transportResponse,
        '15-法规信息': regulatoryResponse,
        '16-其他信息': otherInfoResponse
      };

      console.log('📊 [测试] 所有API响应:', responses);

      // 统计加载结果
      let successCount = 0;
      let failCount = 0;
      let emptyCount = 0;

      Object.entries(responses).forEach(([key, response]) => {
        if (response.code === 200) {
          if (response.data) {
            successCount++;
            console.log(`✅ [测试] ${key}: 有数据`, response.data);
          } else {
            emptyCount++;
            console.log(`⚪ [测试] ${key}: 无数据（data为null）`);
          }
        } else {
          failCount++;
          console.error(`❌ [测试] ${key}: 请求失败`, response);
        }
      });

      const summary = {
        总章节数: 16,
        成功加载: successCount,
        无数据: emptyCount,
        失败: failCount,
        耗时: `${endTime - startTime}ms`,
        responses
      };

      console.log('📈 [测试] 加载统计:', summary);
      setResult(summary);

      if (successCount > 0) {
        message.success(`成功加载${successCount}个章节的数据`);
      } else if (failCount > 0) {
        message.error(`${failCount}个章节加载失败`);
      } else {
        message.warning('所有章节都无数据');
      }

    } catch (error) {
      console.error('❌ [测试] 数据加载失败:', error);
      message.error('数据加载失败: ' + error);
      setResult({ error: String(error) });
    } finally {
      setLoading(false);
    }
  };

  return (
    <Card title="MSDS数据加载测试工具" style={{ margin: 24 }}>
      <Space direction="vertical" style={{ width: '100%' }}>
        <Space>
          <Input
            placeholder="请输入MSDS ID"
            value={testMsdsId}
            onChange={(e) => setTestMsdsId(e.target.value)}
            style={{ width: 200 }}
          />
          <Button 
            type="primary" 
            onClick={testDataLoading}
            loading={loading}
          >
            测试数据加载
          </Button>
        </Space>

        {result && (
          <Card size="small" title="测试结果">
            <pre style={{ 
              background: '#f5f5f5', 
              padding: 16, 
              borderRadius: 4,
              overflow: 'auto',
              maxHeight: 500
            }}>
              {JSON.stringify(result, null, 2)}
            </pre>
          </Card>
        )}

        <Card size="small" title="使用说明" type="inner">
          <ol>
            <li>输入要测试的MSDS ID（如：164）</li>
            <li>点击"测试数据加载"按钮</li>
            <li>打开浏览器控制台（F12）查看详细日志</li>
            <li>查看测试结果，了解哪些章节有数据</li>
          </ol>
        </Card>

        <Card size="small" title="数据库中的MSDS ID" type="inner">
          <p>您可以使用以下ID进行测试：</p>
          <ul>
            <li>164 - (1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯</li>
            <li>165 - (1R,2R,4R)-冰片-2-硫氰基醋酸酯</li>
            <li>166 - (S)-3-(1-甲基吡咯烷-2-基)吡啶</li>
            <li>167 - 0，0-二乙基硫代磷酰氯</li>
            <li>168 - 1-(2-过氧化乙基己醇-1,3-二甲</li>
          </ul>
        </Card>
      </Space>
    </Card>
  );
};

export default DataLoadingTest;
