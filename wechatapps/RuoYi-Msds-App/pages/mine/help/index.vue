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
  import { listFaq } from "@/api/system/faq";

  export default {
    data() {
      return {
        list: []
      }
    },
    onLoad() {
      this.getList();
    },
    methods: {
      getList() {
        listFaq().then(response => {
          const rows = response.rows;
          // 将扁平的列表转换为页面需要的结构
          // 目前数据库没有分类字段，暂时全部归为"常见问题"
          // 如果后续有分类，可以根据分类字段进行分组
          this.list = [{
            icon: 'iconfont icon-help',
            title: '常见问题',
            childList: rows.map(item => ({
              title: item.question,
              content: item.answer
            }))
          }];
        });
      },
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
