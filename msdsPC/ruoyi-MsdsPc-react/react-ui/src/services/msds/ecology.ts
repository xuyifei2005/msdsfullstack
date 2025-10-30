import { request } from '@umijs/max';

// MSDS生态学信息API服务
const api = '/api/system/msds/ecology';

/** 查询生态学信息列表 */
export async function getEcologyList(params?: any) {
  return request(`${api}/list`, {
    method: 'GET',
    params,
  });
}

/** 根据MSDS主表ID获取生态学信息 */
export async function getEcologyByMsdsId(msdsId: number) {
  return request<API.Result<API.Msds.MsdsEcology>>(`${api}/msds/${msdsId}`, {
    method: 'GET',
  });
}

/** 获取生态学信息详情 */
export async function getEcology(id: number) {
  return request<API.Result<API.Msds.MsdsEcology>>(`${api}/${id}`, {
    method: 'GET',
  });
}

/** 新增生态学信息 */
export async function addEcology(data: API.Msds.MsdsEcology) {
  return request<API.Result>(api, {
    method: 'POST',
    data,
  });
}

/** 修改生态学信息 */
export async function updateEcology(data: API.Msds.MsdsEcology) {
  return request<API.Result>(api, {
    method: 'PUT',
    data,
  });
}

/** 删除生态学信息 */
export async function removeEcology(ids: number | number[]) {
  const idList = Array.isArray(ids) ? ids : [ids];
  return request<API.Result>(`${api}/${idList.join(',')}`, {
    method: 'DELETE',
  });
}

/** 根据MSDS主表ID删除生态学信息 */
export async function removeEcologyByMsdsId(msdsId: number) {
  return request<API.Result>(`${api}/${msdsId}`, {
    method: 'DELETE',
  });
}

/** 根据CAS号查询生态毒性数据 */
export async function getEcotoxicityDataByCas(casNumber: string) {
  return request<API.Result<Partial<API.Msds.MsdsEcology>>>(`${api}/cas/${casNumber}`, {
    method: 'GET',
  });
}

/** 获取生态毒性试验方法 */
export async function getEcotoxicityTestMethods() {
  return request<API.Result<any[]>>(`${api}/test-methods`, {
    method: 'GET',
  });
}

/** 获取环境归趋评估 */
export async function getEnvironmentalFate(chemicalProperties: any) {
  return request<API.Result<any>>(`${api}/environmental-fate`, {
    method: 'POST',
    data: chemicalProperties,
  });
}

/** 计算生物累积性 */
export async function calculateBioaccumulation(data: any) {
  return request<API.Result<any>>(`${api}/bioaccumulation`, {
    method: 'POST',
    data,
  });
}

/** 验证生态学信息完整性 */
export async function validateEcology(data: API.Msds.MsdsEcology) {
  return request<API.Result<{ isValid: boolean; missingFields: string[]; warnings: string[] }>>(`${api}/validate`, {
    method: 'POST',
    data,
  });
}