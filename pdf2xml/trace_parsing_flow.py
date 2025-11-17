#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
追踪完整的解析流程
"""

import sys
from pathlib import Path
import re

# 添加当前目录到Python路径
sys.path.insert(0, str(Path(__file__).parent))

from pdf_to_xml import extract_pdf_text
from msds_parser import MSDSParser

def trace_flow():
    """追踪解析流程"""
    
    # 提取文本
    pdf_path = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\aboutproject\doc\(1R,2R,4R)-冰片-2-硫氰基醋酸酯、1,7,7-trimethylbicyclo(2,2,1)hept-2-yl thiocyanatoacetate、115-31-1.pdf"
    text = extract_pdf_text(pdf_path)
    
    print("="*80)
    print("步骤1: PDF文本提取")
    print("="*80)
    print(f"文本长度: {len(text)} 字符")
    
    # 解析章节
    parser = MSDSParser()
    parsed_info = parser.parse(text)
    sections = parsed_info.get('sections', {})
    
    print("\n" + "="*80)
    print("步骤2: 章节提取")
    print("="*80)
    
    # 重点关注"危险性概述"
    hazard_content = sections.get('危险性概述', '')
    print(f"\n危险性概述章节:")
    print(f"  长度: {len(hazard_content)} 字符")
    print(f"  内容:\n{hazard_content}")
    
    # 手动测试字段提取
    print("\n" + "="*80)
    print("步骤3: 手动测试字段提取")
    print("="*80)
    
    field_name = "危险性类别"
    pattern = rf'{re.escape(field_name)}\s*[:：]\s*([^\n]+)'
    match = re.search(pattern, hazard_content, re.IGNORECASE)
    
    if match:
        value = match.group(1).strip()
        print(f"\n手动提取 '{field_name}':")
        print(f"  SUCCESS")
        print(f"  值: {value}")
    else:
        print(f"\n手动提取 '{field_name}':")
        print(f"  FAILED")
        print(f"  使用的模式: {pattern}")
        
        # 检查文本中是否存在该字段名
        if field_name in hazard_content:
            print(f"  提示: 字段名在内容中存在")
            idx = hazard_content.find(field_name)
            context = hazard_content[max(0, idx-20):idx+100]
            print(f"  上下文: ...{context}...")
        else:
            print(f"  提示: 字段名在内容中不存在")
    
    # 测试所有危险性概述的字段
    print("\n" + "="*80)
    print("步骤4: 测试所有危险性概述字段")
    print("="*80)
    
    hazard_fields = [
        '危险性类别',
        '侵入途径',
        '健康危害',
        '环境危害',
        '燃爆危险'
    ]
    
    for field in hazard_fields:
        pattern = rf'{re.escape(field)}\s*[:：]\s*(.*?)(?=\n(?:危险性类别|侵入途径|健康危害|环境危害|燃爆危险)[:：]|$)'
        match = re.search(pattern, hazard_content, re.DOTALL | re.IGNORECASE)
        
        if match:
            value = match.group(1).strip()
            value = re.sub(r'\s+', ' ', value)
            print(f"\n{field}:")
            print(f"  值: {value[:100]}")
        else:
            print(f"\n{field}: 未提取到")


if __name__ == '__main__':
    trace_flow()

