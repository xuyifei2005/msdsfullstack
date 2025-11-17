#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
测试单个文件的完整转换
"""

import sys
from pathlib import Path

# 添加当前目录到Python路径
sys.path.insert(0, str(Path(__file__).parent))

from pdf_to_xml import convert_pdf_to_xml

def main():
    pdf_path = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\aboutproject\doc\(1R,2R,4R)-冰片-2-硫氰基醋酸酯、1,7,7-trimethylbicyclo(2,2,1)hept-2-yl thiocyanatoacetate、115-31-1.pdf"
    output_xml = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\pdf2xml\output\test_final.xml"
    
    print("测试完整转换流程...")
    print(f"输入: {pdf_path}")
    print(f"输出: {output_xml}")
    
    success = convert_pdf_to_xml(pdf_path, output_xml)
    
    if success:
        print("\n转换成功！")
        print(f"请查看: {output_xml}")
        
        # 显示XML前80行
        with open(output_xml, 'r', encoding='utf-8') as f:
            lines = f.readlines()
            print("\nXML预览（前80行）:")
            print("="*80)
            for i, line in enumerate(lines[:80], 1):
                print(f"{i:3d}: {line.rstrip()}")
            print("="*80)
            print(f"总行数: {len(lines)}")
    else:
        print("\n转换失败！")
        return 1
    
    return 0

if __name__ == '__main__':
    sys.exit(main())

