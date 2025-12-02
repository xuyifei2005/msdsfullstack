<template>
  <view class="normal-login-container">
    <!-- 背景装饰球 -->
    <view class="blob blob-1"></view>
    <view class="blob blob-2"></view>

    <!-- 标题区域 -->
    <view class="logo-content">
      <view class="logo-bg">
        <image class="logo-img" :src="globalConfig.appInfo.logo" mode="aspectFit"></image>
      </view>
      <text class="title">创建账户</text>
      <text class="subtitle">加入 MSDS 管理系统</text>
    </view>

    <!-- 注册表单区域 -->
    <view class="login-form-content">
      <!-- 用户名输入 -->
      <view class="input-group">
        <text class="input-label">用户名</text>
        <view class="input-item" :class="{ 'input-focus': focusedInput === 'username' }">
          <view class="iconfont icon-user icon"></view>
          <input 
            v-model="registerForm.username" 
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
            v-model="registerForm.password" 
            :type="showPassword ? 'text' : 'password'"
            class="input" 
            placeholder="请输入密码" 
            maxlength="20" 
            placeholder-style="color: rgba(255, 255, 255, 0.6)"
            @focus="focusedInput = 'password'"
            @blur="focusedInput = ''"
            @input="checkPasswordStrength"
          />
          <view class="password-toggle" @click="showPassword = !showPassword">
             <u-icon :name="showPassword ? 'eye-fill' : 'eye-off-fill'" color="rgba(255,255,255,0.8)" size="36"></u-icon>
          </view>
        </view>
        <!-- 密码强度指示器 -->
        <view class="password-strength">
            <view class="strength-bar" :class="strengthLevel > 0 ? strengthColor : ''"></view>
            <view class="strength-bar" :class="strengthLevel > 1 ? strengthColor : ''"></view>
            <view class="strength-bar" :class="strengthLevel > 2 ? strengthColor : ''"></view>
            <view class="strength-bar" :class="strengthLevel > 3 ? strengthColor : ''"></view>
        </view>
        <text class="strength-text" :style="{ color: strengthColorValue }">{{ strengthText }}</text>
      </view>

      <!-- 确认密码 -->
      <view class="input-group">
        <text class="input-label">确认密码</text>
        <view class="input-item" :class="{ 'input-focus': focusedInput === 'confirmPassword' }">
          <view class="iconfont icon-password icon"></view>
          <input 
            v-model="registerForm.confirmPassword" 
            :type="showConfirmPassword ? 'text' : 'password'"
            class="input" 
            placeholder="请再次输入密码" 
            maxlength="20" 
            placeholder-style="color: rgba(255, 255, 255, 0.6)"
            @focus="focusedInput = 'confirmPassword'"
            @blur="focusedInput = ''"
          />
          <view class="password-toggle" @click="showConfirmPassword = !showConfirmPassword">
             <u-icon :name="showConfirmPassword ? 'eye-fill' : 'eye-off-fill'" color="rgba(255,255,255,0.8)" size="36"></u-icon>
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
              v-model="registerForm.code" 
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

      <!-- 协议同意 -->
      <view class="agreement" @click="agree = !agree">
          <view class="checkbox" :class="{ checked: agree }"></view>
          <view class="agreement-text">
              我已阅读并同意<text class="link">用户协议</text>和<text class="link">隐私政策</text>
          </view>
      </view>

      <!-- 注册按钮 -->
      <view class="action-btn">
        <button @click="handleRegister" class="register-btn" :class="{ disabled: !agree }" hover-class="button-hover">
          <text class="iconfont icon-user-add" style="margin-right: 10rpx;"></text> 注册
        </button>
      </view>

      <!-- 登录链接 -->
      <view class="login-link">
        <text class="text-white-opacity">已有账户？</text>
        <text @click="handleUserLogin" class="text-highlight" hover-class="text-hover">立即登录</text>
      </view>
    </view>
  </view>
</template>

<script>
  import { getCodeImg, register } from '@/api/login'

  export default {
    data() {
      return {
        codeUrl: "",
        captchaEnabled: true,
        globalConfig: getApp().globalData.config,
        focusedInput: '',
        showPassword: false,
        showConfirmPassword: false,
        agree: false,
        strengthLevel: 0,
        registerForm: {
          username: "",
          password: "",
          confirmPassword: "",
          code: "",
          uuid: ""
        }
      }
    },
    computed: {
        strengthText() {
            const texts = ['密码强度：弱', '密码强度：弱', '密码强度：中', '密码强度：强', '密码强度：强'];
            return texts[this.strengthLevel] || '密码强度：弱';
        },
        strengthColor() {
            if (this.strengthLevel <= 1) return 'weak';
            if (this.strengthLevel <= 2) return 'medium';
            return 'strong';
        },
        strengthColorValue() {
             if (this.strengthLevel <= 1) return '#FF3B30';
             if (this.strengthLevel <= 2) return '#FF9500';
             return '#34C759';
        }
    },
    created() {
      this.getCode()
    },
    methods: {
      checkPasswordStrength() {
          const password = this.registerForm.password;
          let strength = 0;
          if (password.length >= 8) strength++;
          if (/[a-z]/.test(password)) strength++;
          if (/[A-Z]/.test(password)) strength++;
          if (/[0-9]/.test(password)) strength++;
          if (/[^A-Za-z0-9]/.test(password)) strength++;
          
          // Limit to 0-4
          this.strengthLevel = Math.min(strength, 4);
      },
      handleUserLogin() {
        this.$tab.navigateTo(`/pages/login`)
      },
      getCode() {
        getCodeImg().then(res => {
          this.captchaEnabled = res.captchaEnabled === undefined ? true : res.captchaEnabled
          if (this.captchaEnabled) {
            this.codeUrl = 'data:image/gif;base64,' + res.img
            this.registerForm.uuid = res.uuid
          }
        })
      },
      async handleRegister() {
        if (!this.agree) {
            this.$modal.msgError("请先同意用户协议和隐私政策");
            return;
        }
        if (this.registerForm.username === "") {
          this.$modal.msgError("请输入您的账号")
        } else if (this.registerForm.password === "") {
          this.$modal.msgError("请输入您的密码")
        } else if (this.registerForm.confirmPassword === "") {
          this.$modal.msgError("请再次输入您的密码")
        } else if (this.registerForm.password !== this.registerForm.confirmPassword) {
          this.$modal.msgError("两次输入的密码不一致")
        } else if (this.registerForm.code === "" && this.captchaEnabled) {
          this.$modal.msgError("请输入验证码")
        } else {
          this.$modal.loading("注册中，请耐心等待...")
          this.register()
        }
      },
      async register() {
        register(this.registerForm).then(res => {
          this.$modal.closeLoading()
          uni.showModal({
            title: "系统提示",
            content: "恭喜你，您的账号 " + this.registerForm.username + " 注册成功！",
            success: function (res) {
              if (res.confirm) {
                uni.redirectTo({ url: `/pages/login` });
              }
            }
          })
        }).catch(() => {
          if (this.captchaEnabled) {
            this.getCode()
          }
        })
      }
    }
  }
</script>

<style lang="scss" scoped>
  /* 全局页面背景 */
  page {
    background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
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
    background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
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
    margin-bottom: 40rpx;
    display: flex;
    flex-direction: column;
    align-items: center;
    animation: fadeInUp 0.8s cubic-bezier(0.2, 0.8, 0.2, 1) both;

    .logo-bg {
      width: 140rpx;
      height: 140rpx;
      background: linear-gradient(135deg, #007AFF, #5856D6);
      border-radius: 40rpx;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
      margin-bottom: 20rpx;
      
      .logo-img {
        width: 90rpx;
        height: 90rpx;
      }
    }

    .title {
      font-size: 44rpx;
      font-weight: bold;
      color: white;
      margin-bottom: 8rpx;
      text-shadow: 0 2px 10px rgba(0,0,0,0.15);
    }

    .subtitle {
      font-size: 26rpx;
      color: rgba(255, 255, 255, 0.85);
      font-weight: 300;
    }
  }

  /* 注册表单卡片 */
  .login-form-content {
    width: 100%;
    max-width: 680rpx;
    background: rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(25px);
    -webkit-backdrop-filter: blur(25px);
    border-radius: 48rpx;
    padding: 50rpx 40rpx;
    border: 1px solid rgba(255, 255, 255, 0.15);
    box-shadow: 0 20px 50px rgba(0, 0, 0, 0.15);
    animation: fadeInUp 0.8s cubic-bezier(0.2, 0.8, 0.2, 1) 0.2s both;

    .input-group {
      margin-bottom: 30rpx;

      .input-label {
        display: block;
        font-size: 26rpx;
        font-weight: 600;
        color: rgba(255, 255, 255, 0.95);
        margin-bottom: 12rpx;
        margin-left: 12rpx;
      }
    }

    .input-item {
      background: rgba(255, 255, 255, 0.15);
      border: 2rpx solid rgba(255, 255, 255, 0.2);
      border-radius: 28rpx;
      height: 100rpx;
      display: flex;
      align-items: center;
      padding: 0 30rpx;
      transition: all 0.3s;

      &.input-focus {
        background: rgba(255, 255, 255, 0.25);
        border-color: rgba(255, 255, 255, 0.6);
        transform: translateY(-2rpx);
      }

      .icon {
        font-size: 40rpx;
        margin-right: 20rpx;
        color: rgba(255, 255, 255, 0.8);
      }
      
      &.input-focus .icon {
        color: #fff;
      }

      .input {
        flex: 1;
        font-size: 30rpx;
        color: white;
        height: 100%;
      }

      .password-toggle {
        padding: 10rpx;
        margin-right: -10rpx;
        display: flex;
        align-items: center;
        justify-content: center;
        opacity: 0.8;
      }
    }

    /* 密码强度 */
    .password-strength {
        display: flex;
        gap: 8rpx;
        margin-top: 16rpx;
        padding: 0 10rpx;

        .strength-bar {
            flex: 1;
            height: 6rpx;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 4rpx;
            transition: all 0.3s;

            &.weak { background: #FF3B30; }
            &.medium { background: #FF9500; }
            &.strong { background: #34C759; }
        }
    }
    .strength-text {
        display: block;
        text-align: right;
        font-size: 22rpx;
        color: rgba(255, 255, 255, 0.7);
        margin-top: 8rpx;
        margin-right: 10rpx;
    }

    /* 验证码图片 */
    .login-code {
      height: 100rpx;
      display: flex;
      align-items: center;
      
      .login-code-img {
        width: 200rpx;
        height: 100rpx;
        border-radius: 28rpx;
        background: rgba(255, 255, 255, 0.2);
      }
    }

    /* 协议复选框 */
    .agreement {
        display: flex;
        align-items: flex-start;
        margin: 40rpx 0;
        padding: 0 10rpx;
        
        .checkbox {
            width: 36rpx;
            height: 36rpx;
            border: 2rpx solid rgba(255, 255, 255, 0.5);
            border-radius: 8rpx;
            margin-right: 16rpx;
            position: relative;
            transition: all 0.3s;
            flex-shrink: 0;
            margin-top: 4rpx;
            
            &.checked {
                background: #007AFF;
                border-color: #007AFF;
                
                &::after {
                    content: '';
                    position: absolute;
                    top: 6rpx;
                    left: 10rpx;
                    width: 12rpx;
                    height: 18rpx;
                    border-right: 4rpx solid white;
                    border-bottom: 4rpx solid white;
                    transform: rotate(45deg);
                }
            }
        }
        
        .agreement-text {
            font-size: 26rpx;
            color: rgba(255, 255, 255, 0.8);
            line-height: 1.5;
            
            .link {
                color: white;
                text-decoration: underline;
                margin: 0 6rpx;
            }
        }
    }

    /* 注册按钮 */
    .action-btn {
      .register-btn {
        width: 100%;
        background: linear-gradient(135deg, #007AFF 0%, #5856D6 100%);
        color: white;
        border: none;
        border-radius: 28rpx;
        height: 100rpx;
        line-height: 100rpx;
        font-size: 34rpx;
        font-weight: 600;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 8px 25px rgba(0, 122, 255, 0.4);
        transition: all 0.3s ease;
        
        &.disabled {
            opacity: 0.5;
            box-shadow: none;
            background: rgba(255, 255, 255, 0.2);
            pointer-events: none;
        }
        
        &::after {
          border: none;
        }
      }
    }

    /* 底部文字 */
    .login-link {
      margin-top: 40rpx;
      text-align: center;
      font-size: 26rpx;
      
      .text-white-opacity {
        color: rgba(255, 255, 255, 0.7);
      }
      
      .text-highlight {
        color: white;
        font-weight: 600;
        margin-left: 10rpx;
      }
    }
  }

  /* 交互状态 */
  .button-hover {
    transform: scale(0.98);
    opacity: 0.9;
  }
  .opacity-hover { opacity: 0.8; }
  .text-hover { opacity: 0.7; }

  @keyframes fadeInUp {
    from { opacity: 0; transform: translateY(40px); }
    to { opacity: 1; transform: translateY(0); }
  }
  
  .flex { display: flex; }
  .align-center { align-items: center; }
  .justify-between { justify-content: space-between; }
</style>
