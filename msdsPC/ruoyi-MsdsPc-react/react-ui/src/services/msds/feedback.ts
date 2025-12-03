import { request } from '@umijs/max';

/** 查询意见反馈列表 */
export async function listFeedback(params?: any) {
  return request<any>('/api/system/feedback/list', {
    method: 'GET',
    params: {
      ...params,
    },
  });
}

/** 获取意见反馈详细信息 */
export async function getFeedback(id: number) {
  return request<any>(`/api/system/feedback/${id}`, {
    method: 'GET',
  });
}

/** 新增意见反馈 */
export async function addFeedback(data: any) {
  return request<any>('/api/system/feedback', {
    method: 'POST',
    data,
  });
}

/** 修改意见反馈 */
export async function updateFeedback(data: any) {
  return request<any>('/api/system/feedback', {
    method: 'PUT',
    data,
  });
}

/** 删除意见反馈 */
export async function removeFeedback(ids: string) {
  return request<any>(`/api/system/feedback/${ids}`, {
    method: 'DELETE',
  });
}
