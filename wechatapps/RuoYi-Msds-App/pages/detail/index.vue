<template>
  <view class="page-container">
    <!-- 背景图片/效果 -->
    <view class="glass-bg"></view>

    <!-- 自定义导航栏 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-content">
        <view class="nav-left" @click="onBack">
          <uni-icons type="arrow-left" color="#007AFF" size="20"></uni-icons>
        </view>
        <view class="nav-title">化学品详情</view>
        <view class="nav-right">
          <uni-icons type="redo" color="#007AFF" size="20"></uni-icons>
        </view>
      </view>
    </view>

    <!-- 占位符，防止内容被导航栏遮挡 -->
    <view :style="{ height: (44 + statusBarHeight) + 'px' }"></view>

    <!-- 主内容区域 -->
    <view class="content" v-if="loading">
      <view class="loading-container">
        <uni-load-more status="loading" content-text="加载中..."></uni-load-more>
      </view>
    </view>
    
    <view class="content" v-else>
      <!-- 化学品头部信息 -->
      <view class="chemical-header">
        <view class="header-bg-anim"></view>
        <view class="danger-level-indicator">{{ chemical.dangerLevel || '?' }}</view>
        <view class="chemical-name">{{ chemical.name || '未命名' }}</view>
        <view class="chemical-formula">{{ chemical.formula || '-' }}</view>
        <view class="chemical-cas">CAS: {{ chemical.cas || '-' }}</view>
      </view>

      <!-- 操作按钮 -->
      <view class="action-buttons">
        <button class="action-btn btn-primary" @click="onFavorite">
          <uni-icons :type="isFavorited ? 'star-filled' : 'star'" color="#fff" size="18" style="margin-right: 4px;"></uni-icons>
          <text>{{ isFavorited ? '已收藏' : '收藏' }}</text>
        </button>
        <button class="action-btn btn-secondary" @click="onDownload">
          <uni-icons type="download" color="#333" size="18" style="margin-right: 4px;"></uni-icons>
          <text>下载MSDS</text>
        </button>
      </view>

      <!-- 基本信息 -->
      <view class="info-card">
        <view class="card-header header-basic">
          <uni-icons type="info" color="#fff" size="20" style="margin-right: 8px;"></uni-icons>
          <text>基本信息</text>
        </view>
        <view class="card-content">
          <view class="property-row" v-for="(item, index) in basicInfo" :key="index">
            <view class="property-label">{{ item.label }}</view>
            <view class="property-value">{{ item.value }}</view>
          </view>
        </view>
      </view>

      <!-- 危险性信息 (如果有) -->
      <view class="info-card" v-if="hazardInfo.length > 0 || chemical.tags.length > 0">
        <view class="card-header header-danger">
          <uni-icons type="info-filled" color="#fff" size="20" style="margin-right: 8px;"></uni-icons>
          <text>危险性信息</text>
        </view>
        <view class="card-content">
          <view class="property-row" v-for="(item, index) in hazardInfo" :key="index">
            <view class="property-label">{{ item.label }}</view>
            <view class="property-value">{{ item.value }}</view>
          </view>
          <view class="hazard-tags" v-if="chemical.tags.length > 0">
            <view class="hazard-tag" v-for="(tag, index) in chemical.tags" :key="index">
              <uni-icons type="info-filled" color="#fff" size="12" style="margin-right: 4px;"></uni-icons>
              <text>{{ tag }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 健康危害 (如果有) -->
      <view class="info-card" v-if="healthHazards.length > 0">
        <view class="card-header header-health">
          <uni-icons type="heart" color="#fff" size="20" style="margin-right: 8px;"></uni-icons>
          <text>健康危害</text>
        </view>
        <view class="card-content">
          <view class="safety-item" v-for="(item, index) in healthHazards" :key="index">
            <view class="safety-icon">
              <uni-icons :type="item.icon" color="#fff" size="18"></uni-icons>
            </view>
            <view class="safety-text">
              <text style="font-weight: bold;">{{ item.type }}：</text>
              <text>{{ item.desc }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 急救措施 -->
      <view class="info-card" v-if="firstAid.length > 0">
        <view class="card-header header-firstaid">
          <uni-icons type="plus-filled" color="#fff" size="20" style="margin-right: 8px;"></uni-icons>
          <text>急救措施</text>
        </view>
        <view class="card-content">
          <view class="safety-item" v-for="(item, index) in firstAid" :key="index">
            <view class="safety-icon">
              <uni-icons :type="item.icon" color="#fff" size="18"></uni-icons>
            </view>
            <view class="safety-text">
              <text style="font-weight: bold;">{{ item.type }}：</text>
              <text>{{ item.desc }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 泄漏应急处理 -->
      <view class="info-card" v-if="leakResponse.length > 0">
        <view class="card-header header-leak">
          <uni-icons type="fire-filled" color="#fff" size="20" style="margin-right: 8px;"></uni-icons>
          <text>泄漏应急处理</text>
        </view>
        <view class="card-content">
          <view class="property-row" v-for="(item, index) in leakResponse" :key="index">
            <view class="property-label">{{ item.label }}</view>
            <view class="property-value">{{ item.value }}</view>
          </view>
        </view>
      </view>

      <!-- 储存运输 -->
      <view class="info-card" v-if="storageInfo.length > 0">
        <view class="card-header header-storage">
          <uni-icons type="paperplane-filled" color="#fff" size="20" style="margin-right: 8px;"></uni-icons>
          <text>储存运输</text>
        </view>
        <view class="card-content">
          <view class="property-row" v-for="(item, index) in storageInfo" :key="index">
            <view class="property-label">{{ item.label }}</view>
            <view class="property-value">{{ item.value }}</view>
          </view>
        </view>
      </view>
      
      <!-- 底部留白，防止内容被底部安全区遮挡 -->
      <view class="safe-area-bottom"></view>
    </view>
  </view>
</template>

<script>
import { getMsds, getMsdsFirstAidByMsdsId, getMsdsComponentByMsdsId, getMsdsLeakResponseByMsdsId } from '@/api/msds/msds'

export default {
  data() {
    return {
      statusBarHeight: 20,
      loading: true,
      isFavorited: false,
      chemical: {
        id: '',
        name: '',
        formula: '',
        cas: '',
        dangerLevel: '',
        tags: []
      },
      basicInfo: [],
      hazardInfo: [],
      healthHazards: [],
      firstAid: [],
      leakResponse: [], // Added leak response
      storageInfo: []
    }
  },
  onLoad(options) {
    const systemInfo = uni.getSystemInfoSync();
    this.statusBarHeight = systemInfo.statusBarHeight;
    
    if (options.id) {
      this.fetchData(options.id);
    } else if (options.name || options.cas) {
      // Fallback to passed options if no ID (e.g. pure UI preview)
      this.chemical.name = options.name || '';
      this.chemical.cas = options.cas || '';
      this.loading = false;
    } else {
      this.loading = false;
    }
  },
  methods: {
    async fetchData(id) {
      this.loading = true;
      try {
        // 1. Fetch Main Info
        const mainRes = await getMsds(id);
        const data = mainRes.data;
        
        this.chemical.name = data.productName;
        this.chemical.englishName = data.productEnglishName; // Add English name
        this.chemical.cas = data.casNumber;
        // Map risk level
        this.chemical.dangerLevel = data.riskLevel || '一般'; 
        
        // Auto-generate tags for filtering
        this.chemical.tags = [];
        const risk = (this.chemical.dangerLevel || '').toString();
        const name = (this.chemical.name || '').toLowerCase();
        
        if (risk.includes('高') || risk.includes('剧毒')) {
            this.chemical.tags.push('剧毒品');
            this.chemical.tags.push('危险品');
        } else if (risk.includes('中') || risk.includes('警告') || risk.includes('危险')) {
            this.chemical.tags.push('危险品');
        }
        
        if (name.includes('硝酸') || name.includes('过氧化') || name.includes('氯酸')) {
             this.chemical.tags.push('易制爆');
             this.chemical.tags.push('危险品');
        }
        if (name.includes('硫酸') || name.includes('盐酸') || name.includes('甲苯') || name.includes('丙酮')) {
             this.chemical.tags.push('易制毒');
        }
        if (name.includes('醇') || name.includes('醚') || name.includes('苯') || name.includes('酯')) {
             this.chemical.tags.push('有机物');
        } else if (name.includes('钠') || name.includes('钾') || name.includes('钙') || name.includes('铁')) {
             this.chemical.tags.push('无机物');
        }
        
        if (this.chemical.tags.length === 0) {
            this.chemical.tags.push('常用');
        }
        this.chemical.tags = [...new Set(this.chemical.tags)];
        
        // Check favorite status
        this.checkFavoriteStatus();
        
        this.basicInfo = [
          { label: '中文名称', value: data.productName },
          { label: '英文名称', value: data.productEnglishName || '-' },
          { label: 'CAS号', value: data.casNumber || '-' },
          { label: '供应商', value: data.supplierName || '-' },
          { label: '联系电话', value: data.emergencyPhone || data.supplierPhone || '-' }
        ];

        // 2. Fetch Components (for formula)
        try {
          const compRes = await getMsdsComponentByMsdsId(id);
          if (compRes.data && compRes.data.length > 0) {
            // Use the first component's formula as the main formula for display
            this.chemical.formula = compRes.data[0].molecularFormula || '-';
            // Add components to basic info if needed
            this.basicInfo.push({ 
              label: '主要成分', 
              value: compRes.data.map(c => c.componentName).join(', ') 
            });
          }
        } catch (e) {
          console.error('Failed to fetch components', e);
        }

        // 3. Fetch First Aid
        try {
          const firstAidRes = await getMsdsFirstAidByMsdsId(id);
          if (firstAidRes.data) { 
            let fa = firstAidRes.data;
            if (Array.isArray(fa)) fa = fa[0];
            
            if (fa) {
              this.firstAid = [
                { type: '吸入', desc: fa.inhalation || '无资料', icon: 'arrowright' },
                { type: '皮肤接触', desc: fa.skinContact || '无资料', icon: 'trash' },
                { type: '眼睛接触', desc: fa.eyeContact || '无资料', icon: 'eye-filled' },
                { type: '误食', desc: fa.ingestion || '无资料', icon: 'minus-filled' }
              ];
            }
          }
        } catch (e) {
          console.error('Failed to fetch first aid', e);
        }

        // 4. Fetch Leak Response
        try {
          const leakRes = await getMsdsLeakResponseByMsdsId(id);
          if (leakRes.data) {
            let lr = leakRes.data;
            if (Array.isArray(lr)) lr = lr[0];

            if (lr) {
               this.leakResponse = [
                 { label: '应急处理', value: lr.emergencyAction || '无资料' },
                 { label: '消除方法', value: lr.disposalMethod || '无资料' },
                 { label: '注意事项', value: lr.precaution || '无资料' }
               ];
            }
          }
        } catch (e) {
          console.error('Failed to fetch leak response', e);
        }

      } catch (error) {
        uni.showToast({ title: '获取详情失败', icon: 'none' });
        console.error(error);
      } finally {
        this.loading = false;
      }
    },
    onBack() {
      uni.navigateBack();
    },
    checkFavoriteStatus() {
      const id = this.chemical.id || this.chemical.cas;
      const favorites = uni.getStorageSync('MSDS_FAVORITES') || [];
      this.isFavorited = favorites.some(item => item.id === id || (item.cas && item.cas === id));
    },
    onFavorite() {
      const id = this.chemical.id || this.chemical.cas;
      let favorites = uni.getStorageSync('MSDS_FAVORITES') || [];
      
      if (this.isFavorited) {
        // Remove
        favorites = favorites.filter(item => item.id !== id && item.cas !== id);
        this.isFavorited = false;
        uni.showToast({ title: '已取消收藏', icon: 'none' });
      } else {
        // Add
        favorites.unshift({
          id: id,
          name: this.chemical.name,
          englishName: this.chemical.englishName || '',
          cas: this.chemical.cas,
          tags: this.chemical.tags,
          addTime: Date.now()
        });
        this.isFavorited = true;
        uni.showToast({ title: '已收藏', icon: 'success' });
      }
      uni.setStorageSync('MSDS_FAVORITES', favorites);
    },
    onDownload() {
      uni.showToast({
        title: '开始下载MSDS...',
        icon: 'none'
      });
    }
  }
}
</script>

<style lang="scss" scoped>
.page-container {
  min-height: 100vh;
  background-color: #f5f5f7;
  position: relative;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
}

.loading-container {
  display: flex;
  justify-content: center;
  padding-top: 50px;
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
  opacity: 0.3;
  z-index: 0;
  filter: saturate(1.3) brightness(1.2);
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

.nav-bar {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  z-index: 100;
  background-color: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border-bottom: 1px solid rgba(0, 0, 0, 0.1);
}

.nav-content {
  height: 44px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 16px;
}

.nav-title {
  font-size: 17px;
  font-weight: 600;
  color: #000;
}

.nav-left, .nav-right {
  width: 40px;
  display: flex;
  align-items: center;
}
.nav-right {
  justify-content: flex-end;
}

.content {
  position: relative;
  z-index: 1;
  padding: 16px;
}

.chemical-header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 16px;
  padding: 24px;
  margin-bottom: 20px;
  color: white;
  position: relative;
  overflow: hidden;
  box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
}

.header-bg-anim {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: radial-gradient(circle at 20% 20%, rgba(255,255,255,0.1) 0%, transparent 10%),
              radial-gradient(circle at 80% 40%, rgba(255,255,255,0.1) 0%, transparent 5%),
              radial-gradient(circle at 40% 80%, rgba(255,255,255,0.1) 0%, transparent 8%);
  pointer-events: none;
  animation: float 20s infinite linear;
}

@keyframes float {
  0% { transform: translateY(0px); }
  50% { transform: translateY(-10px); }
  100% { transform: translateY(0px); }
}

.chemical-name {
  font-size: 24px;
  font-weight: 700;
  margin-bottom: 8px;
}

.chemical-formula {
  font-size: 16px;
  opacity: 0.9;
  margin-bottom: 12px;
}

.chemical-cas {
  background-color: rgba(255, 255, 255, 0.2);
  padding: 6px 12px;
  border-radius: 20px;
  display: inline-block;
  font-size: 12px;
  font-weight: 500;
}

.danger-level-indicator {
  position: absolute;
  top: 20px;
  right: 20px;
  width: 50px;
  height: 50px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
  font-weight: bold;
  background-color: #ff4757;
  color: white;
  box-shadow: 0 4px 12px rgba(255, 71, 87, 0.3);
  border: 2px solid rgba(255, 255, 255, 0.3);
}

.action-buttons {
  display: flex;
  gap: 12px;
  margin-bottom: 20px;
}

.action-btn {
  flex: 1;
  padding: 0; /* Reset default padding */
  height: 44px;
  border-radius: 12px;
  font-size: 14px;
  font-weight: 600;
  display: flex;
  align-items: center;
  justify-content: center;
  border: none;
  
  &::after {
    border: none;
  }

  &:active {
    transform: scale(0.98);
    opacity: 0.9;
  }
}

.btn-primary {
  background: linear-gradient(135deg, #667eea, #764ba2);
  color: white;
  box-shadow: 0 4px 10px rgba(102, 126, 234, 0.3);
}

.btn-secondary {
  background: rgba(255, 255, 255, 0.9);
  color: #333;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.info-card {
  background-color: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border-radius: 12px;
  margin-bottom: 16px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  overflow: hidden;
}

.card-header {
  padding: 12px 16px;
  font-size: 16px;
  font-weight: 600;
  display: flex;
  align-items: center;
  color: white;
}

.header-basic { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
.header-danger { background: linear-gradient(135deg, #ff758c 0%, #ff7eb3 100%); color: white; }
.header-health { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
.header-firstaid { background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); }
.header-leak { background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); }
.header-storage { background: linear-gradient(135deg, #8fd3f4 0%, #84fab0 100%); }

.card-content {
  padding: 16px;
}

.property-row {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  padding: 10px 0;
  border-bottom: 1px solid rgba(0, 0, 0, 0.05);
  font-size: 14px;
}

.property-row:last-child {
  border-bottom: none;
}

.property-label {
  font-weight: 500;
  color: #333;
  width: 80px;
  flex-shrink: 0;
}

.property-value {
  color: #666;
  text-align: right;
  flex: 1;
  word-break: break-all;
}

.hazard-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-top: 12px;
}

.hazard-tag {
  background: linear-gradient(135deg, #ff6b6b, #ee5a24);
  color: white;
  padding: 4px 10px;
  border-radius: 16px;
  font-size: 12px;
  font-weight: 500;
  display: flex;
  align-items: center;
}

.safety-item {
  display: flex;
  align-items: flex-start;
  padding: 12px 0;
  border-bottom: 1px solid rgba(0, 0, 0, 0.05);
}

.safety-item:last-child {
  border-bottom: none;
}

.safety-icon {
  width: 28px;
  height: 28px;
  border-radius: 50%;
  background: linear-gradient(135deg, #4facfe, #00f2fe);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 12px;
  flex-shrink: 0;
}

.safety-text {
  flex: 1;
  color: #333;
  font-size: 14px;
  line-height: 1.5;
}

.safe-area-bottom {
  height: 30px;
  height: constant(safe-area-inset-bottom);
  height: env(safe-area-inset-bottom);
}
</style>
