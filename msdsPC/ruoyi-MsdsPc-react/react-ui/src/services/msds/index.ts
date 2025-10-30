import { request } from '@umijs/max';
import { downLoadXlsx, resolveBlob } from '@/utils/downloadfile';

// 导入所有子表API服务
export * from './component';
export * from './hazard';
export * from './firstAid';
export * from './fireFighting';
export * from './leakResponse';
export * from './handling';
export * from './exposure';
export * from './physicalChemical';
export * from './stabilityReactivity';
export * from './toxicology';
export * from './ecology';
export * from './disposal';
export * from './transport';
export * from './regulatory';
export * from './otherInfo';

// 统一对外导出的 MSDS 预览相关类型，供前端模块间复用
export interface MsdsPreviewItem {
  fileName: string;
  productName: string;
  productEnglishName?: string;
  casNumber?: string;
  companyName?: string;
  version?: string;
  status: 'success' | 'warning' | 'error';
  errorMessage?: string;
}

export interface MsdsPreviewResponse {
  previewList: MsdsPreviewItem[];
  previewSectionsMap?: Record<string, MsdsSection[]>; // 可选：按文件名聚合的章节字段映射
}

// 结构化章节与字段（前端侧抽象，便于渲染与高亮），后端联调时可调整
export type MsdsFieldStatus = 'success' | 'warning' | 'error';
export interface MsdsSectionField {
  key: string;        // 字段唯一键
  label: string;      // 展示名
  value?: string;     // 字段值
  status: MsdsFieldStatus; // 命中状态
  hint?: string;      // 额外提示
}
export interface MsdsSection {
  id: number;         // 章节序号 1..16
  title: string;      // 章节标题
  fields: MsdsSectionField[]; // 字段列表
}

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
  return downLoadXlsx(`/api/system/msds/export`, { params }, `MSDS主信息_${new Date().getTime()}.xlsx`);
}

// 根据产品名称查询MSDS
export async function getMsdsMainByProductName(productName: string, options?: { [key: string]: any }) {
  return request<API.Msds.MsdsMainListResult>(`/api/system/msds/byProductName`, {
    method: 'GET',
    params: { productName },
    ...(options || {})
  });
}

// 根据公司名称查询MSDS
export async function getMsdsMainByCompany(companyName: string, options?: { [key: string]: any }) {
  return request<API.Msds.MsdsMainListResult>(`/api/system/msds/byCompany`, {
    method: 'GET',
    params: { companyName },
    ...(options || {})
  });
}

// 统计有效MSDS数量
export async function countActiveMsds(options?: { [key: string]: any }) {
  return request<API.Msds.CountResult>(`/api/system/msds/count/active`, {
    method: 'GET',
    ...(options || {})
  });
}

const api = '/api/system/msds';

/** 查询MSDS列表 */
export async function getMsdsList(params: any) {
  return request(`${api}/list`, {
    method: 'GET',
    params,
  });
}

/** 获取MSDS详情 */
export async function getMsdsDetail(id: number) {
  // 统一使用 getMsdsMain，避免重复实现
  return getMsdsMain(id);
}

/** 新增MSDS */
export async function addMsds(data: API.Msds.MsdsMain) {
  return request(api, {
    method: 'POST',
    data,
  });
}

/** 更新MSDS */
export async function updateMsds(data: API.Msds.MsdsMain) {
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

/** 预览MSDS文档 */
export async function previewMsdsDocument(
  formData: FormData,
  onProgress?: (progressEvent: any) => void
) {
  return request<API.Result<MsdsPreviewResponse>>(`${api}/preview`, {
    method: 'POST',
    data: formData,
    requestType: 'form',
    timeout: 300000, // 5分钟超时
    onUploadProgress: onProgress,
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

/** 导入XML格式的MSDS文档 */
export async function importMsdsXml(
  formData: FormData,
  onProgress?: (progressEvent: any) => void
) {
  return request(`${api}/importXml`, {
    method: 'POST',
    data: formData,
    requestType: 'form',
    timeout: 300000, // 5分钟超时
    onUploadProgress: onProgress,
  });
}

/** 下载MSDS导入模板 */
export async function downloadImportTemplate(
  templateType: 'basic' | 'detailed' | 'full' = 'basic',
  scope?: 'all' | 'current',
  tableName?: string
) {
  const params: any = { templateType };
  if (scope) {
    params.scope = scope;
  }
  if (tableName) {
    params.tableName = tableName;
  }
  
  return request(`${api}/importTemplate`, {
    method: 'GET',
    responseType: 'blob',
    getResponse: true,
    params,
  }).then((res) => {
    // 优先使用后端响应头中的文件名，避免前端硬编码重复后缀或错误文件名
    resolveBlob(res, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
  });
}

/** Excel校验接口 */
export async function validateExcelFile(
  formData: FormData,
  onProgress?: (progressEvent: any) => void
) {
  return request<API.Result>('/api/system/msds/validateExcel', {
    method: 'POST',
    data: formData,
    onUploadProgress: onProgress,
    headers: {
      'Content-Type': 'multipart/form-data',
    },
  });
}