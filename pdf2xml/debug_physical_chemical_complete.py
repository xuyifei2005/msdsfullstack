#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from msds_parser import MSDSParser
from xml_generator import XMLGenerator

def debug_physical_chemical_complete():
    """完整调试理化特性字段提取"""
    
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
    
    # 获取理化特性内容
    sections = msds_data.get('sections', {})
    phys_content = sections.get('理化特性', '')
    
    print("=" * 80)
    print("理化特性原始内容:")
    print("=" * 80)
    print(phys_content)
    print("=" * 80)
    
    # 按行分析内容
    lines = phys_content.split('\n')
    print(f"\n按行分析内容 (共{len(lines)}行):")
    for i, line in enumerate(lines):
        print(f"行 {i+1:2d}: {repr(line)}")
    
    # 测试专门的理化特性字段提取方法
    generator = XMLGenerator()
    fields = generator._extract_physical_chemical_fields(phys_content)
    
    print("\n" + "=" * 80)
    print("专门的理化特性字段提取结果:")
    print("=" * 80)
    
    # 检查所有应该有的字段
    expected_fields = {
        "pH": "pH",
        "熔点": "melting_point", 
        "沸点": "boiling_point",
        "闪点": "flash_point",
        "相对密度": "relative_density",
        "相对蒸气密度": "relative_vapor_density",
        "溶解性": "solubility",
        "分子式": "molecular_formula",
        "分子量": "molecular_weight",
        "主要成分": "main_components",
        "饱和蒸气压": "saturated_vapor_pressure",
        "辛醇/水分配系数的对数值": "log_kow",
        "临界温度": "critical_temperature",
        "引燃温度": "ignition_temperature",
        "自燃温度": "autoignition_temperature",
        "燃烧性": "flammability",
        "外观与性状": "appearance",
        "主要用途": "main_uses",
        "其它理化性质": "other_properties",
        "燃烧热": "heat_of_combustion",
        "临界压力": "critical_pressure",
        "爆炸上限": "explosive_upper_limit",
        "爆炸下限": "explosive_lower_limit"
    }
    
    for field_name, xml_tag in expected_fields.items():
        if field_name in fields:
            value = fields[field_name]
            print(f"OK {field_name}: {repr(value)}")
        else:
            print(f"NO {field_name}: 未找到")
    
    # 特别检查问题字段
    print(f"\n问题字段检查:")
    problem_fields = ["溶解性", "外观与性状", "主要用途", "主要成分", "饱和蒸气压", "辛醇/水分配系数的对数值"]
    for field in problem_fields:
        if field in fields:
            print(f"OK {field}: {repr(fields[field])}")
        else:
            print(f"NO {field}: 未找到")

if __name__ == "__main__":
    debug_physical_chemical_complete()
