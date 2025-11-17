#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
针对特定PDF格式的批量转换启动脚本
专门处理 (1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 类型PDF
"""

import sys
from pathlib import Path

# 添加当前目录到Python路径
sys.path.insert(0, str(Path(__file__).parent))

from batch_convert_specific import SpecificFormatBatchConverter

# 配置路径（请根据实际情况修改）
INPUT_DIR = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\aboutproject\doc"
OUTPUT_DIR = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\pdf2xml\output"
WORKERS = 4  # 线程数，建议设置为CPU核心数

def main():
    """主函数"""
    print("=" * 80)
    print("MSDS PDF特定格式批量转XML工具")
    print("专门处理: (1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 类型PDF")
    print("=" * 80)
    print(f"\n配置信息:")
    print(f"  输入目录: {INPUT_DIR}")
    print(f"  输出目录: {OUTPUT_DIR}")
    print(f"  线程数: {WORKERS}")
    print("\n说明:")
    print("  - 已存在的XML文件会被自动跳过")
    print("  - 按Ctrl+C可随时中断转换")
    print("  - 转换结果会保存在输出目录")
    print("  - 详细日志保存在 logs/specific_format_conversion.log")
    print("  - 转换报告保存在输出目录/specific_format_conversion_report.json")
    print()
    
    # 确认开始
    try:
        response = input("确认开始转换？(输入 y 继续，其他键取消): ")
        if response.lower() != 'y':
            print("已取消转换")
            return 0
    except (KeyboardInterrupt, EOFError):
        print("\n已取消")
        return 0
    
    print("\n开始转换...\n")
    
    # 创建转换器
    try:
        converter = SpecificFormatBatchConverter(
            input_dir=INPUT_DIR,
            output_dir=OUTPUT_DIR,
            max_workers=WORKERS
        )
    except Exception as e:
        print(f"[错误] 初始化失败: {e}")
        return 1
    
    # 执行转换
    try:
        converter.convert_batch(skip_existing=True)
        
        # 显示结果摘要
        converter.print_summary()
        
        print("\n转换完成！")
        print(f"输出目录: {OUTPUT_DIR}")
        print(f"转换报告: {OUTPUT_DIR}/specific_format_conversion_report.json")
        print(f"日志文件: logs/specific_format_conversion.log")
        
        return 0
        
    except KeyboardInterrupt:
        print("\n\n[提示] 用户中断转换")
        print("已转换的文件已保存，下次运行会自动跳过")
        converter.print_summary()
        return 1
    
    except Exception as e:
        print(f"\n[错误] 转换失败: {e}")
        print("\n详细错误信息:")
        import traceback
        traceback.print_exc()
        
        print("\n请检查:")
        print("1. 输入目录是否存在且包含PDF文件")
        print("2. 是否有足够的磁盘空间")
        print("3. 是否安装了所有依赖 (pip install -r requirements.txt)")
        print("4. 查看日志文件获取更多信息: logs/specific_format_conversion.log")
        
        return 1


if __name__ == '__main__':
    exit_code = main()
    
    # Windows下暂停，方便查看结果
    if sys.platform == 'win32':
        input("\n按回车键退出...")
    
    sys.exit(exit_code)
