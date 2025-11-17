#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from msds_parser import MSDSParser
from xml_generator import XMLGenerator

def debug_leak_response():
    """调试泄漏应急处理字段提取"""
    
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
    print(repr(leak_content))
    print("=" * 80)
    
    # 按行分析内容
    lines = leak_content.split('\n')
    for i, line in enumerate(lines):
        print(f"行 {i+1:2d}: {repr(line)}")
    
    print("\n" + "=" * 80)
    print("字段提取测试:")
    print("=" * 80)
    
    # 测试字段提取
    generator = XMLGenerator()
    
    # 测试应急处理字段提取
    emergency_proc = generator._extract_field_value_enhanced(leak_content, ["应急处理", "应急措施"])
    print(f"应急处理提取结果: {repr(emergency_proc)}")
    
    # 测试不同的正则表达式模式
    import re
    patterns = [
        r'应急处理[:：]\s*(.*?)(?=操作注意事项|储存注意事项|$)',
        r'应急处理[:：]\s*(.*?)(?=\n|$)',
        r'应急处理[:：]\s*(.*)',
    ]
    
    for i, pattern in enumerate(patterns):
        match = re.search(pattern, leak_content, re.DOTALL | re.IGNORECASE)
        if match:
            value = match.group(1).strip()
            print(f"模式 {i+1} 匹配成功: {repr(value)}")
        else:
            print(f"模式 {i+1} 未匹配")

if __name__ == "__main__":
    debug_leak_response()
