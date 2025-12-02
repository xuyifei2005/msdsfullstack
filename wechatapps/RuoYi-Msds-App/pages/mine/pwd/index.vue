<template>
  <view class="pwd-retrieve-container">
    <!-- Glass Background -->
    <view class="glass-bg"></view>
    
    <!-- Custom Navbar -->
    <u-navbar
      title="修改密码"
      :autoBack="true"
      placeholder
      bgColor="transparent"
      leftIconColor="#333"
      titleStyle="color: #333; font-weight: 600;"
    ></u-navbar>

    <view class="content-wrapper">
      <view class="glass-card">
        <u--form
          labelPosition="left"
          :model="user"
          :rules="rules"
          ref="form"
          labelWidth="80"
        >
          <u-form-item
            label="旧密码"
            prop="oldPassword"
            borderBottom
            ref="item1"
          >
            <u--input
              type="password"
              v-model="user.oldPassword"
              border="none"
              placeholder="请输入旧密码"
            ></u--input>
          </u-form-item>
          <u-form-item
            label="新密码"
            prop="newPassword"
            borderBottom
            ref="item2"
          >
            <u--input
              type="password"
              v-model="user.newPassword"
              border="none"
              placeholder="请输入新密码"
            ></u--input>
          </u-form-item>
          <u-form-item
            label="确认密码"
            prop="confirmPassword"
            borderBottom
            ref="item3"
          >
            <u--input
              type="password"
              v-model="user.confirmPassword"
              border="none"
              placeholder="请确认新密码"
            ></u--input>
          </u-form-item>
        </u--form>

        <view class="action-btn-group">
          <u-button
            type="primary"
            text="提交"
            customStyle="background: rgba(0, 122, 255, 0.85); border: none; margin-top: 40rpx; border-radius: 16rpx; backdrop-filter: blur(5px);"
            @click="submit"
          ></u-button>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
  import { updateUserPwd } from "@/api/system/user"

  export default {
    data() {
      return {
        user: {
          oldPassword: '',
          newPassword: '',
          confirmPassword: ''
        },
        rules: {
          oldPassword: [
            {
              required: true,
              message: '旧密码不能为空',
              trigger: ['blur', 'change']
            }
          ],
          newPassword: [
            {
              required: true,
              message: '新密码不能为空',
              trigger: ['blur', 'change']
            },
            {
              min: 6,
              max: 20,
              message: '长度在 6 到 20 个字符',
              trigger: ['blur', 'change']
            }
          ],
          confirmPassword: [
            {
              required: true,
              message: '确认密码不能为空',
              trigger: ['blur', 'change']
            },
            {
              validator: (rule, value, callback) => {
                return value === this.user.newPassword;
              },
              message: '两次输入的密码不一致',
              trigger: ['blur', 'change']
            }
          ]
        }
      }
    },
    onReady() {
      this.$refs.form.setRules(this.rules)
    },
    methods: {
      submit() {
        this.$refs.form.validate().then(res => {
          updateUserPwd(this.user.oldPassword, this.user.newPassword).then(response => {
            this.$modal.msgSuccess("修改成功")
            setTimeout(() => {
                uni.navigateBack()
            }, 1500)
          })
        }).catch(errors => {
          // uni.$u.toast('校验失败')
        })
      }
    }
  }
</script>

<style lang="scss" scoped>
  page {
    background-color: #f5f7fa;
  }

  .pwd-retrieve-container {
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

  .glass-card {
    background: rgba(255, 255, 255, 0.65);
    backdrop-filter: blur(16px) saturate(180%);
    -webkit-backdrop-filter: blur(16px) saturate(180%);
    border-radius: 24rpx;
    border: 1px solid rgba(255, 255, 255, 0.5);
    padding: 40rpx 30rpx;
    box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.07);
  }

  .action-btn-group {
    margin-top: 20rpx;
  }
</style>
