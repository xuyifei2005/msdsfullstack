import xml.etree.ElementTree as ET
import glob

files = glob.glob(r'D:\XUYIFEI\XUPROJECTS\msdsfullstack\pdf2xml\output\*622-68-4*.xml')
print(f"找到文件: {files}")

if files:
    file_path = files[0]
    print(f"\n读取文件: {file_path}")
    
    tree = ET.parse(file_path)
    root = tree.getroot()
    
    print(f"\n根元素: {root.tag}")
    print(f"\n直接子元素列表:")
    for i, child in enumerate(root, 1):
        print(f"  {i}. {child.tag}")
    
    print(f"\n完整XML结构:")
    def print_structure(element, indent=0):
        print("  " * indent + f"<{element.tag}>")
        if element.text and element.text.strip():
            text_preview = element.text.strip()[:100]
            print("  " * (indent + 1) + f"文本: {text_preview}...")
        for child in element:
            print_structure(child, indent + 1)
        print("  " * indent + f"</{element.tag}>")
    
    print_structure(root)
