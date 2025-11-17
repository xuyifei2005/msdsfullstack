#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
调试字段提取问题
"""

import sys
import re
from pathlib import Path

# 添加当前目录到Python路径
sys.path.insert(0, str(Path(__file__).parent))

from pdf_to_xml import extract_pdf_text
from msds_parser import MSDSParser

def test_field_extraction():
    """测试字段提取"""
    
    # 提取文本
    pdf_path = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\aboutproject\doc\(1R,2R,4R)-冰片-2-硫氰基醋酸酯、1,7,7-trimethylbicyclo(2,2,1)hept-2-yl thiocyanatoacetate、115-31-1.pdf"
    text = extract_pdf_text(pdf_path)
    
    # 解析章节
    parser = MSDSParser()
    parsed = parser.parse(text)
    sections = parsed['sections']
    
    # 测试危险性概述章节
    hazard_content = sections.get('危险性概述', '')
    print("="*80)
    print("危险性概述章节内容:")
    print("="*80)
    print(hazard_content)
    print()
    
    # 测试字段提取
    print("="*80)
    print("字段提取测试:")
    print("="*80)
    
    fields_to_extract = [
        ("危险性类别", ["危险性类别", "危险类别"]),
        ("侵入途径", ["侵入途径", "接触途径"]),
        ("健康危害", ["健康危害", "健康危险"]),
        ("环境危害", ["环境危害", "环境危险"]),
        ("燃爆危险", ["燃爆危险", "燃烧爆炸"]),
    ]
    
    for field_display, field_names in fields_to_extract:
        for field_name in field_names:
            # 尝试提取
            pattern = rf'{re.escape(field_name)}\s*[:：]\s*([^\n]+)'
            match = re.search(pattern, hazard_content, re.IGNORECASE)
            if match:
                value = match.group(1).strip()
                print(f"[OK] {field_display} (模式: {field_name})")
                print(f"  值: {value}")
                print()
                break
        else:
            print(f"[NO] {field_display} - 未找到")
            print(f"  尝试的字段名: {field_names}")
            print()
    
    # 测试急救措施章节
    first_aid_content = sections.get('急救措施', '')
    print("="*80)
    print("急救措施章节内容:")
    print("="*80)
    print(first_aid_content)
    print()
    
    # 测试急救措施字段提取
    print("="*80)
    print("急救措施字段提取测试:")
    print("="*80)
    
    first_aid_fields = [
        ("皮肤接触", ["皮肤接触", "皮肤"]),
        ("眼睛接触", ["眼睛接触", "眼部"]),
        ("吸入", ["吸入"]),
        ("食入", ["食入", "误服"]),
    ]
    
    for field_display, field_names in first_aid_fields:
        for field_name in field_names:
            pattern = rf'{re.escape(field_name)}\s*[:：]\s*([^眼皮吸食]+)'
            match = re.search(pattern, first_aid_content, re.IGNORECASE)
            if match:
                value = match.group(1).strip()
                print(f"[OK] {field_display}")
                print(f"  值: {value[:100]}")
                print()
                break
        else:
            print(f"[NO] {field_display} - 未找到")
            print()


if __name__ == '__main__':
    test_field_extraction()

