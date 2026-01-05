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
        # 检查hazard_info
        hazard_info = msds.find('hazard_info')
        if hazard_info is not None:
            print("\n=== hazard_info 内容 ===")
            for child in hazard_info:
                text = child.text or ''
                print(f"{child.tag}: {text[:100] if len(text) > 100 else text}")
        
        # 检查component_info
        component_info = msds.find('component_info')
        if component_info is not None:
            print("\n=== component_info 内容 ===")
            for child in component_info:
                text = child.text or ''
                print(f"{child.tag}: {text[:100] if len(text) > 100 else text}")
        
        # 检查basic_info
        basic_info = msds.find('basic_info')
        if basic_info is not None:
            print("\n=== basic_info 内容 ===")
            for child in basic_info:
                text = child.text or ''
                print(f"{child.tag}: {text[:100] if len(text) > 100 else text}")
