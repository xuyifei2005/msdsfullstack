#!/usr/bin/env node

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

/**
 * 快速安全修复脚本
 * 用法: node scripts/quick-fix.js [--force]
 */

class QuickSecurityFix {
  constructor(options = {}) {
    this.force = options.force || false;
    this.backupDir = path.join(__dirname, '../backups');
    this.logFile = path.join(__dirname, '../logs/quick-fix.log');
    this.ensureDirectories();
  }

  ensureDirectories() {
    [this.backupDir, path.dirname(this.logFile)].forEach(dir => {
      if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
      }
    });
  }

  log(message, level = 'INFO') {
    const timestamp = new Date().toISOString();
    const logMessage = `[${timestamp}] [${level}] ${message}`;
    console.log(logMessage);
    fs.appendFileSync(this.logFile, logMessage + '\n');
  }

  async createBackup() {
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
    const backupPath = path.join(this.backupDir, `backup-${timestamp}`);
    
    this.log(`创建备份到: ${backupPath}`);
    
    try {
      // 创建备份目录
      fs.mkdirSync(backupPath, { recursive: true });
      
      // 备份关键文件
      const filesToBackup = ['package.json', 'package-lock.json'];
      
      filesToBackup.forEach(file => {
        if (fs.existsSync(file)) {
          fs.copyFileSync(file, path.join(backupPath, file));
          this.log(`备份文件: ${file}`);
        }
      });
      
      this.log('备份创建完成');
      return backupPath;
      
    } catch (error) {
      this.log(`备份创建失败: ${error.message}`, 'ERROR');
      throw error;
    }
  }

  async runAuditFix() {
    this.log('开始执行 npm audit fix');
    
    try {
      const command = this.force ? 'npm audit fix --force' : 'npm audit fix';
      this.log(`执行命令: ${command}`);
      
      execSync(command, { 
        stdio: 'inherit',
        cwd: process.cwd()
      });
      
      this.log('npm audit fix 执行完成');
      return true;
      
    } catch (error) {
      this.log(`npm audit fix 执行失败: ${error.message}`, 'ERROR');
      return false;
    }
  }

  async updateSpecificPackages() {
    this.log('更新特定的安全包');
    
    // 基于我们之前的分析，这些包需要特别关注
    const packagesToUpdate = [
      'postcss',
      'tough-cookie', 
      'underscore'
    ];
    
    for (const pkg of packagesToUpdate) {
      try {
        this.log(`尝试更新包: ${pkg}`);
        execSync(`npm update ${pkg}`, { 
          stdio: 'inherit',
          cwd: process.cwd()
        });
        this.log(`成功更新包: ${pkg}`);
      } catch (error) {
        this.log(`更新包 ${pkg} 失败: ${error.message}`, 'WARN');
      }
    }
  }

  async verifyFix() {
    this.log('验证修复结果');
    
    try {
      // 重新运行audit检查
      const auditOutput = execSync('npm audit --json', { 
        encoding: 'utf8',
        stdio: ['pipe', 'pipe', 'pipe']
      });
      
      const auditData = JSON.parse(auditOutput);
      const vulnerabilities = auditData.metadata?.vulnerabilities || {};
      
      const criticalAndHigh = (vulnerabilities.critical || 0) + (vulnerabilities.high || 0);
      
      if (criticalAndHigh === 0) {
        this.log('✅ 验证成功：没有严重或高危漏洞', 'SUCCESS');
        return true;
      } else {
        this.log(`⚠️  仍存在 ${criticalAndHigh} 个严重/高危漏洞`, 'WARN');
        return false;
      }
      
    } catch (error) {
      this.log(`验证过程出错: ${error.message}`, 'ERROR');
      return false;
    }
  }

  async runTests() {
    this.log('运行测试以确保修复没有破坏功能');
    
    try {
      // 检查是否有测试脚本
      const packageJson = JSON.parse(fs.readFileSync('package.json', 'utf8'));
      
      if (packageJson.scripts && packageJson.scripts.test) {
        this.log('发现测试脚本，开始运行测试');
        execSync('npm test', { 
          stdio: 'inherit',
          cwd: process.cwd()
        });
        this.log('✅ 所有测试通过');
        return true;
      } else {
        this.log('没有发现测试脚本，跳过测试', 'WARN');
        return true;
      }
      
    } catch (error) {
      this.log(`测试失败: ${error.message}`, 'ERROR');
      return false;
    }
  }

  async execute() {
    console.log('🚀 开始快速安全修复流程...');
    
    try {
      // 1. 创建备份
      const backupPath = await this.createBackup();
      
      // 2. 执行audit fix
      const auditSuccess = await this.runAuditFix();
      
      if (!auditSuccess && !this.force) {
        console.log('\n❌ npm audit fix 失败');
        console.log('💡 尝试运行: node scripts/quick-fix.js --force');
        return false;
      }
      
      // 3. 更新特定包
      await this.updateSpecificPackages();
      
      // 4. 验证修复
      const verifySuccess = await this.verifyFix();
      
      // 5. 运行测试
      const testSuccess = await this.runTests();
      
      // 总结结果
      console.log('\n' + '='.repeat(60));
      console.log('📊 修复结果摘要');
      console.log('='.repeat(60));
      console.log(`备份位置: ${backupPath}`);
      console.log(`Audit修复: ${auditSuccess ? '✅ 成功' : '❌ 失败'}`);
      console.log(`验证结果: ${verifySuccess ? '✅ 通过' : '⚠️  需要关注'}`);
      console.log(`测试结果: ${testSuccess ? '✅ 通过' : '❌ 失败'}`);
      
      if (verifySuccess && testSuccess) {
        console.log('\n🎉 快速修复完成！项目安全性已提升');
      } else {
        console.log('\n⚠️  修复部分完成，建议手动检查剩余问题');
      }
      
      console.log('\n📋 详细日志:', this.logFile);
      
      return verifySuccess && testSuccess;
      
    } catch (error) {
      this.log(`修复流程失败: ${error.message}`, 'ERROR');
      console.error('❌ 修复流程失败:', error.message);
      return false;
    }
  }
}

// 主执行函数
async function main() {
  const args = process.argv.slice(2);
  const force = args.includes('--force');
  
  const fixer = new QuickSecurityFix({ force });
  
  try {
    const success = await fixer.execute();
    process.exit(success ? 0 : 1);
  } catch (error) {
    console.error('❌ 执行失败:', error.message);
    process.exit(1);
  }
}

// 如果直接运行此脚本
if (require.main === module) {
  main();
}

module.exports = QuickSecurityFix;