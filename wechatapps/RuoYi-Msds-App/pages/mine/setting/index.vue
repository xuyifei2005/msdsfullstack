<template>
  <view class="page-container">
    <view class="glass-bg"></view>
    
    <!-- 导航栏 -->
    <view class="nav-bar">
      <view class="nav-left" @click="handleBack">
        <uni-icons type="left" color="#007AFF" size="24"></uni-icons>
      </view>
      <view class="nav-title">设置</view>
      <view class="nav-right" @click="handleUserProfile">
        <uni-icons type="compose" color="#007AFF" size="24"></uni-icons>
      </view>
    </view>

    <view class="content">
      <!-- 用户信息 -->
      <view class="user-profile" @click="handleUserProfile">
        <view class="user-avatar">
          <uni-icons type="person-filled" color="#ffffff" size="30"></uni-icons>
        </view>
        <view class="user-info">
          <view class="user-name">{{ userInfo.nickName || '管理员' }}</view>
          <view class="user-email">{{ userInfo.email || 'admin@msds.com' }}</view>
        </view>
        <uni-icons type="right" color="#c7c7cc" size="14"></uni-icons>
      </view>

      <!-- 通用设置 -->
      <view class="settings-group-title">通用</view>
      <view class="settings-group">
        <view class="settings-item">
          <view class="settings-icon" style="background-color: #007AFF;">
            <uni-icons type="notification-filled" color="#ffffff" size="18"></uni-icons>
          </view>
          <view class="settings-info">
            <view class="settings-title">通知</view>
            <view class="settings-subtitle">推送通知和提醒</view>
          </view>
          <u-switch v-model="settings.notification" active-color="#34c759" size="20"></u-switch>
        </view>
        
        <view class="settings-item">
          <view class="settings-icon" style="background-color: #34C759;">
            <uni-icons type="download-filled" color="#ffffff" size="18"></uni-icons>
          </view>
          <view class="settings-info">
            <view class="settings-title">自动下载</view>
            <view class="settings-subtitle">WiFi环境下自动下载更新</view>
          </view>
          <u-switch v-model="settings.autoDownload" active-color="#34c759" size="20"></u-switch>
        </view>
        
        <view class="settings-item" @click="handleLanguage">
          <view class="settings-icon" style="background-color: #FF9500;">
            <uni-icons type="more-filled" color="#ffffff" size="18"></uni-icons> <!-- language icon substitute -->
          </view>
          <view class="settings-info">
            <view class="settings-title">语言</view>
          </view>
          <view class="settings-value">简体中文</view>
          <uni-icons type="right" color="#c7c7cc" size="14"></uni-icons>
        </view>
      </view>

      <!-- 网络设置 -->
      <view class="settings-group-title">网络</view>
      <view class="settings-group">
        <view class="settings-item" @click="handleAutoDetect">
          <view class="settings-icon" style="background-color: #0A84FF;">
            <uni-icons type="refresh" color="#ffffff" size="18"></uni-icons>
          </view>
          <view class="settings-info">
            <view class="settings-title">自动探测最佳地址</view>
            <view class="settings-subtitle">清除当前地址并重新探测</view>
          </view>
          <uni-icons type="right" color="#c7c7cc" size="14"></uni-icons>
        </view>

        <view class="settings-item">
          <view class="settings-icon" style="background-color: #34C759;">
            <uni-icons type="paperplane" color="#ffffff" size="18"></uni-icons>
          </view>
          <view class="settings-info">
            <view class="settings-title">当前后端地址</view>
            <view class="settings-subtitle">{{ currentUrl || '未设置' }}</view>
          </view>
        </view>

        <view class="settings-item" v-for="url in envList" :key="url" @click="handleChooseBaseUrl(url)">
          <view class="settings-icon" style="background-color: #8E8E93;">
            <uni-icons type="link" color="#ffffff" size="18"></uni-icons>
          </view>
          <view class="settings-info">
            <view class="settings-title">{{ url }}</view>
          </view>
          <view class="settings-value" v-if="currentUrl === url">已选择</view>
          <uni-icons :type="currentUrl === url ? 'checkmarkempty' : 'right'" color="#c7c7cc" size="14"></uni-icons>
        </view>

        <view class="settings-item">
          <view class="settings-icon" style="background-color: #FF9F0A;">
            <uni-icons type="compose" color="#ffffff" size="18"></uni-icons>
          </view>
          <view class="settings-info">
            <view class="settings-title">自定义后端地址</view>
            <view class="settings-subtitle">示例: http://192.168.1.215:18080</view>
          </view>
        </view>
        <view class="custom-row">
          <uni-easyinput v-model="customUrl" placeholder="输入完整地址" :clearable="true"></uni-easyinput>
          <u-button type="primary" size="mini" @click="handleSetCustomUrl">设置并测试</u-button>
        </view>
      </view>

      <!-- 数据管理 -->
      <view class="settings-group-title">数据管理</view>
      <view class="settings-group">
        <view class="settings-item">
          <view class="settings-icon" style="background-color: #5856D6;">
            <uni-icons type="cloud-upload-filled" color="#ffffff" size="18"></uni-icons>
          </view>
          <view class="settings-info">
            <view class="settings-title">云同步</view>
            <view class="settings-subtitle">同步收藏和搜索历史</view>
          </view>
          <u-switch v-model="settings.cloudSync" active-color="#34c759" size="20"></u-switch>
        </view>
        
        <view class="settings-item" @click="handleCleanTmp">
          <view class="settings-icon" style="background-color: #32D74B;">
            <uni-icons type="trash-filled" color="#ffffff" size="18"></uni-icons>
          </view>
          <view class="settings-info">
            <view class="settings-title">缓存管理</view>
            <view class="settings-subtitle">已使用 128MB</view>
          </view>
          <uni-icons type="right" color="#c7c7cc" size="14"></uni-icons>
        </view>

        <view class="settings-item" @click="handleDataExport">
          <view class="settings-icon" style="background-color: #FF6B35;">
            <uni-icons type="upload-filled" color="#ffffff" size="18"></uni-icons>
          </view>
          <view class="settings-info">
            <view class="settings-title">数据导出</view>
            <view class="settings-subtitle">导出收藏和历史记录</view>
          </view>
          <uni-icons type="right" color="#c7c7cc" size="14"></uni-icons>
        </view>
      </view>

      <!-- 安全设置 -->
      <view class="settings-group-title">安全</view>
      <view class="settings-group">
        <view class="settings-item">
          <view class="settings-icon" style="background-color: #FF3B30;">
            <uni-icons type="locked-filled" color="#ffffff" size="18"></uni-icons>
          </view>
          <view class="settings-info">
            <view class="settings-title">安全验证</view>
            <view class="settings-subtitle">Face ID / Touch ID</view>
          </view>
          <u-switch v-model="settings.securityVerification" active-color="#34c759" size="20"></u-switch>
        </view>
        
        <view class="settings-item" @click="handleToPwd">
          <view class="settings-icon" style="background-color: #8E8E93;">
            <uni-icons type="auth-filled" color="#ffffff" size="18"></uni-icons>
          </view>
          <view class="settings-info">
            <view class="settings-title">修改密码</view>
          </view>
          <uni-icons type="right" color="#c7c7cc" size="14"></uni-icons>
        </view>
      </view>

      <!-- 关于 -->
      <view class="settings-group-title">关于</view>
      <view class="settings-group">
        <view class="settings-item" @click="handleToUpgrade">
          <view class="settings-icon" style="background-color: #007AFF;">
            <uni-icons type="info-filled" color="#ffffff" size="18"></uni-icons>
          </view>
          <view class="settings-info">
            <view class="settings-title">关于 MSDS</view>
            <view class="settings-subtitle">版本 1.0.0</view>
          </view>
          <uni-icons type="right" color="#c7c7cc" size="14"></uni-icons>
        </view>

        <view class="settings-item" @click="handleRateApp">
          <view class="settings-icon" style="background-color: #34C759;">
            <uni-icons type="star-filled" color="#ffffff" size="18"></uni-icons>
          </view>
          <view class="settings-info">
            <view class="settings-title">评价应用</view>
          </view>
          <uni-icons type="right" color="#c7c7cc" size="14"></uni-icons>
        </view>

        <view class="settings-item" @click="handleHelpFeedback">
          <view class="settings-icon" style="background-color: #FF9500;">
            <uni-icons type="help-filled" color="#ffffff" size="18"></uni-icons>
          </view>
          <view class="settings-info">
            <view class="settings-title">帮助与反馈</view>
          </view>
          <uni-icons type="right" color="#c7c7cc" size="14"></uni-icons>
        </view>
      </view>

      <!-- 危险操作 -->
      <view class="settings-group-title">危险操作</view>
      <view class="settings-group">
        <view class="settings-item danger-item" @click="handleClearAllData">
          <view class="settings-icon" style="background-color: #FF3B30;">
            <uni-icons type="trash-filled" color="#ffffff" size="18"></uni-icons>
          </view>
          <view class="settings-info">
            <view class="settings-title" style="color: #FF3B30;">清除所有数据</view>
            <view class="settings-subtitle">此操作不可恢复</view>
          </view>
          <uni-icons type="right" color="#c7c7cc" size="14"></uni-icons>
        </view>
      </view>

      <!-- 退出登录 -->
      <view class="settings-group">
        <view class="settings-item" @click="handleLogout">
          <view class="settings-icon" style="background-color: #FF3B30;">
            <uni-icons type="minus-filled" color="#ffffff" size="18"></uni-icons>
          </view>
          <view class="settings-info">
            <view class="settings-title" style="color: #FF3B30;">退出登录</view>
          </view>
        </view>
      </view>
      
      <view class="version-info">
        © 2025 MSDS Management System. All rights reserved.
      </view>
    </view>
  </view>
</template>

<script>
  import { mapGetters } from 'vuex'
  import cfg from '@/config'
  
  export default {
    computed: {
      ...mapGetters(['userInfo'])
    },
    data() {
      return {
        settings: {
          notification: true,
          autoDownload: false,
          cloudSync: true,
          securityVerification: false
        },
        envList: [],
        currentUrl: '',
        customUrl: ''
      }
    },
    onShow() {
      this.envList = (cfg.baseUrlList || []).slice()
      const cached = uni.getStorageSync('baseUrl')
      this.currentUrl = cached || cfg.baseUrl || (this.envList[0] || '')
    },
    methods: {
      handleUserProfile() {
        this.$tab.navigateTo('/pages/mine/info/index')
      },
      handleBack() {
        this.$tab.navigateBack()
      },
      handleLanguage() {
        this.$modal.showToast('暂只支持简体中文')
      },
      handleToPwd() {
        this.$tab.navigateTo('/pages/mine/pwd/index')
      },
      handleToUpgrade() {
        this.$modal.showToast('当前已是最新版本')
      },
      handleCleanTmp() {
        this.$modal.confirm('确定清理缓存吗？').then(() => {
          this.$modal.msgSuccess('清理成功')
        })
      },
      handleDataExport() {
        this.$modal.confirm('确定要导出所有收藏和历史记录吗？').then(() => {
          // 模拟导出过程
          this.$modal.loading("正在导出...")
          setTimeout(() => {
            this.$modal.closeLoading()
            this.$modal.msgSuccess('导出成功，文件已保存至手机存储')
          }, 1500)
        })
      },
      handleRateApp() {
        this.$modal.showToast('感谢您的支持！')
      },
      handleHelpFeedback() {
        this.$tab.navigateTo('/pages/mine/help/index')
      },
      handleAutoDetect() {
        uni.removeStorageSync('baseUrl')
        cfg.baseUrl = ''
        this.currentUrl = ''
        this.$modal.msgSuccess('已清除，下一次请求将自动探测')
      },
      handleChooseBaseUrl(url) {
        cfg.baseUrl = url
        uni.setStorageSync('baseUrl', url)
        this.currentUrl = url
        this.$modal.msgSuccess('已切换到指定地址')
      },
      handleSetCustomUrl() {
        const normalize = (u) => (u && u.startsWith('http')) ? u : (u ? 'http://' + u : '')
        const candidate = normalize(this.customUrl || '')
        if (!candidate) {
          this.$modal.msgError('请输入地址')
          return
        }
        this.$modal.loading('正在测试...')
        uni.request({
          method: 'get',
          timeout: 1500,
          url: candidate + '/captchaImage',
          header: { isToken: false },
          dataType: 'json'
        }).then(r => {
          this.$modal.closeLoading()
          const [, res] = r
          if (res && res.statusCode === 200) {
            cfg.baseUrl = candidate
            uni.setStorageSync('baseUrl', candidate)
            this.currentUrl = candidate
            this.$modal.msgSuccess('已设置并通过连通性测试')
          } else {
            this.$modal.msgError('测试失败，请检查服务可用性')
          }
        }).catch(() => {
          this.$modal.closeLoading()
          this.$modal.msgError('测试失败，请检查网络或地址')
        })
      },
      handleClearAllData() {
        this.$modal.confirm('此操作将清除所有本地数据且不可恢复，确定继续吗？').then(() => {
           this.$modal.loading("正在清除...")
           setTimeout(() => {
             this.$modal.closeLoading()
             this.$modal.msgSuccess('所有数据已清除')
             // 可以选择重置设置或退出登录
           }, 1500)
        })
      },
      handleLogout() {
        this.$modal.confirm('确定注销并退出系统吗？').then(() => {
          this.$store.dispatch('LogOut').then(() => {
            this.$tab.reLaunch('/pages/login')
          })
        })
      }
    }
  }
</script>

<style lang="scss" scoped>
  .page-container {
    min-height: 100vh;
    background-color: #f5f5f7;
    position: relative;
    overflow: hidden;
  }

  .glass-bg {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-image: url('https://images.unsplash.com/photo-1579546929518-9e396f3cc809?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHx8&w=1000&q=80');
    background-size: cover;
    background-position: center;
    opacity: 0.2;
    z-index: 0;
    filter: saturate(1.2) brightness(1.1);
    pointer-events: none;
    animation: subtle-move 30s infinite alternate ease-in-out;
  }

  @keyframes subtle-move {
    0% {
      background-position: 0% 0%;
      transform: scale(1.02);
    }
    50% {
      transform: scale(1.0);
    }
    100% {
      background-position: 100% 100%;
      transform: scale(1.02);
    }
  }

  .nav-bar {
    height: 44px;
    background-color: rgba(255, 255, 255, 0.8);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 16px;
    position: sticky;
    top: 0; /* Adjust based on status bar height if needed */
    z-index: 50;
    border-bottom: 1px solid rgba(0, 0, 0, 0.1);
    /* Add status bar padding for mobile */
    padding-top: var(--status-bar-height);
    box-sizing: content-box;
  }
  
  .nav-left, .nav-right {
    width: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  
  .nav-left {
    justify-content: flex-start;
  }
  
  .nav-right {
    justify-content: flex-end;
  }

  .nav-title {
    font-size: 18px;
    font-weight: bold;
    color: #000;
    flex: 1;
    text-align: center;
  }

  .content {
    padding: 16px;
    position: relative;
    z-index: 1;
    padding-bottom: calc(40px + env(safe-area-inset-bottom));
  }

  .user-profile {
    background-color: rgba(255, 255, 255, 0.8);
    backdrop-filter: blur(5px);
    -webkit-backdrop-filter: blur(5px);
    border-radius: 12px;
    padding: 20px;
    margin-bottom: 20px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
    display: flex;
    align-items: center;
  }

  .user-avatar {
    width: 60px;
    height: 60px;
    border-radius: 30px;
    background: linear-gradient(135deg, #007AFF, #5856D6);
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 16px;
  }

  .user-info {
    flex: 1;
  }

  .user-name {
    font-size: 20px;
    font-weight: 600;
    color: #1d1d1f;
    margin-bottom: 4px;
  }

  .user-email {
    font-size: 14px;
    color: #6e6e73;
  }

  .settings-group-title {
    font-size: 14px;
    font-weight: 600;
    color: #6e6e73;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin: 20px 16px 8px 16px;
  }

  .settings-group {
    background-color: rgba(255, 255, 255, 0.8);
    backdrop-filter: blur(5px);
    -webkit-backdrop-filter: blur(5px);
    border-radius: 12px;
    margin-bottom: 20px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
    overflow: hidden;
  }

  .settings-item {
    display: flex;
    align-items: center;
    padding: 16px;
    border-bottom: 1px solid rgba(0, 0, 0, 0.05);
    transition: all 0.2s ease;
    
    &:last-child {
      border-bottom: none;
    }

    &:active {
      background-color: rgba(0, 0, 0, 0.05);
    }
  }

  .settings-icon {
    width: 32px;
    height: 32px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 12px;
  }

  .settings-info {
    flex: 1;
  }

  .settings-title {
    font-size: 16px;
    font-weight: 500;
    color: #1d1d1f;
    margin-bottom: 2px;
  }

  .settings-subtitle {
    font-size: 14px;
    color: #6e6e73;
  }

  .settings-value {
    font-size: 16px;
    color: #6e6e73;
    margin-right: 8px;
  }

  .version-info {
    text-align: center;
    padding: 20px;
    color: #8e8e93;
    font-size: 14px;
  }

  .custom-row {
    display: flex;
    gap: 8px;
    align-items: center;
    padding: 12px 16px;
  }
</style>
