#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from msds_parser import MSDSParser
from xml_generator import XMLGenerator

def test_fire_fighting_fix():
    """测试消防措施修复"""
    
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
    print("消防措施原始内容:")
    print("=" * 80)
    print(fire_content)
    print("=" * 80)
    
    # 测试字段提取
    generator = XMLGenerator()
    
    fields_to_test = [
        ("危险特性", ["危险特性", "特性"]),
        ("建规火险分级", ["建规火险分级", "火险分级", "危险等级"]),
        ("有害燃烧产物", ["有害燃烧产物", "燃烧产物"]),
        ("灭火方法", ["灭火方法", "灭火剂"])
    ]
    
    print("\n字段提取测试:")
    print("-" * 40)
    for field_name, patterns in fields_to_test:
        value = generator._extract_field_value_enhanced(fire_content, patterns)
        print(f"{field_name}: {repr(value)}")
    
    # 生成XML并检查结果
    output_path = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\pdf2xml\test_fire_fighting_fix.xml"
    generator.generate(msds_data, output_path)
    
    print(f"\n生成的XML文件: {output_path}")
    
    # 读取并显示消防措施部分
    with open(output_path, 'r', encoding='utf-8') as f:
        content = f.read()
        lines = content.split('\n')
        for i, line in enumerate(lines):
            if 'fire_fighting' in line or 'hazard_characteristics' in line or 'fire_risk_classification' in line or 'harmful_combustion_products' in line or 'suitable_extinguishing_media' in line:
                print(f"行 {i+1:2d}: {line}")

if __name__ == "__main__":
    test_fire_fighting_fix()
