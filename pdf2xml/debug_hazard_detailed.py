#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from msds_parser import MSDSParser
import re

def debug_hazard_detailed():
    """详细调试危险性概述字段提取"""
    
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
    
    # 获取危险性概述内容
    sections = msds_data.get('sections', {})
    hazard_content = sections.get('危险性概述', '')
    
    print("=" * 80)
    print("危险性概述原始内容（逐字符分析）:")
    print("=" * 80)
    
    # 逐字符分析内容
    for i, char in enumerate(hazard_content):
        if char == '\n':
            print(f"[{i:3d}] \\n")
        elif char == ':':
            print(f"[{i:3d}] :")
        elif char == '：':
            print(f"[{i:3d}] ：")
        elif char in ['危', '侵', '健', '环', '燃']:
            print(f"[{i:3d}] {char} <-- 可能是字段开始")
        else:
            if i % 50 == 0:  # 每50个字符显示一次
                print(f"[{i:3d}] ...")
    
    print("\n" + "=" * 80)
    print("按行分析内容:")
    print("=" * 80)
    
    lines = hazard_content.split('\n')
    for i, line in enumerate(lines):
        print(f"行 {i+1:2d}: {repr(line)}")
    
    print("\n" + "=" * 80)
    print("字段边界分析:")
    print("=" * 80)
    
    # 查找所有字段名
    field_patterns = [
        r'危险性类别',
        r'侵入途径',
        r'健康危害',
        r'环境危害', 
        r'燃爆危险'
    ]
    
    for pattern in field_patterns:
        matches = list(re.finditer(pattern, hazard_content))
        for match in matches:
            start = match.start()
            end = match.end()
            print(f"找到 '{pattern}' 在位置 {start}-{end}")
            print(f"  前文: {repr(hazard_content[max(0, start-20):start])}")
            print(f"  后文: {repr(hazard_content[end:end+50])}")
            print()

if __name__ == "__main__":
    debug_hazard_detailed()
