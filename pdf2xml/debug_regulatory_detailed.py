#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from msds_parser import MSDSParser
from xml_generator import XMLGenerator

def debug_regulatory_detailed():
    """详细调试法规信息字段提取"""
    
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
    
    # 获取所有章节内容
    sections = msds_data.get('sections', {})
    
    print("=" * 80)
    print("所有章节内容:")
    print("=" * 80)
    for section_name, content in sections.items():
        print(f"\n章节: {section_name}")
        print(f"内容: {repr(content)}")
        if "法规" in content or "regulatory" in content.lower():
            print("*** 包含法规相关内容 ***")
    
    # 检查原始文本中是否包含法规信息
    print("\n" + "=" * 80)
    print("在原始文本中搜索法规相关内容:")
    print("=" * 80)
    
    # 搜索包含"法规"的行
    lines = text.split('\n')
    for i, line in enumerate(lines):
        if "法规" in line:
            print(f"行 {i+1:2d}: {repr(line)}")
    
    # 检查是否有"第十五部分"相关内容
    print("\n" + "=" * 80)
    print("搜索第十五部分相关内容:")
    print("=" * 80)
    
    for i, line in enumerate(lines):
        if "第十五部分" in line or "15" in line:
            print(f"行 {i+1:2d}: {repr(line)}")
            # 显示后续几行
            for j in range(1, 6):
                if i + j < len(lines):
                    print(f"行 {i+j+1:2d}: {repr(lines[i+j])}")

if __name__ == "__main__":
    debug_regulatory_detailed()
