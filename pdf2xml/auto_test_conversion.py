#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
自动化测试转换脚本
无需用户交互，直接执行转换
"""

import sys
from pathlib import Path

# 添加当前目录到Python路径
sys.path.insert(0, str(Path(__file__).parent))

from batch_convert_specific import SpecificFormatBatchConverter

def main():
    """主函数"""
    print("=" * 80)
    print("MSDS PDF特定格式自动化转换测试")
    print("=" * 80)
    
    # 配置路径
    INPUT_DIR = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\aboutproject\doc"
    OUTPUT_DIR = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\pdf2xml\output"
    WORKERS = 4
    
    print(f"输入目录: {INPUT_DIR}")
    print(f"输出目录: {OUTPUT_DIR}")
    print(f"线程数: {WORKERS}")
    print()
    
    # 创建转换器
    try:
        converter = SpecificFormatBatchConverter(
            input_dir=INPUT_DIR,
            output_dir=OUTPUT_DIR,
            max_workers=WORKERS
        )
        print("转换器初始化成功")
    except Exception as e:
        print(f"转换器初始化失败: {e}")
        return 1
    
    # 执行转换
    try:
        print("开始批量转换...")
        converter.convert_batch(skip_existing=True)
        
        # 显示结果摘要
        converter.print_summary()
        
        print("\n转换完成！")
        print(f"输出目录: {OUTPUT_DIR}")
        print(f"转换报告: {OUTPUT_DIR}/specific_format_conversion_report.json")
        
        return 0
        
    except Exception as e:
        print(f"\n转换失败: {e}")
        import traceback
        traceback.print_exc()
        return 1


if __name__ == '__main__':
    sys.exit(main())
