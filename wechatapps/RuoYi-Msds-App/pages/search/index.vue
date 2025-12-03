<template>
  <view class="page-container">
    <!-- 背景图片/效果 -->
    <view class="glass-bg"></view>

    <!-- 状态栏占位 -->
    <view class="status-bar" :style="{ height: statusBarHeight + 'px' }"></view>

    <!-- 导航栏 (自定义返回按钮) -->
    <view class="nav-bar">
      <view class="nav-back" @click="goBack">
        <uni-icons type="arrow-left" color="#333" size="20"></uni-icons>
      </view>
      <text class="nav-title">搜索</text>
      <view class="nav-right"></view> <!-- 占位 -->
    </view>

    <!-- 主内容区域 -->
    <view class="content">
      <view class="header-section">
        <text class="title">MSDS文件管理</text>
        <text class="subtitle">查询危险化学品安全数据表</text>
      </view>

      <view class="search-container">
        <input 
          v-model="keyword" 
          type="text" 
          class="search-box" 
          placeholder="输入化学品名称、CAS号或关键词..." 
          confirm-type="search"
          @confirm="onSearch"
        />
        <button class="search-button" @click="onSearch">搜索</button>
      </view>

      <view class="recent-searches">
        <!-- 搜索历史 -->
        <view class="history-section" v-if="recentList.length > 0">
          <view class="recent-header">
            <text class="section-title">最近搜索</text>
            <uni-icons type="trash" color="#909399" size="18" @click="clearHistory('search')"></uni-icons>
          </view>
          
          <view class="recent-list">
            <view 
              class="recent-item" 
              v-for="(item, index) in recentList" 
              :key="index" 
              @click="clickHistory(item)"
            >
              <uni-icons type="search" color="#909399" size="16" class="item-icon"></uni-icons>
              <text class="item-text">{{ item }}</text>
            </view>
          </view>
        </view>

        <!-- 扫码历史 -->
        <view class="history-section" v-if="scanHistory.length > 0" style="margin-top: 30px;">
          <view class="recent-header">
            <text class="section-title">最近扫码</text>
            <uni-icons type="trash" color="#909399" size="18" @click="clearHistory('scan')"></uni-icons>
          </view>
          
          <view class="recent-list">
            <view 
              class="recent-item scan-item" 
              v-for="(item, index) in scanHistory" 
              :key="index" 
              @click="clickScanHistory(item)"
            >
              <view class="scan-icon">
                <uni-icons type="scan" color="#1aad19" size="20"></uni-icons>
              </view>
              <view class="scan-info">
                <text class="scan-name">{{ item.name }}</text>
                <text class="scan-cas" v-if="item.cas">CAS: {{ item.cas }}</text>
                <text class="scan-time">{{ formatTime(item.updateTime || item.createTime) }}</text>
              </view>
              <uni-icons type="arrowright" color="#ccc" size="16"></uni-icons>
            </view>
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
      keyword: '',
      recentList: [],
      scanHistory: [],
      statusBarHeight: 20
    };
  },
  onShow() {
    const systemInfo = uni.getSystemInfoSync();
    this.statusBarHeight = systemInfo.statusBarHeight || 20;

    // 加载搜索历史
    const history = uni.getStorageSync('search_history');
    if (history) {
      try {
        this.recentList = JSON.parse(history);
      } catch (e) {
        this.recentList = [];
      }
    }

    // 加载扫码历史
    const scanHist = uni.getStorageSync('scan_history');
    if (scanHist) {
      // scan_history is array of objects
      this.scanHistory = scanHist;
    }
  },
  methods: {
    goBack() {
      uni.navigateBack();
    },
    formatTime(timeStr) {
      if (!timeStr) return '';
      // Simple formatter or just return string if already formatted
      return timeStr;
    },
    onSearch() {
      if (!this.keyword.trim()) {
        uni.showToast({
          title: '请输入搜索内容',
          icon: 'none'
        });
        return;
      }
      
      // 保存历史记录
      this.saveHistory(this.keyword);
      
      // 跳转到结果页
      uni.navigateTo({
        url: `/pages/search/results?keyword=${encodeURIComponent(this.keyword)}`
      });
    },
    clickHistory(item) {
      this.keyword = item;
      this.onSearch();
    },
    clickScanHistory(item) {
      if (item.id) {
        uni.navigateTo({
            url: `/pages/detail/index?id=${item.id}`
        });
      } else {
        // Fallback if no ID (shouldn't happen with new logic)
        this.keyword = item.name || item.cas;
        this.onSearch();
      }
    },
    saveHistory(keyword) {
      let history = this.recentList || [];
      // 移除重复
      const index = history.indexOf(keyword);
      if (index > -1) {
        history.splice(index, 1);
      }
      // 添加到头部
      history.unshift(keyword);
      // 限制数量
      if (history.length > 10) {
        history = history.slice(0, 10);
      }
      this.recentList = history;
      uni.setStorageSync('search_history', JSON.stringify(history));
    },
    clearHistory(type) {
      uni.showModal({
        title: '提示',
        content: `确定清空${type === 'scan' ? '扫码' : '搜索'}历史吗？`,
        success: (res) => {
          if (res.confirm) {
            if (type === 'scan') {
                this.scanHistory = [];
                uni.removeStorageSync('scan_history');
            } else {
                this.recentList = [];
                uni.removeStorageSync('search_history');
            }
          }
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
  overflow: hidden;
  background-color: #f5f5f7;
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
  animation: subtle-move 30s infinite alternate ease-in-out;
}

@keyframes subtle-move {
  0% { transform: scale(1.0); }
  100% { transform: scale(1.05); }
}

.status-bar {
  width: 100%;
  background: rgba(255,255,255,0.5);
  backdrop-filter: blur(10px);
  position: sticky;
  top: 0;
  z-index: 100;
}

.nav-bar {
  height: 44px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 16px;
  background: rgba(255,255,255,0.5);
  backdrop-filter: blur(10px);
  position: sticky;
  top: var(--status-bar-height);
  z-index: 100;
  
  .nav-title {
    font-size: 17px;
    font-weight: 600;
    color: #000;
  }
  .nav-back, .nav-right {
    width: 40px;
    display: flex;
    align-items: center;
  }
}

.content {
  position: relative;
  z-index: 1;
  padding: 20px;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.header-section {
  text-align: center;
  margin-bottom: 30px;
  margin-top: 20px;
  
  .title {
    display: block;
    font-size: 28px;
    font-weight: bold;
    color: #333;
    margin-bottom: 8px;
  }
  
  .subtitle {
    font-size: 14px;
    color: #666;
  }
}

.search-container {
  width: 100%;
  margin-bottom: 30px;
  max-width: 500px;
}

.search-box {
  background-color: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(10px);
  border-radius: 12px;
  padding: 12px 16px;
  width: 100%;
  height: 50px;
  font-size: 16px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  margin-bottom: 20px;
  box-sizing: border-box;
  border: 1px solid rgba(255, 255, 255, 0.2);
  transition: all 0.3s;
  
  &:focus {
    background-color: rgba(255, 255, 255, 0.95);
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  }
}

.search-button {
  background: linear-gradient(135deg, #007AFF 0%, #5856D6 50%, #AF52DE 100%);
  color: white;
  border: none;
  border-radius: 12px;
  height: 50px;
  line-height: 50px;
  font-size: 16px;
  font-weight: 600;
  width: 100%;
  box-shadow: 0 6px 20px rgba(0, 122, 255, 0.35);
  
  &:active {
    transform: scale(0.98);
    opacity: 0.9;
  }
}

.recent-searches {
  width: 100%;
  max-width: 500px;
}

.recent-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  padding: 0 5px;
  
  .section-title {
    font-size: 16px;
    font-weight: 600;
    color: #606266;
  }
}

.recent-list {
  .recent-item {
    display: flex;
    align-items: center;
    padding: 15px 20px;
    background: rgba(255, 255, 255, 0.7);
    backdrop-filter: blur(5px);
    border-radius: 10px;
    margin-bottom: 12px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
    transition: all 0.3s;
    border: 1px solid rgba(255, 255, 255, 0.4);
    
    &:active {
      background: rgba(255, 255, 255, 0.9);
      transform: scale(0.98);
    }
    
    .item-icon {
      margin-right: 12px;
    }
    
    .item-text {
      font-size: 14px;
      color: #333;
    }
  }
  
  .scan-item {
    justify-content: space-between;
    
    .scan-icon {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      background: rgba(26, 173, 25, 0.1);
      display: flex;
      align-items: center;
      justify-content: center;
      margin-right: 12px;
    }
    
    .scan-info {
      flex: 1;
      display: flex;
      flex-direction: column;
    }
    
    .scan-name {
      font-size: 15px;
      font-weight: 600;
      color: #333;
      margin-bottom: 4px;
    }
    
    .scan-cas {
      font-size: 12px;
      color: #666;
    }
    
    .scan-time {
      font-size: 10px;
      color: #999;
      margin-top: 2px;
    }
  }
}
</style>
