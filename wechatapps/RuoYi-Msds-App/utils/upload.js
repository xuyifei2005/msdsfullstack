import store from '@/store'
import cfg from '@/config'
import { getToken } from '@/utils/auth'
import errorCode from '@/utils/errorCode'
import { toast, showConfirm, tansParams } from '@/utils/common'

let timeout = 10000
let detecting = null

const normalize = (u) => (u && u.startsWith('http')) ? u : (u ? 'http://' + u : '')
const getList = () => (cfg.baseUrlList || []).map(normalize)
const detectOne = (u) => new Promise((resolve) => {
  uni.request({ method: 'get', timeout: 1500, url: u + '/captchaImage', header: { isToken: false }, dataType: 'json' })
    .then(r => { const [, res] = r; resolve(!!(res && res.statusCode === 200)) })
    .catch(() => resolve(false))
})

const ensureBaseUrl = async () => {
  if (cfg.baseUrl) return cfg.baseUrl
  if (!detecting) {
    detecting = new Promise((resolve) => {
      const list = getList()
      const cached = uni.getStorageSync('baseUrl')
      if (cached) {
        cfg.baseUrl = normalize(cached)
        detecting = null
        resolve(cfg.baseUrl)
        return
      }
      const tryNext = (i) => {
        if (i >= list.length) {
          cfg.baseUrl = list[0] || ''
          detecting = null
          resolve(cfg.baseUrl)
          return
        }
        const candidate = list[i]
        detectOne(candidate).then(ok => {
          if (ok) {
            cfg.baseUrl = candidate
            uni.setStorageSync('baseUrl', candidate)
            detecting = null
            resolve(candidate)
          } else {
            tryNext(i + 1)
          }
        })
      }
      tryNext(0)
    })
  }
  return detecting
}

const upload = options => {
  // 是否需要设置 token
  const isToken = (options.headers || {}).isToken === false
  options.header = options.header || {}
  if (getToken() && !isToken) {
    options.header['Authorization'] = 'Bearer ' + getToken()
  }
  // get请求映射params参数
  if (options.params) {
    let url = options.url + '?' + tansParams(options.params)
    url = url.slice(0, -1)
    options.url = url
  }
  return new Promise(async (resolve, reject) => {
      await ensureBaseUrl()
      const send = () => uni.uploadFile({
        timeout: options.timeout || timeout,
        url: (options.baseUrl || cfg.baseUrl) + options.url,
        filePath: options.filePath,
        name: options.name || 'file',
        header: options.header,
        formData: options.formData,
        success: (res) => {
          let result = JSON.parse(res.data)
          const code = result.code || 200
          const msg = errorCode[code] || result.msg || errorCode['default']
          if (code === 200) {
            resolve(result)
          } else if (code == 401) {
            showConfirm("登录状态已过期，您可以继续留在该页面，或者重新登录?").then(res => {
              if (res.confirm) {
                store.dispatch('LogOut').then(res => {
                  uni.reLaunch({ url: '/pages/login/login' })
                })
              }
            })
            reject('无效的会话，或者会话已过期，请重新登录。')
          } else if (code === 500) {
            toast(msg)
            reject('500')
          } else if (code !== 200) {
            toast(msg)
            reject(code)
          }
        },
        fail: (error) => {
          let { message } = error
          if (message == 'Network Error') {
            message = '后端接口连接异常'
          } else if (message.includes('timeout')) {
            message = '系统接口请求超时'
          } else if (message.includes('Request failed with status code')) {
            message = '系统接口' + message.substr(message.length - 3) + '异常'
          }
          const list = getList()
          const idx = Math.max(0, list.indexOf(normalize(cfg.baseUrl)))
          const tryNext = async (i) => {
            if (i >= list.length) {
              toast(message)
              reject(error)
              return
            }
            const candidate = list[i]
            const ok = await detectOne(candidate)
            if (ok) {
              cfg.baseUrl = candidate
              uni.setStorageSync('baseUrl', candidate)
              send()
            } else {
              tryNext(i + 1)
            }
          }
          tryNext(idx + 1)
        }
      })
      send()
  })
}

export default upload
