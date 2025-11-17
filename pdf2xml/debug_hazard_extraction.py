#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from msds_parser import MSDSParser
import re

def debug_hazard_extraction():
    """调试危险性概述字段提取"""
    
    # 测试PDF文件
    pdf_path = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\aboutproject\doc\(1R,2R,4R)-冰片-2-硫氰基醋酸酯、1,7,7-trimethylbicyclo(2,2,1)hept-2-yl thiocyanatoacetate、115-31-1.pdf"
    
    if not os.path.exists(pdf_path):
        print(f"PDF文件不存在: {pdf_path}")
        return
    
    # 解析PDF
    from pdfplumber import open as pdf_open
    with pdf_open(pdf_path) as pdf:
        text = ""
        for page in pdf.pages:
            text += page.extract_text() or ""
    
    parser = MSDSParser()
    msds_data = parser.parse(text)
    
    if not msds_data:
        print("PDF解析失败")
        return
    
    # 获取危险性概述内容
    sections = msds_data.get('sections', {})
    hazard_content = sections.get('危险性概述', '')
    
    print("=" * 80)
    print("危险性概述原始内容:")
    print("=" * 80)
    print(hazard_content)
    print("=" * 80)
    
    # 测试各个字段的提取
    fields_to_test = [
        ("危险性类别", ["危险性类别", "危险类别"]),
        ("侵入途径", ["侵入途径", "接触途径"]),
        ("健康危害", ["健康危害", "健康危险"]),
        ("环境危害", ["环境危害", "环境危险"]),
        ("燃爆危险", ["燃爆危险", "燃烧爆炸危险"])
    ]
    
    for field_name, patterns in fields_to_test:
        print(f"\n测试字段: {field_name}")
        print("-" * 40)
        
        # 使用与xml_generator.py相同的逻辑
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
        
        next_fields_pattern = '|'.join([re.escape(f) for f in all_field_names])
        
        for pattern_name in patterns:
            patterns_to_test = [
                # 匹配到下一个字段（跨行）
                rf'{re.escape(pattern_name)}\s*[:：]\s*(.*?)(?=\n(?:{next_fields_pattern})[:：]|$)',
                # 简单单行匹配
                rf'{re.escape(pattern_name)}\s*[:：]\s*([^\n]+)',
            ]
            
            for i, pattern in enumerate(patterns_to_test):
                match = re.search(pattern, hazard_content, re.DOTALL | re.IGNORECASE)
                if match:
                    value = match.group(1).strip()
                    value = re.sub(r'\s+', ' ', value)
                    value = value.strip()
                    
                    print(f"  模式 {i+1} 匹配成功:")
                    print(f"    值: {repr(value)}")
                    print(f"    长度: {len(value)}")
                    break
            else:
                print(f"  模式 {pattern_name} 未匹配")

if __name__ == "__main__":
    debug_hazard_extraction()
