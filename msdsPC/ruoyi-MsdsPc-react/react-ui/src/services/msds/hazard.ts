import { request } from '@umijs/max';

// MSDS危险性概述API服务
const api = '/api/system/msds/hazard';

/** 查询危险性概述列表 */
export async function getHazardList(params?: any) {
  return request(`${api}/list`, {
    method: 'GET',
    params,
  });
}

/** 根据MSDS主表ID获取危险性概述 */
export async function getHazardByMsdsId(msdsId: number) {
  return request<API.Result<API.Msds.MsdsHazard>>(`${api}/msds/${msdsId}`, {
    method: 'GET',
  });
}

/** 获取危险性概述详情 */
export async function getHazard(id: number) {
  return request<API.Result<API.Msds.MsdsHazard>>(`${api}/${id}`, {
    method: 'GET',
  });
}

/** 新增危险性概述 */
export async function addHazard(data: API.Msds.MsdsHazard) {
  return request<API.Result>(api, {
    method: 'POST',
    data,
  });
}

/** 修改危险性概述 */
export async function updateHazard(data: API.Msds.MsdsHazard) {
  return request<API.Result>(api, {
    method: 'PUT',
    data,
  });
}

/** 删除危险性概述 */
export async function removeHazard(ids: number | number[]) {
  const idList = Array.isArray(ids) ? ids : [ids];
  return request<API.Result>(`${api}/${idList.join(',')}`, {
    method: 'DELETE',
  });
}

/** 根据MSDS主表ID删除危险性概述 */
export async function removeHazardByMsdsId(msdsId: number) {
  return request<API.Result>(`${api}/${msdsId}`, {
    method: 'DELETE',
  });
}

/** 获取GHS分类选项 */
export async function getGhsClassificationOptions() {
  return request<API.Result<any[]>>(`${api}/ghs/classifications`, {
    method: 'GET',
  });
}

/** 获取象形图选项 */
export async function getPictogramOptions() {
  return request<API.Result<any[]>>(`${api}/pictograms`, {
    method: 'GET',
  });
}

/** 获取信号词选项 */
export async function getSignalWordOptions() {
  return request<API.Result<any[]>>(`${api}/signal-words`, {
    method: 'GET',
  });
}

/** 获取危险说明选项 */
export async function getHazardStatementOptions() {
  return request<API.Result<any[]>>(`${api}/hazard-statements`, {
    method: 'GET',
  });
}

/** 获取防范说明选项 */
export async function getPrecautionaryStatementOptions() {
  return request<API.Result<any[]>>(`${api}/precautionary-statements`, {
    method: 'GET',
  });
}

/** 根据GHS分类自动推荐象形图 */
export async function getRecommendedPictograms(ghsClassifications: string[]) {
  return request<API.Result<any[]>>(`${api}/recommend/pictograms`, {
    method: 'POST',
    data: { ghsClassifications },
  });
}

/** 根据GHS分类自动推荐危险说明 */
export async function getRecommendedHazardStatements(ghsClassifications: string[]) {
  return request<API.Result<any[]>>(`${api}/recommend/hazard-statements`, {
    method: 'POST',
    data: { ghsClassifications },
  });
}