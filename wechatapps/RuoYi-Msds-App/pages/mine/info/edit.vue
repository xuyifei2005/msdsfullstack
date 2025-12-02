<template>
  <view class="page-container">
    <!-- 背景图片/效果 -->
    <view class="glass-bg"></view>

    <!-- 自定义导航栏 -->
    <u-navbar
      title="编辑资料"
      :autoBack="true"
      :bgColor="'transparent'"
      :titleStyle="{color: '#1d1d1f', fontWeight: '600'}"
      leftIconColor="#007AFF"
    >
    </u-navbar>

    <view class="content-wrapper" :style="{ paddingTop: (statusBarHeight + 44) + 'px' }">
      <view class="glass-card form-container">
        <u--form
          labelPosition="left"
          :model="user"
          :rules="rules"
          ref="form"
          labelWidth="80"
        >
          <u-form-item
            label="用户昵称"
            prop="nickName"
            borderBottom
            ref="item1"
          >
            <u--input
              v-model="user.nickName"
              border="none"
              placeholder="请输入昵称"
            ></u--input>
          </u-form-item>
          
          <u-form-item
            label="手机号码"
            prop="phonenumber"
            borderBottom
            ref="item2"
          >
            <u--input
              v-model="user.phonenumber"
              border="none"
              placeholder="请输入手机号码"
            ></u--input>
          </u-form-item>

          <u-form-item
            label="邮箱"
            prop="email"
            borderBottom
            ref="item3"
          >
            <u--input
              v-model="user.email"
              border="none"
              placeholder="请输入邮箱"
            ></u--input>
          </u-form-item>

          <u-form-item
            label="性别"
            prop="sex"
            borderBottom
            ref="item4"
          >
            <u-radio-group v-model="user.sex">
              <u-radio
                v-for="(item, index) in sexs"
                :key="index"
                :label="item.text"
                :name="item.value"
                :customStyle="{marginRight: '20px'}"
                activeColor="#007AFF"
              ></u-radio>
            </u-radio-group>
          </u-form-item>
        </u--form>

        <view class="btn-group">
          <u-button
            text="提交修改"
            color="linear-gradient(to right, #007AFF, #5856D6)"
            shape="circle"
            :customStyle="{height: '44px', boxShadow: '0 4px 12px rgba(0, 122, 255, 0.3)'}"
            @click="submit"
          ></u-button>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
  import { getUserProfile, updateUserProfile } from "@/api/system/user"

  export default {
    data() {
      return {
        statusBarHeight: 0,
        user: {
          nickName: "",
          phonenumber: "",
          email: "",
          sex: ""
        },
        sexs: [{
          text: '男',
          value: "0"
        }, {
          text: '女',
          value: "1"
        }],
        rules: {
          nickName: {
            type: 'string',
            required: true,
            message: '用户昵称不能为空',
            trigger: ['blur', 'change']
          },
          phonenumber: {
            type: 'string',
            required: true,
            message: '手机号码不能为空',
            trigger: ['blur', 'change'],
            validator: (rule, value, callback) => {
              return uni.$u.test.mobile(value);
            }
          },
          email: {
            type: 'string',
            required: true,
            message: '邮箱地址不能为空',
            trigger: ['blur', 'change'],
            validator: (rule, value, callback) => {
              return uni.$u.test.email(value);
            }
          }
        }
      }
    },
    onLoad() {
      const systemInfo = uni.getSystemInfoSync();
      this.statusBarHeight = systemInfo.statusBarHeight;
      this.getUser()
    },
    onReady() {
      this.$refs.form.setRules(this.rules)
    },
    methods: {
      getUser() {
        getUserProfile().then(response => {
          this.user = response.data
        })
      },
      submit() {
        this.$refs.form.validate().then(res => {
          updateUserProfile(this.user).then(response => {
            this.$modal.msgSuccess("修改成功")
            setTimeout(() => {
                uni.navigateBack()
            }, 1500)
          })
        }).catch(errors => {
          uni.$u.toast('请检查输入内容')
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
  
  .form-container {
    padding: 20px;
  }
  
  .btn-group {
    margin-top: 30px;
    padding: 0 10px;
  }
</style>
