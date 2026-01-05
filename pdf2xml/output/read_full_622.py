import os

file_path = r"D:\XUYIFEI\XUPROJECTS\msdsfullstack\pdf2xml\output\4-二甲氨基偶氮苯-4'-胂酸、4-dimethylaminoazobenzene-4'-arsonic acid、622-68-4.xml"

try:
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
        print("文件读取成功！")
        print(f"文件长度: {len(content)} 字符")
        print("\n完整内容:")
        print(content)
except Exception as e:
    print(f"读取文件时出错: {e}")
    print(f"文件路径: {file_path}")
    print(f"文件是否存在: {os.path.exists(file_path)}")
