#!/usr/bin/env node

/**
 * MSDS Word文档测试运行脚本
 * 用于执行Word文档上传、解析和处理相关的测试
 */

const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');

// 颜色输出函数
const colors = {
  reset: '\x1b[0m',
  bright: '\x1b[1m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  magenta: '\x1b[35m',
  cyan: '\x1b[36m'
};

function colorLog(message, color = 'reset') {
  console.log(`${colors[color]}${message}${colors.reset}`);
}

// 检查测试文件是否存在
function checkTestFiles() {
  const testFiles = [
    'tests/msds.word.upload.test.tsx',
    'tests/msds.preview.test.tsx',
    'tests/setupTests.jsx'
  ];

  const missingFiles = testFiles.filter(file => {
    const fullPath = path.join(__dirname, '..', file);
    return !fs.existsSync(fullPath);
  });

  if (missingFiles.length > 0) {
    colorLog('❌ 缺少以下测试文件:', 'red');
    missingFiles.forEach(file => colorLog(`   - ${file}`, 'red'));
    return false;
  }

  colorLog('✅ 所有测试文件都存在', 'green');
  return true;
}

// 检查测试数据文件
function checkTestDataFiles() {
  const testDataDir = path.join(__dirname, '..', '..', '..', '..', 'test_msds_files');
  const testDataFiles = [
    'toluene_test.doc',
    'acetone_test.docx',
    'ethanol_special_chars_test.doc',
    'benzene_test.txt'
  ];

  if (!fs.existsSync(testDataDir)) {
    colorLog('❌ 测试数据目录不存在: test_msds_files', 'red');
    return false;
  }

  const missingDataFiles = testDataFiles.filter(file => {
    const fullPath = path.join(testDataDir, file);
    return !fs.existsSync(fullPath);
  });

  if (missingDataFiles.length > 0) {
    colorLog('⚠️  缺少以下测试数据文件:', 'yellow');
    missingDataFiles.forEach(file => colorLog(`   - ${file}`, 'yellow'));
    colorLog('   测试仍可运行，但某些测试用例可能会跳过', 'yellow');
  } else {
    colorLog('✅ 所有测试数据文件都存在', 'green');
  }

  return true;
}

// 运行特定的测试套件
function runTests(testPattern = '', options = {}) {
  const {
    coverage = false,
    watch = false,
    verbose = false,
    reporter = 'default'
  } = options;

  let command = 'npx vitest';
  
  if (testPattern) {
    command += ` ${testPattern}`;
  }
  
  if (coverage) {
    command += ' --coverage';
  }
  
  if (watch) {
    command += ' --watch';
  }
  
  if (verbose) {
    command += ' --reporter=verbose';
  } else if (reporter !== 'default') {
    command += ` --reporter=${reporter}`;
  }

  // 设置配置文件
  command += ' --config tests/vitest.config.ts';

  colorLog(`🚀 执行命令: ${command}`, 'cyan');
  
  try {
    execSync(command, { 
      stdio: 'inherit', 
      cwd: path.join(__dirname, '..'),
      env: { ...process.env, NODE_ENV: 'test' }
    });
    colorLog('✅ 测试执行完成', 'green');
  } catch (error) {
    colorLog('❌ 测试执行失败', 'red');
    process.exit(1);
  }
}

// 主函数
function main() {
  const args = process.argv.slice(2);
  const command = args[0] || 'all';

  colorLog('🧪 MSDS Word文档测试运行器', 'bright');
  colorLog('================================', 'bright');

  // 检查环境
  if (!checkTestFiles()) {
    process.exit(1);
  }
  
  checkTestDataFiles();

  colorLog('\n📋 可用的测试命令:', 'blue');
  colorLog('  all          - 运行所有测试', 'blue');
  colorLog('  word         - 只运行Word文档相关测试', 'blue');
  colorLog('  upload       - 只运行上传功能测试', 'blue');
  colorLog('  preview      - 只运行预览功能测试', 'blue');
  colorLog('  coverage     - 运行测试并生成覆盖率报告', 'blue');
  colorLog('  watch        - 监听模式运行测试', 'blue');
  colorLog('  ci           - CI模式运行测试', 'blue');
  colorLog('');

  switch (command) {
    case 'all':
      colorLog('🔄 运行所有测试...', 'yellow');
      runTests('tests/**/*.test.{ts,tsx}');
      break;
      
    case 'word':
      colorLog('🔄 运行Word文档相关测试...', 'yellow');
      runTests('tests/**/msds.word.*.test.{ts,tsx}');
      break;
      
    case 'upload':
      colorLog('🔄 运行上传功能测试...', 'yellow');
      runTests('tests/msds.word.upload.test.tsx');
      break;
      
    case 'preview':
      colorLog('🔄 运行预览功能测试...', 'yellow');
      runTests('tests/msds.preview.test.tsx');
      break;
      
    case 'coverage':
      colorLog('🔄 运行测试并生成覆盖率报告...', 'yellow');
      runTests('tests/**/*.test.{ts,tsx}', { coverage: true });
      break;
      
    case 'watch':
      colorLog('🔄 监听模式运行测试...', 'yellow');
      runTests('tests/**/*.test.{ts,tsx}', { watch: true });
      break;
      
    case 'ci':
      colorLog('🔄 CI模式运行测试...', 'yellow');
      runTests('tests/**/*.test.{ts,tsx}', { 
        coverage: true, 
        reporter: 'json',
        verbose: true 
      });
      break;
      
    default:
      colorLog(`❌ 未知命令: ${command}`, 'red');
      colorLog('请使用 --help 查看可用命令', 'red');
      process.exit(1);
  }
}

// 处理帮助命令
if (process.argv.includes('--help') || process.argv.includes('-h')) {
  colorLog('🧪 MSDS Word文档测试运行器', 'bright');
  colorLog('================================', 'bright');
  colorLog('');
  colorLog('用法: node scripts/run-word-tests.js [命令]', 'blue');
  colorLog('');
  colorLog('命令:', 'blue');
  colorLog('  all          运行所有测试', 'blue');
  colorLog('  word         只运行Word文档相关测试', 'blue');
  colorLog('  upload       只运行上传功能测试', 'blue');
  colorLog('  preview      只运行预览功能测试', 'blue');
  colorLog('  coverage     运行测试并生成覆盖率报告', 'blue');
  colorLog('  watch        监听模式运行测试', 'blue');
  colorLog('  ci           CI模式运行测试', 'blue');
  colorLog('');
  colorLog('示例:', 'green');
  colorLog('  node scripts/run-word-tests.js word', 'green');
  colorLog('  node scripts/run-word-tests.js coverage', 'green');
  colorLog('  node scripts/run-word-tests.js watch', 'green');
  process.exit(0);
}

// 运行主函数
if (require.main === module) {
  main();
}

module.exports = {
  runTests,
  checkTestFiles,
  checkTestDataFiles
};