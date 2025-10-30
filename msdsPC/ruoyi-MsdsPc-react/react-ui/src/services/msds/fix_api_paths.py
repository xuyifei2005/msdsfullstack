import os
import re

# 需要修复的文件列表
files_to_fix = [
    'exposure.ts',
    'ecology.ts',
    'firstAid.ts',
    'disposal.ts',
    'physicalChemical.ts',
    'toxicology.ts',
    'stabilityReactivity.ts',
    'transport.ts',
    'component.ts',
    'hazard.ts',
    'regulatory.ts',
    'otherInfo.ts'
]

# 修复模式：${api}/msds/${msdsId} -> ${api}/${msdsId}
pattern = r'\$\{api\}/msds/\$\{msdsId\}'
replacement = '${api}/${msdsId}'

for filename in files_to_fix:
    filepath = filename
    if os.path.exists(filepath):
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # 执行替换
        new_content = re.sub(pattern, replacement, content)
        
        if new_content != content:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print(f'✓ Fixed: {filename}')
        else:
            print(f'- Skipped: {filename} (no changes needed)')
    else:
        print(f'✗ Not found: {filename}')

print('\nDone!')

