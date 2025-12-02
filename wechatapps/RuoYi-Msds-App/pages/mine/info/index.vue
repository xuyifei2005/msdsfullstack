<template>
  <view class="page-container">
    <!-- 背景图片/效果 -->
    <view class="glass-bg"></view>

    <!-- 自定义导航栏 -->
    <u-navbar
      title="个人信息"
      :autoBack="true"
      :bgColor="'transparent'"
      :titleStyle="{color: '#1d1d1f', fontWeight: '600'}"
      leftIconColor="#007AFF"
    >
    </u-navbar>

    <view class="content-wrapper" :style="{ paddingTop: (statusBarHeight + 44) + 'px' }">
      <!-- 信息卡片 -->
      <view class="info-card glass-card">
        <u-cell-group :border="false">
          <u-cell
            title="昵称"
            :value="user.nickName"
            :isLink="true"
            url="/pages/mine/info/edit"
          >
            <template #icon>
              <uni-icons type="person-filled" color="#007AFF" size="20" style="margin-right: 4px;"></uni-icons>
            </template>
          </u-cell>
          <u-cell
            title="手机号码"
            :value="user.phonenumber"
          >
            <template #icon>
              <uni-icons type="phone-filled" color="#34C759" size="20" style="margin-right: 4px;"></uni-icons>
            </template>
          </u-cell>
          <u-cell
            title="邮箱"
            :value="user.email"
          >
            <template #icon>
              <uni-icons type="email-filled" color="#5856D6" size="20" style="margin-right: 4px;"></uni-icons>
            </template>
          </u-cell>
          <u-cell
            title="岗位"
            :value="postGroup"
          >
            <template #icon>
              <uni-icons type="location-filled" color="#FF9500" size="20" style="margin-right: 4px;"></uni-icons>
            </template>
          </u-cell>
          <u-cell
            title="角色"
            :value="roleGroup"
          >
            <template #icon>
              <uni-icons type="personadd-filled" color="#FF2D55" size="20" style="margin-right: 4px;"></uni-icons>
            </template>
          </u-cell>
          <u-cell
            title="创建日期"
            :value="user.createTime"
          >
            <template #icon>
              <uni-icons type="calendar-filled" color="#5AC8FA" size="20" style="margin-right: 4px;"></uni-icons>
            </template>
          </u-cell>
        </u-cell-group>
      </view>
      
      <view class="tips">
        <uni-icons type="info-filled" color="#8e8e93" size="14"></uni-icons>
        <text class="tips-text">点击"昵称"可编辑部分个人信息</text>
      </view>
    </view>
  </view>
</template>

<script>
  import { getUserProfile } from "@/api/system/user"

  export default {
    data() {
      return {
        statusBarHeight: 0,
        user: {},
        roleGroup: "",
        postGroup: ""
      }
    },
    onLoad() {
      const systemInfo = uni.getSystemInfoSync();
      this.statusBarHeight = systemInfo.statusBarHeight;
      this.getUser()
    },
    methods: {
      getUser() {
        getUserProfile().then(response => {
          this.user = response.data
          this.roleGroup = response.roleGroup
          this.postGroup = response.postGroup
        })
      }
    }
  }
</script>

<style lang="scss" scoped>
  .page-container {
    min-height: 100vh;
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
    opacity: 0.15;
    z-index: 0;
    filter: saturate(1.2) brightness(1.1);
    pointer-events: none;
    animation: subtle-move 30s infinite alternate ease-in-out;
  }

  @keyframes subtle-move {
    0% { background-position: 0% 0%; transform: scale(1.0); }
    100% { background-position: 100% 100%; transform: scale(1.05); }
  }

  .content-wrapper {
    position: relative;
    z-index: 1;
    padding: 20px 16px;
  }

  .glass-card {
    background: rgba(255, 255, 255, 0.7);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border: 1px solid rgba(255, 255, 255, 0.5);
    box-shadow: 0 8px 32px rgba(31, 38, 135, 0.05);
    border-radius: 16px;
    overflow: hidden;
  }
  
  .tips {
    display: flex;
    align-items: center;
    justify-content: center;
    margin-top: 20px;
    opacity: 0.6;
  }
  
  .tips-text {
    font-size: 12px;
    color: #8e8e93;
    margin-left: 4px;
  }
</style>
