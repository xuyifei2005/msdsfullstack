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
          <uni-icons type="vip-filled" color="rgba(255,255,255,0.9)" size="48"></uni-icons>
        </view>
      </view>

      <!-- 核心功能卡片 -->
      <view class="section-header">
        <text class="section-title">常用功能</text>
      </view>
      
      <view class="quick-actions-grid">
        <view class="glass-card action-card" @click="handleScan">
          <view class="icon-circle green-gradient">
            <uni-icons type="scan" color="#ffffff" size="28"></uni-icons>
          </view>
          <view class="action-text">
            <text class="card-title">扫码查阅</text>
            <text class="card-desc">扫描化学品二维码</text>
          </view>
        </view>
        <view class="glass-card action-card" @click="handleSearch">
          <view class="icon-circle blue-gradient">
            <uni-icons type="search" color="#ffffff" size="28"></uni-icons>
          </view>
          <view class="action-text">
            <text class="card-title">关键词搜索</text>
            <text class="card-desc">查询MSDS/安全信息</text>
          </view>
        </view>
      </view>

      <!-- 学习中心 (新增) -->
      <view class="glass-card features-card">
        <view class="card-header">
          <text class="card-header-title">学习中心</text>
        </view>
        <u-grid :col="4" :border="false" hover-class="none">
          <u-grid-item v-for="(item, index) in eduFeatures" :key="index" @click="handleGridClick(item)" :custom-style="{padding: '15px 0'}">
            <view class="feature-item">
              <view class="feature-icon-wrapper" :style="{ backgroundColor: item.bgColor }">
                <uni-icons :type="item.icon" :color="item.color" size="24"></uni-icons>
              </view>
              <text class="feature-name">{{ item.name }}</text>
            </view>
          </u-grid-item>
        </u-grid>
      </view>

      <!-- 更多服务 -->
      <view class="glass-card features-card">
        <view class="card-header">
          <text class="card-header-title">更多服务</text>
        </view>
        <u-grid :col="4" :border="false" hover-class="none">
          <u-grid-item v-for="(feature, index) in features" :key="index" @click="handleGridClick(feature)" :custom-style="{padding: '15px 0'}">
            <view class="feature-item">
              <view class="feature-icon-wrapper" :style="{ backgroundColor: feature.bgColor }">
                <uni-icons :type="feature.icon" :color="feature.color" size="24"></uni-icons>
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
            <uni-icons type="arrowright" color="#007aff" size="12" style="margin-left: 2px;"></uni-icons>
          </view>
        </view>
        
        <view class="recent-list" v-if="recentList.length > 0">
          <view class="glass-card recent-item" v-for="(item, index) in recentList" :key="index" @click="handleRecentClick(item)">
            <view class="chem-icon-placeholder">
              <text class="chem-char">{{ item.name.charAt(0) }}</text>
            </view>
            <view class="item-info">
              <text class="item-title">{{ item.name }}</text>
              <text class="item-cas" v-if="item.cas">CAS: {{ item.cas }}</text>
              <text class="item-time">{{ item.time }}</text>
            </view>
            <uni-icons type="arrowright" color="#c7c7cc" size="16"></uni-icons>
          </view>
        </view>
        <view class="empty-state" v-else>
          <text>暂无查看记录</text>
        </view>
      </view>

    </view>
  </view>
</template>

<script>
import { getToken } from '@/utils/auth'
import { listNotice } from '@/api/system/notice'
import { listMsds } from '@/api/msds/msds'

export default {
  data() {
    return {
      statusBarHeight: 20,
      bannerList: [],
      // 默认Banner图，当公告没有图片时使用
      defaultBannerImages: [
        '/static/images/banner/banner01.jpg',
        '/static/images/banner/banner02.jpg',
        '/static/images/banner/banner03.jpg'
      ],
      recentList: [], 
      eduFeatures: [
        {
          name: '我的课程',
          icon: 'book-filled', // 假设有此图标，否则使用 standard
          color: '#007AFF',
          bgColor: 'rgba(0, 122, 255, 0.1)',
          path: '/pages/education/course/my'
        },
        {
          name: '在线考试',
          icon: 'paperplane-filled',
          color: '#5856D6',
          bgColor: 'rgba(88, 86, 214, 0.1)',
          path: '/pages/education/exam/list'
        },
        {
          name: '我的证书',
          icon: 'vip-filled',
          color: '#FF9500',
          bgColor: 'rgba(255, 149, 0, 0.1)',
          path: '/pages/education/certificate/my'
        },
        {
          name: '培训记录',
          icon: 'calendar-filled',
          color: '#34C759',
          bgColor: 'rgba(52, 199, 89, 0.1)',
          path: '/pages/education/training/history'
        }
      ],
      features: [
        {
          name: '我的收藏',
          icon: 'star-filled',
          color: '#fa3534',
          bgColor: 'rgba(250, 53, 52, 0.1)',
          path: '/pages/favorites/index'
        },
        {
          name: '浏览历史',
          icon: 'refresh-filled',
          color: '#606266',
          bgColor: 'rgba(96, 98, 102, 0.1)',
          path: '/pages/mine/history/index'
        },
        {
          name: '危险品库',
          icon: 'info-filled',
          color: '#ff9900',
          bgColor: 'rgba(255, 153, 0, 0.1)',
          path: '/pages/features/dangerous'
        },
        {
          name: '个人中心',
          icon: 'person-filled',
          color: '#909399',
          bgColor: 'rgba(144, 147, 153, 0.1)',
          path: '/pages/mine/index'
        }
      ]
    };
  },
  onLoad() {
    const systemInfo = uni.getSystemInfoSync();
    this.statusBarHeight = systemInfo.statusBarHeight || 20;
  },
  onShow() {
    // 检查登录状态
    if (!getToken()) {
      uni.reLaunch({ url: '/pages/login' });
      return;
    }
    // 获取数据
    this.getBannerList();
    this.getRecentList();
  },
  methods: {
    // 获取公告作为Banner
    getBannerList() {
      listNotice({ pageNum: 1, pageSize: 5 }).then(response => {
        if (response.rows && response.rows.length > 0) {
          this.bannerList = response.rows.map((item, index) => {
            return {
              image: this.defaultBannerImages[index % this.defaultBannerImages.length],
              title: item.noticeTitle,
              id: item.noticeId
            };
          });
        } else {
          // 如果没有公告，显示默认Banner
          this.bannerList = [
            { image: '/static/images/banner/banner01.jpg', title: '实验室安全规范' },
            { image: '/static/images/banner/banner02.jpg', title: '危化品管理' },
            { image: '/static/images/banner/banner03.jpg', title: '最新公告' }
          ];
        }
      });
    },
    handleBannerClick(index) {
      const item = this.bannerList[index];
      if (item && item.id) {
        // 跳转到公告详情
        uni.navigateTo({
           url: `/pages/common/notice/detail?noticeId=${item.id}`,
           fail: () => {
             uni.showToast({ title: '公告详情页开发中', icon: 'none' });
           }
        });
      }
    },
    handleScan() {
      uni.scanCode({
        success: function (res) {
          console.log('条码类型：' + res.scanType);
          console.log('条码内容：' + res.result);
          // 假设扫描结果是 CAS 号或 ID，跳转到详情页
          // 实际开发中可能需要解析 URL 或特定格式
          uni.showLoading({ title: '解析中...' });
          setTimeout(() => {
             uni.hideLoading();
             uni.navigateTo({
               url: `/pages/document/detail?code=${res.result}`,
               fail: () => {
                 uni.showToast({ title: '无法识别的二维码', icon: 'none' });
               }
             });
          }, 500);
        },
        fail: function(err) {
            // 仅提示错误
            console.log(err);
        }
      });
    },
    handleSearch() {
      uni.navigateTo({ url: '/pages/search/index' });
    },
    viewAllRecent() {
      uni.navigateTo({ url: '/pages/mine/history' });
    },
    handleGridClick(item) {
      if (item.path) {
        uni.navigateTo({ 
          url: item.path,
          fail: () => {
             uni.showToast({ title: '功能开发中', icon: 'none' });
           }
        });
      }
    },
    handleRecentClick(item) {
        // 跳转到详情
        uni.navigateTo({ url: '/pages/document/detail?id=' + item.id });
    },
    getRecentList() {
        // 获取最新的MSDS数据
        listMsds({ pageNum: 1, pageSize: 5 }).then(response => {
            if (response.rows) {
                this.recentList = response.rows.map(item => ({
                    id: item.id,
                    name: item.productName,
                    cas: item.casNumber,
                    time: item.createTime
                }));
            }
        });
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
  
  .card-header {
      padding: 12px 16px 4px;
      .card-header-title {
          font-size: 15px;
          font-weight: 600;
          color: #333;
      }
  }
  
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
      
      .item-cas {
        font-size: 12px;
        color: #666;
        margin-bottom: 2px;
      }
      
      .item-time {
        font-size: 12px;
        color: #999;
      }
    }
  }
}

.empty-state {
    padding: 30px;
    text-align: center;
    color: #999;
    font-size: 14px;
}
</style>
