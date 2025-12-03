import { request } from '@umijs/max';

/** 查询常见问题列表 */
export async function listFaq(params?: any) {
  return request<any>('/api/system/faq/list', {
    method: 'GET',
    params: {
      ...params,
    },
  });
}

/** 获取常见问题详细信息 */
export async function getFaq(id: number) {
  return request<any>(`/api/system/faq/${id}`, {
    method: 'GET',
  });
}

/** 新增常见问题 */
export async function addFaq(data: any) {
  return request<any>('/api/system/faq', {
    method: 'POST',
    data,
  });
}

/** 修改常见问题 */
export async function updateFaq(data: any) {
  return request<any>('/api/system/faq', {
    method: 'PUT',
    data,
  });
}

/** 删除常见问题 */
export async function removeFaq(ids: string) {
  return request<any>(`/api/system/faq/${ids}`, {
    method: 'DELETE',
  });
}
