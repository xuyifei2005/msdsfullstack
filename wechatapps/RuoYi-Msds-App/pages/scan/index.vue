<template>
  <view class="scan-page">
    <!-- 自定义导航栏 -->
    <u-navbar
      title="扫码查阅"
      :autoBack="true"
      bgColor="transparent"
      :titleStyle="{color: '#FFFFFF'}"
      leftIconColor="#FFFFFF"
      :fixed="true"
      :placeholder="false"
    >
      <view slot="right" class="nav-right" @click="showMenu">
        <uni-icons type="more-filled" color="#FFFFFF" size="24"></uni-icons>
      </view>
    </u-navbar>

    <!-- 相机组件 -->
    <camera 
      v-if="!showResult"
      device-position="back" 
      :flash="flashOn ? 'on' : 'off'" 
      mode="scanCode"
      @scancode="handleScanCode"
      @error="handleCameraError"
      class="camera-view"
    >
      <!-- 覆盖层 -->
      <cover-view class="scan-overlay">
        <!-- 顶部按钮 -->
        <cover-view class="top-controls">
           <cover-view class="control-btn" @click="toggleHistory">
             <cover-view class="btn-text">🕒</cover-view>
           </cover-view>
           <cover-view class="control-btn" @click="toggleFlash">
             <cover-view class="btn-text" :style="{color: flashOn ? '#1aad19' : '#fff'}">⚡</cover-view>
           </cover-view>
        </cover-view>
        
        <!-- 扫描框 -->
        <cover-view class="scan-area">
           <cover-view class="scan-frame">
             <cover-view class="corner top-left"></cover-view>
             <cover-view class="corner top-right"></cover-view>
             <cover-view class="corner bottom-left"></cover-view>
             <cover-view class="corner bottom-right"></cover-view>
             <cover-view class="scan-line"></cover-view>
           </cover-view>
        </cover-view>

        <!-- 提示文案 -->
        <cover-view class="scan-tips">
           <cover-view class="tip-title">将二维码放入框内</cover-view>
           <cover-view class="tip-desc">对准化学品标签上的二维码即可快速查看信息</cover-view>
        </cover-view>

        <!-- 底部操作栏 -->
        <cover-view class="bottom-actions">
           <cover-view class="action-item" @click="chooseImage">
              <cover-view class="action-icon-circle">🖼️</cover-view>
           </cover-view>
           <cover-view class="action-item center" @click="manualTrigger">
              <cover-view class="action-icon-big">📷</cover-view>
           </cover-view>
           <cover-view class="action-item" @click="manualInput">
              <cover-view class="action-icon-circle">⌨️</cover-view>
           </cover-view>
        </cover-view>
      </cover-view>
    </camera>

    <!-- 扫描结果弹窗 (当有结果时显示，相机隐藏或被覆盖) -->
    <view class="result-container" v-if="showResult">
        <!-- 模糊背景或黑色背景 -->
        <view class="result-mask" @click="closeResult"></view>
        
        <view class="result-card">
            <view class="result-header">
                <text class="result-title">扫描结果</text>
                <view class="close-btn" @click="closeResult">
                    <uni-icons type="closeempty" size="20" color="#666"></uni-icons>
                </view>
            </view>
            
            <view class="chemical-info" v-if="scanData">
                <view class="chem-name">{{ scanData.name }}</view>
                <view class="chem-name-en">{{ scanData.nameEn }}</view>
                
                <view class="tags-row">
                    <view class="tag">CAS: {{ scanData.cas }}</view>
                    <view class="tag">分子式: {{ scanData.formula }}</view>
                    <view class="tag danger" v-if="scanData.isDanger">易燃</view>
                </view>
                
                <view class="info-details">
                    <view class="detail-row">供应商: {{ scanData.supplier }}</view>
                    <view class="detail-row">更新时间: {{ scanData.updateTime }}</view>
                </view>
                
                <view class="card-actions">
                    <button class="btn secondary" @click="toggleCollect">
                        <uni-icons :type="isCollected ? 'heart-filled' : 'heart'" :color="isCollected ? '#ff4757' : '#666'" size="16"></uni-icons>
                        <text>{{ isCollected ? '已收藏' : '收藏' }}</text>
                    </button>
                    <button class="btn primary" @click="viewDetail">
                        <uni-icons type="eye" color="#fff" size="16"></uni-icons>
                        <text>查看详情</text>
                    </button>
                </view>
            </view>
            
            <view class="no-data" v-else>
                <text>未查询到相关化学品信息</text>
                <button class="btn primary" @click="closeResult" style="margin-top: 20rpx;">重新扫描</button>
            </view>
        </view>
    </view>

  </view>
</template>

<script>
export default {
  data() {
    return {
      flashOn: false,
      showResult: false,
      scanData: null,
      isCollected: false,
      lastScanTime: 0
    };
  },
  methods: {
    handleCameraError(e) {
        uni.showToast({
            title: '摄像头启动失败',
            icon: 'none'
        });
    },
    toggleFlash() {
      this.flashOn = !this.flashOn;
    },
    toggleHistory() {
      uni.showToast({ title: '查看历史记录', icon: 'none' });
    },
    showMenu() {
      uni.showActionSheet({
          itemList: ['帮助', '反馈'],
          success: (res) => {
              console.log('选中了第' + (res.tapIndex + 1) + '个按钮');
          }
      });
    },
    // 扫码回调
    handleScanCode(e) {
        const now = Date.now();
        if (now - this.lastScanTime < 2000) return; // 防抖
        this.lastScanTime = now;
        
        this.processScanResult(e.result);
    },
    // 处理扫码结果
    processScanResult(result) {
        // 震动反馈
        uni.vibrateShort();
        
        // 模拟API请求
        uni.showLoading({ title: '查询中...' });
        
        setTimeout(() => {
            uni.hideLoading();
            // 这里模拟识别到了乙醇
            // 实际项目中应该调用API: getChemicalByCode(result)
            this.scanData = {
                name: '乙醇',
                nameEn: 'Ethanol',
                cas: '64-17-5',
                formula: 'C₂H₆O',
                isDanger: true,
                supplier: '国药集团化学试剂有限公司',
                updateTime: '2024-01-15',
                id: 'ethanol_001'
            };
            this.showResult = true;
        }, 500);
    },
    // 手动触发（模拟）
    manualTrigger() {
        this.processScanResult('MOCK_CODE_123');
    },
    // 相册选择
    chooseImage() {
      uni.chooseImage({
        count: 1,
        sourceType: ['album'],
        success: (res) => {
          uni.scanCode({
              scanType: ['qrCode', 'barCode'],
              path: res.tempFilePaths[0],
              success: (scanRes) => {
                  this.processScanResult(scanRes.result);
              },
              fail: () => {
                  uni.showToast({ title: '未识别到二维码', icon: 'none' });
              }
          });
        },
      });
    },
    // 手动输入
    manualInput() {
      uni.navigateTo({
          url: '/pages/search/index'
      });
    },
    closeResult() {
        this.showResult = false;
        this.scanData = null;
    },
    toggleCollect() {
        this.isCollected = !this.isCollected;
        uni.showToast({
            title: this.isCollected ? '收藏成功' : '取消收藏',
            icon: 'none'
        });
    },
    viewDetail() {
        if (this.scanData && this.scanData.id) {
            uni.navigateTo({
                url: `/pages/detail/index?id=${this.scanData.id}`
            });
        }
    }
  }
};
</script>

<style lang="scss" scoped>
.scan-page {
  width: 100vw;
  height: 100vh;
  background-color: #000;
  position: relative;
}

.camera-view {
    width: 100%;
    height: 100vh;
    position: absolute;
    top: 0;
    left: 0;
}

.scan-overlay {
    width: 100%;
    height: 100%;
    position: relative;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
}

.top-controls {
    position: absolute;
    top: 180rpx; /* 避开导航栏 */
    width: 100%;
    padding: 0 40rpx;
    display: flex;
    justify-content: space-between;
    box-sizing: border-box;
    z-index: 10;
}

.control-btn {
    width: 80rpx;
    height: 80rpx;
    background: rgba(0,0,0,0.4);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    border: 1px solid rgba(255,255,255,0.2);
}

.btn-text {
    font-size: 40rpx;
    color: #fff;
    line-height: 80rpx;
    text-align: center;
}

.scan-area {
    width: 500rpx;
    height: 500rpx;
    position: relative;
}

.scan-frame {
    width: 100%;
    height: 100%;
    border: 1px solid rgba(255,255,255,0.3);
    position: relative;
}

.corner {
    position: absolute;
    width: 40rpx;
    height: 40rpx;
    border: 6rpx solid #1aad19;
}

.top-left { top: -2rpx; left: -2rpx; border-right: none; border-bottom: none; }
.top-right { top: -2rpx; right: -2rpx; border-left: none; border-bottom: none; }
.bottom-left { bottom: -2rpx; left: -2rpx; border-right: none; border-top: none; }
.bottom-right { bottom: -2rpx; right: -2rpx; border-left: none; border-top: none; }

.scan-line {
    position: absolute;
    width: 100%;
    height: 2rpx;
    background: #1aad19;
    top: 0;
    animation: scanMove 2s infinite linear;
    box-shadow: 0 0 4px #1aad19;
}

/* cover-view animation support is limited, but basic keyframes often work in modern MP */
@keyframes scanMove {
    0% { top: 0; opacity: 0.6; }
    50% { opacity: 1; }
    100% { top: 100%; opacity: 0.6; }
}

.scan-tips {
    margin-top: 60rpx;
    text-align: center;
}

.tip-title {
    font-size: 36rpx;
    color: #fff;
    font-weight: bold;
    margin-bottom: 16rpx;
    text-align: center;
}

.tip-desc {
    font-size: 28rpx;
    color: #ccc;
    text-align: center;
    white-space: pre-wrap;
}

.bottom-actions {
    position: absolute;
    bottom: 80rpx;
    width: 100%;
    display: flex;
    justify-content: space-around;
    align-items: center;
    padding: 0 60rpx;
    box-sizing: border-box;
}

.action-item {
    display: flex;
    flex-direction: column;
    align-items: center;
}

.action-icon-circle {
    width: 100rpx;
    height: 100rpx;
    background: rgba(255,255,255,0.2);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 50rpx;
    color: #fff;
}

.action-icon-big {
    width: 140rpx;
    height: 140rpx;
    background: #1aad19;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 70rpx;
    color: #fff;
    border: 8rpx solid rgba(255,255,255,0.3);
}

/* Result Popup Styles */
.result-container {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 100;
    display: flex;
    flex-direction: column;
    justify-content: flex-end;
}

.result-mask {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0,0,0,0.7);
}

.result-card {
    background: #fff;
    border-radius: 24rpx 24rpx 0 0;
    padding: 32rpx;
    position: relative;
    z-index: 101;
    animation: slideUp 0.3s ease-out;
}

@keyframes slideUp {
    from { transform: translateY(100%); }
    to { transform: translateY(0); }
}

.result-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 32rpx;
}

.result-title {
    font-size: 36rpx;
    font-weight: bold;
    color: #333;
}

.close-btn {
    width: 60rpx;
    height: 60rpx;
    background: #f3f4f6;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
}

.chemical-info {
    background: #f9fafb;
    border-radius: 16rpx;
    padding: 24rpx;
}

.chem-name {
    font-size: 32rpx;
    font-weight: bold;
    color: #1f2937;
    margin-bottom: 8rpx;
}

.chem-name-en {
    font-size: 28rpx;
    color: #6b7280;
    margin-bottom: 20rpx;
}

.tags-row {
    display: flex;
    flex-wrap: wrap;
    gap: 16rpx;
    margin-bottom: 24rpx;
}

.tag {
    background: #e5e7eb;
    color: #374151;
    padding: 4rpx 16rpx;
    border-radius: 8rpx;
    font-size: 24rpx;
}

.tag.danger {
    background: #fee2e2;
    color: #ef4444;
}

.info-details {
    font-size: 26rpx;
    color: #4b5563;
    margin-bottom: 32rpx;
}

.detail-row {
    margin-bottom: 8rpx;
}

.card-actions {
    display: flex;
    gap: 24rpx;
}

.btn {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    height: 88rpx;
    border-radius: 12rpx;
    font-size: 28rpx;
    border: none;
    gap: 10rpx;
}

.btn.secondary {
    background: #f3f4f6;
    color: #374151;
}

.btn.primary {
    background: #1aad19;
    color: #fff;
}

.no-data {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 40rpx 0;
    color: #6b7280;
}
</style>