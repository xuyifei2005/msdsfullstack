import { request } from '@umijs/max';

// MSDS消防措施API服务
const api = '/api/system/msds/fireFighting';

/** 查询消防措施列表 */
export async function getFireFightingList(params?: any) {
  return request(`${api}/list`, {
    method: 'GET',
    params,
  });
}

/** 根据MSDS主表ID获取消防措施 */
export async function getFireFightingByMsdsId(msdsId: number) {
  return request<API.Result<API.Msds.MsdsFireFighting>>(`${api}/msds/${msdsId}`, {
    method: 'GET',
  });
}

/** 获取消防措施详情 */
export async function getFireFighting(id: number) {
  return request<API.Result<API.Msds.MsdsFireFighting>>(`${api}/${id}`, {
    method: 'GET',
  });
}

/** 新增消防措施 */
export async function addFireFighting(data: API.Msds.MsdsFireFighting) {
  return request<API.Result>(api, {
    method: 'POST',
    data,
  });
}

/** 修改消防措施 */
export async function updateFireFighting(data: API.Msds.MsdsFireFighting) {
  return request<API.Result>(api, {
    method: 'PUT',
    data,
  });
}

/** 删除消防措施 */
export async function removeFireFighting(ids: number | number[]) {
  const idList = Array.isArray(ids) ? ids : [ids];
  return request<API.Result>(`${api}/${idList.join(',')}`, {
    method: 'DELETE',
  });
}

/** 根据MSDS主表ID删除消防措施 */
export async function removeFireFightingByMsdsId(msdsId: number) {
  return request<API.Result>(`${api}/msds/${msdsId}`, {
    method: 'DELETE',
  });
}

/** 获取灭火介质选项 */
export async function getExtinguishingMediaOptions() {
  return request<API.Result<any[]>>(`${api}/extinguishing-media`, {
    method: 'GET',
  });
}

/** 获取火险分级选项 */
export async function getFireHazardClassOptions() {
  return request<API.Result<any[]>>(`${api}/fire-hazard-class`, {
    method: 'GET',
  });
}

/** 根据化学品性质推荐消防措施 */
export async function getRecommendedFireFighting(chemicalProperties: any) {
  return request<API.Result<Partial<API.Msds.MsdsFireFighting>>>(`${api}/recommend`, {
    method: 'POST',
    data: chemicalProperties,
  });
}

/** 验证消防措施完整性 */
export async function validateFireFighting(data: API.Msds.MsdsFireFighting) {
  return request<API.Result<{ isValid: boolean; missingFields: string[]; warnings: string[] }>>(`${api}/validate`, {
    method: 'POST',
    data,
  });
}

/** 获取消防措施模板 */
export async function getFireFightingTemplate(chemicalType?: string) {
  return request<API.Result<API.Msds.MsdsFireFighting>>(`${api}/template`, {
    method: 'GET',
    params: { chemicalType },
  });
}