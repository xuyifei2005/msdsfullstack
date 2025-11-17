#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
对比XML质量 - 找出转换结果与目标的差异
"""

import xml.etree.ElementTree as ET

def analyze_xml(xml_path):
    """分析XML文件的结构和数据完整性"""
    tree = ET.parse(xml_path)
    root = tree.getroot()
    msds = root.find('msds')
    
    stats = {
        'total_sections': 0,
        'filled_sections': 0,
        'empty_sections': 0,
        'total_fields': 0,
        'filled_fields': 0,
        'empty_fields': 0,
        'sections_detail': {}
    }
    
    # 分析每个章节
    for child in msds:
        if child.tag in ['basic_info', 'hazard_info', 'component_info', 'first_aid', 
                         'fire_fighting', 'leak_response', 'handling_storage', 
                         'exposure_control', 'physical_chemical', 'stability_reactivity',
                         'toxicological', 'ecological', 'disposal', 'transportation',
                         'regulatory', 'other_info']:
            
            stats['total_sections'] += 1
            section_fields = list(child)
            section_name = child.tag
            
            if section_fields:
                # 有子字段的章节
                filled_count = sum(1 for f in section_fields if f.text and f.text.strip())
                total_count = len(section_fields)
                
                stats['total_fields'] += total_count
                stats['filled_fields'] += filled_count
                stats['empty_fields'] += (total_count - filled_count)
                
                if filled_count > 0:
                    stats['filled_sections'] += 1
                else:
                    stats['empty_sections'] += 1
                
                stats['sections_detail'][section_name] = {
                    'total_fields': total_count,
                    'filled_fields': filled_count,
                    'empty_fields': total_count - filled_count,
                    'completeness': f"{filled_count}/{total_count} ({filled_count/total_count*100:.1f}%)" if total_count > 0 else "0/0"
                }
            else:
                # 直接文本内容的章节
                if child.text and child.text.strip():
                    stats['filled_sections'] += 1
                    stats['sections_detail'][section_name] = {
                        'total_fields': 1,
                        'filled_fields': 1,
                        'empty_fields': 0,
                        'completeness': "1/1 (100%)"
                    }
                else:
                    stats['empty_sections'] += 1
                    stats['sections_detail'][section_name] = {
                        'total_fields': 1,
                        'filled_fields': 0,
                        'empty_fields': 1,
                        'completeness': "0/1 (0%)"
                    }
    
    return stats


def main():
    """主函数"""
    print("="*80)
    print("XML质量对比分析")
    print("="*80)
    
    # 目标XML（手工制作的完美版本）
    target_xml = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\pdf2xml\output\(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.xml"
    
    # 当前转换的XML
    current_xml = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\pdf2xml\output\(1R,2R,4R)-冰片-2-硫氰基醋酸酯、1,7,7-trimethylbicyclo(2,2,1)hept-2-yl thiocyanatoacetate、115-31-1.xml"
    
    print("\n分析目标XML（完美版本）...")
    target_stats = analyze_xml(target_xml)
    
    print("\n分析当前XML（转换结果）...")
    current_stats = analyze_xml(current_xml)
    
    # 对比
    print("\n" + "="*80)
    print("整体对比")
    print("="*80)
    
    print("\n目标XML:")
    print(f"  总章节数: {target_stats['total_sections']}")
    print(f"  有数据章节: {target_stats['filled_sections']}")
    print(f"  空章节: {target_stats['empty_sections']}")
    print(f"  总字段数: {target_stats['total_fields']}")
    print(f"  有数据字段: {target_stats['filled_fields']}")
    print(f"  空字段: {target_stats['empty_fields']}")
    print(f"  数据完整性: {target_stats['filled_fields']/target_stats['total_fields']*100:.1f}%")
    
    print("\n当前XML:")
    print(f"  总章节数: {current_stats['total_sections']}")
    print(f"  有数据章节: {current_stats['filled_sections']}")
    print(f"  空章节: {current_stats['empty_sections']}")
    print(f"  总字段数: {current_stats['total_fields']}")
    print(f"  有数据字段: {current_stats['filled_fields']}")
    print(f"  空字段: {current_stats['empty_fields']}")
    print(f"  数据完整性: {current_stats['filled_fields']/current_stats['total_fields']*100:.1f}%")
    
    # 详细对比
    print("\n" + "="*80)
    print("章节详细对比")
    print("="*80)
    
    all_sections = set(target_stats['sections_detail'].keys()) | set(current_stats['sections_detail'].keys())
    
    for section in sorted(all_sections):
        target_detail = target_stats['sections_detail'].get(section, {})
        current_detail = current_stats['sections_detail'].get(section, {})
        
        target_comp = target_detail.get('completeness', 'N/A')
        current_comp = current_detail.get('completeness', 'N/A')
        
        print(f"\n{section}:")
        print(f"  目标: {target_comp}")
        print(f"  当前: {current_comp}")
        
        if target_detail.get('filled_fields', 0) > current_detail.get('filled_fields', 0):
            diff = target_detail['filled_fields'] - current_detail.get('filled_fields', 0)
            print(f"  差距: 缺少 {diff} 个字段")


if __name__ == '__main__':
    main()

