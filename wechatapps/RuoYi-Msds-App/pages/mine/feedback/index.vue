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
  import { addFeedback } from "@/api/system/feedback";
  import upload from "@/utils/upload";

  export default {
    data() {
      return {
        statusBarHeight: uni.getSystemInfoSync().statusBarHeight,
        loading: false,
        form: {
          type: '功能建议',
          content: '',
          contact: '',
          images: ''
        },
        feedbackTypes: [
          { name: '功能建议' },
          { name: '性能问题' },
          { name: '其他' }
        ],
        fileList: [],
        rules: {
          content: [
            { required: true, message: '请输入反馈内容', trigger: ['blur', 'change'] }
          ]
        }
      }
    },
    methods: {
      // 删除图片
      deletePic(event) {
        this.fileList.splice(event.index, 1)
      },
      // 新增图片
      async afterRead(event) {
        // 当设置 mutiple 为 true 时, file 为数组格式，否则为对象格式
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
          upload({
            url: '/common/upload',
            filePath: url,
            name: 'file'
          }).then(res => {
             // 这里返回完整URL以便前端显示
             resolve(res.url)
          }).catch(err => {
             reject(err)
          })
        })
      },
      submit() {
        this.$refs.form.validate().then(res => {
          this.loading = true;
          // 处理图片
          let images = '';
          if (this.fileList.length > 0) {
            images = this.fileList.map(item => item.url).join(',');
          }
          
          // 构造后端需要的参数结构
          const data = {
            feedbackType: this.form.type,
            content: this.form.content,
            contactInfo: this.form.contact,
            images: images
          };
          
          addFeedback(data).then(response => {
            console.log('Feedback response:', response);
            uni.$u.toast('提交成功，感谢您的反馈！');
            setTimeout(() => {
              uni.navigateBack();
            }, 1500);
          }).catch(err => {
            console.error('Feedback submit error:', err);
            uni.$u.toast('提交失败：' + (err.msg || '未知错误'));
          }).finally(() => {
            this.loading = false;
          });
        }).catch(errors => {
          uni.$u.toast('请完善表单信息');
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
    background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
    z-index: -1;
  }

  .content-wrapper {
    padding: 0 16px 24px;
  }

  .glass-card {
    background: rgba(255, 255, 255, 0.7);
    backdrop-filter: blur(20px);
    border-radius: 24px;
    border: 1px solid rgba(255, 255, 255, 0.8);
    box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.07);
  }

  .form-container {
    padding: 24px 20px;
    margin-bottom: 20px;
  }

  .btn-group {
    margin-top: 32px;
    padding: 0 12px;
  }
</style>