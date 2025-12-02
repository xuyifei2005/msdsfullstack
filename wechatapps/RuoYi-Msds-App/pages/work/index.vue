<template>
  <view class="work-container">
    <!-- 背景图片/效果 -->
    <view class="glass-bg"></view>

    <view class="content-wrapper">
      <!-- 顶部标题区 (可选，如果使用了自定义导航栏可以去掉) -->
      <view class="header-section" :style="{ paddingTop: statusBarHeight + 'px' }">
        <text class="header-title">工作台</text>
        <text class="header-subtitle">Laboratory Management</text>
      </view>

      <!-- 轮播图 -->
      <view class="banner-section">
        <u-swiper
          :list="bannerList"
          keyName="image"
          :autoplay="true"
          radius="12"
          height="160"
          indicator
          indicatorMode="line"
          circular
          bgColor="transparent"
          @click="clickBannerItem"
        ></u-swiper>
      </view>

      <!-- 系统管理 -->
      <view class="section-container glass-card">
        <view class="section-header">
          <uni-icons type="grid-filled" color="#007AFF" size="20"></uni-icons>
          <text class="section-title">系统管理</text>
        </view>
        <u-grid :border="false" col="4">
          <u-grid-item
            v-for="(item, index) in sysGridList"
            :key="index"
            customStyle="padding-top: 20px; padding-bottom: 20px"
            @click="gridClick(item)"
          >
            <view class="grid-icon-bg" :style="{ backgroundColor: item.color || '#e8f3ff' }">
              <uni-icons :type="item.icon" :color="item.iconColor || '#007AFF'" size="28"></uni-icons>
            </view>
            <text class="grid-text">{{ item.title }}</text>
          </u-grid-item>
        </u-grid>
      </view>

      <!-- 常用工具 (示例扩展) -->
      <view class="section-container glass-card">
        <view class="section-header">
          <uni-icons type="settings-filled" color="#34C759" size="20"></uni-icons>
          <text class="section-title">常用工具</text>
        </view>
        <u-grid :border="false" col="4">
          <u-grid-item
            v-for="(item, index) in toolsGridList"
            :key="index"
            customStyle="padding-top: 20px; padding-bottom: 20px"
            @click="gridClick(item)"
          >
            <view class="grid-icon-bg" :style="{ backgroundColor: item.color || '#eafdf0' }">
              <uni-icons :type="item.icon" :color="item.iconColor || '#34C759'" size="28"></uni-icons>
            </view>
            <text class="grid-text">{{ item.title }}</text>
          </u-grid-item>
        </u-grid>
      </view>
      
      <!-- 底部留白 -->
      <view class="safe-area-bottom"></view>
    </view>
  </view>
</template>

<script>
  export default {
    data() {
      return {
        statusBarHeight: 20,
        bannerList: [
          { image: '/static/images/banner/banner01.jpg', title: '实验室安全规范' },
          { image: '/static/images/banner/banner02.jpg', title: '危化品管理' },
          { image: '/static/images/banner/banner03.jpg', title: '最新公告' }
        ],
        sysGridList: [
          { title: '用户管理', icon: 'person-filled', color: '#e8f3ff', iconColor: '#007AFF' },
          { title: '角色管理', icon: 'contact-filled', color: '#fff0e6', iconColor: '#FF9500' },
          { title: '菜单管理', icon: 'list', color: '#fce8ff', iconColor: '#AF52DE' },
          { title: '部门管理', icon: 'home-filled', color: '#e8fff3', iconColor: '#34C759' },
          { title: '岗位管理', icon: 'heart-filled', color: '#ffe8e8', iconColor: '#FF3B30' },
          { title: '字典管理', icon: 'list', color: '#e8faff', iconColor: '#5AC8FA' },
          { title: '参数设置', icon: 'settings-filled', color: '#f2f2f7', iconColor: '#8E8E93' },
          { title: '通知公告', icon: 'notification-filled', color: '#fff8e6', iconColor: '#FFCC00' }
        ],
        toolsGridList: [
          { title: '日志管理', icon: 'email-filled', color: '#e8f3ff', iconColor: '#007AFF' },
          { title: '在线监控', icon: 'videocam-filled', color: '#e8fff3', iconColor: '#34C759' },
          { title: '数据报表', icon: 'cloud-upload-filled', color: '#fff0e6', iconColor: '#FF9500' },
          { title: '系统帮助', icon: 'help-filled', color: '#f2f2f7', iconColor: '#8E8E93' }
        ]
      }
    },
    onLoad() {
      const systemInfo = uni.getSystemInfoSync();
      this.statusBarHeight = systemInfo.statusBarHeight;
    },
    methods: {
      clickBannerItem(index) {
        console.log('Banner clicked:', this.bannerList[index]);
        this.$modal.showToast('Banner点击: ' + this.bannerList[index].title);
      },
      gridClick(item) {
        this.$modal.showToast(item.title + ' 模块建设中~');
      }
    }
  }
</script>

<style lang="scss" scoped>
  .work-container {
    min-height: 100vh;
    position: relative;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
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
    opacity: 0.15;
    z-index: 0;
    filter: saturate(1.2) brightness(1.1);
    pointer-events: none;
    animation: subtle-move 30s infinite alternate ease-in-out;
  }

  @keyframes subtle-move {
    0% { background-position: 0% 0%; transform: scale(1.0); }
    100% { background-position: 100% 100%; transform: scale(1.05); }
  }

  .content-wrapper {
    position: relative;
    z-index: 1;
    padding: 0 16px;
  }

  .header-section {
    display: flex;
    flex-direction: column;
    padding: 12px 4px 16px;
  }

  .header-title {
    font-size: 28px;
    font-weight: 700;
    color: #1d1d1f;
    letter-spacing: -0.5px;
  }

  .header-subtitle {
    font-size: 14px;
    color: #86868b;
    margin-top: 4px;
    font-weight: 500;
  }

  .banner-section {
    margin-bottom: 24px;
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
    border-radius: 12px;
    overflow: hidden;
  }

  .section-container {
    margin-bottom: 24px;
    border-radius: 16px;
    overflow: hidden;
    transition: transform 0.2s ease;
  }

  .glass-card {
    background: rgba(255, 255, 255, 0.65);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border: 1px solid rgba(255, 255, 255, 0.4);
    box-shadow: 0 8px 32px rgba(31, 38, 135, 0.05);
  }

  .section-header {
    display: flex;
    align-items: center;
    padding: 16px 16px 8px;
    margin-bottom: 8px;
  }

  .section-title {
    font-size: 17px;
    font-weight: 600;
    color: #1d1d1f;
    margin-left: 8px;
  }

  .grid-text {
    font-size: 13px;
    color: #333;
    margin-top: 8px;
    font-weight: 500;
  }
  
  .grid-icon-bg {
    width: 48px;
    height: 48px;
    border-radius: 14px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 4px;
    transition: transform 0.2s ease;
  }
  
  .grid-icon-bg:active {
    transform: scale(0.92);
  }
  
  .safe-area-bottom {
    height: env(safe-area-inset-bottom);
    height: constant(safe-area-inset-bottom);
    min-height: 20px;
  }
</style>
