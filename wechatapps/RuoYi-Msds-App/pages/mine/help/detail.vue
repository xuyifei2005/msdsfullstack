<template>
  <view class="help-detail-container">
    <!-- Glass Background -->
    <view class="glass-bg"></view>
    
    <!-- Custom Navbar -->
    <u-navbar
      title="问题详情"
      :autoBack="true"
      placeholder
      bgColor="transparent"
      leftIconColor="#333"
      titleStyle="color: #333; font-weight: 600;"
    ></u-navbar>

    <view class="content-wrapper">
      <view class="detail-card glass-card">
        <view class="question-title">{{ faq.title }}</view>
        <view class="question-meta">
          <text class="date">{{ faq.createTime }}</text>
        </view>
        <view class="divider"></view>
        <view class="answer-content">
          <u-parse :content="faq.answer" :selectable="true"></u-parse>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
  export default {
    data() {
      return {
        faq: {
          title: '',
          answer: '',
          createTime: ''
        }
      }
    },
    onLoad() {
      const faq = uni.getStorageSync('currentFaq');
      if (faq) {
        this.faq = faq;
      }
    }
  }
</script>

<style lang="scss" scoped>
  page {
    background-color: #f5f7fa;
  }

  .help-detail-container {
    position: relative;
    min-height: 100vh;
  }

  /* Glass Background Animation */
  .glass-bg {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-image: url('https://images.unsplash.com/photo-1579546929518-9e396f3cc809?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHx8&w=1000&q=80');
    background-size: cover;
    background-position: center;
    opacity: 0.15;
    z-index: 0;
    filter: saturate(1.2) brightness(1.1);
    pointer-events: none;
    animation: subtle-move 30s infinite alternate ease-in-out;
  }

  @keyframes subtle-move {
    0% { transform: scale(1.0); }
    100% { transform: scale(1.05); }
  }

  .content-wrapper {
    position: relative;
    z-index: 1;
    padding: 20rpx;
  }

  .glass-card {
    background: rgba(255, 255, 255, 0.65);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border-radius: 24rpx;
    border: 1px solid rgba(255, 255, 255, 0.4);
    box-shadow: 0 8rpx 32rpx rgba(31, 38, 135, 0.07);
    padding: 30rpx;
  }

  .question-title {
    font-size: 36rpx;
    font-weight: bold;
    color: #333;
    margin-bottom: 16rpx;
    line-height: 1.4;
  }

  .question-meta {
    font-size: 24rpx;
    color: #999;
    margin-bottom: 20rpx;
  }

  .divider {
    height: 1px;
    background: rgba(0, 0, 0, 0.05);
    margin-bottom: 30rpx;
  }

  .answer-content {
    font-size: 30rpx;
    color: #555;
    line-height: 1.6;
  }
</style>
