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

// 根据MSDS ID获取急救措施
export function getMsdsFirstAidByMsdsId(msdsId) {
  return request({
    url: '/system/msds/firstaid/msds/' + msdsId,
    method: 'get'
  })
}

// 根据MSDS ID获取成分信息
export function getMsdsComponentByMsdsId(msdsId) {
  return request({
    url: '/system/msds/component/msds/' + msdsId,
    method: 'get'
  })
}

// 根据MSDS ID获取泄漏应急处理
export function getMsdsLeakResponseByMsdsId(msdsId) {
  return request({
    url: '/system/msds/leakresponse/msds/' + msdsId,
    method: 'get'
  })
}

// 根据MSDS ID获取理化特性
export function getMsdsPhysicalChemicalByMsdsId(msdsId) {
  return request({
    url: '/system/msds/physicalchemical/msds/' + msdsId,
    method: 'get'
  })
}
