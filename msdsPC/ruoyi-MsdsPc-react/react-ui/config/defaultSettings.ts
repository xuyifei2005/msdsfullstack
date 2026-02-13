import { ProLayoutProps } from '@ant-design/pro-components';

/**
 * @name
 */
const Settings: ProLayoutProps & {
  pwa?: boolean;
  logo?: string;
} = {
  navTheme: 'light',
  // 现代明亮风格
  colorPrimary: '#1890ff',
  colorSuccess: '#43cd80',
  colorWarning: '#faad14',
  colorError: '#ff4d4f',
  colorInfo: '#1890ff',
  layout: 'mix',
  contentWidth: 'Fluid',
  fixedHeader: false,
  fixSiderbar: true,
  colorWeak: false,
  title: 'MSDS安全智库网',
  pwa: true,
  logo: 'https://gw.alipayobjects.com/zos/rmsportal/KDpgvguMpGfqaHPjicRK.svg',
  iconfontUrl: '',
  collapsed: false, // 强制侧边栏默认展开
  token: {
    // 参见ts声明，demo 见文档，通过token 修改样式
    //https://procomponents.ant.design/components/layout#%E9%80%9A%E8%BF%87-token-%E4%BF%AE%E6%94%B9%E6%A0%B7%E5%BC%8F
    colorBgAppList: '#f8fafc',
    colorBgLayout: '#f1f5f9',
    colorBgSpotlight: '#ffffff',
    colorBgContainer: '#ffffff',
    colorBorder: '#e2e8f0',
    colorBorderSecondary: '#f1f5f9',
    colorTextBase: '#1e293b',
    colorTextSecondary: '#64748b',
    colorTextTertiary: '#94a3b8',
    colorTextQuaternary: '#cbd5e1',
    colorFillAlter: 'rgba(24, 144, 255, 0.06)',
    colorFillContent: 'rgba(24, 144, 255, 0.04)',
    colorFillSecondary: 'rgba(24, 144, 255, 0.02)',
    colorBgTextHover: 'rgba(24, 144, 255, 0.06)',
    colorBgSpotlightHover: 'rgba(67, 205, 128, 0.08)',
    borderRadius: 12,
    fontDefault: `Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif`,
  },
};

export default Settings;
