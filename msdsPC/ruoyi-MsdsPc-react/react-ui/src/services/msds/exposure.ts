import { request } from '@umijs/max';

// MSDS接触控制/个体防护API服务
const api = '/api/system/msds/exposure';

/** 查询接触控制/个体防护列表 */
export async function getExposureList(params?: any) {
  return request(`${api}/list`, {
    method: 'GET',
    params,
  });
}

/** 根据MSDS主表ID获取接触控制/个体防护 */
export async function getExposureByMsdsId(msdsId: number) {
  return request<API.Result<API.Msds.MsdsExposure>>(`${api}/msds/${msdsId}`, {
    method: 'GET',
  });
}

/** 获取接触控制/个体防护详情 */
export async function getExposure(id: number) {
  return request<API.Result<API.Msds.MsdsExposure>>(`${api}/${id}`, {
    method: 'GET',
  });
}

/** 新增接触控制/个体防护 */
export async function addExposure(data: API.Msds.MsdsExposure) {
  return request<API.Result>(api, {
    method: 'POST',
    data,
  });
}

/** 修改接触控制/个体防护 */
export async function updateExposure(data: API.Msds.MsdsExposure) {
  return request<API.Result>(api, {
    method: 'PUT',
    data,
  });
}

/** 删除接触控制/个体防护 */
export async function removeExposure(ids: number | number[]) {
  const idList = Array.isArray(ids) ? ids : [ids];
  return request<API.Result>(`${api}/${idList.join(',')}`, {
    method: 'DELETE',
  });
}

/** 根据MSDS主表ID删除接触控制/个体防护 */
export async function removeExposureByMsdsId(msdsId: number) {
  return request<API.Result>(`${api}/${msdsId}`, {
    method: 'DELETE',
  });
}

/** 获取职业接触限值标�?*/
export async function getOccupationalExposureLimits(casNumber?: string) {
  return request<API.Result<any[]>>(`${api}/exposure-limits`, {
    method: 'GET',
    params: { casNumber },
  });
}

/** 获取个体防护设备推荐 */
export async function getPersonalProtectiveEquipment(hazardTypes: string[]) {
  return request<API.Result<any>>(`${api}/ppe-recommend`, {
    method: 'POST',
    data: { hazardTypes },
  });
}

/** 获取工程控制措施推荐 */
export async function getEngineeringControls(exposureScenario: any) {
  return request<API.Result<any>>(`${api}/engineering-controls`, {
    method: 'POST',
    data: exposureScenario,
  });
}

/** 验证接触控制/个体防护完整�?*/
export async function validateExposure(data: API.Msds.MsdsExposure) {
  return request<API.Result<{ isValid: boolean; missingFields: string[]; warnings: string[] }>>(`${api}/validate`, {
    method: 'POST',
    data,
  });
}
