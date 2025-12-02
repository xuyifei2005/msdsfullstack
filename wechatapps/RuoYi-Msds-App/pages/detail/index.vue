<template>
  <view class="page-container">
    <!-- 背景图片/效果 -->
    <view class="glass-bg"></view>

    <!-- 自定义导航栏 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-content">
        <view class="nav-left" @click="onBack">
          <u-icon name="arrow-left" color="#007AFF" size="20"></u-icon>
        </view>
        <view class="nav-title">化学品详情</view>
        <view class="nav-right">
          <u-icon name="share" color="#007AFF" size="20"></u-icon>
        </view>
      </view>
    </view>

    <!-- 占位符，防止内容被导航栏遮挡 -->
    <view :style="{ height: (44 + statusBarHeight) + 'px' }"></view>

    <!-- 主内容区域 -->
    <view class="content">
      <!-- 化学品头部信息 -->
      <view class="chemical-header">
        <view class="header-bg-anim"></view>
        <view class="danger-level-indicator">{{ chemical.dangerLevel }}</view>
        <view class="chemical-name">{{ chemical.name }}</view>
        <view class="chemical-formula">{{ chemical.formula }}</view>
        <view class="chemical-cas">CAS: {{ chemical.cas }}</view>
      </view>

      <!-- 操作按钮 -->
      <view class="action-buttons">
        <button class="action-btn btn-primary" @click="onFavorite">
          <u-icon name="star" color="#fff" size="18" style="margin-right: 4px;"></u-icon>
          <text>收藏</text>
        </button>
        <button class="action-btn btn-secondary" @click="onDownload">
          <u-icon name="download" color="#333" size="18" style="margin-right: 4px;"></u-icon>
          <text>下载MSDS</text>
        </button>
      </view>

      <!-- 基本信息 -->
      <view class="info-card">
        <view class="card-header header-basic">
          <u-icon name="info-circle" color="#fff" size="20" style="margin-right: 8px;"></u-icon>
          <text>基本信息</text>
        </view>
        <view class="card-content">
          <view class="property-row" v-for="(item, index) in basicInfo" :key="index">
            <view class="property-label">{{ item.label }}</view>
            <view class="property-value">{{ item.value }}</view>
          </view>
        </view>
      </view>

      <!-- 危险性信息 -->
      <view class="info-card">
        <view class="card-header header-danger">
          <u-icon name="error-circle" color="#fff" size="20" style="margin-right: 8px;"></u-icon>
          <text>危险性信息</text>
        </view>
        <view class="card-content">
          <view class="property-row" v-for="(item, index) in hazardInfo" :key="index">
            <view class="property-label">{{ item.label }}</view>
            <view class="property-value">{{ item.value }}</view>
          </view>
          <view class="hazard-tags">
            <view class="hazard-tag" v-for="(tag, index) in chemical.tags" :key="index">
              <u-icon name="warning-fill" color="#fff" size="12" style="margin-right: 4px;"></u-icon>
              <text>{{ tag }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 健康危害 -->
      <view class="info-card">
        <view class="card-header header-health">
          <u-icon name="heart" color="#fff" size="20" style="margin-right: 8px;"></u-icon>
          <text>健康危害</text>
        </view>
        <view class="card-content">
          <view class="safety-item" v-for="(item, index) in healthHazards" :key="index">
            <view class="safety-icon">
              <u-icon :name="item.icon" color="#fff" size="18"></u-icon>
            </view>
            <view class="safety-text">
              <text style="font-weight: bold;">{{ item.type }}：</text>
              <text>{{ item.desc }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 急救措施 -->
      <view class="info-card">
        <view class="card-header header-firstaid">
          <u-icon name="plus-circle" color="#fff" size="20" style="margin-right: 8px;"></u-icon>
          <text>急救措施</text>
        </view>
        <view class="card-content">
          <view class="safety-item" v-for="(item, index) in firstAid" :key="index">
            <view class="safety-icon">
              <u-icon :name="item.icon" color="#fff" size="18"></u-icon>
            </view>
            <view class="safety-text">
              <text style="font-weight: bold;">{{ item.type }}：</text>
              <text>{{ item.desc }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 储存运输 -->
      <view class="info-card">
        <view class="card-header header-storage">
          <u-icon name="car" color="#fff" size="20" style="margin-right: 8px;"></u-icon>
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
export default {
  data() {
    return {
      statusBarHeight: 20,
      chemical: {
        name: '甲醇',
        formula: 'CH₃OH',
        cas: '67-56-1',
        dangerLevel: '3',
        tags: ['易燃', '有毒', '刺激性']
      },
      basicInfo: [
        { label: '中文名称', value: '甲醇' },
        { label: '英文名称', value: 'Methanol' },
        { label: '分子式', value: 'CH₃OH' },
        { label: '分子量', value: '32.04' },
        { label: '沸点', value: '64.7°C' },
        { label: '熔点', value: '-97.8°C' },
        { label: '密度', value: '0.791 g/cm³' }
      ],
      hazardInfo: [
        { label: '危险等级', value: '3级 - 高度危险' },
        { label: '闪点', value: '11°C' },
        { label: '自燃温度', value: '464°C' }
      ],
      healthHazards: [
        { type: '吸入', desc: '可引起头痛、眩晕、恶心、呕吐，严重时可导致昏迷甚至死亡。', icon: 'arrow-up' }, // lungs -> arrow-up as proxy
        { type: '皮肤接触', desc: '可引起皮肤干燥、脱脂，长期接触可导致皮炎。', icon: 'minus' }, // hand-paper -> minus proxy
        { type: '眼睛接触', desc: '可引起眼睛刺激、疼痛、流泪，严重时可导致角膜损伤。', icon: 'eye' },
        { type: '误食', desc: '可引起恶心、呕吐、腹痛，严重时可导致失明或死亡。', icon: 'close' } // tint -> close proxy
      ],
      firstAid: [
        { type: '吸入', desc: '迅速脱离现场至空气新鲜处，保持呼吸道通畅，必要时进行人工呼吸。', icon: 'arrow-right' },
        { type: '皮肤接触', desc: '立即脱去污染的衣着，用大量清水冲洗皮肤至少15分钟。', icon: 'trash' }, // shower -> trash proxy (cleaning)
        { type: '眼睛接触', desc: '立即提起眼睑，用大量清水或生理盐水彻底冲洗至少15分钟。', icon: 'eye-fill' },
        { type: '误食', desc: '用水漱口，给饮牛奶或蛋清。不要催吐，立即就医。', icon: 'minus-circle' }
      ],
      storageInfo: [
        { label: '储存条件', value: '阴凉、通风、干燥处' },
        { label: '包装要求', value: '密封包装' },
        { label: '运输类别', value: '危险品3类' },
        { label: 'UN编号', value: '1230' }
      ]
    }
  },
  onLoad(options) {
    const systemInfo = uni.getSystemInfoSync();
    this.statusBarHeight = systemInfo.statusBarHeight;
    
    // 如果有传入参数，可以更新数据
    if (options.name) {
        this.chemical.name = options.name;
    }
    if (options.cas) {
        this.chemical.cas = options.cas;
    }
  },
  methods: {
    onBack() {
      uni.navigateBack();
    },
    onFavorite() {
      uni.showToast({
        title: '已收藏',
        icon: 'success'
      });
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
.header-danger { background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 99%, #fecfef 100%); color: #d63031; } /* Danger header usually red/warning color */
.header-danger .u-icon, .header-danger text { color: white; } /* Override for consistency if using gradient */
.header-danger { background: linear-gradient(135deg, #ff758c 0%, #ff7eb3 100%); color: white; } /* Fixed danger gradient */

.header-health { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
.header-firstaid { background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); }
.header-storage { background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); }

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
