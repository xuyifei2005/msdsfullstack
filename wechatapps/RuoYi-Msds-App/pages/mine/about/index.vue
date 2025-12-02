<template>
  <view class="about-container">
    <!-- Glass Background -->
    <view class="glass-bg"></view>
    
    <!-- Custom Navbar -->
    <u-navbar
      title="关于我们"
      :autoBack="true"
      placeholder
      bgColor="transparent"
      leftIconColor="#333"
      titleStyle="color: #333; font-weight: 600;"
    ></u-navbar>

    <view class="content-wrapper">
      <view class="header-section">
        <image class="logo" src="/static/logo200.png" mode="widthFix"></image>
        <view class="app-name">若依移动端</view>
        <view class="app-version">Version {{version}}</view>
      </view>

      <view class="glass-card">
        <u-cell-group :border="false">
          <u-cell
            title="版本信息"
            :value="'v' + version"
            icon="info-circle"
            :iconStyle="{color: '#007AFF', fontSize: '20px'}"
          ></u-cell>
          <u-cell
            title="官方邮箱"
            value="ruoyi@xx.com"
            icon="email"
            :iconStyle="{color: '#007AFF', fontSize: '20px'}"
          ></u-cell>
          <u-cell
            title="服务热线"
            value="400-999-9999"
            icon="phone"
            :iconStyle="{color: '#007AFF', fontSize: '20px'}"
          ></u-cell>
          <u-cell
            title="公司网站"
            :value="url"
            :isLink="true"
            icon="globe"
            :iconStyle="{color: '#007AFF', fontSize: '20px'}"
            @click="openLink"
          ></u-cell>
        </u-cell-group>
      </view>

      <view class="copyright">
        <view>Copyright &copy; 2025 ruoyi.vip</view>
        <view>All Rights Reserved.</view>
      </view>
    </view>
  </view>
</template>

<script>
  export default {
    data() {
      return {
        url: getApp().globalData.config.appInfo.site_url,
        version: getApp().globalData.config.appInfo.version
      }
    },
    methods: {
      openLink() {
        // For simple linking, or use a webview
        // uni.navigateTo({ url: '/pages/common/webview/index?url=' + encodeURIComponent(this.url) });
        // Or copy to clipboard
        uni.setClipboardData({
          data: this.url,
          success: () => {
            uni.$u.toast('网址已复制');
          }
        });
      }
    }
  }
</script>

<style lang="scss" scoped>
  page {
    background-color: #f5f7fa;
  }

  .about-container {
    position: relative;
    min-height: 100vh;
  }

  /* Glass Background Animation */
  .glass-bg {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-image: url('https://images.unsplash.com/photo-1579546929518-9e396f3cc809?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHx8&w=1000&q=80');
    background-size: cover;
    background-position: center;
    opacity: 0.15;
    z-index: 0;
    filter: saturate(1.2) brightness(1.1);
    pointer-events: none;
    animation: subtle-move 30s infinite alternate ease-in-out;
  }

  @keyframes subtle-move {
    0% { background-position: 0% 0%; transform: scale(1.0); }
    100% { background-position: 100% 100%; transform: scale(1.1); }
  }

  .content-wrapper {
    position: relative;
    z-index: 1;
    padding: 30rpx;
  }

  .header-section {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 60rpx 0;
    
    .logo {
      width: 160rpx;
      height: 160rpx;
      border-radius: 30rpx;
      box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
      margin-bottom: 20rpx;
    }

    .app-name {
      font-size: 36rpx;
      font-weight: 600;
      color: #333;
      margin-bottom: 10rpx;
    }

    .app-version {
      font-size: 24rpx;
      color: #888;
      background: rgba(0, 0, 0, 0.05);
      padding: 4rpx 16rpx;
      border-radius: 20rpx;
    }
  }

  .glass-card {
    background: rgba(255, 255, 255, 0.65);
    backdrop-filter: blur(16px) saturate(180%);
    -webkit-backdrop-filter: blur(16px) saturate(180%);
    border-radius: 24rpx;
    border: 1px solid rgba(255, 255, 255, 0.5);
    overflow: hidden; /* For u-cell-group radius */
    box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.07);
  }

  .copyright {
    margin-top: 80rpx;
    text-align: center;
    
    view {
      font-size: 24rpx;
      color: #999;
      line-height: 1.5;
    }
  }
</style>
