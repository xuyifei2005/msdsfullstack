#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
测试单个PDF的转换效果
"""

import sys
from pathlib import Path

# 添加当前目录到Python路径
sys.path.insert(0, str(Path(__file__).parent))

from pdf_to_xml import extract_pdf_text, convert_pdf_to_xml
from msds_parser import MSDSParser
from xml_generator import XMLGenerator

def test_pdf(pdf_path, output_path):
    """测试单个PDF转换"""
    print("="*80)
    print(f"测试PDF: {pdf_path}")
    print("="*80)
    
    # 1. 提取文本
    print("\n1. 提取PDF文本...")
    text = extract_pdf_text(pdf_path)
    print(f"   文本长度: {len(text)} 字符")
    
    # 2. 解析MSDS
    print("\n2. 解析MSDS信息...")
    parser = MSDSParser()
    parsed_info = parser.parse(text)
    
    # 显示章节提取结果
    sections = parsed_info.get('sections', {})
    filled_sections = [s for s, c in sections.items() if c]
    print(f"   成功提取的章节: {len(filled_sections)}/16")
    
    # 显示每个章节
    for i, section_name in enumerate(parser.sections, 1):
        content = sections.get(section_name, '')
        if content:
            preview = content[:80] + "..." if len(content) > 80 else content
            print(f"   [{i:2d}] SUCCESS {section_name}: {preview}")
        else:
            print(f"   [{i:2d}] EMPTY   {section_name}")
    
    # 3. 生成XML
    print("\n3. 生成XML...")
    generator = XMLGenerator()
    success = generator.generate(parsed_info, output_path)
    
    if success:
        print(f"   SUCCESS: {output_path}")
    else:
        print(f"   FAILED")
    
    return success


if __name__ == '__main__':
    # 测试几个PDF
    test_files = [
        (
            r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\aboutproject\doc\(1R,2R,4R)-冰片-2-硫氰基醋酸酯、1,7,7-trimethylbicyclo(2,2,1)hept-2-yl thiocyanatoacetate、115-31-1.pdf",
            r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\pdf2xml\output\test_115-31-1.xml"
        ),
        (
            r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\aboutproject\doc\(E)-O,O-二甲基-O-[1-甲基-2-(1-苯基-乙氧基甲酰)乙烯基]磷酸酯、1-phenylethyl 3-(dimethoxyphosphinyloxy)isocrotonate powder、7700-17-6.pdf",
            r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\pdf2xml\output\test_7700-17-6.xml"
        ),
    ]
    
    for pdf_path, output_path in test_files:
        test_pdf(pdf_path, output_path)
        print("\n")

