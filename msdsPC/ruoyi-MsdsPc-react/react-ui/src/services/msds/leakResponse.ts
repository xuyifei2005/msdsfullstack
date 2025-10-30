import { request } from '@umijs/max';

// MSDS泄漏应急处理API服务
const api = '/api/system/msds/leakResponse';

/** 查询泄漏应急处理列表 */
export async function getLeakResponseList(params?: any) {
  return request(`${api}/list`, {
    method: 'GET',
    params,
  });
}

/** 根据MSDS主表ID获取泄漏应急处理 */
export async function getLeakResponseByMsdsId(msdsId: number) {
  return request<API.Result<API.Msds.MsdsLeakResponse>>(`${api}/msds/${msdsId}`, {
    method: 'GET',
  });
}

/** 获取泄漏应急处理详情 */
export async function getLeakResponse(id: number) {
  return request<API.Result<API.Msds.MsdsLeakResponse>>(`${api}/${id}`, {
    method: 'GET',
  });
}

/** 新增泄漏应急处理 */
export async function addLeakResponse(data: API.Msds.MsdsLeakResponse) {
  return request<API.Result>(api, {
    method: 'POST',
    data,
  });
}

/** 修改泄漏应急处理 */
export async function updateLeakResponse(data: API.Msds.MsdsLeakResponse) {
  return request<API.Result>(api, {
    method: 'PUT',
    data,
  });
}

/** 删除泄漏应急处理 */
export async function removeLeakResponse(ids: number | number[]) {
  const idList = Array.isArray(ids) ? ids : [ids];
  return request<API.Result>(`${api}/${idList.join(',')}`, {
    method: 'DELETE',
  });
}

/** 根据MSDS主表ID删除泄漏应急处理 */
export async function removeLeakResponseByMsdsId(msdsId: number) {
  return request<API.Result>(`${api}/msds/${msdsId}`, {
    method: 'DELETE',
  });
}

/** 获取应急处理模板 */
export async function getLeakResponseTemplate(chemicalType?: string) {
  return request<API.Result<API.Msds.MsdsLeakResponse>>(`${api}/template`, {
    method: 'GET',
    params: { chemicalType },
  });
}

/** 根据化学品性质推荐应急处理措施 */
export async function getRecommendedLeakResponse(chemicalProperties: any) {
  return request<API.Result<Partial<API.Msds.MsdsLeakResponse>>>(`${api}/recommend`, {
    method: 'POST',
    data: chemicalProperties,
  });
}

/** 验证泄漏应急处理完整性 */
export async function validateLeakResponse(data: API.Msds.MsdsLeakResponse) {
  return request<API.Result<{ isValid: boolean; missingFields: string[]; warnings: string[] }>>(`${api}/validate`, {
    method: 'POST',
    data,
  });
}