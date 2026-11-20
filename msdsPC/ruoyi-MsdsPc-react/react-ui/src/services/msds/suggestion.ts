import { request } from '@umijs/max';

/** 搜索建议词条 */
export interface SearchSuggestionItem {
  suggestionId?: number;
  keyword?: string;
  keywordType?: string;
  relatedCas?: string;
  relatedMsdsId?: number;
  searchCount?: number;
  clickCount?: number;
  sortOrder?: number;
  isActive?: number;
  startTime?: string;
  endTime?: string;
  remark?: string;
  createTime?: string;
}

/** 词条类型字典 */
export const SUGGESTION_TYPE_OPTIONS = [
  { label: '热门推荐', value: 'hot' },
  { label: '相关词', value: 'related' },
  { label: 'CAS号', value: 'cas' },
  { label: '分子式', value: 'formula' },
  { label: 'AI推荐', value: 'ai' },
];

/**
 * 查询搜索词条列表
 */
export async function listSearchSuggestions(
  params?: { keyword?: string; keywordType?: string; isActive?: number },
) {
  return request<API.Result & { rows: SearchSuggestionItem[]; total: number }>(
    '/api/system/msds/search/suggestion/list',
    {
      method: 'GET',
      params,
    },
  );
}

/**
 * 新增搜索词条
 */
export async function addSearchSuggestion(data: SearchSuggestionItem) {
  return request<API.Result>('/api/system/msds/search/suggestion', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json;charset=UTF-8',
    },
    data,
  });
}

/**
 * 修改搜索词条
 */
export async function updateSearchSuggestion(data: SearchSuggestionItem) {
  return request<API.Result>('/api/system/msds/search/suggestion', {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json;charset=UTF-8',
    },
    data,
  });
}

/**
 * 删除搜索词条
 */
export async function removeSearchSuggestions(suggestionIds: number | number[]) {
  const ids = Array.isArray(suggestionIds) ? suggestionIds : [suggestionIds];
  return request<API.Result>(`/api/system/msds/search/suggestion/${ids.join(',')}`, {
    method: 'DELETE',
  });
}
