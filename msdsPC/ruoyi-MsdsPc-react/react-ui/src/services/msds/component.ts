import { request } from '@umijs/max';

// MSDS成分/组成信息API服务
const api = '/api/system/msds/component';

/** 查询成分/组成信息列表 */
export async function getComponentList(params?: any) {
  return request(`${api}/list`, {
    method: 'GET',
    params,
  });
}

/** 根据MSDS主表ID获取成分/组成信息 */
export async function getComponentByMsdsId(msdsId: number) {
  return request<API.Result<API.Msds.MsdsComponent[]>>(`${api}/msds/${msdsId}`, {
    method: 'GET',
  });
}

/** 获取成分/组成信息详情 */
export async function getComponent(id: number) {
  return request<API.Result<API.Msds.MsdsComponent>>(`${api}/${id}`, {
    method: 'GET',
  });
}

/** 新增成分/组成信息 */
export async function addComponent(data: API.Msds.MsdsComponent) {
  return request<API.Result>(api, {
    method: 'POST',
    data,
  });
}

/** 修改成分/组成信息 */
export async function updateComponent(data: API.Msds.MsdsComponent) {
  return request<API.Result>(api, {
    method: 'PUT',
    data,
  });
}

/** 删除成分/组成信息 */
export async function removeComponent(ids: number | number[]) {
  const idList = Array.isArray(ids) ? ids : [ids];
  return request<API.Result>(`${api}/${idList.join(',')}`, {
    method: 'DELETE',
  });
}

/** 根据MSDS主表ID删除成分/组成信息 */
export async function removeComponentByMsdsId(msdsId: number) {
  return request<API.Result>(`${api}/${msdsId}`, {
    method: 'DELETE',
  });
}

/** 批量保存成分/组成信息 */
export async function batchSaveComponent(data: API.Msds.MsdsComponent[]) {
  return request<API.Result>(`${api}/batch`, {
    method: 'POST',
    data,
  });
}

/** 验证CAS号格式 */
export async function validateCasNumber(casNumber: string) {
  return request<API.Result<boolean>>(`${api}/validate/cas`, {
    method: 'GET',
    params: { casNumber },
  });
}

/** 根据CAS号查询化学品信息 */
export async function getChemicalInfoByCas(casNumber: string) {
  return request<API.Result<any>>(`${api}/chemical/cas`, {
    method: 'GET',
    params: { casNumber },
  });
}