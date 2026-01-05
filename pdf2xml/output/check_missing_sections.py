import xml.etree.ElementTree as ET
import glob

files = glob.glob(r'D:\XUYIFEI\XUPROJECTS\msdsfullstack\pdf2xml\output\*622-68-4*.xml')
print(f"找到文件: {files}")

if files:
    file_path = files[0]
    print(f"\n读取文件: {file_path}")
    
    tree = ET.parse(file_path)
    root = tree.getroot()
    
    msds = root.find('msds')
    
    if msds is not None:
        print("\nmsds元素下的所有直接子元素:")
        for i, child in enumerate(msds, 1):
            print(f"  {i}. {child.tag}")
        
        print("\n检查特定部分:")
        
        # 检查hazard_overview
        hazard_overview = msds.find('hazard_overview')
        if hazard_overview is not None:
            print("✓ 找到hazard_overview")
            for child in hazard_overview:
                print(f"  - {child.tag}: {child.text[:50] if child.text else 'None'}...")
        else:
            print("✗ 未找到hazard_overview")
        
        # 检查composition
        composition = msds.find('composition')
        if composition is not None:
            print("✓ 找到composition")
            for child in composition:
                print(f"  - {child.tag}: {child.text[:50] if child.text else 'None'}...")
        else:
            print("✗ 未找到composition")
        
        # 检查其他可能相关的标签
        print("\n查找可能相关的标签:")
        for child in msds:
            if 'compos' in child.tag.lower() or 'hazard' in child.tag.lower():
                print(f"  - {child.tag}")
