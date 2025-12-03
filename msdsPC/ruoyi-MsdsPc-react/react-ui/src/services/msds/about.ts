import { request } from '@umijs/max';

/** 查询关于我们列表 */
export async function listAbout(params?: any) {
  return request<any>('/api/system/about/list', {
    method: 'GET',
    params: {
      ...params,
    },
  });
}

/** 获取关于我们详细信息 */
export async function getAbout(id: number) {
  return request<any>(`/api/system/about/${id}`, {
    method: 'GET',
  });
}

/** 新增关于我们 */
export async function addAbout(data: any) {
  return request<any>('/api/system/about', {
    method: 'POST',
    data,
  });
}

/** 修改关于我们 */
export async function updateAbout(data: any) {
  return request<any>('/api/system/about', {
    method: 'PUT',
    data,
  });
}

/** 删除关于我们 */
export async function removeAbout(ids: string) {
  return request<any>(`/api/system/about/${ids}`, {
    method: 'DELETE',
  });
}
