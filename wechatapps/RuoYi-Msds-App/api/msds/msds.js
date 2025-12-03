import request from '@/utils/request'

// 查询MSDS主信息列表
export function listMsds(query) {
  return request({
    url: '/system/msds/list',
    method: 'get',
    params: query
  })
}

// 查询MSDS主信息详细
export function getMsds(id) {
  return request({
    url: '/system/msds/' + id,
    method: 'get'
  })
}

// 获取MSDS统计信息
export function getMsdsStatistics() {
  return request({
    url: '/system/msds/statistics',
    method: 'get'
  })
}
