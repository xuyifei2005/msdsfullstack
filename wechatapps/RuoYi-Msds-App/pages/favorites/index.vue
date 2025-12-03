<template>
  <view class="page-container">
    <!-- 全局背景 -->
    <view class="glass-bg"></view>
    
    <!-- 自定义导航栏 -->
    <view class="custom-navbar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="navbar-content">
        <view class="nav-left" @click="goBack" v-if="showBack">
          <uni-icons type="arrow-left" size="20" color="#333"></uni-icons>
        </view>
        <view class="nav-title" :class="{'with-back': showBack}">我的收藏</view>
        <view class="nav-right">
          <view class="sort-btn" @click="toggleSortMenu">
            <text>{{ currentSortLabel }}</text>
            <uni-icons type="bottom" size="12" color="#333"></uni-icons>
          </view>
          <view class="action-icon" @click="toggleEditMode">
            <uni-icons :type="isEditMode ? 'checkbox-filled' : 'compose'" size="20" color="#333"></uni-icons>
          </view>
          
          <!-- 排序菜单 -->
          <view class="sort-menu" v-if="showSortMenu">
            <view class="sort-option" :class="{ active: sortBy === 'time' }" @click="selectSort('time')">时间排序</view>
            <view class="sort-option" :class="{ active: sortBy === 'name' }" @click="selectSort('name')">名称排序</view>
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
            type="text" 
            v-model="searchKeyword" 
            placeholder="搜索收藏的化学品..." 
            class="search-input"
            @focus="onSearchFocus"
            @blur="onSearchBlur"
          />
          <view v-if="searchKeyword" @click="clearSearch" class="clear-icon">
            <uni-icons type="clear" size="18" color="#999"></uni-icons>
          </view>
        </view>
      </view>

      <!-- 统计信息 -->
      <view class="stats-section">
        <view class="glass-card stats-grid">
          <view class="stat-item">
            <view class="stat-number">{{ favorites.length }}</view>
            <view class="stat-label">总收藏</view>
          </view>
          <view class="stat-divider"></view>
          <view class="stat-item">
            <view class="stat-number">{{ newThisWeekCount }}</view>
            <view class="stat-label">本周新增</view>
          </view>
          <view class="stat-divider"></view>
          <view class="stat-item">
            <view class="stat-number">{{ categoryCount }}</view>
            <view class="stat-label">分类数</view>
          </view>
        </view>
      </view>

      <!-- 分类标签 -->
      <scroll-view scroll-x class="category-tabs-scroll" show-scrollbar="false">
        <view class="category-tabs">
          <view 
            class="category-tab" 
            :class="{ active: currentCategory === 'all' }" 
            @click="setCategory('all')"
          >全部</view>
          <view 
            class="category-tab" 
            v-for="(cat, index) in categories" 
            :key="index"
            :class="{ active: currentCategory === cat.key }"
            @click="setCategory(cat.key)"
          >{{ cat.label }}</view>
        </view>
      </scroll-view>

      <!-- 收藏列表 -->
      <view class="favorites-list">
        <view v-if="!filteredFavorites || filteredFavorites.length === 0" class="empty-state">
          <view class="empty-icon-bg">
            <uni-icons type="star" size="40" color="#ccc"></uni-icons>
          </view>
          <view class="empty-title">暂无收藏</view>
          <view class="empty-desc">您可以在浏览MSDS文档时点击星标添加收藏</view>
          <button class="empty-action-btn" @click="goHome">开始浏览</button>
        </view>
        
        <view v-else class="list-container">
          <view 
            class="glass-card favorite-card" 
            v-for="(item, index) in filteredFavorites" 
            :key="item.id"
            :class="{ selected: isSelected(item.id) }"
            @click="onItemClick(item)"
          >
            <!-- 选择框 (编辑模式下显示) -->
            <view class="select-checkbox" :class="{ checked: isSelected(item.id) }" v-if="isEditMode">
              <uni-icons v-if="isSelected(item.id)" type="checkmarkempty" size="16" color="#fff"></uni-icons>
            </view>
  
            <view class="card-header">
              <view class="chem-icon-placeholder">
                 <text class="chem-char">{{ (item.name || '?').charAt(0) }}</text>
              </view>
              <view class="chemical-info">
                <view class="chemical-name">{{ item.name }}</view>
                <view class="chemical-meta">{{ item.englishName || '-' }}</view>
                <view class="chemical-meta" v-if="item.cas">CAS: {{ item.cas }}</view>
              </view>
            </view>
            
            <view class="card-body">
               <view class="chemical-tags" v-if="item.tagObjects && item.tagObjects.length > 0">
                 <view class="tag" :class="tagObj.class" v-for="(tagObj, tIdx) in item.tagObjects" :key="tIdx">{{ tagObj.text }}</view>
               </view>
            </view>
            
            <view class="card-actions">
              <view class="favorite-time">收藏于 {{ formatTime(item.addTime) }}</view>
              <view class="action-icons" v-if="!isEditMode">
                 <view class="action-icon-btn" @click.stop="shareItem(item)">
                   <uni-icons type="redo" size="18" color="#999"></uni-icons>
                 </view>
                 <view class="action-icon-btn favorited" @click.stop="removeItem(item)">
                   <uni-icons type="star-filled" size="18" color="#ff4757"></uni-icons>
                 </view>
              </view>
            </view>
          </view>
        </view>
      </view>
    </view>

    <!-- 底部操作栏 (编辑模式下显示) -->
    <view class="bottom-toolbar glass-card-top" v-if="isEditMode">
      <view class="toolbar-content">
        <view class="selected-count">已选 {{ selectedIds.length }} 项</view>
        <view class="toolbar-actions">
          <button class="toolbar-btn secondary" @click="cancelEditMode">取消</button>
          <button class="toolbar-btn danger" @click="batchDelete">删除</button>
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
      showBack: false, // If navigated from somewhere else
      favorites: [],
      searchKeyword: '',
      currentCategory: 'all',
      sortBy: 'time', // time, name
      showSortMenu: false,
      isEditMode: false,
      isSearchFocused: false,
      selectedIds: [],
      categories: [
        { key: 'explosive', label: '易制爆' },
        { key: 'precursor_chem', label: '易制毒' },
        { key: 'toxic', label: '剧毒品' },
        { key: 'dangerous', label: '危险品' },
        { key: 'organic', label: '有机物' },
        { key: 'inorganic', label: '无机物' },
        { key: 'common', label: '常用' }
      ]
    };
  },
  computed: {
    currentSortLabel() {
      return this.sortBy === 'time' ? '时间' : '名称';
    },
    filteredFavorites() {
      if (!this.favorites) return [];
      let list = [...this.favorites];
      
      // Search
      if (this.searchKeyword) {
        const k = this.searchKeyword.toLowerCase();
        list = list.filter(item => 
          (item.name && item.name.toLowerCase().includes(k)) || 
          (item.englishName && item.englishName.toLowerCase().includes(k)) ||
          (item.cas && item.cas.includes(k))
        );
      }
      
      // Filter Category
      if (this.currentCategory !== 'all') {
        list = list.filter(item => this.checkCategoryMatch(item, this.currentCategory));
      }
      
      // Sort
      list.sort((a, b) => {
        if (this.sortBy === 'time') {
          return (b.addTime || 0) - (a.addTime || 0);
        } else {
          return (a.name || '').localeCompare(b.name || '');
        }
      });
      
      return list;
    },
    newThisWeekCount() {
      if (!this.favorites) return 0;
      const now = Date.now();
      const oneWeek = 7 * 24 * 60 * 60 * 1000;
      return this.favorites.filter(item => (now - (item.addTime || 0)) < oneWeek).length;
    },
    categoryCount() {
      if (!this.favorites || this.favorites.length === 0) return 0;
      return this.categories.filter(cat => 
        this.favorites.some(item => this.checkCategoryMatch(item, cat.key))
      ).length;
    }
  },
  onLoad() {
    const systemInfo = uni.getSystemInfoSync();
    this.statusBarHeight = systemInfo.statusBarHeight || 20;
    const pages = getCurrentPages();
    if (pages.length > 1) {
        this.showBack = true;
    }
  },
  onShow() {
    this.loadFavorites();
    this.isEditMode = false;
    this.selectedIds = [];
  },
  methods: {
    checkCategoryMatch(item, catKey) {
      if (!item.tags || item.tags.length === 0) return false;
      const tagsStr = item.tags.join(',');
      
      if (catKey === 'explosive') return tagsStr.includes('易制爆') || tagsStr.includes('爆');
      if (catKey === 'precursor_chem') return tagsStr.includes('易制毒') || tagsStr.includes('毒品');
      if (catKey === 'toxic') return tagsStr.includes('剧毒') || tagsStr.includes('有毒');
      if (catKey === 'dangerous') return tagsStr.includes('危险') || tagsStr.includes('燃');
      if (catKey === 'organic') return tagsStr.includes('有机');
      if (catKey === 'inorganic') return tagsStr.includes('无机');
      if (catKey === 'common') return tagsStr.includes('常用');
      return false;
    },
    loadFavorites() {
      this.favorites = uni.getStorageSync('MSDS_FAVORITES') || [];
      
      // Ensure addTime exists and auto-tag legacy items
      this.favorites = this.favorites.map((item, index) => {
          // 1. Ensure timestamp
          if (!item.addTime) item.addTime = Date.now();
          // Ensure ID exists (fix for :key error)
          if (!item.id) item.id = 'fav_' + item.addTime + '_' + index;
          
          // 2. Auto-tag if missing
          if (!item.tags || item.tags.length === 0) {
              item.tags = [];
              const name = (item.name || '').toLowerCase();
              const englishName = (item.englishName || '').toLowerCase();
              
              // Basic rules based on name keywords (since we might not have dangerLevel here)
              if (name.includes('硝酸') || name.includes('过氧化') || name.includes('氯酸')) {
                   item.tags.push('易制爆');
                   item.tags.push('危险品');
              }
              if (name.includes('硫酸') || name.includes('盐酸') || name.includes('甲苯') || name.includes('丙酮')) {
                   item.tags.push('易制毒');
              }
              if (name.includes('剧毒') || name.includes('氰') || name.includes('砷')) {
                   item.tags.push('剧毒品');
                   item.tags.push('危险品');
              }
              if (name.includes('醇') || name.includes('醚') || name.includes('苯') || name.includes('酯') || name.includes('烷')) {
                   item.tags.push('有机物');
              } else if (name.includes('钠') || name.includes('钾') || name.includes('钙') || name.includes('铁') || name.includes('酸') || name.includes('碱')) {
                   item.tags.push('无机物');
              }
              
              if (item.tags.length === 0) {
                  item.tags.push('常用');
              }
              item.tags = [...new Set(item.tags)];
          }

          // 3. Generate tag display objects (fixes :class compilation error)
          item.tagObjects = (item.tags || []).map(tag => {
              let className = 'tag-info';
              if (!tag) className = 'tag-info';
              else if (tag.indexOf('险') > -1 || tag.indexOf('毒') > -1 || tag.indexOf('爆') > -1) className = 'tag-danger';
              else if (tag.indexOf('告') > -1 || tag.indexOf('注意') > -1) className = 'tag-warning';
              
              return {
                  text: tag,
                  class: className
              };
          });
          
          return item;
      });
    },
    goBack() {
      uni.navigateBack();
    },
    goHome() {
      uni.switchTab({ url: '/pages/index' });
    },
    toggleSortMenu() {
      this.showSortMenu = !this.showSortMenu;
    },
    selectSort(type) {
      this.sortBy = type;
      this.showSortMenu = false;
    },
    toggleEditMode() {
      this.isEditMode = !this.isEditMode;
      this.selectedIds = [];
    },
    cancelEditMode() {
      this.isEditMode = false;
    },
    isSelected(id) {
      return this.selectedIds.includes(id);
    },
    onItemClick(item) {
      if (this.isEditMode) {
        const index = this.selectedIds.indexOf(item.id);
        if (index > -1) {
          this.selectedIds.splice(index, 1);
        } else {
          this.selectedIds.push(item.id);
        }
      } else {
        uni.navigateTo({
          url: `/pages/document/detail?id=${item.id}`
        });
      }
    },
    removeItem(item) {
      uni.showModal({
        title: '提示',
        content: '确定要取消收藏吗？',
        success: (res) => {
          if (res.confirm) {
            this.favorites = this.favorites.filter(i => i.id !== item.id);
            uni.setStorageSync('MSDS_FAVORITES', this.favorites);
            uni.showToast({ title: '已移除', icon: 'none' });
          }
        }
      });
    },
    batchDelete() {
        if (this.selectedIds.length === 0) return;
        uni.showModal({
            title: '提示',
            content: `确定要删除选中的 ${this.selectedIds.length} 项收藏吗？`,
            success: (res) => {
                if (res.confirm) {
                    this.favorites = this.favorites.filter(i => !this.selectedIds.includes(i.id));
                    uni.setStorageSync('MSDS_FAVORITES', this.favorites);
                    this.selectedIds = [];
                    this.isEditMode = false;
                    uni.showToast({ title: '已删除', icon: 'success' });
                }
            }
        });
    },
    shareItem(item) {
        uni.showToast({ title: '分享功能开发中', icon: 'none' });
    },
    formatTime(timestamp) {
        if (!timestamp) return '';
        const date = new Date(timestamp);
        return `${date.getFullYear()}-${String(date.getMonth()+1).padStart(2,'0')}-${String(date.getDate()).padStart(2,'0')}`;
    },
    setCategory(key) {
      this.currentCategory = key;
    },
    onSearchFocus() {
      this.isSearchFocused = true;
    },
    onSearchBlur() {
      this.isSearchFocused = false;
    },
    clearSearch() {
      this.searchKeyword = '';
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

/* 毛玻璃背景 - 与主页一致 */
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

/* 自定义导航栏 - 与主页一致 */
.custom-navbar {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%; // Note: height 100% is wrong for navbar, should be auto or specific
  height: auto;
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
    position: absolute;
    left: 50%;
    transform: translateX(-50%);
    
    &.with-back {
      // margin-left: -40px; 
    }
  }
  
  .nav-left, .nav-right {
    display: flex;
    align-items: center;
    z-index: 1; // Ensure buttons are above title
  }

  .nav-right {
    justify-content: flex-end;
    gap: 16px;
  }
}

.content-area {
  position: relative;
  z-index: 1;
  padding: 0 16px 80px; // Bottom padding for toolbar
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

.glass-card-sm {
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.4);
}

.glass-card-top {
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-top: 1px solid rgba(255, 255, 255, 0.5);
  box-shadow: 0 -4px 20px rgba(0,0,0,0.05);
}

/* 搜索框 */
.search-section {
  padding: 12px 0;
}

.search-box {
  display: flex;
  align-items: center;
  padding: 10px 12px;
  transition: all 0.3s ease;
  
  &.focused {
    background: rgba(255, 255, 255, 0.95);
    box-shadow: 0 4px 12px rgba(0,122,255,0.15);
    border-color: #007aff;
  }
  
  .search-input {
    flex: 1;
    margin-left: 8px;
    font-size: 14px;
    color: #333;
  }
  
  .clear-icon {
    padding: 4px;
  }
}

/* 统计信息 */
.stats-section {
  margin-bottom: 20px;
}

.stats-grid {
  display: flex;
  align-items: center;
  padding: 20px 0;
  
  .stat-item {
    flex: 1;
    text-align: center;
    
    .stat-number {
      font-size: 20px;
      font-weight: bold;
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
    background-color: rgba(0,0,0,0.1);
  }
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
  
  .category-tab {
    padding: 6px 16px;
    margin-right: 10px;
    border-radius: 20px;
    font-size: 13px;
    color: #666;
    background: rgba(255, 255, 255, 0.5);
    border: 1px solid rgba(255,255,255,0.2);
    transition: all 0.3s;
    
    &.active {
      background: #007aff;
      color: #fff;
      box-shadow: 0 4px 10px rgba(0, 122, 255, 0.3);
    }
  }
}

/* 列表项 */
.favorites-list {
  padding-bottom: 20px;
}

.favorite-card {
  padding: 16px;
  margin-bottom: 12px;
  position: relative;
  transition: all 0.3s;
  
  &.selected {
    background: rgba(0, 122, 255, 0.05);
    border-color: #007aff;
  }
  
  .select-checkbox {
    position: absolute;
    top: 16px;
    right: 16px;
    width: 20px;
    height: 20px;
    border-radius: 50%;
    border: 2px solid #ccc;
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 10;
    
    &.checked {
      background-color: #007aff;
      border-color: #007aff;
    }
  }
}

.card-header {
  display: flex;
  align-items: flex-start;
  margin-bottom: 12px;
  
  .chem-icon-placeholder {
    width: 40px;
    height: 40px;
    border-radius: 10px;
    background: linear-gradient(135deg, #e0c3fc 0%, #8ec5fc 100%);
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 12px;
    
    .chem-char {
      color: #fff;
      font-size: 18px;
      font-weight: bold;
    }
  }
  
  .chemical-info {
    flex: 1;
    
    .chemical-name {
      font-size: 16px;
      font-weight: bold;
      color: #333;
      margin-bottom: 4px;
    }
    
    .chemical-meta {
      font-size: 12px;
      color: #888;
      margin-bottom: 2px;
    }
  }
}

.chemical-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 12px;
  
  .tag {
    padding: 2px 8px;
    border-radius: 4px;
    font-size: 11px;
    
    &.tag-info { background: rgba(0,0,0,0.05); color: #666; }
    &.tag-danger { background: rgba(255, 59, 48, 0.1); color: #ff3b30; }
    &.tag-warning { background: rgba(255, 149, 0, 0.1); color: #ff9500; }
  }
}

.card-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 12px;
  border-top: 1px solid rgba(0,0,0,0.05);
  
  .favorite-time {
    font-size: 12px;
    color: #999;
  }
  
  .action-icons {
    display: flex;
    gap: 16px;
    
    .action-icon-btn {
      padding: 4px;
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
    padding: 12px 24px;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  
  .selected-count {
    font-size: 14px;
    color: #333;
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
    background: rgba(255,255,255,0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 16px;
  }
  
  .empty-title {
    font-size: 16px;
    font-weight: bold;
    color: #333;
    margin-bottom: 8px;
  }
  
  .empty-desc {
    font-size: 13px;
    color: #999;
    margin-bottom: 24px;
  }
  
  .empty-action-btn {
    background: #007aff;
    color: #fff;
    font-size: 14px;
    padding: 0 32px;
    height: 40px;
    line-height: 40px;
    border-radius: 20px;
  }
}

/* 排序菜单 */
.sort-btn {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 6px 12px;
  background: rgba(255,255,255,0.5);
  border-radius: 14px;
  font-size: 13px;
  color: #333;
}

.sort-menu {
  position: absolute;
  top: 44px;
  right: 0;
  background: rgba(255,255,255,0.95);
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  padding: 4px 0;
  min-width: 100px;
  backdrop-filter: blur(10px);
  
  .sort-option {
    padding: 8px 16px;
    font-size: 13px;
    color: #333;
    
    &.active {
      color: #007aff;
      background: rgba(0,122,255,0.05);
    }
  }
}
</style>
