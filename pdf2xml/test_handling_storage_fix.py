#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from msds_parser import MSDSParser
from xml_generator import XMLGenerator

def test_handling_storage_fix():
    """测试操作处置与储存修复"""
    
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
    print("操作处置与储存原始内容:")
    print("=" * 80)
    print(handling_content)
    print("=" * 80)
    
    # 测试新的提取方法
    generator = XMLGenerator()
    handling_precautions, storage_precautions = generator._extract_handling_storage_fields(handling_content)
    
    print(f"\n字段提取结果:")
    print(f"操作注意事项: {repr(handling_precautions)}")
    print(f"储存注意事项: {repr(storage_precautions)}")
    
    # 生成XML并检查结果
    output_path = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\pdf2xml\test_handling_storage_fix.xml"
    generator.generate(msds_data, output_path)
    
    print(f"\n生成的XML文件: {output_path}")
    
    # 读取并显示操作处置与储存部分
    with open(output_path, 'r', encoding='utf-8') as f:
        content = f.read()
        lines = content.split('\n')
        for i, line in enumerate(lines):
            if 'handling_storage' in line or 'handling_precautions' in line or 'storage_precautions' in line:
                print(f"行 {i+1:2d}: {line}")

if __name__ == "__main__":
    test_handling_storage_fix()
