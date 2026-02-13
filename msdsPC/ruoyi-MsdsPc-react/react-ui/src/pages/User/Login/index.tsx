import Footer from '@/components/Footer';
import { login } from '@/services/ant-design-pro/login';
import { getCaptchaImg } from '@/services/system/auth';
import {
  LockOutlined,
  UserOutlined,
  SafetyOutlined,
  SearchOutlined,
  TeamOutlined,
  BarChartOutlined,
  ExperimentOutlined,
  CheckCircleOutlined,
  LoginOutlined,
} from '@ant-design/icons';
import {
  ProFormCheckbox,
  ProFormText,
} from '@ant-design/pro-components';
import { useEmotionCss } from '@ant-design/use-emotion-css';
import { history, SelectLang, useIntl, useModel, Helmet } from '@umijs/max';
import { Alert, Button, Col, Form, message, Row, Checkbox, Input } from 'antd';
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

// 功能特点卡片组件
const FeatureCard: React.FC<{
  icon: React.ReactNode;
  title: string;
  description: string;
}> = ({ icon, title, description }) => {
  const cardClassName = useEmotionCss(() => {
    return {
      background: 'rgba(15, 23, 42, 0.6)',
      backdropFilter: 'blur(10px)',
      border: '1px solid rgba(24, 144, 255, 0.2)',
      borderRadius: '12px',
      padding: '24px',
      height: '100%',
      minHeight: '130px',
      display: 'flex',
      flexDirection: 'column',
      transition: 'all 0.3s ease',
      position: 'relative',
      overflow: 'hidden',
      '&:before': {
        content: '""',
        position: 'absolute',
        top: 0,
        left: 0,
        right: 0,
        height: '3px',
        background: 'linear-gradient(90deg, #1890ff, #43cd80)',
        opacity: 0,
        transition: 'opacity 0.3s ease',
      },
      '&:hover': {
        background: 'rgba(15, 23, 42, 0.8)',
        borderColor: 'rgba(24, 144, 255, 0.4)',
        transform: 'translateY(-5px)',
        boxShadow: '0 12px 40px rgba(24, 144, 255, 0.15)',
        '&:before': {
          opacity: 1,
        },
      },
    };
  });

  return (
    <div className={cardClassName}>
      <div style={{ display: 'flex', alignItems: 'center', marginBottom: '16px' }}>
        <span style={{
          fontSize: '28px',
          marginRight: '12px',
          color: '#1890ff',
          filter: 'drop-shadow(0 0 8px rgba(24, 144, 255, 0.5))'
        }}>{icon}</span>
        <h3 style={{
          margin: 0,
          fontSize: '17px',
          fontWeight: 600,
          color: '#e6f7ff',
          letterSpacing: '0.5px'
        }}>{title}</h3>
      </div>
      <p style={{
        margin: 0,
        fontSize: '14px',
        color: 'rgba(230, 247, 255, 0.7)',
        lineHeight: '1.7'
      }}>
        {description}
      </p>
    </div>
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

const Login: React.FC = () => {
  console.log('🚀🚀🚀 Login组件开始渲染 🚀🚀🚀');
  const [userLoginState, setUserLoginState] = useState<API.LoginResult>({code: 200});
  const { initialState, setInitialState } = useModel('@@initialState');
  const [captchaCode, setCaptchaCode] = useState<string>('');
  const [uuid, setUuid] = useState<string>('');
  const [loading, setLoading] = useState(false);
  const [mounted, setMounted] = useState(false);
  
  console.log('🖼️ 验证码状态:', captchaCode ? '已设置' : '未设置');
  console.log('🆔 UUID状态:', uuid || '未设置');

  // 组件加载时自动获取验证码并触发入场动画
  useEffect(() => {
    console.log('🎯 Login组件已挂载，自动获取验证码');
    getCaptchaCode();
    // 触发入场动画
    setTimeout(() => setMounted(true), 100);
  }, []);

  const containerClassName = useEmotionCss(() => {
    return {
      display: 'flex',
      flexDirection: 'column',
      minHeight: '100vh',
      overflow: 'auto',
      background: '#0a1628',
      position: 'relative',
      '&:before': {
        content: '""',
        position: 'absolute',
        inset: 0,
        backgroundImage: `
          linear-gradient(30deg, rgba(24, 144, 255, 0.03) 1px, transparent 1px),
          linear-gradient(-30deg, rgba(24, 144, 255, 0.03) 1px, transparent 1px)
        `,
        backgroundSize: '60px 60px',
        pointerEvents: 'none',
      },
      '&:after': {
        content: '""',
        position: 'absolute',
        inset: 0,
        background: 'radial-gradient(ellipse at 20% 20%, rgba(24, 144, 255, 0.15) 0%, transparent 50%), radial-gradient(ellipse at 80% 80%, rgba(67, 205, 128, 0.1) 0%, transparent 50%)',
        pointerEvents: 'none',
      },
    };
  });

  const floatingElementStyle = useEmotionCss(() => {
    return {
      position: 'absolute',
      borderRadius: '50%',
      pointerEvents: 'none',
      background: 'linear-gradient(135deg, rgba(24, 144, 255, 0.15), rgba(67, 205, 128, 0.1))',
      boxShadow: '0 0 60px rgba(24, 144, 255, 0.3)',
      '@keyframes float': {
        '0%, 100%': { transform: 'translateY(0px) rotate(0deg)' },
        '50%': { transform: 'translateY(-20px) rotate(180deg)' },
      },
      animation: 'float 8s ease-in-out infinite',
    };
  });

  const loginCardClassName = useEmotionCss(() => {
    return {
      background: 'rgba(15, 23, 42, 0.85)',
      backdropFilter: 'blur(20px)',
      borderRadius: '20px',
      padding: '48px',
      border: '1px solid rgba(24, 144, 255, 0.2)',
      boxShadow: `
        0 0 0 1px rgba(24, 144, 255, 0.1),
        0 20px 60px rgba(0, 0, 0, 0.5),
        0 0 100px rgba(24, 144, 255, 0.1) inset
      `,
      maxWidth: '480px',
      width: '100%',
      opacity: mounted ? 1 : 0,
      transform: mounted ? 'translateY(0)' : 'translateY(20px)',
      transition: 'all 0.6s cubic-bezier(0.4, 0, 0.2, 1)',
      position: 'relative',
      overflow: 'hidden',
      '&:before': {
        content: '""',
        position: 'absolute',
        top: '-50%',
        left: '-50%',
        width: '200%',
        height: '200%',
        background: 'conic-gradient(from 0deg at 50% 50%, rgba(24, 144, 255, 0.1) 0deg, transparent 60deg, rgba(67, 205, 128, 0.05) 120deg, transparent 180deg)',
        animation: 'rotate 20s linear infinite',
        pointerEvents: 'none',
      },
      '&:after': {
        content: '""',
        position: 'absolute',
        inset: '1px',
        borderRadius: '19px',
        background: 'rgba(15, 23, 42, 0.95)',
        zIndex: -1,
      },
      '@keyframes rotate': {
        from: { transform: 'rotate(0deg)' },
        to: { transform: 'rotate(360deg)' },
      },
    };
  });

  const loginButtonClassName = useEmotionCss(() => {
    return {
      background: 'linear-gradient(135deg, #1890ff 0%, #43cd80 100%)',
      border: 'none',
      height: '48px',
      fontSize: '16px',
      fontWeight: 600,
      borderRadius: '10px',
      color: '#ffffff',
      letterSpacing: '1px',
      textTransform: 'uppercase',
      boxShadow: '0 4px 20px rgba(24, 144, 255, 0.4)',
      transition: 'all 0.3s ease',
      position: 'relative',
      overflow: 'hidden',
      '&:before': {
        content: '""',
        position: 'absolute',
        top: 0,
        left: '-100%',
        width: '100%',
        height: '100%',
        background: 'linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent)',
        transition: 'left 0.5s ease',
      },
      '&:hover': {
        transform: 'translateY(-2px) scale(1.02)',
        boxShadow: '0 8px 30px rgba(24, 144, 255, 0.5) !important',
        '&:before': {
          left: '100%',
        },
      },
      '&:active': {
        transform: 'translateY(0) scale(0.98)',
      },
    };
  });

  const leftContentClassName = useEmotionCss(() => {
    return {
      color: '#e6f7ff',
      opacity: mounted ? 1 : 0,
      transform: mounted ? 'translateX(0)' : 'translateX(-30px)',
      transition: 'all 0.8s cubic-bezier(0.4, 0, 0.2, 1) 0.2s',
      position: 'relative',
      zIndex: 1,
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
        setInitialState((s: any) => ({
          ...s,
          currentUser: userInfo,
        }));
      });
    }
  };

  const handleSubmit = async (values: API.LoginParams) => {
    setLoading(true);
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
        setUserLoginState({ ...response });
        getCaptchaCode();
      }
    } catch (error) {
      const defaultLoginFailureMessage = intl.formatMessage({
        id: 'pages.login.failure',
        defaultMessage: '登录失败，请重试！',
      });
      console.log(error);
      message.error(defaultLoginFailureMessage);
    } finally {
      setLoading(false);
    }
  };
  const { code } = userLoginState;

  const [form] = Form.useForm();

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
      
      {/* 背景装饰元素 */}
      <div style={{ position: 'fixed', inset: 0, overflow: 'hidden', pointerEvents: 'none' }}>
        <div className={floatingElementStyle} style={{ top: '80px', left: '80px', width: '128px', height: '128px', background: 'linear-gradient(135deg, rgba(24, 144, 255, 0.2), rgba(67, 205, 128, 0.15))' }} />
        <div className={floatingElementStyle} style={{ top: '160px', right: '128px', width: '96px', height: '96px', background: 'linear-gradient(135deg, rgba(67, 205, 128, 0.15), rgba(24, 144, 255, 0.1))', animationDelay: '-2s' }} />
        <div className={floatingElementStyle} style={{ bottom: '128px', left: '25%', width: '160px', height: '160px', background: 'linear-gradient(135deg, rgba(24, 144, 255, 0.15), rgba(67, 205, 128, 0.1))', animationDelay: '-4s' }} />
        <div className={floatingElementStyle} style={{ bottom: '80px', right: '80px', width: '112px', height: '112px', background: 'linear-gradient(135deg, rgba(67, 205, 128, 0.2), rgba(24, 144, 255, 0.15))', animationDelay: '-1s' }} />
      </div>

      <Lang />

      <div style={{ flex: 1, padding: '32px 16px', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <div style={{ width: '100%', maxWidth: '1200px' }}>
          <Row gutter={[48, 48]} align="middle">
            {/* 左侧：系统介绍 */}
            <Col xs={24} lg={12}>
              <div className={leftContentClassName}>
                {/* 系统标题 */}
                <div style={{ textAlign: 'center', marginBottom: '48px' }}>
                  <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', marginBottom: '16px' }}>
                    <ExperimentOutlined style={{
                      fontSize: '56px',
                      marginRight: '16px',
                      color: '#1890ff',
                      filter: 'drop-shadow(0 0 20px rgba(24, 144, 255, 0.6))'
                    }} />
                    <h1 style={{
                      fontSize: '40px',
                      fontWeight: 'bold',
                      margin: 0,
                      color: '#e6f7ff',
                      letterSpacing: '2px',
                      textShadow: '0 0 40px rgba(24, 144, 255, 0.5)'
                    }}>
                      {intl.formatMessage({ id: 'pages.login.title', defaultMessage: '安全智库' })}
                    </h1>
                  </div>
                  <p style={{ fontSize: '20px', color: 'rgba(230, 247, 255, 0.85)', marginBottom: '8px' }}>
                    {intl.formatMessage({ id: 'pages.login.subtitle', defaultMessage: '专业的化学品安全数据表管理平台' })}
                  </p>
                  <p style={{ fontSize: '16px', color: 'rgba(230, 247, 255, 0.65)' }}>
                    {intl.formatMessage({ id: 'pages.login.description', defaultMessage: '为科研机构和实验室提供安全、高效的MSDS数据管理解决方案' })}
                  </p>
                </div>

                {/* 功能特点 */}
                <Row gutter={[16, 16]} style={{ marginBottom: '48px' }} align="stretch">
                  <Col span={12} style={{ display: 'flex' }}>
                    <FeatureCard
                      icon={<SearchOutlined />}
                      title={intl.formatMessage({ id: 'pages.login.feature.search.title', defaultMessage: '智能搜索' })}
                      description={intl.formatMessage({ id: 'pages.login.feature.search.description', defaultMessage: '支持多维度搜索，快速定位所需的MSDS文档' })}
                    />
                  </Col>
                  <Col span={12} style={{ display: 'flex' }}>
                    <FeatureCard
                      icon={<SafetyOutlined />}
                      title={intl.formatMessage({ id: 'pages.login.feature.safety.title', defaultMessage: '安全合规' })}
                      description={intl.formatMessage({ id: 'pages.login.feature.safety.description', defaultMessage: '符合国际安全标准，确保数据安全和合规性' })}
                    />
                  </Col>
                  <Col span={12} style={{ display: 'flex' }}>
                    <FeatureCard
                      icon={<TeamOutlined />}
                      title={intl.formatMessage({ id: 'pages.login.feature.team.title', defaultMessage: '团队协作' })}
                      description={intl.formatMessage({ id: 'pages.login.feature.team.description', defaultMessage: '支持多用户协作，提高团队工作效率' })}
                    />
                  </Col>
                  <Col span={12} style={{ display: 'flex' }}>
                    <FeatureCard
                      icon={<BarChartOutlined />}
                      title={intl.formatMessage({ id: 'pages.login.feature.analysis.title', defaultMessage: '数据分析' })}
                      description={intl.formatMessage({ id: 'pages.login.feature.analysis.description', defaultMessage: '可视化数据分析，洞察使用趋势和风险分布' })}
                    />
                  </Col>
                </Row>

                {/* 统计数据 */}
                <Row gutter={16} style={{ textAlign: 'center' }}>
                  <Col span={8}>
                    <div style={{ fontSize: '36px', fontWeight: 'bold', color: '#1890ff', textShadow: '0 0 20px rgba(24, 144, 255, 0.5)' }}>10,000+</div>
                    <div style={{ fontSize: '14px', color: 'rgba(230, 247, 255, 0.7)' }}>
                      {intl.formatMessage({ id: 'pages.login.stats.documents', defaultMessage: 'MSDS文档' })}
                    </div>
                  </Col>
                  <Col span={8}>
                    <div style={{ fontSize: '36px', fontWeight: 'bold', color: '#43cd80', textShadow: '0 0 20px rgba(67, 205, 128, 0.5)' }}>500+</div>
                    <div style={{ fontSize: '14px', color: 'rgba(230, 247, 255, 0.7)' }}>
                      {intl.formatMessage({ id: 'pages.login.stats.users', defaultMessage: '活跃用户' })}
                    </div>
                  </Col>
                  <Col span={8}>
                    <div style={{ fontSize: '36px', fontWeight: 'bold', color: '#52c41a', textShadow: '0 0 20px rgba(82, 196, 26, 0.5)' }}>99.9%</div>
                    <div style={{ fontSize: '14px', color: 'rgba(230, 247, 255, 0.7)' }}>
                      {intl.formatMessage({ id: 'pages.login.stats.availability', defaultMessage: '系统可用性' })}
                    </div>
                  </Col>
                </Row>
              </div>
            </Col>

            {/* 右侧：登录表单 */}
            <Col xs={24} lg={12}>
              <div className={loginCardClassName}>
                <div style={{ textAlign: 'center', marginBottom: '32px', position: 'relative', zIndex: 1 }}>
                  <h2 style={{
                    fontSize: '26px',
                    fontWeight: 'bold',
                    color: '#e6f7ff',
                    marginBottom: '8px',
                    letterSpacing: '1px',
                    textShadow: '0 0 30px rgba(24, 144, 255, 0.5)'
                  }}>
                    {intl.formatMessage({ id: 'pages.login.welcome', defaultMessage: '欢迎登录' })}
                  </h2>
                  <p style={{ color: 'rgba(230, 247, 255, 0.6)', fontSize: '15px' }}>
                    {intl.formatMessage({ id: 'pages.login.welcomeDescription', defaultMessage: '请输入您的账户信息' })}
                  </p>
                </div>
                {code !== 200 && (
                  <Alert
                    style={{ marginBottom: 24 }}
                    message={intl.formatMessage({
                      id: 'pages.login.accountLogin.errorMessage',
                      defaultMessage: '账户或密码错误',
                    })}
                    type="error"
                    showIcon
                  />
                )}

                <Form
                  form={form}
                  name="login"
                  initialValues={{
                    autoLogin: false,
                  }}
                  onFinish={handleSubmit}
                  size="large"
                >
                  {/* 用户名输入 */}
                  <Form.Item
                    name="username"
                    rules={[
                      {
                        required: true,
                        message: intl.formatMessage({ id: 'pages.login.username.required', defaultMessage: '请输入用户名！' }),
                      },
                    ]}
                  >
                    <ProFormText
                      fieldProps={{
                        size: 'large',
                        prefix: <UserOutlined style={{ color: 'rgba(230, 247, 255, 0.5)' }} />,
                        placeholder: intl.formatMessage({ id: 'pages.login.usernamePlaceholder', defaultMessage: '请输入用户名或邮箱' }),
                      }}
                    />
                  </Form.Item>

                  {/* 密码输入 */}
                  <Form.Item
                    name="password"
                    rules={[
                      {
                        required: true,
                        message: intl.formatMessage({ id: 'pages.login.password.required', defaultMessage: '请输入密码！' }),
                      },
                    ]}
                  >
                    <ProFormText.Password
                      fieldProps={{
                        size: 'large',
                        prefix: <LockOutlined style={{ color: 'rgba(230, 247, 255, 0.5)' }} />,
                        placeholder: intl.formatMessage({ id: 'pages.login.passwordPlaceholder', defaultMessage: '请输入密码' }),
                      }}
                    />
                  </Form.Item>
                  {/* 验证码输入 */}
                  <Row gutter={16}>
                    <Col flex="auto">
                      <Form.Item
                        name="code"
                        rules={[
                          {
                            required: true,
                            message: intl.formatMessage({ id: 'pages.login.captcha.required', defaultMessage: '请输入验证码！' }),
                          },
                        ]}
                      >
                        <ProFormText
                          fieldProps={{
                            size: 'large',
                            prefix: <SafetyOutlined style={{ color: 'rgba(230, 247, 255, 0.5)' }} />,
                            placeholder: intl.formatMessage({ id: 'pages.login.captchaPlaceholder', defaultMessage: '请输入验证码' }),
                          }}
                        />
                      </Form.Item>
                    </Col>
                    <Col flex="120px">
                      <div style={{ height: '40px' }}>
                        {captchaCode ? (
                          <img
                            key={uuid || 'captcha'}
                            src={captchaCode}
                            alt={intl.formatMessage({ id: 'pages.login.captcha', defaultMessage: '验证码' })}
                            style={{
                              width: '120px',
                              height: '40px',
                              cursor: 'pointer',
                              border: '1px solid #d9d9d9',
                              borderRadius: '8px',
                              objectFit: 'cover',
                            }}
                            onClick={() => getCaptchaCode()}
                            onError={() => {
                              setCaptchaCode('');
                              setTimeout(() => getCaptchaCode(), 1000);
                            }}
                          />
                        ) : (
                          <div
                            style={{
                              width: '120px',
                              height: '40px',
                              cursor: 'pointer',
                              border: '1px solid #d9d9d9',
                              borderRadius: '8px',
                              backgroundColor: '#f5f5f5',
                              display: 'flex',
                              alignItems: 'center',
                              justifyContent: 'center',
                              fontSize: '12px',
                              color: '#999',
                            }}
                            onClick={() => getCaptchaCode()}
                          >
                            {intl.formatMessage({ id: 'pages.login.captchaGet', defaultMessage: '点击获取' })}
                          </div>
                        )}
                      </div>
                    </Col>
                  </Row>

                  {/* 记住登录和忘记密码 */}
                  <Form.Item style={{ marginBottom: 24 }}>
                    <Row justify="space-between" align="middle">
                      <Col>
                        <Form.Item name="autoLogin" valuePropName="checked" noStyle>
                          <ProFormCheckbox>
                            <span style={{ color: 'rgba(230, 247, 255, 0.7)' }}>
                              {intl.formatMessage({ id: 'pages.login.rememberStatus', defaultMessage: '记住登录状态' })}
                            </span>
                          </ProFormCheckbox>
                        </Form.Item>
                      </Col>
                      <Col>
                        <a style={{ color: '#43cd80', textDecoration: 'none', transition: 'color 0.3s ease', '&:hover': { color: '#1890ff' } }}>
                          {intl.formatMessage({ id: 'pages.login.forgotPassword', defaultMessage: '忘记密码？' })}
                        </a>
                      </Col>
                    </Row>
                  </Form.Item>

                  {/* 登录按钮 */}
                  <Form.Item>
                    <Button
                      type="primary"
                      htmlType="submit"
                      size="large"
                      block
                      loading={loading}
                      icon={!loading && <LoginOutlined />}
                      className={loginButtonClassName}
                    >
                      {loading 
                        ? intl.formatMessage({ id: 'pages.login.loginButtonLoading', defaultMessage: '登录中...' })
                        : intl.formatMessage({ id: 'pages.login.loginButton', defaultMessage: '登录系统' })
                      }
                    </Button>
                  </Form.Item>
                </Form>

                {/* 系统状态 */}
                <div
                  style={{
                    marginTop: '24px',
                    paddingTop: '24px',
                    borderTop: '1px solid rgba(24, 144, 255, 0.15)',
                  }}
                >
                  <Row justify="space-between" align="middle" style={{ fontSize: '12px', color: 'rgba(230, 247, 255, 0.6)' }}>
                    <Col>
                      <div style={{ display: 'flex', alignItems: 'center' }}>
                        <div
                          style={{
                            width: '8px',
                            height: '8px',
                            borderRadius: '50%',
                            backgroundColor: '#43cd80',
                            marginRight: '8px',
                            boxShadow: '0 0 10px rgba(67, 205, 128, 0.5)',
                          }}
                        />
                        <span>{intl.formatMessage({ id: 'pages.login.systemStatus', defaultMessage: '系统运行正常' })}</span>
                      </div>
                    </Col>
                    <Col>
                      <span>{intl.formatMessage({ id: 'pages.login.version', defaultMessage: '版本 v2.1.0' })}</span>
                    </Col>
                  </Row>
                </div>

                {/* 备案信息 */}
                <div
                  style={{
                    marginTop: '16px',
                    paddingTop: '16px',
                    borderTop: '1px solid rgba(24, 144, 255, 0.15)',
                    textAlign: 'center',
                  }}
                >
                  <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '12px', flexWrap: 'wrap', fontSize: '12px' }}>
                    <a href="https://beian.mps.gov.cn/#/query/webSearch?code=61019602000641" rel="noreferrer" target="_blank" style={{ color: 'rgba(230, 247, 255, 0.6)', textDecoration: 'none', display: 'flex', alignItems: 'center', gap: '4px', transition: 'color 0.3s ease', '&:hover': { color: '#43cd80' } }}>
                      <img src="/beian-icon.png" alt="公安备案" style={{ width: '16px', height: '16px' }} />
                      陕公网安备61019602000641号
                    </a>
                    <a href="https://beian.miit.gov.cn/" target="_blank" rel="noreferrer" style={{ color: 'rgba(230, 247, 255, 0.6)', textDecoration: 'none', transition: 'color 0.3s ease', '&:hover': { color: '#43cd80' } }}>
                      陕ICP备2025081905号-1
                    </a>
                  </div>
                </div>
              </div>
            </Col>
          </Row>
        </div>
      </div>
    </div>
  );
};

export default Login;
