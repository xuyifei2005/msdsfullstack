<template>
  <view class="page-container">
    <!-- 背景图片/效果 -->
    <view class="glass-bg"></view>

    <!-- 自定义导航栏 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-content">
        <view class="nav-left" @click="onBack">
          <u-icon name="arrow-left" color="#007AFF" size="20"></u-icon>
          <text class="back-text">返回</text>
        </view>
        <view class="nav-right">
          <u-icon name="star" :color="isFavorited ? '#ff9900' : '#666'" size="20" style="margin-right: 15px;" @click="toggleFavorite"></u-icon>
          <u-icon name="share" color="#666" size="20"></u-icon>
        </view>
      </view>
    </view>

    <!-- 占位符，防止内容被导航栏遮挡 -->
    <view :style="{ height: (44 + statusBarHeight) + 'px' }"></view>

    <!-- 主内容区域 -->
    <view class="content">
      <!-- 文档头部 -->
      <view class="document-header">
        <view class="document-title">{{ document.title }}</view>
        <view class="document-subtitle">CAS号: {{ document.cas }}</view>
        <view class="document-tags">
          <view class="document-tag" v-for="(tag, index) in document.tags" :key="index">
            {{ tag }}
          </view>
        </view>
        <view class="danger-indicator">
          <u-icon name="info-circle-fill" color="#FF3B30" size="24" style="margin-right: 8px;"></u-icon>
          <view>
            <view class="danger-title">高危险性物质</view>
            <view class="danger-desc">处理时需要特殊防护措施</view>
          </view>
        </view>
      </view>

      <!-- 危险特性 -->
      <view class="document-section">
        <view class="section-title">
          <u-icon name="warning-fill" color="#007AFF" size="18" style="margin-right: 8px;"></u-icon>
          <text>危险特性</text>
        </view>
        <view class="property-row" v-for="(item, index) in dangerProps" :key="index">
          <view class="property-name">{{ item.label }}</view>
          <view class="property-value">{{ item.value }}</view>
        </view>
      </view>

      <!-- 物理化学性质 -->
      <view class="document-section">
        <view class="section-title">
          <u-icon name="hourglass" color="#007AFF" size="18" style="margin-right: 8px;"></u-icon>
          <text>物理化学性质</text>
        </view>
        <view class="property-row" v-for="(item, index) in physicalProps" :key="index">
          <view class="property-name">{{ item.label }}</view>
          <view class="property-value">{{ item.value }}</view>
        </view>
      </view>

      <!-- 安全措施 -->
      <view class="document-section">
        <view class="section-title">
          <u-icon name="checkmark-circle-fill" color="#007AFF" size="18" style="margin-right: 8px;"></u-icon>
          <text>安全措施</text>
        </view>
        <view class="property-row" v-for="(item, index) in safetyProps" :key="index">
          <view class="property-name">{{ item.label }}</view>
          <view class="property-value">{{ item.value }}</view>
        </view>
      </view>

      <!-- 急救措施 -->
      <view class="document-section">
        <view class="section-title">
          <u-icon name="plus-circle-fill" color="#007AFF" size="18" style="margin-right: 8px;"></u-icon>
          <text>急救措施</text>
        </view>
        <view class="property-row" v-for="(item, index) in firstAidProps" :key="index">
          <view class="property-name">{{ item.label }}</view>
          <view class="property-value">{{ item.value }}</view>
        </view>
      </view>

      <!-- 操作按钮 -->
      <view class="action-buttons">
        <button class="action-button primary-button" @click="downloadPdf">
          <u-icon name="download" color="#fff" size="18" style="margin-right: 8px;"></u-icon>
          <text>下载PDF</text>
        </button>
        <button class="action-button secondary-button" @click="printDoc">
          <u-icon name="printer" color="#1d1d1f" size="18" style="margin-right: 8px;"></u-icon>
          <text>打印</text>
        </button>
      </view>
      
      <!-- 底部留白 -->
      <view class="safe-area-bottom"></view>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      statusBarHeight: 20,
      isFavorited: false,
      document: {
        title: '甲醇 (Methanol)',
        cas: '67-56-1',
        tags: ['易燃液体', '毒性物质', '类别2']
      },
      dangerProps: [
        { label: '燃点', value: '11°C' },
        { label: '爆炸极限', value: '5.5% ~ 44%' },
        { label: '毒性等级', value: '中毒' }
      ],
      physicalProps: [
        { label: '分子式', value: 'CH₃OH' },
        { label: '分子量', value: '32.04 g/mol' },
        { label: '沸点', value: '64.7°C' },
        { label: '熔点', value: '-97.6°C' },
        { label: '密度', value: '0.792 g/cm³' },
        { label: '外观', value: '无色透明液体' }
      ],
      safetyProps: [
        { label: '个人防护', value: '防护服、防毒面具、护目镜、橡胶手套' },
        { label: '储存条件', value: '阴凉、通风、干燥处，远离火源、热源' },
        { label: '灭火方法', value: '抗溶性泡沫、干粉、二氧化碳、砂土' }
      ],
      firstAidProps: [
        { label: '皮肤接触', value: '脱去污染的衣着，用肥皂水和清水彻底冲洗皮肤' },
        { label: '眼睛接触', value: '提起眼睑，用流动清水或生理盐水冲洗，就医' },
        { label: '吸入', value: '迅速脱离现场至空气新鲜处，保持呼吸道通畅，如呼吸困难，给输氧，就医' },
        { label: '食入', value: '饮足量温水，催吐，就医' }
      ]
    }
  },
  onLoad() {
    const systemInfo = uni.getSystemInfoSync();
    this.statusBarHeight = systemInfo.statusBarHeight;
  },
  methods: {
    onBack() {
      uni.navigateBack();
    },
    toggleFavorite() {
      this.isFavorited = !this.isFavorited;
      uni.showToast({
        title: this.isFavorited ? '已添加到收藏' : '已从收藏中移除',
        icon: 'none'
      });
    },
    downloadPdf() {
      uni.showToast({
        title: '开始下载PDF文件',
        icon: 'none'
      });
    },
    printDoc() {
      uni.showToast({
        title: '准备打印文档',
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
  opacity: 0.2;
  z-index: 0;
  filter: saturate(1.2) brightness(1.1);
  pointer-events: none;
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

.nav-left {
  display: flex;
  align-items: center;
  .back-text {
    font-size: 16px;
    color: #007AFF;
    margin-left: 4px;
  }
}

.nav-right {
  display: flex;
  align-items: center;
}

.content {
  position: relative;
  z-index: 1;
  padding: 16px;
}

.document-header {
  background-color: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border-radius: 12px;
  padding: 16px;
  margin-bottom: 16px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.document-title {
  font-size: 24px;
  font-weight: 700;
  color: #1d1d1f;
  margin-bottom: 8px;
}

.document-subtitle {
  font-size: 16px;
  color: #6e6e73;
  margin-bottom: 12px;
}

.document-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 12px;
}

.document-tag {
  background-color: rgba(0, 122, 255, 0.1);
  color: #007AFF;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 500;
}

.danger-indicator {
  display: flex;
  align-items: center;
  margin-top: 12px;
  padding: 8px 12px;
  background-color: rgba(255, 59, 48, 0.1);
  border-radius: 8px;
}

.danger-title {
  font-weight: 600;
  color: #FF3B30;
  font-size: 14px;
}

.danger-desc {
  font-size: 12px;
  color: #666;
}

.document-section {
  background-color: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(5px);
  -webkit-backdrop-filter: blur(5px);
  border-radius: 12px;
  padding: 16px;
  margin-bottom: 16px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
  
  &:active {
    transform: translateY(-2px);
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
  }
}

.section-title {
  font-size: 18px;
  font-weight: 600;
  color: #1d1d1f;
  margin-bottom: 12px;
  display: flex;
  align-items: center;
}

.property-row {
  display: flex;
  margin-bottom: 8px;
  padding-bottom: 8px;
  border-bottom: 1px solid rgba(0, 0, 0, 0.05);
  font-size: 14px;
}

.property-row:last-child {
  border-bottom: none;
  margin-bottom: 0;
  padding-bottom: 0;
}

.property-name {
  width: 40%;
  font-weight: 500;
  color: #6e6e73;
}

.property-value {
  width: 60%;
  color: #1d1d1f;
  word-break: break-all;
}

.action-buttons {
  display: flex;
  gap: 10px;
  margin-top: 16px;
}

.action-button {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0;
  height: 44px;
  border-radius: 10px;
  font-weight: 600;
  font-size: 14px;
  border: none;
  
  &::after {
    border: none;
  }
}

.primary-button {
  background-color: #007AFF;
  color: white;
  box-shadow: 0 2px 6px rgba(0, 122, 255, 0.3);
}

.secondary-button {
  background-color: rgba(255, 255, 255, 0.9);
  color: #1d1d1f;
  border: 1px solid rgba(0, 0, 0, 0.05);
}

.safe-area-bottom {
  height: 30px;
  height: constant(safe-area-inset-bottom);
  height: env(safe-area-inset-bottom);
}
</style>
