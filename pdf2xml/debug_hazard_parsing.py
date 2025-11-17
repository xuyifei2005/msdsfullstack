#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
调试危险性概述解析
"""

import sys
from pathlib import Path
import xml.etree.ElementTree as ET

# 添加当前目录到Python路径
sys.path.insert(0, str(Path(__file__).parent))

from pdf_to_xml import extract_pdf_text
from msds_parser import MSDSParser
from xml_generator import XMLGenerator

def debug_hazard():
    """调试危险性概述解析"""
    
    # 提取文本
    pdf_path = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\aboutproject\doc\(1R,2R,4R)-冰片-2-硫氰基醋酸酯、1,7,7-trimethylbicyclo(2,2,1)hept-2-yl thiocyanatoacetate、115-31-1.pdf"
    text = extract_pdf_text(pdf_path)
    
    # 解析章节
    parser = MSDSParser()
    parsed_info = parser.parse(text)
    sections = parsed_info.get('sections', {})
    
    # 获取危险性概述内容
    hazard_content = sections.get('危险性概述', '')
    print("="*80)
    print("危险性概述章节内容:")
    print("="*80)
    print(hazard_content)
    print("\n" + "="*80)
    
    # 创建XML生成器并测试解析
    xml_gen = XMLGenerator()
    
    # 创建根元素
    root = ET.Element("test")
    
    print("调用_parse_hazard_overview_enhanced方法...")
    xml_gen._parse_hazard_overview_enhanced(root, hazard_content)
    
    print("\n生成的XML结构:")
    print("-" * 40)
    
    # 打印生成的XML
    for child in root:
        print(f"<{child.tag}>")
        for subchild in child:
            print(f"  <{subchild.tag}>{subchild.text}</{subchild.tag}>")
        print(f"</{child.tag}>")
    
    # 检查hazard_category
    hazard_info = root.find('hazard_info')
    if hazard_info is not None:
        hazard_category = hazard_info.find('hazard_category')
        if hazard_category is not None:
            print(f"\nhazard_category值: '{hazard_category.text}'")
        else:
            print("\n未找到hazard_category元素")
    else:
        print("\n未找到hazard_info元素")


if __name__ == '__main__':
    debug_hazard()
