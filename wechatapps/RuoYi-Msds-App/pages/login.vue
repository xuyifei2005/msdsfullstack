<template>
  <view class="normal-login-container">
    <!-- 背景装饰球 -->
    <view class="blob blob-1"></view>
    <view class="blob blob-2"></view>

    <!-- Logo区域 -->
    <view class="logo-content">
      <view class="logo-bg">
        <image class="logo-img" :src="globalConfig.appInfo.logo" mode="aspectFit"></image>
      </view>
      <text class="title">MSDS Manager</text>
      <text class="subtitle">危险化学品说明书管理系统</text>
    </view>

    <!-- 登录表单区域 -->
    <view class="login-form-content">
      <!-- 账号输入 -->
      <view class="input-group">
        <text class="input-label">用户名</text>
        <view class="input-item" :class="{ 'input-focus': focusedInput === 'username' }">
          <view class="iconfont icon-user icon"></view>
          <input 
            v-model="loginForm.username" 
            class="input" 
            type="text" 
            placeholder="请输入账号" 
            maxlength="30" 
            placeholder-style="color: rgba(255, 255, 255, 0.6)"
            @focus="focusedInput = 'username'"
            @blur="focusedInput = ''"
          />
        </view>
      </view>

      <!-- 密码输入 -->
      <view class="input-group">
        <text class="input-label">密码</text>
        <view class="input-item" :class="{ 'input-focus': focusedInput === 'password' }">
          <view class="iconfont icon-password icon"></view>
          <input
            v-if="!showPassword"
            v-model="loginForm.password"
            type="password"
            class="input input-password"
            placeholder="请输入密码"
            maxlength="20"
            placeholder-style="color: rgba(255, 255, 255, 0.6)"
            @focus="focusedInput = 'password'"
            @blur="focusedInput = ''"
          />
          <input
            v-else
            v-model="loginForm.password"
            type="text"
            class="input input-password"
            placeholder="请输入密码"
            maxlength="20"
            placeholder-style="color: rgba(255, 255, 255, 0.6)"
            @focus="focusedInput = 'password'"
            @blur="focusedInput = ''"
          />
          <view class="password-toggle" @click="togglePassword">
             <uni-icons :type="showPassword ? 'eye-filled' : 'eye-slash-filled'" color="rgba(255,255,255,0.8)" size="24"></uni-icons>
          </view>
        </view>
      </view>

      <!-- 验证码输入 -->
      <view class="input-group" v-if="captchaEnabled">
        <text class="input-label">验证码</text>
        <view class="flex align-center justify-between">
          <view class="input-item" style="flex: 1; margin-right: 20rpx;" :class="{ 'input-focus': focusedInput === 'code' }">
            <view class="iconfont icon-code icon"></view>
            <input 
              v-model="loginForm.code" 
              type="number" 
              class="input" 
              placeholder="请输入验证码" 
              maxlength="4" 
              placeholder-style="color: rgba(255, 255, 255, 0.6)"
              @focus="focusedInput = 'code'"
              @blur="focusedInput = ''"
            />
          </view>
          <view class="login-code" hover-class="opacity-hover">
            <image :src="codeUrl" @click="getCode" class="login-code-img"></image>
          </view>
        </view>
      </view>

      <!-- 登录按钮 -->
      <view class="action-btn">
        <button @click="handleLogin" class="login-btn" hover-class="button-hover">
          <text class="iconfont icon-login" style="margin-right: 10rpx;"></text> 登录
        </button>
      </view>

      <!-- 社交登录 (模拟) -->
      <view class="social-login">
        <view class="divider">
          <view class="line"></view>
          <text class="text">其他方式登录</text>
          <view class="line"></view>
        </view>
        <view class="social-icons">
          <view class="social-icon" hover-class="icon-hover" @click="handleSocialLogin('wechat')">
            <uni-icons type="weixin" color="#fff" size="30"></uni-icons>
          </view>
          <view class="social-icon" hover-class="icon-hover" @click="handleSocialLogin('apple')">
            <uni-icons type="info-filled" color="#fff" size="30"></uni-icons>
          </view>
        </view>
      </view>

      <!-- 注册链接 -->
      <view class="reg text-center" v-if="register">
        <text class="text-white-opacity">还没有账号？</text>
        <text @click="handleUserRegister" class="text-highlight" hover-class="text-hover">立即注册</text>
      </view>

      <!-- 协议链接 -->
      <view class="xieyi text-center">
        <text class="text-white-opacity">登录即代表同意</text>
        <text @click="handleUserAgrement" class="text-highlight" hover-class="text-hover">《用户协议》</text>
        <text class="text-white-opacity">和</text>
        <text @click="handlePrivacy" class="text-highlight" hover-class="text-hover">《隐私协议》</text>
      </view>
    </view>
  </view>
</template>

<script>
  import { getCodeImg } from '@/api/login'
  import { getToken } from '@/utils/auth'

  export default {
    data() {
      return {
        codeUrl: "",
        captchaEnabled: true,
        register: false,
        globalConfig: getApp().globalData.config,
        focusedInput: '', // 当前聚焦的输入框
        showPassword: false,
        loginForm: {
          username: "admin",
          password: "admin123",
          code: "",
          uuid: ""
        }
      }
    },
    created() {
      this.getCode()
    },
    onLoad() {
      //#ifdef H5
      if (getToken()) {
        this.$tab.reLaunch('/pages/index')
      }
      //#endif
    },
    methods: {
      togglePassword() {
        this.showPassword = !this.showPassword
      },
      handleSocialLogin(type) {
        this.$modal.msgSuccess(type === 'wechat' ? '微信登录' : 'Apple登录')
      },
      handleUserRegister() {
        this.$tab.redirectTo(`/pages/register`)
      },
      handlePrivacy() {
        let site = this.globalConfig.appInfo.agreements[0]
        this.$tab.navigateTo(`/pages/common/webview/index?title=${site.title}&url=${site.url}`)
      },
      handleUserAgrement() {
        let site = this.globalConfig.appInfo.agreements[1]
        this.$tab.navigateTo(`/pages/common/webview/index?title=${site.title}&url=${site.url}`)
      },
      getCode() {
        getCodeImg().then(res => {
          this.captchaEnabled = res.captchaEnabled === undefined ? true : res.captchaEnabled
          if (this.captchaEnabled) {
            this.codeUrl = 'data:image/gif;base64,' + res.img
            this.loginForm.uuid = res.uuid
          }
        })
      },
      async handleLogin() {
        if (this.loginForm.username === "") {
          this.$modal.msgError("请输入账号")
        } else if (this.loginForm.password === "") {
          this.$modal.msgError("请输入密码")
        } else if (this.loginForm.code === "" && this.captchaEnabled) {
          this.$modal.msgError("请输入验证码")
        } else {
          this.$modal.loading("登录中，请耐心等待...")
          this.pwdLogin()
        }
      },
      async pwdLogin() {
        this.$store.dispatch('Login', this.loginForm).then(() => {
          this.$modal.closeLoading()
          this.loginSuccess()
        }).catch(() => {
          if (this.captchaEnabled) {
            this.getCode()
          }
        })
      },
      loginSuccess(result) {
        this.$store.dispatch('GetInfo').then(res => {
          this.$tab.reLaunch('/pages/index')
        })
      }
    }
  }
</script>

<style lang="scss" scoped>
  /* 全局页面背景 */
  page {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
    overflow: hidden;
  }

  .normal-login-container {
    width: 100%;
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 40rpx;
    position: relative;
    /* 确保背景覆盖整个容器 */
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    z-index: 1;
  }

  /* 背景装饰球 */
  .blob {
    position: absolute;
    border-radius: 50%;
    filter: blur(80rpx);
    opacity: 0.6;
    z-index: -1;
    animation: float 10s infinite ease-in-out;
  }

  .blob-1 {
    top: -10%;
    left: -10%;
    width: 500rpx;
    height: 500rpx;
    background: #00c6fb;
    animation-delay: 0s;
  }

  .blob-2 {
    bottom: -10%;
    right: -10%;
    width: 600rpx;
    height: 600rpx;
    background: #005bea;
    animation-delay: -5s;
  }

  @keyframes float {
    0%, 100% { transform: translate(0, 0) scale(1); }
    50% { transform: translate(30rpx, -30rpx) scale(1.1); }
  }

  /* Logo 区域 */
  .logo-content {
    text-align: center;
    margin-bottom: 60rpx;
    display: flex;
    flex-direction: column;
    align-items: center;
    animation: fadeInUp 0.8s cubic-bezier(0.2, 0.8, 0.2, 1) both;

    .logo-bg {
      width: 180rpx;
      height: 180rpx;
      background: linear-gradient(135deg, #007AFF, #5856D6);
      border-radius: 48rpx;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
      margin-bottom: 30rpx;
      animation: breath 4s infinite ease-in-out;
      
      .logo-img {
        width: 110rpx;
        height: 110rpx;
      }
    }

    .title {
      font-size: 52rpx;
      font-weight: bold;
      color: white;
      margin-bottom: 12rpx;
      text-shadow: 0 2px 10px rgba(0,0,0,0.15);
      letter-spacing: 2rpx;
    }

    .subtitle {
      font-size: 28rpx;
      color: rgba(255, 255, 255, 0.85);
      font-weight: 300;
      letter-spacing: 1rpx;
    }
  }

  /* 登录表单卡片 */
  .login-form-content {
    width: 100%;
    max-width: 680rpx;
    background: rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(25px);
    -webkit-backdrop-filter: blur(25px);
    border-radius: 48rpx;
    padding: 60rpx 40rpx;
    border: 1px solid rgba(255, 255, 255, 0.15);
    box-shadow: 0 20px 50px rgba(0, 0, 0, 0.15);
    animation: fadeInUp 0.8s cubic-bezier(0.2, 0.8, 0.2, 1) 0.2s both;

    .input-group {
      margin-bottom: 36rpx;

      .input-label {
        display: block;
        font-size: 28rpx;
        font-weight: 600;
        color: rgba(255, 255, 255, 0.95);
        margin-bottom: 16rpx;
        margin-left: 12rpx;
      }
    }

    .input-item {
      position: relative;
      background: rgba(255, 255, 255, 0.15);
      border: 2rpx solid rgba(255, 255, 255, 0.2);
      border-radius: 28rpx;
      height: 110rpx;
      display: flex;
      align-items: center;
      padding: 0 36rpx;
      transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);

      &.input-focus {
        background: rgba(255, 255, 255, 0.25);
        border-color: rgba(255, 255, 255, 0.6);
        box-shadow: 0 0 20rpx rgba(255, 255, 255, 0.15);
        transform: translateY(-2rpx);
      }

      .icon {
        font-size: 44rpx;
        margin-right: 24rpx;
        color: rgba(255, 255, 255, 0.8);
        transition: color 0.3s ease;
      }
      
      &.input-focus .icon {
        color: #fff;
      }

      .input {
        flex: 1;
        font-size: 32rpx;
        color: white;
        height: 100%;
      }

      .input-password {
        padding-right: 80rpx;
      }

      .password-toggle {
        position: absolute;
        right: 36rpx;
        top: 50%;
        transform: translateY(-50%);
        padding: 16rpx;
        display: flex;
        align-items: center;
        justify-content: center;
        opacity: 0.8;
        z-index: 10;

        &:active {
          opacity: 1;
        }
      }
    }

    /* 验证码图片 */
    .login-code {
      height: 110rpx;
      display: flex;
      align-items: center;
      transition: opacity 0.2s;

      .login-code-img {
        width: 220rpx;
        height: 110rpx;
        border-radius: 28rpx;
        background: rgba(255, 255, 255, 0.2);
        /* 增加一点阴影 */
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
      }
    }

    /* 登录按钮 */
    .action-btn {
      margin-top: 60rpx;
      
      .login-btn {
        width: 100%;
        background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        /* 调整为更亮眼的渐变色，或者保持原有风格但增加亮度 */
        background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%);
        color: white;
        border: none;
        border-radius: 28rpx;
        height: 110rpx;
        line-height: 110rpx;
        font-size: 36rpx;
        font-weight: 600;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 8px 25px rgba(59, 130, 246, 0.4);
        transition: all 0.3s ease;
        
        &::after {
          border: none;
        }
      }
    }

    /* 社交登录 */
    .social-login {
      margin-top: 50rpx;
      width: 100%;
      
      .divider {
        display: flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 30rpx;
        
        .line {
          flex: 1;
          height: 1px;
          background: rgba(255, 255, 255, 0.2);
        }
        
        .text {
          padding: 0 20rpx;
          font-size: 24rpx;
          color: rgba(255, 255, 255, 0.6);
        }
      }
      
      .social-icons {
        display: flex;
        justify-content: center;
        gap: 40rpx;
        
        .social-icon {
          width: 88rpx;
          height: 88rpx;
          border-radius: 50%;
          background: rgba(255, 255, 255, 0.15);
          border: 1px solid rgba(255, 255, 255, 0.2);
          display: flex;
          align-items: center;
          justify-content: center;
          transition: all 0.3s;
          
          &.icon-hover {
            background: rgba(255, 255, 255, 0.3);
            transform: scale(0.95);
          }
        }
      }
    }

    /* 底部文字 */
    .reg, .xieyi {
      margin-top: 40rpx;
      font-size: 26rpx;
      line-height: 1.8;
      
      .text-white-opacity {
        color: rgba(255, 255, 255, 0.7);
      }
      
      .text-highlight {
        color: white;
        font-weight: 600;
        text-decoration: none;
        margin: 0 6rpx;
        position: relative;
        
        /* 下划线动画效果 */
        &::after {
          content: '';
          position: absolute;
          bottom: -4rpx;
          left: 0;
          width: 0;
          height: 2rpx;
          background-color: white;
          transition: width 0.3s ease;
        }
        
        /* 小程序不支持 hover 伪类触发子元素动画，这里简化处理 */
      }
    }
    
    .xieyi {
      margin-top: 50rpx;
      padding-top: 30rpx;
      border-top: 1px solid rgba(255, 255, 255, 0.1);
    }
  }

  /* 交互状态类 */
  .button-hover {
    transform: scale(0.98);
    box-shadow: 0 4px 15px rgba(59, 130, 246, 0.3);
    opacity: 0.9;
  }
  
  .opacity-hover {
    opacity: 0.8;
  }
  
  .text-hover {
    opacity: 0.7;
  }

  /* 动画定义 */
  @keyframes fadeInUp {
    from {
      opacity: 0;
      transform: translateY(40px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
  
  @keyframes breath {
    0%, 100% { transform: scale(1); box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2); }
    50% { transform: scale(1.05); box-shadow: 0 20px 45px rgba(0, 0, 0, 0.25); }
  }
  
  /* 辅助类 */
  .flex { display: flex; }
  .align-center { align-items: center; }
  .justify-center { justify-content: center; }
  .justify-between { justify-content: space-between; }
  .text-center { text-align: center; }
</style>
