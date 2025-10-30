import { request } from '@umijs/max';

// MSDS毒理学信息API服务
const api = '/api/system/msds/toxicological';

/** 查询毒理学信息列表 */
export async function getToxicologyList(params?: any) {
  return request(`${api}/list`, {
    method: 'GET',
    params,
  });
}

/** 根据MSDS主表ID获取毒理学信息 */
export async function getToxicologyByMsdsId(msdsId: number) {
  return request<API.Result<API.Msds.MsdsToxicology>>(`${api}/msds/${msdsId}`, {
    method: 'GET',
  });
}

/** 获取毒理学信息详情 */
export async function getToxicology(id: number) {
  return request<API.Result<API.Msds.MsdsToxicology>>(`${api}/${id}`, {
    method: 'GET',
  });
}

/** 新增毒理学信息 */
export async function addToxicology(data: API.Msds.MsdsToxicology) {
  return request<API.Result>(api, {
    method: 'POST',
    data,
  });
}

/** 修改毒理学信息 */
export async function updateToxicology(data: API.Msds.MsdsToxicology) {
  return request<API.Result>(api, {
    method: 'PUT',
    data,
  });
}

/** 删除毒理学信息 */
export async function removeToxicology(ids: number | number[]) {
  const idList = Array.isArray(ids) ? ids : [ids];
  return request<API.Result>(`${api}/${idList.join(',')}`, {
    method: 'DELETE',
  });
}

/** 根据MSDS主表ID删除毒理学信息 */
export async function removeToxicologyByMsdsId(msdsId: number) {
  return request<API.Result>(`${api}/${msdsId}`, {
    method: 'DELETE',
  });
}

/** 根据CAS号查询毒理学数据 */
export async function getToxicologyDataByCas(casNumber: string) {
  return request<API.Result<Partial<API.Msds.MsdsToxicology>>>(`${api}/cas/${casNumber}`, {
    method: 'GET',
  });
}

/** 获取毒理学试验方法 */
export async function getToxicologyTestMethods() {
  return request<API.Result<any[]>>(`${api}/test-methods`, {
    method: 'GET',
  });
}

/** 获取毒性分级标准 */
export async function getToxicityClassification() {
  return request<API.Result<any[]>>(`${api}/toxicity-classification`, {
    method: 'GET',
  });
}

/** 计算毒性评估 */
export async function calculateToxicityAssessment(data: any) {
  return request<API.Result<any>>(`${api}/assess-toxicity`, {
    method: 'POST',
    data,
  });
}

/** 验证毒理学信息完整性 */
export async function validateToxicology(data: API.Msds.MsdsToxicology) {
  return request<API.Result<{ isValid: boolean; missingFields: string[]; warnings: string[] }>>(`${api}/validate`, {
    method: 'POST',
    data,
  });
}