import { request } from '@umijs/max';
import { downLoadXlsx } from '@/utils/downloadfile';
import type { MsdsType } from '@/types/msds';

// 查询MSDS主信息列表
export async function getMsdsMainList(params?: API.Msds.MsdsMainListParams, options?: { [key: string]: any }) {
  return request<API.Msds.MsdsMainPageResult>('/api/system/msds/list', {
    method: 'GET',
    headers: {
      'Content-Type': 'application/json;charset=UTF-8',
    },
    params,
    ...(options || {})
  });
}

// 查询MSDS主信息详细
export function getMsdsMain(id: number, options?: { [key: string]: any }) {
  return request<API.Msds.MsdsMainInfoResult>(`/api/system/msds/${id}`, {
    method: 'GET',
    ...(options || {})
  });
}

// 新增MSDS主信息
export async function addMsdsMain(params: API.Msds.MsdsMain, options?: { [key: string]: any }) {
  return request<API.Result>('/api/system/msds', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json;charset=UTF-8',
    },
    data: params,
    ...(options || {})
  });
}

// 修改MSDS主信息
export async function updateMsdsMain(params: API.Msds.MsdsMain, options?: { [key: string]: any }) {
  return request<API.Result>('/api/system/msds', {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json;charset=UTF-8',
    },
    data: params,
    ...(options || {})
  });
}

// 删除MSDS主信息
export async function removeMsdsMain(ids: string, options?: { [key: string]: any }) {
  return request<API.Result>(`/api/system/msds/${ids}`, {
    method: 'DELETE',
    ...(options || {})
  });
}

// 导出MSDS主信息
export function exportMsdsMain(params?: API.Msds.MsdsMainListParams, options?: { [key: string]: any }) {
  return downLoadXlsx(`/api/system/msds/export`, { params }, `msds_main_${new Date().getTime()}.xlsx`);
}

// 根据化学品名称查询MSDS信息
export async function getMsdsMainByProductName(productName: string, options?: { [key: string]: any }) {
  return request<API.Msds.MsdsMainInfoResult>('/api/system/msds/product', {
    method: 'GET',
    params: { productName },
    ...(options || {})
  });
}

// 根据企业名称查询MSDS列表
export async function getMsdsMainByCompany(companyName: string, options?: { [key: string]: any }) {
  return request<API.Msds.MsdsMainPageResult>('/api/system/msds/company', {
    method: 'GET',
    params: { companyName },
    ...(options || {})
  });
}

// 统计有效的MSDS数量
export async function countActiveMsds(options?: { [key: string]: any }) {
  return request<{ code: number; msg: string; data: number }>('/api/system/msds/count', {
    method: 'GET',
    ...(options || {})
  });
}

const api = '/api/system/msds';

/** 获取MSDS列表 */
export async function getMsdsList(params: any) {
  return request(`${api}/list`, {
    method: 'GET',
    params,
  });
}

/** 获取MSDS详情 */
export async function getMsdsDetail(id: number) {
  return request(`${api}/${id}`, {
    method: 'GET',
  });
}

/** 新增MSDS */
export async function addMsds(data: MsdsType) {
  return request(api, {
    method: 'POST',
    data,
  });
}

/** 修改MSDS */
export async function updateMsds(data: MsdsType) {
  return request(api, {
    method: 'PUT',
    data,
  });
}

/** 删除MSDS */
export async function removeMsds(ids: number | number[]) {
  const idList = Array.isArray(ids) ? ids : [ids];
  return request(`${api}/${idList.join(',')}`, {
    method: 'DELETE',
  });
}

/** 导入MSDS文档 */
export async function importMsdsDocument(
  formData: FormData,
  onProgress?: (progressEvent: any) => void
) {
  return request(`${api}/import`, {
    method: 'POST',
    data: formData,
    requestType: 'form',
    timeout: 300000, // 5分钟超时
    onUploadProgress: onProgress,
  });
}

/** 下载MSDS导入模板 */
export async function downloadImportTemplate() {
  return request(`${api}/importTemplate`, {
    method: 'GET',
    responseType: 'blob',
  }).then((blob) => {
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'MSDS导入模板.docx';
    document.body.appendChild(a);
    a.click();
    window.URL.revokeObjectURL(url);
    document.body.removeChild(a);
  });
}

/** 导出MSDS数据 */
export async function exportMsds(params: any) {
  return request(`${api}/export`, {
    method: 'POST',
    data: params,
    responseType: 'blob',
  }).then((blob) => {
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `MSDS数据_${new Date().toISOString().slice(0, 10)}.xlsx`;
    document.body.appendChild(a);
    a.click();
    window.URL.revokeObjectURL(url);
    document.body.removeChild(a);
  });
} 