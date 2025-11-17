#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from msds_parser import MSDSParser
import re

def debug_handling_detailed():
    """详细调试操作处置与储存字段提取"""
    
    # 测试PDF文件
    pdf_path = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\aboutproject\doc\(1R,2R,4R)-冰片-2-硫氰基醋酸酯、1,7,7-trimethylbicyclo(2,2,1)hept-2-yl thiocyanatoacetate、115-31-1.pdf"
    
    if not os.path.exists(pdf_path):
        print(f"PDF文件不存在: {pdf_path}")
        return
    
    # 解析PDF
    from pdfplumber import open as pdf_open
    with pdf_open(pdf_path) as pdf:
        text = ""
        for page in pdf.pages:
            text += page.extract_text() or ""
    
    parser = MSDSParser()
    msds_data = parser.parse(text)
    
    if not msds_data:
        print("PDF解析失败")
        return
    
    # 获取操作处置与储存内容
    sections = msds_data.get('sections', {})
    handling_content = sections.get('操作处置与储存', '')
    
    print("=" * 80)
    print("操作处置与储存原始内容（逐字符分析）:")
    print("=" * 80)
    print(repr(handling_content))
    print("=" * 80)
    
    # 逐字符分析内容
    for i, char in enumerate(handling_content):
        if char == '\n':
            print(f"[{i:3d}] \\n")
        elif char == ':':
            print(f"[{i:3d}] :")
        elif char == '：':
            print(f"[{i:3d}] ：")
        elif char in ['操', '作', '注', '意', '事', '项', '储', '存']:
            print(f"[{i:3d}] {char} <-- 可能是字段开始")
        else:
            if i % 30 == 0:  # 每30个字符显示一次
                print(f"[{i:3d}] ...")
    
    print("\n" + "=" * 80)
    print("按行分析内容:")
    print("=" * 80)
    
    lines = handling_content.split('\n')
    for i, line in enumerate(lines):
        print(f"行 {i+1:2d}: {repr(line)}")
    
    print("\n" + "=" * 80)
    print("字段边界分析:")
    print("=" * 80)
    
    # 查找所有字段名
    field_patterns = [
        r'操作注意事项',
        r'储存注意事项'
    ]
    
    for pattern in field_patterns:
        matches = list(re.finditer(pattern, handling_content))
        for match in matches:
            start = match.start()
            end = match.end()
            print(f"找到 '{pattern}' 在位置 {start}-{end}")
            print(f"  前文: {repr(handling_content[max(0, start-20):start])}")
            print(f"  后文: {repr(handling_content[end:end+50])}")
            print()

if __name__ == "__main__":
    debug_handling_detailed()
