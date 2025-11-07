import { request } from '@umijs/max';

/**
 * MSDS数据分析API服务
 */

/** 基础统计数据接口 */
export interface SummaryStatistics {
  totalMsds: number;
  highHazardCount: number;
  monthlyVisits: number;
  activeUsers: number;
  msdsGrowthRate: string;
  hazardGrowthRate: string;
  visitsGrowthRate: string;
  usersGrowthRate: string;
}

/** 趋势数据项 */
export interface TrendDataItem {
  date: string;
  visits: number;
  uniqueUsers: number;
  viewCount: number;
  downloadCount: number;
}

/** 分类分布数据项 */
export interface CategoryDistributionItem {
  code: string;
  name: string;
  value: number;
  count: number;
  percentage: number;
}

/** 危险等级分布数据项 */
export interface HazardDistributionItem {
  level: string;
  value: number;
  count: number;
}

/** 排行榜数据项 */
export interface RankingItem {
  id: number;
  productName: string;
  englishName?: string;
  casNumber: string;
  hazardLevel: 'high' | 'medium' | 'low';
  hazardLevelText: string;
  viewCount: number;
  downloadCount: number;
  favoriteCount: number;
  growthRate: number;
}

/** 月度新增数据项 */
export interface MonthlyDataItem {
  month: string;
  monthLabel: string;
  value: number;
  count: number;
}

/** 用户活跃度数据 */
export interface UserActivityStats {
  dailyActiveUsers: number;
  weeklyActiveUsers: number;
  monthlyActiveUsers: number;
  totalUsers: number;
  dailyActiveRate: number;
  weeklyActiveRate: number;
  monthlyActiveRate: number;
}

/**
 * 获取基础统计数据
 */
export async function getSummaryStatistics() {
  return request<API.Result<SummaryStatistics>>('/api/system/msds/analytics/summary', {
    method: 'GET',
  });
}

/**
 * 获取访问趋势
 */
export async function getAccessTrend(days: number = 7) {
  return request<API.Result<TrendDataItem[]>>('/api/system/msds/analytics/trend', {
    method: 'GET',
    params: { days },
  });
}

/**
 * 获取化学品分类分布
 */
export async function getCategoryDistribution() {
  return request<API.Result<CategoryDistributionItem[]>>('/api/system/msds/analytics/category', {
    method: 'GET',
  });
}

/**
 * 获取危险等级分布
 */
export async function getHazardDistribution() {
  return request<API.Result<HazardDistributionItem[]>>('/api/system/msds/analytics/hazard', {
    method: 'GET',
  });
}

/**
 * 获取热门MSDS排行榜
 */
export async function getTopMsdsRanking(limit: number = 10) {
  return request<API.Result<RankingItem[]>>('/api/system/msds/analytics/ranking', {
    method: 'GET',
    params: { limit },
  });
}

/**
 * 获取月度新增MSDS统计
 */
export async function getMonthlyNewMsds(months: number = 6) {
  return request<API.Result<MonthlyDataItem[]>>('/api/system/msds/analytics/monthly', {
    method: 'GET',
    params: { months },
  });
}

/**
 * 获取用户活跃度统计
 */
export async function getUserActivityStats() {
  return request<API.Result<UserActivityStats>>('/api/system/msds/analytics/users', {
    method: 'GET',
  });
}

/**
 * 导出数据分析报告
 */
export async function exportAnalyticsReport(startDate?: string, endDate?: string) {
  return request<API.Result>('/api/system/msds/analytics/export', {
    method: 'GET',
    params: { startDate, endDate },
  });
}


