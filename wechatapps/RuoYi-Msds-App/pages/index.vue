<template>
  <view class="page-container">
    <!-- 全局背景 -->
    <view class="glass-bg"></view>
    
    <!-- 自定义导航栏 -->
    <view class="custom-navbar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="navbar-content">
        <text class="app-title">MSDS管理</text>
      </view>
    </view>

    <!-- 滚动内容区域 -->
    <view class="content-area" :style="{ paddingTop: (statusBarHeight + 44 + 10) + 'px' }">
      
      <!-- 欢迎横幅 -->
      <view class="welcome-banner">
        <view class="banner-content">
          <text class="banner-title">欢迎使用 MSDS</text>
          <text class="banner-subtitle">安全数据 · 快速查阅 · 风险管控</text>
        </view>
        <view class="banner-icon-box">
          <u-icon name="shield-fill" color="rgba(255,255,255,0.9)" size="48"></u-icon>
        </view>
      </view>

      <!-- 核心功能卡片 -->
      <view class="section-header">
        <text class="section-title">常用功能</text>
      </view>
      
      <view class="quick-actions-grid">
        <view class="glass-card action-card" @click="handleScan">
          <view class="icon-circle green-gradient">
            <u-icon name="scan" color="#ffffff" size="28"></u-icon>
          </view>
          <view class="action-text">
            <text class="card-title">扫码查阅</text>
            <text class="card-desc">扫描二维码</text>
          </view>
        </view>
        <view class="glass-card action-card" @click="handleSearch">
          <view class="icon-circle blue-gradient">
            <u-icon name="search" color="#ffffff" size="28"></u-icon>
          </view>
          <view class="action-text">
            <text class="card-title">关键词搜索</text>
            <text class="card-desc">查询化学品</text>
          </view>
        </view>
      </view>

      <!-- 更多快捷功能 -->
      <view class="glass-card features-card">
        <u-grid :col="4" :border="false" hover-class="none">
          <u-grid-item v-for="(feature, index) in features" :key="index" @click="handleFeatureClick(feature)" :custom-style="{padding: '15px 0'}">
            <view class="feature-item">
              <view class="feature-icon-wrapper" :style="{ backgroundColor: feature.bgColor }">
                <u-icon :name="feature.icon" :color="feature.color" size="24"></u-icon>
              </view>
              <text class="feature-name">{{ feature.name }}</text>
            </view>
          </u-grid-item>
        </u-grid>
      </view>

      <!-- 最近查看列表 -->
      <view class="recent-section">
        <view class="section-header-row">
          <text class="section-title">最近查看</text>
          <view class="see-all-btn" @click="viewAllRecent">
            <text>查看全部</text>
            <u-icon name="arrow-right" color="#007aff" size="12" style="margin-left: 2px;"></u-icon>
          </view>
        </view>
        
        <view class="recent-list">
          <view class="glass-card recent-item" v-for="(item, index) in recentList" :key="index">
            <view class="chem-icon-placeholder">
              <text class="chem-char">{{ item.name.charAt(0) }}</text>
            </view>
            <view class="item-info">
              <text class="item-title">{{ item.name }}</text>
              <text class="item-cas">CAS: {{ item.cas }}</text>
              <text class="item-time">{{ item.time }}</text>
            </view>
            <u-icon name="arrow-right" color="#c7c7cc" size="16"></u-icon>
          </view>
        </view>
      </view>

    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      statusBarHeight: 20,
      recentList: [
        {
          name: '乙醇 (Ethanol)',
          cas: '64-17-5',
          time: '2小时前查看',
          image: '/static/images/sample/ethanol.png'
        },
        {
          name: '丙酮 (Acetone)',
          cas: '67-64-1',
          time: '1天前查看',
          image: '/static/images/sample/acetone.png'
        },
        {
          name: '甲醛 (Formaldehyde)',
          cas: '50-00-0',
          time: '3天前查看',
          image: '/static/images/sample/formaldehyde.png'
        }
      ],
      features: [
        {
          name: '我的收藏',
          icon: 'star-fill',
          color: '#fa3534',
          bgColor: 'rgba(250, 53, 52, 0.1)',
          path: '/pages/favorites/index'
        },
        {
          name: '浏览历史',
          icon: 'clock-fill',
          color: '#606266',
          bgColor: 'rgba(96, 98, 102, 0.1)',
          path: '/pages/mine/history'
        },
        {
          name: '危险品',
          icon: 'error-circle-fill',
          color: '#ff9900',
          bgColor: 'rgba(255, 153, 0, 0.1)',
          path: '/pages/features/dangerous'
        },
        {
          name: '设置',
          icon: 'setting-fill',
          color: '#909399',
          bgColor: 'rgba(144, 147, 153, 0.1)',
          path: '/pages/mine/settings'
        }
      ]
    };
  },
  onLoad() {
    const systemInfo = uni.getSystemInfoSync();
    this.statusBarHeight = systemInfo.statusBarHeight || 20;
  },
  methods: {
    handleScan() {
      uni.scanCode({
        success: function (res) {
          console.log('条码类型：' + res.scanType);
          console.log('条码内容：' + res.result);
          // 实际逻辑：跳转到详情页或解析条码
          uni.showToast({
            title: '扫描成功: ' + res.result,
            icon: 'none'
          });
        }
      });
    },
    handleSearch() {
      uni.navigateTo({ url: '/pages/search/index' });
    },
    viewAllRecent() {
      uni.navigateTo({ url: '/pages/mine/history' });
    },
    handleFeatureClick(feature) {
      if (feature.path) {
        uni.navigateTo({ url: feature.path });
      }
    }
  }
};
</script>

<style lang="scss" scoped>
.page-container {
  min-height: 100vh;
  position: relative;
  background-color: #f5f5f7;
}

/* 毛玻璃背景 */
.glass-bg {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, #e0c3fc 0%, #8ec5fc 100%);
  opacity: 0.3;
  z-index: 0;
  pointer-events: none;
}

/* 自定义导航栏 */
.custom-navbar {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  z-index: 100;
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.3);
  
  .navbar-content {
    height: 44px;
    display: flex;
    align-items: center;
    justify-content: center;
    
    .app-title {
      font-size: 17px;
      font-weight: 600;
      color: #000000;
    }
  }
}

.content-area {
  position: relative;
  z-index: 1;
  padding: 0 16px;
  padding-bottom: 30px;
}

/* 欢迎横幅 */
.welcome-banner {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 24px;
  margin-bottom: 24px;
  color: white;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 20px;
  box-shadow: 0 10px 20px rgba(118, 75, 162, 0.2);
  position: relative;
  overflow: hidden;
  
  &::before {
    content: '';
    position: absolute;
    top: -50%;
    left: -50%;
    width: 200%;
    height: 200%;
    background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 60%);
    pointer-events: none;
  }
  
  .banner-content {
    z-index: 2;
    .banner-title {
      font-size: 22px;
      font-weight: bold;
      margin-bottom: 8px;
      display: block;
    }
    .banner-subtitle {
      font-size: 13px;
      opacity: 0.9;
      font-weight: 300;
    }
  }
  
  .banner-icon-box {
    z-index: 2;
    opacity: 0.9;
  }
}

/* 通用毛玻璃卡片 */
.glass-card {
  background: rgba(255, 255, 255, 0.75);
  backdrop-filter: blur(15px);
  -webkit-backdrop-filter: blur(15px);
  border-radius: 16px;
  border: 1px solid rgba(255, 255, 255, 0.6);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.03);
}

.section-header, .section-header-row {
  margin-bottom: 12px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.section-title {
  font-size: 18px;
  font-weight: 700;
  color: #333;
  padding-left: 4px;
}

.see-all-btn {
  display: flex;
  align-items: center;
  font-size: 13px;
  color: #007aff;
  padding: 4px 8px;
  
  &:active {
    opacity: 0.7;
  }
}

/* 快速操作网格 */
.quick-actions-grid {
  display: flex;
  justify-content: space-between;
  margin-bottom: 24px;
  gap: 15px;
  
  .action-card {
    flex: 1;
    padding: 20px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    text-align: center;
    transition: transform 0.2s;
    
    &:active {
      transform: scale(0.98);
    }
    
    .icon-circle {
      width: 56px;
      height: 56px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 12px;
      box-shadow: 0 6px 12px rgba(0,0,0,0.08);
      
      &.green-gradient {
        background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
      }
      &.blue-gradient {
        background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
      }
    }
    
    .action-text {
      .card-title {
        font-size: 16px;
        font-weight: 600;
        color: #333;
        display: block;
        margin-bottom: 4px;
      }
      .card-desc {
        font-size: 12px;
        color: #888;
      }
    }
  }
}

/* 快捷功能卡片 */
.features-card {
  margin-bottom: 24px;
  padding: 5px 0;
  
  .feature-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    
    .feature-icon-wrapper {
      width: 48px;
      height: 48px;
      border-radius: 14px;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 8px;
    }
    .feature-name {
      font-size: 12px;
      color: #555;
      font-weight: 500;
    }
  }
}

/* 最近查看列表 */
.recent-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
  
  .recent-item {
    display: flex;
    align-items: center;
    padding: 16px;
    transition: background-color 0.2s;
    
    &:active {
      background-color: rgba(255, 255, 255, 0.9);
    }
    
    .chem-icon-placeholder {
      width: 44px;
      height: 44px;
      border-radius: 10px;
      background: linear-gradient(135deg, #f6d365 0%, #fda085 100%);
      display: flex;
      align-items: center;
      justify-content: center;
      margin-right: 14px;
      color: white;
      font-weight: bold;
      font-size: 20px;
      box-shadow: 0 2px 8px rgba(253, 160, 133, 0.3);
    }
    
    .item-info {
      flex: 1;
      display: flex;
      flex-direction: column;
      justify-content: center;
      
      .item-title {
        font-size: 15px;
        font-weight: 600;
        color: #333;
        margin-bottom: 4px;
      }
      
      .item-tags {
        display: flex;
        margin-bottom: 2px;
        .tag-cas {
          font-size: 11px;
          color: #007aff;
          background: rgba(0, 122, 255, 0.1);
          padding: 2px 6px;
          border-radius: 4px;
        }
      }
      
      .item-time {
        font-size: 12px;
        color: #999;
      }
    }
  }
}
</style>
