# -*- coding: utf-8 -*-
# 读取待处理文件列表
with open('remaining_list.txt', 'r', encoding='utf-8') as f:
    remaining_lines = f.read().strip().split('\n')

# 重新生成remaining_list.txt（如果不存在）
if not remaining_lines or len(remaining_lines) == 0:
    import re
    import os
    
    # 读取已完成文件
    completed = set()
    with open('MSDS补全清单.md', 'r', encoding='utf-8') as f:
        content = f.read()
        pattern = r'✅\s+([^、]+、[^、]+、[^、]+\.xml)'
        matches = re.findall(pattern, content)
        for match in matches:
            completed.add(match.strip())
    
    # 获取所有XML文件
    all_files = [f for f in os.listdir('.') if f.endswith('.xml') and 'MSDS补全清单' not in f]
    
    # 找出待处理文件
    remaining = sorted([f for f in all_files if f not in completed])
    
    # 生成待处理文件列表
    remaining_lines = []
    for i, filename in enumerate(remaining, start=1):
        remaining_lines.append(f"{i}. ⬜ {filename}")

# 读取原文档
with open('MSDS补全清单.md', 'r', encoding='utf-8') as f:
    doc_content = f.read()

# 找到并替换 "... (还有3299个文件待列出)"
pattern = r'\.\.\. \(还有\d+个文件待列出\)'
replacement = '\n'.join(remaining_lines)

new_doc_content = re.sub(pattern, replacement, doc_content)

# 写回文档
with open('MSDS补全清单.md', 'w', encoding='utf-8') as f:
    f.write(new_doc_content)

print(f'已更新文档，替换了待处理文件占位符，追加了 {len(remaining_lines)} 个待处理文件')

