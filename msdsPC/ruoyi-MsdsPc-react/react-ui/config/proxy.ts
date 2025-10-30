/**
 * @name 代理的配置
 * @see 在生产环境 代理是无法生效的，所以这里没有生产环境的配置
 * -------------------------------
 * The agent cannot take effect in the production environment
 * so there is no configuration of the production environment
 * For details, please see
 * https://pro.ant.design/docs/deploy
 *
 * @doc https://umijs.org/docs/guides/proxy
 */

// 检测是否运行在 Docker 容器内（/.dockerenv 存在）
// 容器内默认后端地址为 http://msdsbackend:8080，本地开发默认 http://localhost:18080
// 同时读取 REACT_APP_API_URL 用于显式覆盖
// 注意：仅用于开发代理，不影响生产构建。
// eslint-disable-next-line @typescript-eslint/no-var-requires
const fs = require('fs');
const isDocker = fs.existsSync('/.dockerenv');
const DEFAULT_TARGET = isDocker ? 'http://msdsbackend:8080' : 'http://localhost:18080';
const BACKEND_TARGET = process.env.REACT_APP_API_URL || DEFAULT_TARGET;

// 打印当前使用的代理目标，便于调试（启动时输出一次）
// 如需关闭日志，可注释掉下一行
// eslint-disable-next-line no-console
console.info(`[proxy] Using BACKEND_TARGET = ${BACKEND_TARGET} (isDocker=${isDocker})`);

export default {
  // 如果需要自定义本地开发服务器  请取消注释按需调整
  dev: {
    // localhost:8000/api/** -> BACKEND_TARGET/**
    '/api/': {
      // 要代理的地址
      // 使用环境变量以便在 Docker 与本地环境间切换
      target: BACKEND_TARGET,
      // 配置了这个可以从 http 代理到 https
      // 依赖 origin 的功能可能需要这个，比如 cookie
      changeOrigin: true,
      pathRewrite: { '^/api': '' },
      // 增加超时时间
      timeout: 30000,
    },
    // 兜底：有些地方可能直接请求了 /captchaImage（缺少 /api 前缀），这里兼容代理
    '/captchaImage': {
      target: BACKEND_TARGET,
      changeOrigin: true,
      // 不改写路径，直接转发到后端的 /captchaImage
      pathRewrite: { '^/captchaImage': '/captchaImage' },
      timeout: 30000,
    },
    '/profile/avatar/': {
      // 使用相同的后端目标
      target: BACKEND_TARGET,
      changeOrigin: true,
    }
  },

  /**
   * @name 详细的代理配置
   * @doc https://github.com/chimurai/http-proxy-middleware
   */
  test: {
    // localhost:8000/api/** -> https://preview.pro.ant.design/api/**
    '/api/': {
      target: 'https://proapi.azurewebsites.net',
      changeOrigin: true,
      pathRewrite: { '^': '' },
    },
  },
  pre: {
    '/api/': {
      target: 'your pre url',
      changeOrigin: true,
      pathRewrite: { '^': '' },
    },
  },
};
