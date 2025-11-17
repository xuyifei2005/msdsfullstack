#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from msds_parser import MSDSParser
import re

def debug_content_structure():
    """调试内容结构"""
    
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
    
    # 获取危险性概述内容
    sections = msds_data.get('sections', {})
    hazard_content = sections.get('危险性概述', '')
    
    print("=" * 80)
    print("危险性概述原始内容:")
    print("=" * 80)
    print(repr(hazard_content))
    print("=" * 80)
    
    # 分析内容结构
    print("\n按字段分割内容:")
    print("-" * 40)
    
    # 手动分割内容
    lines = hazard_content.split('\n')
    current_field = None
    current_content = []
    
    for line in lines:
        line = line.strip()
        if not line:
            continue
            
        # 检查是否是字段名
        field_patterns = [
            r'^危险性类别[:：]',
            r'^侵入途径[:：]', 
            r'^健康危害[:：]',
            r'^环境危害[:：]',
            r'^燃爆危险[:：]'
        ]
        
        is_field = False
        for pattern in field_patterns:
            if re.match(pattern, line):
                # 输出上一个字段的内容
                if current_field and current_content:
                    print(f"{current_field}: {''.join(current_content)}")
                
                # 开始新字段
                current_field = line.split(':')[0].split('：')[0]
                current_content = [line.split(':', 1)[1] if ':' in line else line.split('：', 1)[1]]
                is_field = True
                break
        
        if not is_field and current_field:
            current_content.append(line)
    
    # 输出最后一个字段
    if current_field and current_content:
        print(f"{current_field}: {''.join(current_content)}")

if __name__ == "__main__":
    debug_content_structure()
