#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
调试文本提取 - 查看实际的文本格式
"""

import sys
import re
from pathlib import Path

# 添加当前目录到Python路径
sys.path.insert(0, str(Path(__file__).parent))

from pdf_to_xml import extract_pdf_text

def debug_text(pdf_path):
    """调试文本内容"""
    print("=" * 80)
    print(f"调试PDF: {pdf_path}")
    print("=" * 80)
    
    # 提取文本
    text = extract_pdf_text(pdf_path)
    print(f"文本长度: {len(text)} 字符\n")
    
    # 保存完整文本到文件
    output_file = "debug_full_text.txt"
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(text)
    print(f"完整文本已保存到: {output_file}\n")
    
    # 查找所有"第X部分"
    print("查找章节标题:")
    pattern1 = r'第\s*([一二三四五六七八九十百]+)\s*部分\s*[:：]?\s*([^\n]+)'
    matches1 = re.findall(pattern1, text)
    if matches1:
        print("\n找到的章节标题（中文数字）:")
        for num, name in matches1:
            print(f"  第{num}部分: {name[:50]}")
    
    # 查找所有"第X部分"（阿拉伯数字）
    pattern2 = r'第\s*(\d+)\s*部分\s*[:：]?\s*([^\n]+)'
    matches2 = re.findall(pattern2, text)
    if matches2:
        print("\n找到的章节标题（阿拉伯数字）:")
        for num, name in matches2:
            print(f"  第{num}部分: {name[:50]}")
    
    # 显示前1500字符
    print("\n" + "="*80)
    print("文本前1500字符:")
    print("="*80)
    print(text[:1500])
    
    # 查找特定章节
    print("\n" + "="*80)
    print("查找特定章节:")
    print("="*80)
    
    section_names = ["化学品及企业标识", "危险性概述", "急救措施"]
    for section in section_names:
        idx = text.find(section)
        if idx >= 0:
            # 显示找到的位置附近的文本
            start = max(0, idx - 50)
            end = min(len(text), idx + len(section) + 200)
            context = text[start:end]
            print(f"\n找到'{section}'在位置 {idx}:")
            print(f"上下文: ...{context}...")
        else:
            print(f"\n未找到'{section}'")


if __name__ == '__main__':
    pdf_path = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\aboutproject\doc\(1R,2R,4R)-冰片-2-硫氰基醋酸酯、1,7,7-trimethylbicyclo(2,2,1)hept-2-yl thiocyanatoacetate、115-31-1.pdf"
    debug_text(pdf_path)

