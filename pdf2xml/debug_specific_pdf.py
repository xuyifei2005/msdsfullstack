#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
调试特定PDF的解析问题
"""

import sys
from pathlib import Path

# 添加当前目录到Python路径
sys.path.insert(0, str(Path(__file__).parent))

from pdf_to_xml import extract_pdf_text
from msds_parser import MSDSParser

def debug_pdf(pdf_path):
    """调试PDF解析"""
    print("=" * 80)
    print(f"调试PDF: {pdf_path}")
    print("=" * 80)
    
    # 1. 提取文本
    print("\n步骤1: 提取PDF文本...")
    text = extract_pdf_text(pdf_path)
    print(f"提取文本长度: {len(text)} 字符")
    
    # 显示前1000字符
    print("\n前1000字符预览:")
    print("-" * 80)
    print(text[:1000])
    print("-" * 80)
    
    # 2. 解析章节
    print("\n步骤2: 解析章节...")
    parser = MSDSParser()
    parsed_info = parser.parse(text)
    
    sections = parsed_info.get('sections', {})
    print(f"\n章节提取结果: {len([s for s in sections.values() if s])}/{len(sections)}")
    
    # 显示每个章节的内容
    for i, section_name in enumerate(parser.sections, 1):
        content = sections.get(section_name, '')
        status = "SUCCESS" if content else "FAILED"
        print(f"\n{i:2d}. {status} {section_name}")
        if content:
            # 显示前200字符
            preview = content[:200] + "..." if len(content) > 200 else content
            print(f"   内容: {preview}")
        else:
            # 尝试在文本中搜索章节名
            if section_name in text:
                print(f"   提示: 章节名'{section_name}'在文本中存在，但未被正确提取")
                # 显示章节名周围的文本
                idx = text.find(section_name)
                context = text[max(0, idx-100):idx+300]
                print(f"   上下文: ...{context}...")
            else:
                print(f"   提示: 章节名'{section_name}'在文本中不存在")
    
    # 3. 显示基本信息
    print("\n步骤3: 基本信息提取结果...")
    basic_info = parsed_info.get('basic_info', {})
    for key, value in basic_info.items():
        print(f"   {key}: {value}")
    
    return text, parsed_info


def main():
    """主函数"""
    # 测试两个PDF文件
    pdf1 = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\aboutproject\doc\(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf"
    pdf2 = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\aboutproject\doc\(1R,2R,4R)-冰片-2-硫氰基醋酸酯、1,7,7-trimethylbicyclo(2,2,1)hept-2-yl thiocyanatoacetate、115-31-1.pdf"
    
    print("测试PDF 1 (好的例子):")
    text1, parsed1 = debug_pdf(pdf1)
    
    print("\n\n" + "=" * 80)
    print("=" * 80)
    print("\n测试PDF 2 (有问题的例子):")
    text2, parsed2 = debug_pdf(pdf2)
    
    # 对比两个文本的差异
    print("\n\n" + "=" * 80)
    print("文本格式对比:")
    print("=" * 80)
    print(f"PDF1 文本长度: {len(text1)} 字符")
    print(f"PDF2 文本长度: {len(text2)} 字符")
    
    # 检查是否包含章节关键词
    sections_to_check = ["危险性概述", "急救措施", "消防措施", "接触控制"]
    for section in sections_to_check:
        in_pdf1 = section in text1
        in_pdf2 = section in text2
        print(f"\n'{section}':")
        print(f"  PDF1: {'YES' if in_pdf1 else 'NO'}")
        print(f"  PDF2: {'YES' if in_pdf2 else 'NO'}")


if __name__ == '__main__':
    main()

