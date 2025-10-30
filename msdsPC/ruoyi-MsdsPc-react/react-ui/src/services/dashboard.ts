import { request } from '@umijs/max';
import { resolveBlob } from '@/utils/downloadfile';

// 获取仪表板概览数据
export async function getDashboardOverview() {
  return request<API.Result>('/api/system/dashboard/overview', {
    method: 'GET',
  });
}

// 获取访问趋势数据
export async function getAccessTrendData(params: {
  startDate: string;
  endDate: string;
  metricType: string;
}) {
  return request<API.Result>('/api/system/dashboard/access-trend', {
    method: 'GET',
    params,
  });
}

// 获取用户活动数据
export async function getUserActivityData() {
  return request<API.Result>('/api/system/dashboard/user-activity', {
    method: 'GET',
  });
}

// 获取下载分析数据
export async function getDownloadAnalyticsData(params: {
  timeRange: string;
}) {
  return request<API.Result>('/api/system/dashboard/download-analytics', {
    method: 'GET',
    params,
  });
}

// 获取热门文档数据
export async function getHotDocumentsData(params: {
  sortBy: string;
}) {
  return request<API.Result>('/api/system/dashboard/hot-documents', {
    method: 'GET',
    params,
  });
}

// 获取实时统计数据
export async function getRealtimeStats() {
  return request<API.Result>('/api/system/dashboard/realtime-stats', {
    method: 'GET',
  });
}

// 获取文档统计数据
export async function getDocumentStats() {
  return request<API.Result>('/api/system/dashboard/document-stats', {
    method: 'GET',
  });
}

// 获取系统健康监控数据
export async function getSystemHealthData() {
  return request<API.Result>('/api/system/dashboard/system-health', {
    method: 'GET',
  });
}

// 获取化学品统计数据
export async function getChemicalStats() {
  return request<API.Result>('/api/system/dashboard/chemical-stats', {
    method: 'GET',
  });
}

// 导出仪表板报告
export async function exportDashboardReport(params: {
  format: 'pdf' | 'excel';
  dateRange: string[];
}) {
  return request('/api/system/dashboard/export-report', {
    method: 'POST',
    data: params,
    responseType: 'blob',
    getResponse: true,
  }).then((res) => {
    // 从响应头解析文件名并下载，避免前端硬编码
    const mime = params.format === 'excel'
      ? 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      : 'application/pdf';
    resolveBlob(res, mime);
  });
}