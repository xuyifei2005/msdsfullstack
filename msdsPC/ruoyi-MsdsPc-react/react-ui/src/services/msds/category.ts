import { request } from '@umijs/max';

/**
 * MSDS 监管分类标签接口（PC 与小程序共用）
 * 数据来自真实法规名录按 CAS 号匹配 msds_main，无 mock、无写死数据。
 */

/** 分类标签 + 每个标签的真实记录数（可带当前搜索条件） */
export async function getRegulatoryCategories(params?: API.Msds.MsdsMainListParams) {
  return request<{
    code: number;
    msg: string;
    data: API.Msds.RegulatoryCategory[];
  }>('/api/system/msds/regulatoryCategories', {
    method: 'GET',
    params,
  });
}

/** 某一篇 MSDS 的分类判定依据（法规名录 / CAS 匹配证据） */
export async function getRegulatoryCategoryItems(msdsId: number) {
  return request<{
    code: number;
    msg: string;
    data: API.Msds.RegulatoryCategoryItem[];
  }>('/api/system/msds/regulatoryCategories/items', {
    method: 'GET',
    params: { msdsId },
  });
}
