#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from msds_parser import MSDSParser
from xml_generator import XMLGenerator

def debug_physical_chemical():
    """调试理化特性字段提取"""
    
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
    
    # 按行分析内容
    lines = phys_content.split('\n')
    for i, line in enumerate(lines):
        print(f"行 {i+1:2d}: {repr(line)}")
    
    print("\n" + "=" * 80)
    print("字段提取测试:")
    print("=" * 80)
    
    # 测试字段提取
    generator = XMLGenerator()
    
    # 测试所有可能的字段
    fields_to_test = [
        ("pH", ["pH"]),
        ("熔点", ["熔点", "熔融点"]),
        ("沸点", ["沸点"]),
        ("闪点", ["闪点"]),
        ("相对密度", ["相对密度", "密度"]),
        ("相对蒸气密度", ["相对蒸气密度"]),
        ("溶解性", ["溶解性", "溶解度"]),
        ("分子式", ["分子式"]),
        ("分子量", ["分子量", "相对分子质量"]),
        ("主要成分", ["主要成分"]),
        ("饱和蒸气压", ["饱和蒸气压"]),
        ("辛醇/水分配系数的对数值", ["辛醇/水分配系数的对数值"]),
        ("临界温度", ["临界温度"]),
        ("引燃温度", ["引燃温度"]),
        ("自燃温度", ["自燃温度"]),
        ("燃烧性", ["燃烧性"]),
        ("外观与性状", ["外观与性状"]),
        ("主要用途", ["主要用途"]),
        ("其它理化性质", ["其它理化性质"]),
        ("燃烧热", ["燃烧热"]),
        ("临界压力", ["临界压力"]),
        ("爆炸上限", ["爆炸上限"]),
        ("爆炸下限", ["爆炸下限"])
    ]
    
    for field_name, patterns in fields_to_test:
        value = generator._extract_field_value_enhanced(phys_content, patterns)
        print(f"{field_name}: {repr(value)}")
    
    # 生成XML并检查结果
    output_path = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\pdf2xml\test_physical_chemical_fix.xml"
    generator.generate(msds_data, output_path)
    
    print(f"\n生成的XML文件: {output_path}")
    
    # 读取并显示理化特性部分
    with open(output_path, 'r', encoding='utf-8') as f:
        content = f.read()
        lines = content.split('\n')
        for i, line in enumerate(lines):
            if 'physical_chemical' in line or 'melting_point' in line or 'boiling_point' in line or 'flash_point' in line or 'relative_density' in line or 'solubility' in line or 'molecular_formula' in line or 'molecular_weight' in line:
                print(f"行 {i+1:2d}: {line}")

if __name__ == "__main__":
    debug_physical_chemical()
