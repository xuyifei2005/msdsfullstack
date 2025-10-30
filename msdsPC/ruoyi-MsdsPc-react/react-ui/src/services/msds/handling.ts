import { request } from '@umijs/max';

// MSDS操作处置与储存API服务
const api = '/api/system/msds/handling';

/** 查询操作处置与储存列表 */
export async function getHandlingList(params?: any) {
  return request(`${api}/list`, {
    method: 'GET',
    params,
  });
}

/** 根据MSDS主表ID获取操作处置与储存 */
export async function getHandlingByMsdsId(msdsId: number) {
  return request<API.Result<API.Msds.MsdsHandling>>(`${api}/msds/${msdsId}`, {
    method: 'GET',
  });
}

/** 获取操作处置与储存详情 */
export async function getHandling(id: number) {
  return request<API.Result<API.Msds.MsdsHandling>>(`${api}/${id}`, {
    method: 'GET',
  });
}

/** 新增操作处置与储存 */
export async function addHandling(data: API.Msds.MsdsHandling) {
  return request<API.Result>(api, {
    method: 'POST',
    data,
  });
}

/** 修改操作处置与储存 */
export async function updateHandling(data: API.Msds.MsdsHandling) {
  return request<API.Result>(api, {
    method: 'PUT',
    data,
  });
}

/** 删除操作处置与储存 */
export async function removeHandling(ids: number | number[]) {
  const idList = Array.isArray(ids) ? ids : [ids];
  return request<API.Result>(`${api}/${idList.join(',')}`, {
    method: 'DELETE',
  });
}

/** 根据MSDS主表ID删除操作处置与储存 */
export async function removeHandlingByMsdsId(msdsId: number) {
  return request<API.Result>(`${api}/msds/${msdsId}`, {
    method: 'DELETE',
  });
}

/** 获取储存条件选项 */
export async function getStorageConditionOptions() {
  return request<API.Result<any[]>>(`${api}/storage-conditions`, {
    method: 'GET',
  });
}

/** 获取个人防护设备选项 */
export async function getPersonalProtectionOptions() {
  return request<API.Result<any[]>>(`${api}/personal-protection`, {
    method: 'GET',
  });
}

/** 根据化学品性质推荐操作处置措施 */
export async function getRecommendedHandling(chemicalProperties: any) {
  return request<API.Result<Partial<API.Msds.MsdsHandling>>>(`${api}/recommend`, {
    method: 'POST',
    data: chemicalProperties,
  });
}

/** 验证操作处置与储存完整性 */
export async function validateHandling(data: API.Msds.MsdsHandling) {
  return request<API.Result<{ isValid: boolean; missingFields: string[]; warnings: string[] }>>(`${api}/validate`, {
    method: 'POST',
    data,
  });
}

/** 获取操作处置与储存模板 */
export async function getHandlingTemplate(chemicalType?: string) {
  return request<API.Result<API.Msds.MsdsHandling>>(`${api}/template`, {
    method: 'GET',
    params: { chemicalType },
  });
}