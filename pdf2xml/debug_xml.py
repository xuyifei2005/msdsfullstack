#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
调试XML文件结构
"""

import xml.etree.ElementTree as ET

def debug_xml_structure():
    """调试XML文件结构"""
    xml_file = "output/(1,4,5,6,7,7-六氯-8,9,10-三降冰片-5-烯-2,3-亚基双亚甲基)亚硫酸酯、1,2,3,4,7,7-hexachloro-8,9,10-trinorborn-2-en-5,6-ylenedimethyl、115-29-7.xml"
    
    try:
        tree = ET.parse(xml_file)
        root = tree.getroot()
        
        print("XML文件结构分析:")
        print(f"根元素: {root.tag}")
        print(f"根元素属性: {root.attrib}")
        print("\n直接子元素:")
        
        for child in root:
            print(f"  - {child.tag}: {child.text[:50] if child.text else 'None'}...")
            
        # 检查hazard_info
        hazard = root.find('hazard_info')
        print(f"\nhazard_info元素: {'存在' if hazard is not None else '不存在'}")
        
        if hazard is not None:
            print("hazard_info子元素:")
            for child in hazard:
                print(f"  - {child.tag}: {child.text[:50] if child.text else 'None'}...")
        
        # 检查msds元素
        msds = root.find('msds')
        print(f"\nmsds元素: {'存在' if msds is not None else '不存在'}")
        
        if msds is not None:
            print("msds子元素:")
            for child in msds:
                print(f"  - {child.tag}: {child.text[:50] if child.text else 'None'}...")
                
            # 在msds中查找hazard_info
            hazard_in_msds = msds.find('hazard_info')
            print(f"\nmsds中的hazard_info: {'存在' if hazard_in_msds is not None else '不存在'}")
            
            if hazard_in_msds is not None:
                print("msds中hazard_info子元素:")
                for child in hazard_in_msds:
                    print(f"  - {child.tag}: {child.text[:50] if child.text else 'None'}...")
        
    except Exception as e:
        print(f"错误: {e}")

if __name__ == '__main__':
    debug_xml_structure()
