<template>
  <view class="page-container">
    <!-- 全局背景 -->
    <view class="glass-bg"></view>
    
    <!-- 自定义导航栏 -->
    <view class="custom-navbar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="navbar-content">
        <view class="nav-left" @click="handleBack">
          <uni-icons type="arrow-left" size="20" color="#333"></uni-icons>
        </view>
        <view class="nav-title with-back">查阅历史</view>
        <view class="nav-right">
          <view class="action-icon" @click="toggleEditMode">
            <uni-icons :type="isEditMode ? 'checkbox-filled' : 'compose'" size="20" color="#333"></uni-icons>
          </view>
        </view>
      </view>
    </view>

    <!-- 占位符 -->
    <view :style="{ height: (statusBarHeight + 44) + 'px' }"></view>

    <view class="content-area">
      <!-- 搜索区域 -->
      <view class="search-section">
        <view class="search-box glass-card-sm" :class="{ focused: isSearchFocused }">
          <uni-icons type="search" size="18" color="#999"></uni-icons>
          <input 
            class="search-input" 
            type="text" 
            placeholder="搜索历史记录" 
            v-model="searchKeyword"
            @focus="isSearchFocused = true"
            @blur="isSearchFocused = false"
            confirm-type="search"
            @confirm="handleSearch"
          />
          <uni-icons v-if="searchKeyword" type="clear" size="18" color="#999" @click="searchKeyword = ''"></uni-icons>
        </view>
      </view>

      <!-- 统计信息 -->
      <view class="stats-section">
        <view class="glass-card stats-grid">
          <view class="stat-item">
            <view class="stat-number">{{ stats.total }}</view>
            <view class="stat-label">总浏览</view>
          </view>
          <view class="stat-divider"></view>
          <view class="stat-item">
            <view class="stat-number">{{ stats.today }}</view>
            <view class="stat-label">今日</view>
          </view>
          <view class="stat-divider"></view>
          <view class="stat-item">
            <view class="stat-number">{{ stats.favorites }}</view>
            <view class="stat-label">收藏</view>
          </view>
          <view class="stat-divider"></view>
          <view class="stat-item">
             <view class="stat-number">{{ stats.days }}</view>
             <view class="stat-label">天数</view>
          </view>
        </view>
      </view>

      <!-- 分类标签 -->
      <scroll-view scroll-x class="category-tabs-scroll" show-scrollbar="false">
        <view class="category-tabs">
          <view 
            class="category-tab" 
            :class="{ active: currentTab === tab.key }"
            v-for="(tab, index) in tabs" 
            :key="index"
            @click="handleTabChange(tab.key)"
          >
            {{ tab.name }}
          </view>
        </view>
      </scroll-view>

      <!-- 历史列表 -->
      <view class="history-list">
        <view v-if="filteredHistory.length === 0" class="empty-state">
           <view class="empty-icon-bg">
             <uni-icons type="info" size="40" color="#ccc"></uni-icons>
           </view>
           <view class="empty-title">暂无浏览记录</view>
           <view class="empty-desc">您还没有浏览过任何内容，快去看看吧</view>
           <button class="empty-action-btn" @click="goBrowse">去浏览</button>
        </view>

        <view class="date-group" v-else v-for="(group, gIndex) in filteredHistory" :key="gIndex">
          <view class="date-header">
            <text class="date-title">{{ group.date }}</text>
            <view class="date-line"></view>
            <text class="date-count">{{ group.items.length }}条</text>
          </view>
          
          <view 
            class="glass-card history-card" 
            :class="{ selected: isSelected(item.id) }"
            v-for="(item, iIndex) in group.items" 
            :key="item.id"
            @click="handleItemClick(item)"
          >
            <!-- 选择框 (编辑模式下显示) -->
            <view class="select-checkbox" :class="{ checked: isSelected(item.id) }" v-if="isEditMode">
              <uni-icons v-if="isSelected(item.id)" type="checkmarkempty" size="16" color="#fff"></uni-icons>
            </view>

            <view class="card-header">
               <view class="chem-icon-placeholder">
                 <text class="chem-char">{{ (item.title || '?').charAt(0) }}</text>
               </view>
               <view class="chemical-info">
                 <view class="chemical-name">{{ item.title }}</view>
                 <view class="chemical-meta">{{ item.subtitle }}</view>
               </view>
            </view>
            
            <view class="card-body">
               <view class="chemical-tags">
                 <view 
                   class="tag" 
                   :class="'tag-' + tag.type" 
                   v-for="(tag, tIndex) in item.tags" 
                   :key="tIndex"
                 >
                   {{ tag.text }}
                 </view>
               </view>
            </view>

            <view class="card-actions">
               <view class="visit-info">
                  <uni-icons type="calendar" size="12" color="#999"></uni-icons>
                  <text>{{ item.time }}</text>
                  <text style="margin: 0 4px">·</text>
                  <uni-icons type="eye" size="12" color="#999"></uni-icons>
                  <text>浏览 {{ item.count }} 次</text>
               </view>
               
               <view class="action-icons" v-if="!isEditMode">
                  <view class="action-icon-btn" :class="{ favorited: item.isFavorite }" @click.stop="toggleFavorite(item)">
                    <uni-icons :type="item.isFavorite ? 'star-filled' : 'star'" size="18" :color="item.isFavorite ? '#ff4757' : '#999'"></uni-icons>
                  </view>
                  <view class="action-icon-btn" @click.stop="shareItem(item)">
                    <uni-icons type="redo" size="18" color="#999"></uni-icons>
                  </view>
               </view>
            </view>
          </view>
        </view>
      </view>
    </view>

    <!-- 底部工具栏 (编辑模式下显示) -->
    <view class="bottom-toolbar glass-card-top" v-if="isEditMode">
      <view class="toolbar-content">
        <view class="selected-count">已选 {{ selectedIds.length }} 项</view>
        <view class="toolbar-actions">
          <button class="toolbar-btn secondary" @click="selectAll">全选</button>
          <button class="toolbar-btn danger" @click="deleteSelected">删除</button>
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
      searchKeyword: '',
      isSearchFocused: false,
      isEditMode: false,
      currentTab: 'all',
      selectedIds: [],
      tabs: [
        { name: '全部', key: 'all' },
        { name: 'MSDS', key: 'msds' },
        { name: '课程', key: 'course' },
        { name: '考试', key: 'exam' },
        { name: '其他', key: 'other' }
      ],
      stats: {
        total: 128,
        today: 12,
        favorites: 45,
        days: 30
      },
      // 模拟数据
      historyData: [
        {
          date: '今天',
          items: [
            {
              id: 1,
              title: '乙醇 [64-17-5]',
              subtitle: 'Ethanol',
              type: 'msds',
              tags: [{ text: '易燃液体', type: 'danger' }],
              time: '14:30',
              count: 5,
              isFavorite: true
            },
            {
              id: 2,
              title: '实验室安全准入考试',
              subtitle: 'Safety Access Exam',
              type: 'exam',
              tags: [{ text: '进行中', type: 'warning' }],
              time: '10:15',
              count: 1,
              isFavorite: false
            }
          ]
        },
        {
          date: '昨天',
          items: [
            {
              id: 3,
              title: '硫酸 [7664-93-9]',
              subtitle: 'Sulfuric acid',
              type: 'msds',
              tags: [{ text: '腐蚀性', type: 'danger' }, { text: '易制毒', type: 'warning' }],
              time: '16:20',
              count: 12,
              isFavorite: true
            }
          ]
        }
      ]
    };
  },
  computed: {
    filteredHistory() {
      let data = JSON.parse(JSON.stringify(this.historyData));
      
      if (this.currentTab !== 'all') {
        data.forEach(group => {
          group.items = group.items.filter(item => item.type === this.currentTab);
        });
        data = data.filter(group => group.items.length > 0);
      }
      
      if (this.searchKeyword) {
        const k = this.searchKeyword.toLowerCase();
        data.forEach(group => {
          group.items = group.items.filter(item => 
            item.title.toLowerCase().includes(k) || 
            item.subtitle.toLowerCase().includes(k)
          );
        });
        data = data.filter(group => group.items.length > 0);
      }
      
      return data;
    }
  },
  onLoad() {
    const systemInfo = uni.getSystemInfoSync();
    this.statusBarHeight = systemInfo.statusBarHeight || 20;
  },
  methods: {
    handleBack() {
      uni.navigateBack();
    },
    toggleEditMode() {
      this.isEditMode = !this.isEditMode;
      this.selectedIds = [];
    },
    handleSearch() {
      console.log('Search:', this.searchKeyword);
    },
    handleTabChange(key) {
      this.currentTab = key;
    },
    handleItemClick(item) {
      if (this.isEditMode) {
        const index = this.selectedIds.indexOf(item.id);
        if (index > -1) {
          this.selectedIds.splice(index, 1);
        } else {
          this.selectedIds.push(item.id);
        }
      } else {
        // 根据类型跳转
        console.log('Navigate to:', item);
      }
    },
    isSelected(id) {
      return this.selectedIds.includes(id);
    },
    selectAll() {
      const allIds = [];
      this.filteredHistory.forEach(group => {
        group.items.forEach(item => {
          allIds.push(item.id);
        });
      });
      
      if (this.selectedIds.length === allIds.length) {
        this.selectedIds = [];
      } else {
        this.selectedIds = allIds;
      }
    },
    deleteSelected() {
      if (this.selectedIds.length === 0) return;
      
      uni.showModal({
        title: '提示',
        content: `确定要删除选中的 ${this.selectedIds.length} 条记录吗？`,
        success: (res) => {
          if (res.confirm) {
            // Mock delete
            this.selectedIds = [];
            this.isEditMode = false;
            uni.showToast({ title: '已删除', icon: 'success' });
          }
        }
      });
    },
    goBrowse() {
      uni.switchTab({ url: '/pages/index' });
    },
    toggleFavorite(item) {
      item.isFavorite = !item.isFavorite;
      uni.showToast({
        title: item.isFavorite ? '已收藏' : '取消收藏',
        icon: 'none'
      });
    },
    shareItem(item) {
      uni.showToast({ title: '分享功能开发中', icon: 'none' });
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

/* 毛玻璃背景 - 与系统一致 */
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

/* 自定义导航栏 - 与系统一致 */
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
    justify-content: space-between;
    padding: 0 16px;
  }
  
  .nav-title {
    font-size: 17px;
    font-weight: 600;
    color: #000000;
    
    &.with-back {
      margin-left: -40px;
    }
  }
  
  .nav-left, .nav-right {
    display: flex;
    align-items: center;
    min-width: 60px;
  }

  .nav-right {
    justify-content: flex-end;
  }
}

.content-area {
  position: relative;
  z-index: 1;
  padding: 0 16px 80px;
}

/* 通用毛玻璃卡片 */
.glass-card {
  background: rgba(255, 255, 255, 0.75);
  backdrop-filter: blur(15px);
  -webkit-backdrop-filter: blur(15px);
  border-radius: 16px;
  border: 1px solid rgba(255, 255, 255, 0.6);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.03);
  margin-bottom: 12px;
}

.glass-card-sm {
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border-radius: 25px;
  border: 1px solid rgba(255, 255, 255, 0.4);
}

.glass-card-top {
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-top: 1px solid rgba(255, 255, 255, 0.5);
  box-shadow: 0 -4px 20px rgba(0, 0, 0, 0.05);
}

/* 搜索区域 */
.search-section {
  padding: 16px 0;
}

.search-box {
  padding: 0 16px;
  height: 40px;
  display: flex;
  align-items: center;
  transition: all 0.3s;
  
  &.focused {
    background: white;
    box-shadow: 0 4px 12px rgba(0, 122, 255, 0.1);
    border-color: rgba(0, 122, 255, 0.3);
  }
  
  .search-input {
    flex: 1;
    margin: 0 10px;
    font-size: 14px;
    height: 100%;
  }
}

/* 统计区域 */
.stats-section {
  margin-bottom: 16px;
}

.stats-grid {
  display: flex;
  justify-content: space-around;
  align-items: center;
  padding: 16px 0;
}

.stat-item {
  flex: 1;
  text-align: center;
  
  .stat-number {
    font-size: 20px;
    font-weight: 700;
    color: #007aff;
    margin-bottom: 4px;
  }
  
  .stat-label {
    font-size: 12px;
    color: #666;
  }
}

.stat-divider {
  width: 1px;
  height: 24px;
  background: rgba(0,0,0,0.05);
}

/* 分类标签 */
.category-tabs-scroll {
  width: 100%;
  white-space: nowrap;
  margin-bottom: 16px;
}

.category-tabs {
  display: inline-flex;
  padding: 0 4px;
}

.category-tab {
  display: inline-block;
  padding: 6px 16px;
  margin-right: 10px;
  background: rgba(255, 255, 255, 0.4);
  border-radius: 20px;
  font-size: 14px;
  color: #666;
  border: 1px solid rgba(255, 255, 255, 0.2);
  transition: all 0.3s;
  
  &.active {
    background: #007aff;
    color: #fff;
    box-shadow: 0 4px 10px rgba(0, 122, 255, 0.2);
    border-color: transparent;
  }
}

/* 历史列表 */
.date-group {
  margin-bottom: 20px;
}

.date-header {
  display: flex;
  align-items: center;
  margin-bottom: 12px;
  padding: 0 4px;
  
  .date-title {
    font-size: 16px;
    font-weight: 600;
    color: #333;
  }
  
  .date-line {
    flex: 1;
    height: 1px;
    background: rgba(0,0,0,0.05);
    margin: 0 12px;
  }
  
  .date-count {
    font-size: 12px;
    color: #999;
  }
}

.history-card {
  padding: 16px;
  position: relative;
  transition: all 0.3s;
  
  &.selected {
    border-color: #007aff;
    background: rgba(0, 122, 255, 0.03);
  }
  
  &:active {
    transform: scale(0.98);
  }
}

.select-checkbox {
  position: absolute;
  top: 16px;
  right: 16px;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  border: 2px solid #ddd;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2;
  
  &.checked {
    background: #007aff;
    border-color: #007aff;
  }
}

.card-header {
  display: flex;
  margin-bottom: 12px;
  
  .chem-icon-placeholder {
    width: 40px;
    height: 40px;
    border-radius: 10px;
    background: linear-gradient(135deg, #f0f0f0 0%, #e6e6e6 100%);
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 12px;
    font-weight: 600;
    color: #666;
    font-size: 18px;
  }
  
  .chemical-info {
    flex: 1;
    
    .chemical-name {
      font-size: 16px;
      font-weight: 600;
      color: #333;
      margin-bottom: 4px;
    }
    
    .chemical-meta {
      font-size: 12px;
      color: #999;
    }
  }
}

.card-body {
  margin-bottom: 12px;
  padding-left: 52px; // Align with text
  
  .chemical-tags {
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
  }
  
  .tag {
    font-size: 10px;
    padding: 2px 8px;
    border-radius: 4px;
    
    &.tag-danger {
      background: rgba(255, 59, 48, 0.1);
      color: #ff3b30;
    }
    
    &.tag-warning {
      background: rgba(255, 149, 0, 0.1);
      color: #ff9500;
    }
    
    &.tag-info {
      background: rgba(142, 142, 147, 0.1);
      color: #8e8e93;
    }
  }
}

.card-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 12px;
  border-top: 1px solid rgba(0,0,0,0.03);
  
  .visit-info {
    display: flex;
    align-items: center;
    font-size: 12px;
    color: #999;
    
    uni-icons {
      margin-right: 4px;
    }
  }
  
  .action-icons {
    display: flex;
    gap: 16px;
  }
  
  .action-icon-btn {
    padding: 4px;
    
    &.favorited {
      uni-icons {
        color: #ff4757 !important;
      }
    }
  }
}

/* 底部工具栏 */
.bottom-toolbar {
  position: fixed;
  bottom: 0;
  left: 0;
  width: 100%;
  z-index: 100;
  padding-bottom: constant(safe-area-inset-bottom);
  padding-bottom: env(safe-area-inset-bottom);
  
  .toolbar-content {
    height: 60px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 16px;
  }
  
  .selected-count {
    font-size: 14px;
    color: #333;
    font-weight: 500;
  }
  
  .toolbar-actions {
    display: flex;
    gap: 12px;
    
    .toolbar-btn {
      margin: 0;
      font-size: 14px;
      padding: 0 20px;
      height: 36px;
      line-height: 36px;
      border-radius: 18px;
      
      &.secondary {
        background: #f5f5f7;
        color: #333;
      }
      
      &.danger {
        background: #ff3b30;
        color: #fff;
      }
      
      &::after {
        border: none;
      }
    }
  }
}

/* 空状态 */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 0;
  
  .empty-icon-bg {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 16px;
  }
  
  .empty-title {
    font-size: 16px;
    font-weight: 600;
    color: #333;
    margin-bottom: 8px;
  }
  
  .empty-desc {
    font-size: 14px;
    color: #999;
    margin-bottom: 24px;
  }
  
  .empty-action-btn {
    background: #007aff;
    color: #fff;
    font-size: 14px;
    padding: 8px 32px;
    border-radius: 20px;
    line-height: 1.5;
    
    &::after {
      border: none;
    }
  }
}
</style>