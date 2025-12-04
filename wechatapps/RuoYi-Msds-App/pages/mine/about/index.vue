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
        <view class="app-name">MSDS安全智库网移动端</view>
        <view class="app-version">Version {{version}}</view>
      </view>

      <view class="glass-card" v-if="aboutList.length > 0">
        <u-cell-group :border="false">
          <u-cell
            v-for="(item, index) in aboutList"
            :key="index"
            :title="item.title"
            isLink
            :url="'/pages/mine/about/detail?id=' + item.id"
            @click="handleAboutClick(item)"
            icon="file-text"
            :iconStyle="{color: '#007AFF', fontSize: '20px'}"
          ></u-cell>
        </u-cell-group>
      </view>

      <view class="glass-card" style="margin-top: 20rpx;">
        <u-cell-group :border="false">
          <u-cell
            title="版本信息"
            :value="'v' + version"
            icon="info-circle"
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
        <view>Copyright &copy; 2025 sxjfkj.com</view>
        <view>All Rights Reserved.</view>
      </view>
    </view>
  </view>
</template>

<script>
  import { listAbout } from "@/api/system/about";

  export default {
    data() {
      return {
        url: getApp().globalData.config.appInfo.site_url,
        version: getApp().globalData.config.appInfo.version,
        aboutList: []
      }
    },
    onLoad() {
      this.getList();
    },
    methods: {
      getList() {
        listAbout().then(response => {
          this.aboutList = response.rows;
        });
      },
      handleAboutClick(item) {
        uni.setStorageSync('currentAbout', item);
        this.$tab.navigateTo('/pages/mine/about/detail');
      },
      openLink() {
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
    0% { transform: scale(1.0); }
    100% { transform: scale(1.05); }
  }

  .content-wrapper {
    position: relative;
    z-index: 1;
    padding: 20rpx;
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
      margin-bottom: 20rpx;
      box-shadow: 0 8rpx 24rpx rgba(0,0,0,0.1);
    }
    
    .app-name {
      font-size: 40rpx;
      font-weight: bold;
      color: #333;
      margin-bottom: 10rpx;
    }
    
    .app-version {
      font-size: 26rpx;
      color: #888;
    }
  }

  .glass-card {
    background: rgba(255, 255, 255, 0.65);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border-radius: 24rpx;
    border: 1px solid rgba(255, 255, 255, 0.4);
    box-shadow: 0 8rpx 32rpx rgba(31, 38, 135, 0.07);
    overflow: hidden;
  }

  .copyright {
    margin-top: 60rpx;
    text-align: center;
    color: #999;
    font-size: 24rpx;
    line-height: 1.6;
    padding-bottom: 40rpx;
  }
</style>
