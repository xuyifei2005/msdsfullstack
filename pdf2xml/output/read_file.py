import os
import glob

files = glob.glob('*622-68-4*.xml')
print('Found files:', files)

if files:
    filename = files[0]
    print(f'Reading file: {filename}')
    with open(filename, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    print(f'File length: {len(content)}')
    print('\nFirst 2000 characters:')
    print(content[:2000])
