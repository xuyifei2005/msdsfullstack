<template>
  <view class="mine-container">
    <!-- 毛玻璃背景 -->
    <view class="glass-bg"></view>

    <!-- 自定义状态栏 -->
    <view class="status-bar" :style="{ height: statusBarHeight + 'px' }"></view>

    <!-- 自定义导航栏 -->
    <view class="nav-bar" :style="{ top: statusBarHeight + 'px' }">
      <text class="nav-title">我的</text>
      <view class="nav-action" @click="handleToInfo">
        <uni-icons type="compose" size="24" color="#007AFF"></uni-icons>
      </view>
    </view>

    <!-- 主内容区域 -->
    <scroll-view scroll-y class="content" :style="{ marginTop: (statusBarHeight + 44) + 'px', height: 'calc(100vh - ' + (statusBarHeight + 44) + 'px)' }">
      <!-- 用户信息 -->
      <view class="user-profile" @click="handleToInfo">
        <view class="user-avatar">
          <image v-if="avatar" :src="avatar" class="avatar-img" mode="aspectFill"></image>
          <uni-icons v-else type="person-filled" size="32" color="#ffffff"></uni-icons>
        </view>
        <view class="user-info">
          <view class="user-name">{{ name || '点击登录' }}</view>
          <view class="user-email">{{ name ? '已登录用户' : '请先登录以同步数据' }}</view>
        </view>
        <uni-icons type="arrowright" size="16" color="#c7c7cc"></uni-icons>
      </view>

      <!-- 功能分组 1 -->
      <view class="settings-group-title">常用功能</view>
      <view class="settings-group">
        <view class="settings-item" @click="handleToFavorites">
          <view class="settings-icon" style="background-color: #FF9500;">
            <uni-icons type="star-filled" size="18" color="#ffffff"></uni-icons>
          </view>
          <view class="settings-info">
            <view class="settings-title">我的收藏</view>
          </view>
          <uni-icons type="arrowright" size="16" color="#c7c7cc"></uni-icons>
        </view>

        <view class="settings-item" @click="handleToHistory">
          <view class="settings-icon" style="background-color: #00C7BE;">
            <uni-icons type="eye-filled" size="18" color="#ffffff"></uni-icons>
          </view>
          <view class="settings-info">
            <view class="settings-title">浏览历史</view>
          </view>
          <uni-icons type="arrowright" size="16" color="#c7c7cc"></uni-icons>
        </view>

        <view class="settings-item" @click="handleToPwd">
          <view class="settings-icon" style="background-color: #007AFF;">
            <uni-icons type="auth-filled" size="18" color="#ffffff"></uni-icons>
          </view>
          <view class="settings-info">
            <view class="settings-title">修改密码</view>
          </view>
          <uni-icons type="arrowright" size="16" color="#c7c7cc"></uni-icons>
        </view>

        <view class="settings-item" @click="handleToSettings">
          <view class="settings-icon" style="background-color: #32D74B;">
            <uni-icons type="gear-filled" size="18" color="#ffffff"></uni-icons>
          </view>
          <view class="settings-info">
            <view class="settings-title">系统设置</view>
          </view>
          <uni-icons type="arrowright" size="16" color="#c7c7cc"></uni-icons>
        </view>
      </view>

      <!-- 功能分组 2 -->
      <view class="settings-group-title">关于与帮助</view>
      <view class="settings-group">
        <view class="settings-item" @click="handleHelp">
          <view class="settings-icon" style="background-color: #34C759;">
            <uni-icons type="help-filled" size="18" color="#ffffff"></uni-icons>
          </view>
          <view class="settings-info">
            <view class="settings-title">常见问题</view>
          </view>
          <uni-icons type="arrowright" size="16" color="#c7c7cc"></uni-icons>
        </view>

        <view class="settings-item" @click="handleFeedback">
          <view class="settings-icon" style="background-color: #FF9500;">
            <uni-icons type="chat-filled" size="18" color="#ffffff"></uni-icons>
          </view>
          <view class="settings-info">
            <view class="settings-title">意见反馈</view>
          </view>
          <uni-icons type="arrowright" size="16" color="#c7c7cc"></uni-icons>
        </view>

        <view class="settings-item" @click="handleAbout">
          <view class="settings-icon" style="background-color: #5856D6;">
            <uni-icons type="info-filled" size="18" color="#ffffff"></uni-icons>
          </view>
          <view class="settings-info">
            <view class="settings-title">关于我们</view>
          </view>
          <uni-icons type="arrowright" size="16" color="#c7c7cc"></uni-icons>
        </view>
      </view>

      <!-- 危险操作 -->
      <view class="settings-group-title" v-if="name">账号管理</view>
      <view class="settings-group" v-if="name">
        <view class="settings-item" @click="handleCleanTmp">
          <view class="settings-icon" style="background-color: #8E8E93;">
            <uni-icons type="trash-filled" size="18" color="#ffffff"></uni-icons>
          </view>
          <view class="settings-info">
            <view class="settings-title">清理缓存</view>
            <view class="settings-subtitle">已使用 12.5MB</view>
          </view>
          <uni-icons type="arrowright" size="16" color="#c7c7cc"></uni-icons>
        </view>

        <view class="settings-item danger-item" @click="handleLogout">
          <view class="settings-icon" style="background-color: #FF3B30;">
            <uni-icons type="clear" size="18" color="#ffffff"></uni-icons>
          </view>
          <view class="settings-info">
            <view class="settings-title" style="color: #FF3B30;">退出登录</view>
          </view>
          <uni-icons type="arrowright" size="16" color="#c7c7cc"></uni-icons>
        </view>
      </view>

      <!-- 版本信息 -->
      <view class="version-info">
        安全智库移动端 v1.2.0<br>
        © 2025 All Rights Reserved
      </view>
    </scroll-view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      statusBarHeight: 20
    }
  },
  computed: {
    name() {
      return this.$store.state.user.name
    },
    avatar() {
      return this.$store.state.user.avatar
    }
  },
  onLoad() {
    const systemInfo = uni.getSystemInfoSync();
    this.statusBarHeight = systemInfo.statusBarHeight;
  },
  methods: {
    handleToInfo() {
      if (!this.name) {
        this.$tab.reLaunch('/pages/login');
        return;
      }
      this.$tab.navigateTo('/pages/mine/info/index');
    },
    handleToFavorites() {
      this.$tab.navigateTo('/pages/favorites/index');
    },
    handleToHistory() {
      this.$tab.navigateTo('/pages/mine/history/index');
    },
    handleToPwd() {
      if (!this.name) {
         this.$modal.msgError("请先登录");
         return;
      }
      this.$tab.navigateTo('/pages/mine/pwd/index');
    },
    handleToSettings() {
      this.$tab.navigateTo('/pages/mine/setting/index');
    },
    handleHelp() {
      this.$tab.navigateTo('/pages/mine/help/index');
    },
    handleFeedback() {
      this.$tab.navigateTo('/pages/mine/feedback/index');
    },
    handleAbout() {
      this.$tab.navigateTo('/pages/mine/about/index');
    },
    handleCleanTmp() {
      this.$modal.showToast('缓存清理完成');
    },
    handleLogout() {
      this.$modal.confirm('确定注销并退出系统吗？').then(() => {
        this.$store.dispatch('LogOut').then(() => {
          this.$tab.reLaunch('/pages/login');
        })
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.mine-container {
  min-height: 100vh;
  background-color: #f5f5f7;
  position: relative;
  overflow: hidden;
}

.glass-bg {
  position: absolute;
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
}

.status-bar {
  background-color: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(10px);
  position: fixed;
  top: 0;
  width: 100%;
  z-index: 100;
}

.nav-bar {
  height: 44px;
  background-color: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(10px);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 16px;
  position: fixed;
  width: 100%;
  z-index: 99;
  border-bottom: 1px solid rgba(0, 0, 0, 0.1);
}

.nav-title {
  font-size: 18px;
  font-weight: bold;
  color: #000000;
}

.content {
  padding: 16px;
  box-sizing: border-box;
  position: relative;
  z-index: 1;
}

.user-profile {
  background-color: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(5px);
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
  overflow: hidden;
}

.avatar-img {
  width: 100%;
  height: 100%;
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

.settings-group {
  background-color: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(5px);
  border-radius: 12px;
  margin-bottom: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  overflow: hidden;
}

.settings-group-title {
  font-size: 14px;
  font-weight: 600;
  color: #6e6e73;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  margin: 0 16px 8px 16px;
}

.settings-item {
  display: flex;
  align-items: center;
  padding: 16px;
  border-bottom: 1px solid rgba(0, 0, 0, 0.05);
  transition: all 0.2s ease;
}

.settings-item:last-child {
  border-bottom: none;
}

.settings-item:active {
  background-color: rgba(0, 0, 0, 0.05);
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
  font-size: 12px;
  color: #86868b;
}

.version-info {
  text-align: center;
  padding: 20px;
  color: #8e8e93;
  font-size: 12px;
  line-height: 1.5;
}
</style>
