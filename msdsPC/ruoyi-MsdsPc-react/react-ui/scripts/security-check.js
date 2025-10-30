#!/usr/bin/env node

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

class SecurityChecker {
  constructor() {
    this.logsDir = path.join(process.cwd(), 'logs');
    this.reportFile = path.join(this.logsDir, 'security-report.json');
    this.logFile = path.join(this.logsDir, 'security-check.log');
    
    // 确保logs目录存在
    if (!fs.existsSync(this.logsDir)) {
      fs.mkdirSync(this.logsDir, { recursive: true });
    }
  }

  log(message, level = 'INFO') {
    const timestamp = new Date().toISOString();
    const logEntry = `[${timestamp}] [${level}] ${message}`;
    
    console.log(logEntry);
    
    // 写入日志文件
    fs.appendFileSync(this.logFile, logEntry + '\n');
  }

  async runSecurityAudit() {
    try {
      this.log('🔍 开始安全审计...');
      
      // 运行 npm audit --json (忽略退出码，因为有漏洞时会返回非零)
      let auditResult;
      try {
        auditResult = execSync('npm audit --json', { 
          encoding: 'utf8',
          cwd: process.cwd()
        });
      } catch (error) {
        // npm audit 在有漏洞时会返回非零退出码，但stdout仍然包含JSON数据
        if (error.stdout) {
          auditResult = error.stdout;
        } else {
          throw error;
        }
      }
      
      const auditData = JSON.parse(auditResult);
      this.log('✅ 安全审计完成');
      
      // 保存完整报告
      fs.writeFileSync(this.reportFile, JSON.stringify(auditData, null, 2));
      
      // 分析结果
      const summary = this.analyzeAuditResults(auditData);
      
      // 输出摘要
      this.displaySummary(summary);
      
      // 生成建议
      this.generateRecommendations(summary);
      
      return summary;
      
    } catch (error) {
      this.log(`❌ 安全审计失败: ${error.message}`, 'ERROR');
      throw error;
    }
  }

  analyzeAuditResults(auditData) {
    const vulnerabilities = auditData.metadata?.vulnerabilities || {};
    const advisories = auditData.advisories || {};
    
    const summary = {
      total: (vulnerabilities.critical || 0) + (vulnerabilities.high || 0) + 
             (vulnerabilities.moderate || 0) + (vulnerabilities.low || 0),
      critical: vulnerabilities.critical || 0,
      high: vulnerabilities.high || 0,
      moderate: vulnerabilities.moderate || 0,
      low: vulnerabilities.low || 0,
      advisories: Object.keys(advisories).length,
      timestamp: new Date().toISOString()
    };
    
    // 分析主要漏洞包
    const packageVulns = {};
    Object.values(advisories).forEach(advisory => {
      const pkgName = advisory.module_name;
      if (!packageVulns[pkgName]) {
        packageVulns[pkgName] = {
          count: 0,
          severities: [],
          titles: []
        };
      }
      packageVulns[pkgName].count++;
      packageVulns[pkgName].severities.push(advisory.severity);
      packageVulns[pkgName].titles.push(advisory.title);
    });
    
    summary.topVulnerablePackages = Object.entries(packageVulns)
      .sort(([,a], [,b]) => b.count - a.count)
      .slice(0, 10)
      .map(([pkg, data]) => ({ package: pkg, ...data }));
    
    return summary;
  }

  displaySummary(summary) {
    this.log('\n📊 安全审计摘要:');
    this.log(`🔴 严重: ${summary.critical}`);
    this.log(`🟠 高危: ${summary.high}`);
    this.log(`🟡 中危: ${summary.moderate}`);
    this.log(`🔵 低危: ${summary.low}`);
    this.log(`📦 总计: ${summary.total} 个漏洞`);
    
    if (summary.topVulnerablePackages.length > 0) {
      this.log('\n🎯 主要漏洞包:');
      summary.topVulnerablePackages.slice(0, 5).forEach(pkg => {
        this.log(`  - ${pkg.package}: ${pkg.count} 个漏洞`);
      });
    }
  }

  generateRecommendations(summary) {
    this.log('\n💡 修复建议:');
    
    if (summary.total === 0) {
      this.log('✅ 没有发现安全漏洞！');
      return;
    }
    
    if (summary.critical > 0 || summary.high > 0) {
      this.log('🚨 发现严重或高危漏洞，建议立即修复:');
      this.log('   1. 运行: npm audit fix');
      this.log('   2. 如果自动修复失败，运行: node scripts/quick-fix.js');
    }
    
    if (summary.moderate > 10) {
      this.log('⚠️  中危漏洞较多，建议定期更新依赖');
    }
    
    // 检查是否有可自动修复的漏洞
    this.log('\n🔧 尝试自动修复:');
    this.log('   运行: npm audit fix');
    this.log('   强制修复: npm audit fix --force');
    this.log('   使用快速修复脚本: node scripts/quick-fix.js');
  }

  async checkOutdatedPackages() {
    try {
      this.log('\n📦 检查过时包...');
      
      const outdatedResult = execSync('npm outdated --json', { 
        encoding: 'utf8',
        cwd: process.cwd()
      });
      
      const outdatedData = JSON.parse(outdatedResult);
      const outdatedCount = Object.keys(outdatedData).length;
      
      if (outdatedCount > 0) {
        this.log(`📈 发现 ${outdatedCount} 个过时包`);
        
        // 保存过时包报告
        const outdatedFile = path.join(this.logsDir, 'outdated-packages.json');
        fs.writeFileSync(outdatedFile, JSON.stringify(outdatedData, null, 2));
        
        // 显示前5个过时包
        const topOutdated = Object.entries(outdatedData).slice(0, 5);
        topOutdated.forEach(([pkg, info]) => {
          this.log(`  - ${pkg}: ${info.current} → ${info.latest}`);
        });
      } else {
        this.log('✅ 所有包都是最新的');
      }
      
    } catch (error) {
      // npm outdated 在有过时包时也会返回非零退出码
      if (error.stdout) {
        try {
          const outdatedData = JSON.parse(error.stdout);
          const outdatedCount = Object.keys(outdatedData).length;
          this.log(`📈 发现 ${outdatedCount} 个过时包`);
        } catch (parseError) {
          this.log('无法解析过时包信息', 'WARN');
        }
      } else {
        this.log('检查过时包失败', 'WARN');
      }
    }
  }

  async run() {
    try {
      this.log('🚀 开始安全检查流程...');
      
      // 运行安全审计
      const summary = await this.runSecurityAudit();
      
      // 检查过时包
      await this.checkOutdatedPackages();
      
      this.log('\n✅ 安全检查完成！');
      this.log(`📄 详细报告保存在: ${this.reportFile}`);
      this.log(`📋 日志文件: ${this.logFile}`);
      
      // 根据漏洞数量设置退出码
      if (summary.critical > 0) {
        process.exit(2); // 严重漏洞
      } else if (summary.high > 0) {
        process.exit(1); // 高危漏洞
      } else {
        process.exit(0); // 无严重问题
      }
      
    } catch (error) {
      this.log(`❌ 安全检查失败: ${error.message}`, 'ERROR');
      process.exit(3);
    }
  }
}

// 如果直接运行此脚本
if (require.main === module) {
  const checker = new SecurityChecker();
  checker.run();
}

module.exports = SecurityChecker;