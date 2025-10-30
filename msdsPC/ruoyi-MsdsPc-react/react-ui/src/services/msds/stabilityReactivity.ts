import { request } from '@umijs/max';

// MSDS稳定性和反应活性API服务
const api = '/api/system/msds/stabilityReactivity';

/** 查询稳定性和反应活性列表 */
export async function getStabilityReactivityList(params?: any) {
  return request(`${api}/list`, {
    method: 'GET',
    params,
  });
}

/** 根据MSDS主表ID获取稳定性和反应活性 */
export async function getStabilityReactivityByMsdsId(msdsId: number) {
  return request<API.Result<API.Msds.MsdsStabilityReactivity>>(`${api}/msds/${msdsId}`, {
    method: 'GET',
  });
}

/** 获取稳定性和反应活性详情 */
export async function getStabilityReactivity(id: number) {
  return request<API.Result<API.Msds.MsdsStabilityReactivity>>(`${api}/${id}`, {
    method: 'GET',
  });
}

/** 新增稳定性和反应活性 */
export async function addStabilityReactivity(data: API.Msds.MsdsStabilityReactivity) {
  return request<API.Result>(api, {
    method: 'POST',
    data,
  });
}

/** 修改稳定性和反应活性 */
export async function updateStabilityReactivity(data: API.Msds.MsdsStabilityReactivity) {
  return request<API.Result>(api, {
    method: 'PUT',
    data,
  });
}

/** 删除稳定性和反应活性 */
export async function removeStabilityReactivity(ids: number | number[]) {
  const idList = Array.isArray(ids) ? ids : [ids];
  return request<API.Result>(`${api}/${idList.join(',')}`, {
    method: 'DELETE',
  });
}

/** 根据MSDS主表ID删除稳定性和反应活性 */
export async function removeStabilityReactivityByMsdsId(msdsId: number) {
  return request<API.Result>(`${api}/${msdsId}`, {
    method: 'DELETE',
  });
}

/** 获取不相容物质数据库 */
export async function getIncompatibleMaterials(casNumber?: string) {
  return request<API.Result<any[]>>(`${api}/incompatible-materials`, {
    method: 'GET',
    params: { casNumber },
  });
}

/** 获取危险反应条件 */
export async function getHazardousReactionConditions() {
  return request<API.Result<any[]>>(`${api}/hazardous-conditions`, {
    method: 'GET',
  });
}

/** 根据化学结构预测稳定性 */
export async function predictStability(chemicalStructure: any) {
  return request<API.Result<any>>(`${api}/predict-stability`, {
    method: 'POST',
    data: chemicalStructure,
  });
}

/** 验证稳定性和反应活性数据 */
export async function validateStabilityReactivity(data: API.Msds.MsdsStabilityReactivity) {
  return request<API.Result<{ isValid: boolean; warnings: string[]; recommendations: string[] }>>(`${api}/validate`, {
    method: 'POST',
    data,
  });
}