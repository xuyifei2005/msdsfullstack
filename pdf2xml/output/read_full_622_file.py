import os
import glob

files = glob.glob(r'D:\XUYIFEI\XUPROJECTS\msdsfullstack\pdf2xml\output\*622-68-4*.xml')
print(f"Found files: {files}")

if files:
    file_path = files[0]
    print(f"Reading file: {file_path}")
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    print(f"File length: {len(content)} characters")
    print("\nFull content:")
    print(content)
