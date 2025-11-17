#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
增强版转换测试脚本
测试新的XML生成器是否能生成与目标格式一致的XML
"""

import os
import sys
import logging
from pathlib import Path

# 添加当前目录到Python路径
sys.path.insert(0, str(Path(__file__).parent))

from pdf_to_xml import extract_pdf_text
from msds_parser import MSDSParser
from xml_generator import XMLGenerator, XMLValidator

def test_enhanced_conversion():
    """测试增强版转换"""
    
    # 配置日志
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
    logger = logging.getLogger(__name__)
    
    # 测试文件路径
    test_pdf = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\aboutproject\doc\(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf"
    output_xml = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\pdf2xml\output\enhanced_test.xml"
    
    print("=" * 80)
    print("增强版MSDS PDF转换测试")
    print("=" * 80)
    print(f"输入PDF: {test_pdf}")
    print(f"输出XML: {output_xml}")
    print()
    
    # 检查输入文件
    if not os.path.exists(test_pdf):
        print(f"错误: 输入文件不存在: {test_pdf}")
        return False
    
    try:
        # 1. 提取PDF文本
        print("步骤1: 提取PDF文本...")
        text = extract_pdf_text(test_pdf)
        print(f"   提取文本长度: {len(text)} 字符")
        
        if len(text) < 100:
            print("错误: 提取的文本内容过少")
            return False
        
        # 2. 解析MSDS信息
        print("\n步骤2: 解析MSDS信息...")
        parser = MSDSParser()
        
        # 从文件名提取信息
        filename = os.path.basename(test_pdf)
        filename_info = parser.extract_from_filename(filename)
        print(f"   文件名信息: {filename_info}")
        
        # 解析PDF内容
        parsed_info = parser.parse(text)
        print(f"   基本信息: {parsed_info.get('basic_info', {})}")
        
        # 合并信息
        msds_data = parser.merge_info(parsed_info, filename_info)
        print(f"   合并后信息: {msds_data.get('basic_info', {})}")
        
        # 验证数据
        is_valid, errors = parser.validate(msds_data)
        if not is_valid:
            print(f"   警告: 数据验证警告: {', '.join(errors)}")
        else:
            print("   成功: 数据验证通过")
        
        # 显示章节信息
        sections = msds_data.get('sections', {})
        filled_sections = len([s for s in sections.values() if s])
        print(f"   章节完整度: {filled_sections}/{len(sections)}")
        
        # 显示每个章节的状态和内容预览
        print("   章节状态和内容预览:")
        for i, section_name in enumerate(parser.sections, 1):
            content = sections.get(section_name, '')
            status = "成功" if content else "失败"
            preview = content[:50] + "..." if len(content) > 50 else content
            print(f"     {i:2d}. {status} {section_name}: {preview}")
        
        # 3. 生成XML
        print("\n步骤3: 生成增强版XML...")
        generator = XMLGenerator()
        success = generator.generate(msds_data, output_xml)
        
        if success:
            print(f"   成功: XML生成成功: {output_xml}")
            
            # 4. 验证XML
            print("\n步骤4: 验证XML...")
            is_valid, message = XMLValidator.validate_xml(output_xml)
            
            if is_valid:
                print(f"   成功: XML验证通过: {message}")
            else:
                print(f"   错误: XML验证失败: {message}")
                return False
        else:
            print("   错误: XML生成失败")
            return False
        
        print("\n" + "=" * 80)
        print("成功: 增强版转换完成！")
        print("=" * 80)
        
        # 显示结果摘要
        basic_info = msds_data.get('basic_info', {})
        print("\n转换结果摘要:")
        print(f"   化学品名称(中): {basic_info.get('chemical_name_cn', '未提取')}")
        print(f"   化学品名称(英): {basic_info.get('chemical_name_en', '未提取')}")
        print(f"   CAS号: {basic_info.get('cas_number', '未提取')}")
        print(f"   分子式: {basic_info.get('molecular_formula', '未提取')}")
        print(f"   分子量: {basic_info.get('molecular_weight', '未提取')}")
        print(f"   章节完整度: {filled_sections}/{len(sections)}")
        
        # 显示XML文件预览
        print("\nXML文件预览:")
        try:
            with open(output_xml, 'r', encoding='utf-8') as f:
                lines = f.readlines()
                for i, line in enumerate(lines[:30]):  # 显示前30行
                    print(f"   {i+1:2d}: {line.rstrip()}")
                if len(lines) > 30:
                    print(f"   ... 还有 {len(lines) - 30} 行")
        except Exception as e:
            print(f"   无法读取XML文件: {e}")
        
        return True
        
    except Exception as e:
        print(f"\n错误: 测试失败: {e}")
        import traceback
        traceback.print_exc()
        return False


def main():
    """主函数"""
    print("增强版MSDS PDF转换测试")
    print("测试新的XML生成器是否能生成与目标格式一致的XML")
    print()
    
    success = test_enhanced_conversion()
    
    if success:
        print("\n成功: 增强版转换测试成功！")
        print("现在可以开始批量转换了")
        return 0
    else:
        print("\n失败: 增强版转换测试失败！")
        return 1


if __name__ == '__main__':
    sys.exit(main())
