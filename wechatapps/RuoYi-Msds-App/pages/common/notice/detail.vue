<template>
  <view class="container">
    <view class="notice-header">
      <view class="notice-title">{{ notice.noticeTitle }}</view>
      <view class="notice-info">
        <text class="notice-time">{{ notice.createTime }}</text>
        <text class="notice-type" v-if="dict.type.sys_notice_type">
          {{ dict.label.sys_notice_type[notice.noticeType] }}
        </text>
      </view>
    </view>
    
    <view class="notice-content">
      <rich-text :nodes="notice.noticeContent"></rich-text>
    </view>
  </view>
</template>

<script>
import { getNotice } from "@/api/system/notice";

export default {
  dicts: ['sys_notice_type'],
  data() {
    return {
      notice: {
        noticeTitle: '',
        createTime: '',
        noticeContent: ''
      }
    };
  },
  onLoad(options) {
    if (options.noticeId) {
      this.getNoticeDetail(options.noticeId);
    }
  },
  methods: {
    getNoticeDetail(noticeId) {
      getNotice(noticeId).then(response => {
        this.notice = response.data;
      });
    }
  }
};
</script>

<style lang="scss" scoped>
.container {
  padding: 20px;
  background-color: #fff;
  min-height: 100vh;
}

.notice-header {
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 1px solid #eee;
  
  .notice-title {
    font-size: 20px;
    font-weight: bold;
    color: #333;
    margin-bottom: 10px;
    line-height: 1.4;
  }
  
  .notice-info {
    display: flex;
    align-items: center;
    font-size: 12px;
    color: #999;
    
    .notice-time {
      margin-right: 15px;
    }
    
    .notice-type {
      background-color: #e8f4ff;
      color: #007aff;
      padding: 2px 6px;
      border-radius: 4px;
    }
  }
}

.notice-content {
  font-size: 15px;
  color: #666;
  line-height: 1.8;
  
  // 处理图片自适应
  ::v-deep img {
    max-width: 100%;
    height: auto;
  }
}
</style>
