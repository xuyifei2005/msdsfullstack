<template>
  <view class="work-container">
    <!-- 背景图片/效果 -->
    <view class="glass-bg"></view>

    <view class="content-wrapper">
      <!-- 顶部标题区 -->
      <view class="header-section" :style="{ paddingTop: statusBarHeight + 'px' }">
        <text class="header-title">工作台</text>
        <text class="header-subtitle">Laboratory Safety Education</text>
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

      <!-- 安全教育核心功能 (新增) -->
      <view class="section-container glass-card">
        <view class="section-header">
          <uni-icons type="vip-filled" color="#007AFF" size="20"></uni-icons>
          <text class="section-title">安全教育</text>
        </view>
        <u-grid :border="false" col="4">
          <u-grid-item
            v-for="(item, index) in eduGridList"
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

      <!-- 实验室常用服务 (新增) -->
      <view class="section-container glass-card">
        <view class="section-header">
          <uni-icons type="grid-filled" color="#34C759" size="20"></uni-icons>
          <text class="section-title">实验室服务</text>
        </view>
        <u-grid :border="false" col="4">
          <u-grid-item
            v-for="(item, index) in serviceGridList"
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

      <!-- 系统管理 (原有功能恢复) -->
      <view class="section-container glass-card">
        <view class="section-header">
          <uni-icons type="gear-filled" color="#FF9500" size="20"></uni-icons>
          <text class="section-title">系统管理</text>
        </view>
        <u-grid :border="false" col="4">
          <u-grid-item
            v-for="(item, index) in sysGridList"
            :key="index"
            customStyle="padding-top: 20px; padding-bottom: 20px"
            @click="gridClick(item)"
          >
            <view class="grid-icon-bg" :style="{ backgroundColor: item.color || '#fff0e6' }">
              <uni-icons :type="item.icon" :color="item.iconColor || '#FF9500'" size="28"></uni-icons>
            </view>
            <text class="grid-text">{{ item.title }}</text>
          </u-grid-item>
        </u-grid>
      </view>

      <!-- 常用工具 (原有功能恢复) -->
      <view class="section-container glass-card">
        <view class="section-header">
          <uni-icons type="settings-filled" color="#8E8E93" size="20"></uni-icons>
          <text class="section-title">常用工具</text>
        </view>
        <u-grid :border="false" col="4">
          <u-grid-item
            v-for="(item, index) in toolsGridList"
            :key="index"
            customStyle="padding-top: 20px; padding-bottom: 20px"
            @click="gridClick(item)"
          >
            <view class="grid-icon-bg" :style="{ backgroundColor: item.color || '#f2f2f7' }">
              <uni-icons :type="item.icon" :color="item.iconColor || '#8E8E93'" size="28"></uni-icons>
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
        // 使用 Unsplash 开源高质量图片
        bannerList: [
          { 
            image: 'https://images.unsplash.com/photo-1576086213369-97a306d36557?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', 
            title: '实验室安全准入教育',
            url: '/pages/education/course/required'
          },
          { 
            image: 'https://images.unsplash.com/photo-1532094349884-543bc11b234d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', 
            title: '化学品安全规范',
            url: '/pages/education/course/list?type=chemical'
          },
          { 
            image: 'https://images.unsplash.com/photo-1605918321755-0b5ffd8a796a?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', 
            title: '仪器设备操作指南',
            url: '/pages/education/course/list?type=equipment'
          }
        ],
        // 核心教育功能 (新增)
        eduGridList: [
          { title: '必修课程', icon: 'map-filled', color: '#e8f3ff', iconColor: '#007AFF', path: '/pages/education/course/required' },
          { title: '选修课程', icon: 'list', color: '#fff0e6', iconColor: '#FF9500', path: '/pages/education/course/elective' },
          { title: '在线考试', icon: 'paperplane-filled', color: '#fce8ff', iconColor: '#AF52DE', path: '/pages/education/exam/list' },
          { title: '我的证书', icon: 'star-filled', color: '#e8fff3', iconColor: '#34C759', path: '/pages/education/certificate/index' }
        ],
        // 常用服务功能 (新增)
        serviceGridList: [
          { title: '扫码准入', icon: 'scan', color: '#e8faff', iconColor: '#5AC8FA', path: '/pages/common/scan/index' },
          { title: '隐患上报', icon: 'camera-filled', color: '#fff8e6', iconColor: '#FFCC00', path: '/pages/education/hazard/report' },
          { title: '违规记录', icon: 'info-filled', color: '#ffe8e8', iconColor: '#FF3B30', path: '/pages/education/record/violation' },
          { title: '帮助中心', icon: 'help-filled', color: '#f2f2f7', iconColor: '#8E8E93', path: '/pages/common/help/index' }
        ],
        // 系统管理 (原有功能恢复)
        sysGridList: [
          { title: '用户管理', icon: 'person-filled', color: '#e8f3ff', iconColor: '#007AFF', path: '/pages/system/user/index' },
          { title: '角色管理', icon: 'contact-filled', color: '#fff0e6', iconColor: '#FF9500', path: '/pages/system/role/index' },
          { title: '菜单管理', icon: 'list', color: '#fce8ff', iconColor: '#AF52DE', path: '/pages/system/menu/index' },
          { title: '部门管理', icon: 'home-filled', color: '#e8fff3', iconColor: '#34C759', path: '/pages/system/dept/index' },
          { title: '岗位管理', icon: 'heart-filled', color: '#ffe8e8', iconColor: '#FF3B30', path: '/pages/system/post/index' },
          { title: '字典管理', icon: 'list', color: '#e8faff', iconColor: '#5AC8FA', path: '/pages/system/dict/index' },
          { title: '参数设置', icon: 'settings-filled', color: '#f2f2f7', iconColor: '#8E8E93', path: '/pages/system/config/index' },
          { title: '通知公告', icon: 'notification-filled', color: '#fff8e6', iconColor: '#FFCC00', path: '/pages/system/notice/index' }
        ],
        // 常用工具 (原有功能恢复)
        toolsGridList: [
          { title: '日志管理', icon: 'email-filled', color: '#e8f3ff', iconColor: '#007AFF', path: '/pages/monitor/log/index' },
          { title: '在线监控', icon: 'videocam-filled', color: '#e8fff3', iconColor: '#34C759', path: '/pages/monitor/online/index' },
          { title: '数据报表', icon: 'cloud-upload-filled', color: '#fff0e6', iconColor: '#FF9500', path: '/pages/monitor/report/index' },
          { title: '系统帮助', icon: 'help-filled', color: '#f2f2f7', iconColor: '#8E8E93', path: '/pages/common/help/index' }
        ]
      }
    },
    onLoad() {
      const systemInfo = uni.getSystemInfoSync();
      this.statusBarHeight = systemInfo.statusBarHeight;
    },
    methods: {
      clickBannerItem(index) {
        const item = this.bannerList[index];
        console.log('Banner clicked:', item);
        // 如果有链接则跳转
        if (item.url) {
          // 这里仅作演示，实际需根据tabbar或普通页面决定跳转方式
          // uni.navigateTo({ url: item.url });
          this.$modal.showToast('跳转至: ' + item.title);
        }
      },
      gridClick(item) {
        // 如果没有配置path，提示建设中
        if (!item.path) {
          this.$modal.showToast(item.title + ' 模块建设中~');
          return;
        }
        
        console.log('Navigate to:', item.path);
        
        // 演示跳转逻辑
        this.$modal.showToast(`准备跳转: ${item.title}`);
        
        // 实际跳转逻辑示例:
        // uni.navigateTo({
        //   url: item.path,
        //   fail: () => {
        //     uni.switchTab({ url: item.path }).catch(() => {
        //       this.$modal.msgError('页面不存在或路径错误');
        //     })
        //   }
        // });
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
    // 使用更有实验室科技感的背景图
    background-image: url('https://images.unsplash.com/photo-1532094349884-543bc11b234d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80');
    background-size: cover;
    background-position: center;
    opacity: 0.1;
    z-index: 0;
    filter: saturate(1.2) brightness(1.1);
    pointer-events: none;
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
    background: rgba(255, 255, 255, 0.75); // 稍微增加不透明度以提高可读性
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border: 1px solid rgba(255, 255, 255, 0.6);
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