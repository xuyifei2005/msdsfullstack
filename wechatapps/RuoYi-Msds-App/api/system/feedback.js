import request from '@/utils/request'

// 新增意见反馈
export function addFeedback(data) {
  return request({
    url: '/system/feedback/app/add',
    method: 'post',
    data: data
  })
}
