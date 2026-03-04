import { Footer, SelectLang, AvatarDropdown, AvatarName } from '@/components';
import type { Settings as LayoutSettings } from '@ant-design/pro-components';
import { SettingDrawer } from '@ant-design/pro-components';
import type { RunTimeLayoutConfig } from '@umijs/max';
import { history, Link } from '@umijs/max';
import { App, Tooltip } from 'antd';
import defaultSettings from '../config/defaultSettings';
import { errorConfig } from './requestErrorConfig';
import { clearSessionToken, getAccessToken, getRefreshToken, getTokenExpireTime } from './access';
import { getRemoteMenu, getRoutersInfo, getUserInfo, patchRouteWithRemoteMenus, setRemoteMenu, getRemoteMenuWithRetry } from './services/session';
import { PageEnum } from './enums/pagesEnums';


const isDev = process.env.NODE_ENV === 'development';


/**
 * @see  https://umijs.org/zh-CN/plugins/plugin-initial-state
 * */
export async function getInitialState(): Promise<{
  settings?: Partial<LayoutSettings>;
  currentUser?: API.CurrentUser;
  loading?: boolean;
  fetchUserInfo?: () => Promise<API.CurrentUser | undefined>;
}> {
  const fetchUserInfo = async () => {
    try {
      const response = await getUserInfo({
        skipErrorHandler: true,
      });
      if (response.user.avatar === '') {
        response.user.avatar =
          'https://gw.alipayobjects.com/zos/rmsportal/BiazfanxmamNRoxxVxka.png';
      }
      return {
        ...response.user,
        permissions: response.permissions,
        roles: response.roles,
      } as API.CurrentUser;
    } catch (error) {
      console.log(error);
      history.push(PageEnum.LOGIN);
    }
    return undefined;
  };
  // 如果不是登录页面，执行
  const { location } = history;
  if (location.pathname !== PageEnum.LOGIN) {
    const currentUser = await fetchUserInfo();
    
    // 预加载菜单数据，提高用户体验
    try {
      await getRemoteMenuWithRetry();
    } catch (error) {
      console.warn('预加载菜单数据失败:', error);
      // 不阻塞页面渲染
    }
    
    return {
      fetchUserInfo,
      currentUser,
      settings: defaultSettings as Partial<LayoutSettings>,
    };
  }
  return {
    fetchUserInfo,
    settings: defaultSettings as Partial<LayoutSettings>,
  };
}

// ProLayout 支持的api https://procomponents.ant.design/components/layout
export const layout: RunTimeLayoutConfig = ({ initialState, setInitialState }) => {
  return {
    actionsRender: () => [<SelectLang key="SelectLang" />],
    avatarProps: {
      src: initialState?.currentUser?.avatar,
      title: <AvatarName />,
      render: (_, avatarChildren) => {
        return <AvatarDropdown menu={true}>{avatarChildren}</AvatarDropdown>;
      },
    },
    waterMarkProps: {
      // content: initialState?.currentUser?.nickName,
    },
    menu: {
      locale: false,
      // 每当 initialState?.currentUser?.userid 发生修改时重新执行 request
      params: {
        userId: initialState?.currentUser?.userId,
      },
      request: async () => {
        if (!initialState?.currentUser?.userId) {
          return [];
        }
        try {
          // 使用新的重试机制获取菜单
          const menu = await getRemoteMenuWithRetry();
          return menu || [];
        } catch (error) {
          console.error('菜单加载失败:', error);
          // 如果获取失败，尝试使用缓存的数据
          const cachedMenu = getRemoteMenu();
          return cachedMenu || [];
        }
      },
    },
    footerRender: () => <Footer />,
    onPageChange: () => {
      const { location } = history;
      // 如果没有登录，重定向到 login
      if (!initialState?.currentUser && location.pathname !== PageEnum.LOGIN) {
        history.push(PageEnum.LOGIN);
      }
    },
    layoutBgImgList: [
      {
        src: 'https://mdn.alipayobjects.com/yuyan_qk0oxh/afts/img/D2LWSqNny4sAAAAAAAAAAAAAFl94AQBr',
        left: 85,
        bottom: 100,
        height: '303px',
      },
      {
        src: 'https://mdn.alipayobjects.com/yuyan_qk0oxh/afts/img/C2TWRpJpiC0AAAAAAAAAAAAAFl94AQBr',
        bottom: -68,
        right: -45,
        height: '303px',
      },
      {
        src: 'https://mdn.alipayobjects.com/yuyan_qk0oxh/afts/img/F6vSTbj8KpYAAAAAAAAAAAAAFl94AQBr',
        bottom: 0,
        left: 0,
        width: '331px',
      },
    ],
    links: [],
    menuHeaderRender: undefined,
    // 自定义 403 页面
    // unAccessible: <div>unAccessible</div>,
    // 增加一个 loading 的状态
    childrenRender: (children) => {
      // if (initialState?.loading) return <PageLoading />;
      return (
        <App>
          {children}
          <SettingDrawer
            disableUrlParams
            enableDarkTheme
            settings={initialState?.settings}
            onSettingChange={(settings) => {
              setInitialState((preInitialState) => ({
                ...preInitialState,
                settings,
              }));
            }}
          />
        </App>
      );
    },
    ...initialState?.settings,
  };
};

export async function onRouteChange({ clientRoutes, location }: { clientRoutes: any; location: any }) {
  const menus = getRemoteMenu();
  console.log('onRouteChange', clientRoutes, location, menus);
  
  // 如果不是登录页面且菜单为空，尝试重新获取菜单数据
  if((menus === null || menus.length === 0) && location.pathname !== PageEnum.LOGIN) {
    console.log('菜单为空，尝试重新获取菜单数据');
    try {
      await getRemoteMenuWithRetry();
    } catch (error) {
      console.error('重新获取菜单失败:', error);
      // 如果仍然失败，可以考虑显示错误提示而不是强制刷新
    }
  }
}

// export function patchRoutes({ routes, routeComponents }) {
//   console.log('patchRoutes', routes, routeComponents);
// }


export async function patchClientRoutes({ routes }: { routes: any }) {
  // console.log('patchClientRoutes', routes);
  patchRouteWithRemoteMenus(routes);
}

export function render(oldRender: () => void) {
  console.log('render get routers', oldRender)
  const token = getAccessToken();
  if(!token || token?.length === 0) {
    oldRender();
    return;
  }
  
  // 使用新的重试机制初始化菜单数据
  getRemoteMenuWithRetry().then(res => {
    console.log('菜单数据初始化成功:', res);
    oldRender();
  }).catch(error => {
    console.error('菜单数据初始化失败:', error);
    // 即使失败也要渲染，避免页面白屏
    oldRender();
  });
}

/**
 * @name request 配置，可以配置错误处理
 * 它基于 axios 和 ahooks 的 useRequest 提供了一套统一的网络请求和错误处理方案。
 * @doc https://umijs.org/docs/max/request#配置
 */
const checkRegion = 5 * 60 * 1000;

export const request = {
  ...errorConfig,
  requestInterceptors: [
    (url: any, options: { headers: any }) => {
      const headers = options.headers ? options.headers : {};
      console.log('request ====>:', url);
      const authHeader = headers['Authorization'];
      const isToken = headers['isToken'];

      // 统一识别 isToken 为 false 的多种写法（boolean/字符串/数字）
      const isExplicitSkip = (() => {
        if (typeof isToken === 'undefined') return false;
        const v = String(isToken).toLowerCase();
        return v === 'false' || v === '0' || v === '';
      })();

      // 对登录/验证码等开放接口，强制不携带 Authorization
      const isPublicApi = (() => {
        try {
          const u = typeof url === 'string' ? url : '';
          return (
            u.includes('/api/login') ||
            u.includes('/api/captchaImage') ||
            u.includes('/api/logout')
          );
        } catch {
          return false;
        }
      })();

      // 如果明确设置了 isToken: false，或命中公共接口，则跳过 token 处理
      if (isExplicitSkip || isPublicApi) {
        console.log('跳过token验证：', { isExplicitSkip, isPublicApi });
        // 移除isToken标记，避免传递给后端
        if (headers['isToken'] !== undefined) delete headers['isToken'];
        return { url, options: { ...options, headers } };
      }

      // 如果没有Authorization头且没有明确禁用token，则添加token
      if (!authHeader) {
        const expireTime = getTokenExpireTime();
        if (expireTime) {
          const left = Number(expireTime) - new Date().getTime();
          const refreshToken = getRefreshToken();
          if (left < checkRegion && refreshToken) {
            if (left < 0) {
              clearSessionToken();
            }
          } else {
            const accessToken = getAccessToken();
            if (accessToken) {
              headers['Authorization'] = `Bearer ${accessToken}`;
            }
          }
        } else {
          clearSessionToken();
        }
      }

      // 移除isToken标记，避免传递给后端
      if (headers['isToken'] !== undefined) {
        delete headers['isToken'];
      }

      return { url, options: { ...options, headers } };
    },
  ],
  responseInterceptors: [
    // (response) =>
    // {
    //   // // 不再需要异步处理读取返回体内容，可直接在data中读出，部分字段可在 config 中找到
    //   // const { data = {} as any, config } = response;
    //   // // do something
    //   // console.log('data: ', data)
    //   // console.log('config: ', config)
    //   return response
    // },
  ],
};
