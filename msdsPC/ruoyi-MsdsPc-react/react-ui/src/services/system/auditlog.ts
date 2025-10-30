import { request } from '@umijs/max';
import { downLoadXlsx } from '@/utils/downloadfile';

const api = '/api/system/auditlog';

// 查询MSDS操作审计日志列表
export async function getAuditLogList(params?: API.System.MsdsAuditLogListParams) {
  return request<API.System.MsdsAuditLogPageResult>(`${api}/list`, {
    method: 'GET',
    headers: { 'Content-Type': 'application/json;charset=UTF-8' },
    params,
  });
}

// 查询MSDS操作审计日志详细
export function getAuditLog(logId: number) {
  return request<API.System.MsdsAuditLogInfoResult>(`${api}/${logId}`, {
    method: 'GET',
  });
}

// 删除MSDS操作审计日志
export async function removeAuditLog(ids: number | number[]) {
  const idList = Array.isArray(ids) ? ids : [ids];
  return request<API.Result>(`${api}/${idList.join(',')}`, {
    method: 'DELETE',
  });
}

// 导出MSDS操作审计日志
export function exportAuditLog(params?: API.System.MsdsAuditLogListParams) {
  return downLoadXlsx(`${api}/export`, { params }, `msds_audit_log_${new Date().getTime()}.xlsx`);
}

// 获取审计统计信息
export async function getAuditStatistics() {
  return request<API.Result>(`${api}/statistics`, { method: 'GET' });
}

// 获取操作类型分布统计
export async function getOperationTypeStatistics() {
  return request<API.Result>(`${api}/operationTypes`, { method: 'GET' });
}

// 获取操作人员活跃度统计
export async function getOperatorStatistics(days: number = 30) {
  return request<API.Result>(`${api}/operators`, { method: 'GET', params: { days } });
}