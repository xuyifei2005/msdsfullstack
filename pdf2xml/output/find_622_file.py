import os
import glob

# 尝试查找文件
pattern = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\pdf2xml\output\*622-68-4.xml"
files = glob.glob(pattern)

print(f"找到的文件: {files}")

if files:
    file_path = files[0]
    print(f"\n使用文件路径: {file_path}")
    print(f"文件是否存在: {os.path.exists(file_path)}")

    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            print("\n文件读取成功！")
            print(f"文件长度: {len(content)} 字符")
            print("\n完整内容:")
            print(content)
    except Exception as e:
        print(f"\n读取文件时出错: {e}")
else:
    print("未找到文件")
