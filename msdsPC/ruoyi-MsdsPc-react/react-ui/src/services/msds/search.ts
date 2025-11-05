import { request } from '@umijs/max';

/** 智能搜索参数 */
export interface IntelligentSearchParams {
  keyword?: string;
  searchType?: 'general' | 'semantic' | 'cas' | 'formula';
  documentType?: string;
  categoryId?: number;
  supplier?: string;
  sortBy?: 'relevance' | 'updated' | 'name' | 'views';
  pageNum?: number;
  pageSize?: number;
}

/** 搜索建议项 */
export interface SearchSuggestion {
  name: string;
  casNumber?: string;
  englishName?: string;
}

/** 热门搜索项 */
export interface HotSearch {
  suggestionId: number;
  keyword: string;
  keywordType: string;
  searchCount: number;
  sortOrder: number;
}

/** 搜索历史项 */
export interface SearchHistory {
  searchId: number;
  searchKeyword: string;
  searchType: string;
  resultCount: number;
  searchTime: string;
}

/** 搜索结果 */
export interface SearchResult {
  code: number;
  msg: string;
  rows: API.Msds.MsdsMain[];
  total: number;
}

/**
 * 智能搜索MSDS文档
 */
export async function intelligentSearch(params: IntelligentSearchParams) {
  return request<SearchResult>('/api/system/msds/search/intelligent', {
    method: 'GET',
    params,
  });
}

/**
 * 高级搜索
 */
export async function advancedSearch(filters: Record<string, any>) {
  return request<SearchResult>('/api/system/msds/search/advanced', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json;charset=UTF-8',
    },
    data: filters,
  });
}

/**
 * 获取搜索建议
 */
export async function getSearchSuggestions(keyword: string, limit = 10) {
  return request<API.Result<SearchSuggestion[]>>('/api/system/msds/search/suggestions', {
    method: 'GET',
    params: { keyword, limit },
  });
}

/**
 * 获取热门搜索
 */
export async function getHotSearches(limit = 10) {
  return request<API.Result<HotSearch[]>>('/api/system/msds/search/hot', {
    method: 'GET',
    params: { limit },
  });
}

/**
 * 获取用户搜索历史
 */
export async function getUserSearchHistory(limit = 20) {
  return request<API.Result<SearchHistory[]>>('/api/system/msds/search/history', {
    method: 'GET',
    params: { limit },
  });
}

/**
 * 清除搜索历史
 */
export async function clearSearchHistory() {
  return request<API.Result>('/api/system/msds/search/history/clear', {
    method: 'DELETE',
  });
}

/**
 * 删除指定搜索历史记录
 */
export async function deleteSearchHistory(searchIds: number[]) {
  return request<API.Result>(`/api/system/msds/search/history/${searchIds.join(',')}`, {
    method: 'DELETE',
  });
}

/**
 * 获取相关文档
 */
export async function getRelatedDocuments(msdsId: number, limit = 5) {
  return request<API.Result<API.Msds.MsdsMain[]>>(`/api/system/msds/search/related/${msdsId}`, {
    method: 'GET',
    params: { limit },
  });
}

/**
 * 记录搜索行为
 */
export async function recordSearch(params: {
  searchKeyword: string;
  searchType: string;
  resultCount: number;
  filterParams?: string;
}) {
  return request<API.Result>('/api/system/msds/search/record', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json;charset=UTF-8',
    },
    data: params,
  });
}

/**
 * 更新搜索建议统计
 */
export async function updateSuggestionStat(keyword: string, clicked = false) {
  return request<API.Result>('/api/system/msds/search/suggestion/stat', {
    method: 'POST',
    params: { keyword, clicked },
  });
}

