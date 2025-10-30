import Footer from '@/components/Footer';
import { login } from '@/services/ant-design-pro/login';
import { getCaptchaImg } from '@/services/system/auth';
import {
  AlipayCircleOutlined,
  LockOutlined,
  MobileOutlined,
  TaobaoCircleOutlined,
  UserOutlined,
  WeiboCircleOutlined,
} from '@ant-design/icons';
import {
  LoginForm,
  ProFormCaptcha,
  ProFormCheckbox,
  ProFormText,
} from '@ant-design/pro-components';
import { useEmotionCss } from '@ant-design/use-emotion-css';
import { FormattedMessage, history, SelectLang, useIntl, useModel, Helmet } from '@umijs/max';
import { Alert, Col, message, Row, Tabs, Image } from 'antd';
import Settings from '../../../../config/defaultSettings';
import React, { useEffect, useState } from 'react';
import { flushSync } from 'react-dom';
import { clearSessionToken, setSessionToken } from '@/access';

// 基于 base64 前缀自动识别图片 MIME 类型，提升兼容性（模块作用域）
function detectMimeFromBase64(data: string): string {
  // PNG 以 iVBORw0 开头，JPEG 以 /9j/ 开头，GIF 以 R0lGOD 开头
  if (!data) return 'image/png';
  const prefix = data.substring(0, 10);
  if (prefix.startsWith('iVBORw0')) return 'image/png';
  if (prefix.startsWith('/9j/')) return 'image/jpeg';
  if (prefix.startsWith('R0lGOD')) return 'image/gif';
  return 'image/png';
}

// 新增：将后端返回的 img 统一标准化为可用的 dataURL（兼容已经带 data: 前缀或仅 base64 的两种情况）
function normalizeCaptchaImage(rawImg?: string): string | '' {
  if (!rawImg) return '';
  // 如果已经是 dataURL，直接返回
  if (rawImg.startsWith('data:image/')) return rawImg;
  // 否则自动识别 MIME，拼接为 dataURL
  const mime = detectMimeFromBase64(rawImg);
  return `data:${mime};base64,${rawImg}`;
}

const ActionIcons = () => {
  const langClassName = useEmotionCss(({ token }) => {
    return {
      marginLeft: '8px',
      color: 'rgba(0, 0, 0, 0.2)',
      fontSize: '24px',
      verticalAlign: 'middle',
      cursor: 'pointer',
      transition: 'color 0.3s',
      '&:hover': {
        color: token.colorPrimaryActive,
      },
    };
  });

  return (
    <>
      <AlipayCircleOutlined key="AlipayCircleOutlined" className={langClassName} />
      <TaobaoCircleOutlined key="TaobaoCircleOutlined" className={langClassName} />
      <WeiboCircleOutlined key="WeiboCircleOutlined" className={langClassName} />
    </>
  );
};

const Lang = () => {
  const langClassName = useEmotionCss(({ token }) => {
    return {
      width: 42,
      height: 42,
      lineHeight: '42px',
      position: 'fixed',
      right: 16,
      borderRadius: token.borderRadius,
      ':hover': {
        backgroundColor: token.colorBgTextHover,
      },
    };
  });

  return (
    <div className={langClassName} data-lang>
      {SelectLang && <SelectLang />}
    </div>
  );
};

const LoginMessage: React.FC<{
  content: string;
}> = ({ content }) => {
  return (
    <Alert
      style={{
        marginBottom: 24,
      }}
      message={content}
      type="error"
      showIcon
    />
  );
};

const Login: React.FC = () => {
  console.log('🚀🚀🚀 Login组件开始渲染 - 调试版本 v2.0 🚀🚀🚀');
  const [userLoginState, setUserLoginState] = useState<API.LoginResult>({code: 200});
  const [type, setType] = useState<string>('account');
  const { initialState, setInitialState } = useModel('@@initialState');
  const [captchaCode, setCaptchaCode] = useState<string>('');
  const [uuid, setUuid] = useState<string>('');
  
  console.log('🔍 当前登录类型:', type);
  console.log('🖼️ 验证码状态:', captchaCode ? '已设置' : '未设置');
  console.log('🆔 UUID状态:', uuid || '未设置');
  
  // 添加页面标题调试
  document.title = '调试模式 - MSDS登录页面';

  // 组件加载时自动获取验证码
  useEffect(() => {
    console.log('🎯 Login组件已挂载，自动获取验证码');
    getCaptchaCode();
  }, []);

  const containerClassName = useEmotionCss(() => {
    return {
      display: 'flex',
      flexDirection: 'column',
      height: '100vh',
      overflow: 'auto',
      backgroundImage:
        "url('https://mdn.alipayobjects.com/yuyan_qk0oxh/afts/img/V-_oS6r-i7wAAAAAAAAAAAAAFl94AQBr')",
      backgroundSize: '100% 100%',
    };
  });

  const intl = useIntl();

  const getCaptchaCode = async (retryCount = 0) => {
    const maxRetries = 3;
    try {
      console.log(`🔄🔄🔄 开始获取验证码... (尝试 ${retryCount + 1}/${maxRetries + 1}) 🔄🔄🔄`);
      console.log('🌐 当前页面URL:', window.location.href);
      console.log('🔗 请求URL: /api/captchaImage');
      
      // 添加时间戳防缓存参数，避免拿到旧图片
      const response = await getCaptchaImg({ t: Date.now() });
      console.log('📡 验证码响应:', response);
      console.log('📡 响应类型:', typeof response);
      console.log('📡 响应键:', Object.keys(response || {}));
      
      if (response && response.code === 200) {
        // 标准化图片（兼容 data:image/...;base64,xxx 或 仅 base64）
        const imageData = normalizeCaptchaImage(response.img);
        if (!imageData) {
          throw new Error('验证码图片数据为空或无法识别');
        }
        console.log('🖼️ 设置验证码图片数据长度:', response.img?.length || 0);
        console.log('🖼️ 图片数据前缀:', imageData.substring(0, 50) + '...');
        setCaptchaCode(imageData);
        setUuid(response.uuid);
        console.log('✅ 验证码设置成功, UUID:', response.uuid);
        return true; // 成功标志
      } else {
        const errorMsg = response?.msg || '响应格式错误';
        console.error('❌ 验证码获取失败:', response);
        
        // 如果还有重试次数，则自动重试
        if (retryCount < maxRetries) {
          const delay = 1000 * (retryCount + 1);
          console.log(`🔄 ${delay}ms后自动重试...`);
          setTimeout(() => {
            getCaptchaCode(retryCount + 1);
          }, delay);
          return false;
        } else {
          message.error(`验证码获取失败: ${errorMsg}`);
          return false;
        }
      }
    } catch (error: any) {
      console.error('💥 获取验证码异常:', error);
      console.error('💥 错误详情:', {
        message: error?.message,
        stack: error?.stack,
        name: error?.name,
        response: error?.response
      });
      
      // 如果还有重试次数，则自动重试
      if (retryCount < maxRetries) {
        const delay = 1000 * (retryCount + 1);
        console.log(`🔄 ${delay}ms后自动重试...`);
        setTimeout(() => {
          getCaptchaCode(retryCount + 1);
        }, delay);
        return false;
      } else {
        const errorMsg = error?.message || '未知错误';
        message.error(`验证码获取异常: ${errorMsg}`);
        return false;
      }
    }
  };

  const fetchUserInfo = async () => {
    const userInfo = await initialState?.fetchUserInfo?.();
    if (userInfo) {
      flushSync(() => {
        setInitialState((s) => ({
          ...s,
          currentUser: userInfo,
        }));
      });
    }
  };

  const handleSubmit = async (values: API.LoginParams) => {
    try {
      // 登录
      const response = await login({ ...values, uuid });
      if (response.code === 200) {
        const defaultLoginSuccessMessage = intl.formatMessage({
          id: 'pages.login.success',
          defaultMessage: '登录成功！',
        });
        const current = new Date();
        const expireTime = current.setTime(current.getTime() + 1000 * 12 * 60 * 60);
        console.log('login response: ', response);
        setSessionToken(response?.token, response?.token, expireTime);
        message.success(defaultLoginSuccessMessage);
        await fetchUserInfo();
        console.log('login ok');
        const urlParams = new URL(window.location.href).searchParams;
        history.push(urlParams.get('redirect') || '/');
        return;
      } else {
        console.log(response.msg);
        clearSessionToken();
        // 如果失败去设置用户错误信息
        setUserLoginState({ ...response, type });
        getCaptchaCode();
      }
    } catch (error) {
      const defaultLoginFailureMessage = intl.formatMessage({
        id: 'pages.login.failure',
        defaultMessage: '登录失败，请重试！',
      });
      console.log(error);
      message.error(defaultLoginFailureMessage);
    }
  };
  const { code } = userLoginState;
  const loginType = type;

  // 已移除重复的 useEffect，避免重复获取验证码

  return (
    <div className={containerClassName}>
      <Helmet>
        <title>
          {intl.formatMessage({
            id: 'menu.login',
            defaultMessage: '登录页',
          })}
          - {Settings.title}
        </title>
      </Helmet>
      <Lang />
      <div
        style={{
          flex: '1',
          padding: '32px 0',
        }}
      >
        <LoginForm
          contentStyle={{
            minWidth: 280,
            maxWidth: '75vw',
          }}
          logo={<img alt="logo" src="/logo.svg" />}
          title="MSDS 危险化学品说明书管理平台"
          subTitle={intl.formatMessage({ id: 'pages.layouts.userLayout.title' })}
          initialValues={{
            autoLogin: true,
          }}
          actions={[
            <FormattedMessage
              key="loginWith"
              id="pages.login.loginWith"
              defaultMessage="其他登录方式"
            />,
            <ActionIcons key="icons" />,
          ]}
          onFinish={async (values) => {
            await handleSubmit(values as API.LoginParams);
          }}
        >
          <Tabs
            activeKey={type}
            onChange={setType}
            centered
            items={[
              {
                key: 'account',
                label: intl.formatMessage({
                  id: 'pages.login.accountLogin.tab',
                  defaultMessage: '账户密码登录',
                }),
              },
              {
                key: 'mobile',
                label: intl.formatMessage({
                  id: 'pages.login.phoneLogin.tab',
                  defaultMessage: '手机号登录',
                }),
              },
            ]}
          />

          {code !== 200 && loginType === 'account' && (
            <LoginMessage
              content={intl.formatMessage({
                id: 'pages.login.accountLogin.errorMessage',
                defaultMessage: '账户或密码错误(admin/admin123)',
              })}
            />
          )}
          {type === 'account' && (
            <>
              <ProFormText
                name="username"
                initialValue="admin"
                fieldProps={{
                  size: 'large',
                  prefix: <UserOutlined />,
                }}
                placeholder={intl.formatMessage({
                  id: 'pages.login.username.placeholder',
                  defaultMessage: '用户名: admin',
                })}
                rules={[
                  {
                    required: true,
                    message: (
                      <FormattedMessage
                        id="pages.login.username.required"
                        defaultMessage="请输入用户名!"
                      />
                    ),
                  },
                ]}
              />
              <ProFormText.Password
                name="password"
                initialValue="admin123"
                fieldProps={{
                  size: 'large',
                  prefix: <LockOutlined />,
                }}
                placeholder={intl.formatMessage({
                  id: 'pages.login.password.placeholder',
                  defaultMessage: '密码: admin123',
                })}
                rules={[
                  {
                    required: true,
                    message: (
                      <FormattedMessage
                        id="pages.login.password.required"
                        defaultMessage="请输入密码！"
                      />
                    ),
                  },
                ]}
              />
              <Row>
                <Col flex={3}>
                  <ProFormText
                    style={{
                      float: 'right',
                    }}
                    name="code"
                    placeholder={intl.formatMessage({
                      id: 'pages.login.captcha.placeholder',
                      defaultMessage: '请输入验证',
                    })}
                    rules={[
                      {
                        required: true,
                        message: (
                          <FormattedMessage
                            id="pages.searchTable.updateForm.ruleName.nameRules"
                            defaultMessage="请输入验证啊"
                          />
                        ),
                      },
                    ]}
                  />
                </Col>
                <Col flex={2}>
                  {(() => {
                    console.log('渲染验证码图片组件, src:', captchaCode ? captchaCode.substring(0, 50) + '...' : '空');
                    return null;
                  })()}
                  {captchaCode ? (
                    <img
                      key={uuid || 'captcha-placeholder'}
                      src={captchaCode}
                      alt="验证码"
                      style={{
                        display: 'inline-block',
                        verticalAlign: 'top',
                        cursor: 'pointer',
                        paddingLeft: '10px',
                        width: '100px',
                        height: '38px',
                        border: '1px solid #d9d9d9',
                        borderRadius: '6px',
                      }}
                      onClick={() => {
                        console.log('点击刷新验证码');
                        getCaptchaCode();
                      }}
                      onLoad={() => console.log('✅ 验证码图片加载成功')}
                      onError={(e) => {
                        console.error('❌ 验证码图片加载失败:', e);
                        console.error('❌ 图片src:', captchaCode?.substring(0, 100));
                        // 清空以触发占位符，并尝试退避重试
                        setCaptchaCode('');
                        const retryDelay = 1000;
                        setTimeout(() => {
                          console.log('🔄 自动重试获取验证码');
                          getCaptchaCode();
                        }, retryDelay);
                      }}
                    />
                  ) : (
                    <div
                      aria-label="点击获取验证码"
                      style={{
                        display: 'inline-block',
                        verticalAlign: 'top',
                        cursor: 'pointer',
                        paddingLeft: '10px',
                        width: '100px',
                        height: '38px',
                        border: '1px solid #d9d9d9',
                        borderRadius: '6px',
                        backgroundColor: '#f5f5f5',
                        textAlign: 'center',
                        lineHeight: '36px',
                        fontSize: '12px',
                        color: '#999',
                      }}
                      onClick={() => {
                        console.log('点击加载验证码');
                        getCaptchaCode();
                      }}
                    >
                      点击获取
                    </div>
                  )}
                  {/* 调试信息
                  {true && (
                    <div style={{ fontSize: '12px', color: '#999', marginTop: '5px', border: '1px solid #ccc', padding: '10px', backgroundColor: '#f9f9f9' }}>
                      <strong>🔧 调试面板</strong>
                      <br />
                      验证码状态: {captchaCode ? '✅ 已加载' : '❌ 未加载'}
                      <br />
                      验证码长度: {captchaCode ? captchaCode.length : 0}
                      <br />
                      UUID: {uuid || '❌ 无'}
                      <br />
                      <button 
                        type="button" 
                        onClick={() => {
                          console.log('🔄 手动点击测试按钮');
                          getCaptchaCode();
                        }}
                        style={{ fontSize: '12px', padding: '5px 10px', margin: '5px 0', backgroundColor: '#1890ff', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}
                      >
                        🔄 手动获取验证码
                      </button>
                      <br />
                      <button 
                        type="button" 
                        onClick={() => {
                          console.log('🧪 测试API直接调用');
                          fetch('/api/captchaImage')
                            .then(res => res.json())
                            .then(data => {
                              console.log('🧪 直接API调用结果:', data);
                              alert('API测试结果: ' + JSON.stringify(data, null, 2));
                            })
                            .catch(err => {
                              console.error('🧪 API测试失败:', err);
                              alert('API测试失败: ' + err.message);
                            });
                        }}
                        style={{ fontSize: '12px', padding: '5px 10px', margin: '5px 0', backgroundColor: '#52c41a', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}
                      >
                        🧪 测试API
                      </button>
                      {captchaCode && (
                        <>
                          <br />
                          <small>验证码预览: {captchaCode.substring(0, 100)}...</small>
                        </>
                      )}
                    </div>
                  )} */}
                </Col>
              </Row>
            </>
          )}

          {code !== 200 && loginType === 'mobile' && <LoginMessage content="验证码错误" />}
          {type === 'mobile' && (
            <>
              <ProFormText
                fieldProps={{
                  size: 'large',
                  prefix: <MobileOutlined />,
                }}
                name="mobile"
                placeholder={intl.formatMessage({
                  id: 'pages.login.phoneNumber.placeholder',
                  defaultMessage: '手机号',
                })}
                rules={[
                  {
                    required: true,
                    message: intl.formatMessage({
                      id: 'pages.login.phoneNumber.required',
                      defaultMessage: '请输入手机号！',
                    }),
                  },
                  {
                    pattern: /^1\d{10}$/,
                    message: intl.formatMessage({
                      id: 'pages.login.phoneNumber.invalid',
                      defaultMessage: '手机号格式错误！',
                    }),
                  },
                ]}
              />
              <ProFormCaptcha
                fieldProps={{
                  size: 'large',
                  prefix: <LockOutlined />,
                }}
                captchaProps={{
                  size: 'large',
                }}
                placeholder={intl.formatMessage({
                  id: 'pages.login.captcha.placeholder',
                  defaultMessage: '请输入验证码',
                })}
                captchaTextRender={(timing, count) => {
                  if (timing) {
                    return `${count} ${intl.formatMessage({
                      id: 'pages.getCaptchaSecondText',
                      defaultMessage: '获取验证码',
                    })}`;
                  }
                  return intl.formatMessage({
                    id: 'pages.login.phoneLogin.getVerificationCode',
                    defaultMessage: '获取验证码',
                  });
                }}
                name="captcha"
                rules={[
                  {
                    required: true,
                    message: intl.formatMessage({
                      id: 'pages.login.captcha.required',
                      defaultMessage: '请输入验证码！',
                    }),
                  },
                ]}
                onGetCaptcha={async (phone) => {
                  // 同样添加防缓存参数，避免偶现拿到旧验证码
                  const result = await getCaptchaImg({ t: Date.now() });
                  if (result.code === 200) {
                    // 使用统一标准化方法，兼容 dataURL 与 base64
                    const dataUrl = normalizeCaptchaImage(result.img);
                    setCaptchaCode(dataUrl);
                    setUuid(result.uuid);
                    console.log('✅ 验证码已更新:', { uuid: result.uuid, preview: dataUrl?.substring(0, 50) + '...' });
                    message.success('验证码图片已更新');
                  } else {
                    message.error('获取验证码图片失败');
                  }
                }}
              />
            </>
          )}
          <div
            style={{
              marginBottom: 24,
            }}
          >
            <ProFormCheckbox noStyle name="autoLogin">
              <FormattedMessage id="pages.login.rememberMe" defaultMessage="自动登录" />
            </ProFormCheckbox>
            <a
              style={{
                float: 'right',
              }}
            >
              <FormattedMessage id="pages.login.forgotPassword" defaultMessage="忘记密码" />
            </a>
          </div>
        </LoginForm>
      </div>
      <Footer />
    </div>
  );
};

export default Login;
