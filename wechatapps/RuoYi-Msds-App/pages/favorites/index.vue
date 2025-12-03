<template>
  <view class="favorites-container">
    <!-- 毛玻璃背景 -->
    <view class="glass-bg"></view>

    <!-- 自定义状态栏 -->
    <view class="status-bar" :style="{ height: statusBarHeight + 'px' }"></view>

    <!-- 自定义导航栏 -->
    <view class="nav-bar" :style="{ top: statusBarHeight + 'px' }">
      <text class="nav-title">收藏</text>
      <view class="nav-action" @click="handleAction">
        <uni-icons type="more-filled" size="24" color="#007AFF"></uni-icons>
      </view>
    </view>

    <!-- 主内容区域 -->
    <scroll-view scroll-y class="content" :style="{ marginTop: (statusBarHeight + 44) + 'px', height: 'calc(100vh - ' + (statusBarHeight + 44) + 'px)' }">
      <!-- 空状态 -->
      <view v-if="favorites.length === 0" class="empty-state">
        <uni-icons type="star" size="60" color="#8E8E93"></uni-icons>
        <text class="empty-title">暂无收藏</text>
        <text class="empty-desc">您可以在浏览MSDS文档时点击星标添加收藏</text>
        <button class="start-btn" @click="goHome">开始浏览</button>
      </view>

      <!-- 收藏列表 -->
      <view v-else class="favorites-list">
        <view v-for="(group, index) in favorites" :key="index">
          <view class="group-title">{{ group.title }}</view>
          <view 
            class="favorite-item" 
            v-for="(item, idx) in group.items" 
            :key="idx"
            @click="goToDetail(item)"
          >
            <view class="favorite-icon">
              <uni-icons type="info-filled" size="28" color="#007AFF"></uni-icons>
            </view>
            <view class="favorite-info">
              <view class="favorite-title">{{ item.name }} ({{ item.englishName }})</view>
              <view class="favorite-subtitle">CAS号: {{ item.cas }}</view>
              <view class="favorite-meta">
                <view class="favorite-tag" v-for="(tag, tIdx) in item.tags" :key="tIdx">{{ tag }}</view>
                <text class="update-time">更新于 {{ item.updateTime }}</text>
              </view>
            </view>
            <view class="favorite-actions" @click.stop="showItemAction(item)">
              <uni-icons type="more-filled" size="20" color="#8E8E93"></uni-icons>
            </view>
          </view>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      statusBarHeight: 20,
      favorites: []
    };
  },
  onLoad() {
    const systemInfo = uni.getSystemInfoSync();
    this.statusBarHeight = systemInfo.statusBarHeight;
  },
  onShow() {
    this.loadFavorites();
  },
  methods: {
    loadFavorites() {
      const list = uni.getStorageSync('MSDS_FAVORITES') || [];
      if (list.length > 0) {
        this.favorites = [
          {
            title: '我的收藏',
            items: list
          }
        ];
      } else {
        this.favorites = [];
      }
    },
    handleAction() {
      uni.showToast({ title: '操作菜单', icon: 'none' });
    },
    goHome() {
      uni.switchTab({ url: '/pages/index' });
    },
    goToDetail(item) {
      uni.navigateTo({
        url: `/pages/document/detail?id=${item.id}`
      });
    },
    showItemAction(item) {
      uni.showActionSheet({
        itemList: ['取消收藏', '分享'],
        success: (res) => {
          if (res.tapIndex === 0) {
            this.removeFavorite(item);
          } else if (res.tapIndex === 1) {
             uni.showToast({ title: '分享功能开发中', icon: 'none' });
          }
        }
      });
    },
    removeFavorite(item) {
      let list = uni.getStorageSync('MSDS_FAVORITES') || [];
      list = list.filter(i => i.id !== item.id);
      uni.setStorageSync('MSDS_FAVORITES', list);
      this.loadFavorites();
      uni.showToast({ title: '已取消收藏', icon: 'none' });
    }
  }
};
</script>

<style lang="scss" scoped>
.favorites-container {
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
  pointer-events: none;
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

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  padding: 20px;
  text-align: center;
}

.empty-title {
  font-size: 20px;
  font-weight: 600;
  color: #1d1d1f;
  margin-top: 16px;
  margin-bottom: 8px;
}

.empty-desc {
  font-size: 14px;
  color: #86868b;
}

.start-btn {
  margin-top: 24px;
  background-color: #007AFF;
  color: #ffffff;
  padding: 0 24px;
  height: 40px;
  line-height: 40px;
  border-radius: 20px;
  font-size: 16px;
  font-weight: 600;
}

.group-title {
  font-size: 18px;
  font-weight: 600;
  color: #1d1d1f;
  margin: 20px 0 12px;
  position: relative;
  display: inline-block;
}

.favorite-item {
  background-color: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(5px);
  border-radius: 12px;
  padding: 16px;
  margin-bottom: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  display: flex;
  align-items: center;
  transition: all 0.3s;
}

.favorite-item:active {
  transform: scale(0.98);
  background-color: rgba(240, 240, 245, 0.9);
}

.favorite-icon {
  width: 40px;
  height: 40px;
  background-color: rgba(0, 122, 255, 0.1);
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 12px;
}

.favorite-info {
  flex: 1;
}

.favorite-title {
  font-weight: 600;
  font-size: 16px;
  color: #1d1d1f;
  margin-bottom: 2px;
}

.favorite-subtitle {
  font-size: 14px;
  color: #6e6e73;
}

.favorite-meta {
  display: flex;
  align-items: center;
  margin-top: 4px;
}

.favorite-tag {
  background-color: rgba(0, 122, 255, 0.1);
  color: #007AFF;
  padding: 2px 6px;
  border-radius: 4px;
  font-size: 10px;
  font-weight: 500;
  margin-right: 6px;
}

.update-time {
  font-size: 10px;
  color: #86868b;
}

.favorite-actions {
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>
