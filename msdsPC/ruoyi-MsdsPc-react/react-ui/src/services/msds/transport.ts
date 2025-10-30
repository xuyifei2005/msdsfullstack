import { request } from '@umijs/max';

// MSDS运输信息API服务
const api = '/api/system/msds/transport';

/** 查询运输信息列表 */
export async function getTransportList(params?: any) {
  return request(`${api}/list`, {
    method: 'GET',
    params,
  });
}

/** 根据MSDS主表ID获取运输信息 */
export async function getTransportByMsdsId(msdsId: number) {
  return request<API.Result<API.Msds.MsdsTransport>>(`${api}/msds/${msdsId}`, {
    method: 'GET',
  });
}

/** 获取运输信息详情 */
export async function getTransport(id: number) {
  return request<API.Result<API.Msds.MsdsTransport>>(`${api}/${id}`, {
    method: 'GET',
  });
}

/** 新增运输信息 */
export async function addTransport(data: API.Msds.MsdsTransport) {
  return request<API.Result>(api, {
    method: 'POST',
    data,
  });
}

/** 修改运输信息 */
export async function updateTransport(data: API.Msds.MsdsTransport) {
  return request<API.Result>(api, {
    method: 'PUT',
    data,
  });
}

/** 删除运输信息 */
export async function removeTransport(ids: number | number[]) {
  const idList = Array.isArray(ids) ? ids : [ids];
  return request<API.Result>(`${api}/${idList.join(',')}`, {
    method: 'DELETE',
  });
}

/** 根据MSDS主表ID删除运输信息 */
export async function removeTransportByMsdsId(msdsId: number) {
  return request<API.Result>(`${api}/${msdsId}`, {
    method: 'DELETE',
  });
}

/** 根据危险性分类获取UN编号 */
export async function getUnNumberByHazard(hazardClass: string, packingGroup?: string) {
  return request<API.Result<any[]>>(`${api}/un-number`, {
    method: 'GET',
    params: { hazardClass, packingGroup },
  });
}

/** 获取运输标签要求 */
export async function getTransportLabels(unNumber: string) {
  return request<API.Result<any[]>>(`${api}/transport-labels`, {
    method: 'GET',
    params: { unNumber },
  });
}

/** 获取包装要求 */
export async function getPackagingRequirements(unNumber: string, transportMode: string) {
  return request<API.Result<any>>(`${api}/packaging-requirements`, {
    method: 'GET',
    params: { unNumber, transportMode },
  });
}

/** 获取运输法规要求 */
export async function getTransportRegulations(region: string, transportMode: string) {
  return request<API.Result<any>>(`${api}/regulations`, {
    method: 'GET',
    params: { region, transportMode },
  });
}

/** 验证运输信息完整性 */
export async function validateTransport(data: API.Msds.MsdsTransport) {
  return request<API.Result<{ isValid: boolean; missingFields: string[]; warnings: string[] }>>(`${api}/validate`, {
    method: 'POST',
    data,
  });
}