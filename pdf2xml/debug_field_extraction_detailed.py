#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
详细调试字段提取过程
"""

import sys
from pathlib import Path
import re

# 添加当前目录到Python路径
sys.path.insert(0, str(Path(__file__).parent))

from pdf_to_xml import extract_pdf_text
from msds_parser import MSDSParser
from xml_generator import XMLGenerator

def debug_field_extraction():
    """详细调试字段提取"""
    
    # 提取文本
    pdf_path = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\aboutproject\doc\(1R,2R,4R)-冰片-2-硫氰基醋酸酯、1,7,7-trimethylbicyclo(2,2,1)hept-2-yl thiocyanatoacetate、115-31-1.pdf"
    text = extract_pdf_text(pdf_path)
    
    # 解析章节
    parser = MSDSParser()
    parsed_info = parser.parse(text)
    sections = parsed_info.get('sections', {})
    
    # 获取危险性概述内容
    hazard_content = sections.get('危险性概述', '')
    print("="*80)
    print("危险性概述章节内容:")
    print("="*80)
    print(hazard_content)
    print("\n" + "="*80)
    
    # 创建XML生成器并测试字段提取
    xml_gen = XMLGenerator()
    
    # 测试危险性类别字段提取
    print("测试危险性类别字段提取:")
    print("-" * 40)
    
    field_names = ["危险性类别", "危险类别"]
    for field_name in field_names:
        print(f"\n尝试字段名: '{field_name}'")
        
        # 定义所有可能的下一个字段名
        all_field_names = [
            '危险性类别', '侵入途径', '健康危害', '环境危害', '燃爆危险',
            '有害物成分', '含量', 'CAS号',
            '皮肤接触', '眼睛接触', '吸入', '食入',
            '危险特性', '有害燃烧产物', '灭火方法', '建规火险分级',
            '应急处理', '小量泄漏', '大量泄漏',
            '操作注意事项', '储存注意事项',
            '中国MAC', '前苏联MAC', 'TLVTN', 'TLVWN', '接触限值', '监测方法',
            '工程控制', '呼吸系统防护', '眼睛防护', '身体防护', '手防护', '其他防护',
            'pH', '熔点', '沸点', '闪点', '相对密度', '相对蒸气密度', '溶解性', '分子式', '分子量', 
            '饱和蒸气压', '燃烧热', '临界温度', '临界压力', '辛醇/水分配系数', '外观与性状', '主要用途',
            '稳定性', '禁配物', '避免接触的条件', '聚合危害', '分解产物',
            '急性毒性', '亚急性和慢性毒性', 'RTECS', '刺激性', '致敏性', '致突变性', '致畸性', '致癌性',
            '生态毒理毒性', '生物降解性', '非生物降解性',
            '废弃物性质', '废弃处置方法', '废弃注意事项',
            '危险货物编号', 'UN编号', '包装类别', '包装标志', '包装方法', '运输注意事项',
            '法规信息', '化学危险物品安全管理条例', '化学危险物品安全管理条例实施细则',
            '参考文献', '编制说明', '修订说明'
        ]
        
        # 构建下一个字段的匹配模式
        next_fields_pattern = '|'.join([re.escape(f) for f in all_field_names])
        
        patterns = [
            # 匹配到下一个字段（跨行）
            rf'{re.escape(field_name)}\s*[:：]\s*(.*?)(?=\n(?:{next_fields_pattern})[:：]|$)',
            
            # 简单单行匹配
            rf'{re.escape(field_name)}\s*[:：]\s*([^\n]+)',
        ]
        
        for i, pattern in enumerate(patterns):
            print(f"  模式 {i+1}: {pattern}")
            match = re.search(pattern, hazard_content, re.DOTALL | re.IGNORECASE)
            if match:
                value = match.group(1).strip()
                # 清理多余的空白
                value = re.sub(r'\s+', ' ', value)
                value = value.strip()
                
                print(f"  SUCCESS: {value}")
                break
            else:
                print(f"  FAILED")
        else:
            print(f"  所有模式都失败")
    
    # 测试XML生成器的_extract_field_value方法
    print("\n" + "="*80)
    print("测试XML生成器的_extract_field_value方法:")
    print("="*80)
    
    result = xml_gen._extract_field_value(hazard_content, ["危险性类别", "危险类别"])
    print(f"XML生成器结果: '{result}'")


if __name__ == '__main__':
    debug_field_extraction()
