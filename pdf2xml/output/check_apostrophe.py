# 检查清单文件中第943个文档的字符编码
import re

with open('../MSDS补全清单.md', 'r', encoding='utf-8') as f:
    lines = f.readlines()

# 查找包含622-68-4的行
for i, line in enumerate(lines, 1):
    if '622-68-4' in line:
        print(f'Line {i}:')
        print(repr(line))
        print()
        # 查找所有撇号字符
        for j, char in enumerate(line):
            if char in ["'", "'", '"', '"']:
                print(f'Position {j}: {repr(char)} (Unicode: U+{ord(char):04X})')
        break
