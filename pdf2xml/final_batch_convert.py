#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
最终批量转换 - 使用优化后的解析器
"""

import sys
from pathlib import Path

# 添加当前目录到Python路径
sys.path.insert(0, str(Path(__file__).parent))

from batch_convert_specific import SpecificFormatBatchConverter

def main():
    """主函数"""
    print("="*80)
    print("MSDS PDF最终批量转换 - 使用优化后的解析器")
    print("="*80)
    
    # 配置
    INPUT_DIR = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\aboutproject\doc"
    OUTPUT_DIR = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\pdf2xml\output"
    WORKERS = 4
    
    print(f"输入目录: {INPUT_DIR}")
    print(f"输出目录: {OUTPUT_DIR}")
    print(f"线程数: {WORKERS}")
    print(f"模式: 强制重新转换所有文件")
    print()
    
    # 创建转换器
    converter = SpecificFormatBatchConverter(
        input_dir=INPUT_DIR,
        output_dir=OUTPUT_DIR,
        max_workers=WORKERS
    )
    
    # 执行转换（强制覆盖）
    print("开始批量转换...")
    converter.convert_batch(skip_existing=False)
    
    # 显示摘要（跳过emoji）
    stats = converter.stats
    print("\n" + "="*80)
    print("转换完成！")
    print("="*80)
    print(f"总文件数: {stats['total']}")
    print(f"成功: {stats['success']}")
    print(f"失败: {stats['failed']}")
    print(f"跳过: {stats['skipped']}")
    success_rate = (stats['success'] / stats['total'] * 100) if stats['total'] > 0 else 0
    print(f"成功率: {success_rate:.2f}%")
    
    if stats.get('start_time') and stats.get('end_time'):
        from datetime import datetime
        duration = (stats['end_time'] - stats['start_time']).total_seconds()
        print(f"耗时: {duration:.2f} 秒")
        if duration > 0:
            speed = stats['success'] / duration
            print(f"速度: {speed:.2f} 文件/秒")
    
    print("="*80)
    print(f"\n输出目录: {OUTPUT_DIR}")
    print("转换完成！可以查看output目录中的XML文件")
    
    return 0

if __name__ == '__main__':
    sys.exit(main())

