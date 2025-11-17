#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import os
import re
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from msds_parser import MSDSParser
from xml_generator import XMLGenerator

def debug_regulatory_section():
    """调试法规信息章节提取"""
    
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
    
    print("=" * 80)
    print("测试法规信息章节提取:")
    print("=" * 80)
    
    # 手动测试法规信息章节的正则表达式
    patterns = [
        # 匹配 "第十五部分：法规信息" 格式
        r'第十五部分[:：]法规信息(.*?)(?=第十六部分|$)',
        # 备用：宽松匹配
        r'第十五部分[:：]法规信息(.+?)(?=第|$)',
    ]
    
    for i, pattern in enumerate(patterns):
        print(f"\n测试模式 {i+1}: {pattern}")
        match = re.search(pattern, text, re.DOTALL)
        if match:
            content = match.group(1).strip()
            print(f"找到内容: {repr(content)}")
            
            # 清理内容
            content = re.sub(r'第\s*\d+\s*页\s*/\s*共\s*\d+\s*页', '', content)
            content = re.sub(r'[ \t]+', ' ', content)
            content = re.sub(r'\n\s*\n', '\n', content)
            content = content.strip()
            
            print(f"清理后内容: {repr(content)}")
        else:
            print("未找到匹配")
    
    # 测试解析器
    parser = MSDSParser()
    msds_data = parser.parse(text)
    
    if not msds_data:
        print("PDF解析失败")
        return
    
    # 获取法规信息内容
    sections = msds_data.get('sections', {})
    regulatory_content = sections.get('法规信息', '')
    
    print("\n" + "=" * 80)
    print("解析器提取的法规信息内容:")
    print("=" * 80)
    print(f"内容: {repr(regulatory_content)}")
    
    if regulatory_content:
        # 测试字段提取
        generator = XMLGenerator()
        fields = generator._extract_regulatory_fields(regulatory_content)
        
        print("\n" + "=" * 80)
        print("字段提取结果:")
        print("=" * 80)
        for field_name, value in fields.items():
            print(f"{field_name}: {repr(value)}")
    else:
        print("法规信息内容为空，无法提取字段")

if __name__ == "__main__":
    debug_regulatory_section()
