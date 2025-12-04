import request from '@/utils/request'

// 查询关于我们列表
export function listAbout(query) {
  return request({
    url: '/system/about/app/list',
    method: 'get',
    params: query
  })
}

// 查询关于我们详细
export function getAbout(id) {
  return request({
    url: '/system/about/' + id,
    method: 'get'
  })
}
