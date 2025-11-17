#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from msds_parser import MSDSParser
from xml_generator import XMLGenerator

def debug_toxicological():
    """调试毒理学信息字段提取"""
    
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
    
    # 获取毒理学信息内容
    sections = msds_data.get('sections', {})
    tox_content = sections.get('毒理学信息', '')
    
    print("=" * 80)
    print("毒理学信息原始内容:")
    print("=" * 80)
    print(tox_content)
    print("=" * 80)
    
    # 按行分析内容
    lines = tox_content.split('\n')
    print(f"\n按行分析内容 (共{len(lines)}行):")
    for i, line in enumerate(lines):
        print(f"行 {i+1:2d}: {repr(line)}")
    
    # 测试专门的毒理学字段提取方法
    generator = XMLGenerator()
    fields = generator._extract_toxicological_fields(tox_content)
    
    print("\n" + "=" * 80)
    print("专门的毒理学字段提取结果:")
    print("=" * 80)
    
    # 检查所有应该有的字段
    expected_fields = {
        "急性毒性": "acute_toxicity",
        "亚急性和慢性毒性": "subacute_chronic_toxicity",
        "RTECS": "rtecs",
        "刺激性": "irritation",
        "致敏性": "sensitization",
        "致突变性": "mutagenicity",
        "致畸性": "teratogenicity",
        "致癌性": "carcinogenicity"
    }
    
    for field_name, xml_tag in expected_fields.items():
        if field_name in fields:
            value = fields[field_name]
            print(f"OK {field_name}: {repr(value)}")
        else:
            print(f"NO {field_name}: 未找到")
    
    # 生成XML并检查结果
    output_path = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\pdf2xml\test_toxicological_fix.xml"
    generator.generate(msds_data, output_path)
    
    print(f"\n生成的XML文件: {output_path}")
    
    # 读取并显示毒理学信息部分
    with open(output_path, 'r', encoding='utf-8') as f:
        content = f.read()
        lines = content.split('\n')
        for i, line in enumerate(lines):
            if 'toxicological' in line or 'acute_toxicity' in line or 'subacute_chronic_toxicity' in line or 'rtecs' in line or 'irritation' in line or 'sensitization' in line or 'mutagenicity' in line or 'teratogenicity' in line or 'carcinogenicity' in line:
                print(f"行 {i+1:2d}: {line}")

if __name__ == "__main__":
    debug_toxicological()
