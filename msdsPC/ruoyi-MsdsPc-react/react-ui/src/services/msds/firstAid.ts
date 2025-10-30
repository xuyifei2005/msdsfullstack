import { request } from '@umijs/max';

// MSDS急救措施API服务
const api = '/api/system/msds/firstaid';

/** 查询急救措施列表 */
export async function getFirstAidList(params?: any) {
  return request(`${api}/list`, {
    method: 'GET',
    params,
  });
}

/** 根据MSDS主表ID获取急救措施 */
export async function getFirstAidByMsdsId(msdsId: number) {
  return request<API.Result<API.Msds.MsdsFirstAid>>(`${api}/msds/${msdsId}`, {
    method: 'GET',
  });
}

/** 获取急救措施详情 */
export async function getFirstAid(id: number) {
  return request<API.Result<API.Msds.MsdsFirstAid>>(`${api}/${id}`, {
    method: 'GET',
  });
}

/** 新增急救措施 */
export async function addFirstAid(data: API.Msds.MsdsFirstAid) {
  return request<API.Result>(api, {
    method: 'POST',
    data,
  });
}

/** 修改急救措施 */
export async function updateFirstAid(data: API.Msds.MsdsFirstAid) {
  return request<API.Result>(api, {
    method: 'PUT',
    data,
  });
}

/** 删除急救措施 */
export async function removeFirstAid(ids: number | number[]) {
  const idList = Array.isArray(ids) ? ids : [ids];
  return request<API.Result>(`${api}/${idList.join(',')}`, {
    method: 'DELETE',
  });
}

/** 根据MSDS主表ID删除急救措施 */
export async function removeFirstAidByMsdsId(msdsId: number) {
  return request<API.Result>(`${api}/${msdsId}`, {
    method: 'DELETE',
  });
}

/** 获取急救措施模板 */
export async function getFirstAidTemplate(hazardType?: string) {
  return request<API.Result<API.Msds.MsdsFirstAid>>(`${api}/template`, {
    method: 'GET',
    params: { hazardType },
  });
}

/** 根据危险性分类推荐急救措施 */
export async function getRecommendedFirstAid(ghsClassifications: string[]) {
  return request<API.Result<Partial<API.Msds.MsdsFirstAid>>>(`${api}/recommend`, {
    method: 'POST',
    data: { ghsClassifications },
  });
}

/** 验证急救措施完整性 */
export async function validateFirstAid(data: API.Msds.MsdsFirstAid) {
  return request<API.Result<{ isValid: boolean; missingFields: string[]; warnings: string[] }>>(`${api}/validate`, {
    method: 'POST',
    data,
  });
}