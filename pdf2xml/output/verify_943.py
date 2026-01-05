import os
import xml.etree.ElementTree as ET

file_path = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\pdf2xml\output\4-二甲氨基偶氮苯-4'-胂酸、4-dimethylaminoazobenzene-4'-arsonic acid、622-68-4.xml"

try:
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
        print("文件读取成功！")
        print(f"文件长度: {len(content)} 字符")
        
        # 解析XML
        root = ET.fromstring(content)
        
        # 检查关键部分是否存在
        sections = [
            "化学品及企业标识",
            "危险性概述",
            "成分/组成信息",
            "急救措施",
            "消防措施",
            "泄漏应急处理",
            "操作处置与储存",
            "接触控制/个体防护",
            "理化特性",
            "稳定性和反应活性",
            "毒理学信息",
            "生态学资料",
            "废弃处置",
            "运输信息",
            "法规信息",
            "其他信息"
        ]
        
        print("\n检查MSDS文档结构完整性：")
        for section in sections:
            # 查找包含该部分名称的标签
            found = section in content
            status = "✓" if found else "✗"
            print(f"{status} {section}")
        
        # 检查msds_code字段
        msds_code = root.findtext(".//msds_code")
        print(f"\nmsds_code: {msds_code}")
        
        # 检查供应商信息
        company_name = root.findtext(".//company_name")
        print(f"company_name: {company_name}")
        
        # 检查理化特性
        physical = root.find(".//physical_chemical")
        if physical is not None:
            print("\n理化特性数据：")
            for child in physical:
                print(f"  {child.tag}: {child.text}")
        
except Exception as e:
    print(f"读取文件时出错: {e}")
    import traceback
    traceback.print_exc()
