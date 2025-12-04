import request from '@/utils/request'

// 查询常见问题列表
export function listFaq(query) {
  return request({
    url: '/system/faq/app/list',
    method: 'get',
    params: query
  })
}

// 查询常见问题详细
export function getFaq(id) {
  return request({
    url: '/system/faq/' + id,
    method: 'get'
  })
}
