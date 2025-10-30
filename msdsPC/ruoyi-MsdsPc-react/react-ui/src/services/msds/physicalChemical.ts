import { request } from '@umijs/max';

// MSDS理化性质API服务
const api = '/api/system/msds/physicalchemical';

/** 查询理化性质列表 */
export async function getPhysicalChemicalList(params?: any) {
  return request(`${api}/list`, {
    method: 'GET',
    params,
  });
}

/** 根据MSDS主表ID获取理化性质 */
export async function getPhysicalChemicalByMsdsId(msdsId: number) {
  return request<API.Result<API.Msds.MsdsPhysicalChemical>>(`${api}/msds/${msdsId}`, {
    method: 'GET',
  });
}

/** 获取理化性质详情 */
export async function getPhysicalChemical(id: number) {
  return request<API.Result<API.Msds.MsdsPhysicalChemical>>(`${api}/${id}`, {
    method: 'GET',
  });
}

/** 新增理化性质 */
export async function addPhysicalChemical(data: API.Msds.MsdsPhysicalChemical) {
  return request<API.Result>(api, {
    method: 'POST',
    data,
  });
}

/** 修改理化性质 */
export async function updatePhysicalChemical(data: API.Msds.MsdsPhysicalChemical) {
  return request<API.Result>(api, {
    method: 'PUT',
    data,
  });
}

/** 删除理化性质 */
export async function removePhysicalChemical(ids: number | number[]) {
  const idList = Array.isArray(ids) ? ids : [ids];
  return request<API.Result>(`${api}/${idList.join(',')}`, {
    method: 'DELETE',
  });
}

/** 根据MSDS主表ID删除理化性质 */
export async function removePhysicalChemicalByMsdsId(msdsId: number) {
  return request<API.Result>(`${api}/${msdsId}`, {
    method: 'DELETE',
  });
}

/** 根据CAS号查询标准理化性质数据 */
export async function getStandardPhysicalChemical(casNumber: string) {
  return request<API.Result<Partial<API.Msds.MsdsPhysicalChemical>>>(`${api}/standard`, {
    method: 'GET',
    params: { casNumber },
  });
}

/** 验证理化性质数据合理性 */
export async function validatePhysicalChemicalData(data: API.Msds.MsdsPhysicalChemical) {
  return request<API.Result<{ isValid: boolean; warnings: string[]; suggestions: string[] }>>(`${api}/validate`, {
    method: 'POST',
    data,
  });
}

/** 获取理化性质测试方法 */
export async function getTestMethods() {
  return request<API.Result<any[]>>(`${api}/test-methods`, {
    method: 'GET',
  });
}

/** 计算理化性质相关参数 */
export async function calculatePhysicalProperties(inputData: any) {
  return request<API.Result<any>>(`${api}/calculate`, {
    method: 'POST',
    data: inputData,
  });
}