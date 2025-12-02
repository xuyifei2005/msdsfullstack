<template>
  <view class="scan-page">
    <u-navbar
      title="扫码查阅MSDS"
      :autoBack="true"
      :bgColor="'#374151'"
      :titleStyle="{color: '#FFFFFF'}"
      leftIconColor="#FFFFFF"
    >
    </u-navbar>

    <view class="scan-container">
      <view class="scan-box">
        <view class="corner top-left"></view>
        <view class="corner top-right"></view>
        <view class="corner bottom-left"></view>
        <view class="corner bottom-right"></view>
        <view class="scan-line"></view>
      </view>

      <view class="tips">
        <text class="title">将二维码放入框内</text>
        <text class="subtitle">对准化学品标签上的二维码\n即可快速查看MSDS信息</text>
      </view>

      <view class="actions">
        <view class="action-item" @click="chooseImage">
          <uni-icons type="image" color="#9CA3AF" size="28"></uni-icons>
          <text class="action-text">相册</text>
        </view>
        <view class="action-item" @click="toggleFlash">
          <uni-icons :type="flashOn ? 'star-filled' : 'star'" :color="flashOn ? '#FBBF24' : '#9CA3AF'" size="28"></uni-icons>
          <text class="action-text">闪光灯</text>
        </view>
      </view>
    </view>

    <view class="bottom-tip">
        <uni-icons type="info" color="#60A5FA" size="18"></uni-icons>
        <text class="bottom-tip-text">确保光线充足，保持设备稳定</text>
      </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      flashOn: false,
    };
  },
  methods: {
    // 从相册选择图片
    chooseImage() {
      uni.chooseImage({
        count: 1,
        sizeType: ['compressed'],
        sourceType: ['album'],
        success: (res) => {
          // res.tempFilePaths[0] 为选定的图片
          this.scanCode(res.tempFilePaths[0]);
        },
      });
    },
    // 切换闪光灯
    toggleFlash() {
      this.flashOn = !this.flashOn;
      // uni.scanCode 暂不支持直接控制闪光灯，这里仅为UI切换
      // 实际控制需在原生插件或特定API支持下实现
      this.$u.toast(this.flashOn ? '闪光灯已打开' : '闪光灯已关闭');
    },
    // 扫码逻辑
    scanCode(filePath) {
      uni.scanCode({
        scanType: ['qrCode'],
        path: filePath, // 从相册选择时传入
        success: (res) => {
          console.log('条码类型：' + res.scanType);
          console.log('条码内容：' + res.result);
          // 扫码成功，跳转到详情页
          uni.navigateTo({
            url: '/pages/detail/index?result=' + res.result,
          });
        },
        fail: (err) => {
          this.$u.toast('扫码失败，请重试');
        }
      });
    }
  },
  onReady() {
    // 页面加载完成后，自动调起摄像头扫码
    // #ifndef H5
    this.scanCode();
    // #endif
  }
};
</script>

<style lang="scss" scoped>
.scan-page {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background-color: #111827; // bg-gray-900
  color: white;
}

.scan-container {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 40rpx;
}

.scan-box {
  width: 500rpx;
  height: 500rpx;
  border: 2px solid #10b981; // emerald-500
  position: relative;
  background: rgba(16, 185, 129, 0.1);

  .corner {
    position: absolute;
    width: 40rpx;
    height: 40rpx;
    border: 4px solid #10b981;
  }

  .top-left {
    top: -4rpx;
    left: -4rpx;
    border-right: none;
    border-bottom: none;
  }

  .top-right {
    top: -4rpx;
    right: -4rpx;
    border-left: none;
    border-bottom: none;
  }

  .bottom-left {
    bottom: -4rpx;
    left: -4rpx;
    border-right: none;
    border-top: none;
  }

  .bottom-right {
    bottom: -4rpx;
    right: -4rpx;
    border-left: none;
    border-top: none;
  }

  .scan-line {
    position: absolute;
    left: 0;
    top: 50%;
    width: 100%;
    height: 4rpx;
    background: linear-gradient(90deg, transparent, #10b981, transparent);
    animation: scan-animation 2.5s linear infinite;
    transform: translateY(-50%);
  }
}

@keyframes scan-animation {
  0% {
    transform: translateY(-250rpx);
  }
  100% {
    transform: translateY(250rpx);
  }
}

.tips {
  text-align: center;
  margin-top: 40rpx;
  .title {
    font-size: 36rpx;
    font-weight: 600;
    display: block;
    margin-bottom: 16rpx;
  }
  .subtitle {
    font-size: 28rpx;
    color: #9ca3af; // text-gray-400
    white-space: pre-wrap;
  }
}

.actions {
  display: flex;
  gap: 80rpx;
  margin-top: 60rpx;
  .action-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    .action-text {
      font-size: 24rpx;
      color: #d1d5db; // text-gray-300
      margin-top: 8rpx;
    }
  }
}

.bottom-tip {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20rpx;
  background-color: #374151; // bg-gray-800
  .bottom-tip-text {
    margin-left: 10rpx;
    font-size: 26rpx;
    color: #d1d5db; // text-gray-300
  }
}
</style>