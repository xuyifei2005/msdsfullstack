/**
 * @name umi 的路由配置
 * @description 只支持 path,component,routes,redirect,wrappers,name,icon 的配置
 * @param path  path 只支持两种占位符配置，第一种是动态参数 :id 的形式，第二种是 * 通配符，通配符只能出现路由字符串的最后。
 * @param component 配置 location 和 path 匹配后用于渲染的 React 组件路径。可以是绝对路径，也可以是相对路径，如果是相对路径，会从 src/pages 开始找起。
 * @param routes 配置子路由，通常在需要为多个路径增加 layout 组件时使用。
 * @param redirect 配置路由跳转
 * @param wrappers 配置路由组件的包装组件，通过包装组件可以为当前的路由组件组合进更多的功能。 比如，可以用于路由级别的权限校验
 * @param name 配置路由的标题，默认读取国际化文件 menu.ts 中 menu.xxxx 的值，如配置 name 为 login，则读取 menu.ts 中 menu.login 的取值作为标题
 * @param icon 配置路由的图标，取值参考 https://ant.design/components/icon-cn， 注意去除风格后缀和大小写，如想要配置图标为 <StepBackwardOutlined /> 则取值应为 stepBackward 或 StepBackward，如想要配置图标为 <UserOutlined /> 则取值应为 user 或者 User
 * @doc https://umijs.org/docs/guides/routes
 */
export default [
  {
    path: '/',
    redirect: '/dashboard',
  },
  {
    name: 'dashboard',
    path: '/dashboard',
    component: './Dashboard',
    icon: 'dashboard',
  },
  {
    name: 'intelligent-search',
    path: '/intelligent-search',
    component: './Msds/IntelligentSearch',
    icon: 'search',
    routes: [
      {
        path: '/intelligent-search',
        redirect: '/intelligent-search/index',
      },
      {
        path: '/intelligent-search/index',
        component: './Msds/IntelligentSearch',
      },
    ],
  },
  {
    path: '*',
    layout: false,
    component: './404',
  },
  {
    path: '/user',
    layout: false,
    routes: [
      {
        name: 'login',
        path: '/user/login',
        component: './User/Login',
      },
    ],
  },
  {
    path: '/test',
    layout: false,
    component: './Test',
  },
  {
    path: '/account',
    routes: [
      {
        name: 'acenter',
        path: '/account/center',
        component: './User/Center',
      },
      {
        name: 'asettings',
        path: '/account/settings',
        component: './User/Settings',
      },
      {
        name: '常见问题管理',
        path: '/account/faq',
        component: './Msds/Faq',
      },
      {
        name: '意见反馈管理',
        path: '/account/feedback',
        component: './Msds/Feedback',
      },
      {
        name: '关于我们管理',
        path: '/account/about',
        component: './Msds/About',
      },
    ],
  },
  {
    name: 'system',
    path: '/system',
    routes: [
      {
        name: 'menu',
        path: '/system/menu',
        component: './System/Menu',
      },
      {
        name: '字典数据',
        path: '/system/dict-data/index/:id',
        component: './System/DictData',
      },
      {
        name: '分配用户',
        path: '/system/role-auth/user/:id',
        component: './System/Role/authUser',
      },
      {
        name: 'MSDS审计日志',
        path: '/system/auditlog',
        component: './System/AuditLog',
      },
      {
        name: 'MSDS审计统计',
        path: '/system/audit-statistics',
        component: './System/AuditStatistics',
      },

    ]
  },
  {
    name: 'workflow',
    path: '/workflow',
    icon: 'team',
    routes: [
      {
        name: '工作流看板',
        path: '/workflow/board',
        component: './Workflow/index',
      },
    ]
  },
  {
    name: 'monitor',
    path: '/monitor',
    routes: [
      {
        name: 'menu.monitor.online',
        path: '/monitor/online',
        component: './Monitor/Online',
      },
      {
        name: 'menu.monitor.job-log',
        path: '/monitor/job-log/index/:id',
        component: './Monitor/JobLog',
      },
    ]
  },
  {
    name: 'tool',
    path: '/tool',
    routes: [
      {
        name: '代码生成',
        path: '/tool/gen',
        component: './Tool/Gen/index',
      },
      {
        name: '导入表',
        path: '/tool/gen/import',
        component: './Tool/Gen/import',
      },
      {
        name: '编辑表',
        path: '/tool/gen/edit',
        component: './Tool/Gen/edit',
      },
    ]
  },
  {
    name: 'msds',
    path: '/msds',
    routes: [
      {
        name: 'MSDS管理',
        path: '/msds/main',
        component: './Msds/index',
      },
      // 新增：数据分析报告
      {
        name: '数据分析',
        path: '/msds/analytics',
        component: './Analytics/DataReport',
        icon: 'barChart',
      },
      // 新增：MSDS 预览页面路由
      {
        name: 'MSDS预览',
        path: '/msds/preview',
        component: './Msds/Preview',
      },
      // 新增：智能搜索页面路由
      {
        name: '智能搜索',
        path: '/msds/search',
        component: './Msds/IntelligentSearch',
        icon: 'search',
      },
      // 新增：AI 智能解析录入
      {
        name: 'AI 智能解析',
        path: '/msds/ai-import',
        component: './Msds/AiImport',
        icon: 'robot',
      },
      // MSDS详情页面路由
      {
        name: 'MSDS详情',
        path: '/msds/detail/:id',
        component: './Msds/Detail',
        hideInMenu: true,
      },
    ]
  },
];
