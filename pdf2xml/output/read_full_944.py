# 完整读取第944个文档的XML内容
import glob

# 使用glob查找文件
files = glob.glob('*120-22-9*.xml')
print('Found files:', files)

if files:
    filename = files[0]
    print(f'Reading file: {filename}')
    with open(filename, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    print(f'File length: {len(content)}')
    print('\nFull content:')
    print(content)
else:
    print('File not found')
