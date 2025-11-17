#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from msds_parser import MSDSParser
from xml_generator import XMLGenerator

def debug_exposure_control():
    """调试接触控制/个体防护字段提取"""
    
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
    
    # 获取接触控制/个体防护内容
    sections = msds_data.get('sections', {})
    exposure_content = sections.get('接触控制/个体防护', '')
    
    print("=" * 80)
    print("接触控制/个体防护原始内容:")
    print("=" * 80)
    print(exposure_content)
    print("=" * 80)
    
    # 按行分析内容
    lines = exposure_content.split('\n')
    for i, line in enumerate(lines):
        print(f"行 {i+1:2d}: {repr(line)}")
    
    print("\n" + "=" * 80)
    print("字段提取测试:")
    print("=" * 80)
    
    # 测试字段提取
    generator = XMLGenerator()
    
    # 测试所有可能的字段
    fields_to_test = [
        ("中国MAC", ["中国MAC", "MAC"]),
        ("前苏联MAC", ["前苏联MAC", "苏联MAC"]),
        ("TLVTN", ["TLVTN"]),
        ("TLVWN", ["TLVWN"]),
        ("接触限值", ["接触限值", "接触限制"]),
        ("监测方法", ["监测方法", "监测"]),
        ("工程控制", ["工程控制", "工程"]),
        ("呼吸系统防护", ["呼吸系统防护", "呼吸防护"]),
        ("眼睛防护", ["眼睛防护", "眼部防护"]),
        ("身体防护", ["身体防护", "躯体防护"]),
        ("手防护", ["手防护", "手部防护"]),
        ("其他防护", ["其他防护", "其他"])
    ]
    
    for field_name, patterns in fields_to_test:
        value = generator._extract_field_value_enhanced(exposure_content, patterns)
        print(f"{field_name}: {repr(value)}")
    
    # 生成XML并检查结果
    output_path = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\pdf2xml\test_exposure_control_fix.xml"
    generator.generate(msds_data, output_path)
    
    print(f"\n生成的XML文件: {output_path}")
    
    # 读取并显示接触控制/个体防护部分
    with open(output_path, 'r', encoding='utf-8') as f:
        content = f.read()
        lines = content.split('\n')
        for i, line in enumerate(lines):
            if 'exposure_control' in line or 'china_mac' in line or 'engineering_controls' in line or 'respiratory_protection' in line or 'eye_protection' in line or 'body_protection' in line or 'hand_protection' in line:
                print(f"行 {i+1:2d}: {line}")

if __name__ == "__main__":
    debug_exposure_control()
