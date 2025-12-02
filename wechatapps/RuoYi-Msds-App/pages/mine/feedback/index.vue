<template>
  <view class="page-container">
    <!-- 背景图片/效果 -->
    <view class="glass-bg"></view>

    <!-- 自定义导航栏 -->
    <u-navbar
      title="意见反馈"
      :autoBack="true"
      :bgColor="'transparent'"
      :titleStyle="{color: '#1d1d1f', fontWeight: '600'}"
      leftIconColor="#007AFF"
    >
    </u-navbar>

    <view class="content-wrapper" :style="{ paddingTop: (statusBarHeight + 44) + 'px' }">
      <view class="glass-card form-container">
        <u--form
          labelPosition="top"
          :model="form"
          :rules="rules"
          ref="form"
          labelWidth="auto"
        >
          <u-form-item
            label="反馈类型"
            prop="type"
            borderBottom
            ref="item1"
          >
            <u-radio-group v-model="form.type">
              <u-radio
                v-for="(item, index) in feedbackTypes"
                :key="index"
                :label="item.name"
                :name="item.name"
                :customStyle="{marginRight: '16px'}"
                activeColor="#007AFF"
              ></u-radio>
            </u-radio-group>
          </u-form-item>

          <u-form-item
            label="反馈内容"
            prop="content"
            borderBottom
            ref="item2"
          >
            <u--textarea
              v-model="form.content"
              placeholder="请详细描述您遇到的问题或建议..."
              count
              maxlength="500"
              border="none"
              height="150"
            ></u--textarea>
          </u-form-item>

          <u-form-item
            label="联系方式 (选填)"
            prop="contact"
            borderBottom
            ref="item3"
          >
            <u--input
              v-model="form.contact"
              border="none"
              placeholder="请留下您的手机号或邮箱，方便我们联系您"
            ></u--input>
          </u-form-item>
          
          <u-form-item label="图片上传 (选填)">
            <u-upload
              :fileList="fileList"
              @afterRead="afterRead"
              @delete="deletePic"
              name="1"
              multiple
              :maxCount="3"
            ></u-upload>
          </u-form-item>
        </u--form>

        <view class="btn-group">
          <u-button
            text="提交反馈"
            color="linear-gradient(to right, #007AFF, #5856D6)"
            shape="circle"
            :customStyle="{height: '44px', boxShadow: '0 4px 12px rgba(0, 122, 255, 0.3)'}"
            @click="submit"
            :loading="loading"
          ></u-button>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
  export default {
    data() {
      return {
        statusBarHeight: 0,
        loading: false,
        form: {
          type: '功能异常',
          content: '',
          contact: ''
        },
        fileList: [],
        feedbackTypes: [
          { name: '功能异常' },
          { name: '产品建议' },
          { name: '其他问题' }
        ],
        rules: {
          type: {
            type: 'string',
            required: true,
            message: '请选择反馈类型',
            trigger: ['change']
          },
          content: {
            type: 'string',
            required: true,
            message: '请输入反馈内容',
            trigger: ['blur', 'change']
          }
        }
      }
    },
    onLoad() {
      const systemInfo = uni.getSystemInfoSync();
      this.statusBarHeight = systemInfo.statusBarHeight;
    },
    onReady() {
      this.$refs.form.setRules(this.rules)
    },
    methods: {
      deletePic(event) {
        this.fileList.splice(event.index, 1)
      },
      async afterRead(event) {
        // 当设置 multiple 为 true 时, file 为数组格式，否则为对象格式
        let lists = [].concat(event.file)
        let fileListLen = this.fileList.length
        lists.map((item) => {
          this.fileList.push({
            ...item,
            status: 'uploading',
            message: '上传中'
          })
        })
        for (let i = 0; i < lists.length; i++) {
          const result = await this.uploadFilePromise(lists[i].url)
          let item = this.fileList[fileListLen]
          this.fileList.splice(fileListLen, 1, Object.assign(item, {
            status: 'success',
            message: '',
            url: result
          }))
          fileListLen++
        }
      },
      uploadFilePromise(url) {
        return new Promise((resolve, reject) => {
          // 模拟上传
          setTimeout(() => {
            resolve(url)
          }, 1000)
        })
      },
      submit() {
        this.$refs.form.validate().then(res => {
          this.loading = true;
          // 模拟提交请求
          setTimeout(() => {
            this.loading = false;
            this.$modal.msgSuccess("反馈提交成功，感谢您的宝贵意见！");
            setTimeout(() => {
              uni.navigateBack();
            }, 1500);
          }, 1500);
        }).catch(errors => {
          uni.$u.toast('请填写必填项');
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
    padding: 20px;
    overflow: hidden;
  }

  .btn-group {
    margin-top: 30px;
  }
</style>
