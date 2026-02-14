// 应用全局配置
module.exports = {
  baseUrlList: [
    'http://192.168.1.215:18080',
    'http://192.168.0.101:18080',
    'http://localhost:18080'
    
  ],
  baseUrl: '',

  // 应用信息
  appInfo: {
    // 应用名称
    name: "安全智库",
    // 应用版本
    version: "1.2.0",
    // 应用logo
    logo: "/static/logo_new.png",
    // 官方网站
    site_url: "http://ruoyi.vip",
    // 政策协议
    agreements: [{
        title: "隐私政策",
        url: "https://ruoyi.vip/protocol.html"
      },
      {
        title: "用户服务协议",
        url: "https://ruoyi.vip/protocol.html"
      }
    ]
  }
}
