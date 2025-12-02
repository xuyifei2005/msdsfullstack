<template>
  <view class="help-container">
    <!-- Glass Background -->
    <view class="glass-bg"></view>
    
    <!-- Custom Navbar -->
    <u-navbar
      title="常见问题"
      :autoBack="true"
      placeholder
      bgColor="transparent"
      leftIconColor="#333"
      titleStyle="color: #333; font-weight: 600;"
    ></u-navbar>

    <view class="content-wrapper">
      <view v-for="(item, findex) in list" :key="findex" class="section-group">
        <view class="section-title">
          <i :class="item.icon" style="margin-right: 10rpx;"></i> {{ item.title }}
        </view>
        
        <view class="glass-card">
          <u-cell-group :border="false">
            <u-cell
              v-for="(child, zindex) in item.childList"
              :key="zindex"
              :title="child.title"
              :isLink="true"
              @click="handleText(child)"
            ></u-cell>
          </u-cell-group>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
  export default {
    data() {
      return {
        list: [{
            icon: 'iconfont icon-github',
            title: '若依问题',
            childList: [{
              title: '若依开源吗？',
              content: '开源'
            }, {
              title: '若依可以商用吗？',
              content: '可以'
            }, {
              title: '若依官网地址多少？',
              content: 'http://ruoyi.vip'
            }, {
              title: '若依文档地址多少？',
              content: 'http://doc.ruoyi.vip'
            }]
          },
          {
            icon: 'iconfont icon-help',
            title: '其他问题',
            childList: [{
              title: '如何退出登录？',
              content: '请点击[我的] - [应用设置] - [退出登录]即可退出登录',
            }, {
              title: '如何修改用户头像？',
              content: '请点击[我的] - [选择头像] - [点击提交]即可更换用户头像',
            }, {
              title: '如何修改登录密码？',
              content: '请点击[我的] - [应用设置] - [修改密码]即可修改登录密码',
            }]
          }
        ]
      }
    },
    methods: {
      handleText(item) {
        this.$tab.navigateTo(`/pages/common/textview/index?title=${item.title}&content=${item.content}`)
      }
    }
  }
</script>

<style lang="scss" scoped>
  page {
    background-color: #f5f7fa;
  }

  .help-container {
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
    0% { background-position: 0% 0%; transform: scale(1.0); }
    100% { background-position: 100% 100%; transform: scale(1.1); }
  }

  .content-wrapper {
    position: relative;
    z-index: 1;
    padding: 30rpx;
  }

  .section-group {
    margin-bottom: 40rpx;
  }

  .section-title {
    font-size: 30rpx;
    font-weight: 600;
    color: #333;
    margin-bottom: 20rpx;
    padding-left: 10rpx;
    display: flex;
    align-items: center;
  }

  .glass-card {
    background: rgba(255, 255, 255, 0.65);
    backdrop-filter: blur(16px) saturate(180%);
    -webkit-backdrop-filter: blur(16px) saturate(180%);
    border-radius: 24rpx;
    border: 1px solid rgba(255, 255, 255, 0.5);
    overflow: hidden;
    box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.07);
  }
</style>
