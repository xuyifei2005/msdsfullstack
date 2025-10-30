import { request } from '@umijs/max';

// MSDS法规信息API服务
const api = '/api/system/msds/regulatory';

/** 查询法规信息列表 */
export async function getRegulatoryList(params?: any) {
  return request(`${api}/list`, {
    method: 'GET',
    params,
  });
}

/** 根据MSDS主表ID获取法规信息 */
export async function getRegulatoryByMsdsId(msdsId: number) {
  return request<API.Result<API.Msds.MsdsRegulatory>>(`${api}/msds/${msdsId}`, {
    method: 'GET',
  });
}

/** 获取法规信息详情 */
export async function getRegulatory(id: number) {
  return request<API.Result<API.Msds.MsdsRegulatory>>(`${api}/${id}`, {
    method: 'GET',
  });
}

/** 新增法规信息 */
export async function addRegulatory(data: API.Msds.MsdsRegulatory) {
  return request<API.Result>(api, {
    method: 'POST',
    data,
  });
}

/** 修改法规信息 */
export async function updateRegulatory(data: API.Msds.MsdsRegulatory) {
  return request<API.Result>(api, {
    method: 'PUT',
    data,
  });
}

/** 删除法规信息 */
export async function removeRegulatory(ids: number | number[]) {
  const idList = Array.isArray(ids) ? ids : [ids];
  return request<API.Result>(`${api}/${idList.join(',')}`, {
    method: 'DELETE',
  });
}

/** 根据MSDS主表ID删除法规信息 */
export async function removeRegulatoryByMsdsId(msdsId: number) {
  return request<API.Result>(`${api}/${msdsId}`, {
    method: 'DELETE',
  });
}

/** 根据CAS号查询法规状态 */
export async function getRegulatoryStatusByCas(casNumber: string, region?: string) {
  return request<API.Result<any>>(`${api}/status/${casNumber}`, {
    method: 'GET',
    params: { region },
  });
}

/** 获取法规清单 */
export async function getRegulatoryInventories(region: string) {
  return request<API.Result<any[]>>(`${api}/inventories`, {
    method: 'GET',
    params: { region },
  });
}

/** 获取限制使用信息 */
export async function getRestrictions(casNumber: string, region?: string) {
  return request<API.Result<any[]>>(`${api}/restrictions`, {
    method: 'GET',
    params: { casNumber, region },
  });
}

/** 获取安全评价要求 */
export async function getSafetyAssessmentRequirements(region: string, useCategory?: string) {
  return request<API.Result<any>>(`${api}/safety-assessment`, {
    method: 'GET',
    params: { region, useCategory },
  });
}

/** 检查法规合规性 */
export async function checkCompliance(data: any) {
  return request<API.Result<{ isCompliant: boolean; violations: string[]; recommendations: string[] }>>(`${api}/compliance-check`, {
    method: 'POST',
    data,
  });
}

/** 验证法规信息完整性 */
export async function validateRegulatory(data: API.Msds.MsdsRegulatory) {
  return request<API.Result<{ isValid: boolean; missingFields: string[]; warnings: string[] }>>(`${api}/validate`, {
    method: 'POST',
    data,
  });
}