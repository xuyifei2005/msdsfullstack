#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from msds_parser import MSDSParser
import re

def debug_fire_fighting():
    """调试消防措施字段提取"""
    
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
    
    # 获取消防措施内容
    sections = msds_data.get('sections', {})
    fire_content = sections.get('消防措施', '')
    
    print("=" * 80)
    print("消防措施原始内容（逐字符分析）:")
    print("=" * 80)
    print(repr(fire_content))
    print("=" * 80)
    
    # 逐字符分析内容
    for i, char in enumerate(fire_content):
        if char == '\n':
            print(f"[{i:3d}] \\n")
        elif char == ':':
            print(f"[{i:3d}] :")
        elif char == '：':
            print(f"[{i:3d}] ：")
        elif char in ['建', '规', '火', '险', '分', '级']:
            print(f"[{i:3d}] {char} <-- 可能是建规火险分级")
        else:
            if i % 30 == 0:  # 每30个字符显示一次
                print(f"[{i:3d}] ...")
    
    print("\n" + "=" * 80)
    print("按行分析内容:")
    print("=" * 80)
    
    lines = fire_content.split('\n')
    for i, line in enumerate(lines):
        print(f"行 {i+1:2d}: {repr(line)}")
    
    print("\n" + "=" * 80)
    print("建规火险分级字段测试:")
    print("=" * 80)
    
    # 测试不同的正则表达式模式
    patterns = [
        r'建规火险分级[:：]\s*([^\n]+)',
        r'建规火险分级[:：]\s*([^有害燃烧产物]+?)(?=有害燃烧产物|$)',
        r'建规火险分级[:：]\s*([^灭火方法]+?)(?=灭火方法|$)',
        r'建规火险分级[:：]\s*(.*?)(?=\n|$)',
    ]
    
    for i, pattern in enumerate(patterns):
        match = re.search(pattern, fire_content, re.DOTALL | re.IGNORECASE)
        if match:
            value = match.group(1).strip()
            print(f"模式 {i+1} 匹配成功: {repr(value)}")
        else:
            print(f"模式 {i+1} 未匹配")

if __name__ == "__main__":
    debug_fire_fighting()
