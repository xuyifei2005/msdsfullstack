import { request } from '@umijs/max';

// MSDS其他信息API服务
const api = '/api/system/msds/otherInfo';

/** 查询其他信息列表 */
export async function getOtherInfoList(params?: any) {
  return request(`${api}/list`, {
    method: 'GET',
    params,
  });
}

/** 根据MSDS主表ID获取其他信息 */
export async function getOtherInfoByMsdsId(msdsId: number) {
  return request<API.Result<API.Msds.MsdsOtherInfo>>(`${api}/msds/${msdsId}`, {
    method: 'GET',
  });
}

/** 获取其他信息详情 */
export async function getOtherInfo(id: number) {
  return request<API.Result<API.Msds.MsdsOtherInfo>>(`${api}/${id}`, {
    method: 'GET',
  });
}

/** 新增其他信息 */
export async function addOtherInfo(data: API.Msds.MsdsOtherInfo) {
  return request<API.Result>(api, {
    method: 'POST',
    data,
  });
}

/** 修改其他信息 */
export async function updateOtherInfo(data: API.Msds.MsdsOtherInfo) {
  return request<API.Result>(api, {
    method: 'PUT',
    data,
  });
}

/** 删除其他信息 */
export async function removeOtherInfo(ids: number | number[]) {
  const idList = Array.isArray(ids) ? ids : [ids];
  return request<API.Result>(`${api}/${idList.join(',')}`, {
    method: 'DELETE',
  });
}

/** 根据MSDS主表ID删除其他信息 */
export async function removeOtherInfoByMsdsId(msdsId: number) {
  return request<API.Result>(`${api}/${msdsId}`, {
    method: 'DELETE',
  });
}

/** 获取参考文献模板 */
export async function getReferenceTemplates() {
  return request<API.Result<any[]>>(`${api}/reference-templates`, {
    method: 'GET',
  });
}

/** 获取缩略语词典 */
export async function getAbbreviationDictionary() {
  return request<API.Result<any[]>>(`${api}/abbreviations`, {
    method: 'GET',
  });
}

/** 获取MSDS编制指南 */
export async function getPreparationGuidelines(region?: string) {
  return request<API.Result<any>>(`${api}/preparation-guidelines`, {
    method: 'GET',
    params: { region },
  });
}

/** 验证其他信息完整性 */
export async function validateOtherInfo(data: API.Msds.MsdsOtherInfo) {
  return request<API.Result<{ isValid: boolean; missingFields: string[]; warnings: string[] }>>(`${api}/validate`, {
    method: 'POST',
    data,
  });
}

/** 生成MSDS版本历史 */
export async function generateVersionHistory(msdsId: number) {
  return request<API.Result<any[]>>(`${api}/version-history/${msdsId}`, {
    method: 'GET',
  });
}