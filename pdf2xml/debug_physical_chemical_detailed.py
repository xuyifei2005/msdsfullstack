#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from msds_parser import MSDSParser
from xml_generator import XMLGenerator

def debug_physical_chemical_detailed():
    """详细调试理化特性字段提取"""
    
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
    
    # 获取理化特性内容
    sections = msds_data.get('sections', {})
    phys_content = sections.get('理化特性', '')
    
    print("=" * 80)
    print("理化特性原始内容:")
    print("=" * 80)
    print(phys_content)
    print("=" * 80)
    
    # 测试专门的理化特性字段提取方法
    generator = XMLGenerator()
    fields = generator._extract_physical_chemical_fields(phys_content)
    
    print("\n" + "=" * 80)
    print("专门的理化特性字段提取结果:")
    print("=" * 80)
    
    for field_name, value in fields.items():
        print(f"{field_name}: {repr(value)}")
    
    # 特别检查缺失的字段
    missing_fields = ["溶解性", "分子式", "分子量", "燃烧性"]
    print(f"\n缺失字段检查:")
    for field in missing_fields:
        if field in fields:
            print(f"OK {field}: {repr(fields[field])}")
        else:
            print(f"NO {field}: 未找到")

if __name__ == "__main__":
    debug_physical_chemical_detailed()
