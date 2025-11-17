#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
测试特定PDF格式的转换
针对 (1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯 类型PDF
"""

import os
import sys
import logging
from pathlib import Path

# 添加当前目录到Python路径
sys.path.insert(0, str(Path(__file__).parent))

from pdf_to_xml import extract_pdf_text, convert_pdf_to_xml
from msds_parser import MSDSParser
from xml_generator import XMLGenerator, XMLValidator
# from config import setup_logging  # 不需要这个导入

def test_specific_pdf():
    """测试特定PDF格式的转换"""
    
    # 配置日志
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
    logger = logging.getLogger(__name__)
    
    # 测试文件路径
    test_pdf = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\aboutproject\doc\(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.pdf"
    output_xml = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\pdf2xml\output\test_specific_format.xml"
    
    print("=" * 80)
    print("测试特定PDF格式转换")
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
        
        # 显示文本前500字符
        print("   文本预览:")
        print("   " + "-" * 50)
        print("   " + text[:500] + "...")
        print("   " + "-" * 50)
        
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
        
        # 显示每个章节的状态
        print("   章节状态:")
        for i, section_name in enumerate(parser.sections, 1):
            content = sections.get(section_name, '')
            status = "成功" if content else "失败"
            print(f"     {i:2d}. {status} {section_name}")
        
        # 3. 生成XML
        print("\n步骤3: 生成XML...")
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
        print("成功: 测试完成！转换成功")
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
        
        return True
        
    except Exception as e:
        print(f"\n错误: 测试失败: {e}")
        import traceback
        traceback.print_exc()
        return False


def main():
    """主函数"""
    print("MSDS PDF特定格式转换测试")
    print("针对: (1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯")
    print()
    
    success = test_specific_pdf()
    
    if success:
        print("\n成功: 测试成功！可以开始批量转换")
        return 0
    else:
        print("\n失败: 测试失败！请检查配置和依赖")
        return 1


if __name__ == '__main__':
    sys.exit(main())
