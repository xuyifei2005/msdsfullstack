<template>
  <view class="page-container">
    <!-- 欢迎横幅 -->
    <view class="welcome-banner">
      <view>
        <h2 class="banner-title">欢迎使用MSDS管理</h2>
        <p class="banner-subtitle">快速查阅化学品安全技术说明书</p>
      </view>
      <u-icon name="shield-fill" color="#fff" size="32"></u-icon>
    </view>

    <!-- 快速操作卡片 -->
    <u-grid :col="2" :border="false" class="quick-actions">
      <u-grid-item @click="handleScan">
        <view class="action-card">
          <u-icon name="scan" color="#19be6b" size="28"></u-icon>
          <text class="action-title">扫码查阅</text>
          <text class="action-desc">扫描二维码快速查看</text>
        </view>
      </u-grid-item>
      <u-grid-item @click="handleSearch">
        <view class="action-card">
          <u-icon name="search" color="#2979ff" size="28"></u-icon>
          <text class="action-title">关键词搜索</text>
          <text class="action-desc">输入化学品名称搜索</text>
        </view>
      </u-grid-item>
    </u-grid>

    <!-- 最近查看 -->
    <view class="recent-view">
      <view class="section-header">
        <h3 class="section-title">最近查看</h3>
        <text class="see-all" @click="viewAllRecent">查看全部</text>
      </view>
      <view class="recent-list">
        <view class="recent-item" v-for="(item, index) in recentList" :key="index">
          <u-image width="50px" height="50px" :src="item.image" radius="8"></u-image>
          <view class="item-info">
            <h4 class="item-title">{{ item.name }}</h4>
            <p class="item-cas">CAS: {{ item.cas }}</p>
            <p class="item-time">{{ item.time }}</p>
          </view>
          <u-icon name="arrow-right" color="#c0c4cc" size="14"></u-icon>
        </view>
      </view>
    </view>

    <!-- 快捷功能 -->
    <view class="quick-features">
      <h3 class="section-title">快捷功能</h3>
      <u-grid :col="4" :border="false">
        <u-grid-item v-for="(feature, index) in features" :key="index" @click="handleFeatureClick(feature)">
          <view class="feature-item">
            <view class="feature-icon-wrapper" :style="{ backgroundColor: feature.bgColor }">
              <u-icon :name="feature.icon" :color="feature.color" size="24"></u-icon>
            </view>
            <text class="feature-name">{{ feature.name }}</text>
          </view>
        </u-grid-item>
      </u-grid>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
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
          bgColor: '#fdf6ec',
          path: '/pages/mine/favorites'
        },
        {
          name: '查看历史',
          icon: 'clock-fill',
          color: '#606266',
          bgColor: '#f8f8f8',
          path: '/pages/mine/history'
        },
        {
          name: '危险品',
          icon: 'error-circle-fill',
          color: '#ff9900',
          bgColor: '#fef0f0',
          path: '/pages/features/dangerous'
        },
        {
          name: '设置',
          icon: 'setting-fill',
          color: '#909399',
          bgColor: '#f8f8f8',
          path: '/pages/mine/settings'
        }
      ]
    };
  },
  methods: {
    handleScan() {
      uni.scanCode({
        success: function (res) {
          console.log('条码类型：' + res.scanType);
          console.log('条码内容：' + res.result);
          // 跳转到详情页
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
      uni.navigateTo({ url: feature.path });
    }
  }
};
</script>

<style lang="scss" scoped>
.page-container {
  padding: 15px;
  background-color: #f4f4f5;
}

.welcome-banner {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  margin-bottom: 15px;
  color: white;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 12px;
  .banner-title {
    font-size: 20px;
    font-weight: bold;
    margin-bottom: 5px;
  }
  .banner-subtitle {
    font-size: 14px;
    opacity: 0.8;
  }
}

.quick-actions {
  margin-bottom: 20px;
  .action-card {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    padding: 15px;
    background-color: #ffffff;
    border-radius: 8px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.05);
    .action-title {
      font-size: 16px;
      font-weight: 600;
      margin-top: 8px;
      color: $u-main-color;
    }
    .action-desc {
      font-size: 12px;
      color: $u-tips-color;
    }
  }
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  .section-title {
    font-size: 18px;
    font-weight: bold;
    color: $u-main-color;
  }
  .see-all {
    font-size: 14px;
    color: $u-type-primary;
  }
}

.recent-view {
  margin-bottom: 20px;
}

.recent-list {
  .recent-item {
    display: flex;
    align-items: center;
    padding: 15px;
    margin-bottom: 10px;
    background-color: #ffffff;
    border-radius: 8px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.05);
    .item-info {
      flex: 1;
      margin-left: 12px;
      .item-title {
        font-size: 15px;
        font-weight: 500;
        color: $u-main-color;
      }
      .item-cas {
        font-size: 13px;
        color: $u-content-color;
        margin: 2px 0;
      }
      .item-time {
        font-size: 12px;
        color: $u-tips-color;
      }
    }
  }
}

.quick-features {
  .feature-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    .feature-icon-wrapper {
      width: 50px;
      height: 50px;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 8px;
    }
    .feature-name {
      font-size: 12px;
      color: $u-content-color;
    }
  }
}
</style>
