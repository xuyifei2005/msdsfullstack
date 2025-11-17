#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
分析PDF格式差异
帮助了解为什么某些PDF的章节无法被正确提取
"""

import os
import sys
from pathlib import Path

# 添加当前目录到Python路径
sys.path.insert(0, str(Path(__file__).parent))

from pdf_to_xml import extract_pdf_text
import re

def analyze_pdf(pdf_path):
    """分析单个PDF的格式"""
    print(f"\n{'='*80}")
    print(f"分析PDF: {os.path.basename(pdf_path)}")
    print('='*80)
    
    # 提取文本
    text = extract_pdf_text(pdf_path)
    print(f"文本长度: {len(text)} 字符")
    
    # 显示前500字符
    print("\n前500字符预览:")
    print("-" * 80)
    print(text[:500])
    print("-" * 80)
    
    # 分析章节标题格式
    chapter_patterns = [
        (r'第\s*(\d+)\s*[章节部分][:：]\s*([^\n]+)', '标准格式: 第X部分：名称'),
        (r'(\d+)\.\s*([^\n]+)', '编号格式: X. 名称'),
        (r'([一二三四五六七八九十百]+)[、.]\s*([^\n]+)', '中文数字: X、名称'),
    ]
    
    print("\n章节标题分析:")
    for pattern, desc in chapter_patterns:
        matches = re.findall(pattern, text[:1000])  # 只分析前1000字符
        if matches:
            print(f"\n找到匹配 ({desc}):")
            for match in matches[:5]:  # 只显示前5个
                print(f"  {match}")
    
    # 分析字段分隔符
    separator_patterns = [
        (r'[:：]', '冒号分隔'),
        (r'[：]', '中文冒号'),
        (r'[:  ]', '英文冒号'),
    ]
    
    print("\n字段分隔符分析:")
    for pattern, desc in separator_patterns:
        count = len(re.findall(pattern, text[:1000]))
        if count > 0:
            print(f"  {desc}: {count}个")
    
    # 检查关键章节名称
    section_names = [
        "化学品及企业标识",
        "危险性概述",
        "成分/组成信息",
        "急救措施",
        "消防措施",
        "泄漏应急处理",
        "操作处置与储存",
        "接触控制",
        "理化特性",
        "稳定性和反应",
        "毒理学信息",
        "生态学信息",
        "废弃处置",
        "运输信息",
        "法规信息",
        "其他信息"
    ]
    
    print("\n章节名称检查:")
    for section in section_names:
        if section in text:
            idx = text.find(section)
            context = text[max(0, idx-20):idx+len(section)+50]
            print(f"  ✓ {section}")
            print(f"    上下文: ...{context}...")
        else:
            print(f"  ✗ {section} (未找到)")
    
    return {
        'text_length': len(text),
        'text_preview': text[:500],
        'has_standard_format': bool(re.search(r'第\s*\d+\s*[章节部分]', text)),
        'sections_found': [s for s in section_names if s in text]
    }


def main():
    """主函数"""
    import glob
    
    # PDF目录
    pdf_dir = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\aboutproject\doc"
    
    # 获取所有PDF文件
    pdf_files = glob.glob(os.path.join(pdf_dir, "*.pdf"))
    print(f"找到 {len(pdf_files)} 个PDF文件")
    
    # 分析每个PDF
    results = {}
    for pdf_file in pdf_files[:5]:  # 只分析前5个
        try:
            result = analyze_pdf(pdf_file)
            results[os.path.basename(pdf_file)] = result
        except Exception as e:
            print(f"分析失败: {e}")
    
    # 总结
    print("\n" + "="*80)
    print("总结")
    print("="*80)
    
    print("\n标准格式使用情况:")
    standard_count = sum(1 for r in results.values() if r['has_standard_format'])
    print(f"  使用标准格式: {standard_count}/{len(results)}")
    print(f"  非标准格式: {len(results) - standard_count}/{len(results)}")
    
    print("\n章节完整性:")
    for name, result in results.items():
        sections_count = len(result['sections_found'])
        print(f"  {name[:50]}: {sections_count}/16 章节")


if __name__ == '__main__':
    main()


