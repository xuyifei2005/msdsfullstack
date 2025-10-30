import { request } from '@umijs/max';

// MSDS废弃处置API服务
const api = '/api/system/msds/disposal';

/** 查询废弃处置列表 */
export async function getDisposalList(params?: any) {
  return request(`${api}/list`, {
    method: 'GET',
    params,
  });
}

/** 根据MSDS主表ID获取废弃处置 */
export async function getDisposalByMsdsId(msdsId: number) {
  return request<API.Result<API.Msds.MsdsDisposal>>(`${api}/msds/${msdsId}`, {
    method: 'GET',
  });
}

/** 获取废弃处置详情 */
export async function getDisposal(id: number) {
  return request<API.Result<API.Msds.MsdsDisposal>>(`${api}/${id}`, {
    method: 'GET',
  });
}

/** 新增废弃处置 */
export async function addDisposal(data: API.Msds.MsdsDisposal) {
  return request<API.Result>(api, {
    method: 'POST',
    data,
  });
}

/** 修改废弃处置 */
export async function updateDisposal(data: API.Msds.MsdsDisposal) {
  return request<API.Result>(api, {
    method: 'PUT',
    data,
  });
}

/** 删除废弃处置 */
export async function removeDisposal(ids: number | number[]) {
  const idList = Array.isArray(ids) ? ids : [ids];
  return request<API.Result>(`${api}/${idList.join(',')}`, {
    method: 'DELETE',
  });
}

/** 根据MSDS主表ID删除废弃处置 */
export async function removeDisposalByMsdsId(msdsId: number) {
  return request<API.Result>(`${api}/${msdsId}`, {
    method: 'DELETE',
  });
}

/** 获取废物分类标准 */
export async function getWasteClassification() {
  return request<API.Result<any[]>>(`${api}/waste-classification`, {
    method: 'GET',
  });
}

/** 获取处置方法推荐 */
export async function getDisposalMethods(wasteType: string, hazardClass?: string) {
  return request<API.Result<any[]>>(`${api}/disposal-methods`, {
    method: 'GET',
    params: { wasteType, hazardClass },
  });
}

/** 获取法规要求 */
export async function getRegulationRequirements(region: string) {
  return request<API.Result<any>>(`${api}/regulations`, {
    method: 'GET',
    params: { region },
  });
}

/** 计算处置成本估算 */
export async function calculateDisposalCost(data: any) {
  return request<API.Result<any>>(`${api}/cost-estimate`, {
    method: 'POST',
    data,
  });
}

/** 验证废弃处置信息完整性 */
export async function validateDisposal(data: API.Msds.MsdsDisposal) {
  return request<API.Result<{ isValid: boolean; missingFields: string[]; warnings: string[] }>>(`${api}/validate`, {
    method: 'POST',
    data,
  });
}