<template>
  <view class="page-container">
    <!-- 背景图片/效果 -->
    <view class="glass-bg"></view>

    <!-- 自定义导航栏 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-content">
        <view class="back-btn" @click="onBack">
          <u-icon name="arrow-left" color="#007AFF" size="20"></u-icon>
          <text class="back-text">返回</text>
        </view>
        <view class="search-box">
          <u-icon name="search" color="#909399" size="16"></u-icon>
          <input 
            v-model="keyword" 
            type="text" 
            class="search-input" 
            placeholder="搜索化学品..." 
            confirm-type="search"
            @confirm="onSearch"
          />
          <u-icon v-if="keyword" name="close-circle-fill" color="#909399" size="16" @click="clearKeyword"></u-icon>
        </view>
      </view>
    </view>

    <!-- 占位符，防止内容被导航栏遮挡 -->
    <view :style="{ height: (44 + statusBarHeight) + 'px' }"></view>

    <!-- 主内容区域 -->
    <view class="content">
      <view class="result-count">
        <text class="count-text">找到 <text class="count-number">{{ resultList.length }}</text> 条结果</text>
      </view>

      <view 
        class="result-item" 
        v-for="(item, index) in resultList" 
        :key="index"
        @click="onItemClick(item)"
      >
        <view class="result-title">{{ item.name }}</view>
        <view class="result-subtitle">CAS号: {{ item.cas }}</view>
        
        <view class="tags-container">
          <view 
            class="result-tag" 
            v-for="(tag, tagIndex) in item.tags" 
            :key="tagIndex"
          >
            {{ tag }}
          </view>
        </view>
        
        <view class="danger-level">
          <view class="danger-dot" :class="item.dangerLevel"></view>
          <text class="danger-text">{{ getDangerText(item.dangerLevel) }}</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      statusBarHeight: 20, // 默认值，会在onLoad中更新
      keyword: '',
      resultList: [
        {
          id: 1,
          name: '甲醇 (Methanol)',
          cas: '67-56-1',
          tags: ['易燃液体', '毒性物质'],
          dangerLevel: 'high'
        },
        {
          id: 2,
          name: '甲醇溶液 (Methanol Solution)',
          cas: '67-56-1 (混合物)',
          tags: ['易燃液体'],
          dangerLevel: 'medium'
        },
        {
          id: 3,
          name: '甲醇钠 (Sodium Methoxide)',
          cas: '124-41-4',
          tags: ['易燃固体', '腐蚀性'],
          dangerLevel: 'high'
        },
        {
          id: 4,
          name: '甲醇钾 (Potassium Methoxide)',
          cas: '865-33-8',
          tags: ['易燃固体', '腐蚀性'],
          dangerLevel: 'high'
        },
        {
          id: 5,
          name: '甲醇锂 (Lithium Methoxide)',
          cas: '865-34-9',
          tags: ['易燃固体'],
          dangerLevel: 'medium'
        }
      ]
    };
  },
  onLoad(options) {
    // 获取系统状态栏高度
    const systemInfo = uni.getSystemInfoSync();
    this.statusBarHeight = systemInfo.statusBarHeight || 20;

    if (options.keyword) {
      this.keyword = decodeURIComponent(options.keyword);
    }
  },
  methods: {
    onBack() {
      uni.navigateBack();
    },
    onSearch() {
      // 这里应该调用API重新搜索
      console.log('Searching for:', this.keyword);
      uni.showToast({
        title: '搜索中...',
        icon: 'loading'
      });
    },
    clearKeyword() {
      this.keyword = '';
    },
    onItemClick(item) {
      // 跳转到详情页
      uni.navigateTo({
        url: `/pages/detail/index?id=${item.id}&name=${encodeURIComponent(item.name)}&cas=${item.cas}`
      });
    },
    getDangerText(level) {
      const map = {
        high: '高危险性',
        medium: '中等危险性',
        low: '低危险性'
      };
      return map[level] || '未知';
    }
  }
};
</script>

<style lang="scss" scoped>
.page-container {
  min-height: 100vh;
  background-color: #f5f5f7;
  position: relative;
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
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  background-color: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  z-index: 100;
  border-bottom: 1px solid rgba(0, 0, 0, 0.1);
  
  .nav-content {
    height: 44px;
    display: flex;
    align-items: center;
    padding: 0 16px;
  }
}

.back-btn {
  display: flex;
  align-items: center;
  margin-right: 10px;
  
  .back-text {
    font-size: 16px;
    color: #007AFF;
    margin-left: 4px;
  }
}

.search-box {
  flex: 1;
  background-color: rgba(142, 142, 147, 0.12);
  border-radius: 10px;
  padding: 6px 12px;
  height: 36px;
  display: flex;
  align-items: center;
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
  
  &:active {
     background-color: rgba(142, 142, 147, 0.18);
  }

  .search-input {
    flex: 1;
    background: transparent;
    border: none;
    margin-left: 8px;
    margin-right: 8px;
    font-size: 16px;
    height: 100%;
  }
}

.content {
  position: relative;
  z-index: 1;
  padding: 16px;
  padding-bottom: 40px;
}

.result-count {
  margin-bottom: 16px;
  
  .count-text {
    font-size: 14px;
    color: #606266;
    
    .count-number {
      font-weight: 600;
      color: #1d1d1f;
      margin: 0 4px;
    }
  }
}

.result-item {
  background-color: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(5px);
  -webkit-backdrop-filter: blur(5px);
  border-radius: 12px;
  padding: 16px;
  margin-bottom: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
  position: relative;
  overflow: hidden;
  
  &:active {
    transform: scale(0.98);
    background-color: rgba(240, 240, 245, 0.9);
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  }
  
  .result-title {
    font-size: 18px;
    font-weight: 600;
    color: #1d1d1f;
    margin-bottom: 4px;
  }
  
  .result-subtitle {
    font-size: 14px;
    color: #6e6e73;
    margin-bottom: 8px;
  }
  
  .tags-container {
    display: flex;
    flex-wrap: wrap;
    margin-bottom: 8px;
    
    .result-tag {
      background-color: rgba(0, 122, 255, 0.1);
      color: #007AFF;
      padding: 4px 8px;
      border-radius: 4px;
      font-size: 12px;
      font-weight: 500;
      margin-right: 8px;
      margin-bottom: 4px;
    }
  }
  
  .danger-level {
    display: flex;
    align-items: center;
    margin-top: 8px;
    
    .danger-dot {
      width: 10px;
      height: 10px;
      border-radius: 50%;
      margin-right: 6px;
      
      &.high { background-color: #FF3B30; }
      &.medium { background-color: #FF9500; }
      &.low { background-color: #34C759; }
    }
    
    .danger-text {
      font-size: 12px;
      color: #86868b;
    }
  }
}
</style>
