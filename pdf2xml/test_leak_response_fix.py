#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from msds_parser import MSDSParser
from xml_generator import XMLGenerator

def test_leak_response_fix():
    """测试泄漏应急处理修复"""
    
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
    
    # 获取泄漏应急处理内容
    sections = msds_data.get('sections', {})
    leak_content = sections.get('泄漏应急处理', '')
    
    print("=" * 80)
    print("泄漏应急处理原始内容:")
    print("=" * 80)
    print(leak_content)
    print("=" * 80)
    
    # 测试新的提取方法
    generator = XMLGenerator()
    emergency_proc = generator._extract_leak_emergency_procedures(leak_content)
    
    print(f"\n应急处理提取结果:")
    print(f"长度: {len(emergency_proc) if emergency_proc else 0}")
    print(f"内容: {repr(emergency_proc)}")
    
    # 生成XML并检查结果
    output_path = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\pdf2xml\test_leak_response_fix.xml"
    generator.generate(msds_data, output_path)
    
    print(f"\n生成的XML文件: {output_path}")
    
    # 读取并显示泄漏应急处理部分
    with open(output_path, 'r', encoding='utf-8') as f:
        content = f.read()
        lines = content.split('\n')
        for i, line in enumerate(lines):
            if 'leak_response' in line or 'emergency_procedures' in line:
                print(f"行 {i+1:2d}: {line}")

if __name__ == "__main__":
    test_leak_response_fix()
