<template>
  <view class="page-container">
    <!-- 背景效果 -->
    <view class="bg-gradient"></view>

    <!-- 自定义导航栏 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-content">
        <view class="nav-left" @click="onBack">
          <uni-icons type="arrow-left" color="#000" size="24"></uni-icons>
        </view>
        <view class="nav-title">化学品详情</view>
        <view class="nav-right">
           <!-- 预留分享或其他按钮 -->
        </view>
      </view>
    </view>

    <!-- 占位符，防止内容被导航栏遮挡 -->
    <view :style="{ height: (44 + statusBarHeight) + 'px' }"></view>

    <!-- 主内容区域 -->
    <view class="content" v-if="loading">
      <view class="loading-container">
        <uni-load-more status="loading" content-text="正在加载MSDS详情..."></uni-load-more>
      </view>
    </view>
    
    <view class="content" v-else>
      <!-- 化学品头部信息 -->
      <view class="chemical-header">
        <view class="header-bg-anim"></view>
        <view class="danger-level-badge" :class="dangerLevelClass">
          {{ chemical.dangerLevel || '一般' }}
        </view>
        
        <view class="name-section" @click="toggleName">
          <view class="chemical-name" :class="{ 'name-expanded': isNameExpanded }">
            {{ chemical.name || '未命名' }}
          </view>
          <view class="name-expand-hint" v-if="chemical.name && chemical.name.length > 20">
            <uni-icons :type="isNameExpanded ? 'up' : 'down'" color="rgba(255,255,255,0.8)" size="14"></uni-icons>
          </view>
        </view>
        
        <view class="chemical-meta">
            <view class="meta-item" @click.stop="handleCopyCas">
                <text class="meta-label">CAS</text>
                <text class="meta-value">{{ chemical.cas || '-' }}</text>
                <uni-icons type="copy" color="rgba(255,255,255,0.8)" size="12" style="margin-left: 4px;"></uni-icons>
            </view>
            <view class="meta-item" v-if="chemical.formula">
                <text class="meta-label">分子式</text>
                <text class="meta-value">{{ chemical.formula }}</text>
            </view>
        </view>

        <!-- 快捷理化数据 (新增) -->
        <view class="quick-stats">
            <view class="stat-item">
                <text class="stat-label">分子量</text>
                <text class="stat-value">{{ quickStats.molecularWeight || '-' }}</text>
            </view>
            <view class="stat-item">
                <text class="stat-label">沸点</text>
                <text class="stat-value">{{ quickStats.boilingPoint || '-' }}</text>
            </view>
            <view class="stat-item">
                <text class="stat-label">密度</text>
                <text class="stat-value">{{ quickStats.density || '-' }}</text>
            </view>
            <view class="stat-item">
                <text class="stat-label">闪点</text>
                <text class="stat-value">{{ quickStats.flashPoint || '-' }}</text>
            </view>
        </view>

        <!-- 快捷操作栏 (新增) -->
        <view class="header-actions">
            <view class="action-item" @click="onFavorite">
                <uni-icons :type="isFavorited ? 'heart-filled' : 'heart'" color="#fff" size="20"></uni-icons>
                <text>收藏</text>
            </view>
            <view class="action-item" @click="onShare">
                <uni-icons type="redo" color="#fff" size="20"></uni-icons>
                <text>分享</text>
                <!-- 微信小程序分享按钮遮罩 -->
                <!-- #ifdef MP-WEIXIN -->
                <button open-type="share" class="share-btn-overlay"></button>
                <!-- #endif -->
            </view>
            <view class="action-item" @click="onQRCode">
                <uni-icons type="scan" color="#fff" size="20"></uni-icons>
                <text>二维码</text>
            </view>
        </view>
      </view>



      <!-- 二维码弹窗 -->
      <uni-popup ref="qrPopup" type="center">
        <view class="qr-popup-content">
            <view class="qr-title">化学品二维码</view>
            <image class="qr-image" :src="qrCodeUrl" mode="aspectFit"></image>
            <view class="qr-desc">{{ chemical.name }}</view>
            <view class="qr-cas">CAS: {{ chemical.cas }}</view>
            <button class="qr-close-btn" @click="closeQRCode">关闭</button>
        </view>
      </uni-popup>



      <!-- 基本信息 -->
      <view class="info-card">
        <view class="card-header header-basic">
          <view class="header-icon">
            <uni-icons type="info" color="#fff" size="18"></uni-icons>
          </view>
          <text>基本信息</text>
        </view>
        <view class="card-content">
          <view class="property-row" v-for="(item, index) in basicInfo" :key="index">
            <view class="property-label">{{ item.label }}</view>
            <view class="property-value" @click="handleCopyItem(item)">
                {{ item.value }}
                <uni-icons v-if="item.copy" type="copy" color="#999" size="14" style="margin-left: 4px;"></uni-icons>
            </view>
          </view>
        </view>
      </view>


      <!-- 理化特性 -->
      <view class="info-card" v-if="physicalProps.length > 0">
        <view class="card-header header-physical">
          <view class="header-icon">
            <uni-icons type="eye-filled" color="#fff" size="18"></uni-icons>
          </view>
          <text>理化特性</text>
        </view>
        <view class="card-content">
          <view class="property-row" v-for="(item, index) in physicalProps" :key="index">
            <view class="property-label">{{ item.label }}</view>
            <view class="property-value">{{ item.value }}</view>
          </view>
        </view>
      </view>

      <!-- 危险性信息 (Enhanced) -->
      <view class="info-card" v-if="hazardDetail || hazardInfo.length > 0 || chemical.tags.length > 0">
        <view class="card-header header-danger">
          <uni-icons type="info-filled" color="#fff" size="20" style="margin-right: 8px;"></uni-icons>
          <text>危险性信息</text>
        </view>
        <view class="card-content">
          <!-- GHS Pictograms (Visual Identification) -->
          <view class="ghs-icons-container" v-if="ghsIcons.length > 0">
            <view class="ghs-icon-card" v-for="(icon, index) in ghsIcons" :key="index">
              <view class="ghs-icon-wrapper" :style="{ background: icon.background, boxShadow: '0 4px 12px ' + icon.shadowColor }">
                <uni-icons :type="icon.type" color="#fff" size="28"></uni-icons>
              </view>
              <text class="ghs-label">{{ icon.label }}</text>
            </view>
          </view>

          <!-- Emergency Overview Highlight -->
          <view class="hazard-overview-box" v-if="hazardDetail && hazardDetail.emergencyOverview">
             <view class="hazard-title">
                 <uni-icons type="sound-filled" color="#ff4757" size="16" style="margin-right: 4px;"></uni-icons>
                 紧急情况概述
             </view>
             <text class="hazard-text">{{ hazardDetail.emergencyOverview }}</text>
          </view>

          <!-- Warning Word & Tags -->
          <view class="hazard-meta-row">
              <view class="warning-word-badge" :class="(hazardDetail && hazardDetail.warningWord && hazardDetail.warningWord.includes('危险')) ? 'bg-red' : 'bg-orange'" v-if="hazardDetail && hazardDetail.warningWord">
                  {{ hazardDetail.warningWord }}
              </view>
              <view class="hazard-tags" v-if="chemical.tags.length > 0">
                <view class="hazard-tag" v-for="(tag, index) in chemical.tags" :key="index">
                  <text>{{ tag }}</text>
                </view>
              </view>
          </view>

          <!-- Categories -->
          <view class="hazard-section" v-if="hazardDetail && hazardDetail.hazardCategory">
             <view class="section-label">危险性类别</view>
             <view class="section-content">{{ hazardDetail.hazardCategory }}</view>
          </view>

          <!-- Detailed Hazards -->
           <view class="hazard-section" v-if="hazardDetail && hazardDetail.healthHazards">
             <view class="section-label">健康危害</view>
             <view class="section-content">{{ hazardDetail.healthHazards }}</view>
          </view>
           <view class="hazard-section" v-if="hazardDetail && hazardDetail.environmentalHazards">
             <view class="section-label">环境危害</view>
             <view class="section-content">{{ hazardDetail.environmentalHazards }}</view>
          </view>
           <view class="hazard-section" v-if="hazardDetail && hazardDetail.fireExplosionHazards">
             <view class="section-label">燃爆危险</view>
             <view class="section-content">{{ hazardDetail.fireExplosionHazards }}</view>
          </view>
          
          <!-- Prevention -->
          <view class="hazard-section" v-if="hazardDetail && hazardDetail.preventionMeasures">
             <view class="section-label">预防措施</view>
             <view class="section-content">{{ hazardDetail.preventionMeasures }}</view>
          </view>

          <!-- Fallback to simple list if no detail but hazardInfo exists (compatibility) -->
          <block v-if="!hazardDetail && hazardInfo.length > 0">
              <view class="property-row" v-for="(item, index) in hazardInfo" :key="index">
                <view class="property-label">{{ item.label }}</view>
                <view class="property-value">{{ item.value }}</view>
              </view>
          </block>
        </view>
      </view>

      <!-- 健康危害 (如果有) -->
      <view class="info-card" v-if="healthHazards.length > 0">
        <view class="card-header header-health">
          <uni-icons type="heart" color="#fff" size="20" style="margin-right: 8px;"></uni-icons>
          <text>健康危害</text>
        </view>
        <view class="card-content">
          <view class="safety-item" v-for="(item, index) in healthHazards" :key="index">
            <view class="safety-icon">
              <uni-icons :type="item.icon" color="#fff" size="18"></uni-icons>
            </view>
            <view class="safety-text">
              <text style="font-weight: bold;">{{ item.type }}：</text>
              <text>{{ item.desc }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 急救措施 -->
      <view class="info-card" v-if="firstAid.length > 0">
        <view class="card-header header-firstaid">
          <uni-icons type="plus-filled" color="#fff" size="20" style="margin-right: 8px;"></uni-icons>
          <text>急救措施</text>
        </view>
        <view class="card-content" style="padding: 16px;">
          <!-- Inner Red Container -->
          <view class="first-aid-container">
              <view class="fa-header">
                  <uni-icons type="checkbox-filled" color="#ff4757" size="20" style="margin-right: 8px;"></uni-icons>
                  <text>紧急处理步骤</text>
              </view>
              
              <view class="first-aid-grid">
                <view class="aid-item" v-for="(item, index) in firstAid" :key="index">
                    <view class="aid-icon-box">
                        <uni-icons :type="item.icon" color="#fff" size="28"></uni-icons>
                    </view>
                    <text class="aid-title">{{ item.type }}</text>
                    <text class="aid-desc">{{ item.desc }}</text>
                </view>
              </view>
          </view>

          <!-- Doctor Advice Section -->
          <view class="doctor-advice-box" v-if="doctorAdvice.length > 0">
              <view class="da-header">
                  <uni-icons type="person-filled" color="#2b85e4" size="18" style="margin-right: 6px;"></uni-icons>
                  <text>对医生的提示</text>
              </view>
              <view class="da-list">
                  <view class="da-item" v-for="(item, index) in doctorAdvice" :key="index">
                      <view class="da-dot"></view>
                      <text>{{ item }}</text>
                  </view>
              </view>
          </view>
        </view>
      </view>

      <!-- 泄漏应急处理 -->
      <view class="info-card" v-if="leakResponse.length > 0">
        <view class="card-header header-leak">
          <uni-icons type="fire-filled" color="#fff" size="20" style="margin-right: 8px;"></uni-icons>
          <text>泄漏应急处理</text>
        </view>
        <view class="card-content">
          <view class="property-row" v-for="(item, index) in leakResponse" :key="index">
            <view class="property-label">{{ item.label }}</view>
            <view class="property-value">{{ item.value }}</view>
          </view>
        </view>
      </view>

      <!-- 储存运输 -->
      <view class="info-card" v-if="storageInfo.length > 0">
        <view class="card-header header-storage">
          <uni-icons type="paperplane-filled" color="#fff" size="20" style="margin-right: 8px;"></uni-icons>
          <text>储存运输</text>
        </view>
        <view class="card-content">
          <view class="property-row" v-for="(item, index) in storageInfo" :key="index">
            <view class="property-label">{{ item.label }}</view>
            <view class="property-value">{{ item.value }}</view>
          </view>
        </view>
      </view>

      <!-- 原操作按钮 (移除收藏，保留下载) -->
      <view class="action-buttons">
        <button class="action-btn btn-download" @click="onDownload">
          <uni-icons type="download" color="#fff" size="20"></uni-icons>
          <text>下载MSDS文档</text>
        </button>
      </view>
      







      <!-- 底部留白，防止内容被底部安全区遮挡 -->
      <view class="safe-area-bottom"></view>
    </view>
  </view>
</template>

<script>
import { getMsds, getMsdsFirstAidByMsdsId, getMsdsComponentByMsdsId, getMsdsLeakResponseByMsdsId, getMsdsPhysicalChemicalByMsdsId, getMsdsHazardByMsdsId } from '@/api/msds/msds'
import config from '@/config'

export default {
  data() {
    return {
      statusBarHeight: 20,
      loading: true,
      isFavorited: false,
      isNameExpanded: false,
      chemical: {
        id: '',
        name: '',
        englishName: '',
        formula: '',
        cas: '',
        dangerLevel: '',
        tags: [],
        filePath: '' // Store file path if available
      },
      quickStats: {
        molecularWeight: '',
        boilingPoint: '',
        density: '',
        flashPoint: ''
      },
      qrCodeUrl: '',
      physicalProps: [],
      basicInfo: [],
      hazardInfo: [],
      hazardDetail: null, // New structured hazard data
      doctorAdvice: [], // Doctor's advice list
      healthHazards: [],
      firstAid: [],
      leakResponse: [],
      storageInfo: []
    }
  },
  onLoad(options) {
    const systemInfo = uni.getSystemInfoSync();
    this.statusBarHeight = systemInfo.statusBarHeight;
    
    if (options.id) {
      this.chemical.id = options.id;
      this.fetchData(options.id);
    } else if (options.name || options.cas) {
      this.chemical.name = options.name || '';
      this.chemical.cas = options.cas || '';
      this.loading = false;
    } else {
      this.loading = false;
    }
  },
  // Share to Friends
  onShareAppMessage(res) {
    return {
      title: `MSDS详情: ${this.chemical.name}`,
      path: `/pages/detail/index?id=${this.chemical.id}`,
      imageUrl: '/static/logo.png' // Assuming logo exists
    }
  },
  // Share to Timeline
  onShareTimeline(res) {
    return {
      title: `MSDS详情: ${this.chemical.name}`,
      query: `id=${this.chemical.id}`,
      imageUrl: '/static/logo.png'
    }
  },
  computed: {
    dangerLevelClass() {
      const level = (this.chemical.dangerLevel || '').toString();
      if (level.includes('高') || level.includes('剧毒')) return 'badge-danger';
      if (level.includes('中') || level.includes('警告') || level.includes('危险')) return 'badge-warning';
      return 'badge-normal';
    },
    ghsIcons() {
      const icons = [];
      const text = ((this.hazardDetail && this.hazardDetail.hazardCategory) || '') + 
                   ((this.chemical.tags || []).join(' ')) + 
                   ((this.chemical.dangerLevel || ''));
      
      // Helper to avoid duplicates
      const hasLabel = (label) => icons.some(i => i.label === label);

      // Flammable
      if (text.includes('燃') || text.includes('火')) {
        icons.push({ 
            type: 'fire-filled', 
            background: 'linear-gradient(135deg, #ff4757 0%, #ff6b81 100%)',
            shadowColor: 'rgba(255, 71, 87, 0.3)', 
            label: '易燃' 
        });
      }
      
      // Toxic
      if (text.includes('毒')) {
        if (!hasLabel('有毒')) icons.push({ 
            type: 'close', // Changed from 'clear' to 'close' for better compatibility
            background: 'linear-gradient(135deg, #2ed573 0%, #7bed9f 100%)',
            shadowColor: 'rgba(46, 213, 115, 0.3)',
            label: '有毒' 
        });
      }
      
      // Explosive
      if (text.includes('爆')) {
        icons.push({ 
            type: 'fire-filled', // Reusing fire-filled or use 'warn-filled'
            background: 'linear-gradient(135deg, #ffa502 0%, #ff6348 100%)',
            shadowColor: 'rgba(255, 165, 2, 0.3)',
            label: '爆炸' 
        });
      }

      // Corrosive
      if (text.includes('腐蚀')) {
        icons.push({ 
            type: 'trash', 
            background: 'linear-gradient(135deg, #5352ed 0%, #70a1ff 100%)',
            shadowColor: 'rgba(83, 82, 237, 0.3)',
            label: '腐蚀' 
        });
      }
      
      // Irritant / Health Hazard
      if (text.includes('刺激') || text.includes('过敏') || text.includes('麻醉')) {
        icons.push({ 
            type: 'info-filled', 
            background: 'linear-gradient(135deg, #ff6b81 0%, #ff4757 100%)',
            shadowColor: 'rgba(255, 107, 129, 0.3)',
            label: '刺激' 
        });
      }
      
      // Environment
      if (text.includes('环境') || text.includes('水生')) {
        icons.push({ 
            type: 'image-filled', 
            background: 'linear-gradient(135deg, #1e90ff 0%, #00d2d3 100%)',
            shadowColor: 'rgba(30, 144, 255, 0.3)',
            label: '环境' 
        });
      }
      
      // Precursor Chemicals
      if (text.includes('易制毒')) {
        if (!hasLabel('易制毒')) icons.push({ 
            type: 'locked-filled', 
            background: 'linear-gradient(135deg, #00b894 0%, #55efc4 100%)',
            shadowColor: 'rgba(0, 184, 148, 0.3)',
            label: '易制毒' 
        });
      }
      
      // Precursor Explosives
      if (text.includes('易制爆')) {
         if (!hasLabel('易制爆')) icons.push({ 
             type: 'info-filled', 
             background: 'linear-gradient(135deg, #ff7f50 0%, #ff9f43 100%)',
             shadowColor: 'rgba(255, 127, 80, 0.3)',
             label: '易制爆' 
         });
      }

      // Default Warning
      if (icons.length === 0 && (text.includes('危险') || text.includes('警告'))) {
          icons.push({ 
              type: 'info-filled', 
              background: 'linear-gradient(135deg, #ffa502 0%, #eccc68 100%)',
              shadowColor: 'rgba(255, 165, 2, 0.3)',
              label: '警告' 
          });
      }

      return icons;
    }
  },
  methods: {
    toggleName() {
      this.isNameExpanded = !this.isNameExpanded;
    },
    handleCopyItem(item) {
      if (item && item.copy) {
        this.copyText(item.value, item.label);
      }
    },
    handleCopyCas() {
        this.copyText(this.chemical.cas, 'CAS号');
    },
    copyText(text, label) {
      if (!text || text === '-') return;
      uni.setClipboardData({
        data: text,
        success: () => {
          uni.showToast({
            title: `${label}已复制`,
            icon: 'none'
          });
        }
      });
    },
    async fetchData(id) {
      this.loading = true;
      try {
        // 1. Fetch Main Info
        const mainRes = await getMsds(id);
        const data = mainRes.data;
        
        this.chemical.name = data.productName;
        this.chemical.englishName = data.productEnglishName;
        this.chemical.cas = data.casNumber;
        this.chemical.dangerLevel = data.riskLevel || '一般'; 
        this.chemical.filePath = data.filePath || data.fileName; // Try to catch file path
        
        // Auto-generate tags
        this.chemical.tags = [];
        const risk = (this.chemical.dangerLevel || '').toString();
        const name = (this.chemical.name || '').toLowerCase();
        
        if (risk.includes('高') || risk.includes('剧毒')) {
            this.chemical.tags.push('剧毒品');
            this.chemical.tags.push('危险品');
        } else if (risk.includes('中') || risk.includes('警告') || risk.includes('危险')) {
            this.chemical.tags.push('危险品');
        }
        
        if (name.includes('硝酸') || name.includes('过氧化') || name.includes('氯酸')) {
             this.chemical.tags.push('易制爆');
             this.chemical.tags.push('危险品');
        }
        if (name.includes('硫酸') || name.includes('盐酸') || name.includes('甲苯') || name.includes('丙酮')) {
             this.chemical.tags.push('易制毒');
        }
        
        if (this.chemical.tags.length === 0) {
            this.chemical.tags.push('常用');
        }
        this.chemical.tags = [...new Set(this.chemical.tags)];
        
        // Check favorite status
        this.checkFavoriteStatus();
        
        this.basicInfo = [
          { label: '中文名称', value: data.productName, copy: true },
          { label: '英文名称', value: data.productEnglishName || '-', copy: true },
          { label: 'CAS号', value: data.casNumber || '-', copy: true },
          { label: '供应商', value: data.supplierName || '-' },
          { label: '联系电话', value: data.emergencyPhone || data.supplierPhone || '-', copy: true }
        ];

        // 2. Fetch Components (for formula)
        try {
          const compRes = await getMsdsComponentByMsdsId(id);
          if (compRes.data && compRes.data.length > 0) {
            this.chemical.formula = compRes.data[0].molecularFormula || '-';
            this.basicInfo.push({ 
              label: '主要成分', 
              value: compRes.data.map(c => c.componentName).join(', ') 
            });
          }
        } catch (e) { console.error(e); }

        // 3. Fetch First Aid
        try {
          const firstAidRes = await getMsdsFirstAidByMsdsId(id);
          if (firstAidRes.data) { 
            let fa = firstAidRes.data;
            if (Array.isArray(fa)) fa = fa[0];
            
            if (fa) {
              this.firstAid = [
                { type: '吸入', desc: fa.inhalation || '无资料', icon: 'cloud-upload-filled' },
                { type: '皮肤接触', desc: fa.skinContact || '无资料', icon: 'hand-up-filled' },
                { type: '眼睛接触', desc: fa.eyeContact || '无资料', icon: 'eye-filled' },
                { type: '误食', desc: fa.ingestion || '无资料', icon: 'chat-filled' }
              ];

              // Populate Doctor Advice
              const advice = [];
              if (fa.symptomsEffects) advice.push(fa.symptomsEffects);
              if (fa.immediateMedicalAttention) advice.push(fa.immediateMedicalAttention);
              if (fa.antidoteTreatment) advice.push(fa.antidoteTreatment);
              if (fa.generalNotes) advice.push(fa.generalNotes);
              
              // If no specific advice, add defaults if needed or leave empty
              // Reference image shows specific generic advice, so we can add fallbacks if empty
              if (advice.length === 0) {
                  advice.push('症状治疗，无特效解毒剂');
                  advice.push('监测呼吸和循环系统');
                  advice.push('必要时给予氧气支持');
              }
              this.doctorAdvice = advice;
            }
          }
        } catch (e) { console.error(e); }

        // 4. Fetch Leak Response
        try {
          const leakRes = await getMsdsLeakResponseByMsdsId(id);
          if (leakRes.data) {
            let lr = leakRes.data;
            if (Array.isArray(lr)) lr = lr[0];

            if (lr) {
               this.leakResponse = [
                 { label: '应急处理', value: lr.emergencyAction || '无资料' },
                 { label: '消除方法', value: lr.disposalMethod || '无资料' },
                 { label: '注意事项', value: lr.precaution || '无资料' }
               ];
            }
          }
        } catch (e) { console.error(e); }

        // 5. Fetch Physical Properties
        try {
          const physRes = await getMsdsPhysicalChemicalByMsdsId(id);
          if (physRes.data) {
             let phys = physRes.data;
             if (Array.isArray(phys)) phys = phys[0]; // Handle if list returned
             
             if (phys) {
                // Populate Quick Stats
                this.quickStats = {
                    molecularWeight: phys.molecularWeight,
                    boilingPoint: phys.boilingPoint,
                    density: phys.relativeDensity,
                    flashPoint: phys.flashPoint
                };

                const props = [];
                if (phys.appearance) props.push({ label: '外观与性状', value: phys.appearance });
                if (phys.odor) props.push({ label: '气味', value: phys.odor });
                if (phys.meltingPoint) props.push({ label: '熔点(℃)', value: phys.meltingPoint });
                if (phys.boilingPoint) props.push({ label: '沸点(℃)', value: phys.boilingPoint });
                if (phys.flashPoint) props.push({ label: '闪点(℃)', value: phys.flashPoint });
                if (phys.relativeDensity) props.push({ label: '相对密度', value: phys.relativeDensity });
                if (phys.solubility) props.push({ label: '溶解性', value: phys.solubility });
                this.physicalProps = props;
             }
          }
        } catch (e) { console.error(e); }

        // 6. Fetch Hazard Info (Enhanced)
        try {
          const hazRes = await getMsdsHazardByMsdsId(id);
          if (hazRes.data) {
             let haz = hazRes.data;
             if (Array.isArray(haz)) haz = haz[0];
             
             if (haz) {
                this.hazardDetail = haz;
                
                // Populate basic hazard info list
                const hInfo = [];
                if (haz.warningWord) hInfo.push({ label: '警示词', value: haz.warningWord });
                if (haz.hazardCategory) hInfo.push({ label: '危险性类别', value: haz.hazardCategory });
                // Emergency overview is often long, maybe handle separately or here
                if (haz.emergencyOverview) hInfo.push({ label: '紧急情况概述', value: haz.emergencyOverview });
                
                this.hazardInfo = hInfo;
             }
          }
        } catch (e) { console.error(e); }

      } catch (error) {
        uni.showToast({ title: '获取详情失败', icon: 'none' });
        console.error(error);
      } finally {
        this.loading = false;
      }
    },
    onBack() {
      uni.navigateBack();
    },
    checkFavoriteStatus() {
      const id = this.chemical.id || this.chemical.cas;
      const favorites = uni.getStorageSync('MSDS_FAVORITES') || [];
      this.isFavorited = favorites.some(item => item.id === id || (item.cas && item.cas === id));
    },
    onFavorite() {
      const id = this.chemical.id || this.chemical.cas;
      let favorites = uni.getStorageSync('MSDS_FAVORITES') || [];
      
      if (this.isFavorited) {
        favorites = favorites.filter(item => item.id !== id && item.cas !== id);
        this.isFavorited = false;
        uni.showToast({ title: '已取消收藏', icon: 'none' });
      } else {
        favorites.unshift({
          id: id,
          name: this.chemical.name,
          englishName: this.chemical.englishName || '',
          cas: this.chemical.cas,
          tags: this.chemical.tags,
          addTime: Date.now()
        });
        this.isFavorited = true;
        uni.showToast({ title: '已收藏', icon: 'success' });
      }
      uni.setStorageSync('MSDS_FAVORITES', favorites);
    },
    onDownload() {
      if (!this.chemical.id) return;
      
      // Check if we have a file path or if we can construct one
      // This is a common pattern in RuoYi: /common/download/resource?resource=...
      // But here we might just want to download the MSDS report if generated
      // Or if there is an uploaded file.
      
      // Assuming the standard download URL for RuoYi common files if filePath exists
      let url = '';
      if (this.chemical.filePath) {
          // If it starts with http, use it
          if (this.chemical.filePath.startsWith('http')) {
              url = this.chemical.filePath;
          } else {
              // Append base URL
              url = config.baseUrl + this.chemical.filePath;
          }
      } else {
          // Try to construct a default download or export URL
          // e.g. /system/msds/export/{id}
          // Since we don't know the exact endpoint for PDF generation, we'll simulate a check
          uni.showToast({
            title: '未找到相关文档',
            icon: 'none'
          });
          return;
      }

      uni.showLoading({ title: '下载中...' });
      
      uni.downloadFile({
        url: url,
        success: (res) => {
          if (res.statusCode === 200) {
            uni.openDocument({
              filePath: res.tempFilePath,
              success: function () {
                console.log('打开文档成功');
              },
              fail: function(err) {
                  uni.showToast({ title: '无法打开文档', icon: 'none' });
              }
            });
          } else {
              uni.showToast({ title: '下载失败', icon: 'none' });
          }
        },
        fail: (err) => {
          uni.showToast({ title: '下载请求失败', icon: 'none' });
          console.error(err);
        },
        complete: () => {
          uni.hideLoading();
        }
      });
    },
    onShare() {
        // Handle share logic (mainly for App/H5, WeChat is handled by open-type button)
        // #ifdef APP-PLUS
        uni.share({
            provider: "weixin",
            scene: "WXSceneSession",
            type: 0,
            href: `http://www.yourdomain.com/h5/#/pages/detail/index?id=${this.chemical.id}`,
            title: `MSDS详情: ${this.chemical.name}`,
            summary: `CAS: ${this.chemical.cas}`,
            imageUrl: "/static/logo.png",
            success: function (res) {
                console.log("success:" + JSON.stringify(res));
            },
            fail: function (err) {
                console.log("fail:" + JSON.stringify(err));
            }
        });
        // #endif
    },
    onQRCode() {
        // Generate QR Code URL
        // Using a public API for demo purposes. In production, use a local generator or backend API.
        const data = `MSDS:${this.chemical.id}|${this.chemical.cas}`;
        this.qrCodeUrl = `https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${encodeURIComponent(data)}`;
        this.$refs.qrPopup.open();
    },
    closeQRCode() {
        this.$refs.qrPopup.close();
    }
  }
}
</script>

<style lang="scss" scoped>
.page-container {
  min-height: 100vh;
  background-color: #f5f5f7;
  position: relative;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
}

.loading-container {
  display: flex;
  justify-content: center;
  padding-top: 50px;
}

.bg-gradient {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(180deg, #e0eafc 0%, #cfdef3 100%);
  z-index: 0;
  pointer-events: none;
}

.nav-bar {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  z-index: 100;
  background-color: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(10px);
  border-bottom: 1px solid rgba(0, 0, 0, 0.05);
}

.nav-content {
  height: 44px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 16px;
}

.nav-title {
  font-size: 17px;
  font-weight: 600;
  color: #000;
}

.nav-left, .nav-right {
  width: 40px;
  display: flex;
  align-items: center;
}
.nav-right {
  justify-content: flex-end;
}

.content {
  position: relative;
  z-index: 1;
  padding: 16px;
  padding-bottom: 40px;
}

.chemical-header {
  background: linear-gradient(135deg, #409eff 0%, #2b85e4 100%);
  border-radius: 16px;
  padding: 24px 20px;
  margin-bottom: 20px;
  color: #fff;
  position: relative;
  overflow: hidden;
  box-shadow: 0 8px 24px rgba(43, 133, 228, 0.25);
}

.header-bg-anim {
  position: absolute;
  top: -20px;
  right: -20px;
  width: 200px;
  height: 200px;
  background: radial-gradient(circle at 50% 50%, rgba(255, 255, 255, 0.15) 0%, transparent 70%);
  pointer-events: none;
  border-radius: 50%;
}

.name-section {
  margin-bottom: 20px;
  position: relative;
  z-index: 1;
}

.chemical-name {
  font-size: 24px;
  font-weight: 700;
  color: #fff;
  line-height: 1.4;
  text-shadow: 0 2px 4px rgba(0,0,0,0.1);
  
  /* Truncate logic */
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2; /* Limit to 2 lines by default */
  overflow: hidden;
  transition: all 0.3s ease;
  
  &.name-expanded {
    -webkit-line-clamp: unset;
  }
}

.name-expand-hint {
    text-align: center;
    margin-top: 8px;
    opacity: 0.8;
}

.chemical-meta {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    position: relative;
    z-index: 1;
}

.meta-item {
    background-color: rgba(255, 255, 255, 0.15);
    backdrop-filter: blur(5px);
    padding: 6px 12px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    font-size: 13px;
    border: 1px solid rgba(255, 255, 255, 0.1);
}

.meta-label {
    color: rgba(255, 255, 255, 0.8);
    margin-right: 6px;
}

.meta-value {
    color: #fff;
    font-weight: 600;
    font-family: monospace;
}

.danger-level-badge {
  position: absolute;
  top: 20px;
  right: 20px;
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: bold;
  color: white;
  box-shadow: 0 2px 8px rgba(0,0,0,0.15);
}

.badge-danger { background: linear-gradient(135deg, #ff416c, #ff4b2b); }
.badge-warning { background: linear-gradient(135deg, #f7971e, #ffd200); }
.badge-normal { background: linear-gradient(135deg, #56ab2f, #a8e063); }

.action-buttons {
  display: flex;
  gap: 12px;
  margin-bottom: 20px;
}

.action-btn {
  flex: 1;
  padding: 0;
  height: 48px;
  border-radius: 24px;
  font-size: 15px;
  font-weight: 600;
  display: flex;
  align-items: center;
  justify-content: center;
  border: none;
  
  &::after { border: none; }
  &:active { transform: scale(0.98); }
}

.btn-favorite {
  background-color: #fff;
  color: #666;
  border: 1px solid #eee;
  
  &.is-active {
    background-color: #ff9f43;
    color: #fff;
    border-color: #ff9f43;
  }
}

.btn-download {
  background: linear-gradient(135deg, #0061ff, #60efff);
  color: white;
  box-shadow: 0 4px 15px rgba(0, 97, 255, 0.3);
}

.info-card {
  background-color: #fff;
  border-radius: 16px;
  margin-bottom: 16px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.03);
  overflow: hidden;
}

.card-header {
  padding: 16px;
  font-size: 16px;
  font-weight: 600;
  display: flex;
  align-items: center;
  color: #fff;
}

.header-icon {
    width: 28px;
    height: 28px;
    border-radius: 8px;
    background: rgba(255,255,255,0.2);
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 10px;
}

.header-basic { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
.header-physical { background: linear-gradient(135deg, #8EC5FC 0%, #E0C3FC 100%); }
.header-danger { background: linear-gradient(135deg, #ff758c 0%, #ff7eb3 100%); }
.header-health { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
.header-firstaid { background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); }
.header-leak { background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); }
.header-storage { background: linear-gradient(135deg, #8fd3f4 0%, #84fab0 100%); }

.card-content {
  padding: 0 16px 16px 16px;
}

.property-row {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  padding: 12px 0;
  border-bottom: 1px solid #f5f5f5;
  font-size: 14px;
}

.property-row:last-child {
  border-bottom: none;
}

.property-label {
  color: #999;
  width: 70px;
  flex-shrink: 0;
}

.property-value {
  color: #333;
  text-align: right;
  flex: 1;
  word-break: break-all;
  line-height: 1.4;
}

.hazard-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-top: 12px;
}

.hazard-tag {
  background: #fff0f0;
  color: #ff4757;
  padding: 4px 10px;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 500;
  display: flex;
  align-items: center;
  border: 1px solid rgba(255, 71, 87, 0.2);
}

.safety-item {
  display: flex;
  align-items: flex-start;
  padding: 14px 0;
  border-bottom: 1px solid #f5f5f5;
}

.safety-item:last-child {
  border-bottom: none;
}

.safety-icon {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: #f0f7ff;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 12px;
  flex-shrink: 0;
}

.safety-text {
  flex: 1;
  color: #444;
  font-size: 14px;
  line-height: 1.6;
}

.safe-area-bottom {
  height: 30px;
  height: constant(safe-area-inset-bottom);
  height: env(safe-area-inset-bottom);
}

/* Quick Stats Styles */
.quick-stats {
    display: flex;
    justify-content: space-between;
    margin: 20px 0;
    padding: 16px 0;
    border-top: 1px solid rgba(255, 255, 255, 0.15);
    border-bottom: 1px solid rgba(255, 255, 255, 0.15);
    position: relative;
    z-index: 1;
}

.stat-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    flex: 1;
    position: relative;
    
    &:not(:last-child)::after {
        content: '';
        position: absolute;
        right: 0;
        top: 50%;
        transform: translateY(-50%);
        height: 20px;
        width: 1px;
        background-color: rgba(255, 255, 255, 0.2);
    }
}

.stat-label {
    font-size: 12px;
    color: rgba(255, 255, 255, 0.7);
    margin-bottom: 4px;
}

.stat-value {
    font-size: 16px;
    font-weight: 600;
    color: #fff;
}

/* Header Actions Styles */
.header-actions {
    display: flex;
    justify-content: space-around;
    padding-top: 10px;
    position: relative;
    z-index: 1;
}

.action-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 8px 16px;
    border-radius: 8px;
    background-color: rgba(255, 255, 255, 0.1);
    transition: all 0.2s;
    position: relative;
    
    &:active {
        background-color: rgba(255, 255, 255, 0.2);
        transform: scale(0.95);
    }
    
    text {
        font-size: 12px;
        color: #fff;
        margin-top: 4px;
    }
}

.share-btn-overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    opacity: 0;
    z-index: 2;
}

/* QR Code Popup Styles */
.qr-popup-content {
    background-color: #fff;
    width: 300px;
    border-radius: 16px;
    padding: 24px;
    display: flex;
    flex-direction: column;
    align-items: center;
}

.qr-title {
    font-size: 18px;
    font-weight: 600;
    margin-bottom: 20px;
    color: #333;
}

.qr-image {
    width: 200px;
    height: 200px;
    margin-bottom: 16px;
}

.qr-desc {
    font-size: 16px;
    font-weight: 500;
    color: #333;
    margin-bottom: 4px;
    text-align: center;
}

.qr-cas {
    font-size: 14px;
    color: #666;
    margin-bottom: 24px;
    font-family: monospace;
}

.qr-close-btn {
    width: 100%;
    height: 44px;
    line-height: 44px;
    text-align: center;
    background: #f5f5f5;
    border-radius: 22px;
    color: #666;
    font-size: 15px;
    border: none;
    
    &::after { border: none; }
    &:active { background: #eee; }
}

/* Enhanced Hazard Module Styles */
.hazard-overview-box {
    background-color: #fff0f0;
    border-radius: 12px;
    padding: 16px;
    margin: 16px 0;
    border: 1px solid rgba(255, 71, 87, 0.1);
}

.hazard-title {
    font-size: 15px;
    font-weight: 600;
    color: #ff4757;
    margin-bottom: 8px;
    display: flex;
    align-items: center;
}

.hazard-text {
    font-size: 14px;
    color: #333;
    line-height: 1.6;
    text-align: justify;
}

.hazard-meta-row {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 12px;
    margin-bottom: 16px;
    padding-bottom: 16px;
    border-bottom: 1px solid #f5f5f5;
}

.warning-word-badge {
    padding: 4px 12px;
    border-radius: 6px;
    font-size: 14px;
    font-weight: 600;
    color: #fff;
}

.bg-red { background-color: #ff4757; }
.bg-orange { background-color: #ffa502; }

.hazard-section {
    margin-bottom: 16px;
}

.hazard-section .section-label {
    font-size: 14px;
    font-weight: 600;
    color: #666;
    margin-bottom: 6px;
}

.hazard-section .section-content {
    font-size: 14px;
    color: #333;
    line-height: 1.6;
    background-color: #f8f9fa;
    padding: 12px;
    border-radius: 8px;
}

/* GHS Icons Grid Styles */
.ghs-icons-container {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
    margin-bottom: 16px;
    padding: 16px 0 16px 0; /* Added top padding to fix spacing from header */
    border-bottom: 1px solid #eee;
}

.ghs-icon-card {
    display: flex;
    flex-direction: column;
    align-items: center;
    width: 60px;
}

.ghs-icon-wrapper {
    width: 48px;
    height: 48px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 6px;
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
}

.ghs-label {
    font-size: 12px;
    color: #666;
    text-align: center;
}

/* First Aid Grid Styles */
.first-aid-grid {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
}

.aid-item {
    width: calc(50% - 6px);
    background: linear-gradient(135deg, #ff6b81 0%, #ff4757 100%);
    border-radius: 12px;
    padding: 16px;
    display: flex;
    flex-direction: column;
    align-items: center;
    box-shadow: 0 4px 12px rgba(255, 71, 87, 0.2);
    box-sizing: border-box;
}

.aid-icon-box {
    width: 48px;
    height: 48px;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.2);
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 12px;
}

.aid-info {
    text-align: center;
    width: 100%;
}

.aid-title {
    font-size: 14px;
    font-weight: bold;
    color: #fff;
    margin-bottom: 6px;
    display: block;
}

.aid-desc {
    font-size: 12px;
    color: rgba(255, 255, 255, 0.95);
    line-height: 1.4;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 3;
    overflow: hidden;
}

/* Doctor Advice Styles */
.doctor-advice-box {
    margin-top: 16px;
    padding: 16px;
    background-color: #f8f9fa;
    border-radius: 12px;
    border-left: 4px solid #2b85e4;
}

.da-header {
    font-size: 14px;
    font-weight: bold;
    color: #333;
    margin-bottom: 12px;
    display: flex;
    align-items: center;
}

.da-list {
    padding-left: 4px;
}

.da-item {
    display: flex;
    align-items: flex-start;
    margin-bottom: 8px;
    font-size: 13px;
    color: #555;
    line-height: 1.5;
}

.da-dot {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background-color: #2b85e4;
    margin-top: 7px;
    margin-right: 10px;
    flex-shrink: 0;
}

.fa-header {
    display: flex;
    align-items: center;
    margin-bottom: 12px;
    color: #333;
    font-size: 14px;
    font-weight: bold;
    padding-left: 4px;
}
</style>
