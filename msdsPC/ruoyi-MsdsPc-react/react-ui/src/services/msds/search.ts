import { request } from '@umijs/max';

/** 智能搜索参数 */
export interface IntelligentSearchParams {
  keyword?: string;
  searchType?: 'general' | 'semantic' | 'cas' | 'formula';
  documentType?: string;
  categoryId?: number;
  supplier?: string;
  /** 危险性分类关键字，多个用逗号分隔 */
  hazardKeyword?: string;
  /** 更新时间范围起 */
  updateTimeFrom?: string;
  /** 更新时间范围止 */
  updateTimeTo?: string;
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

/** 危险性分类真实数量 */
export interface HazardFacet {
  keyword: string;
  docCount: number;
}

/**
 * 获取危险性分类的真实文档数量
 */
export async function getHazardFacet() {
  return request<API.Result<HazardFacet[]>>('/api/system/msds/search/facet/hazard', {
    method: 'GET',
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

/** 文档真实计数 */
export interface MsdsStatistics {
  viewCount: number;
  downloadCount: number;
  favoriteCount: number;
  shareCount: number;
  lastViewTime?: string;
  lastDownloadTime?: string;
  lastFavoriteTime?: string;
}

/**
 * 获取文档的真实计数（查看/下载/收藏）
 */
export async function getMsdsStatistics(msdsId: number) {
  return request<API.Result<MsdsStatistics>>(`/api/system/msds/statistics/${msdsId}`, {
    method: 'GET',
  });
}

/**
 * 记录一次真实访问行为并累加计数
 *
 * @param action view / download / favorite / share
 */
export async function recordMsdsAccess(msdsId: number, action: 'view' | 'download' | 'favorite' | 'share') {
  return request<API.Result<MsdsStatistics>>(`/api/system/msds/statistics/${msdsId}/access`, {
    method: 'POST',
    params: { action },
  });
}

/** 收藏记录项 */
export interface UserFavorite {
  favoriteId: number;
  userId: number;
  userName?: string;
  msdsId: number;
  msdsName?: string;
  casNumber?: string;
  folderName?: string;
  tags?: string;
  note?: string;
  createTime?: string;
}

/**
 * 获取当前用户的收藏列表
 */
export async function getUserFavorites() {
  return request<API.Result<UserFavorite[]>>('/api/system/msds/favorite/list', {
    method: 'GET',
  });
}

/**
 * 查询当前用户是否已收藏某文档
 */
export async function getFavoriteStatus(msdsId: number) {
  return request<API.Result<{ favorited: boolean }>>(`/api/system/msds/favorite/${msdsId}/status`, {
    method: 'GET',
  });
}

/**
 * 收藏文档
 */
export async function addFavorite(
  msdsId: number,
  params?: { msdsName?: string; casNumber?: string; folderName?: string; tags?: string; note?: string },
) {
  return request<API.Result<{ favorited: boolean; statistics: MsdsStatistics }>>(
    `/api/system/msds/favorite/${msdsId}`,
    {
      method: 'POST',
      params,
    },
  );
}

/**
 * 取消收藏
 */
export async function removeFavorite(msdsId: number) {
  return request<API.Result<{ favorited: boolean; statistics: MsdsStatistics }>>(
    `/api/system/msds/favorite/${msdsId}`,
    {
      method: 'DELETE',
    },
  );
}

/**
 * 导出MSDS为PDF（真实下载，由后端生成并统计下载次数）
 */
export async function exportMsdsPdf(id: number) {
  return request<Blob>(`/api/system/msds/exportPdf?id=${id}`, {
    method: 'POST',
    responseType: 'blob',
    getResponse: true,
  });
}

