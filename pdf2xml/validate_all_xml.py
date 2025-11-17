#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
验证所有生成的XML文件
"""

import os
import xml.etree.ElementTree as ET
from pathlib import Path
from collections import defaultdict

def validate_xml_structure(xml_path):
    """验证XML结构完整性"""
    try:
        tree = ET.parse(xml_path)
        root = tree.getroot()
        
        stats = {
            'valid': True,
            'sections_found': 0,
            'empty_sections': 0,
            'has_basic_info': False,
            'has_cas_number': False,
            'errors': []
        }
        
        # 检查基本信息
        basic_info = root.find('.//basic_info')
        if basic_info is not None:
            stats['has_basic_info'] = True
            cas = basic_info.find('cas_number')
            if cas is not None and cas.text:
                stats['has_cas_number'] = True
        
        # 检查所有章节标签
        section_tags = [
            'hazard_info', 'component_info', 'first_aid', 'fire_fighting',
            'leak_response', 'handling_storage', 'exposure_control',
            'physical_chemical', 'stability_reactivity', 'toxicological',
            'ecological', 'disposal', 'transportation', 'regulatory'
        ]
        
        for tag in section_tags:
            section = root.find(f'.//{tag}')
            if section is not None:
                stats['sections_found'] += 1
                # 检查是否所有子元素都为空
                if all(not child.text or not child.text.strip() for child in section):
                    stats['empty_sections'] += 1
        
        return stats
        
    except ET.ParseError as e:
        return {
            'valid': False,
            'errors': [f'XML解析错误: {str(e)}']
        }
    except Exception as e:
        return {
            'valid': False,
            'errors': [f'未知错误: {str(e)}']
        }

def main():
    """主函数"""
    output_dir = Path('output')
    
    if not output_dir.exists():
        print("输出目录不存在！")
        return
    
    xml_files = list(output_dir.glob('*.xml'))
    
    if not xml_files:
        print("没有找到XML文件！")
        return
    
    print("="*80)
    print(f"XML文件质量验证")
    print("="*80)
    print(f"输出目录: {output_dir.absolute()}")
    print(f"XML文件数: {len(xml_files)}")
    print()
    
    # 统计信息
    total_stats = {
        'total': len(xml_files),
        'valid': 0,
        'invalid': 0,
        'has_basic_info': 0,
        'has_cas_number': 0,
        'sections_distribution': defaultdict(int),
        'empty_sections_distribution': defaultdict(int)
    }
    
    invalid_files = []
    
    # 验证每个文件
    for xml_file in xml_files:
        stats = validate_xml_structure(xml_file)
        
        if stats['valid']:
            total_stats['valid'] += 1
            if stats['has_basic_info']:
                total_stats['has_basic_info'] += 1
            if stats['has_cas_number']:
                total_stats['has_cas_number'] += 1
            
            total_stats['sections_distribution'][stats['sections_found']] += 1
            total_stats['empty_sections_distribution'][stats['empty_sections']] += 1
        else:
            total_stats['invalid'] += 1
            invalid_files.append((xml_file.name, stats['errors']))
    
    # 显示统计结果
    print("验证结果:")
    print("-"*80)
    print(f"✅ 有效文件: {total_stats['valid']}/{total_stats['total']}")
    print(f"❌ 无效文件: {total_stats['invalid']}/{total_stats['total']}")
    print(f"📋 包含基本信息: {total_stats['has_basic_info']}/{total_stats['total']}")
    print(f"🔢 包含CAS号: {total_stats['has_cas_number']}/{total_stats['total']}")
    print()
    
    # 章节完整性统计
    print("章节完整性分布:")
    print("-"*80)
    for sections_count in sorted(total_stats['sections_distribution'].keys(), reverse=True):
        count = total_stats['sections_distribution'][sections_count]
        percentage = (count / total_stats['total'] * 100)
        print(f"  {sections_count}/14 个章节: {count} 个文件 ({percentage:.1f}%)")
    print()
    
    # 空章节统计
    print("空章节分布:")
    print("-"*80)
    for empty_count in sorted(total_stats['empty_sections_distribution'].keys()):
        count = total_stats['empty_sections_distribution'][empty_count]
        percentage = (count / total_stats['total'] * 100)
        print(f"  {empty_count} 个空章节: {count} 个文件 ({percentage:.1f}%)")
    print()
    
    # 显示无效文件
    if invalid_files:
        print("无效文件列表:")
        print("-"*80)
        for filename, errors in invalid_files:
            print(f"❌ {filename}")
            for error in errors:
                print(f"   - {error}")
        print()
    
    # 总结
    success_rate = (total_stats['valid'] / total_stats['total'] * 100)
    print("="*80)
    print("验证完成！")
    print("="*80)
    print(f"成功率: {success_rate:.2f}%")
    
    if total_stats['valid'] == total_stats['total']:
        print("🎉 所有XML文件格式正确！")
    else:
        print(f"⚠️  发现 {total_stats['invalid']} 个文件存在问题")

if __name__ == '__main__':
    main()

