#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from msds_parser import MSDSParser
from xml_generator import XMLGenerator

def debug_ecological():
    """调试生态学信息字段提取"""
    
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
    
    # 获取生态学信息内容
    sections = msds_data.get('sections', {})
    eco_content = sections.get('生态学资料', '')
    
    print("=" * 80)
    print("生态学信息原始内容:")
    print("=" * 80)
    print(eco_content)
    print("=" * 80)
    
    # 按行分析内容
    lines = eco_content.split('\n')
    print(f"\n按行分析内容 (共{len(lines)}行):")
    for i, line in enumerate(lines):
        print(f"行 {i+1:2d}: {repr(line)}")
    
    # 测试专门的生态学字段提取方法
    generator = XMLGenerator()
    fields = generator._extract_ecological_fields(eco_content)
    
    print("\n" + "=" * 80)
    print("专门的生态学字段提取结果:")
    print("=" * 80)
    
    # 检查所有应该有的字段
    expected_fields = {
        "生态毒理毒性": "ecological_toxicity",
        "生物降解性": "biodegradability",
        "非生物降解性": "non_biodegradability",
        "生物富集或生物积累性": "bioaccumulation",
        "其它有害作用": "other_harmful_effects"
    }
    
    for field_name, xml_tag in expected_fields.items():
        if field_name in fields:
            value = fields[field_name]
            print(f"OK {field_name}: {repr(value)}")
        else:
            print(f"NO {field_name}: 未找到")
    
    # 生成XML并检查结果
    output_path = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\pdf2xml\test_ecological_fix.xml"
    generator.generate(msds_data, output_path)
    
    print(f"\n生成的XML文件: {output_path}")
    
    # 读取并显示生态学信息部分
    with open(output_path, 'r', encoding='utf-8') as f:
        content = f.read()
        lines = content.split('\n')
        for i, line in enumerate(lines):
            if 'ecological' in line or 'ecological_toxicity' in line or 'biodegradability' in line or 'non_biodegradability' in line or 'bioaccumulation' in line or 'other_harmful_effects' in line:
                print(f"行 {i+1:2d}: {line}")

if __name__ == "__main__":
    debug_ecological()
