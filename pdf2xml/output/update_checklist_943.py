# 更新清单文件，在第943个文档前添加✅标记
import re

with open('../MSDS补全清单.md', 'r', encoding='utf-8') as f:
    lines = f.readlines()

# 查找第943个文档并更新
for i, line in enumerate(lines):
    if '622-68-4' in line:
        print(f'找到第{i+1}行: {repr(line)}')
        # 在行首添加✅标记
        if not line.startswith('943. ✅'):
            lines[i] = line.replace('943. ', '943. ✅ ', 1)
            print(f'更新后: {repr(lines[i])}')
        else:
            print('该行已标记为完成')
        break

# 写回文件
with open('../MSDS补全清单.md', 'w', encoding='utf-8') as f:
    f.writelines(lines)

print('✅ 成功更新清单：第943个文档已标记为完成')
