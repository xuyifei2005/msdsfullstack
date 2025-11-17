#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from msds_parser import MSDSParser
from xml_generator import XMLGenerator

def test_hazard_fix():
    """测试危险性概述修复"""
    
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
    print("危险性概述原始内容:")
    print("=" * 80)
    print(hazard_content)
    print("=" * 80)
    
    # 测试新的字段提取方法
    from xml_generator import XMLGenerator
    generator = XMLGenerator()
    
    fields_to_test = ["危险性类别", "侵入途径", "健康危害", "环境危害", "燃爆危险"]
    
    for field_name in fields_to_test:
        value = generator._extract_hazard_field(hazard_content, field_name)
        print(f"{field_name}: {repr(value)}")
    
    # 生成XML并检查结果
    output_path = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\pdf2xml\test_hazard_fix.xml"
    generator.generate(msds_data, output_path)
    
    print(f"\n生成的XML文件: {output_path}")
    
    # 读取并显示危险性概述部分
    with open(output_path, 'r', encoding='utf-8') as f:
        content = f.read()
        lines = content.split('\n')
        for i, line in enumerate(lines):
            if 'hazard_info' in line or 'hazard_category' in line or 'exposure_routes' in line or 'health_hazards' in line:
                print(f"行 {i+1:2d}: {line}")

if __name__ == "__main__":
    test_hazard_fix()
